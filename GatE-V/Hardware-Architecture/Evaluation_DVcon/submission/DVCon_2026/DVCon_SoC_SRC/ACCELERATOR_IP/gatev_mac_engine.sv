// GatE-V FPGA — Compute Engine (merged, 16-wide systolic array)
// Contains: gatev_mac_cell, gatev_systolic_8x16, gatev_requantize, gatev_activation_lut, gatev_shared_mac_engine
// 16 output columns × 8 input rows = 128 MAC cells.
// 2-cycle output: lower 8 channels then upper 8 channels (64-bit AXI compatible).

import gatev_pkg::*;

// ═════════════════════════════════════════════════════════════════════════════
// gatev_mac_cell — Single INT8 Multiply-Accumulate Cell
// p_sum_out = registered(p_sum_in + a_in * weight)
// Uses DSP48E1 via ( * use_dsp = "yes" * ) + clean signed arithmetic.
// ═════════════════════════════════════════════════════════════════════════════
module gatev_mac_cell (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        load,       // Assert to load weight
    input  logic        clear,      // Assert to clear accumulator
    input  logic [7:0]  w_load,     // Weight value
    input  logic [7:0]  a_in,       // Activation from left
    input  logic [31:0] p_sum_in,   // Partial sum from above
    output logic [7:0]  a_out,      // Activation to right (combinational)
    output logic [31:0] p_sum_out   // Partial sum to below (DSP-inferred registered)
);

    logic signed [7:0] weight_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)    weight_q <= 8'sd0;
        else if (load) weight_q <= signed'(w_load);
    end

    (* use_dsp = "yes" *)
    logic [31:0] mac_p;

    always_ff @(posedge clk) begin
        if (!rst_n || clear)  mac_p <= 32'd0;
        else                  mac_p <= signed'(p_sum_in) + signed'(a_in) * weight_q;
    end

    assign p_sum_out = mac_p;
    assign a_out = a_in;

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// gatev_systolic — Parameterized systolic array: ROWS × COLS MAC cells
// ═════════════════════════════════════════════════════════════════════════════
module gatev_systolic #(
    parameter int ROWS = 8,
    parameter int COLS = 16
) (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        load_weights,
    input  logic        compute,
    input  logic        clear_psum,

    input  logic [7:0]  w_load [0:ROWS-1],
    input  logic [$clog2(COLS)-1:0] w_load_col,

    input  logic [7:0]  act [0:ROWS-1],

    input  logic [31:0] p_sum_in [0:COLS-1],

    output logic [31:0] p_sum_out [0:COLS-1],
    output logic        psum_valid
);

    logic [7:0]  a_int [0:ROWS-1][0:COLS];
    logic [31:0] p_int [0:ROWS][0:COLS-1];

    logic [COLS-1:0] col_load_en;
    always_comb begin
        col_load_en = {COLS{1'b0}};
        if (load_weights) col_load_en[w_load_col] = 1'b1;
    end

    genvar r, c;
    for (r = 0; r < ROWS; r++) begin : gen_row_in
        assign a_int[r][0] = act[r];
    end
    for (c = 0; c < COLS; c++) begin : gen_col_in
        assign p_int[0][c] = p_sum_in[c];
    end

    for (r = 0; r < ROWS; r++) begin : gen_row
        for (c = 0; c < COLS; c++) begin : gen_col
            gatev_mac_cell u_cell (
                .clk      (clk),
                .rst_n    (rst_n),
                .load     (col_load_en[c]),
                .clear    (clear_psum),
                .w_load   (w_load[r]),
                .a_in     (a_int[r][c]),
                .p_sum_in (p_int[r][c]),
                .a_out    (a_int[r][c+1]),
                .p_sum_out(p_int[r+1][c])
            );
        end
    end

    for (c = 0; c < COLS; c++) begin : gen_psum_out
        assign p_sum_out[c] = p_int[ROWS][c];
    end

    logic [ROWS+COLS-1:0] valid_shift;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)          valid_shift <= {(ROWS+COLS){1'b0}};
        else if (load_weights || clear_psum) valid_shift <= {(ROWS+COLS){1'b0}};
        else if (compute)    valid_shift <= {valid_shift[ROWS+COLS-2:0], 1'b1};
    end
    assign psum_valid = valid_shift[ROWS+COLS-1];

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// gatev_requantize — same as before
// ═════════════════════════════════════════════════════════════════════════════
module gatev_requantize (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] acc_in,
    input  logic [15:0] scale_m,
    input  logic [4:0]  shift_r,
    input  logic        valid_in,
    output logic [7:0]  dout,
    output logic        valid_out
);

    logic [47:0] mul_result;
    logic [31:0] scaled;
    logic [7:0]  result;
    logic [1:0]  valid_pipe;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_result  <= 48'd0;
            valid_pipe[0] <= 1'b0;
        end else begin
            mul_result    <= $signed(acc_in) * $signed(scale_m);
            valid_pipe[0] <= valid_in;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scaled      <= 32'd0;
            valid_pipe[1] <= 1'b0;
        end else begin
            scaled        <= $signed(mul_result[31:0]) >>> shift_r;
            valid_pipe[1] <= valid_pipe[0];
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result    <= 8'd0;
            valid_out <= 1'b0;
        end else begin
            valid_out <= valid_pipe[1];
            if ($signed(scaled) > 32'sd127)
                result <= 8'sd127;
            else if ($signed(scaled) < -32'sd128)
                result <= 8'sd128;
            else
                result <= scaled[7:0];
        end
    end

    assign dout = result;

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// gatev_activation_lut — same as before
// ═════════════════════════════════════════════════════════════════════════════
module gatev_activation_lut (
    input  logic        clk,
    input  logic [7:0]  addr,
    output logic [7:0]  dout
);

    logic [7:0] lut [0:255];

    initial begin
        lut[8'd0]   = -8'sd34; lut[8'd1]   = -8'sd34; lut[8'd2]   = -8'sd34; lut[8'd3]   = -8'sd34;
        lut[8'd4]   = -8'sd34; lut[8'd5]   = -8'sd34; lut[8'd6]   = -8'sd34; lut[8'd7]   = -8'sd34;
        lut[8'd8]   = -8'sd34; lut[8'd9]   = -8'sd34; lut[8'd10]  = -8'sd34; lut[8'd11]  = -8'sd33;
        lut[8'd12]  = -8'sd33; lut[8'd13]  = -8'sd33; lut[8'd14]  = -8'sd33; lut[8'd15]  = -8'sd33;
        lut[8'd16]  = -8'sd33; lut[8'd17]  = -8'sd33; lut[8'd18]  = -8'sd33; lut[8'd19]  = -8'sd33;
        lut[8'd20]  = -8'sd32; lut[8'd21]  = -8'sd32; lut[8'd22]  = -8'sd32; lut[8'd23]  = -8'sd32;
        lut[8'd24]  = -8'sd32; lut[8'd25]  = -8'sd32; lut[8'd26]  = -8'sd32; lut[8'd27]  = -8'sd32;
        lut[8'd28]  = -8'sd31; lut[8'd29]  = -8'sd31; lut[8'd30]  = -8'sd31; lut[8'd31]  = -8'sd31;
        lut[8'd32]  = -8'sd31; lut[8'd33]  = -8'sd31; lut[8'd34]  = -8'sd30; lut[8'd35]  = -8'sd30;
        lut[8'd36]  = -8'sd30; lut[8'd37]  = -8'sd30; lut[8'd38]  = -8'sd30; lut[8'd39]  = -8'sd30;
        lut[8'd40]  = -8'sd29; lut[8'd41]  = -8'sd29; lut[8'd42]  = -8'sd29; lut[8'd43]  = -8'sd29;
        lut[8'd44]  = -8'sd29; lut[8'd45]  = -8'sd28; lut[8'd46]  = -8'sd28; lut[8'd47]  = -8'sd28;
        lut[8'd48]  = -8'sd28; lut[8'd49]  = -8'sd28; lut[8'd50]  = -8'sd27; lut[8'd51]  = -8'sd27;
        lut[8'd52]  = -8'sd27; lut[8'd53]  = -8'sd27; lut[8'd54]  = -8'sd27; lut[8'd55]  = -8'sd26;
        lut[8'd56]  = -8'sd26; lut[8'd57]  = -8'sd26; lut[8'd58]  = -8'sd26; lut[8'd59]  = -8'sd25;
        lut[8'd60]  = -8'sd25; lut[8'd61]  = -8'sd25; lut[8'd62]  = -8'sd25; lut[8'd63]  = -8'sd24;
        lut[8'd64]  = -8'sd24; lut[8'd65]  = -8'sd24; lut[8'd66]  = -8'sd24; lut[8'd67]  = -8'sd23;
        lut[8'd68]  = -8'sd23; lut[8'd69]  = -8'sd23; lut[8'd70]  = -8'sd23; lut[8'd71]  = -8'sd22;
        lut[8'd72]  = -8'sd22; lut[8'd73]  = -8'sd22; lut[8'd74]  = -8'sd21; lut[8'd75]  = -8'sd21;
        lut[8'd76]  = -8'sd21; lut[8'd77]  = -8'sd20; lut[8'd78]  = -8'sd20; lut[8'd79]  = -8'sd20;
        lut[8'd80]  = -8'sd20; lut[8'd81]  = -8'sd19; lut[8'd82]  = -8'sd19; lut[8'd83]  = -8'sd19;
        lut[8'd84]  = -8'sd18; lut[8'd85]  = -8'sd18; lut[8'd86]  = -8'sd18; lut[8'd87]  = -8'sd17;
        lut[8'd88]  = -8'sd17; lut[8'd89]  = -8'sd17; lut[8'd90]  = -8'sd16; lut[8'd91]  = -8'sd16;
        lut[8'd92]  = -8'sd15; lut[8'd93]  = -8'sd15; lut[8'd94]  = -8'sd15; lut[8'd95]  = -8'sd14;
        lut[8'd96]  = -8'sd14; lut[8'd97]  = -8'sd14; lut[8'd98]  = -8'sd13; lut[8'd99]  = -8'sd13;
        lut[8'd100] = -8'sd12; lut[8'd101] = -8'sd12; lut[8'd102] = -8'sd12; lut[8'd103] = -8'sd11;
        lut[8'd104] = -8'sd11; lut[8'd105] = -8'sd10; lut[8'd106] = -8'sd10; lut[8'd107] = -8'sd10;
        lut[8'd108] = -8'sd9;  lut[8'd109] = -8'sd9;  lut[8'd110] = -8'sd8;  lut[8'd111] = -8'sd8;
        lut[8'd112] = -8'sd8;  lut[8'd113] = -8'sd7;  lut[8'd114] = -8'sd7;  lut[8'd115] = -8'sd6;
        lut[8'd116] = -8'sd6;  lut[8'd117] = -8'sd5;  lut[8'd118] = -8'sd5;  lut[8'd119] = -8'sd4;
        lut[8'd120] = -8'sd4;  lut[8'd121] = -8'sd3;  lut[8'd122] = -8'sd3;  lut[8'd123] = -8'sd2;
        lut[8'd124] = -8'sd2;  lut[8'd125] = -8'sd1;  lut[8'd126] = -8'sd1;  lut[8'd127] = 8'sd0;
        lut[8'd128] = 8'sd0;   lut[8'd129] = 8'sd1;   lut[8'd130] = 8'sd1;   lut[8'd131] = 8'sd2;
        lut[8'd132] = 8'sd2;   lut[8'd133] = 8'sd3;   lut[8'd134] = 8'sd3;   lut[8'd135] = 8'sd4;
        lut[8'd136] = 8'sd4;   lut[8'd137] = 8'sd5;   lut[8'd138] = 8'sd5;   lut[8'd139] = 8'sd6;
        lut[8'd140] = 8'sd6;   lut[8'd141] = 8'sd7;   lut[8'd142] = 8'sd7;   lut[8'd143] = 8'sd8;
        lut[8'd144] = 8'sd8;   lut[8'd145] = 8'sd9;   lut[8'd146] = 8'sd10;  lut[8'd147] = 8'sd10;
        lut[8'd148] = 8'sd11;  lut[8'd149] = 8'sd11;  lut[8'd150] = 8'sd12;  lut[8'd151] = 8'sd13;
        lut[8'd152] = 8'sd13;  lut[8'd153] = 8'sd14;  lut[8'd154] = 8'sd14;  lut[8'd155] = 8'sd15;
        lut[8'd156] = 8'sd16;  lut[8'd157] = 8'sd16;  lut[8'd158] = 8'sd17;  lut[8'd159] = 8'sd17;
        lut[8'd160] = 8'sd18;  lut[8'd161] = 8'sd19;  lut[8'd162] = 8'sd19;  lut[8'd163] = 8'sd20;
        lut[8'd164] = 8'sd21;  lut[8'd165] = 8'sd21;  lut[8'd166] = 8'sd22;  lut[8'd167] = 8'sd22;
        lut[8'd168] = 8'sd23;  lut[8'd169] = 8'sd24;  lut[8'd170] = 8'sd24;  lut[8'd171] = 8'sd25;
        lut[8'd172] = 8'sd26;  lut[8'd173] = 8'sd26;  lut[8'd174] = 8'sd27;  lut[8'd175] = 8'sd28;
        lut[8'd176] = 8'sd28;  lut[8'd177] = 8'sd29;  lut[8'd178] = 8'sd30;  lut[8'd179] = 8'sd31;
        lut[8'd180] = 8'sd31;  lut[8'd181] = 8'sd32;  lut[8'd182] = 8'sd33;  lut[8'd183] = 8'sd33;
        lut[8'd184] = 8'sd34;  lut[8'd185] = 8'sd35;  lut[8'd186] = 8'sd35;  lut[8'd187] = 8'sd36;
        lut[8'd188] = 8'sd37;  lut[8'd189] = 8'sd38;  lut[8'd190] = 8'sd38;  lut[8'd191] = 8'sd39;
        lut[8'd192] = 8'sd40;  lut[8'd193] = 8'sd41;  lut[8'd194] = 8'sd41;  lut[8'd195] = 8'sd42;
        lut[8'd196] = 8'sd43;  lut[8'd197] = 8'sd44;  lut[8'd198] = 8'sd44;  lut[8'd199] = 8'sd45;
        lut[8'd200] = 8'sd46;  lut[8'd201] = 8'sd47;  lut[8'd202] = 8'sd47;  lut[8'd203] = 8'sd48;
        lut[8'd204] = 8'sd49;  lut[8'd205] = 8'sd50;  lut[8'd206] = 8'sd51;  lut[8'd207] = 8'sd51;
        lut[8'd208] = 8'sd52;  lut[8'd209] = 8'sd53;  lut[8'd210] = 8'sd54;  lut[8'd211] = 8'sd55;
        lut[8'd212] = 8'sd55;  lut[8'd213] = 8'sd56;  lut[8'd214] = 8'sd57;  lut[8'd215] = 8'sd58;
        lut[8'd216] = 8'sd59;  lut[8'd217] = 8'sd59;  lut[8'd218] = 8'sd60;  lut[8'd219] = 8'sd61;
        lut[8'd220] = 8'sd62;  lut[8'd221] = 8'sd63;  lut[8'd222] = 8'sd64;  lut[8'd223] = 8'sd64;
        lut[8'd224] = 8'sd65;  lut[8'd225] = 8'sd66;  lut[8'd226] = 8'sd67;  lut[8'd227] = 8'sd68;
        lut[8'd228] = 8'sd69;  lut[8'd229] = 8'sd69;  lut[8'd230] = 8'sd70;  lut[8'd231] = 8'sd71;
        lut[8'd232] = 8'sd72;  lut[8'd233] = 8'sd73;  lut[8'd234] = 8'sd74;  lut[8'd235] = 8'sd75;
        lut[8'd236] = 8'sd76;  lut[8'd237] = 8'sd76;  lut[8'd238] = 8'sd77;  lut[8'd239] = 8'sd78;
        lut[8'd240] = 8'sd79;  lut[8'd241] = 8'sd80;  lut[8'd242] = 8'sd81;  lut[8'd243] = 8'sd82;
        lut[8'd244] = 8'sd83;  lut[8'd245] = 8'sd84;  lut[8'd246] = 8'sd84;  lut[8'd247] = 8'sd85;
        lut[8'd248] = 8'sd86;  lut[8'd249] = 8'sd87;  lut[8'd250] = 8'sd88;  lut[8'd251] = 8'sd89;
        lut[8'd252] = 8'sd90;  lut[8'd253] = 8'sd91;  lut[8'd254] = 8'sd92;  lut[8'd255] = 8'sd93;
    end

    always_ff @(posedge clk) dout <= lut[addr];

endmodule


// ═════════════════════════════════════════════════════════════════════════════
// shared_mac_engine — MAC Engine Top (16-wide)
// Handles MAC_ROWS×MAC_COLS tiles.
// 64-bit weight bus → 2 cycles per column when MAC_ROWS > 8.
// Outputs: 2 × 64-bit words (lower 8 cols, upper 8 cols when MAC_COLS=16)
// ═════════════════════════════════════════════════════════════════════════════
module gatev_shared_mac_engine (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        start,
    output logic        busy,
    output logic        done,

    // Weight loading (64-bit = 8 × INT8 per cycle)
    input  logic [63:0] weight_data,
    input  logic        weight_valid,
    output logic        weight_ready,

    // Activation input (scalar INT8)
    input  logic [7:0]  act_data,
    input  logic        act_valid,
    output logic        act_ready,

    // Output stream: 64-bit per cycle, 2 cycles (low then high column half)
    output logic [63:0] out_data,
    output logic        out_valid,
    input  logic        out_ready,

    input  logic [15:0] cfg_scale_m,
    input  logic [4:0]  cfg_shift_r,
    input  logic        cfg_with_act,
    input  logic [7:0]  cfg_num_tiles,

    output logic [3:0]  dbg_state
);

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_WEIGHT_LOAD,
        ST_ACT_LOAD,
        ST_COMPUTE,
        ST_REQUANTIZE,
        ST_ACTIVATE,
        ST_OUTPUT_LOW,       // output columns 0-7
        ST_OUTPUT_HIGH,      // output columns 8-15
        ST_DONE
    } state_e;

    state_e state, next;

    logic [7:0]  tile_count;
    logic [5:0]  w_phase;    // 0..(MAC_COLS*ceil(MAC_ROWS/8)-1): column*words_per_col
    logic [4:0]  act_phase;  // 0..(MAC_ROWS-1)
    logic        ld_done;
    logic        act_ld_done;

    localparam int WORDS_PER_COL = (MAC_ROWS + 7) / 8;  // 2 for MAC_ROWS=16
    localparam int WT_PHASES     = MAC_COLS * WORDS_PER_COL;

    // Systolic array wires
    logic        load_weights;
    logic        compute;
    logic [7:0]  w_load [0:MAC_ROWS-1];
    logic [7:0]  act [0:MAC_ROWS-1];
    logic [31:0] p_sum_in [0:MAC_COLS-1];
    logic [31:0] p_sum_out [0:MAC_COLS-1];
    logic        psum_valid;

    // Tie p_sum_in to zero
    genvar g_pi;
    generate
        for (g_pi = 0; g_pi < MAC_COLS; g_pi++) begin
            assign p_sum_in[g_pi] = 32'd0;
        end
    endgenerate

    // Requantizer wires (×16 parallel)
    logic [7:0]  req_dout [0:MAC_COLS-1];
    logic        req_valid_out [0:MAC_COLS-1];

    // Activation LUT wires (×16 parallel)
    logic [7:0]  act_lut_dout [0:MAC_COLS-1];

    // ── FSM Sequential ────────────────────────────────────────────────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= ST_IDLE;
        else        state <= next;
    end

    always_comb begin
        next = state;
        case (state)
            ST_IDLE:          if (start)             next = ST_WEIGHT_LOAD;
            ST_WEIGHT_LOAD:   if (ld_done)           next = ST_COMPUTE;
            ST_ACT_LOAD:      if (act_ld_done)       next = ST_COMPUTE;
            ST_COMPUTE:       if (psum_valid)         next = ST_REQUANTIZE;
            ST_REQUANTIZE: begin
                if (req_valid_out[0]) begin
                    if (cfg_with_act)  next = ST_ACTIVATE;
                    else               next = ST_OUTPUT_LOW;
                end
            end
            ST_ACTIVATE:      next = ST_OUTPUT_LOW;
            ST_OUTPUT_LOW:    if (out_ready)          next = ST_OUTPUT_HIGH;
            ST_OUTPUT_HIGH: begin
                if (tile_count < cfg_num_tiles - 1)
                    next = ST_ACT_LOAD;
                else
                    next = ST_DONE;
            end
            ST_DONE:          if (!start)            next = ST_IDLE;
            default:          next = ST_IDLE;
        endcase
    end

    // ── Counters ──────────────────────────────────────────────────────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            w_phase     <= 6'd0;
            act_phase   <= 5'd0;
            tile_count  <= 8'd0;
            ld_done     <= 1'b0;
            act_ld_done <= 1'b0;
        end else begin
            case (state)
                ST_WEIGHT_LOAD: begin
                    if (weight_valid) begin
                        if (w_phase < WT_PHASES - 1) w_phase <= w_phase + 1;
                        if (w_phase == WT_PHASES - 1) ld_done <= 1'b1;
                    end
                end
                ST_ACT_LOAD: begin
                    if (act_valid && act_phase < MAC_ROWS - 1) act_phase <= act_phase + 1;
                    if (act_valid && act_phase == MAC_ROWS - 1) act_ld_done <= 1'b1;
                end
                ST_COMPUTE: begin
                end
                ST_OUTPUT_HIGH: begin
                    tile_count <= tile_count + 1;
                    act_phase  <= 5'd0;
                    act_ld_done <= 1'b0;
                end
                ST_DONE: begin
                    tile_count <= 8'd0;
                    ld_done    <= 1'b0;
                    act_ld_done <= 1'b0;
                end
                default: begin
                    if (next == ST_WEIGHT_LOAD) begin
                        w_phase     <= 6'd0;
                        act_phase   <= 5'd0;
                        ld_done     <= 1'b0;
                        act_ld_done <= 1'b0;
                    end else if (next == ST_ACT_LOAD) begin
                        act_phase   <= 5'd0;
                        act_ld_done <= 1'b0;
                    end
                end
            endcase
        end
    end

    // ── Weight Loading ────────────────────────────────────────────────────
    // For MAC_ROWS ≤ 8 (WORDS_PER_COL=1): direct unpack per cycle (original behavior)
    // For MAC_ROWS > 8 (WORDS_PER_COL>1): accumulate full column, then load in one shot
    genvar wr;
    generate
        if (WORDS_PER_COL == 1) begin : gen_w_direct
            for (wr = 0; wr < MAC_ROWS; wr++) begin
                assign w_load[wr] = weight_data[wr*8 +: 8];
            end
            assign load_weights = (state == ST_WEIGHT_LOAD && weight_valid);
        end else begin : gen_w_buffered
            logic [7:0]  wrk_buf [0:MAC_ROWS-1];
            logic [5:0]  wrk_idx;
            for (wr = 0; wr < MAC_ROWS; wr++) begin
                assign w_load[wr] = wrk_buf[wr];
            end
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    wrk_idx <= 5'd0;
                    for (int i = 0; i < MAC_ROWS; i++) wrk_buf[i] <= 8'd0;
                end else if (state == ST_WEIGHT_LOAD && weight_valid) begin
                    for (int i = 0; i < 8 && (wrk_idx + i) < MAC_ROWS; i++) begin
                        wrk_buf[wrk_idx + i] <= weight_data[i*8 +: 8];
                    end
                    if (wrk_idx + 8 < MAC_ROWS) wrk_idx <= wrk_idx + 8;
                end else begin
                    wrk_idx <= 5'd0;
                end
            end
            // Pulse load_weights on the cycle after last word of a column
            logic lw_delay;
            logic [$clog2(MAC_COLS)-1:0] w_col_idx_reg;
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n) begin
                    lw_delay <= 1'b0;
                    w_col_idx_reg <= '0;
                end else begin
                    lw_delay <= (state == ST_WEIGHT_LOAD && weight_valid && wrk_idx + 8 >= MAC_ROWS);
                    if (state == ST_WEIGHT_LOAD && weight_valid && wrk_idx + 8 >= MAC_ROWS)
                        w_col_idx_reg <= w_phase / WORDS_PER_COL;
                end
            end
            assign load_weights = lw_delay;
        end
    endgenerate

    logic [$clog2(MAC_COLS)-1:0] sys_w_load_col;
    assign sys_w_load_col = (WORDS_PER_COL == 1) ? w_phase : gen_w_buffered.w_col_idx_reg;

    assign weight_ready = (state == ST_WEIGHT_LOAD);

    // ── Activation Input ─────────────────────────────────────────────────
    // Tile 0: activations loaded during ST_WEIGHT_LOAD (from wt_raddr feed loop)
    // Subsequent tiles: activations loaded during ST_ACT_LOAD
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (int i = 0; i < MAC_ROWS; i++) act[i] <= 8'd0;
        end else if (state == ST_WEIGHT_LOAD && weight_valid) begin
            if (w_phase < MAC_ROWS) act[w_phase] <= act_data;
        end else if (state == ST_ACT_LOAD && act_valid) begin
            act[act_phase] <= act_data;
        end
    end

    assign act_ready = (state == ST_ACT_LOAD);
    assign compute   = (state == ST_COMPUTE);

    // ── Parallel Requantizers (×16) ─────────────────────────────────────
    logic        parallel_valid_in;
    assign parallel_valid_in = (state == ST_COMPUTE && psum_valid);

    genvar rq;
    for (rq = 0; rq < 16; rq++) begin : gen_requant
        gatev_requantize u_requant (
            .clk      (clk),
            .rst_n    (rst_n),
            .acc_in   (p_sum_out[rq]),
            .scale_m  (cfg_scale_m),
            .shift_r  (cfg_shift_r),
            .valid_in (parallel_valid_in),
            .dout     (req_dout[rq]),
            .valid_out(req_valid_out[rq])
        );
    end

    // ── Parallel Activation LUTs (×16) ──────────────────────────────────
    genvar al;
    for (al = 0; al < 16; al++) begin : gen_act_lut
        gatev_activation_lut u_act_lut (
            .clk  (clk),
            .addr (req_dout[al] ^ 8'h80),
            .dout (act_lut_dout[al])
        );
    end

    // ── Sub-module Instantiations ────────────────────────────────────────
    logic clear_pipeline;
    assign clear_pipeline = ((state == ST_WEIGHT_LOAD) && !ld_done) || (state == ST_ACT_LOAD);

    gatev_systolic #(.ROWS(MAC_ROWS), .COLS(MAC_COLS)) u_systolic (
        .clk          (clk),
        .rst_n        (rst_n),
        .load_weights (load_weights),
        .compute      (compute),
        .clear_psum   (clear_pipeline),
        .w_load       (w_load),
        .w_load_col   (sys_w_load_col),
        .act          (act),
        .p_sum_in     (p_sum_in),
        .p_sum_out    (p_sum_out),
        .psum_valid   (psum_valid)
    );

    // ── Output Packing (2 cycles: low 8 columns, high 8 columns) ────────
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_data  <= 64'd0;
            out_valid <= 1'b0;
        end else begin
            if (state == ST_REQUANTIZE && req_valid_out[0]) begin
                if (!cfg_with_act) begin
                    for (int i = 0; i < 8; i++) begin
                        out_data[i*8 +: 8] <= req_dout[i];
                    end
                    out_valid <= 1'b1;
                end
                // For cfg_with_act: LUT needs 1 cycle; output in ST_ACTIVATE
            end else if (state == ST_OUTPUT_LOW) begin
                out_valid <= 1'b0;
            end else if (state == ST_OUTPUT_HIGH) begin
                for (int i = 0; i < 8; i++) begin
                    out_data[i*8 +: 8] <= cfg_with_act ? act_lut_dout[i+8] : req_dout[i+8];
                end
                out_valid <= 1'b1;
            end else if (state == ST_ACTIVATE) begin
                for (int i = 0; i < 8; i++) begin
                    out_data[i*8 +: 8] <= act_lut_dout[i];
                end
                out_valid <= 1'b1;
            end else begin
                out_valid <= 1'b0;
            end
        end
    end

    assign busy = (state != ST_IDLE && state != ST_DONE);
    assign done = (state == ST_DONE);
    assign dbg_state = state;

endmodule
