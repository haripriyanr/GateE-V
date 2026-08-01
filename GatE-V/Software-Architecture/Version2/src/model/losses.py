"""Loss functions: focal loss, L1, GIoU, task classification + no-object penalty.

Key improvement over STAGE1:
  - lambda_noobj: strong penalty on all queries when GT has no preferred object.
    This directly combats false positives (RT-DETR always tries to detect something).
  - loss_weights now configurable from YAML config.
"""
from __future__ import annotations

import torch
import torch.nn.functional as F
from torchvision.ops import generalized_box_iou

from src.model.matcher import hungarian_match, safe_boxes_xyxy


def focal_loss(
    pred: torch.Tensor, target: torch.Tensor,
    alpha: float = 0.25, gamma: float = 2.0,
) -> torch.Tensor:
    """Returns sum of focal loss — caller normalizes by num_boxes."""
    bce = F.binary_cross_entropy_with_logits(pred, target, reduction="none")
    prob = pred.sigmoid()
    p_t = prob * target + (1.0 - prob) * (1.0 - target)
    alpha_t = alpha * target + (1.0 - alpha) * (1.0 - target)
    return (alpha_t * (1.0 - p_t) ** gamma * bce).sum()


def compute_loss(
    pred_logits: torch.Tensor,
    pred_boxes: torch.Tensor,
    task_logits: torch.Tensor,
    exist_logits: torch.Tensor,
    targets: list[dict],
    task_ids: torch.Tensor,
    lambda_task: float = 0.0,
    lambda_noobj: float = 10.0,
    lambda_exists: float = 4.0,
    loss_weights: dict[str, float] | None = None,
) -> tuple[torch.Tensor, dict[str, float]]:
    """Compute detection + task classification + existence loss."""
    lw = loss_weights or {"cls": 2.5, "l1": 5.0, "giou": 2.0}
    device = pred_logits.device
    B, Q, _ = pred_logits.shape

    indices = hungarian_match(pred_logits, pred_boxes, targets)

    # ── Classification targets ─────────────────────────────────────────
    cls_targets = torch.zeros(B, Q, 1, device=device)
    num_pos = 0
    for b, (pred_idx, _) in enumerate(indices):
        if len(pred_idx) > 0:
            cls_targets[b, pred_idx] = 1.0
            num_pos += len(pred_idx)

    num_pos = max(num_pos, 1)
    loss_cls = focal_loss(pred_logits, cls_targets) / num_pos

    # ── Box regression (matched pairs only) ───────────────────────────
    loss_bbox = torch.tensor(0.0, device=device)
    loss_giou = torch.tensor(0.0, device=device)
    if num_pos > 0:
        pred_matched, tgt_matched = [], []
        for b, (pred_idx, tgt_idx) in enumerate(indices):
            if len(pred_idx) > 0:
                pred_matched.append(pred_boxes[b, pred_idx])
                tgt_matched.append(targets[b]["boxes"][tgt_idx].to(device))
        if pred_matched:
            pred_cat = torch.cat(pred_matched)
            tgt_cat = torch.cat(tgt_matched)
            loss_bbox = F.l1_loss(pred_cat, tgt_cat, reduction="mean")
            giou_matrix = generalized_box_iou(
                safe_boxes_xyxy(pred_cat), safe_boxes_xyxy(tgt_cat)
            )
            loss_giou = (1.0 - torch.diag(giou_matrix)).mean()

    # === No-Object Loss: direct objectness suppression ================
    obj_scores = pred_logits.sigmoid().squeeze(-1)           # [B, Q]

    # Build mask: 1 for unmatched queries, 0 for matched
    unmatched_mask = torch.ones(B, Q, device=device)
    for b, (pred_idx, _) in enumerate(indices):
        if len(pred_idx) > 0:
            unmatched_mask[b, pred_idx] = 0.0

    # Primary: suppress raw objectness of unmatched queries
    unmatched_obj = (obj_scores * unmatched_mask).sum() / unmatched_mask.sum().clamp(min=1)

    # Secondary: also penalize combined obj×task for fine-grained signal
    task_scores = torch.stack([
        task_logits[b, :, task_ids[b]].sigmoid() for b in range(B)
    ])                                                        # [B, Q]
    combined_unmatched = (obj_scores * task_scores * unmatched_mask).sum() / unmatched_mask.sum().clamp(min=1)

    # 70% raw objectness (strong) + 30% combined (fine-grained)
    loss_noobj = 0.7 * unmatched_obj + 0.3 * combined_unmatched

    # ── Task classification loss ───────────────────────────────────────
    loss_task = torch.tensor(0.0, device=device)
    if lambda_task > 0.0 and num_pos > 0:
        task_losses = []
        for b, (pred_idx, _) in enumerate(indices):
            if len(pred_idx) > 0:
                matched_logits = task_logits[b][pred_idx]  # [M, num_tasks]
                num_tasks = task_logits.shape[-1]
                task_tgt = torch.zeros(len(pred_idx), num_tasks, device=device)
                task_tgt[:, task_ids[b]] = 1.0
                task_losses.append(
                    F.binary_cross_entropy_with_logits(matched_logits, task_tgt)
                )
        if task_losses:
            loss_task = torch.stack(task_losses).mean()

    # ── Existence Loss ────────────────────────────────────────────────
    exist_targets = torch.tensor(
        [[1.0 if len(t["boxes"]) > 0 else 0.0] for t in targets],
        device=device
    )
    loss_exists = F.binary_cross_entropy_with_logits(exist_logits, exist_targets)

    # ── Total ──────────────────────────────────────────────────────────
    total = (
        lw["cls"] * loss_cls
        + lw["l1"] * loss_bbox
        + lw["giou"] * loss_giou
        + lambda_task * loss_task
        + lambda_noobj * loss_noobj
        + lambda_exists * loss_exists
    )

    loss_dict = {
        "cls": loss_cls.item(),
        "bbox": loss_bbox.item(),
        "giou": loss_giou.item(),
        "task": loss_task.item(),
        "noobj": loss_noobj.item(),
        "exists": loss_exists.item(),
        "total": total.item(),
    }
    return total, loss_dict
