create_clock -period 5.000 -name clk_in1_p [get_ports clk_in1_p]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets u_clk_wiz_0/inst/clk_out3]
#set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u3_SDCLKMUX/sync2_1_reg]
#set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets eth_rxck_IBUF]

set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets eth_rxck_IBUF]

set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 9 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## 200MHz clock from board
set_property -dict {PACKAGE_PIN AD11 IOSTANDARD LVDS} [get_ports clk_in1_n]
set_property -dict {PACKAGE_PIN AD12 IOSTANDARD LVDS} [get_ports clk_in1_p]

### boot mode select slide sw0
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS12} [get_ports boot]

#### reset push CPU resten
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports rst]

################################ uart pins #################################
####USB UART
set_property -dict {PACKAGE_PIN Y23 IOSTANDARD LVCMOS33} [get_ports sout0]
set_property -dict {PACKAGE_PIN Y20 IOSTANDARD LVCMOS33} [get_ports sin0]

####JC0
#set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS33} [get_ports sout1]
set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS33} [get_ports soft_rst]
####JC2
set_property -dict {PACKAGE_PIN AH30 IOSTANDARD LVCMOS33} [get_ports sin1]
####JC1
set_property -dict {PACKAGE_PIN AJ27 IOSTANDARD LVCMOS33} [get_ports sout2]
####JC3
set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS33} [get_ports sin2]


################################ LEDs ######################################
#### heart beat LED0
set_property -dict {PACKAGE_PIN T28 IOSTANDARD LVCMOS33} [get_ports proc_beat]

#### reset led1
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports rst_led]

#### calibration complete led2
set_property -dict {PACKAGE_PIN U30 IOSTANDARD LVCMOS33} [get_ports init_calib_complete]

#### locked led3
set_property -dict {PACKAGE_PIN U29 IOSTANDARD LVCMOS33} [get_ports locked_led]

#### LED4to7
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[0]}]
set_property -dict {PACKAGE_PIN V26 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[1]}]
set_property -dict {PACKAGE_PIN W24 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[2]}]
set_property -dict {PACKAGE_PIN W23 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[3]}]

################################ Buttons ######################################
set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[4]}]
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[5]}]
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[6]}]
set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[7]}]
set_property -dict {PACKAGE_PIN B19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[8]}]

################################ Switches #####################################
set_property -dict {PACKAGE_PIN G25 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[9]}]
set_property -dict {PACKAGE_PIN H24 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[10]}]
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[11]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[12]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS12} [get_ports {gpio_port0[13]}]
set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[14]}]
set_property -dict {PACKAGE_PIN P27 IOSTANDARD LVCMOS33} [get_ports {gpio_port0[15]}]

################################ VGA Connector ################################
set_property -dict {PACKAGE_PIN AH20 IOSTANDARD LVCMOS33} [get_ports {vga_b[0]}]
set_property -dict {PACKAGE_PIN AG20 IOSTANDARD LVCMOS33} [get_ports {vga_b[1]}]
set_property -dict {PACKAGE_PIN AF21 IOSTANDARD LVCMOS33} [get_ports {vga_b[2]}]
set_property -dict {PACKAGE_PIN AK20 IOSTANDARD LVCMOS33} [get_ports {vga_b[3]}]
set_property -dict {PACKAGE_PIN AG22 IOSTANDARD LVCMOS33} [get_ports {vga_b[4]}]

set_property -dict {PACKAGE_PIN AJ23 IOSTANDARD LVCMOS33} [get_ports {vga_g[0]}]
set_property -dict {PACKAGE_PIN AJ22 IOSTANDARD LVCMOS33} [get_ports {vga_g[1]}]
set_property -dict {PACKAGE_PIN AH22 IOSTANDARD LVCMOS33} [get_ports {vga_g[2]}]
set_property -dict {PACKAGE_PIN AK21 IOSTANDARD LVCMOS33} [get_ports {vga_g[3]}]
set_property -dict {PACKAGE_PIN AJ21 IOSTANDARD LVCMOS33} [get_ports {vga_g[4]}]
set_property -dict {PACKAGE_PIN AK23 IOSTANDARD LVCMOS33} [get_ports {vga_g[5]}]

set_property -dict {PACKAGE_PIN AK25 IOSTANDARD LVCMOS33} [get_ports {vga_r[0]}]
set_property -dict {PACKAGE_PIN AG25 IOSTANDARD LVCMOS33} [get_ports {vga_r[1]}]
set_property -dict {PACKAGE_PIN AH25 IOSTANDARD LVCMOS33} [get_ports {vga_r[2]}]
set_property -dict {PACKAGE_PIN AK24 IOSTANDARD LVCMOS33} [get_ports {vga_r[3]}]
set_property -dict {PACKAGE_PIN AJ24 IOSTANDARD LVCMOS33} [get_ports {vga_r[4]}]

set_property -dict {PACKAGE_PIN AF20 IOSTANDARD LVCMOS33} [get_ports vga_hs]
set_property -dict {PACKAGE_PIN AG23 IOSTANDARD LVCMOS33} [get_ports vga_vs]

