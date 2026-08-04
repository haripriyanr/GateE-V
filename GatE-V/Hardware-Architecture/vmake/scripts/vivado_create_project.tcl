# GatE-V Stage 2B — Vivado Project Creation Script
# Usage: cd Make Files && vivado -source scripts/vivado_create_project.tcl

set project_name "GatE-V"
set project_dir [lindex $argv 0]
if {$project_dir == ""} { set project_dir "../GatE-V" }
set src_dir [lindex $argv 1]
if {$src_dir == ""} { set src_dir "../GatE-V/src" }
set rtl_root "$src_dir/rtl"

create_project $project_name $project_dir -part xc7k325tffg900-2 -force
set_property target_language Verilog [current_project]
set_property board_part_repo_paths [file normalize "$src_dir/board_files"] [current_project]
set_property board_part digilentinc.com:genesys2:part0:1.1 [current_project]

# Add all RTL sources (synthesizable + simulation)
read_verilog -sv [list \
    $rtl_root/gatev_pkg.sv      \
    $rtl_root/gatev_top.sv      \
    $rtl_root/gatev_axi_lite_slave.sv   \
    $rtl_root/gatev_axi4_master.sv      \
    $rtl_root/gatev_mac_engine.sv       \
    $rtl_root/gatev_backbone.sv         \
    $rtl_root/gatev_ddr3_model.sv       \
    $rtl_root/tb_gatev.sv       \
]

set_property top gatev_top [current_fileset]

# Add timing constraints
read_xdc $src_dir/constraints/gatev_constraints.xdc

puts "============================================================"
puts " GatE-V Stage 2B Vivado Project Created"
puts " Part: xc7k325tffg900-2 (Kintex-7, Digilent Genesys-2)"
puts " Sources: 8 files in rtl/"
puts " Top: gatev_top"
puts ""
puts " Next:"
puts "   1. vivado GatE-V.xpr"
puts "   2. Run Simulation -> tb_gatev"
puts "   3. Run Synthesis to check resource usage"
puts "============================================================"

close_project
