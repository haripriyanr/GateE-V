# DVCon India 2026 Design Contest — Stage 3A Submission
**Team ID:** 166 (Byte Silicon)  
**Project Title:** GatE-V — Task-Aware Object Detection on VEGA AS1061 RISC-V + Kintex-7 FPGA  

---

## 1. Executive Summary

This archive contains Team 166's official Stage 3A submission for the DVCon India 2026 Design Contest.
The submission integrates our custom **512-MAC Weight-Stationary Systolic Array Accelerator** (`GatE-V`) into the **C-DAC VEGA AS1061 RISC-V SoC** environment.

### Key Performance Highlights:
- **Matrix Engine:** $32 \times 16$ (512 MAC cells) executing INT8 weight-stationary matrix operations.
- **Integrated SoC Clock:** 50 MHz — the single active clock (`clk_out1_clk_wiz_0` / `sys_clk`, 20 ns period) derived from the 200 MHz board clock; 51.2 GOPS peak (512 MAC cells $\times$ 50 MHz $\times$ 2 ops).
  - *Standalone target/architecture:* the accelerator RTL is clocked at **100 MHz** in the standalone `vmake` build; the integrated SoC design runs at **50 MHz**.
- **Resource Utilization (Kintex-7 xc7k325tffg900-2):**
  - **Whole integrated SoC:** Slice LUTs 88,054 / 203,800 (43.21%), DSP48E1 594 / 840 (70.71%), Slice Registers 56,312 / 407,600 (13.82%).
  - **GatE-V accelerator alone (within the SoC):** Slice LUTs 5,356 (2.63%), DSP48E1 **544 / 840 (64.76%)**, 18,953 Slice Registers, 8 BRAM18.
- **Verification:** Bare-metal RISC-V self-test firmware (`gatev_firmware`) runs on the VEGA AS1061 CPU, programs the accelerator MMIO registers, and checks the accelerator's AXI4 memory read/write result against expected layer values.

---

## 2. Directory Structure

```
DVCon_India_2026_DC_Stage3A_166/
├── Document/
│   ├── DVCon_India_2026_DC_Stage3A_Report_166.pdf  ← Stage 3A IEEE Report
│   ├── simulation_logs_summary.txt                  ← Simulation summary
│   └── figures/                                     ← Figures & waveform PNGs
├── Readme/
│   ├── README.md                                    ← Execution instructions (Markdown)
│   └── Readme.pdf                                   ← Execution instructions (PDF)
└── ENV/
    ├── Application/                 ← Bare-metal C application firmware (gatev_firmware)
    ├── DVCon_SoC_SRC/               ← C-DAC VEGA AS1061 RISC-V SoC + GatE-V IP
    │   ├── ACCELERATOR_IP/          ← GatE-V 512-MAC Systolic Array RTL
    │   ├── TOP/                     ← VEGA AS1061 SoC Top Integration
    │   ├── TB/                      ← Testbench environment
    │   └── MEMORY_IP/               ← Boot ROM models (rom_32KB_axi)
    ├── DVCon_SoC_XDC/               ← Kintex-7 constraint files
    ├── GEN_BIT_OUT/                 ← Boot ROM & bitstream configuration
    ├── RUN/                         ← Automated simulation scripts (run.sh) & rom_32KB_axi.mif
    ├── TCL/                         ← Vivado synthesis scripts (DVCon_SYN.tcl)
    └── VIVADO_PROJECT/              ← Vivado synthesis project directory
```

---

## 3. How to Run Simulation & Verification

To run the automated C-DAC simulation testbench:

```bash
cd RUN
./run.sh
```

Or for GUI simulation in ModelSim/QuestaSim:
```bash
vsim -do simulate.do
```

### Building the Bare-Metal Self-Test Firmware

The `Application/gatev_firmware` directory is a self-contained, reproducible source tree for the
GatE-V accelerator self-test. To build it (requires the bundled `toolchain-bare` and `Util` tools, or any
RISC-V cross toolchain plus the conversion utilities):

```bash
cd Application/gatev_firmware
./build.sh
```

The build re-creates `Application/gatev_firmware/build/gatev_test.hex.mif`, which is installed as the
boot ROM image `rom_32KB_axi.mif` (see Section 5). The ROM copy lives in `RUN/rom_32KB_axi.mif` and is
also regenerated across the Vivado/Questa flow directories under `VIVADO_PROJECT`.

---

## 4. Bare-Metal Self-Test (what the firmware does)

The shipped `gatev_firmware` performs a deterministic, PASS/FAIL accelerator self-test. It does **not**
perform full RT-DETR object detection inference — it exercises the accelerator datapath end-to-end:

1. **SRAM all-ones test inputs:** the CPU fills the SRAM image buffer (base `0x2_0000`) with
   `NUM_TILES × 32` INT8 **all-ones** activations and the SRAM weight buffer (base `0x2_1000`) with
   512 INT8 **all-ones** weights (16 columns × 32 rows).
2. **CPU register programming:** the firmware writes the accelerator MMIO control registers
   (base `0x2004_0000`): `TASK_ID`=0xA5, `MODE`=0x42, `TILES_NUM`=4, image/weight/output base
   addresses, burst type (`INCR`) and burst length (64 beats), then sets the `CTRL` Start bit.
3. **AXI memory read/write:** the accelerator's AXI4 master reads the all-ones SRAM operands and
   writes the convolution result back to the SRAM output buffer (base `0x2_2000`).
4. **Expected layer values:** all six accelerator layers are checked. The SiLU-activated layers are
   expected to produce `93`, and the final identity layer is expected to produce `127`.
5. **Outcome:** the CPU polls the `STATUS` Done bit and prints either
   `===== GATE-V ACCELERATOR TEST PASSED =====` or `FAILED`.

The firmware also prints accelerator performance counters (cycle low, read bytes, write bytes,
MAC cycles, stall cycles) after completion.

---

## 5. Hardware Memory Map (Base Address: `0x2004_0000`)

| Offset | Register Name | Access | Description |
|---|---|---|---|
| `0x00` | `CTRL` | W | Bit 0: Start computation |
| `0x04` | `STATUS` | R | Bit 0: Done flag |
| `0x08` | `TASK_ID` | R/W | Algorithmic Task ID |
| `0x0C` | `MODE` | R/W | Configuration mode |
| `0x10` | `IMG_BASE_ADDR` | R/W | SRAM Base Address for activation image |
| `0x14` | `WT_BASE_ADDR` | R/W | SRAM Base Address for layer weights |
| `0x18` | `OUT_BASE_ADDR` | R/W | SRAM Base Address for convolution output |
| `0x1C` | `TILES_NUM` | R/W | Total convolution tiles to process |
| `0x30` | `BURST_TYPE` | R/W | AXI burst type (INCR) |
| `0x34` | `BURST_LEN` | R/W | AXI burst length (64 beats) |
| `0x40–0x54` | `PERF_*` | R | Performance counters |

---

- **Team ID:** 166 (Byte Silicon)

