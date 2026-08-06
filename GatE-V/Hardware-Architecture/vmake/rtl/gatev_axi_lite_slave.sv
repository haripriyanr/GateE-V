// GatE-V FPGA — AXI4-Lite Register File (Slave)
// Provides CPU-configurable control/status registers for the accelerator.
// Supports 32-bit aligned read/write with byte strobes.
// Synthesizable.

import gatev_pkg::*;

module gatev_axi_lite_slave (
    input  logic        aclk,
    input  logic        areset_n,

    // AXI4-Lite Write Address
    input  logic [31:0] awaddr,
    input  logic        awvalid,
    output logic        awready,

    // AXI4-Lite Write Data
    input  logic [31:0] wdata,
    input  logic [3:0]  wstrb,
    input  logic        wvalid,
    output logic        wready,

    // AXI4-Lite Write Response
    output logic [1:0]  bresp,
    output logic        bvalid,
    input  logic        bready,

    // AXI4-Lite Read Address
    input  logic [31:0] araddr,
    input  logic        arvalid,
    output logic        arready,

    // AXI4-Lite Read Data
    output logic [31:0] rdata,
    output logic [1:0]  rresp,
    output logic        rvalid,
    input  logic        rready,

    // Register outputs to accelerator
    output logic        start,
    output logic        done,
    output logic [3:0]  task_id,
    output logic [7:0]  mode,
    output logic [AXI_ADDR_W-1:0] img_base_addr,
    output logic [AXI_ADDR_W-1:0] wt_base_addr,
    output logic [AXI_ADDR_W-1:0] out_base_addr,

    // Tiles / DMA control
    output logic [7:0]  tiles_num,
    output logic        dma_reg_start,
    output logic        dma_reg_dir,
    output logic [AXI_ADDR_W-1:0] dma_reg_src_addr,
    output logic [AXI_ADDR_W-1:0] dma_reg_dst_addr,
    output logic [31:0] dma_reg_len,

    // DMA status
    input  logic        dma_done,
    input  logic [31:0] dma_bytes,

    // Burst control
    output logic [1:0]  burst_type,
    output logic [7:0]  burst_len,
    output logic [2:0]  burst_size,

    // Performance counters (read-only)
    input  logic [31:0] perf_cycle_low,
    input  logic [31:0] perf_cycle_high,
    input  logic [31:0] perf_read_bytes,
    input  logic [31:0] perf_write_bytes,
    input  logic [31:0] perf_mac_cycles,
    input  logic [31:0] perf_stall_cycles,

    // Interrupt
    output logic        interrupt
);

    // ── Register File ───────────────────────────────────────────────────────
    logic [31:0] ctrl_reg;
    logic [31:0] status_reg;
    logic [31:0] task_id_reg;
    logic [31:0] mode_reg;
    logic [AXI_ADDR_W-1:0] img_base_addr_reg;
    logic [AXI_ADDR_W-1:0] wt_base_addr_reg;
    logic [AXI_ADDR_W-1:0] out_base_addr_reg;
    logic [AXI_ADDR_W-1:0] dma_src_addr_reg;
    logic [AXI_ADDR_W-1:0] dma_dst_addr_reg;
    logic [31:0] dma_len_reg;
    logic [31:0] dma_ctrl_reg;
    logic [31:0] tiles_num_reg;
    logic [31:0] burst_type_reg;
    logic [31:0] burst_len_reg;

    // ── Write FSM ──────────────────────────────────────────────────────────
    typedef enum logic [1:0] { W_IDLE, W_WRITE, W_RESP } w_state_e;
    w_state_e w_state;
    logic [31:0] w_addr_latched;

    // Single-cycle pulse generators
    logic start_q;
    logic dma_start_q;

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            w_state  <= W_IDLE;
            awready  <= 1'b0;
            wready   <= 1'b0;
            bvalid   <= 1'b0;
            bresp    <= AXI_RESP_OKAY;
            w_addr_latched <= '0;
            ctrl_reg      <= '0;
            status_reg    <= '0;
            task_id_reg   <= '0;
            mode_reg      <= '0;
            img_base_addr_reg <= '0;
            wt_base_addr_reg  <= '0;
            out_base_addr_reg <= '0;
            dma_src_addr_reg  <= '0;
            dma_dst_addr_reg  <= '0;
            dma_len_reg  <= '0;
            dma_ctrl_reg <= '0;
            tiles_num_reg <= '0;
            burst_type_reg <= '0;
            burst_len_reg  <= '0;
            start_q      <= 1'b0;
            dma_start_q  <= 1'b0;
        end else begin
            start_q     <= 1'b0;
            dma_start_q <= 1'b0;
            case (w_state)
                W_IDLE: begin
                    if (awvalid) begin
                        awready <= 1'b1;
                        w_addr_latched <= awaddr;
                        w_state <= W_WRITE;
                    end
                end
                W_WRITE: begin
                    awready <= 1'b0;
                    if (wvalid) begin
                        wready <= 1'b1;
                        bresp  <= AXI_RESP_OKAY;
                        bvalid <= 1'b1;
                        _write_register(w_addr_latched, wdata, wstrb);
                        w_state <= W_RESP;
                    end
                end
                W_RESP: begin
                    awready <= 1'b0;
                    wready  <= 1'b0;
                    if (bready && bvalid) begin
                        bvalid  <= 1'b0;
                        w_state <= W_IDLE;
                    end
                end
                default: w_state <= W_IDLE;
            endcase

            // Auto-clear ctrl_reg start bit (generate 1-cycle pulse)
            if (ctrl_reg[CTRL_START_BIT]) begin
                start_q <= 1'b1;
                ctrl_reg[CTRL_START_BIT] <= 1'b0;
                status_reg[STATUS_DONE_BIT] <= 1'b0;
            end
            // Auto-clear dma start bit
            if (dma_ctrl_reg[DMA_CTRL_START_BIT]) begin
                dma_start_q <= 1'b1;
                dma_ctrl_reg[DMA_CTRL_START_BIT] <= 1'b0;
            end
            // Update status register from DMA
            if (dma_done) status_reg[STATUS_DONE_BIT] <= 1'b1;
            status_reg[31:8] <= dma_bytes[23:0];
        end
    end

    // ── Read FSM ───────────────────────────────────────────────────────────
    typedef enum logic [1:0] { R_IDLE, R_READ, R_RESP } r_state_e;
    r_state_e r_state;
    logic [31:0] r_addr_latched;

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            r_state <= R_IDLE;
            arready <= 1'b0;
            rvalid  <= 1'b0;
            rdata   <= '0;
            rresp   <= AXI_RESP_OKAY;
            r_addr_latched <= '0;
        end else begin
            case (r_state)
                R_IDLE: begin
                    if (arvalid) begin
                        arready <= 1'b1;
                        r_addr_latched <= araddr;
                        r_state <= R_READ;
                    end
                end
                R_READ: begin
                    arready <= 1'b0;
                    rresp   <= AXI_RESP_OKAY;
                    rdata   <= _read_register(r_addr_latched);
                    rvalid  <= 1'b1;
                    r_state <= R_RESP;
                end
                R_RESP: begin
                    if (rready && rvalid) begin
                        rvalid  <= 1'b0;
                        r_state <= R_IDLE;
                    end
                end
                default: r_state <= R_IDLE;
            endcase
        end
    end

    // ── Register Write Decode ─────────────────────────────────────────────
    function automatic void _write_register(
        input logic [31:0] addr,
        input logic [31:0] data,
        input logic [3:0]  strb
    );
        case (addr)
            CTRL_REG_ADDR: begin
                if (strb[0]) ctrl_reg[7:0]   <= data[7:0];
                if (strb[1]) ctrl_reg[15:8]  <= data[15:8];
                if (strb[2]) ctrl_reg[23:16] <= data[23:16];
                if (strb[3]) ctrl_reg[31:24] <= data[31:24];
            end
            TASK_ID_REG_ADDR: begin
                if (strb[0]) task_id_reg[7:0] <= data[7:0];
            end
            MODE_REG_ADDR: begin
                if (strb[0]) mode_reg[7:0] <= data[7:0];
            end
            IMG_BASE_ADDR_REG: begin
                if (strb[0]) img_base_addr_reg[7:0]   <= data[7:0];
                if (strb[1]) img_base_addr_reg[15:8]  <= data[15:8];
                if (strb[2]) img_base_addr_reg[23:16] <= data[23:16];
                if (strb[3]) img_base_addr_reg[31:24] <= data[31:24];
            end
            WT_BASE_ADDR_REG: begin
                if (strb[0]) wt_base_addr_reg[7:0]   <= data[7:0];
                if (strb[1]) wt_base_addr_reg[15:8]  <= data[15:8];
                if (strb[2]) wt_base_addr_reg[23:16] <= data[23:16];
                if (strb[3]) wt_base_addr_reg[31:24] <= data[31:24];
            end
            OUT_BASE_ADDR_REG: begin
                if (strb[0]) out_base_addr_reg[7:0]   <= data[7:0];
                if (strb[1]) out_base_addr_reg[15:8]  <= data[15:8];
                if (strb[2]) out_base_addr_reg[23:16] <= data[23:16];
                if (strb[3]) out_base_addr_reg[31:24] <= data[31:24];
            end
            DMA_SRC_ADDR_REG: dma_src_addr_reg <= data;
            DMA_DST_ADDR_REG: dma_dst_addr_reg <= data;
            DMA_LEN_REG:      dma_len_reg      <= data;
            DMA_CTRL_REG:     dma_ctrl_reg     <= data;
            TILES_NUM_REG_ADDR: begin
                if (strb[0]) tiles_num_reg[7:0] <= data[7:0];
            end
            BURST_TYPE_REG: begin
                if (strb[0]) burst_type_reg[1:0] <= data[1:0];
            end
            BURST_LEN_REG: begin
                if (strb[0]) burst_len_reg[7:0] <= data[7:0];
            end
            default: bresp <= AXI_RESP_SLVERR;
        endcase
    endfunction

    // ── Register Read Decode ───────────────────────────────────────────────
    function automatic logic [31:0] _read_register(input logic [31:0] addr);
        case (addr)
            CTRL_REG_ADDR:     return ctrl_reg;
            STATUS_REG_ADDR:   return status_reg;
            TASK_ID_REG_ADDR:  return task_id_reg;
            MODE_REG_ADDR:     return mode_reg;
            IMG_BASE_ADDR_REG: return img_base_addr_reg;
            WT_BASE_ADDR_REG:  return wt_base_addr_reg;
            OUT_BASE_ADDR_REG: return out_base_addr_reg;
            DMA_SRC_ADDR_REG:  return dma_src_addr_reg;
            DMA_DST_ADDR_REG:  return dma_dst_addr_reg;
            DMA_LEN_REG:       return dma_len_reg;
            DMA_CTRL_REG:      return dma_ctrl_reg;
            TILES_NUM_REG_ADDR: return tiles_num_reg;
            BURST_TYPE_REG:     return burst_type_reg;
            BURST_LEN_REG:      return burst_len_reg;
            PERF_CYCLE_LOW:     return perf_cycle_low;
            PERF_CYCLE_HIGH:    return perf_cycle_high;
            PERF_READ_BYTES:    return perf_read_bytes;
            PERF_WRITE_BYTES:   return perf_write_bytes;
            PERF_MAC_CYCLES:    return perf_mac_cycles;
            PERF_STALL_CYCLES:  return perf_stall_cycles;
            default: begin
                rresp <= AXI_RESP_SLVERR;
                return '0;
            end
        endcase
    endfunction

    // ── Output Assignments ─────────────────────────────────────────────────
    assign start         = start_q;
    assign done          = status_reg[STATUS_DONE_BIT];
    assign task_id       = task_id_reg[3:0];
    assign mode          = mode_reg[7:0];
    assign img_base_addr = img_base_addr_reg;
    assign wt_base_addr  = wt_base_addr_reg;
    assign out_base_addr = out_base_addr_reg;

    assign dma_reg_start    = dma_start_q;
    assign dma_reg_dir      = dma_ctrl_reg[DMA_CTRL_DIR_BIT];
    assign dma_reg_src_addr = dma_src_addr_reg;
    assign dma_reg_dst_addr = dma_dst_addr_reg;
    assign dma_reg_len      = dma_len_reg;
    assign tiles_num        = tiles_num_reg[7:0];
    assign burst_type       = burst_type_reg[1:0];
    assign burst_len        = burst_len_reg[7:0];
    assign burst_size       = 3'd3;           // hardcoded to 8 bytes for now

    assign interrupt = dma_done;

endmodule
