"""Evaluation entry point.

Usage:
    python scripts/eval.py --config configs/gatev_base.yaml --checkpoint runs/gatev_base/checkpoints/best.pth
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

from src.utils.config import GatEVConfig
from src.engine.trainer import get_device, build_model
from src.engine.evaluator import run_evaluation
from src.data.dataset import COCOTasksDataset


def main():
    parser = argparse.ArgumentParser(description="GatE-V Evaluation")
    parser.add_argument("--config", type=str, default="configs/gatev_base.yaml")
    parser.add_argument("--checkpoint", type=str, required=True)
    args = parser.parse_args()

    config_path = ROOT / args.config if not Path(args.config).is_absolute() else Path(args.config)
    cfg = GatEVConfig.from_yaml(config_path)
    device = get_device()

    # Load model
    import torch
    ckpt = torch.load(args.checkpoint, map_location="cpu", weights_only=False)
    ckpt_cfg = ckpt.get("config", {})

    model = build_model(cfg)
    if "ema" in ckpt:
        state = ckpt["ema"]
    else:
        state = ckpt["model"]
    
    clean_state = {k.replace("_orig_mod.", ""): v for k, v in state.items()}
    model.load_state_dict(clean_state)
    model.to(device)

    # Load test dataset
    test_ds = COCOTasksDataset(
        cfg.data.dataset_dir, cfg.data.images_dir,
        split="test", img_size=cfg.training.img_size, augment=False,
    )

    run_evaluation(model, test_ds, device)


if __name__ == "__main__":
    main()
