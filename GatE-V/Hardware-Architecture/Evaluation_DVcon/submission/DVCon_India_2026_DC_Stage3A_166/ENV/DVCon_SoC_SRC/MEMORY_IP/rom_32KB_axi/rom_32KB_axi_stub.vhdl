-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2026.1 (lin64) Build 6511674 Tue Jun 16 11:01:26 MDT 2026
-- Date        : Wed Aug  5 00:34:09 2026
-- Host        : AETHER running 64-bit CachyOS
-- Command     : write_vhdl -force -mode synth_stub
--               /run/media/user/DATA/DVcon/GatE-V/Hardware-Architecture/Evaluation_DVcon/submission/DVCon_2026/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi_stub.vhdl
-- Design      : rom_32KB_axi
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom_32KB_axi is
  Port ( 
    rsta_busy : out STD_LOGIC;
    rstb_busy : out STD_LOGIC;
    s_aclk : in STD_LOGIC;
    s_aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC
  );

  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of rom_32KB_axi : entity is "rom_32KB_axi,blk_mem_gen_v8_4_13,{}";
  attribute core_generation_info : string;
  attribute core_generation_info of rom_32KB_axi : entity is "rom_32KB_axi,blk_mem_gen_v8_4_13,{x_ipProduct=Vivado 2026.1,x_ipVendor=xilinx.com,x_ipLibrary=ip,x_ipName=blk_mem_gen,x_ipVersion=8.4,x_ipCoreRevision=13,x_ipLanguage=VHDL,x_ipSimLanguage=MIXED,C_FAMILY=kintex7,C_XDEVICEFAMILY=kintex7,C_ELABORATION_DIR=./,C_INTERFACE_TYPE=1,C_AXI_TYPE=1,C_AXI_SLAVE_TYPE=0,C_USE_BRAM_BLOCK=0,C_ENABLE_32BIT_ADDRESS=0,C_CTRL_ECC_ALGO=NONE,C_HAS_AXI_ID=1,C_AXI_ID_WIDTH=12,C_MEM_TYPE=1,C_BYTE_SIZE=8,C_ALGORITHM=0,C_PRIM_TYPE=3,C_LOAD_INIT_FILE=1,C_INIT_FILE_NAME=rom_32KB_axi.mif,C_INIT_FILE=rom_32KB_axi.mem,C_USE_DEFAULT_DATA=1,C_DEFAULT_DATA=0,C_HAS_RSTA=0,C_RST_PRIORITY_A=CE,C_RSTRAM_A=0,C_INITA_VAL=0,C_HAS_ENA=1,C_HAS_REGCEA=0,C_USE_BYTE_WEA=1,C_WEA_WIDTH=8,C_WRITE_MODE_A=READ_FIRST,C_WRITE_WIDTH_A=64,C_READ_WIDTH_A=64,C_WRITE_DEPTH_A=4096,C_READ_DEPTH_A=4096,C_ADDRA_WIDTH=12,C_HAS_RSTB=1,C_RST_PRIORITY_B=CE,C_RSTRAM_B=0,C_INITB_VAL=0,C_HAS_ENB=1,C_HAS_REGCEB=0,C_USE_BYTE_WEB=1,C_WEB_WIDTH=8,C_WRITE_MODE_B=READ_FIRST,C_WRITE_WIDTH_B=64,C_READ_WIDTH_B=64,C_WRITE_DEPTH_B=4096,C_READ_DEPTH_B=4096,C_ADDRB_WIDTH=12,C_HAS_MEM_OUTPUT_REGS_A=0,C_HAS_MEM_OUTPUT_REGS_B=0,C_HAS_MUX_OUTPUT_REGS_A=0,C_HAS_MUX_OUTPUT_REGS_B=0,C_MUX_PIPELINE_STAGES=0,C_HAS_SOFTECC_INPUT_REGS_A=0,C_HAS_SOFTECC_OUTPUT_REGS_B=0,C_USE_SOFTECC=0,C_USE_ECC=0,C_EN_ECC_PIPE=0,C_READ_LATENCY_A=1,C_READ_LATENCY_B=1,C_HAS_INJECTERR=0,C_SIM_COLLISION_CHECK=ALL,C_COMMON_CLK=1,C_DISABLE_WARN_BHV_COLL=0,C_EN_SLEEP_PIN=0,C_USE_URAM=0,C_EN_RDADDRA_CHG=0,C_EN_RDADDRB_CHG=0,C_EN_DEEPSLEEP_PIN=0,C_EN_SHUTDOWN_PIN=0,C_EN_SAFETY_CKT=1,C_DISABLE_WARN_BHV_RANGE=0,C_COUNT_36K_BRAM=8,C_COUNT_18K_BRAM=0,C_MEMORY_OPTIMIZATION=1,C_EST_POWER_SUMMARY=Estimated Power for IP     _     42.0362 mW}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of rom_32KB_axi : entity is "yes";
