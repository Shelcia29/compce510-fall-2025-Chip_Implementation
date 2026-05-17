# Flowkit v19.10-s008_1
#- tempus_steps.tcl : defines Tempus based flow_steps

#=============================================================================
# Flow: sta
#=============================================================================

##############################################################################
# STEP update_timing
##############################################################################
create_flow_step -name update_timing -owner cadence {
    #- update timer for signoff timing reports
    update_timing -full
}

##############################################################################
# Load latency files
##############################################################################
create_flow_step -name tempus_load_latency_files -owner tuni {   
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
}

##############################################################################
# Set propagated clocks
##############################################################################
create_flow_step -name tempus_set_propagated_clock -owner tuni {   
    set_interactive_constraint_modes [all_constraint_modes -active]
    set_propagated_clock [all_clocks]
}

##############################################################################
# Tempus manage derating
##############################################################################
create_flow_step -name tempus_manage_derating -exclude_time_metric -owner tuni {

    global mmmc_vars
    foreach active_av [get_db [get_db analysis_views -if {.is_setup || .is_hold}] .name] {
	# SOCV RC variation
	set_socv_rc_variation_factor -view ${active_av} -late  $mmmc_vars(late_rc_variation_factor)
	set_socv_rc_variation_factor -view ${active_av} -early $mmmc_vars(early_rc_variation_factor)

    }

    set_socv_reporting_nsigma_multiplier -hold $mmmc_vars(timing_socv_analysis_nsigma_multiplier) \
        -setup $mmmc_vars(timing_socv_analysis_nsigma_multiplier) -views [get_db [get_db analysis_views -if {.is_setup || .is_hold}] .name]

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
}

##############################################################################
# STEP check_timing
##############################################################################
create_flow_step -name check_timing -owner cadence -exclude_time_metric {
    #- Reports that check design health
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
    
    #- Reports that describe constraints
    report_clocks                > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report.clocks.rpt]
    report_case_analysis         > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report.case_analysis.rpt]
    #report_inactive_arcs         > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report.inactive_arcs.rpt]
}

##############################################################################
# STEP report_timing_late
##############################################################################
create_flow_step -name report_timing_late -owner cadence -exclude_time_metric -categories setup {
    #- Reports that describe timing health
    report_timing_summary -checks {setup drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.analysis_summary.rpt]
    report_timing_summary -checks {setup drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.view_summary.rpt]
    report_timing_summary -checks {setup drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.group_summary.rpt]
    report_constraint > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report_constraint.summary.rpt]
    report_constraint -late -all_violators -drv_violation_type {max_capacitance max_transition max_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
    set_metric -name timing.drv.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
}

##############################################################################
# STEP report_timing_early
##############################################################################
create_flow_step -name report_timing_early -owner cadence -exclude_time_metric -categories hold {
    #- Reports that describe early timing health
    report_timing_summary -checks {hold drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.analysis_summary.rpt]
    report_timing_summary -checks {hold drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.view_summary.rpt]
    report_timing_summary -checks {hold drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.group_summary.rpt]
    report_constraint -early -all_violators -drv_violation_type {min_capacitance min_transition min_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.all_violators.rpt]
}

############################################################################
# STEP write_timing_db
############################################################################
create_flow_step -name write_timing_db -owner cadence -exclude_time_metric {
    write_eco_opt_db
}

############################################################################
# STEP schedule_sta_eco
############################################################################
create_flow_step -name schedule_sta_eco -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow sta_eco \
	-branch [get_db flow_branch] \
	-db [get_db flow_starting_db] \
	-include_in_metrics \
	-no_sync
}

