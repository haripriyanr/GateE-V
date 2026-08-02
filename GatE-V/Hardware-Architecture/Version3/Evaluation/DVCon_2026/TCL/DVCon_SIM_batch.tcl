puts "--- Simulation Started (Batch Mode) ---"
set MDIR_PATH "/run/media/user/DATA/DVcon/GatE-V/Hardware-Architecture/Version3/Evaluation/DVCon_2026"
set PJT_PATH "$MDIR_PATH/VIVADO_PROJECT"
set SIM_RUN_TIME "100"

set today [clock seconds]
set Project_Folder [clock format $today -format %d_%m_%y-%H_%M_%S]

create_project DVCon_PJT_SIM_2026 $MDIR_PATH/VIVADO_PROJECT/DVCon_PJT_SIM_2026_$Project_Folder -part xc7k325tffg900-2
set_property part xc7k325tffg900-2 [current_project]
set_property target_language VHDL [current_project]

add_files $MDIR_PATH/DVCon_SoC_SRC/AS1061_SYSTEM/AS1061_SYSTEM_TOP.v $MDIR_PATH/DVCon_SoC_SRC/TOP/Top.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/TB/test_bench.vhd
add_files $MDIR_PATH/DVCon_SoC_SRC/MEMORY_IP/rom_32KB_axi/rom_32KB_axi.xci
foreach file [exec find $MDIR_PATH/DVCon_SoC_SRC/ACCELERATOR_IP -type f \( -name "*.v" -o -name "*.sv" -o -name "*.vhd" -o -name "*.xci" \)] {
    add_files $file
} 
add_files -fileset constrs_1 -norecurse $MDIR_PATH/DVCon_SoC_XDC/AS1061_SYSTEM_XDC.xdc

update_compile_order -fileset sources_1
set_property top test_bench [get_filesets sim_1]
update_compile_order -fileset sim_1

launch_simulation -simset sim_1 -mode behavioral
run $SIM_RUN_TIME us
close_sim
close_project
puts "--- Simulation Completed Successfully ---"