########################## OLED Display #######################################
#oled_res
set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS18} [get_ports {gpio_port1[12]}]
#oled_dc
set_property -dict {PACKAGE_PIN AC17 IOSTANDARD LVCMOS18} [get_ports {gpio_port1[13]}]
#oled_vbat
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {gpio_port1[14]}]
#oled_vdd
set_property -dict {PACKAGE_PIN AG17 IOSTANDARD LVCMOS18} [get_ports {gpio_port1[15]}]
set_property -dict {PACKAGE_PIN AF17 IOSTANDARD LVCMOS18} [get_ports sclk3]
set_property -dict {PACKAGE_PIN Y15 IOSTANDARD LVCMOS18} [get_ports mosi3]

########################## Audio Codec ##########################
#set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports i2s_data_out]
#set_property -dict {PACKAGE_PIN AJ19 IOSTANDARD LVCMOS18} [get_ports i2s_data_in]
#set_property -dict {PACKAGE_PIN AD19 IOSTANDARD LVCMOS18} [get_ports {gpio_port1[8]}]
#set_property -dict {PACKAGE_PIN AG19 IOSTANDARD LVCMOS18} [get_ports {gpio_port1[9]}]
#set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS33} [get_ports sck_out]
#set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports ws_out]
#set_property -dict {PACKAGE_PIN AK19 IOSTANDARD LVCMOS18} [get_ports master_clock]

set_property -dict {PACKAGE_PIN AE19 IOSTANDARD LVCMOS18} [get_ports SCL_2]
set_property -dict {PACKAGE_PIN AF18 IOSTANDARD LVCMOS18} [get_ports SDA_2]
set_property PULLUP true [get_ports SDA_2]

########################## XADC #######################################
#set_property -dict { PACKAGE_PIN J24   IOSTANDARD LVCMOS33 } [get_ports { vauxn0 }]
#set_property -dict { PACKAGE_PIN J23   IOSTANDARD LVCMOS33 } [get_ports { vauxp0 }]
#set_property -dict { PACKAGE_PIN K24   IOSTANDARD LVCMOS33 } [get_ports { vauxn1 }]
#set_property -dict { PACKAGE_PIN K23   IOSTANDARD LVCMOS33 } [get_ports { vauxp1 }]
#set_property -dict { PACKAGE_PIN L23   IOSTANDARD LVCMOS33 } [get_ports { vauxn2 }]
#set_property -dict { PACKAGE_PIN L22   IOSTANDARD LVCMOS33 } [get_ports { vauxp2 }]
#set_property -dict { PACKAGE_PIN K21   IOSTANDARD LVCMOS33 } [get_ports { vauxn3 }]
#set_property -dict { PACKAGE_PIN L21   IOSTANDARD LVCMOS33 } [get_ports { vauxp3 }]

########################## SPI #######################################
#JA0to7
set_property -dict {PACKAGE_PIN U27 IOSTANDARD LVCMOS33} [get_ports mosi0]
set_property -dict {PACKAGE_PIN U28 IOSTANDARD LVCMOS33} [get_ports miso0]
set_property -dict {PACKAGE_PIN T26 IOSTANDARD LVCMOS33} [get_ports sclk0]
set_property -dict {PACKAGE_PIN T27 IOSTANDARD LVCMOS33} [get_ports cs_n0]

set_property -dict {PACKAGE_PIN T22 IOSTANDARD LVCMOS33} [get_ports mosi1]
set_property -dict {PACKAGE_PIN T23 IOSTANDARD LVCMOS33} [get_ports miso1]
set_property -dict {PACKAGE_PIN T20 IOSTANDARD LVCMOS33} [get_ports sclk1]
set_property -dict {PACKAGE_PIN T21 IOSTANDARD LVCMOS33} [get_ports cs_n1]
#JB0to3
#set_property -dict {PACKAGE_PIN R29 IOSTANDARD LVCMOS33} [get_ports mosi2]
#set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33} [get_ports miso2]
#set_property -dict {PACKAGE_PIN R28 IOSTANDARD LVCMOS33} [get_ports sclk2]
#set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports cs_n2]
#set_property -dict {PACKAGE_PIN AE24 IOSTANDARD LVCMOS33} [get_ports sd_reset]
########################## IIC #######################################
#JB4to7
set_property -dict {PACKAGE_PIN T25 IOSTANDARD LVCMOS33} [get_ports SDA]
set_property PULLUP true [get_ports SDA]
set_property -dict {PACKAGE_PIN U25 IOSTANDARD LVCMOS33} [get_ports SCL]
set_property -dict {PACKAGE_PIN U22 IOSTANDARD LVCMOS33} [get_ports SDA_1]
set_property PULLUP true [get_ports SDA_1]
set_property -dict {PACKAGE_PIN U23 IOSTANDARD LVCMOS33} [get_ports SCL_1]

########################## PWM #######################################
#JC0to7
#set_property -dict {PACKAGE_PIN AC26 IOSTANDARD LVCMOS33} [get_ports {PWM[0]}]
#set_property -dict {PACKAGE_PIN AJ27 IOSTANDARD LVCMOS33} [get_ports {PWM[1]}]

#set_property -dict {PACKAGE_PIN AH30 IOSTANDARD LVCMOS33} [get_ports {PWM[2]}]
#set_property -dict {PACKAGE_PIN AK29 IOSTANDARD LVCMOS33} [get_ports {PWM[3]}]
set_property -dict {PACKAGE_PIN AD26 IOSTANDARD LVCMOS33} [get_ports {PWM[0]}]
set_property -dict {PACKAGE_PIN AG30 IOSTANDARD LVCMOS33} [get_ports {PWM[1]}]
set_property -dict {PACKAGE_PIN AK30 IOSTANDARD LVCMOS33} [get_ports {PWM[2]}]
set_property -dict {PACKAGE_PIN AK28 IOSTANDARD LVCMOS33} [get_ports {PWM[3]}]

