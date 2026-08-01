# GatE-V Stage 2B — Vivado Synthesis (100 MHz)
# Usage: cd Make Files && vivado -mode batch -source scripts/vivado_synth.tcl

set project_name "GatE-V"
set project_dir [lindex $argv 0]
if {$project_dir == ""} { set project_dir "../GatE-V" }

open_project $project_dir/$project_name.xpr

# Reset and re-run synthesis
reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1

# Open synthesized design and report
open_run synth_1
report_utilization -file ${project_dir}/synth_utilization.rpt
report_timing_summary -file ${project_dir}/synth_timing.rpt

puts "============================================================"
puts " GatE-V Stage 2B Synthesis Complete (100 MHz)"
puts " Utilization: $project_dir/synth_utilization.rpt"
puts " Timing: $project_dir/synth_timing.rpt"
puts "============================================================"

close_project
