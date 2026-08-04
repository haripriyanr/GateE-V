# GatE-V Stage 2B — Vivado Simulation Script
# Usage: cd Make Files && vivado -mode batch -source scripts/vivado_sim.tcl -tclargs <PROJECT_DIR> <SRC_DIR> <NUM_TILES>

set project_name "GatE-V"

set project_dir [lindex $argv 0]
if {$project_dir eq ""} { set project_dir "../GatE-V" }
set src_dir [lindex $argv 1]
if {$src_dir eq ""} { set src_dir "../GatE-V/src" }
set num_tiles [lindex $argv 2]
if {$num_tiles eq ""} { set num_tiles 4 }
set rtl_root "$src_dir/rtl"

# Create/update project
if {[file exists $project_dir/$project_name.xpr]} {
    open_project $project_dir/$project_name.xpr
} else {
    create_project $project_name $project_dir -part xc7k325tffg900-2 -force
}

# Add sources (idempotent — skip if already added)
set src_files [list \
    $rtl_root/gatev_pkg.sv      \
    $rtl_root/gatev_top.sv      \
    $rtl_root/gatev_axi_lite_slave.sv   \
    $rtl_root/gatev_axi4_master.sv      \
    $rtl_root/gatev_mac_engine.sv       \
    $rtl_root/gatev_backbone.sv         \
    $rtl_root/gatev_async_fifo.sv       \
    $rtl_root/gatev_ddr3_model.sv       \
    $rtl_root/tb_gatev.sv       \
]

foreach f $src_files {
    if {[lsearch [get_files] $f] < 0} {
        read_verilog -sv $f
    }
}

set_property top tb_gatev [get_filesets sim_1]

# Pass NUM_TILES (+define+ is fragile with incr cache; default 4 works always)
set_property -name {xsim.compile.xvlog.more_options} -value "+define+NUM_TILES=${num_tiles}" -objects [get_filesets sim_1]

# Launch simulation
launch_simulation
run all

puts "============================================================"
puts " GatE-V Stage 2B Simulation Complete"
puts " Check waveform or console output for pass/fail"
puts "============================================================"
