#################################################################################
#
# Created by Genus(TM) Synthesis Solution 23.15-s099_1 on Fri Nov 14 14:45:09 EET 2025
#
#################################################################################

## library_sets
create_library_set -name slow_0p9v_125c_ls \
    -timing { /opt/soc/tech/GPDK045/gsclib045/timing/slow_vdd1v0_basicCells.lib }
create_library_set -name fast_1p1v_0c_ls \
    -timing { /opt/soc/tech/GPDK045/gsclib045/timing/fast_vdd1v0_basicCells.lib }

## opcond
create_opcond -name 0p9v_125c \
    -process 1.0 \
    -voltage 0.9 \
    -temperature 125.0
create_opcond -name 1p1v_0c \
    -process 1.0 \
    -voltage 1.1 \
    -temperature 0.0

## timing_condition
create_timing_condition -name fast_1p1v_0c \
    -opcond 1p1v_0c \
    -library_sets { fast_1p1v_0c_ls }
create_timing_condition -name slow_0p9v_125c \
    -opcond 0p9v_125c \
    -library_sets { slow_0p9v_125c_ls }

## rc_corner
create_rc_corner -name cmax_125c \
    -temperature 125.0 \
    -qrc_tech /opt/soc/tech/GPDK045/gsclib045/qrc/gpdk045.tch \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0} \
    -post_route_clock_cross_cap {1.0 1.0 1.0}
create_rc_corner -name cmin_0c \
    -temperature 0.0 \
    -qrc_tech /opt/soc/tech/GPDK045/gsclib045/qrc/gpdk045.tch \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0} \
    -post_route_clock_cross_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name fast_1p1v_0c_cmin \
    -early_timing_condition { fast_1p1v_0c } \
    -late_timing_condition { fast_1p1v_0c } \
    -early_rc_corner cmin_0c \
    -late_rc_corner cmin_0c
create_delay_corner -name slow_0p9v_125c_cmax \
    -early_timing_condition { slow_0p9v_125c } \
    -late_timing_condition { slow_0p9v_125c } \
    -early_rc_corner cmax_125c \
    -late_rc_corner cmax_125c

## constraint_mode
create_constraint_mode -name scan_capture \
    -sdc_files { /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/modes/scan_capture/scan_capture.sdc.gz }
create_constraint_mode -name func \
    -sdc_files { /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/modes/func/func.sdc.gz }
create_constraint_mode -name scan_shift \
    -sdc_files { /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/modes/scan_shift/scan_shift.sdc.gz }

## analysis_view
create_analysis_view -name slow_0p9v_125c_cmax_scan_shift \
    -constraint_mode scan_shift \
    -delay_corner slow_0p9v_125c_cmax \
    -latency_file /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/views/slow_0p9v_125c_cmax_scan_shift/latency.sdc.gz
create_analysis_view -name slow_0p9v_125c_cmax_scan_capture \
    -constraint_mode scan_capture \
    -delay_corner slow_0p9v_125c_cmax \
    -latency_file /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/views/slow_0p9v_125c_cmax_scan_capture/latency.sdc.gz
create_analysis_view -name slow_0p9v_125c_cmax_func \
    -constraint_mode func \
    -delay_corner slow_0p9v_125c_cmax \
    -latency_file /home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.mmmc/views/slow_0p9v_125c_cmax_func/latency.sdc.gz
create_analysis_view -name fast_1p1v_0c_cmin_scan_capture \
    -constraint_mode scan_capture \
    -delay_corner fast_1p1v_0c_cmin
create_analysis_view -name fast_1p1v_0c_cmin_scan_shift \
    -constraint_mode scan_shift \
    -delay_corner fast_1p1v_0c_cmin
create_analysis_view -name fast_1p1v_0c_cmin_func \
    -constraint_mode func \
    -delay_corner fast_1p1v_0c_cmin

## set_analysis_view
set_analysis_view -setup { slow_0p9v_125c_cmax_func slow_0p9v_125c_cmax_scan_capture slow_0p9v_125c_cmax_scan_shift } \
                  -hold { slow_0p9v_125c_cmax_func slow_0p9v_125c_cmax_scan_capture slow_0p9v_125c_cmax_scan_shift } \
                  -leakage slow_0p9v_125c_cmax_func \
                  -dynamic slow_0p9v_125c_cmax_func
