# DVCon India 2026 Design Contest — Stage 3A Submission
**Team ID:** 166 (Byte Silicon)  
**Project Title:** GatE-V — Task-Aware Object Detection on VEGA AS1061 RISC-V + Kintex-7 FPGA  

---

## 1. Executive Summary

This archive contains Team 166's official Stage 3A submission for the DVCon India 2026 Design Contest.
The submission integrates our custom **512-MAC Weight-Stationary Systolic Array Accelerator** (`GatE-V`) into the **C-DAC VEGA AS1061 RISC-V SoC** environment.

### Key Performance Highlights:
- **Matrix Engine:** 32 × 16 (512 MAC cells) executing INT8 weight-stationary matrix operations.
- **Integrated SoC Clock:** 50 MHz — the single active clock (`clk_out1_clk_wiz_0` / `sys_clk`, 20 ns period) derived from the 200 MHz board clock; 51.2 GOPS peak (512 MAC cells × 50 MHz × 2 ops).
  - *Standalone target/architecture:* the accelerator RTL is clocked at **100 MHz** in the standalone `vmake` build; the integrated SoC design runs at **50 MHz**.
- **Resource Utilization (Kintex-7 xc7k325tffg900-2):**
  - **Whole integrated SoC:** Slice LUTs **87,698 / 203,800 (43.03%)**, DSP48E1 **596 / 840 (70.95%)**, Slice Registers **52,802 / 407,600 (12.95%)**, Block RAM Tiles **77 / 445 (17.30%)** (32 RAMB36 + 90 RAMB18).
  - **GatE-V accelerator alone (within the SoC):** 512 MAC cells using 512 DSP48E1 slices, ~5,356 Slice LUTs (2.63%), 18,953 Slice Registers.
- **Verification:** Bare-metal RISC-V self-test firmware (`gatev_firmware`) runs on the VEGA AS1061 CPU, programs the accelerator MMIO registers, and checks the accelerator's AXI4 memory read/write result against expected layer values.

---

## 2. Directory Structure

```
DVCon_India_2026_DC_Stage3A_166/
├── Document/
│   ├── DVCon_India_2026_DC_Stage3A_Report_166.pdf  ← Stage 3A IEEE Report
│   └── figures/                                     ← Figures & waveform PNGs
├── Readme/
│   └── README.md                                    ← Execution instructions (Markdown)
└── ENV/
    ├── Application/                 ← Bare-metal application firmware & cross-compiler tools
    │   ├── gatev_firmware/          ← GatE-V C self-test firmware source & build.sh
    │   ├── dummy_firmware.../       ← Reference firmware
    │   ├── .docker_scripts/         ← Docker container image (docker.tar) & load scripts
    │   ├── toolchain-bare/          ← Bundled RISC-V cross-compiler toolchain
    │   └── Util/                    ← Hex to MIF conversion utilities
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

### Official QuestaSim Waveform Setup Script
In QuestaSim, copy and paste this command block directly into the **Transcript** window to display the official 3-section CDAC waveform layout:

```tcl
# 0. Clear existing signals
delete wave *

# 1. Top Level Signals
add wave -group "Top Level" /test_bench/u_Top/clk_in1_p
add wave -group "Top Level" /test_bench/u_Top/rst
add wave -group "Top Level" /test_bench/u_Top/reset_n
add wave -group "Top Level" /test_bench/u_Top/sin0
add wave -group "Top Level" /test_bench/u_Top/sout0

# SECTION 1: Processor Side Signals (CDAC PDF Page 8)
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_arid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_araddr
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_arlen
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_arsize
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_arvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_arready
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rdata
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rresp
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rlast
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_rready

add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_awvalid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_awaddr
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_awlen
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_awsize
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_awready
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_wdata
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_wstrb
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_wlast
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_wvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_wready

add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_bid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_bresp
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_bvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m0_axi_bready

add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_araddr
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arlen
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arsize
add wave -group "Processor Side Signals" -radix dec /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arburst
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_arready
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rid
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rdata
add wave -group "Processor Side Signals" -radix hex /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rresp
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rlast
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rvalid
add wave -group "Processor Side Signals" /test_bench/u_Top/u_AS1061_SYSTEM_TOP/u_soc_top_64/u_Processor_top/proc_m1_axi_rready

# SECTION 2: Accelerator Slave Side Signals (CDAC PDF Page 9)
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_awid
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_awaddr
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_awlen
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_awsize
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_awburst
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_awvalid
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_awready

add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_wdata
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_wstrb
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_wvalid
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_wready

add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_bid
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_bresp
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_bvalid
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_bready

