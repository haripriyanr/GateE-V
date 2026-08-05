# ═════════════════════════════════════════════════════════════════════════════
# GatE-V FPGA Accelerator — Timing & Board Constraints
# Derived from C-DAC VEGA AS1061 Board Specification (Kintex-7 xc7k325t)
# DVCon India 2026 Design Contest — Team 166 (Byte Silicon)
# ═════════════════════════════════════════════════════════════════════════════

# ── 1. Primary Accelerator Clock Constraint (100 MHz) ────────────────────────
create_clock -period 10.000 -name aclk -waveform {0.000 5.000} [get_ports aclk]

# ── 2. Asynchronous Reset False Path ──────────────────────────────────────────
set_false_path -from [get_ports rst_n]

# ── 3. Kintex-7 Genesys-2 Board Voltage & Configuration Settings ─────────────
# Derived directly from AS1061_SYSTEM_XDC.xdc
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

# ── 4. Bitstream & QSPI Configuration Properties ──────────────────────────────
# Derived directly from AS1061_SYSTEM_XDC.xdc
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 9 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
