"""YAML configuration loader with dataclass validation.

Usage:
    cfg = GatEVConfig.from_yaml("configs/gatev_base.yaml")
    cfg = GatEVConfig.from_yaml("configs/gatev_base.yaml", overrides=["training.batch_size=4"])
"""
from __future__ import annotations

import copy
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

import yaml


# ── Nested config dataclasses ─────────────────────────────────────────────


@dataclass
class LossWeights:
    cls: float = 2.0
    l1: float = 5.0
    giou: float = 2.0
    task: float = 1.0


@dataclass
class StageConfig:
    epochs: int = 12
    batch_size: int = 0       # 0 = inherit from training.batch_size
    img_size: int = 0         # 0 = inherit from training.img_size
    frozen_modules: list[str] = field(default_factory=lambda: ["backbone"])
    loss_weights: LossWeights = field(default_factory=LossWeights)
    task_loss_weight: float = 0.0
    task_loss_warmup_epochs: int = 0
    task_loss_warmup_start: float = 0.1
    lambda_noobj: float = 6.0          # No-object penalty weight
    lambda_exists: float = 4.0         # Existence loss weight
    lambda_noobj_ramp_epoch: int = 10  # Epoch at which noobj ramps to max
    lambda_noobj_max: float = 10.0     # Max noobj weight after ramp epoch
    lambda_comp: float = 0.0           # Comparative ranking loss weight
    comp_margin: float = 0.5           # Comparative ranking margin
    base_lr: float = -1.0              # Stage-specific LR; -1 means use training.base_lr
    backbone_lr: float = -1.0          # Stage-specific backbone LR; -1 means use training.backbone_lr
    cost_cls: float = 2.0              # Hungarian matcher class cost weight
    cost_l1: float = 5.0               # Hungarian matcher L1 cost weight
    cost_giou: float = 2.0             # Hungarian matcher GIoU cost weight
    mal_alpha: float = 2.0             # Matchability-Aware Loss IoU exponent
    lambda_aux_head: float = 0.2       # CNN aux branch loss weight


@dataclass
class ModelConfig:
    backbone: str = "repvgg_b0"
    num_classes: int = 1
    num_tasks: int = 14
    hidden_dim: int = 256
    num_queries: int = 200
    num_encoder_layers: int = 1
    num_decoder_layers: int = 6
    eval_idx: int = -1
    task_embed_dim: int = 128
    fgtq_layers: list[str] = field(default_factory=lambda: ["P3", "P4", "P5"])
    clip_model: str = "ViT-B/32"
    clip_proj_method: str = "gaussian"
    use_fpga_discrete_sampling: bool = True
    cross_attn_method: str = "discrete"
    use_learnable_residuals: bool = True
    inject_task_every_layer: bool = True
    backbone_pretrained: bool = False
    use_fgpa: bool = False             # Fine-Grained Path Augmentation (P2 injection)
    use_aff: bool = False              # Adaptive Feature Fusion (learnable level weights)
    use_aux_head: bool = False         # CNN aux branch on encoder outputs (training-only)
    use_kd: bool = False               # Self-KD via EMA teacher
    kd_decay: float = 0.999            # Teacher EMA decay
    kd_weight: float = 0.1             # KD loss weight (fraction of total)


@dataclass
class TrainingConfig:
    stage1: StageConfig = field(default_factory=lambda: StageConfig(
        epochs=12,
        frozen_modules=["backbone"],
        loss_weights=LossWeights(cls=2.0, l1=5.0, giou=2.0),
        task_loss_weight=0.0,
    ))
    stage2: StageConfig = field(default_factory=lambda: StageConfig(
        epochs=24,
        frozen_modules=[],
        loss_weights=LossWeights(cls=2.0, l1=5.0, giou=2.0, task=1.0),
        task_loss_weight=1.0,
        task_loss_warmup_epochs=6,
        task_loss_warmup_start=0.1,
    ))
    batch_size: int = 8
    img_size: int = 512
    grad_accum_steps: int = 4
    amp: bool = True
    base_lr: float = 1e-4
    backbone_lr: float = 1e-5
    weight_decay: float = 1e-4
    max_grad_norm: float = 0.1
    bbox_loss: str = "l1"
    lr_scheduler: str = "cosine"
    lr_warmup_epochs: int = 3
    use_ema: bool = True
    ema_decay: float = 0.999
    use_compile: bool = False
    use_checkpoint: bool = False
    use_aux_loss: bool = True          # Weighted auxiliary decoder supervision


