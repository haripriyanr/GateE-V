# ==========================================================
# Headless QuestaSim run for DVCon Stage3A submission
# Mirrors official TCL/QuestaSim_SIM.do (full SoC: work.test_bench glbl)
# Run: vsim -c -do run_questa_headless.do
# Outputs: gatev_headless.wlf + gatev_headless.vcd + transcript
# ==========================================================

# ---- CONFIG ----
set SIM_TIME "1000 us"
set VCD_FILE  gatev_headless.vcd

set MDIR "/run/media/user/DATA/DVcon/GatE-V/Hardware-Architecture/Evaluation_DVcon/submission/DVCon_India_2026_DC_Stage3A_166/ENV"
set worklib work
set unisims_src "$MDIR/DVCon_SoC_SRC/TB/unisims"
set unisims_lib "$MDIR/DVCon_SoC_SRC/TB/unisims_ver"
set accel_dir "$MDIR/DVCon_SoC_SRC/ACCELERATOR_IP"

# ==========================================================
# WORK + UNISIMS LIBRARY SETUP (official)
# ==========================================================
if {[file exists $worklib]} { file delete -force $worklib }
vlib $worklib
vmap work $worklib

if {[file exists $unisims_lib]} { file delete -force $unisims_lib }
vlib $unisims_lib
vmap unisims_ver $unisims_lib

puts "Compiling UNISIM library..."
eval vlog -work unisims_ver [glob "$unisims_src/*.v"]

# ==========================================================
# FIXED DESIGN FILES (official order; DDR3 model FIRST)
# ==========================================================
set ddr3_model_dir "$MDIR/DVCon_SoC_SRC/TB/ddr3_model"
puts "Compiling DDR3 behavioural model..."
vlog -work $worklib +incdir+$ddr3_model_dir $ddr3_model_dir/ddr3_model.sv

vcom -2008 -work $worklib $MDIR/DVCon_SoC_SRC/TB/test_bench.vhd
vcom -2008 -work $worklib $MDIR/DVCon_SoC_SRC/TOP/Top.vhd
vlog -work $worklib $MDIR/DVCon_SoC_SRC/AS1061_SYSTEM/AS1061_SYSTEM_TOP.v
vlog -work $worklib $MDIR/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/sim/rom_32KB_axi.v
vlog -work $worklib $MDIR/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/simulation/blk_mem_gen_v8_4.v
vlog -work $worklib $MDIR/DVCon_SoC_SRC/TB/glbl.v

# ==========================================================
# ACCELERATOR_IP (dependency-ordered; excludes tb_gatev.sv)
# ==========================================================
puts "Compiling ACCELERATOR_IP package (gatev_pkg.sv)..."
vlog -sv -work $worklib $accel_dir/gatev_pkg.sv
set sv_files [list \
    "$accel_dir/gatev_mac_engine.sv" \
    "$accel_dir/gatev_axi_lite_slave.sv" \
    "$accel_dir/gatev_axi4_master.sv" \
    "$accel_dir/gatev_backbone.sv" \
    "$accel_dir/gatev_top.sv" \
    "$accel_dir/Accelerator_Top.sv" \
]
puts "Compiling ACCELERATOR_IP SystemVerilog files (dependency-ordered)..."
vlog -sv -work $worklib {*}$sv_files

# ==========================================================
# ELABORATE + RUN (official full-SoC top: test_bench glbl)
# ==========================================================
vsim -novopt -suppress 12110 -suppress 8630 -L unisims_ver -t ps work.test_bench glbl

# WLF (native) capture on gatev accelerator instance
log -r /test_bench/u_Top/u_Accelerator_Top/u_gatev_top/*

# VCD dump for Python analysis (pyvcd / numpy)
vcd file $VCD_FILE
vcd add -r sim:/test_bench/u_Top/u_Accelerator_Top/u_gatev_top/*

puts "==> Running $SIM_TIME of simulation (gatev top captured)..."
run $SIM_TIME

puts "==> Done. Flushing VCD + saving WLF..."
vcd flush
quit -f