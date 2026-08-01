# GatE-V — Project Agent Guide

**DVCon India 2026 Design Contest — Team 166 (Byte Silicon)**  
**Task-aware object detection deployed on VEGA RISC-V + Kintex-7 FPGA**

---

## 1. Project Overview

### The Problem
Conventional object detectors are task-agnostic — they detect everything in a scene.
The DVCon challenge requires a **task-aware** detector: given a natural language task
(e.g., "Find a tool to cut paper"), detect only relevant objects and ignore the rest.
The solution must run on the **VEGA AS1061 RISC-V processor** on a Xilinx Kintex-7
FPGA (Genesys-2 board) with a custom hardware accelerator.

### The Solution: GatE-V
- **Software** (`Software-Architecture/Version3/`): RT-DETRv2 + ResNet-50vd backbone
  with CLIP-based task conditioning, feature gating (FGTQ), FGPA (P2 injection),
  AFF (adaptive feature fusion), and INT8 quantization for FPGA deployment.
- **Hardware** (`Hardware-Architecture/`): Custom 32x16 weight-stationary systolic
  array (512 MAC cells) at 100 MHz, AXI4 DMA, double buffering, SiLU activation LUT.
  Achieves 51.2 GOPS peak throughput.

### Contest Stages
| Stage | Description | Status |
|-------|-------------|--------|
| Stage 1 | Problem statement + approach report | Submitted |
| Stage 2A | Software-only detection on COCO-Tasks | Submitted (v2) |
| Stage 2B | Custom FPGA accelerator (systolic array) | Submitted |
| Stage 3A | Integrated HW+SW (VEGA CPU + FPGA) | Pending (user will share later) |

---

## 2. Directory Structure

```
GatE-V/
├── AGENTS.md                          ← This file
├── Software-Architecture/
│   ├── Version3/                      ← ACTIVE — latest code (July 2026)
│   │   ├── configs/gatev_base.yaml    ← All hyperparameters
│   │   ├── src/                       ← Python source
│   │   │   ├── model/                 ← Core model (detector, gate, encoder, decoder, losses)
│   │   │   ├── engine/                ← Trainer, evaluator
│   │   │   ├── data/                  ← Dataset, collate, transforms
│   │   │   └── utils/                 ← Config, checkpoint, logger, metrics
│   │   ├── scripts/                   ← Entry points (train, eval, export, bootstrap)
│   │   ├── tests/                     ← Unit tests
│   │   ├── docs/                      ← Architecture docs, V3 plan archive
│   │   ├── run.sh                     ← Linux: setup + data download + training
│   │   ├── run.bat                    ← Windows equivalent
│   │   ├── train_new.log              ← Training log from VM
│   │   └── checkpoints/               ← best.pth, latest.pth (need download from GCP)
│   ├── Version2/                      ← OLD — Stage 2A submission (May 2026), kept for reference
│   └── [pretrained/]                  ← RT-DETRv2 pretrained weights (auto-downloaded by run.sh)
├── Hardware-Architecture/
│   ├── rtl/                           ← SystemVerilog RTL
│   │   ├── gatev_pkg.sv              ← Package: params, address map, SiLU LUT
│   │   ├── gatev_top.sv              ← Top-level accelerator
│   │   ├── gatev_mac_engine.sv       ← Systolic array + MAC cells + requantizer
│   │   ├── gatev_backbone.sv         ← Conv backbone tile scheduler
│   │   ├── gatev_axi_lite_slave.sv   ← CPU config interface
│   │   ├── gatev_axi4_master.sv      ← DDR DMA engine
│   │   ├── gatev_async_fifo.sv       ← Clock domain crossing
│   │   ├── gatev_ddr3_model.sv       ← DDR3 simulation model
│   │   └── tb_gatev.sv              ← Testbench
│   ├── Make/                          ← Vivado/ModelSim build system
│   ├── board_files/                   ← Genesys-2 FPGA board files
│   ├── report/                        ← Stage 2B report PDF
│   ├── AXI_Interface_Details.txt      ← AXI register map docs
│   └── README.md                      ← Build instructions
├── DVCon_India_2026_DC_Stage2_166.zip   ← Stage 2A submission archive
├── DVCon_India_2026_DC_Stage2B_166.zip  ← Stage 2B submission archive
└── [Reference PDFs]                    ← Problem statement, VEGA docs, research paper
```

---

## 3. Software Architecture (Version 3)

### Model: GatEVTaskAwareRTDETR
- **Backbone**: ResNet-50vd (pretrained RT-DETRv2)
- **Encoder**: HybridEncoder (1 transformer layer) with FGPA (P2 injection) + AFF
- **Decoder**: 6-layer RT-DETRv2 decoder with per-layer task bias injection
- **Gate**: MultilevelFGTQGate — CLIP-seeded task conditioning on P3/P4/P5
- **Head**: Classification (14 tasks) + Bounding Box (4 coords) + Exists (binary)
- **Query budget**: 200 object queries

