"""Training engine with gradient accumulation, EMA, early stopping.

Replaces train_stage_1(), train_stage_2(), run_training() from monolith.
"""
from __future__ import annotations

import math
import random
import time
from pathlib import Path

import numpy as np
import torch
import torch.nn as nn

from src.utils.config import VegaConfig
from src.utils.checkpoint import ModelEMA, CheckpointManager
from src.utils.logger import Logger
from src.utils.metrics import compute_map50
from src.model.losses import compute_loss
from src.model.gate import apply_semantic_seeding
from src.model.detector import VegaTaskAwareRTDETR
from src.data.collate import get_dataloaders


def set_seed(seed: int):
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)


def get_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device("cuda")
    elif hasattr(torch.backends, "mps") and torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


def build_model(cfg: VegaConfig) -> VegaTaskAwareRTDETR:
    return VegaTaskAwareRTDETR(
        num_tasks=cfg.model.num_tasks,
        num_queries=cfg.model.num_queries,
        hidden_dim=cfg.model.hidden_dim,
        num_encoder_layers=cfg.model.num_encoder_layers,
        num_decoder_layers=cfg.model.num_decoder_layers,
        eval_idx=cfg.model.eval_idx,
        task_embed_dim=cfg.model.task_embed_dim,
        fgtq_layers=cfg.model.fgtq_layers,
        cross_attn_method=cfg.model.cross_attn_method,
        use_learnable_residuals=cfg.model.use_learnable_residuals,
        inject_task_every_layer=cfg.model.inject_task_every_layer,
    )


def _warmup_lr(optimizer, epoch, warmup_epochs, base_lrs):
    """Linear LR warmup."""
    if epoch >= warmup_epochs:
        return
    alpha = epoch / max(warmup_epochs, 1)
    for param_group, base_lr in zip(optimizer.param_groups, base_lrs):
        param_group["lr"] = base_lr * alpha


