"""Failure Analysis Script for GatE-V (Version 3).

Evaluates the test split of COCO-Tasks dataset with a checkpoint, identifies the 3 worst
predicted images per task (42 images total), renders side-by-side visual panels:
  - Left panel: Ground-truth bounding boxes (green) + task label
  - Right panel: Predictions (red) + confidence scores + diagnostic text
Saves visualizations to runs/failure_analysis/ and prints a per-task diagnostic summary table.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path
import numpy as np
import torch
import torch.nn as nn
from PIL import Image, ImageDraw, ImageFont
from torchvision.ops import box_iou

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src.utils.config import GatEVConfig
from src.engine.trainer import get_device, build_model
from src.data.dataset import COCOTasksDataset
from src.model.matcher import box_cxcywh_to_xyxy, safe_boxes_xyxy
from src.model.gate import TASK_DESCRIPTIONS

def draw_boxes_on_pil(img: Image.Image, boxes_xyxy: list, labels: list[str], color: str = "green") -> Image.Image:
    """Draw bounding boxes and text labels on a PIL Image."""
    canvas = img.copy()
    draw = ImageDraw.Draw(canvas)
    try:
        font = ImageFont.truetype("DejaVuSans-Bold.ttf", 16)
        small_font = ImageFont.truetype("DejaVuSans.ttf", 13)
    except OSError:
        font = ImageFont.load_default()
        small_font = font

    W, H = canvas.size
    for i, box in enumerate(boxes_xyxy):
        x1 = max(0, min(W - 1, int(box[0])))
        y1 = max(0, min(H - 1, int(box[1])))
        x2 = max(0, min(W - 1, int(box[2])))
        y2 = max(0, min(H - 1, int(box[3])))

        # Draw thick bounding box
        draw.rectangle([x1, y1, x2, y2], outline=color, width=3)
        if i < len(labels) and labels[i]:
            lbl = labels[i]
            text_bbox = draw.textbbox((x1, y1), lbl, font=small_font)
            tb_w = text_bbox[2] - text_bbox[0] + 6
            tb_h = text_bbox[3] - text_bbox[1] + 4
            ty = max(0, y1 - tb_h)
            draw.rectangle([x1, ty, x1 + tb_w, ty + tb_h], fill=color)
            draw.text((x1 + 3, ty + 2), lbl, fill="white" if color in ("green", "red") else "black", font=small_font)
    return canvas

def create_side_by_side_panel(
    orig_img_path: str,
    gt_boxes_pixels: list,
    pred_boxes_pixels: list,
    pred_scores: list[float],
    task_id: int,
    task_name: str,
    diagnosis_note: str,
) -> Image.Image:
    """Create a side-by-side panel comparing GT vs Predictions."""
    base_img = Image.open(orig_img_path).convert("RGB")
    W, H = base_img.size

    # Left: GT (Green)
    gt_labels = [f"GT Object {i+1}" for i in range(len(gt_boxes_pixels))]
    left_img = draw_boxes_on_pil(base_img, gt_boxes_pixels, gt_labels, color="green")
    draw_l = ImageDraw.Draw(left_img)
    draw_l.rectangle([0, 0, W, 28], fill="darkgreen")
    try:
        title_font = ImageFont.truetype("DejaVuSans-Bold.ttf", 14)
    except OSError:
        title_font = ImageFont.load_default()
    draw_l.text((8, 5), f"GROUND TRUTH (Task {task_id+1}: {task_name[:30]})", fill="white", font=title_font)

    # Right: Predictions (Red)
    pred_labels = [f"Pred {s:.2f}" for s in pred_scores[:len(pred_boxes_pixels)]]
    right_img = draw_boxes_on_pil(base_img, pred_boxes_pixels, pred_labels, color="red")
    draw_r = ImageDraw.Draw(right_img)
    draw_r.rectangle([0, 0, W, 28], fill="darkred")
    draw_r.text((8, 5), f"GATE-V PREDICTION (Task {task_id+1})", fill="white", font=title_font)

    # Side-by-side stitch
    combined = Image.new("RGB", (W * 2 + 10, H + 60), (30, 30, 30))
    combined.paste(left_img, (0, 0))
    combined.paste(right_img, (W + 10, 0))

    # Diagnosis footer text banner
    draw_c = ImageDraw.Draw(combined)
    draw_c.rectangle([0, H, W * 2 + 10, H + 60], fill=(15, 15, 25))
    try:
        foot_font = ImageFont.truetype("DejaVuSans.ttf", 13)
    except OSError:
        foot_font = ImageFont.load_default()
    draw_c.text((12, H + 8), f"Diagnosis: {diagnosis_note}", fill=(255, 220, 100), font=foot_font)

    return combined

def analyze_failures(cfg_path: str, ckpt_path: str, out_dir: str):
    device = get_device()
    cfg = GatEVConfig.from_yaml(cfg_path)
    out_path = Path(out_dir)
    out_path.mkdir(parents=True, exist_ok=True)

    print(f"\n[failure_analysis] Loading model from {ckpt_path}...")
    ckpt = torch.load(ckpt_path, map_location="cpu", weights_only=False)
    state = ckpt.get("ema", ckpt.get("model", ckpt.get("state_dict")))
    clean_state = {k.replace("_orig_mod.", ""): v for k, v in state.items()}

    model = build_model(cfg)
    model.load_state_dict(clean_state, strict=False)
    model.to(device)
    model.eval()

    test_ds = COCOTasksDataset(
        cfg.data.dataset_dir, cfg.data.images_dir,
        split="test", img_size=cfg.training.img_size, augment=False,
    )

    print(f"[failure_analysis] Evaluating {len(test_ds)} test samples across 14 tasks...")

    # Group test indices by task
    task_indices: dict[int, list[int]] = {t: [] for t in range(14)}
    for idx, sample in enumerate(test_ds.samples):
        task_indices[sample["task_idx"]].append(idx)

    task_diagnostics = []

    with torch.no_grad():
        for tid in range(14):
            task_name = TASK_DESCRIPTIONS[tid] if tid < len(TASK_DESCRIPTIONS) else f"task_{tid+1}"
            indices = task_indices[tid]
            if not indices:
                continue

            sample_evals = []

            for idx in indices:
                sample_meta = test_ds.samples[idx]
                sample_data = test_ds[idx]
                gt_boxes_norm = sample_data["boxes"]  # [N, 4] cxcywh in [0, 1]
                num_gt = len(gt_boxes_norm)

                img_t = sample_data["image"].unsqueeze(0).to(device)
                tid_t = torch.tensor([tid], device=device)

                pred_logits, pred_boxes, task_logits, exist_logits, _, _, _ = model(img_t, tid_t)

                obj_s = pred_logits[0].sigmoid().squeeze(-1)
                tsk_s = task_logits[0, :, tid].sigmoid()
                scores = (obj_s * tsk_s.clamp(min=0.10)).pow(0.6).cpu().numpy()
                boxes_cpu = pred_boxes[0].cpu()

                # Filter top predictions above score threshold
                keep_idx = np.where(scores > 0.15)[0]
                if len(keep_idx) == 0:
                    keep_idx = scores.argsort()[::-1][:5]
                else:
                    keep_idx = keep_idx[scores[keep_idx].argsort()[::-1][:5]]

                pred_scores_kept = scores[keep_idx].tolist()
                pred_boxes_kept = boxes_cpu[keep_idx]

                # Match with GT to compute image IoU score / recall
                if num_gt > 0:
                    gt_xyxy = box_cxcywh_to_xyxy(gt_boxes_norm)
                    if len(pred_boxes_kept) > 0:
                        pred_xyxy = safe_boxes_xyxy(pred_boxes_kept)
                        iou_mat = box_iou(pred_xyxy, gt_xyxy).numpy()
                        max_iou_per_gt = iou_mat.max(axis=0) if iou_mat.size > 0 else np.zeros(num_gt)
                        tp_count = (max_iou_per_gt >= 0.5).sum()
                        rec = tp_count / num_gt
                        mean_iou = max_iou_per_gt.mean()
                    else:
                        rec = 0.0
                        mean_iou = 0.0
                    metric_score = rec * 0.7 + mean_iou * 0.3
                else:
                    # GT empty: penalty for false positives
                    fp_count = (np.array(pred_scores_kept) > 0.3).sum()
                    metric_score = 1.0 if fp_count == 0 else max(0.0, 1.0 - fp_count * 0.25)

                sample_evals.append({
                    "idx": idx,
                    "img_path": sample_meta["img_path"],
                    "orig_w": sample_meta["img_w"],
                    "orig_h": sample_meta["img_h"],
                    "num_gt": num_gt,
                    "gt_boxes_norm": gt_boxes_norm,
                    "pred_boxes_norm": pred_boxes_kept,
                    "pred_scores": pred_scores_kept,
                    "metric_score": metric_score,
                })

            # Sort by metric_score ascending (worst first)
            sample_evals.sort(key=lambda x: x["metric_score"])
            worst_3 = sample_evals[:3]

            for rank, item in enumerate(worst_3, 1):
                orig_w, orig_h = item["orig_w"], item["orig_h"]
                
                # Convert GT boxes to pixels
                gt_boxes_pix = []
                if item["num_gt"] > 0:
                    gt_xyxy = box_cxcywh_to_xyxy(item["gt_boxes_norm"])
                    for b in gt_xyxy:
                        gt_boxes_pix.append([b[0]*orig_w, b[1]*orig_h, b[2]*orig_w, b[3]*orig_h])

                # Convert Pred boxes to pixels
                pred_boxes_pix = []
                if len(item["pred_boxes_norm"]) > 0:
                    pred_xyxy = safe_boxes_xyxy(item["pred_boxes_norm"])
                    for b in pred_xyxy:
                        pred_boxes_pix.append([b[0]*orig_w, b[1]*orig_h, b[2]*orig_w, b[3]*orig_h])

                # Build failure diagnosis text
                if item["num_gt"] == 0:
                    diag = f"False Positive: empty scene but predicted {len(item['pred_scores'])} boxes (max conf: {max(item['pred_scores'], default=0):.2f})"
                elif len(item["pred_boxes_norm"]) == 0:
                    diag = f"Complete Miss: {item['num_gt']} GT object(s) present, model produced 0 detections above threshold."
                else:
                    diag = f"Poor Alignment/Miss: {item['num_gt']} GT object(s), metric score={item['metric_score']:.2f}. Highest IoU overlap low or missed target."

                panel = create_side_by_side_panel(
                    item["img_path"],
                    gt_boxes_pix,
                    pred_boxes_pix,
                    item["pred_scores"],
                    tid,
                    task_name,
                    diag,
                )

                file_name = f"task_{tid+1:02d}_worst_{rank}_idx_{item['idx']}.png"
                panel.save(out_path / file_name)

            avg_task_score = np.mean([e["metric_score"] for e in sample_evals])
            task_diagnostics.append((tid + 1, task_name, len(indices), avg_task_score))

    print(f"\n{'='*70}")
    print(f"  PER-TASK FAILURE ANALYSIS SUMMARY (42 images saved to {out_dir})")
    print(f"{'='*70}")
    print(f"  {'Task ID':<8} {'Task Description':<32} {'Test Samples':<14} {'Health Score':<12}")
    print(f"{'-'*70}")
    for tid, name, count, score in task_diagnostics:
        status = "CRITICAL" if score < 0.4 else ("WEAK" if score < 0.6 else "HEALTHY")
        print(f"  Task {tid:<3}  {name[:30]:<32}  {count:<14}  {score*100:>5.1f}% ({status})")
    print(f"{'='*70}\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Failure Analysis")
    parser.add_argument("--config", type=str, default="configs/gatev_base.yaml")
    parser.add_argument("--checkpoint", type=str, default="runs/gatev_base/checkpoints/best.pth")
    parser.add_argument("--output-dir", type=str, default="runs/failure_analysis")
    args = parser.parse_args()

    cfg_file = ROOT / args.config if not Path(args.config).is_absolute() else Path(args.config)
    ckpt_file = ROOT / args.checkpoint if not Path(args.checkpoint).is_absolute() else Path(args.checkpoint)
    out_dir = ROOT / args.output_dir if not Path(args.output_dir).is_absolute() else Path(args.output_dir)

    analyze_failures(str(cfg_file), str(ckpt_file), str(out_dir))
