// GatE-V FPGA — Stage 2B Integration Testbench
// Tests the full accelerator flow:
//   1. Pre-load DDR with weights + activations
//   2. Configure via AXI4-Lite register writes
//   3. Start accelerator
//   4. Wait for acc_done
//   5. Read output from DDR
//   6. Compare against expected golden values
//   7. Print pass/fail
//
// Run with: vsim -c -do "run -all" tb_gatev
// Or Vivado Simulator: launch_simulation

`timescale 1ns/1ps

import gatev_pkg::*;

module tb_gatev;

    // ── Clock & Reset ──────────────────────────────────────────────────
    logic clk;
    logic rst_n;

    // Clock generation: 100 MHz (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Reset: active low, deassert after 100 ns
    initial begin
        rst_n = 1'b0;
        #100;
        rst_n = 1'b1;
    end

    // ── AXI4-Lite Interface (to DUT slave) ──────────────────────────────
    logic [31:0] s_axil_awaddr, s_axil_wdata;
    logic [3:0]  s_axil_wstrb;
    logic        s_axil_awvalid, s_axil_wvalid, s_axil_bready;
    logic        s_axil_awready, s_axil_wready, s_axil_bvalid;
    logic [1:0]  s_axil_bresp;
    logic [31:0] s_axil_araddr;
    logic        s_axil_arvalid, s_axil_rready;
    logic        s_axil_arready, s_axil_rvalid;
    logic [31:0] s_axil_rdata;
    logic [1:0]  s_axil_rresp;

    // ── AXI4 Full Interface (DUT master ↔ DDR model) ───────────────────
    logic [AXI_ID_W-1:0]   m_axi_awid;    logic [AXI_ADDR_W-1:0] m_axi_awaddr;
    logic [7:0]            m_axi_awlen;   logic [2:0]            m_axi_awsize;
    logic [1:0]            m_axi_awburst; logic                  m_axi_awvalid;
    logic                  m_axi_awready;
    logic [63:0]           m_axi_wdata;   logic [7:0]            m_axi_wstrb;
    logic                  m_axi_wlast;   logic                  m_axi_wvalid;
    logic                  m_axi_wready;
    logic [AXI_ID_W-1:0]   m_axi_bid;     logic [1:0]            m_axi_bresp;
    logic                  m_axi_bvalid;  logic                  m_axi_bready;
    logic [AXI_ID_W-1:0]   m_axi_arid;    logic [AXI_ADDR_W-1:0] m_axi_araddr;
    logic [7:0]            m_axi_arlen;   logic [2:0]            m_axi_arsize;
    logic [1:0]            m_axi_arburst; logic                  m_axi_arvalid;
    logic                  m_axi_arready;
    logic [AXI_ID_W-1:0]   m_axi_rid;     logic [63:0]           m_axi_rdata;
    logic [1:0]            m_axi_rresp;   logic                  m_axi_rlast;
    logic                  m_axi_rvalid;  logic                  m_axi_rready;

    logic acc_done;

    // ── DUT ─────────────────────────────────────────────────────────────
    gatev_top u_dut (
        .aclk(clk), .areset_n(rst_n),
        .s_axil_awaddr(s_axil_awaddr), .s_axil_awvalid(s_axil_awvalid), .s_axil_awready(s_axil_awready),
        .s_axil_wdata(s_axil_wdata), .s_axil_wstrb(s_axil_wstrb), .s_axil_wvalid(s_axil_wvalid),
        .s_axil_wready(s_axil_wready), .s_axil_bresp(s_axil_bresp), .s_axil_bvalid(s_axil_bvalid),
        .s_axil_bready(s_axil_bready),
        .s_axil_araddr(s_axil_araddr), .s_axil_arvalid(s_axil_arvalid), .s_axil_arready(s_axil_arready),
        .s_axil_rdata(s_axil_rdata), .s_axil_rresp(s_axil_rresp), .s_axil_rvalid(s_axil_rvalid),
        .s_axil_rready(s_axil_rready),
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
        .acc_done(acc_done)
    );

    // ── DDR3 Memory Model ──────────────────────────────────────────────
    gatev_ddr3_model u_ddr (
        .clk(clk), .rst_n(rst_n),
        .s_axi_awid(m_axi_awid), .s_axi_awaddr(m_axi_awaddr),
        .s_axi_awlen(m_axi_awlen), .s_axi_awsize(m_axi_awsize),
        .s_axi_awburst(m_axi_awburst), .s_axi_awvalid(m_axi_awvalid),
        .s_axi_awready(m_axi_awready),
        .s_axi_wdata(m_axi_wdata), .s_axi_wstrb(m_axi_wstrb),
        .s_axi_wlast(m_axi_wlast), .s_axi_wvalid(m_axi_wvalid),
        .s_axi_wready(m_axi_wready),
        .s_axi_bid(m_axi_bid), .s_axi_bresp(m_axi_bresp),
        .s_axi_bvalid(m_axi_bvalid), .s_axi_bready(m_axi_bready),
        .s_axi_arid(m_axi_arid), .s_axi_araddr(m_axi_araddr),
        .s_axi_arlen(m_axi_arlen), .s_axi_arsize(m_axi_arsize),
        .s_axi_arburst(m_axi_arburst), .s_axi_arvalid(m_axi_arvalid),
        .s_axi_arready(m_axi_arready),
        .s_axi_rid(m_axi_rid), .s_axi_rdata(m_axi_rdata),
        .s_axi_rresp(m_axi_rresp), .s_axi_rlast(m_axi_rlast),
        .s_axi_rvalid(m_axi_rvalid), .s_axi_rready(m_axi_rready)
    );

    // ── AXI4-Lite Driver Tasks ─────────────────────────────────────────
    // Single write to a 32-bit aligned register
    task axil_write(input logic [31:0] addr, input logic [31:0] data);
        @(posedge clk);
        s_axil_awaddr  <= addr;
        s_axil_awvalid <= 1'b1;
        s_axil_wdata   <= data;
        s_axil_wstrb   <= 4'b1111;
        s_axil_wvalid  <= 1'b1;
        s_axil_bready  <= 1'b1;
        wait (s_axil_awready && s_axil_wready);
        @(posedge clk);
        s_axil_awvalid <= 1'b0;
        s_axil_wvalid  <= 1'b0;
        s_axil_awaddr  <= 32'd0;
        s_axil_wdata   <= 32'd0;
        s_axil_wstrb   <= 4'd0;
        wait (s_axil_bvalid);
        @(posedge clk);
        s_axil_bready <= 1'b0;
    endtask

    // Single read from a 32-bit aligned register
    task axil_read(input logic [31:0] addr, output logic [31:0] data);
        @(posedge clk);
        s_axil_araddr  <= addr;
        s_axil_arvalid <= 1'b1;
        s_axil_rready  <= 1'b1;
        wait (s_axil_arready);
        @(posedge clk);
        s_axil_arvalid <= 1'b0;
        s_axil_araddr  <= 32'd0;
        wait (s_axil_rvalid);
        data = s_axil_rdata;
        @(posedge clk);
        s_axil_rready <= 1'b0;
    endtask

    // ── Test Stimulus ──────────────────────────────────────────────────
    // Configuration constants
`ifdef NUM_TILES
    localparam int NUM_TILES = `NUM_TILES;
`else
    localparam int          NUM_TILES = 4;
