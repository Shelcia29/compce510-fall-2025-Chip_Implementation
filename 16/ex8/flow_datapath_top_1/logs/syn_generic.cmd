# Cadence Genus(TM) Synthesis Solution, Version 23.15-s099_1, built Jul 15 2025 14:25:04

# Date: Fri Nov 14 15:24:00 2025
# Host: ASIC-vm (x86_64 w/Linux 4.18.0-553.69.1.el8_10.x86_64) (8cores*8cpus*1physical cpu*12th Gen Intel(R) Core(TM) i7-12700 25600KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

if {[catch {init_flow  {flow_script /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl yaml_script {} flow_no_check 0 parent_uuid {} previous_uuid {} top_dir /home/student/16/ex8/flow_datapath_top_1 flow_dir . status_file /home/student/16/ex8/flow_datapath_top_1/flow.status.d/syn_generic metrics_file /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_generic run_tag {} db {{} {} {} {}} db_is_ref_run 0 branch {} caller_data {group 0 process_branch 0 trunk_process 1 flowtool_hostname ASIC-vm flowtool_pid 44425} flow {flow flow:block tool genus tool_options {} dir . db {{} {} {} {}} start_step {tool genus flow flow:block canonical_path {.steps flow:syn_generic .steps flow_step:block_start} step flow_step:block_start features {} str syn_generic.block_start} branch {} caller_data {group 0 process_branch 0} uuid {} parent_uuid {} case_sensitive_match 0 child_of {} process_branch_trunk 1} flow_name flow:block first_step {tool genus flow flow:block canonical_path {.steps flow:syn_generic .steps flow_step:block_start} step flow_step:block_start features {} str syn_generic.block_start} interactive 0 interactive_run 0 enabled_features {report_lec synth_spatial pnr_db_handoff add_scan opt_signoff} inject_tcl {} trunk_process 1 aum_upload false tool_options {} overwrite 0 last_step {tool genus flow flow:block canonical_path {.steps flow:syn_generic .steps flow:report_synth .steps flow_step:report_finish} step flow_step:report_finish features {} str syn_generic.report_synth.report_finish} log_prefix /home/student/16/ex8/flow_datapath_top_1/logs/syn_generic}; run_flow -from {tool genus flow flow:block canonical_path {.steps flow:syn_generic .steps flow_step:block_start} step flow_step:block_start features {} str syn_generic.block_start} -to {tool genus flow flow:block canonical_path {.steps flow:syn_generic .steps flow:report_synth .steps flow_step:report_finish} step flow_step:report_finish features {} str syn_generic.report_synth.report_finish}} msg]} { puts [concat {Tcl error:} $errorInfo]; set fp [open {/home/student/16/ex8/flow_datapath_top_1/flow.status.d/syn_generic} a]; puts $fp {}; puts $fp [list [list script run_tcl status error flow {flow:block} branch {} flow_working_directory {.} flow_starting_db {{} {} {} {}} {tool_options} {} steps_run [get_db flow_step_canonical_current] msg $msg]]; close $fp; exit 1 }; exit 0
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_generic -previous 
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
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): source /home/student/16/ex8/flow_datapath_top_1/cadence_flow_scripts/scripts/run_flow.tcl
#@ (init_flow): cd /home/student/16/ex8/flow_datapath_top_1
#@ (init_flow): read_metric -merge -id current /home/student/16/ex8/flow_datapath_top_1/flow.metrics.d/syn_generic -previous 
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
#@ (flow_step:init_elaborate)  3:     # Tool settings
#@ (flow_step:init_elaborate)  4:     set_db information_level 9
#@ (flow_step:init_elaborate)  6:     # TL: Warns for each missing io port in def...
#@ (flow_step:init_elaborate)  7:     suppress_messages PHYS-156
#@ (flow_step:init_elaborate)  8:     # TL: Warns about multiple connections to power pins
#@ (flow_step:init_elaborate)  9:     suppress_messages PHYS-2381
#@ (flow_step:init_elaborate) 11:     # HDL attributes [get_db -category hdl]
#@ (flow_step:init_elaborate) 12:     #-------------------------------------------------------------------------------
#@ (flow_step:init_elaborate) 13:     if {![get_db flow_feature_disable_naming_rules]} {
#@                              : 	puts "Info: Setting naming rules"
#@                              : 	set_db hdl_array_naming_style %s_%d
#@                              : 	set_db hdl_instance_array_naming_style %s_%d
#@                              : 	set_db hdl_generate_index_style   %s_%d
#@                              : 	set_db hdl_generate_separator _
#@                              : 	set_db hdl_bus_wire_naming_style %s_%d
#@                              : 	set_db hdl_record_naming_style %s_%s
#@                              :     }
#@ (flow_step:init_elaborate) 22:     if {[get_feature -feature flow_express]} {
#@                              : 	# track RTL filename, row & column information for e.g. removed registers
#@                              : 	set_db hdl_track_filename_row_col true
#@                              :     }
#@ (flow_step:init_elaborate) 26:     set_db hdl_max_loop_limit 32768
#@ (flow_step:init_elaborate) 27:     # Add, TL. new variable because of LTEMOD rtl, new in genus 18.73 (not official release)
#@ (flow_step:init_elaborate) 28:     #set_db hdl_array_read_mux_opto true
#@ (flow_step:init_elaborate) 29:     # Don't use scan ports for functional stuff
#@ (flow_step:init_elaborate) 30:     set_db use_scan_seqs_for_non_dft 		false
#@ (flow_step:init_elaborate) 31:     # Do not optimize away any logic which has floating nets in RTL
#@ (flow_step:init_elaborate) 32:     set_db hdl_unconnected_value none
#@ (flow_step:init_elaborate) 33:     # Do not set top name to a monstrous string with all non-default parameter values
#@ (flow_step:init_elaborate) 34:     set_db hdl_parameterize_module_name false
#@ (flow_step:init_elaborate) 35:     # no ungrouping to see hierarchy areas
#@ (flow_step:init_elaborate) 36:     #set_db auto_ungroup none
#@ (flow_step:init_elaborate) 38:     # Note, TL: temp fix for "interface signals using configurations bug"
#@ (flow_step:init_elaborate) 39:     set_db hdl_link_hier_inst_across_hdl_libraries true
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:elaborate_design)  2:     if {[get_db current_design] eq ""} {
#@                                : 	#- setup library information
#@                                : 	global mmmc_vars
#@                                : 	if {[file exists scripts/mmmc_config.tcl]} {
#@                                : 	    read_mmmc             scripts/mmmc_config.tcl
#@                                : 	} else {
#@                                : 	    read_mmmc             [get_db flow_source_directory]/mmmc_config.tcl
#@                                : 	}
#@                                : 	read_physical         -lef [get_db flow_vars_lef_list]
#@                                : 	
#@                                : 	#- read and elaborate design
#@                                : 	#read_hdl
#@                                : 	if {[file exists scripts/compile_[get_db flow_vars_design_name].tcl]} {
#@                                : 	    puts "\nInfo: Sourcing scripts/compile_[get_db flow_vars_design_name].tcl"
#@                                : 	    source scripts/compile_[get_db flow_vars_design_name].tcl
#@                                : 	    puts "\n"
#@                                : 	} else {
#@                                : 	    puts "\nFatal: Compile-script not found! (scripts/compile_[get_db flow_vars_design_name].tcl)"
#@                                : 	    puts "             Run make create_genustech\n"
#@                                : 	    exit
#@                                : 	}
#@                                : 
#@                                : 	# Check for non-default parameters for toplevel
#@                                : 	set topname [get_db flow_vars_design_name]
#@                                : 	if {[get_db flow_vars_design_top] != ""} {
#@                                : 	    set topname [get_db flow_vars_design_top]
#@                                : 	}
#@                                : 	if {[get_db flow_vars_elaboration_parameters] != ""} {
#@                                : 	    elaborate -parameters "[get_db flow_vars_elaboration_parameters]" ${topname}
#@                                : 	} else {
#@                                : 	    elaborate ${topname}
#@                                : 	}
#@                                : 	
#@                                : 	# possible post-elaborate step
#@                                : 	if {[file exists scripts/post_elaborate.tcl]} {
#@                                : 	    puts "\nInfo: Sourcing scripts/post_elaborate.tcl"
#@                                : 	    source scripts/post_elaborate.tcl
#@                                : 	    puts "\n"
#@                                : 	} elseif {[file exists [get_db flow_source_directory]/post_elaborate.tcl]} {
#@                                : 	    puts "\nInfo: Sourcing [get_db flow_source_directory]/post_elaborate.tcl"
#@                                : 	    source [get_db flow_source_directory]/post_elaborate.tcl
#@                                : 	    puts "\n"
#@                                : 	}
#@                                : 	
#@                                : 	# report macros after elaboration to see if linking is ok
#@                                : 	puts "\nInfo: All macros in design:"
#@                                : 	get_db insts -if {.is_macro==true} -foreach {puts [get_db $object .name]}
#@                                : 	puts "\n"
#@                                : 	
#@                                : 	
#@                                : 	# print memories into a text file (/reports folder)
#@                                : 	set fp [open [get_db flow_report_directory]/[get_db flow_vars_design_name].memories.txt w]
#@                                : 	if {[llength [get_db insts -if {.is_memory}]] > 0} {
#@                                : 	    get_db insts -if {.is_memory} -foreach {puts $fp "[get_db $object .name] : [get_db $object .base_cell.name]"}
#@                                : 	} else {
#@                                : 	    puts $fp "no memories found"
#@                                : 	}
#@                                : 	
#@                                : 	close $fp
#@                                :     }
#@ (flow_step:elaborate_design) 63:     if {![get_db flow_feature_disable_naming_rules]} {
#@                                : 	write_db -to_file [get_db flow_database_directory]/syn_generic.elaborate_design.db
#@                                :     }
#@ (flow_step:elaborate_design) 67:     report_messages -warning > [get_db flow_report_directory]/elaboration/report_messages_warnings.txt
#@ (flow_step:elaborate_design) 68:     report_messages -error > [get_db flow_report_directory]/elaboration/report_messages_errors.txt
#@ (flow_step:elaborate_design) 69:     check_design -multiple_driver -unresolved -undriven > [get_db flow_report_directory]/elaboration/check_design_fatal.txt
#@ (flow_step:elaborate_design) 70:     check_design -unloaded -unloaded_comb > [get_db flow_report_directory]/elaboration/check_design_unloaded.txt
#@ (flow_step:elaborate_design) 71:     check_design -combo_loops > [get_db flow_report_directory]/elaboration/check_design_combo_loops.txt
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:init_design)  3:     #- optionally setup power intent from UPF/CPF/1801
#@ (flow_step:init_design)  4:     if {[file exists [get_db flow_vars_power_intent]]} {
#@                           : 	read_power_intent -1801 [get_db flow_vars_power_intent]
#@                           :     }
#@ (flow_step:init_design)  8:     #- initialize library and design information
#@ (flow_step:init_design)  9:     init_design
#@ (flow_step:init_design) 11:     #- load floorplan (created by using "write_def <DEF FILE> -no_core_cells -no_special_net -no_std_cells")
#@ (flow_step:init_design) 12:     if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
#@                           : 	set_db find_fuzzy_match true
#@                           : 	read_def  [get_db flow_vars_floorplan_def]
#@                           :     }
#@ (flow_step:init_design) 17:     #- add cells and commit power rules
#@ (flow_step:init_design) 18:     if {[file exists [get_db flow_vars_power_intent]]} {
#@                           : 	commit_power_intent
#@                           :     }
#@ (flow_step:init_design) 22:     update_names -suffix _cn -name_collision -max_length 1000 [get_db current_design] 
#@ (flow_step:init_design) 24:     #- load tool configs which require design information
#@ (flow_step:init_design) 25:     if {[file exists scripts/[get_db program_short_name]_config.tcl]} {
#@                           : 	uplevel #0 source -quiet scripts/[get_db program_short_name]_config.tcl
#@                           :     } else {
#@                           : 	uplevel #0 source -quiet [file join [get_db flow_source_directory] [get_db program_short_name]_config.tcl]
#@                           :     }
#@ (flow_step:init_design) 31:     if {[get_db flow_feature_disable_naming_rules]} {
#@                           : 	write_db -to_file [get_db flow_database_directory]/syn_generic.init_design.disable_naming_rules.db
#@                           :     } else {
#@                           : 	write_db -to_file [get_db flow_database_directory]/syn_generic.init_design.db
#@                           :     }
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
#@ (flow_step:manage_uncertainty)  2:     if {0} {
#@                                  :     # only set functional mode clock uncertainties
#@                                  :     set_interactive_constraint_modes [get_db constraint_modes -if {(.is_setup||.is_hold) && .name==*func*} -u]
#@                                  :     set clock_names [get_db -u [get_db clocks -if {.base_name!=*_virtual}] .base_name]
#@                                  : 
#@                                  :     global mmmc_vars
#@                                  :     # Note TL: Fix these. Clock uncertainties are corner specific, not mode specific
#@                                  :     if {[is_flow -quiet -after flow:opt_signoff] || [is_flow -quiet -inside flow:opt_signoff] ||
#@                                  : 	[is_flow -quiet -after flow:sta] || [is_flow -quiet -inside flow:sta]} {
#@                                  : 	set stp 0.085
#@                                  : 	set hld 0.050
#@                                  :     } elseif {[is_flow -quiet -after flow:floorplan] || [is_flow -quiet -inside flow:floorplan]} {
#@                                  : 	set stp 0.105
#@                                  : 	set hld 0.065
#@                                  :     } elseif {[is_flow -quiet -after flow:syn_generic] || [is_flow -quiet -inside flow:syn_generic]} {
#@                                  : 	set stp 0.105
#@                                  : 	set hld 0.065
#@                                  :     } else {
#@                                  : 	puts "Error([info script]): flow step out of bounds (syn_generic <-> floorplan <-> sta)"
#@                                  :     }
#@                                  : 
#@                                  :     puts "Info([info script]): Setting setup uncertainty to $stp, hold uncertainty to $hld"
#@                                  :     foreach clock_name $clock_names {
#@                                  : 	set_clock_uncertainty -setup $stp [get_clocks $clock_name]
#@                                  : 	set_clock_uncertainty -hold $hld [get_clocks $clock_name]
#@                                  : 
#@                                  : 	if {[llength [get_db clocks -if ".base_name==${clock_name}_virtual && .view_name==*func"]]} {
#@                                  : 	    set_clock_uncertainty -setup $stp [get_clocks ${clock_name}_virtual]
#@                                  : 	    set_clock_uncertainty -setup $stp -from [get_clocks ${clock_name}_virtual] -to   [get_clocks $clock_name]
#@                                  : 	    set_clock_uncertainty -setup $stp -to   [get_clocks ${clock_name}_virtual] -from [get_clocks $clock_name]
#@                                  : 	    set_clock_uncertainty -hold $hld [get_clocks ${clock_name}_virtual]
#@                                  : 	}
#@                                  :     }
#@                                  :     set_interactive_constraint_modes {}
#@                                  : }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:set_dont_use)  2:     # disable ULVT cells until postroute
#@ (flow_step:set_dont_use)  3:     if {[get_db flow_feature_dont_use_ulvt]} {
#@                            : 	if {[is_flow -before flow:postroute]} {
#@                            : 	    set_db [get_db base_cells -if {.lib_cells.library.name==*ulvt*}] .dont_use true
#@                            : 	} else {
#@                            : 	    set_db [get_db base_cells -if {.lib_cells.library.name==*ulvt*}] .dont_use false
#@                            : 	}
#@                            :     }
#@ (flow_step:set_dont_use) 11:     foreach dont_use_expr [get_db flow_vars_dont_use_list] {
#@                            :         set_db [get_db base_cells -if {*}${dont_use_expr}] .dont_use true
#@                            :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:set_dont_touch)  3:     # set default dont touch from project settings
#@ (flow_step:set_dont_touch)  4:     if {[file exists [get_db flow_source_directory]/set_dont_touch.tcl]} {
#@                              : 	puts "\nInfo: Sourcing [get_db flow_source_directory]/set_dont_touch.tcl"
#@                              : 	source [get_db flow_source_directory]/set_dont_touch.tcl
#@                              : 	puts "\n"
#@                              :     }
#@ (flow_step:set_dont_touch) 10:     # override project dont touch settings and/or add own
#@ (flow_step:set_dont_touch) 11:     if {[file exists scripts/set_dont_touch.tcl]} {
#@                              : 	puts "\nInfo: Sourcing scripts/set_dont_touch.tcl"
#@                              : 	source scripts/set_dont_touch.tcl
#@                              : 	puts "\n"
#@                              :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_manage_preserve) 2:     foreach dpo [get_db insts -if {.base_cell.class != block* && .base_cell.class != ""}] {
#@                                    : 	set_db $dpo .preserve true
#@                                    :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_manage_derating)  2:     # Enable native socv
#@ (flow_step:genus_manage_derating)  3:     #phys_enable_ocv -native_socv -design [current_design]
#@ (flow_step:genus_manage_derating)  4:     global mmmc_vars
#@ (flow_step:genus_manage_derating)  5:     foreach dc [get_db [get_db delay_corners -if {.is_setup}] .name] {
#@                                     : 	if {![info exists mmmc_vars(${dc},flat_data_cell_early)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_data_cell_late)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_clock_cell_early)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_clock_cell_late)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_data_net_early)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_data_net_late)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_clock_net_early)] ||
#@                                     : 	    ![info exists mmmc_vars(${dc},flat_clock_net_late)]} {
#@                                     : 	    puts "Fatal: mmmc_vars(${dc},flat_\[clock|data\]_\[cell|net\]_\[early|late\]) not defined! Check mmmc_setup.tcl!"
#@                                     : 	    exit 1
#@                                     : 	}
#@                                     : 	# Cell OCV
#@                                     : 	# Data
#@                                     : 	set_timing_derate -data  -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},flat_data_cell_early)
#@                                     : 	set_timing_derate -data  -cell_delay -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_data_cell_late)
#@                                     : 	# Clock
#@                                     : 	set_timing_derate -clock -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_cell_early)
#@                                     : 	set_timing_derate -clock -cell_delay -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_cell_late)
#@                                     : 	
#@                                     : 	# Wire OCV
#@                                     : 	# Data
#@                                     : 	set_timing_derate -data  -net_delay  -early -delay_corner ${dc} $mmmc_vars(${dc},flat_data_net_early)
#@                                     : 	set_timing_derate -data  -net_delay  -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_data_net_late)
#@                                     : 	# Clock
#@                                     : 	set_timing_derate -clock -net_delay  -early -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_net_early)
#@                                     : 	set_timing_derate -clock -net_delay  -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_net_late)
#@                                     :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_manage_ungrouping)  2:     foreach dpo [get_db insts -if {.base_cell.class != ""}] {
#@                                       : 	if {[get_db $dpo .parent.name] != [get_db flow_vars_design_name]} {
#@                                       : 	    set exit_loop false
#@                                       : 	} else {
#@                                       : 	    set exit_loop true
#@                                       : 	}
#@                                       : 	while {!$exit_loop} {
#@                                       : 	    set dpo [get_db $dpo .parent]
#@                                       : 	    set_db $dpo .ungroup_ok false
#@                                       : 	    if {[string first [string tolower [get_db flow_vars_design_name]] [string tolower [get_db $dpo .parent.name]]] == 0} {
#@                                       : 		set exit_loop true
#@                                       : 	    }
#@                                       : 	}
#@                                       :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_uniquify_design) 2:     set_db ui_respects_preserve false
#@ (flow_step:genus_uniquify_design) 3:     uniquify [current_design] -verbose
#@ (flow_step:genus_uniquify_design) 4:     set_db ui_respects_preserve true
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:edit_post_elaborate_netlist) 2:     if {[file exists [get_db flow_vars_data_directory]/scripts/edit_post_elaborate_netlist.tcl]} {
#@                                          :         source [get_db flow_vars_data_directory]/scripts/edit_post_elaborate_netlist.tcl
#@                                          :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:init_scan)   3:     set_db dft_prefix 				DFT_[get_db flow_vars_design_name]_
#@ (flow_step:init_scan)   4:     set_db dft_identify_top_level_test_clocks 	false
#@ (flow_step:init_scan)   5:     set_db dft_identify_test_signals 		false
#@ (flow_step:init_scan)   6:     set_db dft_identify_internal_test_clocks 	false
#@ (flow_step:init_scan)   7:     #set_db use_scan_seqs_for_non_dft 		true
#@ (flow_step:init_scan)   8:     set_db use_scan_seqs_for_non_dft 		false
#@ (flow_step:init_scan)   9:     set_db dft_auto_identify_shift_register         true
#@ (flow_step:init_scan)  10:     set_db dft_identify_shared_wrapper_cells        false
#@ (flow_step:init_scan)  11:     #set_db dft_shared_wrapper_through	        combinational
#@ (flow_step:init_scan)  13:     #- DFT Attributes to control scan mapping and connectivity
#@ (flow_step:init_scan)  14:     #set_db designs .dft_mix_clock_edges_in_scan_chains true 
#@ (flow_step:init_scan)  15:     set_db [current_design] .dft_mix_clock_edges_in_scan_chains true 
#@ (flow_step:init_scan)  16:     set_db [current_design] .dft_lockup_element_type level_sensitive
#@ (flow_step:init_scan)  17:     set_db current_design .dft_clock_edge_for_head_of_scan_chains leading
#@ (flow_step:init_scan)  18:     set_db current_design .dft_clock_edge_for_tail_of_scan_chains trailing
#@ (flow_step:init_scan)  19:     # min number of chains used as max number of chains in connect_scan_chain -command
#@ (flow_step:init_scan)  20:     set_db [current_design] .dft_min_number_of_scan_chains 1
#@ (flow_step:init_scan)  21:     set_db [current_design] .dft_max_length_of_scan_chains 30000
#@ (flow_step:init_scan)  23:     #- Define test clock
#@ (flow_step:init_scan)  24:     #define_test_clock			     -name foo
#@ (flow_step:init_scan)  25:     define_test_clock -name jtag_tck_[get_db flow_vars_design_name] -domain scan_jtag clk_i
#@ (flow_step:init_scan)  27:     #- Define test mode port
#@ (flow_step:init_scan)  28:     define_test_signal -function test_mode -lec_value 0 -name scan_mode_[get_db flow_vars_design_name] -create_port -active high scan_mode_[get_db flow_vars_design_name]
#@ (flow_step:init_scan)  29:     #- Define scan enable port
#@ (flow_step:init_scan)  30:     define_test_signal -function shift_enable -lec_value 0 -name scan_enable_[get_db flow_vars_design_name] -create_port -active high scan_enable_[get_db flow_vars_design_name]
#@ (flow_step:init_scan)  31:     # Add, TL: pipeline shift enable
#@ (flow_step:init_scan)  32:     #define_test_signal -name pipe_sen -function pipe_sen -create_port -active low pipe_sen
#@ (flow_step:init_scan)  34:     #- Specify ICG bypass signal for DFT
#@ (flow_step:init_scan)  35:     set_db current_design .lp_clock_gating_test_signal [get_db test_signals scan_enable_[get_db flow_vars_design_name] ]
#@ (flow_step:init_scan)  37:     #- Define test reset port
#@ (flow_step:init_scan)  38:     define_test_signal -function async_set_reset -name scan_reset_[get_db flow_vars_design_name] -active high rst_ni
#@ (flow_step:init_scan)  40:     if {0} {
#@                          :         define_test_signal -function wint -name WINT_[get_db flow_vars_design_name] -create_port WINT
#@                          :         define_test_signal -function wext -name WEXT_[get_db flow_vars_design_name] -create_port WEXT
#@                          :     }
#@ (flow_step:init_scan)  45:     #- Control cg clocks
#@ (flow_step:init_scan)  46:     # go through all instantiated cgs
#@ (flow_step:init_scan)  47:     foreach icg_inst [get_db [get_db insts -if {.base_name==inst_TLATNTSCAX*}] .name] {
#@                          : 	puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
#@                          : 	set_db [get_db pins $icg_inst/Z] .dft_controllable "[get_db pins $icg_inst/CP] non_inverting"
#@                          : 
#@                          : 	# prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
#@                          : 	# Note, TE has to be connected manually to shift enable later on!
#@                          : 	set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
#@                          :     }
#@ (flow_step:init_scan)  56:     #####################################################################
#@ (flow_step:init_scan)  57:     # ADD MUXES 
#@ (flow_step:init_scan)  58:     #####################################################################
#@ (flow_step:init_scan)  59:     # Note, Block specific
#@ (flow_step:init_scan)  60:     #- Add scan clock muxes
#@ (flow_step:init_scan)  62:     if {[file exists scripts/add_mux.tcl]} {
#@                          : 	source scripts/add_mux.tcl
#@                          :     }
#@ (flow_step:init_scan)  66:     # Set all previously instantiated muxes as preserve size_ok
#@ (flow_step:init_scan)  67:     if {[llength [get_db insts *scan_???_mux_*]] == 0} {
#@                          : 	puts "Error: No instantiated clk nor rst muxes found. Check insertion script!"
#@                          :     }
#@ (flow_step:init_scan)  70:     set_db [get_db insts *scan_???_mux_*] .preserve size_ok
#@ (flow_step:init_scan)  71:     set_db [get_db insts *scan_???_inv_*] .preserve size_ok
#@ (flow_step:init_scan)  73:     check_dft_rules
#@ (flow_step:init_scan)  75:     # Read subblock scan abstract models
#@ (flow_step:init_scan)  76:     set_db ui_respects_preserve false
#@ (flow_step:init_scan)  77:     set seg_i 1
#@ (flow_step:init_scan)  78:     if {[llength [get_db flow_vars_scan_abstracts]]} {
#@                          :         foreach scan_abs [get_db flow_vars_scan_abstracts] {
#@                          :             
#@                          :             read_dft_abstract_model -segment_prefix $seg_i $scan_abs
#@                          :             incr seg_i
#@                          : 
#@                          :             set inst_name [lindex [split [file tail $scan_abs] "."] 0]
#@                          :             set i 0
#@                          :             foreach scan_inst [get_db insts -if {.base_cell.base_name==${inst_name}}] {
#@                          :                     connect -remove_multi_driver  -prefix scan_mode_  [get_db ports scan_mode_[get_db flow_vars_design_name]]  [get_db $scan_inst .pins -if {.base_name == scan_mode*}]
#@                          :                     connect -remove_multi_driver  -prefix scan_enable_  [get_db ports scan_enable_[get_db flow_vars_design_name]]  [get_db $scan_inst .pins -if {.base_name == scan_enable*}]
#@                          : 
#@                          : 
#@                          :             }
#@                          :         }
#@                          :     }
#@ (flow_step:init_scan)  94:     set_db ui_respects_preserve true
#@ (flow_step:init_scan)  96:     # For AICGs define shift enable connection inside 
#@ (flow_step:init_scan)  97:     set_compatible_test_clocks [get_db test_clocks *scan_jtag*]
#@ (flow_step:init_scan)  99:     #- Disable internal clock auto identification
#@ (flow_step:init_scan) 100:     set_db dft_identify_internal_test_clocks false
#@ (flow_step:init_scan) 102:     #- Check DFT rules
#@ (flow_step:init_scan) 103:     check_dft_rules
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_add_dft_constraints)  3:     foreach constr_mode [get_db flow_vars_constraint_modes] {
#@                                         : 	set constr_files [list ]
#@                                         : 	foreach sdc [get_db [get_db constraint_modes -if {.base_name==${constr_mode}}] .sdc_files] {
#@                                         : 	    lappend constr_files $sdc
#@                                         : 	}
#@                                         : 	if {$constr_mode != "func"} {
#@                                         : 	} else {
#@                                         : 	    if {[is_flow -inside flow:syn_generic]} {
#@                                         : 		lappend constr_files [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.hier_dft.tcl
#@                                         : 	    }
#@                                         : 	}
#@                                         : 	update_constraint_mode -name $constr_mode -sdc_files $constr_files
#@                                         :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:create_cost_group)  2:     #- Clear existing path_groups
#@ (flow_step:create_cost_group)  3:     get_db cost_groups -if {.name != default} -foreach {delete_obj $object}
#@ (flow_step:create_cost_group)  5:     #- Add basic path_groups
#@ (flow_step:create_cost_group)  6:     set mems [get_cells -hierarchical -filter "@is_memory_cell"]
#@ (flow_step:create_cost_group)  7:     set icgs [filter_collection [all_registers] "@is_integrated_clock_gating_cell"]
#@ (flow_step:create_cost_group)  8:     set regs [remove_from_collection [all_registers -edge_triggered] $icgs]
#@ (flow_step:create_cost_group) 10:     foreach mode [get_db constraint_modes -if {.is_setup}] {
#@                                 :         set_interactive_constraint_mode $mode
#@                                 :         group_path -name in2out -from [all_inputs] -to [all_outputs]
#@                                 :         if {[sizeof_collection [get_cells $regs]] > 0} {
#@                                 :             group_path -name in2reg -from [all_inputs] -to $regs
#@                                 :             group_path -name reg2out -from $regs -to [all_outputs]
#@                                 :             group_path -name reg2reg -from $regs -to $regs
#@                                 :         }
#@                                 :         if {[sizeof_collection [get_cells $mems]] > 0} {
#@                                 :             group_path -name mem2reg -from $mems -to $regs
#@                                 :             group_path -name reg2mem -from $regs -to $mems
#@                                 :             group_path -name mem2mem -from $mems -to $mems
#@                                 :         }
#@                                 :         if {[sizeof_collection [get_cells $icgs]] > 0} {
#@                                 :             group_path -name reg2icg -from $regs -to $icgs
#@                                 :         }
#@                                 :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:generate_activity_file)  2:     if {[get_db flow_feature_run_joules_power]} {
#@                                      : 	set ::rtls::use_joules_write_parsers 1
#@                                      : 	set_db lp_enable_jls_sdb_flow 1
#@                                      : 	set_default_activity -pin_types primary_input -duty 0 -freq 0
#@                                      : 	set_default_activity -pin_types seq_out -duty 0 -freq 0
#@                                      : 
#@                                      : 	read_stimulus  -file [lindex [get_db flow_vars_tcf_file] 0]  -dut_instance [lindex [get_db flow_vars_tcf_file] 1]  -frame 30  -start -end 25261ns  -scrub_prep -resim_cg_enables
#@                                      : 
#@                                      : 	propagate_activity -mode time_based
#@                                      : 	#compute_ideal_power -mode time_based
#@                                      : 	#compute_power -mode time_based
#@                                      : 
#@                                      : 	#write_tcf > [get_db flow_database_directory]/[get_db flow_vars_design_name].tcf
#@                                      : 	if {![file exists [get_db flow_report_directory]/joules]} {file mkdir [get_db flow_report_directory]/joules}
#@                                      : 	report_sdb_annotation > [get_db flow_report_directory]/joules/report_sdb_annotation.txt
#@                                      :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:genus_read_activity_file) 2:     if {[file exists [get_db flow_vars_tcf_file]]} {
#@                                       : 	read_tcf "[get_db flow_vars_tcf_file]"
#@                                       :     } else {
#@                                       : 	puts "Error: TCF file not found [get_db flow_vars_tcf_file]! Skipping reading activity file"
#@                                       :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:pre_syn_generic)  2:     # If we're not doing scan insertion, exclude all instantiated clock gates from "clock gating".
#@ (flow_step:pre_syn_generic)  3:     # Otherwise Genus will add RC_CG_INST* hierarchy to instantiated clock gates
#@ (flow_step:pre_syn_generic)  4:     # which can then i.e. mess up STA constraints later on
#@ (flow_step:pre_syn_generic)  5:     if {![get_feature -feature add_scan]} {
#@                               : 	# go through all instantiated cgs
#@                               : 	foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
#@                               : 	    puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
#@                               : 	    # prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
#@                               : 	    # Note, TE has to be connected manually to shift enable later on!
#@                               : 	    set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
#@                               : 	}
#@                               :     }
#@ (run_flow): pop_snapshot_stack
#@ (run_flow): push_snapshot_stack
#@ (flow_step:run_syn_generic) 2:   #- Synthesize to generic gates
#@ (flow_step:run_syn_generic) 3:   if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
#@                              :     syn_generic -physical
#@                              :   } else {
#@                              :     syn_generic
#@                              :   }
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
#@ (run_flow): write_db -all_root_attributes -to_file /home/student/16/ex8/flow_datapath_top_1/dbs/syn_generic.db
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