########################## JTAG #######################################
#JD0to7
set_property -dict {PACKAGE_PIN V27 IOSTANDARD LVCMOS33} [get_ports TRST]
set_property -dict {PACKAGE_PIN Y30 IOSTANDARD LVCMOS33} [get_ports TCK]
set_property -dict {PACKAGE_PIN V24 IOSTANDARD LVCMOS33} [get_ports TDI]
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports TMS]
set_property -dict {PACKAGE_PIN U24 IOSTANDARD LVCMOS33} [get_ports TDO]
#set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS33} [get_ports {gpio_port1[5]}]
#set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {gpio_port1[6]}]
#set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports {gpio_port1[7]}]
#5to7
set_property -dict {PACKAGE_PIN Y26 IOSTANDARD LVCMOS33} [get_ports sck_out]
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports ws_out]
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports i2s_data_out]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets TCK_IBUF]
########################### USB ###################################
create_clock -period 16.666 -name ulpi_clk60_i [get_ports ulpi_clk60_i]

set_property -dict {PACKAGE_PIN AD18 IOSTANDARD LVCMOS18} [get_ports ulpi_clk60_i]
set_property -dict {PACKAGE_PIN AE14 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[0]}]
set_property -dict {PACKAGE_PIN AE15 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[1]}]
set_property -dict {PACKAGE_PIN AC15 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[2]}]
set_property -dict {PACKAGE_PIN AC16 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[3]}]
set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[4]}]
set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[5]}]
set_property -dict {PACKAGE_PIN AD14 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[6]}]
set_property -dict {PACKAGE_PIN AC14 IOSTANDARD LVCMOS18} [get_ports {ulpi_data[7]}]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS18} [get_ports ulpi_dir_i]
set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS18} [get_ports ulpi_nxt_i]
set_property -dict {PACKAGE_PIN AB14 IOSTANDARD LVCMOS18} [get_ports ulpi_rst_o]
set_property -dict {PACKAGE_PIN AA17 IOSTANDARD LVCMOS18} [get_ports ulpi_stp_o]
set_property -dict {PACKAGE_PIN AF16 IOSTANDARD LVCMOS18} [get_ports usb_ov_ct_det]

#Input delay : Derived from the PHY maximum output delay : Max 9ns
# Propagation time (ltrace length = 15 cm)
#Output delay min : Must assure PHY input hold time: Output delay min > PHY input hold time (1.5ns) - 2 * propagation delay
#Output delay max : Must assure PHY setup time : Output delay max < Period (16.6ns) - PHY Setup Requirement (6ns) - 2 * propagation delay

#create_clock -period 16.666 -name ulpi_clk -waveform {0.000 8.333} [get_ports ulpi_clk]
set_input_delay -clock [get_clocks ulpi_clk60_i] -min -add_delay 1.200 [get_ports {ulpi_data[*]}]
set_input_delay -clock [get_clocks ulpi_clk60_i] -max -add_delay 9.000 [get_ports {ulpi_data[*]}]
set_input_delay -clock [get_clocks ulpi_clk60_i] -min -add_delay 1.200 [get_ports ulpi_dir_i]
set_input_delay -clock [get_clocks ulpi_clk60_i] -max -add_delay 9.000 [get_ports ulpi_dir_i]
set_input_delay -clock [get_clocks ulpi_clk60_i] -min -add_delay 1.200 [get_ports ulpi_nxt_i]
set_input_delay -clock [get_clocks ulpi_clk60_i] -max -add_delay 9.000 [get_ports ulpi_nxt_i]
set_output_delay -clock [get_clocks ulpi_clk60_i] -min -add_delay 1.000 [get_ports {ulpi_data[*]}]
set_output_delay -clock [get_clocks ulpi_clk60_i] -max -add_delay 8.600 [get_ports {ulpi_data[*]}]
set_output_delay -clock [get_clocks ulpi_clk60_i] -min -add_delay 1.000 [get_ports ulpi_stp_o]
set_output_delay -clock [get_clocks ulpi_clk60_i] -max -add_delay 8.600 [get_ports ulpi_stp_o]

########################### ethernet gmac ###################################
create_clock -period 8.000 -name eth_rxck [get_ports eth_rxck]
create_generated_clock -name output_clock -source [get_pins ODDR_inst/C] -divide_by 1 [get_ports eth_txck]