add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_arid
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_araddr
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_arlen
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_arsize
add wave -group "Accelerator Slave Side Signals" -radix dec /test_bench/u_Top/acc_s_axi_arburst
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_arvalid
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_arready

add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_rid
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_rdata
add wave -group "Accelerator Slave Side Signals" -radix hex /test_bench/u_Top/acc_s_axi_rresp
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_rlast
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_rvalid
add wave -group "Accelerator Slave Side Signals" /test_bench/u_Top/acc_s_axi_rready

# SECTION 3: Accelerator Master Side Signals (CDAC PDF Page 10)
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_awid
add wave -group "Accelerator Master Side Signals" -radix dec /test_bench/u_Top/acc_m_axi_awlen
add wave -group "Accelerator Master Side Signals" -radix dec /test_bench/u_Top/acc_m_axi_awsize
add wave -group "Accelerator Master Side Signals" -radix dec /test_bench/u_Top/acc_m_axi_awburst
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_awaddr
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_awvalid
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_awready

add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_wvalid
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_wlast
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_wdata
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_wstrb
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_wready

add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_bready
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_bvalid
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_bid
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_bresp

add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_arvalid
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_arid
add wave -group "Accelerator Master Side Signals" -radix dec /test_bench/u_Top/acc_m_axi_arlen
add wave -group "Accelerator Master Side Signals" -radix dec /test_bench/u_Top/acc_m_axi_arsize
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_araddr
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_arready

add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_rready
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_rvalid
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_rid
add wave -group "Accelerator Master Side Signals" /test_bench/u_Top/acc_m_axi_rlast
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_rresp
add wave -group "Accelerator Master Side Signals" -radix hex /test_bench/u_Top/acc_m_axi_rdata

run 15 ms
wave zoom full
```

### Vivado Synthesis (Kintex-7 xc7k325tffg900-2)
To run FPGA synthesis for the integrated SoC:

Via Batch Command:
```bash
cd RUN
vivado -mode batch -source ../TCL/DVCon_SYN.tcl
```

Via Interactive Menu:
```bash
cd RUN
./run.sh
# Select Option 2 (FPGA Implementation) -> Option 1 (Synthesis Only) or Option 2 (Full Implementation)
```

### Building the Bare-Metal Self-Test Firmware

The `Application/gatev_firmware` directory is a self-contained, reproducible source tree for the
GatE-V accelerator self-test. To build it (requires the bundled `toolchain-bare` and `Util` tools, or any
RISC-V cross toolchain plus the conversion utilities):

Via Native Toolchain (bundled `toolchain-bare` + `Util`):
```bash
cd Application/gatev_firmware
./build.sh
```

Via Docker Environment (bundled `.docker_scripts/docker.tar`):
```bash
cd Application/.docker_scripts
./install_and_load_docker.sh
./sim_app_compile_and_mif.sh
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
| `0x08` | `TASK_ID` | R/W | Algorithmic Task ID (CLIP Task Conditioning) |
| `0x0C` | `MODE` | R/W | Configuration mode |
| `0x10` | `IMG_BASE_ADDR` | R/W | Base Address for activation image / Matrix A |
| `0x14` | `WT_BASE_ADDR` | R/W | Base Address for layer weights / Matrix B |
| `0x18` | `OUT_BASE_ADDR` | R/W | Base Address for output buffer / Matrix C |
| `0x1C` | `TILES_NUM` | R/W | Total convolution tiles / matrix dimensions |
| `0x20` | `DMA_SRC_ADDR` | R/W | DMA Source Address |
| `0x24` | `DMA_DST_ADDR` | R/W | DMA Destination Address |
| `0x28` | `DMA_LEN` | R/W | DMA Length (Bytes) |
| `0x2C` | `DMA_CTRL` | R/W | DMA Control (Bit 0: Start, Bit 1: Direction) |
| `0x30` | `BURST_TYPE` | R/W | AXI burst type (INCR) |
| `0x34` | `BURST_LEN` | R/W | AXI burst length (64 beats) |
| `0x40` | `PERF_CYCLE_LOW` | R | Performance counter: Total cycle count (Low 32 bits) |
| `0x44` | `PERF_CYCLE_HIGH` | R | Performance counter: Total cycle count (High 32 bits) |
| `0x48` | `PERF_READ_BYTES` | R | Performance counter: Total AXI read bytes |
| `0x4C` | `PERF_WRITE_BYTES` | R | Performance counter: Total AXI write bytes |
| `0x50` | `PERF_MAC_CYCLES` | R | Performance counter: Active MAC computation cycles |
| `0x54` | `PERF_STALL_CYCLES` | R | Performance counter: AXI / Memory stall cycles |

---

- **Team ID:** 166 (Byte Silicon)

