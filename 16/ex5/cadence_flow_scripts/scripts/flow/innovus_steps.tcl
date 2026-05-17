# Flowkit v19.10-s008_1
# Time-stamp: <2025-09-23 16:50:20 qftele>
#- innovus_steps.tcl : defines Innovus based flow_steps

#=============================================================================
# Flow: floorplan
#=============================================================================

##############################################################################
# STEP init_floorplan
##############################################################################
create_flow_step -name init_floorplan -owner design {
    if {[file exists floorplan_def/[get_db flow_vars_design_name].pso]} {
        read_power_switches -in_file floorplan_def/[get_db flow_vars_design_name].pso
    }
    
    if {![get_feature pnr_db_handoff]} {
        if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
            read_def  dbs/syn_opt/[get_db flow_vars_design_name].def.gz
        } else {
            read_def  [get_db flow_vars_floorplan_def]
        }
    }
    
    if {![llength [get_db route_rules ndr_cts_2w25s_leaf]]} {
        create_route_rule -name ndr_cts_2w25s_leaf -width {M1:M6 0.1} -spacing {M1:M6 0.1}
    }
    if {![llength [get_db route_rules ndr_cts_2w25s_trunk]]} {
        create_route_rule -name ndr_cts_2w25s_trunk -width {M1:M6 0.1 M7:M8 0.2} -spacing {M1:M6 0.1 M7:M8 0.2}
    }

    create_route_type -name cts_route_type_top -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_trunk -top_preferred_layer 8 -bottom_preferred_layer 7 -shield_net VSS
    create_route_type -name cts_route_type_trunk -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_trunk -top_preferred_layer 8 -bottom_preferred_layer 2 -shield_net VSS
    create_route_type -name cts_route_type_leaf -preferred_routing_layer_effort medium -route_rule ndr_cts_2w25s_leaf -top_preferred_layer 6 -bottom_preferred_layer 2 -shield_net VSS

    # VDDAON (secondary pg) NDR
    if {![llength [get_db route_rules ndr_vddaon]]} {
        create_route_rule -name ndr_vddaon -width {M1:M6 0.2 M7:M8 0.4}
    }
    create_route_type -name vddaon_ndr_route_type -stack_distance 0.001 -min_stack_layer 4 -preferred_routing_layer_effort high -route_rule ndr_vddaon -top_preferred_layer 6 -bottom_preferred_layer 5

    if {![get_feature pnr_db_handoff]} {
        # commit power intent only after reading in .def
        commit_power_intent -verbose
    }

    if {[file exists scripts/post_init_floorplan.tcl]} {
        source scripts/post_init_floorplan.tcl
    }

}

##############################################################################
# STEP create_path_groups
##############################################################################
create_flow_step -name create_path_groups -owner tuni {
    #- Clear existing path_groups
    reset_path_group -all

    #- Add basic path_groups
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
}


##############################################################################
# STEP add_tracks
##############################################################################
create_flow_step -name check_tracks -owner cadence {
    #- generate tracks after creating floorplan
    if {[llength [get_db current_design .track_patterns]] == 0} {
	puts "Fatal: Design floorplan does not contain track patterns. Redo floorplan"
	exit(1)
    }
}

##############################################################################
# Innovus manage derating
##############################################################################
create_flow_step -name innovus_manage_derating -exclude_time_metric -owner tuni {

    # socv not implemented yet
    if {0} {
    foreach active_av [get_db [get_db analysis_views -if {.is_setup || .is_hold}] .name] {
	# SOCV RC variation
	set_socv_rc_variation_factor -view ${active_av} -late  0.100000
	set_socv_rc_variation_factor -view ${active_av} -early 0.100000
    }
    }

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
}

##############################################################################
# Innovus set implementation analysis views
##############################################################################
create_flow_step -name innovus_activate_all_views -exclude_time_metric -owner tuni {

    # Enabled all views which are active in STA
    set_analysis_view \
        -setup             [get_db flow_vars_setup_sta_active_views]  \
        -hold              [get_db flow_vars_hold_sta_active_views]  \
        -leakage           [get_db flow_vars_power_view] \
        -dynamic           [get_db flow_vars_power_view]
}

##############################################################################
# Save latency files
##############################################################################
create_flow_step -name innovus_save_latency_files -owner tuni {   
    if {![file exists [get_db flow_database_directory]/latency_files]} {file mkdir [get_db flow_database_directory]/latency_files}
    foreach dpo [get_db analysis_views] {
	if {[get_db $dpo .latency_file] != ""} {
	    file copy -force [get_db $dpo .latency_file] [file join [get_db flow_database_directory]/latency_files [get_db $dpo .name]_latency.sdc]
	}
    }
}

##############################################################################
# Abstract model generation
##############################################################################
create_flow_step -name generate_abstract -exclude_time_metric -owner tuni {
    if {![file exists models]} {file mkdir models}

    # get top layer
    set top_idx -42
    set top_layer M1
    get_db layers -foreach {
        puts "r_idx: [get_db $object .route_index]"
        if {[get_db $object .route_index] > $top_idx} {
            set top_idx [get_db $object .route_index]
            set top_layer [get_db $object .name]
        }
    }

    # to add antenna information to LEF
    check_process_antenna
    write_lef_abstract -exclude_obs_layers $top_layer -stripe_pins -pg_pin_layers 10 [file join models [get_db flow_report_name] [get_db [current_design] .name].lef]
}