set_property PACKAGE_PIN AK16 [get_ports eth_int_b]
set_property IOSTANDARD LVCMOS18 [get_ports eth_int_b]
set_property PULLUP true [get_ports eth_int_b]
set_property -dict {PACKAGE_PIN AF12 IOSTANDARD LVCMOS15} [get_ports eth_mdc]
set_property -dict {PACKAGE_PIN AG12 IOSTANDARD LVCMOS15} [get_ports eth_mdio]
set_property -dict {PACKAGE_PIN AH24 IOSTANDARD LVCMOS33} [get_ports eth_phyrst_n]
#set_property PACKAGE_PIN AK15 [get_ports eth_pme_b]
#set_property IOSTANDARD LVCMOS18 [get_ports eth_pme_b]
#set_property PULLUP true [get_ports eth_pme_b]
set_property -dict {PACKAGE_PIN AG10 IOSTANDARD LVCMOS15} [get_ports eth_rxck]
set_property -dict {PACKAGE_PIN AH11 IOSTANDARD LVCMOS15} [get_ports eth_rxctl]
set_property -dict {PACKAGE_PIN AJ14 IOSTANDARD LVCMOS15} [get_ports {eth_rxd[0]}]
set_property -dict {PACKAGE_PIN AH14 IOSTANDARD LVCMOS15} [get_ports {eth_rxd[1]}]
set_property -dict {PACKAGE_PIN AK13 IOSTANDARD LVCMOS15} [get_ports {eth_rxd[2]}]
set_property -dict {PACKAGE_PIN AJ13 IOSTANDARD LVCMOS15} [get_ports {eth_rxd[3]}]
set_property -dict {PACKAGE_PIN AE10 IOSTANDARD LVCMOS15} [get_ports eth_txck]
set_property -dict {PACKAGE_PIN AJ12 IOSTANDARD LVCMOS15} [get_ports {eth_txd[0]}]
set_property -dict {PACKAGE_PIN AK11 IOSTANDARD LVCMOS15} [get_ports {eth_txd[1]}]
set_property -dict {PACKAGE_PIN AJ11 IOSTANDARD LVCMOS15} [get_ports {eth_txd[2]}]
set_property -dict {PACKAGE_PIN AK10 IOSTANDARD LVCMOS15} [get_ports {eth_txd[3]}]
set_property -dict {PACKAGE_PIN AK14 IOSTANDARD LVCMOS15} [get_ports eth_tx_en]

set_output_delay -clock output_clock -max 1.200 [get_ports {{eth_txd[*]} eth_tx_en}]
set_output_delay -clock output_clock -min -1.200 [get_ports {{eth_txd[*]} eth_tx_en}]
set_output_delay -clock output_clock -clock_fall -max -add_delay 1.200 [get_ports {{eth_txd[*]} eth_tx_en}]
set_output_delay -clock output_clock -clock_fall -min -add_delay -1.200 [get_ports {{eth_txd[*]} eth_tx_en}]

set_input_delay -clock eth_rxck -max 1.000 [get_ports {{eth_rxd[*]} eth_rxctl}]
set_input_delay -clock eth_rxck -min -1.000 [get_ports {{eth_rxd[*]} eth_rxctl}]
set_input_delay -clock eth_rxck -clock_fall -max -add_delay 1.000 [get_ports {{eth_rxd[*]} eth_rxctl}]
set_input_delay -clock eth_rxck -clock_fall -min -add_delay -1.000 [get_ports {{eth_rxd[*]} eth_rxctl}]

## for receiver part use virtual clock
## Reason the data in is already setup hold met since clock change happens
## in middle , so no need to constraint
## do constraint wr to virtual clock for max and min constraint only

#create_clock -name eth_vir_clock -period 8.000

#set_input_delay -clock eth_vir_clock -max -add_delay 0.200 [get_ports {eth_rxd[*]}]
#set_input_delay -clock eth_vir_clock -min -add_delay 0.000 [get_ports {eth_rxd[*]}]
#set_input_delay -clock eth_vir_clock -clock_fall -max -add_delay 0.200 [get_ports {eth_rxd[*]}]
#set_input_delay -clock eth_vir_clock -clock_fall -min -add_delay 0.000 [get_ports {eth_rxd[*]}]

#set_input_delay -clock eth_vir_clock -max -add_delay 0.200 [get_ports eth_rxctl]
#set_input_delay -clock eth_vir_clock -min -add_delay 0.000 [get_ports eth_rxctl]
#set_input_delay -clock eth_vir_clock -clock_fall -max -add_delay 0.200 [get_ports eth_rxctl]
#set_input_delay -clock eth_vir_clock -clock_fall -min -add_delay 0.000 [get_ports eth_rxctl]


#set_false_path -setup -rise_from [get_clocks {eth_vir_clock}] -fall_to [get_clocks {input_clock}]
#set_false_path -setup -fall_from [get_clocks {eth_vir_clock}] -rise_to [get_clocks {input_clock}]
#set_false_path -hold  -rise_from [get_clocks {eth_vir_clock}]  -rise_to [get_clocks {input_clock}]
#set_false_path -hold  -fall_from [get_clocks {eth_vir_clock}]  -fall_to [get_clocks {input_clock}]

#set_false_path -from [get_clocks {clk_in1_p}] -to [get_clocks {eth_vir_clock}]
#set_false_path -from [get_clocks {eth_vir_clock}] -to [get_clocks {clk_in1_p}]

############################# SD CARD##########################
set_property -dict {PACKAGE_PIN P28 IOSTANDARD LVCMOS33} [get_ports sd_cd]
set_property -dict {PACKAGE_PIN R29 IOSTANDARD LVCMOS33} [get_ports sd_cmd]
set_property -dict {PACKAGE_PIN R26 IOSTANDARD LVCMOS33} [get_ports {sd_data[0]}]
set_property -dict {PACKAGE_PIN R30 IOSTANDARD LVCMOS33} [get_ports {sd_data[1]}]
set_property -dict {PACKAGE_PIN P29 IOSTANDARD LVCMOS33} [get_ports {sd_data[2]}]
set_property -dict {PACKAGE_PIN T30 IOSTANDARD LVCMOS33} [get_ports {sd_data[3]}]
set_property -dict {PACKAGE_PIN R28 IOSTANDARD LVCMOS33} [get_ports clk_sd_out]

