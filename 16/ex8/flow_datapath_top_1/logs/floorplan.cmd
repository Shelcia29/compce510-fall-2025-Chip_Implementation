#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Fri Nov 14 15:46:28 2025                
#                                                     
#######################################################

#@(#)CDS: Innovus v23.15-s106_1 (64bit) 07/16/2025 17:15 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: NanoRoute 23.15-s106_1 NR250707-2219/23_15-UB (database version 18.20.674) {superthreading v2.20}
#@(#)CDS: AAE 23.15-s032 (64bit) 07/16/2025 (Linux 3.10.0-693.el7.x86_64)
#@(#)CDS: CTE 23.15-s037_1 () Jul 16 2025 02:46:10 ( )
#@(#)CDS: SYNTECH 23.15-s011_1 () Jun 23 2025 00:02:58 ( )
#@(#)CDS: CPE v23.15-s089
#@(#)CDS: IQuantus/TQuantus 23.1.1-s476 (64bit) Wed Jul 2 23:22:08 PDT 2025 (Linux 3.10.0-693.el7.x86_64)

if {[catch {init_flow  {flow_script /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl yaml_script {} flow_no_check 0 parent_uuid {} previous_uuid 43ffbc86-9031-4460-91a8-5bb50d088fe3 top_dir /home/student/16/ex8/flow_datapath_top_1 flow_dir . status_file /home/student/16/ex8/flow_datapath_top_1/flow.status.d/floorplan metrics_file /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/floorplan run_tag {} db {cdb /home/student/16/ex8/flow_datapath_top_1/dbs/syn_opt.cdb datapath_top {}} db_is_ref_run 0 branch {} caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} flow {flow flow:block dir . db {cdb dbs/syn_opt.cdb datapath_top {}} branch {} tool innovus caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} uuid 43ffbc86-9031-4460-91a8-5bb50d088fe3 tool_options {} start_step {tool innovus flow flow:block canonical_path {.steps flow:floorplan .steps flow_step:block_start} step flow_step:block_start features {} str floorplan.block_start} process_branch_trunk 1} flow_name flow:block first_step {tool innovus flow flow:block canonical_path {.steps flow:floorplan .steps flow_step:block_start} step flow_step:block_start features {} str floorplan.block_start} interactive 0 interactive_run 0 enabled_features {report_lec synth_spatial pnr_db_handoff add_scan opt_signoff} inject_tcl {} trunk_process 1 aum_upload false tool_options {} overwrite 0 last_step {tool innovus flow flow:block canonical_path {.steps flow:floorplan .steps flow_step:innovus_to_lec} step flow_step:innovus_to_lec features {} str floorplan.innovus_to_lec} log_prefix /home/student/16/ex8/flow_datapath_top_1/logs/floorplan}; run_flow -from {tool innovus flow flow:block canonical_path {.steps flow:floorplan .steps flow_step:block_start} step flow_step:block_start features {} str floorplan.block_start} -to {tool innovus flow flow:block canonical_path {.steps flow:floorplan .steps flow_step:innovus_to_lec} step flow_step:innovus_to_lec features {} str floorplan.innovus_to_lec}} msg]} { puts [concat {Tcl error:} $errorInfo]; set fp [open {/home/student/16/ex8/flow_datapath_top_1/flow.status.d/floorplan} a]; puts $fp {}; puts $fp [list [list script run_tcl status error flow {flow:block} branch {} flow_working_directory {.} flow_starting_db {cdb /home/student/16/ex8/flow_datapath_top_1/dbs/syn_opt.cdb datapath_top {}} {tool_options} {} steps_run [get_db flow_step_canonical_current] msg $msg]]; close $fp; exit 1 };
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/floorplan -previous 43ffbc86-9031-4460-91a8-5bb50d088fe3
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ Begin verbose source (pre): 
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
#@ End verbose source: /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/flow_attributes.tcl
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
switch -glob {innovus} {
set_multi_cpu_usage -verbose -local_cpu   $max_cpus
if {[get_feature -feature opt_signoff]} {
if {[is_flow -inside flow:opt_signoff]} {...}
}
if {[get_feature -feature sta_eco]} {...}
}
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_db /home/student/16/ex8/flow_datapath_top_1/dbs/syn_opt.cdb
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -merge -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/floorplan -previous 43ffbc86-9031-4460-91a8-5bb50d088fe3
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
switch -glob {innovus} {
set_multi_cpu_usage -verbose -local_cpu   $max_cpus
if {[get_feature -feature opt_signoff]} {
if {[is_flow -inside flow:opt_signoff]} {...}
}
if {[get_feature -feature sta_eco]} {...}
}
#@ (flow_step:block_start)  2:     #- Extend flow report name based on context
#@ (flow_step:block_start)  3:     if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
#@                           : 	if {![regexp {sta$} [get_db flow_report_name]]} {
#@                           : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "sta" : "[get_db flow_report_name].sta"}]
#@                           : 	}
#@                           :     } elseif {[is_flow -quiet -inside flow:ir_early_static] || [is_flow -quiet -inside flow:ir_early_dynamic]} {
#@                           : 	if {![regexp {era$} [get_db flow_report_name]]} {
#@                           : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "era" : "[get_db flow_report_name].era"}]
#@                           : 	}
#@                           :     } elseif {[is_flow -quiet -inside flow:ir_grid] || [is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
#@                           : 	if {![regexp {ir$} [get_db flow_report_name]]} {
#@                           : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "ir" : "[get_db flow_report_name].ir"}]
#@                           : 	}
#@                           :     } elseif {[regexp {block_start|hier_start|eco_start} [get_db flow_step_current]]} {
#@                           : 	set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
#@                           :     } else {
#@                           :     }
#@ (flow_step:block_start) 20:     #- Create report directory (if necessary)
#@ (flow_step:block_start) 21:     file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[get_feature -feature report_lec]} {
set_db write_lec_directory_naming_style "fv/%s/[get_db flow_report_name]"
}
set_db init_design_uniquify 1
set_db design_process_node            45
if {[get_feature -feature flow_express]} {...}
set_db design_early_clock_flow              true
set_db write_stream_via_names true
set_db timing_analysis_cppr           both
set_db timing_analysis_type           ocv
set_db timing_report_fields           {timing_point net cell fanout load transition delay incr_delay arrival edge user_derate power_domain}
set_db timing_analysis_async_checks async
set_db timing_apply_default_primary_input_assertion false
set_db delaycal_advanced_node_pin_cap_settings true
set_db delaycal_advanced_pin_cap_mode true
if {[get_feature -feature add_pvs_fill] || [get_feature -feature add_pegasus_beol_fill]} {...}
if {[is_flow -after flow:opt_signoff] || [is_flow -inside flow:opt_signoff]} {...}
if {[is_flow -after flow:route]} {...}
if {0} {...
} else {
set_db delaycal_equivalent_waveform_model               no_propagation
}
set_db si_aggressor_alignment                             timing_aware_edge       
set_db finish_floorplan_active_objs   [list macro soft_blockage core]
set_db floorplan_row_site_height                          even
set_db floorplan_row_site_width                           even
set_db place_detail_legalization_inst_gap                 1 
set_db place_detail_use_no_diffusion_one_site_filler      false                        ;
set_db place_detail_filler_gap_min_gap                    0.2
set_db place_detail_filler_gap_effort                     high
set_db place_global_uniform_density                       true                        ;
set_db place_global_place_io_pins               true
set_db place_detail_use_check_drc               true
set_db add_tieoffs_cells                        [list TIEHI TIELO]
set_db add_tieoffs_max_fanout 32
set_db opt_fix_hold_allow_setup_tns_degradation           true                        ;
set_db opt_fix_hold_verbose                               true                        ;
set_db opt_new_inst_prefix            "[get_db flow_report_name]_"
set_db opt_fix_hold_lib_cells                   [list  ]
set_db opt_fix_fanout_load true
set_db cts_top_fanout_threshold                           2000                        ;
set_db cts_target_skew                          0.15
set_db cts_target_max_transition_time           0.10
set_db cts_buffer_cells                         [list CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8]
set_db cts_inverter_cells                       [list CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8]
set_db cts_clock_gating_cells                   [list TLATNCAX12 TLATNCAX16 TLATNCAX2 TLATNCAX20 TLATNCAX3 TLATNCAX4 TLATNCAX6 TLATNCAX8]
set_db cts_logic_cells                          [get_db [get_db base_cells CLK*] .name]
if {[get_db route_types] ne ""} {...}
set_db cts_use_inverters true
set_db cts_max_fanout 32
set_db opt_leakage_to_dynamic_ratio                 0.5
set_db add_fillers_cells                        [list  DECAP10 DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9  FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8  ]
set_db add_fillers_no_single_site_gap true
set_db add_fillers_cell_name_style                      flat
set_db route_early_global_bottom_routing_layer            [get_db [get_db layers Metal2] .route_index]
set_db route_early_global_top_routing_layer               [get_db [get_db layers Metal11] .route_index]
set_db route_early_global_num_tracks_per_clock_wire     5
set_db route_design_bottom_routing_layer                  [get_db [get_db layers Metal2] .route_index]
set_db route_design_top_routing_layer                     [get_db [get_db layers Metal11] .route_index]
set_db route_design_detail_post_route_swap_via          none
set_db route_design_with_litho_driven                   true
set_db route_design_with_timing_driven                  true
set_db route_design_antenna_pin_limit                   1000
set_db route_design_antenna_cell_name                   ANTENNA
set_db route_design_add_antenna_inst_prefix             "ANTENNA"
set_db route_design_antenna_diode_insertion             true
set_db route_design_detail_fix_antenna                  true
set_db route_design_with_via_in_pin                     1:1 ;
set_db route_design_concurrent_minimize_via_count_effort  high                        ;
set_db route_design_detail_use_multi_cut_via_effort       high                        ;
if {0} {...}
eval_legacy {setNanoRouteMode  -routeExpShieldAddTappingVia true}                     ;
set_db distributed_child_license_checkout_list          tpsxl
set_db opt_signoff_optimize_core_only                   true                                    
set_db opt_signoff_fix_si_slew true
set_db opt_signoff_fix_xtalk   true
set_db opt_signoff_fix_glitch  true
set_db opt_signoff_fix_hold_allow_setup_optimization      true                        ;
set_db opt_signoff_fix_hold_allow_setup_tns_degrade       true                        ;
set_db opt_signoff_retime                               path_slew_propagation
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[file exists floorplan_def/[get_db flow_vars_design_name].pso]} {...}
if {![get_feature pnr_db_handoff]} {...}
if {![llength [get_db route_rules ndr_cts_2w25s_leaf]]} {...}
if {![llength [get_db route_rules ndr_cts_2w25s_trunk]]} {...}
create_route_type -name cts_route_type_top -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_trunk -top_preferred_layer 9 -bottom_preferred_layer 8 -shield_net VSS
create_route_type -name cts_route_type_trunk -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_trunk -top_preferred_layer 9 -bottom_preferred_layer 2 -shield_net VSS
create_route_type -name cts_route_type_leaf -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_leaf -top_preferred_layer 7 -bottom_preferred_layer 2 -shield_net VSS
if {![llength [get_db route_rules ndr_vddaon]]} {...}
create_route_type -name vddaon_ndr_route_type -stack_distance 0.001 -min_stack_layer 4 -preferred_routing_layer_effort high -route_rule ndr_vddaon -top_preferred_layer 6 -bottom_preferred_layer 5
if {![get_feature pnr_db_handoff]} {...}
if {[file exists scripts/post_init_floorplan.tcl]} {...}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[llength [get_db current_design .track_patterns]] == 0} {...}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[get_db flow_feature_dont_use_ulvt]} {...}
foreach dont_use_expr [get_db flow_vars_dont_use_list] {
        set_db [get_db base_cells -if {*}${dont_use_expr}] .dont_use true
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {0} {...}
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {0} {...}
global mmmc_vars
foreach setup_dc [get_db [get_db delay_corners -if {.is_setup || .is_hold}] .name] {
	# Cell OCV
	# Data
	set_timing_derate -data  -cell_delay -early -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_data_cell_early)
	set_timing_derate -data  -cell_delay -late  -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_data_cell_late)
	# Clock
	set_timing_derate -clock -cell_delay -early -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_clock_cell_early)
	set_timing_derate -clock -cell_delay -late  -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_clock_cell_late)
	
	# Wire OCV
	# Data
	set_timing_derate -data  -net_delay  -early -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_data_net_early)
	set_timing_derate -data  -net_delay  -late  -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_data_net_late)
	# Clock
	set_timing_derate -clock -net_delay  -early -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_clock_net_early)
	set_timing_derate -clock -net_delay  -late  -delay_corner ${setup_dc} $mmmc_vars(${setup_dc},flat_clock_net_late)
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
reset_path_group -all
set mems [get_cells -hierarchical -filter "@is_memory_cell"]
set icgs [filter_collection [all_registers] "@is_integrated_clock_gating_cell"]
set regs [remove_from_collection [all_registers -edge_triggered] $icgs]
foreach mode [get_db constraint_modes -if {.is_setup}] {
        set_interactive_constraint_mode $mode
        group_path -name in2out -from [all_inputs] -to [all_outputs]
        if {[sizeof_collection [get_cells $regs]] > 0} {
            group_path -name in2reg -from [all_inputs] -to $regs
            group_path -name reg2out -from $regs -to [all_outputs]
            group_path -name reg2reg -from $regs -to $regs
        }
        if {[sizeof_collection [get_cells $mems]] > 0} {
            group_path -name mem2reg -from $mems -to $regs
            group_path -name reg2mem -from $regs -to $mems
            group_path -name mem2mem -from $mems -to $mems
        }
        if {[sizeof_collection [get_cells $icgs]] > 0} {
            group_path -name reg2icg -from $regs -to $icgs
        }
    }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
