# Flowkit v19.10-s008_1
# Time-stamp: <2025-11-12 21:36:13 qftele>
################################################################################
# Innovus attributes
#
#  Attributes used to drive tool behavior.  Most typically these are root level
#  attributes.  All root attributes can be listed by using 'report_obj -all' or
#  by category using 'report_obj -all -verbose'
#
#  Further attribute help can be obtained by using the command 'help <ATTRIBUTE>'
#
#  The init_innovus flow_step is provided to specify tool level configs after a
#  design has been loaded via the init_design flow_step or specified as a
#  flow_starting_db from a subsequent flow (ie syn_opt).

################################################################################

##############################################################################
# STEP init_innovus
##############################################################################
create_flow_step -name init_innovus -owner flow {

    # Tool settings: NOTE: already set by flow_config.tcl
    #set_multi_cpu_usage -local_cpu 8 -remote_host 1 -cpu_per_remote_host 8

    if {[get_feature -feature report_lec]} {
	# Init attributes  [get_db -category init]
	#-------------------------------------------------------------------------------
	set_db write_lec_directory_naming_style "fv/%s/[get_db flow_report_name]"
	
    }
    set_db init_design_uniquify 1

    # Design attributes  [get_db -category design]
    #-------------------------------------------------------------------------------
    set_db design_process_node            45
    if {[get_feature -feature flow_express]} {
	set_db design_flow_effort                   express
    }
    set_db design_early_clock_flow              true
    
    # Via naming
    #-------------------------------------------------------------------------------
    # Use design name as prefix for VIAs, as otherwise they will cause collision when merging designs on toplevel
    set_db write_stream_via_names true

    # Timing attributes  [get_db -category timing && delaycalc]
    #-------------------------------------------------------------------------------
    set_db timing_analysis_cppr           both
    set_db timing_analysis_type           ocv
    set_db timing_report_fields           {timing_point net cell fanout load transition delay incr_delay arrival edge user_derate power_domain}

    #set_db timing_analysis_socv                               true                        ;# Enable socv analysis
    #set_db timing_socv_rc_variation_mode                      true                        ;# Enable interconnect variation mode in SOCV mode
    #set_db  timing_report_enable_verbose_ssta_mode true

    # Add, TL: flow sets this to "no_async", async is default and should be used
    set_db timing_analysis_async_checks async
    # Add, TL: maybe a bit hazardous... disable default io delay for ports which are unconstrained!
    # if true, will cause hold problems (since launching clock is the receiving clock (with same latency!))
    set_db timing_apply_default_primary_input_assertion false

    set_db delaycal_advanced_node_pin_cap_settings true
    set_db delaycal_advanced_pin_cap_mode true

    
    # Extraction attributes  [get_db -category extract_rc]
    #-------------------------------------------------------------------------------
    if {[get_feature -feature add_pvs_fill] || [get_feature -feature add_pegasus_beol_fill]} {
        set_db extract_rc_pvs_fill            true
    }
    if {[is_flow -after flow:opt_signoff] || [is_flow -inside flow:opt_signoff]} {
	set_db extract_rc_effort_level signoff
        set_db extract_rc_qrc_cmd_type partial
        set_db extract_rc_qrc_cmd_file scripts/gpdk045_qrc.map
    }
	
    if {[is_flow -after flow:route]} {
	set_db delaycal_enable_si           true
	set_db extract_rc_engine            post_route
	# Note, TL: default is false, see effect of setting to true
	#set_db si_delay_separate_on_data                  true
    }    
    if [is_flow -after_history flow:route] {
	set_db delaycal_equivalent_waveform_model               propagation
    } else {
	set_db delaycal_equivalent_waveform_model               no_propagation
    }           
    set_db si_aggressor_alignment                             timing_aware_edge       

    # Mod, TL: Too few licenses to extract all corners in parallel . Use the following to reduce number of used licenses :
    #set_db extract_rc_qrc_run_mode sequential
    
    # Floorplan attributes  [get_db -category floorplan]
    #-------------------------------------------------------------------------------
    set_db finish_floorplan_active_objs   [list macro soft_blockage core]
    # Constraints for even or odd site width/ row height
    set_db floorplan_row_site_height                          even
    set_db floorplan_row_site_width                           even
    
    # Placement attributes  [get_db -category place]
    #-------------------------------------------------------------------------------
    set_db place_detail_legalization_inst_gap                 1 
    set_db place_detail_use_no_diffusion_one_site_filler      false                        ;# False to not leave 1-site gaps
    set_db place_detail_filler_gap_min_gap                    0.2
    set_db place_detail_filler_gap_effort                     high
    
    set_db place_global_uniform_density                       true                        ;# Enable even cell distribution for designs with less than 70% utilization

    set_db place_global_place_io_pins               true
    set_db place_detail_use_check_drc               true
    #set_db place_detail_color_aware_legal           true
    
    # Tieoff attributes  [get_db -category add_tieoffs]
    #-------------------------------------------------------------------------------
    set_db add_tieoffs_cells                        [list TIEHI TIELO]
    # tieoff max fanout not honored without this?
    set_db add_tieoffs_max_fanout 32

    # Optimization attributes  [get_db -category opt]
    #-------------------------------------------------------------------------------
    set_db opt_fix_hold_allow_setup_tns_degradation           true                        ;# When set to true, allows setup total negative slack to degrade during hold optimization.
    set_db opt_fix_hold_verbose                               true                        ;# When set to true, display extra info in the log about remaining hold violations.
    set_db opt_new_inst_prefix            "[get_db flow_report_name]_"
    # Note, do not use DEL* -cells for hold fixing because of HUGE variation
    set_db opt_fix_hold_lib_cells                   [list \
							]
    # enable data checks during gigaplace (false by default)
    #set_db opt_enable_data_to_data_checks     true

    # fix max_fanout / max_load violations, false by default
    set_db opt_fix_fanout_load true

    # Clock attributes  [get_db -category cts]
    #-------------------------------------------------------------------------------
    set_db cts_top_fanout_threshold                           2000                        ;# Minimum number of transitive fanout in the clock tree for a net to be routed as a top net
    set_db cts_target_skew                          0.15
    set_db cts_target_max_transition_time           0.10

    set_db cts_buffer_cells                         [list CLKBUFX12 CLKBUFX16 CLKBUFX2 CLKBUFX20 CLKBUFX3 CLKBUFX4 CLKBUFX6 CLKBUFX8]
    set_db cts_inverter_cells                       [list CLKINVX1 CLKINVX12 CLKINVX16 CLKINVX2 CLKINVX20 CLKINVX3 CLKINVX4 CLKINVX6 CLKINVX8]
    set_db cts_clock_gating_cells                   [list TLATNCAX12 TLATNCAX16 TLATNCAX2 TLATNCAX20 TLATNCAX3 TLATNCAX4 TLATNCAX6 TLATNCAX8]
    set_db cts_logic_cells                          [get_db [get_db base_cells CLK*] .name]

    #- Route types definitions occur during the "init_floorplan" flow_step
    if {[get_db route_types] ne ""} {
	set_db cts_route_type_leaf                     cts_route_type_leaf
	set_db cts_route_type_trunk                    cts_route_type_trunk
	set_db cts_route_type_top                      cts_route_type_top
    }
    
    # Only use inverters in clock tree, no buffers
    set_db cts_use_inverters true

    # Use max 32 fanout also in CTS
    set_db cts_max_fanout 32

    # power balance leakage / dynamic
    #-------------------------------------------------------------------------------
    # Optimize both leakage & dynamic with same weight
    set_db opt_leakage_to_dynamic_ratio                 0.5

    # Filler attributes  [get_db -category add_fillers]
    #-------------------------------------------------------------------------------
    #set_db add_fillers_avoid_abutment_patterns                "1:1 2:1"                   ;# Avoid 1:1 filler abutment
    set_db add_fillers_cells                        [list \
							 DECAP10 DECAP2 DECAP3 DECAP4 DECAP5 DECAP6 DECAP7 DECAP8 DECAP9 \
                                                         FILL1 FILL16 FILL2 FILL32 FILL4 FILL64 FILL8 \
							 ]
    set_db add_fillers_no_single_site_gap true
    # Insert fillers to toplevel hierarchy
    set_db add_fillers_cell_name_style                      flat

    # Routing attributes  [get_db -category route]
    #-------------------------------------------------------------------------------
    set_db route_early_global_bottom_routing_layer            [get_db [get_db layers Metal2] .route_index]
    set_db route_early_global_top_routing_layer               [get_db [get_db layers Metal11] .route_index]
    #set_db route_early_global_num_tracks_per_clock_wire     1
    set_db route_early_global_num_tracks_per_clock_wire     5

    # Note TL: use only up to M8 in routing
    set_db route_design_bottom_routing_layer                  [get_db [get_db layers Metal2] .route_index]
    set_db route_design_top_routing_layer                     [get_db [get_db layers Metal11] .route_index]

    set_db route_design_detail_post_route_swap_via          none
    set_db route_design_with_litho_driven                   true
    set_db route_design_with_timing_driven                  true

    # Antenna options
    set_db route_design_antenna_pin_limit                   1000
    set_db route_design_antenna_cell_name                   ANTENNA
    set_db route_design_add_antenna_inst_prefix             "ANTENNA"
    set_db route_design_antenna_diode_insertion             true
    set_db route_design_detail_fix_antenna                  true

    #set_db route_design_process_node                        45
    set_db route_design_with_via_in_pin                     1:1 ; # enclose via inside stdcell pin shape on M1 accesses

    # H240 trim grid definition
    #set_db route_design_with_trim_metal "-layer 2 \
    #-mask2 {-pitch 0.24 -core_offset 0.225 -width 0.03 } \
    #-mask2 {-pitch 0.24 -core_offset 0.095 -width 0.03 } \
    #-mask1 {-pitch 0.24 -core_offset 0.015 -width 0.03 } \
    #-mask1 {-pitch 0.24 -core_offset 0.145 -width 0.03 }"

    set_db route_design_concurrent_minimize_via_count_effort  high                        ;# Reduce the via count while routing
    set_db route_design_detail_use_multi_cut_via_effort       high                        ;# Turn on concurrent double/bar cut routing before CTS
    #set_db route_design_with_via_only_for_block_cell_pin      2:2                         ;# Access M2 MACRO pin with VIA only

    if [is_flow -after_history flow:route] {
#	reset_db route_design_detail_use_multi_cut_via_effort                               ;# Turn off concurrent double/bar cut routing
#	eval_legacy {setNanoRouteMode -drouteExpConcurrentMinimizeViaCountCost 64}          ;# Concurrently minimize via count adding via cost
#	set_db route_design_antenna_diode_insertion             true                        ;# Allow diode insertion for Antenna fixing
	set_db route_design_detail_post_route_swap_via          multicut                    ;# If postroute double cuts are desired..although the percentage of swap is low for N7
#    }

    eval_legacy {setNanoRouteMode  -routeExpShieldAddTappingVia true}                     ;# Add Tapping via for the specified distance for shielding

    # Timing ECO attributes [get_db -category opt_signoff] 
    #-------------------------------------------------------------------------------
    set_db distributed_child_license_checkout_list          tpsxl

    # techniques                                                                    
    #set_db opt_signoff_resize_inst  true                                           
    #set_db opt_signoff_add_inst true                                               
    #set_db opt_signoff_swap_inst true                                              
    #set_db opt_signoff_delete_inst true                                            
    #set_db opt_signoff_allow_skewing false                                         
    #set_db opt_signoff_optimize_sequential_cells false                             
    set_db opt_signoff_optimize_core_only                   true                                    
    #set_db opt_signoff_optimize_replicated_modules false                           

    # target
    #set_db opt_signoff_setup_target_slack 0.0
    #set_db opt_signoff_hold_target_slack 0.0 

        # Note TL: both false by default
     set_db opt_signoff_fix_si_slew true
     set_db opt_signoff_fix_xtalk   true
     set_db opt_signoff_fix_glitch  true

    # Hold fixing
    set_db opt_signoff_fix_hold_allow_setup_optimization      true                        ;# When set to true, incremental Setup fixing is performed during Hold fixing in order to create more Setup margins on Hold violated nodes that could not be fixed earlier due to Setup timing conflict
    set_db opt_signoff_fix_hold_allow_setup_tns_degrade       true                        ;# When  specified,  the  Setup Total Negative Slack can be degraded during Hold time violations fixing while still maintaining the Setup Worst Negative Slack in every Setup active views.

    # PBA
    set_db opt_signoff_retime                               path_slew_propagation
    #set_db opt_signoff_check_type both                 
    #set_db opt_signoff_max_paths -1                    
    #set_db opt_signoff_nworst -1                       
    #set_db opt_signoff_max_slack 0.0                   

    # I/OS
    #set_db opt_signoff_eco_file_prefix {}
    #set_db opt_signoff_partition_list_file {}
    #set_db opt_signoff_prefix ESO            
    #set_db opt_signoff_read_eco_opt_db {}    
    #set_db opt_signoff_write_eco_opt_db ecoTimingDB
    #set_db opt_signoff_verbose false               
    #set_db opt_signoff_pre_sta_tcl                

}

##############################################################################
# STEP set_dont_use
##############################################################################
# dont_use management
create_flow_step -name set_dont_use -owner cadence {
    # disable ULVT cells until postroute
    if {[get_db flow_feature_dont_use_ulvt]} {
	if {[is_flow -before flow:postroute]} {
	    set_db [get_db base_cells -if {.lib_cells.library.name==*ulvt*}] .dont_use true
	} else {
	    set_db [get_db base_cells -if {.lib_cells.library.name==*ulvt*}] .dont_use false
	}
    }

    foreach dont_use_expr [get_db flow_vars_dont_use_list] {
        set_db [get_db base_cells -if {*}${dont_use_expr}] .dont_use true
    }
}

##############################################################################
# STEP set_stdcell_opts
##############################################################################
# set various options to standard cells
create_flow_step -name set_stdcell_opts -owner cadence {
}

