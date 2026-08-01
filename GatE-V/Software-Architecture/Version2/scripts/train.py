"""Training entry point.

Usage:
    python scripts/train.py --config configs/vega_base.yaml
    python scripts/train.py --config configs/vega_base.yaml --override training.batch_size=4
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

# Add project root to path
ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))

import torch

from src.utils.config import VegaConfig
from src.engine.trainer import run_training

# Enable TF32 for RTX 4000 series (allows fused flash-attention)
torch.set_float32_matmul_precision("high")

def main():
    parser = argparse.ArgumentParser(description="GatE-V Training")
    parser.add_argument(
        "--config", type=str, default="configs/vega_base.yaml",
        help="Path to YAML config file",
    )
    parser.add_argument(
        "--override", nargs="*", default=[],
        help="Config overrides in key=value format (e.g. training.batch_size=4)",
    )
    args = parser.parse_args()

    config_path = ROOT / args.config if not Path(args.config).is_absolute() else Path(args.config)
    cfg = VegaConfig.from_yaml(config_path, overrides=args.override)
    cfg.validate()

    print(f"[config] Loaded: {config_path}")
    print(f"[config] Experiment: {cfg.experiment.name}")
    print(f"[config] Image size: {cfg.training.img_size}")
    print(f"[config] Batch size: {cfg.training.batch_size} × {cfg.training.grad_accum_steps} = {cfg.training.batch_size * cfg.training.grad_accum_steps}")
    print(f"[config] FGTQGate layers: {cfg.model.fgtq_layers}")
    print(f"[config] Cross-attn method: {cfg.model.cross_attn_method}")

    run_training(cfg)


if __name__ == "__main__":
    main()
