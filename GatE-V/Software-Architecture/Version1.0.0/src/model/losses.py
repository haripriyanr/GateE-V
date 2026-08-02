"""Loss functions: focal loss, L1, GIoU, task classification + no-object penalty.

Key improvement over STAGE1:
  - lambda_noobj: strong penalty on all queries when GT has no preferred object.
    This directly combats false positives (RT-DETR always tries to detect something).
  - loss_weights now configurable from YAML config.
  - ADDED deep supervision (aux_outputs and enc_outputs).
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
    prob = pred.sigmoid()
    p_t = prob * target + (1.0 - prob) * (1.0 - target)
    alpha_t = alpha * target + (1.0 - alpha) * (1.0 - target)
    bce = F.binary_cross_entropy_with_logits(pred, target, reduction="none")
    return (alpha_t * (1.0 - p_t) ** gamma * bce).sum()


def varifocal_loss(
    pred: torch.Tensor,
    target: torch.Tensor,
    quality_target: torch.Tensor,
    alpha: float = 0.75,
    gamma: float = 2.0,
) -> torch.Tensor:
    """Varifocal Loss: weights positive samples by IoU quality score.

    For positives (target=1): loss = -q * (q * log(p) + (1-q) * log(1-p))
    For negatives (target=0): loss = -alpha * p^gamma * log(1-p)
    """
    prob = pred.sigmoid()
    focal_weight = target * quality_target + (1.0 - target) * alpha * (prob ** gamma)
    bce = F.binary_cross_entropy_with_logits(pred, quality_target, reduction="none")
    return (focal_weight * bce).sum()


def comparative_ranking_loss(
    pred_logits: torch.Tensor,
    indices: list[tuple[torch.Tensor, torch.Tensor]],
    margin: float = 0.5,
) -> torch.Tensor:
    """Pairwise ranking: positive queries score higher than negatives by margin."""
    B, Q, _ = pred_logits.shape
    scores = pred_logits.sigmoid().squeeze(-1)
    total_loss = torch.tensor(0.0, device=pred_logits.device)
    num_pairs = 0
    for b, (pred_idx, _) in enumerate(indices):
        if len(pred_idx) == 0:
            continue
        pos_mask = torch.zeros(Q, dtype=torch.bool, device=pred_logits.device)
        pos_mask[pred_idx] = True
        pos_scores = scores[b][pos_mask]
        neg_scores = scores[b][~pos_mask]
        if len(pos_scores) == 0 or len(neg_scores) == 0:
            continue
        diff = pos_scores.unsqueeze(1) - neg_scores.unsqueeze(0)
        loss = F.relu(margin - diff)
        total_loss = total_loss + loss.sum()
        num_pairs += loss.numel()
    return total_loss / max(num_pairs, 1)


def sized_l1_loss(pred_boxes: torch.Tensor, tgt_boxes: torch.Tensor) -> torch.Tensor:
    """Scale-normalized L1 for cxcywh boxes, reducing large-box bias."""
    denom = tgt_boxes[..., [2, 3, 2, 3]].clamp(min=1e-2)
    return ((pred_boxes - tgt_boxes).abs() / denom).mean()


def _compute_core_losses(pred_logits, pred_boxes, targets, device,
                         bbox_loss_type="l1", mal_alpha=0.0,
                         cost_cls=2.0, cost_l1=5.0, cost_giou=2.0,
                         use_vfl=True):
    """Core matching and loss computation for a single prediction layer.

    Supports configurable Hungarian costs, Matchability-Aware Loss (MAL), and Varifocal Loss (VFL).
    """
    indices = hungarian_match(pred_logits, pred_boxes, targets,
                              cost_cls=cost_cls, cost_l1=cost_l1, cost_giou=cost_giou)
    B, Q, _ = pred_logits.shape

    # ── Classification targets ──
    cls_targets = torch.zeros(B, Q, 1, device=device)
    quality_targets = torch.zeros(B, Q, 1, device=device)
    num_pos = 0
    for b, (pred_idx, _) in enumerate(indices):
        if len(pred_idx) > 0:
            cls_targets[b, pred_idx] = 1.0
            num_pos += len(pred_idx)

    num_pos = max(num_pos, 1)

    # ── Box regression (matched pairs only) ──
    loss_bbox = torch.tensor(0.0, device=device)
    loss_giou = torch.tensor(0.0, device=device)
    
    pred_matched, tgt_matched = [], []
    for b, (pred_idx, tgt_idx) in enumerate(indices):
        if len(pred_idx) > 0:
            pred_matched.append(pred_boxes[b, pred_idx])
            tgt_matched.append(targets[b]["boxes"][tgt_idx].to(device))
            
    if pred_matched:
        pred_cat = torch.cat(pred_matched)
        tgt_cat = torch.cat(tgt_matched)
        if bbox_loss_type == "sized_l1":
            loss_bbox = sized_l1_loss(pred_cat, tgt_cat)
        else:
            loss_bbox = F.l1_loss(pred_cat, tgt_cat, reduction="mean")
        with torch.amp.autocast('cuda', enabled=False):
            giou_matrix = generalized_box_iou(
                safe_boxes_xyxy(pred_cat).float(),
                safe_boxes_xyxy(tgt_cat).float(),
            )
        loss_giou = (1.0 - torch.diag(giou_matrix)).mean()

        matched_iou = torch.diag(giou_matrix).clamp(min=1e-6).unsqueeze(-1)
        offset = 0
        for b, (pred_idx, _) in enumerate(indices):
            n = len(pred_idx)
            if n > 0:
                quality_targets[b, pred_idx] = matched_iou[offset:offset + n].detach()
                offset += n

        if use_vfl:
            loss_cls = varifocal_loss(pred_logits, cls_targets, quality_targets) / num_pos
        elif mal_alpha > 0.0:
            prob = pred_logits.sigmoid()
            p_t = prob * cls_targets + (1.0 - prob) * (1.0 - cls_targets)
            alpha_t = 0.25 * cls_targets + (1.0 - 0.25) * (1.0 - cls_targets)
            bce = F.binary_cross_entropy_with_logits(pred_logits, cls_targets, reduction="none")
            per_box_focal = alpha_t * (1.0 - p_t) ** 2.0 * bce
            qw_matrix = torch.ones(B, Q, 1, device=device)
            offset = 0
            for b, (pred_idx, _) in enumerate(indices):
                n = len(pred_idx)
                if n > 0:
                    qw_matrix[b, pred_idx] = (matched_iou[offset:offset + n] ** mal_alpha).detach()
                    offset += n
            loss_cls = (per_box_focal * qw_matrix).sum() / num_pos
        else:
            prob = pred_logits.sigmoid()
            p_t = prob * cls_targets + (1.0 - prob) * (1.0 - cls_targets)
            alpha_t = 0.25 * cls_targets + (1.0 - 0.25) * (1.0 - cls_targets)
            bce = F.binary_cross_entropy_with_logits(pred_logits, cls_targets, reduction="none")
            per_box_focal = alpha_t * (1.0 - p_t) ** 2.0 * bce
            loss_cls = per_box_focal.sum() / num_pos
    else:
        if use_vfl:
            loss_cls = varifocal_loss(pred_logits, cls_targets, quality_targets) / num_pos
        else:
            prob = pred_logits.sigmoid()
            p_t = prob * cls_targets + (1.0 - prob) * (1.0 - cls_targets)
            alpha_t = 0.25 * cls_targets + (1.0 - 0.25) * (1.0 - cls_targets)
            bce = F.binary_cross_entropy_with_logits(pred_logits, cls_targets, reduction="none")
            loss_cls = (alpha_t * (1.0 - p_t) ** 2.0 * bce).sum() / num_pos
        
    return loss_cls, loss_bbox, loss_giou, indices


def _compute_aux_pred_loss(
    aux_preds: list[dict],
    targets: list[dict],
    device: torch.device,
    lw: dict[str, float],
    bbox_loss_type: str = "l1",
    mal_alpha: float = 0.0,
) -> torch.Tensor:
    """Dense aux head loss via nearest-grid-cell matching."""
    total = torch.tensor(0.0, device=device)
    num_levels = len(aux_preds)
    level_weight = 1.0 / max(num_levels, 1)

    for level_data in aux_preds:
        cls_logits = level_data["cls"]  # [B, N, 1]
        boxes = level_data["box"]       # [B, N, 4]
        B, N, _ = cls_logits.shape
        H = int(N ** 0.5)
        W = N // H

        # Grid cell centers in normalized coordinates
        gx = (torch.arange(W, device=device).float() + 0.5) / W
        gy = (torch.arange(H, device=device).float() + 0.5) / H
        gcx, gcy = torch.meshgrid(gx, gy, indexing="xy")
        grid_cx = gcx.reshape(-1)  # [N]
        grid_cy = gcy.reshape(-1)

        cls_target = torch.zeros(B, N, 1, device=device)
        matched_pred, matched_gt = [], []

        for b in range(B):
            gt = targets[b]["boxes"]
            if len(gt) == 0:
                continue
            for m in range(len(gt)):
                cx_n, cy_n = gt[m, 0].item(), gt[m, 1].item()
                # Nearest grid cell (L1 distance in normalized space)
                dist = (grid_cx - cx_n).abs() + (grid_cy - cy_n).abs()
                nearest = dist.argmin().item()
                cls_target[b, nearest, 0] = 1.0
                matched_pred.append(boxes[b, nearest])
                matched_gt.append(gt[m].to(device))

        cls_loss = focal_loss(cls_logits, cls_target) / max(cls_target.sum(), 1)

        if matched_pred:
            pred_cat = torch.stack(matched_pred)
            tgt_cat = torch.stack(matched_gt).to(device)
            bbox_loss = F.l1_loss(pred_cat, tgt_cat, reduction="mean")
            with torch.amp.autocast("cuda", enabled=False):
                giou = generalized_box_iou(
                    safe_boxes_xyxy(pred_cat).float(),
                    safe_boxes_xyxy(tgt_cat).float(),
                )
            giou_loss = (1.0 - torch.diag(giou)).mean()
        else:
            bbox_loss = torch.tensor(0.0, device=device)
            giou_loss = torch.tensor(0.0, device=device)

        total = total + level_weight * (
            lw["cls"] * cls_loss + lw["l1"] * bbox_loss + lw["giou"] * giou_loss
        )

    return total


def kd_loss(
    student_logits: torch.Tensor,
    student_boxes: torch.Tensor,
    teacher_logits: torch.Tensor,
    teacher_boxes: torch.Tensor,
    kd_weight: float = 1.0,
) -> torch.Tensor:
    """Self-KD loss: MSE on sigmoid probabilities + smooth L1 on boxes."""
    cls_kd = F.mse_loss(student_logits.sigmoid(), teacher_logits.sigmoid())
    box_kd = F.smooth_l1_loss(student_boxes, teacher_boxes)
    return kd_weight * (cls_kd + box_kd)


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
    lambda_comp: float = 0.0,
    comp_margin: float = 0.5,
    loss_weights: dict[str, float] | None = None,
    bbox_loss_type: str = "l1",
    mal_alpha: float = 0.0,
    cost_cls: float = 2.0,
    cost_l1: float = 5.0,
    cost_giou: float = 2.0,
    aux_outputs: list[dict] | None = None,
    enc_outputs: dict | None = None,
    aux_preds: list[dict] | None = None,
    teacher_out: tuple[torch.Tensor, torch.Tensor] | None = None,
    kd_weight: float = 0.1,
    lambda_aux_head: float = 1.0,
    use_vfl: bool = True,
) -> tuple[torch.Tensor, dict[str, float]]:
    """Compute detection + task classification + existence + comparative loss."""
    lw = loss_weights or {"cls": 2.5, "l1": 5.0, "giou": 2.0}
    device = pred_logits.device
    B, Q, _ = pred_logits.shape

    # ── Final Layer Core Losses ───────────────────────────────────────────
    loss_cls, loss_bbox, loss_giou, indices = _compute_core_losses(
        pred_logits, pred_boxes, targets, device,
        bbox_loss_type=bbox_loss_type, mal_alpha=mal_alpha,
        cost_cls=cost_cls, cost_l1=cost_l1, cost_giou=cost_giou,
        use_vfl=use_vfl,
    )

    # === No-Object Loss: direct objectness suppression ================
    obj_scores = pred_logits.sigmoid().squeeze(-1)           # [B, Q]
    unmatched_mask = torch.ones(B, Q, device=device)
    for b, (pred_idx, _) in enumerate(indices):
        if len(pred_idx) > 0:
            unmatched_mask[b, pred_idx] = 0.0

    unmatched_obj = (obj_scores * unmatched_mask).sum() / unmatched_mask.sum().clamp(min=1)
    task_scores = task_logits.gather(
        -1, task_ids.view(B, 1, 1).expand(B, Q, 1)
    ).squeeze(-1).sigmoid()                                   # [B, Q]
    combined_unmatched = (obj_scores * task_scores * unmatched_mask).sum() / unmatched_mask.sum().clamp(min=1)
    loss_noobj = 0.7 * unmatched_obj + 0.3 * combined_unmatched

    # ── Task classification loss ───────────────────────────────────────
    loss_task = torch.tensor(0.0, device=device)
    if lambda_task > 0.0 and sum([len(p) for p, _ in indices]) > 0:
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
        [[float(len(t["boxes"]) > 0)] for t in targets],
        device=device, dtype=torch.float32,
    )
    loss_exists = F.binary_cross_entropy_with_logits(exist_logits, exist_targets)

    # ── Comparative Ranking Loss ───────────────────────────────────────
    loss_comp = torch.tensor(0.0, device=device)
    if lambda_comp > 0.0:
        loss_comp = comparative_ranking_loss(pred_logits, indices, margin=comp_margin)

    # ── Total Final Layer Loss ─────────────────────────────────────────
    total = (
        lw["cls"] * loss_cls
        + lw["l1"] * loss_bbox
        + lw["giou"] * loss_giou
        + lambda_task * loss_task
        + lambda_noobj * loss_noobj
        + lambda_exists * loss_exists
        + lambda_comp * loss_comp
    )

    # ── Auxiliary Decoder Losses ───────────────────────────────────────
    if aux_outputs is not None:
        aux_weight = 1.0 / max(len(aux_outputs), 1)
        for aux in aux_outputs:
            a_cls, a_bbox, a_giou, _ = _compute_core_losses(
                aux["pred_logits"], aux["pred_boxes"], targets, device,
                bbox_loss_type=bbox_loss_type, mal_alpha=mal_alpha,
                cost_cls=cost_cls, cost_l1=cost_l1, cost_giou=cost_giou)
            total = total + aux_weight * (lw["cls"] * a_cls + lw["l1"] * a_bbox + lw["giou"] * a_giou)

    # ── Encoder Supervision ────────────────────────────────────────────
    if enc_outputs is not None:
        e_cls, e_bbox, e_giou, _ = _compute_core_losses(
            enc_outputs["pred_logits"], enc_outputs["pred_boxes"], targets, device,
            bbox_loss_type=bbox_loss_type, mal_alpha=mal_alpha,
            cost_cls=cost_cls, cost_l1=cost_l1, cost_giou=cost_giou)
        total = total + lw["cls"] * e_cls + lw["l1"] * e_bbox + lw["giou"] * e_giou

    # ── CNN Auxiliary Head Loss (dense encoder predictions) ────────────
    loss_aux_pred = torch.tensor(0.0, device=device)
    if aux_preds is not None:
        loss_aux_pred = _compute_aux_pred_loss(
            aux_preds, targets, device, lw,
            bbox_loss_type=bbox_loss_type, mal_alpha=mal_alpha,
        )
        total = total + lambda_aux_head * loss_aux_pred

    # ── Self-Knowledge Distillation Loss (EMA teacher) ─────────────────
    loss_kd = torch.tensor(0.0, device=device)
    if teacher_out is not None:
        loss_kd = kd_loss(
            pred_logits, pred_boxes,
            teacher_out[0], teacher_out[1],
            kd_weight=kd_weight,
        )
        total = total + loss_kd

    loss_dict = {
        "cls": loss_cls.item(),
        "bbox": loss_bbox.item(),
        "giou": loss_giou.item(),
        "task": loss_task.item(),
        "noobj": loss_noobj.item(),
        "exists": loss_exists.item(),
        "comp": loss_comp.item(),
        "aux_pred": loss_aux_pred.item(),
        "kd": loss_kd.item(),
        "total": total.item(),
    }
    return total, loss_dict