end rom_32KB_axi;

architecture stub of rom_32KB_axi is
  attribute syn_black_box : boolean;
  attribute black_box_pad_pin : string;
  attribute syn_black_box of stub : architecture is true;
  attribute black_box_pad_pin of stub : architecture is "rsta_busy,rstb_busy,s_aclk,s_aresetn,s_axi_awid[11:0],s_axi_awaddr[31:0],s_axi_awlen[7:0],s_axi_awsize[2:0],s_axi_awburst[1:0],s_axi_awvalid,s_axi_awready,s_axi_wdata[63:0],s_axi_wstrb[7:0],s_axi_wlast,s_axi_wvalid,s_axi_wready,s_axi_bid[11:0],s_axi_bresp[1:0],s_axi_bvalid,s_axi_bready,s_axi_arid[11:0],s_axi_araddr[31:0],s_axi_arlen[7:0],s_axi_arsize[2:0],s_axi_arburst[1:0],s_axi_arvalid,s_axi_arready,s_axi_rid[11:0],s_axi_rdata[63:0],s_axi_rresp[1:0],s_axi_rlast,s_axi_rvalid,s_axi_rready";
  attribute x_interface_info : string;
  attribute x_interface_info of s_aclk : signal is "xilinx.com:signal:clock:1.0 CLK.ACLK CLK";
  attribute x_interface_mode : string;
  attribute x_interface_mode of s_aclk : signal is "slave CLK.ACLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of s_aclk : signal is "XIL_INTERFACENAME CLK.ACLK, ASSOCIATED_BUSIF AXI_SLAVE_S_AXI:AXILite_SLAVE_S_AXI, ASSOCIATED_RESET s_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.0, INSERT_VIP 0";
  attribute x_interface_info of s_aresetn : signal is "xilinx.com:signal:reset:1.0 RST.ARESETN RST";
  attribute x_interface_mode of s_aresetn : signal is "slave RST.ARESETN";
  attribute x_interface_parameter of s_aresetn : signal is "XIL_INTERFACENAME RST.ARESETN, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axi_awid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWID";
  attribute x_interface_mode of s_axi_awid : signal is "slave AXI_SLAVE_S_AXI";
  attribute x_interface_parameter of s_axi_awid : signal is "XIL_INTERFACENAME AXI_SLAVE_S_AXI, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 12, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWADDR";
  attribute x_interface_info of s_axi_awlen : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWLEN";
  attribute x_interface_info of s_axi_awsize : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWSIZE";
  attribute x_interface_info of s_axi_awburst : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWBURST";
  attribute x_interface_info of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWVALID";
  attribute x_interface_info of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI AWREADY";
  attribute x_interface_info of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WDATA";
  attribute x_interface_info of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WSTRB";
  attribute x_interface_info of s_axi_wlast : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WLAST";
  attribute x_interface_info of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WVALID";
  attribute x_interface_info of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI WREADY";
  attribute x_interface_info of s_axi_bid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BID";
  attribute x_interface_info of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BRESP";
  attribute x_interface_info of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BVALID";
  attribute x_interface_info of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI BREADY";
  attribute x_interface_info of s_axi_arid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARID";
  attribute x_interface_info of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARADDR";
  attribute x_interface_info of s_axi_arlen : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARLEN";
  attribute x_interface_info of s_axi_arsize : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARSIZE";
  attribute x_interface_info of s_axi_arburst : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARBURST";
  attribute x_interface_info of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARVALID";
  attribute x_interface_info of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI ARREADY";
  attribute x_interface_info of s_axi_rid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RID";
  attribute x_interface_info of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RDATA";
  attribute x_interface_info of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RRESP";
  attribute x_interface_info of s_axi_rlast : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RLAST";
  attribute x_interface_info of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RVALID";
  attribute x_interface_info of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI RREADY";
  attribute x_core_info : string;
  attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_13,Vivado 2026.1";
begin
end;
