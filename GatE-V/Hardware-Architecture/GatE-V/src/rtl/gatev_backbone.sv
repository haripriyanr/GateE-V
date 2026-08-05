// GatE-V FPGA — Backbone Modules (merged)
// Contains: gatev_line_buffer_3x3, gatev_maxpool_3x3, gatev_backbone_controller,
//           gatev_conv2d_tile_scheduler, gatev_backbone_top_wrapper
// Provides convolution tile scheduling and PResNet-50vd sequencing.

import gatev_pkg::*;

// ═════════════════════════════════════════════════════════════════════════════
// gatev_line_buffer_3x3 — 3×3 Sliding-Window Line Buffer
// Stores 3 rows in BRAM, outputs a 3×3 window per pixel.
// No padding — caller must feed padded image (H+2 × W+2) if needed.
// ═════════════════════════════════════════════════════════════════════════════
module gatev_line_buffer_3x3 (
    input  logic        clk,
    input  logic        rst_n,

    input  logic [7:0]  pixel_in,
    input  logic        pixel_valid,
    output logic        pixel_ready,

    output logic [7:0]  window [0:8],
    output logic        window_valid,
    input  logic        window_ready,

    input  logic [15:0] cfg_img_width,
    input  logic [15:0] cfg_img_height
);

    // Row buffers (3 rows × max width)
    logic [7:0] row_buf [0:2][0:MAX_IMG_WIDTH-1];

    // Write pointer management
    logic [15:0] col_cnt;
    logic [1:0]  wr_row;       // which row being written (0,1,2)
    logic [15:0] row_cnt;      // rows fully written
    logic [31:0] pxl_cnt;      // total pixels written
    logic        window_en;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col_cnt <= 16'd0;
            wr_row  <= 2'd0;
            row_cnt <= 16'd0;
            pxl_cnt <= 32'd0;
        end else if (pixel_valid) begin
            row_buf[wr_row][col_cnt] <= pixel_in;
            if (col_cnt == cfg_img_width - 1) begin
                col_cnt <= 16'd0;
                wr_row  <= (wr_row == 2) ? 2'd0 : wr_row + 1;
                row_cnt <= row_cnt + 1;
            end else begin
                col_cnt <= col_cnt + 1;
            end
            pxl_cnt <= pxl_cnt + 1;
        end
    end

    // Window enable after pipeline is filled (2 rows + 2 pixels)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            window_en <= 1'b0;
        else if (pxl_cnt >= (cfg_img_width * 2 + 2) && pixel_valid)
            window_en <= 1'b1;
        else if (row_cnt >= cfg_img_height)
            window_en <= 1'b0;
    end

    // Window shift registers
    logic [7:0] sr [0:2][0:2];  // [row][col]
    logic [1:0] rd_row [0:2];

    always_comb begin
        case (wr_row)
            2'd0: begin rd_row[0] = 2'd1; rd_row[1] = 2'd2; end
            2'd1: begin rd_row[0] = 2'd2; rd_row[1] = 2'd0; end
            default: begin rd_row[0] = 2'd0; rd_row[1] = 2'd1; end
        endcase
        rd_row[2] = wr_row;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int r = 0; r < 3; r++)
                for (int c = 0; c < 3; c++)
                    sr[r][c] <= 8'd0;
        end else if (pixel_valid) begin
            for (int r = 0; r < 3; r++) begin
                sr[r][0] <= sr[r][1];
                sr[r][1] <= sr[r][2];
                // Newest pixel goes to row 2; older rows read from buffer
                sr[r][2] <= (r == 2) ? pixel_in : row_buf[rd_row[r]][col_cnt];
            end
        end
    end

    // Output
    assign pixel_ready = 1'b1;
    assign window[0] = sr[0][0]; assign window[1] = sr[0][1]; assign window[2] = sr[0][2];
    assign window[3] = sr[1][0]; assign window[4] = sr[1][1]; assign window[5] = sr[1][2];
    assign window[6] = sr[2][0]; assign window[7] = sr[2][1]; assign window[8] = sr[2][2];
    assign window_valid = window_en;

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// maxpool_3x3 — 3×3 MaxPool with Stride-2
// Combinational binary tree comparator with registered output.
// ═════════════════════════════════════════════════════════════════════════════
module gatev_maxpool_3x3 (
    input  logic        clk,
    input  logic        rst_n,

    input  logic [7:0]  window [0:8],
    input  logic        window_valid,
    output logic        window_ready,

    output logic [7:0]  max_val,
    output logic        max_valid,
    input  logic        max_ready
);

    // Combinational max tree
    logic [7:0] m1_0, m1_1, m1_2, m1_3, m1_4;
    assign m1_0 = (window[0] > window[1]) ? window[0] : window[1];
    assign m1_1 = (window[2] > window[3]) ? window[2] : window[3];
    assign m1_2 = (window[4] > window[5]) ? window[4] : window[5];
    assign m1_3 = (window[6] > window[7]) ? window[6] : window[7];
    assign m1_4 = window[8];

    logic [7:0] m2_0, m2_1, m2_2;
    assign m2_0 = (m1_0 > m1_1) ? m1_0 : m1_1;
    assign m2_1 = (m1_2 > m1_3) ? m1_2 : m1_3;
    assign m2_2 = m1_4;

    logic [7:0] m3_0;
    assign m3_0 = (m2_0 > m2_1) ? m2_0 : m2_1;

    logic [7:0] max_val_comb;
    assign max_val_comb = (m3_0 > m2_2) ? m3_0 : m2_2;

    // Registered output
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            max_val   <= 8'd0;
            max_valid <= 1'b0;
        end else if (window_valid) begin
            max_val   <= max_val_comb;
            max_valid <= 1'b1;
        end else begin
            max_valid <= 1'b0;
        end
    end

    assign window_ready = 1'b1;

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// backbone_controller — PResNet-50vd Layer Sequencer
// Sequences backbone layers via a ROM descriptor table.
// Feeds layer config to conv2d_tile_scheduler and manages start/done handoff.
// NOTE: Currently unused in gatev_top (powered by direct FSM).
// ═════════════════════════════════════════════════════════════════════════════
module gatev_backbone_controller (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        start,
    output logic        busy,
    output logic        done,

    output logic [15:0] cfg_in_ch,
    output logic [15:0] cfg_out_ch,
    output logic [7:0]  cfg_kernel_size,
    output logic [7:0]  cfg_stride,
    output logic [15:0] cfg_in_w,
    output logic [15:0] cfg_out_h,
    output logic [15:0] cfg_out_w,
    output logic [15:0] cfg_scale_m,
    output logic [4:0]  cfg_shift_r,
    output logic        cfg_with_act,
    output logic [15:0] cfg_num_in_grps,

    output logic        sched_start,
    input  logic        sched_busy,
    input  logic        sched_done
);

    // ── Layer ROM (Stem + Stage 1 blocks, 64×64 test input) ───────────────
    localparam int NUM_LAYERS = 6;
    layer_desc_t rom [0:NUM_LAYERS-1];

    always_comb begin
        rom[0] = '{with_act: 1'b1, kernel: 3'd2, in_ch: 16'd3,  out_ch: 16'd32, in_w: 16'd64, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
        rom[1] = '{with_act: 1'b1, kernel: 3'd2, in_ch: 16'd32, out_ch: 16'd32, in_w: 16'd32, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
        rom[2] = '{with_act: 1'b1, kernel: 3'd2, in_ch: 16'd32, out_ch: 16'd64, in_w: 16'd32, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
        rom[3] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd64,  out_ch: 16'd64,  in_w: 16'd32, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
        rom[4] = '{with_act: 1'b1, kernel: 3'd2, in_ch: 16'd64,  out_ch: 16'd64,  in_w: 16'd32, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
        rom[5] = '{with_act: 1'b0, kernel: 3'd0, in_ch: 16'd64,  out_ch: 16'd256, in_w: 16'd32, out_h: 16'd32, out_w: 16'd32, scale_m: 16'd32768, shift_r: 5'd8};
    end

    // ── State Machine ────────────────────────────────────────────────────
    typedef enum logic [1:0] { ST_IDLE, ST_ACTIVE, ST_DONE } state_e;
    state_e state, next;
    logic [7:0] layer_idx;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= ST_IDLE;
        else        state <= next;
    end

    always_comb begin
        next = state;
        case (state)
            ST_IDLE:   if (start)                    next = ST_ACTIVE;
            ST_ACTIVE: if (sched_done && layer_idx >= NUM_LAYERS - 1) next = ST_DONE;
                       else if (sched_done)          next = ST_ACTIVE;
            ST_DONE:   if (!start)                   next = ST_IDLE;
            default:   next = ST_IDLE;
        endcase
    end

    // Layer index counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            layer_idx <= 8'd0;
        else case (state)
            ST_IDLE:   layer_idx <= 8'd0;
            ST_ACTIVE: if (sched_done && layer_idx < NUM_LAYERS - 1)
                           layer_idx <= layer_idx + 1;
        endcase
    end

    // Config output mux from ROM
    always_comb begin
        cfg_in_ch       = rom[layer_idx].in_ch;
        cfg_out_ch      = rom[layer_idx].out_ch;
        cfg_kernel_size = rom[layer_idx].kernel + 1;
        cfg_stride      = (rom[layer_idx].kernel == 3'd2) ? 8'd2 : 8'd1;
        cfg_in_w        = rom[layer_idx].in_w;
        cfg_out_h       = rom[layer_idx].out_h;
        cfg_out_w       = rom[layer_idx].out_w;
        cfg_scale_m     = rom[layer_idx].scale_m;
        cfg_shift_r     = rom[layer_idx].shift_r;
        cfg_with_act    = rom[layer_idx].with_act;
        cfg_num_in_grps = (rom[layer_idx].in_ch + 7) / 8;
    end

    // Scheduler start pulse
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) sched_start <= 1'b0;
        else sched_start <= (state == ST_ACTIVE && next == ST_ACTIVE && !sched_busy);
    end

    assign busy = (state == ST_ACTIVE);
    assign done = (state == ST_DONE);

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// conv2d_tile_scheduler — Conv2D Tile Scheduler
// Streams weight tiles and activation pixels through the shared MAC engine.
// Iterates over input channel groups, kernel positions, and output tiles.
// Each round: load 8 weight columns → feed 9 activations → collect output.
// ═════════════════════════════════════════════════════════════════════════════
module gatev_conv2d_tile_scheduler (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start,
    output logic        busy,
    output logic        done,

    // Weight stream: 64-bit packed word per column, 8 columns per round
    input  logic [63:0] weight_data,
    input  logic        weight_valid,
    output logic        weight_ready,

    // Activation stream: INT8 pixel per input channel
    input  logic [7:0]  act_data,
    input  logic        act_valid,
    output logic        act_ready,

    // Output stream: 64-bit packed word (8 × INT8, all columns in parallel)
    output logic [63:0] out_data,
    output logic        out_valid,
    input  logic        out_ready,

    // Layer config
    input  logic [15:0] cfg_num_in_grps,
    input  logic [7:0]  cfg_kernel_size,
    input  logic [15:0] cfg_scale_m,
    input  logic [4:0]  cfg_shift_r,
    input  logic        cfg_with_act,
    input  logic [7:0]  cfg_num_tiles,

    // Debug
    output logic [3:0]  dbg_state,
    output logic [3:0]  dbg_next,
    output logic [15:0] dbg_round_cnt,
    output logic [3:0]  dbg_w_col_cnt,
    output logic        dbg_mac_start,
    output logic        dbg_mac_done,
    output logic        dbg_mac_weight_ready,
    output logic [3:0]  dbg_mac_state
);

    // ── Internal MAC Engine ──────────────────────────────────────────────
    logic        mac_start;
    logic        mac_busy;
    logic        mac_done;
    logic [63:0] mac_weight_data;
    logic        mac_weight_valid;
    logic        mac_weight_ready;
    logic [7:0]  mac_act_data;
    logic        mac_act_valid;
    logic        mac_act_ready;
    logic [63:0] mac_out_data;
    logic        mac_out_valid;
    logic        mac_out_ready;

    gatev_shared_mac_engine u_mac (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (mac_start),
        .busy          (mac_busy),
        .done          (mac_done),
        .weight_data   (mac_weight_data),
        .weight_valid  (mac_weight_valid),
        .weight_ready  (mac_weight_ready),
        .act_data      (mac_act_data),
        .act_valid     (mac_act_valid),
        .act_ready     (mac_act_ready),
        .out_data      (mac_out_data),
        .out_valid     (mac_out_valid),
        .out_ready     (mac_out_ready),
        .cfg_scale_m   (cfg_scale_m),
        .cfg_shift_r   (cfg_shift_r),
        .cfg_with_act  (cfg_with_act),
        .cfg_num_tiles (cfg_num_tiles),
        .dbg_state     (dbg_mac_state)
    );

    // ── Scheduler FSM ────────────────────────────────────────────────────
    typedef enum logic [3:0] {
        ST_IDLE,
        ST_WEIGHT_LOAD,
        ST_FEED_ACT,
        ST_WAIT_MAC,
        ST_OUTPUT_LO,       // output columns 0-7
        ST_WAIT_MAC_HI,     // wait for columns 8-15
        ST_OUTPUT_HI,       // output columns 8-15
        ST_WAIT_MAC_DONE,
        ST_NEXT_ROUND,
        ST_DONE
    } state_e;

    state_e state, next;

    logic [15:0] round_cnt;
    logic [15:0] total_rounds;
    localparam int WORDS_PER_COL = (MAC_ROWS + 7) / 8;
    localparam int WT_PHASES     = MAC_COLS * WORDS_PER_COL;

    logic [6:0]  w_col_cnt;
    logic        act_done;
    logic [5:0]  act_cnt;

    assign total_rounds = cfg_num_in_grps * cfg_kernel_size * cfg_kernel_size;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= ST_IDLE;
        else        state <= next;
    end

    always_comb begin
        next = state;
        case (state)
            ST_IDLE:          if (start)               next = ST_WEIGHT_LOAD;
            ST_WEIGHT_LOAD:   if (w_col_cnt == WT_PHASES) next = ST_FEED_ACT;
            ST_FEED_ACT:      if (act_done)            next = ST_WAIT_MAC;
            ST_WAIT_MAC:      if (mac_out_valid)       next = ST_OUTPUT_LO;
            ST_OUTPUT_LO:     if (out_ready)           next = ST_WAIT_MAC_HI;
            ST_WAIT_MAC_HI:   if (mac_out_valid)       next = ST_OUTPUT_HI;
            ST_OUTPUT_HI:     if (out_ready)           next = ST_WAIT_MAC_DONE;
            ST_WAIT_MAC_DONE: begin
                              if (mac_act_ready)       next = ST_FEED_ACT;
                              else                     next = ST_NEXT_ROUND;
            end
            ST_NEXT_ROUND:    if (round_cnt >= total_rounds - 1) next = ST_DONE;
                              else                     next = ST_WEIGHT_LOAD;
            ST_DONE:          if (!start)              next = ST_IDLE;
            default:                                    next = ST_IDLE;
        endcase
    end

    // ── Counters ─────────────────────────────────────────────────────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_col_cnt   <= 7'd0;
            act_cnt     <= 6'd0;
            round_cnt   <= 16'd0;
        end else begin
            case (state)
                ST_IDLE: begin
                    w_col_cnt   <= 7'd0;
                    act_cnt     <= 6'd0;
                    round_cnt   <= 16'd0;
                end
                ST_WEIGHT_LOAD: begin
                    if (weight_valid && w_col_cnt < WT_PHASES) w_col_cnt <= w_col_cnt + 1;
                end
                ST_FEED_ACT: begin
                    if (act_valid && act_cnt < MAC_ROWS) act_cnt <= act_cnt + 1;
                end
                ST_NEXT_ROUND: begin
                    w_col_cnt   <= 7'd0;
                    act_cnt     <= 6'd0;
                    round_cnt   <= round_cnt + 1;
                end
                default: begin
                    w_col_cnt   <= w_col_cnt;
                    act_cnt     <= (next == ST_FEED_ACT) ? 6'd0 : act_cnt;
                    round_cnt   <= round_cnt;
                end
            endcase
        end
    end

    // ── Handshake Signals ────────────────────────────────────────────────
    assign weight_ready = (state == ST_WEIGHT_LOAD) && mac_weight_ready;
    assign act_ready    = (state == ST_FEED_ACT) && mac_act_ready;
    assign act_done     = (act_cnt == MAC_ROWS);

    // Forward data to MAC
    assign mac_weight_data  = weight_data;
    assign mac_weight_valid = (state == ST_WEIGHT_LOAD) ? weight_valid : 1'b0;
    assign mac_act_data     = act_data;
    assign mac_act_valid    = (state == ST_FEED_ACT) ? act_valid : 1'b0;
    assign mac_start        = start || (next == ST_WEIGHT_LOAD);
    assign mac_out_ready    = (state == ST_WAIT_MAC || state == ST_WAIT_MAC_HI);

    // ── Output (2-cycle) ────────────────────────────────────────────────
    assign out_data  = mac_out_data;
    assign out_valid = (state == ST_OUTPUT_LO || state == ST_OUTPUT_HI);

    // ── Status ──────────────────────────────────────────────────────────
    assign busy = (state != ST_IDLE && state != ST_DONE);
    assign done = (state == ST_DONE);

    // Debug assignments
    assign dbg_state    = state;
    assign dbg_next     = next;
    assign dbg_round_cnt = round_cnt;
    assign dbg_w_col_cnt = w_col_cnt;
    assign dbg_mac_start = mac_start;
    assign dbg_mac_done  = mac_done;
    assign dbg_mac_weight_ready = mac_weight_ready;

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// backbone_top_wrapper — Backbone Integration Wrapper
// Connects line_buffer, maxpool, MAC engine, and tile scheduler.
// Exposes all ports flat for standalone testbench access.
// ═════════════════════════════════════════════════════════════════════════════
module gatev_backbone_top_wrapper (
    input  logic        clk,
    input  logic        rst_n,

    // Control
    input  logic        start,
    output logic        busy,
    output logic        done,

    // Line buffer test ports
    input  logic [7:0]  lb_pixel_in,
    input  logic        lb_pixel_valid,
    output logic        lb_pixel_ready,
    output logic [7:0]  lb_window [0:8],
    output logic        lb_window_valid,
    input  logic        lb_window_ready,

    // MAC engine test ports
    input  logic        mac_start,
    input  logic [63:0] mac_weight_data,
    input  logic        mac_weight_valid,
    output logic        mac_weight_ready,
    input  logic [7:0]  mac_act_data,
    input  logic        mac_act_valid,
    output logic        mac_act_ready,
    output logic [63:0] mac_out_data,
    output logic        mac_out_valid,
    input  logic        mac_out_ready,

    // MaxPool test ports
    input  logic [7:0]  mp_window [0:8],
    input  logic        mp_window_valid,
    output logic        mp_window_ready,
    output logic [7:0]  mp_max_val,
    output logic        mp_max_valid,
    input  logic        mp_max_ready,

    // Tile scheduler ports
    input  logic        sched_start,
    output logic        sched_busy,
    output logic        sched_done,
    input  logic [63:0] sched_weight_data,
    input  logic        sched_weight_valid,
    output logic        sched_weight_ready,
    input  logic [7:0]  sched_act_data,
    input  logic        sched_act_valid,
    output logic        sched_act_ready,
    output logic [63:0] sched_out_data,
    output logic        sched_out_valid,
    input  logic        sched_out_ready,
    input  logic [15:0] sched_cfg_num_in_grps,
    input  logic [7:0]  sched_cfg_kernel_size,
    input  logic [15:0] sched_cfg_scale_m,
    input  logic [4:0]  sched_cfg_shift_r,
    input  logic        sched_cfg_with_act,
    input  logic [7:0]  sched_cfg_num_tiles,

    // Line buffer config
    input  logic [15:0] cfg_img_width,
    input  logic [15:0] cfg_img_height,

    // Debug
    output logic [3:0]  dbg_sched_state,
    output logic [3:0]  dbg_sched_next,
    output logic [15:0] dbg_sched_round_cnt,
    output logic [3:0]  dbg_sched_w_col_cnt,
    output logic        dbg_sched_mac_start,
    output logic        dbg_sched_mac_done,
    output logic        dbg_sched_mw_ready,
    output logic [3:0]  dbg_sched_mac_state
);

    gatev_line_buffer_3x3 u_linebuf (
        .clk           (clk),
        .rst_n         (rst_n),
        .pixel_in      (lb_pixel_in),
        .pixel_valid   (lb_pixel_valid),
        .pixel_ready   (lb_pixel_ready),
        .window        (lb_window),
        .window_valid  (lb_window_valid),
        .window_ready  (lb_window_ready),
        .cfg_img_width (cfg_img_width),
        .cfg_img_height(cfg_img_height)
    );

    gatev_maxpool_3x3 u_maxpool (
        .clk           (clk),
        .rst_n         (rst_n),
        .window        (mp_window),
        .window_valid  (mp_window_valid),
        .window_ready  (mp_window_ready),
        .max_val       (mp_max_val),
        .max_valid     (mp_max_valid),
        .max_ready     (mp_max_ready)
    );

    gatev_shared_mac_engine u_mac (
        .clk           (clk),
        .rst_n         (rst_n),
        .start         (mac_start),
        .busy          (),
        .done          (),
        .weight_data   (mac_weight_data),
        .weight_valid  (mac_weight_valid),
        .weight_ready  (mac_weight_ready),
        .act_data      (mac_act_data),
        .act_valid     (mac_act_valid),
        .act_ready     (mac_act_ready),
        .out_data      (mac_out_data),
        .out_valid     (mac_out_valid),
        .out_ready     (mac_out_ready),
        .cfg_scale_m   (16'd32768),
        .cfg_shift_r   (5'd8),
        .cfg_with_act  (1'b1),
        .cfg_num_tiles (8'd1),
        .dbg_state     ()
    );

    gatev_conv2d_tile_scheduler u_scheduler (
        .clk               (clk),
        .rst_n             (rst_n),
        .start             (sched_start),
        .busy              (sched_busy),
        .done              (sched_done),
        .weight_data       (sched_weight_data),
        .weight_valid      (sched_weight_valid),
        .weight_ready      (sched_weight_ready),
        .act_data          (sched_act_data),
        .act_valid         (sched_act_valid),
        .act_ready         (sched_act_ready),
        .out_data          (sched_out_data),
        .out_valid         (sched_out_valid),
        .out_ready         (sched_out_ready),
        .cfg_num_in_grps   (sched_cfg_num_in_grps),
        .cfg_kernel_size   (sched_cfg_kernel_size),
        .cfg_scale_m       (sched_cfg_scale_m),
        .cfg_shift_r       (sched_cfg_shift_r),
        .cfg_with_act      (sched_cfg_with_act),
        .cfg_num_tiles     (sched_cfg_num_tiles),
        .dbg_state         (dbg_sched_state),
        .dbg_next          (dbg_sched_next),
        .dbg_round_cnt     (dbg_sched_round_cnt),
        .dbg_w_col_cnt     (dbg_sched_w_col_cnt),
        .dbg_mac_start     (dbg_sched_mac_start),
        .dbg_mac_done      (dbg_sched_mac_done),
        .dbg_mac_weight_ready (dbg_sched_mw_ready),
        .dbg_mac_state     (dbg_sched_mac_state)
    );

    assign done = 1'b0;
    assign busy = u_mac.busy;

endmodule
