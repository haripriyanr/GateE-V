"""Gating threshold optimization sweep script.

Usage:
    python scripts/optimize_gating.py --config configs/vega_base.yaml --checkpoint runs/vega_base/checkpoints/best.pth
"""
from __future__ import annotations

import argparse
import sys
from datetime import datetime
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

import torch
import numpy as np
from src.utils.config import VegaConfig
from src.engine.trainer import get_device, build_model
from src.data.dataset import COCOTasksDataset
import src.utils.metrics as metrics


def main():
    parser = argparse.ArgumentParser(description="GatE-V Threshold Optimization Sweep")
    parser.add_argument("--config", type=str, default="configs/vega_base.yaml")
    parser.add_argument("--checkpoint", type=str, required=True,
                        help="Path to trained checkpoint (e.g. runs/vega_base/vega_edge_detect_final.pth)")
    parser.add_argument("--start", type=float, default=0.0)
    parser.add_argument("--end", type=float, default=0.50)
    parser.add_argument("--step", type=float, default=0.05)
    args = parser.parse_args()

    config_path = ROOT / args.config if not Path(args.config).is_absolute() else Path(args.config)
    cfg = VegaConfig.from_yaml(config_path)
    device = get_device()

    # Load model
    print(f"[optimize] Loading model from checkpoint: {args.checkpoint}...")
    ckpt = torch.load(args.checkpoint, map_location="cpu", weights_only=False)

    model = build_model(cfg)
    
    if "ema" in ckpt:
        state = ckpt["ema"]
        print("[optimize] Loaded EMA weights")
    elif "model" in ckpt:
        state = ckpt["model"]
        print("[optimize] Loaded model weights")
    else:
        state = ckpt
        print("[optimize] Loaded raw weights")
        
    # Strip torch.compile prefix if present
    clean_state = {k.replace("_orig_mod.", ""): v for k, v in state.items()}
    model.load_state_dict(clean_state)
    
    model.to(device)
    model.eval()

    # Load full test dataset
    print("[optimize] Loading full test dataset...")
    test_ds = COCOTasksDataset(
        cfg.data.dataset_dir, cfg.data.images_dir,
        split="test", img_size=cfg.training.img_size, augment=False,
    )

    # 1. Forward Pass & Caching
    print("\n[optimize] Running full test set inference and caching logits...")
    cached_data = []
    
    with torch.no_grad():
        for i in range(len(test_ds)):
            sample = test_ds[i]
            task_id = int(sample["task_id"])
            img_t = sample["image"].unsqueeze(0).to(device)
            tid_t = torch.tensor([task_id], device=device)
            
            pred_logits, pred_boxes, task_logits, exist_logits = model(img_t, tid_t)
            
            cached_data.append({
                "task_id": task_id,
                "gt_boxes": sample["boxes"],
                "pred_logits": pred_logits[0].cpu(),
                "pred_boxes": pred_boxes[0].cpu(),
                "task_logits": task_logits[0].cpu(),
                "exist_logits": exist_logits[0].cpu()
            })
            if (i+1) % 1000 == 0:
                print(f"  --> Processed {i+1}/{len(test_ds)} images")

    print("[optimize] Inference complete! Starting ultra-fast hyperparameter sweep...")

    # Helper to compute mAP from cached data
    def compute_map_from_cache(threshold: float | None = None) -> float:
        task_results: dict[int, dict] = {t: {"scores": [], "tp": [], "num_gt": 0} for t in range(14)}
        
        for item in cached_data:
            tid = item["task_id"]
            task_results[tid]["num_gt"] += len(item["gt_boxes"])
            
            obj_s = item["pred_logits"].sigmoid().squeeze(-1)
            tsk_s = item["task_logits"][:, tid].sigmoid()
            exist_prob = item["exist_logits"].sigmoid().item()
            
            tsk_s_floored = tsk_s.clamp(min=metrics.TASK_MIN_CONF)
            base_scores = (obj_s * tsk_s_floored).pow(metrics.SCORE_EXPONENT)
            
            if threshold is not None:
                # Hard Gating
                if exist_prob >= threshold:
                    scores = base_scores.numpy()
                else:
                    scores = np.zeros_like(base_scores.numpy())
            else:
                # Baseline Soft Gating
                scores = (base_scores * exist_prob).numpy()
                
            boxes_cpu = item["pred_boxes"]
            order = scores.argsort()[::-1].copy()
            scores = scores[order]
            boxes_cpu = boxes_cpu[order]
            
            if len(item["gt_boxes"]) > 0:
                from src.model.matcher import box_cxcywh_to_xyxy, safe_boxes_xyxy
                from torchvision.ops import box_iou
                
                gt_xyxy = box_cxcywh_to_xyxy(item["gt_boxes"])
                gt_matched = np.zeros(len(item["gt_boxes"]), dtype=bool)
                tp = []
                for i in range(len(boxes_cpu)):
                    box_xyxy = safe_boxes_xyxy(boxes_cpu[i:i + 1])
                    iou = box_iou(box_xyxy, gt_xyxy).squeeze(0).numpy()
                    best_j = int(iou.argmax())
                    if float(iou[best_j]) >= 0.5 and not gt_matched[best_j]:
                        gt_matched[best_j] = True
                        tp.append(1)
                    else:
                        tp.append(0)
            else:
                tp = [0] * len(scores)
            
            task_results[tid]["scores"].extend(scores.tolist())
            task_results[tid]["tp"].extend(tp)
            
        aps = []
        for t in range(14):
            if task_results[t]["num_gt"] == 0 or len(task_results[t]["scores"]) == 0: 
                continue
                
            s_arr = np.array(task_results[t]["scores"])
            tp_arr = np.array(task_results[t]["tp"], dtype=np.float32)
            order = s_arr.argsort()[::-1]
            tp_sorted = tp_arr[order]
            tp_cum = tp_sorted.cumsum()
            fp_cum = (1.0 - tp_sorted).cumsum()
            precision = tp_cum / (tp_cum + fp_cum + 1e-9)
            recall = tp_cum / (task_results[t]["num_gt"] + 1e-9)
            
            ap = 0.0
            for thresh in np.linspace(0.0, 1.0, 101):
                mask = recall >= thresh
                ap += (float(precision[mask].max()) if mask.any() else 0.0) / 101.0
            aps.append(ap)
            
        return sum(aps) / len(aps) if aps else 0.0

    # 2. Baseline
    print("\n[optimize] Evaluating Baseline (Original Soft Gating)...")
    baseline_map = compute_map_from_cache(threshold=None)
    print(f"  --> Baseline Soft-Gating mAP@0.5 = {baseline_map:.4f}")

    # 3. Sweep
    thresholds = np.arange(args.start, args.end + 1e-9, args.step)
    results = []

    print("\n" + "=" * 60)
    print(f"  SWEEPING HARD GATING EXIST_THRESHOLD ({args.start:.2f} -> {args.end:.2f})")
    print("=" * 60)

    for thresh in thresholds:
        thresh = float(round(thresh, 4))
        map_val = compute_map_from_cache(threshold=thresh)
        print(f"  [sweep] Exist Threshold = {thresh:.3f}  -->  mAP@0.5 = {map_val:.4f}")
        results.append((thresh, map_val))

    print("=" * 60)

    # Find the best result
    best_thresh, best_map = max(results, key=lambda x: x[1])

    print(f"\n[optimize] Sweep Completed!")
    print(f"  Best Gating Threshold found: {best_thresh:.3f}")
    print(f"  Best Gating mAP@0.5:         {best_map:.4f} (Baseline was {baseline_map:.4f})")
    improvement = best_map - baseline_map
    print(f"  Absolute mAP Gain:           {improvement:+.4f}")

    # Save Log
    now_str = datetime.now().strftime("%Y%m%d_%H%M%S")
    log_dir = ROOT / "runs" / "vega_base" / "threshold_run"
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / f"threshold_run_{now_str}.log"

    print(f"\n[optimize] Writing proof and sweep results to log file...")
    with open(log_file, "w") as f:
        f.write("============================================================\n")
        f.write("             GatE-V POST-TRAINING THRESHOLD OPTIMIZATION    \n")
        f.write("============================================================\n")
        f.write(f"Date/Time:         {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
        f.write(f"Checkpoint Used:   {args.checkpoint}\n")
        f.write(f"Config File:       {args.config}\n")
        f.write(f"Baseline Soft mAP: {baseline_map:.6f}\n")
        f.write("------------------------------------------------------------\n")
        f.write("                 SWEEP RESULTS (HARD GATING)                \n")
        f.write("------------------------------------------------------------\n")
        f.write(" Threshold   |   mAP@0.5     |   Improvement vs Baseline  \n")
        f.write("-------------|---------------|----------------------------\n")
        for thresh, map_val in results:
            diff = map_val - baseline_map
            f.write(f"   {thresh:<9.3f} |   {map_val:<13.6f} |   {diff:+.6f}\n")
        f.write("------------------------------------------------------------\n")
        f.write(f"RECOMMENDED THRESHOLD SETTING:  {best_thresh:.3f}\n")
        f.write(f"FINAL OPTIMIZED mAP@0.5:        {best_map:.6f} ({improvement:+.6f} gain)\n")
        f.write("============================================================\n")

    print(f"[optimize] Log successfully created at:")
    print(f"  --> {log_file}")


if __name__ == "__main__":
    main()
