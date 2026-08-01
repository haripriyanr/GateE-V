# GatE-V Agent Guide (Software Architecture)

## GatE-V Project Narrative & Point of View (POV)

This directory contains the software and hardware implementation of the GatE-V custom object detector, developed by **Team 166 (Byte Silicon)** for the **DVCon India 2026 Design Contest**. 

### 1. The DVCon Challenge (The Problem)
Conventional object detection techniques are task-agnostic—they blindly detect all objects in a scene, leading to reduced decision relevance and inefficient computation. The DVCon challenge demands a **task-aware object selection framework** that selectively detects and prioritizes objects relevant to a given text description or goal (e.g., "Find a tool to cut paper"), while ignoring irrelevant objects. This pipeline must be deployed on an edge device powered by the indigenously developed **VEGA AS1061 RISC-V Processor** on the Digilent Genesys-2 FPGA board.

### 2. Stage 2A: The GatE-V Solution (Software Architecture)
Unlike vanilla detectors (like YOLO or standard RT-DETRv2), GatE-V is a Feature-Gated Task Query detector that uses CLIP to translate text tasks and actively filters out irrelevant background objects early in the pipeline.
**Why v3 is our best architecture:**
Our v3 software architecture improves upon the Stage 2A submission by introducing **FGPA (P2 injection for a 4th encoder level)** and **AFF (3 learnable scalars after PAN)**, alongside Sized L1 loss and Matchability-Aware Loss (MAL). These features specifically boost small-object recall by 1.0-1.5% AP without requiring any structural changes to the underlying hardware.

### 3. Stage 2B: The Custom Accelerator (Hardware Architecture)
To achieve real-time performance on the edge, we designed a custom **$32\times16$ weight-stationary systolic array** (512 MAC cells) running at 100 MHz. The Stage 2B hardware features:
- **INT8 Quantization:** Strict INT8 math for both weights and activations.
- **Double Buffering:** Ping-pong storage for weights and activations to hide DDR latency.
- **Spatial Tiling:** Runtime-configurable weight reuse.
- **AXI4 Full DMA:** Burst-capable 64-bit transactions directly with the 1GB DDR3 RAM.
This design achieves **51.2 GOPS peak throughput** while consuming only 34.5% of the Kintex-7 DSP budget (290 DSPs) and 1.88% of LUTs, synthesizing cleanly with zero errors.

### 4. Stage 3A: Integrated Hardware Phase (SoC Integration)
The VEGA AS1061 RISC-V CPU (running at 50 MHz) lacks the compute to process the heavy $1\times1$ convolutions of the RT-DETR backbone. 
In the Stage 3A Integrated Hardware Phase, we solve this by offloading the massive backbone convolutions to the FPGA systolic array via the AXI4 interconnect. The VEGA CPU is then freed up to efficiently execute the lightweight transformer decoder heads and bounding box generation. To further eliminate CPU bottlenecks, the SiLU activation function is implemented purely in hardware as a single-cycle 256-entry lookup table (LUT).

## VM Infrastructure (Interruptible VMs)
The project now uses Preemptible/Interruptible VMs to save costs. The persistent disk and auto-restart edge triggers have been deleted.

### New Deployment Workflow:
1. **Prep (Non-GPU VM)**:
   - Create/Start a cheap CPU-only VM instance.
   - Copy source code: `gcloud compute scp --recurse ~/DVcon/GatE-V/Software-Architecture/* <vm-name>:/home/haripriyanr/Software-Architecture/ --zone=asia-east1-b --tunnel-through-iap`
   - Run `./run.sh --data-only` to download the COCO dataset, mirror annotations, and precompute images.
2. **Switch to GPU**:
   - Stop the non-GPU VM.
   - Edit the VM instance to attach an NVIDIA GPU (e.g., L4) and change the machine type.
   - Start the GPU VM.
3. **Train**:
   - Run `./run.sh --clean-venv` to wipe the CPU environment, reinstall with GPU CUDA support, and start the full training pipeline. (The script uses `uv pip install --upgrade` which automatically syncs the correct Torch version based on `nvidia-smi` detection).

- **VRAM**: ~42% usage (9700/23034 MiB) at B=8
- **Note**: `pkill -f "scripts.train"` triggers SSH disconnection; use with care

## Setup & Run
- Source dir on VM: `/home/haripriyanr/Software-Architecture/`
- Local mirror: `~/DVcon/GatE-V/Software-Architecture/` (sync via gcloud compute scp)
- Run: `./run.sh` (no `--fresh` for resume)
- Fresh restart: delete checkpoints dir manually, then `./run.sh`
- Flags: `--fresh` to delete old checkpoints, `--no-compile` to disable torch.compile
- Training log: `runs/gatev_base/output.log`

