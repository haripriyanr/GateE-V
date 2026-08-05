# GatE-V Stage 2B — ModelSim/Questa Simulation Script
# Compatible with: Windows (ModelSim/Questa) and Linux (ModelSim/Questa)
#
# Usage (from the Hardware Architecture/ directory):
#
#   Batch mode (no GUI):
#     vsim -do sim/run.do
#
#   GUI mode:
#     vsim -do {do sim/run.do}
#     or from within ModelSim GUI: do sim/run.do
#
# To change NUM_TILES (default 4):
#   Edit the NUM_TILES variable below, or pass -G:
#     vsim -G/NUM_TILES=2 -do sim/run.do

# ── Compiler Options ────────────────────────────────────────────────
set SvOpts {-sv}
set VOpts  {}

# Suppress common warnings
quietly set StdArithNoWarnings 1
quietly set NumericStdNoWarnings 1

# ── Configuration ───────────────────────────────────────────────────
set NUM_TILES 4           ;# Valid range: 1-4

# ── Source Directories ──────────────────────────────────────────────
set RTL_DIR "rtl"

# ── Clean & Create Work Library ─────────────────────────────────────
if {[file exists work]} {
    vdel -all
}
vlib work

# ── Compile Sources (order matters!) ────────────────────────────────
# Package (must be compiled first)
vlog $SvOpts $RTL_DIR/gatev_pkg.sv

# DDR3 memory model
vlog $SvOpts $RTL_DIR/gatev_ddr3_model.sv

# AXI4 interfaces (Lite slave + Full master)
vlog $SvOpts $RTL_DIR/gatev_axi_lite_slave.sv
vlog $SvOpts $RTL_DIR/gatev_axi4_master.sv

# Async FIFO (CDC utility, included for completeness)
vlog $SvOpts $RTL_DIR/gatev_async_fifo.sv

# MAC engine (systolic array, requantize, SiLU LUT)
vlog $SvOpts $RTL_DIR/gatev_mac_engine.sv

# Backbone (line buffer, maxpool, tile scheduler)
vlog $SvOpts $RTL_DIR/gatev_backbone.sv

# Top-level accelerator
vlog $SvOpts $RTL_DIR/gatev_top.sv

# Self-checking testbench
vlog $SvOpts $RTL_DIR/tb_gatev.sv

# ── Elaborate & Run ─────────────────────────────────────────────────
if {$NUM_TILES != 4} {
    vsim -voptargs="+acc=npr" -G/NUM_TILES=$NUM_TILES work.tb_gatev
} else {
    vsim -voptargs="+acc=npr" work.tb_gatev
}

# Load waveform configuration
if {[file exists sim/wave.do]} {
    do sim/wave.do
}

# Run simulation
run -all

# Print completion
puts "\n═══════════════════════════════════════════"
puts " Simulation Complete"
puts "═══════════════════════════════════════════"
quit -f
