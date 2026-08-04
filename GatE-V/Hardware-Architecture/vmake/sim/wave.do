# GatE-V Stage 2B — ModelSim/Questa Waveform Configuration
# Load from sim/run.do (automatic) or manually:
#   do sim/wave.do   (from within simulation)

onerror {resume}
quietly WaveActivateNextPane {} 0

# ── Clock & Reset ──────────────────────────────────────────────────
add wave -divider "Clock & Reset"
add wave -radix binary /tb_gatev/clk
add wave -radix binary /tb_gatev/rst_n
add wave -radix binary /tb_gatev/acc_done

# ── Top-Level FSM ──────────────────────────────────────────────────
add wave -divider "Top-Level FSM"
add wave -radix hexadecimal /tb_gatev/u_dut/state
add wave -radix unsigned   /tb_gatev/u_dut/layer_idx
add wave -radix binary     /tb_gatev/u_dut/bank_sel
add wave -radix unsigned   /tb_gatev/u_dut/wt_raddr
add wave -radix unsigned   /tb_gatev/u_dut/act_feed_ptr
add wave -radix unsigned   /tb_gatev/u_dut/out_buf_cnt
add wave -radix unsigned   /tb_gatev/u_dut/store_cnt

# ── AXI-Lite Transactions ──────────────────────────────────────────
add wave -divider "AXI-Lite (Control/Status Registers)"
add wave -radix hexadecimal /tb_gatev/s_axil_awaddr
add wave -radix hexadecimal /tb_gatev/s_axil_wdata
add wave -radix binary     /tb_gatev/s_axil_awvalid
add wave -radix binary     /tb_gatev/s_axil_awready
add wave -radix binary     /tb_gatev/s_axil_wvalid
add wave -radix binary     /tb_gatev/s_axil_wready
add wave -radix hexadecimal /tb_gatev/s_axil_araddr
add wave -radix hexadecimal /tb_gatev/s_axil_rdata
add wave -radix binary     /tb_gatev/s_axil_arvalid
add wave -radix binary     /tb_gatev/s_axil_arready
add wave -radix binary     /tb_gatev/s_axil_rvalid

# ── AXI4 Full Master (DDR Burst Reads/Writes) ──────────────────────
add wave -divider "AXI4 Master (DDR)"
add wave -radix hexadecimal /tb_gatev/m_axi_awaddr
add wave -radix binary     /tb_gatev/m_axi_awvalid
add wave -radix binary     /tb_gatev/m_axi_awready
add wave -radix hexadecimal /tb_gatev/m_axi_wdata
add wave -radix binary     /tb_gatev/m_axi_wvalid
add wave -radix binary     /tb_gatev/m_axi_wready
add wave -radix hexadecimal /tb_gatev/m_axi_araddr
add wave -radix binary     /tb_gatev/m_axi_arvalid
add wave -radix binary     /tb_gatev/m_axi_arready
add wave -radix hexadecimal /tb_gatev/m_axi_rdata
add wave -radix binary     /tb_gatev/m_axi_rvalid

# ── Tile Scheduler State ──────────────────────────────────────────
add wave -divider "Tile Scheduler (gatev_conv2d_tile_scheduler)"
add wave -radix hexadecimal /tb_gatev/u_dut/u_sched/state
add wave -radix unsigned   /tb_gatev/u_dut/u_sched/round_cnt
add wave -radix unsigned   /tb_gatev/u_dut/u_sched/w_col_cnt
add wave -radix unsigned   /tb_gatev/u_dut/u_sched/act_cnt
add wave -radix binary     /tb_gatev/u_dut/u_sched/start
add wave -radix binary     /tb_gatev/u_dut/u_sched/busy
add wave -radix binary     /tb_gatev/u_dut/u_sched/done

# ── MAC Engine State ───────────────────────────────────────────────
add wave -divider "MAC Engine (gatev_shared_mac_engine)"
add wave -radix hexadecimal /tb_gatev/u_dut/u_sched/u_mac/dbg_state
add wave -radix binary     /tb_gatev/u_dut/u_sched/u_mac/start
add wave -radix binary     /tb_gatev/u_dut/u_sched/u_mac/busy
add wave -radix binary     /tb_gatev/u_dut/u_sched/u_mac/done
add wave -radix binary     /tb_gatev/u_dut/u_sched/mac_weight_ready
add wave -radix binary     /tb_gatev/u_dut/u_sched/mac_act_ready

# ── DDR Memory Model ───────────────────────────────────────────────
add wave -divider "DDR3 Memory Model (gatev_ddr3_model)"
add wave -radix hexadecimal /tb_gatev/u_ddr/s_axi_awaddr
add wave -radix binary     /tb_gatev/u_ddr/s_axi_awvalid
add wave -radix binary     /tb_gatev/u_ddr/s_axi_awready
add wave -radix hexadecimal /tb_gatev/u_ddr/s_axi_wdata
add wave -radix binary     /tb_gatev/u_ddr/s_axi_wvalid
add wave -radix binary     /tb_gatev/u_ddr/s_axi_wready
add wave -radix hexadecimal /tb_gatev/u_ddr/s_axi_araddr
add wave -radix binary     /tb_gatev/u_ddr/s_axi_arvalid
add wave -radix binary     /tb_gatev/u_ddr/s_axi_arready
add wave -radix hexadecimal /tb_gatev/u_ddr/s_axi_rdata
add wave -radix binary     /tb_gatev/u_ddr/s_axi_rvalid

# ── Performance Counters ───────────────────────────────────────────
add wave -divider "Performance Counters"
add wave -radix unsigned   /tb_gatev/u_dut/perf_cycle
add wave -radix unsigned   /tb_gatev/u_dut/perf_rd_bytes
add wave -radix unsigned   /tb_gatev/u_dut/perf_wr_bytes
add wave -radix unsigned   /tb_gatev/u_dut/perf_mac
add wave -radix unsigned   /tb_gatev/u_dut/perf_stall

# ── Display Settings ───────────────────────────────────────────────
TreeUpdate [SetDefaultTree]
WaveRestoreZoom {0 ns} {2000 ns}
configure wave -namecolwidth 300
configure wave -valuecolwidth 100
