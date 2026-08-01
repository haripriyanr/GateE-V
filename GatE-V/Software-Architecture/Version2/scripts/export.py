"""ONNX export for GatE-V model.

Exports the trained model to ONNX format for FPGA/edge deployment.

Usage:
    python scripts/export.py --config configs/vega_base.yaml \\
                              --checkpoint runs/vega_base/vega_edge_detect_final.pth

Output: <checkpoint_dir>/vega_exported.onnx
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

import torch
from src.utils.config import VegaConfig
from src.engine.trainer import get_device, build_model


def main():
    parser = argparse.ArgumentParser(description="GatE-V ONNX Export")
    parser.add_argument("--config", type=str, default="configs/vega_base.yaml")
    parser.add_argument("--checkpoint", type=str, required=True,
                        help="Path to .pth checkpoint")
    parser.add_argument("--output", type=str, default=None,
                        help="Output .onnx path (default: alongside checkpoint)")
    parser.add_argument("--img-size", type=int, default=None,
                        help="Override image size (default: from config)")
    parser.add_argument("--opset", type=int, default=18,
                        help="ONNX opset version (default: 18)")
    parser.add_argument("--task-id", type=int, default=0,
                        help="Task ID for dummy export input (0-13)")
    args = parser.parse_args()

    config_path = ROOT / args.config if not Path(args.config).is_absolute() else Path(args.config)
    cfg = VegaConfig.from_yaml(config_path)

    img_size = args.img_size or cfg.training.img_size
    ckpt_path = Path(args.checkpoint)
    if not ckpt_path.is_absolute():
        ckpt_path = ROOT / ckpt_path

    output = Path(args.output) if args.output else ckpt_path.parent / "vega_exported.onnx"

    print(f"[export] Checkpoint : {ckpt_path}")
    print(f"[export] Output     : {output}")
    print(f"[export] Image size : {img_size}")
    print(f"[export] ONNX opset : {args.opset}")

    # Build model
    device = torch.device("cpu")  # Export on CPU for portability
    model = build_model(cfg)

    state = torch.load(ckpt_path, map_location="cpu", weights_only=False)
    if "ema" in state:
        ckpt_state = state["ema"]
        print("[export] Loaded EMA weights")
    elif "model" in state:
        ckpt_state = state["model"]
        print("[export] Loaded model weights")
    else:
        ckpt_state = state
        print("[export] Loaded raw weights")

    clean_state = {k.replace("_orig_mod.", ""): v for k, v in ckpt_state.items()}
    model.load_state_dict(clean_state)

    model.eval()

    # Dummy inputs
    dummy_image = torch.randn(1, 3, img_size, img_size)
    dummy_task  = torch.tensor([args.task_id], dtype=torch.long)

    # Verify forward pass first
    with torch.no_grad():
        pred_logits, pred_boxes, task_logits, exist_logits = model(dummy_image, dummy_task)
    print(f"[export] Forward pass OK: logits={pred_logits.shape}, boxes={pred_boxes.shape}, exists={exist_logits.shape}")

    # Export
    output.parent.mkdir(parents=True, exist_ok=True)
    print(f"[export] Exporting...")
    torch.onnx.export(
        model,
        (dummy_image, dummy_task),
        str(output),
        opset_version=args.opset,
        input_names=["image", "task_id"],
        output_names=["pred_logits", "pred_boxes", "task_logits", "exist_logits"],
        dynamic_axes={
            "image": {0: "batch_size"},
            "task_id": {0: "batch_size"},
            "pred_logits": {0: "batch_size"},
            "pred_boxes": {0: "batch_size"},
            "task_logits": {0: "batch_size"},
            "exist_logits": {0: "batch_size"},
        },
        do_constant_folding=True,
    )

    size_mb = output.stat().st_size / 1e6
    print(f"[export] ✓ Saved to {output} ({size_mb:.1f} MB)")

    # Validate with onnxruntime if available
    try:
        import onnxruntime as ort
        import numpy as np
        sess = ort.InferenceSession(str(output), providers=["CPUExecutionProvider"])
        out = sess.run(None, {
            "image": dummy_image.numpy(),
            "task_id": dummy_task.numpy(),
        })
        print(f"[export] ✓ ONNX Runtime validation passed")
        print(f"         logits:      {out[0].shape}")
        print(f"         boxes:       {out[1].shape}")
        print(f"         task_logits: {out[2].shape}")
        print(f"         exist_logits:{out[3].shape}")
    except ImportError:
        print("[export] onnxruntime not installed — skipping validation")
        print("         pip install onnxruntime  (CPU) or onnxruntime-gpu (CUDA)")


if __name__ == "__main__":
    main()
