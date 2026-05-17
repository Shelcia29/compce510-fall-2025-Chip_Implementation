# Flowkit v19.10-s008_1
# Time-stamp: <2025-06-12 11:41:41 qftele>
#- common_steps.tcl : defines common flow attributes and flowsteps

#===============================================================================
# Common attributes used in implementation flow
#===============================================================================

#- Specify Flow Header (runs at the start of run_flow command)
set_db flow_header_tcl {
    #- Extend flow report name based on context
    if {[is_flow -quiet -inside flow:sta] || [is_flow -quiet -inside flow:sta_dmmmc] || [is_flow -quiet -inside flow:sta_eco]} {
	if {![regexp {sta$} [get_db flow_report_name]]} {
	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "sta" : "[get_db flow_report_name].sta"}]
	}
    } elseif {[is_flow -quiet -inside flow:ir_early_static] || [is_flow -quiet -inside flow:ir_early_dynamic]} {
	if {![regexp {era$} [get_db flow_report_name]]} {
	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "era" : "[get_db flow_report_name].era"}]
	}
    } elseif {[is_flow -quiet -inside flow:ir_grid] || [is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
	if {![regexp {ir$} [get_db flow_report_name]]} {
	    set_db flow_report_name [expr {[string is space [get_db flow_report_name]] ? "ir" : "[get_db flow_report_name].ir"}]
	}
    } elseif {[regexp {block_start|hier_start|eco_start} [get_db flow_step_current]]} {
	set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
    } else {
    }

    #- Create report directory (if necessary)
    file mkdir [file normalize [file join [get_db flow_report_directory] [get_db flow_report_name]]]
}

#- Specify qor html file to generate at the end of every flow
if {[get_db program_short_name]!="modus"} {
    set_db flow_metrics_qor_html [get_db flow_report_directory]/qor.html
}

#===============================================================================
# Common steps used in implementation flow
#===============================================================================

##############################################################################
# STEP block_start
##############################################################################
create_flow_step -name block_start -owner cadence {
}

##############################################################################
# STEP block_finish
##############################################################################
create_flow_step -name block_finish -owner cadence -write_db -categories flow {
    #- Make sure flow_report_name is reset from any reports executed during the flow
    set_db flow_report_name [get_db [lindex [get_db flow_hier_path] end] .name]
    
    if {[get_feature pnr_db_handoff] && [is_flow -quiet -inside flow:syn_opt]} {
        set_db flow_write_db_common true
    } else {
        set_db flow_write_db_common false
    }

    #- Store non-default root attributes to metrics
    catch {report_obj -tcl} flow_root_config
    if {[dict exists $flow_root_config root:/]} {
	set flow_root_config [dict get $flow_root_config root:/]
    } elseif {[dict exists $flow_root_config root:]} {
	set flow_root_config [dict get $flow_root_config root:]
    } else {
    }
    foreach key [dict keys $flow_root_config] {
	if {[string length [dict get $flow_root_config $key]] > 200} {
	    dict set flow_root_config $key "\[long value truncated\]"
	}
    }
    set_metric -name flow.root_config -value $flow_root_config
}

##############################################################################
# STEP activate_views
##############################################################################
create_flow_step -name activate_views -owner cadence {
    set db [get_db flow_starting_db]
    set flow [lindex [get_db flow_hier_path] end]
    set setup_views [get_feature $flow -feature setup_views]
    set hold_views [get_feature $flow -feature hold_views]
    set leakage_view [get_feature $flow -feature leakage_view]
    set dynamic_view [get_feature $flow -feature dynamic_view]
    
    if {($setup_views ne "") || ($hold_views ne "") || ($leakage_view ne "") || ($dynamic_view ne "")} {
	#- use read_db args for DB types and set_analysis_views for TCL
	if {([llength [get_db analysis_views]]) > 0 && \
		([lindex $db 0] eq {tcl} || [lindex $db 0] eq {enc} && [file isfile [lindex $db 1]])} {
	    set cmd "set_analysis_view"
	    if {$setup_views ne ""} {
		append cmd " -setup [list $setup_views]"
	    } else {
		append cmd " -setup [list [get_db [get_db analysis_views -if .is_setup] .name]]"
	    }
	    if {$hold_views ne ""} {
		append cmd " -hold [list $hold_views]"
	    } else {
		append cmd " -hold [list [get_db [get_db analysis_views -if .is_hold] .name]]"
	    }
	    if {$leakage_view ne ""} {
		append cmd " -leakage [list $leakage_view]"
	    } else {
		if {[llength [get_db analysis_views -if .is_leakage]] > 0} {
		    append cmd " -leakage [list [get_db [get_db analysis_views -if .is_leakage] .name]]"
		}
	    }
	    if {$dynamic_view ne ""} {
		append cmd " -dynamic [list $dynamic_view]"
	    } else {
		if {[llength [get_db analysis_views -if .is_dynamic]] > 0} {
		    append cmd " -dynamic [list [get_db [get_db analysis_views -if .is_dynamic] .name]]"
		}
	    }
	    eval $cmd
	} elseif {[llength [get_db analysis_views]] == 0} {
	    set_flowkit_read_db_args -setup_views "$setup_views" -hold_views "$hold_views" -leakage_view "$leakage_view" -dynamic_view "$dynamic_view"
	} else {
	}
    }
}
edit_flow -before Cadence.plugin.flowkit.read_db.pre -prepend flow_step:activate_views
edit_flow -before Cadence.plugin.flowkit.read_db.post -prepend flow_step:activate_views

