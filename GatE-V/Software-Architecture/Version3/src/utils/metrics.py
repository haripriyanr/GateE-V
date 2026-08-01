"""mAP@0.5 computation (contest metric).

Score fusion: geometric mean (obj × tsk)^0.8 — better calibrated than raw
product. The exponent 0.8 prevents extremely low task scores from collapsing
the ranking, while still requiring strong task agreement for top-ranked detections.
"""
from __future__ import annotations

import random

import numpy as np
import torch
import torch.nn as nn
from torchvision.ops import box_iou

from src.model.matcher import box_cxcywh_to_xyxy, safe_boxes_xyxy

# Minimum task confidence: queries below this are considered noise.
TASK_MIN_CONF = 0.10
# Geometric mean exponent — lower values preserve more recall.
SCORE_EXPONENT = 0.6
# Existence head gating threshold. Detections are suppressed if exist_prob < EXIST_THRESHOLD.
# Set to 0.0 to disable existence head gating entirely.
EXIST_THRESHOLD = 0.00
# If True, use hard gating (filtering). If False, use soft scaling (multiplication).
USE_HARD_GATING = True


def compute_map50(
    model: nn.Module,
    dataset,
    device: torch.device,
    max_samples_per_task: int | None = None,
) -> tuple[float, dict[int, float]]:
    """Compute per-task AP@0.5 using combined objectness × task-suitability.

    Returns (mean_ap, {task_id_0indexed: ap}).
    """
    model.eval()
    task_results: dict[int, dict] = {
        t: {"scores": [], "tp": [], "num_gt": 0} for t in range(14)
    }

    task_to_indices = {t: [] for t in range(14)}
    for i in range(len(dataset)):
        task_to_indices[dataset.samples[i]["task_idx"]].append(i)

    # Fixed seed so intermediate validation picks the same images every epoch,
    # making the early-stopping signal reproducible.
    rng = random.Random(42)
    indices = []
    for t in range(14):
        pool = task_to_indices[t]
        if max_samples_per_task and len(pool) > max_samples_per_task:
            indices.extend(rng.sample(pool, max_samples_per_task))
        else:
            indices.extend(pool)

    with torch.no_grad():
        for idx in indices:
            sample = dataset[idx]
            task_id = int(sample["task_id"])
            gt_boxes = sample["boxes"]

            img_t = sample["image"].unsqueeze(0).to(device)
            tid_t = torch.tensor([task_id], device=device)

            pred_logits, pred_boxes, task_logits, exist_logits, _, _, _ = model(img_t, tid_t)

            obj_s = pred_logits[0].sigmoid().squeeze(-1)
            tsk_s = task_logits[0, :, task_id].sigmoid()
            exist_prob = exist_logits[0].sigmoid().item()  # Scalar probability

            # Geometric mean with task floor: (obj × clamp(tsk, min))^exp
            tsk_s_floored = tsk_s.clamp(min=TASK_MIN_CONF)
            base_scores = (obj_s * tsk_s_floored).pow(SCORE_EXPONENT)
            
            # Existence head gating: hard gating or soft scaling
            if USE_HARD_GATING:
                if exist_prob >= EXIST_THRESHOLD:
                    scores = base_scores.cpu().numpy()
                else:
                    scores = np.zeros_like(base_scores.cpu().numpy())
            else:
                scores = (base_scores * exist_prob).cpu().numpy()
            boxes_cpu = pred_boxes[0].cpu()

            order = scores.argsort()[::-1].copy()
            scores = scores[order]
            boxes_cpu = boxes_cpu[order]

            num_gt = len(gt_boxes)
            task_results[task_id]["num_gt"] += num_gt

            if num_gt == 0:
                for s in scores:
                    task_results[task_id]["scores"].append(float(s))
                    task_results[task_id]["tp"].append(0)
                continue

            gt_xyxy = box_cxcywh_to_xyxy(gt_boxes)
            gt_matched = np.zeros(num_gt, dtype=bool)

            for i in range(len(boxes_cpu)):
                task_results[task_id]["scores"].append(float(scores[i]))
                box_xyxy = safe_boxes_xyxy(boxes_cpu[i:i + 1])
                iou = box_iou(box_xyxy, gt_xyxy).squeeze(0).numpy()
                best_j = int(iou.argmax())
                if float(iou[best_j]) >= 0.5 and not gt_matched[best_j]:
                    gt_matched[best_j] = True
                    task_results[task_id]["tp"].append(1)
                else:
                    task_results[task_id]["tp"].append(0)

    # 101-point interpolated AP per task
    aps: dict[int, float] = {}
    for task_id, r in task_results.items():
        if r["num_gt"] == 0 or len(r["scores"]) == 0:
            continue
        s_arr = np.array(r["scores"])
        tp_arr = np.array(r["tp"], dtype=np.float32)
        order = s_arr.argsort()[::-1]
        tp_sorted = tp_arr[order]
        tp_cum = tp_sorted.cumsum()
        fp_cum = (1.0 - tp_sorted).cumsum()
        precision = tp_cum / (tp_cum + fp_cum + 1e-9)
        recall = tp_cum / (r["num_gt"] + 1e-9)
        ap = 0.0
        for t in np.linspace(0.0, 1.0, 101):
            mask = recall >= t
            ap += (float(precision[mask].max()) if mask.any() else 0.0) / 101.0
        aps[task_id] = ap

    mean_ap = float(np.mean(list(aps.values()))) if aps else 0.0
    return mean_ap, aps