##############################################################################
# ETM model generation
##############################################################################
create_flow_step -name innovus_generate_etm -exclude_time_metric -owner tuni {
    if {![file exists models]} {file mkdir models}
    if {![file exists models/[get_db flow_report_name]]} {file mkdir models/[get_db flow_report_name]}
    set spef_dir  [file normalize [file join [get_db flow_working_directory] [get_db flow_db_directory] [file rootname [get_db flow_report_name]]]]
    puts "Info: Using SPEF-dir: $spef_dir"
    set active_setup_views [get_db [get_db analysis_views -if {.is_setup||.is_leakage||.is_dynamic}] .name]
    set active_hold_views [get_db [get_db analysis_views -if {.is_hold}] .name]
    #set_multi_cpu_usage -local_cpu 4 -remote_host 1 -cpu_per_remote_host 4
    foreach view_dpo [get_db analysis_views -if {.is_setup||.is_hold||.is_leakage||.is_dynamic}] {
	puts "Info: Writing timing model for analysis_view [get_db $view_dpo .name]"
	set_analysis_view -setup [get_db $view_dpo .name] -hold [get_db $view_dpo .name]
	# Note, TL. Parasitics are extracted only after route step
	if {[is_flow -quiet -after flow:route]} {
	    set corner_name [get_db $view_dpo .delay_corner.late_rc_corner.name]
	    set spef_file [glob -nocomplain -directory ${spef_dir} *.${corner_name}.spef*]
	    puts "Info: Reading SPEF-file ${spef_file} for corner $corner_name"
	    read_spef -rc_corner ${corner_name} ${spef_file}
	}
	write_timing_model -include_power_ground [file join models [get_db flow_report_name] [get_db [current_design] .name].[get_db $view_dpo .name].lib] -view [get_db $view_dpo .name]
    }
    #set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 8

    set_analysis_view -setup $active_setup_views -hold $active_hold_views
    
    # merge .libs to one single multimode file
    foreach corner_name [get_db -u [get_db analysis_views -if {.is_setup||.is_hold||.is_leakage||.is_dynamic}] .delay_corner.name] {

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

	merge_model_timing -input_library_file $files \
	    -mode_group $mode_group \
	    -modes $mode_list \
	    -merged_library_file models/[get_db flow_report_name]/[get_db [current_design] .name].${corner_name}.lib
    }
}

#===========================================================================
# Flow: prects
#===========================================================================


##############################################################################
# STEP pre_run_place_opt
##############################################################################
create_flow_step -name pre_run_place_opt -owner cadence {
    if {[file exists scripts/pre_run_place_opt.tcl]} {
        puts "Info: Sourcing scripts/pre_run_place_opt.tcl"
        source scripts/pre_run_place_opt.tcl
    }
}

##############################################################################
# STEP run_place_opt
##############################################################################
create_flow_step -name run_place_opt -owner cadence {
    #- perform global placement and ideal clock setup optimization
    if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
	place_opt_design -incremental -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix place_opt_design
    } else {
	place_opt_design -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix place_opt_design
    }
}

#=============================================================================
# Flow: cts
#=============================================================================

##############################################################################
# STEP add_clock_spec
##############################################################################
create_flow_step -name add_clock_spec -owner cadence {

    if {[file exists scripts/clock_tree_spec.tcl]} {
        puts "Info: Sourcing scripts/clock_tree_spec.tcl"
        source scripts/clock_tree_spec.tcl
    } else {
        #- automatically create clock spec if one is not available
        if {[llength [get_db clock_trees]] == 0} {
            create_clock_tree_spec
        } else {
            puts "INFO: reusing existing clock tree spec"
            puts "        to reload a new one use 'delete_clock_tree_spec' and 'read_ccopt_config"
        }
    }
}

##############################################################################
# STEP add_clock_tree
##############################################################################
create_flow_step -name add_clock_tree -owner cadence {
    if {![get_db opt_enable_podv2_clock_opt_flow]} {
        #- implement clock trees and propagated clock setup optimization
        ccopt_design -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix ccopt_design
    } else {
        clock_opt_design -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix clock_opt_design
    }
}

##############################################################################
# STEP add_tieoffs
##############################################################################
create_flow_step -name add_tieoffs -owner cadence {
    #- insert dedicated tieoff models
    if {[get_db add_tieoffs_cells] ne "" } {
	delete_tieoffs
	#add_tieoffs -matching_power_domains true
        puts "Warning: add_tiedoffs without matching_power_domains"
	add_tieoffs
    }
}

#=============================================================================
# Flow: postcts
#=============================================================================

##########################################################################
# STEP run_opt_postcts_hold
##########################################################################
create_flow_step -name run_opt_postcts_hold -owner cadence {
    #- perform postcts setup & hold optimization
    opt_design -post_cts -hold -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_design_post_cts_hold
}

