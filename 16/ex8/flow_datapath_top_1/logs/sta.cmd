#######################################################
#                                                     
#  Tempus Timing Solution Command Logging File                     
#  Created on Fri Nov 14 17:44:23 2025                
#                                                     
#######################################################

#@(#)CDS: Tempus Timing Solution v23.15-s108_1 (64bit) 07/22/2025 11:26 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 23.15-s108_1 NR250707-2219/23_15-UB (database version 18.20.674) {superthreading v2.20}
#@(#)CDS: AAE 23.15-s032 (64bit) 07/22/2025 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 23.15-s037_1 () Jul 16 2025 02:46:10 ( )
#@(#)CDS: SYNTECH 23.15-s011_1 () Jun 23 2025 00:02:58 ( )
#@(#)CDS: CPE v23.15-s090

init_flow {flow_script /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl yaml_script {} flow_no_check 0 parent_uuid {} previous_uuid a15a5787-5cd5-417d-8bc5-7cc2a2a5cbb9 top_dir /home/student/16/ex8/flow_datapath_top_1 flow_dir . status_file /home/student/16/ex8/flow_datapath_top_1/flow.status.d/sta metrics_file /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/sta run_tag {} db {tcl /home/student/16/ex8/flow_datapath_top_1/dbs/opt_signoff/init_sta.tcl /home/student/16/ex8/flow_datapath_top_1 {}} db_is_ref_run 0 branch {} caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} flow {flow flow:block dir . db {tcl dbs/opt_signoff/init_sta.tcl . {}} branch {} tool tempus caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} uuid a15a5787-5cd5-417d-8bc5-7cc2a2a5cbb9 tool_options {} start_step {tool tempus flow flow:block canonical_path {.steps flow:sta .steps flow_step:signoff_start} step flow_step:signoff_start features {} str sta.signoff_start} process_branch_trunk 1} flow_name flow:block first_step {tool tempus flow flow:block canonical_path {.steps flow:sta .steps flow_step:signoff_start} step flow_step:signoff_start features {} str sta.signoff_start} interactive 0 interactive_run 0 enabled_features {report_lec synth_spatial pnr_db_handoff add_scan opt_signoff} inject_tcl {} trunk_process 1 aum_upload false tool_options {} overwrite 0 last_step {tool tempus flow flow:block canonical_path {.steps flow:sta .steps flow_step:post_sta} step flow_step:post_sta features {} str sta.post_sta} log_prefix /home/student/16/ex8/flow_datapath_top_1/logs/sta}
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/sta -previous a15a5787-5cd5-417d-8bc5-7cc2a2a5cbb9
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/flow_attributes.tcl (pre)
set flow_vars [dict create]
dict lappend flow_vars flow_vars_data_directory                                 description   "Path to the input data"
dict lappend flow_vars flow_vars_data_directory                                 type          string
dict lappend flow_vars flow_vars_data_directory                                 default       ""
dict lappend flow_vars flow_vars_dft_data_directory                             description   "Path to the DFT input data"
dict lappend flow_vars flow_vars_dft_data_directory                             type          string
dict lappend flow_vars flow_vars_dft_data_directory                             default       ""
dict lappend flow_vars flow_vars_dft_library                                    description   "Path to the DFT std cell library"
dict lappend flow_vars flow_vars_dft_library                                    type          string
dict lappend flow_vars flow_vars_dft_library                                    default       ""
dict lappend flow_vars flow_vars_dft_ncsim_library                              description   "Path to the DFT include library"
dict lappend flow_vars flow_vars_dft_ncsim_library                              type          string
dict lappend flow_vars flow_vars_dft_ncsim_library                              default       ""
dict lappend flow_vars flow_vars_memory_path                                    description   "Path to memory libs"
dict lappend flow_vars flow_vars_memory_path                                    type          string
dict lappend flow_vars flow_vars_memory_path                                    default       ""
dict lappend flow_vars flow_vars_stdcell_path                                   description   "Path to stdcell libs"
dict lappend flow_vars flow_vars_stdcell_path                                   type          string
dict lappend flow_vars flow_vars_stdcell_path                                   default       ""
dict lappend flow_vars flow_vars_qrc_tech_directory                             description   "Path to qrc technology directory"
dict lappend flow_vars flow_vars_qrc_tech_directory                             type          string
dict lappend flow_vars flow_vars_qrc_tech_directory                             default       ""
dict lappend flow_vars flow_vars_lef_tech_file                                  description   "Path to lef technology file"
dict lappend flow_vars flow_vars_lef_tech_file                                  type          string
dict lappend flow_vars flow_vars_lef_tech_file                                  default       ""
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              description   "Path to PVS DRC rule file"
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          description   "Path to Pegasus DRC rule file"
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              description   "Path to PVS LVS rule file"
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          description   "Path to PEGASUS LVS rule file"
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          description   "Path to PVS antenna rule file"
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          type          string
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          default       ""
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      description   "Path to Pegasus antenna rule file"
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      type          string
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      default       ""
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       description   "Path to PVS metal fill rule file"
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       type          string
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   description   "Path to PEGASUS metal fill rule file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   default       ""
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        description   "Path to PVS FEOL fill rule file"
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        type          string
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        default       ""
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    description   "Path to PEGASUS FEOL fill rule file"
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    type          string
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    default       ""
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         type          string
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      description   "Path to PEGASUS metal fill stream out map file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      default       ""
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          description   "Path to stream in map file"
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          type          string
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          default       ""
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         type          string
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         default       ""
dict lappend flow_vars flow_vars_ict_em_models                                  description   "Path to ict em models"
dict lappend flow_vars flow_vars_ict_em_models                                  type          string
dict lappend flow_vars flow_vars_ict_em_models                                  default       ""
dict lappend flow_vars flow_vars_rtl_root_dir                                   description   "Design RTL root directory"
dict lappend flow_vars flow_vars_rtl_root_dir                                   type          string
dict lappend flow_vars flow_vars_rtl_root_dir                                   default       ""
dict lappend flow_vars flow_vars_design_name                                    description   "Top level design name"
dict lappend flow_vars flow_vars_design_name                                    type          string
dict lappend flow_vars flow_vars_design_name                                    default       ""
dict lappend flow_vars flow_vars_design_top                                     description   "Top entity name to be elaborated"
dict lappend flow_vars flow_vars_design_top                                     type          string
dict lappend flow_vars flow_vars_design_top                                     default       ""
dict lappend flow_vars flow_vars_power_intent                                   description   "Path to the power intent file"
dict lappend flow_vars flow_vars_power_intent                                   type          string
dict lappend flow_vars flow_vars_power_intent                                   default       ""
dict lappend flow_vars flow_vars_floorplan_def                                  description   "Path to the floorplan def file"
dict lappend flow_vars flow_vars_floorplan_def                                  type          string
dict lappend flow_vars flow_vars_floorplan_def                                  default       ""
dict lappend flow_vars flow_vars_tcf_file                                       description   "Path to the activity file generated by joules"
dict lappend flow_vars flow_vars_tcf_file                                       type          string
dict lappend flow_vars flow_vars_tcf_file                                       default       ""
dict lappend flow_vars flow_vars_bist_signals                                   description   "Generated verilog file which specifies bist signal connectivity"
dict lappend flow_vars flow_vars_bist_signals                                   type          string
dict lappend flow_vars flow_vars_bist_signals                                   default       ""
dict lappend flow_vars flow_vars_scan_abstracts                                 description   "Subblock scan abstract file paths"
dict lappend flow_vars flow_vars_scan_abstracts                                 type          string
dict lappend flow_vars flow_vars_scan_abstracts                                 default       ""
dict lappend flow_vars flow_vars_elaboration_parameters                         description   "Design toplevel parameters"
dict lappend flow_vars flow_vars_elaboration_parameters                         type          string
dict lappend flow_vars flow_vars_elaboration_parameters                         default       ""
dict lappend flow_vars flow_vars_constraint_modes                               description   "Define the list of constraint modes"
dict lappend flow_vars flow_vars_constraint_modes                               type          string
dict lappend flow_vars flow_vars_constraint_modes                               default       ""
dict lappend flow_vars flow_vars_setup_synth_active_views                       description   "Define the list of setup active analysis views for Synthesis"
dict lappend flow_vars flow_vars_setup_synth_active_views                       type          string
dict lappend flow_vars flow_vars_setup_synth_active_views                       default       ""
dict lappend flow_vars flow_vars_setup_pnr_active_views                         description   "Define the list of setup active analysis views for P&R"
dict lappend flow_vars flow_vars_setup_pnr_active_views                         type          string
dict lappend flow_vars flow_vars_setup_pnr_active_views                         default       ""
dict lappend flow_vars flow_vars_setup_sta_active_views                         description   "Define the list of setup active analysis views for STA"
dict lappend flow_vars flow_vars_setup_sta_active_views                         type          string
dict lappend flow_vars flow_vars_setup_sta_active_views                         default       ""
dict lappend flow_vars flow_vars_hold_views                                     description   "Define the list of hold analysis views"
dict lappend flow_vars flow_vars_hold_views                                     type          string
dict lappend flow_vars flow_vars_hold_views                                     default       ""
dict lappend flow_vars flow_vars_hold_pnr_active_views                          description   "Define the list of hold active analysis views for P&R"
dict lappend flow_vars flow_vars_hold_pnr_active_views                          type          string
dict lappend flow_vars flow_vars_hold_pnr_active_views                          default       ""
dict lappend flow_vars flow_vars_hold_sta_active_views                          description   "Define the list of hold active analysis views for STA"
dict lappend flow_vars flow_vars_hold_sta_active_views                          type          string
dict lappend flow_vars flow_vars_hold_sta_active_views                          default       ""
dict lappend flow_vars flow_vars_power_view                                     description   "Define the power analysis view"
dict lappend flow_vars flow_vars_power_view                                     type          string
dict lappend flow_vars flow_vars_power_view                                     default       ""
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            description   "Define the the list of different VTs that should be loaded in the tool"
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            type          string
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            default       ""
dict lappend flow_vars flow_vars_lef_list                                       description   "Lef file list definition"
dict lappend flow_vars flow_vars_lef_list                                       type          string
dict lappend flow_vars flow_vars_lef_list                                       default       ""
dict lappend flow_vars flow_vars_stdcell_gds_list                               description   "Stdcell GDS file list definition"
dict lappend flow_vars flow_vars_stdcell_gds_list                               type          string
dict lappend flow_vars flow_vars_stdcell_gds_list                               default       ""
dict lappend flow_vars flow_vars_stdcell_spi_list                               description   "Stdcell SPICE file list definition"
dict lappend flow_vars flow_vars_stdcell_spi_list                               type          string
dict lappend flow_vars flow_vars_stdcell_spi_list                               default       ""
dict lappend flow_vars flow_vars_memory_gds_list                                description   "Memory GDS file list definition"
dict lappend flow_vars flow_vars_memory_gds_list                                type          string
dict lappend flow_vars flow_vars_memory_gds_list                                default       ""
dict lappend flow_vars flow_vars_memory_spi_list                                description   "Memory SPICE file list definition"
dict lappend flow_vars flow_vars_memory_spi_list                                type          string
dict lappend flow_vars flow_vars_memory_spi_list                                default       ""
dict lappend flow_vars flow_vars_io_gds_list                                    description   "IO GDS file list definition"
dict lappend flow_vars flow_vars_io_gds_list                                    type          string
dict lappend flow_vars flow_vars_io_gds_list                                    default       ""
dict lappend flow_vars flow_vars_io_spi_list                                    description   "IO SPICE file list definition"
dict lappend flow_vars flow_vars_io_spi_list                                    type          string
dict lappend flow_vars flow_vars_io_spi_list                                    default       ""
dict lappend flow_vars flow_vars_macro_gds_list                                 description   "Macro GDS file list definition"
dict lappend flow_vars flow_vars_macro_gds_list                                 type          string
dict lappend flow_vars flow_vars_macro_gds_list                                 default       ""
dict lappend flow_vars flow_vars_macro_spi_list                                 description   "Macro SPICE file list definition"
dict lappend flow_vars flow_vars_macro_spi_list                                 type          string
dict lappend flow_vars flow_vars_macro_spi_list                                 default       ""
dict lappend flow_vars flow_vars_dont_use_list                                  description   "dont_use cell list definition"
dict lappend flow_vars flow_vars_dont_use_list                                  type          string
dict lappend flow_vars flow_vars_dont_use_list                                  default       ""
dict lappend flow_vars flow_vars_sdf_list                                       description   "Macro SDF file list definition"
dict lappend flow_vars flow_vars_sdf_list                                       type          string
dict lappend flow_vars flow_vars_sdf_list                                       default       ""
dict lappend flow_vars flow_vars_voltus_file_list                               description   "Voltus file list definition"
dict lappend flow_vars flow_vars_voltus_file_list                               type          string
dict lappend flow_vars flow_vars_voltus_file_list                               default       ""
foreach myAttr [dict keys $flow_vars] {
  if { ![is_attribute -obj_type root $myAttr]} {
    define_attribute $myAttr \
      -category user_flow \
      -data_type [dict get $flow_vars $myAttr type] \
      -default [dict get $flow_vars $myAttr default] \
      -help_string [dict get $flow_vars $myAttr description] \
      -obj_type root
    }
}
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/flow_attributes.tcl
#@ Begin verbose source scripts/design_setup.tcl (pre)
set_db flow_vars_data_directory                             [exec pwd]
set_db flow_vars_rtl_root_dir                               .
set_db flow_vars_design_name                                $env(MODULE_NAME)
set_db flow_vars_design_top                                 $env(MODULE_NAME)
set_db flow_vars_power_intent                               "[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].upf"
set_db flow_vars_floorplan_def                              "[get_db flow_vars_data_directory]/floorplan_def/[get_db flow_vars_design_name].def.gz"
set_db flow_vars_tcf_file				    [list /userwork8/tlehtine/projects/ML/sim/mem_pow_test/sim_out_read_1GHz.vcd tb_top.i_dut]
set_db flow_vars_bist_signals                               ""
set_db flow_vars_elaboration_parameters                     ""
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
set_db flow_vars_power_view                                 [lindex [get_db flow_vars_setup_synth_active_views] 0]
#@ End verbose source scripts/design_setup.tcl
#@ Begin verbose source scripts/tech_setup.tcl (pre)
set TECHNOLOGY "gpdk045"
set TECH_SETUP_VERSION "v1.0"
puts "Info: TECHNOLOGY SETUP: $TECHNOLOGY : $TECH_SETUP_VERSION"
set_db flow_vars_lef_tech_file                             "/opt/soc/tech/GPDK045/gsclib045/lef/gsclib045_tech.lef"
set_db flow_vars_qrc_tech_directory                        "/opt/soc/tech/GPDK045/gsclib045/qrc"
set_db flow_vars_gdsout_stream_map_file                    "/opt/soc/tech/GPDK045/gsclib045/oa22/gsclib045/gsclib045.layermap"
set tech_lef_filelist [list ]
lappend tech_lef_filelist                                   [get_db flow_vars_lef_tech_file]
set_db flow_vars_lef_list $tech_lef_filelist
#@ End verbose source scripts/tech_setup.tcl
#@ Begin verbose source scripts/mmmc_setup.tcl (pre)
set MMMC_SETUP_VERSION "v1.0"
puts "Info: MMMC SETUP: $TECHNOLOGY : $MMMC_SETUP_VERSION"
set mmmc_vars(delay_corners) \
    [list \
	 slow_0p9v_125c_cmax \
	 fast_1p1v_0c_cmin \
	 ]
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # qrc techfile
    set mmmc_vars("${rc}_${temp}",qrc_tech) "[get_db flow_vars_qrc_tech_directory]/gpdk045.tch"
    # temperature
    if {${temp} == "m40c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "-40"
    } elseif {${temp} == "125c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "125"
    } elseif {${temp} == "0c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "0"
    } else {
	set mmmc_vars("${rc}_${temp}",temperature) "25"
    }


    ###########################################
    # OCVs &  Clock uncertainties for FLAT OCV
    ###########################################

    # use following uncertainties
    # FUNC:
    # setup:
    # clock jitter: defined through clock cycle
    # TECH uncertainty: 25ps
    # extra uncertainty (implementation): 20ps
    # extra uncertainty (signoff STA): 0ps
    # hold:
    # TECH uncertainty (SSG): 50ps
    # TECH uncertainty (fast): 40ps
    # extra uncertainty (implementation): 15ps
    # extra uncertainty (signoff STA): 0ps

    # Note, add 1% OCV on top of previous to match LVF
    # so flat values below have 0.01 added (subtracted) because of this

    # setup in slow, 0.81v, -40C/125c, cmax
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	($rc eq "cmax")} {
	
	# -2.0% + -3.7% (10mV V-margin) + -0.6% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.927"
	# +2.0% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.03"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_cell_early)   "1.0"
	# + 6.9% on data cell
	set mmmc_vars(${dc},flat_data_cell_late)    "1.079"

	# -6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.93"
	# +6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.07"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# +6.0 for data net
	set mmmc_vars(${dc},flat_data_net_late)    "1.07"

    # hold in slow, 0.81v, -40c/125c, cmax
    } elseif {$corn eq "slow" &&
	      $volt eq "0p9v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.2% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.882"
	# +3.2% for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.042"
	# -9.7% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.817"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmax
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.103"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmin
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmin")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.083"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# no derate on launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "1.0"
	# +8.5% for capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.075"
	# no derate for data net
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    } else {
	puts "Fatal: delay corner ${dc} OCVs not defined (corner: $corn, voltage: $volt, temperature: $temp, rc: ${rc})"
	exit 1
    }

    ###########################################
    # OCVs &  Clock uncertainties for SOCV
    ###########################################

    # Note, only voltage and temperature OCVs needed

    # Early & late variation factors from:
    set mmmc_vars(early_rc_variation_factor) 0.06
    set mmmc_vars(late_rc_variation_factor) 0.06

    set mmmc_vars(timing_socv_analysis_nsigma_multiplier) 3

    # slow, 0.81v, -40c
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "m40c"} {
        
        # DATA  @ 20.3mV : 7.4%
        # DATA  @ 10c    : 0.9%
        # CLOCK @ 20.3mV : 5.4%
        # CLOCK @ 10c    : 0.7%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.054"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.061"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.083"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "125c"} {
       
        # DATA  @ 20.3mV : 5.0%
        # DATA  @ 10c    : 0.3%
        # CLOCK @ 20.3mV : 3.5%
        # CLOCK @ 10c    : 0.2%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.037"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.037"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.053"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "0c"} {
       
        # DATA  @ 20.3mV : 6.6%
        # DATA  @ 10c    : 0.8%
        # CLOCK @ 20.3mV : 4.9%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.055"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.055"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "m40c"} {
       
        # DATA  @ 45mV   : 7.4%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 5.1%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.057"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.057"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.079"

     } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "125c"} {

        # DATA  @ 45mV   : 5.8%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 3.6%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.042"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.042"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.063"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "0c"} {

        # DATA  @ 45mV   : 7.0%
        # DATA  @ 10c    : 0.4%
        # CLOCK @ 45mV   : 4.7%
        # CLOCK @ 10c    : 0.4%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.051"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.051"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

     } else {
        puts "Fatal: corner / voltage / temperature combination not allowed (corner: $corn, voltage: $volt, temperature: $temp)"
        exit 1
    }
}
set mmmc_vars(constraint_modes) [get_db flow_vars_constraint_modes]
foreach cm $mmmc_vars(constraint_modes) {
    if {[get_db program_short_name] == "genus"} {
#	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
#	} else {
#	    set mmmc_vars(${cm},sdc_files) [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.dummy.tcl
#	}
    } else {
	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.hier_dft.tcl \
						]
	} else {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
	}
    }
}
#@ End verbose source scripts/mmmc_setup.tcl
#@ Begin verbose source scripts/library_setup.tcl (pre)
set PROJECT "Ballast"
set LIBRARY_SETUP_VERSION "v1.0"
puts "Info: LIBRARY SETUP: $PROJECT : $LIBRARY_SETUP_VERSION"
set_db flow_vars_stdcell_path                               "/opt/soc/tech/GPDK045/gsclib045"
set_db flow_vars_dft_data_directory                         [exec pwd]/dft_lib
set_db flow_vars_dft_library                                "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"
set_db flow_vars_dft_ncsim_library                          "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"
set_db flow_vars_dont_use_list                              [list "{.name==*FOOFOO*}" "{.name==*FIIFAA*}" ]
set io_lef_filelist [list ]
set io_gds_filelist [list ]
set io_spi_filelist [list ]
lappend io_lef_filelist ""
lappend io_gds_filelist ""
lappend io_spi_filelist ""
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $io_lef_filelist]
set_db flow_vars_io_gds_list $io_gds_filelist
set_db flow_vars_io_spi_list $io_spi_filelist
set stdcell_lef_filelist [list ]
set stdcell_gds_filelist [list ]
set stdcell_spi_filelist [list ]
lappend stdcell_lef_filelist [get_db flow_vars_stdcell_path]/lef/gsclib045_macro.lef
lappend stdcell_gds_filelist /opt/soc/tech/GPDK045/gsclib045/gds/gsclib045.gds
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $stdcell_lef_filelist]
set_db flow_vars_stdcell_gds_list $stdcell_gds_filelist
set_db flow_vars_stdcell_spi_list $stdcell_spi_filelist
foreach dc $mmmc_vars(delay_corners) {
    set mmmc_vars(${dc},timing_nldm) [list \
                                         ]
    set mmmc_vars(${dc},timing_ecsm) [list \
                                         ]
    if {[regexp {slow} $dc]} {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
    } else {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
    }
}
#@ End verbose source scripts/library_setup.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/global_macro_setup.tcl (pre)
set MACRO_SETUP_VERSION "v1.0"
puts "Info: MACRO SETUP: $MACRO_SETUP_VERSION"
array set global_macro_exportdir {
}
set ip_lef_filelist [list ]
lappend ip_lef_filelist ""
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $ip_lef_filelist]
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # PLL .lib
    lappend mmmc_vars(${dc},timing_nldm) ""
    lappend mmmc_vars(${dc},timing_ecsm) ""
    lappend mmmc_vars(${dc},timing_lvf) ""
}
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/global_macro_setup.tcl
#@ Begin verbose source scripts/local_macro_setup.tcl (pre)
if {1} {
array unset global_macro_exportdir
set macro_scan_abstract_filelist [list ]
set macro_lef_filelist [list ]
array set local_macro_exportdir {
    matmul_sync "../flow_matmul_sync_1"
}
array set memarray {
    256x32 "IN22FDX_S1DU_BFUG_W00256B032M04C128"
}
foreach {blockname blockpath} [array get global_macro_exportdir] {

    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT"
	continue
    }

    if {[info exists local_macro_exportdir($blockname)]} {
	if {[string compare $blockpath $local_macro_exportdir($blockname)]} {
	    puts "Warning([info script]): Overriding global setting for $blockname ->"
	    puts "\#OLD\#: $blockpath"
	    puts "\#NEW\#: $local_macro_exportdir($blockname)"
	    set $blockpath $local_macro_exportdir($blockname)
	}
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } elseif {[file exists $blockpath/models/cts/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/cts/$blockname.lef
    } elseif {[file exists $blockpath/models/floorplan/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/floorplan/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/{opt_signoff|cts|floorplan}"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/{opt_signoff.sta|cts|floorplan}"
	    exit 1
	}
    }
}
foreach {blockname blockpath} [array get local_macro_exportdir] {
    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT. Remove the definition from local macro settings!"
	continue
    }

    set found 0
    if {[info exists global_macro_exportdir($blockname)]} {
	set found 1
    }

    if {!$found} {
	puts "Warning([info script]): Global setting for $blockname set in local setting not found from global settings! Report this to project toplevel!"	
    } else {
	# it was found so it's already set
	continue
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } elseif {[file exists $blockpath/models/cts/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/cts/$blockname.lef
    } elseif {[file exists $blockpath/models/floorplan/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/floorplan/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/{opt_signoff|cts|floorplan}"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

        puts "corn volt temp rc: ${corn}_${volt}_${temp}_${rc}"

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/{opt_signoff.sta|cts|floorplan}"
	    exit 1
	}
    }
}
set memory_gds_filelist [list]
set memory_spi_filelist [list]
foreach {memdir memlist} [array get memarray] {

    set mem_directory ./models
    puts "Info: setting mem_directory as $mem_directory"
    foreach mem $memlist {

        lappend macro_lef_filelist ${mem_directory}/${mem}.lef

        # lappend macro_scan_abstract_filelist ${mem_directory}/${mem}/${mem}.ctl
        #lappend dft_library ${mem_directory}/model/verilog/${mem}.v
        #lappend dft_ncsim_library ${mem_directory}/model/verilog/${mem}.v

        #lappend memory_gds_filelist ${mem_directory}/gds/${mem}.gds

        #lappend memory_spi_filelist ${mem_directory}/cdl/${mem}.cdl

        foreach dc $mmmc_vars(delay_corners) {

	    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	    puts "Info: Adding NLDM: ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib"
            lappend mmmc_vars(${dc},timing_nldm) ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib
            lappend mmmc_vars(${dc},timing_ecsm) ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib
            #lappend mmmc_vars(${dc},timing_lvf) ${mem_directory}/${mem}/${mem}_${corn}g_${rc}_${volt}_${volt}_${temp}.lib_ecsm_tv
        }
    }
}
puts "Info: Adding macro info to flow_vars_lef_list in [info script]"
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $macro_lef_filelist]
set pll_idx [lsearch -regexp [get_db flow_vars_lef_list] {CLKPLL}]
set_db flow_vars_lef_list [lreplace [get_db flow_vars_lef_list] $pll_idx $pll_idx]
puts "Info: re-writing flow_vars_scan_abstracts in [info script]"
set_db flow_vars_scan_abstracts $macro_scan_abstract_filelist
}
#@ End verbose source scripts/local_macro_setup.tcl
set db [get_db flow_starting_db]
set flow [lindex [get_db flow_hier_path] end]
set setup_views [get_feature $flow -feature setup_views]
set hold_views [get_feature $flow -feature hold_views]
set leakage_view [get_feature $flow -feature leakage_view]
set dynamic_view [get_feature $flow -feature dynamic_view]
if {($setup_views ne "") || ($hold_views ne "") || ($leakage_view ne "") || ($dynamic_view ne "")} {...}
if {[info exists ::env(FLOWTOOL_NUM_CPUS)]} {
set max_cpus $::env(FLOWTOOL_NUM_CPUS)
}
switch -glob {tempus} {
set_multi_cpu_usage -verbose -local_cpu   $max_cpus
if {[get_feature -feature opt_signoff]} {
if {[is_flow -inside flow:opt_signoff]} {...}
}
if {[get_feature -feature sta_eco]} {...}
}
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/dbs/opt_signoff/init_sta.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/dbs/opt_signoff/init_sta.tcl (pre)
read_mmmc [get_db flow_source_directory]/mmmc_config.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/mmmc_config.tcl (pre)
foreach constraint_mode $mmmc_vars(constraint_modes) {
    create_constraint_mode -name $constraint_mode -sdc_files $mmmc_vars($constraint_mode,sdc_files)
}
array unset tcs
array unset rcs
array unset ocs
foreach dc $mmmc_vars(delay_corners) {
    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # temperature
    set temp_val "0.0"
    if {${temp} == "m40c" || ${temp} == "M40C"} {
        set temp_val "-40.0"
    } elseif {${temp} == "125c" || ${temp} == "125C"} {
        set temp_val "125.0"
    } elseif {${temp} == "25c" || ${temp} == "25C"} {
        set temp_val "25.0"
    } elseif {${temp} == "85c" || ${temp} == "85C"} {
        set temp_val "85.0"
    } else {
        set temp_val "0.0"
    }
    
    # voltage
    set volt_val "0.9"
    set volt_val [regsub {[v|V]} [regsub {[p|P]} $volt "."] ""]
    

    ## LIBRARY SETS
    if {[get_db program_short_name] == "genus"} {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_nldm)
    } elseif {[get_db program_short_name] == "innovus"} {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
    } elseif {[get_db program_short_name] == "tempus"} {
        if {[info exist $mmmc_vars(${dc},timing_lvf)] && [info exist $mmmc_vars(${dc},timing_socv)]} {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_lvf) -socv $mmmc_vars(${dc},timing_socv)
        } else {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
        }
    } elseif {[get_db program_short_name] == "voltus"} {
        if {[info exist $mmmc_vars(${dc},timing_lvf)] && [info exist $mmmc_vars(${dc},timing_socv)]} {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_lvf) -socv $mmmc_vars(${dc},timing_socv)
        } else {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
        }
    } else {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
    }

    ## OPERATING CONDITIONS
    if {![info exists ocs("${volt}_${temp}")]} {
	create_opcond -name "${volt}_${temp}" -process 1.0 -voltage $volt_val -temperature $temp_val
	set ocs("${volt}_${temp}") 1
    }

    ## TIMING CONDITIONS
    if {![info exists tcs("${corn}_${volt}_${temp}")]} {
	create_timing_condition -name "${corn}_${volt}_${temp}" -library_sets "${corn}_${volt}_${temp}_ls" -opcond "${volt}_${temp}"
	set tcs("${corn}_${volt}_${temp}") 1
    }
    
    ## RC CORNERS
    if {![info exists rcs("${rc}_${temp}")]} {
	create_rc_corner -name "${rc}_${temp}" -qrc_tech $mmmc_vars("${rc}_${temp}",qrc_tech) -temperature $mmmc_vars("${rc}_${temp}",temperature)
	set rcs("${rc}_${temp}") 1
    }

    ## DELAY CORNERS
    create_delay_corner -name ${dc} -timing_condition "${corn}_${volt}_${temp}" -rc_corner "${rc}_${temp}"

    ## ANALYSIS VIEWS
    foreach constraint_mode $mmmc_vars(constraint_modes) {
	create_analysis_view -name "${dc}_${constraint_mode}" -delay_corner $dc -constraint_mode $constraint_mode
    }
}
if {[get_db program_short_name] == "genus"} {...
} elseif {[get_db program_short_name] == "innovus"} {...
} else {
set_analysis_view  -setup             [get_db flow_vars_setup_sta_active_views]   -hold              [get_db flow_vars_hold_sta_active_views]   -leakage           [get_db flow_vars_power_view]  -dynamic           [get_db flow_vars_power_view]
}
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/mmmc_config.tcl
set netlist_list [list \
dbs/opt_signoff/datapath_top.v.gz \
]
foreach {blockname blockpath} [array get local_macro_exportdir] {
    lappend netlist_list ${blockpath}/dbs/opt_signoff/${blockname}.v.gz
}
read_netlist "${netlist_list}"
set STA_SIGNOFF 1
init_design
read_power_intent -1801 /home/student/16/ex8/flow_datapath_top_1/constraints/datapath_top.upf
commit_power_intent -verbose
set_db flow_report_name opt_signoff
read_activity_file -format TCF dbs/syn_opt/datapath_top.tcf
set_spef_transform -inst genblk1_0_i_mem_a/i_ram -orient r0 -x_offset 11.5 -y_offset 2635.98
set_spef_transform -inst genblk1_0_i_mem_b/i_ram -orient r0 -x_offset 532.2 -y_offset 2624.85
set_spef_transform -inst genblk1_1_i_mem_a/i_ram -orient my -x_offset 1476.7 -y_offset 2625.415
set_spef_transform -inst genblk1_1_i_mem_b/i_ram -orient my -x_offset 885.3 -y_offset 2275.915
set_spef_transform -inst genblk1_2_i_mem_a/i_ram -orient r0 -x_offset 2119.1 -y_offset 2631.69
set_spef_transform -inst genblk1_2_i_mem_b/i_ram -orient r0 -x_offset 2472.2 -y_offset 2631.69
set_spef_transform -inst genblk1_3_i_mem_a/i_ram -orient mx -x_offset 2564.2 -y_offset 2111.67
set_spef_transform -inst genblk1_3_i_mem_b/i_ram -orient my -x_offset 407.2 -y_offset 1886.39
set_spef_transform -inst genblk1_4_i_mem_a/i_ram -orient r0 -x_offset 19.0 -y_offset 2280.18
set_spef_transform -inst genblk1_4_i_mem_b/i_ram -orient r0 -x_offset 532.2 -y_offset 2271.75
set_spef_transform -inst genblk1_5_i_mem_a/i_ram -orient r0 -x_offset 885.3 -y_offset 2624.85
set_spef_transform -inst genblk1_5_i_mem_b/i_ram -orient r0 -x_offset 1476.7 -y_offset 2265.45
set_spef_transform -inst genblk1_6_i_mem_a/i_ram -orient r0 -x_offset 2042.9 -y_offset 2258.73
set_spef_transform -inst genblk1_6_i_mem_b/i_ram -orient r180 -x_offset 2631.6 -y_offset 1608.99
set_spef_transform -inst genblk1_7_i_mem_a/i_ram -orient r0 -x_offset 992.7 -y_offset 1831.23
set_spef_transform -inst genblk1_7_i_mem_b/i_ram -orient r0 -x_offset 2042.9 -y_offset 1902.93
set_spef_transform -inst genblk1_8_i_mem_a/i_ram -orient r180 -x_offset 2631.6 -y_offset 1253.19
set_spef_transform -inst genblk1_8_i_mem_b/i_ram -orient r0 -x_offset 2042.9 -y_offset 1547.13
set_spef_transform -inst genblk1_9_i_mem_a/i_ram -orient r180 -x_offset 2297.3 -y_offset 366.72
set_spef_transform -inst genblk1_9_i_mem_b/i_ram -orient r180 -x_offset 1944.2 -y_offset 374.22
set_spef_transform -inst genblk1_10_i_mem_a/i_ram -orient r0 -x_offset 2239.6 -y_offset 1188.39
set_spef_transform -inst genblk1_10_i_mem_b/i_ram -orient r180 -x_offset 2077.17 -y_offset 753.32
set_spef_transform -inst genblk1_11_i_mem_a/i_ram -orient mx -x_offset 1519.83 -y_offset 557.34
set_spef_transform -inst genblk1_11_i_mem_b/i_ram -orient mx -x_offset 756.3 -y_offset 654.845
set_spef_transform -inst genblk1_12_i_mem_a/i_ram -orient mx -x_offset 403.2 -y_offset 654.845
set_spef_transform -inst genblk1_12_i_mem_b/i_ram -orient r0 -x_offset 507.9 -y_offset 1026.99
set_spef_transform -inst genblk1_13_i_mem_a/i_ram -orient r0 -x_offset 515.4 -y_offset 1382.79
set_spef_transform -inst genblk1_13_i_mem_b/i_ram -orient r0 -x_offset 884.0 -y_offset 1154.19
set_spef_transform -inst genblk1_14_i_mem_a/i_ram -orient r180 -x_offset 1944.2 -y_offset 18.42
set_spef_transform -inst genblk1_14_i_mem_b/i_ram -orient r180 -x_offset 2646.65 -y_offset 604.1
set_spef_transform -inst genblk1_15_i_mem_a/i_ram -orient r180 -x_offset 2650.4 -y_offset 3.42
set_spef_transform -inst genblk1_15_i_mem_b/i_ram -orient r180 -x_offset 2297.3 -y_offset 10.92
set_spef_transform -inst genblk3_0_i_mul_wrapper_a/i_mul_a -orient my -x_offset 403.2 -y_offset 2864.25
set_spef_transform -inst genblk3_0_i_mul_wrapper_b/i_mul_a -orient r0 -x_offset 405.605 -y_offset 2754.15
set_spef_transform -inst genblk3_0_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 1368.2 -y_offset 2864.25
set_spef_transform -inst genblk3_1_i_mul_wrapper_a/i_mul_a -orient my -x_offset 1238.4 -y_offset 2867.85
set_spef_transform -inst genblk3_1_i_mul_wrapper_b/i_mul_a -orient mx -x_offset 2840.2 -y_offset 2498.31
set_spef_transform -inst genblk3_1_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 2891.05 -y_offset 2760.99
set_spef_transform -inst genblk3_2_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 2396.2 -y_offset 2501.73
set_spef_transform -inst genblk3_2_i_mul_wrapper_b/i_mul_a -orient r180 -x_offset 407.2 -y_offset 1568.07
set_spef_transform -inst genblk3_2_i_mul_wrapper_c/i_mul_a -orient mx -x_offset 1372.2 -y_offset 2040.03
set_spef_transform -inst genblk3_3_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 2876.2 -y_offset 1964.79
set_spef_transform -inst genblk3_3_i_mul_wrapper_b/i_mul_a -orient my -x_offset 407.2 -y_offset 2347.83
set_spef_transform -inst genblk3_3_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 2404.2 -y_offset 2347.83
set_spef_transform -inst genblk3_4_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 409.605 -y_offset 2235.325
set_spef_transform -inst genblk3_4_i_mul_wrapper_b/i_mul_a -orient my -x_offset 1364.2 -y_offset 2344.41
set_spef_transform -inst genblk3_4_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 1240.805 -y_offset 2755.345
set_spef_transform -inst genblk3_5_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 884.2 -y_offset 2074.23
set_spef_transform -inst genblk3_5_i_mul_wrapper_b/i_mul_a -orient r0 -x_offset 1904.2 -y_offset 2255.49
set_spef_transform -inst genblk3_5_i_mul_wrapper_c/i_mul_a -orient r180 -x_offset 1899.2 -y_offset 2040.03
set_spef_transform -inst genblk3_6_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 2404.2 -y_offset 2040.03
set_spef_transform -inst genblk3_6_i_mul_wrapper_b/i_mul_a -orient my -x_offset 1349.505 -y_offset 2755.345
set_spef_transform -inst genblk3_6_i_mul_wrapper_c/i_mul_a -orient r180 -x_offset 1363.2 -y_offset 1557.81
set_spef_transform -inst genblk3_7_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 1904.2 -y_offset 1557.81
set_spef_transform -inst genblk3_7_i_mul_wrapper_b/i_mul_a -orient mx -x_offset 2894.8 -y_offset 471.725
set_spef_transform -inst genblk3_7_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 2891.05 -y_offset 2648.485
set_spef_transform -inst genblk3_8_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 2444.2 -y_offset 1728.81
set_spef_transform -inst genblk3_8_i_mul_wrapper_b/i_mul_a -orient mx -x_offset 1900.2 -y_offset 1332.09
set_spef_transform -inst genblk3_8_i_mul_wrapper_c/i_mul_a -orient mx -x_offset 2484.2 -y_offset 1075.59
set_spef_transform -inst genblk3_9_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 2891.05 -y_offset 959.9
set_spef_transform -inst genblk3_9_i_mul_wrapper_b/i_mul_a -orient r180 -x_offset 1408.725 -y_offset 561.505
set_spef_transform -inst genblk3_9_i_mul_wrapper_c/i_mul_a -orient my -x_offset 395.2 -y_offset 1373.13
set_spef_transform -inst genblk3_10_i_mul_wrapper_a/i_mul_a -orient my -x_offset 1813.085 -y_offset 968.8
set_spef_transform -inst genblk3_10_i_mul_wrapper_b/i_mul_a -orient r180 -x_offset 403.2 -y_offset 548.91
set_spef_transform -inst genblk3_10_i_mul_wrapper_c/i_mul_a -orient my -x_offset 1264.085 -y_offset 939.435
set_spef_transform -inst genblk3_11_i_mul_wrapper_a/i_mul_a -orient r180 -x_offset 879.2 -y_offset 548.91
set_spef_transform -inst genblk3_11_i_mul_wrapper_b/i_mul_a -orient my -x_offset 399.2 -y_offset 1024.29
set_spef_transform -inst genblk3_11_i_mul_wrapper_c/i_mul_a -orient mx -x_offset 625.41 -y_offset 548.91
set_spef_transform -inst genblk3_12_i_mul_wrapper_a/i_mul_a -orient mx -x_offset 514.305 -y_offset 548.91
set_spef_transform -inst genblk3_12_i_mul_wrapper_b/i_mul_a -orient r0 -x_offset 1380.2 -y_offset 1229.49
set_spef_transform -inst genblk3_12_i_mul_wrapper_c/i_mul_a -orient r180 -x_offset 734.11 -y_offset 548.91
set_spef_transform -inst genblk3_13_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 884.2 -y_offset 1041.39
set_spef_transform -inst genblk3_13_i_mul_wrapper_b/i_mul_a -orient mx -x_offset 2764.395 -y_offset 491.595
set_spef_transform -inst genblk3_13_i_mul_wrapper_c/i_mul_a -orient my -x_offset 372.1 -y_offset 2523.18
set_spef_transform -inst genblk3_14_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 2432.675 -y_offset 755.725
set_spef_transform -inst genblk3_14_i_mul_wrapper_b/i_mul_a -orient mx -x_offset 2783.695 -y_offset 366.72
set_spef_transform -inst genblk3_14_i_mul_wrapper_c/i_mul_a -orient mx -x_offset 2716.6 -y_offset 2521.555
set_spef_transform -inst genblk3_15_i_mul_wrapper_a/i_mul_a -orient r0 -x_offset 2894.8 -y_offset 361.625
set_spef_transform -inst genblk3_15_i_mul_wrapper_b/i_mul_a -orient r180 -x_offset 403.2 -y_offset 2641.61
set_spef_transform -inst genblk3_15_i_mul_wrapper_c/i_mul_a -orient r0 -x_offset 2852.2 -y_offset 2871.09
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/dbs/opt_signoff/init_sta.tcl
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/flow_attributes.tcl (pre)
set flow_vars [dict create]
dict lappend flow_vars flow_vars_data_directory                                 description   "Path to the input data"
dict lappend flow_vars flow_vars_data_directory                                 type          string
dict lappend flow_vars flow_vars_data_directory                                 default       ""
dict lappend flow_vars flow_vars_dft_data_directory                             description   "Path to the DFT input data"
dict lappend flow_vars flow_vars_dft_data_directory                             type          string
dict lappend flow_vars flow_vars_dft_data_directory                             default       ""
dict lappend flow_vars flow_vars_dft_library                                    description   "Path to the DFT std cell library"
dict lappend flow_vars flow_vars_dft_library                                    type          string
dict lappend flow_vars flow_vars_dft_library                                    default       ""
dict lappend flow_vars flow_vars_dft_ncsim_library                              description   "Path to the DFT include library"
dict lappend flow_vars flow_vars_dft_ncsim_library                              type          string
dict lappend flow_vars flow_vars_dft_ncsim_library                              default       ""
dict lappend flow_vars flow_vars_memory_path                                    description   "Path to memory libs"
dict lappend flow_vars flow_vars_memory_path                                    type          string
dict lappend flow_vars flow_vars_memory_path                                    default       ""
dict lappend flow_vars flow_vars_stdcell_path                                   description   "Path to stdcell libs"
dict lappend flow_vars flow_vars_stdcell_path                                   type          string
dict lappend flow_vars flow_vars_stdcell_path                                   default       ""
dict lappend flow_vars flow_vars_qrc_tech_directory                             description   "Path to qrc technology directory"
dict lappend flow_vars flow_vars_qrc_tech_directory                             type          string
dict lappend flow_vars flow_vars_qrc_tech_directory                             default       ""
dict lappend flow_vars flow_vars_lef_tech_file                                  description   "Path to lef technology file"
dict lappend flow_vars flow_vars_lef_tech_file                                  type          string
dict lappend flow_vars flow_vars_lef_tech_file                                  default       ""
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              description   "Path to PVS DRC rule file"
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          description   "Path to Pegasus DRC rule file"
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              description   "Path to PVS LVS rule file"
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          description   "Path to PEGASUS LVS rule file"
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          description   "Path to PVS antenna rule file"
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          type          string
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          default       ""
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      description   "Path to Pegasus antenna rule file"
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      type          string
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      default       ""
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       description   "Path to PVS metal fill rule file"
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       type          string
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   description   "Path to PEGASUS metal fill rule file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   default       ""
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        description   "Path to PVS FEOL fill rule file"
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        type          string
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        default       ""
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    description   "Path to PEGASUS FEOL fill rule file"
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    type          string
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    default       ""
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         type          string
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      description   "Path to PEGASUS metal fill stream out map file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      default       ""
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          description   "Path to stream in map file"
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          type          string
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          default       ""
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         type          string
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         default       ""
dict lappend flow_vars flow_vars_ict_em_models                                  description   "Path to ict em models"
dict lappend flow_vars flow_vars_ict_em_models                                  type          string
dict lappend flow_vars flow_vars_ict_em_models                                  default       ""
dict lappend flow_vars flow_vars_rtl_root_dir                                   description   "Design RTL root directory"
dict lappend flow_vars flow_vars_rtl_root_dir                                   type          string
dict lappend flow_vars flow_vars_rtl_root_dir                                   default       ""
dict lappend flow_vars flow_vars_design_name                                    description   "Top level design name"
dict lappend flow_vars flow_vars_design_name                                    type          string
dict lappend flow_vars flow_vars_design_name                                    default       ""
dict lappend flow_vars flow_vars_design_top                                     description   "Top entity name to be elaborated"
dict lappend flow_vars flow_vars_design_top                                     type          string
dict lappend flow_vars flow_vars_design_top                                     default       ""
dict lappend flow_vars flow_vars_power_intent                                   description   "Path to the power intent file"
dict lappend flow_vars flow_vars_power_intent                                   type          string
dict lappend flow_vars flow_vars_power_intent                                   default       ""
dict lappend flow_vars flow_vars_floorplan_def                                  description   "Path to the floorplan def file"
dict lappend flow_vars flow_vars_floorplan_def                                  type          string
dict lappend flow_vars flow_vars_floorplan_def                                  default       ""
dict lappend flow_vars flow_vars_tcf_file                                       description   "Path to the activity file generated by joules"
dict lappend flow_vars flow_vars_tcf_file                                       type          string
dict lappend flow_vars flow_vars_tcf_file                                       default       ""
dict lappend flow_vars flow_vars_bist_signals                                   description   "Generated verilog file which specifies bist signal connectivity"
dict lappend flow_vars flow_vars_bist_signals                                   type          string
dict lappend flow_vars flow_vars_bist_signals                                   default       ""
dict lappend flow_vars flow_vars_scan_abstracts                                 description   "Subblock scan abstract file paths"
dict lappend flow_vars flow_vars_scan_abstracts                                 type          string
dict lappend flow_vars flow_vars_scan_abstracts                                 default       ""
dict lappend flow_vars flow_vars_elaboration_parameters                         description   "Design toplevel parameters"
dict lappend flow_vars flow_vars_elaboration_parameters                         type          string
dict lappend flow_vars flow_vars_elaboration_parameters                         default       ""
dict lappend flow_vars flow_vars_constraint_modes                               description   "Define the list of constraint modes"
dict lappend flow_vars flow_vars_constraint_modes                               type          string
dict lappend flow_vars flow_vars_constraint_modes                               default       ""
dict lappend flow_vars flow_vars_setup_synth_active_views                       description   "Define the list of setup active analysis views for Synthesis"
dict lappend flow_vars flow_vars_setup_synth_active_views                       type          string
dict lappend flow_vars flow_vars_setup_synth_active_views                       default       ""
dict lappend flow_vars flow_vars_setup_pnr_active_views                         description   "Define the list of setup active analysis views for P&R"
dict lappend flow_vars flow_vars_setup_pnr_active_views                         type          string
dict lappend flow_vars flow_vars_setup_pnr_active_views                         default       ""
dict lappend flow_vars flow_vars_setup_sta_active_views                         description   "Define the list of setup active analysis views for STA"
dict lappend flow_vars flow_vars_setup_sta_active_views                         type          string
dict lappend flow_vars flow_vars_setup_sta_active_views                         default       ""
dict lappend flow_vars flow_vars_hold_views                                     description   "Define the list of hold analysis views"
dict lappend flow_vars flow_vars_hold_views                                     type          string
dict lappend flow_vars flow_vars_hold_views                                     default       ""
dict lappend flow_vars flow_vars_hold_pnr_active_views                          description   "Define the list of hold active analysis views for P&R"
dict lappend flow_vars flow_vars_hold_pnr_active_views                          type          string
dict lappend flow_vars flow_vars_hold_pnr_active_views                          default       ""
dict lappend flow_vars flow_vars_hold_sta_active_views                          description   "Define the list of hold active analysis views for STA"
dict lappend flow_vars flow_vars_hold_sta_active_views                          type          string
dict lappend flow_vars flow_vars_hold_sta_active_views                          default       ""
dict lappend flow_vars flow_vars_power_view                                     description   "Define the power analysis view"
dict lappend flow_vars flow_vars_power_view                                     type          string
dict lappend flow_vars flow_vars_power_view                                     default       ""
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            description   "Define the the list of different VTs that should be loaded in the tool"
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            type          string
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            default       ""
dict lappend flow_vars flow_vars_lef_list                                       description   "Lef file list definition"
dict lappend flow_vars flow_vars_lef_list                                       type          string
dict lappend flow_vars flow_vars_lef_list                                       default       ""
dict lappend flow_vars flow_vars_stdcell_gds_list                               description   "Stdcell GDS file list definition"
dict lappend flow_vars flow_vars_stdcell_gds_list                               type          string
dict lappend flow_vars flow_vars_stdcell_gds_list                               default       ""
dict lappend flow_vars flow_vars_stdcell_spi_list                               description   "Stdcell SPICE file list definition"
dict lappend flow_vars flow_vars_stdcell_spi_list                               type          string
dict lappend flow_vars flow_vars_stdcell_spi_list                               default       ""
dict lappend flow_vars flow_vars_memory_gds_list                                description   "Memory GDS file list definition"
dict lappend flow_vars flow_vars_memory_gds_list                                type          string
dict lappend flow_vars flow_vars_memory_gds_list                                default       ""
dict lappend flow_vars flow_vars_memory_spi_list                                description   "Memory SPICE file list definition"
dict lappend flow_vars flow_vars_memory_spi_list                                type          string
dict lappend flow_vars flow_vars_memory_spi_list                                default       ""
dict lappend flow_vars flow_vars_io_gds_list                                    description   "IO GDS file list definition"
dict lappend flow_vars flow_vars_io_gds_list                                    type          string
dict lappend flow_vars flow_vars_io_gds_list                                    default       ""
dict lappend flow_vars flow_vars_io_spi_list                                    description   "IO SPICE file list definition"
dict lappend flow_vars flow_vars_io_spi_list                                    type          string
dict lappend flow_vars flow_vars_io_spi_list                                    default       ""
dict lappend flow_vars flow_vars_macro_gds_list                                 description   "Macro GDS file list definition"
dict lappend flow_vars flow_vars_macro_gds_list                                 type          string
dict lappend flow_vars flow_vars_macro_gds_list                                 default       ""
dict lappend flow_vars flow_vars_macro_spi_list                                 description   "Macro SPICE file list definition"
dict lappend flow_vars flow_vars_macro_spi_list                                 type          string
dict lappend flow_vars flow_vars_macro_spi_list                                 default       ""
dict lappend flow_vars flow_vars_dont_use_list                                  description   "dont_use cell list definition"
dict lappend flow_vars flow_vars_dont_use_list                                  type          string
dict lappend flow_vars flow_vars_dont_use_list                                  default       ""
dict lappend flow_vars flow_vars_sdf_list                                       description   "Macro SDF file list definition"
dict lappend flow_vars flow_vars_sdf_list                                       type          string
dict lappend flow_vars flow_vars_sdf_list                                       default       ""
dict lappend flow_vars flow_vars_voltus_file_list                               description   "Voltus file list definition"
dict lappend flow_vars flow_vars_voltus_file_list                               type          string
dict lappend flow_vars flow_vars_voltus_file_list                               default       ""
foreach myAttr [dict keys $flow_vars] {
  if { ![is_attribute -obj_type root $myAttr]} {
    define_attribute $myAttr \
      -category user_flow \
      -data_type [dict get $flow_vars $myAttr type] \
      -default [dict get $flow_vars $myAttr default] \
      -help_string [dict get $flow_vars $myAttr description] \
      -obj_type root
    }
}
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/flow_attributes.tcl
#@ Begin verbose source scripts/design_setup.tcl (pre)
set_db flow_vars_data_directory                             [exec pwd]
set_db flow_vars_rtl_root_dir                               .
set_db flow_vars_design_name                                $env(MODULE_NAME)
set_db flow_vars_design_top                                 $env(MODULE_NAME)
set_db flow_vars_power_intent                               "[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].upf"
set_db flow_vars_floorplan_def                              "[get_db flow_vars_data_directory]/floorplan_def/[get_db flow_vars_design_name].def.gz"
set_db flow_vars_tcf_file				    [list /userwork8/tlehtine/projects/ML/sim/mem_pow_test/sim_out_read_1GHz.vcd tb_top.i_dut]
set_db flow_vars_bist_signals                               ""
set_db flow_vars_elaboration_parameters                     ""
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
set_db flow_vars_power_view                                 [lindex [get_db flow_vars_setup_synth_active_views] 0]
#@ End verbose source scripts/design_setup.tcl
#@ Begin verbose source scripts/tech_setup.tcl (pre)
set TECHNOLOGY "gpdk045"
set TECH_SETUP_VERSION "v1.0"
puts "Info: TECHNOLOGY SETUP: $TECHNOLOGY : $TECH_SETUP_VERSION"
set_db flow_vars_lef_tech_file                             "/opt/soc/tech/GPDK045/gsclib045/lef/gsclib045_tech.lef"
set_db flow_vars_qrc_tech_directory                        "/opt/soc/tech/GPDK045/gsclib045/qrc"
set_db flow_vars_gdsout_stream_map_file                    "/opt/soc/tech/GPDK045/gsclib045/oa22/gsclib045/gsclib045.layermap"
set tech_lef_filelist [list ]
lappend tech_lef_filelist                                   [get_db flow_vars_lef_tech_file]
set_db flow_vars_lef_list $tech_lef_filelist
#@ End verbose source scripts/tech_setup.tcl
#@ Begin verbose source scripts/mmmc_setup.tcl (pre)
set MMMC_SETUP_VERSION "v1.0"
puts "Info: MMMC SETUP: $TECHNOLOGY : $MMMC_SETUP_VERSION"
set mmmc_vars(delay_corners) \
    [list \
	 slow_0p9v_125c_cmax \
	 fast_1p1v_0c_cmin \
	 ]
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # qrc techfile
    set mmmc_vars("${rc}_${temp}",qrc_tech) "[get_db flow_vars_qrc_tech_directory]/gpdk045.tch"
    # temperature
    if {${temp} == "m40c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "-40"
    } elseif {${temp} == "125c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "125"
    } elseif {${temp} == "0c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "0"
    } else {
	set mmmc_vars("${rc}_${temp}",temperature) "25"
    }


    ###########################################
    # OCVs &  Clock uncertainties for FLAT OCV
    ###########################################

    # use following uncertainties
    # FUNC:
    # setup:
    # clock jitter: defined through clock cycle
    # TECH uncertainty: 25ps
    # extra uncertainty (implementation): 20ps
    # extra uncertainty (signoff STA): 0ps
    # hold:
    # TECH uncertainty (SSG): 50ps
    # TECH uncertainty (fast): 40ps
    # extra uncertainty (implementation): 15ps
    # extra uncertainty (signoff STA): 0ps

    # Note, add 1% OCV on top of previous to match LVF
    # so flat values below have 0.01 added (subtracted) because of this

    # setup in slow, 0.81v, -40C/125c, cmax
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	($rc eq "cmax")} {
	
	# -2.0% + -3.7% (10mV V-margin) + -0.6% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.927"
	# +2.0% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.03"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_cell_early)   "1.0"
	# + 6.9% on data cell
	set mmmc_vars(${dc},flat_data_cell_late)    "1.079"

	# -6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.93"
	# +6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.07"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# +6.0 for data net
	set mmmc_vars(${dc},flat_data_net_late)    "1.07"

    # hold in slow, 0.81v, -40c/125c, cmax
    } elseif {$corn eq "slow" &&
	      $volt eq "0p9v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.2% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.882"
	# +3.2% for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.042"
	# -9.7% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.817"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmax
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.103"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmin
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmin")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.083"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# no derate on launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "1.0"
	# +8.5% for capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.075"
	# no derate for data net
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    } else {
	puts "Fatal: delay corner ${dc} OCVs not defined (corner: $corn, voltage: $volt, temperature: $temp, rc: ${rc})"
	exit 1
    }

    ###########################################
    # OCVs &  Clock uncertainties for SOCV
    ###########################################

    # Note, only voltage and temperature OCVs needed

    # Early & late variation factors from:
    set mmmc_vars(early_rc_variation_factor) 0.06
    set mmmc_vars(late_rc_variation_factor) 0.06

    set mmmc_vars(timing_socv_analysis_nsigma_multiplier) 3

    # slow, 0.81v, -40c
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "m40c"} {
        
        # DATA  @ 20.3mV : 7.4%
        # DATA  @ 10c    : 0.9%
        # CLOCK @ 20.3mV : 5.4%
        # CLOCK @ 10c    : 0.7%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.054"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.061"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.083"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "125c"} {
       
        # DATA  @ 20.3mV : 5.0%
        # DATA  @ 10c    : 0.3%
        # CLOCK @ 20.3mV : 3.5%
        # CLOCK @ 10c    : 0.2%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.037"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.037"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.053"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "0c"} {
       
        # DATA  @ 20.3mV : 6.6%
        # DATA  @ 10c    : 0.8%
        # CLOCK @ 20.3mV : 4.9%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.055"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.055"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "m40c"} {
       
        # DATA  @ 45mV   : 7.4%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 5.1%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.057"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.057"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.079"

     } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "125c"} {

        # DATA  @ 45mV   : 5.8%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 3.6%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.042"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.042"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.063"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "0c"} {

        # DATA  @ 45mV   : 7.0%
        # DATA  @ 10c    : 0.4%
        # CLOCK @ 45mV   : 4.7%
        # CLOCK @ 10c    : 0.4%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.051"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.051"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

     } else {
        puts "Fatal: corner / voltage / temperature combination not allowed (corner: $corn, voltage: $volt, temperature: $temp)"
        exit 1
    }
}
set mmmc_vars(constraint_modes) [get_db flow_vars_constraint_modes]
foreach cm $mmmc_vars(constraint_modes) {
    if {[get_db program_short_name] == "genus"} {
#	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
#	} else {
#	    set mmmc_vars(${cm},sdc_files) [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.dummy.tcl
#	}
    } else {
	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.hier_dft.tcl \
						]
	} else {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
	}
    }
}
#@ End verbose source scripts/mmmc_setup.tcl
#@ Begin verbose source scripts/library_setup.tcl (pre)
set PROJECT "Ballast"
set LIBRARY_SETUP_VERSION "v1.0"
puts "Info: LIBRARY SETUP: $PROJECT : $LIBRARY_SETUP_VERSION"
set_db flow_vars_stdcell_path                               "/opt/soc/tech/GPDK045/gsclib045"
set_db flow_vars_dft_data_directory                         [exec pwd]/dft_lib
set_db flow_vars_dft_library                                "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"
set_db flow_vars_dft_ncsim_library                          "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"
set_db flow_vars_dont_use_list                              [list "{.name==*FOOFOO*}" "{.name==*FIIFAA*}" ]
set io_lef_filelist [list ]
set io_gds_filelist [list ]
set io_spi_filelist [list ]
lappend io_lef_filelist ""
lappend io_gds_filelist ""
lappend io_spi_filelist ""
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $io_lef_filelist]
set_db flow_vars_io_gds_list $io_gds_filelist
set_db flow_vars_io_spi_list $io_spi_filelist
set stdcell_lef_filelist [list ]
set stdcell_gds_filelist [list ]
set stdcell_spi_filelist [list ]
lappend stdcell_lef_filelist [get_db flow_vars_stdcell_path]/lef/gsclib045_macro.lef
lappend stdcell_gds_filelist /opt/soc/tech/GPDK045/gsclib045/gds/gsclib045.gds
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $stdcell_lef_filelist]
set_db flow_vars_stdcell_gds_list $stdcell_gds_filelist
set_db flow_vars_stdcell_spi_list $stdcell_spi_filelist
foreach dc $mmmc_vars(delay_corners) {
    set mmmc_vars(${dc},timing_nldm) [list \
                                         ]
    set mmmc_vars(${dc},timing_ecsm) [list \
                                         ]
    if {[regexp {slow} $dc]} {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
    } else {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
    }
}
#@ End verbose source scripts/library_setup.tcl
#@ Begin verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/global_macro_setup.tcl (pre)
set MACRO_SETUP_VERSION "v1.0"
puts "Info: MACRO SETUP: $MACRO_SETUP_VERSION"
array set global_macro_exportdir {
}
set ip_lef_filelist [list ]
lappend ip_lef_filelist ""
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $ip_lef_filelist]
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # PLL .lib
    lappend mmmc_vars(${dc},timing_nldm) ""
    lappend mmmc_vars(${dc},timing_ecsm) ""
    lappend mmmc_vars(${dc},timing_lvf) ""
}
#@ End verbose source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/global_macro_setup.tcl
#@ Begin verbose source scripts/local_macro_setup.tcl (pre)
if {1} {
array unset global_macro_exportdir
set macro_scan_abstract_filelist [list ]
set macro_lef_filelist [list ]
array set local_macro_exportdir {
    matmul_sync "../flow_matmul_sync_1"
}
array set memarray {
    256x32 "IN22FDX_S1DU_BFUG_W00256B032M04C128"
}
foreach {blockname blockpath} [array get global_macro_exportdir] {

    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT"
	continue
    }

    if {[info exists local_macro_exportdir($blockname)]} {
	if {[string compare $blockpath $local_macro_exportdir($blockname)]} {
	    puts "Warning([info script]): Overriding global setting for $blockname ->"
	    puts "\#OLD\#: $blockpath"
	    puts "\#NEW\#: $local_macro_exportdir($blockname)"
	    set $blockpath $local_macro_exportdir($blockname)
	}
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } elseif {[file exists $blockpath/models/cts/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/cts/$blockname.lef
    } elseif {[file exists $blockpath/models/floorplan/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/floorplan/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/{opt_signoff|cts|floorplan}"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/{opt_signoff.sta|cts|floorplan}"
	    exit 1
	}
    }
}
foreach {blockname blockpath} [array get local_macro_exportdir] {
    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT. Remove the definition from local macro settings!"
	continue
    }

    set found 0
    if {[info exists global_macro_exportdir($blockname)]} {
	set found 1
    }

    if {!$found} {
	puts "Warning([info script]): Global setting for $blockname set in local setting not found from global settings! Report this to project toplevel!"	
    } else {
	# it was found so it's already set
	continue
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } elseif {[file exists $blockpath/models/cts/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/cts/$blockname.lef
    } elseif {[file exists $blockpath/models/floorplan/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/floorplan/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/{opt_signoff|cts|floorplan}"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

        puts "corn volt temp rc: ${corn}_${volt}_${temp}_${rc}"

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/cts/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} elseif {[file exists $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/floorplan/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/{opt_signoff.sta|cts|floorplan}"
	    exit 1
	}
    }
}
set memory_gds_filelist [list]
set memory_spi_filelist [list]
foreach {memdir memlist} [array get memarray] {

    set mem_directory ./models
    puts "Info: setting mem_directory as $mem_directory"
    foreach mem $memlist {

        lappend macro_lef_filelist ${mem_directory}/${mem}.lef

        # lappend macro_scan_abstract_filelist ${mem_directory}/${mem}/${mem}.ctl
        #lappend dft_library ${mem_directory}/model/verilog/${mem}.v
        #lappend dft_ncsim_library ${mem_directory}/model/verilog/${mem}.v

        #lappend memory_gds_filelist ${mem_directory}/gds/${mem}.gds

        #lappend memory_spi_filelist ${mem_directory}/cdl/${mem}.cdl

        foreach dc $mmmc_vars(delay_corners) {

	    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	    puts "Info: Adding NLDM: ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib"
            lappend mmmc_vars(${dc},timing_nldm) ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib
            lappend mmmc_vars(${dc},timing_ecsm) ${mem_directory}/${mem}.${corn}_${volt}_${temp}_${rc}_func.lib
            #lappend mmmc_vars(${dc},timing_lvf) ${mem_directory}/${mem}/${mem}_${corn}g_${rc}_${volt}_${volt}_${temp}.lib_ecsm_tv
        }
    }
}
puts "Info: Adding macro info to flow_vars_lef_list in [info script]"
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $macro_lef_filelist]
set pll_idx [lsearch -regexp [get_db flow_vars_lef_list] {CLKPLL}]
set_db flow_vars_lef_list [lreplace [get_db flow_vars_lef_list] $pll_idx $pll_idx]
puts "Info: re-writing flow_vars_scan_abstracts in [info script]"
set_db flow_vars_scan_abstracts $macro_scan_abstract_filelist
}
#@ End verbose source scripts/local_macro_setup.tcl
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -merge -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/sta -previous a15a5787-5cd5-417d-8bc5-7cc2a2a5cbb9
set db [get_db flow_starting_db]
set flow [lindex [get_db flow_hier_path] end]
set setup_views [get_feature $flow -feature setup_views]
set hold_views [get_feature $flow -feature hold_views]
set leakage_view [get_feature $flow -feature leakage_view]
set dynamic_view [get_feature $flow -feature dynamic_view]
if {($setup_views ne "") || ($hold_views ne "") || ($leakage_view ne "") || ($dynamic_view ne "")} {...}
if {[info exists ::env(FLOWTOOL_NUM_CPUS)]} {
set max_cpus $::env(FLOWTOOL_NUM_CPUS)
}
switch -glob {tempus} {
set_multi_cpu_usage -verbose -local_cpu   $max_cpus
if {[get_feature -feature opt_signoff]} {
if {[is_flow -inside flow:opt_signoff]} {...}
}
if {[get_feature -feature sta_eco]} {...}
}
#@ (flow_step:signoff_start)  2:     #- Extend flow report name based on context
#@ (flow_step:signoff_start)  3:     if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
#@                             : 	if {![regexp {sta$} [get_db flow_report_name]]} {
#@                             : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "sta" : "[get_db flow_report_name].sta"}]
#@                             : 	}
#@                             :     } elseif {[is_flow -quiet -inside flow:ir_early_static] || [is_flow -quiet -inside flow:ir_early_dynamic]} {
#@                             : 	if {![regexp {era$} [get_db flow_report_name]]} {
#@                             : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "era" : "[get_db flow_report_name].era"}]
#@                             : 	}
#@                             :     } elseif {[is_flow -quiet -inside flow:ir_grid] || [is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
#@                             : 	if {![regexp {ir$} [get_db flow_report_name]]} {
#@                             : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "ir" : "[get_db flow_report_name].ir"}]
#@                             : 	}
#@                             :     } elseif {[regexp {block_start|hier_start|eco_start} [get_db flow_step_current]]} {
#@                             : 	set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
#@                             :     } else {
#@                             :     }
#@ (flow_step:signoff_start) 20:     #- Create report directory (if necessary)
#@ (flow_step:signoff_start) 21:     file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
set_db design_process_node                        22
set_db timing_report_fields                               {timing_point net edge cell user_derate transition load delay arrival annotation}
set_db si_aggressor_alignment                             timing_aware_edge       
set_table_style -no_frame_fix_width -nosplit
set_db delaycal_enable_si                         true
set_db delaycal_ewm_type simulation
set_db delaycal_equivalent_waveform_model propagation
set_db delaycal_enable_quiet_receivers_for_hold true
set_db delaycal_advanced_pin_cap_mode true 
set_db delaycal_accurate_receiver_out_load true
set_db timing_analysis_socv                       false
set_db timing_analysis_cppr                       both
set_db timing_analysis_type                       ocv
set_db timing_socv_rc_variation_mode                      false
set_db timing_disable_retime_clock_path_slew_propagation false
if {[get_feature -feature sta_eco]} {...}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
foreach dpo [get_db analysis_views] {
	set dpo_latency_file [file join [get_db flow_db_directory]/latency_files [get_db $dpo .name]_latency.sdc]
	if {[file exists $dpo_latency_file]} {
	    update_analysis_view -name [get_db $dpo .name] -latency_file $dpo_latency_file
	} else {
            puts "Warning: Could not find latency file for view: [get_db $dpo .name] in [get_db flow_db_directory]/latency_files"
            puts "Note: Using different view for latency"
            if {[regexp {^ss_0p81v.*worst_T_(\w+)$} [get_db $dpo .name] -> mode_name]} {
                set new_dpo_name ss_0p81v_m40c_rcworst_T_${mode_name}
                set dpo_latency_file [file join [get_db flow_db_directory]/latency_files ${new_dpo_name}_latency.sdc]
            } elseif {[regexp {^ss_0p81v.*worst_(\w+)$} [get_db $dpo .name] -> mode_name]} {
                set new_dpo_name ss_0p81v_m40c_rcworst_${mode_name}
                set dpo_latency_file [file join [get_db flow_db_directory]/latency_files ${new_dpo_name}_latency.sdc]
            } elseif {[regexp {^ff_0p99v.*best_(\w+)$} [get_db $dpo .name] -> mode_name]} {
                set new_dpo_name ff_0p99v_125c_cbest_${mode_name}
                set dpo_latency_file [file join [get_db flow_db_directory]/latency_files ${new_dpo_name}_latency.sdc]
            } elseif {[regexp {^ff_0p99v.*worst_(\w+)$} [get_db $dpo .name] -> mode_name]} {
                set new_dpo_name ff_0p99v_125c_cbest_${mode_name}
                set dpo_latency_file [file join [get_db flow_db_directory]/latency_files ${new_dpo_name}_latency.sdc]
            }
                
            if {[file exists $dpo_latency_file]} {
                update_analysis_view -name [get_db $dpo .name] -latency_file $dpo_latency_file
            } else {
                puts "Error: Could not map [get_db $dpo .name] to latency file $dpo_latency_file"
            }
        }
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
set_interactive_constraint_modes [all_constraint_modes -active]
set_propagated_clock [all_clocks]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {...
} else {
set views [get_db -u analysis_views -if {.is_setup || .is_hold || .is_leakage}]
set decoupled ""
}
set spef_dir  [file normalize [file join [get_db flow_working_directory] [get_db flow_db_directory] [file rootname [get_db flow_report_name]]]]
puts "Info: Using SPEF-dir: $spef_dir"
set corners [lsort -u [concat [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .late_rc_corner]  [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .early_rc_corner]]]
puts "Info: reading corners $corners"
foreach corner $corners {
        set rcc_name [get_db ${corner} .name]

        set spef_list [list ${spef_dir}/[get_db flow_vars_design_name].${rcc_name}.spef.gz]
        # subblock SPEFs
        foreach {blockname blockpath} [array get local_macro_exportdir] {
            puts "Info: Reading subblock SPEF ${blockpath}/dbs/opt_signoff/${blockname}.${rcc_name}.spef.gz"
            lappend spef_list ${blockpath}/dbs/opt_signoff/${blockname}.${rcc_name}.spef.gz
        }
        puts "Info: read_spef \"${spef_list}\" -rc_corner $rcc_name"
        read_spef "${spef_list}" -rc_corner $rcc_name
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {0} {...}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
global mmmc_vars
foreach active_av [get_db [get_db analysis_views -if {.is_setup || .is_hold}] .name] {
	# SOCV RC variation
	set_socv_rc_variation_factor -view ${active_av} -late  $mmmc_vars(late_rc_variation_factor)
	set_socv_rc_variation_factor -view ${active_av} -early $mmmc_vars(early_rc_variation_factor)

    }
set_socv_reporting_nsigma_multiplier -hold $mmmc_vars(timing_socv_analysis_nsigma_multiplier)  -setup $mmmc_vars(timing_socv_analysis_nsigma_multiplier) -views [get_db [get_db analysis_views -if {.is_setup || .is_hold}] .name]
foreach dc [get_db [get_db delay_corners] .name] {
        regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

        # If rc-corner name ends in _T it is a setup corner
        if {[regexp {_T$} $rc]} {
            # For setup only derate capturing clock -> early
            set_timing_derate -add -clock -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},socv_clock_cell_early)
        } else {
            if {[regexp {ss} $corn]} {
                # For hold in SS derate launching clock and data
                set_timing_derate -add -data  -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},socv_data_cell_early)
                set_timing_derate -add -clock -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},socv_clock_cell_early)
            } else {
                # For hold in FF only derate capturing clock -> late
                set_timing_derate -add -clock -cell_delay -late  -delay_corner ${dc} $mmmc_vars(${dc},socv_clock_cell_late)
            }
        }
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
update_timing -full
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
check_netlist -out_file        [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.netlist.rpt]
array unset cmode_done
foreach view_dpo [get_db analysis_views -if {.is_active && (.is_setup || .is_hold)}] {
        set cmode [get_db $view_dpo .constraint_mode.name]
        if {![info exists cmode_done($cmode)]} {
            check_timing -view [get_db $view_dpo .name]               > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.timing.${cmode}.rpt]
            set cmode_done($cmode) 1
        } else {
            continue
        }
    }
