"""Single-image inference + visualization."""
from __future__ import annotations

from pathlib import Path

import torch
import torch.nn as nn
from PIL import Image
from torchvision import transforms

from src.engine.evaluator import draw_boxes, boxes_to_pixels
from src.model.matcher import box_cxcywh_to_xyxy
from src.utils.metrics import TASK_MIN_CONF, SCORE_EXPONENT, EXIST_THRESHOLD, USE_HARD_GATING


IMAGENET_MEAN = [0.485, 0.456, 0.406]
IMAGENET_STD = [0.229, 0.224, 0.225]


def infer_single(
    model: nn.Module,
    image_path: str | Path,
    task_id: int,
    device: torch.device,
    img_size: int = 512,
    conf_thresh: float = 0.3,
) -> tuple[Image.Image, list[float]]:
    """Run inference on a single image.

    Returns (annotated_image, list_of_scores).
    """
    model.eval()
    img = Image.open(image_path).convert("RGB")
    orig_w, orig_h = img.size

    resized = img.resize((img_size, img_size), Image.BILINEAR)
    tensor = transforms.ToTensor()(resized)
    tensor = transforms.Normalize(IMAGENET_MEAN, IMAGENET_STD)(tensor)
    tensor = tensor.unsqueeze(0).to(device)
    tid = torch.tensor([task_id], device=device)

    with torch.no_grad():
        pred_logits, pred_boxes, task_logits, exist_logits = model(tensor, tid)

    obj_s = pred_logits[0].sigmoid().squeeze(-1)
    tsk_s = task_logits[0, :, task_id].sigmoid()
    exist_prob = exist_logits[0].sigmoid().item()

    # Scale the scores using the geometric mean formulation and existence gate
    # Must match the constants in src/utils/metrics.py
    base_scores = (obj_s * tsk_s.clamp(min=TASK_MIN_CONF)).pow(SCORE_EXPONENT)
    if USE_HARD_GATING:
        if exist_prob >= EXIST_THRESHOLD:
            scores = base_scores.cpu()
        else:
            scores = torch.zeros_like(base_scores).cpu()
    else:
        scores = (base_scores * exist_prob).cpu()
    boxes = pred_boxes[0].cpu()

    keep = scores > conf_thresh
    kept_boxes = boxes[keep]
    kept_scores = scores[keep]

    result_img = img.copy()
    if len(kept_boxes) > 0:
        pred_xyxy = box_cxcywh_to_xyxy(kept_boxes)
        pred_px = boxes_to_pixels(pred_xyxy, orig_w, orig_h)
        labels = [f"{s:.2f}" for s in kept_scores.tolist()]
        draw_boxes(result_img, pred_px, color="red", labels=labels)

    return result_img, kept_scores.tolist()
