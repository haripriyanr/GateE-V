# GatE-V — Software Architecture

**Task-Conditioned Multi-Task Object Detector**  
**Target**: FPGA Deployment (Kintex-7 xc7k325t) via INT8 Quantization  
**Framework**: PyTorch 2.5+, Python 3.12+  
**Backend**: RT-DETRv2 + ResNet-50vd

---

## Overview

The GatE-V software implements a **feature-gated, task-conditioned** RT-DETRv2
detector supporting 14 manipulation tasks (pick, place, pour, open, close, etc.).
Key innovations:

- **FGPA** (Fine-Grained Path Augmentation): Injects P2 feature level from
  backbone into the encoder for improved small-object recall.
- **AFF** (Adaptive Feature Fusion): 3 learnable scalars re-weighting P3, P4, P5
  at the encoder input — zero hardware cost.
- **Sized L1 Loss**: Area-proportional bounding box regression loss.
- **MAL** (Matchability-Aware Loss): IoU-weighted positive supervision.
- **Discrete Grid Sampling**: FPGA-aligned cross-attention (grid points instead
  of continuous coordinates).

The model is designed for INT8 quantization and eventual deployment on the
GatE-V FPGA accelerator (see `Hardware Architecture/`).

---

## Directory Structure

```
Software-Architecture/
├── configs/                 ← YAML training configs
│   └── gatev_base.yaml         Main configuration (all hyperparameters)
├── src/                     ← Python source code
│   ├── data/                  Dataset, collate, transforms
│   │   ├── dataset.py           COCO-Tasks multi-task dataset
│   │   ├── collate.py           Batch collation & data loading
│   │   └── transforms.py        Image augmentations
│   ├── engine/                Training & evaluation
│   │   ├── trainer.py           Two-stage trainer (EMA, SWA, auto-batch)
│   │   └── evaluator.py         mAP evaluation
│   ├── model/                 Core model modules
│   │   ├── detector.py          GatEVTaskAwareRTDETR (top-level)
│   │   ├── encoder.py           HybridEncoder (1 layer)
│   │   ├── decoder.py           RTDETRDecoderLayer x6 with task bias
│   │   ├── backbone.py          ResNet-50vd backbone
│   │   ├── gate.py              MultilevelFGTQGate (P3, P4, P5)
│   │   ├── losses.py            Focal + L1 + GIoU + MAL + Sized L1
│   │   └── matcher.py           Hungarian matcher
│   └── utils/                 Config, device, helpers
├── scripts/                 ← Runnable entry points
│   ├── train.py                Training launcher
│   ├── eval.py                 Evaluation on validation set
│   ├── export.py               ONNX / INT8 export
│   ├── bootstrap.py            Environment setup, data download
│   └── monitor.py              Training progress monitor
├── data/                    ← Dataset storage
│   ├── coco-tasks-dataset/     COCO-Tasks annotations (git submodule)
│   ├── images_800/             Pre-computed 800px images
│   └── models/                 Pretrained weights, checkpoints
├── tests/                   ← Unit tests
│   ├── test_dataset.py
│   ├── test_gate.py
│   └── test_matcher.py
├── docs/                    ← Architecture documentation
│   ├── ARCH_EXPLAINER.md
│   ├── BACKBONE_RESEARCH.md
│   └── V3_PLAN_ARCHIVE.md
├── requirements.txt         ← Python dependencies
├── run.sh                   ← Linux setup + training script
├── run.bat                  ← Windows setup + training script
└── AGENTS.md                ← Detailed agent guide (training internals)
```

---

## Quick Start

### Prerequisites
- **OS**: Linux (Ubuntu 22.04+), Windows, or macOS
- **Python**: 3.12+
- **GPU**: NVIDIA with 8GB+ VRAM (RTX 4060M, L4, A100, etc.)
- **Tools**: `uv` (installer included in run.sh)

### Setup & Training (Linux)

```bash
./run.sh
```

