# GatE-V FPGA Simulator Guide

## Prerequisites
- Vivado 2023.2 or compatible version
- Make

## Project Structure
The `Make` directory is completely self-contained. When you run `make`, it automatically creates a Vivado project directory named `GatE-V` inside its parent folder (e.g. `../GatE-V`), copies the `rtl` and `tb` files into it, and uses those files to run simulations and generate block designs. 

## Running the Simulation (Linux/macOS or WSL)

1. **Terminal Setup:**
   Ensure `vivado` is available in your PATH. Change directory to the `Make` folder.

2. **Simulation:**
   Run the following command to execute the block design creation and behavioral simulation in batch mode:
   ```bash
   make sim
   ```
   To specify the number of tiles (default is 4):
   ```bash
   make sim NUM_TILES=4
   ```

3. **GUI Simulation:**
   To open the Vivado GUI and view waveforms:
   ```bash
   make sim-gui
   ```

4. **Generating Block Design:**
   If you just want to generate the block design:
   ```bash
   make bd
   ```

5. **Sync RTL:**
   Sync RTL to Vivado project:
   ```bash
   make prepare
   ```

5. **Cleaning Build Files:**
   To remove generated simulation artifacts (Vivado and Questa) and the Vivado project entirely:
   ```bash
   make clean
   ```


## Running the Simulation (ModelSim/Questa)
1. **Terminal Setup:**
   Ensure `vsim` is available in your PATH. Change directory to the `Make` folder.
   
2. **Batch Simulation:**
   ```bash
   make questa
   ```
   Or directly:
   ```bash
   vsim -c -do "do sim/run.do"
   ```

3. **GUI Simulation:**
   ```bash
   make questa-gui
   ```
   Or directly:
   ```bash
   vsim -do "do sim/run.do"
   ```

## Running the Simulation (Windows)
Because the `Makefile` relies on native Linux commands, a `build.bat` script is provided for native Windows users. Ensure Vivado and/or ModelSim is added to your PATH (e.g. from the Vivado Tcl Shell or Command Prompt). Change directory to the `Make` folder.

1. **Vivado Simulation:**
   ```cmd
   build.bat sim
   build.bat sim 4
   build.bat sim-gui
   ```

2. **ModelSim/Questa Simulation:**
   ```cmd
   build.bat questa
   build.bat questa-gui
   ```

3. **Generating Block Design & Synthesis:**
   ```cmd
   build.bat bd
   build.bat synth
   build.bat gatev
   ```

4. **Cleaning Build Files:**
   ```cmd
   build.bat clean
   ```