#=============================================================================
# Flow: route
#=============================================================================

##############################################################################
# STEP add_fillers
##############################################################################
create_flow_step -name add_fillers -owner cadence {
    #- insert filler cells before final routing
    if {[get_db add_fillers_cells] ne "" } {
	add_fillers
    }
}

##############################################################################
# STEP run_route
##############################################################################
create_flow_step -name run_route -owner cadence {
    #- perform detail routing and DRC cleanup
    route_design
}

##############################################################################
# STEP run_route_secondary_nets
##############################################################################
create_flow_step -name run_route_secondary_nets -owner design {

    # set secondary PG pins to use signal router
    foreach bc [get_db base_cells PT*] {
        set_pg_pins_use_signal_route [get_db ${bc} .name]:TVDD
    }
    foreach bc [get_db base_cells LVLSRLHCRBD*BWP30P140LVT] {
        set_pg_pins_use_signal_route [get_db ${bc} .name]:VDDS
    }
    foreach bc [get_db base_cells LVLLHD*BWP30P140LVT] {
        set_pg_pins_use_signal_route [get_db ${bc} .name]:VDDL
    }
    foreach bc [get_db base_cells ISOSRLOD*BWP30P140LVT] {
        set_pg_pins_use_signal_route [get_db ${bc} .name]:VDDS
    }

    #- route secondary PG nets to e.g. level shifters and isolation cells
    set_route_attributes -nets VDDAON -skip_routing false
    route_secondary_pg_pins -nets VDDAON \
        -pattern trunk \
        -max_pins_per_trunk 1 \
        -non_default_rule ndr_vddaon
    set_route_attributes -nets VDDAON -skip_routing true
}

##############################################################################
# STEP run_route_eco_secondary_nets
##############################################################################
create_flow_step -name run_route_eco_secondary_nets -owner design {

    # connect always-on cells added at postroute or opt_signoff -stage
    set_route_attributes -nets VDDAON -skip_routing false -top_preferred_routing_layer M6 -bottom_preferred_routing_layer M5 -preferred_routing_layer_effort low -pattern trunk -stack_distance 0.001 -min_stack_layer 4 -route_rule ndr_vddaon
    deselect_obj -all
    select_obj [get_db nets VDDAON]
    set_db route_design_with_eco true
    set_db route_design_selected_net_only true
    route_global_detail
    set_route_attributes -nets VDDAON -skip_routing true
    set_db route_design_with_eco false
    set_db route_design_selected_net_only false
}

##############################################################################
# STEP fix_route_drc
##############################################################################
create_flow_step -name fix_route_drc -owner design {
    # check for possible routing DRCs and fix
    # delete possible existing markers
    delete_drc_markers
    # check for routing drcs
    check_drc -check_only regular
    # if errors, fix
    if {[llength [get_db markers -if {.type=="drc"}]]} {
        route_eco -fix_drc
    }
}

#=============================================================================
# Flow: postroute
#=============================================================================

##########################################################################
# STEP run_opt_postroute_setup
##########################################################################
create_flow_step -name run_opt_postroute_setup -owner cadence {
    #- perform postroute and SI based setup optimization
    opt_design -post_route -setup -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_design_post_route_setup
}

##########################################################################
# STEP run_opt_postroute_hold
##########################################################################
create_flow_step -name run_opt_postroute_hold -owner cadence {
    #- perform postroute and SI based hold optimization
    opt_design -post_route -hold -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_design_post_route_hold
}

##########################################################################
# STEP run_opt_postroute
##########################################################################
create_flow_step -name run_opt_postroute -owner cadence {
    #- perform postroute and SI based setup optimization
    opt_design -post_route -setup -hold -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_design_post_route_setup_hold
}

#=============================================================================
# Flow: opt_signoff
#=============================================================================

##########################################################################
# STEP run_opt_signoff
##########################################################################
create_flow_step -name run_opt_signoff -owner cadence {
    #- perform signoff based optimization
    push_snapshot_stack
    opt_signoff -drv -no_eco_route -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_signoff_drv
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -drv" -auto min
    
    push_snapshot_stack
    opt_signoff -setup -no_eco_route -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_signoff_setup
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -setup" -auto min
    
    push_snapshot_stack
    opt_signoff -hold -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_signoff_hold
    pop_snapshot_stack
    create_snapshot -name "opt_signoff -hold" -auto min
}

#=============================================================================
# Flow: eco
#=============================================================================

############################################################################
# STEP eco_start
############################################################################
create_flow_step -name eco_start -owner cadence {
}

############################################################################
# STEP run_place_eco
############################################################################
create_flow_step -name run_place_eco -owner cadence {
    place_eco
}

############################################################################
# STEP run_route_eco
############################################################################
create_flow_step -name run_route_eco -owner cadence {
    route_eco
}

##########################################################################
# STEP run_opt_eco
##########################################################################
create_flow_step -name run_opt_eco -owner cadence {
    opt_design -post_route -setup -hold -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix opt_design_post_route_setup_hold
}

############################################################################
# STEP eco_finish
############################################################################
create_flow_step -name eco_finish -owner cadence -write_db {
}

