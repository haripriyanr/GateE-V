"""Hungarian matcher and box utilities.

Extracted verbatim from monolithic main.py — no modifications.
"""
from __future__ import annotations

import torch
import torch.nn.functional as F
from scipy.optimize import linear_sum_assignment
from torchvision.ops import generalized_box_iou


def box_cxcywh_to_xyxy(boxes: torch.Tensor) -> torch.Tensor:
    cx, cy, w, h = boxes.unbind(-1)
    return torch.stack([cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], dim=-1)


def safe_boxes_xyxy(boxes_cxcywh: torch.Tensor) -> torch.Tensor:
    cx, cy, w, h = boxes_cxcywh.unbind(-1)
    w = w.clamp(min=1e-6)
    h = h.clamp(min=1e-6)
    return torch.stack(
        [cx - w / 2, cy - h / 2, cx + w / 2, cy + h / 2], dim=-1
    ).clamp(0.0, 1.0)


@torch.no_grad()
def hungarian_match(
    pred_logits: torch.Tensor,
    pred_boxes: torch.Tensor,
    targets: list[dict],
    cost_cls: float = 2.0,
    cost_l1: float = 5.0,
    cost_giou: float = 2.0,
) -> list[tuple[torch.Tensor, torch.Tensor]]:
    B = pred_logits.size(0)
    indices: list[tuple[torch.Tensor, torch.Tensor]] = []
    for b in range(B):
        tgt_boxes = targets[b]["boxes"]
        if len(tgt_boxes) == 0:
            indices.append(
                (torch.zeros(0, dtype=torch.long),
                 torch.zeros(0, dtype=torch.long))
            )
            continue
        out_prob = pred_logits[b].sigmoid().squeeze(-1)
        out_bbox = pred_boxes[b].clamp(0.0, 1.0)
        tgt_bbox = tgt_boxes.to(out_bbox.device).clamp(0.0, 1.0)
        cost_class = -out_prob.unsqueeze(1).expand(-1, len(tgt_bbox))
        cost_bbox = torch.cdist(out_bbox, tgt_bbox, p=1)
        cost_giou_matrix = -generalized_box_iou(
            safe_boxes_xyxy(out_bbox).float(),
            safe_boxes_xyxy(tgt_bbox).float(),
        )
        C = cost_cls * cost_class + cost_l1 * cost_bbox + cost_giou * cost_giou_matrix
        C = torch.nan_to_num(C, nan=1e4, posinf=1e4, neginf=-1e4)
        try:
            row_ind, col_ind = linear_sum_assignment(C.cpu().numpy())
            indices.append((
                torch.tensor(row_ind, dtype=torch.long),
                torch.tensor(col_ind, dtype=torch.long),
            ))
        except ValueError:
            indices.append((
                torch.zeros(0, dtype=torch.long),
                torch.zeros(0, dtype=torch.long),
            ))
    return indices
