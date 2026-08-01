"""Tests for config loading."""
from __future__ import annotations

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from src.utils.config import VegaConfig


def test_default_config():
    """Default config has sane values."""
    cfg = VegaConfig()
    assert cfg.model.num_tasks == 14
    assert cfg.model.hidden_dim == 256
    assert cfg.training.batch_size == 8
    assert cfg.training.stage1.epochs == 12
    assert cfg.training.stage2.epochs == 24
    cfg.validate()
    print("✓ test_default_config")


def test_yaml_loading():
    """Load from YAML file."""
    yaml_path = Path(__file__).resolve().parent.parent / "configs" / "vega_base.yaml"
    if not yaml_path.exists():
        print("⊘ test_yaml_loading (skipped — config file not found)")
        return
    cfg = VegaConfig.from_yaml(yaml_path)
    cfg.validate()
    assert cfg.training.img_size == 512
    assert cfg.model.fgtq_layers == ["P3", "P4", "P5"]
    print("✓ test_yaml_loading")


def test_overrides():
    """CLI overrides work."""
    yaml_path = Path(__file__).resolve().parent.parent / "configs" / "vega_base.yaml"
    if not yaml_path.exists():
        print("⊘ test_overrides (skipped — config file not found)")
        return
    cfg = VegaConfig.from_yaml(yaml_path, overrides=["training.batch_size=4"])
    assert cfg.training.batch_size == 4
    print("✓ test_overrides")


if __name__ == "__main__":
    test_default_config()
    test_yaml_loading()
    test_overrides()
    print("\nAll config tests passed!")