### Training Pipeline (Two-Stage)
| | Stage 1 | Stage 2 |
|---|---------|---------|
| Epochs | 10 | 140 |
| Backbone | Frozen | Unfrozen at epoch 28 |
| Losses | Focal + L1 + GIoU + MAL | + Comparative Ranking + Task Loss |
| Lambda_noobj | 2.0 → 12.0 (ramp 5 ep) | 10.0 → 12.0 (ramp 10 ep) |
| Task loss | Disabled | Warmup 6 epochs |
| LR | Cosine T_max=7 (crashes hard) | Cosine T_max=135 (slow decay) |

### Key Innovations (v3 vs v2)
1. **FGPA** (Fine-Grained Path Augmentation): P2 (stride-4, 256ch) injected into encoder → +1.5% APs
2. **AFF** (Adaptive Feature Fusion): 3 learnable scalars re-weighting P3/P4/P5 → zero HW cost
3. **Sized L1 Loss**: Area-proportional bounding box regression
4. **MAL** (Matchability-Aware Loss): IoU-weighted positive supervision
5. **Discrete Grid Sampling**: FPGA-aligned cross-attention (grid points, not continuous coords)

### Known Training Issues
- Stage 1 overfits after epoch 5 (LR crashes 17x with T_max=7)
- Stage 2 mAP plateaued ~0.5076 at epoch 72/140 (may need LR tuning or longer training)
- Backbone re-freeze bug was fixed (re-freeze at epoch 1, unfreeze at epoch >= 28)
- `set_best_metric` was dead code, now wired in with max() guard

### Running Training
```bash
cd Software-Architecture/Version3
./run.sh                    # Full setup + train (interactive menu if no args)
./run.sh --data-only        # Download data only, skip training
./run.sh --train-only       # Skip data prep, just train
./run.sh --fresh            # Delete old checkpoints, start fresh
./run.sh --debug            # Smoke test: 100 images, 2 epochs
./run.sh --no-compile       # Disable torch.compile (if OOM)
./run.sh --clean-venv       # Recreate .venv (use when switching CPU↔GPU)
```

### Export (for FPGA deployment)
```bash
python scripts/export.py --checkpoint runs/gatev_base/checkpoints/best.pth \
    --output-dir exported/ --quantize int8
```

---

## 4. Hardware Architecture

### Systolic Array Design
- **Size**: 32 rows x 16 columns = 512 MAC cells
- **Data type**: INT8 weights, INT8 activations, INT32 partial sums
- **Clock**: 100 MHz
- **Peak throughput**: 51.2 GOPS
- **DSP usage**: 290 DSPs (34.5% of Kintex-7 budget)
- **LUT usage**: 1.88%

### Key Features
- **Weight-stationary**: Weights loaded once, activations stream through
- **Double buffering**: Ping-pong banks for weights and activations (hide DDR latency)
- **AXI4 Full DMA**: 64-bit burst transactions to DDR3 (1GB)
- **AXI4-Lite slave**: CPU config registers (start, task_id, memory addresses, tile count)
- **SiLU activation**: 256-entry INT8 lookup table (single-cycle)
- **Layer descriptor ROM**: 6-layer convolution config (8x8x8, 1x1 conv, SiLU)

### Register Map (AXI4-Lite)
| Addr | Name | Description |
|------|------|-------------|
| 0x00 | CTRL | Start bit |
| 0x04 | STATUS | Done bit |
| 0x08 | TASK_ID | Current task |
| 0x10 | IMG_BASE_ADDR | Image DDR address |
| 0x14 | WT_BASE_ADDR | Weight DDR address |
| 0x18 | OUT_BASE_ADDR | Output DDR address |
| 0x1C | TILES_NUM | Number of tiles |
| 0x20-0x2C | DMA_* | DMA source/dest/length/control |
| 0x40-0x54 | PERF_* | Performance counters |

### Running Simulation
```bash
cd Hardware-Architecture/Make
make sim                    # Vivado behavioral sim (default 4 tiles)
make sim NUM_TILES=8        # Custom tile count
make sim-gui                # Vivado GUI with waveforms
make questa                 # ModelSim/Questa batch
make questa-gui             # ModelSim GUI
make bd                     # Generate block design only
make clean                  # Remove build artifacts
```

---

## 5. GCP VM Infrastructure

### Current State
- **Project**: `ai-ml-499411` (AI ML, billing: INR)
- **Account**: konradjr007@gmail.com
- **Disk**: `gatetv-train` (100GB pd-balanced, us-central1-a) — contains checkpoints + data
- **VM**: Deleted (was preemptible g2-standard-8, terminated)
- **Scheduler**: Deleted (vm-watchdog was a Cloud Scheduler every 5 min)

