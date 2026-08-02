# GatE-V: Problem Statement and Hardware/Software Solution
**Context:** DVCon India 2026 Design & Verification Challenge
**Team:** Byte Silicon (Team 166)

## 1. The Problem Statement
The DVCon India 2026 Challenge asks participants to design a **task-aware object selection framework** based on the paper *"What Object Should I Use? - Task Driven Object Detection" (1904.03000)*. 
Conventional object detectors (like YOLO or Faster R-CNN) are task-agnostic; they blindly detect all objects in a scene. The challenge requires a framework that takes a natural language task (e.g., "Find a tool to cut paper") and selectively detects only the objects relevant to that specific task, ignoring the rest.

Furthermore, the solution must be **edge-compatible** and deployed onto the **VEGA Microprocessor (RISC-V)** on a Xilinx Kintex-7 FPGA (Genesys-2 board) using a custom hardware accelerator to speed up inference.

## 2. Our Solution: GatE-V Hardware/Software Co-Design
Our team engineered GatE-V, a custom hardware accelerator integrated with a highly optimized vision-language PyTorch software model.

### A. The Software Architecture (GatE-V v3)
Our software model is a Feature-Gated Task Query detector derived from RT-DETRv2 with an HGNetV2-B1/ResNet50vd backbone. 
- **Task-Conditioning:** We use CLIP to encode the 14 text tasks into a "visual idea."
- **FGTQ (Feature-Gated Task Queries):** The model dynamically filters feature maps based on the task prompt, essentially masking out irrelevant pixels early in the pipeline.
- **Existence Head:** A global classifier that stops the detector from drawing boxes on empty backgrounds, slashing false positives.
- **Why v3 is better than our v2 (Stage 2A) submission:** Our current GatE-V v3 architecture vastly improves upon our Stage 2A baseline by introducing **FGPA (P2 injection for a 4th encoder level)** and **AFF (3 learnable scalars after PAN)**, alongside Sized L1 loss and Matchability-Aware Loss (MAL). These architectural upgrades specifically target and improve small-object recall by 1.0-1.5% APs without requiring structural changes to the hardware accelerator.

### B. The Hardware Architecture (Stage 2B Accelerator)
The VEGA RISC-V CPU lacks a dedicated convolution engine, bottlenecking edge deployment. 
- **The Core Engine:** We designed a custom AXI4-compliant $32\times16$ **weight-stationary systolic array** containing 512 INT8 MAC cells.
- **Double Buffering:** Implements ping-pong banks for weights and activations to hide DDR3 latency via background prefetching.
- **INT8 Quantization:** The software model uses an INT8 SiLU activation lookup table (LUT) and parallel requantizers to perfectly match the mathematics of our systolic array.
- **Performance:** Achieves **51.2 GOPS** peak throughput at 100 MHz on the Kintex-7 FPGA.

## Summary
The combination of a structurally optimized INT8 PyTorch model (Software) and a $32\times16$ systolic array (Hardware) allows GatE-V to perform task-driven object detection at the edge, fully solving the DVCon 2026 problem statement.