set_property -dict {PACKAGE_PIN AE24 IOSTANDARD LVCMOS33} [get_ports sd_reset]

#create_clock -period 20.000 -name clk_cmd -waveform {0.000 10.000}  u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/clk_cmd
#create_generated_clock -name clk_cmd -source [get_ports clk_in1_p] -divide_by 8 [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/clk_cmd]

#set_input_delay -clock [get_clocks clk_out3_clk_wiz_0] -max 10.000 [get_ports -filter { NAME =~  "*sd_data*" }]
#set_input_delay -clock [get_clocks clk_out3_clk_wiz_0] -min 10.000 [get_ports -filter { NAME =~  "*sd_data*"  }]
#set_input_delay -clock [get_clocks clk_out3_clk_wiz_0] -max 10.000 [get_ports -filter { NAME =~  "*sd_cmd*" }]
#set_input_delay -clock [get_clocks clk_out3_clk_wiz_0] -min 10.000 [get_ports -filter { NAME =~  "*sd_cmd*"  }]

#set_output_delay -clock [get_clocks clk_out3_clk_wiz_0] -max 10.000 [get_ports -filter { NAME =~  "*sd_data*" }]
#set_output_delay -clock [get_clocks clk_out3_clk_wiz_0] -min 10.000 [get_ports -filter { NAME =~  "*sd_data*"  }]
#set_output_delay -clock [get_clocks clk_out3_clk_wiz_0] -max 10.000 [get_ports -filter { NAME =~  "*sd_cmd*" }]
#set_output_delay -clock [get_clocks clk_out3_clk_wiz_0] -min 10.000 [get_ports -filter { NAME =~  "*sd_cmd*"  }]

create_clock -period 40.000 -name clk25CLKWIZ [get_pins u_clk_wiz_0/clk_out3]
create_clock -period 20.000 -name clk50CLKWIZ [get_pins u_clk_wiz_0/clk_out6]
create_generated_clock -name clk390I -source [get_pins u_clk_wiz_0/clk_out3] -divide_by 64 -add -master_clock clk25CLKWIZ [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/clk_400_reg/Q]
create_generated_clock -name clk390K -source [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/clk_400_reg/Q] -divide_by 1 [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u0_SDCLKMUX/CLK]
create_generated_clock -name clk25M -source [get_pins u_clk_wiz_0/clk_out3] -divide_by 1 -add -master_clock clk25CLKWIZ [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u1_SDCLKMUX/clk_25_u1]
create_generated_clock -name clk50M -source [get_pins u_clk_wiz_0/clk_out6] -divide_by 1 -add -master_clock clk50CLKWIZ [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u2_SDCLKMUX/clk_50_u2]
#U3 OUT
#U4 OUT
#create_generated_clock -name clk_sd_out -source [get_pins u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u5_SDCLKMUX/I0] -divide_by 1 [get_ports clk_sd_out]

set_clock_groups -physically_exclusive -group {clk390I clk390K clk390KU3 clk390KU4 clk_sd_out_390K} -group {clk25M clk_sd_out_25M clk25MU3 clk25MU4} -group {clk50M clk50MU4 clk_sd_out_50M}
set_clock_groups -asynchronous -group {clk50M clk_sd_out_50M} -group clk_out1_clk_wiz_0


#############################################Timing constraints
#set_clock_groups -asynchronous -group [get_clocks eth_rxck -include_generated_clocks] #-group [get_clocks -of_objects [get_nets u_clk_wiz_0/clk_out1]] #-group [get_clocks ulpi_clk60_i -include_generated_clocks] #-group [get_clocks clk_cmd -include_generated_clocks]

#set_false_path -from [get_clocks clk_cmd] -to [get_clocks clk_out1_clk_wiz_0]
#set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_cmd]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks ulpi_clk60_i]
set_false_path -from [get_clocks ulpi_clk60_i] -to [get_clocks clk_out1_clk_wiz_0]

set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_out4_clk_wiz_0]
set_false_path -from [get_clocks clk_out4_clk_wiz_0] -to [get_clocks clk_pll_i]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_out1_clk_wiz_eth]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_out1_clk_wiz_eth]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_out2_clk_wiz_eth]
set_false_path -from [get_clocks clk_out1_clk_wiz_eth] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out2_clk_wiz_eth] -to [get_clocks clk_out1_clk_wiz_0]

set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_out3_clk_wiz_0]
set_false_path -from [get_clocks clk_out3_clk_wiz_0] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out2_clk_wiz_eth] -to [get_clocks output_clock]

#set_clock_uncertainty -setup 1.000 [get_clocks clk_out1_clk_wiz_0]
#set_clock_uncertainty -hold 0.250 [get_clocks clk_out1_clk_wiz_0]
#set_clock_uncertainty -hold 0.250 [get_clocks eth_rxck -include_generated_clocks]

set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_pll_i]
set_false_path -from [get_clocks clk_out2_clk_wiz_0] -to [get_clocks clk_pll_i]
set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_out2_clk_wiz_0]
set_false_path -from [get_clocks clk_pll_i] -to [get_clocks clk_out1_clk_wiz_0]
set_false_path -from [get_clocks clk_out1_clk_wiz_0] -to [get_clocks clk_pll_i]
set_false_path -from u_soc_top/u_tft_controller/bram_controller_tft_map/U0/gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/ADDR_SNG_PORT.bram_addr_int_reg[*]/C