### Recovery Workflow (to download checkpoints tomorrow)
```bash
# 1. Create cheap e2-micro spot VM
gcloud compute instances create recovery-vm \
    --zone=us-central1-a --machine-type=e2-micro \
    --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud \
    --boot-disk-size=10GB --provisioning-model=SPOT

# 2. Delete old VM reference (disk is already detached)
gcloud compute instances delete gatetv-train --zone=us-central1-a --quiet

# 3. Attach the data disk
gcloud compute instances attach-disk recovery-vm --disk=gatetv-train --zone=us-central1-a

# 4. SSH + mount
gcloud compute ssh recovery-vm --zone=us-central1-a
sudo mkdir -p /mnt/old_disk
sudo mount /dev/sdb1 /mnt/old_disk

# 5. Copy only what's needed (exclude data/images/venv/pretrained)
# Checkpoints: /mnt/old_disk/home/haripriyanr/runs/gatev_base/checkpoints/
# Source: /mnt/old_disk/home/haripriyanr/src/

# 6. Download to local via SCP
gcloud compute scp recovery-vm:/path/to/file ./local/path --zone=us-central1-a

# 7. Delete recovery VM when done
gcloud compute instances delete recovery-vm --zone=us-central1-a --quiet
```

### Training on New Preemptible VM
1. Create CPU VM → `scp` source → `./run.sh --data-only` (download COCO ~19GB)
2. Stop VM → Edit to attach NVIDIA L4 GPU → Start
3. `./run.sh --clean-venv` → installs GPU torch + starts training
4. Training auto-resumes from `runs/gatev_base/checkpoints/latest.pth`

---

## 6. Key Conventions

- **Python**: 3.12+, package manager: `uv` (creates `.venv/`)
- **Imports**: Project-root-relative (`src.model.detector`, `src.utils.config`)
- **Config**: YAML → `GatEVConfig` dataclass (validated on load)
- **Losses**: GIoU computed in **fp32** (outside AMP) to prevent NaN
- **EMA**: Decay 0.9999, gradient clip norm 0.1
- **Checkpoints**: `latest.pth` (resume), `best.pth` (best mAP, max-guarded)
- **No git repo** in the software source directory
- **Saved model keys** may have `_orig_mod.` prefix from `torch.compile` — strip on load
- **FPGA**: Strict INT8 math, SiLU via LUT, 100 MHz clock, AXI4 interfaces

---

## 7. File Inventory

### Must Keep (Recovery Needed)
| File | Size | Location | Status |
|------|------|----------|--------|
| best.pth | 603 MB | GCP disk | **Not downloaded** |
| latest.pth | 603 MB | GCP disk | **Not downloaded** |

### Already Recovered
| File | Location |
|------|----------|
| V3 source code | `Software-Architecture/Version3/src/` |
| V3 config | `Software-Architecture/Version3/configs/gatev_base.yaml` |
| V3 run scripts | `Software-Architecture/Version3/run.sh`, `run.bat` |
| V3 train log | `Software-Architecture/Version3/train_new.log` |
| V3 docs | `Software-Architecture/Version3/docs/` |
| HW V2 RTL & Build | `Hardware-Architecture/Version2/` |
| HW V3 RTL & Build | `Hardware-Architecture/Version3/` |

### Reference (Kept As-Is)
| File | Purpose |
|------|---------|
| `1904.03000v1.pdf` | Original research paper (Task-Driven Object Detection) |
| `DS-VEGA_AS1061 V1.0.pdf` | VEGA RISC-V processor documentation |
| `DVCon India 2026 Design Contest - Problem Statement.pdf` | Official problem statement |
| `genesys2_rm.pdf` | Genesys-2 FPGA board reference manual |
| `DVCon_India_2026_DC_Stage1_Sub_166.pdf` | Stage 1 submission |
| `DVCon_India_2026_DC_Stage2_166.zip` | Stage 2A submission archive |
| `DVCon_India_2026_DC_Stage2B_166.zip` | Stage 2B submission archive |
| `Software-Architecture/Version2/` | Old v2 source (kept for diffing) |

---

## 8. Future Optimization & Retraining Plan (Target: ~54%+ mAP)

*Saved for future training runs when GPU time is available:*

1. **Learning Rate Scheduler Adjustments**:
   - Switch Stage 2 scheduler from plain cosine to `cosine_warm_restarts` ($T_0=35$) or 3-step decay at epochs 60, 90, 110.
   - Increase `backbone_lr` to $1.0 \times 10^{-5}$ upon backbone unfreezing at epoch 28 (prevents LR starvation & plateau around epoch 72).
2. **CLIP Prompt Ensembling**:
   - In `src/model/gate.py`, average CLIP task text embeddings over prompt templates (`"a photo of a {task_target}"`, `"a clear image showing {task_name}"`, etc.) for richer task seeding at zero FPGA runtime cost.
3. **Task-Aware Data Augmentations**:
   - Enable low-probability spatial scale jittering ($0.8\times – 1.2\times$) and task-safe Mosaic (0.15–0.20) in Stage 2 to improve scale-invariant query priors.
4. **Varifocal Loss (VFL)**:
   - Replace standard Focal Loss with Varifocal Loss on the classification head to weight confidence by target IoU overlap, directly boosting mAP@0.5.