This single command:
1. Installs `uv` (if missing) and creates a virtual environment
2. Installs PyTorch + dependencies
3. Mirrors COCO-Tasks dataset annotations from GitHub
4. Downloads COCO train/val 2017 images (~19 GB)
5. Precomputes 800px resized images
6. Starts training (Stage 1: 40 epochs, Stage 2: 110 epochs)

### Setup & Training (Windows)

```powershell
run.bat
```

### Data Preparation Only

```bash
./run.sh --data-only      # Download images + precompute, skip training
```

### Debug Mode (Fast Smoke Test)

```bash
./run.sh --debug          # 100 images, 2 epochs per stage
```

### Resume Training

The script auto-resumes from `runs/{experiment}/checkpoints/latest.pth`.
To start fresh:

```bash
./run.sh --fresh
```

---

## Training Architecture

### Two-Stage Pipeline

| Stage | Epochs | Backbone | Losses | Task Loss |
|-------|--------|----------|--------|-----------|
| 1 | 40 | Frozen | Focal + L1 + GIoU + MAL | Disabled |
| 2 | 110 | Unfrozen (epoch 22) | + Comparative Ranking + Task Loss | Warmup 6 epochs |

### Key Hyperparameters (`configs/gatev_base.yaml`)

| Parameter | Stage 1 | Stage 2 |
|-----------|---------|---------|
| Batch size | 8 (accum 8 = eff. 64) | Same |
| Learning rate | 1e-4 | 1e-4 |
| Backbone LR | 1e-5 | 1e-5 |
| λ_cls | 2.0 | 2.0 |
| λ_l1 | 5.0 | 5.0 |
| λ_giou | 2.0 | 2.0 |
| λ_noobj | 2.0→5.0 (ramp 10 ep) | 5.0→7.5 (ramp 10 ep) |
| λ_noobj_max | 5.0 | 7.5 |
| λ_comp | 0.0 | 0.05 |
| λ_task | 0.0 | 0.0→1.0 (warmup 6 ep) |
| MAL α | 2.0 | 2.0 |

### GPU Memory Optimizations (8 GB VRAM)
- AMP BF16 (RTX 40-series native)
- `torch.compile` disabled by default (OOM on 8GB; enable with `--compile` on larger GPUs)
- `expandable_segments: True` in CUDA allocator
- TF32 precision for tensor cores
- 8 data loading workers, pin_memory

---

## Scripts Reference

| Script | Purpose |
|--------|---------|
| `scripts/train.py` | Main training entry point |
| `scripts/eval.py` | Evaluate checkpoint on validation set |
| `scripts/export.py` | Export to ONNX / INT8 quantized format |
| `scripts/bootstrap.py` | Environment setup (torch, data mirror, image download) |
| `scripts/monitor.py` | Live training progress dashboard |
| `scripts/precompute_images.py` | Resize COCO images to 800px |
| `scripts/precompute_clip.py` | Precompute CLIP embeddings for tasks |
| `scripts/gui_visualizer.py` | GUI prediction visualizer |

### Training CLI Options

```bash
python scripts/train.py --config configs/gatev_base.yaml [options]

Options:
  --override KEY=VAL        Override config (e.g., training.batch_size=4)
  --fresh                   Delete old checkpoints, start from epoch 0
  --debug                   Fast smoke test (100 images, 2 epochs)
  --compile                 Enable torch.compile (requires GPU with sm_80+)
```

---

## Model Architecture

```
Input Image (800×800×3)
    │
    ▼
ResNet-50vd Backbone
    │
    ├── P3  (100×100×512)  ──┐
    ├── P4  (50×50×1024)   ──┤── AFF (3 learnable scalars)
    ├── P5  (25×25×2048)   ──┘         │
    │                                    ▼
    │                         [FGPA] P2 injection
    │                           (200×200×256)
    │                                    │
    ▼                                    ▼
MultilevelFGTQGate (task-conditioned feature gating)
    │
    ▼
HybridEncoder (1 layer, task-conditioned)
    │
    ▼
Transformer Decoder (6 layers, additive task bias per layer)
    │
    ▼
Task-Specific Prediction Heads (14 tasks)
    │
    ├── Classification head (200 queries × 1 class)
    ├── Bounding box head (200 queries × 4 coords)
    └── Exists head (200 queries × 1 binary)
```

