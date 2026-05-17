################################################################################
# Design specific setup
################################################################################
# Time-stamp: <2025-10-25 15:42:58 qftele>

# Directory structure
set_db flow_vars_data_directory                             [exec pwd]

# Design info
set_db flow_vars_rtl_root_dir                               .
set_db flow_vars_design_name                                $env(MODULE_NAME)
set_db flow_vars_design_top                                 $env(MODULE_NAME)
set_db flow_vars_power_intent                               "[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].upf"
set_db flow_vars_floorplan_def                              "[get_db flow_vars_data_directory]/floorplan_def/[get_db flow_vars_design_name].def.gz"
set_db flow_vars_tcf_file				    [list /userwork8/tlehtine/projects/ML/sim/mem_pow_test/sim_out_read_1GHz.vcd tb_top.i_dut]
set_db flow_vars_bist_signals                               ""
set_db flow_vars_elaboration_parameters                     ""

# block specific MMMC settings
set_db flow_vars_constraint_modes                           [list \
								 func \
								 scan_capture \
								 scan_shift \
							    ]
set_db flow_vars_setup_synth_active_views                   [list \
                                                              slow_0p9v_125c_cmax_func \
                                                              slow_0p9v_125c_cmax_scan_capture \
                                                              slow_0p9v_125c_cmax_scan_shift \
                                                            ]
set_db flow_vars_setup_pnr_active_views                     [list \
                                                              slow_0p9v_125c_cmax_func \
                                                              slow_0p9v_125c_cmax_scan_capture \
                                                              slow_0p9v_125c_cmax_scan_shift \
                                                            ]
set_db flow_vars_setup_sta_active_views                     [list \
                                                              slow_0p9v_125c_cmax_func \
                                                              slow_0p9v_125c_cmax_scan_capture \
                                                              slow_0p9v_125c_cmax_scan_shift \
                                                              ]
set_db flow_vars_hold_views                                 "fast_1p1v_0c_cmin_func"
set_db flow_vars_hold_pnr_active_views                      [list \
                                                                 slow_0p9v_125c_cmax_func \
                                                                 slow_0p9v_125c_cmax_scan_capture \
                                                                 slow_0p9v_125c_cmax_scan_shift \
								 fast_1p1v_0c_cmin_func \
								 fast_1p1v_0c_cmin_scan_capture \
								 fast_1p1v_0c_cmin_scan_shift \
                                                            ]
set_db flow_vars_hold_sta_active_views                      [list \
                                                                 slow_0p9v_125c_cmax_func \
                                                                 slow_0p9v_125c_cmax_scan_capture \
                                                                 slow_0p9v_125c_cmax_scan_shift \
								 fast_1p1v_0c_cmin_func \
								 fast_1p1v_0c_cmin_scan_capture \
								 fast_1p1v_0c_cmin_scan_shift \
                                                            ]
# set_db flow_vars_hold_sta_active_views                      [get_db flow_vars_hold_pnr_active_views]
set_db flow_vars_power_view                                 [lindex [get_db flow_vars_setup_synth_active_views] 0]
#set_db flow_vars_power_view                                 "fast_1p1v_0c_cmin_func"
