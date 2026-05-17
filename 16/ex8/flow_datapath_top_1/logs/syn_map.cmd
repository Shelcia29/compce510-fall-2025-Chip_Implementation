# Cadence Genus(TM) Synthesis Solution, Version 23.15-s099_1, built Jul 15 2025 14:25:04

# Date: Fri Nov 14 15:33:16 2025
# Host: ASIC-vm (x86_64 w/Linux 4.18.0-553.69.1.el8_10.x86_64) (8cores*8cpus*1physical cpu*12th Gen Intel(R) Core(TM) i7-12700 25600KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

if {[catch {init_flow  {flow_script /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl yaml_script {} flow_no_check 0 parent_uuid {} previous_uuid 0a1f9698-dd41-439e-8fc4-b14cbfef6920 top_dir /home/student/16/ex8/flow_datapath_top_1 flow_dir . status_file /home/student/16/ex8/flow_datapath_top_1/flow.status.d/syn_map metrics_file /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_map run_tag {} db {rc /home/student/16/ex8/flow_datapath_top_1/dbs/syn_generic.db datapath_top {}} db_is_ref_run 0 branch {} caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} flow {flow flow:block dir . db {rc dbs/syn_generic.db datapath_top {}} branch {} tool genus caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} uuid 0a1f9698-dd41-439e-8fc4-b14cbfef6920 tool_options {} start_step {tool genus flow flow:block canonical_path {.steps flow:syn_map .steps flow_step:block_start} step flow_step:block_start features {} str syn_map.block_start} process_branch_trunk 1} flow_name flow:block first_step {tool genus flow flow:block canonical_path {.steps flow:syn_map .steps flow_step:block_start} step flow_step:block_start features {} str syn_map.block_start} interactive 0 interactive_run 0 enabled_features {report_lec synth_spatial pnr_db_handoff add_scan opt_signoff} inject_tcl {} trunk_process 1 aum_upload false tool_options {} overwrite 0 last_step {tool genus flow flow:block canonical_path {.steps flow:syn_map .steps flow_step:genus_to_lec} step flow_step:genus_to_lec features {} str syn_map.genus_to_lec} log_prefix /home/student/16/ex8/flow_datapath_top_1/logs/syn_map}; run_flow -from {tool genus flow flow:block canonical_path {.steps flow:syn_map .steps flow_step:block_start} step flow_step:block_start features {} str syn_map.block_start} -to {tool genus flow flow:block canonical_path {.steps flow:syn_map .steps flow_step:genus_to_lec} step flow_step:genus_to_lec features {} str syn_map.genus_to_lec}} msg]} { puts [concat {Tcl error:} $errorInfo]; set fp [open {/home/student/16/ex8/flow_datapath_top_1/flow.status.d/syn_map} a]; puts $fp {}; puts $fp [list [list script run_tcl status error flow {flow:block} branch {} flow_working_directory {.} flow_starting_db {rc /home/student/16/ex8/flow_datapath_top_1/dbs/syn_generic.db datapath_top {}} {tool_options} {} steps_run [get_db flow_step_canonical_current] msg $msg]]; close $fp; exit 1 }; exit 0
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_map -previous 0a1f9698-dd41-439e-8fc4-b14cbfef6920
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ (flow_step:block_start)  2:     set db [get_db flow_starting_db]
#@ (flow_step:block_start)  3:     set flow [lindex [get_db flow_hier_path] end]
#@ (flow_step:block_start)  4:     set setup_views [get_feature $flow -feature setup_views]
#@ (flow_step:block_start)  5:     set hold_views [get_feature $flow -feature hold_views]
#@ (flow_step:block_start)  6:     set leakage_view [get_feature $flow -feature leakage_view]
#@ (flow_step:block_start)  7:     set dynamic_view [get_feature $flow -feature dynamic_view]
#@ (flow_step:block_start)  9:     if {($setup_views ne "") || ($hold_views ne "") || ($leakage_view ne "") || ($dynamic_view ne "")} {
#@                           : 	#- use read_db args for DB types and set_analysis_views for TCL
#@                           : 	if {([llength [get_db analysis_views]]) > 0 &&  ([lindex $db 0] eq {tcl} || [lindex $db 0] eq {enc} && [file isfile [lindex $db 1]])} {
#@                           : 	    set cmd "set_analysis_view"
#@                           : 	    if {$setup_views ne ""} {
#@                           : 		append cmd " -setup [list $setup_views]"
#@                           : 	    } else {
#@                           : 		append cmd " -setup [list [get_db [get_db analysis_views -if .is_setup] .name]]"
#@                           : 	    }
#@                           : 	    if {$hold_views ne ""} {
#@                           : 		append cmd " -hold [list $hold_views]"
#@                           : 	    } else {
#@                           : 		append cmd " -hold [list [get_db [get_db analysis_views -if .is_hold] .name]]"
#@                           : 	    }
#@                           : 	    if {$leakage_view ne ""} {
#@                           : 		append cmd " -leakage [list $leakage_view]"
#@                           : 	    } else {
#@                           : 		if {[llength [get_db analysis_views -if .is_leakage]] > 0} {
#@                           : 		    append cmd " -leakage [list [get_db [get_db analysis_views -if .is_leakage] .name]]"
#@                           : 		}
#@                           : 	    }
#@                           : 	    if {$dynamic_view ne ""} {
#@                           : 		append cmd " -dynamic [list $dynamic_view]"
#@                           : 	    } else {
#@                           : 		if {[llength [get_db analysis_views -if .is_dynamic]] > 0} {
#@                           : 		    append cmd " -dynamic [list [get_db [get_db analysis_views -if .is_dynamic] .name]]"
#@                           : 		}
#@                           : 	    }
#@                           : 	    eval $cmd
#@                           : 	} elseif {[llength [get_db analysis_views]] == 0} {
#@                           : 	    set_flowkit_read_db_args -setup_views "$setup_views" -hold_views "$hold_views" -leakage_view "$leakage_view" -dynamic_view "$dynamic_view"
#@                           : 	} else {
#@                           : 	}
#@                           :     }
#@ (flow_step:block_start)  2:     # Multi host/cpu attributes
#@ (flow_step:block_start)  3:     #-----------------------------------------------------------------------------
#@ (flow_step:block_start)  4:     # The FLOWTOOL_NUM_CPUS is an environment variable which should be exported by
#@ (flow_step:block_start)  5:     # the specified dist script.  This connects the number of CPUs being reserved
#@ (flow_step:block_start)  6:     # for batch jobs with the current flow scripts.  The LSB_MAX_NUM_PROCESSORS is
#@ (flow_step:block_start)  7:     # a typical environment variable exported by distribution platforms and is
#@ (flow_step:block_start)  8:     # useful for ensuring all interactive jobs are using the reserved amount of CPUs.
#@ (flow_step:block_start)  9:     if {[info exists ::env(FLOWTOOL_NUM_CPUS)]} {
#@                           : 	set max_cpus $::env(FLOWTOOL_NUM_CPUS)
#@                           :     } elseif {[info exists ::env(LSB_MAX_NUM_PROCESSORS)]} {
#@                           : 	set max_cpus $::env(LSB_MAX_NUM_PROCESSORS)
#@                           :     } else {
#@                           : 	set max_cpus 8
#@                           :     }
#@ (flow_step:block_start) 17:     switch -glob [get_db program_short_name] {
#@                           : 	joules*       -
#@                           : 	genus*        {
#@                           : 	    set_db max_cpus_per_server                $max_cpus
#@                           : 	}
#@                           : 	innovus*      -
#@                           : 	tempus*       -
#@                           : 	voltus*       {
#@                           : 	    set_multi_cpu_usage -verbose -local_cpu   $max_cpus
#@                           : 	    if {[get_feature -feature opt_signoff]} {
#@                           : 		if {[is_flow -inside flow:opt_signoff]} {
#@                           : 		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
#@                           : 		    set_distributed_hosts                             -local
#@                           : 		}
#@                           : 	    }
#@                           : 	    if {[get_feature -feature sta_eco]} {
#@                           : 		if {[is_flow -inside flow:sta_eco]} {
#@                           : 		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
#@                           : 		    set_distributed_hosts                             -local
#@                           : 		}
#@                           : 	    }
#@                           : 	}
#@                           : 	default       {}
#@                           :     }
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_db /home/student/16/ex8/flow_datapath_top_1/dbs/syn_generic.db
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -merge -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_map -previous 0a1f9698-dd41-439e-8fc4-b14cbfef6920
#@ (flow_step:block_start)  2:     set db [get_db flow_starting_db]
#@ (flow_step:block_start)  3:     set flow [lindex [get_db flow_hier_path] end]
#@ (flow_step:block_start)  4:     set setup_views [get_feature $flow -feature setup_views]
#@ (flow_step:block_start)  5:     set hold_views [get_feature $flow -feature hold_views]
#@ (flow_step:block_start)  6:     set leakage_view [get_feature $flow -feature leakage_view]
#@ (flow_step:block_start)  7:     set dynamic_view [get_feature $flow -feature dynamic_view]
#@ (flow_step:block_start)  9:     if {($setup_views ne "") || ($hold_views ne "") || ($leakage_view ne "") || ($dynamic_view ne "")} {
#@                           : 	#- use read_db args for DB types and set_analysis_views for TCL
#@                           : 	if {([llength [get_db analysis_views]]) > 0 &&  ([lindex $db 0] eq {tcl} || [lindex $db 0] eq {enc} && [file isfile [lindex $db 1]])} {
#@                           : 	    set cmd "set_analysis_view"
#@                           : 	    if {$setup_views ne ""} {
#@                           : 		append cmd " -setup [list $setup_views]"
#@                           : 	    } else {
#@                           : 		append cmd " -setup [list [get_db [get_db analysis_views -if .is_setup] .name]]"
#@                           : 	    }
#@                           : 	    if {$hold_views ne ""} {
#@                           : 		append cmd " -hold [list $hold_views]"
#@                           : 	    } else {
#@                           : 		append cmd " -hold [list [get_db [get_db analysis_views -if .is_hold] .name]]"
#@                           : 	    }
#@                           : 	    if {$leakage_view ne ""} {
#@                           : 		append cmd " -leakage [list $leakage_view]"
#@                           : 	    } else {
#@                           : 		if {[llength [get_db analysis_views -if .is_leakage]] > 0} {
#@                           : 		    append cmd " -leakage [list [get_db [get_db analysis_views -if .is_leakage] .name]]"
#@                           : 		}
#@                           : 	    }
#@                           : 	    if {$dynamic_view ne ""} {
#@                           : 		append cmd " -dynamic [list $dynamic_view]"
#@                           : 	    } else {
#@                           : 		if {[llength [get_db analysis_views -if .is_dynamic]] > 0} {
#@                           : 		    append cmd " -dynamic [list [get_db [get_db analysis_views -if .is_dynamic] .name]]"
#@                           : 		}
#@                           : 	    }
#@                           : 	    eval $cmd
#@                           : 	} elseif {[llength [get_db analysis_views]] == 0} {
#@                           : 	    set_flowkit_read_db_args -setup_views "$setup_views" -hold_views "$hold_views" -leakage_view "$leakage_view" -dynamic_view "$dynamic_view"
#@                           : 	} else {
#@                           : 	}
#@                           :     }
#@ (flow_step:block_start)  2:     # Multi host/cpu attributes
#@ (flow_step:block_start)  3:     #-----------------------------------------------------------------------------
#@ (flow_step:block_start)  4:     # The FLOWTOOL_NUM_CPUS is an environment variable which should be exported by
#@ (flow_step:block_start)  5:     # the specified dist script.  This connects the number of CPUs being reserved
#@ (flow_step:block_start)  6:     # for batch jobs with the current flow scripts.  The LSB_MAX_NUM_PROCESSORS is
#@ (flow_step:block_start)  7:     # a typical environment variable exported by distribution platforms and is
#@ (flow_step:block_start)  8:     # useful for ensuring all interactive jobs are using the reserved amount of CPUs.
#@ (flow_step:block_start)  9:     if {[info exists ::env(FLOWTOOL_NUM_CPUS)]} {
#@                           : 	set max_cpus $::env(FLOWTOOL_NUM_CPUS)
#@                           :     } elseif {[info exists ::env(LSB_MAX_NUM_PROCESSORS)]} {
#@                           : 	set max_cpus $::env(LSB_MAX_NUM_PROCESSORS)
#@                           :     } else {
#@                           : 	set max_cpus 8
#@                           :     }
#@ (flow_step:block_start) 17:     switch -glob [get_db program_short_name] {
#@                           : 	joules*       -
#@                           : 	genus*        {
#@                           : 	    set_db max_cpus_per_server                $max_cpus
#@                           : 	}
#@                           : 	innovus*      -
#@                           : 	tempus*       -
#@                           : 	voltus*       {
#@                           : 	    set_multi_cpu_usage -verbose -local_cpu   $max_cpus
#@                           : 	    if {[get_feature -feature opt_signoff]} {
#@                           : 		if {[is_flow -inside flow:opt_signoff]} {
#@                           : 		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
#@                           : 		    set_distributed_hosts                             -local
#@                           : 		}
#@                           : 	    }
#@                           : 	    if {[get_feature -feature sta_eco]} {
#@                           : 		if {[is_flow -inside flow:sta_eco]} {
#@                           : 		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
#@                           : 		    set_distributed_hosts                             -local
#@                           : 		}
#@                           : 	    }
#@                           : 	}
#@                           : 	default       {}
#@                           :     }
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
#@ (flow_step:init_genus)  3:     # Tool settings
#@ (flow_step:init_genus)  4:     set_db information_level 9
#@ (flow_step:init_genus)  6:     # Timing attributes  [get_db -category tim]
#@ (flow_step:init_genus)  7:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus)  8:     set_db ocv_mode                         true
#@ (flow_step:init_genus) 10:     if {[get_feature -feature dft_simple] || [get_feature -feature dft_compressor]} {
#@                          : 	# DFT attributes  [get_db -category dft]
#@                          : 	#-------------------------------------------------------------------------------
#@                          : 	set_db dft_wait_for_license true
#@                          : 	
#@                          :     }
#@ (flow_step:init_genus) 16:     # automatic identification is a must to preserve synchronizer connections
#@ (flow_step:init_genus) 17:     set_db dft_auto_identify_shift_register true
#@ (flow_step:init_genus) 19:     # No identification for other test signals
#@ (flow_step:init_genus) 20:     set_db dft_identify_internal_test_clocks false
#@ (flow_step:init_genus) 21:     set_db dft_identify_test_signals false
#@ (flow_step:init_genus) 22:     set_db dft_identify_top_level_test_clocks false
#@ (flow_step:init_genus) 23:     set_db dft_include_controllable_pins_in_abstract_model allmodes
#@ (flow_step:init_genus) 26:     # Optimization attributes  [get_db -category netlist]
#@ (flow_step:init_genus) 27:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 28:     if {[get_feature -feature flow_express]} {
#@                          : 	set_db syn_generic_effort express
#@                          : 	set_db syn_map_effort     express
#@                          : 	set_db syn_opt_effort     express
#@                          :     } else {
#@                          : 	set_db syn_generic_effort medium
#@                          : 	set_db syn_map_effort medium
#@                          : 	set_db syn_opt_effort medium
#@                          :     }
#@ (flow_step:init_genus) 37:     set_db lp_insert_clock_gating true
#@ (flow_step:init_genus) 38:     set_db auto_ungroup both
#@ (flow_step:init_genus) 40:     # Datapath attributes  [get_db -category dp]
#@ (flow_step:init_genus) 41:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 43:     # Leakage Power attributes  [get_db -category lp_opt lib_ui]
#@ (flow_step:init_genus) 44:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 45:     set_db leakage_power_effort medium
#@ (flow_step:init_genus) 47:     # Physical Synthesis attributes  [get_db -category phys]
#@ (flow_step:init_genus) 48:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 49:     set_db design_process_node              22
#@ (flow_step:init_genus) 50:     if {[get_feature -feature flow_express]} {
#@                          : 	set_db design_flow_effort               express
#@                          :     }
#@ (flow_step:init_genus) 53:     if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
#@                          : 	# Physical Synthesis attributes  [get_db -category phys]
#@                          : 	#-------------------------------------------------------------------------------
#@                          : 	if {[array names env INNOVUSHOME] != ""} {
#@                          : 	    set_db innovus_executable               $env(INNOVUSHOME)/tools/bin/innovus
#@                          : 	} else {
#@                          : 	    set_db innovus_executable               /opt/soc/eda/cadence/INNOVUS191/tools/bin/innovus
#@                          : 	}
#@                          : 	set_db phys_checkout_innovus_license    false
#@                          : 
#@                          : 	if {[file exists scripts/innovus_config.tcl]} {
#@                          : 	    set_db invs_preload_script              scripts/innovus_config.tcl
#@                          : 	    set_db invs_postload_script             ""
#@                          : 	} else {
#@                          : 	    set_db invs_preload_script              [get_db flow_source_directory]/innovus_config.tcl
#@                          : 	    set_db invs_postload_script             ""
#@                          : 	}
#@                          : 	set_db invs_temp_dir $env(TMPDIR)/invs_temp_dir
#@                          : 
#@                          : 	set_db number_of_routing_layers 7
#@                          : 
#@                          : 	# # Clock gating setup
#@                          : 	set_db base_cell:TLATNTSCAX4 .dont_use false
#@                          : 	set_db current_design .lp_clock_gating_cell TLATNTSCAX4
#@                          : 
#@                          : 	set_db current_design .max_dynamic_power 0.06
#@                          : 	set_db current_design .lp_power_optimization_weight 0.5
#@                          : 
#@                          : 	set_db lp_power_analysis_effort high
#@                          : 	set_db lp_power_unit mW
#@                          :     }
#@ (flow_step:init_genus) 85:     # DFT helper procedures
#@ (flow_step:init_genus) 86:     source -quiet [get_db flow_source_directory]/dft_utils.tcl
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:pre_syn_map)  2:     clock_gating import -hierarchical -verbose
#@ (flow_step:pre_syn_map)  3:     # If we're not doing scan insertion, set all clock gates as controllable.
#@ (flow_step:pre_syn_map)  4:     # Otherwise check_dft_rules will mark flops driven by them with errors
#@ (flow_step:pre_syn_map)  5:     # and they will not b replaced by scan flops. This will give optimistic
#@ (flow_step:pre_syn_map)  6:     # area numbers when doing synthesis trials
#@ (flow_step:pre_syn_map)  7:     if {![get_feature -feature add_scan]} {
#@                           : 	# go through all instantiated cgs
#@                           : 	foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
#@                           : 	    puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
#@                           : 	    set_db [get_db pins $icg_inst/Q] .dft_controllable "[get_db pins $icg_inst/CP] non_inverting"
#@                           : 
#@                           : 	    # prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
#@                           : 	    # Note, TE has to be connected manually to shift enable later on!
#@                           : 	    set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
#@                           : 	}
#@                           : 	# go through all automatically inserted cgs
#@                           : 	foreach aicg_inst [get_db [get_db insts *RC_CGIC_INST] .name] {
#@                           : 	    if {[llength [get_db pins $aicg_inst/CP]]} {
#@                           : 		set_db [get_db pins $aicg_inst/Q] .dft_controllable "[get_db pins $aicg_inst/CP] non_inverting"
#@                           : 	    } elseif {[llength [get_db pins $aicg_inst/CPN]]} {
#@                           : 		set_db [get_db pins $aicg_inst/Q] .dft_controllable "[get_db pins $aicg_inst/CPN] non_inverting"
#@                           : 	    } else {
#@                           : 		puts "Error: No CP nor CPN pin on inst: $aicg_inst. Cannot set cell output as dft_controllable"
#@                           : 	    }
#@                           : 	}
#@                           :     }
#@ (flow_step:pre_syn_map) 28:     check_dft_rules
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:run_syn_map) 2:   #- Synthesize to target library gates
#@ (flow_step:run_syn_map) 3:   if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
#@                          :     syn_map -physical
#@                          :   } else {
#@                          :     syn_map
#@                          :   }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:block_finish)  2:     #- Make sure flow_report_name is reset from any reports executed during the flow
#@ (flow_step:block_finish)  3:     set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
#@ (flow_step:block_finish)  5:     if {[get_feature pnr_db_handoff] && [is_flow -quiet -inside flow:syn_opt]} {
#@                            :         set_db flow_write_db_common true
#@                            :     } else {
#@                            :         set_db flow_write_db_common false
#@                            :     }
#@ (flow_step:block_finish) 11:     #- Store non-default root attributes to metrics
#@ (flow_step:block_finish) 12:     catch {report_obj -tcl} flow_root_config
#@ (flow_step:block_finish) 13:     if {[dict exists $flow_root_config root:/]} {
#@                            : 	set flow_root_config [dict get $flow_root_config root:/]
#@                            :     } elseif {[dict exists $flow_root_config root:]} {
#@                            : 	set flow_root_config [dict get $flow_root_config root:]
#@                            :     } else {
#@                            :     }
#@ (flow_step:block_finish) 19:     foreach key [dict keys $flow_root_config] {
#@                            : 	if {[string length [dict get $flow_root_config $key]] > 200} {
#@                            : 	    dict set flow_root_config $key "\[long value truncated\]"
#@                            : 	}
#@                            :     }
#@ (flow_step:block_finish) 24:     set_metric -name flow.root_config -value $flow_root_config
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): write_db -all_root_attributes -to_file /home/student/16/ex8/flow_datapath_top_1/dbs/syn_map.db
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
#@ (flow_step:init_genus)  3:     # Tool settings
#@ (flow_step:init_genus)  4:     set_db information_level 9
#@ (flow_step:init_genus)  6:     # Timing attributes  [get_db -category tim]
#@ (flow_step:init_genus)  7:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus)  8:     set_db ocv_mode                         true
#@ (flow_step:init_genus) 10:     if {[get_feature -feature dft_simple] || [get_feature -feature dft_compressor]} {
#@                          : 	# DFT attributes  [get_db -category dft]
#@                          : 	#-------------------------------------------------------------------------------
#@                          : 	set_db dft_wait_for_license true
#@                          : 	
#@                          :     }
#@ (flow_step:init_genus) 16:     # automatic identification is a must to preserve synchronizer connections
#@ (flow_step:init_genus) 17:     set_db dft_auto_identify_shift_register true
#@ (flow_step:init_genus) 19:     # No identification for other test signals
#@ (flow_step:init_genus) 20:     set_db dft_identify_internal_test_clocks false
#@ (flow_step:init_genus) 21:     set_db dft_identify_test_signals false
#@ (flow_step:init_genus) 22:     set_db dft_identify_top_level_test_clocks false
#@ (flow_step:init_genus) 23:     set_db dft_include_controllable_pins_in_abstract_model allmodes
#@ (flow_step:init_genus) 26:     # Optimization attributes  [get_db -category netlist]
#@ (flow_step:init_genus) 27:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 28:     if {[get_feature -feature flow_express]} {
#@                          : 	set_db syn_generic_effort express
#@                          : 	set_db syn_map_effort     express
#@                          : 	set_db syn_opt_effort     express
#@                          :     } else {
#@                          : 	set_db syn_generic_effort medium
#@                          : 	set_db syn_map_effort medium
#@                          : 	set_db syn_opt_effort medium
#@                          :     }
#@ (flow_step:init_genus) 37:     set_db lp_insert_clock_gating true
#@ (flow_step:init_genus) 38:     set_db auto_ungroup both
#@ (flow_step:init_genus) 40:     # Datapath attributes  [get_db -category dp]
#@ (flow_step:init_genus) 41:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 43:     # Leakage Power attributes  [get_db -category lp_opt lib_ui]
#@ (flow_step:init_genus) 44:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 45:     set_db leakage_power_effort medium
#@ (flow_step:init_genus) 47:     # Physical Synthesis attributes  [get_db -category phys]
#@ (flow_step:init_genus) 48:     #-------------------------------------------------------------------------------
#@ (flow_step:init_genus) 49:     set_db design_process_node              22
#@ (flow_step:init_genus) 50:     if {[get_feature -feature flow_express]} {
#@                          : 	set_db design_flow_effort               express
#@                          :     }
#@ (flow_step:init_genus) 53:     if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
#@                          : 	# Physical Synthesis attributes  [get_db -category phys]
#@                          : 	#-------------------------------------------------------------------------------
#@                          : 	if {[array names env INNOVUSHOME] != ""} {
#@                          : 	    set_db innovus_executable               $env(INNOVUSHOME)/tools/bin/innovus
#@                          : 	} else {
#@                          : 	    set_db innovus_executable               /opt/soc/eda/cadence/INNOVUS191/tools/bin/innovus
#@                          : 	}
#@                          : 	set_db phys_checkout_innovus_license    false
#@                          : 
#@                          : 	if {[file exists scripts/innovus_config.tcl]} {
#@                          : 	    set_db invs_preload_script              scripts/innovus_config.tcl
#@                          : 	    set_db invs_postload_script             ""
#@                          : 	} else {
#@                          : 	    set_db invs_preload_script              [get_db flow_source_directory]/innovus_config.tcl
#@                          : 	    set_db invs_postload_script             ""
#@                          : 	}
#@                          : 	set_db invs_temp_dir $env(TMPDIR)/invs_temp_dir
#@                          : 
#@                          : 	set_db number_of_routing_layers 7
#@                          : 
#@                          : 	# # Clock gating setup
#@                          : 	set_db base_cell:TLATNTSCAX4 .dont_use false
#@                          : 	set_db current_design .lp_clock_gating_cell TLATNTSCAX4
#@                          : 
#@                          : 	set_db current_design .max_dynamic_power 0.06
#@                          : 	set_db current_design .lp_power_optimization_weight 0.5
#@                          : 
#@                          : 	set_db lp_power_analysis_effort high
#@                          : 	set_db lp_power_unit mW
#@                          :     }
#@ (flow_step:init_genus) 85:     # DFT helper procedures
#@ (flow_step:init_genus) 86:     source -quiet [get_db flow_source_directory]/dft_utils.tcl
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_area_genus) 2:   report_area -min_count 5000 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.summary.rpt]
#@ (flow_step:report_area_genus) 3:   report_dp                   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.datapath.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_timing_summary_late_genus) 2:   report_timing_summary -checks {setup drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.analysis_summary.rpt]
#@ (flow_step:report_timing_summary_late_genus) 3:   report_timing_summary -checks {setup drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.view_summary.rpt]
#@ (flow_step:report_timing_summary_late_genus) 4:   report_timing_summary -checks {setup drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.group_summary.rpt]
#@ (flow_step:report_timing_summary_late_genus) 5:   report_qor > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]qor.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_late_paths)  2:     #- Reports that show detailed timing with Graph Based Analysis (GBA)
#@ (flow_step:report_late_paths)  3:     report_timing -max_paths 5   -nworst 1 -path_type endpoint        > [get_db flow_report_directory]/[get_db flow_report_name]/setup.endpoint.rpt
#@ (flow_step:report_late_paths)  4:     report_timing -max_paths 1   -nworst 1 -path_type full_clock -net > [get_db flow_report_directory]/[get_db flow_report_name]/setup.worst.rpt
#@ (flow_step:report_late_paths)  5:     report_timing -max_paths 500 -nworst 1 -path_type full_clock      > [get_db flow_report_directory]/[get_db flow_report_name]/setup.gba.rpt
#@ (flow_step:report_late_paths)  7:     #- Reports that show detailed timing with Path Based Analysis (PBA)
#@ (flow_step:report_late_paths)  8:     if {[is_flow -quiet -inside flow:sta]} {
#@                                 : 	report_timing -max_paths 50 -nworst 1 -path_type full_clock -retime path_slew_propagation > [get_db flow_report_directory]/[get_db flow_report_name]/setup.pba.rpt
#@                                 :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_power_genus) 2:   report_gates -power   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]power.all.rpt]
#@ (flow_step:report_power_genus) 3:   report_clock_gating   > [file join [get_db flow_report_directory]/[get_db flow_report_name] [get_db flow_report_prefix]power.clock_gating.rpt]
#@ (flow_step:report_power_genus) 4:   report_power -depth 0 > [file join [get_db flow_report_directory]/[get_db flow_report_name] [get_db flow_report_prefix]power.design.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_design_genus)  2:     report_sequential -deleted          > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]removed_registers.rpt]
#@ (flow_step:report_design_genus)  3:     # check timing intent for each mode (in active views) separately
#@ (flow_step:report_design_genus)  4:     array unset cmode_done
#@ (flow_step:report_design_genus)  5:     foreach view_dpo [get_db analysis_views -if {.is_active && (.is_setup || .is_hold)}] {
#@                                   :         set cmode [get_db $view_dpo .constraint_mode.name]
#@                                   :         if {![info exists cmode_done($cmode)]} {
#@                                   :             check_timing_intent -view $view_dpo -verbose        > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check_timing_intent.${cmode}.rpt]
#@                                   :             set cmode_done($cmode) 1
#@                                   :         } else {
#@                                   :             continue
#@                                   :         }
#@                                   :     }
#@ (flow_step:report_design_genus) 15:     check_design -all                   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check_design.rpt]
#@ (flow_step:report_design_genus) 16:     report_clocks                       > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]clocks.rpt]
#@ (flow_step:report_design_genus) 17:     report_case_analysis                > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]case_analysis.rpt]
#@ (flow_step:report_design_genus) 18:     report_area -detail                 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area_detail.rpt]
#@ (flow_step:report_design_genus) 19:     report_design_rules                 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report_design_rules.rpt]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_dft_genus)  2:     report_scan_setup        > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]scan.setup.rpt]
#@ (flow_step:report_dft_genus)  4:     if {[is_flow -inside flow:syn_opt]} {
#@                                : 	report_scan_chains       > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]scan.chains.rpt]
#@                                : 	if {[llength [get_db actual_scan_chains]] > 0} {
#@                                : 	    write_scandef            > [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.def]
#@                                :             # By default compression chains are written to abstract. For hierarchical integration has to be fullscan
#@                                :             if {[get_feature -feature dft_compressor] && [get_db dft_add_test_compression_new_flow]} {
#@                                :                 # spatial synthesis seems to delete scan clock in some cases, redefine it here
#@                                :                 foreach name [list jtag_tck_[get_db flow_vars_design_name] jtag_tck] {
#@                                :                     set tck_port [get_db ports $name]
#@                                :                     if {[llength $tck_port]} {
#@                                :                         if {$tck_port ni [get_db [get_db test_clocks] .sources]} {
#@                                :                             define_test_clock -name jtag_tck_[get_db flow_vars_design_name] $tck_port
#@                                :                         }
#@                                :                         break
#@                                :                     }
#@                                :                 }
#@                                : 
#@                                :                 define_dft_cfg_mode -name FULLSCAN -type scan  -mode_enable_low [get_db test_signals -if {.function==compression_enable || .function==spread_enable}]
#@                                : 
#@                                :                 check_dft_rules -dft_cfg_mode FULLSCAN
#@                                : 
#@                                :                 for {set i 0} {$i < [get_db dft_compression_num_scanin]} {incr i} {
#@                                :                     define_scan_chain -name FULLSCAN_$i  -sdi [get_db [get_db test_signals -if {.function==compress_sdi && .index==$i}] .pin]  -sdo [get_db [get_db test_signals -if {.function==compress_sdo && .index==$i}] .pin]  -dft_configuration_mode FULLSCAN  -multi_mode -analyze
#@                                :                 }
#@                                : 
#@                                :                 write_dft_abstract_model -write_as_libcell -dft_cfg_mode FULLSCAN >  [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
#@                                : 
#@                                :                 # input->inout arcs aren't written to abstract
#@                                :                 # TODO deleting self controllable definition would be good as now scan out
#@                                :                 # controllables overwrite them but it requires the order to always be same
#@                                :                 dft_utils::read_scan_abstract [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
#@                                :                 foreach port [get_db ports -if {.is_user_scan_out}] {
#@                                :                     set controllable [report_dft_trace_back -continue $port]
#@                                :                     if {[get_db $controllable .obj_type]!="port"} {
#@                                :                         continue
#@                                :                     }
#@                                :                     dft_utils::add_dft_controllable -from [get_db $controllable .name] -to [get_db $port .name]
#@                                :                 }
#@                                :                 dft_utils::write_scan_abstract [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
#@                                : 
#@                                :                 delete_obj [get_db dft_configuration_modes FULLSCAN]
#@                                :                 check_dft_rules
#@                                : 
#@                                :                 report_core_wrapper_cell -report_flops > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]core_wrapper.rpt]
#@                                :             } else {
#@                                :                 write_dft_abstract_model -write_as_libcell > [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
#@                                :             }
#@                                : 	}
#@                                :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:report_congestion_genus) 2:     report ple            > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.ple.rpt]
#@ (flow_step:report_congestion_genus) 3:     report congestion     > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.congestion.rpt]
#@ (flow_step:report_congestion_genus) 4:     gui_pv_snapshot -overwrite              [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.placement.gif]
#@ (flow_step:report_congestion_genus) 5:     gui_pv_snapshot -overwrite -congestion  [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.congestion.gif]
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (run_flow): pop_snapshot_stack
#@ (flow_step:genus_to_lec)  2:     #- Extend flow report name based on context
#@ (flow_step:genus_to_lec)  3:     if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
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
#@ (flow_step:genus_to_lec) 20:     #- Create report directory (if necessary)
#@ (flow_step:genus_to_lec) 21:     file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_to_lec)  2:     #- create output location
#@ (flow_step:genus_to_lec)  3:     set design  [get_db current_design .name]
#@ (flow_step:genus_to_lec)  4:     if {[is_flow -quiet -inside flow:syn_opt] && [get_feature pnr_db_handoff]} {
#@                            :         set out_dir [lindex [get_db flow_starting_db] 1]/cmn
#@                            :     } else {
#@                            :         set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
#@                            :         file mkdir $out_dir
#@                            :     }
#@ (flow_step:genus_to_lec) 11:     #- write dofile for LEC
#@ (flow_step:genus_to_lec) 12:     if {[is_flow -inside flow:syn_map]} {
#@                            :         if {[file exists scripts/lec.pre_compare.tcl]} {
#@                            :             write_do_lec  -top $design  -golden_design rtl  -revised_design fv_map  -pre_compare scripts/lec.pre_compare.tcl  -no_lp  -no_exit  -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log]  > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
#@                            :         } else {
#@                            :             write_do_lec  -top $design  -golden_design rtl  -revised_design fv_map  -no_lp  -no_exit  -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log]  > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
#@                            :         }
#@                            : 	# Note, TL: From Benoit. Check if still needed!
#@                            : 	#- Add "analyze_datapath -flowgraph" to dofile
#@                            : 	file rename -force [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp]
#@                            : 	set file_r [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp] r]
#@                            : 	set file_w [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] w]
#@                            : 	
#@                            : 	while {![eof $file_r]} {
#@                            : 	    set line [gets $file_r]
#@                            : 	    if {[regexp {analyze_datapath[ \t]+-verbose;} $line]} {
#@                            : 		set line [regsub {(analyze_datapath[ \t]+-verbose;)} $line {analyze_datapath -flowgraph -verbose;}]
#@                            : 	    } elseif {[regexp "read_library.+-lp all.+" $line]} {
#@                            : 		set line [regsub -- "-lp all " $line ""]
#@                            : 	    }
#@                            : 
#@                            : 	    puts $file_w $line
#@                            : 	}
#@                            : 	
#@                            : 	close $file_r
#@                            : 	close $file_w
#@                            : 	# Note, TL. Check if needed end!
#@                            : 
#@                            :     } else {
#@                            :         if {[file exists scripts/lec.pre_compare.syn_opt.tcl]} {
#@                            :             write_do_lec  -top $design  -golden_design fv_map  -revised_design [file join $out_dir $design.v.gz]  -pre_compare scripts/lec.pre_compare.syn_opt.tcl  -no_lp  -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log]  > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
#@                            :         } else {
#@                            :             write_do_lec  -top $design  -golden_design fv_map  -revised_design [file join $out_dir $design.v.gz]  -no_lp  -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log]  > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
#@                            :         }
#@                            : 	#- Add "analyze_datapath -flowgraph" to dofile
#@                            : 	file rename -force [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp]
#@                            : 	set file_r [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp] r]
#@                            : 	set file_w [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] w]
#@                            : 	
#@                            : 	while {![eof $file_r]} {
#@                            : 	    set line [gets $file_r]
#@                            : 	    if {[regexp "read_library.+-lp all.+" $line]} {
#@                            : 		set line [regsub -- "-lp all " $line ""]
#@                            : 	    }
#@                            : 
#@                            : 	    puts $file_w $line
#@                            : 	}
#@                            : 	
#@                            : 	close $file_r
#@                            : 	close $file_w
#@                            : 
#@                            :     }
#@ (flow_step:genus_to_lec) 64:     #- schedule the LEC flow
#@ (flow_step:genus_to_lec) 65:     #FlowtoolPredictHint ArgumentRandomise -branch
#@ (flow_step:genus_to_lec) 66:     #	schedule_flow  #	    -flow lec  #	    -branch [get_db flow_report_name]  #	    -no_db  #	    -no_sync  #	    -tool_options "-nogui -XL -do [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]"
#@ (run_flow): pop_snapshot_stack
