create_project pe_tile_synth vivado_synth_proj -part xc7a35tcpg236-1 -force
add_files src/rtl/pe_mac.sv
add_files src/rtl/pe_control.sv
add_files src/rtl/pe_tile.sv
add_files src/rtl/ping_pong_controller.sv
add_files src/rtl/sram_2kb_dual_port.sv
add_files src/rtl/axi4_stream_dma.sv
set_property top pe_tile [current_fileset]
synth_design -top pe_tile -part xc7a35tcpg236-1 -mode out_of_context
report_utilization -file reports/pe_tile_util.rpt
report_timing_summary -file reports/pe_tile_timing.rpt
exit
