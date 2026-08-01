"""Evaluation engine: mAP computation + visualization."""
from __future__ import annotations

from pathlib import Path

import torch
import torch.nn as nn
from PIL import Image, ImageDraw, ImageFont

from src.model.matcher import box_cxcywh_to_xyxy, safe_boxes_xyxy
from src.utils.metrics import compute_map50
from src.model.gate import TASK_DESCRIPTIONS


def boxes_to_pixels(boxes, img_w, img_h):
    result = []
    for b in boxes:
        x1 = int(b[0].item() * img_w)
        y1 = int(b[1].item() * img_h)
        x2 = int(b[2].item() * img_w)
        y2 = int(b[3].item() * img_h)
        result.append((x1, y1, x2, y2))
    return result


def draw_boxes(img, boxes, color="green", labels=None):
    draw = ImageDraw.Draw(img)
    try:
        font = ImageFont.truetype("arial.ttf", 14)
    except OSError:
        font = ImageFont.load_default()
    for i, (x1, y1, x2, y2) in enumerate(boxes):
        draw.rectangle([x1, y1, x2, y2], outline=color, width=3)
        if labels and i < len(labels):
            draw.text((x1 + 2, max(y1 - 16, 0)), labels[i], fill=color, font=font)
    return img


def run_evaluation(model, dataset, device, output_dir=None):
    """Run full evaluation with mAP and optional visualization."""
    model.eval()
    print("\n[eval] Computing mAP@0.5...")
    mean_ap, per_task = compute_map50(model, dataset, device)

    task_names = [d.split(",")[0][:22] for d in TASK_DESCRIPTIONS]
    print(f"\n{'=' * 60}")
    print("  mAP@0.5 — Test Split")
    print(f"{'=' * 60}")
    for tid in range(14):
        name = task_names[tid] if tid < len(task_names) else f"task_{tid+1}"
        ap = per_task.get(tid, float("nan"))
        print(f"  Task {tid+1:>2}  {name:<22s}  AP@0.5 = {ap:.4f}")
    print(f"{'-' * 60}")
    print(f"  Mean AP@0.5 = {mean_ap:.4f}")
    print(f"{'=' * 60}")

    return mean_ap, per_task