######################## DDR3 #######################################

# PadFunction: IO_L1N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[0]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[0]}]
set_property PACKAGE_PIN AD3 [get_ports {ddr3_dq[0]}]

# PadFunction: IO_L2P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[1]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[1]}]
set_property PACKAGE_PIN AC2 [get_ports {ddr3_dq[1]}]

# PadFunction: IO_L2N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[2]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[2]}]
set_property PACKAGE_PIN AC1 [get_ports {ddr3_dq[2]}]

# PadFunction: IO_L4P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[3]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[3]}]
set_property PACKAGE_PIN AC5 [get_ports {ddr3_dq[3]}]

# PadFunction: IO_L4N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[4]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[4]}]
set_property PACKAGE_PIN AC4 [get_ports {ddr3_dq[4]}]

# PadFunction: IO_L5P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[5]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[5]}]
set_property PACKAGE_PIN AD6 [get_ports {ddr3_dq[5]}]

# PadFunction: IO_L5N_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[6]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[6]}]
set_property PACKAGE_PIN AE6 [get_ports {ddr3_dq[6]}]

# PadFunction: IO_L6P_T0_34
set_property SLEW FAST [get_ports {ddr3_dq[7]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[7]}]
set_property PACKAGE_PIN AC7 [get_ports {ddr3_dq[7]}]

# PadFunction: IO_L7N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[8]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[8]}]
set_property PACKAGE_PIN AF2 [get_ports {ddr3_dq[8]}]

# PadFunction: IO_L8P_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[9]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[9]}]
set_property PACKAGE_PIN AE1 [get_ports {ddr3_dq[9]}]

# PadFunction: IO_L8N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[10]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[10]}]
set_property PACKAGE_PIN AF1 [get_ports {ddr3_dq[10]}]

# PadFunction: IO_L10P_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[11]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[11]}]
set_property PACKAGE_PIN AE4 [get_ports {ddr3_dq[11]}]

# PadFunction: IO_L10N_T1_34
set_property SLEW FAST [get_ports {ddr3_dq[12]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[12]}]
set_property PACKAGE_PIN AE3 [get_ports {ddr3_dq[12]}]

# PadFunction: IO_L11P_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[13]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[13]}]
set_property PACKAGE_PIN AE5 [get_ports {ddr3_dq[13]}]

# PadFunction: IO_L11N_T1_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[14]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[14]}]
set_property PACKAGE_PIN AF5 [get_ports {ddr3_dq[14]}]

# PadFunction: IO_L12P_T1_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[15]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[15]}]
set_property PACKAGE_PIN AF6 [get_ports {ddr3_dq[15]}]

# PadFunction: IO_L13N_T2_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[16]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[16]}]
set_property PACKAGE_PIN AJ4 [get_ports {ddr3_dq[16]}]

# PadFunction: IO_L14P_T2_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[17]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[17]}]
set_property PACKAGE_PIN AH6 [get_ports {ddr3_dq[17]}]

# PadFunction: IO_L14N_T2_SRCC_34
set_property SLEW FAST [get_ports {ddr3_dq[18]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[18]}]
set_property PACKAGE_PIN AH5 [get_ports {ddr3_dq[18]}]

# PadFunction: IO_L16P_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[19]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[19]}]
set_property PACKAGE_PIN AH2 [get_ports {ddr3_dq[19]}]

# PadFunction: IO_L16N_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[20]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[20]}]
set_property PACKAGE_PIN AJ2 [get_ports {ddr3_dq[20]}]

# PadFunction: IO_L17P_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[21]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[21]}]
set_property PACKAGE_PIN AJ1 [get_ports {ddr3_dq[21]}]

# PadFunction: IO_L17N_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[22]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[22]}]
set_property PACKAGE_PIN AK1 [get_ports {ddr3_dq[22]}]

# PadFunction: IO_L18P_T2_34
set_property SLEW FAST [get_ports {ddr3_dq[23]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[23]}]
set_property PACKAGE_PIN AJ3 [get_ports {ddr3_dq[23]}]

# PadFunction: IO_L20P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[24]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[24]}]
set_property PACKAGE_PIN AF7 [get_ports {ddr3_dq[24]}]

# PadFunction: IO_L20N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[25]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[25]}]
set_property PACKAGE_PIN AG7 [get_ports {ddr3_dq[25]}]

# PadFunction: IO_L22P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[26]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[26]}]
set_property PACKAGE_PIN AJ6 [get_ports {ddr3_dq[26]}]

# PadFunction: IO_L22N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[27]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[27]}]
set_property PACKAGE_PIN AK6 [get_ports {ddr3_dq[27]}]

# PadFunction: IO_L23P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[28]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[28]}]
set_property PACKAGE_PIN AJ8 [get_ports {ddr3_dq[28]}]

# PadFunction: IO_L23N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[29]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[29]}]
set_property PACKAGE_PIN AK8 [get_ports {ddr3_dq[29]}]

# PadFunction: IO_L24P_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[30]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[30]}]
set_property PACKAGE_PIN AK5 [get_ports {ddr3_dq[30]}]

# PadFunction: IO_L24N_T3_34
set_property SLEW FAST [get_ports {ddr3_dq[31]}]
set_property IOSTANDARD SSTL15_T_DCI [get_ports {ddr3_dq[31]}]
set_property PACKAGE_PIN AK4 [get_ports {ddr3_dq[31]}]

