// GatE-V FPGA — Accelerator_Top Wrapper for C-DAC VEGA AS1061 SoC Integration
// Name: Accelerator_Top
// Matches component declaration in Top.vhd.
// Exposes 64-bit AXI4 Full Slave (for MMIO CPU configuration) and 64-bit AXI4 Full Master (for DDR3 memory).

import gatev_pkg::*;

module Accelerator_Top (
    input  wire        s_axi_aclk,
    input  wire        s_axi_aresetn,

    // ── Master Write Address Channel ──────────────────────────────────────
    output wire        m_axi_awvalid,
    output wire [11:0] m_axi_awid,
    output wire [7:0]  m_axi_awlen,
    output wire [2:0]  m_axi_awsize,
    output wire [1:0]  m_axi_awburst,
    output wire [0:0]  m_axi_awlock,
    output wire [3:0]  m_axi_awcache,
    output wire [3:0]  m_axi_awqos,
    output wire [63:0] m_axi_awaddr,
    output wire [2:0]  m_axi_awprot,
    input  wire        m_axi_awready,

    // ── Master Write Data Channel ─────────────────────────────────────────
    output wire        m_axi_wvalid,
    output wire        m_axi_wlast,
    output wire [63:0] m_axi_wdata,
    output wire [7:0]  m_axi_wstrb,
    input  wire        m_axi_wready,

    // ── Master Write Response Channel ─────────────────────────────────────
    output wire        m_axi_bready,
    input  wire        m_axi_bvalid,
    input  wire [11:0] m_axi_bid,
    input  wire [1:0]  m_axi_bresp,

    // ── Master Read Address Channel ───────────────────────────────────────
    output wire        m_axi_arvalid,
    output wire [11:0] m_axi_arid,
    output wire [7:0]  m_axi_arlen,
    output wire [2:0]  m_axi_arsize,
    output wire [1:0]  m_axi_arburst,
    output wire [0:0]  m_axi_arlock,
    output wire [3:0]  m_axi_arcache,
    output wire [3:0]  m_axi_arqos,
    output wire [63:0] m_axi_araddr,
    output wire [2:0]  m_axi_arprot,
    input  wire        m_axi_arready,

    // ── Master Read Response Channel ──────────────────────────────────────
    output wire        m_axi_rready,
    input  wire        m_axi_rvalid,
    input  wire [11:0] m_axi_rid,
    input  wire        m_axi_rlast,
    input  wire [1:0]  m_axi_rresp,
    input  wire [63:0] m_axi_rdata,

    // ── Slave Write Address Channel ───────────────────────────────────────
    input  wire [11:0] s_axi_awid,
    input  wire [63:0] s_axi_awaddr,
    input  wire [7:0]  s_axi_awlen,
    input  wire [2:0]  s_axi_awsize,
    input  wire [1:0]  s_axi_awburst,
    input  wire        s_axi_awlock,
    input  wire [3:0]  s_axi_awcache,
    input  wire [2:0]  s_axi_awprot,
    input  wire [3:0]  s_axi_awqos,
    input  wire        s_axi_awvalid,
    output wire        s_axi_awready,

    // ── Slave Write Data Channel ──────────────────────────────────────────
    input  wire [63:0] s_axi_wdata,
    input  wire [7:0]  s_axi_wstrb,
    input  wire        s_axi_wlast,
    input  wire        s_axi_wvalid,
    output wire        s_axi_wready,

    // ── Slave Write Response Channel ──────────────────────────────────────
    input  wire        s_axi_bready,
    output wire [11:0] s_axi_bid,
    output wire [1:0]  s_axi_bresp,
    output wire        s_axi_bvalid,

    // ── Slave Read Address Channel ────────────────────────────────────────
    input  wire [11:0] s_axi_arid,
    input  wire [63:0] s_axi_araddr,
    input  wire [7:0]  s_axi_arlen,
    input  wire [2:0]  s_axi_arsize,
    input  wire [1:0]  s_axi_arburst,
    input  wire        s_axi_arlock,
    input  wire [3:0]  s_axi_arcache,
    input  wire [2:0]  s_axi_arprot,
    input  wire [3:0]  s_axi_arqos,
    input  wire        s_axi_arvalid,
    output wire        s_axi_arready,

    // ── Slave Read Data Channel ───────────────────────────────────────────
    input  wire        s_axi_rready,
    output wire [11:0] s_axi_rid,
    output wire [63:0] s_axi_rdata,
    output wire [1:0]  s_axi_rresp,
    output wire        s_axi_rlast,
    output wire        s_axi_rvalid
);

    // ── AXI4-Lite Internal Signals for gatev_top ──────────────────────────
    wire [31:0] s_axil_awaddr;
    wire        s_axil_awvalid;
    wire        s_axil_awready;
    wire [31:0] s_axil_wdata;
    wire [3:0]  s_axil_wstrb;
    wire        s_axil_wvalid;
    wire        s_axil_wready;
    wire [1:0]  s_axil_bresp;
    wire        s_axil_bvalid;
    wire        s_axil_bready;

    wire [31:0] s_axil_araddr;
    wire        s_axil_arvalid;
    wire        s_axil_arready;
    wire [31:0] s_axil_rdata;
    wire [1:0]  s_axil_rresp;
    wire        s_axil_rvalid;
    wire        s_axil_rready;

    wire        acc_done;

    // ── AXI4 Full Slave to AXI4-Lite Bridge ─────────────────────────────────
    reg [11:0] latched_awid;
    reg [11:0] latched_arid;

    always_ff @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            latched_awid <= 12'd0;
            latched_arid <= 12'd0;
        end else begin
            if (s_axi_awvalid && s_axi_awready) latched_awid <= s_axi_awid;
            if (s_axi_arvalid && s_axi_arready) latched_arid <= s_axi_arid;
        end
    end

    // Slave Write Channel Mapping
    assign s_axil_awaddr  = s_axi_awaddr[31:0];
    assign s_axil_awvalid = s_axi_awvalid;
    assign s_axi_awready  = s_axil_awready;

    assign s_axil_wdata   = s_axi_wdata[31:0];
    assign s_axil_wstrb   = s_axi_wstrb[3:0];
    assign s_axil_wvalid  = s_axi_wvalid;
    assign s_axi_wready   = s_axil_wready;

    assign s_axi_bid      = latched_awid;
    assign s_axi_bresp    = s_axil_bresp;
    assign s_axi_bvalid   = s_axil_bvalid;
    assign s_axil_bready  = s_axi_bready;

    // Slave Read Channel Mapping
    assign s_axil_araddr  = s_axi_araddr[31:0];
    assign s_axil_arvalid = s_axi_arvalid;
    assign s_axi_arready  = s_axil_arready;

    assign s_axi_rid      = latched_arid;
    assign s_axi_rdata    = {32'h0000_0000, s_axil_rdata};
    assign s_axi_rresp    = s_axil_rresp;
    assign s_axi_rlast    = 1'b1;
    assign s_axi_rvalid   = s_axil_rvalid;
    assign s_axil_rready  = s_axi_rready;

    // ── GatE-V Top Module Instantiation ────────────────────────────────────
    gatev_top u_gatev_top (
        .aclk            (s_axi_aclk),
        .areset_n        (s_axi_aresetn),

        // AXI4-Lite Slave MMIO Registers
        .s_axil_awaddr   (s_axil_awaddr),
        .s_axil_awvalid  (s_axil_awvalid),
        .s_axil_awready  (s_axil_awready),
        .s_axil_wdata    (s_axil_wdata),
        .s_axil_wstrb    (s_axil_wstrb),
        .s_axil_wvalid   (s_axil_wvalid),
        .s_axil_wready   (s_axil_wready),
        .s_axil_bresp    (s_axil_bresp),
        .s_axil_bvalid   (s_axil_bvalid),
        .s_axil_bready   (s_axil_bready),

        .s_axil_araddr   (s_axil_araddr),
        .s_axil_arvalid  (s_axil_arvalid),
        .s_axil_arready  (s_axil_arready),
        .s_axil_rdata    (s_axil_rdata),
        .s_axil_rresp    (s_axil_rresp),
        .s_axil_rvalid   (s_axil_rvalid),
        .s_axil_rready   (s_axil_rready),

        // AXI4-Full Master (DDR3 Access)
        .m_axi_awid      (m_axi_awid),
        .m_axi_awaddr    (m_axi_awaddr),
        .m_axi_awlen     (m_axi_awlen),
        .m_axi_awsize    (m_axi_awsize),
        .m_axi_awburst   (m_axi_awburst),
        .m_axi_awvalid   (m_axi_awvalid),
        .m_axi_awready   (m_axi_awready),

        .m_axi_wdata     (m_axi_wdata),
        .m_axi_wstrb     (m_axi_wstrb),
        .m_axi_wlast     (m_axi_wlast),
        .m_axi_wvalid    (m_axi_wvalid),
        .m_axi_wready    (m_axi_wready),

        .m_axi_bid       (m_axi_bid),
        .m_axi_bresp     (m_axi_bresp),
        .m_axi_bvalid    (m_axi_bvalid),
        .m_axi_bready    (m_axi_bready),

        .m_axi_arid      (m_axi_arid),
        .m_axi_araddr    (m_axi_araddr),
        .m_axi_arlen     (m_axi_arlen),
        .m_axi_arsize    (m_axi_arsize),
        .m_axi_arburst   (m_axi_arburst),
        .m_axi_arvalid   (m_axi_arvalid),
        .m_axi_arready   (m_axi_arready),

        .m_axi_rid       (m_axi_rid),
        .m_axi_rdata     (m_axi_rdata),
        .m_axi_rresp     (m_axi_rresp),
        .m_axi_rlast     (m_axi_rlast),
        .m_axi_rvalid    (m_axi_rvalid),

        .m_axi_rready    (m_axi_rready),

        .acc_done        (acc_done)
    );

    assign m_axi_awlock = 1'b0;
    assign m_axi_awcache = 4'b0011;
    assign m_axi_awqos = 4'b0000;
    assign m_axi_awprot = 3'b000;

    assign m_axi_arlock = 1'b0;
    assign m_axi_arcache = 4'b0011;
    assign m_axi_arqos = 4'b0000;
    assign m_axi_arprot = 3'b000;

endmodule
