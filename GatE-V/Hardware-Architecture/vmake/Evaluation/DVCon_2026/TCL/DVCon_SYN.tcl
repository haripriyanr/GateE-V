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
#%% File Name        : DVCon_IMP.tcl                                                         	 %%
#%% Title            : AS1061 System TCL Script                                                  %%
#%% Author           : HDG, CDAC Thiruvananthapuram                                              %%
#%% Description      : TCL Script for AS1061 System vivado Implementation                        %%
#%% Version          : 00                                                                        %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%%%%%%%%%%%%%%%%%%% Modification / Updation  History %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
#%%    Date                By              Version          Change Description                   %%
#%%                                                                                              %%
#%%                                                                                              %%
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
puts "--- Implementation Started ---"
set MDIR_PATH "/run/media/user/DATA/DVcon/GatE-V/Hardware-Architecture/vmake/Evaluation/DVCon_2026"
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set DELAY_TIME "5000"

set today [clock seconds]
set Project_Folder [clock format $today -format  %d_%m_%y-%H_%M_%S]

##-------------------------------------------------------------
#start_gui
create_project DVCon_PJT_SYN_2026 $MDIR_PATH/VIVADO_PROJECT/DVCon_PJT_SYN_2026_$Project_Folder -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

add_files $MDIR_PATH/DVCon_SoC_SRC/AS1061_SYSTEM/AS1061_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci 
##------- Add design source files [Accelerator] ---------------
foreach file [exec find $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP -type f \( -name "*.v" -o -name "*.sv" -o -name "*.vhd" -o -name "*.xci" \)] {
    add_files $file
} 
##-------------------------------------------------------------
add_files -fileset constrs_1 -norecurse $MDIR_PATH/DVCon_SoC_XDC/AS1061_SYSTEM_XDC.xdc
##-------------------------------------------------------------

set_property top Top [current_fileset]
update_compile_order -fileset sources_1

reset_run synth_1
launch_runs synth_1 -jobs 40
wait_on_run synth_1
open_run synth_1

report_utilization -hierarchical -hierarchical_percentages  -file $MDIR_PATH/GEN_BIT_OUT/report_hierarchical_utilization_summary.rpt
report_utilization -file $MDIR_PATH/GEN_BIT_OUT/report_utilization_summary.rpt

close_design
close_project

