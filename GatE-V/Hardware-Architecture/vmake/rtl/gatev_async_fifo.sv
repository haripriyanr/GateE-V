// GatE-V FPGA — Simple Dual-Clock Async FIFO (parameterizable width & depth)
// Gray-code pointer crossing for safe CDC. Width must be ≤ 256.
// Depth must be a power of 2.

module gatev_async_fifo #(
    parameter int DATA_WIDTH = 64,
    parameter int DEPTH      = 8
) (
    input  logic                  wr_clk,
    input  logic                  wr_rst_n,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] din,
    output logic                  full,

    input  logic                  rd_clk,
    input  logic                  rd_rst_n,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] dout,
    output logic                  empty
);

    localparam int PTR_W = $clog2(DEPTH);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [PTR_W:0] wr_ptr, rd_ptr;
    logic [PTR_W:0] wr_ptr_gray, rd_ptr_gray;
    logic [PTR_W:0] wr_ptr_gray_sync1, wr_ptr_gray_sync2;
    logic [PTR_W:0] rd_ptr_gray_sync1, rd_ptr_gray_sync2;
    logic [PTR_W:0] wr_ptr_bin, rd_ptr_bin;

    // ── Write Domain ─────────────────────────────────────────────────
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            wr_ptr <= 0;
        end else if (wr_en && !full) begin
            mem[wr_ptr[PTR_W-1:0]] <= din;
            wr_ptr <= wr_ptr + 1;
        end
    end

    always_comb begin
        wr_ptr_gray = wr_ptr ^ (wr_ptr >> 1);
    end

    // Cross read pointer to write domain
    always_ff @(posedge wr_clk or negedge wr_rst_n) begin
        if (!wr_rst_n) begin
            rd_ptr_gray_sync1 <= 0;
            rd_ptr_gray_sync2 <= 0;
        end else begin
            rd_ptr_gray_sync1 <= rd_ptr_gray;
            rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
        end
    end

    // Gray → binary for full detection
    always_comb begin
        rd_ptr_bin = rd_ptr_gray_sync2;
        for (int i = PTR_W-1; i >= 0; i--) begin
            rd_ptr_bin[i] = rd_ptr_bin[i+1] ^ rd_ptr_bin[i];
        end
    end

    assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[PTR_W:PTR_W-1], rd_ptr_gray_sync2[PTR_W-2:0]});

    // ── Read Domain ──────────────────────────────────────────────────
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            rd_ptr <= 0;
            dout   <= {DATA_WIDTH{1'b0}};
        end else if (rd_en && !empty) begin
            dout   <= mem[rd_ptr[PTR_W-1:0]];
            rd_ptr <= rd_ptr + 1;
        end
    end

    always_comb begin
        rd_ptr_gray = rd_ptr ^ (rd_ptr >> 1);
    end

    // Cross write pointer to read domain
    always_ff @(posedge rd_clk or negedge rd_rst_n) begin
        if (!rd_rst_n) begin
            wr_ptr_gray_sync1 <= 0;
            wr_ptr_gray_sync2 <= 0;
        end else begin
            wr_ptr_gray_sync1 <= wr_ptr_gray;
            wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
        end
    end

    assign empty = (wr_ptr_gray_sync2 == rd_ptr_gray);

endmodule
