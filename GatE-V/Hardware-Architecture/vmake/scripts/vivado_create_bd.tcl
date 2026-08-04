# GatE-V Stage 2B — Vivado Block Design Creation Script
# Target: Digilent Genesys-2 (XC7K325T-2FFG900C, 1GB DDR3)
#
# Usage:
#   cd Make Files && vivado -mode batch -source scripts/vivado_create_bd.tcl

set project_name "GatE-V"
set project_dir [lindex $argv 0]
if {$project_dir == ""} { set project_dir "../GatE-V" }
set src_dir [lindex $argv 1]
if {$src_dir == ""} { set src_dir "../GatE-V/src" }
set bd_name "gatev_bd"
set rtl_root "$src_dir/rtl"

# ── 1. Create project fresh ───────────────────────────────────────────
if {[file exists $project_dir/$project_name.xpr]} {
    file delete -force $project_dir/$project_name.xpr
    file delete -force $project_dir/$project_name.cache
    file delete -force $project_dir/$project_name.hw
    file delete -force $project_dir/$project_name.ip_user_files
    file delete -force $project_dir/$project_name.sim
    file delete -force $project_dir/$project_name.srcs
}

create_project $project_name $project_dir -part xc7k325tffg900-2 -force
set_property target_language Verilog [current_project]
set_property board_part_repo_paths [file normalize "$src_dir/board_files"] [current_project]
set_property board_part digilentinc.com:genesys2:part0:1.1 [current_project]

# Add RTL sources (synthesizable subset — no testbench)
read_verilog -sv [list \
    $rtl_root/gatev_pkg.sv      \
    $rtl_root/gatev_top.sv      \
    $rtl_root/gatev_axi_lite_slave.sv   \
    $rtl_root/gatev_axi4_master.sv      \
    $rtl_root/gatev_mac_engine.sv       \
    $rtl_root/gatev_backbone.sv         \
]

set_property top gatev_top [current_fileset]

# ── 2. Block Design ───────────────────────────────────────────────────
create_bd_design $bd_name

# ── 3. Clocking Wizard (200 MHz diff in -> 100 MHz sys + 200 MHz ref) ─
create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0
set_property -dict [list \
    CONFIG.PRIMITIVE {PLL} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.CLKOUT1_USED {true} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
] [get_bd_cells clk_wiz_0]

# ── 4. Processor System Reset ─────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0

# ── 5. AXI Interconnect (accelerator M_AXI -> DDR) ────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon
set_property -dict [list CONFIG.NUM_SI {1} CONFIG.NUM_MI {1}] [get_bd_cells axi_mem_intercon]

# ── 5b. MIG 7-Series DDR3 Memory Controller ───────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:mig_7series:4.2 mig_7series_0
set mig_prj_path [file normalize "$src_dir/board_files/genesys2/H/mig.prj"]
if {[file exists $mig_prj_path]} {
    set_property -dict [list \
        CONFIG.XML_INPUT_FILE $mig_prj_path \
        CONFIG.MIG_DONT_TOUCH_PARAM {Custom} \
    ] [get_bd_cells mig_7series_0]
}

# Connect AXI Memory Interconnect M00_AXI -> MIG S_AXI
connect_bd_intf_net [get_bd_intf_pins axi_mem_intercon/M00_AXI] \
                    [get_bd_intf_pins mig_7series_0/S_AXI]

# ── 6. Accelerator (gatev_top) ──────────────────────────────────────
create_bd_cell -type module -reference gatev_top gatev_top

# ── 7. Interrupt concat ───────────────────────────────────────────────
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0
set_property -dict [list CONFIG.NUM_PORTS {1}] [get_bd_cells xlconcat_0]

# ── 8. Clock and reset connections ────────────────────────────────────
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins gatev_top/aclk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins proc_sys_reset_0/slowest_sync_clk]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins axi_mem_intercon/S00_ACLK]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins axi_mem_intercon/ACLK]
connect_bd_net [get_bd_pins clk_wiz_0/clk_out1] \
               [get_bd_pins axi_mem_intercon/M00_ACLK]

connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
               [get_bd_pins gatev_top/areset_n]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
               [get_bd_pins axi_mem_intercon/S00_ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
               [get_bd_pins axi_mem_intercon/ARESETN]
connect_bd_net [get_bd_pins proc_sys_reset_0/peripheral_aresetn] \
               [get_bd_pins axi_mem_intercon/M00_ARESETN]

# ── 9. Data path ──────────────────────────────────────────────────────
connect_bd_intf_net [get_bd_intf_pins gatev_top/m_axi] \
                    [get_bd_intf_pins axi_mem_intercon/S00_AXI]

# ── 10. IRQ ────────────────────────────────────────────────────────────
connect_bd_net [get_bd_pins gatev_top/acc_done] \
               [get_bd_pins xlconcat_0/In0]

# ── 11. External interfaces ────────────────────────────────────────────
make_bd_intf_pins_external [get_bd_intf_pins gatev_top/s_axil]
set_property name ext_s_axil [get_bd_intf_ports s_axil_0]

make_bd_intf_pins_external [get_bd_intf_pins mig_7series_0/DDR3]
set_property name ddr3_sdram [get_bd_intf_ports DDR3_0]

create_bd_port -dir I -type clk sys_clk
set_property CONFIG.FREQ_HZ 200000000 [get_bd_ports sys_clk]
connect_bd_net [get_bd_ports sys_clk] [get_bd_pins clk_wiz_0/clk_in1]

create_bd_port -dir I -type rst ext_reset_n
connect_bd_net [get_bd_ports ext_reset_n] [get_bd_pins proc_sys_reset_0/ext_reset_in]

create_bd_port -dir O -type intr irq
connect_bd_net [get_bd_ports irq] [get_bd_pins xlconcat_0/dout]

# ── 12. Suppress harmless IP_Flow messages ────────────────────────────
set_msg_config -suppress -id {IP_Flow 19-5101}    ;# SV top packaging
set_msg_config -suppress -id {IP_Flow 19-11770}   ;# FREQ_HZ on aclk

# ── 13. Validate and save ─────────────────────────────────────────────
regenerate_bd_layout
save_bd_design

puts "============================================================"
puts " GatE-V Stage 3A Block Design Created & Fully Wired to DDR3 MIG"
puts " Contains:"
puts "   - clk_wiz_0        (200M in -> 100M sys + 200M ref)"
puts "   - proc_sys_reset_0 (reset synchronizer)"
puts "   - axi_mem_intercon (accelerator M_AXI <-> DDR3 bridge)"
puts "   - mig_7series_0    (Genesys-2 DDR3 Memory Controller)"
puts "   - gatev_top        (convolution accelerator core)"
puts "   - xlconcat_0       (acc_done -> irq)"
puts "   - External ports: sys_clk, ext_reset_n, ext_s_axil, irq, ddr3_sdram"
puts "============================================================"