@dataclass
class HSVConfig:
    h: float = 0.015
    s: float = 0.7
    v: float = 0.4


@dataclass
class AugmentationConfig:
    hsv: HSVConfig = field(default_factory=HSVConfig)
    degrees: float = 0.0
    translate: float = 0.1
    scale: float = 0.5
    shear: float = 0.0
    perspective: float = 0.0
    flipud: float = 0.0
    fliplr: float = 0.5
    mosaic: float = 0.0
    mixup: float = 0.0


@dataclass
class ValidationConfig:
    stage1_frequency: int = 1
    stage2_frequency: int = 1
    early_stopping_patience: int = 10
    early_stopping_metric: str = "map_0.5"
    max_samples_per_task: int = 50


@dataclass
class DataConfig:
    coco_root: str = "./data/coco"
    dataset_dir: str = "./data/coco-tasks-dataset"
    images_dir: str = "./data/images"
    num_workers: int = 4
    pin_memory: bool = True
    cache_images: bool = False
    task_aware_sampling: bool = True
    max_samples_debug: int = -1
    augmentations: AugmentationConfig = field(default_factory=AugmentationConfig)


@dataclass
class ExperimentConfig:
    name: str = "vega_base"
    output_dir: str = "./runs"
    seed: int = 42
    log_interval: int = 50
    checkpoint_save_top_k: int = 3


@dataclass
class PrecomputedConfig:
    clip_embeddings: str | None = None
    pretrained_checkpoint: str | None = None


@dataclass
class GatEVConfig:
    """Top-level configuration for GatE-V training pipeline."""

    model: ModelConfig = field(default_factory=ModelConfig)
    training: TrainingConfig = field(default_factory=TrainingConfig)
    validation: ValidationConfig = field(default_factory=ValidationConfig)
    data: DataConfig = field(default_factory=DataConfig)
    experiment: ExperimentConfig = field(default_factory=ExperimentConfig)
    precomputed: PrecomputedConfig = field(default_factory=PrecomputedConfig)

    # ── Factory methods ───────────────────────────────────────────────

    @classmethod
    def from_yaml(cls, path: str | Path, overrides: list[str] | None = None) -> "GatEVConfig":
        """Load config from YAML file with optional CLI overrides.

        Overrides use dot notation: ``training.batch_size=4``
        """
        path = Path(path)
        if not path.exists():
            raise FileNotFoundError(f"Config file not found: {path}")

        with open(path) as f:
            raw = yaml.safe_load(f) or {}

        # Apply CLI overrides
        if overrides:
            for override in overrides:
                if "=" not in override:
                    raise ValueError(f"Invalid override format (use key=value): {override}")
                key, value = override.split("=", 1)
                _set_nested(raw, key.strip(), _parse_value(value.strip()))

        return cls._from_dict(raw)

    @classmethod
    def _from_dict(cls, d: dict[str, Any]) -> "GatEVConfig":
        """Recursively build config from a dict."""
        return cls(
            model=_build_dataclass(ModelConfig, d.get("model", {})),
            training=_build_training(d.get("training", {})),
            validation=_build_dataclass(ValidationConfig, d.get("validation", {})),
            data=_build_data(d.get("data", {})),
            experiment=_build_dataclass(ExperimentConfig, d.get("experiment", {})),
            precomputed=_build_dataclass(PrecomputedConfig, d.get("precomputed", {})),
        )

    # ── Validation ────────────────────────────────────────────────────

    def validate(self) -> None:
        """Run range checks and path existence checks."""
        errors: list[str] = []

        if self.training.base_lr <= 0:
            errors.append("training.base_lr must be > 0")
        if self.training.backbone_lr <= 0:
            errors.append("training.backbone_lr must be > 0")
        if self.training.weight_decay < 0:
            errors.append("training.weight_decay must be >= 0")
        if self.training.batch_size <= 0:
            errors.append("training.batch_size must be > 0")
        if self.training.stage1.epochs <= 0:
            errors.append("training.stage1.epochs must be > 0")
        if self.training.stage2.epochs <= 0:
            errors.append("training.stage2.epochs must be > 0")
        if self.training.img_size <= 0:
            errors.append("training.img_size must be > 0")
        if self.training.grad_accum_steps <= 0:
            errors.append("training.grad_accum_steps must be > 0")
        if not 0 < self.training.ema_decay < 1:
            errors.append("training.ema_decay must be in (0, 1)")
        if self.model.num_tasks <= 0:
            errors.append("model.num_tasks must be > 0")
        if self.model.num_queries <= 0:
            errors.append("model.num_queries must be > 0")
        
        valid_fgtq = {"P2", "P3", "P4", "P5"}
        for lvl in self.model.fgtq_layers:
            if lvl not in valid_fgtq:
                errors.append(f"Invalid fgtq_layer '{lvl}'. Must be one of {valid_fgtq}")

        if self.validation.early_stopping_patience <= 0:
            errors.append("validation.early_stopping_patience must be > 0")

        if errors:
            raise ValueError("Config validation failed:\n  " + "\n  ".join(errors))


