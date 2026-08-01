# GatE-V Debug Simulation Script (simplified)
set project_name "GatE-V"
set project_dir "../GatE-V"
set rtl_root "rtl"

if {[file exists $project_dir/$project_name.xpr]} {
    open_project $project_dir/$project_name.xpr
} else {
    create_project $project_name $project_dir -part xc7k325tffg900-2 -force
}

set src_files [list \
    $rtl_root/gatev_pkg.sv      \
    $rtl_root/gatev_top.sv      \
    $rtl_root/gatev_axi_lite_slave.sv   \
    $rtl_root/gatev_axi4_master.sv      \
    $rtl_root/gatev_mac_engine.sv       \
    $rtl_root/gatev_backbone.sv         \
    $rtl_root/gatev_ddr3_model.sv       \
    $rtl_root/tb_gatev.sv       \
]

foreach f $src_files {
    if {[lsearch [get_files] $f] < 0} {
        read_verilog -sv $f
    }
}

set_property top tb_gatev [get_filesets sim_1]
launch_simulation
run 5000ns
close_wave_config
open_wave_config
add_wave /
puts "============================================================"
puts "State at 5000ns:"
puts "============================================================"
puts "Top state: [get_value -radix unsigned /tb_gatev/u_dut/state]"
puts "Acc_done:  [get_value -radix unsigned /tb_gatev/u_dut/acc_done]"
puts "Layer idx: [get_value -radix unsigned /tb_gatev/u_dut/layer_idx]"
puts "Sched dbg_state: [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_state]"
puts "Sched dbg_next:  [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_next]"
puts "Sched round_cnt: [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_round_cnt]"
puts "Sched w_col_cnt: [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_w_col_cnt]"
puts "MAC dbg_state:   [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_mac_state]"
puts "MAC start:  [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_mac_start]"
puts "MAC done:   [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_mac_done]"
puts "W ready:    [get_value -radix unsigned /tb_gatev/u_dut/u_sched/dbg_mac_weight_ready]"
puts "wr_phase:   [get_value -radix unsigned /tb_gatev/u_dut/wr_phase]"
puts "lo_captured:[get_value -radix unsigned /tb_gatev/u_dut/out_lo_captured]"
puts "hi_captured:[get_value -radix unsigned /tb_gatev/u_dut/out_hi_captured]"
puts "wr_pending: [get_value -radix unsigned /tb_gatev/u_dut/wr_pending]"
puts "load_phase: [get_value -radix unsigned /tb_gatev/u_dut/load_phase]"
puts "act_ld_cnt: [get_value -radix unsigned /tb_gatev/u_dut/act_ld_cnt]"
puts "ld_cnt:     [get_value -radix unsigned /tb_gatev/u_dut/ld_cnt]"
puts "wt_raddr:   [get_value -radix unsigned /tb_gatev/u_dut/wt_raddr]"
puts "============================================================"
