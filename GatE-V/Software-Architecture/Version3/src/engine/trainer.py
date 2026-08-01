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

from src.utils.config import GatEVConfig
from src.utils.checkpoint import ModelEMA, CheckpointManager
from src.utils.logger import Logger
from src.utils.metrics import compute_map50
from src.model.losses import compute_loss
from src.model.gate import apply_semantic_seeding
from src.model.detector import GatEVTaskAwareRTDETR
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


def build_model(cfg: GatEVConfig) -> GatEVTaskAwareRTDETR:
    return GatEVTaskAwareRTDETR(
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
        backbone_name=cfg.model.backbone,
        backbone_pretrained=cfg.model.backbone_pretrained,
        use_checkpoint=cfg.training.use_checkpoint,
        use_fgpa=cfg.model.use_fgpa,
        use_aff=cfg.model.use_aff,
        use_aux_head=getattr(cfg.model, "use_aux_head", False),
        use_kd=getattr(cfg.model, "use_kd", False),
        kd_decay=getattr(cfg.model, "kd_decay", 0.999),
    )


def _warmup_lr(optimizer, epoch, warmup_epochs, base_lrs):
    """Linear LR warmup. epoch is 0-indexed, warmup spans epochs [0, warmup_epochs-1]."""
    if epoch >= warmup_epochs:
        return
    alpha = (epoch + 1) / max(warmup_epochs, 1)  # [1/warmup...1.0]
    for param_group, base_lr in zip(optimizer.param_groups, base_lrs):
        param_group["lr"] = base_lr * alpha


