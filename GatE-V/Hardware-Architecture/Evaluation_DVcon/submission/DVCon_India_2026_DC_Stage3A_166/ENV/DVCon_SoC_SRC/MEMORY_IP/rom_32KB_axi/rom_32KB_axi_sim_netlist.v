// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
// Date        : Tue Jun 23 11:37:02 2026
// Host        : node03.cdac.in running 64-bit Red Hat Enterprise Linux release 8.10 (Ootpa)
// Command     : write_verilog -force -mode funcsim
//               /home/user008/Thejus64_Limited/DVCON_PJT/DVCon_2026_90/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi_sim_netlist.v
// Design      : rom_32KB_axi
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "rom_32KB_axi,blk_mem_gen_v8_4_1,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2018.1" *) 
(* NotValidForBitStream *)
module rom_32KB_axi
   (rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready);
  output rsta_busy;
  output rstb_busy;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 CLK.ACLK CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME CLK.ACLK, ASSOCIATED_BUSIF AXI_SLAVE_S_AXI:AXILite_SLAVE_S_AXI, ASSOCIATED_RESET s_aresetn, FREQ_HZ 100000000, PHASE 0.000" *) input s_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 RST.ARESETN RST" *) (* x_interface_parameter = "XIL_INTERFACENAME RST.ARESETN, POLARITY ACTIVE_LOW" *) input s_aresetn;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWID" *) (* x_interface_parameter = "XIL_INTERFACENAME AXI_SLAVE_S_AXI, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 12, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0" *) input [11:0]s_axi_awid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWADDR" *) input [31:0]s_axi_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWLEN" *) input [7:0]s_axi_awlen;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWSIZE" *) input [2:0]s_axi_awsize;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWBURST" *) input [1:0]s_axi_awburst;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWVALID" *) input s_axi_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWREADY" *) output s_axi_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WDATA" *) input [63:0]s_axi_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WSTRB" *) input [7:0]s_axi_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WLAST" *) input s_axi_wlast;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WVALID" *) input s_axi_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WREADY" *) output s_axi_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BID" *) output [11:0]s_axi_bid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BVALID" *) output s_axi_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BREADY" *) input s_axi_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARID" *) input [11:0]s_axi_arid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARADDR" *) input [31:0]s_axi_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARLEN" *) input [7:0]s_axi_arlen;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARSIZE" *) input [2:0]s_axi_arsize;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARBURST" *) input [1:0]s_axi_arburst;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARVALID" *) input s_axi_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARREADY" *) output s_axi_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RID" *) output [11:0]s_axi_rid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RDATA" *) output [63:0]s_axi_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RLAST" *) output s_axi_rlast;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RVALID" *) output s_axi_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RREADY" *) input s_axi_rready;

  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [11:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [11:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [11:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;
  wire [63:0]s_axi_rdata;
  wire [11:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [63:0]NLW_U0_douta_UNCONNECTED;
  wire [63:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "0" *) 
  (* C_AXI_ID_WIDTH = "12" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "1" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "8" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     42.0362 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "1" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "1" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "rom_32KB_axi.mem" *) 
  (* C_INIT_FILE_NAME = "rom_32KB_axi.mif" *) 
  (* C_INTERFACE_TYPE = "1" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "3" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "8" *) 
  (* C_WEB_WIDTH = "8" *) 
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "READ_FIRST" *) 
  (* C_WRITE_MODE_B = "READ_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  rom_32KB_axi_blk_mem_gen_v8_4_1 U0
       (.addra({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(1'b0),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[63:0]),
        .doutb(NLW_U0_doutb_UNCONNECTED[63:0]),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(rsta_busy),
        .rstb(1'b0),
        .rstb_busy(rstb_busy),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .web({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_axi_read_fsm" *) 
module rom_32KB_axi_blk_mem_axi_read_fsm
   (s_axi_arready,
    SR,
    s_axi_rvalid,
    s_axi_rlast,
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] ,
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ,
    \gaxi_full_sm.outstanding_read_r_reg_0 ,
    \FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ,
    \gaxi_full_sm.arlen_cntr_reg[7] ,
    \gaxi_full_sm.arlen_cntr_reg[6] ,
    \gaxi_full_sm.arlen_cntr_reg[3] ,
    D,
    \gaxi_full_sm.arlen_cntr_reg[7]_0 ,
    \grid.ar_id_r_reg[11] ,
    \grid.S_AXI_RID_reg[11] ,
    E,
    \gaxi_full_sm.arlen_cntr_reg[0] ,
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] ,
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_1 ,
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 ,
    ADDRBWRADDR,
    s_aclk,
    s_aresetn,
    s_axi_rready,
    Q,
    s_axi_arlen,
    s_axi_araddr_1_sp_1,
    s_axi_arvalid,
    s_axi_arlen_1_sp_1,
    \gaxi_full_sm.arlen_cntr_reg[6]_0 ,
    s_axi_arid,
    \grid.ar_id_r_reg[11]_0 ,
    s_axi_araddr_2_sp_1,
    s_axi_araddr,
    \s_axi_arsize[2] ,
    s_axi_arlen_5_sp_1,
    s_axi_arlen_2_sp_1,
    \gaxi_full_sm.arlen_cntr_reg[4] ,
    \gaxi_full_sm.arlen_cntr_reg[3]_0 ,
    \gaxi_full_sm.arlen_cntr_reg[2] ,
    \s_axi_arsize[0] ,
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] ,
    \gaxi_full_sm.arlen_cntr_reg[6]_1 ,
    s_axi_arburst,
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 ,
    addr_cnt_enb_r,
    bmg_address_inc_c,
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] );
  output s_axi_arready;
  output [0:0]SR;
  output s_axi_rvalid;
  output s_axi_rlast;
  output [0:0]\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] ;
  output \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ;
  output \gaxi_full_sm.outstanding_read_r_reg_0 ;
  output \FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ;
  output \gaxi_full_sm.arlen_cntr_reg[7] ;
  output \gaxi_full_sm.arlen_cntr_reg[6] ;
  output \gaxi_full_sm.arlen_cntr_reg[3] ;
  output [3:0]D;
  output [7:0]\gaxi_full_sm.arlen_cntr_reg[7]_0 ;
  output \grid.ar_id_r_reg[11] ;
  output [11:0]\grid.S_AXI_RID_reg[11] ;
  output [0:0]E;
  output [0:0]\gaxi_full_sm.arlen_cntr_reg[0] ;
  output [0:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] ;
  output [0:0]\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_1 ;
  output [11:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 ;
  output [11:0]ADDRBWRADDR;
  input s_aclk;
  input s_aresetn;
  input s_axi_rready;
  input [7:0]Q;
  input [7:0]s_axi_arlen;
  input s_axi_araddr_1_sp_1;
  input s_axi_arvalid;
  input s_axi_arlen_1_sp_1;
  input \gaxi_full_sm.arlen_cntr_reg[6]_0 ;
  input [11:0]s_axi_arid;
  input [11:0]\grid.ar_id_r_reg[11]_0 ;
  input s_axi_araddr_2_sp_1;
  input [14:0]s_axi_araddr;
  input \s_axi_arsize[2] ;
  input s_axi_arlen_5_sp_1;
  input s_axi_arlen_2_sp_1;
  input \gaxi_full_sm.arlen_cntr_reg[4] ;
  input \gaxi_full_sm.arlen_cntr_reg[3]_0 ;
  input \gaxi_full_sm.arlen_cntr_reg[2] ;
  input [0:0]\s_axi_arsize[0] ;
  input [3:0]\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] ;
  input \gaxi_full_sm.arlen_cntr_reg[6]_1 ;
  input [1:0]s_axi_arburst;
  input [11:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 ;
  input [7:0]addr_cnt_enb_r;
  input [14:3]bmg_address_inc_c;
  input [2:0]\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] ;

  wire [11:0]ADDRBWRADDR;
  wire [3:0]D;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ;
  wire [0:0]E;
  wire \FSM_sequential_gaxi_full_sm.present_state[1]_i_2__0_n_0 ;
  wire \FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ;
  wire [7:0]Q;
  wire [0:0]SR;
  wire [7:0]addr_cnt_enb_r;
  wire ar_ready_c;
  wire [14:3]bmg_address_inc_c;
  wire \gaxi_full_sm.S_AXI_RLAST_i_1_n_0 ;
  wire \gaxi_full_sm.ar_ready_r_i_2_n_0 ;
  wire \gaxi_full_sm.ar_ready_r_i_3_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[2]_i_2_n_0 ;
  wire [0:0]\gaxi_full_sm.arlen_cntr_reg[0] ;
  wire \gaxi_full_sm.arlen_cntr_reg[2] ;
  wire \gaxi_full_sm.arlen_cntr_reg[3] ;
  wire \gaxi_full_sm.arlen_cntr_reg[3]_0 ;
  wire \gaxi_full_sm.arlen_cntr_reg[4] ;
  wire \gaxi_full_sm.arlen_cntr_reg[6] ;
  wire \gaxi_full_sm.arlen_cntr_reg[6]_0 ;
  wire \gaxi_full_sm.arlen_cntr_reg[6]_1 ;
  wire \gaxi_full_sm.arlen_cntr_reg[7] ;
  wire [7:0]\gaxi_full_sm.arlen_cntr_reg[7]_0 ;
  wire [0:0]\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ;
  wire [0:0]\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_1 ;
  wire [0:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] ;
  wire [11:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 ;
  wire [11:0]\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[0]_i_2_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_3_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_3_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_4_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_6_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_8_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_9_n_0 ;
  wire [2:0]\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] ;
  wire [3:0]\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] ;
  wire \gaxi_full_sm.outstanding_read_r_i_1_n_0 ;
  wire \gaxi_full_sm.outstanding_read_r_reg_0 ;
  wire \gaxi_full_sm.r_valid_r_i_1_n_0 ;
  wire \gaxi_full_sm.r_valid_r_i_2_n_0 ;
  wire [11:0]\grid.S_AXI_RID_reg[11] ;
  wire \grid.ar_id_r_reg[11] ;
  wire [11:0]\grid.ar_id_r_reg[11]_0 ;
  wire [1:0]next_state;
  wire outstanding_read_r;
  (* RTL_KEEP = "yes" *) wire [1:0]present_state;
  wire s_aclk;
  wire s_aresetn;
  wire [14:0]s_axi_araddr;
  wire s_axi_araddr_1_sn_1;
  wire s_axi_araddr_2_sn_1;
  wire [1:0]s_axi_arburst;
  wire [11:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arlen_1_sn_1;
  wire s_axi_arlen_2_sn_1;
  wire s_axi_arlen_5_sn_1;
  wire s_axi_arready;
  wire [0:0]\s_axi_arsize[0] ;
  wire \s_axi_arsize[2] ;
  wire s_axi_arvalid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;

  assign s_axi_araddr_1_sn_1 = s_axi_araddr_1_sp_1;
  assign s_axi_araddr_2_sn_1 = s_axi_araddr_2_sp_1;
  assign s_axi_arlen_1_sn_1 = s_axi_arlen_1_sp_1;
  assign s_axi_arlen_2_sn_1 = s_axi_arlen_2_sp_1;
  assign s_axi_arlen_5_sn_1 = s_axi_arlen_5_sp_1;
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_16 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [11]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[14]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[14]),
        .O(ADDRBWRADDR[11]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_17 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [10]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[13]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[13]),
        .O(ADDRBWRADDR[10]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_18 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [9]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[12]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[12]),
        .O(ADDRBWRADDR[9]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_19 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [8]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[11]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[11]),
        .O(ADDRBWRADDR[8]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_20 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [7]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[10]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[10]),
        .O(ADDRBWRADDR[7]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_21 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [6]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[9]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[9]),
        .O(ADDRBWRADDR[6]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_22 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [5]),
        .I1(addr_cnt_enb_r[7]),
        .I2(s_axi_araddr[8]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[8]),
        .O(ADDRBWRADDR[5]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_23 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [4]),
        .I1(addr_cnt_enb_r[6]),
        .I2(s_axi_araddr[7]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[7]),
        .O(ADDRBWRADDR[4]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_24 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [3]),
        .I1(addr_cnt_enb_r[5]),
        .I2(s_axi_araddr[6]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[6]),
        .O(ADDRBWRADDR[3]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_25 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [2]),
        .I1(addr_cnt_enb_r[4]),
        .I2(s_axi_araddr[5]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[5]),
        .O(ADDRBWRADDR[2]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_26 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [1]),
        .I1(addr_cnt_enb_r[3]),
        .I2(s_axi_araddr[4]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[4]),
        .O(ADDRBWRADDR[1]));
  LUT5 #(
    .INIT(32'hB8BBB888)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_27 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [0]),
        .I1(addr_cnt_enb_r[2]),
        .I2(s_axi_araddr[3]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(bmg_address_inc_c[3]),
        .O(ADDRBWRADDR[0]));
  LUT5 #(
    .INIT(32'h2022FFFF)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31 
       (.I0(present_state[1]),
        .I1(outstanding_read_r),
        .I2(s_axi_rready),
        .I3(s_axi_rvalid),
        .I4(present_state[0]),
        .O(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ));
  LUT6 #(
    .INIT(64'h1110111111111111)) 
    \FSM_sequential_gaxi_full_sm.present_state[0]_i_1__0 
       (.I0(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ),
        .I1(\gaxi_full_sm.ar_ready_r_i_3_n_0 ),
        .I2(\gaxi_full_sm.ar_ready_r_i_2_n_0 ),
        .I3(outstanding_read_r),
        .I4(present_state[1]),
        .I5(present_state[0]),
        .O(next_state[0]));
  LUT6 #(
    .INIT(64'hFF00FFFFFF08FF08)) 
    \FSM_sequential_gaxi_full_sm.present_state[1]_i_1__0 
       (.I0(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .I1(s_axi_arvalid),
        .I2(present_state[0]),
        .I3(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ),
        .I4(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2__0_n_0 ),
        .I5(present_state[1]),
        .O(next_state[1]));
  LUT6 #(
    .INIT(64'h0F000F0F77447777)) 
    \FSM_sequential_gaxi_full_sm.present_state[1]_i_2__0 
       (.I0(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .I1(s_axi_arvalid),
        .I2(outstanding_read_r),
        .I3(s_axi_rready),
        .I4(s_axi_rvalid),
        .I5(present_state[0]),
        .O(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2__0_n_0 ));
  (* FSM_ENCODED_STATES = "wait_rdaddr:00,os_rd:11,rd_mem:01,reg_rdaddr:10" *) 
  (* KEEP = "yes" *) 
  FDRE \FSM_sequential_gaxi_full_sm.present_state_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(next_state[0]),
        .Q(present_state[0]),
        .R(SR));
  (* FSM_ENCODED_STATES = "wait_rdaddr:00,os_rd:11,rd_mem:01,reg_rdaddr:10" *) 
  (* KEEP = "yes" *) 
  FDRE \FSM_sequential_gaxi_full_sm.present_state_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(next_state[1]),
        .Q(present_state[1]),
        .R(SR));
  LUT5 #(
    .INIT(32'hFFFB00FB)) 
    \gaxi_full_sm.S_AXI_RLAST_i_1 
       (.I0(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ),
        .I1(\gaxi_full_sm.outstanding_read_r_reg_0 ),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ),
        .I3(\gaxi_full_sm.ar_ready_r_i_2_n_0 ),
        .I4(s_axi_rlast),
        .O(\gaxi_full_sm.S_AXI_RLAST_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hBF)) 
    \gaxi_full_sm.S_AXI_RLAST_i_2 
       (.I0(present_state[0]),
        .I1(s_axi_arvalid),
        .I2(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .O(\gaxi_full_sm.outstanding_read_r_reg_0 ));
  LUT5 #(
    .INIT(32'hD0000000)) 
    \gaxi_full_sm.S_AXI_RLAST_i_3 
       (.I0(s_axi_rvalid),
        .I1(s_axi_rready),
        .I2(outstanding_read_r),
        .I3(present_state[1]),
        .I4(present_state[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ));
  FDRE \gaxi_full_sm.S_AXI_RLAST_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxi_full_sm.S_AXI_RLAST_i_1_n_0 ),
        .Q(s_axi_rlast),
        .R(SR));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFF0008)) 
    \gaxi_full_sm.ar_ready_r_i_1 
       (.I0(present_state[0]),
        .I1(present_state[1]),
        .I2(outstanding_read_r),
        .I3(\gaxi_full_sm.ar_ready_r_i_2_n_0 ),
        .I4(\gaxi_full_sm.ar_ready_r_i_3_n_0 ),
        .I5(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ),
        .O(ar_ready_c));
  LUT2 #(
    .INIT(4'h2)) 
    \gaxi_full_sm.ar_ready_r_i_2 
       (.I0(s_axi_rvalid),
        .I1(s_axi_rready),
        .O(\gaxi_full_sm.ar_ready_r_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h2030203322332033)) 
    \gaxi_full_sm.ar_ready_r_i_3 
       (.I0(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .I1(present_state[0]),
        .I2(s_axi_rready),
        .I3(s_axi_arvalid),
        .I4(present_state[1]),
        .I5(s_axi_rvalid),
        .O(\gaxi_full_sm.ar_ready_r_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000010000000000)) 
    \gaxi_full_sm.ar_ready_r_i_4 
       (.I0(Q[7]),
        .I1(\gaxi_full_sm.arlen_cntr_reg[6] ),
        .I2(Q[6]),
        .I3(s_axi_rready),
        .I4(present_state[1]),
        .I5(present_state[0]),
        .O(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.ar_ready_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ar_ready_c),
        .Q(s_axi_arready),
        .R(SR));
  LUT5 #(
    .INIT(32'h00FF2F0D)) 
    \gaxi_full_sm.arlen_cntr[0]_i_1 
       (.I0(s_axi_arvalid),
        .I1(present_state[0]),
        .I2(Q[0]),
        .I3(s_axi_arlen[0]),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [0]));
  LUT6 #(
    .INIT(64'hB4B7B484B484B4B7)) 
    \gaxi_full_sm.arlen_cntr[1]_i_1 
       (.I0(s_axi_arlen[0]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_arlen[1]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hE1FFE100)) 
    \gaxi_full_sm.arlen_cntr[2]_i_1 
       (.I0(s_axi_arlen[1]),
        .I1(s_axi_arlen[0]),
        .I2(s_axi_arlen[2]),
        .I3(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I4(\gaxi_full_sm.arlen_cntr[2]_i_2_n_0 ),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [2]));
  LUT6 #(
    .INIT(64'hFBFBFB08080808FB)) 
    \gaxi_full_sm.arlen_cntr[2]_i_2 
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arvalid),
        .I2(present_state[0]),
        .I3(Q[1]),
        .I4(Q[0]),
        .I5(Q[2]),
        .O(\gaxi_full_sm.arlen_cntr[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB4B7B484B484B4B7)) 
    \gaxi_full_sm.arlen_cntr[3]_i_1 
       (.I0(\gaxi_full_sm.arlen_cntr_reg[3] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_arlen[3]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(\gaxi_full_sm.arlen_cntr_reg[2] ),
        .I5(Q[3]),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \gaxi_full_sm.arlen_cntr[3]_i_2 
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arlen[0]),
        .I2(s_axi_arlen[1]),
        .O(\gaxi_full_sm.arlen_cntr_reg[3] ));
  LUT6 #(
    .INIT(64'h787B78487848787B)) 
    \gaxi_full_sm.arlen_cntr[4]_i_1 
       (.I0(s_axi_arlen_2_sn_1),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_arlen[4]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(\gaxi_full_sm.arlen_cntr_reg[3]_0 ),
        .I5(Q[4]),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [4]));
  LUT6 #(
    .INIT(64'hBF40BF4FBF40B040)) 
    \gaxi_full_sm.arlen_cntr[5]_i_1 
       (.I0(s_axi_arlen[4]),
        .I1(s_axi_arlen_2_sn_1),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I3(s_axi_arlen[5]),
        .I4(\grid.ar_id_r_reg[11] ),
        .I5(\gaxi_full_sm.arlen_cntr_reg[4] ),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [5]));
  LUT6 #(
    .INIT(64'h787B78487848787B)) 
    \gaxi_full_sm.arlen_cntr[6]_i_1 
       (.I0(s_axi_arlen_5_sn_1),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_arlen[6]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(\gaxi_full_sm.arlen_cntr_reg[6] ),
        .I5(Q[6]),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [6]));
  LUT5 #(
    .INIT(32'hFFFF0100)) 
    \gaxi_full_sm.arlen_cntr[7]_i_1 
       (.I0(Q[7]),
        .I1(\gaxi_full_sm.arlen_cntr_reg[6] ),
        .I2(Q[6]),
        .I3(s_axi_rready),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] ),
        .O(\gaxi_full_sm.arlen_cntr_reg[0] ));
  LUT6 #(
    .INIT(64'hFFC300C3AAC300C3)) 
    \gaxi_full_sm.arlen_cntr[7]_i_2 
       (.I0(s_axi_arlen_1_sn_1),
        .I1(\gaxi_full_sm.arlen_cntr_reg[6]_0 ),
        .I2(Q[7]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(s_axi_arlen[7]),
        .I5(\gaxi_full_sm.arlen_cntr_reg[7] ),
        .O(\gaxi_full_sm.arlen_cntr_reg[7]_0 [7]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \gaxi_full_sm.arlen_cntr[7]_i_3 
       (.I0(Q[5]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(Q[2]),
        .I5(Q[4]),
        .O(\gaxi_full_sm.arlen_cntr_reg[6] ));
  LUT1 #(
    .INIT(2'h1)) 
    \gaxi_full_sm.aw_ready_r_i_1 
       (.I0(s_aresetn),
        .O(SR));
  LUT3 #(
    .INIT(8'h40)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[14]_i_2 
       (.I0(s_axi_rready),
        .I1(s_axi_rvalid),
        .I2(present_state[1]),
        .O(\gaxi_full_sm.arlen_cntr_reg[7] ));
  LUT6 #(
    .INIT(64'hFFFFABBBFFFFFFFF)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_1 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 ),
        .I1(\gaxi_full_sm.outstanding_read_r_reg_0 ),
        .I2(\gaxi_full_sm.ar_ready_r_i_2_n_0 ),
        .I3(present_state[1]),
        .I4(\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 ),
        .I5(s_aresetn),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] ));
  LUT5 #(
    .INIT(32'h00000400)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_2 
       (.I0(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .I1(s_axi_arburst[1]),
        .I2(s_axi_arburst[0]),
        .I3(s_axi_arvalid),
        .I4(present_state[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_1 ));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[10]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [7]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[10]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[10]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [7]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[11]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [8]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[11]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[11]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [8]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[12]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [9]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[12]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[12]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [9]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[13]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [10]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[13]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[13]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [10]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[14]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [11]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[14]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[14]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [11]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[3]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [0]),
        .I2(addr_cnt_enb_r[2]),
        .I3(s_axi_araddr[3]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[3]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [0]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[4]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [1]),
        .I2(addr_cnt_enb_r[3]),
        .I3(s_axi_araddr[4]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[4]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [1]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[5]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [2]),
        .I2(addr_cnt_enb_r[4]),
        .I3(s_axi_araddr[5]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[5]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [2]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[6]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [3]),
        .I2(addr_cnt_enb_r[5]),
        .I3(s_axi_araddr[6]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[6]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [3]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[7]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [4]),
        .I2(addr_cnt_enb_r[6]),
        .I3(s_axi_araddr[7]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[7]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [4]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[8]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [5]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[8]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[8]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [5]));
  LUT6 #(
    .INIT(64'hEF40EF45EF40EA40)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r[9]_i_1 
       (.I0(\grid.ar_id_r_reg[11] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 [6]),
        .I2(addr_cnt_enb_r[7]),
        .I3(s_axi_araddr[9]),
        .I4(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I5(bmg_address_inc_c[9]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 [6]));
  LUT6 #(
    .INIT(64'h787B78487848787B)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[0]_i_1 
       (.I0(\s_axi_arsize[0] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_araddr[0]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [0]),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[0]_i_2_n_0 ),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h47)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[0]_i_2 
       (.I0(s_axi_araddr[0]),
        .I1(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[0]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hB7B7B4B78484B484)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_1 
       (.I0(\s_axi_arsize[2] ),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_araddr[1]),
        .I3(s_axi_arvalid),
        .I4(present_state[0]),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_3_n_0 ),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hAA9A55955565AA6A)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_3 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7_n_0 ),
        .I1(s_axi_araddr[1]),
        .I2(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I3(addr_cnt_enb_r[0]),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [1]),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hB888B8BBB8BBB888)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_1 
       (.I0(s_axi_araddr_2_sn_1),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(s_axi_araddr[2]),
        .I3(\grid.ar_id_r_reg[11] ),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_3_n_0 ),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_4_n_0 ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFFEFAAEAAA8A0080)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_3 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [1]),
        .I1(s_axi_araddr[1]),
        .I2(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I3(addr_cnt_enb_r[0]),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [1]),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7_n_0 ),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h65666A66)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_4 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [2]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [2]),
        .I2(addr_cnt_enb_r[1]),
        .I3(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I4(s_axi_araddr[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h03AA00AA03AA03AA)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_1 
       (.I0(s_axi_arvalid),
        .I1(\gaxi_full_sm.arlen_cntr_reg[6]_1 ),
        .I2(present_state[1]),
        .I3(present_state[0]),
        .I4(s_axi_rready),
        .I5(s_axi_rvalid),
        .O(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] ));
  LUT5 #(
    .INIT(32'h4F4F444F)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_2 
       (.I0(s_axi_araddr_1_sn_1),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_6_n_0 ),
        .I3(s_axi_arvalid),
        .I4(present_state[0]),
        .O(D[3]));
  LUT6 #(
    .INIT(64'h000000000000BF00)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5 
       (.I0(s_axi_rready),
        .I1(s_axi_rvalid),
        .I2(present_state[1]),
        .I3(s_axi_arvalid),
        .I4(present_state[0]),
        .I5(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAAAAA995A9955555)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_6 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [3]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7_n_0 ),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_8_n_0 ),
        .I3(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [1]),
        .I4(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_9_n_0 ),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'hA808)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] [0]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [0]),
        .I2(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I3(s_axi_araddr[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_7_n_0 ));
  LUT4 #(
    .INIT(16'hFB08)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_8 
       (.I0(s_axi_araddr[1]),
        .I1(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I2(addr_cnt_enb_r[0]),
        .I3(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_9 
       (.I0(s_axi_araddr[2]),
        .I1(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_31_n_0 ),
        .I2(addr_cnt_enb_r[1]),
        .I3(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] [2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h0C00000004040000)) 
    \gaxi_full_sm.outstanding_read_r_i_1 
       (.I0(\gaxi_full_sm.outstanding_read_r_reg_0 ),
        .I1(s_axi_rvalid),
        .I2(s_axi_rready),
        .I3(outstanding_read_r),
        .I4(present_state[1]),
        .I5(present_state[0]),
        .O(\gaxi_full_sm.outstanding_read_r_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.outstanding_read_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxi_full_sm.outstanding_read_r_i_1_n_0 ),
        .Q(outstanding_read_r),
        .R(SR));
  LUT6 #(
    .INIT(64'hAAEAFFFFAAEAAAEA)) 
    \gaxi_full_sm.r_valid_r_i_1 
       (.I0(E),
        .I1(\gaxi_full_sm.r_valid_r_i_2_n_0 ),
        .I2(s_axi_arvalid),
        .I3(present_state[0]),
        .I4(s_axi_rready),
        .I5(s_axi_rvalid),
        .O(\gaxi_full_sm.r_valid_r_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \gaxi_full_sm.r_valid_r_i_2 
       (.I0(s_axi_arlen[7]),
        .I1(s_axi_arlen[4]),
        .I2(s_axi_arlen[5]),
        .I3(s_axi_arlen[3]),
        .I4(s_axi_arlen[6]),
        .I5(\gaxi_full_sm.arlen_cntr_reg[3] ),
        .O(\gaxi_full_sm.r_valid_r_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.r_valid_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxi_full_sm.r_valid_r_i_1_n_0 ),
        .Q(s_axi_rvalid),
        .R(SR));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[0]_i_1 
       (.I0(s_axi_arid[0]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [0]),
        .O(\grid.S_AXI_RID_reg[11] [0]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[10]_i_1 
       (.I0(s_axi_arid[10]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [10]),
        .O(\grid.S_AXI_RID_reg[11] [10]));
  LUT6 #(
    .INIT(64'hF300F3F3A2A2AAAA)) 
    \grid.S_AXI_RID[11]_i_1 
       (.I0(s_axi_arvalid),
        .I1(s_axi_rvalid),
        .I2(s_axi_rready),
        .I3(outstanding_read_r),
        .I4(present_state[1]),
        .I5(present_state[0]),
        .O(E));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[11]_i_2 
       (.I0(s_axi_arid[11]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [11]),
        .O(\grid.S_AXI_RID_reg[11] [11]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[1]_i_1 
       (.I0(s_axi_arid[1]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [1]),
        .O(\grid.S_AXI_RID_reg[11] [1]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[2]_i_1 
       (.I0(s_axi_arid[2]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [2]),
        .O(\grid.S_AXI_RID_reg[11] [2]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[3]_i_1 
       (.I0(s_axi_arid[3]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [3]),
        .O(\grid.S_AXI_RID_reg[11] [3]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[4]_i_1 
       (.I0(s_axi_arid[4]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [4]),
        .O(\grid.S_AXI_RID_reg[11] [4]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[5]_i_1 
       (.I0(s_axi_arid[5]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [5]),
        .O(\grid.S_AXI_RID_reg[11] [5]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[6]_i_1 
       (.I0(s_axi_arid[6]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [6]),
        .O(\grid.S_AXI_RID_reg[11] [6]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[7]_i_1 
       (.I0(s_axi_arid[7]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [7]),
        .O(\grid.S_AXI_RID_reg[11] [7]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[8]_i_1 
       (.I0(s_axi_arid[8]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [8]),
        .O(\grid.S_AXI_RID_reg[11] [8]));
  LUT6 #(
    .INIT(64'hBBBBFBBB88880888)) 
    \grid.S_AXI_RID[9]_i_1 
       (.I0(s_axi_arid[9]),
        .I1(\grid.ar_id_r_reg[11] ),
        .I2(present_state[1]),
        .I3(s_axi_rvalid),
        .I4(s_axi_rready),
        .I5(\grid.ar_id_r_reg[11]_0 [9]),
        .O(\grid.S_AXI_RID_reg[11] [9]));
  LUT2 #(
    .INIT(4'h2)) 
    \grid.ar_id_r[11]_i_1 
       (.I0(s_axi_arvalid),
        .I1(present_state[0]),
        .O(\grid.ar_id_r_reg[11] ));
endmodule

(* ORIG_REF_NAME = "blk_mem_axi_read_wrapper" *) 
module rom_32KB_axi_blk_mem_axi_read_wrapper
   (s_axi_arready,
    SS,
    s_axi_rvalid,
    s_axi_rlast,
    E,
    ADDRBWRADDR,
    s_axi_rid,
    s_aclk,
    s_aresetn,
    s_axi_rready,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arvalid,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arburst);
  output s_axi_arready;
  output [0:0]SS;
  output s_axi_rvalid;
  output s_axi_rlast;
  output [0:0]E;
  output [11:0]ADDRBWRADDR;
  output [11:0]s_axi_rid;
  input s_aclk;
  input s_aresetn;
  input s_axi_rready;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input s_axi_arvalid;
  input [11:0]s_axi_arid;
  input [14:0]s_axi_araddr;
  input [1:0]s_axi_arburst;

  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_36_n_0 ;
  wire [0:0]E;
  wire [0:0]SS;
  wire [14:1]addr_cnt_enb_r;
  wire [11:0]ar_id_r;
  wire [7:0]arlen_cntr;
  wire axi_read_fsm_n_10;
  wire axi_read_fsm_n_15;
  wire axi_read_fsm_n_16;
  wire axi_read_fsm_n_17;
  wire axi_read_fsm_n_18;
  wire axi_read_fsm_n_19;
  wire axi_read_fsm_n_20;
  wire axi_read_fsm_n_21;
  wire axi_read_fsm_n_22;
  wire axi_read_fsm_n_23;
  wire axi_read_fsm_n_24;
  wire axi_read_fsm_n_25;
  wire axi_read_fsm_n_26;
  wire axi_read_fsm_n_27;
  wire axi_read_fsm_n_28;
  wire axi_read_fsm_n_29;
  wire axi_read_fsm_n_30;
  wire axi_read_fsm_n_31;
  wire axi_read_fsm_n_32;
  wire axi_read_fsm_n_33;
  wire axi_read_fsm_n_34;
  wire axi_read_fsm_n_35;
  wire axi_read_fsm_n_37;
  wire axi_read_fsm_n_4;
  wire axi_read_fsm_n_40;
  wire axi_read_fsm_n_41;
  wire axi_read_fsm_n_42;
  wire axi_read_fsm_n_43;
  wire axi_read_fsm_n_44;
  wire axi_read_fsm_n_45;
  wire axi_read_fsm_n_46;
  wire axi_read_fsm_n_47;
  wire axi_read_fsm_n_48;
  wire axi_read_fsm_n_49;
  wire axi_read_fsm_n_5;
  wire axi_read_fsm_n_50;
  wire axi_read_fsm_n_51;
  wire axi_read_fsm_n_6;
  wire axi_read_fsm_n_7;
  wire axi_read_fsm_n_8;
  wire axi_read_fsm_n_9;
  wire [14:3]bmg_address_inc_c;
  wire \gaxi_full_sm.arlen_cntr[3]_i_3_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[4]_i_2_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[5]_i_2_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[5]_i_3_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[6]_i_2_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[7]_i_4_n_0 ;
  wire \gaxi_full_sm.arlen_cntr[7]_i_5_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[14]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[1]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[2]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[3]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[4]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[5]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[6]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_3_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[10] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[11] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[12] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[13] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[14] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[3] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[4] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[5] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[6] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[7] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[8] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[9] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.incr_en_r_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_2_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_2_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_3_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_4_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[0] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[1] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[2] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[1]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[2]_i_1_n_0 ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[0] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[1] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[2] ;
  wire \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[3] ;
  wire incr_en_r;
  wire [3:0]next_address_r;
  wire [3:0]num_of_bytes_c;
  wire p_0_in3_in;
  wire [3:3]p_2_out;
  wire p_2_out_0;
  wire s_aclk;
  wire s_aresetn;
  wire [14:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [11:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [11:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [3:3]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_CO_UNCONNECTED ;

  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32 
       (.CI(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_0 ),
        .CO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_CO_UNCONNECTED [3],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_32_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(bmg_address_inc_c[14:11]),
        .S({\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[14] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[13] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[12] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[11] }));
  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33 
       (.CI(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_0 ),
        .CO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_0 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_33_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(bmg_address_inc_c[10:7]),
        .S({\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[10] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[9] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[8] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[7] }));
  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34 
       (.CI(1'b0),
        .CO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_0 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_34_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[3] }),
        .O(bmg_address_inc_c[6:3]),
        .S({\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[6] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[5] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[4] ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_36_n_0 }));
  LUT3 #(
    .INIT(8'h6A)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_36 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[3] ),
        .I1(p_0_in3_in),
        .I2(incr_en_r),
        .O(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_36_n_0 ));
  rom_32KB_axi_blk_mem_axi_read_fsm axi_read_fsm
       (.ADDRBWRADDR(ADDRBWRADDR),
        .D(next_address_r),
        .E(E),
        .\FSM_sequential_gaxi_full_sm.present_state_reg[1]_0 (axi_read_fsm_n_7),
        .Q(arlen_cntr),
        .SR(SS),
        .addr_cnt_enb_r({addr_cnt_enb_r[14],addr_cnt_enb_r[7:1]}),
        .bmg_address_inc_c(bmg_address_inc_c),
        .\gaxi_full_sm.arlen_cntr_reg[0] (axi_read_fsm_n_37),
        .\gaxi_full_sm.arlen_cntr_reg[2] (\gaxi_full_sm.arlen_cntr[3]_i_3_n_0 ),
        .\gaxi_full_sm.arlen_cntr_reg[3] (axi_read_fsm_n_10),
        .\gaxi_full_sm.arlen_cntr_reg[3]_0 (\gaxi_full_sm.arlen_cntr[4]_i_2_n_0 ),
        .\gaxi_full_sm.arlen_cntr_reg[4] (\gaxi_full_sm.arlen_cntr[5]_i_3_n_0 ),
        .\gaxi_full_sm.arlen_cntr_reg[6] (axi_read_fsm_n_9),
        .\gaxi_full_sm.arlen_cntr_reg[6]_0 (\gaxi_full_sm.arlen_cntr[7]_i_5_n_0 ),
        .\gaxi_full_sm.arlen_cntr_reg[6]_1 (\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_3_n_0 ),
        .\gaxi_full_sm.arlen_cntr_reg[7] (axi_read_fsm_n_8),
        .\gaxi_full_sm.arlen_cntr_reg[7]_0 ({axi_read_fsm_n_15,axi_read_fsm_n_16,axi_read_fsm_n_17,axi_read_fsm_n_18,axi_read_fsm_n_19,axi_read_fsm_n_20,axi_read_fsm_n_21,axi_read_fsm_n_22}),
        .\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] (axi_read_fsm_n_4),
        .\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_0 (axi_read_fsm_n_5),
        .\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1]_1 (p_2_out_0),
        .\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] (p_2_out),
        .\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_0 ({axi_read_fsm_n_40,axi_read_fsm_n_41,axi_read_fsm_n_42,axi_read_fsm_n_43,axi_read_fsm_n_44,axi_read_fsm_n_45,axi_read_fsm_n_46,axi_read_fsm_n_47,axi_read_fsm_n_48,axi_read_fsm_n_49,axi_read_fsm_n_50,axi_read_fsm_n_51}),
        .\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14]_1 ({\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[14] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[13] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[12] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[11] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[10] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[9] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[8] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[7] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[6] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[5] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[4] ,\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[3] }),
        .\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] ({\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[2] ,\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[1] ,\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[0] }),
        .\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] ({\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[3] ,\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[2] ,\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[1] ,\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[0] }),
        .\gaxi_full_sm.outstanding_read_r_reg_0 (axi_read_fsm_n_6),
        .\grid.S_AXI_RID_reg[11] ({axi_read_fsm_n_24,axi_read_fsm_n_25,axi_read_fsm_n_26,axi_read_fsm_n_27,axi_read_fsm_n_28,axi_read_fsm_n_29,axi_read_fsm_n_30,axi_read_fsm_n_31,axi_read_fsm_n_32,axi_read_fsm_n_33,axi_read_fsm_n_34,axi_read_fsm_n_35}),
        .\grid.ar_id_r_reg[11] (axi_read_fsm_n_23),
        .\grid.ar_id_r_reg[11]_0 (ar_id_r),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_araddr_1_sp_1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_4_n_0 ),
        .s_axi_araddr_2_sp_1(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_2_n_0 ),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlen_1_sp_1(\gaxi_full_sm.arlen_cntr[7]_i_4_n_0 ),
        .s_axi_arlen_2_sp_1(\gaxi_full_sm.arlen_cntr[5]_i_2_n_0 ),
        .s_axi_arlen_5_sp_1(\gaxi_full_sm.arlen_cntr[6]_i_2_n_0 ),
        .s_axi_arready(s_axi_arready),
        .\s_axi_arsize[0] (num_of_bytes_c[0]),
        .\s_axi_arsize[2] (\gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_2_n_0 ),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \gaxi_full_sm.arlen_cntr[3]_i_3 
       (.I0(arlen_cntr[2]),
        .I1(arlen_cntr[0]),
        .I2(arlen_cntr[1]),
        .O(\gaxi_full_sm.arlen_cntr[3]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \gaxi_full_sm.arlen_cntr[4]_i_2 
       (.I0(arlen_cntr[3]),
        .I1(arlen_cntr[1]),
        .I2(arlen_cntr[0]),
        .I3(arlen_cntr[2]),
        .O(\gaxi_full_sm.arlen_cntr[4]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h0001)) 
    \gaxi_full_sm.arlen_cntr[5]_i_2 
       (.I0(s_axi_arlen[3]),
        .I1(s_axi_arlen[1]),
        .I2(s_axi_arlen[0]),
        .I3(s_axi_arlen[2]),
        .O(\gaxi_full_sm.arlen_cntr[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000001)) 
    \gaxi_full_sm.arlen_cntr[5]_i_3 
       (.I0(arlen_cntr[4]),
        .I1(arlen_cntr[2]),
        .I2(arlen_cntr[0]),
        .I3(arlen_cntr[1]),
        .I4(arlen_cntr[3]),
        .I5(arlen_cntr[5]),
        .O(\gaxi_full_sm.arlen_cntr[5]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000001)) 
    \gaxi_full_sm.arlen_cntr[6]_i_2 
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arlen[0]),
        .I2(s_axi_arlen[1]),
        .I3(s_axi_arlen[3]),
        .I4(s_axi_arlen[4]),
        .I5(s_axi_arlen[5]),
        .O(\gaxi_full_sm.arlen_cntr[6]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFE)) 
    \gaxi_full_sm.arlen_cntr[7]_i_4 
       (.I0(axi_read_fsm_n_10),
        .I1(s_axi_arlen[6]),
        .I2(s_axi_arlen[3]),
        .I3(s_axi_arlen[5]),
        .I4(s_axi_arlen[4]),
        .O(\gaxi_full_sm.arlen_cntr[7]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \gaxi_full_sm.arlen_cntr[7]_i_5 
       (.I0(arlen_cntr[6]),
        .I1(axi_read_fsm_n_9),
        .O(\gaxi_full_sm.arlen_cntr[7]_i_5_n_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \gaxi_full_sm.arlen_cntr_reg[0] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_22),
        .Q(arlen_cntr[0]),
        .S(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[1] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_21),
        .Q(arlen_cntr[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[2] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_20),
        .Q(arlen_cntr[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[3] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_19),
        .Q(arlen_cntr[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[4] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_18),
        .Q(arlen_cntr[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[5] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_17),
        .Q(arlen_cntr[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[6] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_16),
        .Q(arlen_cntr[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.arlen_cntr_reg[7] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_37),
        .D(axi_read_fsm_n_15),
        .Q(arlen_cntr[7]),
        .R(SS));
  LUT6 #(
    .INIT(64'hAAAABBBAAAAAAAAA)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[14]_i_1 
       (.I0(p_2_out_0),
        .I1(axi_read_fsm_n_5),
        .I2(axi_read_fsm_n_6),
        .I3(axi_read_fsm_n_8),
        .I4(axi_read_fsm_n_7),
        .I5(addr_cnt_enb_r[14]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000004)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[1]_i_1 
       (.I0(s_axi_arlen[2]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I2(s_axi_arsize[2]),
        .I3(s_axi_arsize[1]),
        .I4(s_axi_arsize[0]),
        .I5(s_axi_arlen[1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000400000404)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[2]_i_1 
       (.I0(s_axi_arlen[2]),
        .I1(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I2(s_axi_arsize[2]),
        .I3(s_axi_arlen[1]),
        .I4(s_axi_arsize[1]),
        .I5(s_axi_arsize[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000001000007050)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[3]_i_1 
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arsize[0]),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I3(s_axi_arlen[1]),
        .I4(s_axi_arsize[2]),
        .I5(s_axi_arsize[1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h000002AF0000222F)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[4]_i_1 
       (.I0(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I1(s_axi_arlen[2]),
        .I2(s_axi_arsize[0]),
        .I3(s_axi_arsize[1]),
        .I4(s_axi_arsize[2]),
        .I5(s_axi_arlen[1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h030003007300FFFF)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[5]_i_1 
       (.I0(s_axi_arsize[0]),
        .I1(s_axi_arlen[2]),
        .I2(s_axi_arlen[1]),
        .I3(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I4(s_axi_arsize[1]),
        .I5(s_axi_arsize[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0FFF0F7F00770077)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[6]_i_1 
       (.I0(s_axi_arsize[1]),
        .I1(s_axi_arsize[0]),
        .I2(s_axi_arlen[2]),
        .I3(s_axi_arsize[2]),
        .I4(s_axi_arlen[1]),
        .I5(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hD0FF)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_3 
       (.I0(s_axi_arlen[2]),
        .I1(s_axi_arlen[1]),
        .I2(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ),
        .I3(s_axi_arsize[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000010000)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4 
       (.I0(s_axi_arlen[6]),
        .I1(s_axi_arlen[3]),
        .I2(s_axi_arlen[5]),
        .I3(s_axi_arlen[4]),
        .I4(s_axi_arlen[0]),
        .I5(s_axi_arlen[7]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[14] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[14]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[14]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[1] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[1]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[1]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[2] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[2]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[2]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[3] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[3]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[3]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[4] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[4]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[4]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[5] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[5]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[5]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[6] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[6]_i_1_n_0 ),
        .Q(addr_cnt_enb_r[6]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r_reg[7] 
       (.C(s_aclk),
        .CE(p_2_out_0),
        .D(\gaxi_full_sm.gaxifull_mem_slave.addr_cnt_enb_r[7]_i_3_n_0 ),
        .Q(addr_cnt_enb_r[7]),
        .R(axi_read_fsm_n_4));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[10] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_44),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[10] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[11] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_43),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[11] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[12] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_42),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[12] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[13] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_41),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[13] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[14] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_40),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[14] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[3] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_51),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[3] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[4] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_50),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[4] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[5] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_49),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[5] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[6] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_48),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[6] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[7] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_47),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[7] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[8] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_46),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[8] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg[9] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(axi_read_fsm_n_45),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.bmg_address_r_reg_n_0_[9] ),
        .R(SS));
  LUT2 #(
    .INIT(4'hE)) 
    \gaxi_full_sm.gaxifull_mem_slave.incr_en_r_i_1 
       (.I0(s_axi_arburst[1]),
        .I1(s_axi_arburst[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.incr_en_r_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.incr_en_r_reg 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(\gaxi_full_sm.gaxifull_mem_slave.incr_en_r_i_1_n_0 ),
        .Q(incr_en_r),
        .R(SS));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT4 #(
    .INIT(16'hFFF1)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_2 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_arsize[0]),
        .I2(s_axi_arsize[1]),
        .I3(s_axi_arsize[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFF03700000FC8)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_2 
       (.I0(s_axi_araddr[0]),
        .I1(s_axi_araddr[1]),
        .I2(s_axi_arsize[0]),
        .I3(s_axi_arsize[1]),
        .I4(s_axi_arsize[2]),
        .I5(s_axi_araddr[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h0002)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_3 
       (.I0(s_axi_rready),
        .I1(arlen_cntr[6]),
        .I2(axi_read_fsm_n_9),
        .I3(arlen_cntr[7]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hF0F7F1F7F3F7F3F7)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_4 
       (.I0(s_axi_arsize[0]),
        .I1(s_axi_arsize[1]),
        .I2(s_axi_arsize[2]),
        .I3(s_axi_araddr[2]),
        .I4(s_axi_araddr[0]),
        .I5(s_axi_araddr[1]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.next_address_r[3]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[0] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(next_address_r[0]),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[0] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[1] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(next_address_r[1]),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[1] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[2] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(next_address_r[2]),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg_n_0_[2] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.next_address_r_reg[3] 
       (.C(s_aclk),
        .CE(p_2_out),
        .D(next_address_r[3]),
        .Q(p_0_in3_in),
        .R(SS));
  LUT3 #(
    .INIT(8'h01)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[0]_i_1 
       (.I0(s_axi_arsize[2]),
        .I1(s_axi_arsize[1]),
        .I2(s_axi_arsize[0]),
        .O(num_of_bytes_c[0]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[1]_i_1 
       (.I0(s_axi_arsize[2]),
        .I1(s_axi_arsize[1]),
        .I2(s_axi_arsize[0]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h04)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[2]_i_1 
       (.I0(s_axi_arsize[0]),
        .I1(s_axi_arsize[1]),
        .I2(s_axi_arsize[2]),
        .O(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[3]_i_1 
       (.I0(s_axi_arsize[0]),
        .I1(s_axi_arsize[1]),
        .I2(s_axi_arsize[2]),
        .O(num_of_bytes_c[3]));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[0] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(num_of_bytes_c[0]),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[0] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[1] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[1]_i_1_n_0 ),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[1] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[2] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r[2]_i_1_n_0 ),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[2] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg[3] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(num_of_bytes_c[3]),
        .Q(\gaxi_full_sm.gaxifull_mem_slave.num_of_bytes_r_reg_n_0_[3] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[0] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_35),
        .Q(s_axi_rid[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[10] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_25),
        .Q(s_axi_rid[10]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[11] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_24),
        .Q(s_axi_rid[11]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[1] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_34),
        .Q(s_axi_rid[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[2] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_33),
        .Q(s_axi_rid[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[3] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_32),
        .Q(s_axi_rid[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[4] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_31),
        .Q(s_axi_rid[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[5] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_30),
        .Q(s_axi_rid[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[6] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_29),
        .Q(s_axi_rid[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[7] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_28),
        .Q(s_axi_rid[7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[8] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_27),
        .Q(s_axi_rid[8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.S_AXI_RID_reg[9] 
       (.C(s_aclk),
        .CE(E),
        .D(axi_read_fsm_n_26),
        .Q(s_axi_rid[9]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[0] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[0]),
        .Q(ar_id_r[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[10] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[10]),
        .Q(ar_id_r[10]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[11] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[11]),
        .Q(ar_id_r[11]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[1] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[1]),
        .Q(ar_id_r[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[2] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[2]),
        .Q(ar_id_r[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[3] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[3]),
        .Q(ar_id_r[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[4] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[4]),
        .Q(ar_id_r[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[5] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[5]),
        .Q(ar_id_r[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[6] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[6]),
        .Q(ar_id_r[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[7] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[7]),
        .Q(ar_id_r[7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[8] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[8]),
        .Q(ar_id_r[8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \grid.ar_id_r_reg[9] 
       (.C(s_aclk),
        .CE(axi_read_fsm_n_23),
        .D(s_axi_arid[9]),
        .Q(ar_id_r[9]),
        .R(SS));
endmodule

(* ORIG_REF_NAME = "blk_mem_axi_write_fsm" *) 
module rom_32KB_axi_blk_mem_axi_write_fsm
   (out,
    s_axi_awready,
    s_axi_wready,
    SR,
    \gaxif_wlast_gen.awlen_cntr_r_reg[7] ,
    \gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ,
    bvalid_c,
    E,
    \gaxif_ms_addr_gen.bmg_address_r_reg[3] ,
    D,
    \gaxif_wlast_gen.awlen_cntr_r_reg[6] ,
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[3] ,
    \gaxif_ms_addr_gen.next_address_r_reg[3] ,
    \gaxif_ms_addr_gen.bmg_address_r_reg[14] ,
    \gaxif_ms_addr_gen.incr_en_r_reg ,
    I6,
    ENA_I,
    \gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] ,
    \gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] ,
    SS,
    s_aclk,
    s_axi_awvalid,
    s_axi_awburst_1_sp_1,
    s_aresetn,
    s_axi_wvalid,
    s_axi_bready,
    s_axi_awlen,
    \gaxif_wlast_gen.awlen_cntr_r_reg[6]_0 ,
    Q,
    \gaxif_wlast_gen.awlen_cntr_r_reg[4] ,
    \gaxif_wlast_gen.awlen_cntr_r_reg[3] ,
    \gaxif_wlast_gen.awlen_cntr_r_reg[2] ,
    \gaxif_wlast_gen.awlen_cntr_r_reg[1] ,
    s_axi_awburst,
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[2] ,
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[3] ,
    s_axi_awaddr,
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[0] ,
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[0]_0 ,
    \gaxif_ms_addr_gen.next_address_r_reg[0] ,
    ADDRARDADDR,
    \bvalid_count_r_reg[0] ,
    \bvalid_count_r_reg[2] ,
    \bvalid_count_r_reg[1] ,
    ENA_dly_D,
    ADDRD);
  output [0:0]out;
  output s_axi_awready;
  output s_axi_wready;
  output [0:0]SR;
  output \gaxif_wlast_gen.awlen_cntr_r_reg[7] ;
  output \gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ;
  output bvalid_c;
  output [0:0]E;
  output [0:0]\gaxif_ms_addr_gen.bmg_address_r_reg[3] ;
  output [7:0]D;
  output \gaxif_wlast_gen.awlen_cntr_r_reg[6] ;
  output [0:0]\gaxif_ms_addr_gen.addr_cnt_enb_reg[3] ;
  output [3:0]\gaxif_ms_addr_gen.next_address_r_reg[3] ;
  output [11:0]\gaxif_ms_addr_gen.bmg_address_r_reg[14] ;
  output [0:0]\gaxif_ms_addr_gen.incr_en_r_reg ;
  output I6;
  output ENA_I;
  output \gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] ;
  output \gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] ;
  input [0:0]SS;
  input s_aclk;
  input s_axi_awvalid;
  input s_axi_awburst_1_sp_1;
  input s_aresetn;
  input s_axi_wvalid;
  input s_axi_bready;
  input [7:0]s_axi_awlen;
  input \gaxif_wlast_gen.awlen_cntr_r_reg[6]_0 ;
  input [7:0]Q;
  input \gaxif_wlast_gen.awlen_cntr_r_reg[4] ;
  input \gaxif_wlast_gen.awlen_cntr_r_reg[3] ;
  input \gaxif_wlast_gen.awlen_cntr_r_reg[2] ;
  input \gaxif_wlast_gen.awlen_cntr_r_reg[1] ;
  input [1:0]s_axi_awburst;
  input \gaxif_ms_addr_gen.num_of_bytes_r_reg[2] ;
  input [1:0]\gaxif_ms_addr_gen.num_of_bytes_r_reg[3] ;
  input [14:0]s_axi_awaddr;
  input \gaxif_ms_addr_gen.num_of_bytes_r_reg[0] ;
  input \gaxif_ms_addr_gen.num_of_bytes_r_reg[0]_0 ;
  input [0:0]\gaxif_ms_addr_gen.next_address_r_reg[0] ;
  input [11:0]ADDRARDADDR;
  input \bvalid_count_r_reg[0] ;
  input \bvalid_count_r_reg[2] ;
  input \bvalid_count_r_reg[1] ;
  input ENA_dly_D;
  input [1:0]ADDRD;

  wire [11:0]ADDRARDADDR;
  wire [1:0]ADDRD;
  wire [7:0]D;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly_D;
  wire \FSM_sequential_gaxi_full_sm.present_state[0]_i_2_n_0 ;
  wire \FSM_sequential_gaxi_full_sm.present_state[0]_i_3_n_0 ;
  wire \FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ;
  wire I6;
  wire [7:0]Q;
  wire [0:0]SR;
  wire [0:0]SS;
  wire aw_ready_c;
  wire bvalid_c;
  wire \bvalid_count_r_reg[0] ;
  wire \bvalid_count_r_reg[1] ;
  wire \bvalid_count_r_reg[2] ;
  wire \gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] ;
  wire \gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] ;
  wire \gaxi_full_sm.aw_ready_r_i_3_n_0 ;
  wire [0:0]\gaxif_ms_addr_gen.addr_cnt_enb_reg[3] ;
  wire [11:0]\gaxif_ms_addr_gen.bmg_address_r_reg[14] ;
  wire [0:0]\gaxif_ms_addr_gen.bmg_address_r_reg[3] ;
  wire [0:0]\gaxif_ms_addr_gen.incr_en_r_reg ;
  wire [0:0]\gaxif_ms_addr_gen.next_address_r_reg[0] ;
  wire [3:0]\gaxif_ms_addr_gen.next_address_r_reg[3] ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg[0] ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg[0]_0 ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg[2] ;
  wire [1:0]\gaxif_ms_addr_gen.num_of_bytes_r_reg[3] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[1] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[2] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[3] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[4] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[6] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[6]_0 ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[7] ;
  wire \gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ;
  wire [1:0]next_state;
  (* RTL_KEEP = "yes" *) wire [0:0]out;
  (* RTL_KEEP = "yes" *) wire [1:1]present_state;
  wire s_aclk;
  wire s_aresetn;
  wire [14:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire s_axi_awburst_1_sn_1;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire w_ready_c;

  assign s_axi_awburst_1_sn_1 = s_axi_awburst_1_sp_1;
  LUT4 #(
    .INIT(16'hAEEA)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_1 
       (.I0(ENA_dly_D),
        .I1(s_axi_wvalid),
        .I2(present_state),
        .I3(out),
        .O(ENA_I));
  LUT6 #(
    .INIT(64'hAAAABAAABFAFAAAA)) 
    \FSM_sequential_gaxi_full_sm.present_state[0]_i_1 
       (.I0(\FSM_sequential_gaxi_full_sm.present_state[0]_i_2_n_0 ),
        .I1(\FSM_sequential_gaxi_full_sm.present_state[0]_i_3_n_0 ),
        .I2(s_axi_wvalid),
        .I3(\gaxi_full_sm.aw_ready_r_i_3_n_0 ),
        .I4(out),
        .I5(present_state),
        .O(next_state[0]));
  LUT5 #(
    .INIT(32'h55000030)) 
    \FSM_sequential_gaxi_full_sm.present_state[0]_i_2 
       (.I0(s_axi_bready),
        .I1(s_axi_wvalid),
        .I2(s_axi_awvalid),
        .I3(out),
        .I4(present_state),
        .O(\FSM_sequential_gaxi_full_sm.present_state[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \FSM_sequential_gaxi_full_sm.present_state[0]_i_3 
       (.I0(Q[7]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg[6] ),
        .I2(Q[6]),
        .O(\FSM_sequential_gaxi_full_sm.present_state[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h3F0A3FAA30003FA0)) 
    \FSM_sequential_gaxi_full_sm.present_state[1]_i_1 
       (.I0(s_axi_wvalid),
        .I1(s_axi_bready),
        .I2(out),
        .I3(present_state),
        .I4(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I5(s_axi_awvalid),
        .O(next_state[1]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT4 #(
    .INIT(16'hA8AA)) 
    \FSM_sequential_gaxi_full_sm.present_state[1]_i_2 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ),
        .I1(\bvalid_count_r_reg[1] ),
        .I2(\bvalid_count_r_reg[2] ),
        .I3(\bvalid_count_r_reg[0] ),
        .O(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ));
  (* FSM_ENCODED_STATES = "os_wr:01,reg_wraddr:10,wr_mem:11,wait_wraddr:00" *) 
  (* KEEP = "yes" *) 
  FDRE \FSM_sequential_gaxi_full_sm.present_state_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(next_state[0]),
        .Q(out),
        .R(SS));
  (* FSM_ENCODED_STATES = "os_wr:01,reg_wraddr:10,wr_mem:11,wait_wraddr:00" *) 
  (* KEEP = "yes" *) 
  FDRE \FSM_sequential_gaxi_full_sm.present_state_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(next_state[1]),
        .Q(present_state),
        .R(SS));
  LUT2 #(
    .INIT(4'h8)) 
    \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_i_1 
       (.I0(s_axi_awready),
        .I1(s_axi_awvalid),
        .O(I6));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \gaxi_bid_gen.bvalid_wr_cnt_r[0]_i_1 
       (.I0(bvalid_c),
        .I1(ADDRD[0]),
        .O(\gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h78)) 
    \gaxi_bid_gen.bvalid_wr_cnt_r[1]_i_1 
       (.I0(ADDRD[0]),
        .I1(bvalid_c),
        .I2(ADDRD[1]),
        .O(\gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] ));
  LUT6 #(
    .INIT(64'h0000000000000028)) 
    \gaxi_bvalid_id_r.bvalid_d1_c_i_1 
       (.I0(s_axi_wvalid),
        .I1(present_state),
        .I2(out),
        .I3(Q[6]),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg[6] ),
        .I5(Q[7]),
        .O(bvalid_c));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFFFE)) 
    \gaxi_bvalid_id_r.bvalid_d1_c_i_2 
       (.I0(Q[5]),
        .I1(Q[3]),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(Q[2]),
        .I5(Q[4]),
        .O(\gaxif_wlast_gen.awlen_cntr_r_reg[6] ));
  LUT6 #(
    .INIT(64'hF4444444F44444FF)) 
    \gaxi_full_sm.aw_ready_r_i_2 
       (.I0(\gaxi_full_sm.aw_ready_r_i_3_n_0 ),
        .I1(bvalid_c),
        .I2(s_axi_bready),
        .I3(out),
        .I4(present_state),
        .I5(s_axi_awvalid),
        .O(aw_ready_c));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \gaxi_full_sm.aw_ready_r_i_3 
       (.I0(\bvalid_count_r_reg[0] ),
        .I1(\bvalid_count_r_reg[2] ),
        .I2(\bvalid_count_r_reg[1] ),
        .O(\gaxi_full_sm.aw_ready_r_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.aw_ready_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(aw_ready_c),
        .Q(s_axi_awready),
        .R(SS));
  LUT5 #(
    .INIT(32'h000F2FAA)) 
    \gaxi_full_sm.w_ready_r_i_1 
       (.I0(s_axi_awvalid),
        .I1(\gaxi_full_sm.aw_ready_r_i_3_n_0 ),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ),
        .I3(present_state),
        .I4(out),
        .O(w_ready_c));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'h0002)) 
    \gaxi_full_sm.w_ready_r_i_2 
       (.I0(s_axi_wvalid),
        .I1(Q[6]),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg[6] ),
        .I3(Q[7]),
        .O(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_full_sm.w_ready_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(w_ready_c),
        .Q(s_axi_wready),
        .R(SS));
  LUT6 #(
    .INIT(64'hFFBF0000FFFFFFFF)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_1 
       (.I0(out),
        .I1(s_axi_awvalid),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ),
        .I3(s_axi_awburst_1_sn_1),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ),
        .I5(s_aresetn),
        .O(SR));
  LUT6 #(
    .INIT(64'h0000000040440000)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_2 
       (.I0(out),
        .I1(s_axi_awvalid),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(present_state),
        .I4(s_axi_awburst[1]),
        .I5(s_axi_awburst[0]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb_reg[3] ));
  LUT5 #(
    .INIT(32'hFD00FFFF)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_4 
       (.I0(\bvalid_count_r_reg[0] ),
        .I1(\bvalid_count_r_reg[2] ),
        .I2(\bvalid_count_r_reg[1] ),
        .I3(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ),
        .I4(present_state),
        .O(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[10]_i_1 
       (.I0(s_axi_awaddr[10]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[7]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [7]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[11]_i_1 
       (.I0(s_axi_awaddr[11]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[8]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [8]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[12]_i_1 
       (.I0(s_axi_awaddr[12]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[9]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [9]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[13]_i_1 
       (.I0(s_axi_awaddr[13]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[10]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [10]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[14]_i_1 
       (.I0(s_axi_awaddr[14]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[11]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [11]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[3]_i_1 
       (.I0(s_axi_awaddr[3]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[0]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [0]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[4]_i_1 
       (.I0(s_axi_awaddr[4]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[1]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [1]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[5]_i_1 
       (.I0(s_axi_awaddr[5]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[2]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [2]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[6]_i_1 
       (.I0(s_axi_awaddr[6]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[3]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [3]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[7]_i_1 
       (.I0(s_axi_awaddr[7]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[4]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [4]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[8]_i_1 
       (.I0(s_axi_awaddr[8]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[5]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [5]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.bmg_address_r[9]_i_1 
       (.I0(s_axi_awaddr[9]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(ADDRARDADDR[6]),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[14] [6]));
  LUT6 #(
    .INIT(64'h0080FFBFFFBF0080)) 
    \gaxif_ms_addr_gen.next_address_r[0]_i_1 
       (.I0(s_axi_awaddr[0]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ),
        .I2(s_axi_awvalid),
        .I3(out),
        .I4(\gaxif_ms_addr_gen.next_address_r_reg[0] ),
        .I5(\gaxif_ms_addr_gen.num_of_bytes_r_reg[3] [0]),
        .O(\gaxif_ms_addr_gen.next_address_r_reg[3] [0]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.next_address_r[1]_i_1 
       (.I0(s_axi_awaddr[1]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_ms_addr_gen.num_of_bytes_r_reg[0]_0 ),
        .O(\gaxif_ms_addr_gen.next_address_r_reg[3] [1]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_ms_addr_gen.next_address_r[2]_i_1 
       (.I0(s_axi_awaddr[2]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_ms_addr_gen.num_of_bytes_r_reg[0] ),
        .O(\gaxif_ms_addr_gen.next_address_r_reg[3] [2]));
  LUT6 #(
    .INIT(64'h0FFA002A000A000A)) 
    \gaxif_ms_addr_gen.next_address_r[3]_i_1 
       (.I0(s_axi_awvalid),
        .I1(\gaxi_full_sm.aw_ready_r_i_3_n_0 ),
        .I2(present_state),
        .I3(out),
        .I4(\FSM_sequential_gaxi_full_sm.present_state[0]_i_3_n_0 ),
        .I5(s_axi_wvalid),
        .O(\gaxif_ms_addr_gen.bmg_address_r_reg[3] ));
  LUT6 #(
    .INIT(64'h6066666660666066)) 
    \gaxif_ms_addr_gen.next_address_r[3]_i_2 
       (.I0(\gaxif_ms_addr_gen.num_of_bytes_r_reg[2] ),
        .I1(\gaxif_ms_addr_gen.num_of_bytes_r_reg[3] [1]),
        .I2(out),
        .I3(s_axi_awvalid),
        .I4(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I5(present_state),
        .O(\gaxif_ms_addr_gen.next_address_r_reg[3] [3]));
  LUT4 #(
    .INIT(16'h00D0)) 
    \gaxif_ms_addr_gen.num_of_bytes_r[3]_i_1 
       (.I0(present_state),
        .I1(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I2(s_axi_awvalid),
        .I3(out),
        .O(\gaxif_ms_addr_gen.incr_en_r_reg ));
  LUT6 #(
    .INIT(64'h0000A200FFFFAEFF)) 
    \gaxif_wlast_gen.awlen_cntr_r[0]_i_1 
       (.I0(s_axi_awlen[0]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(Q[0]),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hFFBF00800080FFBF)) 
    \gaxif_wlast_gen.awlen_cntr_r[1]_i_1 
       (.I0(s_axi_awlen[1]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ),
        .I2(s_axi_awvalid),
        .I3(out),
        .I4(Q[1]),
        .I5(Q[0]),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_wlast_gen.awlen_cntr_r[2]_i_1 
       (.I0(s_axi_awlen[2]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_wlast_gen.awlen_cntr_r_reg[1] ),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_wlast_gen.awlen_cntr_r[3]_i_1 
       (.I0(s_axi_awlen[3]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_wlast_gen.awlen_cntr_r_reg[2] ),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_wlast_gen.awlen_cntr_r[4]_i_1 
       (.I0(s_axi_awlen[4]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_wlast_gen.awlen_cntr_r_reg[3] ),
        .O(D[4]));
  LUT6 #(
    .INIT(64'hFFFFAEFF0000A200)) 
    \gaxif_wlast_gen.awlen_cntr_r[5]_i_1 
       (.I0(s_axi_awlen[5]),
        .I1(present_state),
        .I2(\FSM_sequential_gaxi_full_sm.present_state[1]_i_2_n_0 ),
        .I3(s_axi_awvalid),
        .I4(out),
        .I5(\gaxif_wlast_gen.awlen_cntr_r_reg[4] ),
        .O(D[5]));
  LUT6 #(
    .INIT(64'hFFBF00800080FFBF)) 
    \gaxif_wlast_gen.awlen_cntr_r[6]_i_1 
       (.I0(s_axi_awlen[6]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ),
        .I2(s_axi_awvalid),
        .I3(out),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg[6] ),
        .I5(Q[6]),
        .O(D[6]));
  LUT2 #(
    .INIT(4'hE)) 
    \gaxif_wlast_gen.awlen_cntr_r[7]_i_1 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 ),
        .I1(\gaxif_ms_addr_gen.bmg_address_r_reg[3] ),
        .O(E));
  LUT6 #(
    .INIT(64'hFFBF00800080FFBF)) 
    \gaxif_wlast_gen.awlen_cntr_r[7]_i_2 
       (.I0(s_axi_awlen[7]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg[7] ),
        .I2(s_axi_awvalid),
        .I3(out),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg[6]_0 ),
        .I5(Q[7]),
        .O(D[7]));
endmodule

(* ORIG_REF_NAME = "blk_mem_axi_write_wrapper" *) 
module rom_32KB_axi_blk_mem_axi_write_wrapper
   (s_axi_awready,
    s_axi_wready,
    s_axi_bvalid,
    ADDRARDADDR,
    ENA_I,
    s_axi_bid,
    SS,
    s_aclk,
    s_axi_awvalid,
    s_aresetn,
    s_axi_awsize,
    s_axi_awlen,
    s_axi_wvalid,
    s_axi_bready,
    s_axi_awburst,
    s_axi_awaddr,
    ENA_dly_D,
    s_axi_awid);
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_bvalid;
  output [11:0]ADDRARDADDR;
  output ENA_I;
  output [11:0]s_axi_bid;
  input [0:0]SS;
  input s_aclk;
  input s_axi_awvalid;
  input s_aresetn;
  input [2:0]s_axi_awsize;
  input [7:0]s_axi_awlen;
  input s_axi_wvalid;
  input s_axi_bready;
  input [1:0]s_axi_awburst;
  input [14:0]s_axi_awaddr;
  input ENA_dly_D;
  input [11:0]s_axi_awid;

  wire [11:0]ADDRARDADDR;
  wire [1:0]CONV_INTEGER;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_0 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_1 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_2 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_3 ;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_35_n_0 ;
  wire ENA_I;
  wire ENA_dly_D;
  wire [0:0]SS;
  wire addr_en_c;
  wire axi_wr_fsm_n_0;
  wire axi_wr_fsm_n_17;
  wire axi_wr_fsm_n_23;
  wire axi_wr_fsm_n_24;
  wire axi_wr_fsm_n_25;
  wire axi_wr_fsm_n_26;
  wire axi_wr_fsm_n_27;
  wire axi_wr_fsm_n_28;
  wire axi_wr_fsm_n_29;
  wire axi_wr_fsm_n_3;
  wire axi_wr_fsm_n_30;
  wire axi_wr_fsm_n_31;
  wire axi_wr_fsm_n_32;
  wire axi_wr_fsm_n_33;
  wire axi_wr_fsm_n_34;
  wire axi_wr_fsm_n_36;
  wire axi_wr_fsm_n_38;
  wire axi_wr_fsm_n_39;
  wire axi_wr_fsm_n_4;
  wire axi_wr_fsm_n_5;
  wire axi_wr_fsm_n_7;
  wire axi_wr_fsm_n_8;
  wire [14:3]bmg_address_r;
  wire bvalid_c;
  wire \bvalid_count_r[0]_i_1_n_0 ;
  wire \bvalid_count_r[1]_i_1_n_0 ;
  wire \bvalid_count_r[2]_i_1_n_0 ;
  wire \bvalid_count_r_reg_n_0_[0] ;
  wire \bvalid_count_r_reg_n_0_[1] ;
  wire \bvalid_count_r_reg_n_0_[2] ;
  wire bvalid_d1_c;
  wire [1:0]bvalid_rd_cnt_r;
  wire [1:0]bvalid_wr_cnt_r;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_0 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_1 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_2 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_3 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_4 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_5 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_0 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_1 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_2 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_3 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_4 ;
  wire \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_5 ;
  wire \gaxi_bvalid_id_r.bvalid_r_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[14]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[3]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[4]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[5]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[6]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_3_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_5_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[3] ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[4] ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[5] ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[6] ;
  wire \gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[7] ;
  wire \gaxif_ms_addr_gen.next_address_r[1]_i_2_n_0 ;
  wire \gaxif_ms_addr_gen.next_address_r[2]_i_2_n_0 ;
  wire \gaxif_ms_addr_gen.next_address_r[3]_i_3_n_0 ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r[1]_i_1_n_0 ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[1] ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[2] ;
  wire \gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[3] ;
  wire \gaxif_wlast_gen.awlen_cntr_r[2]_i_2_n_0 ;
  wire \gaxif_wlast_gen.awlen_cntr_r[3]_i_2_n_0 ;
  wire \gaxif_wlast_gen.awlen_cntr_r[4]_i_2_n_0 ;
  wire \gaxif_wlast_gen.awlen_cntr_r[5]_i_2_n_0 ;
  wire \gaxif_wlast_gen.awlen_cntr_r[7]_i_3_n_0 ;
  wire [7:0]\gaxif_wlast_gen.awlen_cntr_r_reg__0 ;
  wire incr_en_r;
  wire [3:0]next_address_r;
  wire [3:0]num_of_bytes_c;
  wire [7:0]p_0_in;
  wire p_0_in5_in;
  wire p_0_out;
  wire [2:0]p_1_in;
  wire [14:3]p_1_in__0;
  wire p_4_out;
  wire s_aclk;
  wire s_aresetn;
  wire [14:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [11:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [11:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire s_axi_wready;
  wire s_axi_wvalid;
  wire [3:3]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_CO_UNCONNECTED ;
  wire [1:0]\NLW_gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_DOD_UNCONNECTED ;
  wire [1:0]\NLW_gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_DOD_UNCONNECTED ;

  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_10 
       (.I0(bmg_address_r[8]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[8]),
        .O(ADDRARDADDR[5]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_11 
       (.I0(bmg_address_r[7]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[7] ),
        .I2(p_1_in__0[7]),
        .O(ADDRARDADDR[4]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_12 
       (.I0(bmg_address_r[6]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[6] ),
        .I2(p_1_in__0[6]),
        .O(ADDRARDADDR[3]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_13 
       (.I0(bmg_address_r[5]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[5] ),
        .I2(p_1_in__0[5]),
        .O(ADDRARDADDR[2]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_14 
       (.I0(bmg_address_r[4]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[4] ),
        .I2(p_1_in__0[4]),
        .O(ADDRARDADDR[1]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_15 
       (.I0(bmg_address_r[3]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[3] ),
        .I2(p_1_in__0[3]),
        .O(ADDRARDADDR[0]));
  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28 
       (.CI(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_0 ),
        .CO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_CO_UNCONNECTED [3],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_28_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(p_1_in__0[14:11]),
        .S(bmg_address_r[14:11]));
  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29 
       (.CI(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_0 ),
        .CO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_0 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_29_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O(p_1_in__0[10:7]),
        .S(bmg_address_r[10:7]));
  CARRY4 \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30 
       (.CI(1'b0),
        .CO({\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_0 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_1 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_2 ,\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_30_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,bmg_address_r[3]}),
        .O(p_1_in__0[6:3]),
        .S({bmg_address_r[6:4],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_35_n_0 }));
  LUT3 #(
    .INIT(8'h6A)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_35 
       (.I0(bmg_address_r[3]),
        .I1(p_0_in5_in),
        .I2(incr_en_r),
        .O(\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_35_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_4 
       (.I0(bmg_address_r[14]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[14]),
        .O(ADDRARDADDR[11]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_5 
       (.I0(bmg_address_r[13]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[13]),
        .O(ADDRARDADDR[10]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_6 
       (.I0(bmg_address_r[12]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[12]),
        .O(ADDRARDADDR[9]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_7 
       (.I0(bmg_address_r[11]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[11]),
        .O(ADDRARDADDR[8]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_8 
       (.I0(bmg_address_r[10]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[10]),
        .O(ADDRARDADDR[7]));
  LUT3 #(
    .INIT(8'hB8)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_9 
       (.I0(bmg_address_r[9]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .I2(p_1_in__0[9]),
        .O(ADDRARDADDR[6]));
  rom_32KB_axi_blk_mem_axi_write_fsm axi_wr_fsm
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRD(bvalid_wr_cnt_r),
        .D(p_0_in),
        .E(axi_wr_fsm_n_7),
        .ENA_I(ENA_I),
        .ENA_dly_D(ENA_dly_D),
        .I6(axi_wr_fsm_n_36),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 ),
        .SR(axi_wr_fsm_n_3),
        .SS(SS),
        .bvalid_c(bvalid_c),
        .\bvalid_count_r_reg[0] (\bvalid_count_r_reg_n_0_[0] ),
        .\bvalid_count_r_reg[1] (\bvalid_count_r_reg_n_0_[1] ),
        .\bvalid_count_r_reg[2] (\bvalid_count_r_reg_n_0_[2] ),
        .\gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] (axi_wr_fsm_n_39),
        .\gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] (axi_wr_fsm_n_38),
        .\gaxif_ms_addr_gen.addr_cnt_enb_reg[3] (p_4_out),
        .\gaxif_ms_addr_gen.bmg_address_r_reg[14] ({axi_wr_fsm_n_23,axi_wr_fsm_n_24,axi_wr_fsm_n_25,axi_wr_fsm_n_26,axi_wr_fsm_n_27,axi_wr_fsm_n_28,axi_wr_fsm_n_29,axi_wr_fsm_n_30,axi_wr_fsm_n_31,axi_wr_fsm_n_32,axi_wr_fsm_n_33,axi_wr_fsm_n_34}),
        .\gaxif_ms_addr_gen.bmg_address_r_reg[3] (axi_wr_fsm_n_8),
        .\gaxif_ms_addr_gen.incr_en_r_reg (addr_en_c),
        .\gaxif_ms_addr_gen.next_address_r_reg[0] (p_1_in[0]),
        .\gaxif_ms_addr_gen.next_address_r_reg[3] (next_address_r),
        .\gaxif_ms_addr_gen.num_of_bytes_r_reg[0] (\gaxif_ms_addr_gen.next_address_r[2]_i_2_n_0 ),
        .\gaxif_ms_addr_gen.num_of_bytes_r_reg[0]_0 (\gaxif_ms_addr_gen.next_address_r[1]_i_2_n_0 ),
        .\gaxif_ms_addr_gen.num_of_bytes_r_reg[2] (\gaxif_ms_addr_gen.next_address_r[3]_i_3_n_0 ),
        .\gaxif_ms_addr_gen.num_of_bytes_r_reg[3] ({\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[3] ,\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] }),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[1] (\gaxif_wlast_gen.awlen_cntr_r[2]_i_2_n_0 ),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[2] (\gaxif_wlast_gen.awlen_cntr_r[3]_i_2_n_0 ),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[3] (\gaxif_wlast_gen.awlen_cntr_r[4]_i_2_n_0 ),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[4] (\gaxif_wlast_gen.awlen_cntr_r[5]_i_2_n_0 ),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[6] (axi_wr_fsm_n_17),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[6]_0 (\gaxif_wlast_gen.awlen_cntr_r[7]_i_3_n_0 ),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[7] (axi_wr_fsm_n_4),
        .\gaxif_wlast_gen.awlen_cntr_r_reg[7]_0 (axi_wr_fsm_n_5),
        .out(axi_wr_fsm_n_0),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awburst_1_sp_1(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_5_n_0 ),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
  LUT6 #(
    .INIT(64'hF0000FFF0FFFE000)) 
    \bvalid_count_r[0]_i_1 
       (.I0(\bvalid_count_r_reg_n_0_[2] ),
        .I1(\bvalid_count_r_reg_n_0_[1] ),
        .I2(s_axi_bready),
        .I3(s_axi_bvalid),
        .I4(bvalid_c),
        .I5(\bvalid_count_r_reg_n_0_[0] ),
        .O(\bvalid_count_r[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD52AD52ABF40BF00)) 
    \bvalid_count_r[1]_i_1 
       (.I0(bvalid_c),
        .I1(s_axi_bvalid),
        .I2(s_axi_bready),
        .I3(\bvalid_count_r_reg_n_0_[1] ),
        .I4(\bvalid_count_r_reg_n_0_[2] ),
        .I5(\bvalid_count_r_reg_n_0_[0] ),
        .O(\bvalid_count_r[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD5FF2A00FFBF0000)) 
    \bvalid_count_r[2]_i_1 
       (.I0(bvalid_c),
        .I1(s_axi_bvalid),
        .I2(s_axi_bready),
        .I3(\bvalid_count_r_reg_n_0_[1] ),
        .I4(\bvalid_count_r_reg_n_0_[2] ),
        .I5(\bvalid_count_r_reg_n_0_[0] ),
        .O(\bvalid_count_r[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_count_r_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\bvalid_count_r[0]_i_1_n_0 ),
        .Q(\bvalid_count_r_reg_n_0_[0] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_count_r_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\bvalid_count_r[1]_i_1_n_0 ),
        .Q(\bvalid_count_r_reg_n_0_[1] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_count_r_reg[2] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\bvalid_count_r[2]_i_1_n_0 ),
        .Q(\bvalid_count_r_reg_n_0_[2] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[0] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_1 ),
        .Q(s_axi_bid[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[10] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_5 ),
        .Q(s_axi_bid[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[11] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_4 ),
        .Q(s_axi_bid[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[1] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_0 ),
        .Q(s_axi_bid[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[2] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_3 ),
        .Q(s_axi_bid[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[3] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_2 ),
        .Q(s_axi_bid[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[4] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_5 ),
        .Q(s_axi_bid[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[5] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_4 ),
        .Q(s_axi_bid[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[6] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_1 ),
        .Q(s_axi_bid[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[7] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_0 ),
        .Q(s_axi_bid[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[8] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_3 ),
        .Q(s_axi_bid[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.S_AXI_BID_reg[9] 
       (.C(s_aclk),
        .CE(s_aresetn),
        .D(\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_2 ),
        .Q(s_axi_bid[9]),
        .R(1'b0));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    \gaxi_bid_gen.axi_bid_array_reg_0_3_0_5 
       (.ADDRA({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRB({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRC({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRD({1'b0,1'b0,1'b0,bvalid_wr_cnt_r}),
        .DIA(s_axi_awid[1:0]),
        .DIB(s_axi_awid[3:2]),
        .DIC(s_axi_awid[5:4]),
        .DID({1'b0,1'b0}),
        .DOA({\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_0 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_1 }),
        .DOB({\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_2 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_3 }),
        .DOC({\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_4 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_n_5 }),
        .DOD(\NLW_gaxi_bid_gen.axi_bid_array_reg_0_3_0_5_DOD_UNCONNECTED [1:0]),
        .WCLK(s_aclk),
        .WE(axi_wr_fsm_n_36));
  (* METHODOLOGY_DRC_VIOS = "" *) 
  RAM32M #(
    .INIT_A(64'h0000000000000000),
    .INIT_B(64'h0000000000000000),
    .INIT_C(64'h0000000000000000),
    .INIT_D(64'h0000000000000000)) 
    \gaxi_bid_gen.axi_bid_array_reg_0_3_6_11 
       (.ADDRA({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRB({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRC({1'b0,1'b0,1'b0,CONV_INTEGER}),
        .ADDRD({1'b0,1'b0,1'b0,bvalid_wr_cnt_r}),
        .DIA(s_axi_awid[7:6]),
        .DIB(s_axi_awid[9:8]),
        .DIC(s_axi_awid[11:10]),
        .DID({1'b0,1'b0}),
        .DOA({\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_0 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_1 }),
        .DOB({\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_2 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_3 }),
        .DOC({\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_4 ,\gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_n_5 }),
        .DOD(\NLW_gaxi_bid_gen.axi_bid_array_reg_0_3_6_11_DOD_UNCONNECTED [1:0]),
        .WCLK(s_aclk),
        .WE(axi_wr_fsm_n_36));
  LUT3 #(
    .INIT(8'h6A)) 
    \gaxi_bid_gen.bvalid_rd_cnt_r[0]_i_1 
       (.I0(bvalid_rd_cnt_r[0]),
        .I1(s_axi_bvalid),
        .I2(s_axi_bready),
        .O(CONV_INTEGER[0]));
  LUT4 #(
    .INIT(16'h6AAA)) 
    \gaxi_bid_gen.bvalid_rd_cnt_r[1]_i_1 
       (.I0(bvalid_rd_cnt_r[1]),
        .I1(s_axi_bready),
        .I2(s_axi_bvalid),
        .I3(bvalid_rd_cnt_r[0]),
        .O(CONV_INTEGER[1]));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.bvalid_rd_cnt_r_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(CONV_INTEGER[0]),
        .Q(bvalid_rd_cnt_r[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.bvalid_rd_cnt_r_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(CONV_INTEGER[1]),
        .Q(bvalid_rd_cnt_r[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.bvalid_wr_cnt_r_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(axi_wr_fsm_n_39),
        .Q(bvalid_wr_cnt_r[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bid_gen.bvalid_wr_cnt_r_reg[1] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(axi_wr_fsm_n_38),
        .Q(bvalid_wr_cnt_r[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bvalid_id_r.bvalid_d1_c_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(bvalid_c),
        .Q(bvalid_d1_c),
        .R(SS));
  LUT5 #(
    .INIT(32'hFEFFAAAA)) 
    \gaxi_bvalid_id_r.bvalid_r_i_1 
       (.I0(bvalid_d1_c),
        .I1(\bvalid_count_r_reg_n_0_[1] ),
        .I2(\bvalid_count_r_reg_n_0_[2] ),
        .I3(s_axi_bready),
        .I4(s_axi_bvalid),
        .O(\gaxi_bvalid_id_r.bvalid_r_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxi_bvalid_id_r.bvalid_r_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxi_bvalid_id_r.bvalid_r_i_1_n_0 ),
        .Q(s_axi_bvalid),
        .R(SS));
  LUT6 #(
    .INIT(64'h5555755500003000)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[14]_i_1 
       (.I0(axi_wr_fsm_n_5),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_5_n_0 ),
        .I2(axi_wr_fsm_n_4),
        .I3(s_axi_awvalid),
        .I4(axi_wr_fsm_n_0),
        .I5(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[14]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000001500010005)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[3]_i_1 
       (.I0(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ),
        .I1(s_axi_awsize[0]),
        .I2(s_axi_awlen[2]),
        .I3(s_axi_awsize[2]),
        .I4(s_axi_awsize[1]),
        .I5(s_axi_awlen[1]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0011013301010133)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[4]_i_1 
       (.I0(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ),
        .I1(s_axi_awsize[2]),
        .I2(s_axi_awlen[2]),
        .I3(s_axi_awsize[1]),
        .I4(s_axi_awsize[0]),
        .I5(s_axi_awlen[1]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[4]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000555507475757)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[5]_i_1 
       (.I0(s_axi_awsize[2]),
        .I1(s_axi_awlen[1]),
        .I2(s_axi_awlen[2]),
        .I3(s_axi_awsize[0]),
        .I4(s_axi_awsize[1]),
        .I5(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[5]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h005500553FFF3F7F)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[6]_i_1 
       (.I0(s_axi_awlen[2]),
        .I1(s_axi_awsize[1]),
        .I2(s_axi_awsize[0]),
        .I3(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ),
        .I4(s_axi_awlen[1]),
        .I5(s_axi_awsize[2]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h31FF)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_3 
       (.I0(s_axi_awlen[2]),
        .I1(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ),
        .I2(s_axi_awlen[1]),
        .I3(s_axi_awsize[2]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_5 
       (.I0(s_axi_awburst[0]),
        .I1(s_axi_awburst[1]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFEFFFFFFFF)) 
    \gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6 
       (.I0(s_axi_awlen[5]),
        .I1(s_axi_awlen[6]),
        .I2(s_axi_awlen[7]),
        .I3(s_axi_awlen[4]),
        .I4(s_axi_awlen[3]),
        .I5(s_axi_awlen[0]),
        .O(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_6_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[14] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[14]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[14] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[3] 
       (.C(s_aclk),
        .CE(p_4_out),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[3]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[3] ),
        .R(axi_wr_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[4] 
       (.C(s_aclk),
        .CE(p_4_out),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[4]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[4] ),
        .R(axi_wr_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[5] 
       (.C(s_aclk),
        .CE(p_4_out),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[5]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[5] ),
        .R(axi_wr_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[6] 
       (.C(s_aclk),
        .CE(p_4_out),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[6]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[6] ),
        .R(axi_wr_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.addr_cnt_enb_reg[7] 
       (.C(s_aclk),
        .CE(p_4_out),
        .D(\gaxif_ms_addr_gen.addr_cnt_enb[7]_i_3_n_0 ),
        .Q(\gaxif_ms_addr_gen.addr_cnt_enb_reg_n_0_[7] ),
        .R(axi_wr_fsm_n_3));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[10] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_27),
        .Q(bmg_address_r[10]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[11] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_26),
        .Q(bmg_address_r[11]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[12] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_25),
        .Q(bmg_address_r[12]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[13] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_24),
        .Q(bmg_address_r[13]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[14] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_23),
        .Q(bmg_address_r[14]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[3] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_34),
        .Q(bmg_address_r[3]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[4] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_33),
        .Q(bmg_address_r[4]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[5] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_32),
        .Q(bmg_address_r[5]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[6] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_31),
        .Q(bmg_address_r[6]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[7] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_30),
        .Q(bmg_address_r[7]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[8] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_29),
        .Q(bmg_address_r[8]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.bmg_address_r_reg[9] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(axi_wr_fsm_n_28),
        .Q(bmg_address_r[9]),
        .R(SS));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \gaxif_ms_addr_gen.incr_en_r_i_1 
       (.I0(s_axi_awburst[1]),
        .I1(s_axi_awburst[0]),
        .O(p_0_out));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.incr_en_r_reg 
       (.C(s_aclk),
        .CE(addr_en_c),
        .D(p_0_out),
        .Q(incr_en_r),
        .R(SS));
  LUT4 #(
    .INIT(16'h8778)) 
    \gaxif_ms_addr_gen.next_address_r[1]_i_2 
       (.I0(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] ),
        .I1(p_1_in[0]),
        .I2(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[1] ),
        .I3(p_1_in[1]),
        .O(\gaxif_ms_addr_gen.next_address_r[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hF880077F077FF880)) 
    \gaxif_ms_addr_gen.next_address_r[2]_i_2 
       (.I0(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] ),
        .I1(p_1_in[0]),
        .I2(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[1] ),
        .I3(p_1_in[1]),
        .I4(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[2] ),
        .I5(p_1_in[2]),
        .O(\gaxif_ms_addr_gen.next_address_r[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFEAEAAAAA808000)) 
    \gaxif_ms_addr_gen.next_address_r[3]_i_3 
       (.I0(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[2] ),
        .I1(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] ),
        .I2(p_1_in[0]),
        .I3(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[1] ),
        .I4(p_1_in[1]),
        .I5(p_1_in[2]),
        .O(\gaxif_ms_addr_gen.next_address_r[3]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.next_address_r_reg[0] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(next_address_r[0]),
        .Q(p_1_in[0]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.next_address_r_reg[1] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(next_address_r[1]),
        .Q(p_1_in[1]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.next_address_r_reg[2] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(next_address_r[2]),
        .Q(p_1_in[2]),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.next_address_r_reg[3] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_8),
        .D(next_address_r[3]),
        .Q(p_0_in5_in),
        .R(SS));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h01)) 
    \gaxif_ms_addr_gen.num_of_bytes_r[0]_i_1 
       (.I0(s_axi_awsize[1]),
        .I1(s_axi_awsize[2]),
        .I2(s_axi_awsize[0]),
        .O(num_of_bytes_c[0]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \gaxif_ms_addr_gen.num_of_bytes_r[1]_i_1 
       (.I0(s_axi_awsize[1]),
        .I1(s_axi_awsize[2]),
        .I2(s_axi_awsize[0]),
        .O(\gaxif_ms_addr_gen.num_of_bytes_r[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h02)) 
    \gaxif_ms_addr_gen.num_of_bytes_r[2]_i_1 
       (.I0(s_axi_awsize[1]),
        .I1(s_axi_awsize[2]),
        .I2(s_axi_awsize[0]),
        .O(num_of_bytes_c[2]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \gaxif_ms_addr_gen.num_of_bytes_r[3]_i_2 
       (.I0(s_axi_awsize[1]),
        .I1(s_axi_awsize[0]),
        .I2(s_axi_awsize[2]),
        .O(num_of_bytes_c[3]));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[0] 
       (.C(s_aclk),
        .CE(addr_en_c),
        .D(num_of_bytes_c[0]),
        .Q(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[0] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[1] 
       (.C(s_aclk),
        .CE(addr_en_c),
        .D(\gaxif_ms_addr_gen.num_of_bytes_r[1]_i_1_n_0 ),
        .Q(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[1] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[2] 
       (.C(s_aclk),
        .CE(addr_en_c),
        .D(num_of_bytes_c[2]),
        .Q(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[2] ),
        .R(SS));
  FDRE #(
    .INIT(1'b0)) 
    \gaxif_ms_addr_gen.num_of_bytes_r_reg[3] 
       (.C(s_aclk),
        .CE(addr_en_c),
        .D(num_of_bytes_c[3]),
        .Q(\gaxif_ms_addr_gen.num_of_bytes_r_reg_n_0_[3] ),
        .R(SS));
  LUT3 #(
    .INIT(8'hE1)) 
    \gaxif_wlast_gen.awlen_cntr_r[2]_i_2 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [1]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [0]),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [2]),
        .O(\gaxif_wlast_gen.awlen_cntr_r[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hFE01)) 
    \gaxif_wlast_gen.awlen_cntr_r[3]_i_2 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [2]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [0]),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [1]),
        .I3(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [3]),
        .O(\gaxif_wlast_gen.awlen_cntr_r[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT5 #(
    .INIT(32'hFFFE0001)) 
    \gaxif_wlast_gen.awlen_cntr_r[4]_i_2 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [3]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [1]),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [0]),
        .I3(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [2]),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [4]),
        .O(\gaxif_wlast_gen.awlen_cntr_r[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFE00000001)) 
    \gaxif_wlast_gen.awlen_cntr_r[5]_i_2 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [4]),
        .I1(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [2]),
        .I2(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [0]),
        .I3(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [1]),
        .I4(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [3]),
        .I5(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [5]),
        .O(\gaxif_wlast_gen.awlen_cntr_r[5]_i_2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \gaxif_wlast_gen.awlen_cntr_r[7]_i_3 
       (.I0(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [6]),
        .I1(axi_wr_fsm_n_17),
        .O(\gaxif_wlast_gen.awlen_cntr_r[7]_i_3_n_0 ));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[0] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[0]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [0]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[1] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[1]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [1]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[2] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[2]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [2]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[3] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[3]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [3]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[4] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[4]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [4]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[5] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[5]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [5]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[6] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[6]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [6]),
        .S(SS));
  FDSE #(
    .INIT(1'b1)) 
    \gaxif_wlast_gen.awlen_cntr_r_reg[7] 
       (.C(s_aclk),
        .CE(axi_wr_fsm_n_7),
        .D(p_0_in[7]),
        .Q(\gaxif_wlast_gen.awlen_cntr_r_reg__0 [7]),
        .S(SS));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_generic_cstr" *) 
module rom_32KB_axi_blk_mem_gen_generic_cstr
   (s_axi_rdata,
    ENA_dly_D,
    rsta_busy,
    rstb_busy,
    s_aclk,
    ENA_I,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    s_aresetn,
    E);
  output [63:0]s_axi_rdata;
  output ENA_dly_D;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input ENA_I;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_aresetn;
  input [0:0]E;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly;
  wire ENA_dly_D;
  wire ENB_I;
  wire ENB_dly;
  wire ENB_dly_D;
  wire POR_A;
  wire ram_rstram_b;
  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire [63:0]s_axi_rdata;
  wire [63:0]s_axi_wdata;
  wire [7:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_width \ramloop[0].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .E(E),
        .ENA_I(ENA_I),
        .ENA_dly(ENA_dly),
        .ENA_dly_D(ENA_dly_D),
        .ENB_I(ENB_I),
        .ENB_dly(ENB_dly),
        .ENB_dly_D(ENB_dly_D),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[7:0]),
        .s_axi_wdata(s_axi_wdata[7:0]),
        .s_axi_wstrb(s_axi_wstrb[0]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized0 \ramloop[1].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[15:8]),
        .s_axi_wdata(s_axi_wdata[15:8]),
        .s_axi_wstrb(s_axi_wstrb[1]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized1 \ramloop[2].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[23:16]),
        .s_axi_wdata(s_axi_wdata[23:16]),
        .s_axi_wstrb(s_axi_wstrb[2]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized2 \ramloop[3].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[31:24]),
        .s_axi_wdata(s_axi_wdata[31:24]),
        .s_axi_wstrb(s_axi_wstrb[3]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized3 \ramloop[4].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[39:32]),
        .s_axi_wdata(s_axi_wdata[39:32]),
        .s_axi_wstrb(s_axi_wstrb[4]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized4 \ramloop[5].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[47:40]),
        .s_axi_wdata(s_axi_wdata[47:40]),
        .s_axi_wstrb(s_axi_wstrb[5]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized5 \ramloop[6].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata[55:48]),
        .s_axi_wdata(s_axi_wdata[55:48]),
        .s_axi_wstrb(s_axi_wstrb[6]));
  rom_32KB_axi_blk_mem_gen_prim_width__parameterized6 \ramloop[7].ram.r 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENA_dly(ENA_dly),
        .ENA_dly_D(ENA_dly_D),
        .ENB_I(ENB_I),
        .ENB_dly(ENB_dly),
        .ENB_dly_D(ENB_dly_D),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .rsta_busy(rsta_busy),
        .rstb_busy(rstb_busy),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_rdata(s_axi_rdata[63:56]),
        .s_axi_wdata(s_axi_wdata[63:56]),
        .s_axi_wstrb(s_axi_wstrb[7]));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width
   (s_axi_rdata,
    ENB_I,
    ENA_dly_D,
    ENB_dly_D,
    s_aclk,
    ENA_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    ENA_dly,
    ENB_dly,
    E);
  output [7:0]s_axi_rdata;
  output ENB_I;
  output ENA_dly_D;
  output ENB_dly_D;
  input s_aclk;
  input ENA_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input ENA_dly;
  input ENB_dly;
  input [0:0]E;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly;
  wire ENA_dly_D;
  wire ENB_I;
  wire ENB_dly;
  wire ENB_dly_D;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_D_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ENA_dly),
        .Q(ENA_dly_D),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENB_NO_REG.ENB_dly_D_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ENB_dly),
        .Q(ENB_dly_D),
        .R(1'b0));
  rom_32KB_axi_blk_mem_gen_prim_wrapper_init \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .E(E),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .ENB_dly_D(ENB_dly_D),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized0
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized0 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized1
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized1 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized2
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized2 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized3
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized3 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized4
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized4 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized5
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized5 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .POR_A(POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_width" *) 
module rom_32KB_axi_blk_mem_gen_prim_width__parameterized6
   (s_axi_rdata,
    POR_A,
    ram_rstram_b,
    ENA_dly,
    ENB_dly,
    rsta_busy,
    rstb_busy,
    s_aclk,
    ENA_I,
    ENB_I,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    s_aresetn,
    ENB_dly_D,
    ENA_dly_D);
  output [7:0]s_axi_rdata;
  output POR_A;
  output ram_rstram_b;
  output ENA_dly;
  output ENB_dly;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_aresetn;
  input ENB_dly_D;
  input ENA_dly_D;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire ENA_I;
  wire ENA_dly;
  wire ENA_dly_D;
  wire ENB_I;
  wire ENB_dly;
  wire ENB_dly_D;
  wire POR_A;
  wire \SAFETY_CKT_GEN.POR_A_i_1_n_0 ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ;
  wire \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ;
  wire ram_rstram_a_busy;
  wire ram_rstram_b;
  wire ram_rstram_b_busy;
  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;

  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENA_NO_REG.ENA_dly_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(POR_A),
        .Q(ENA_dly),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.ENB_NO_REG.ENB_dly_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_rstram_b),
        .Q(ENB_dly),
        .R(1'b0));
  LUT2 #(
    .INIT(4'h6)) 
    \SAFETY_CKT_GEN.POR_A_i_1 
       (.I0(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .I1(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ),
        .O(\SAFETY_CKT_GEN.POR_A_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.POR_A_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.POR_A_i_1_n_0 ),
        .Q(POR_A),
        .R(1'b0));
  LUT3 #(
    .INIT(8'hFE)) 
    \SAFETY_CKT_GEN.RSTA_BUSY_NO_REG.RSTA_BUSY_i_1 
       (.I0(ENA_dly),
        .I1(ENA_dly_D),
        .I2(POR_A),
        .O(ram_rstram_a_busy));
  FDRE \SAFETY_CKT_GEN.RSTA_BUSY_NO_REG.RSTA_BUSY_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_rstram_a_busy),
        .Q(rsta_busy),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[0] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(1'b1),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .R(1'b0));
  (* srl_bus_name = "U0/\inst_blk_mem_gen/gnbram.gaxibmg.axi_blk_mem_gen/valid.cstr/ramloop[7].ram.r/SAFETY_CKT_GEN.RSTA_SHFT_REG_reg " *) 
  (* srl_name = "U0/\inst_blk_mem_gen/gnbram.gaxibmg.axi_blk_mem_gen/valid.cstr/ramloop[7].ram.r/SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3 " *) 
  SRL16E #(
    .INIT(16'h0000)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3 
       (.A0(1'b0),
        .A1(1'b1),
        .A2(1'b0),
        .A3(1'b0),
        .CE(1'b1),
        .CLK(s_aclk),
        .D(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[0] ),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[4] 
       (.C(s_aclk),
        .CE(1'b1),
        .D(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg[3]_srl3_n_0 ),
        .Q(\SAFETY_CKT_GEN.RSTA_SHFT_REG_reg_n_0_[4] ),
        .R(1'b0));
  LUT4 #(
    .INIT(16'hFFFD)) 
    \SAFETY_CKT_GEN.nSPRAM_RST_BUSY.RSTB_BUSY_NO_REG.RSTB_BUSY_i_1 
       (.I0(s_aresetn),
        .I1(POR_A),
        .I2(ENB_dly),
        .I3(ENB_dly_D),
        .O(ram_rstram_b_busy));
  FDRE \SAFETY_CKT_GEN.nSPRAM_RST_BUSY.RSTB_BUSY_NO_REG.RSTB_BUSY_reg 
       (.C(s_aclk),
        .CE(1'b1),
        .D(ram_rstram_b_busy),
        .Q(rstb_busy),
        .R(1'b0));
  rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized6 \prim_init.ram 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .ENA_I(ENA_I),
        .ENB_I(ENB_I),
        .\SAFETY_CKT_GEN.POR_A_reg (POR_A),
        .ram_rstram_b(ram_rstram_b),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init
   (s_axi_rdata,
    ENB_I,
    s_aclk,
    ENA_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    ENB_dly_D,
    E);
  output [7:0]s_axi_rdata;
  output ENB_I;
  input s_aclk;
  input ENA_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input ENB_dly_D;
  input [0:0]E;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire [0:0]E;
  wire ENA_I;
  wire ENB_I;
  wire ENB_dly_D;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h3367930F1393E3936323931397936F9393939393939393939393939393939393),
    .INIT_01(256'h0303030303030303030373B7EFF3232323232323232323232323232323236F13),
    .INIT_02(256'h23131313132383B3038363136F9BB31B93238393232393131313130303030303),
    .INIT_03(256'h132383B3038363136F9BB31B932383932323931313131313238383B3139B83B7),
    .INIT_04(256'h93931393E3B723832313B713932393A313131313238383B3139B83B723131313),
    .INIT_05(256'h2323239323131313E3B7238323A3932393A3932393A3932393A39313A39313A3),
    .INIT_06(256'h8303EF17839323936F93939B6F9B9B6393EF1783932393E3B3B79B9313132323),
    .INIT_07(256'h839B239303931323232393E31B839B23936FEF63EF9313EF1793E31B23839323),
    .INIT_08(256'h139BEF9B93E39323839323939313931383B7231393939323839313931383B7B3),
    .INIT_09(256'hE383039B23936FEF170363839323139BEF9B9323139BEF9B9323139BEF9B9323),
    .INIT_0A(256'h83039BEF1713B3839B83231393931363836F931BEF1793EF9393830303EF1793),
    .INIT_0B(256'h1383B72323232323232313236703131313232323930383171323670313139393),
    .INIT_0C(256'h9B238383B723139313979393839B23830323936F232383239B839B8383B79B93),
    .INIT_0D(256'h1B9B23936F2303EF63BB03EF1713631B03931B2383B3B723EF8363BB039B6F83),
    .INIT_0E(256'h670313EF170313831363836F931BEF939383030363BB03839B23836F9323839B),
    .INIT_0F(256'h83B70F13B7E31B238303B72303B71393E31B2383932303B72323232323931323),
    .INIT_10(256'h9B2313131313E31B039B2383936F6383832383839323236783136F83B79B9B93),
    .INIT_11(256'h23131383E70F23130F2393132393132323131313B39B1B9BB79B83B3B3B79B83),
    .INIT_12(256'h839323B713EF1713EF1713EF1713EF1713EF2323232323232323232323232393),
    .INIT_13(256'hEF136303EFEF1703238323931383132313136F63231313EF17136383B7138313),
    .INIT_14(256'h238313839313136F63931313EF8313EF1713631B6F0393EFEF179383938313A3),
    .INIT_15(256'h1383EF9393232323932393932313EF172313138393136F13EF17B783EF83E393),
    .INIT_16(256'h13936F9B832303B723670313E3B7839B6F93EF9393EF939313EF13139B932313),
    .INIT_17(256'h931313131383EFEF9393EF1313EF13139B93EF1313EF231313132313B7130323),
    .INIT_18(256'h2367030F039323139B9B9B9BA3139B9B9B9B1B9B9B2313836F9B832303B79393),
    .INIT_19(256'h030F33B7B383931313639B939393A323232367030F33B79313639B9393932323),
    .INIT_1A(256'h03B79393139323131313139B6F9B6F9B6F8363136393136393139B23A3932367),
    .INIT_1B(256'h93EF17139393EF179B9B939393EF93931303EF93939B1B93EF1313EF6F9B8323),
    .INIT_1C(256'h236703136393832303B72367038383B72393136393832303B7A313131383EF23),
    .INIT_1D(256'h23939393131323678383EF83BB9B2383938323EF83932313130323A323239323),
    .INIT_1E(256'h13EF17832303231313EF17139393939393EF83EF1783979313231313EF938383),
    .INIT_1F(256'h031383139383B39393939393EF83EF17136393032393832313136F232393EF83),
    .INIT_20(256'h2393E393832303B7236703EF83BB9B238313939B2323B38323139303836F9B23),
    .INIT_21(256'h1313830F13239313239363938383B76F9B9B939393EF939323B7131323670313),
    .INIT_22(256'h23A31323670313EF9313B76F13B79B9BA393136393832303B713130F93EF9323),
    .INIT_23(256'hEFEF9393EF939383EFEF93931323670313138393839BEF93939B932323A323A3),
    .INIT_24(256'h930F03B72393030F930F13B72323839323839323931393032323670313EF1313),
    .INIT_25(256'h0F13B79B9B9313939393631B93839B9B9313939B839383939313932313131323),
    .INIT_26(256'hEF179B9393EF179B9B93930F13931B832313930F03B72313B79B0F1303B72393),
    .INIT_27(256'hB79383B72393E3939383B78313A3EF136FEF179BEF17130F03B783B79B93B3B7),
    .INIT_28(256'h932383932383B3B7B3B72313236703136F638393631B93839383B79383B79383),
    .INIT_29(256'h63939383B7839363939383B71303B7B72313138383931313830383B393232393),
    .INIT_2A(256'hB713A363939383B7A363939383B79B9B93139B9B93130F03B783B763939383B7),
    .INIT_2B(256'h13A3EF939B9B9393239313236703132313931383B71303B7B793A36313B31383),
    .INIT_2C(256'h9363939383B7631363139BA3EF23A36F93A36F9393EFA36F9363136393839363),
    .INIT_2D(256'h131383932393E3939383B78393EF179B9B9393232313138383A36F93A363836F),
    .INIT_2E(256'h83B7EF1713A3231313831393238303231323670313832383932383936F6F2313),
    .INIT_2F(256'hB713131383939393136F6F6F936313639313639383936FEFEF9BB79B93E3B313),
    .INIT_30(256'h13938303831393830383B78323232323131313E3039323838383B7239B931383),
    .INIT_31(256'h1313B7236703139B9B83B72393131313832313B783B713139313931323670313),
    .INIT_32(256'h1383EF931B1B9B230383839323839383B3B7B3B72323939323131313E3939393),
    .INIT_33(256'hEF1793A3EF9383839BA3EF9383938393A3939393131323670313EFEFEFEF2313),
    .INIT_34(256'h23EF9383938323B79383931B8397831383932383239393939323132367031313),
    .INIT_35(256'h836383936F93E30393EF639303EF17932383930323831363839313838303839B),
    .INIT_36(256'h9BB79B93EF17E3939383B713B79383B783B7233797932393A3132367031313E3),
    .INIT_37(256'h83B70F03930F930F93A32313939323B723930F936313B31383B7B79BB79B9313),
    .INIT_38(256'h239B1B8383B3B723239323930F13B72337B723930F13930F0393231383E39393),
    .INIT_39(256'h839383B3B7B3B723A3EF938303B3839B23238393239323931393032393139303),
    .INIT_3A(256'h236383B3839B232383932393239313930323131303236FB793239B1B83839323),
    .INIT_3B(256'h238393239323931393032363B3139393136F13EF179BB783136383EF938383B7),
    .INIT_3C(256'h9B93931B839383B70F930F1393239BB79B930F0393231383EF938303B3839B23),
    .INIT_3D(256'h032383B7132313B79393931323931B832303B793EF0F13931B8323139323B723),
    .INIT_3E(256'h938303B3839B23238393239323B3B72323139303239B1B838393238393839393),
    .INIT_3F(256'h832313939B93139303239B1B83839323839383B3B7B3B72323939393139B93EF),
    .INIT_40(256'hB3839B23238393239323B3B7232323EF938303B3839B23238393238393930323),
    .INIT_41(256'hEF179383EF179383EF179363832313B79393939323931B832303B793EF938383),
    .INIT_42(256'h13236703132313B713B72313B79393939B9B9393139393932313B703EF179383),
    .INIT_43(256'h23EF17EF17EF172313236703130303839393EF1783979323A323232323A32393),
    .INIT_44(256'h13E383931313131383EF1713236703131313236F93839BEF1713030383231393),
    .INIT_45(256'h13132367031313038323B397B397130323B397B3972313138393132393231313),
    .INIT_46(256'h6313EFE3839393931383136F2323131383931383932313138323EF931383EF93),
    .INIT_47(256'h1313231323670313132393839B2383B3139B839393938393832313236703136F),
    .INIT_48(256'h8313039B939393839383B3936F1B238313036F6FB3830323931B1BB383232323),
    .INIT_49(256'h830383631B2323236703938303836F2393839B6F239383938393131313831323),
    .INIT_4A(256'h9B2383239393938393E31383E78323836F232323231313132393838303836383),
    .INIT_4B(256'hE3836F93239B6F83136F936313939B839BBB9B9B036F93A367931BB39793631B),
    .INIT_4C(256'h2383E7836F9B238313038323BB931383631363831703136F1303238323832323),
    .INIT_4D(256'h9303931383138393236F932323831383839313936F9B23831383E3839BE3839B),
    .INIT_4E(256'h23670313EF17038393232323232313236703031313831383E7836F03039B83EF),
    .INIT_4F(256'h9323839383231723B79323B79393839323232323231313138383230383832393),
    .INIT_50(256'h83232383936F8383E3B30303932303232363B3330323131313839B8323EF0393),
    .INIT_51(256'hB303132383236F038323238323230383B3932303839363B30323232367038303),
    .INIT_52(256'h13A3238323236703B303836313238323231313131383E383936F8313131313E3),
    .INIT_53(256'h631383938323832323236703838303932303232313131313BB83839383638383),
    .INIT_54(256'h23B7B71323B79323670383B363838323839B9B2383939303238393B31B839383),
    .INIT_55(256'h0F9BB723670313E38393EF836F13236703139383930F9BB72303A31313131323),
    .INIT_56(256'h831363136313A3EF9383A39383A383939303A32323A393231313130F9BB79B9B),
    .INIT_57(256'h9B6F13139BEF831313E3136313A3EF93836FA38313EFEF8393E3136F9B130313),
    .INIT_58(256'h83936313A3EF9383A3A39323131383839383A383B303B3B313B39B23931B83B3),
    .INIT_59(256'hA38313EFEF8313EFEF839383938393E31303A383031383A38313EFEF8313EFEF),
    .INIT_5A(256'h83A38313EFEF8393839383936F931323670313E313039B23838313839B6F1313),
    .INIT_5B(256'h039BE3839B236F8393839BEF8393839383238313631363136F9BEF8393839383),
    .INIT_5C(256'h93832313EF93E3B7839B6F939B9BA3836FEF6F139393232323932313138383B3),
    .INIT_5D(256'h93038393931323231313839383139383132393839B2383839B8323EF93838313),
    .INIT_5E(256'h936F9313236703131313EF6F13EF238313939B83936F93839383938393839383),
    .INIT_5F(256'h839B1B93239313236703E3A3839323838383A3832323670313E313A38313B383),
    .INIT_60(256'hB31B9B9BB383232323236703136F639B1B936F6F6F63839313936313BB838383),
    .INIT_61(256'h0A202047430A656F6E0A1313E383238393A3839B6F9BB39B931B9B839B6F939B),
    .INIT_62(256'h0D3A200D0073250D3A200D0065696F0D2E720A2E65650A2564200D205F0A6572),
    .INIT_63(256'h6F207C0D2D2D2D2D2D2D2D2B0A0A00202020200D006620720D6474650D74656E),
    .INIT_64(256'h2D2D2D2B2D2D2D2B0D202020202020207C0D496F4D7244526C7C0D6E436F7270),
    .INIT_65(256'h6F736974650A5D5B726C6574650A524D790A0A20660A0D2061207C2E6F777C0D),
    .INIT_66(256'h6564746974650A3A6574206F0A006864206974650A0A6F2073206769650A3020),
    .INIT_67(256'h67746420006920656D0A206720660A0920740A3A323A640A2041790A7220660A),
    .INIT_68(256'h3A200D3067256E0D3E6F610A3072200D306F200075200A2D2D2D2D2D2D0A3643),
    .INIT_69(256'h21650D00532048490D6365740D006F640D0D540D700D2554520D506C66250D00),
    .INIT_6A(256'h4F0A304F0A00304F0A00304F0A003A440D533A440D0D200A200A256C206E690D),
    .INIT_6B(256'hA4A4A4908C9090907C30282C7449454120720D736225437845000A0020642035),
    .INIT_6C(256'hF89490049090909090709090909090909090909090909090909090909090A4A4),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000090),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT2 #(
    .INIT(4'hE)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_2 
       (.I0(ENB_dly_D),
        .I1(E),
        .O(ENB_I));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized0
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0200871000870C850EB00682718200920F0E0D0C0B0A09080706050403020100),
    .INIT_01(256'h3A393837363534333231A02240253C343C343C343C343C343C343C343C344011),
    .INIT_02(256'h170401010090376757D710F700D77757C71737F7301707870401013F3E3D3C3B),
    .INIT_03(256'h0090376757D710F700D77757C71737F730170787040101851737378787975707),
    .INIT_04(256'h87870787D44734373407070787A0870F04010185173737878797570717040101),
    .INIT_05(256'h3C24260730010100D48730373082878287818781878087808785870784870783),
    .INIT_06(256'h3727406527F72A87000707D70087D78EF7406527F72A879E7717878700053422),
    .INIT_07(256'h67D7208727078592919087EA8727872A870030940085064065F7FA8726278734),
    .INIT_08(256'h57870087876087202787B09786970785A70720058587F73C3787970785A70707),
    .INIT_09(256'h4A3727872A87004065368E4787B05787008787B05787008787B05787008787B0),
    .INIT_0A(256'hB72787405586072786272C058587058C47F087874065F7000507A7B7B74065F7),
    .INIT_0B(256'h87A70734263830242630043C8034008506203C38875726670434803400058587),
    .INIT_0C(256'h872227A7072205078565070727873437272A87003424272487278727A7078787),
    .INIT_0D(256'h87972A87003C37309677274055050007278787222777072A0027947727870027),
    .INIT_0E(256'h8034853055360535058A47F08787000507A7B7B79A7727278720270087A03787),
    .INIT_0F(256'hA707000707DC87202727072027070787D487222787A0370722282C2C2E870434),
    .INIT_10(256'hD7260401018548072787303787000637372E3737073434803400F0A707878787),
    .INIT_11(256'h300101308010B00010348786B087053C300101856797878707872767F7078727),
    .INIT_12(256'h378730170540550540550540550540550540343C342C200320031A340320B087),
    .INIT_13(256'h4005F4374040553726272607853705380505008C3405054055059A5727173717),
    .INIT_14(256'h242705B79787050080870505E047054055051C8700358740405507470747850F),
    .INIT_15(256'h01300005068080908780870738013055300101300705000540554757F0B76E87),
    .INIT_16(256'h7787F0D7C7B0B70734803400D227278700070005060005060500850687873801),
    .INIT_17(256'h8787040101300000050600050600850687870005060030010100B4870767D790),
    .INIT_18(256'h3C803400378780F797D7878780F797D78787578787915727F0D7C7B0B7070707),
    .INIT_19(256'h3400E7076637979700D4978787870B3C3434803400E7079600D4978787872234),
    .INIT_1A(256'hB707078707073801018500D700D700D700470A874A8607468607870F0F073480),
    .INIT_1B(256'h87305505858730558787878787F005068527F0850687878700050600F0D7C7B0),
    .INIT_1C(256'h3C80340094F7C7B0B70734803437B707BC870094F7C7B0B7070F04010130F0B8),
    .INIT_1D(256'h3407078787043C803430F02757872E2787B7B0F047872E858627030324260734),
    .INIT_1E(256'h052055B7B0B7B007852055058587878787F0473055B7578705B00785F0052746),
    .INIT_1F(256'h370535058527770787D78787F0472055050087B78087C7B0078500202287F047),
    .INIT_20(256'hB8878CF7C7B0B707348034F027578722270585878022D747B0878737B70087B0),
    .INIT_21(256'h0101300005B88700B8878CF747B707F08787878787F00506BC0705043C803400),
    .INIT_22(256'h0707043C803400F0050707F00707878707870094F7C7B0B70705060087F00538),
    .INIT_23(256'hF0F00506F00506C7F0F0050604348034008527F64797F0050687872E30050606),
    .INIT_24(256'h87005707A087B70087000707A01057E71057E71087878757143C803400F00506),
    .INIT_25(256'h0007078787870007D7F71087975787878700D78727D727078707073001010090),
    .INIT_26(256'h20458797872045878797870057878727901787002707901707D7005727079087),
    .INIT_27(256'h0787A70790878EF7D7D707470507000500204587204505005707D70787D77747),
    .INIT_28(256'hE71457E71457671777C714043C803485008647071287975787A70787A70787A7),
    .INIT_29(256'h84F7D7D70747078CF7D7D707575707073801013047078586363737E7973C3007),
    .INIT_2A(256'h07050788F7D7D7070788F7D7D7078787870087878700005707D70784F7D7D707),
    .INIT_2B(256'hF707F007878797879087043C80348590178757D70757570707070708877787A7),
    .INIT_2C(256'h078AF7D7D7070287DC078707F007070007070007F7000700078A078C86470712),
    .INIT_2D(256'h0101300790878EF7D7D707470720458787978734380101304707000707884700),
    .INIT_2E(256'hA707104505073801013000073437353404348034003734370730378700003004),
    .INIT_2F(256'h070401013007070705000000078A078A86074486470700000087078787807787),
    .INIT_30(256'h8506363737850636373707B7343C3430010185F437873C3737A70734878787A7),
    .INIT_31(256'h000707348034008787C707808704010130806707C707057787F7870434803400),
    .INIT_32(256'h013000058607873C573757E71457E757671777C7143087073801010092F7F787),
    .INIT_33(256'h1035F707F00527268709F007470747F70707078787043480340000F0F0F03001),
    .INIT_34(256'h0FF0074707473407E7378787A747370535F73C37030787070634043C80348500),
    .INIT_35(256'h478C470700F76C3787109687371035F7343707353447058C4707854636373787),
    .INIT_36(256'h87078787103584F7D7D7070707D7D707A707A017478722870F04348034850098),
    .INIT_37(256'hD707005787008700878080F7978724178087008716877787A707078707878700),
    .INIT_38(256'h2C8787275777C71026078087000707901707908700078700578780F7C780F7D7),
    .INIT_39(256'h57E757673777C7100BF00527266757972C1057E710F710878787571407850627),
    .INIT_3A(256'h2688476757972C1057F710F7108787875714858667260007F72C87872757F710),
    .INIT_3B(256'h1057E710F7108787875714867787878705000700358707A700C4A7F005666787),
    .INIT_3C(256'h8797878727D7D7070087007787248707878700578780F7C7F00527266757972C),
    .INIT_3D(256'h5714A7070590870787E787058087872780270787F00057878727901787280728),
    .INIT_3E(256'h0527266757972C1057E710F71077C710268506272C87872757F71057E757E787),
    .INIT_3F(256'hB780F7F7D7878506272C87872757F71057E757671777C71026878797578787F0),
    .INIT_40(256'h6757972C1057E710F71077C7102626F00527266757972C1057E71057E7875714),
    .INIT_41(256'h00350747003507470035F78E4790870787F7870780878727802707E7E0056667),
    .INIT_42(256'h043C803400908707070790870787E787878797870087F7879087074700350747),
    .INIT_43(256'h3000250025002538043C80340036456695870025A737F73C0338303830012287),
    .INIT_44(256'h009C270787040101300025043C80340005043400072787002506B73727260585),
    .INIT_45(256'h8704348034008536373087378737853634873787373801013007052607380101),
    .INIT_46(256'h1687F0923707070785C787003C30010130078527073801013026C0058527F007),
    .INIT_47(256'h87863804348034008504072787343787F7862607070737F73726043C80348500),
    .INIT_48(256'h27853787070707A70627079700072027853700F0576737AC06878776672E2022),
    .INIT_49(256'hB737B7D08722343C8034D7A737B7003086378700308637072787040101300026),
    .INIT_4A(256'h843C372807070737871687C780353C37003C343830010185308637B737B78027),
    .INIT_4B(256'hD827F007268700A787F087C6870784378787979727F007038087870727D7EC87),
    .INIT_4C(256'h2627803500872627853747268707052702F75A2729B987008537383728272426),
    .INIT_4D(256'h05270705370537072A00072A3C37053737078507008726270537DA2787C62784),
    .INIT_4E(256'h3C803485F0F5363787383C343C340434803934000037053780350035368726F0),
    .INIT_4F(256'h0730370737BC07A60686A2B6060737073038303C3801010037B7802737372E07),
    .INIT_50(256'h3780383707003737680737378634373034986767373004010130873780F03607),
    .INIT_51(256'h073777303730003737B03437343C373767973C3737F79267373C343480343737),
    .INIT_52(256'h87073C373C3480340737C788873437343804010185379637870037040101856C),
    .INIT_53(256'h0C873707C73C37223C34803437C747863837343804010185074747F7478C47C7),
    .INIT_54(256'hA6171707A617073C803437078827C7343787873C379797373C37F707873707C7),
    .INIT_55(256'h0087173C8034009E3787F0C700043C8034000747F7008717A0470F04010100A2),
    .INIT_56(256'h4785EEF7F6F70BF0F74707F7470747979737073C340B07380101850087178787),
    .INIT_57(256'h8700000087F04705851EF704F70BF0F747F0074785F0F047F718F7F087004707),
    .INIT_58(256'h47F710F70300F7470703073801013037F7470747573707078707878406074707),
    .INIT_59(256'h074785F0F04785F0F04707470747071E77470747470747074785F0F04785F0F0),
    .INIT_5A(256'h47064785F0F04707470747070007043C8034856A7747872427C7074797000000),
    .INIT_5B(256'h47979A4787070047074787F04707470747064785E0F7F8F70087F04707470747),
    .INIT_5C(256'h07C78087F0F7FA972787000787870BA700F00007878722242607380101304767),
    .INIT_5D(256'h0735270707873C3801013007270507C7002407278724272787272C0085272685),
    .INIT_5E(256'h07000704348034850005F00005F0282785D78727860007270727072707270727),
    .INIT_5F(256'h37878787268704348034D40347873C37373703373C34803485F2F70747770747),
    .INIT_60(256'h475787870767242A3C34803485001687878700000096270785871E8707C737C7),
    .INIT_61(256'h0D253A545F0D2E6F670D0185EC272427F703479700D7479787979757870007D7),
    .INIT_62(256'h0A20700A0073640A20660A00696E610A2E650D0070200D6463250A25660D6420),
    .INIT_63(256'h665320002D2D2D2D2D2D2D2D0D0D005B2C25620A007573650A2068200A637263),
    .INIT_64(256'h2D2D2D2D2D2D2D2D002020203220202020006E76656F4949202000642D707372),
    .INIT_65(256'h72737468200D3A3161657268200D4120090D0D09650D002063762069632E2000),
    .INIT_66(256'h78726F7468200D00207264750D006564707468200D0D77617361206C200D785B),
    .INIT_67(256'h65207252006C7164700D546709650D0066690D393220640D544D090D6E09650D),
    .INIT_68(256'h20610A317464750A3E6D6E0D31654400316945006E640D2D2D2D2D2D2D0D6C53),
    .INIT_69(256'h00530A002053454E0A7572690A0063200A0A550A6F0A6C415F0A446565640A00),
    .INIT_6A(256'h430D20430D0030430D0030430D0020650A4420650A0A340D320D306F4E646E0A),
    .INIT_6B(256'hDFDFDFE2DFE2E2E2E2E06E20206D584225650073616C610A50000D0025644220),
    .INIT_6C(256'hE1E0E2E2E2E2E2E2E2E0E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2DFDF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000E2),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized1
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'hC20681000081D60105D510F1020200F200000000000000000000000000000000),
    .INIT_01(256'h0101010101010101010102004010F1D1B19171513111F1D1B19171513111C0A1),
    .INIT_02(256'hF401010100E704F7E407F7F70007F707F7F404F7F40407050101010101010101),
    .INIT_03(256'h00E704F7E407F7F70007F707F7F404F7F404070501010107F48404E70727E418),
    .INIT_04(256'h81810747E70FF4840400031707E787F401010107F48404E70727E408F4010101),
    .INIT_05(256'h0404040581010100E77DF40404E747E747E747E747E747E747E78110E78120E7),
    .INIT_06(256'h8444400044F7F407401084270017270737D00044F7F4C707F70007470045F404),
    .INIT_07(256'hC407F4F7440507E7E7E781E7078417F407001007D0C560C000F7E707F4C417F4),
    .INIT_08(256'h0707800707F701F40417E73701070507070304450701F7F484010705070703F7),
    .INIT_09(256'hF784C417F40700C0008407F447E70707800707E70707800707E70707800707E7),
    .INIT_0A(256'h078417C00007F784078404C50701C507F49FF7074000F7C06004078707C000F7),
    .INIT_0B(256'h070703F40404F40404B401110001000760F4E4E4814707020111000100450701),
    .INIT_0C(256'hB7F444070304300507020440C417F48444F40780F4F4C4F407C407C407030707),
    .INIT_0D(256'h0727F407C0F4849007F784C000C5F70704F707F444F701F4804407F704178044),
    .INIT_0E(256'h000107D00004C5844507F45FF70740600407870707F78404B7F4048047E70407),
    .INIT_0F(256'h0703F0C003E707F404840304840387C7E707F44447E78403040404F4F4050181),
    .INIT_10(256'h87F401010107F707C417F4041700F7048404048406A4810001005F07030707C7),
    .INIT_11(256'h810101810700070000F48181E781C5A481010107F7870707FF07C4F7F60107C4),
    .INIT_12(256'h0487F430C5400045C000C54000C5C00045C0040404040404040404040404E701),
    .INIT_13(256'h40C5E78400400084F4C4F4050704C5A440454007A410C5400045076400E78487),
    .INIT_14(256'hF4840007370145C0070100459F7445400045F70700048180C00090F490F407F4),
    .INIT_15(256'h01815030300707E7A1E781058101500081010181004500C5C00000649F07F701),
    .INIT_16(256'h07019F8747E7072081000100E700C4170010400090C000600040070007818101),
    .INIT_17(256'h05060101018110C00050D000105007000781D000105081010100E701200707E7),
    .INIT_18(256'h810081F00707E7F787870707E7F787870707870707E707C49F8747E707200706),
    .INIT_19(256'h81F0E620F7840707000787818107F4C4A4810081F0E62007000787818107F4A4),
    .INIT_1A(256'h0720070606058101010700374027401740E4F707D70720D7073007F4F4058100),
    .INIT_1B(256'h07C00045070740000707818107DF80C007849F0700F70781C00030809F8747E7),
    .INIT_1C(256'h11008100074747E70720810081840720E70700070747E70720F4010101819FE7),
    .INIT_1D(256'h04070605060111008181DFC4F707F4C40107F41F740104070684F4F4F4F40591),
    .INIT_1E(256'hC5D00007E707E705078000C507810181811F74C00007008145E705079F07C464),
    .INIT_1F(256'h84C584450704F7F0810781819F745000C5F74707E78107E70507C0F404819F74),
    .INIT_20(256'hE707078747E707208100015F44F707F444C507F70704F664E787010707C017E7),
    .INIT_21(256'h010181F000E70700E7070717F407205F0707818107DF00500720000111008100),
    .INIT_22(256'hF4F401110001004F00F0205FF0200707F40700074747E707200030F0074F1081),
    .INIT_23(256'h1FCF00908F0000071FCF006001110001000784F7D4878F07000781F404F4F4F4),
    .INIT_24(256'hE7F08404E78707F067F0000407F40487F40407F40707F70404810001005F0030),
    .INIT_25(256'hF0F00407074700000707F70707040707470007074407440706060581010100E7),
    .INIT_26(256'h4000070727C00007070727F007E70744E707C7F08404E7070407F007C404E727),
    .INIT_27(256'h04810704E7070717070704F445F4804580C000074000C5F0C40407040707F700),
    .INIT_28(256'h07F48437F484F700F7FF0401110001078007F405F70707048107048107048107),
    .INIT_29(256'h07F7070704F4050707070704070704048101018174050706840484E707F40400),
    .INIT_2A(256'h0440F40707070704F407F70707040707470007074700F0C40407040707070704),
    .INIT_2B(256'hF7F49F10070707C7E7270111000107E707670707040707040410F4F707F70707),
    .INIT_2C(256'h600707070704F707071007F4DF04F48020F40040F7C0F480100720E607F405F7),
    .INIT_2D(256'h01018100E70707270707047405C000070707270481010181F4F40050F407E480),
    .INIT_2E(256'h070450004504810101810070F4848404011100810084F48420F40417C0C00401),
    .INIT_2F(256'h04010101811010100040C000100720E60730D707F405C040C00701074707F707),
    .INIT_30(256'h074084048407408404841A07F4C4A481010107E78417F4848407040407070707),
    .INIT_31(256'h0040048100810007070704E7F701010181E717040704A0F797F7970111000100),
    .INIT_32(256'h0181C007060707F404848407F4842784F700F7FF04F40100810101000747F7F7),
    .INIT_33(256'h5000F7F40F07C444F7F49F10F41034F704070605060111000100C05F5F1F8101),
    .INIT_34(256'hF41F107410E4F43A0784C707070284C584F7F4040407060507C4011100010700),
    .INIT_35(256'hE407740500F7F7841780070784D000F7F48405840474C507740507E4840404F7),
    .INIT_36(256'h070207474000072707070410040707040704E70002010407F401110001070007),
    .INIT_37(256'h0704F007C7F0F7F0E707E7F707C7F400E797F087F707F7070704030703074700),
    .INIT_38(256'hF407078404F7FF040400E7E7F0F004E70004E767F03747F007C7E7F707072707),
    .INIT_39(256'h042704F700F7FF04F45F07C484F78407F4F40487F4C7F40707F70404500710C4),
    .INIT_3A(256'hF40774F78407F4F40477F4C7F40707F704040706C4F4C000F7F407078404F7F4),
    .INIT_3B(256'hF40487F4C7F40707F7040407F70781A145801090000700070007078F0784C4FF),
    .INIT_3C(256'h0707C70704070704F097F0F7870407F00747F007C7E7F707CF07C484F78407F4),
    .INIT_3D(256'h0404070430E7810481478150E7970784E78404074FF007E70704E707C7F408F4),
    .INIT_3E(256'h07C484F78407F4F40487F4C7F4F7FF04040740C4F407078404F7F404170407F7),
    .INIT_3F(256'h07E7F7F767810740C4F407078404F7F4041704F700F7FF04F40101470707074F),
    .INIT_40(256'hF78407F4F40487F4C7F4F7FF04F4F44F07C484F78407F4F40487F40407F70404),
    .INIT_41(256'h500020B4500010B45000F707F4E7810481B78130E7970784E78404271F0784C4),
    .INIT_42(256'h0111000100E78104D004E78104814781070707C70081F781E78104B4500030B4),
    .INIT_43(256'hF4D000D000D000B40111000100847444074750000702F7F40404040404F4F405),
    .INIT_44(256'h0007C4070501010181D0000111000100C5011100F0C417D000070784C4044507),
    .INIT_45(256'h050111000100070484F4470247020784F44702470281010181F0C5F405810101),
    .INIT_46(256'hF7071F0784F0F00507071780A4810101810007C40581010181F49F0007C41F07),
    .INIT_47(256'h0706B401110001000704F0C417F484D7F706C470009084F78404011100010780),
    .INIT_48(256'hC40784070070908704C4F7270007E4040784809FF74484E7040617F744F4F4F4),
    .INIT_49(256'h078407E707F4A48100810707840740D7878407C0D787841044050101018100E4),
    .INIT_4A(256'h07E48404F0F0008417F704070704F48440C4A42181010107D787840784070744),
    .INIT_4B(256'h07C41F1004078007879F17E704F0078407F41727849F00F4074707F70007E706),
    .INIT_4C(256'hF4C407044007F4C4078474F4F4050984F7F7F0C4000787C00784E404F404F4F4),
    .INIT_4D(256'h0704008084008410F400A0F4F484D084840507044007F4C400840784F7078407),
    .INIT_4E(256'h810001079FFF848487F414F4D4B401110001010000845084070440848407441F),
    .INIT_4F(256'h84F4840484E700D70336D7837084840404E4C4A4810101008407E7C48404F405),
    .INIT_50(256'h84E7D40417408404F7F7840787F484F4F407F7F784B4010101810784071F0484),
    .INIT_51(256'hF784F7E404F4C08484E7E484F4F48484F707F48484F707F784C4A48100818404),
    .INIT_52(256'h17F4E484A4810081F7840707F7F484F4B40101010784078417008401010107F7),
    .INIT_53(256'hF707840007F48404A481008184070717F404F4B401010107F7E4F4F7E407F407),
    .INIT_54(256'hE70000B0E7000581008184F0074407F4840707E484172784F484F7F70784B007),
    .INIT_55(256'hF00700810001000784171F0700011100810000F407F00700E7F4F40101010007),
    .INIT_56(256'hF407E7F7E7F7F4DFF7F404F7F4F4F4172784F4F404040581010107F007000707),
    .INIT_57(256'h07C00000F79F740007F7F7F7F7F45FF7F41FF4F4079F1F74F7F7F7DF17007404),
    .INIT_58(256'h74F7F7F7F4C0F7F40404058101018104F7F4F4F4F784F7F707F707E70407F4F7),
    .INIT_59(256'hF4F4079F1F74079F1F748074D07405F7F7F4F4F47404F4F4F4071F9F74071F9F),
    .INIT_5A(256'hC4F4D4071F9FC410D480C40580200111000107F7F7F417F4840704F487000000),
    .INIT_5B(256'hB44707D4F7F4C0C420D4979FC460C400C4F4C407E7F7E7F780071FC490C4F0C4),
    .INIT_5C(256'h1007E7075FF7E75B041740100707F447009F401701C104F4040581010181B4F7),
    .INIT_5D(256'h058444070606A48101018110446040070004F08407F4848407C4F4800784C481),
    .INIT_5E(256'h054010011100010700600FC0508FF404060707C437C0D0C410C4E0C4E0C4F0C4),
    .INIT_5F(256'h8407071704050111008107F47417F48484840404A481000107E7F7F4F4F7F7F4),
    .INIT_60(256'hF7070707F78404F4A48100010780F7F7071700800007C4050737F707F7078407),
    .INIT_61(256'h2078254852202E7420200107E784F484F7F474170007F707010717E407408007),
    .INIT_62(256'h09256F09002020092569090076676409007020006C7320206F64207869200A73),
    .INIT_63(256'h206520002D2D2D2D2D2D2D2D0A0A00255B647909006C7563090D657209682065),
    .INIT_64(256'h2D2D2D2D2D2D2D2D00202020302020202000647469675253494400694465206F),
    .INIT_65(256'h65202065652020206E73206565204D610920203A722000202E65206E65762000),
    .INIT_66(256'h5D6572206565200028656520200078726F20656520206E66206E786573200068),
    .INIT_67(256'h206F65650075730A6C2030653A722000696E0A303A307220320A0920653A7220),
    .INIT_68(256'h25642036680D6D203E70732036735400366E6E006461200A2D2D2D2D2D007852),
    .INIT_69(256'h00442000535452472072726D20006365432353206E4E785449204D7472202000),
    .INIT_6A(256'h4B204D4B2000204B2000204B200053742048537420320020002038636F3A2045),
    .INIT_6B(256'hFFFFFFFFFFFFFFFFFFFF75666D70494F6C67003A6478750D4300540030726C4D),
    .INIT_6C(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000FF),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized2
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h000083000081FE84020000D60008000100000000000000000000000000000000),
    .INIT_01(256'h0A090807060504030201300021340F0F0D0D0B0B090906060404020200004D00),
    .INIT_02(256'hFC04FC030000FE00FE00020F03410041FFFEFE0FFEFE000003FD110F0E0D0C0B),
    .INIT_03(256'h0000FE00FE00020F03410041FFFEFE0FFEFE000003FD0400FEFDFE000000FC10),
    .INIT_04(256'h8A8A780EFE00FEFEFE1920200E0000FC03FD0400FEFDFE000000FC10FC04FC03),
    .INIT_05(256'hFCFEFE000AF50300FE01FEFEFE00AB00AC00AD00AE00AF00B0008A00008A0200),
    .INIT_06(256'hFCFD7900FD0FFC0F0600F80001000000000000FB0FFA0EFC0000000A00BAFCFA),
    .INIT_07(256'hF901FAFFFD00000000008AFC00FE00FC0F026E040E8E0073000FF800FEFE00FC),
    .INIT_08(256'h02007F000FFA82FCFC0000008C0200000020FC9B00820FFCFD82020000002000),
    .INIT_09(256'hFCFDFB00FC0F024B00FD00F70000020076000F00020079000F0002007C000F00),
    .INIT_0A(256'h00FB0039000000FB00FBFA8000827F08F7BAFF0042000F4B02F501000046000F),
    .INIT_0B(256'h000020FCFAFAFEFEFEF80A080002000000FEFCFC8A0000000302000A007D0081),
    .INIT_0C(256'hFFFCFC0020FC02000000F900FE00FCFCFDFC0F03FCFEFBFE00FB00FB00200080),
    .INIT_0D(256'h0000FC0F05FCFD080002FA0D00560200FDFF00FAFD0000FC3AFD0002FD0019FC),
    .INIT_0E(256'h0009007900FE49FD4802F8D4FF000702F60100000202FAFCFFFCFC000000FE00),
    .INIT_0F(256'h00200F0420FC00FEFEF920FEF920000FFC00FEFE0000FE20FEFCFCF8F8000706),
    .INIT_10(256'h01FE02FE0500FA00FD00FEFE000400FEFEFCFCFC00FC04000600FD002000000A),
    .INIT_11(256'h0CF303020000000000FE8381008320FC02FD0200000100000000FE00000000FE),
    .INIT_12(256'hFA03FA101E2B00202C000F2E00152F001224FAFAFCFCFEF4F4FEF4F4F6F60084),
    .INIT_13(256'h1E2A06F84C1B00F8FEFEF60000F728F60026051EF8002424002212FD0001F901),
    .INIT_14(256'hFEFE0000008C2A030A82002AFDF92B1000290A0010F88145140005F707F700F6),
    .INIT_15(256'h02014F00000000008500840000FE0F0000FF0D0C00260026040000FDC500FA82),
    .INIT_16(256'hFF87FD410000001000000100FE00FE00010030000931000600080000008400FE),
    .INIT_17(256'h000002FE0100231A000310000018000000841400001C00FF0100008710190000),
    .INIT_18(256'h0000010F0010000F01410000000F014100004100000003FEFD41000000100000),
    .INIT_19(256'h020F001000FD0102000001868610FCFCFE0200010F001002000001868610FEFE),
    .INIT_1A(256'h00100000000000FE030000000100020003FD000004000006000000FCFC000200),
    .INIT_1B(256'h102800C200102B000000868610DD390000FEC70000FF00845700006DFD410000),
    .INIT_1C(256'h02000000000000000010000002FE0210021000000100000010FC03FD02019602),
    .INIT_1D(256'hFE000000000402000203EFFD0200FCFD880000ECFC88FC0000FCFCFCFCFC0002),
    .INIT_1E(256'h9878000000000000007D009C0087818787DBFC01000000879E000000CA00FCFC),
    .INIT_1F(256'hFD8FFD8E00FE00FF87028787C8FC6F0092029C0000880000000015FEFE87D1FC),
    .INIT_20(256'h0210FC0000000010000003C0FE0200FEFE8900FF00FE02FC0000880000020000),
    .INIT_21(256'hFE02010F0002100002100000FE0210FD00008686108128000210000200000000),
    .INIT_22(256'hFCFC0402000100E3000410F804100000FE100000000000001000000F10EE0000),
    .INIT_23(256'hE0D70002C0000000E4DB0000010000030000FD0FFC00C900000084FCFEFCFCFC),
    .INIT_24(256'h000FFE200000000F000F202000FEFE00FEFE0CFEC0000FFEFE00000000CA0000),
    .INIT_25(256'h0FFF20000002000C030C040003FE000002000300FD03FD0000000002FD020000),
    .INIT_26(256'h78000003037A00000003030F030000FD0003000FFD20000320010F03FD200003),
    .INIT_27(256'h20A700200003EC00030020FE1EFE731F107000007200200FFE20002000030000),
    .INIT_28(256'h01FCFC00FCFC000000FFFC04020002000000FE00020003FEA70020A70020A700),
    .INIT_29(256'h0000030020FE0000100300200300202000FE0403FD000000FDFEFE0001FCFE20),
    .INIT_2A(256'h2006FE0001030020FE000003002000000200000002000FFE2000200007030020),
    .INIT_2B(256'h0FFED80000000303000302000001000003030300200300202000FE0000000000),
    .INIT_2C(256'h0000080300200600000000FEBFFEFE0B00FE0D000F58FE0F0000000400FE0008),
    .INIT_2D(256'hFC0201000003F800030020FE000E0000000303FE00FE0201FEFE0100FE00FE03),
    .INIT_2E(256'h00207900AEFE00FE0302003EFEFEFDFE0302000300FCFEFE00FEFE000103FE04),
    .INIT_2F(256'h2003FD0201000000000202030000000200000600FE00086E1D00000002FE0000),
    .INIT_30(256'h0000FBFCFC0000FDFEFE3700FEFAFC04FB0300FCFE00FCFDFD0020FE00800000),
    .INIT_31(256'h0000200000000000000020000201FF01000000200020000F020F020100000400),
    .INIT_32(256'h04030500000000FCFDFDFC01FCFC00FC000000FFFCFE892002FC0100FE000F02),
    .INIT_33(256'h28000FFE9400FDFDFFFCF500FE00FD0FFE0000000003020000002FDFECF200FF),
    .INIT_34(256'hFAE100FE00FBFC1220FDB8000000FD59FD0FFCFAFE00000000FA060400020000),
    .INIT_35(256'hFB00FE00020FF8FE00090071FE0E000FFAFA00FAFEFE4E00FE0000FBFCFBFDFF),
    .INIT_36(256'h000000027A00FA000300206020030020002000000089FEF0FA050400050000EC),
    .INIT_37(256'h00200F00020F020F0200000F0302FE0000020F020E0000000020000000000200),
    .INIT_38(256'hFC0000FDFC00FFFCFE2000020F0F2000002000030F08030F0002000F00FE0003),
    .INIT_39(256'hFC00FC000000FFFCFC9900FDFD00FC01FCFCFC00FCFFFC80000FFCFC150000FE),
    .INIT_3A(256'hFE00FD00FC01FCFCFCFFFCFFFC90000FFCFC0000FEFE00100FFC0000FDFCFEFC),
    .INIT_3B(256'hFCFC00FCFFFCB0000FFCFC240000A789F001003200004000000000D500FDFD50),
    .INIT_3C(256'h00030300FD0300200F020F0F02FE000000020F0002000F00F000FDFD00FC01FC),
    .INIT_3D(256'hFCFC00200000892089008900000200FE00FE20B0910F030300FD000303FC00FC),
    .INIT_3E(256'h00FDFD00FC01FCFCFC00FCFFFC00FFFCFE0000FEFC0000FDFCFEFCFC00FC200F),
    .INIT_3F(256'h00000F0F01A70000FEFC0000FDFCFEFCFC00FC000000FFFCFE898900020001C4),
    .INIT_40(256'h00FC01FCFCFC00FCFFFC00FFFCFEFCAC00FDFD00FC01FCFCFC00FCFC700FFCFC),
    .INIT_41(256'h480000FC4A0000FC4C000F06FB00892089FF8900000200FE00FE2000F600FDFD),
    .INIT_42(256'h08060004000089200020008920890089000003020089FE89008920FC460000FC),
    .INIT_43(256'hFE280029002A00FC0402000700F9FAF802CC310000000FF8FAFAFCFCFEF8F800),
    .INIT_44(256'h00FEFE000002FE02011C0002000000007001000001FE0023000000FCFEFE7500),
    .INIT_45(256'h00030200010000FEFEFE0000000000FEFE0000000000FE0201FF66FE0000FE02),
    .INIT_46(256'h0000F6FCFDFFFF0000000003FC02FD02010000FE0000FE0302FEBC0000FDF400),
    .INIT_47(256'h0000EC151400030000FE00FE00FCFC000F00FE050300FC00FCFE040200020000),
    .INIT_48(256'hFE00ED00030500EFFFFE00000600ECEC00ED01FB02ECECEEFF000002ECEAECEC),
    .INIT_49(256'h00FE000200FEFE0000010200FE00020000FE00040000FE00FE0002FE151400FE),
    .INIT_4A(256'h00F8F9FCFFFF02F900FC000000FAF8F902F8FA0506F902000000FE00FE0002FE),
    .INIT_4B(256'hEEFCF000FC00020000FA0004000200F9FD000000FCF903FC0008000000023200),
    .INIT_4C(256'hFCFC00FA0200FCFC00FAFCFC400000FC080F08FC0000002100FAF8F9FCFDFCFC),
    .INIT_4D(256'h00FD0107FA03FA00FC0400FCFCFD02FAFD0000F91000FCFC02FAFAFCFFFCFC00),
    .INIT_4E(256'h02000200B7FFFDFEFCFC0302000003020005060000FB02FA00FA03FAFD00FDB2),
    .INIT_4F(256'hF4FEF203F30000000038000139F4F203030000F20CEF0400FE0000FDFEFDFC00),
    .INIT_50(256'hFB00FCFD0002FCFCFC00FC0000FEFEFEFE040000FCFC05FB110D00FE00A4F3F3),
    .INIT_51(256'h00FC0FFEFEFE03FEFB00FEFEFEFCFDFD0001FCFDFD0F0800FCFAFC040004FCFD),
    .INIT_52(256'h00FEFCFDFC02000240FE0000FFFEFEFEFC03FD0300FDFEFE0001FD03FD0500FC),
    .INIT_53(256'h0000FD0200FCFDFEFC020002FD000000FCFDFEFC03FD030040FEFE0FFE00FE00),
    .INIT_54(256'h00101001001000000002FE4000FE00FEFE0000FCFD0000FEFCFD0F4000FD0200),
    .INIT_55(256'h0F001000000100FCFE00F70002020000020002FE020F001000FDFC03FD020000),
    .INIT_56(256'hFE00020F040FFCF10FFAFE0FFAFEFE0000FDFEFCFCFC0004FA02000F00100000),
    .INIT_57(256'h00070000FFD4FD0200EE0F040FFCE50FFAF5FEFE00DCDDFD0FF80FF80000FDFF),
    .INIT_58(256'hFE0F060FFE1A0FFCFEFE0002FC0605FE0FFAFEFE02FD0002000000FCFFFDFE00),
    .INIT_59(256'hFEFE00B3B4FE00B5B6FE00FE00FE00F20FFEFEFEFEFFFEFEFE00BFBFFE00C1C1),
    .INIT_5A(256'hFEFEFE00A4A4FE00FE00FE0014000200000300FA0FFE00FEFEFEFFFE00040000),
    .INIT_5B(256'hFE00EAFEFFFE00FE00FEFA97FE06FE06FEFEFE00020F020F07FD9FFE03FE02FE),
    .INIT_5C(256'h00000000900FFA00FE0002000000FC01048A06028A89FEFEFE0002FC0201FE00),
    .INIT_5D(256'h00FDFD000000FC02FC040300FE00000000FE0FFE08FEFEFD00FEFC0900FEFCAA),
    .INIT_5E(256'h00030003020003000000E70101E8FCFD000200FC0006FFFE00FEFFFEFFFEFFFE),
    .INIT_5F(256'hFD000000FE0003020002FCFEFE00FCFDFEFDFEFDFC02000200FC0FFEFE0F00FE),
    .INIT_60(256'h0041000000FEFEFCFC020002000000FF000003030400FE00000002000000FD00),
    .INIT_61(256'h6820645F58452E2066570300F2FEFEFE0FFEFE00014100018A0100FE00060041),
    .INIT_62(256'h5378694500096146646C540065732044006C73007965620D752C740A6C6E0D74),
    .INIT_63(256'h4D7220002D2D2D2D2D2D2D2D0D0D007825207454006C6365460A206550206D20),
    .INIT_64(256'h2D2D2D2D2D2D2D2D00202020324420202000692E74722D436E69006141644463),
    .INIT_65(256'h207461206E50006473206F206E500A6E3A4D0020205400206967202073652000),
    .INIT_66(256'h3A736544206E50007965767541005D656965206E50006C7465646D2065500065),
    .INIT_67(256'h0A6673610072700D654E0A72202054006C670D003030654D0A0D3A4D74202054),
    .INIT_68(256'h3064536C200A62460A6C663C6C7342006C7474003E743C0D2D2D2D2D2D00003A),
    .INIT_69(256'h006548005441202043726F65440075726F233A31736F00554E537F6520744600),
    .INIT_6A(256'h2053482053004D2053004D205300446543434465434100450045786B20004352),
    .INIT_6B(256'hFFFFFFFFFFFFFFFFFFFF6C6F616C545278200020610A73002000520038656F48),
    .INIT_6C(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000FF),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized3
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h1313030F13837303937393139373976393131313131313131313131313131313),
    .INIT_01(256'h83838383838383838383839B7313732323232323232323232323232323231333),
    .INIT_02(256'h23932367030F03238323839383239B831B83836383B723A39323738383838383),
    .INIT_03(256'h030F03238323839383239B831B83836383B723A39323670383832323839B9B23),
    .INIT_04(256'h13232337B79303936F23932337B713B79323670383832323839B9B2323932367),
    .INIT_05(256'h232323A313236703139303936F0F139713971397139713971397132393132393),
    .INIT_06(256'h9323831393638383B723232383239B839B831393638383B79B931383B7EF1793),
    .INIT_07(256'h032383B3B723EF830303036F839B238383B723139313979313638393839B2383),
    .INIT_08(256'h9313931383B783039B2383B383139BEF9B936FEF178363839323139BEF9B9323),
    .INIT_09(256'h83B383238383B7231393839323839313931383B79313931383B79313931383B7),
    .INIT_0A(256'hE393238313938393139B6FEF1783EF17931363B7831363831313232323931363),
    .INIT_0B(256'hB79B93139323238323A39323131383EF93938303032323139323131383EF1783),
    .INIT_0C(256'h1B839B23936FEF63EF9313E31B238393238383B723939B6F9B9B63932393E3B3),
    .INIT_0D(256'h839B8383B723B383139B936F13EF179B8363B7839B2393039313239B932383E3),
    .INIT_0E(256'h131383931383EF17EF17931363B7831313232323939B93E31B839B1323830363),
    .INIT_0F(256'hB7931323930F93839B23936F23932337B793839B238303936F23232393139323),
    .INIT_10(256'h1B8393236703939B8323839323839383036F2323232313131303132393639383),
    .INIT_11(256'h1323670313830F93130F83837303EF17132367039B9B83B3B3939B1B9B93939B),
    .INIT_12(256'h1323B793EF1713EF1713EF1713EF1713EF171323232323A323232323A3232313),
    .INIT_13(256'h93EF1793231313E3839BEF9BEF9BEF17EFEF172383EFEF1713EF179B23231323),
    .INIT_14(256'h039BEF93B383EF172383EFEF1713EF1713EF17B783EF2313131363136313EF83),
    .INIT_15(256'h670313131313939313EF03A313236F131323670313EF17EF1713631B6F139383),
    .INIT_16(256'h130313639B93939313131383EF931B238323EF1313EF1313EF93EF9393831323),
    .INIT_17(256'hA3239323670313EF1313EFEF9393EF939383EFEF9393132367030F0393231393),
    .INIT_18(256'h131313132313B7939B939B9B83939BB39B9B831B9B83931313639B939393A323),
    .INIT_19(256'h1313239303933383836F9B832303B7932313131313239303836F9B832303B793),
    .INIT_1A(256'h9393A32323931323670383A383A383A383A36F93631363931363938393131313),
    .INIT_1B(256'h13B713EF1783B7136393832303B71313EF93831313938383EFEF939313639B93),
    .INIT_1C(256'h231313136F9B9B9393931313131323930F03B76F9B9B9393932393236703130F),
    .INIT_1D(256'h2323A32323932313130313E31B03839B2313939313836FEF9383839393931313),
    .INIT_1E(256'hEF17139393939393EF8313EF178323032313136F13639303EF1793EF83131303),
    .INIT_1F(256'h93EF17EF170323930323832313136F13EF1783979313639393EF832393231313),
    .INIT_20(256'h0F13B79B9B93939313131383E31B03839BEF179B839363830393832313932383),
    .INIT_21(256'h23670313EF9313B76F13B79B9BA393136393832303B713130F93EF9323131313),
    .INIT_22(256'h939393231313830F13239313239363938383B76F9B9B939393EF939323B71313),
    .INIT_23(256'h93EF1313EF13139B93EF1313EF23131383EF93039B1B831313038323B7239393),
    .INIT_24(256'h03B723930F1BB79323B723930FB7932383932383B3B7B3B72313131383EFEF93),
    .INIT_25(256'hB72393E39383B7631B9383939393E39383B723939B239323232393132367030F),
    .INIT_26(256'h0313939383B71363939383B72313B79B0F1303B723930F13931B832313930F13),
    .INIT_27(256'h93231B930F13B79B9B93936FEF1793EF179313938313EF1723932393639B9393),
    .INIT_28(256'h23839323839323931393032323131383938393A3EF939393231B93231B93231B),
    .INIT_29(256'hEF9B9B93936FA3EF9B9B9393231393131323670313A3EF939B1B9B2303838323),
    .INIT_2A(256'h93EF6F939B9B93936F939B9B9393E39383B7E39383B7EF23932393EF9B9B9393),
    .INIT_2B(256'h9383932363939383B713B723131383831313B7139323139313A36F93B79BB79B),
    .INIT_2C(256'hA3EF9B9B93936F936F63938393EF6F93A36F93A363836F9363136393139BA3EF),
    .INIT_2D(256'h236703130F13B79B9B93936FA3EF1363939383B713236703131393A36F9393EF),
    .INIT_2E(256'h9B931313EF171323670313E30393EF6F2323131313E30393E303932383232323),
    .INIT_2F(256'h9323236703136F6FEFEF939363136393136393139BA3EF931363B31383B79BB7),
    .INIT_30(256'hEF931B1B9BEF931B1B9B2323939323132367039393238393231B936FE3B3B79B),
    .INIT_31(256'hB7239313131313E39393931313B72367031313931393EF2313B783B723131383),
    .INIT_32(256'h6703131393830383B393232383932393239313930323832313236703139B9B83),
    .INIT_33(256'h6F13638393131303A38393631363136383A32323239323131383EF13EFEF1323),
    .INIT_34(256'h8393631363136F9323932397BB931BEF17638393A3A323A31323232313138383),
    .INIT_35(256'h931393A3EF638383238313B3B76F13638393A3EF6F6FEF1793A3EF931B1B9B23),
    .INIT_36(256'hE3B31383B7136F9B9B9393239323939323936F1393232323B79323131383836F),
    .INIT_37(256'h9393132313B723B723B793939383B7930F13B723B7B79BB79B93E313B31383B7),
    .INIT_38(256'h03B3839B2323930323230F13B723930F13930F13B72337B72313B79393939B9B),
    .INIT_39(256'h93239323931393032393139303239B1B83839323839383B3B7B3B72323EF9383),
    .INIT_3A(256'h6FB793239B1B83839323839383B3B7B3B723EF938383B7236383B3839B232383),
    .INIT_3B(256'h839323839383B3B7B3B723239BB78323EF1723931363B313936F9B9313130323),
    .INIT_3C(256'hB39383B79B2393936F23B72303B763B31383B72313B7939393139303239B1B83),
    .INIT_3D(256'hB7232393EF0F0393231383EF0F13B79B0F139323B7132313B79B0F1303B7B303),
    .INIT_3E(256'h139303239B1B8383932383938393930323EF938303B3839B23238393239323B3),
    .INIT_3F(256'h239393939B83EF938303B3839B232383932393239313930323832333B71383B7),
    .INIT_40(256'h239B1B83839323839383939303239393139303239B1B83839323839323B3B723),
    .INIT_41(256'h6F1363136F1363136F136383930F0393231383A30F13B79B0F13932383131303),
    .INIT_42(256'h23231313830F039323930F0393231383E3939383B7A313830F0393A393136313),
    .INIT_43(256'h83F31383138313232323131383EF138393839713939363838323232323A39313),
    .INIT_44(256'h03139B23239323670313132323131383EF172313E31B2383139383B3936FEF17),
    .INIT_45(256'h239323131383EF93B313B3831383EF9393B38313831323670313EF1723132367),
    .INIT_46(256'h93939313836F6313EF9B2383231323670313EF932313236703139313EF930323),
    .INIT_47(256'h9393232323131383EF93E31B2383932393BBBB136F639313936F232313138393),
    .INIT_48(256'h1BE7839BBB6F6393B393031383E3031BE783831323036383B393238303239393),
    .INIT_49(256'h6F23938393839313131313932393838303836383830383631B232323670313E3),
    .INIT_4A(256'h9B8313232323A3232383939B8313839363232313232367038303836F2393839B),
    .INIT_4B(256'h839B13236FE383232383238393631383239B9BBB9323A36F93B3978393139393),
    .INIT_4C(256'h839B131383E3839BE7839B6F9B9BEF938393839B13632383E78383136F9B6F93),
    .INIT_4D(256'h139323E783E783236F93236F93B3E7836323EF9303E3839BE7836F9B23839B63),
    .INIT_4E(256'h13131383931393932383932323232323131383836F23E7836F1383EF83038323),
    .INIT_4F(256'h13039323230F13239323B7932313232323232323132367032313831383232323),
    .INIT_50(256'hB3030393230323236F0383232383936F8383938383232323670313B303839393),
    .INIT_51(256'h03832303136F83E3B30303136F83B393230383B39323839383239313131313E3),
    .INIT_52(256'h23838313231313131383E3832383936F8323236703B303832383232323670383),
    .INIT_53(256'h839383E31383936F2313131313E3232383931383232367039B9B1BE313039323),
    .INIT_54(256'hB7132323B713A3131313136F839BE383B3139B831323B3936F93239393836313),
    .INIT_55(256'h83A383131313831383238313832323131313E313A383A3830F1BB7932367030F),
    .INIT_56(256'h9BEF839383938393631303E313039B23B3936F939323A313236703832383E393),
    .INIT_57(256'h1383A36FA38313EFEF839383938393E31303139BEF83131363839383A38323B3),
    .INIT_58(256'h13638393839363130323A31323670313E313039B2393230383831383B3139B03),
    .INIT_59(256'h6F9BEF831313EF831313E3136313A3EF93836F9B23B39B6F9BEF831313EF8313),
    .INIT_5A(256'h6F6F9BEF8313136313631323EFA3A323131383839383A383B31BB39B2383A36F),
    .INIT_5B(256'h83A38393A38383A36313238313631363136F9BEF839383938323831363136313),
    .INIT_5C(256'h6313939393E383931B2383A36393839BB72313233723A32393231323670313A3),
    .INIT_5D(256'h23EF932323239313236703136FEF6313936FE31B23839B23E31B0393131303EF),
    .INIT_5E(256'h23EFA3232313138383EF6F13EF6F139BEF9393BB0383631B631B631B631B631B),
    .INIT_5F(256'h9363838383232323131313839B23839323036F2323131313839393839B230303),
    .INIT_60(256'h9B831B9B83036F23931313138393939B8383839393939B23EF9383939B9B931B),
    .INIT_61(256'h65000A465F522E696F616703839B039BE3839B2383239B9B831B9B9B6383A323),
    .INIT_62(256'h65206E6E003A646920656F006420736F007965002E6E650A6E204C0D656F0972),
    .INIT_63(256'h696956002D2D2D2D2D2D2D2D0A00005D7800656F00796369690962736C0D696E),
    .INIT_64(256'h2D2D2D2D2D2D2D2D0020202034562020200061205961562D6467002043206565),
    .INIT_65(256'h666F6433746C00696674666E746C0D64206500556D7200206E61202073672000),
    .INIT_66(256'h2073645433746C002F20697372003A736E6E33746C006F656E206F756E6C0078),
    .INIT_67(256'h0D207364006569206D6F0D0A446D720065202000313A73410D2020650A456D72),
    .INIT_68(256'h317274783A2065690D65653C78202000782072003E613C002D2D2D2D2D000020),
    .INIT_69(256'h00726100415443574865726F610072726D23202E652000535444436463726900),
    .INIT_6A(256'h3A447A3A4400483A4400483A44005363612058636100007200720A736F006F52),
    .INIT_6B(256'hA4A4A4981C90049090906C6F69650A540A250025640D65003A0041007873637A),
    .INIT_6C(256'h909090109060909090AC909090909090909090909090909090909090909090A4),
    .INIT_6D(256'h0000000000000000000000000000000000000000000000000000000000000038),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized4
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0116B60000B525B606258572819002D4020F0E0D0C0B0A090807060504030201),
    .INIT_01(256'h3A39383736353433323130821006253830383038303830383038303830380101),
    .INIT_02(256'h17073C803400571757173707471797179717D79C47071E0F0734003F3E3D3C3B),
    .INIT_03(256'h3400571757173707471797179717D79C47071E0F0734803457D73C3037878730),
    .INIT_04(256'h0783A0E70787378700A087A0270707070734803457D73C303787873017073C80),
    .INIT_05(256'h34302A0F04348034008737870000077707770777077707770777078587078487),
    .INIT_06(256'h87A03705858C47A70726342427248727872705858C47A707878787A707406507),
    .INIT_07(256'h372E2777072A00275757570027872227A7072205078575070588470727873C37),
    .INIT_08(256'h87970785A707B727873C3787275787008787004065B78E4787B0578700878730),
    .INIT_09(256'h4787662E27A7072E058527F73C3787970785A70787970785A70787970785A707),
    .INIT_0A(256'h6A872C270585B7978787004065B74055F7000407270588478506203C38870588),
    .INIT_0B(256'h1787870007283C372E070738010130000507A7B7B792A00787300101304055B7),
    .INIT_0C(256'h8727872A87003094008506F087262787A037A7072607D70087D78EF72E879E77),
    .INIT_0D(256'h278727A7072007670587070005405587270A0727D724872707852887072827EA),
    .INIT_0E(256'h01013007053530553055F7000407278506283430878707EC8727870030372770),
    .INIT_0F(256'h078700A08700072787A08700A087A007070727873437278700342A2E07070430),
    .INIT_10(256'h8727073C80340787272E2787343707C7C70030342E30040101340026879CF7A7),
    .INIT_11(256'h04348034003700870000B735253740550434803487872767F7869787878786D7),
    .INIT_12(256'h073C178740550540550540550540550540550538301B2E02123C0B2803123C07),
    .INIT_13(256'h07405507300505E427874087408740554040552637404055054055871BB007B0),
    .INIT_14(256'h2787F0850727405524B7F040558540550540552757F0B007050512F70AF74047),
    .INIT_15(256'h803400050607878707004707043C0005043480348540554055051087008587B7),
    .INIT_16(256'h67D700D497878787040101300087872627260005060005060005000506C7043C),
    .INIT_17(256'h0526073C80340000050600000506000506C70000050604348034003787907787),
    .INIT_18(256'h04010100B0870787D7E797974787D767979747979747879700D4978787870405),
    .INIT_19(256'h0100BC874797673737F0D7C7B0B707873004010100B8876737F0D7C7B0B70787),
    .INIT_1A(256'h878703242686043C8034470747074707470700078A0780860784864707870401),
    .INIT_1B(256'h0707053055B7070588F7C7B0B7070506F005670506F747C700F0050600D49787),
    .INIT_1C(256'h38010100F08787878787040101853487004707F0878787878734073480340000),
    .INIT_1D(256'h3C03032426073801013400E687274787B087870785B400F00527460707878704),
    .INIT_1E(256'h2055058587878787F047052055B7B0B7B0078500050A87B7305587F047858627),
    .INIT_1F(256'h8720552055363CD7B734B7B0078500052055B7578707948787F0472207B00785),
    .INIT_20(256'h000707878787878704010130E887274787205587278716362787B7B087872027),
    .INIT_21(256'h3C803400F0050707F00707878707870094F7C7B0B70705060087F00538010100),
    .INIT_22(256'h078707380101300005B88700B8878CF747B707F08787878787F00506BC070504),
    .INIT_23(256'h06F00506F085068787F00506F030010130F00546878727850647C72C07340787),
    .INIT_24(256'h5707908700070787900790870007E71057E71057671777C71004010130F0F005),
    .INIT_25(256'h07908794F7A7070287975707D7F794F7A7071097D714972A2C2E860434803400),
    .INIT_26(256'h570585D7D7070582F7D7D707901707D700572707A08700578787279017870007),
    .INIT_27(256'h87A0878700070787879787002045072045070585470520459087168790879787),
    .INIT_28(256'h1457E71457E7148787875718380101300747F7070007D7F7A68787A48787A287),
    .INIT_29(256'h00878797870007008787978790178787043C8034850BF0058607873C57375734),
    .INIT_2A(256'h870000078787978700078787978794F7A70794F7A707F0908716870087879787),
    .INIT_2B(256'h074707078AF7D7D7070707380101304757670797879017878707000707870787),
    .INIT_2C(256'h0700878797870007004686470700000707000707884700070A874686078707F0),
    .INIT_2D(256'h3C803485000707878797870003000582F7D7D707043C8034850007070007F700),
    .INIT_2E(256'h878700051045043C803400F23787F0003C30010100603787F037873C37303434),
    .INIT_2F(256'h873C348034850000000007070887428607DA86078707F007059C7787A7078707),
    .INIT_30(256'h000586078700058607873C30870730043480340707343787A08787008E771787),
    .INIT_31(256'h0780870401010092F7F787000707348034007787F787F0807707C70730010130),
    .INIT_32(256'h8034008506363737E7973C1457E714F7148787875718B734043C8034008787C7),
    .INIT_33(256'h00058A470785862709470718F710F78047092A2C2E0730010130F005F0F00434),
    .INIT_34(256'h470718F710F700873897A04707878710358A47D7020E0F0F8730383801013047),
    .INIT_35(256'hF700F703F0844737343705772700058A478703F000001035F703F0058607870F),
    .INIT_36(256'h8A7787A70705008787978790872297872287000787B020241707300101304700),
    .INIT_37(256'h978700908707800780078787D7D70787000707800707870787871C877787A707),
    .INIT_38(256'h266757972C108757142E000707908700078700070790170790870787E7878787),
    .INIT_39(256'hF710F7108787875714078506272C87872757E71057E757671777C71026F00527),
    .INIT_3A(256'h0087F72C87872757F71057E757673777C710F0056667072688476757972C1057),
    .INIT_3B(256'h57E71057E757671777C710268707A780003580870580778787F0878785866726),
    .INIT_3C(256'h67D7D707972897870080078027078A7787A70790870787F7878506272C878727),
    .INIT_3D(256'hC7102687F000578780F7C7F0007707D7007787241705901707D7005727076727),
    .INIT_3E(256'h8506272C87872757E71057E757E7875714F00527266757972C1057E710F71077),
    .INIT_3F(256'h268787F787A7F00527266757972C1057E710F7108787875714B7B077F797A707),
    .INIT_40(256'h2C87872757E71057E757E787571407078506272C87872757E71057E71077C710),
    .INIT_41(256'h00051AF700051AF700059A47F700578780F7C705007707D70077872427858667),
    .INIT_42(256'h3438010130005787808700578780F7C780F7D7D70780F7C700578780870518F7),
    .INIT_43(256'h37270535053505343C38010130F00747D5A737058587804737343C343C070707),
    .INIT_44(256'h3400872426073C80340005343801013000253001DE8726270585270797000025),
    .INIT_45(256'h2E07300101300005070707B787B700850707B787B7043C803485F02530043C80),
    .INIT_46(256'h07070705C7001687F0873C3726043480348500F726043C8034000705F005272C),
    .INIT_47(256'h0706343C30010130F007D6872627D7840787060600E6F6F7F700343801013007),
    .INIT_48(256'h870035878700F6868797A707274C27870035270034376C678797262737260787),
    .INIT_49(256'h003086370727870401018597308637B737B78027B737B7D08722343C8034004C),
    .INIT_4A(256'h86C7872A2426033C3C37078437853787823830043C348034A737B70030863787),
    .INIT_4B(256'h2787002AF0DA272438373C3707DC87C724878787072403F0070727A787979707),
    .INIT_4C(256'h47870985374A2787003587008787008524074787091638370035A787F087F007),
    .INIT_4D(256'h85072A803580352800072A0007078035D03CF005274E27878035008724278784),
    .INIT_4E(256'h04010130070505863437073830383C3001013430F03C8035008537F03527473C),
    .INIT_4F(256'h85378734341007B886A4B686A0073C34343C3438043C8034B0873777B7343438),
    .INIT_50(256'h073747863C37383C003737B0303707003737F737373C34348034850737378506),
    .INIT_51(256'h373780278700376E07373787003767973C373767973C27F73722870401018568),
    .INIT_52(256'h3837C7873804010185379E3738378700373C3480340737C73437343C34803437),
    .INIT_53(256'h3707C7028737870034040101859E8034370700373C3480348787870E7747F707),
    .INIT_54(256'h1707A2A0170707040101850037879A37878787C787348707008722B707C71C87),
    .INIT_55(256'h4707A70401013000C73437853734380101001AF7074707A70007170734803400),
    .INIT_56(256'h87F04707470747077C7747667747873C87070007073007043C80344707A78EF7),
    .INIT_57(256'h074707F0074785F0F04707470747071477470087F04705858847074707478407),
    .INIT_58(256'h8586470747077277472407043C8034856C7747873C07303737C70747877787C7),
    .INIT_59(256'h0087F0470585F047058518F706F703F0F747F0878007870087F0470585F04705),
    .INIT_5A(256'h000087F0470585EAF716F706F006053801013067F7470747E7870787242707F0),
    .INIT_5B(256'h470547F70647470718F7064785E6F7FEF70087F04707470747064785E0F7F8F7),
    .INIT_5C(256'h1E878787078C47878720270F88F747871720059017A00F2C0726043C80348505),
    .INIT_5D(256'h26008526282A87043C80348500F01A8787F0F687222787260E07270785062700),
    .INIT_5E(256'h24F0073C3001013027F00005F00005870085970727370C870C87E8870A870687),
    .INIT_5F(256'h879C27C7372A3C30010100078734378780C70034380401013007074787802737),
    .INIT_60(256'h97179797C7370017870401013007078727C73707070787260005370787878787),
    .INIT_61(256'h61000D494C472E6D72698034578727879C478717571797D7D7578787D0170317),
    .INIT_62(256'h710074740020646C007374000D726577002E6E002E64660974726509735F0069),
    .INIT_63(256'h636545002D2D2D2D2D2D2D2D0D00000D5D007374000D65766C006F65650A7375),
    .INIT_64(256'h2D2D2D2D2D2D2D2D00202020204320202000206F2C6D2956696900202C427673),
    .INIT_65(256'h6920643265650067656F207565652020536D00416F610020204020206F612000),
    .INIT_66(256'h30202042326565006E666369650020737474326565006172747064736465005D),
    .INIT_67(256'h00722020002020006574000D656F6100206657003A4173430000536D0D746F61),
    .INIT_68(256'h36656F00204C726C0074723C003A4100003A79003E203C002D2D2D2D2D000025),
    .INIT_69(256'h00726E0042454148456420757400726F6D00305353720020525F410D6F616C00),
    .INIT_6A(256'h3A200A3A20007A3A20007A3A20004374720D43747200007200720D2066006D4F),
    .INIT_6B(256'hDFDFDFDFE0E2E0E2E2E229216E6D0D0A0D64006C64002000200050000A736B0A),
    .INIT_6C(256'hE2E2E2E2E2E0E2E2E2E1E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2E2DF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000E2),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized5
   (s_axi_rdata,
    s_aclk,
    ENA_I,
    ENB_I,
    POR_A,
    ram_rstram_b,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb);
  output [7:0]s_axi_rdata;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input POR_A;
  input ram_rstram_b;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire POR_A;
  wire ram_rstram_b;
  wire s_aclk;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h15A507F000074005104001028152000210000000000000000000000000000000),
    .INIT_01(256'h818181818181818181818102150120E1C1A18161412101E1C1A1816141210141),
    .INIT_02(256'h0405810081F0E4F4C4F40410F4F407E407C40707F41CF4F40581208181818181),
    .INIT_03(256'h81F0E4F4C4F40410F4F407E407C40707F40CF4F405810081E407F4F4040707F4),
    .INIT_04(256'h0007E74003F7841700E7C7E7A003F00305810081E407F4F4040707F404058100),
    .INIT_05(256'h040404F40111008100F7041700F0F002F002F002F002F002F00200E78110E781),
    .INIT_06(256'h47E784050707F40703F4F4F444F407440744850707F407030707070703900084),
    .INIT_07(256'h04F444F701F450442404E4C044B7F44407030430050702840507F450C417F484),
    .INIT_08(256'h010705070703070417F484F6040707D007078080000707F417E70707500707F4),
    .INIT_09(256'hF4F684F4C4070304050784F7F484010705070703810705070703810705070703),
    .INIT_0A(256'hF701F484850607370117408000070000F700F701048507F40760F4E4E4810507),
    .INIT_0B(256'h000747000404040404F40581010181806004078707E7D7878181010181800007),
    .INIT_0C(256'h078417F40700D007808560E707F4C447E78407030404270017270737F4C707F7),
    .INIT_0D(256'h440704070304F744E00740000580000784F7018407F4F7440507040780F404E7),
    .INIT_0E(256'h01018100050410001000F700F701840760F4E4E4810750E707841700F40444F7),
    .INIT_0F(256'h030700E787F0D00417E7C700E7C7E7CD03204417F48407C70094040407060591),
    .INIT_10(256'h07C4058100810007C4F4C417F484F0070740F4F4F4B40101018100F447070707),
    .INIT_11(256'h011100010084F00100F0070640848000011100810707C4F7F607870707070787),
    .INIT_12(256'hF0F430078000050000858000850000058000B004040404040404040404040410),
    .INIT_13(256'h05000010A44005E7C417000750078000C00000048440800085000007F4E730E7),
    .INIT_14(256'h84170F07F784800004074F00000780008500000064DFE7054085F7F7F7F7C0F4),
    .INIT_15(256'h000100F07010918100C0F4F40111008501110001070000000085F707C0070107),
    .INIT_16(256'hA70700078781810701010181400707F4C4F49000301000308000400000070111),
    .INIT_17(256'hF4F4058100010010001090800070400000079080006001110081F00707E7F701),
    .INIT_18(256'h01010100E781208187178727B48187F78767A48777948107000787818107F4F4),
    .INIT_19(256'h0100E7077487F704849F8747E7072006B401010100E70744849F8747E7072005),
    .INIT_1A(256'h8107F4F4F40501110081F4F4E4F4E4F4E4F400100720E60730E607F407050101),
    .INIT_1B(256'h1020858000072005071747E7072080F09F07C40700F77407C09F006000078781),
    .INIT_1C(256'h810101005F070781810701010107F407F0F4205F0707818107040581000100F0),
    .INIT_1D(256'h04F4F4F4F4058101010100E707846417E7870105070700DF07C4640706050601),
    .INIT_1E(256'hC0000507818181815F7485900007E707E705070005F70707000081DF74070684),
    .INIT_1F(256'h019000900084F40707F407E705078085100007008110078181DF740410E70507),
    .INIT_20(256'hF0F020070781810701010181E7078464179000070481F784440107E78101F404),
    .INIT_21(256'h110001008F00F0205FF0200707F40700074747E707200010F0078F1081010100),
    .INIT_22(256'h06050581010181F000E70700E7070717F407205F07078181078F005007200001),
    .INIT_23(256'h501F0030DF070007811F0030DF810101811F07C41707C40700D4070404040706),
    .INIT_24(256'h0404E7C7F00704010704E747F00407F40437F404F700F7FF04010101811F0F00),
    .INIT_25(256'h04E70707270704F707070430073707170704F40707F407F4F4F40501110081F0),
    .INIT_26(256'h0485070707048507F7070704E7070407F0074404E787F0076707C4E70747F0F0),
    .INIT_27(256'h47E70707F0100407070707C00000058000700507F4050000E727F42707070707),
    .INIT_28(256'hF48487F48407F40707F784048101018100F4F7F440300737E707C7E70787E707),
    .INIT_29(256'hC00707072740F48007070727E70747470111000107F4DF07060707F4048484F4),
    .INIT_2A(256'h4740C02007070727C0200707072707270704071707041FE727F4278007070727),
    .INIT_2B(256'h10F405F40717070704000481010181F407F7040767E7074747F4C020F007F007),
    .INIT_2C(256'hF480070707C7C020C0D707F40540C020F44050F407E4C030F707D7072007F41F),
    .INIT_2D(256'h81000107F020040707070700F4C005070707070401110001070020F4C040F780),
    .INIT_2E(256'h0747008510000111000100E78417DF80A481010100F78417E70417F4840404A4),
    .INIT_2F(256'h47A481000107800080001010F707D70720E6076007F45F100007F70707040702),
    .INIT_30(256'h80070607070007060707F4F40100B40111008100F0F48447E707074007F70007),
    .INIT_31(256'h04E7F7010101000727F7F700200481000100F797F7971FE7E704070481010181),
    .INIT_32(256'h0001000740840484E707F4F48487F4C7F40707F7840407F40111008100070707),
    .INIT_33(256'h800507F405070684F43440F7F7F7F70734F4F4F4F405810101815F005F5F0111),
    .INIT_34(256'hE440F7F7F7F7C067F407E702F70707900007D49704F4F4F407D4B481010181F4),
    .INIT_35(256'hF700F7F44F077484F484E0F7008085077407F45F40C01000F7F49F07060707F4),
    .INIT_36(256'h07F70707040500070707C7E7C7F407C7F447C007870704F40005810101817480),
    .INIT_37(256'h07C700E7810407040704818107070407F0F00407040307030747F707F7070704),
    .INIT_38(256'h84F78407F4F4F70404F4F05004E7A7F03787F0F004E70004E781048147810707),
    .INIT_39(256'h77F4C7F40707F70404050710C4F40707840407F4042704F700F7FF04F41F07C4),
    .INIT_3A(256'hC0FFF7F407078404F7F4042704F700F7FF04CF0784C400F40774F78407F4F404),
    .INIT_3B(256'h0407F4042704F700F7FF040407000707D000E7A10507F70781DF07810706C4F4),
    .INIT_3C(256'hF707070407F407E7000704E7840407F7070704E7810481B7810740C4F4070784),
    .INIT_3D(256'hFF0404470FF007C7E7F7078FF0F70487F0F787F40050E7070407F0070404F704),
    .INIT_3E(256'h0740C4F40707840407F404270407F704040F07C484F78407F4F40487F4C7F4F7),
    .INIT_3F(256'hF401B13707C78F07C484F78407F4F40487F4C7F40707F7040407E7F7FF070704),
    .INIT_40(256'hF40707840407F404270407F7040420050740C4F40707840407F40437F4F7FF04),
    .INIT_41(256'h0085F7F70085F7F7008507B4F7F007C7E7F707F4F0F70487F0F787F4840706C4),
    .INIT_42(256'hA481010181F007C7E7E7F007C7E7F7070727070704E7F717F007C7E78105F7F7),
    .INIT_43(256'h04300584050405C4A4810101818F403405070285070707348404040404040706),
    .INIT_44(256'h810007F4F4058100010005A48101018110008101E707F4C48507C4F737C01000),
    .INIT_45(256'hF405810101811000F702F7870787500102F787070701110001079F00B4011100),
    .INIT_46(256'hF0F005A00740F707DF07E484040111000107D0F7F401110001000500DF0784F4),
    .INIT_47(256'h0607C4A4810101819F84E707F4C447E704E7D6F080D7F7F7F7C0A48101018110),
    .INIT_48(256'hF7070407E780D707F6278704C4F7C4F70704C400F484F744F627E4C484040706),
    .INIT_49(256'h40D787841044050101010707D787840784070744078407E707F4A481000100F0),
    .INIT_4A(256'hD4071704F4F4F4F4F48450078404841704D4B40191110081078407C0D7878407),
    .INIT_4B(256'h840700F4DF07C4F4E404F48490E70407F40707E70704F45FD0F7000787270650),
    .INIT_4C(256'h09F7190484F0C4F7070407800707C007C4D074070909E40407040787DF17DFF0),
    .INIT_4D(256'h0704F407040704F44080F440A0F0070407F41F0704F0C4F707040007F4840704),
    .INIT_4E(256'h0101018100850007F4040404E4C4A481010181811FF407040004841F04C474A4),
    .INIT_4F(256'h070407F4F400C7E776D70336D784F4F414F4D4B401110081E71784F707F474B4),
    .INIT_50(256'hF7840717F484F4F4C00484E7D40487408404778404C4A481000107F784840707),
    .INIT_51(256'h0484E74417C084F7F78484878084F707F48484F787F4447784F40501010107F7),
    .INIT_52(256'hE4040717B401010107840784E404170084A4810081F78407F484F4A481008184),
    .INIT_53(256'h84D007F707841700040101010707E7D484170084A4810081070707F7F7F4F7F4),
    .INIT_54(256'h003007E70030F4010101078084070784E707070717F4E7078017F417D007F707),
    .INIT_55(256'hF4F447010101810007F4840784A481010100F7F7F4F4F447F0070005810081F0),
    .INIT_56(256'h075F749074F07405F7F7F4F7F7F417F4E70780101004F401110081E4F4070717),
    .INIT_57(256'h04F4049FF4F4075FDF748074D07405F7F7F400F7DF74000707F48074F4F4E7F7),
    .INIT_58(256'h0707F4807405F7F7F404F40111000107F7F7F417F4A0F404848704F4F6F70787),
    .INIT_59(256'h80F7DF740007DF740007F7F7F7F7F49FF7F41F17E7F707C0F75F7400075F7400),
    .INIT_5A(256'h00C0175FC40007E7F7F7F7F41FF4048101018184F7F4F4F4E707F707F484049F),
    .INIT_5B(256'hE4F4F4F7F4D4C4F4F7F7F4C407E7F7E7F7C0975FC460C400C4F4C407E7F7E7F7),
    .INIT_5C(256'hF70781810507F4F707F404F407177407000430E70007040410F40111000107F4),
    .INIT_5D(256'hF48007F4F4F4050111000107804FF707815FE707F44417F4F70784058107C400),
    .INIT_5E(256'hF48FF4A481010181044F0080CF806007000707F70484F707F707E707F707F707),
    .INIT_5F(256'h17E7440784F4A4810101007417F48417E70780F4B4010101810040F417E78484),
    .INIT_60(256'h07E40787078400040501010181D0E007440784F0F01007F4002084F007072707),
    .INIT_61(256'h64000946454D006120740081E40744170774F7F4E4F407070707070707E4F4F4),
    .INIT_62(256'h7500207200257265002061000A65746E002E64002E206F003A656E00206F0070),
    .INIT_63(256'h727347002B2D2D2D2D2D2D2D0000000A20002061000A73656500617461096D6D),
    .INIT_64(256'h2B2D2D2D2D2D2D2D007C2020204F202020007C66202C20206174007C20796573),
    .INIT_65(256'h6C737220726100697220666D72610053526F0052646E007C2063202072707700),
    .INIT_66(256'h785B6120207261002969656E200030202072207261006420657265692061003A),
    .INIT_67(256'h00616F61000A66006E20002062646E000A6F6100303020200000446F2068646E),
    .INIT_68(256'h6C73720020653A650065205400206400002020000A664E002D2D2D2D2D000030),
    .INIT_69(256'h006F64004C20524543006F7461006572610078540065003A5F45440A6D6E6500),
    .INIT_6A(256'h20430D2043000A2043000A204300206564002C656400006F006F203A20006D52),
    .INIT_6B(256'hFFFFFFFFFFFFFFFFFFFF000A2865000D0020007872003A0025000A000D20200D),
    .INIT_6C(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000FF),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(POR_A),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_prim_wrapper_init" *) 
module rom_32KB_axi_blk_mem_gen_prim_wrapper_init__parameterized6
   (s_axi_rdata,
    ram_rstram_b,
    s_aclk,
    ENA_I,
    ENB_I,
    \SAFETY_CKT_GEN.POR_A_reg ,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    s_aresetn);
  output [7:0]s_axi_rdata;
  output ram_rstram_b;
  input s_aclk;
  input ENA_I;
  input ENB_I;
  input \SAFETY_CKT_GEN.POR_A_reg ;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [7:0]s_axi_wdata;
  input [0:0]s_axi_wstrb;
  input s_aresetn;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 ;
  wire ENA_I;
  wire ENB_I;
  wire \SAFETY_CKT_GEN.POR_A_reg ;
  wire ram_rstram_b;
  wire s_aclk;
  wire s_aresetn;
  wire [7:0]s_axi_rdata;
  wire [7:0]s_axi_wdata;
  wire [0:0]s_axi_wstrb;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ;
  wire \NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ;
  wire [31:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED ;
  wire [31:8]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED ;
  wire [3:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED ;
  wire [3:1]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED ;
  wire [7:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED ;
  wire [8:0]\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED ;

  (* box_type = "PRIMITIVE" *) 
  RAMB36E1 #(
    .DOA_REG(0),
    .DOB_REG(0),
    .EN_ECC_READ("FALSE"),
    .EN_ECC_WRITE("FALSE"),
    .INITP_00(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_01(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_02(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_03(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_04(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_05(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_06(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_07(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_08(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_09(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INITP_0F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_00(256'h0000000F0000F10000F184FC7930000000000000000000000000000000000000),
    .INIT_01(256'h0A09080706050403020100803400340F0F0D0D0B0B090906060404020200EF00),
    .INIT_02(256'hFE000200020FFEFEFDFEFE00FDFE01FE01FD0002FD10FCFC0002300F0E0D0C0B),
    .INIT_03(256'h020FFEFEFDFEFE00FDFE01FE01FD0002FD10FCFC00020003FE00FCFEFE0000FE),
    .INIT_04(256'hFA0000F42023FE0001000D000020FF2000020003FE00FCFEFE0000FEFE000200),
    .INIT_05(256'hFAFEFAF60B0A00020083FE00010FFF00FF00FF00FF00FF00FF00F9008A00008A),
    .INIT_06(256'h0000FCB10000F70020FEFCFEFBFE00FB00FBB60000F7002000800000200600F8),
    .INIT_07(256'hFEF8FD0000FC11FDF9F9F82CFCFFFCFC0020FC02000000F8AC00F700FE00FCFD),
    .INIT_08(256'h81020000002000FC00FCFD00FC020005000F0561000000F7000002000C000FFE),
    .INIT_09(256'hF740FEFAFB0020FA8700FE0FFCFD830200000020820200000020810200000020),
    .INIT_0A(256'hFA82FAFB7E0000008C00043D00003F000F000000FA8100F70000F6F4F48A8400),
    .INIT_0B(256'h00000A00F9FCFCF8FAF80008F603023702FD01000000004F8A02FD0B0A360000),
    .INIT_0C(256'h00FE00FC0F021704383800FC00FEFE0000FC0020FEF9000100000000FA0EFC00),
    .INIT_0D(256'hFA00FC0020FC00FA02001F00580E0000FA0200FA01FAFFFD0000FC003EFCFDFC),
    .INIT_0E(256'hF90A09004AF87B007C000F000000FA0000F6F6F68A0000F800FE0000FEFEFD02),
    .INIT_0F(256'h200B00000F0F00FE00000F02000F00AC2000FE00FEFE000F03FEFCFC00000006),
    .INIT_10(256'h00FE000000040000FBFCFD00FEFEFF000004FEFEFAFC05FB070600FC0F004000),
    .INIT_11(256'h0D0C000200FE0F84000F0000F1FD3F00030200010000FE000000000000F00000),
    .INIT_12(256'h0BF810032A00242C001C2D00192F0012300001FAFCFCFCFEF4F2F4F4FEF6F400),
    .INIT_13(256'h00190000F80029FAFE00230008001F00512100FEF82E230023250000FC000000),
    .INIT_14(256'hFE00EB0000FE0B00FE00920E00000F002A110000FDD100000029020F000F10F7),
    .INIT_15(256'h00010003000085850404FEFE020000240100000C000300040025020003008100),
    .INIT_16(256'h000000000186861001FF02010A7100FEFEFE2400002600002B001B0000000200),
    .INIT_17(256'hFEFE00000000000F0000161C000B050000001A200000010000000F001000E087),
    .INIT_18(256'h02FE02000086108641000100FE8641000100FE0100FE8603000001868610FEFE),
    .INIT_19(256'h03000010FD0000FEFEFD410000001000FE03FD02000010FEFEFD410000001000),
    .INIT_1A(256'h8610FEFEFE0002000002FEFEFDFEFDFEFDFE040000000400000600FD000003FD),
    .INIT_1B(256'h0010C229000010C20400000000100803D700FE00000FFE006BE3000000000186),
    .INIT_1C(256'h02FC0100FD000086861001FF0300FE100FFD10FD0000868610FE00020001000F),
    .INIT_1D(256'hFCFCFCFCFC0002FC040300FA00FCFC0000008800000004D700FCFC0000000004),
    .INIT_1E(256'h78009A0087818787D6FC9D7D00000000000000009F00AE00040087DFFC0000FC),
    .INIT_1F(256'h8868006900FEFC0200FE0000000011897000000087000C8887CEFCFE00000000),
    .INIT_20(256'h0F0410000086861001FF0403E800FCFC00600000FE8802FEFE8800008788FEFE),
    .INIT_21(256'h00000100F1000410F804100000FE100000000000001000000F10FC0000FE0100),
    .INIT_22(256'h00000002FC02010F0002100002100000FE0210FD0000868610F3380002100002),
    .INIT_23(256'h0FCC0000E100000084D00000E500FF0403A500FC0000FD0000FC00FC00FE0000),
    .INIT_24(256'hFE2000000F002089002000000F2001FEFE00FEFE000000FFFE02FE0100D0D600),
    .INIT_25(256'h200003FE000020020003FE000300FE000020FE0301FE03FCFCFC00030200010F),
    .INIT_26(256'hFE2500030020260E00030020000320010F03FD2000000F030000FD0003000FFF),
    .INIT_27(256'h010000010F0020000003030D6E00006F00001E00FE2173000003FE03068003F0),
    .INIT_28(256'hFCFC00FCFC0CFCC0000FFCFC02FC030200FE0FFE4F0003000000010000010000),
    .INIT_29(256'h78000003031BFE1D00000303000303030200000300FCBC00000000FCFDFDFCFE),
    .INIT_2A(256'h0230040000000303070000000303FE000020FE0000209E0003FE037B00000303),
    .INIT_2B(256'h00FE00FE0A00030020102000FE0201FE031720030300030303FE000000000000),
    .INIT_2C(256'hFE4E000003030600070000FE004F0A00FE0C00FE00FE0E00000010000000FEC9),
    .INIT_2D(256'h020001000F00200000030304FE12C1020103002002000001000000FE01000F4D),
    .INIT_2E(256'h000200B07A000200000200FEFE00F601FC02FD0400FCFE00FEFE00FCFDFEFEFC),
    .INIT_2F(256'h02FC02000100000166160000000004000004000000FEA2000000000000200000),
    .INIT_30(256'h24000000002700000000FCFE8920FC050400020007FEFE0000000203FC000000),
    .INIT_31(256'h20000201FF0100FE000F02000020000000000F020F02D200FF20002000FF0504),
    .INIT_32(256'h0003000000FDFEFE0001FCFCFC00FCFFFCD0000FFCFC00FE0402000000000000),
    .INIT_33(256'h006100FE000000FDFCFD00000F020F08FDFCFCFCFC0002FD0100F000F1E70100),
    .INIT_34(256'hFB00000F020F1203FC01000000BA001F0000FB00FEFAFAFA00FAFA04FA0302FE),
    .INIT_35(256'h0F000FFEF700FEFDFEFE020200034B00FE20FEA8060B13000FFEE100000000FA),
    .INIT_36(256'hFC000000203801000003020002FE0302FE0203809D00FEFE000004FB0605FE00),
    .INIT_37(256'h030200008920002000208989030020F00F002000200000000002FC0000000020),
    .INIT_38(256'hFD00FC01FCFC0FFCFCFC0F002000030F08030F0F200000200089208900890000),
    .INIT_39(256'hFFFCFFFC90000FFCFC000000FEFC0000FDFC01FCFC00FC000000FFFCFEA300FD),
    .INIT_3A(256'h00100FFC0000FDFCFEFCFC00FC000000FFFCE000FDFD50FE00FD00FC01FCFCFC),
    .INIT_3B(256'hFC01FCFC00FC000000FFFCFE0001000030000089F0020000A7F300A70000FEFE),
    .INIT_3C(256'h0003002001FC030300002000FE20020000002000892089FF890000FEFC0000FD),
    .INIT_3D(256'hFFFCFE02890F0002000F008C0F0F20000F0F02FE0000000320010F03FD2000FD),
    .INIT_3E(256'h0000FEFC0000FDFC01FCFC00FC300FFCFCCD00FDFD00FC01FCFCFC00FCFFFC00),
    .INIT_3F(256'hFE8989000000B700FDFD00FC01FCFCFC00FCFFFC90000FFCFC0000000F020020),
    .INIT_40(256'hFC0000FDFC01FCFC00FC600FFCFC00000000FEFC0000FDFC01FCFC00FC00FFFC),
    .INIT_41(256'h028E000F048E000F068E00FC0F0F0002000F00FC0F0F20000F0F02FEFE0000FE),
    .INIT_42(256'hF806F805040F000200020F0002000F00FE00030020000F000F000200898E000F),
    .INIT_43(256'hFE3476FD76FD76FCFC02FC08078800F80200007A00CE02F8F8FAFAFCFCFE0000),
    .INIT_44(256'h010000FEFE00000001006EFE00FE0100200000FFFA00FEFE7300FE0000032700),
    .INIT_45(256'hFC0002FD02013500000040A600A82BD30040AA00AB0200000100F600FE020000),
    .INIT_46(256'hFFFF000000030000F800FCFDFE03020001006A0FFE02000002000000EA00FDFC),
    .INIT_47(256'h0000ECEC14EB0403CDFDF800FEFE00FEFF0040000000000F0F06FC02FC030200),
    .INIT_48(256'hFF00ED00000000000000EFFFFEFCFEFF00EDEB00ECEC00EC0000FEFEECFE0000),
    .INIT_49(256'h040000FE00FE0002FE0200020000FE00FE0002FE00FE000200FEFE00001400F8),
    .INIT_4A(256'hFD0000FAFCFCFCFAF8F90200F900FA003EF8FA070406000100FE00010000FE00),
    .INIT_4B(256'hFC0000FAF0F0FCFCF8F9F8F903040000FC00000000FCFCFA0200000009000205),
    .INIT_4C(256'h00FF0000FAFCFCFF00FA000200005D00FC02FC00F500F8F900FA0000EC00EDFF),
    .INIT_4D(256'h00F9FC00FA00FAFC0300FC06004000FA02FCC500FDFCFCFF00FA0200FCFC0004),
    .INIT_4E(256'h04FC070200770000FEFD04030200FC02F9070506C4F800FA0200FA9BFAFCFCFC),
    .INIT_4F(256'h00FEFDF2FE00F2000600013000F4FCF2030000F20E0C00030000FE0F00FEFCFC),
    .INIT_50(256'h00FC0000FCFDFCFC04FEFB00FEFE0002FCFC00FBFCFAFC04000D0040F3F30000),
    .INIT_51(256'hFEFB00FC0001FCFC00FCFD0001FC0002FCFDFD0000FCFC00FBFC0005FB0500FC),
    .INIT_52(256'hFCFD0000FC03FD0300FDFCFEFCFD0001FDFC02000240FE00FEFEFEFC020004FC),
    .INIT_53(256'hFD0200FE00FD0001FE03FD0300FC00FEFE0000FDFC020002000000FA0FFE0FFE),
    .INIT_54(256'h100000001008FE02FE030000FE00FAFD0000FD0000FE00000400FE0002000600),
    .INIT_55(256'hFEFE0102FE02010000FEFE00FEFE00FE0300FC0FFEFEFE010F0010000200010F),
    .INIT_56(256'h00E2FD03FD02FD000A0FFEFC0FFE00FC0000020000FEFA06040001FEFE00FC00),
    .INIT_57(256'hFFFEFEECFEFE00D5D5FD00FD00FD00F20FFE00FFDBFD020002FE00FDFEFEFC00),
    .INIT_58(256'h0010FE00FE000A0FFEFEFC0402000500F60FFE00FC00FEFEFDFCFFFE000F00FC),
    .INIT_59(256'h00FFB2FE0200B4FE0200F00F060FFEC50FFCF500FE00000BFFBEFE0200C0FE02),
    .INIT_5A(256'h110E00A3FE0200020F040FFEB4FEFE00FE0403FE0FFCFEFE00000000FEFEFEEB),
    .INIT_5B(256'hFEFEFE0FFEFEFEFE000FFEFE00040F040F03FC9BFE04FE04FEFEFE00020F020F),
    .INIT_5C(256'h0600AAAA00F8FDD700FEFEFC0000FD0010FE04000000FCFC00FC0402000100FE),
    .INIT_5D(256'hFE1C00FCFCFC00040200030000F80000AAF6F600FEFE00FEF800FD00AA00FE1D),
    .INIT_5E(256'hFEEEFEFC02FD0403FDE60101E70200080D000200FDFD04000000080008000800),
    .INIT_5F(256'h0006FD00FDFCFC02FD0300FE00FEFE00000003FEFC03FD03020008FE0000FEFD),
    .INIT_60(256'h01FE010000FD0CFE0003FD0302FFFF00FD00FDFFFF0000FE0708FD0F00000000),
    .INIT_61(256'h6500004F4E41006762690002FE00FD00F8FEFFFEFEFE01410041000004FEFEFE),
    .INIT_62(256'h650009790078652000096C000963746C002E20002E72720020613A003A660070),
    .INIT_63(256'h6F2041000A2D2D2D2D2D2D2D000000092D003A6C000973642000722073006162),
    .INIT_64(256'h0A2D2D2D2D2D2D2D000A2020204E202020000A20472050282061000A49206C6F),
    .INIT_65(256'h65746562207300742074696220730044417200546573000A2064202073727700),
    .INIT_66(256'h0068647362207300206C20677900785B6179622073002E6472656D6E66730020),
    .INIT_67(256'h006E7564000D610074690000756573000D726900313A09610000527200656573),
    .INIT_68(256'h78736500256E20200064437200256400002570000D6F6F002D2D2D2D2D000031),
    .INIT_69(256'h00726C00454944544B006320200064206E000041007300005352430070732000),
    .INIT_6A(256'h324C00354C000D314C000D324C000D6420002064200000720072002042006120),
    .INIT_6B(256'hFFFFFFFFFFFFFFFFFFFF0000296E0000003A000A650020006C000D00203A4100),
    .INIT_6C(256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF),
    .INIT_6D(256'h00000000000000000000000000000000000000000000000000000000000000FF),
    .INIT_6E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_6F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_70(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_71(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_72(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_73(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_74(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_75(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_76(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_77(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_78(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_79(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7A(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7B(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7C(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7D(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7E(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_7F(256'h0000000000000000000000000000000000000000000000000000000000000000),
    .INIT_A(36'h000000000),
    .INIT_B(36'h000000000),
    .INIT_FILE("NONE"),
    .IS_CLKARDCLK_INVERTED(1'b0),
    .IS_CLKBWRCLK_INVERTED(1'b0),
    .IS_ENARDEN_INVERTED(1'b0),
    .IS_ENBWREN_INVERTED(1'b0),
    .IS_RSTRAMARSTRAM_INVERTED(1'b0),
    .IS_RSTRAMB_INVERTED(1'b0),
    .IS_RSTREGARSTREG_INVERTED(1'b0),
    .IS_RSTREGB_INVERTED(1'b0),
    .RAM_EXTENSION_A("NONE"),
    .RAM_EXTENSION_B("NONE"),
    .RAM_MODE("TDP"),
    .RDADDR_COLLISION_HWCONFIG("DELAYED_WRITE"),
    .READ_WIDTH_A(9),
    .READ_WIDTH_B(9),
    .RSTREG_PRIORITY_A("REGCE"),
    .RSTREG_PRIORITY_B("REGCE"),
    .SIM_COLLISION_CHECK("ALL"),
    .SIM_DEVICE("7SERIES"),
    .SRVAL_A(36'h000000000),
    .SRVAL_B(36'h000000000),
    .WRITE_MODE_A("READ_FIRST"),
    .WRITE_MODE_B("READ_FIRST"),
    .WRITE_WIDTH_A(9),
    .WRITE_WIDTH_B(9)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram 
       (.ADDRARDADDR({1'b1,ADDRARDADDR,1'b1,1'b1,1'b1}),
        .ADDRBWRADDR({1'b1,ADDRBWRADDR,1'b1,1'b1,1'b1}),
        .CASCADEINA(1'b0),
        .CASCADEINB(1'b0),
        .CASCADEOUTA(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTA_UNCONNECTED ),
        .CASCADEOUTB(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_CASCADEOUTB_UNCONNECTED ),
        .CLKARDCLK(s_aclk),
        .CLKBWRCLK(s_aclk),
        .DBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DBITERR_UNCONNECTED ),
        .DIADI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axi_wdata}),
        .DIBDI({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .DIPADIP({1'b0,1'b0,1'b0,1'b0}),
        .DIPBDIP({1'b0,1'b0,1'b0,1'b0}),
        .DOADO(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOADO_UNCONNECTED [31:0]),
        .DOBDO({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOBDO_UNCONNECTED [31:8],s_axi_rdata}),
        .DOPADOP(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPADOP_UNCONNECTED [3:0]),
        .DOPBDOP({\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_DOPBDOP_UNCONNECTED [3:1],\DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_n_75 }),
        .ECCPARITY(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_ECCPARITY_UNCONNECTED [7:0]),
        .ENARDEN(ENA_I),
        .ENBWREN(ENB_I),
        .INJECTDBITERR(1'b0),
        .INJECTSBITERR(1'b0),
        .RDADDRECC(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_RDADDRECC_UNCONNECTED [8:0]),
        .REGCEAREGCE(1'b0),
        .REGCEB(1'b0),
        .RSTRAMARSTRAM(\SAFETY_CKT_GEN.POR_A_reg ),
        .RSTRAMB(ram_rstram_b),
        .RSTREGARSTREG(1'b0),
        .RSTREGB(1'b0),
        .SBITERR(\NLW_DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_SBITERR_UNCONNECTED ),
        .WEA({s_axi_wstrb,s_axi_wstrb,s_axi_wstrb,s_axi_wstrb}),
        .WEBWE({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}));
  LUT2 #(
    .INIT(4'hB)) 
    \DEVICE_7SERIES.NO_BMM_INFO.SDP.SIMPLE_PRIM36.ram_i_3 
       (.I0(\SAFETY_CKT_GEN.POR_A_reg ),
        .I1(s_aresetn),
        .O(ram_rstram_b));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_top" *) 
module rom_32KB_axi_blk_mem_gen_top
   (s_axi_rdata,
    ENA_dly_D,
    rsta_busy,
    rstb_busy,
    s_aclk,
    ENA_I,
    ADDRARDADDR,
    ADDRBWRADDR,
    s_axi_wdata,
    s_axi_wstrb,
    s_aresetn,
    E);
  output [63:0]s_axi_rdata;
  output ENA_dly_D;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input ENA_I;
  input [11:0]ADDRARDADDR;
  input [11:0]ADDRBWRADDR;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_aresetn;
  input [0:0]E;

  wire [11:0]ADDRARDADDR;
  wire [11:0]ADDRBWRADDR;
  wire [0:0]E;
  wire ENA_I;
  wire ENA_dly_D;
  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire [63:0]s_axi_rdata;
  wire [63:0]s_axi_wdata;
  wire [7:0]s_axi_wstrb;

  rom_32KB_axi_blk_mem_gen_generic_cstr \valid.cstr 
       (.ADDRARDADDR(ADDRARDADDR),
        .ADDRBWRADDR(ADDRBWRADDR),
        .E(E),
        .ENA_I(ENA_I),
        .ENA_dly_D(ENA_dly_D),
        .rsta_busy(rsta_busy),
        .rstb_busy(rstb_busy),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
endmodule

(* C_ADDRA_WIDTH = "12" *) (* C_ADDRB_WIDTH = "12" *) (* C_ALGORITHM = "0" *) 
(* C_AXI_ID_WIDTH = "12" *) (* C_AXI_SLAVE_TYPE = "0" *) (* C_AXI_TYPE = "1" *) 
(* C_BYTE_SIZE = "8" *) (* C_COMMON_CLK = "1" *) (* C_COUNT_18K_BRAM = "0" *) 
(* C_COUNT_36K_BRAM = "8" *) (* C_CTRL_ECC_ALGO = "NONE" *) (* C_DEFAULT_DATA = "0" *) 
(* C_DISABLE_WARN_BHV_COLL = "0" *) (* C_DISABLE_WARN_BHV_RANGE = "0" *) (* C_ELABORATION_DIR = "./" *) 
(* C_ENABLE_32BIT_ADDRESS = "0" *) (* C_EN_DEEPSLEEP_PIN = "0" *) (* C_EN_ECC_PIPE = "0" *) 
(* C_EN_RDADDRA_CHG = "0" *) (* C_EN_RDADDRB_CHG = "0" *) (* C_EN_SAFETY_CKT = "1" *) 
(* C_EN_SHUTDOWN_PIN = "0" *) (* C_EN_SLEEP_PIN = "0" *) (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     42.0362 mW" *) 
(* C_FAMILY = "kintex7" *) (* C_HAS_AXI_ID = "1" *) (* C_HAS_ENA = "1" *) 
(* C_HAS_ENB = "1" *) (* C_HAS_INJECTERR = "0" *) (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
(* C_HAS_MEM_OUTPUT_REGS_B = "0" *) (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
(* C_HAS_REGCEA = "0" *) (* C_HAS_REGCEB = "0" *) (* C_HAS_RSTA = "0" *) 
(* C_HAS_RSTB = "1" *) (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
(* C_INITA_VAL = "0" *) (* C_INITB_VAL = "0" *) (* C_INIT_FILE = "rom_32KB_axi.mem" *) 
(* C_INIT_FILE_NAME = "rom_32KB_axi.mif" *) (* C_INTERFACE_TYPE = "1" *) (* C_LOAD_INIT_FILE = "1" *) 
(* C_MEM_TYPE = "1" *) (* C_MUX_PIPELINE_STAGES = "0" *) (* C_PRIM_TYPE = "3" *) 
(* C_READ_DEPTH_A = "4096" *) (* C_READ_DEPTH_B = "4096" *) (* C_READ_WIDTH_A = "64" *) 
(* C_READ_WIDTH_B = "64" *) (* C_RSTRAM_A = "0" *) (* C_RSTRAM_B = "0" *) 
(* C_RST_PRIORITY_A = "CE" *) (* C_RST_PRIORITY_B = "CE" *) (* C_SIM_COLLISION_CHECK = "ALL" *) 
(* C_USE_BRAM_BLOCK = "0" *) (* C_USE_BYTE_WEA = "1" *) (* C_USE_BYTE_WEB = "1" *) 
(* C_USE_DEFAULT_DATA = "1" *) (* C_USE_ECC = "0" *) (* C_USE_SOFTECC = "0" *) 
(* C_USE_URAM = "0" *) (* C_WEA_WIDTH = "8" *) (* C_WEB_WIDTH = "8" *) 
(* C_WRITE_DEPTH_A = "4096" *) (* C_WRITE_DEPTH_B = "4096" *) (* C_WRITE_MODE_A = "READ_FIRST" *) 
(* C_WRITE_MODE_B = "READ_FIRST" *) (* C_WRITE_WIDTH_A = "64" *) (* C_WRITE_WIDTH_B = "64" *) 
(* C_XDEVICEFAMILY = "kintex7" *) (* ORIG_REF_NAME = "blk_mem_gen_v8_4_1" *) (* downgradeipidentifiedwarnings = "yes" *) 
module rom_32KB_axi_blk_mem_gen_v8_4_1
   (clka,
    rsta,
    ena,
    regcea,
    wea,
    addra,
    dina,
    douta,
    clkb,
    rstb,
    enb,
    regceb,
    web,
    addrb,
    dinb,
    doutb,
    injectsbiterr,
    injectdbiterr,
    eccpipece,
    sbiterr,
    dbiterr,
    rdaddrecc,
    sleep,
    deepsleep,
    shutdown,
    rsta_busy,
    rstb_busy,
    s_aclk,
    s_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_injectsbiterr,
    s_axi_injectdbiterr,
    s_axi_sbiterr,
    s_axi_dbiterr,
    s_axi_rdaddrecc);
  input clka;
  input rsta;
  input ena;
  input regcea;
  input [7:0]wea;
  input [11:0]addra;
  input [63:0]dina;
  output [63:0]douta;
  input clkb;
  input rstb;
  input enb;
  input regceb;
  input [7:0]web;
  input [11:0]addrb;
  input [63:0]dinb;
  output [63:0]doutb;
  input injectsbiterr;
  input injectdbiterr;
  input eccpipece;
  output sbiterr;
  output dbiterr;
  output [11:0]rdaddrecc;
  input sleep;
  input deepsleep;
  input shutdown;
  output rsta_busy;
  output rstb_busy;
  input s_aclk;
  input s_aresetn;
  input [11:0]s_axi_awid;
  input [31:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  output s_axi_awready;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [11:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [11:0]s_axi_arid;
  input [31:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arvalid;
  output s_axi_arready;
  output [11:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_injectsbiterr;
  input s_axi_injectdbiterr;
  output s_axi_sbiterr;
  output s_axi_dbiterr;
  output [11:0]s_axi_rdaddrecc;

  wire \<const0> ;
  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire [31:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [11:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [31:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [11:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [11:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [63:0]s_axi_rdata;
  wire [11:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [63:0]s_axi_wdata;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;

  assign dbiterr = \<const0> ;
  assign douta[63] = \<const0> ;
  assign douta[62] = \<const0> ;
  assign douta[61] = \<const0> ;
  assign douta[60] = \<const0> ;
  assign douta[59] = \<const0> ;
  assign douta[58] = \<const0> ;
  assign douta[57] = \<const0> ;
  assign douta[56] = \<const0> ;
  assign douta[55] = \<const0> ;
  assign douta[54] = \<const0> ;
  assign douta[53] = \<const0> ;
  assign douta[52] = \<const0> ;
  assign douta[51] = \<const0> ;
  assign douta[50] = \<const0> ;
  assign douta[49] = \<const0> ;
  assign douta[48] = \<const0> ;
  assign douta[47] = \<const0> ;
  assign douta[46] = \<const0> ;
  assign douta[45] = \<const0> ;
  assign douta[44] = \<const0> ;
  assign douta[43] = \<const0> ;
  assign douta[42] = \<const0> ;
  assign douta[41] = \<const0> ;
  assign douta[40] = \<const0> ;
  assign douta[39] = \<const0> ;
  assign douta[38] = \<const0> ;
  assign douta[37] = \<const0> ;
  assign douta[36] = \<const0> ;
  assign douta[35] = \<const0> ;
  assign douta[34] = \<const0> ;
  assign douta[33] = \<const0> ;
  assign douta[32] = \<const0> ;
  assign douta[31] = \<const0> ;
  assign douta[30] = \<const0> ;
  assign douta[29] = \<const0> ;
  assign douta[28] = \<const0> ;
  assign douta[27] = \<const0> ;
  assign douta[26] = \<const0> ;
  assign douta[25] = \<const0> ;
  assign douta[24] = \<const0> ;
  assign douta[23] = \<const0> ;
  assign douta[22] = \<const0> ;
  assign douta[21] = \<const0> ;
  assign douta[20] = \<const0> ;
  assign douta[19] = \<const0> ;
  assign douta[18] = \<const0> ;
  assign douta[17] = \<const0> ;
  assign douta[16] = \<const0> ;
  assign douta[15] = \<const0> ;
  assign douta[14] = \<const0> ;
  assign douta[13] = \<const0> ;
  assign douta[12] = \<const0> ;
  assign douta[11] = \<const0> ;
  assign douta[10] = \<const0> ;
  assign douta[9] = \<const0> ;
  assign douta[8] = \<const0> ;
  assign douta[7] = \<const0> ;
  assign douta[6] = \<const0> ;
  assign douta[5] = \<const0> ;
  assign douta[4] = \<const0> ;
  assign douta[3] = \<const0> ;
  assign douta[2] = \<const0> ;
  assign douta[1] = \<const0> ;
  assign douta[0] = \<const0> ;
  assign doutb[63] = \<const0> ;
  assign doutb[62] = \<const0> ;
  assign doutb[61] = \<const0> ;
  assign doutb[60] = \<const0> ;
  assign doutb[59] = \<const0> ;
  assign doutb[58] = \<const0> ;
  assign doutb[57] = \<const0> ;
  assign doutb[56] = \<const0> ;
  assign doutb[55] = \<const0> ;
  assign doutb[54] = \<const0> ;
  assign doutb[53] = \<const0> ;
  assign doutb[52] = \<const0> ;
  assign doutb[51] = \<const0> ;
  assign doutb[50] = \<const0> ;
  assign doutb[49] = \<const0> ;
  assign doutb[48] = \<const0> ;
  assign doutb[47] = \<const0> ;
  assign doutb[46] = \<const0> ;
  assign doutb[45] = \<const0> ;
  assign doutb[44] = \<const0> ;
  assign doutb[43] = \<const0> ;
  assign doutb[42] = \<const0> ;
  assign doutb[41] = \<const0> ;
  assign doutb[40] = \<const0> ;
  assign doutb[39] = \<const0> ;
  assign doutb[38] = \<const0> ;
  assign doutb[37] = \<const0> ;
  assign doutb[36] = \<const0> ;
  assign doutb[35] = \<const0> ;
  assign doutb[34] = \<const0> ;
  assign doutb[33] = \<const0> ;
  assign doutb[32] = \<const0> ;
  assign doutb[31] = \<const0> ;
  assign doutb[30] = \<const0> ;
  assign doutb[29] = \<const0> ;
  assign doutb[28] = \<const0> ;
  assign doutb[27] = \<const0> ;
  assign doutb[26] = \<const0> ;
  assign doutb[25] = \<const0> ;
  assign doutb[24] = \<const0> ;
  assign doutb[23] = \<const0> ;
  assign doutb[22] = \<const0> ;
  assign doutb[21] = \<const0> ;
  assign doutb[20] = \<const0> ;
  assign doutb[19] = \<const0> ;
  assign doutb[18] = \<const0> ;
  assign doutb[17] = \<const0> ;
  assign doutb[16] = \<const0> ;
  assign doutb[15] = \<const0> ;
  assign doutb[14] = \<const0> ;
  assign doutb[13] = \<const0> ;
  assign doutb[12] = \<const0> ;
  assign doutb[11] = \<const0> ;
  assign doutb[10] = \<const0> ;
  assign doutb[9] = \<const0> ;
  assign doutb[8] = \<const0> ;
  assign doutb[7] = \<const0> ;
  assign doutb[6] = \<const0> ;
  assign doutb[5] = \<const0> ;
  assign doutb[4] = \<const0> ;
  assign doutb[3] = \<const0> ;
  assign doutb[2] = \<const0> ;
  assign doutb[1] = \<const0> ;
  assign doutb[0] = \<const0> ;
  assign rdaddrecc[11] = \<const0> ;
  assign rdaddrecc[10] = \<const0> ;
  assign rdaddrecc[9] = \<const0> ;
  assign rdaddrecc[8] = \<const0> ;
  assign rdaddrecc[7] = \<const0> ;
  assign rdaddrecc[6] = \<const0> ;
  assign rdaddrecc[5] = \<const0> ;
  assign rdaddrecc[4] = \<const0> ;
  assign rdaddrecc[3] = \<const0> ;
  assign rdaddrecc[2] = \<const0> ;
  assign rdaddrecc[1] = \<const0> ;
  assign rdaddrecc[0] = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_dbiterr = \<const0> ;
  assign s_axi_rdaddrecc[11] = \<const0> ;
  assign s_axi_rdaddrecc[10] = \<const0> ;
  assign s_axi_rdaddrecc[9] = \<const0> ;
  assign s_axi_rdaddrecc[8] = \<const0> ;
  assign s_axi_rdaddrecc[7] = \<const0> ;
  assign s_axi_rdaddrecc[6] = \<const0> ;
  assign s_axi_rdaddrecc[5] = \<const0> ;
  assign s_axi_rdaddrecc[4] = \<const0> ;
  assign s_axi_rdaddrecc[3] = \<const0> ;
  assign s_axi_rdaddrecc[2] = \<const0> ;
  assign s_axi_rdaddrecc[1] = \<const0> ;
  assign s_axi_rdaddrecc[0] = \<const0> ;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  assign s_axi_sbiterr = \<const0> ;
  assign sbiterr = \<const0> ;
  GND GND
       (.G(\<const0> ));
  rom_32KB_axi_blk_mem_gen_v8_4_1_synth inst_blk_mem_gen
       (.rsta_busy(rsta_busy),
        .rstb_busy(rstb_busy),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_araddr(s_axi_araddr[14:0]),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr[14:0]),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "blk_mem_gen_v8_4_1_synth" *) 
module rom_32KB_axi_blk_mem_gen_v8_4_1_synth
   (s_axi_rvalid,
    s_axi_rdata,
    s_axi_awready,
    s_axi_wready,
    s_axi_bvalid,
    s_axi_arready,
    s_axi_rid,
    rsta_busy,
    rstb_busy,
    s_axi_bid,
    s_axi_rlast,
    s_aclk,
    s_axi_awvalid,
    s_aresetn,
    s_axi_rready,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_awsize,
    s_axi_awlen,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_bready,
    s_axi_arid,
    s_axi_awid,
    s_axi_wvalid,
    s_axi_awburst,
    s_axi_awaddr,
    s_axi_arvalid,
    s_axi_araddr,
    s_axi_arburst);
  output s_axi_rvalid;
  output [63:0]s_axi_rdata;
  output s_axi_awready;
  output s_axi_wready;
  output s_axi_bvalid;
  output s_axi_arready;
  output [11:0]s_axi_rid;
  output rsta_busy;
  output rstb_busy;
  output [11:0]s_axi_bid;
  output s_axi_rlast;
  input s_aclk;
  input s_axi_awvalid;
  input s_aresetn;
  input s_axi_rready;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [2:0]s_axi_awsize;
  input [7:0]s_axi_awlen;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_bready;
  input [11:0]s_axi_arid;
  input [11:0]s_axi_awid;
  input s_axi_wvalid;
  input [1:0]s_axi_awburst;
  input [14:0]s_axi_awaddr;
  input s_axi_arvalid;
  input [14:0]s_axi_araddr;
  input [1:0]s_axi_arburst;

  wire \gnbram.gaxibmg.axi_rd_sm_n_4 ;
  wire rsta_busy;
  wire rstb_busy;
  wire s_aclk;
  wire s_aresetn;
  wire s_aresetn_a_c;
  wire [14:0]s_axi_araddr;
  wire [11:0]s_axi_araddr_out_c;
  wire [1:0]s_axi_arburst;
  wire [11:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [14:0]s_axi_awaddr;
  wire [11:0]s_axi_awaddr_out_c;
  wire [1:0]s_axi_awburst;
  wire [11:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [11:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [63:0]s_axi_rdata;
  wire [11:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [63:0]s_axi_wdata;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire \valid.cstr/ramloop[0].ram.r/ENA_dly_D ;
  wire \valid.cstr/ramloop[7].ram.r/ENA_I ;

  rom_32KB_axi_blk_mem_gen_top \gnbram.gaxibmg.axi_blk_mem_gen 
       (.ADDRARDADDR(s_axi_awaddr_out_c),
        .ADDRBWRADDR(s_axi_araddr_out_c),
        .E(\gnbram.gaxibmg.axi_rd_sm_n_4 ),
        .ENA_I(\valid.cstr/ramloop[7].ram.r/ENA_I ),
        .ENA_dly_D(\valid.cstr/ramloop[0].ram.r/ENA_dly_D ),
        .rsta_busy(rsta_busy),
        .rstb_busy(rstb_busy),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb));
  rom_32KB_axi_blk_mem_axi_read_wrapper \gnbram.gaxibmg.axi_rd_sm 
       (.ADDRBWRADDR(s_axi_araddr_out_c),
        .E(\gnbram.gaxibmg.axi_rd_sm_n_4 ),
        .SS(s_aresetn_a_c),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rvalid(s_axi_rvalid));
  rom_32KB_axi_blk_mem_axi_write_wrapper \gnbram.gaxibmg.axi_wr_fsm 
       (.ADDRARDADDR(s_axi_awaddr_out_c),
        .ENA_I(\valid.cstr/ramloop[7].ram.r/ENA_I ),
        .ENA_dly_D(\valid.cstr/ramloop[0].ram.r/ENA_dly_D ),
        .SS(s_aresetn_a_c),
        .s_aclk(s_aclk),
        .s_aresetn(s_aresetn),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_wvalid(s_axi_wvalid));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
