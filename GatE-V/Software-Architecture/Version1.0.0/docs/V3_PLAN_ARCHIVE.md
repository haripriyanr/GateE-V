# Execution Plan: FPGA-Optimized GatE-V (v3.1)

## Architecture Overhaul Rationale
The v3 pipeline failed because the combination of a weak backbone (RepVGG-B0), multiplicative scaling (FiLM), and noisy score injection (`graph_fusion`) destroyed gradient flow during training.

[UPDATE 2026-06-28] v3 keeps **PResNet-50vd** as backbone (same as v2), not HGNetV2-B1. The HGNetV2-B1 experiment was archived. Config: `configs/vega_base.yaml` uses `backbone: r50vd`.

## Implemented Changes
1. **Decoder Stabilization (`src/model/decoder.py`)**:
   - Remove FiLM (`task_mod`) from `RTDETRDecoderLayer`.
   - Revert to the proven, stable **additive task bias** from v2 (`target = target + task_bias`).

2. **Detector Streamlining (`src/model/detector.py`)**:
   - Strip all references to `GGNReasoner` and `graph_fusion` (which was overwriting logits).
   - Replace the backbone initialization with `timm.create_model('hgnetv2_b1', pretrained=True, features_only=True, out_indices=(1, 2, 3))`.
   - Update FGTQGate `channel_map` to `[256, 512, 1024]` matching HGNetV2-B1's P3, P4, and P5 stages.
   - Update `HybridEncoder` in_channels to match `[256, 512, 1024]`.

3. **Codebase Cleanup**:
   - Delete `src/model/graph_head.py` after all imports are removed.
   - Delete `src/model/backbone_repvgg.py` after all imports are removed.
   - Update configuration in `configs/vega_base.yaml` to ensure backbone channels and lr config are clean.

4. **Training Runtime**:
   - Use CUDA AMP with BF16 on supported RTX 40-series GPUs.
   - Keep GradScaler only for FP16 fallback.
   - Add `scripts/train.py --fresh` to start v3 from epoch 0 without loading incompatible old checkpoints.
   - Keep validation/checkpointing every epoch through the existing checkpoint manager.

---

## GPU + Batch Size + Compilation Strategy

### 1. Best GPU for Smoke Test vs Full Run

| Stage | GPU Choice | Why |
|-------|-----------|-----|
| **Smoke test (1-5 epochs)** | **RTX 4060 Laptop** or **Lightning L4** | Fastest feedback loop. Data is already local, no cloud setup overhead. |
| **Quick smoke on cloud** | **Lightning L4 (24GB)** | If RTX 4060 bugs out, L4 is cheapest GPU on Lightning that definitely works with `--no-compile`. A10G is overkill for 1-5 epochs. |
| **Full training (30+90 epochs)** | **Lightning L4 or T4** | L4 is ~25% cheaper/hr than A10G, handles B=16/32 fine. Reserve A10G only if you need B=64 to hit effective 128 with lower accum. |

*Recommendation:* **Start smoke test on RTX 4060**. If the SM-assertion / CUDA graph crash recurs, switch immediately to a Lightning **L4** instance with `--no-compile --batch-size 16`.

### 2. Auto-Batch Tuner Status & Per-GPU Limits

**Current code:** `_ensure_batch_fits()` **runs by default** in `run_training()` (line 374). It probes from config `batch_size` upward, doubling until >85% VRAM or OOM, then falls back. No config flag needed.

**Recommended action:** Either a) enable `auto_tune_batch` in YAML, or b) manually set batch sizes per GPU below.

| GPU | VRAM | Max Batch (no compile) | Max Batch (compile) | Recommended Config |
|-----|------|------------------------|---------------------|-------------------|
| RTX 4060 Mobile | 8 GB | **B=8** | **B=4** (unstable) | **B=8, accum=16 → eff. 128** |
| Lightning T4 | 16 GB | **B=16** | **B=16** | **B=16, accum=8 → eff. 128** |
| Lightning L4 | 24 GB | **B=32** | **B=32** | **B=16, accum=8 → eff. 128** (safe) or **B=32, accum=4** |
| Lightning A10G | 24 GB | **B=32** | **B=32** | **B=32, accum=4 → eff. 128** |