def train_stage(
    model: nn.Module,
    train_loader,
    val_dataset,
    device: torch.device,
    cfg: VegaConfig,
    stage: int,
    logger: Logger,
    ckpt_mgr: CheckpointManager,
    ema: ModelEMA | None = None,
    start_epoch: int = 0,
    resume_state: dict | None = None,
) -> float:
    """Train one stage (1 or 2). Returns best mAP achieved."""
    stage_cfg = cfg.training.stage1 if stage == 1 else cfg.training.stage2
    val_cfg = cfg.validation
    epochs = stage_cfg.epochs
    grad_accum = cfg.training.grad_accum_steps

    # Freeze modules for stage 1
    if stage == 1:
        for name in stage_cfg.frozen_modules:
            module = getattr(model, name, None)
            if module:
                for p in module.parameters():
                    p.requires_grad = False
                module.eval()
                print(f"  [stage1] Frozen: {name}")

    # Optimizer with differential LR
    if stage == 1:
        trainable = [p for p in model.parameters() if p.requires_grad]
        optimizer = torch.optim.AdamW(
            trainable, lr=cfg.training.base_lr,
            weight_decay=cfg.training.weight_decay,
        )
        base_lrs = [cfg.training.base_lr]
    else:
        backbone_params, head_params = [], []
        for name, param in model.named_parameters():
            if name.startswith("backbone."):
                backbone_params.append(param)
            else:
                head_params.append(param)
        optimizer = torch.optim.AdamW([
            {"params": backbone_params, "lr": cfg.training.backbone_lr},
            {"params": head_params, "lr": cfg.training.base_lr},
        ], weight_decay=cfg.training.weight_decay)
        base_lrs = [cfg.training.backbone_lr, cfg.training.base_lr]

    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=epochs, eta_min=1e-6,
    )

    use_amp = cfg.training.amp and device.type == "cuda"
    scaler = torch.amp.GradScaler("cuda", enabled=use_amp)

    loss_weights = {
        "cls": stage_cfg.loss_weights.cls,
        "l1": stage_cfg.loss_weights.l1,
        "giou": stage_cfg.loss_weights.giou,
    }

    if resume_state is not None:
        if "optimizer" in resume_state: optimizer.load_state_dict(resume_state["optimizer"])
        if "scheduler" in resume_state: scheduler.load_state_dict(resume_state["scheduler"])
        if "scaler" in resume_state: scaler.load_state_dict(resume_state["scaler"])
        print(f"  [stage{stage}] Recovered optimizer/scheduler/scaler state")

    val_freq = val_cfg.stage1_frequency if stage == 1 else val_cfg.stage2_frequency
    best_map = resume_state.get("metric", 0.0) if resume_state else 0.0
    patience_counter = 0
    global_step = start_epoch * len(train_loader)

    print(f"\n{'=' * 64}")
    print(f"  STAGE {stage}  —  {epochs} epochs  [AMP={use_amp}]")
    print(f"  Grad accumulation: {grad_accum}  Effective batch: {cfg.training.batch_size * grad_accum}")
    print(f"{'=' * 64}")

    for epoch in range(start_epoch + 1, epochs + 1):
        model.train()
        if stage == 1:
            for name in stage_cfg.frozen_modules:
                module = getattr(model, name, None)
                if module:
                    module.eval()

        # LR warmup
        if epoch <= cfg.training.lr_warmup_epochs:
            _warmup_lr(optimizer, epoch - 1, cfg.training.lr_warmup_epochs, base_lrs)

        # Task loss lambda (stage 2 warmup)
        if stage == 2:
            warmup_ep = stage_cfg.task_loss_warmup_epochs
            if epoch <= warmup_ep:
                lambda_task = stage_cfg.task_loss_warmup_start + (
                    1.0 - stage_cfg.task_loss_warmup_start
                ) * ((epoch - 1) / max(warmup_ep - 1, 1))
            else:
                lambda_task = 1.0

            # Progressive backbone unfreezing at epoch 12 of stage 2
            if epoch == 12 and stage == 2:
                for p in model.backbone.parameters():
                    p.requires_grad = True
                print("  [stage2] Backbone progressively unfrozen at epoch 12")
        else:
            lambda_task = stage_cfg.task_loss_weight

        # No-object penalty — ramps from lambda_noobj → lambda_noobj_max
        if epoch > stage_cfg.lambda_noobj_ramp_epoch:
            lambda_noobj = stage_cfg.lambda_noobj_max
        else:
            lambda_noobj = stage_cfg.lambda_noobj

        running_loss = 0.0
        t0 = time.time()
        optimizer.zero_grad()

        for step, (images, task_ids, targets) in enumerate(train_loader):
            images = images.to(device)
            task_ids = task_ids.to(device)

            with torch.autocast(device_type=device.type, enabled=use_amp):
                pred_logits, pred_boxes, task_logits, exist_logits = model(images, task_ids)
                loss, ldict = compute_loss(
                    pred_logits, pred_boxes, task_logits, exist_logits,
                    targets, task_ids,
                    lambda_task=lambda_task,
                    lambda_noobj=lambda_noobj,
                    lambda_exists=stage_cfg.lambda_exists,
                    loss_weights=loss_weights,
                )
                loss = loss / grad_accum

            # NaN/Inf gradient detection
            if not torch.isfinite(loss):
                print(f"  [warning] Non-finite loss at step {step}, skipping")
                optimizer.zero_grad()
                continue

            scaler.scale(loss).backward()

            if (step + 1) % grad_accum == 0 or (step + 1) == len(train_loader):
                scaler.unscale_(optimizer)
                nn.utils.clip_grad_norm_(
                    model.parameters(), max_norm=cfg.training.max_grad_norm)
                scaler.step(optimizer)
                scaler.update()
                optimizer.zero_grad()

                if ema is not None:
                    ema.update(model)

            running_loss += ldict["total"]
            global_step += 1

            if step % cfg.experiment.log_interval == 0:
                extra = f"noobj={lambda_noobj:.1f}  exists={ldict.get('exists', 0.0):.4f}  scale={scaler.get_scale():.0f}"
                if stage == 2:
                    extra = f"λ={lambda_task:.2f}  " + extra
                logger.print_step(epoch, epochs, step, len(train_loader), ldict, extra)
                logger.log_loss(ldict, global_step, prefix=f"stage{stage}")

        scheduler.step()
        elapsed = time.time() - t0
        avg_loss = running_loss / max(len(train_loader), 1)
        lr_now = optimizer.param_groups[-1]["lr"]
        logger.scalar(f"stage{stage}/lr", lr_now, global_step)
        print(f"  [{epoch:>2}/{epochs}]  avg_loss={avg_loss:.4f}  lr={lr_now:.2e}  time={elapsed:.0f}s")

        # Validation
        if val_dataset is not None and epoch % val_freq == 0:
            eval_model = ema.ema if ema else model
            cur_map, per_task = compute_map50(
                eval_model, val_dataset, device,
                max_samples_per_task=val_cfg.max_samples_per_task,
            )
            print(f"  [val] mAP@0.5 = {cur_map:.4f}")
            logger.log_map(cur_map, per_task, global_step)

            saved = ckpt_mgr.save(
                model, optimizer, scheduler, epoch, cur_map,
                ema=ema, scaler=scaler,
                extra={"stage": stage, "config": cfg.__dict__},
            )
            if saved:
                print(f"  [val] Checkpoint saved: {saved.name}")

            if cur_map > best_map:
                best_map = cur_map
                patience_counter = 0
            else:
                patience_counter += 1
                if patience_counter >= val_cfg.early_stopping_patience:
                    print(f"  [early stopping] No improvement for {patience_counter} epochs")
                    break

    # Unfreeze for next stage
    if stage == 1:
        for p in model.parameters():
            p.requires_grad = True

    return best_map


