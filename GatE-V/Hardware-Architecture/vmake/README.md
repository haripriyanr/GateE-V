# GatE-V FPGA Build & Simulation (vmake)

Self-contained Vivado/Questa build system for the **GatE-V** hardware accelerator (FPGA V3).

**Hardware Specs**: 32x16 Systolic Array (512 INT8 MACs) @ 100 MHz, 800x800 image support (`MAX_IMG_WIDTH=800`), P2–P5 FGPA line buffering, discrete grid sampling, 256-entry SiLU LUT, AXI4 Full DMA.

**Target device**: Xilinx Kintex-7 XC7K325T-FFG900 (Digilent Genesys-2).

## Prerequisites
- **Vivado 2026.1** (tested; compatible versions should work)
- **Make** (Linux/macOS/WSL) — or native Windows via `build.bat`
- **ModelSim/Questa** *(optional)* — for `make questa`

## Directory Layout
```
vmake/
├── rtl/                 SystemVerilog RTL (10 files, ~3.4k lines)
│   ├── gatev_pkg.sv          Package: params, AXI widths, SiLU function
│   ├── Accelerator_Top.sv    Top-level accelerator wrapper
│   ├── gatev_top.sv          AXI4-Lite slave + config/task control
│   ├── gatev_axi4_master.sv  AXI4 Full master (burst read/write)
│   ├── gatev_axi_lite_slave.sv  AXI4-Lite slave interface
│   ├── gatev_mac_engine.sv   Systolic array, requantizer, SiLU LUT
│   ├── gatev_backbone.sv     Line buffer, maxpool, tile scheduler
│   ├── gatev_async_fifo.sv   CDC FIFO utility
│   ├── gatev_ddr3_model.sv   DDR3 behavioral model (sim only)
│   └── tb_gatev.sv           Self-checking testbench
├── scripts/             Vivado Tcl driver scripts
│   ├── vivado_create_project.tcl
│   ├── vivado_create_bd.tcl  Block design
│   ├── vivado_synth.tcl      Synthesis (100 MHz)
│   ├── vivado_sim.tcl        XSim batch/GUI
│   ├── capture_bd_screenshot.tcl
│   └── debug_sim.tcl
├── constraints/
│   └── gatev_constraints.xdc  100 MHz clock (`create_clock -period 10.000`)
├── sim/
│   ├── run.do           Questa/ModelSim script (compile + run 200us)
│   └── wave.do          Waveform view configuration
├── board_files/
│   └── genesys2/        Digilent Genesys-2 board files (H/*.xml)
├── Makefile             Linux/macOS/WSL build & sim targets
├── build.bat            Windows equivalent
└── Evaluation/          *(reference)* C-DAC VEGA AS1061 delivery package
```

## How it works
`make` builds a self-contained Vivado project at `../GatE-V/`, copying `rtl/`, `constraints/`, and `board_files/` into it. Run `make help` for the interactive target menu.

## Make Targets (Linux/macOS/WSL)

| Target | Description |
|--------|-------------|
| `make help` | Show interactive help menu |
| `make prepare` | Sync RTL/constraints/board_files into the Vivado project |
| `make bd` | Generate block design (batch) |
| `make synth` | Synthesize design at 100 MHz |
| `make gatev` | Full flow: bd + synth + sim |
| `make sim` | Vivado XSim batch (default 4 tiles) |
| `make sim-gui` | Vivado XSim with waveforms |
| `make questa` | Questa/ModelSim batch (runs `sim/run.do`, 200us) |
| `make questa-gui` | Questa/ModelSim with GUI |
| `make open` | Open the Vivado project in GUI |
| `make clean` | Remove all build artifacts + `../GatE-V` project |

**Options**: `make sim NUM_TILES=2` — tile count 1–4, default 4.

## Questa/ModelSim (direct)
```bash
vsim -c -do "do sim/run.do"     # batch
vsim -do "do sim/run.do"        # GUI
```

## Windows (`build.bat`)
```cmd
build.bat gatev          rem full flow (bd + synth + sim)
build.bat synth
build.bat bd
build.bat sim
build.bat sim 2          rem NUM_TILES
build.bat sim-gui
build.bat questa
build.bat questa-gui
build.bat clean
```
`build.bat` with no argument defaults to `bd`.

## Simulation Notes
- `tb_gatev.sv` is self-checking; Questa runs 200 us by default.
- NUM_TILES range is 1–4 (validated in `sim/run.do`).
- `gatev_ddr3_model.sv` is a simulation-only behavioral DDR3 model.