set_analysis_view  -setup             [get_db flow_vars_setup_pnr_active_views]   -hold              [get_db flow_vars_hold_pnr_active_views]   -leakage           [get_db flow_vars_power_view]  -dynamic           [get_db flow_vars_power_view]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
if {[get_feature pnr_db_handoff] && [is_flow -quiet -inside flow:syn_opt]} {...
} else {
set_db flow_write_db_common false
}
catch {report_obj -tcl} flow_root_config
if {[dict exists $flow_root_config root:/]} {
set flow_root_config [dict get $flow_root_config root:/]
}
foreach key [dict keys $flow_root_config] {
	if {[string length [dict get $flow_root_config $key]] > 200} {
	    dict set flow_root_config $key "\[long value truncated\]"
	}
    }
set_metric -name flow.root_config -value $flow_root_config
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): write_db -sdc /home/student/16/ex8/flow_datapath_top_1/dbs/floorplan.enc
#@ (flow_step:report_start)  2:     #- Extend flow report name based on context
#@ (flow_step:report_start)  3:     if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
#@                            : 	if {![regexp {sta$} [get_db flow_report_name]]} {
#@                            : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "sta" : "[get_db flow_report_name].sta"}]
#@                            : 	}
#@                            :     } elseif {[is_flow -quiet -inside flow:ir_early_static] || [is_flow -quiet -inside flow:ir_early_dynamic]} {
#@                            : 	if {![regexp {era$} [get_db flow_report_name]]} {
#@                            : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "era" : "[get_db flow_report_name].era"}]
#@                            : 	}
#@                            :     } elseif {[is_flow -quiet -inside flow:ir_grid] || [is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
#@                            : 	if {![regexp {ir$} [get_db flow_report_name]]} {
#@                            : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "ir" : "[get_db flow_report_name].ir"}]
#@                            : 	}
#@                            :     } elseif {[regexp {block_start|hier_start|eco_start} [get_db flow_step_current]]} {
#@                            : 	set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
#@                            :     } else {
#@                            :     }
#@ (flow_step:report_start) 20:     #- Create report directory (if necessary)
#@ (flow_step:report_start) 21:     file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[get_feature -feature report_lec]} {
set_db write_lec_directory_naming_style "fv/%s/[get_db flow_report_name]"
}
set_db init_design_uniquify 1
set_db design_process_node            45
if {[get_feature -feature flow_express]} {...}
set_db design_early_clock_flow              true
set_db write_stream_via_names true
set_db timing_analysis_cppr           both
set_db timing_analysis_type           ocv
set_db timing_report_fields           {timing_point net cell fanout load transition delay incr_delay arrival edge user_derate power_domain}
set_db timing_analysis_async_checks async
set_db timing_apply_default_primary_input_assertion false
set_db delaycal_advanced_node_pin_cap_settings true
set_db delaycal_advanced_pin_cap_mode true
if {[get_feature -feature add_pvs_fill] || [get_feature -feature add_pegasus_beol_fill]} {...}
if {[is_flow -after flow:opt_signoff] || [is_flow -inside flow:opt_signoff]} {...}
if {[is_flow -after flow:route]} {...}
if {0} {...
} else {
set_db delaycal_equivalent_waveform_model               no_propagation
}
set_db si_aggressor_alignment                             timing_aware_edge       
set_db finish_floorplan_active_objs   [list macro soft_blockage core]
set_db floorplan_row_site_height                          even
set_db floorplan_row_site_width                           even
set_db place_detail_legalization_inst_gap                 1 
set_db place_detail_use_no_diffusion_one_site_filler      false                        ;
set_db place_detail_filler_gap_min_gap                    0.2
set_db place_detail_filler_gap_effort                     high
set_db place_global_uniform_density                       true                        ;
set_db place_global_place_io_pins               true
set_db place_detail_use_check_drc               true
set_db add_tieoffs_cells                        [list TIEHI TIELO]
set_db add_tieoffs_max_fanout 32
set_db opt_fix_hold_allow_setup_tns_degradation           true                        ;
set_db opt_fix_hold_verbose                               true                        ;
set_db opt_new_inst_prefix            "[get_db flow_report_name]_"
set_db opt_fix_hold_lib_cells                   [list  ]
set_db opt_fix_fanout_load true
set_db cts_top_fanout_threshold                           2000                        ;
set_db cts_target_skew                          0.15
set_db cts_target_max_transition_time           0.10
set_db cts_buffer_cells                         [list CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8]
set_db cts_inverter_cells                       [list CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8]
set_db cts_clock_gating_cells                   [list TLATNCAX12 TLATNCAX16 TLATNCAX2 TLATNCAX20 TLATNCAX3 TLATNCAX4 TLATNCAX6 TLATNCAX8]
set_db cts_logic_cells                          [get_db [get_db base_cells CLK*] .name]
if {[get_db route_types] ne ""} {
set_db cts_route_type_leaf                     cts_route_type_leaf
set_db cts_route_type_trunk                    cts_route_type_trunk
set_db cts_route_type_top                      cts_route_type_top
}
set_db cts_use_inverters true
set_db cts_max_fanout 32
set_db opt_leakage_to_dynamic_ratio                 0.5
set_db add_fillers_cells                        [list  DECAP10 DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9  FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8  ]
set_db add_fillers_no_single_site_gap true
set_db add_fillers_cell_name_style                      flat
set_db route_early_global_bottom_routing_layer            [get_db [get_db layers Metal2] .route_index]
set_db route_early_global_top_routing_layer               [get_db [get_db layers Metal11] .route_index]
set_db route_early_global_num_tracks_per_clock_wire     5
set_db route_design_bottom_routing_layer                  [get_db [get_db layers Metal2] .route_index]
set_db route_design_top_routing_layer                     [get_db [get_db layers Metal11] .route_index]
set_db route_design_detail_post_route_swap_via          none
set_db route_design_with_litho_driven                   true
set_db route_design_with_timing_driven                  true
set_db route_design_antenna_pin_limit                   1000
set_db route_design_antenna_cell_name                   ANTENNA
set_db route_design_add_antenna_inst_prefix             "ANTENNA"
set_db route_design_antenna_diode_insertion             true
set_db route_design_detail_fix_antenna                  true
set_db route_design_with_via_in_pin                     1:1 ;
set_db route_design_concurrent_minimize_via_count_effort  high                        ;
set_db route_design_detail_use_multi_cut_via_effort       high                        ;
if {0} {...}
eval_legacy {setNanoRouteMode  -routeExpShieldAddTappingVia true}                     ;
set_db distributed_child_license_checkout_list          tpsxl
set_db opt_signoff_optimize_core_only                   true                                    
set_db opt_signoff_fix_si_slew true
set_db opt_signoff_fix_xtalk   true
set_db opt_signoff_fix_glitch  true
set_db opt_signoff_fix_hold_allow_setup_optimization      true                        ;
set_db opt_signoff_fix_hold_allow_setup_tns_degrade       true                        ;
set_db opt_signoff_retime                               path_slew_propagation
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
report_summary -no_html -out_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]qor.rpt]
report_area  -min_count 1000 -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.summary.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
if {[is_flow -inside flow:report_floorplan]} {
check_drc -check_only special -ignore_trial_route -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.drc.rpt]
}
set_metric -name check.drc.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]route.drc.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (flow_step:innovus_to_lec)  2:     #- Extend flow report name based on context
#@ (flow_step:innovus_to_lec)  3:     if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
#@                              : 	if {![regexp {sta$} [get_db flow_report_name]]} {
#@                              : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "sta" : "[get_db flow_report_name].sta"}]
#@                              : 	}
#@                              :     } elseif {[is_flow -quiet -inside flow:ir_early_static] || [is_flow -quiet -inside flow:ir_early_dynamic]} {
#@                              : 	if {![regexp {era$} [get_db flow_report_name]]} {
#@                              : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "era" : "[get_db flow_report_name].era"}]
#@                              : 	}
#@                              :     } elseif {[is_flow -quiet -inside flow:ir_grid] || [is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
#@                              : 	if {![regexp {ir$} [get_db flow_report_name]]} {
#@                              : 	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "ir" : "[get_db flow_report_name].ir"}]
#@                              : 	}
#@                              :     } elseif {[regexp {block_start|hier_start|eco_start} [get_db flow_step_current]]} {
#@                              : 	set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
#@                              :     } else {
#@                              :     }
#@ (flow_step:innovus_to_lec) 20:     #- Create report directory (if necessary)
#@ (flow_step:innovus_to_lec) 21:     file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
#@ (run_flow): push_snapshot_stack
if {[is_flow -inside flow:floorplan]} {
write_do_lec  -flat  -log_file [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log]  lec.[get_db flow_report_name].do
}
schedule_flow  -flow lec  -branch [get_db flow_report_name]  -no_db  -no_sync  -tool_options "-nogui -lp -do [file join [string map [list %s [get_db current_design .name]] [get_db write_lec_directory_naming_style]] lec.[get_db flow_report_name].do]"
#@ (run_flow): pop_snapshot_stack
exit 0
