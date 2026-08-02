# GatE-V-v1.0.0 — Software Architecture

**Task-Conditioned Multi-Task Object Detector**  
**Target**: FPGA Deployment (Kintex-7 xc7k325t) via INT8 Quantization  
**Framework**: PyTorch 2.5+, Python 3.12+  
**Backend**: RT-DETRv2 + ResNet-50vd @ 640x640 Resolution  

---

## Overview & GatE-V-v1.0.0 Innovations

The GatE-V-v1.0.0 software implements an optimized **feature-gated, task-conditioned** RT-DETRv2 detector supporting 14 natural language manipulation tasks.

Key architectural innovations in v1.0.0:

- **Varifocal Loss (VFL)**: Replaces standard Focal Loss. Scales positive classification loss directly by IoU quality score ($q$), eliminating low-quality false positives in dense/cluttered scenes.
- **CLIP Multi-Prompt Ensembling**: Averages 4 prompt templates per task (`"a photo of an object used to {task}"`, `"a clear image showing something to {task}"`, etc.) for richer semantic task embeddings at zero runtime cost.
- **Cosine Warm Restarts Scheduler**: Progressive LR restart cycles ($T_0=35, T_{mult}=2$) for 300-epoch deep convergence.
- **Task-Frequency Weighted Loss**: Inverse-sqrt task sample frequency weighting to boost accuracy on rare minority tasks.
- **Dataset Expansion**: COCO 2014 mining with AI-verified quality control targeting ≥350 images per task.
- **640x640 Native Resolution (`data/images_640`)**: $56\%$ fewer pixels than 800x800, eliminating PCIe VRAM paging on 8GB GPUs and boosting Kintex-7 FPGA inference speed to **39.4 FPS (25.4 ms latency)**.
- **FGPA** (Fine-Grained Path Augmentation): Injects P2 feature level from backbone into encoder for fine-grained spatial recall.
- **AFF** (Adaptive Feature Fusion): Learnable level re-weighting across P3, P4, P5 — zero hardware cost.
- **Discrete Grid Sampling**: FPGA-aligned cross-attention for seamless systolic array hardware execution.

---

## Directory Structure

```
Software-Architecture/Version1.0.0/
├── configs/                 ← YAML training configs
│   ├── gatev_v1.0.0.yaml       Active v1.0.0 configuration (VFL, CLIP Ensemble, 640px)
│   └── gatev_base.yaml         Base reference configuration
├── src/                     ← Python source code
│   ├── data/                  Dataset, collate, transforms
│   │   ├── dataset.py           COCO-Tasks multi-task dataset (TaskAwareSampler)
│   │   ├── collate.py           Batch collation & data loading
│   │   └── transforms.py        Augmentations (Wider Scale Jitter 0.7-1.3, Mosaic, Mixup)
│   ├── engine/                Training & evaluation
│   │   ├── trainer.py           Two-stage trainer (VFL, CosineWarmRestarts, Task Weighting, SWA)
│   │   └── evaluator.py         mAP@0.5 evaluation
│   ├── model/                 Core model modules
│   │   ├── detector.py          GatEVTaskAwareRTDETR (top-level)
│   │   ├── encoder.py           HybridEncoder (P2-P5 FGPA + AFF)
│   │   ├── decoder.py           RTDETRTransformerv2 x6 with task bias
│   │   ├── backbone.py          PResNet-50vd backbone
│   │   ├── gate.py              MultilevelFGTQGate (CLIP Ensembling)
│   │   ├── losses.py            Varifocal Loss + Sized L1 + GIoU + MAL
│   │   └── matcher.py           Hungarian matcher
│   └── utils/                 Config, metrics, logger, checkpointing
├── scripts/                 ← Runnable entry points
│   ├── train.py                Training launcher
│   ├── eval.py                 Evaluation on test split
│   ├── failure_analysis.py     42-image per-task diagnostic panel generator
│   ├── export.py               ONNX / INT8 export
│   ├── bootstrap.py            Environment setup & data mirror
│   ├── precompute_images.py    640px image resizer
│   └── mine_coco_for_minority_tasks.py  COCO-2017 mining fallback
├── data/                    ← Dataset storage
│   ├── coco-tasks-dataset/     COCO-Tasks annotations
│   └── images_640/             Pre-computed 640px images (374k files)
├── pretrained/              ← Pretrained backbone weights
│   └── rtdetrv2_r50vd_m_7x_coco_ema.pth
├── requirements.txt         ← Python dependencies
├── run.sh                   ← Linux setup & training launcher
├── run.bat                  ← Windows setup & training launcher
└── AGENTS.md                ← Detailed architecture & contest guide
```

---

## Quick Start

### Setup & Training (Linux / macOS)

```bash
cd Software-Architecture/Version1.0.0
./run.sh --fresh --train-only
```

### Setup & Training (Windows CMD)

```cmd
cd Software-Architecture\Version1.0.0
run.bat --fresh --train-only
```

---

## Performance Targets

| Metric | Version 2 | Version 3 | **Version 1.0.0 (Current)** |
| :--- | :---: | :---: | :---: |
| **Backbone** | ResNet-50vd | ResNet-50vd | **ResNet-50vd** |
| **Resolution** | 640x640 | 800x800 | **640x640** |
| **Loss Function** | Focal Loss | Focal Loss | **Varifocal Loss (VFL)** |
| **CLIP Seeding** | Single Text | Single Text | **4-Template Multi-Prompt Ensemble** |
| **Training Epochs** | 150 | 150 | **300 (10+290)** |
| **RTX 4060M Training Time** | ~12 Hours | 7 Days (VRAM paging) | **~24–35 Hours** |
| **mAP@0.5 Accuracy** | 48.50% | 50.76% (53.16% peak) | **55.0% – 60.0% (Target)** |
| **FPGA Latency / FPS** | 35 ms / 28 FPS | 35 ms / 28 FPS | **25.4 ms / 39.4 FPS** |