#===========================================================================
# Flow: report_innovus
#===========================================================================

############################################################################
# STEP write_lec_constraints
############################################################################
create_flow_step -name write_lec_constraints -owner cadence -exclude_time_metric {
    # Innovus scan lec constraints
    file mkdir  [file join [string map [list %s [get_db current_design .name]] [get_db write_lec_directory_naming_style]]]
    set FH [open [file join [string map [list %s [get_db current_design .name]] [get_db write_lec_directory_naming_style]] lec.[get_db flow_report_name].pre_compare] "w"]
    
    foreach pin [get_db [get_db ports {scan_enable* WRSTN* WEXT}] .name] {
        puts $FH "add_pin_constraints 0 \{$pin\} -both"
    }
    foreach pin [get_db [get_db [get_db insts {*lockup_latch* *lockup_flop*}] .pins -if {.base_name==D}] .name] {
        puts $FH "add_primary_input \{$pin\} -both"
        puts $FH "add_ignored_inputs \{$pin\} -both"
    }
    foreach mc [get_db -u [get_db insts -if {.is_memory}] .base_cell] {
        foreach msp [get_db $mc .base_pins.base_name *si*] {
            puts $FH "add_ignored_inputs \{$msp\} -module [get_db $mc .base_name] -both"
        }
    }
    foreach cb [get_db -u [get_db insts -if {.is_macro && !.is_memory}] .base_cell] {
        foreach msp [get_db $cb .base_pins.base_name *scan_in*] {
            puts $FH "add_ignored_inputs \{$msp\} -module [get_db $cb .base_name] -both"
        }
    }

    close $FH
}

############################################################################
# STEP innovus_to_lec
############################################################################
create_flow_step -name innovus_to_lec -owner flow {
    #- write dofile for LEC
    if {[is_flow -inside flow:floorplan]} {
	write_do_lec \
	    -flat \
	    -log_file [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
	    lec.[get_db flow_report_name].do
    } else {
	write_do_lec \
	    -flat \
	    -pre_compare [file join [string map [list %s [get_db current_design .name]] [get_db write_lec_directory_naming_style]] lec.[get_db flow_report_name].pre_compare] \
	    -log_file [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
	    lec.[get_db flow_report_name].do
    }
    
    #- schedule the LEC flow
    #FlowtoolPredictHint ArgumentRandomise -branch
    schedule_flow \
	-flow lec \
	-branch [get_db flow_report_name] \
	-no_db \
	-no_sync \
	-tool_options "-nogui -lp -do [file join [string map [list %s [get_db current_design .name]] [get_db write_lec_directory_naming_style]] lec.[get_db flow_report_name].do]"
}

############################################################################
# STEP innovus_to_clp
############################################################################
create_flow_step -name innovus_to_clp -owner flow {
    
    run_clp -setup_only
    
    #- schedule the clp flow
    schedule_flow \
        -flow clp \
        -branch [get_db flow_report_name] \
        -no_db \
        -no_sync \
        -tool_options "-nogui -lp -1801 -verify -do clp_input/feclp.tcl"
}


##############################################################################
# STEP innovus_to_quantus
##############################################################################
create_flow_step -name innovus_to_quantus -owner cadence {
    #- create output location
    if {[get_db flow_branch] ne ""} {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_branch]_[get_db flow_report_name]]
    } else {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    }
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }
    
    #- write extraction command file
    #set_multi_cpu_usage -local_cpu 4 -remote_host 1 -cpu_per_remote_host 4
    write_extraction_spec -out_dir $out_dir
    #set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 8
    puts "Info: sleep until qrc.cmd -file is visible"
    exec sleep 1
    set count 0
    while {![file exists qrc.cmd]} {
	puts "Info: Sleeping..."
	exec sleep 1
	incr count
	
	if {$count >= 30} {
	    puts "Fatal: qrc.cmd -file not populated into workspace"
	    exit 0
	}
    }

    puts "Info: renaming qrc.cmd to [file join $out_dir qrc.cmd]"
    file rename -force qrc.cmd [file join $out_dir qrc.cmd]
}

##############################################################################
# STEP innovus_to_tempus
##############################################################################
create_flow_step -name innovus_to_tempus -owner cadence {
    #- create output location
    set design  [get_db [current_design] .name]

    if {[get_db flow_branch] ne ""} {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_branch]_[get_db flow_report_name]]
    } else {
	set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    }

    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }

    #- write design and library information
    write_netlist -top_module_first -top_module $design [file join $out_dir $design.v.gz]

    #- write init_design sequence for STA flow
    set FH [open $out_dir/init_sta.tcl w]
    if {[file exists scripts/mmmc_config.tcl]} {
	puts $FH "read_mmmc scripts/mmmc_config.tcl"
    } else {
	puts $FH "read_mmmc \[get_db flow_source_directory\]/mmmc_config.tcl"
    }

    puts $FH "set netlist_list \[list \\"
    puts $FH "dbs/opt_signoff/[get_db flow_vars_design_name].v.gz \\"
    puts $FH "\]"
    puts $FH ""
    puts $FH "# All subsystems need to be defined in local_macro_setup!"
    puts $FH "foreach {blockname blockpath} \[array get local_macro_exportdir\] {"
    puts $FH "    lappend netlist_list \${blockpath}/dbs/opt_signoff/\${blockname}.v.gz"
    puts $FH "}"
    puts $FH ""
    puts $FH "read_netlist \"\${netlist_list}\""
    puts $FH "set STA_SIGNOFF 1"
    puts $FH "init_design"
    puts $FH "read_power_intent -1801 [get_db flow_vars_power_intent]"
    puts $FH "commit_power_intent -verbose"
    puts $FH "set_db flow_report_name [get_db flow_report_name]"
    puts $FH "read_activity_file -format TCF dbs/syn_opt/[get_db flow_vars_design_name].tcf"

    get_db insts -if {.is_macro && !.is_memory} -foreach {puts $FH "set_spef_transform -inst [get_db $object .name] -orient [get_db $object .orient] -x_offset [get_db $object .location.x] -y_offset [get_db $object .location.y]"}

    close $FH

    set_db flow_post_db_overwrite $out_dir/init_sta.tcl
}