#=============================================================================
# Flow: sta_eco
#=============================================================================
############################################################################
# STEP run_sta_opt_signoff
############################################################################
create_flow_step -name run_sta_opt_signoff -owner cadence {
    #- perform signoff based DRV optimization
    file mkdir [file join [get_db flow_report_directory] [get_db flow_report_name] eco.drv]
    set_db opt_signoff_eco_file_prefix  [file join [get_db flow_report_directory] [get_db flow_report_name] eco.drv [get_db current_design .name]]
    push_snapshot_stack
    opt_signoff -drv
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -drv" -auto min
    
    #- perform signoff based setup optimization
    file mkdir [file join [get_db flow_report_directory] [get_db flow_report_name] eco.setup]
    set_db opt_signoff_eco_file_prefix  [file join [get_db flow_report_directory] [get_db flow_report_name] eco.setup [get_db current_design .name]]
    push_snapshot_stack
    opt_signoff -setup
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -setup" -auto min
    
    #- perform signoff based hold optimization
    file mkdir [file join [get_db flow_report_directory] [get_db flow_report_name] eco.hold]
    set_db opt_signoff_eco_file_prefix  [file join [get_db flow_report_directory] [get_db flow_report_name] eco.hold [get_db current_design .name]]
    push_snapshot_stack
    opt_signoff -hold
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -hold" -auto min
}

############################################################################
# STEP write_eco
############################################################################
create_flow_step -name write_eco -owner cadence {
    write_eco -format innovus [file join [get_db flow_report_directory] [get_db flow_report_name] eco.innovus.tcl]
    write_eco -format tempus [file join [get_db flow_report_directory] [get_db flow_report_name] eco.tempus.tcl]
}

############################################################################
# STEP write_sdf
############################################################################
create_flow_step -name write_sdf -owner tuni {
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
        file mkdir $out_dir
    }

    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application sta     -gate_level_sim_model ${out_dir}/[get_db current_design .name].gatesim.sta.sdf.gz
    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application verilog -gate_level_sim_model ${out_dir}/[get_db current_design .name].gatesim.verilog.sdf.gz
    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application sta     ${out_dir}/[get_db current_design .name].sta.sdf.gz
    write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application verilog ${out_dir}/[get_db current_design .name].verilog.sdf.gz

    # Write sdf cmd file for xcelium
    file mkdir compiled_sdf
    set fp [open compiled_sdf/sdf.cmd w]
    set instance_name [get_db flow_vars_design_name]_inst
    puts $fp "COMPILED_SDF_FILE = \"[get_db flow_vars_data_directory]/compiled_sdf/[get_db flow_vars_design_name].verilog.sdf.gz.X\","
    puts $fp "SCOPE = \"\$\{TESTBENCH\}.$instance_name\","
    puts $fp "MTM_CONTROL = \"\$\{MTM\}\";"
    puts $fp ""
    foreach sdf [get_db flow_vars_sdf_list] {
        set module [lindex [split [file tail $sdf] .] 0]
        # Note flat sta, macros as hinsts
        foreach inst [get_db hinsts -if {.module.name==$module}] {
            puts $fp "COMPILED_SDF_FILE = \"[get_db flow_vars_data_directory]/compiled_sdf/[file tail $sdf].X\","
            puts $fp "SCOPE = \"\$\{TESTBENCH\}.$instance_name.[string map {/ .} [get_db $inst .name]]\","
            puts $fp "MTM_CONTROL = \"\$\{MTM\}\";"
            puts $fp ""
        }
    }
    close $fp

    # Compile
    set_db flow_vars_sdf_list [concat [get_db flow_vars_sdf_list] ${out_dir}/[get_db flow_vars_design_name].verilog.sdf.gz]
    file copy -force [get_db flow_source_directory]/../../dft/templates/compile_sdf.sh [get_db flow_vars_data_directory]/compiled_sdf
    exec sed -i s:SDF_LIST:\([get_db flow_vars_sdf_list]\):g [get_db flow_vars_data_directory]/compiled_sdf/compile_sdf.sh
    catch {exec -ignorestderr [get_db flow_vars_data_directory]/compiled_sdf/compile_sdf.sh}
}

