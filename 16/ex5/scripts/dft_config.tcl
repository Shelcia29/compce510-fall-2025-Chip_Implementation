###############################################
# Place all DFT related stuff into own file
# Time-stamp: <2025-09-28 16:56:54 qftele>
###############################################


##############################################################################
# STEP init_scan
##############################################################################
create_flow_step -name init_scan -owner design {

    set_db dft_prefix 				DFT_[get_db flow_vars_design_name]_
    set_db dft_identify_top_level_test_clocks 	false
    set_db dft_identify_test_signals 		false
    set_db dft_identify_internal_test_clocks 	false
    #set_db use_scan_seqs_for_non_dft 		true
    set_db use_scan_seqs_for_non_dft 		false
    set_db dft_auto_identify_shift_register         true
    set_db dft_identify_shared_wrapper_cells        false
    #set_db dft_shared_wrapper_through	        combinational

    #- DFT Attributes to control scan mapping and connectivity
    #set_db designs .dft_mix_clock_edges_in_scan_chains true 
    set_db [current_design] .dft_mix_clock_edges_in_scan_chains true 
    set_db [current_design] .dft_lockup_element_type level_sensitive
    set_db current_design .dft_clock_edge_for_head_of_scan_chains leading
    set_db current_design .dft_clock_edge_for_tail_of_scan_chains trailing
    # min number of chains used as max number of chains in connect_scan_chain -command
    set_db [current_design] .dft_min_number_of_scan_chains 9
    set_db [current_design] .dft_max_length_of_scan_chains 300

    #- Define test clock
    #define_test_clock			     -name foo
    define_test_clock -name jtag_tck_[get_db flow_vars_design_name] -domain scan_jtag clk_i

    #- Define test mode port
    define_test_signal -function test_mode -lec_value 0 -name scan_mode_[get_db flow_vars_design_name] -create_port -active high scan_mode_[get_db flow_vars_design_name]
    #- Define scan enable port
    define_test_signal -function shift_enable -lec_value 0 -name scan_enable_[get_db flow_vars_design_name] -create_port -active high scan_enable_[get_db flow_vars_design_name]
    # Add, TL: pipeline shift enable
    #define_test_signal -name pipe_sen -function pipe_sen -create_port -active low pipe_sen

    #- Specify ICG bypass signal for DFT
    set_db current_design .lp_clock_gating_test_signal [get_db test_signals scan_enable_[get_db flow_vars_design_name] ]
    
    #- Define test reset port
    define_test_signal -function async_set_reset -name scan_reset_[get_db flow_vars_design_name] -active high rst_ni

    if {0} {
        define_test_signal -function wint -name WINT_[get_db flow_vars_design_name] -create_port WINT
        define_test_signal -function wext -name WEXT_[get_db flow_vars_design_name] -create_port WEXT
    }
    
    #- Control cg clocks
    # go through all instantiated cgs
    foreach icg_inst [get_db [get_db insts -if {.base_name==inst_TLATNTSCAX*}] .name] {
	puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
	set_db [get_db pins $icg_inst/Z] .dft_controllable "[get_db pins $icg_inst/CP] non_inverting"

	# prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
	# Note, TE has to be connected manually to shift enable later on!
	set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
    }

    #####################################################################
    # ADD MUXES 
    #####################################################################
    # Note, Block specific
    #- Add scan clock muxes
    
    if {[file exists scripts/add_mux.tcl]} {
	source scripts/add_mux.tcl
    }

    # Set all previously instantiated muxes as preserve size_ok
    if {[llength [get_db insts *scan_???_mux_*]] == 0} {
	puts "Error: No instantiated clk nor rst muxes found. Check insertion script!"
    }
    set_db [get_db insts *scan_???_mux_*] .preserve size_ok
    set_db [get_db insts *scan_???_inv_*] .preserve size_ok
    
    check_dft_rules

    # For AICGs define shift enable connection inside 
    set_compatible_test_clocks [get_db test_clocks *scan_jtag*]

    #- Disable internal clock auto identification
    set_db dft_identify_internal_test_clocks false

    #- Check DFT rules
    check_dft_rules
}

##############################################################################
# STEP add_mbist_logic
##############################################################################
create_flow_step -name add_mbist_logic -owner design {
    
}

##############################################################################
# STEP add_scan_logic
##############################################################################
create_flow_step -name add_scan_logic -owner design {

    #- Re-run DFT rule checks
    check_dft_rules	     

    if {0} {

        add_core_wrapper_cell \
            -location [get_db ports {*src2dst* *dst2src*}] \
            -shared_through buffer \
            -no_mux_before_shared_cell \
            -wsen [get_db ports scan_enable*]

        check_dft_rules

        #report_core_wrapper_cell -report_flops

        define_scan_chain -name 1500_chain \
            -sdi wchain_si_[get_db flow_vars_design_name]_0 \
            -sdo wchain_so_[get_db flow_vars_design_name]_0 \
            -create_ports

        set num_chains [get_db current_design .dft_min_number_of_scan_chains]
        reset_db current_design .dft_min_number_of_scan_chains
        if {[get_db flow_feature_synth_physical] || [get_db flow_feature_synth_spatial]} {
            place_dft_sequentials
            
            connect_scan_chains -chains 1500_chain \
                -elements [get_db scan_segments -if {.core_wrapper}] \
                -physical -incremental
        } else {
            connect_scan_chains -chains 1500_chain \
                -elements [get_db scan_segments -if {.core_wrapper}] \
                -incremental
        }
        set_db current_design .dft_min_number_of_scan_chains $num_chains
    }

    for {set i 0} {$i < [get_db [current_design] .dft_min_number_of_scan_chains]} {incr i} {
        define_scan_chain \
            -sdi scan_in_[get_db flow_vars_design_name]_$i \
            -sdo scan_out_[get_db flow_vars_design_name]_$i \
            -create_ports \
            -name scan_chain_[get_db flow_vars_design_name]_$i \
            -terminal_lockup level_sensitive
    }

    #define_scan_chain -create_ports -sdi sdi -sdo sdo -terminal_lockup level_sensitive
    if {[get_db flow_feature_synth_physical] || [get_db flow_feature_synth_spatial]} {
	connect_scan_chains -chains scan_chain_* \
	    -incremental \
	    -physical -cluster_aggressively_high
    } else {
	connect_scan_chains -chains scan_chain_* \
	    -incremental -zipper_stitch
	
    }

    # connect shift enable signal to AICG TE-pins (can be done only after design is uniquified)
    # go through all instantiated cgs
    set_db ui_respects_preserve false
    foreach icg_inst [get_db [get_db insts -if {.base_name==inst_TLATNTSCAX*}] .name] {
	disconnect [get_db pins $icg_inst/TE]
	connect [get_db ports scan_enable_[get_db flow_vars_design_name]] [get_db pins $icg_inst/TE] -prefix DFT_AICG_TE_scan_enable_[get_db flow_vars_design_name]_
    }
    set_db ui_respects_preserve true

}

################################################################################
# Genus add dft constraints after port creation
################################################################################
create_flow_step -name genus_add_dft_constraints -exclude_time_metric -owner tuni {

    foreach constr_mode [get_db flow_vars_constraint_modes] {
	set constr_files [list ]
	foreach sdc [get_db [get_db constraint_modes -if {.base_name==${constr_mode}}] .sdc_files] {
	    lappend constr_files $sdc
	}
	if {$constr_mode != "func"} {
	} else {
	    if {[is_flow -inside flow:syn_generic]} {
		lappend constr_files [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.hier_dft.tcl
	    }
	}
	update_constraint_mode -name $constr_mode -sdc_files $constr_files
    }
}
