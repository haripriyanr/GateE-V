// GatE-V FPGA — Version 3 Package (800x800, P2-P5 FGPA, INT8 LUT, 32x16 Systolic Array)
// Central definitions: parameters, address map, interface structs, LUT constants.
// Import with: import gatev_pkg::*;

package gatev_pkg;

    // ── Bus Widths ─────────────────────────────────────────────────────────
    localparam int ADDR_WIDTH   = 32;    // AXI4-Lite (fixed 32-bit)
    localparam int AXI_ADDR_W   = 64;    // AXI4 Full address width
    localparam int AXI_ID_W     = 12;    // AXI4 Full ID width
    localparam int AXI_DATA_W   = 64;    // AXI4 Full data width

    // ── AXI-Lite Register Address Map ───────────────────────────────────────
    localparam logic [31:0] CTRL_REG_ADDR       = 32'h0000_0000;
    localparam logic [31:0] STATUS_REG_ADDR     = 32'h0000_0004;
    localparam logic [31:0] TASK_ID_REG_ADDR    = 32'h0000_0008;
    localparam logic [31:0] MODE_REG_ADDR       = 32'h0000_000C;
    localparam logic [31:0] IMG_BASE_ADDR_REG   = 32'h0000_0010;
    localparam logic [31:0] WT_BASE_ADDR_REG    = 32'h0000_0014;
    localparam logic [31:0] OUT_BASE_ADDR_REG   = 32'h0000_0018;
    localparam logic [31:0] TILES_NUM_REG_ADDR  = 32'h0000_001C;
    localparam logic [31:0] DMA_SRC_ADDR_REG    = 32'h0000_0020;
    localparam logic [31:0] DMA_DST_ADDR_REG    = 32'h0000_0024;
    localparam logic [31:0] DMA_LEN_REG         = 32'h0000_0028;
    localparam logic [31:0] DMA_CTRL_REG        = 32'h0000_002C;
    localparam logic [31:0] BURST_TYPE_REG      = 32'h0000_0030;
    localparam logic [31:0] BURST_LEN_REG       = 32'h0000_0034;
    localparam logic [31:0] PERF_CYCLE_LOW      = 32'h0000_0040;
    localparam logic [31:0] PERF_CYCLE_HIGH     = 32'h0000_0044;
    localparam logic [31:0] PERF_READ_BYTES     = 32'h0000_0048;
    localparam logic [31:0] PERF_WRITE_BYTES    = 32'h0000_004C;
    localparam logic [31:0] PERF_MAC_CYCLES     = 32'h0000_0050;
    localparam logic [31:0] PERF_STALL_CYCLES   = 32'h0000_0054;

    // ── Register Field Offsets ─────────────────────────────────────────────
    localparam int CTRL_START_BIT     = 0;
    localparam int STATUS_DONE_BIT    = 0;
    localparam int DMA_CTRL_START_BIT = 0;
    localparam int DMA_CTRL_DIR_BIT   = 1;

    // ── AXI Responses ──────────────────────────────────────────────────────
    localparam logic [1:0] AXI_RESP_OKAY   = 2'b00;
    localparam logic [1:0] AXI_RESP_SLVERR = 2'b10;
    localparam logic [1:0] AXI_RESP_DECERR = 2'b11;

    // ── MAC Engine ─────────────────────────────────────────────────────────
    localparam int MAC_ROWS    = 32;
    localparam int MAC_COLS    = 16;
    localparam int PIPE_STAGES = 3;

    // ── Backbone / Tile Scheduler ──────────────────────────────────────────
    localparam int MAX_IMG_WIDTH  = 800;
    localparam int MAX_IMG_HEIGHT = 800;
    localparam int LINE_BUF_DEPTH = 1024;
    localparam int MAX_CHANNELS   = 2048;
    localparam int MAC_TILE_OUT_CH = 8;
    localparam int MAC_TILE_IN_CH  = 8;

    // ── Layer Descriptor Type ──────────────────────────────────────────────
    typedef struct packed {
        logic       with_act;
        logic [2:0] kernel;   // kernel_size - 1 (0 = 1x1, 2 = 3x3)
        logic [15:0] in_ch;
        logic [15:0] out_ch;
        logic [15:0] in_w;
        logic [15:0] out_h;
        logic [15:0] out_w;
        logic [15:0] scale_m;
        logic [4:0]  shift_r;
    } layer_desc_t;

    // ── Streaming Interface Types ──────────────────────────────────────────
    typedef struct packed {
        logic [7:0]  data;
        logic        valid;
        logic        ready;
        logic [15:0] channel_id;
        logic [31:0] tile_id;
    } axis_int8_t;

    typedef struct packed {
        logic [31:0] data;
        logic        valid;
        logic        ready;
        logic [15:0] channel_id;
        logic [31:0] tile_id;
    } axis_int32_t;

    // ── SiLU Activation LUT (pre-computed for INT8 range [-128, 127]) ──────
    // silu(x) = x * sigmoid(x), quantized to INT8
    function automatic logic [7:0] silu_lut(input logic [7:0] addr);
        case (addr)
            8'd0:   return -8'sd34; 8'd1:   return -8'sd34;
            8'd2:   return -8'sd34; 8'd3:   return -8'sd34;
            8'd4:   return -8'sd34; 8'd5:   return -8'sd34;
            8'd6:   return -8'sd34; 8'd7:   return -8'sd34;
            8'd8:   return -8'sd34; 8'd9:   return -8'sd34;
            8'd10:  return -8'sd34; 8'd11:  return -8'sd33;
            8'd12:  return -8'sd33; 8'd13:  return -8'sd33;
            8'd14:  return -8'sd33; 8'd15:  return -8'sd33;
            8'd16:  return -8'sd33; 8'd17:  return -8'sd33;
            8'd18:  return -8'sd33; 8'd19:  return -8'sd33;
            8'd20:  return -8'sd32; 8'd21:  return -8'sd32;
            8'd22:  return -8'sd32; 8'd23:  return -8'sd32;
            8'd24:  return -8'sd32; 8'd25:  return -8'sd32;
            8'd26:  return -8'sd32; 8'd27:  return -8'sd32;
            8'd28:  return -8'sd31; 8'd29:  return -8'sd31;
            8'd30:  return -8'sd31; 8'd31:  return -8'sd31;
            8'd32:  return -8'sd31; 8'd33:  return -8'sd31;
            8'd34:  return -8'sd30; 8'd35:  return -8'sd30;
            8'd36:  return -8'sd30; 8'd37:  return -8'sd30;
            8'd38:  return -8'sd30; 8'd39:  return -8'sd30;
            8'd40:  return -8'sd29; 8'd41:  return -8'sd29;
            8'd42:  return -8'sd29; 8'd43:  return -8'sd29;
            8'd44:  return -8'sd29; 8'd45:  return -8'sd28;
            8'd46:  return -8'sd28; 8'd47:  return -8'sd28;
            8'd48:  return -8'sd28; 8'd49:  return -8'sd28;
            8'd50:  return -8'sd27; 8'd51:  return -8'sd27;
            8'd52:  return -8'sd27; 8'd53:  return -8'sd27;
            8'd54:  return -8'sd27; 8'd55:  return -8'sd26;
            8'd56:  return -8'sd26; 8'd57:  return -8'sd26;
            8'd58:  return -8'sd26; 8'd59:  return -8'sd25;
            8'd60:  return -8'sd25; 8'd61:  return -8'sd25;
            8'd62:  return -8'sd25; 8'd63:  return -8'sd24;
            8'd64:  return -8'sd24; 8'd65:  return -8'sd24;
            8'd66:  return -8'sd24; 8'd67:  return -8'sd23;
            8'd68:  return -8'sd23; 8'd69:  return -8'sd23;
            8'd70:  return -8'sd23; 8'd71:  return -8'sd22;
            8'd72:  return -8'sd22; 8'd73:  return -8'sd22;
            8'd74:  return -8'sd21; 8'd75:  return -8'sd21;
            8'd76:  return -8'sd21; 8'd77:  return -8'sd20;
            8'd78:  return -8'sd20; 8'd79:  return -8'sd20;
            8'd80:  return -8'sd20; 8'd81:  return -8'sd19;
            8'd82:  return -8'sd19; 8'd83:  return -8'sd19;
            8'd84:  return -8'sd18; 8'd85:  return -8'sd18;
            8'd86:  return -8'sd18; 8'd87:  return -8'sd17;
            8'd88:  return -8'sd17; 8'd89:  return -8'sd17;
            8'd90:  return -8'sd16; 8'd91:  return -8'sd16;
            8'd92:  return -8'sd15; 8'd93:  return -8'sd15;
            8'd94:  return -8'sd15; 8'd95:  return -8'sd14;
            8'd96:  return -8'sd14; 8'd97:  return -8'sd14;
            8'd98:  return -8'sd13; 8'd99:  return -8'sd13;
            8'd100: return -8'sd12; 8'd101: return -8'sd12;
            8'd102: return -8'sd12; 8'd103: return -8'sd11;
            8'd104: return -8'sd11; 8'd105: return -8'sd10;
            8'd106: return -8'sd10; 8'd107: return -8'sd10;
            8'd108: return -8'sd9;  8'd109: return -8'sd9;
            8'd110: return -8'sd8;  8'd111: return -8'sd8;
            8'd112: return -8'sd8;  8'd113: return -8'sd7;
            8'd114: return -8'sd7;  8'd115: return -8'sd6;
            8'd116: return -8'sd6;  8'd117: return -8'sd5;
            8'd118: return -8'sd5;  8'd119: return -8'sd4;
            8'd120: return -8'sd4;  8'd121: return -8'sd3;
            8'd122: return -8'sd3;  8'd123: return -8'sd2;
            8'd124: return -8'sd2;  8'd125: return -8'sd1;
            8'd126: return -8'sd1;  8'd127: return 8'sd0;
            8'd128: return 8'sd0;   8'd129: return 8'sd1;
            8'd130: return 8'sd1;   8'd131: return 8'sd2;
            8'd132: return 8'sd2;   8'd133: return 8'sd3;
            8'd134: return 8'sd3;   8'd135: return 8'sd4;
            8'd136: return 8'sd4;   8'd137: return 8'sd5;
            8'd138: return 8'sd5;   8'd139: return 8'sd6;
            8'd140: return 8'sd6;   8'd141: return 8'sd7;
            8'd142: return 8'sd7;   8'd143: return 8'sd8;
            8'd144: return 8'sd8;   8'd145: return 8'sd9;
            8'd146: return 8'sd10;  8'd147: return 8'sd10;
            8'd148: return 8'sd11;  8'd149: return 8'sd11;
            8'd150: return 8'sd12;  8'd151: return 8'sd13;
            8'd152: return 8'sd13;  8'd153: return 8'sd14;
            8'd154: return 8'sd14;  8'd155: return 8'sd15;
            8'd156: return 8'sd16;  8'd157: return 8'sd16;
            8'd158: return 8'sd17;  8'd159: return 8'sd17;
            8'd160: return 8'sd18;  8'd161: return 8'sd19;
            8'd162: return 8'sd19;  8'd163: return 8'sd20;
            8'd164: return 8'sd21;  8'd165: return 8'sd21;
            8'd166: return 8'sd22;  8'd167: return 8'sd22;
            8'd168: return 8'sd23;  8'd169: return 8'sd24;
            8'd170: return 8'sd24;  8'd171: return 8'sd25;
            8'd172: return 8'sd26;  8'd173: return 8'sd26;
            8'd174: return 8'sd27;  8'd175: return 8'sd28;
            8'd176: return 8'sd28;  8'd177: return 8'sd29;
            8'd178: return 8'sd30;  8'd179: return 8'sd31;
            8'd180: return 8'sd31;  8'd181: return 8'sd32;
            8'd182: return 8'sd33;  8'd183: return 8'sd33;
            8'd184: return 8'sd34;  8'd185: return 8'sd35;
            8'd186: return 8'sd35;  8'd187: return 8'sd36;
            8'd188: return 8'sd37;  8'd189: return 8'sd38;
            8'd190: return 8'sd38;  8'd191: return 8'sd39;
            8'd192: return 8'sd40;  8'd193: return 8'sd41;
            8'd194: return 8'sd41;  8'd195: return 8'sd42;
            8'd196: return 8'sd43;  8'd197: return 8'sd44;
            8'd198: return 8'sd44;  8'd199: return 8'sd45;
            8'd200: return 8'sd46;  8'd201: return 8'sd47;
            8'd202: return 8'sd47;  8'd203: return 8'sd48;
            8'd204: return 8'sd49;  8'd205: return 8'sd50;
            8'd206: return 8'sd51;  8'd207: return 8'sd51;
            8'd208: return 8'sd52;  8'd209: return 8'sd53;
            8'd210: return 8'sd54;  8'd211: return 8'sd55;
            8'd212: return 8'sd55;  8'd213: return 8'sd56;
            8'd214: return 8'sd57;  8'd215: return 8'sd58;
            8'd216: return 8'sd59;  8'd217: return 8'sd59;
            8'd218: return 8'sd60;  8'd219: return 8'sd61;
            8'd220: return 8'sd62;  8'd221: return 8'sd63;
            8'd222: return 8'sd64;  8'd223: return 8'sd64;
            8'd224: return 8'sd65;  8'd225: return 8'sd66;
            8'd226: return 8'sd67;  8'd227: return 8'sd68;
            8'd228: return 8'sd69;  8'd229: return 8'sd69;
            8'd230: return 8'sd70;  8'd231: return 8'sd71;
            8'd232: return 8'sd72;  8'd233: return 8'sd73;
            8'd234: return 8'sd74;  8'd235: return 8'sd75;
            8'd236: return 8'sd76;  8'd237: return 8'sd76;
            8'd238: return 8'sd77;  8'd239: return 8'sd78;
            8'd240: return 8'sd79;  8'd241: return 8'sd80;
            8'd242: return 8'sd81;  8'd243: return 8'sd82;
            8'd244: return 8'sd83;  8'd245: return 8'sd84;
            8'd246: return 8'sd84;  8'd247: return 8'sd85;
            8'd248: return 8'sd86;  8'd249: return 8'sd87;
            8'd250: return 8'sd88;  8'd251: return 8'sd89;
            8'd252: return 8'sd90;  8'd253: return 8'sd91;
            8'd254: return 8'sd92;  8'd255: return 8'sd93;
        endcase
    endfunction

endpackage