############################################################################
# STEP schedule_report_floorplan
############################################################################
create_flow_step -name schedule_report_floorplan -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_floorplan  \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

############################################################################
# STEP schedule_report_prects
############################################################################
create_flow_step -name schedule_report_prects -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_prects  \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

############################################################################
# STEP schedule_report_postcts
############################################################################
create_flow_step -name schedule_report_postcts -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_postcts  \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

############################################################################
# STEP schedule_report_postroute
############################################################################
create_flow_step -name schedule_report_postroute -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_postroute  \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

##############################################################################
# STEP report_check_design
##############################################################################
create_flow_step -name report_check_design -owner cadence -exclude_time_metric -categories design {
    if {[is_flow -inside flow:report_postroute]} {
	check_design -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.design.tcl] -type {power_intent timing place opt cts route}
    } elseif {[is_flow -inside flow:report_postcts]} {
	check_design -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.design.tcl] -type {power_intent timing place opt cts}
    } else {
	check_design -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check.design.tcl] -type {power_intent timing place opt}
    }
}

##############################################################################
# STEP report_area_innovus
##############################################################################
create_flow_step -name report_area_innovus -owner cadence -exclude_time_metric -categories design {
    report_summary -no_html -out_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]qor.rpt]
    report_area  -min_count 1000 -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.summary.rpt]
}

##############################################################################
# STEP report_timing_late_innovus
##############################################################################
create_flow_step -name report_timing_late_innovus -owner cadence -exclude_time_metric -categories setup {
    #- Update the timer for setup and write reports
    time_design -expanded_views -report_only -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix time_design_expanded_views
    
    #- Reports that describe timing health
    report_timing_summary -checks {setup drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.analysis_summary.rpt]
    report_timing_summary -checks {setup drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.view_summary.rpt]
    report_timing_summary -checks {setup drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.group_summary.rpt]
    report_constraint -late -all_violators -drv_violation_type {max_capacitance max_transition max_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
    set_metric -name timing.drv.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]setup.all_violators.rpt]
}

##############################################################################
# STEP report_timing_early_innovus
##############################################################################
create_flow_step -name report_timing_early_innovus -owner cadence -exclude_time_metric -categories hold {
    #- Update the timer for hold and write reports
    time_design -expanded_views -hold -report_only -report_dir [file join [get_db flow_report_directory] [get_db flow_report_name]] -report_prefix time_design_expanded_views_hold
    
    #- Reports that describe timing health
    report_timing_summary -checks {hold drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.analysis_summary.rpt]
    report_timing_summary -checks {hold drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.view_summary.rpt]
    report_timing_summary -checks {hold drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.group_summary.rpt]
    report_constraint -early -all_violators -drv_violation_type {min_capacitance min_transition min_fanout} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]hold.all_violators.rpt]
}

##############################################################################
# STEP report_clock_timing
##############################################################################
create_flow_step -name report_clock_timing -owner cadence -exclude_time_metric -categories clock {
    #- Reports that check clock implementation
    report_clock_timing -type summary > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]clock.summary.rpt]
    report_clock_timing -type latency > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]clock.latency.rpt]
    report_clock_timing -type skew    > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]clock.skew.rpt]
}

##############################################################################
# STEP report_power_innovus
##############################################################################
create_flow_step -name report_power_innovus -owner cadence -exclude_time_metric -categories power {
    report_power -no_wrap -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]power.all.rpt]
}

##############################################################################
# STEP report_route_process
##############################################################################
create_flow_step -name report_route_process -owner cadence -exclude_time_metric {
    #- Reports that process rules
    check_process_antenna -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.antenna.rpt]
    check_filler -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.filler.rpt]
    set_metric -name check.drc.antenna.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]route.antenna.rpt]
}

##############################################################################
# STEP report_route_drc
##############################################################################
create_flow_step -name report_route_drc -owner cadence -exclude_time_metric -categories route {
    #- Reports that check signal routing
    if {[is_flow -inside flow:report_floorplan]} {
	check_drc -check_only special -ignore_trial_route -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.drc.rpt]
    } else {
	check_drc -check_only special -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.special.drc.rpt]
	check_drc -check_only regular -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.regular.drc.rpt]
        check_connectivity -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.open.rpt]
    }
    set_metric -name check.drc.report_file -value [file join [get_db flow_report_name] [get_db flow_report_prefix]route.drc.rpt]
}