report_analysis_coverage     > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.coverage.rpt]
report_annotated_parasitics  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.annotation.rpt]
report_clocks                > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report.clocks.rpt]
report_case_analysis         > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report.case_analysis.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
report_timing_summary -checks {setup drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.analysis_summary.rpt]
report_timing_summary -checks {setup drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.view_summary.rpt]
report_timing_summary -checks {setup drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.group_summary.rpt]
report_constraint > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report_constraint.summary.rpt]
report_constraint -late -all_violators -drv_violation_type {max_capacitance max_transition max_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
set_metric -name timing.drv.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
report_timing -max_paths 5   -nworst 1 -path_type endpoint        > [get_db flow_report_directory]/[get_db flow_report_name]/setup.endpoint.rpt
report_timing -max_paths 1   -nworst 1 -path_type full_clock -net > [get_db flow_report_directory]/[get_db flow_report_name]/setup.worst.rpt
report_timing -max_paths 500 -nworst 1 -path_type full_clock      > [get_db flow_report_directory]/[get_db flow_report_name]/setup.gba.rpt
if {[is_flow -quiet -inside flow:sta]} {
report_timing -max_paths 50 -nworst 1 -path_type full_clock -retime path_slew_propagation > [get_db flow_report_directory]/[get_db flow_report_name]/setup.pba.rpt
}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
report_timing_summary -checks {hold drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.analysis_summary.rpt]
report_timing_summary -checks {hold drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.view_summary.rpt]
report_timing_summary -checks {hold drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.group_summary.rpt]
report_constraint -early -all_violators -drv_violation_type {min_capacitance min_transition min_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.all_violators.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
report_timing -early -max_paths 5   -nworst 1 -path_type endpoint        > [get_db flow_report_directory]/[get_db flow_report_name]/hold.endpoint.rpt
report_timing -early -max_paths 1   -nworst 1 -path_type full_clock -net > [get_db flow_report_directory]/[get_db flow_report_name]/hold.worst.rpt
report_timing -early -max_paths 500 -nworst 1 -path_type full_clock      > [get_db flow_report_directory]/[get_db flow_report_name]/hold.gba.rpt
if {[is_flow -quiet -inside flow:sta]} {
report_timing -early -max_paths 50 -nworst 1 -path_type full_clock -retime path_slew_propagation  > [get_db flow_report_directory]/[get_db flow_report_name]/hold.pba.rpt
}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
if {![file exists $out_dir]} {
file mkdir $out_dir
}
write_sdf -recompute_parallel_arcs -delimiter "." -voltage 1.1:1.0:0.9 -temperature 125.0:25.0:-0.0 -process best:worst -target_application verilog ${out_dir}/[get_db current_design .name].verilog.sdf.gz
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): write_db /home/student/16/ex8/flow_datapath_top_1/dbs/sta.enc
#@ (run_flow): push_snapshot_stack
if {[get_db flow_branch] ne ""} {...
} else {
set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
}
close [open $out_dir/post_sta.tcl w]
set_db flow_post_db_overwrite $out_dir/post_sta.tcl
#@ (run_flow): pop_snapshot_stack
