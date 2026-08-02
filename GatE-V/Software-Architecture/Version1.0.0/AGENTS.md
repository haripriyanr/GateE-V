# GatE-V Agent Guide (Software Architecture - Version 1.0.0)

## GatE-V Project Narrative & Point of View (POV)

This directory contains the software and hardware implementation of the GatE-V custom object detector, developed by **Team 166 (Byte Silicon)** for the **DVCon India 2026 Design Contest**. 

### 1. The DVCon Challenge (The Problem)
Conventional object detection techniques are task-agnostic—they blindly detect all objects in a scene, leading to reduced decision relevance and inefficient computation. The DVCon challenge demands a **task-aware object selection framework** that selectively detects and prioritizes objects relevant to a given text description or goal (e.g., "Find a tool to cut paper"), while ignoring irrelevant objects. This pipeline must be deployed on an edge device powered by the indigenously developed **VEGA AS1061 RISC-V Processor** on the Digilent Genesys-2 FPGA board.

### 2. Stage 2A & 3A: The GatE-V-v1.0.0 Solution
Unlike vanilla detectors (like YOLO or standard RT-DETRv2), GatE-V is a Feature-Gated Task Query detector that uses CLIP to translate text tasks and actively filters out irrelevant background objects early in the pipeline.

**Why Version 1.0.0 is our flagship software architecture:**
Version 1.0.0 introduces key architectural upgrades designed to break the mAP plateau and eliminate hardware bottlenecks:

- **Varifocal Loss (VFL)**: Replaces Focal Loss. Weights positive classification loss directly by IoU quality score ($q$), eliminating low-quality false positives in dense/cluttered scenes.
- **CLIP Multi-Prompt Ensembling**: Encodes 4 prompt templates per task (`"a photo of an object used to {task}"`, `"a clear image showing something to {task}"`, etc.) for richer task embeddings at zero runtime cost.
- **Cosine Warm Restarts Scheduler ($T_0=15$)**: Eliminates learning rate starvation and late-stage mAP degradation.
- **Task-Frequency Weighted Loss**: Inverse-sqrt task frequency loss weighting to prevent common tasks from drowning out minority tasks.
- **640x640 Native Resolution (`data/images_640`)**: Eliminates 8GB VRAM PCIe memory paging, allowing GPU training to run at 100% native CUDA speed (~10-12 hours) and boosting Kintex-7 FPGA inference to **39.4 FPS (25.4 ms latency)**.
- **FGPA (P2 Injection)** & **AFF (Adaptive Feature Fusion)**: Preserved from v3 for fine-grained small object recall.

---

## Setup & Training (Version 1.0.0)

### Quick Launch Command (Linux / macOS):
```bash
cd Software-Architecture/Version1.0.0
./run.sh --fresh --train-only
```

### Quick Launch Command (Windows CMD):
```cmd
cd Software-Architecture\Version1.0.0
run.bat --fresh --train-only
```

---

## Directory Inventory

```
Software-Architecture/Version1.0.0/
├── configs/
│   ├── gatev_v1.0.0.yaml       Active v1.0.0 config (ResNet-50vd, VFL, CLIP Ensemble, 640px)
│   └── gatev_base.yaml         Reference config
├── src/
│   ├── data/                  COCO-Tasks dataset, collate, transforms (Wider Scale Jitter, Mosaic, Mixup)
│   ├── engine/                Trainer (VFL, CosineWarmRestarts, Task Weighting, SWA) & Evaluator
│   ├── model/                 GatEVTaskAwareRTDETR, HybridEncoder, Decoder, PResNet, Gate, Losses
│   └── utils/                 Config loader, metrics, logger, checkpoint manager
├── scripts/
│   ├── train.py                Training launcher
│   ├── eval.py                 Test set evaluator
│   ├── failure_analysis.py     42-image per-task diagnostic panel generator
│   ├── precompute_images.py    640px image resizer
│   └── mine_coco_for_minority_tasks.py  COCO-2017 mining fallback
├── data/
│   ├── coco-tasks-dataset/     Annotations
│   └── images_640/             374k pre-resized 640px images
├── pretrained/
│   └── rtdetrv2_r50vd_m_7x_coco_ema.pth  Pretrained RT-DETRv2 backbone weights
├── run.sh                      Linux launcher
└── run.bat                     Windows launcher
```