##############################################################################
# STEP report_route_density
##############################################################################
create_flow_step -name report_route_density -owner cadence -exclude_time_metric {
    check_metal_density -report [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.metal_density.rpt]
    check_cut_density -out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]route.cut_density.rpt]
}
  
############################################################################
# STEP trim_metal_fill
############################################################################
create_flow_step -name trim_metal_fill -owner flow {
    if {0} {
	trim_metal_fill_near_net \
	    -clock \
	    -create_fill_blockage FILL
    }
}

############################################################################
# STEP write_stream_for_fill
############################################################################
create_flow_step -name write_stream_for_fill -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }

    write_stream \
	-die_area_as_boundary \
	-format stream \
	-map_file [get_db flow_vars_gdsout_stream_map_file] \
	-output_macros \
	-unit 1000 \
	-mode ALL \
	$out_dir/$design.prefill.gds.gz
}

############################################################################
# STEP run_pvs_metal_fill
############################################################################
create_flow_step -name run_pvs_metal_fill -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }
    
    run_pvs_metal_fill \
	-stream_file $out_dir/$design.prefill.gds.gz \
	-layer_map_file [get_db flow_vars_gdsout_stream_map_file] \
	-layer_map_table [get_db flow_vars_gdsout_layer_map_table] \
	-rule_file [get_db flow_vars_pvs_metal_fill_rule_file] \
	-cell $design \
	-working_dir PVS_FILL \
	-extra_pvs_options "-dp 16 -license_timeout 5"

}

############################################################################
# STEP run_pegasus_metal_fill
############################################################################
create_flow_step -name run_pegasus_metal_fill -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }

    /opt/soc/tech/gf22/tech/FILLGEN/Pegasus/run_pegasus \
        -l $out_dir/$design.prefill.gds.gz \
        -ln $design \
        -tech [get_db flow_vars_pegasus_metal_fill_rule_file] \
        -output_filename fill.gds \
        -output_type gds \
        -setup scripts/beol_fill.setup \
        -boundary_layer_override OUTLINE \
        -tiles_gen_layer_override OPTION3_10M_2Mx_6Cx_2Ix_LB_SELECT \
        -ncpu 16
    
    set_metal_fill_signoff_config \
        -output_macros \
        -layer_map_file scripts/gf22_gdsout_layer_map_file.map \
        -layer_map_table [get_db flow_vars_gdsout_layer_map_table] \
        -rule_file ${design}.pegasus.tech \
        -tmp_working_dir PEGASUS_BEOL_FILL \
        -distributed 16 \
        -license_timeout 5

    add_metal_fill_signoff \
        -fill
}

############################################################################
# STEP run_pegasus_beolfeol_fill
############################################################################
create_flow_step -name run_pegasus_feol_fill -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
        file mkdir $out_dir
    }
    
    /opt/soc/tech/gf22/tech/FILLGEN/Pegasus/run_pegasus \
        -l $out_dir/$design.prefill.gds.gz \
        -ln $design \
        -tech [get_db flow_vars_pegasus_metal_fill_rule_file] \
        -output_filename fill.gds \
        -output_type gds \
        -setup scripts/feol_fill.setup \
        -boundary_layer_override OUTLINE \
        -tiles_gen_layer_override OPTION3_10M_2Mx_6Cx_2Ix_LB_SELECT \
        -ncpu 16

    exec pegasus \
        -dp 16 \
        -license_timeout 5 \
        -drc \
        -run_dir ./PEGASUS_FEOL_FILL \
        -log logs/PEGASUS_FEOL_FILL.log \
        -gds $out_dir/$design.merged.gds.gz \
        -top_cell $design \
        $design.pegasus.tech
        
    # merge fill gds to top GDSs
    exec -ignorestderr k2_viewer \
        -batch dbmerge scripts/k2_viewer_merge.feol.setup \
        $out_dir/$design.merged.full.gds.gz

}

############################################################################
# STEP run_pvs_feol_fill
############################################################################
create_flow_step -name run_pvs_feol_fill -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }
    
    exec pvs \
	-dp 16 \
	-license_timeout 5 \
	-run_dir PVS_FEOL_FILL \
        -log logs/PVS_FEOL_FILL.log \
	-ui_data \
	-gds $out_dir/$design.merged.gds.gz \
	-top_cell $design \
	-drc [get_db flow_vars_pvs_feol_fill_rule_file]

    # merge feol fill to top GDSs
    exec -ignorestderr k2_viewer \
        -batch dbmerge scripts/k2_viewer_merge.merged.setup \
        $out_dir/$design.merged.full.gds.gz

    exec -ignorestderr k2_viewer \
        -batch dbmerge scripts/k2_viewer_merge.hierarchical.setup \
        $out_dir/$design.hierarchical.full.gds.gz

}