def train_stage(
    model: nn.Module,
    train_loader,
    val_dataset,
    device: torch.device,
    cfg: GatEVConfig,
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

    # Reset SWA state from previous stage (function attribute persists across calls)
    # Only reset if NOT restoring from a checkpoint (resume_state handles restoration)
    if resume_state is None:
        if hasattr(train_stage, "swa_state"):
            del train_stage.swa_state
        if hasattr(train_stage, "swa_count"):
            del train_stage.swa_count

    # Freeze modules for stage 1
    if stage == 1:
        for name in stage_cfg.frozen_modules:
            module = getattr(model, name, None)
            if module:
                for p in module.parameters():
                    p.requires_grad = False
                module.eval()
                print(f"  [stage1] Frozen: {name}")

    # Resolve stage-specific LR with fallback to global training LR
    stage_base_lr = stage_cfg.base_lr if stage_cfg.base_lr > 0 else cfg.training.base_lr
    stage_backbone_lr = stage_cfg.backbone_lr if stage_cfg.backbone_lr > 0 else cfg.training.backbone_lr

    # Optimizer with differential LR
    if stage == 1:
        trainable = [p for p in model.parameters() if p.requires_grad]
        optimizer = torch.optim.AdamW(
            trainable, lr=stage_base_lr,
            weight_decay=cfg.training.weight_decay,
        )
        base_lrs = [stage_base_lr]
    else:
        backbone_params, head_params = [], []
        for name, param in model.named_parameters():
            if name.startswith("backbone."):
                backbone_params.append(param)
            else:
                head_params.append(param)
        optimizer = torch.optim.AdamW([
            {"params": backbone_params, "lr": stage_backbone_lr},
            {"params": head_params, "lr": stage_base_lr},
        ], weight_decay=cfg.training.weight_decay)
        base_lrs = [stage_backbone_lr, stage_base_lr]

    scheduler_delay = cfg.training.lr_warmup_epochs if stage == 1 else 5
    cosine_epochs = max(epochs - scheduler_delay, 1)
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=cosine_epochs, eta_min=1e-6,
    )

    use_amp = cfg.training.amp and device.type == "cuda"
    amp_dtype = torch.bfloat16 if use_amp and torch.cuda.is_bf16_supported() else torch.float16
    scaler = torch.amp.GradScaler("cuda", enabled=use_amp and amp_dtype == torch.float16)

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
    print(f"  STAGE {stage}  —  {epochs} epochs  [AMP={use_amp}, dtype={amp_dtype if use_amp else 'fp32'}]")
    print(f"  Grad accumulation: {grad_accum}  Effective batch: {cfg.training.batch_size * grad_accum}")
    print(f"{'=' * 64}")

    for epoch in range(start_epoch + 1, epochs + 1):
        model.train()
        if stage == 1:
            for name in stage_cfg.frozen_modules:
                module = getattr(model, name, None)
                if module:
                    module.eval()

        # Re-freeze backbone at stage 2 start (stage 1 unfroze everything at its end)
        if stage == 2 and epoch == 1:
            for p in model.backbone.parameters():
                p.requires_grad = False
            print(f"  [stage2] Backbone re-frozen at epoch {epoch}")

        # LR warmup (stage 1 only — stage 2 uses the bridge below)
        if stage == 1 and epoch <= cfg.training.lr_warmup_epochs:
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

            # LR warmup bridge: cosine resets to base_lr at stage 2 start;
            # ramp linearly from a small fraction to full base_lr over 5 epochs
            bridge_epochs = 5
            if epoch <= bridge_epochs:
                alpha = epoch / max(bridge_epochs, 1)
                for param_group, base_lr in zip(optimizer.param_groups, base_lrs):
                    param_group["lr"] = base_lr * alpha

            # Progressive backbone unfreezing at 20% into stage 2
            unfreeze_ep = max(1, epochs // 5)
            if epoch >= unfreeze_ep and stage == 2 and not getattr(model, '_backbone_unfrozen', False):
                for p in model.backbone.parameters():
                    p.requires_grad = True
                print(f"  [stage2] Backbone progressively unfrozen at epoch {unfreeze_ep}")
                model._backbone_unfrozen = True
        else:
            lambda_task = stage_cfg.task_loss_weight

        # No-object penalty — linear ramp from lambda_noobj → lambda_noobj_max
        ramp_ep = stage_cfg.lambda_noobj_ramp_epoch
        if ramp_ep > 0 and epoch <= ramp_ep:
            ratio = (epoch - 1) / max(ramp_ep, 1)
            lambda_noobj = stage_cfg.lambda_noobj + ratio * (
                stage_cfg.lambda_noobj_max - stage_cfg.lambda_noobj
            )
        else:
            lambda_noobj = stage_cfg.lambda_noobj_max

        running_loss = 0.0
        running_components = {}
        t0 = time.time()
        optimizer.zero_grad()

        for step, (images, task_ids, targets) in enumerate(train_loader):
            images = images.to(device)
            task_ids = task_ids.to(device)

            with torch.autocast(device_type=device.type, dtype=amp_dtype, enabled=use_amp):
                res = model(images, task_ids)
                pred_logits, pred_boxes, task_logits, exist_logits, aux_outputs, enc_outputs, aux_preds = res
                lambda_comp = getattr(stage_cfg, "lambda_comp", 0.0)
                comp_margin = getattr(stage_cfg, "comp_margin", 0.5)

                # Teacher prediction for self-KD
                raw_model = getattr(model, "module", model)
                teacher_out = None
                if getattr(raw_model, "use_kd", False) and raw_model.teacher is not None:
                    raw_model.teacher.eval()
                    with torch.no_grad():
                        t_logits, t_boxes, *_ = raw_model.teacher(images, task_ids)
                        teacher_out = (t_logits, t_boxes)

                loss, ldict = compute_loss(
                    pred_logits, pred_boxes, task_logits, exist_logits,
                    targets, task_ids,
                    lambda_task=lambda_task,
                    lambda_noobj=lambda_noobj,
                    lambda_exists=stage_cfg.lambda_exists,
                    lambda_comp=lambda_comp,
                    comp_margin=comp_margin,
                    loss_weights=loss_weights,
                    bbox_loss_type=cfg.training.bbox_loss,
                    mal_alpha=stage_cfg.mal_alpha,
                    cost_cls=stage_cfg.cost_cls,
                    cost_l1=stage_cfg.cost_l1,
                    cost_giou=stage_cfg.cost_giou,
                    aux_outputs=aux_outputs if cfg.training.use_aux_loss else None,
                    enc_outputs=enc_outputs,
                    aux_preds=aux_preds if getattr(cfg.model, "use_aux_head", False) else None,
                    teacher_out=teacher_out,
                    kd_weight=getattr(cfg.model, "kd_weight", 0.1),
                    lambda_aux_head=getattr(stage_cfg, "lambda_aux_head", 0.2),
                )
                loss = loss / grad_accum

            # NaN/Inf gradient detection
            if not torch.isfinite(loss):
                print(f"  [warning] Non-finite loss at step {step}, skipping")
                continue

            scaler.scale(loss).backward()

            if (step + 1) % grad_accum == 0 or (step + 1) == len(train_loader):
                scaler.unscale_(optimizer)
                nn.utils.clip_grad_norm_(
                    model.parameters(), max_norm=cfg.training.max_grad_norm)
                old_scale = scaler.get_scale()
                scaler.step(optimizer)
                scaler.update()
                optimizer.zero_grad()

                if ema is not None:
                    if scaler.get_scale() == old_scale:
                        ema.update(model)

                # Update EMA teacher (student → teacher)
                raw_model = getattr(model, "module", model)
                if getattr(raw_model, "use_kd", False):
                    if scaler.get_scale() == old_scale:
                        raw_model.update_teacher()

            running_loss += ldict["total"]
            for k, v in ldict.items():
                if k != "total":
                    running_components[k] = running_components.get(k, 0.0) + v
            global_step += 1

            if step % cfg.experiment.log_interval == 0:
                extra = f"noobj={lambda_noobj:.1f}  exists={ldict.get('exists', 0.0):.4f}  scale={scaler.get_scale():.0f}"
                if stage == 2:
                    extra = f"λ={lambda_task:.2f}  " + extra
                logger.print_step(epoch, epochs, step, len(train_loader), ldict, extra)
                logger.log_loss(ldict, global_step, prefix=f"stage{stage}")

        if epoch > scheduler_delay:
            scheduler.step()
        elapsed = time.time() - t0
        avg_loss = running_loss / max(len(train_loader), 1)
        lr_now = optimizer.param_groups[-1]["lr"]
        logger.scalar(f"stage{stage}/lr", lr_now, global_step)
        num_steps = max(len(train_loader), 1)
        comp_str = "  ".join(f"{k}={v/num_steps:.4f}" for k, v in sorted(running_components.items()))
        print(f"  [{epoch:>2}/{epochs}]  avg_loss={avg_loss:.4f}  {comp_str}  lr={lr_now:.2e}  time={elapsed:.0f}s")

        # --- Dead Layer Checker ---
        dead_layer_stats = []
        hooks = []
        def get_hook(name):
            def hook(m, inp, out):
                dead_pct = (out == 0).sum().item() / max(out.numel(), 1) * 100
                dead_layer_stats.append((name, dead_pct))
            return hook
        
        raw_model = getattr(model, "module", model)
        for name, layer in raw_model.backbone.named_modules():
            if isinstance(layer, torch.nn.Conv2d):
                hooks.append(layer.register_forward_hook(get_hook(name)))
                
        raw_model.eval()
        with torch.no_grad(), torch.autocast(device_type=device.type, dtype=amp_dtype, enabled=use_amp):
            raw_model(images[0:1], task_ids[0:1])
        raw_model.train()
        
        for h in hooks: h.remove()
        
        print(f"  \033[0;36m{'='*48}\033[0m")
        print(f"  \033[0;36mBackbone Dead Neuron Health Report\033[0m")
        print(f"  \033[0;36m{'='*48}\033[0m")
        for name, pct in dead_layer_stats:
            color = "\033[0;31m" if pct > 20 else ("\033[0;33m" if pct > 5 else "\033[0;32m")
            status = "[!]" if pct > 20 else ("[~]" if pct > 5 else "[✓]")
            print(f"  {color}{status} {name:<25}: {pct:>6.2f}% dead\033[0m")
        print(f"  \033[0;36m{'='*48}\033[0m")
        # --------------------------

        # SWA: collect running average during last 20% of epochs
        swa_start = max(1, epochs * 4 // 5)
        swa_min_epochs = 5  # only start SWA after at least this many epochs
        if epoch >= swa_start and epochs >= swa_min_epochs:
            if not hasattr(train_stage, "swa_state"):
                train_stage.swa_state = {
                    k.replace("_orig_mod.", ""): v.data.clone() for k, v in model.state_dict().items()
                }
                train_stage.swa_count = 1
            else:
                n = train_stage.swa_count
                for k, v in model.state_dict().items():
                    key = k.replace("_orig_mod.", "")
                    if v.dtype.is_floating_point:
                        train_stage.swa_state[key].mul_(n / (n + 1)).add_(v.data / (n + 1))
                train_stage.swa_count += 1
            if epoch == epochs:
                print(f"  [SWA] Averaged {train_stage.swa_count} snapshots from epoch {swa_start}")
                # BN recalibration: run forward passes with SWA weights to update running stats
                if hasattr(train_stage, "swa_state"):
                    print(f"  [SWA] Recalibrating BN statistics over {min(50, len(train_loader))} batches...")
                    swa_model = build_model(cfg).to(device)
                    swa_model.load_state_dict(train_stage.swa_state)
                    swa_model.train()
                    with torch.no_grad():
                        for i, (cal_images, cal_tasks, _) in enumerate(train_loader):
                            if i >= 50:
                                break
                            swa_model(cal_images.to(device), cal_tasks.to(device))
                    train_stage.swa_state = {k: v.data.clone() for k, v in swa_model.state_dict().items()}
                    del swa_model
                    print(f"  [SWA] BN recalibration complete")

        # Validation
        if val_dataset is not None and epoch % val_freq == 0:
            eval_model = ema.ema if ema else model
            cur_map, per_task = compute_map50(
                eval_model, val_dataset, device,
                max_samples_per_task=val_cfg.max_samples_per_task,
            )
            print(f"  [val] mAP@0.5 = {cur_map:.4f}")
            logger.log_map(cur_map, per_task, global_step)

            extra_dict = {"stage": stage, "config": cfg.__dict__}
            if hasattr(train_stage, "swa_state"):
                extra_dict["swa_state"] = train_stage.swa_state
                extra_dict["swa_count"] = train_stage.swa_count

            saved = ckpt_mgr.save(
                model, optimizer, scheduler, epoch, cur_map,
                ema=ema, scaler=scaler,
                extra=extra_dict,
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


def _ensure_batch_fits(
    model: nn.Module,
    train_loader,
    cfg: GatEVConfig,
    device: torch.device,
):
    """Probe real batch forward+backward; halve batch until peak < 85% VRAM."""
    if device.type != "cuda":
        return cfg.training.batch_size, cfg.training.grad_accum_steps, train_loader

    total = torch.cuda.get_device_properties(0).total_memory
    
    def _recreate(bs, workers=0):
        return get_dataloaders(
            cfg.data.dataset_dir, cfg.data.images_dir,
            batch_size=bs,
            num_workers=workers,
            img_size=cfg.training.img_size,
            pin_memory=cfg.data.pin_memory,
            aug_config=cfg.data.augmentations,
            cache_images=cfg.data.cache_images,
            max_samples_debug=cfg.data.max_samples_debug,
        )

    max_requested = cfg.training.batch_size
    target_eff_batch = cfg.training.batch_size * cfg.training.grad_accum_steps
    
    if total > 24 * 1024**3:
        batch_size = 12
    else:
        batch_size = 2
        
    if batch_size > max_requested:
        batch_size = max_requested
        
    grad_accum = int(math.ceil(target_eff_batch / batch_size))
    
    best_bs = 1
    best_accum = target_eff_batch
    
    while batch_size <= max_requested:
        train_loader, val_loader = _recreate(batch_size, workers=0)
        probe_iter = iter(train_loader)
        
        try:
            images, task_ids, targets = next(probe_iter)
            images = images.to(device, non_blocking=True)
            task_ids = task_ids.to(device, non_blocking=True)

            model.train()
            with torch.autocast(device_type=device.type,
                                dtype=torch.bfloat16 if torch.cuda.is_bf16_supported() else torch.float16,
                                enabled=cfg.training.amp):
                pred_logits, pred_boxes, task_logits, exist_logits, aux_outputs, enc_outputs, _ = model(images, task_ids)
                loss = pred_logits.sum() + pred_boxes.sum()
                if isinstance(task_logits, torch.Tensor):
                    loss = loss + task_logits.sum()
                if isinstance(exist_logits, torch.Tensor):
                    loss = loss + exist_logits.sum()
                if aux_outputs is not None:
                    for aux in aux_outputs:
                        loss = loss + aux["pred_logits"].sum() + aux["pred_boxes"].sum()
                if enc_outputs is not None:
                    loss = loss + enc_outputs["pred_logits"].sum() + enc_outputs["pred_boxes"].sum()
            loss.backward()
            
            if not torch.isfinite(loss):
                print(f"[auto_batch] Non-finite loss at B={batch_size}, stepping down.")
                model.zero_grad(set_to_none=True)
                break
                
            nn.utils.clip_grad_norm_(model.parameters(), max_norm=cfg.training.max_grad_norm)
            model.zero_grad(set_to_none=True)
            
            peak = torch.cuda.max_memory_allocated()
            torch.cuda.reset_peak_memory_stats()
            ratio = peak / total
            print(f"[auto_batch] B={batch_size}  peak={peak//1024**2}MB/{total//1024**2}MB  ({ratio:.1%})")
            
            if ratio >= 0.98:
                print(f"[auto_batch] Ratio too high at B={batch_size}, stepping down.")
                break
                
            best_bs = batch_size
            best_accum = grad_accum
            
            if batch_size == max_requested:
                break
                
            # Step up safely
            if batch_size >= 10:
                batch_size += 4
            else:
                batch_size += 1
            if batch_size > max_requested:
                batch_size = max_requested
            grad_accum = int(math.ceil(target_eff_batch / batch_size))
            
            # Explicitly garbage collect dataloaders to free /dev/shm
            del train_loader, val_loader, probe_iter
            import gc; gc.collect()
            
        except (torch.cuda.OutOfMemoryError, RuntimeError) as e:
            if isinstance(e, torch.cuda.OutOfMemoryError) or "out of memory" in str(e).lower():
                torch.cuda.empty_cache()
                print(f"[auto_batch] OOM at B={batch_size}, falling back to B={best_bs}.")
                break
            else:
                raise

    if best_bs == 1 and batch_size == 1:
        raise RuntimeError("Cannot fit batch_size=1 even with grad_accum=1.")
        
    print(f"[auto_batch] → Settled on B={best_bs}, grad_accum={best_accum}")
    train_loader, val_loader = _recreate(best_bs, workers=cfg.data.num_workers)
    return best_bs, best_accum, train_loader

def run_training(cfg: GatEVConfig, fresh: bool = False) -> None:
    """Full training pipeline: build model → stage1 → stage2 → save."""
    import torch
    torch.set_float32_matmul_precision('high')
    set_seed(cfg.experiment.seed)
    device = get_device()
    print(f"\n[train] Device: {device}")

    # Build model
    model = build_model(cfg)

    # Load pretrained weights (RepVGG backbone has its own ImageNet weights via timm)
    model.load_pretrained_partial(cfg.precomputed.pretrained_checkpoint)

    # Semantic seeding
    apply_semantic_seeding(
        model.fgtq_gate,
        precomputed_path=cfg.precomputed.clip_embeddings,
        dim=cfg.model.task_embed_dim,
    )

    model.to(device)

    # Create EMA teacher for self-KD
    if getattr(cfg.model, "use_kd", False):
        raw_model = getattr(model, "module", model)
        raw_model.create_teacher(device)

    # Data loaders created lazily inside _ensure_batch_fits after autotune
    dummy_loader, _ = get_dataloaders(
        cfg.data.dataset_dir, cfg.data.images_dir,
        batch_size=cfg.training.batch_size,
        num_workers=cfg.data.num_workers,
        img_size=cfg.training.img_size,
        pin_memory=cfg.data.pin_memory,
        aug_config=cfg.data.augmentations,
        cache_images=cfg.data.cache_images,
        max_samples_debug=cfg.data.max_samples_debug,
    )

    # Auto-tune batch size to fit GPU VRAM
    auto_bs, auto_accum, train_loader = _ensure_batch_fits(model, dummy_loader, cfg, device)
    if auto_bs != cfg.training.batch_size or auto_accum != cfg.training.grad_accum_steps:
        old_bs = cfg.training.batch_size
        old_accum = cfg.training.grad_accum_steps
        cfg.training.batch_size = auto_bs
        cfg.training.grad_accum_steps = auto_accum
        print(f"[train] Batch auto-tuned: {old_bs}×{old_accum} → {auto_bs}×{auto_accum} (eff. {auto_bs * auto_accum})")

    # Logger + checkpoint manager
    run_dir = Path(cfg.experiment.output_dir) / cfg.experiment.name
    logger = Logger(run_dir / "logs", cfg.experiment.log_interval)
    ckpt_mgr = CheckpointManager(run_dir / "checkpoints", cfg.experiment.checkpoint_save_top_k)

    # EMA (must be created BEFORE torch.compile, since compile creates non-leaf
    # tensors that break copy.deepcopy in ModelEMA.__init__)
    ema = ModelEMA(model, cfg.training.ema_decay) if cfg.training.use_ema else None

    # Optionally compile
    if cfg.training.use_compile:
        try:
            model = torch.compile(model, mode="default")
            print("[train] torch.compile() enabled (mode=default)")
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
        max_samples_debug=cfg.data.max_samples_debug,
    )
    print(f"[train] Train: {len(train_loader.dataset):,} samples, {len(train_loader)} batches")
    print(f"[train] Val:   {len(val_loader.dataset):,} samples")

    # Stage 1 may use larger batch + smaller images (frozen backbone = less memory)
    s1_bs = cfg.training.stage1.batch_size or cfg.training.batch_size
    s1_imgsz = cfg.training.stage1.img_size or cfg.training.img_size
    if s1_bs != cfg.training.batch_size or s1_imgsz != cfg.training.img_size:
        s1_img_dir = cfg.data.images_dir.replace("_800", f"_{s1_imgsz}")
        if not Path(s1_img_dir).exists():
            print(f"[train] WARNING: {s1_img_dir} not found; using {cfg.data.images_dir}")
            s1_img_dir = cfg.data.images_dir
        stage1_train_loader, _ = get_dataloaders(
            cfg.data.dataset_dir, s1_img_dir,
            batch_size=s1_bs,
            num_workers=cfg.data.num_workers,
            img_size=s1_imgsz,
            pin_memory=cfg.data.pin_memory,
            aug_config=cfg.data.augmentations,
            cache_images=cfg.data.cache_images,
            max_samples_debug=cfg.data.max_samples_debug,
        )
        print(f"[train] Stage 1: B={s1_bs}, img_size={s1_imgsz}, images_dir={s1_img_dir}, "
              f"{len(stage1_train_loader)} batches/epoch")
    else:
        stage1_train_loader = train_loader

    # Resume Logic
    latest_ckpt = run_dir / "checkpoints" / "latest.pth"
    resume_stage = 1
    resume_epoch = 0
    resume_state = None

    if fresh:
        print("\n[train] Fresh run requested; skipping checkpoint resume")
    elif latest_ckpt.exists():
        print(f"\n[train] Found existing checkpoint {latest_ckpt}")
        try:
            resume_state = torch.load(latest_ckpt, map_location="cpu", weights_only=False)
            model.load_state_dict(resume_state["model"])
            if ema and "ema" in resume_state:
                ema.load_state_dict(resume_state["ema"])
            
            # Sync the teacher weights if KD is used
            if getattr(cfg.model, "use_kd", False):
                raw_model = getattr(model, "module", model)
                raw_model.sync_teacher()

            resume_stage = resume_state.get("stage", 1)
            resume_epoch = resume_state.get("epoch", 0)
            print(f"[train] Resumed from Stage {resume_stage}, Epoch {resume_epoch}")
            
            if "swa_state" in resume_state and resume_state["swa_state"] is not None:
                train_stage.swa_state = {
                    k.replace("_orig_mod.", ""): v.to(device)
                    for k, v in resume_state["swa_state"].items()
                }
                train_stage.swa_count = resume_state.get("swa_count", 1)
                print(f"[train] Restored SWA state ({train_stage.swa_count} snapshots)")
            
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
            model, stage1_train_loader, val_loader.dataset, device, cfg,
            stage=1, logger=logger, ckpt_mgr=ckpt_mgr, ema=ema,
            start_epoch=resume_epoch, resume_state=resume_state,
        )
        print(f"\n[train] Stage 1 best mAP@0.5 = {s1_map:.4f}")

        best_path = ckpt_mgr.save_dir / "best.pth"
        if best_path.exists():
            state = torch.load(best_path, map_location="cpu", weights_only=False)
            model.load_state_dict(state["model"], strict=True)
            loaded_epoch = state.get("epoch", "?")
            loaded_metric = state.get("metric", float("nan"))
            print(f"[train] Reloaded Stage 1 peak checkpoint before Stage 2: "
                  f"epoch={loaded_epoch}, mAP={loaded_metric:.4f} "
                  f"(vs Stage 1 final-epoch mAP={s1_map:.4f})")
        else:
            print("[train] WARNING: no best.pth found, "
                  "continuing with Stage 1 final-epoch weights.")

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
    else:
        eval_model = ema.ema if ema else model
    eval_model.to(device)

    final_map, per_task = compute_map50(eval_model, val_loader.dataset, device)
    print(f"[train] Best checkpoint mAP@0.5 = {final_map:.4f}")

    # SWA evaluation (if available, takes precedence)
    swa_state = getattr(train_stage, "swa_state", None)
    if swa_state:
        swa_model = build_model(cfg).to(device)
        swa_model.load_state_dict(swa_state)
        swa_map, swa_per_task = compute_map50(swa_model, val_loader.dataset, device)
        print(f"[train] SWA mAP@0.5 = {swa_map:.4f}")
        if swa_map > final_map:
            print(f"[train] SWA improves ({swa_map:.4f} > {final_map:.4f})")
            eval_model = swa_model
            final_map = swa_map
            per_task = swa_per_task
            eval_model.to(device)

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
            "backbone": cfg.model.backbone,
        },
    }, save_path)
    print(f"\n[train] Final weights saved → {save_path}")
    logger.close()