### Key Components

- **FGPA** (`use_fgpa=true`): Injects P2 (stride 4, 256ch) alongside P3/P4/P5
  into the encoder. Improves small-object recall by ~1.5 APₛ.
- **AFF** (`use_aff=true`): 3 learnable scalars (initialized to 1/3 each)
  re-weighting P3/P4/P5 before encoder. Zero hardware changes for inference.
- **MAL** (`mal_alpha=2.0`): Matchability-Aware Loss weights each positive
  query by its IoU with the assigned ground truth — focuses supervision on
  well-matched queries.
- **Sized L1 Loss**: Scales L1 regression loss by ground-truth area —
  larger objects contribute more to box regression.
- **Discrete Grid Sampling** (`cross_attn_method: discrete`): Encoder
  cross-attention uses a fixed grid of sampling points instead of continuous
  coordinates — aligns with FPGA systolic array constraints.

---

## Dataset

**COCO-Tasks**: 14 manipulation tasks derived from COCO 2017:

| Task | Examples | Train Images | Val Images |
|------|----------|:---:|:---:|
| person | detect people | 3,600 | 900 |
| food | detect food items | 3,600 | 900 |
| furniture | chairs, tables, couches | 3,600 | 900 |
| electronics | TVs, laptops, phones | 3,600 | 900 |
| kitchen | utensils, appliances | 3,600 | 900 |
| tool | hand tools | 3,600 | 900 |
| book | books, papers | 3,600 | 900 |
| clothing | clothes, accessories | 3,600 | 900 |
| vehicle | cars, bikes, buses | 3,600 | 900 |
| sports | sports equipment | 3,600 | 900 |
| animal | pets, wildlife | 3,600 | 900 |
| container | boxes, bags, bottles | 3,600 | 900 |
| decoration | decor items | 3,600 | 900 |
| furniture | (extended) | 3,600 | 900 |

**Total**: 50,400 train + 12,600 validation images.

Annotations mirrored from `coco-tasks-dataset` GitHub repo; images from
official COCO 2017 URLs.

---

## Current Status

| Component | Status |
|-----------|--------|
| v2 model (r50vd backbone) | Complete — baseline trained |
| FGPA (P2 injection) | Implemented, in v3 training |
| AFF (Adaptive Feature Fusion) | Implemented, in v3 training |
| Sized L1 Loss | Implemented, in v3 training |
| MAL (Matchability-Aware Loss) | Implemented, in v3 training |
| Discrete grid sampling | Implemented |
| ONNX export | Complete |
| INT8 quantization | Complete (tested) |
| v3 training (L4 GPU) | **In progress** (~2-3 days, 150 epochs) |

### v3 Training

The v3 model is currently training on a preemptible L4 GPU (GCP, asia-east1-a)
with the following improvements over v2:

- FGPA (P2 injection for 4th encoder level) — improves small-object recall
- AFF (3 learnable scalars) — adaptive feature weighting, zero HW cost
- Sized L1 loss — area-proportional box regression
- MAL (Matchability-Aware Loss) — IoU-weighted positive supervision
- 150 total epochs (40 stage 1 + 110 stage 2)
- Effective batch size 64 (B=4, grad_accum=16)
- BF16 AMP + torch.compile enabled (L4 sm_89)

Expected improvements: +1.0–1.5 mAP over v2 baseline.

---

## References

1. Y. Zhao et al., "DETRs Beat YOLOs on Real-time Object Detection," CVPR 2024.
2. Y. Li et al., "RT-DETRv2: Improved Baseline with Bag-of-Freebies," 2024.
3. N. Carion et al., "End-to-End Object Detection with Transformers," ECCV 2020.
4. A. Vaswani et al., "Attention Is All You Need," NeurIPS 2017.