def run_training(cfg: VegaConfig) -> None:
    """Full training pipeline: build model → stage1 → stage2 → save."""
    set_seed(cfg.experiment.seed)
    device = get_device()
    print(f"\n[train] Device: {device}")

    # Build model
    model = build_model(cfg)

    # Load pretrained RT-DETRv2 weights
    root = Path(cfg.data.dataset_dir).parent.parent
    ckpt_path = cfg.precomputed.pretrained_checkpoint
    if ckpt_path is None:
        ckpt_path = root / "data" / "models" / "rtdetrv2_r50vd_m_7x_coco_ema.pth"
        if not ckpt_path.exists():
            print("[model] Downloading RT-DETRv2-M checkpoint...")
            import urllib.request
            url = "https://github.com/lyuwenyu/storage/releases/download/v0.1/rtdetrv2_r50vd_m_7x_coco_ema.pth"
            ckpt_path.parent.mkdir(parents=True, exist_ok=True)
            urllib.request.urlretrieve(url, str(ckpt_path))
    model.load_pretrained_partial(str(ckpt_path))

    # Semantic seeding
    apply_semantic_seeding(
        model.fgtq_gate,
        precomputed_path=cfg.precomputed.clip_embeddings,
        dim=cfg.model.task_embed_dim,
    )

    model.to(device)

    # Optionally compile
    if cfg.training.use_compile:
        try:
            model = torch.compile(model)
            print("[train] torch.compile() enabled")
        except Exception as e:
            print(f"[train] torch.compile() failed: {e}")

    total_params = sum(p.numel() for p in model.parameters())
    trainable = sum(p.numel() for p in model.parameters() if p.requires_grad)
    print(f"[train] Parameters: {total_params:,} total, {trainable:,} trainable")

    # Data loaders
    train_loader, val_loader = get_dataloaders(
        cfg.data.dataset_dir, cfg.data.images_dir,
        batch_size=cfg.training.batch_size,
        num_workers=cfg.data.num_workers,
        img_size=cfg.training.img_size,
        pin_memory=cfg.data.pin_memory,
        aug_config=cfg.data.augmentations,
        cache_images=cfg.data.cache_images,
    )
    print(f"[train] Train: {len(train_loader.dataset):,} samples, {len(train_loader)} batches")
    print(f"[train] Val:   {len(val_loader.dataset):,} samples")

    # Logger + checkpoint manager
    run_dir = Path(cfg.experiment.output_dir) / cfg.experiment.name
    logger = Logger(run_dir / "logs", cfg.experiment.log_interval)
    ckpt_mgr = CheckpointManager(run_dir / "checkpoints", cfg.experiment.checkpoint_save_top_k)

    # EMA
    ema = ModelEMA(model, cfg.training.ema_decay) if cfg.training.use_ema else None

    # Resume Logic
    latest_ckpt = run_dir / "checkpoints" / "latest.pth"
    resume_stage = 1
    resume_epoch = 0
    resume_state = None

    if latest_ckpt.exists():
        print(f"\n[train] Found existing checkpoint {latest_ckpt}")
        try:
            resume_state = torch.load(latest_ckpt, map_location="cpu", weights_only=False)
            model.load_state_dict(resume_state["model"])
            if ema and "ema" in resume_state:
                ema.load_state_dict(resume_state["ema"])
            
            # Use 'extra' dict from checkpoint to find stage, fallback to 1
            extra = resume_state.get("stage", 1)  # previously we saved stage directly, or check extra dict
            # Checkpoint save structure: saved extra inside state if we passed it in save()
            resume_stage = resume_state.get("stage", 1)
            resume_epoch = resume_state.get("epoch", 0)
            print(f"[train] Resumed from Stage {resume_stage}, Epoch {resume_epoch}")
            
            # If a stage completed fully, roll over to the next stage
            if resume_stage == 1 and resume_epoch >= cfg.training.stage1.epochs:
                resume_stage = 2
                resume_epoch = 0
                resume_state = None  # don't carry stage1 optimizer into stage2
                print(f"[train] Stage 1 was complete, moving directly to Stage 2")
        except Exception as e:
            print(f"[train] Failed to load resume state: {e}")
            resume_state = None

    # Stage 1
    if resume_stage == 1:
        s1_map = train_stage(
            model, train_loader, val_loader.dataset, device, cfg,
            stage=1, logger=logger, ckpt_mgr=ckpt_mgr, ema=ema,
            start_epoch=resume_epoch, resume_state=resume_state,
        )
        print(f"\n[train] Stage 1 best mAP@0.5 = {s1_map:.4f}")
        # Reset for stage 2
        resume_epoch = 0
        resume_state = None

    # Stage 2
    if resume_stage <= 2:
        s2_map = train_stage(
            model, train_loader, val_loader.dataset, device, cfg,
            stage=2, logger=logger, ckpt_mgr=ckpt_mgr, ema=ema,
            start_epoch=resume_epoch, resume_state=resume_state,
        )
        print(f"\n[train] Stage 2 best mAP@0.5 = {s2_map:.4f}")

    # Final evaluation
    best_ckpt = run_dir / "checkpoints" / "best.pth"
    if best_ckpt.exists():
        state = torch.load(best_ckpt, map_location="cpu", weights_only=False)
        if ema and "ema" in state:
            ema.load_state_dict(state["ema"])
            eval_model = ema.ema
        else:
            model.load_state_dict(state["model"])
            eval_model = model
        eval_model.to(device)
    else:
        eval_model = ema.ema if ema else model

    print("\n[train] Final evaluation (full test split)...")
    final_map, per_task = compute_map50(eval_model, val_loader.dataset, device)
    print(f"[train] Final mAP@0.5 = {final_map:.4f}")
    for tid, ap in sorted(per_task.items()):
        print(f"  Task {tid + 1:>2}: AP@0.5 = {ap:.4f}")

    # Save final weights
    save_path = run_dir / "vega_edge_detect_final.pth"
    torch.save({
        "model": (ema.ema if ema else model).state_dict(),
        "config": {
            "num_tasks": cfg.model.num_tasks,
            "num_queries": cfg.model.num_queries,
            "hidden_dim": cfg.model.hidden_dim,
            "num_encoder_layers": cfg.model.num_encoder_layers,
            "num_decoder_layers": cfg.model.num_decoder_layers,
            "eval_idx": cfg.model.eval_idx,
            "task_embed_dim": cfg.model.task_embed_dim,
            "fgtq_layers": cfg.model.fgtq_layers,
            "cross_attn_method": cfg.model.cross_attn_method,
            "use_learnable_residuals": cfg.model.use_learnable_residuals,
            "inject_task_every_layer": cfg.model.inject_task_every_layer,
        },
    }, save_path)
    print(f"\n[train] Final weights saved → {save_path}")
    logger.close()