## Training: Two-Stage Pipeline (gatev_base)
- **Stage 1** (10 epochs): frozen backbone, heads-only training, lambda_noobj=2.0, cosine LR (T_max=7, crashes from 1e-4 to 5.9e-6). Stage 1 best ~0.2064 mAP (epoch 5), then overfits as LR decays.
- **Stage 2** (140 epochs): heads + backbone, lambda_noobj=10.0 (ramps to 12.0 over 10 epochs), cosine LR (T_max=135, barely decays — LR still 9.37e-05 at epoch 28).
- **Stage 2 reload fix**: At Stage 1→2 boundary, best.pth (Stage 1 peak) is reloaded, not the degraded final-epoch weights.
- **Backbone unfreeze**: At epoch 28 (20% of Stage 2), backbone_lr=3e-6. Uses one-shot guard to prevent re-unfreeze on resume.

## Config (configs/gatev_base.yaml)
- batch_size=8, grad_accum=8 (effective 64), img_size=800
- backbone_lr: 3.0e-6 (line 76)
- Stage 2 lambda_noobj: 10.0, lambda_noobj_ramp_epoch: 10
- task_loss_warmup_epochs: 6
- stage2_frequency: 1 (validate every epoch in Stage 2)

## Checkpoints & Resume
- Dir: `runs/gatev_base/checkpoints/`
- `latest.pth` = most recent save (used for resume on VM restart)
- `best.pth` = best by mAP (max guard prevents overwrite by worse checkpoints)
- `runs/gatev_base_epoch55_collapsed_backup/` backup of collapsed run (epoch 55, mAP=0.02)
- On VM restart: `train_start_stage()` at checkpoint.py line 127 calls `set_best_metric()` with max() guard to prevent best.pth corruption
- Saved model keys may have `_orig_mod.` prefix (from `torch.compile`) — strip on load

## Fixes Applied
1. **batch_size override removed**: `train-startup.sh` no longer passes `--override training.batch_size=4`
2. **set_best_metric wired in**: Was dead code (defined but never called). Now called from `load_latest()`, uses `max()` guard.
3. **Backbone unfreeze bug fixed**: re-freeze at epoch 1 (not `start_epoch+1`), unfreeze at epoch `>= 28` (not `== 28`), one-shot guard prevents re-firing on resume.
4. **Stage 1→2 best checkpoint reload**: Stage 2 now loads `best.pth` (Stage 1 peak) instead of inheriting final-epoch degraded weights.

## Known Issues & Patterns
- Stage 1 consistently overfits: LR crashes 17x (T_max=7) causing heads to overfit after epoch 5 peak
- Stage 2 LR barely moves (T_max=135) — overfitting is not LR-driven, was caused by inheriting Stage 1's degraded weights (now fixed via reload)
- Backbone re-freeze bug caused backbone to stay frozen through entire Stage 2 on VM resume (now fixed)
- Collapsed run (epoch 55, mAP 0.02) had `best.pth` overwritten by collapsed checkpoint due to dead `set_best_metric` (now fixed)

## Prompt Template for AI Agents (Copy-paste to Gemini/Claude/etc.)

```
You are helping debug/improve a multi-task object detector training pipeline.

Source code is on a gcloud VM. To access it:
- SSH: gcloud compute ssh gatetv-train --zone=asia-east1-b --tunnel-through-iap --ssh-flag="-o ServerAliveInterval=10"
- SCP: gcloud compute scp ... gatetv-train:... --zone=asia-east1-b --tunnel-through-iap

Source: /home/haripriyanr/Software-Architecture/
Config: configs/gatev_base.yaml
Train log: runs/gatev_base/output.log
Startup: /usr/local/bin/train-startup.sh
Checkpoints: runs/gatev_base/checkpoints/

Training: 2-stage RT-DETRv2+AFF+FGPA on L4 GPU (23GB), B=8, grad_accum=8.
Stage 1: 10 epochs, frozen backbone, cosine LR T_max=7 (crashes hard)
Stage 2: 140 epochs, cosine LR T_max=135, backbone unfreeze at epoch 28 with lr=3e-6

Fixes already applied:
- Stage 1→2 reloads best.pth instead of degraded final weights
- Backbone unfreeze uses >= not ==, re-freeze at epoch 1 not start_epoch+1
- set_best_metric wired into load_latest with max() guard
- train-startup.sh no longer overrides batch_size

Full context of all previous work is in AGENTS.md at the repo root.
```

## Key Conventions
- Package manager: `pip` (via `.venv/bin/python3 -m pip`)
- All imports use project-root-relative paths (`src.model.detector`, `src.utils.config`)
- YAML config → `GatEVConfig` dataclass (validated on load)
- Losses use **fp32 for GIoU** (`torch.amp.autocast('cuda', enabled=False)`) — prevents NaN
- EMA decay 0.9999, gradient clip norm 0.1
- No git repo in project root
- Config backup at `runs/gatev_base_epoch55_collapsed_backup/`