############################################################################
# STEP innovus_export_design
############################################################################
create_flow_step -name innovus_export_design -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
	file mkdir $out_dir
    }

    # Export GDSII, no leaf cell data whatsoever
    write_stream \
	-die_area_as_boundary \
	-format stream \
	-map_file [get_db flow_vars_gdsout_stream_map_file] \
	-unit 1000 \
	-mode ALL \
	-pvs_fill \
	$out_dir/$design.hierarchical.gds.gz

    # Export GDSII with macros from LEF-data
    write_stream \
	-die_area_as_boundary \
	-format stream \
	-map_file [get_db flow_vars_gdsout_stream_map_file] \
	-output_macros \
	-unit 1000 \
	-mode ALL \
	-pvs_fill \
	$out_dir/$design.output_macros.gds.gz

    write_stream \
        -die_area_as_boundary \
        -format stream \
        -map_file [get_db flow_vars_gdsout_stream_map_file] \
        -unit 1000 \
        -mode ALL \
        -pvs_fill \
        -merge [concat [get_db flow_vars_macro_gds_list] [get_db flow_vars_stdcell_gds_list] [get_db flow_vars_memory_gds_list] [get_db flow_vars_io_gds_list]] \
        -uniquify_cell_names \
        $out_dir/$design.merged.gds.gz

    # write out LVS netlist
    write_netlist -exclude_leaf_cells -exclude_insts_of_cells "PAD73D6GU PAD73D6NU" -include_phys_inst -include_pg_ports $out_dir/$design.lvs.v.gz

    # write out LEC script to check that LVS netlist matches "actual" signoff netlist
    write_do_lec \
        -flat \
        -golden_design $out_dir/$design.v.gz \
        -revised_design $out_dir/$design.lvs.v.gz \
        -log_file logs/lec.lvs.opt_signoff.log \
        lec.lvs.opt_signoff.do

    # Export DEF
    set_db write_def_include_lef_vias true
    write_def -routing $out_dir/$design.def.gz
    set_db write_def_include_lef_vias false
}

############################################################################
# STEP schedule_check_drc_pvs
############################################################################
create_flow_step -name schedule_check_drc_pvs -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]

    # if feol fill was not done, copy gds to .full.gds.gz
    if {![get_feature -feature add_pvs_feol_fill]} {
        exec cp $out_dir/$design.merged.gds.gz \
            $out_dir/$design.merged.full.gds.gz
        exec sleep 10
    }

    exec pvs \
	-dp 16 \
	-license_timeout 5 \
	-run_dir PVS_ANT_DRC \
        -log logs/PVS_ANT_DRC.log \
	-ui_data \
	-gds $out_dir/$design.merged.full.gds.gz \
	-top_cell $design \
	-drc [get_db flow_vars_pvs_antenna_rule_file]


    exec pvs \
	-dp 16 \
	-license_timeout 5 \
	-run_dir PVS_DRC \
        -log logs/PVS_DRC.log \
	-ui_data \
	-gds $out_dir/$design.merged.full.gds.gz \
	-top_cell $design \
	-drc [get_db flow_vars_pvs_drc_rule_file]

}

############################################################################
# STEP schedule_check_drc_pegasus
############################################################################
create_flow_step -name schedule_check_drc_pegasus -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]

    # if feol fill was not done, copy gds to .full.gds.gz
    if {![get_feature -feature add_pvs_feol_fill]} {
        exec cp $out_dir/$design.merged.gds.gz \
            $out_dir/$design.merged.full.gds.gz
        exec sleep 10
    }

    if {[file exist scripts/gf22_drc.run]} {
        exec ./scripts/gf22_drc.run
    } else {

        exec pegasus \
            -dp 16 \
            -license_timeout 5 \
            -run_dir PEGASUS_ANT_DRC \
            -log logs/PEGASUS_ANT_DRC.log \
            -ui_data \
            -gds $out_dir/$design.merged.full.gds.gz \
            -top_cell $design \
            -drc [get_db flow_vars_pegasus_antenna_rule_file] &

        # use control-file if it exists
        if {[file exists scripts/pvsdrcctl_signoff]} {
            puts "Info: Running PEGASUS DRC with control file: scripts/pvsdrcctl_signoff ->"
            puts [read [open scripts/pvsdrcctl_signoff r]]
            puts "Info: <- scripts/pvsdrcctl_signoff ends"
            exec pegasus \
                -dp 16 \
                -license_timeout 5 \
                -run_dir PEGASUS_DRC \
                -log logs/PEGASUS_DRC.log \
                -ui_data \
                -control scripts/pvsdrcctl_signoff \
                -gds $out_dir/$design.merged.full.gds.gz \
                -top_cell $design \
                -drc [get_db flow_vars_pegasus_drc_rule_file] &
        } else {
            exec pegasus \
                -dp 16 \
                -license_timeout 5 \
                -run_dir PEGASUS_DRC \
                -log logs/PEGASUS_DRC.log \
                -ui_data \
                -gds $out_dir/$design.merged.full.gds.gz \
                -top_cell $design \
                -drc [get_db flow_vars_pegasus_drc_rule_file] &
        }
    }
}