##############################################################################
# ETM model generation
##############################################################################
create_flow_step -name tempus_generate_etm -exclude_time_metric -owner tuni {
    if {![file exists models]} {file mkdir models}
    if {![file exists models/[get_db flow_report_name]]} {file mkdir models/[get_db flow_report_name]}
    set spef_dir  [file normalize [file join [get_db flow_working_directory] [get_db flow_db_directory] [file rootname [get_db flow_report_name]]]]
    puts "Info: Using SPEF-dir: $spef_dir"
    set active_setup_views [get_db [get_db analysis_views -if {.is_setup||.is_leakage||.is_dynamic}] .name]
    set active_hold_views [get_db [get_db analysis_views -if {.is_hold}] .name]

    # ETM model must be generated with the following setting
    set_db timing_extract_model_slew_propagation_mode path_based_slew
    # The following setting speeds up ETM generation
    set_db timing_enable_timing_window_pessimism_removal false

    # do ETM models only for PNR views
    set pnr_aviews [get_db analysis_views  "[get_db  flow_vars_setup_pnr_active_views] [get_db flow_vars_hold_pnr_active_views]"]
    set pnr_corners [get_db -u ${pnr_aviews} .delay_corner.late_rc_corner.name]
    #set all_corners [get_db -u [get_db analysis_views -if {.is_setup||.is_hold||.is_leakage||.is_dynamic}] .delay_corner.late_rc_corner.name]
    #set all_aviews [get_db analysis_views -if {(.is_setup||.is_hold||.is_leakage||.is_dynamic)}]
    foreach corner_name $pnr_corners {

	# rc_corner for which we read parasitics must be active, so we must first activate one before reading spef.
	foreach view_dpo $pnr_aviews {
	    if {[get_db $view_dpo .delay_corner.late_rc_corner.name] == $corner_name} {
		puts "Info: Temp set_analysis_view in order to load parasitics"
		set_analysis_view -setup [get_db $view_dpo .name] -hold [get_db $view_dpo .name]
		break
	    }
	}
	set spef_file [glob -nocomplain -directory ${spef_dir} *.${corner_name}.spef*]
	puts "Info: Reading SPEF-file ${spef_file} for corner $corner_name"
	read_spef -rc_corner ${corner_name} ${spef_file}

	foreach view_dpo $pnr_aviews {
	    if {[get_db $view_dpo .delay_corner.late_rc_corner.name] == $corner_name} {
		puts "Info: Writing timing model for analysis_view [get_db $view_dpo .name]"
		set_analysis_view -setup [get_db $view_dpo .name] -hold [get_db $view_dpo .name]
		
		write_timing_model -include_power_ground [file join models [get_db flow_report_name] [get_db [current_design] .name].[get_db $view_dpo .name].lib] -view [get_db $view_dpo .name]
	    }
	}
    }
    #set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 8
    
    # merge .libs to one single multimode file
    foreach corner_name [get_db -u [get_db analysis_views "[get_db  flow_vars_setup_pnr_active_views] [get_db flow_vars_hold_pnr_active_views]"] .delay_corner.name] {

        set constraint_modes [join [get_db -u analysis_views .constraint_mode.name] ","]
        set files [glob models/[get_db flow_report_name]/[get_db [current_design] .name].${corner_name}_{${constraint_modes}}.lib]
	if {![llength $files]} {
	    puts "Error: No files corresponding to corner: ${corner_name} and constraint_modes: ${constraint_modes} in models/[get_db flow_report_name]/"
	    continue
	}
	set mode_list [list ]
	set mode_group ""
	foreach ff $files {
	    set mode ""
	    set cmodes [regsub -all "," $constraint_modes "|"]
	    if {![regexp "_(${cmodes})\.lib" $ff -> mode]} {
		puts "Error: Bad filename $ff"
		continue
	    }
	    lappend mode_list $mode
	    if {$mode_group == ""} {
		set mode_group $mode
	    } else {
		set mode_group ${mode_group}_${mode}
	    }
	}

        if {[llength $files] > 1} {
            merge_model_timing -input_library_file $files \
                -mode_group $mode_group \
                -modes $mode_list \
                -merged_library_file models/[get_db flow_report_name]/[get_db [current_design] .name].${corner_name}.lib
        } else {
            # we only have one mode
            exec cp [lindex $files 0] models/[get_db flow_report_name]/[get_db [current_design] .name].${corner_name}.lib
        }
    }

    set_analysis_view -setup $active_setup_views -hold $active_hold_views
}

##############################################################################
# Post STA
##############################################################################
create_flow_step -name post_sta -exclude_time_metric -owner tuni {
    if {[get_db flow_branch] ne ""} {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_branch]_[get_db flow_report_name]]
    } else {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    }
    close [open $out_dir/post_sta.tcl w]

    set_db flow_post_db_overwrite $out_dir/post_sta.tcl
}
