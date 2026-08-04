// GatE-V FPGA — AXI4 Full Master (burst-capable reads/writes)
// Translates simple controller requests into AXI4 bus transactions.
// Supports multi-beat INCR bursts for efficient DDR access.
// Synthesizable.

import gatev_pkg::*;

module gatev_axi4_master (
    input  logic         clk,
    input  logic         rst_n,

    // Internal request interface (from controller)
    // Read: pulse rd_req + addr + len -> rd_valid pulses for each beat
    input  logic          rd_req,
    input  logic [63:0]   rd_addr,
    input  logic [7:0]    rd_len,       // burst length - 1
    output logic [63:0]   rd_data,
    output logic          rd_valid,

    // Write: pulse wr_req + addr + data/strb + len; then stream wr_data_valid beats -> wr_ack
    input  logic          wr_req,
    input  logic [63:0]   wr_addr,
    input  logic [7:0]    wr_strb,
    input  logic [7:0]    wr_len,       // burst length - 1
    input  logic [63:0]   wr_data_in,
    input  logic          wr_data_valid,
    output logic          wr_data_ready,
    output logic          wr_ack,

    // Burst configuration (from registers)
    input  logic [1:0]    cfg_burst_type,
    input  logic [2:0]    cfg_burst_size,

    // ── AXI4 Full Master Ports ─────────────────────────────────────────────
    output logic [AXI_ID_W-1:0]  m_axi_awid,
    output logic [AXI_ADDR_W-1:0] m_axi_awaddr,
    output logic [7:0]           m_axi_awlen,
    output logic [2:0]           m_axi_awsize,
    output logic [1:0]           m_axi_awburst,
    output logic                 m_axi_awvalid,
    input  logic                 m_axi_awready,

    output logic [63:0]          m_axi_wdata,
    output logic [7:0]           m_axi_wstrb,
    output logic                 m_axi_wlast,
    output logic                 m_axi_wvalid,
    input  logic                 m_axi_wready,

    input  logic [AXI_ID_W-1:0]  m_axi_bid,
    input  logic [1:0]           m_axi_bresp,
    input  logic                 m_axi_bvalid,
    output logic                 m_axi_bready,

    output logic [AXI_ID_W-1:0]  m_axi_arid,
    output logic [AXI_ADDR_W-1:0] m_axi_araddr,
    output logic [7:0]           m_axi_arlen,
    output logic [2:0]           m_axi_arsize,
    output logic [1:0]           m_axi_arburst,
    output logic                 m_axi_arvalid,
    input  logic                 m_axi_arready,

    input  logic [AXI_ID_W-1:0]  m_axi_rid,
    input  logic [63:0]          m_axi_rdata,
    input  logic [1:0]           m_axi_rresp,
    input  logic                 m_axi_rlast,
    input  logic                 m_axi_rvalid,
    output logic                 m_axi_rready
);

    // ── Constants ──────────────────────────────────────────────────────────
    localparam IDLE = 1'b0, BUSY = 1'b1;

    // ── Write FSM (streaming data beats) ────────────────────────────────
    logic wr_state, wr_next;
    logic [7:0]  wr_beat_cnt;   // beats remaining
    logic        wr_addr_done, wr_aw_accepted;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_state        <= IDLE;
            m_axi_awid      <= {AXI_ID_W{1'b0}};
            m_axi_awaddr    <= {AXI_ADDR_W{1'b0}};
            m_axi_awlen     <= 8'd0;
            m_axi_awsize    <= 3'd0;
            m_axi_awburst   <= 2'd0;
            m_axi_awvalid   <= 1'b0;
            m_axi_wdata     <= 64'd0;
            m_axi_wstrb     <= 8'd0;
            m_axi_wlast     <= 1'b0;
            m_axi_wvalid    <= 1'b0;
            m_axi_bready    <= 1'b0;
            wr_ack          <= 1'b0;
            wr_beat_cnt     <= 8'd0;
            wr_addr_done    <= 1'b0;
            wr_aw_accepted  <= 1'b0;
            wr_data_ready   <= 1'b0;
        end else begin
            wr_state <= wr_next;
            wr_ack   <= 1'b0;
            m_axi_bready <= 1'b0;
            wr_data_ready <= 1'b0;

            case (wr_state)
                IDLE: begin
                    wr_addr_done   <= 1'b0;
                    wr_aw_accepted <= 1'b0;
                    if (wr_req) begin
                        m_axi_awid    <= {AXI_ID_W{1'b0}};
                        m_axi_awaddr  <= wr_addr;
                        m_axi_awlen   <= wr_len;
                        m_axi_awsize  <= cfg_burst_size;
                        m_axi_awburst <= cfg_burst_type;
                        m_axi_awvalid <= 1'b1;
                        wr_beat_cnt   <= wr_len + 1;
                    end else begin
                        m_axi_awvalid <= 1'b0;
                    end
                end

                BUSY: begin
                    // Accept AW
                    if (m_axi_awvalid && m_axi_awready) begin
                        m_axi_awvalid  <= 1'b0;
                        wr_aw_accepted <= 1'b1;
                    end
                    // Stream data beats
                    if (wr_beat_cnt > 0 && wr_data_valid && !m_axi_wvalid) begin
                        m_axi_wdata  <= wr_data_in;
                        m_axi_wstrb  <= wr_strb;
                        m_axi_wlast  <= (wr_beat_cnt == 1);
                        m_axi_wvalid <= 1'b1;
                        wr_beat_cnt  <= wr_beat_cnt - 1;
                    end
                    if (m_axi_wvalid && m_axi_wready) begin
                        m_axi_wvalid <= 1'b0;
                        wr_data_ready <= 1'b1;
                    end
                    // Accept write response
                    m_axi_bready <= 1'b1;
                    if (m_axi_bvalid) wr_ack <= 1'b1;
                end
            endcase
        end
    end

    assign wr_next = (wr_state == IDLE) ? (wr_req ? BUSY : IDLE)
                   : ((m_axi_bvalid && m_axi_bready) ? IDLE : BUSY);

    // ── Read FSM ──────────────────────────────────────────────────────────
    logic rd_state, rd_next;
    logic [63:0] rd_data_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_state      <= IDLE;
            m_axi_arid    <= {AXI_ID_W{1'b0}};
            m_axi_araddr  <= {AXI_ADDR_W{1'b0}};
            m_axi_arlen   <= 8'd0;
            m_axi_arsize  <= 3'd0;
            m_axi_arburst <= 2'd0;
            m_axi_arvalid <= 1'b0;
            m_axi_rready  <= 1'b0;
            rd_data_q     <= 64'd0;
            rd_valid      <= 1'b0;
        end else begin
            rd_state <= rd_next;
            rd_valid <= 1'b0;
            case (rd_state)
                IDLE: begin
                    m_axi_arvalid <= 1'b0;
                    if (rd_req) begin
                        m_axi_arid    <= {AXI_ID_W{1'b0}};
                        m_axi_araddr  <= rd_addr;
                        m_axi_arlen   <= rd_len;
                        m_axi_arsize  <= cfg_burst_size;
                        m_axi_arburst <= cfg_burst_type;
                        m_axi_arvalid <= 1'b1;
                    end
                end
                BUSY: begin
                    if (m_axi_arvalid && m_axi_arready) m_axi_arvalid <= 1'b0;
                    m_axi_rready <= 1'b1;
                    if (m_axi_rvalid) begin
                        rd_data_q <= m_axi_rdata;
                        rd_valid  <= 1'b1;
                    end
                end
            endcase
        end
    end

    assign rd_next = (rd_state == IDLE) ? (rd_req ? BUSY : IDLE)
                   : ((m_axi_rvalid && m_axi_rready && m_axi_rlast) ? IDLE : BUSY);
    assign rd_data = rd_data_q;

endmodule