#===============================================================================
# Common steps used in reporting
#===============================================================================

##############################################################################
# STEP report_start
##############################################################################
create_flow_step -name report_start -owner cadence {
}

##############################################################################
# STEP report_finish
##############################################################################
create_flow_step -name report_finish -owner cadence -categories flow {
}

##############################################################################
# STEP signoff_start
##############################################################################
create_flow_step -name signoff_start -owner cadence {
}

##############################################################################
# STEP signoff_finish
##############################################################################
create_flow_step -name signoff_finish -owner cadence -write_db -categories flow {
}

##############################################################################
# STEP tQuantus extraction
##############################################################################
create_flow_step -name extract_rc -owner cadence {
    if {([get_feature -feature add_pvs_fill] && [is_flow -quiet -after flow:opt_signoff.run_pvs_metal_fill]) ||
    ([get_feature -feature add_pegasus_beol_fill] && [is_flow -quiet -after flow:opt_signoff.run_pegasus_metal_fill])} {
	set_db extract_rc_pvs_fill true
    }	
    #set_multi_cpu_usage -local_cpu 4 -remote_host 1 -cpu_per_remote_host 4    
    extract_rc
    #set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 8
}

##############################################################################
# STEP write extract_rc results to spef-files
##############################################################################
create_flow_step -name write_parasitics -owner cadence {
    set spef_dir  [file normalize [file join [get_db flow_working_directory] [get_db flow_db_directory] [file rootname [get_db flow_report_name]]]]
    puts "Info: Using SPEF-dir: $spef_dir"

    set corners [lsort -u [concat [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .late_rc_corner] \
			       [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .early_rc_corner]]]
    puts "Info: dumping corners $corners"
    
    foreach corner $corners {
	set corner_name [get_db ${corner} .name]
	puts "Info: Writing corner $corner_name to file [file join $spef_dir [get_db flow_vars_design_name].$corner_name.spef.gz]"
	write_parasitics -rc_corner $corner_name -spef_file [file join $spef_dir [get_db flow_vars_design_name].$corner_name.spef.gz]
    }
}

##############################################################################
# STEP read_parasitics
##############################################################################
create_flow_step -name read_parasitics -owner cadence {
    #- initialize annotations using spef
    if {[is_flow -quiet -inside flow:ir_static] || [is_flow -quiet -inside flow:ir_dynamic] || [is_flow -quiet -inside flow:ir_rampup]} {
	set views [get_db analysis_views [get_db power_view]]
	set decoupled "-decoupled"
    } else {
	set views [get_db -u analysis_views -if {.is_setup || .is_hold || .is_leakage}]
	set decoupled ""
    }
    set spef_dir  [file normalize [file join [get_db flow_working_directory] [get_db flow_db_directory] [file rootname [get_db flow_report_name]]]]
    puts "Info: Using SPEF-dir: $spef_dir"
    set corners [lsort -u [concat [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .late_rc_corner] \
			       [get_db -u [get_db delay_corners -if {.is_setup || .is_hold}] .early_rc_corner]]]
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
}

##############################################################################
# STEP schedule_sta
##############################################################################
create_flow_step -name schedule_sta -owner cadence {
    #FlowtoolPredictHint ArgumentRandomise -branch
    if {[get_db flow_branch] ne ""} {
	set branch_name [get_db flow_branch]_[get_db flow_report_name]
    } else {
	set branch_name [get_db flow_report_name]
    }
    
    schedule_flow \
	-flow sta \
	-branch $branch_name \
	-db [file join [get_db flow_db_directory] [get_db flow_report_name] init_sta.tcl] \
	-include_in_metrics \
	-no_sync
}

##############################################################################
# STEP schedule_signoff
##############################################################################
create_flow_step -name schedule_signoff -owner cadence {
    #FlowtoolPredictHint ArgumentRandomise -branch
    if {([get_db flow_branch] ne "") && ([get_db flow_starting_db] eq "")} {
	set branch_name [get_db flow_branch]
    } elseif {([get_db flow_branch] ne "") && ([get_db flow_branch] ne [get_db flow_report_name])} {
	set branch_name [get_db flow_branch]_[get_db flow_report_name]
    } else {
	set branch_name [get_db flow_report_name]
    }
 
    schedule_flow \
	-flow signoff \
	-branch $branch_name \
	-no_sync

}    


