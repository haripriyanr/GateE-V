// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2026 Advanced Micro Devices, Inc. All Rights Reserved.
// -------------------------------------------------------------------------------
// This file contains confidential and proprietary information
// of AMD and is protected under U.S. and international copyright
// and other intellectual property laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// AMD, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND AMD HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) AMD shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or AMD had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// AMD products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of AMD products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
// DO NOT MODIFY THIS FILE.

// MODULE VLNV: xilinx.com:ip:blk_mem_gen:8.4

`timescale 1ps / 1ps

`include "vivado_interfaces.svh"

module rom_32KB_axi_sv (
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 AXI_SLAVE_S_AXI" *)
  (* X_INTERFACE_MODE = "slave AXI_SLAVE_S_AXI" *)
  (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME AXI_SLAVE_S_AXI, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 12, ADDR_WIDTH 32, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 0, HAS_PROT 0, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *)
  vivado_aximm_v1_0.slave AXI_SLAVE_S_AXI,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire rsta_busy,
  (* X_INTERFACE_IGNORE = "true" *)
  output wire rstb_busy,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire s_aclk,
  (* X_INTERFACE_IGNORE = "true" *)
  input wire s_aresetn
);

  // interface wire assignments
  assign AXI_SLAVE_S_AXI.BUSER = 0;
  assign AXI_SLAVE_S_AXI.RUSER = 0;

  rom_32KB_axi inst (
    .rsta_busy(rsta_busy),
    .rstb_busy(rstb_busy),
    .s_aclk(s_aclk),
    .s_aresetn(s_aresetn),
    .s_axi_awid(AXI_SLAVE_S_AXI.AWID),
    .s_axi_awaddr(AXI_SLAVE_S_AXI.AWADDR),
    .s_axi_awlen(AXI_SLAVE_S_AXI.AWLEN),
    .s_axi_awsize(AXI_SLAVE_S_AXI.AWSIZE),
    .s_axi_awburst(AXI_SLAVE_S_AXI.AWBURST),
    .s_axi_awvalid(AXI_SLAVE_S_AXI.AWVALID),
    .s_axi_awready(AXI_SLAVE_S_AXI.AWREADY),
    .s_axi_wdata(AXI_SLAVE_S_AXI.WDATA),
    .s_axi_wstrb(AXI_SLAVE_S_AXI.WSTRB),
    .s_axi_wlast(AXI_SLAVE_S_AXI.WLAST),
    .s_axi_wvalid(AXI_SLAVE_S_AXI.WVALID),
    .s_axi_wready(AXI_SLAVE_S_AXI.WREADY),
    .s_axi_bid(AXI_SLAVE_S_AXI.BID),
    .s_axi_bresp(AXI_SLAVE_S_AXI.BRESP),
    .s_axi_bvalid(AXI_SLAVE_S_AXI.BVALID),
    .s_axi_bready(AXI_SLAVE_S_AXI.BREADY),
    .s_axi_arid(AXI_SLAVE_S_AXI.ARID),
    .s_axi_araddr(AXI_SLAVE_S_AXI.ARADDR),
    .s_axi_arlen(AXI_SLAVE_S_AXI.ARLEN),
    .s_axi_arsize(AXI_SLAVE_S_AXI.ARSIZE),
    .s_axi_arburst(AXI_SLAVE_S_AXI.ARBURST),
    .s_axi_arvalid(AXI_SLAVE_S_AXI.ARVALID),
    .s_axi_arready(AXI_SLAVE_S_AXI.ARREADY),
    .s_axi_rid(AXI_SLAVE_S_AXI.RID),
    .s_axi_rdata(AXI_SLAVE_S_AXI.RDATA),
    .s_axi_rresp(AXI_SLAVE_S_AXI.RRESP),
    .s_axi_rlast(AXI_SLAVE_S_AXI.RLAST),
    .s_axi_rvalid(AXI_SLAVE_S_AXI.RVALID),
    .s_axi_rready(AXI_SLAVE_S_AXI.RREADY)
  );

endmodule