*Memory model used:* Probe allocates ~2× model memory + activation overhead for 640px. RTX 4060 peaks around 6.8 GiB at B=8 without compile.

### 3. Compile + AMP Strategy

| Mode | `--no-compile` | `--use-compile` | Notes |
|------|----------------|-----------------|-------|
| **Smoke test** | **YES** | No | Removes SM-assertion variable entirely. Smoke test is about speed-of-feedback, not throughput. |
| **Smoke test (alt)** | Optional | Only if `CUDA_LAUNCH_BLOCKING=1` + `mode='default'` | Not worth debugging for 1-5 epochs. |
| **Full run (RTX 4060)** | **YES** | No | 8GB is too tight. `--no-compile` saves ~1.5GB. |
| **Full run (Cloud GPU)** | **Optional** | **Recommended** (`mode='default'`) | L4 / A10G compile is stable and gives ~15-20% speedup on the decoder loop. |

*AMP is always enabled (`amp: true` in config) and uses BF16 on RTX 40-series / L4 / A10G. GradScaler only activates as FP16 fallback on T4 where BF16 is missing hardware support.*

### 4. Minimal Epochs to Confirm Learning

| Phase | Epochs |validation mAP target | What to check |
|-------|--------|----------------------|---------------|
| **Smoke test** | **Stage 1: 1-3 epochs** | `> 0.01` (above noise) | Loss should drop from ~5.x to ~2.x. Class loss and GIoU loss must both decrease. |
| **Confidence check** | **Stage 1: 5 epochs** | `> 0.05` | Per-task mAP should show spread (some tasks >0.02, not all zeros). |
| **Go / no-go** | **Stage 1: 10 epochs** | `> 0.10` | If mAP is flat or oscillating, review data pipeline / labels / loss weights before burning GPU time on Stage 2. |

### 5. Key Metrics to Monitor

```
# Watch these during smoke test (printed every 50 steps + end-of-epoch)
Stage 1 [1/30]  avg_loss=2.34  lr=1.00e-04  time=420s
[val] mAP@0.5 = 0.0031   ← must be > 0.001 after epoch 3
Per-task AP: Task 01: 0.0002, Task 02: 0.0051 ... (some positive, not all zero)
```

| Metric | Green Flag | Red Flag |
|--------|-----------|----------|
| `avg_loss` epoch-over-epoch | Drops from ~5.0 → ~2.0 in first 3 epochs | Flat or increasing >5% |
| `cls` loss | Decays steadily | Spikes or stuck >2.0 |
| `giou` loss | <1.5 after 3 epochs | >3.0 after 5 epochs |
| Per-task AP | At least 5/14 tasks >0.0 | All tasks == 0.0000 (broken matcher / labels) |
| GPU memory | ~6.0-7.5GB on RTX 4060 | **OOM or >7.8GB** → reduce batch immediately |
| GPU utilization (nvidia-smi) | >80% during forward | <30% → check DataLoader worker bottleneck |

### Recommended Run Commands

```bash
# ----- RTX 4060 Smoke Test (1-3 epochs) ----- #
./run.sh --fresh --no-compile --batch-size 8 --workers 2

# ----- Lightning L4 Smoke Test (1-5 epochs) ----- #
./run.sh --cloud --fresh --no-compile --batch-size 16 --workers 4

# ----- Lightning L4 / A10G Full Run (120 epochs) ----- #
./run.sh --cloud --fresh --batch-size 16 --workers 4  # compile enabled by default on cloud YAML

# Override if you want compile on cloud (config default should flip use_compile=true)
./run.sh --cloud --fresh --batch-size 16 --workers 4 --override training.use_compile=true
```

### Summary Checklist Before Full 30+90 Epoch Run
- [ ] Smoke test (3 epochs) on RTX 4060 or L4 completes without OOM or NaN.
- [ ] Loss curves show monotonic decrease (first 3 epochs).
- [ ] Validation mAP after epoch 3 is above noise (`>0.003`).
- [ ] At least some per-task AP values are non-zero (indicates matcher + labels are correct).
- [ ] If any above fails, debug data/matcher/loss before committing to long GPU run.