##############################################################################
# STEP schedule_signoff_subflows
##############################################################################
create_flow_step -name schedule_signoff_subflows -owner cadence -skip_metric {
    
    #  schedule_flow \
       -flow extract \
       -branch [get_db flow_branch] \
       -tool_options "-log_file [file join [get_db flow_log_directory] extract.[get_db flow_report_name].log] -cmd [file join [get_db flow_db_directory] [get_db flow_report_name] qrc.cmd]" \
       -include_in_metrics \
       -sync

    schedule_flow \
	   -flow sta \
	   -branch [get_db flow_branch] \
	   -db [file join [get_db flow_db_directory] [get_db flow_branch] init_sta.tcl] \
	   -include_in_metrics \
	   -sync
}

################################################################################
# Uncertainty management
################################################################################
create_flow_step -name manage_uncertainty -owner tuni {
    if {0} {
    # only set functional mode clock uncertainties
    set_interactive_constraint_modes [get_db constraint_modes -if {(.is_setup||.is_hold) && .name==*func*} -u]
    set clock_names [get_db -u [get_db clocks -if {.base_name!=*_virtual}] .base_name]

    global mmmc_vars
    # Note TL: Fix these. Clock uncertainties are corner specific, not mode specific
    if {[is_flow -quiet -after flow:opt_signoff] || [is_flow -quiet -inside flow:opt_signoff] ||
	[is_flow -quiet -after flow:sta] || [is_flow -quiet -inside flow:sta]} {
	set stp 0.085
	set hld 0.050
    } elseif {[is_flow -quiet -after flow:floorplan] || [is_flow -quiet -inside flow:floorplan]} {
	set stp 0.105
	set hld 0.065
    } elseif {[is_flow -quiet -after flow:syn_generic] || [is_flow -quiet -inside flow:syn_generic]} {
	set stp 0.105
	set hld 0.065
    } else {
	puts "Error([info script]): flow step out of bounds (syn_generic <-> floorplan <-> sta)"
    }

    puts "Info([info script]): Setting setup uncertainty to $stp, hold uncertainty to $hld"
    foreach clock_name $clock_names {
	set_clock_uncertainty -setup $stp [get_clocks $clock_name]
	set_clock_uncertainty -hold $hld [get_clocks $clock_name]

	if {[llength [get_db clocks -if ".base_name==${clock_name}_virtual && .view_name==*func"]]} {
	    set_clock_uncertainty -setup $stp [get_clocks ${clock_name}_virtual]
	    set_clock_uncertainty -setup $stp -from [get_clocks ${clock_name}_virtual] -to   [get_clocks $clock_name]
	    set_clock_uncertainty -setup $stp -to   [get_clocks ${clock_name}_virtual] -from [get_clocks $clock_name]
	    set_clock_uncertainty -hold $hld [get_clocks ${clock_name}_virtual]
	}
    }
    set_interactive_constraint_modes {}
}
}

##############################################################################
# STEP report_late_paths
##############################################################################
create_flow_step -name report_late_paths -owner flow -exclude_time_metric {
    #- Reports that show detailed timing with Graph Based Analysis (GBA)
    report_timing -max_paths 5   -nworst 1 -path_type endpoint        > [get_db flow_report_directory]/[get_db flow_report_name]/setup.endpoint.rpt
    report_timing -max_paths 1   -nworst 1 -path_type full_clock -net > [get_db flow_report_directory]/[get_db flow_report_name]/setup.worst.rpt
    report_timing -max_paths 500 -nworst 1 -path_type full_clock      > [get_db flow_report_directory]/[get_db flow_report_name]/setup.gba.rpt
    
    #- Reports that show detailed timing with Path Based Analysis (PBA)
    if {[is_flow -quiet -inside flow:sta]} {
	report_timing -max_paths 50 -nworst 1 -path_type full_clock -retime path_slew_propagation > [get_db flow_report_directory]/[get_db flow_report_name]/setup.pba.rpt
    }
}

##############################################################################
# STEP report_early_paths
##############################################################################
create_flow_step -name report_early_paths -owner flow -exclude_time_metric {
    #- Reports that show detailed early timing with Graph Based Analysis (GBA)
    report_timing -early -max_paths 5   -nworst 1 -path_type endpoint        > [get_db flow_report_directory]/[get_db flow_report_name]/hold.endpoint.rpt
    report_timing -early -max_paths 1   -nworst 1 -path_type full_clock -net > [get_db flow_report_directory]/[get_db flow_report_name]/hold.worst.rpt
    report_timing -early -max_paths 500 -nworst 1 -path_type full_clock      > [get_db flow_report_directory]/[get_db flow_report_name]/hold.gba.rpt
    
    #- Reports that show detailed timing with Path Based Analysis (PBA)
    if {[is_flow -quiet -inside flow:sta]} {
	report_timing -early -max_paths 50 -nworst 1 -path_type full_clock -retime path_slew_propagation  > [get_db flow_report_directory]/[get_db flow_report_name]/hold.pba.rpt
    }
}
