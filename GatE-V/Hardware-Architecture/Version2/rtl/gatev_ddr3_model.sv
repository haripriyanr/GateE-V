// GatE-V FPGA — Behavioral DDR3 Memory Model (AXI4 Slave)
// 256 MB, 64-bit data bus. Supports INCR burst reads/writes.
// Non-synthesizable — for simulation only.

import gatev_pkg::*;

module gatev_ddr3_model #(
    parameter int MEM_WORDS = 32 * 1024 * 1024  // 256 MB / 8 bytes
) (
    input  logic        clk,
    input  logic        rst_n,

    // AXI4 Slave: Write Address
    input  logic [AXI_ID_W-1:0]  s_axi_awid,
    input  logic [AXI_ADDR_W-1:0] s_axi_awaddr,
    input  logic [7:0]           s_axi_awlen,
    input  logic [2:0]           s_axi_awsize,
    input  logic [1:0]           s_axi_awburst,
    input  logic                 s_axi_awvalid,
    output logic                 s_axi_awready,

    // AXI4 Slave: Write Data
    input  logic [63:0]          s_axi_wdata,
    input  logic [7:0]           s_axi_wstrb,
    input  logic                 s_axi_wlast,
    input  logic                 s_axi_wvalid,
    output logic                 s_axi_wready,

    // AXI4 Slave: Write Response
    output logic [AXI_ID_W-1:0]  s_axi_bid,
    output logic [1:0]           s_axi_bresp,
    output logic                 s_axi_bvalid,
    input  logic                 s_axi_bready,

    // AXI4 Slave: Read Address
    input  logic [AXI_ID_W-1:0]  s_axi_arid,
    input  logic [AXI_ADDR_W-1:0] s_axi_araddr,
    input  logic [7:0]           s_axi_arlen,
    input  logic [2:0]           s_axi_arsize,
    input  logic [1:0]           s_axi_arburst,
    input  logic                 s_axi_arvalid,
    output logic                 s_axi_arready,

    // AXI4 Slave: Read Data
    output logic [AXI_ID_W-1:0]  s_axi_rid,
    output logic [63:0]          s_axi_rdata,
    output logic [1:0]           s_axi_rresp,
    output logic                 s_axi_rlast,
    output logic                 s_axi_rvalid,
    input  logic                 s_axi_rready
);

    // ── Memory Storage ──────────────────────────────────────────────────
    logic [63:0] mem [0:MEM_WORDS-1];

    // Initialize memory to zero
    initial begin
        for (int i = 0; i < MEM_WORDS; i++) mem[i] = 64'd0;
    end

    // Word-aligned address helper
    function automatic logic [31:0] word_addr(input logic [AXI_ADDR_W-1:0] addr);
        return addr[31:3];  // 8-byte aligned -> word index (lower 32-bit addr space)
    endfunction

    // ── Write Transaction State ─────────────────────────────────────────
    typedef enum logic [1:0] { W_IDLE, W_ADDR, W_DATA, W_RESP } w_state_e;
    w_state_e w_state;
    logic [AXI_ADDR_W-1:0] w_addr_q;
    logic [7:0]  w_burst_len;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_state     <= W_IDLE;
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;
            s_axi_bid     <= {AXI_ID_W{1'b0}};
            s_axi_bresp   <= 2'b00;
            w_addr_q      <= {AXI_ADDR_W{1'b0}};
            w_burst_len   <= 8'd0;
        end else begin
            s_axi_awready <= 1'b0;
            s_axi_wready  <= 1'b0;
            s_axi_bvalid  <= 1'b0;

            case (w_state)
                W_IDLE: begin
                    if (s_axi_awvalid) begin
                        s_axi_awready <= 1'b1;
                        w_addr_q      <= s_axi_awaddr;
                        w_burst_len   <= s_axi_awlen;
                        w_state       <= W_DATA;
                    end
                end

                W_DATA: begin
                    s_axi_wready <= 1'b1;
                    if (s_axi_wvalid) begin
                        // Write with byte strobes
                        if (s_axi_wstrb[0]) mem[word_addr(w_addr_q)][7:0]   <= s_axi_wdata[7:0];
                        if (s_axi_wstrb[1]) mem[word_addr(w_addr_q)][15:8]  <= s_axi_wdata[15:8];
                        if (s_axi_wstrb[2]) mem[word_addr(w_addr_q)][23:16] <= s_axi_wdata[23:16];
                        if (s_axi_wstrb[3]) mem[word_addr(w_addr_q)][31:24] <= s_axi_wdata[31:24];
                        if (s_axi_wstrb[4]) mem[word_addr(w_addr_q)][39:32] <= s_axi_wdata[39:32];
                        if (s_axi_wstrb[5]) mem[word_addr(w_addr_q)][47:40] <= s_axi_wdata[47:40];
                        if (s_axi_wstrb[6]) mem[word_addr(w_addr_q)][55:48] <= s_axi_wdata[55:48];
                        if (s_axi_wstrb[7]) mem[word_addr(w_addr_q)][63:56] <= s_axi_wdata[63:56];
                        // Advance to next word for burst
                        w_addr_q <= w_addr_q + 8;
                        if (s_axi_wlast) begin
                            w_state <= W_RESP;
                        end
                    end
                end

                W_RESP: begin
                    s_axi_bid    <= {AXI_ID_W{1'b0}};
                    s_axi_bresp  <= 2'b00;  // OKAY
                    s_axi_bvalid <= 1'b1;
                    if (s_axi_bready)
                        w_state <= W_IDLE;
                end

                default: w_state <= W_IDLE;
            endcase
        end
    end

    // ── Read Transaction State ──────────────────────────────────────────
    typedef enum logic [1:0] { R_IDLE, R_ADDR, R_DATA } r_state_e;
    r_state_e r_state;
    logic [AXI_ADDR_W-1:0] r_addr_q;
    logic [7:0]  r_burst_len;
    logic [7:0]  r_beat_cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            r_state     <= R_IDLE;
            s_axi_arready <= 1'b0;
            s_axi_rvalid  <= 1'b0;
            s_axi_rdata   <= 64'd0;
            s_axi_rid     <= {AXI_ID_W{1'b0}};
            s_axi_rresp   <= 2'b00;
            s_axi_rlast   <= 1'b0;
            r_addr_q      <= {AXI_ADDR_W{1'b0}};
            r_burst_len   <= 8'd0;
            r_beat_cnt    <= 8'd0;
        end else begin
            s_axi_arready <= 1'b0;
            s_axi_rvalid  <= 1'b0;
            s_axi_rlast   <= 1'b0;

            case (r_state)
                R_IDLE: begin
                    if (s_axi_arvalid) begin
                        s_axi_arready <= 1'b1;
                        r_addr_q      <= s_axi_araddr;
                        r_burst_len   <= s_axi_arlen;
                        r_beat_cnt    <= 8'd0;
                        r_state       <= R_DATA;
                    end
                end

                R_DATA: begin
                    s_axi_rid   <= {AXI_ID_W{1'b0}};
                    s_axi_rdata <= mem[word_addr(r_addr_q)];
                    s_axi_rresp <= 2'b00;
                    s_axi_rlast <= (r_beat_cnt == r_burst_len);
                    s_axi_rvalid <= 1'b1;
                    if (s_axi_rready) begin
                        if (r_beat_cnt == r_burst_len) begin
                            r_state <= R_IDLE;
                        end else begin
                            r_addr_q   <= r_addr_q + 8;
                            r_beat_cnt <= r_beat_cnt + 1;
                        end
                    end
                end

                default: r_state <= R_IDLE;
            endcase
        end
    end

    // ── Public Access (for testbench pre-load, 64-bit aligned) ─────────
    function automatic void write_word(input logic [AXI_ADDR_W-1:0] addr, input logic [63:0] data);
        mem[word_addr(addr)] = data;
    endfunction

    function automatic logic [63:0] read_word(input logic [AXI_ADDR_W-1:0] addr);
        return mem[word_addr(addr)];
    endfunction

    // Convenience: write single byte
    function automatic void write_byte(input logic [AXI_ADDR_W-1:0] addr, input logic [7:0] data);
        logic [31:0] wa;
        wa = word_addr(addr);
        if (addr[2])
            mem[wa][32 + 8*addr[1:0] +: 8] = data;
        else
            mem[wa][8*addr[1:0] +: 8] = data;
    endfunction

endmodule
