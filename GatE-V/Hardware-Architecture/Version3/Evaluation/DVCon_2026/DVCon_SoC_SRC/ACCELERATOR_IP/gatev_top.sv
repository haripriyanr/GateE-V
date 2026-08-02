// GatE-V FPGA — Stage 2B Accelerator Top-Level
// Single-clock 100 MHz design. INT8 convolution accelerator with AXI4 interfaces.
// DSP-optimized mac_cell uses single-expression multiply-accumulate.
//
// Flow:
//   1. CPU writes config registers via AXI4-Lite slave (s_axil)
//   2. Main FSM loads weights + activations from DDR via AXI4 master (m_axi)
//   3. Feeds data to gatev_conv2d_tile_scheduler → gatev_shared_mac_engine
//   4. Writes result back to DDR
//   5. Asserts acc_done
//
// Multilayer support: 6-layer descriptor ROM (8×8×8, 1×1 conv, SiLU activation)
//   Layers 0-4: with_act=1, Layer 5: with_act=0 (identity)

import gatev_pkg::*;

module gatev_top (
    input  logic        aclk,
    input  logic        areset_n,

    // ── AXI4-Lite Slave (CPU config registers) ─────────────────────────
    input  logic [31:0] s_axil_awaddr, input  logic s_axil_awvalid, output logic s_axil_awready,
    input  logic [31:0] s_axil_wdata,  input  logic [3:0] s_axil_wstrb, input  logic s_axil_wvalid,
    output logic s_axil_wready, output logic [1:0] s_axil_bresp, output logic s_axil_bvalid,
    input  logic s_axil_bready,
    input  logic [31:0] s_axil_araddr, input  logic s_axil_arvalid, output logic s_axil_arready,
    output logic [31:0] s_axil_rdata, output logic [1:0] s_axil_rresp,
    output logic s_axil_rvalid, input  logic s_axil_rready,

    // ── AXI4 Full Master (DDR read/write) ──────────────────────────────
    output logic [AXI_ID_W-1:0]   m_axi_awid,    output logic [AXI_ADDR_W-1:0] m_axi_awaddr,
    output logic [7:0]            m_axi_awlen,   output logic [2:0]            m_axi_awsize,
    output logic [1:0]            m_axi_awburst, output logic                  m_axi_awvalid,
    input  logic                  m_axi_awready,
    output logic [63:0]           m_axi_wdata,   output logic [7:0]            m_axi_wstrb,
    output logic                  m_axi_wlast,   output logic                  m_axi_wvalid,
    input  logic                  m_axi_wready,
    input  logic [AXI_ID_W-1:0]   m_axi_bid,     input  logic [1:0]            m_axi_bresp,
    input  logic                  m_axi_bvalid,  output logic                  m_axi_bready,
    output logic [AXI_ID_W-1:0]   m_axi_arid,    output logic [AXI_ADDR_W-1:0] m_axi_araddr,
    output logic [7:0]            m_axi_arlen,   output logic [2:0]            m_axi_arsize,
    output logic [1:0]            m_axi_arburst, output logic                  m_axi_arvalid,
    input  logic                  m_axi_arready,
    input  logic [AXI_ID_W-1:0]   m_axi_rid,     input  logic [63:0]           m_axi_rdata,
    input  logic [1:0]            m_axi_rresp,   input  logic                  m_axi_rlast,
    input  logic                  m_axi_rvalid,  output logic                  m_axi_rready,

    // Config
    // Status
    output logic        acc_done
);

    // ── Internal Signals ─────────────────────────────────────────────────
    // Control from register file
    logic        acc_start;
    logic [AXI_ADDR_W-1:0] reg_img_addr, reg_wt_addr, reg_out_addr;
    logic [7:0]  cfg_num_tiles;

    // Scheduler interface
    logic        sched_start, sched_busy, sched_done;
    logic [63:0] sched_weight;
    logic        sched_wvalid, sched_wready;
    logic [7:0]  sched_act_data;
    logic [63:0] sched_out;
    logic        sched_outv;

    // Ping-pong weight buffers (64 × 64-bit words each)
    logic [63:0] wt_bank_0 [0:63];
    logic [63:0] wt_bank_1 [0:63];
    logic        bank_sel;       // 0→read from bank_0, write to bank_1; 1→vice versa
    logic [5:0]  wt_raddr;

    // Ping-pong activation buffers (128 bytes each — 32 bytes/tile × 4 tiles)
    logic [7:0]  act_buf_0 [0:127];
    logic [7:0]  act_buf_1 [0:127];
    logic [5:0]  act_ld_cnt;
    logic [6:0]  act_feed_ptr;
    logic        load_phase;

    // Muxed read ports for scheduler (reads active bank)
    wire [63:0] wt_bank [0:63];
    wire [7:0]  act_buf [0:127];
    generate
        for (genvar i = 0; i < 64; i++) assign wt_bank[i] = bank_sel ? wt_bank_1[i] : wt_bank_0[i];
        for (genvar i = 0; i < 128; i++) assign act_buf[i] = bank_sel ? act_buf_1[i] : act_buf_0[i];
    endgenerate

    // Background load during S_RUN
    logic        bg_load_active;  // background load in progress
    logic        bg_load_phase;   // 0=act load, 1=weight load
    logic [5:0]  bg_act_cnt;
    logic [6:0]  bg_wt_cnt;
    logic        bg_rd_pending;
    logic        bg_burst_issued;

    // Self-feed
    wire sched_act_feed;

    // Output buffer (up to 4 tiles × 2 words = 8 × 64-bit)
    logic [63:0] out_buf [0:7];
    logic [3:0]  out_buf_cnt;
    logic [3:0]  store_cnt;

    // AXI4 master internal request interface
    logic        m_rd_req;
    logic [AXI_ADDR_W-1:0] m_rd_addr;
    logic [7:0]  m_rd_len;
    logic [63:0] m_rd_data;
    logic        m_rd_valid;
    logic        m_wr_req;
    logic [AXI_ADDR_W-1:0] m_wr_addr;
    logic [63:0] m_wr_data_in;
    logic [7:0]  m_wr_strb;
    logic [7:0]  m_wr_len;
    logic        m_wr_data_valid;
    logic        m_wr_data_ready;
    logic        m_wr_ack;

    // ── Layer Descriptor ROM ─────────────────────────────────────────────
    localparam int ACT_WORDS_PER_TILE = (MAC_ROWS + 7) / 8;  // 4 for MAC_ROWS=32
    localparam int NUM_LAYERS = 6;
    logic [2:0] layer_idx;

    layer_desc_t layer_rom [0:NUM_LAYERS-1];
    always_comb begin
        layer_rom[0] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
        layer_rom[1] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
        layer_rom[2] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
        layer_rom[3] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
        layer_rom[4] = '{with_act: 1'b1, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
        layer_rom[5] = '{with_act: 1'b0, kernel: 3'd0, in_ch: 16'd8, out_ch: 16'd16, in_w: 16'd8, out_h: 16'd8, out_w: 16'd8, scale_m: 16'd16, shift_r: 5'd0};
    end

    // Scheduler config from current layer
    logic [15:0] cfg_layer_scale_m;
    logic [4:0]  cfg_layer_shift_r;
    logic        cfg_layer_with_act;
    logic [7:0]  cfg_layer_kernel_size;
    logic [15:0] cfg_layer_num_in_grps;

    always_comb begin
        cfg_layer_scale_m     = layer_rom[layer_idx].scale_m;
        cfg_layer_shift_r     = layer_rom[layer_idx].shift_r;
        cfg_layer_with_act    = layer_rom[layer_idx].with_act;
        cfg_layer_kernel_size = layer_rom[layer_idx].kernel + 1;
        cfg_layer_num_in_grps = (layer_rom[layer_idx].in_ch + 7) / 8;
    end

    // ── Performance Counters ─────────────────────────────────────────────
    logic [63:0] perf_cycle;
    logic [31:0] perf_rd_bytes, perf_wr_bytes, perf_mac, perf_stall;
    logic        perf_running;
    logic [2:0]  mac_state;
    assign mac_state = u_sched.u_mac.dbg_state;

    // FSM signals (declared early for perf counter use)
    typedef enum logic [2:0] { S_IDLE, S_LOAD, S_RUN, S_WAIT, S_STORE, S_DONE } state_e;
    state_e state;
    logic        all_done;

    // ── Sub-module Instantiations ────────────────────────────────────────

    // AXI4-Lite Register File (CPU config)
    gatev_axi_lite_slave u_regfile (
        .aclk(aclk), .areset_n(areset_n),
        .awaddr(s_axil_awaddr), .awvalid(s_axil_awvalid), .awready(s_axil_awready),
        .wdata(s_axil_wdata), .wstrb(s_axil_wstrb), .wvalid(s_axil_wvalid),
        .wready(s_axil_wready), .bresp(s_axil_bresp), .bvalid(s_axil_bvalid), .bready(s_axil_bready),
        .araddr(s_axil_araddr), .arvalid(s_axil_arvalid), .arready(s_axil_arready),
        .rdata(s_axil_rdata), .rresp(s_axil_rresp), .rvalid(s_axil_rvalid), .rready(s_axil_rready),
        .start(acc_start), .done(), .task_id(), .mode(),
        .tiles_num(cfg_num_tiles),
        .img_base_addr(reg_img_addr), .wt_base_addr(reg_wt_addr), .out_base_addr(reg_out_addr),
        .dma_reg_start(), .dma_reg_dir(), .dma_reg_src_addr(), .dma_reg_dst_addr(),
        .dma_reg_len(), .dma_done(acc_done), .dma_bytes(32'd0),
        .burst_type(), .burst_len(), .burst_size(),
        .perf_cycle_low(perf_cycle[31:0]), .perf_cycle_high(perf_cycle[63:32]),
        .perf_read_bytes(perf_rd_bytes), .perf_write_bytes(perf_wr_bytes),
        .perf_mac_cycles(perf_mac), .perf_stall_cycles(perf_stall),
        .interrupt()
    );

    // AXI4 Full Master (DDR access)
    gatev_axi4_master u_axi_master (
        .clk(aclk), .rst_n(areset_n),
        .rd_req(m_rd_req), .rd_addr(m_rd_addr), .rd_len(m_rd_len),
        .rd_data(m_rd_data), .rd_valid(m_rd_valid),
        .wr_req(m_wr_req), .wr_addr(m_wr_addr), .wr_strb(m_wr_strb),
        .wr_len(m_wr_len), .wr_data_in(m_wr_data_in), .wr_data_valid(m_wr_data_valid),
        .wr_data_ready(m_wr_data_ready), .wr_ack(m_wr_ack),
        .m_axi_awid(m_axi_awid), .m_axi_awaddr(m_axi_awaddr),
        .m_axi_awlen(m_axi_awlen), .m_axi_awsize(m_axi_awsize),
        .m_axi_awburst(m_axi_awburst), .m_axi_awvalid(m_axi_awvalid),
        .m_axi_awready(m_axi_awready),
        .m_axi_wdata(m_axi_wdata), .m_axi_wstrb(m_axi_wstrb),
        .m_axi_wlast(m_axi_wlast), .m_axi_wvalid(m_axi_wvalid),
        .m_axi_wready(m_axi_wready),
        .m_axi_bid(m_axi_bid), .m_axi_bresp(m_axi_bresp),
        .m_axi_bvalid(m_axi_bvalid), .m_axi_bready(m_axi_bready),
        .m_axi_arid(m_axi_arid), .m_axi_araddr(m_axi_araddr),
        .m_axi_arlen(m_axi_arlen), .m_axi_arsize(m_axi_arsize),
        .m_axi_arburst(m_axi_arburst), .m_axi_arvalid(m_axi_arvalid),
        .m_axi_arready(m_axi_arready),
        .m_axi_rid(m_axi_rid), .m_axi_rdata(m_axi_rdata),
        .m_axi_rresp(m_axi_rresp), .m_axi_rlast(m_axi_rlast),
        .m_axi_rvalid(m_axi_rvalid), .m_axi_rready(m_axi_rready),
        .cfg_burst_type(2'b01), .cfg_burst_size(3'd3)
    );

    // Conv2D Tile Scheduler (config from layer ROM)
    gatev_conv2d_tile_scheduler u_sched (
        .clk(aclk), .rst_n(areset_n),
        .start(sched_start), .busy(sched_busy), .done(sched_done),
        .weight_data(sched_weight), .weight_valid(sched_wvalid), .weight_ready(sched_wready),
        .act_data(sched_act_data), .act_valid(sched_act_feed), .act_ready(sched_act_feed),
        .out_data(sched_out), .out_valid(sched_outv), .out_ready(1'b1),
        .cfg_num_in_grps(cfg_layer_num_in_grps),
        .cfg_kernel_size(cfg_layer_kernel_size),
        .cfg_scale_m(cfg_layer_scale_m),
        .cfg_shift_r(cfg_layer_shift_r),
        .cfg_with_act(cfg_layer_with_act),
        .cfg_num_tiles(cfg_num_tiles),
        .dbg_state(), .dbg_next(), .dbg_round_cnt(), .dbg_w_col_cnt(),
        .dbg_mac_start(), .dbg_mac_done(), .dbg_mac_weight_ready(), .dbg_mac_state()
    );

    // ── Performance Counter Logic ──────────────────────────────────────────
    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            perf_cycle    <= 64'd0;
            perf_rd_bytes <= 32'd0;
            perf_wr_bytes <= 32'd0;
            perf_mac      <= 32'd0;
            perf_stall    <= 32'd0;
            perf_running  <= 1'b0;
        end else begin
            if (acc_start) perf_running <= 1'b1;
            else if (all_done) perf_running <= 1'b0;

            if (perf_running) begin
                perf_cycle <= perf_cycle + 1;
                if (mac_state inside {3'd3, 3'd4, 3'd5, 3'd6, 3'd7})
                    perf_mac <= perf_mac + 1;
                if (state == S_LOAD || state == S_STORE)
                    perf_stall <= perf_stall + 1;
            end

            if (m_rd_valid)  perf_rd_bytes <= perf_rd_bytes + 8;
            if (m_wr_ack)    perf_wr_bytes <= perf_wr_bytes + ((m_wr_len + 1) << 3);
        end
    end

    // ── Main Controller FSM ──────────────────────────────────────────────
    logic [6:0]  ld_cnt;
    logic [AXI_ADDR_W-1:0] ld_addr;
    logic        sched_pulsed;
    logic        rd_pending;
    logic        burst_issued;
    logic        wr_pending;
    logic [7:0]  wr_beat_cnt;
    logic [AXI_ADDR_W-1:0] out_addr;

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            state <= S_IDLE;
            layer_idx <= 3'd0;
            ld_cnt <= 7'd0; ld_addr <= {AXI_ADDR_W{1'b0}}; sched_pulsed <= 1'b0;
            rd_pending <= 1'b0; burst_issued <= 1'b0; wr_pending <= 1'b0; all_done <= 1'b0;
            m_rd_req <= 1'b0; m_rd_addr <= {AXI_ADDR_W{1'b0}}; m_rd_len <= 8'd0;
            m_wr_req <= 1'b0; m_wr_addr <= {AXI_ADDR_W{1'b0}}; m_wr_strb <= 8'd0; m_wr_len <= 8'd0;
            m_wr_data_in <= 64'd0; m_wr_data_valid <= 1'b0; out_addr <= {AXI_ADDR_W{1'b0}};
            for (int i = 0; i < 64; i++) begin wt_bank_0[i] <= 64'd0; wt_bank_1[i] <= 64'd0; end
            bank_sel <= 1'b0; wt_raddr <= 6'd0;
            for (int i = 0; i < 128; i++) begin act_buf_0[i] <= 8'd0; act_buf_1[i] <= 8'd0; end
            act_ld_cnt <= 6'd0; act_feed_ptr <= 7'd0; load_phase <= 1'b0;
            bg_load_active <= 1'b0; bg_load_phase <= 1'b0;
            bg_act_cnt <= 6'd0; bg_wt_cnt <= 7'd0;
            bg_rd_pending <= 1'b0; bg_burst_issued <= 1'b0;
            sched_weight <= 64'd0; sched_wvalid <= 1'b0; sched_act_data <= 8'd0;
            sched_start <= 1'b0;
            for (int i = 0; i < 8; i++) out_buf[i] <= 64'd0;
            out_buf_cnt <= 4'd0; store_cnt <= 4'd0;
        end else begin
            m_rd_req <= 1'b0; m_wr_req <= 1'b0;
            sched_wvalid <= 1'b0; sched_start <= 1'b0;

            // Capture scheduler output into buffer
            if (sched_outv && out_buf_cnt < 8) begin
                out_buf[out_buf_cnt] <= sched_out;
                out_buf_cnt <= out_buf_cnt + 1;
            end

            case (state)
                S_IDLE: begin
                    for (int i = 0; i < 8; i++) out_buf[i] <= 64'd0;
                    out_buf_cnt <= 4'd0; store_cnt <= 4'd0;
                    layer_idx <= 3'd0;
                    all_done <= 1'b0;
                    if (acc_start) begin
                        out_addr     <= reg_out_addr;
                        ld_addr      <= reg_img_addr;
                        act_ld_cnt   <= 6'd0;
                        ld_cnt       <= 7'd0;
                        load_phase   <= 1'b0;
                        rd_pending   <= 1'b0;
                        burst_issued <= 1'b0;
                        state        <= S_LOAD;
                    end
                end

                S_LOAD: begin
                    // Phase A: Load cfg_num_tiles activation words into inactive bank (multi-beat burst)
                    if (!load_phase) begin
                        if (act_ld_cnt >= cfg_num_tiles * ACT_WORDS_PER_TILE) begin
                            load_phase  <= 1'b1;
                            ld_addr    <= reg_wt_addr;
                            rd_pending <= 1'b0;
                        end else if (m_rd_valid) begin
                            for (int i = 0; i < 8; i++) begin
                                if (bank_sel)
                                    act_buf_0[act_ld_cnt*8 + i] <= m_rd_data[i*8 +: 8];
                                else
                                    act_buf_1[act_ld_cnt*8 + i] <= m_rd_data[i*8 +: 8];
                            end
                            act_ld_cnt <= act_ld_cnt + 1;
                            if (act_ld_cnt == cfg_num_tiles * ACT_WORDS_PER_TILE - 1)
                                rd_pending <= 1'b0;
                        end else if (!rd_pending) begin
                            m_rd_req   <= 1'b1;
                            m_rd_addr  <= ld_addr;
                            m_rd_len   <= (cfg_num_tiles * ACT_WORDS_PER_TILE) - 1;
                            rd_pending <= 1'b1;
                        end
                    end else begin
                        // Phase B: Load 64 weight words into inactive bank
                        if (ld_cnt >= 64) begin
                            wt_raddr  <= 6'd0;
                            bank_sel  <= !bank_sel;  // loaded bank becomes active
                            state <= S_RUN;
                        end else if (m_rd_valid) begin
                            if (bank_sel)
                                wt_bank_0[ld_cnt] <= m_rd_data;
                            else
                                wt_bank_1[ld_cnt] <= m_rd_data;
                            ld_cnt    <= ld_cnt + 1;
                        end else if (!burst_issued) begin
                            m_rd_req     <= 1'b1;
                            m_rd_addr    <= ld_addr;
                            m_rd_len     <= 8'd63;
                            burst_issued <= 1'b1;
                        end
                    end
                end

                S_RUN: begin
                    if (!sched_busy && !sched_pulsed) begin
                        sched_start   <= 1'b1;
                        sched_pulsed  <= 1'b1;
                        act_feed_ptr  <= 7'd32;
                        // Start background load for next layer (skip for last layer)
                        if (layer_idx < NUM_LAYERS - 1) begin
                            bg_load_active  <= 1'b1;
                            bg_load_phase   <= 1'b0;
                            bg_act_cnt      <= 6'd0;
                            bg_wt_cnt       <= 6'd0;
                            bg_rd_pending   <= 1'b0;
                            bg_burst_issued <= 1'b0;
                        end
                    end
                    // Weight + initial activation feed (tile 0) from active bank
                    if (sched_wready && wt_raddr < 64) begin
                        sched_weight   <= wt_bank[wt_raddr];
                        sched_wvalid   <= 1'b1;
                        sched_act_data <= act_buf[wt_raddr];
                        wt_raddr       <= wt_raddr + 1;
                    end
                    // Multi-tile activation feed (tiles 1..N-1) from active bank
                    if (sched_act_feed && act_feed_ptr < cfg_num_tiles * MAC_ROWS) begin
                        sched_act_data <= act_buf[act_feed_ptr];
                        act_feed_ptr   <= act_feed_ptr + 1;
                    end
                    // ── Background Load: load next layer into inactive bank ──
                    if (bg_load_active) begin
                        if (!bg_load_phase) begin
                            // Phase A: load activations (multi-beat burst)
                            if (bg_act_cnt >= cfg_num_tiles * ACT_WORDS_PER_TILE) begin
                                bg_load_phase <= 1'b1;
                                bg_rd_pending <= 1'b0;
                            end else if (m_rd_valid) begin
                                for (int i = 0; i < 8; i++) begin
                                    if (bank_sel)
                                        act_buf_0[bg_act_cnt*8 + i] <= m_rd_data[i*8 +: 8];
                                    else
                                        act_buf_1[bg_act_cnt*8 + i] <= m_rd_data[i*8 +: 8];
                                end
                                bg_act_cnt   <= bg_act_cnt + 1;
                                if (bg_act_cnt == cfg_num_tiles * ACT_WORDS_PER_TILE - 1)
                                    bg_rd_pending <= 1'b0;
                            end else if (!bg_rd_pending) begin
                                m_rd_req      <= 1'b1;
                                m_rd_addr     <= reg_img_addr;
                                m_rd_len      <= (cfg_num_tiles * ACT_WORDS_PER_TILE) - 1;
                                bg_rd_pending <= 1'b1;
                            end
                        end else begin
                            // Phase B: load weights
                            if (bg_wt_cnt >= 64) begin
                                bg_load_active <= 1'b0;
                            end else if (m_rd_valid) begin
                                if (bank_sel)
                                    wt_bank_0[bg_wt_cnt] <= m_rd_data;
                                else
                                    wt_bank_1[bg_wt_cnt] <= m_rd_data;
                                bg_wt_cnt      <= bg_wt_cnt + 1;
                            end else if (!bg_burst_issued) begin
                                m_rd_req        <= 1'b1;
                                m_rd_addr       <= reg_wt_addr;
                                m_rd_len        <= 8'd63;
                                bg_burst_issued <= 1'b1;
                            end
                        end
                    end
                    // Wait for scheduler done AND background load complete
                    if (sched_done && !bg_load_active) begin
                        sched_pulsed <= 1'b0;
                        state <= S_WAIT;
                    end
                end

                S_WAIT: begin
                    state <= S_STORE;
                end

                S_STORE: begin
                    // Burst write all buffered output words in a single transaction
                    if (!wr_pending) begin
                        if (out_buf_cnt > 0) begin
                            m_wr_req        <= 1'b1;
                            m_wr_addr       <= out_addr;
                            m_wr_strb       <= 8'b1111_1111;
                            m_wr_len        <= out_buf_cnt - 1;
                            m_wr_data_in    <= out_buf[0];
                            m_wr_data_valid <= 1'b1;
                            store_cnt       <= 4'd1;
                            wr_pending      <= 1'b1;
                        end else begin
                            state <= S_WAIT;
                        end
                    end else if (m_wr_ack) begin
                        // Burst write complete
                        m_wr_data_valid <= 1'b0;
                        store_cnt   <= 4'd0;
                        out_buf_cnt <= 4'd0;
                        out_addr    <= out_addr + (store_cnt << 3);
                        wr_pending  <= 1'b0;
                        if (layer_idx >= NUM_LAYERS - 1) begin
                            all_done <= 1'b1;
                            state <= S_DONE;
                        end else begin
                            layer_idx    <= layer_idx + 1;
                            bank_sel     <= !bank_sel;  // swap active bank (next layer ready in bg)
                            wt_raddr     <= 6'd0;       // reset scheduler read pointer
                            act_feed_ptr <= 7'd0;
                            sched_pulsed <= 1'b0;
                            state        <= S_RUN;      // skip S_LOAD — bg load already populated it
                        end
                    end else if (m_wr_data_ready && store_cnt < out_buf_cnt) begin
                        // Advance to next beat
                        m_wr_data_in  <= out_buf[store_cnt];
                        m_wr_data_valid <= 1'b1;
                        store_cnt     <= store_cnt + 1;
                    end
                end

                S_DONE: begin
                    if (!acc_start) state <= S_IDLE;
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign acc_done = all_done;

endmodule