`endif
    localparam logic [AXI_ADDR_W-1:0] IMG_BASE  = 64'h0000_0000_0000_0000;  // activations in DDR
    localparam logic [AXI_ADDR_W-1:0] WT_BASE   = 64'h0000_0000_0000_0100;  // weights in DDR
    localparam logic [AXI_ADDR_W-1:0] OUT_BASE  = 64'h0000_0000_0000_8000;  // output in DDR

    // 32-wide MAC: 32 input channels × 16 output channels, 1×1 conv
    // Test layer has 8 in_ch (padded to 32 with all-1's in this test).
    // Expected output for each layer:
    //   Accum = 32 (all-1 weights × all-1 activations, 32 in_ch padded)
    //   Req   = clamp(32 * 16 >> 0) = clamp(512) = 127
    //   SiLU  = LUT[127 ^ 0x80] = LUT[255] = 93
    //   Layer 5: with_act=0, skips SiLU → output = req_dout = 127
    localparam logic [7:0] EXPECTED = 8'd93;
    localparam logic [7:0] EXPECTED_LAYER5 = 8'd127;

    // Signals for acc_done detection
    logic done_prev;
    logic done_rose;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_prev <= 1'b0;
            done_rose <= 1'b0;
        end else begin
            done_prev <= acc_done;
            done_rose <= acc_done && !done_prev;
        end
    end

    // ── Main Test Sequence ─────────────────────────────────────────────
    initial begin
        logic [31:0] rd_val;
        logic [63:0] mem_val;
        logic [7:0]  result;
        int          err_count;
        string       test_name;

        // Initialize AXI-Lite signals
        s_axil_awaddr  <= 32'd0; s_axil_awvalid <= 1'b0;
        s_axil_wdata   <= 32'd0; s_axil_wstrb   <= 4'd0;
        s_axil_wvalid  <= 1'b0;  s_axil_bready  <= 1'b0;
        s_axil_araddr  <= 32'd0; s_axil_arvalid <= 1'b0;
        s_axil_rready  <= 1'b0;

        err_count = 0;

        // Wait for reset deassert
        @(posedge rst_n);
        #20;
        @(posedge clk);

        // ═══════════════════════════════════════════════════════════════
        // Test 1: Basic Register Read/Write (AXI-Lite Slave Validation)
        // ═══════════════════════════════════════════════════════════════
        test_name = "AXI-Lite Register Write/Read";
        $display("┌─ %s", test_name);
        $display("│");

        axil_write(TASK_ID_REG_ADDR, 32'h0000_00A5);
        axil_read(TASK_ID_REG_ADDR, rd_val);
        if (rd_val[7:0] == 8'hA5) begin
            $display("│  [OK] TASK_ID write/read: 0x%02h (expected 0xA5)", rd_val[7:0]);
        end else begin
            $display("│  [ERR] TASK_ID MISMATCH: got 0x%02h, expected 0xA5", rd_val[7:0]);
            err_count++;
        end

        axil_write(MODE_REG_ADDR, 32'h0000_0042);
        axil_read(MODE_REG_ADDR, rd_val);
        if (rd_val[7:0] == 8'h42) begin
            $display("│  [OK] MODE write/read: 0x%02h (expected 0x42)", rd_val[7:0]);
        end else begin
            $display("│  [ERR] MODE MISMATCH: got 0x%02h, expected 0x42", rd_val[7:0]);
            err_count++;
        end
        $display("│");

        // ═══════════════════════════════════════════════════════════════
        // Test 2: Conv2D Acceleration (Full Flow)
        // ═══════════════════════════════════════════════════════════════
        test_name = "Conv2D Accelerator - All-1 Weights & Activations";
        $display("├─ %s", test_name);
        $display("│");

        // Step 1: Pre-load DDR with activations at IMG_BASE
        // NUM_TILES tiles × 32 INT8 activations per tile = all 1's (4 words per tile)
        // Packed as: {act[31], ..., act[0]} = {1,1,1,1,1,1,1,1,...}
        // Tile i activation starts at IMG_BASE + i*32
        for (int t = 0; t < NUM_TILES; t++) begin
            u_ddr.write_word(IMG_BASE + (t * 32),      64'h0101_0101_0101_0101);
            u_ddr.write_word(IMG_BASE + (t * 32 + 8),   64'h0101_0101_0101_0101);
            u_ddr.write_word(IMG_BASE + (t * 32 + 16),  64'h0101_0101_0101_0101);
            u_ddr.write_word(IMG_BASE + (t * 32 + 24),  64'h0101_0101_0101_0101);
        end

        // Step 2: Pre-load DDR with weights at WT_BASE
        // 16 columns × 32 rows = 512 × INT8 = all 1's
        // 4 words per column (8 INT8 per 64-bit word)
        // Top loads 64 weight words in a single 64-beat burst from WT_BASE
        for (int col = 0; col < 64; col++) begin
            // Each weight word: {w_row7, ..., w_row0} = {1,1,1,1,1,1,1,1}
            u_ddr.write_word(WT_BASE + (col << 3), 64'h0101_0101_0101_0101);
        end

        // Step 3: Configure accelerator base addresses and tile count
        $display("│  Configuring accelerator registers...");
        axil_write(TILES_NUM_REG_ADDR, NUM_TILES);
        axil_write(IMG_BASE_ADDR_REG, IMG_BASE[31:0]);
        axil_write(WT_BASE_ADDR_REG, WT_BASE[31:0]);
        axil_write(OUT_BASE_ADDR_REG, OUT_BASE[31:0]);

        // Step 4: Read status register (should show not-done)
        axil_read(STATUS_REG_ADDR, rd_val);
        $display("│  Status before start: 0x%08h", rd_val);

        // Step 5: Start accelerator
        $display("│  Starting accelerator...");
        axil_write(CTRL_REG_ADDR, 32'h0000_0001);   // set start bit
        $display("│  Waiting for acc_done...");

        // Step 6: Wait for acc_done rising edge
        wait (done_rose);
        $display("│  [OK] acc_done asserted");

        // Step 7: Read output from DDR
        // Layer 0 result is stored at OUT_BASE + 0
        mem_val = u_ddr.read_word(OUT_BASE);
        result  = mem_val[7:0];
        $display("│");
        $display("│  Layer 0 output from DDR[0x%08h] = 0x%02h (%0d)", OUT_BASE[31:0], result, result);

        // Step 8: Compare against expected
        if (result == EXPECTED) begin
            $display("│  [OK] Output matches expected value %0d", EXPECTED);
        end else begin
            $display("│  [ERR] OUTPUT MISMATCH: got %0d, expected %0d", result, EXPECTED);
            err_count++;
        end

        // Step 9: Read back all 6 layer outputs
        // Each layer stores NUM_TILES × 32 INT8 values (NUM_TILES × 4 × 64-bit words)
        // Sequential: layer l starts at OUT_BASE + l * NUM_TILES * 32
        $display("│");
        $display("│  All layer outputs (NUM_TILES=%0d):", NUM_TILES);
        for (int l = 0; l < 6; l++) begin
            logic [7:0]  exp;
            int          chk_err;
            int          layer_bytes;
            chk_err = 0;
            exp = (l == 5) ? EXPECTED_LAYER5 : EXPECTED;
            layer_bytes = l * NUM_TILES * 16;
            for (int w = 0; w < NUM_TILES * 2; w++) begin
                logic [AXI_ADDR_W-1:0] off;
                off = OUT_BASE + layer_bytes + (w << 3);
                mem_val = u_ddr.read_word(off);
                for (int b = 0; b < 8; b++) begin
                    result = mem_val[b*8 +: 8];
                    if (result != exp) chk_err++;
                end
            end
            err_count += chk_err;
            $display("│    Layer %0d @ [0x%08h] = %0d (%0d tiles x 16 channels)%s",
                     l, OUT_BASE + layer_bytes, exp, NUM_TILES,
                     (chk_err > 0) ? " [ERR]" : " [OK]");
        end
        $display("│");

        // ═══════════════════════════════════════════════════════════════
        // Performance Counters
        // ═══════════════════════════════════════════════════════════════
        $display("│");
        $display("├─ Performance Counters");
        $display("│");
        axil_read(PERF_CYCLE_LOW, rd_val);
        $display("│  Cycles (low):  %0d", rd_val);
        axil_read(PERF_READ_BYTES, rd_val);
        $display("│  Read bytes:    %0d", rd_val);
        axil_read(PERF_WRITE_BYTES, rd_val);
        $display("│  Write bytes:   %0d", rd_val);
        axil_read(PERF_MAC_CYCLES, rd_val);
        $display("│  MAC cycles:    %0d", rd_val);
        axil_read(PERF_STALL_CYCLES, rd_val);
        $display("│  Stall cycles:  %0d", rd_val);
        $display("│");
        $display("│");
        $display("└─────────────────────────────────────────────────");
        if (err_count == 0) begin
            $display("");
            $display("╔═══════════════════════════════════════════╗");
            $display("║           ALL TESTS PASSED               ║");
            $display("╚═══════════════════════════════════════════╝");
        end else begin
            $display("");
            $display("╔═══════════════════════════════════════════╗");
            $display("║  %0d TEST(S) FAILED                      ║", err_count);
            $display("╚═══════════════════════════════════════════╝");
        end

        // Run simulation until 1000 us (1,000,000 ns) mark
        while ($time < 1000000000) #100;
        $finish;
    end

    // ── Waveform Dump ─────────────────────────────────────────────────
    initial begin
        $dumpfile("tb_gatev.vcd");
        $dumpvars(0, tb_gatev);
    end

    // ── Debug Monitor (state transitions) ──────────────────────────────
    logic [3:0] last_sched_state, last_mac_state;
    initial begin
        last_sched_state = 4'd0;
        last_mac_state = 4'd0;
        @(posedge rst_n);
        #200;
        forever @(posedge clk) begin
            if (tb_gatev.u_dut.u_sched.dbg_state !== last_sched_state) begin
                last_sched_state <= tb_gatev.u_dut.u_sched.dbg_state;
                $display("DEBUG@%0t: SCHED=%0d", $time, tb_gatev.u_dut.u_sched.dbg_state);
            end
            if (tb_gatev.u_dut.u_sched.u_mac.dbg_state !== last_mac_state) begin
                last_mac_state <= tb_gatev.u_dut.u_sched.u_mac.dbg_state;
                $display("DEBUG@%0t:   MAC=%0d", $time, tb_gatev.u_dut.u_sched.u_mac.dbg_state);
            end
        end
    end

endmodule
