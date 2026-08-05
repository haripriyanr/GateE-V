# GatE-V 100 MHz clock constraint
create_clock -period 10.000 -name aclk [get_ports aclk]

# Configuration bank voltage select for Kintex-7 Genesys-2 board
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