############################################################################
# STEP schedule_check_lvs_pvs
############################################################################
create_flow_step -name schedule_check_lvs_pvs -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]

    set pvs_cmd "exec pvs \
    -lvs \
    -dp 16 \
    -license_timeout 5 \
    -control scripts/pvslvsctrl \
    -run_dir PVS_LVS \
    -log logs/PVS_LVS.log \
    -gds $out_dir/$design.merged.full.gds.gz \
    -source_verilog $out_dir/$design.lvs.v.gz \
    -layout_top_cell $design \
    -source_top_cell $design \
    -ui_data \
"
    foreach add_spi [concat [get_db flow_vars_macro_spi_list] [get_db flow_vars_stdcell_spi_list] [get_db flow_vars_memory_spi_list] [get_db flow_vars_io_spi_list]] {
        set pvs_cmd "$pvs_cmd    -source_cdl $add_spi \
"
    }
    set pvs_cmd "$pvs_cmd    [get_db flow_vars_pvs_lvs_rule_file]"

    puts "Launching LVS: $pvs_cmd"
    {*}$pvs_cmd
}

############################################################################
# STEP schedule_check_lvs_pegasus
############################################################################
create_flow_step -name schedule_check_lvs_pegasus -owner flow {

    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]

    if {[file exist scripts/gf22_lvs.run]} {
        exec ./scripts/gf22_lvs.run
    } else {

        set pvs_cmd "exec pegasus \
    -lvs \
    -dp 16 \
    -license_timeout 5 \
    -control scripts/pvslvsctrl \
    -run_dir PEGASUS_LVS \
    -log logs/PEGASUS_LVS.log \
    -gds $out_dir/$design.merged.full.gds.gz \
    -source_verilog $out_dir/$design.lvs.v.gz \
    -layout_top_cell $design \
    -source_top_cell $design \
    -ui_data \
"
        foreach add_spi [concat [get_db flow_vars_macro_spi_list] [get_db flow_vars_stdcell_spi_list] [get_db flow_vars_memory_spi_list] [get_db flow_vars_io_spi_list]] {
            set pvs_cmd "$pvs_cmd    -source_cdl $add_spi \
"
        }
        set pvs_cmd "$pvs_cmd    [get_db flow_vars_pegasus_lvs_rule_file]"

        puts "Launching LVS: $pvs_cmd"
        {*}$pvs_cmd
    }
}

############################################################################
# STEP fix_via4_r4_m5_drc
############################################################################
create_flow_step -name fix_via4_r4_m5_drc -owner flow {
    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]

    if {![file exists scripts/pvsdrcctl_pr]} {
        puts "Warning: file scripts/pvsdrcctl_pr does not exist"
        puts "Creating file scripts/pvsdrcctl_pr"

        set FH [open scripts/pvsdrcctl_pr w]
        puts $FH "text_depth -primary;"
        puts $FH "virtual_connect -colon no;"
        puts $FH "virtual_connect -semicolon_as_colon yes;"
        puts $FH "virtual_connect -noname;"
        puts $FH "virtual_connect -report no;"
        puts $FH "virtual_connect -depth -primary;"
        puts $FH "report_summary -drc \"${design}.sum\" -replace;"
        puts $FH "max_results -drc -all;"
        puts $FH "max_vertex -drc 4096;"
        puts $FH "results_db -drc \"${design}.drc_errors.ascii\" -ascii;"
        puts $FH "keep_layers -none;"
        puts $FH "abort_on_layout_error yes;"
        puts $FH "layout_allow_duplicate_cell yes;"
        puts $FH "select_check -drc VIA4.R.4:M5;"
        puts $FH ""
        close $FH

 
    } else {
        puts "Found existing file scripts/pvsdrcctl_pr"
        puts "Using that in fix_via4_r4_m5_drc step"
    }

    write_stream \
        -die_area_as_boundary \
        -format stream \
        -map_file [get_db flow_vars_gdsout_stream_map_file] \
        -output_macros \
        -unit 1000 \
        -mode ALL \
        $out_dir/$design.pr.gds.gz

    exec pvs \
        -dp 32 \
        -license_timeout 5 \
        -run_dir PVS_DRC_PR \
        -log logs/PVS_DRC_PR.log \
        -ui_data \
        -control scripts/pvsdrcctl_pr \
        -gds $out_dir/$design.pr.gds.gz \
        -top_cell $design \
        -drc [get_db flow_vars_pvs_drc_rule_file]

    read_markers -type pvs PVS_DRC_PR/$design.drc_errors.ascii
    # Procedure to delete vias under DRC marker of specific type

    foreach drc_marker [get_db markers -if ".user_type == VIA4.R.4:M5"] {
        set vias_in_box [get_obj_in_area -areas [get_db $drc_marker .bbox] -obj_type special_via]
        set_db selected $vias_in_box
        puts "Deleting via $vias_in_box at location: [get_db $drc_marker .bbox]"
        delete_routes -selected
	puts "Creating via4 blockage on drc marker: [get_db $drc_marker .bbox]"
	create_route_blockage -layers VIA4 -rects [get_db $drc_marker .bbox]
    }

    delete_markers
    
}
