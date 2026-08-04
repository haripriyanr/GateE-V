# GatE-V BD Screenshot Capture
# Usage: cd Hardware Architecture/Make && vivado -source scripts/capture_bd_screenshot.tcl

set prj "../GatE-V/GatE-V.xpr"
set bd  "../GatE-V/GatE-V.srcs/sources_1/bd/gatev_bd/gatev_bd.bd"
set out "report/figures/gatev_bd"

open_project $prj
open_bd_design $bd
write_bd_layout -format svg -force $out
puts "BD screenshot saved to ${out}.svg"
