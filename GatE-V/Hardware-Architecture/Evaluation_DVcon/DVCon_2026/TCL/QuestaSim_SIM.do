#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
#%%                      Centre for Development of Advanced Computing                            %%
#%%                          Vellayambalam, Thiruvananthapuram.                                  %%
#%%==============================================================================================%%
#%% This confidential and proprietary software may be used only as authorised by a licensing     %%
#%% agreement from Centre for Development of Advanced Computing, India (C-DAC).In the event of   %%
#%% publication, the following notice is applicable:                                             %%
#%% Copyright (c) 2026 C-DAC                                                                     %%
#%% ALL RIGHTS RESERVED                                                                          %%
#%% The entire notice above must be reproduced on all authorised copies.                         %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%% File Name        : QuestaSim_SIM.do                                                       	 %%
#%% Title            : AS1061 System TCL Script                                                  %%
#%% Author           : HDG, CDAC Thiruvananthapuram                                              %%
#%% Description      : TCL Script for AS1061 System QuestaSim Simulation                         %%
#%% Version          : 00                                                                        %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%    Date                By              Version          Change Description                   %%
#%%                                                                                              %%
#%%                                                                                              %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
# ==========================================================
# CONFIGURABLE VARIABLES
# ==========================================================
set worklib work
set unisims_src "../DVCon_SoC_SRC/TB/unisims"
set unisims_lib "../DVCon_SoC_SRC/TB/unisims_ver"
set accel_dir "../DVCon_SoC_SRC/ACCELERATOR_IP"

# ==========================================================
# WORK LIBRARY SETUP
# ==========================================================
if {[file exists $worklib]} {
    file delete -force $worklib
}

vlib $worklib
vmap work $worklib

# ==========================================================
# UNISIMS_VER LIBRARY SETUP
# ==========================================================
if {[file exists $unisims_lib]} {
    file delete -force $unisims_lib
}

vlib $unisims_lib
vmap unisims_ver $unisims_lib

# ==========================================================
# COMPILE UNISIM SOURCE FILES
# ==========================================================
puts "Compiling UNISIM library..."
eval vlog -work unisims_ver [glob "$unisims_src/*.v"]

# ==========================================================
# COMPILE FIXED DESIGN FILES
# ==========================================================

# VHDL
vcom -2008 -work $worklib ../DVCon_SoC_SRC/TB/test_bench.vhd
vcom -2008 -work $worklib ../DVCon_SoC_SRC/TOP/Top.vhd

# Verilog
vlog -work $worklib ../DVCon_SoC_SRC/AS1061_SYSTEM/AS1061_SYSTEM_TOP.v
vlog -work $worklib ../DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/sim/rom_32KB_axi.v
vlog -work $worklib ../DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/simulation/blk_mem_gen_v8_4.v
vlog -work $worklib ../DVCon_SoC_SRC/TB/glbl.v

# ==========================================================
# AUTOMATICALLY COMPILE ACCELERATOR_IP FILES
# ==========================================================

# VHDL (*.vhd)
set vhdl_files [lsort [glob -nocomplain "$accel_dir/*.vhd"]]
if {[llength $vhdl_files] > 0} {
    puts "Compiling ACCELERATOR_IP VHDL files..."
    vcom -2008 -work $worklib {*}$vhdl_files
} else {
    puts "No *.vhd files found in ACCELERATOR_IP."
}

# VHDL (*.vhdl)
set vhdl_files2 [lsort [glob -nocomplain "$accel_dir/*.vhdl"]]
if {[llength $vhdl_files2] > 0} {
    puts "Compiling ACCELERATOR_IP VHDL (.vhdl) files..."
    vcom -2008 -work $worklib {*}$vhdl_files2
} else {
    puts "No *.vhdl files found in ACCELERATOR_IP."
}

# Verilog (*.v)
set verilog_files [lsort [glob -nocomplain "$accel_dir/*.v"]]
if {[llength $verilog_files] > 0} {
    puts "Compiling ACCELERATOR_IP Verilog files..."
    vlog -work $worklib {*}$verilog_files
} else {
    puts "No *.v files found in ACCELERATOR_IP."
}

# SystemVerilog (*.sv)
set sv_files [lsort [glob -nocomplain "$accel_dir/*.sv"]]
if {[llength $sv_files] > 0} {
    puts "Compiling ACCELERATOR_IP SystemVerilog files..."
    vlog -sv -work $worklib {*}$sv_files
} else {
    puts "No *.sv files found in ACCELERATOR_IP."
}

# ==========================================================
# RUN SIMULATION
# ==========================================================
vsim -novopt -suppress 12110 -L unisims_ver -t ps work.test_bench glbl

# ==========================================================
# ADD WAVES
# ==========================================================
 add wave -r /*

# ==========================================================
# RUN TIME CONTROL
# ==========================================================
# run 12 ms