# PadFunction: IO_L16N_T2_33
set_property SLEW FAST [get_ports {ddr3_addr[14]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[14]}]
set_property PACKAGE_PIN AH9 [get_ports {ddr3_addr[14]}]

# PadFunction: IO_L1P_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[13]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[13]}]
set_property PACKAGE_PIN AA12 [get_ports {ddr3_addr[13]}]

# PadFunction: IO_L1N_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[12]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[12]}]
set_property PACKAGE_PIN AB12 [get_ports {ddr3_addr[12]}]

# PadFunction: IO_L2P_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[11]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[11]}]
set_property PACKAGE_PIN AA8 [get_ports {ddr3_addr[11]}]

# PadFunction: IO_L2N_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[10]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[10]}]
set_property PACKAGE_PIN AB8 [get_ports {ddr3_addr[10]}]

# PadFunction: IO_L4P_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[9]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[9]}]
set_property PACKAGE_PIN Y11 [get_ports {ddr3_addr[9]}]

# PadFunction: IO_L4N_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[8]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[8]}]
set_property PACKAGE_PIN Y10 [get_ports {ddr3_addr[8]}]

# PadFunction: IO_L5P_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[7]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[7]}]
set_property PACKAGE_PIN AA11 [get_ports {ddr3_addr[7]}]

# PadFunction: IO_L5N_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[6]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[6]}]
set_property PACKAGE_PIN AA10 [get_ports {ddr3_addr[6]}]

# PadFunction: IO_L6P_T0_33
set_property SLEW FAST [get_ports {ddr3_addr[5]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[5]}]
set_property PACKAGE_PIN AA13 [get_ports {ddr3_addr[5]}]

# PadFunction: IO_L10P_T1_33
set_property SLEW FAST [get_ports {ddr3_addr[4]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[4]}]
set_property PACKAGE_PIN AD9 [get_ports {ddr3_addr[4]}]

