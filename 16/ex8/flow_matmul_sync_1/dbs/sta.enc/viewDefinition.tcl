if {![namespace exists ::IMEX]} { namespace eval ::IMEX {} }
set ::IMEX::dataVar [file dirname [file normalize [info script]]]
set ::IMEX::libVar ${::IMEX::dataVar}/libs

create_library_set -name slow_0p9v_125c_ls\
   -timing\
    [list ${::IMEX::libVar}/mmmc/slow_vdd1v0_basicCells.lib]
create_library_set -name fast_1p1v_0c_ls\
   -timing\
    [list ${::IMEX::libVar}/mmmc/fast_vdd1v0_basicCells.lib]
create_opcond -name 0p9v_125c -process 1 -voltage 0.9 -temperature 125
create_opcond -name 1p1v_0c -process 1 -voltage 1.1 -temperature 0
create_timing_condition -name fast_1p1v_0c\
   -library_sets [list fast_1p1v_0c_ls]\
   -opcond 1p1v_0c
create_timing_condition -name slow_0p9v_125c\
   -library_sets [list slow_0p9v_125c_ls]\
   -opcond 0p9v_125c
create_rc_corner -name cmax_125c\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 125\
   -qrc_tech ${::IMEX::libVar}/mmmc/cmax_125c/gpdk045.tch
create_rc_corner -name cmin_0c\
   -pre_route_res 1\
   -post_route_res 1\
   -pre_route_cap 1\
   -post_route_cap 1\
   -post_route_cross_cap 1\
   -pre_route_clock_res 0\
   -pre_route_clock_cap 0\
   -temperature 0\
   -qrc_tech ${::IMEX::libVar}/mmmc/cmax_125c/gpdk045.tch
create_delay_corner -name fast_1p1v_0c_cmin\
   -timing_condition {fast_1p1v_0c}\
   -rc_corner cmin_0c
create_delay_corner -name slow_0p9v_125c_cmax\
   -timing_condition {slow_0p9v_125c}\
   -rc_corner cmax_125c
create_constraint_mode -name scan_capture\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/scan_capture/scan_capture.sdc]
create_constraint_mode -name func\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/func/func.sdc]
create_constraint_mode -name scan_shift\
   -sdc_files\
    [list ${::IMEX::dataVar}/mmmc/modes/scan_shift/scan_shift.sdc]
create_analysis_view -name slow_0p9v_125c_cmax_scan_shift -constraint_mode scan_shift -delay_corner slow_0p9v_125c_cmax -latency_file ${::IMEX::dataVar}/mmmc/views/slow_0p9v_125c_cmax_scan_shift/latency.sdc
create_analysis_view -name slow_0p9v_125c_cmax_scan_capture -constraint_mode scan_capture -delay_corner slow_0p9v_125c_cmax -latency_file ${::IMEX::dataVar}/mmmc/views/slow_0p9v_125c_cmax_scan_capture/latency.sdc
create_analysis_view -name slow_0p9v_125c_cmax_func -constraint_mode func -delay_corner slow_0p9v_125c_cmax -latency_file ${::IMEX::dataVar}/mmmc/views/slow_0p9v_125c_cmax_func/latency.sdc
create_analysis_view -name fast_1p1v_0c_cmin_scan_capture -constraint_mode scan_capture -delay_corner fast_1p1v_0c_cmin -latency_file ${::IMEX::dataVar}/mmmc/views/fast_1p1v_0c_cmin_scan_capture/latency.sdc
create_analysis_view -name fast_1p1v_0c_cmin_scan_shift -constraint_mode scan_shift -delay_corner fast_1p1v_0c_cmin -latency_file ${::IMEX::dataVar}/mmmc/views/fast_1p1v_0c_cmin_scan_shift/latency.sdc
create_analysis_view -name fast_1p1v_0c_cmin_func -constraint_mode func -delay_corner fast_1p1v_0c_cmin -latency_file ${::IMEX::dataVar}/mmmc/views/fast_1p1v_0c_cmin_func/latency.sdc
set_analysis_view -setup [list slow_0p9v_125c_cmax_scan_shift slow_0p9v_125c_cmax_scan_capture slow_0p9v_125c_cmax_func] -hold [list slow_0p9v_125c_cmax_scan_shift slow_0p9v_125c_cmax_scan_capture slow_0p9v_125c_cmax_func fast_1p1v_0c_cmin_scan_capture fast_1p1v_0c_cmin_scan_shift fast_1p1v_0c_cmin_func]
