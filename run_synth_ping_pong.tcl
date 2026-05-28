create_project ping_pong_synth vivado_synth_proj -part xc7a35tcpg236-1 -force
add_files src/rtl/ping_pong_controller.sv
set_property top ping_pong_controller [current_fileset]
synth_design -top ping_pong_controller -part xc7a35tcpg236-1
report_utilization -file reports/ping_pong_util.rpt
report_timing_summary -file reports/ping_pong_timing.rpt
exit