# PadFunction: IO_L7N_T1_33
set_property SLEW FAST [get_ports {ddr3_addr[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[3]}]
set_property PACKAGE_PIN AC10 [get_ports {ddr3_addr[3]}]

# PadFunction: IO_L8P_T1_33
set_property SLEW FAST [get_ports {ddr3_addr[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[2]}]
set_property PACKAGE_PIN AD8 [get_ports {ddr3_addr[2]}]

# PadFunction: IO_L8N_T1_33
set_property SLEW FAST [get_ports {ddr3_addr[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[1]}]
set_property PACKAGE_PIN AE8 [get_ports {ddr3_addr[1]}]

# PadFunction: IO_L9P_T1_DQS_33
set_property SLEW FAST [get_ports {ddr3_addr[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_addr[0]}]
set_property PACKAGE_PIN AC12 [get_ports {ddr3_addr[0]}]

# PadFunction: IO_L9N_T1_DQS_33
set_property SLEW FAST [get_ports {ddr3_ba[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[2]}]
set_property PACKAGE_PIN AC11 [get_ports {ddr3_ba[2]}]

# PadFunction: IO_L7P_T1_33
set_property SLEW FAST [get_ports {ddr3_ba[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[1]}]
set_property PACKAGE_PIN AB10 [get_ports {ddr3_ba[1]}]

# PadFunction: IO_L10N_T1_33
set_property SLEW FAST [get_ports {ddr3_ba[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_ba[0]}]
set_property PACKAGE_PIN AE9 [get_ports {ddr3_ba[0]}]

# PadFunction: IO_L11P_T1_SRCC_33
set_property SLEW FAST [get_ports ddr3_ras_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_ras_n]
set_property PACKAGE_PIN AE11 [get_ports ddr3_ras_n]

# PadFunction: IO_L11N_T1_SRCC_33
set_property SLEW FAST [get_ports ddr3_cas_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_cas_n]
set_property PACKAGE_PIN AF11 [get_ports ddr3_cas_n]

# PadFunction: IO_L24P_T3_33
set_property SLEW FAST [get_ports ddr3_we_n]
set_property IOSTANDARD SSTL15 [get_ports ddr3_we_n]
set_property PACKAGE_PIN AG13 [get_ports ddr3_we_n]

# PadFunction: IO_L12N_T1_MRCC_34
set_property SLEW FAST [get_ports ddr3_reset_n]
set_property IOSTANDARD LVCMOS15 [get_ports ddr3_reset_n]
set_property PACKAGE_PIN AG5 [get_ports ddr3_reset_n]

# PadFunction: IO_L15P_T2_DQS_33
set_property SLEW FAST [get_ports {ddr3_cke[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cke[0]}]
set_property PACKAGE_PIN AJ9 [get_ports {ddr3_cke[0]}]

# PadFunction: IO_L15N_T2_DQS_33
set_property SLEW FAST [get_ports {ddr3_odt[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_odt[0]}]
set_property PACKAGE_PIN AK9 [get_ports {ddr3_odt[0]}]

# PadFunction: IO_L24N_T3_33
set_property SLEW FAST [get_ports {ddr3_cs_n[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_cs_n[0]}]
set_property PACKAGE_PIN AH12 [get_ports {ddr3_cs_n[0]}]

# PadFunction: IO_L1P_T0_34
set_property SLEW FAST [get_ports {ddr3_dm[0]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[0]}]
set_property PACKAGE_PIN AD4 [get_ports {ddr3_dm[0]}]

# PadFunction: IO_L7P_T1_34
set_property SLEW FAST [get_ports {ddr3_dm[1]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[1]}]
set_property PACKAGE_PIN AF3 [get_ports {ddr3_dm[1]}]

# PadFunction: IO_L13P_T2_MRCC_34
set_property SLEW FAST [get_ports {ddr3_dm[2]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[2]}]
set_property PACKAGE_PIN AH4 [get_ports {ddr3_dm[2]}]

# PadFunction: IO_L19P_T3_34
set_property SLEW FAST [get_ports {ddr3_dm[3]}]
set_property IOSTANDARD SSTL15 [get_ports {ddr3_dm[3]}]
set_property PACKAGE_PIN AF8 [get_ports {ddr3_dm[3]}]

# PadFunction: IO_L3P_T0_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[0]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[0]}]

# PadFunction: IO_L3N_T0_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[0]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[0]}]
set_property PACKAGE_PIN AD2 [get_ports {ddr3_dqs_p[0]}]
set_property PACKAGE_PIN AD1 [get_ports {ddr3_dqs_n[0]}]

# PadFunction: IO_L9P_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[1]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[1]}]

# PadFunction: IO_L9N_T1_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[1]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[1]}]
set_property PACKAGE_PIN AG4 [get_ports {ddr3_dqs_p[1]}]
set_property PACKAGE_PIN AG3 [get_ports {ddr3_dqs_n[1]}]

# PadFunction: IO_L15P_T2_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[2]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[2]}]

# PadFunction: IO_L15N_T2_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[2]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[2]}]
set_property PACKAGE_PIN AG2 [get_ports {ddr3_dqs_p[2]}]
set_property PACKAGE_PIN AH1 [get_ports {ddr3_dqs_n[2]}]

# PadFunction: IO_L21P_T3_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_p[3]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_p[3]}]

# PadFunction: IO_L21N_T3_DQS_34
set_property SLEW FAST [get_ports {ddr3_dqs_n[3]}]
set_property IOSTANDARD DIFF_SSTL15_T_DCI [get_ports {ddr3_dqs_n[3]}]
set_property PACKAGE_PIN AH7 [get_ports {ddr3_dqs_p[3]}]
set_property PACKAGE_PIN AJ7 [get_ports {ddr3_dqs_n[3]}]

# PadFunction: IO_L3P_T0_DQS_33
set_property SLEW FAST [get_ports {ddr3_ck_p[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_p[0]}]

# PadFunction: IO_L3N_T0_DQS_33
set_property SLEW FAST [get_ports {ddr3_ck_n[0]}]
set_property IOSTANDARD DIFF_SSTL15 [get_ports {ddr3_ck_n[0]}]
set_property PACKAGE_PIN AB9 [get_ports {ddr3_ck_p[0]}]
set_property PACKAGE_PIN AC9 [get_ports {ddr3_ck_n[0]}]

set_property LOC PHASER_OUT_PHY_X1Y7 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y6 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y5 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y4 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_1.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_out}]
set_property LOC PHASER_OUT_PHY_X1Y8 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_A.ddr_byte_lane_A/phaser_out}]

set_property LOC PHASER_IN_PHY_X1Y11 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_D.ddr_byte_lane_D/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y10 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_C.ddr_byte_lane_C/phaser_in_gen.phaser_in}]
set_property LOC PHASER_IN_PHY_X1Y9 [get_cells -hier -filter {NAME =~ */ddr_phy_4lanes_0.u_ddr_phy_4lanes/ddr_byte_lane_B.ddr_byte_lane_B/phaser_in_gen.phaser_in}]


set_multicycle_path -setup -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] -to [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] 6

set_multicycle_path -hold -from [get_cells -hier -filter {NAME =~ */mc0/mc_read_idle_r_reg}] -to [get_cells -hier -filter {NAME =~ */input_[?].iserdes_dq_.iserdesdq}] 5

set_false_path -through [get_pins -filter {NAME =~ */DQSFOUND} -of [get_cells -hier -filter {REF_NAME == PHASER_IN_PHY}]]

set_multicycle_path -setup -start -through [get_pins -filter {NAME =~ */OSERDESRST} -of [get_cells -hier -filter {REF_NAME == PHASER_OUT_PHY}]] 2
set_multicycle_path -hold -start -through [get_pins -filter {NAME =~ */OSERDESRST} -of [get_cells -hier -filter {REF_NAME == PHASER_OUT_PHY}]] 1

set_max_delay -to [get_pins -hier -include_replicated_objects -filter {NAME =~ *temp_mon_enabled.u_tempmon/device_temp_sync_r1_reg[*]/D}] 20.000
set_max_delay -datapath_only -from [get_cells -hier *rstdiv0_sync_r1_reg*] -to [get_pins -filter {NAME =~ */RESET} -of [get_cells -hier -filter {REF_NAME == PHY_CONTROL}]] 5.000
set_false_path -through [get_nets -hier -filter {NAME =~ */u_iodelay_ctrl/sys_rst_i}]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u3_SDCLKMUX/CLK]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u4_SDCLKMUX/CLK]

set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u1_SDCLKBUF/clk_uHS_inv]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u1_SDCLKMUX/clk_25_u1]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u4_SDCLKMUX/clk_int]
set_property CLOCK_DEDICATED_ROUTE ANY_CMT_COLUMN [get_nets u_soc_top/u_SDC_AXI_TOP/u_sd_top/u_clock_manager/u2_SDCLKMUX/clk_50_u2]

##############################debug probes ##################################