# ── Helper functions ──────────────────────────────────────────────────────


def _build_dataclass(cls, d: dict[str, Any]):
    """Build a dataclass from a dict, ignoring unknown keys."""
    if not isinstance(d, dict):
        return cls()
    valid_keys = {f.name for f in cls.__dataclass_fields__.values()}
    filtered = {k: v for k, v in d.items() if k in valid_keys}
    return cls(**filtered)


def _build_training(d: dict[str, Any]) -> TrainingConfig:
    """Build TrainingConfig with nested StageConfig and LossWeights."""
    if not isinstance(d, dict):
        return TrainingConfig()
    d = copy.deepcopy(d)

    s1 = d.pop("stage1", {})
    s2 = d.pop("stage2", {})

    # Build stage configs with nested loss_weights
    stage1 = _build_stage(s1, defaults={"epochs": 12, "task_loss_weight": 0.0})
    stage2 = _build_stage(s2, defaults={"epochs": 24, "task_loss_weight": 1.0})

    valid_keys = {f.name for f in TrainingConfig.__dataclass_fields__.values()}
    filtered = {k: v for k, v in d.items() if k in valid_keys and k not in ("stage1", "stage2")}

    return TrainingConfig(stage1=stage1, stage2=stage2, **filtered)


def _build_stage(d: dict[str, Any], defaults: dict | None = None) -> StageConfig:
    if not isinstance(d, dict):
        d = {}
    d = {**(defaults or {}), **d}
    lw = d.pop("loss_weights", {})
    if isinstance(lw, dict):
        d["loss_weights"] = _build_dataclass(LossWeights, lw)
    return _build_dataclass(StageConfig, d)


def _build_data(d: dict[str, Any]) -> DataConfig:
    """Build DataConfig with nested AugmentationConfig."""
    if not isinstance(d, dict):
        return DataConfig()
    d = copy.deepcopy(d)
    aug = d.pop("augmentations", {})
    if isinstance(aug, dict):
        hsv = aug.pop("hsv", {})
        if isinstance(hsv, dict):
            aug["hsv"] = _build_dataclass(HSVConfig, hsv)
        d["augmentations"] = _build_dataclass(AugmentationConfig, aug)
    valid_keys = {f.name for f in DataConfig.__dataclass_fields__.values()}
    filtered = {k: v for k, v in d.items() if k in valid_keys}
    return DataConfig(**filtered)


def _set_nested(d: dict, key: str, value: Any) -> None:
    """Set a value in a nested dict using dot notation."""
    parts = key.split(".")
    for part in parts[:-1]:
        if part not in d or not isinstance(d[part], dict):
            d[part] = {}
        d = d[part]
    d[parts[-1]] = value


def _parse_value(s: str) -> Any:
    """Parse a CLI override value string into the appropriate Python type."""
    if s.lower() in ("true", "yes"):
        return True
    if s.lower() in ("false", "no"):
        return False
    if s.lower() in ("null", "none"):
        return None
    try:
        return int(s)
    except ValueError:
        pass
    try:
        return float(s)
    except ValueError:
        pass
    return s
