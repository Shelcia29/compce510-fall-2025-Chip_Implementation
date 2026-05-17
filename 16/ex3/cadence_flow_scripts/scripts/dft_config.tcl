###############################################
# Place all DFT related stuff into own file
# Time-stamp: <2025-09-23 16:50:49 qftele>
###############################################


##############################################################################
# STEP init_scan
##############################################################################
create_flow_step -name init_scan -owner design {

    set_db dft_prefix 				DFT_[get_db flow_vars_design_name]_
    set_db dft_identify_top_level_test_clocks 	false
    set_db dft_identify_test_signals 		false
    set_db dft_identify_internal_test_clocks 	no_cgic_hier
    #set_db use_scan_seqs_for_non_dft 		true
    set_db use_scan_seqs_for_non_dft 		false
    set_db dft_auto_identify_shift_register         false
    set_db dft_identify_shared_wrapper_cells        false
    #set_db dft_shared_wrapper_through	        combinational

    #- DFT Attributes to control scan mapping and connectivity
    #set_db designs .dft_mix_clock_edges_in_scan_chains true 
    set_db current_design .dft_mix_clock_edges_in_scan_chains true
    set_db current_design .dft_lockup_element_type level_sensitive

    # NM, change to single scan chain
    set_db current_design .dft_min_number_of_scan_chains 1
    #set_db current_design .dft_max_length_of_scan_chains 150

    #- Define test clock
    #define_test_clock			     -name foo

    #- Define test mode port
    define_test_signal -function test_mode -lec_value 0 -name scan_mode_[get_db flow_vars_design_name] -create_port -active high scan_mode_[get_db flow_vars_design_name]
    #- Define scan enable port
    define_test_signal -function shift_enable -lec_value 0 -name scan_enable_[get_db flow_vars_design_name] -create_port -active high scan_enable_[get_db flow_vars_design_name]
    # Add, TL: pipeline shift enable
    #define_test_signal -name pipe_sen -function pipe_sen -create_port -active low pipe_sen

    #- Specify ICG bypass signal for DFT
    set_db current_design .lp_clock_gating_test_signal [get_db test_signals scan_enable_[get_db flow_vars_design_name]]
    
    #- Define test reset port
    define_test_signal -function async_set_reset -name scan_reset_[get_db flow_vars_design_name] -active high refrstn
    #define_test_signal -function async_set_reset -name jtag_reset -active low jtag_trst

    #- Control cg clocks
    # go through all instantiated cgs

    foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
	puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
	set_db [get_db pins $icg_inst/Q] .dft_controllable "[get_db pins $icg_inst/CP] non_inverting"

	# prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
	# Note, TE has to be connected manually to shift enable later on!
	set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
    }

    if {1} {
	#- JTAG/Scan clock
	if {![llength [get_db ports jtag_tck]]} {
	    define_test_clock -name scan_clk -domain scan_jtag -create_port jtag_tck
	} else {
	    define_test_clock -name scan_clk -domain scan_jtag jtag_tck
	}
    }

    #####################################################################
    # ADD MUXES 
    #####################################################################
    # Note, These could be in a file of it's own. Block specific
    #- Add scan clock muxes
    set sel scan_mode_[get_db flow_vars_design_name]

    set fixport refclk
    set mux_inst [add_user_test_point \
	-cell [get_db lib_cells *CKMUX2D4*LVT] \
	-name scan_clk_mux_1 \
	-location [get_db ports $fixport] \
	-cfi I0 -cfo Z -connect {I1 jtag_tck} -connect [list S $sel]]

    define_test_clock \
	-name refclk_muxed \
	-domain scan_jtag \
	[lindex [get_db $mux_inst .pins] 3]
    
     set fixpin i_subsystem_clock_control/i_main_ckgate/inst_CKLNQD8BWP30P140LVT/Q
     set mux_inst [add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_clk_mux_2 \
     	-location [get_db pins $fixpin] \
         -cfi I0 -cfo Z -connect {I1 jtag_tck} -connect [list S $sel]]

     define_test_clock \
     	-name main_clk_muxed \
     	-domain scan_jtag \
     	[lindex [get_db $mux_inst .pins] 3]
    
     set fixpin i_pll/i_pll/FLLCLK
     set mux_inst [add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_clk_mux_3 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 jtag_tck} -connect [list S $sel]]

     define_test_clock \
     	-name pll_muxed \
     	-domain scan_jtag \
     	[lindex [get_db $mux_inst .pins] 3]
    
     set fixpin i_subsystem_clock_control/i_rstn_sync/inst_SDFCNQD2BWP30P140LVT_sync2/Q
     add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_rst_mux_1 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 refrstn} -connect [list S $sel]
    
     set fixpin i_ariane_cluster_ballast/genblk1_0_i_tico_ctand_rstn_anded/inst_CKAN2D4BWP30P140LVT/Z
     add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_rst_mux_2_1 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 refrstn} -connect [list S $sel]

    set fixpin i_ariane_cluster_ballast/genblk1_1_i_tico_ctand_rstn_anded/inst_CKAN2D4BWP30P140LVT/Z
    add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_rst_mux_2_2 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 refrstn} -connect [list S $sel]

    set fixpin i_ariane_cluster_ballast/i_l2_cache_subsystem/i_tico_ctand_l2_rstn/inst_CKAN2D4BWP30P140LVT/Z
     add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_rst_mux_3 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 refrstn} -connect [list S $sel]

    set fixpin i_ariane_cluster_ballast/i_l2_cache_subsystem/i_tico_ctand_xbar_rstn/inst_CKAN2D4BWP30P140LVT/Z
     add_user_test_point \
     	-cell [get_db lib_cells *CKMUX2D4*LVT] \
     	-name scan_rst_mux_4 \
     	-location [get_db pins $fixpin] \
     	-cfi I0 -cfo Z -connect {I1 refrstn} -connect [list S $sel]

    # Set all previously instantiated muxes as preserve size_ok
    if {[llength [get_db insts *scan_???_mux_*]] == 0} {
	puts "Error: No instantiated clk nor rst muxes found. Check insertion script!"
    }
    set_db [get_db insts *scan_???_mux_*] .preserve true
    
    
    
    check_dft_rules

    # Add, TL: fix here all possible structural DFT issues concerning resets
    # Add, TL: fix internally driven reset/set
    #fix_dft_violations -async_reset -async_set -test_control scan_mode

    #- The following command will add WINT/WEXT and create the logic for 
    #- shift enable signals and clock gating control based on INTEST/EXTEST modes of 1500
    #add_wir_signal_bits -create_wrapper_shift_enables_for_delay_test scan_enable -create_cgic_enable_for_wrap scan_enable 
    if {0} {
	add_wir_signal_bits 
    }
    #- Add shadow logic around memories and macro as CTL models are not available
    #foreach memory [get_db insts -if {.is_memory==true}] {
    #  add_shadow_logic -around $memory -mode bypass -balance -dont_map -test_control scan_mode
    #}
    # Mod, TL: generate CTLs on the fly
    if {[file exists scripts/memory_atpg_models.tcl]} {
	puts "Info: sourcing scripts/memory_atpg_models.tcl"
	source -echo -verbose scripts/memory_atpg_models.tcl
    } elseif {[file exists [get_db flow_source_directory]/../scripts_global/utilities/memory_atpg_models.tcl]} {
	puts "Info: sourcing [get_db flow_source_directory]/../scripts_global/utilities/memory_atpg_models.tcl"
	source -echo -verbose [get_db flow_source_directory]/../scripts_global/utilities/memory_atpg_models.tcl
    } else {
	puts "Error: no memory_atpg_models.tcl -script found!"
    }

    # Read subblock scan abstract models
    if {[llength [get_db flow_vars_scan_abstracts]]} {
	foreach scan_abs [get_db flow_vars_scan_abstracts] {
	    set inst_name [lindex [split [file tail $scan_abs] "."] 0]
	    set idx 0
	    foreach scan_inst [get_db insts -if {.base_cell.base_name==${inst_name}}] {
		read_dft_abstract_model $scan_abs -instance $scan_inst -segment_prefix inst_index${idx}_
		incr idx
	    }
	}
    }
    
    # For AICGs define shift enable connection inside 
    set_compatible_test_clocks -all

    #- Disable internal clock auto identification
    set_db dft_identify_internal_test_clocks false

    #- Check DFT rules
    check_dft_rules

    if {1} {
	# connect manually test signals on subblocks
	connect -prefix jtag_tck [get_db ports jtag_tck] [get_db pins */jtag_tck]
	connect -prefix scan_mode [get_db ports scan_mode_[get_db flow_vars_design_name]] [get_db pins */scan_mode*]
    }
    if {0} {
	# connect manually test signals on subblocks
	connect -prefix jtag_tck [get_db ports jtag_tck] [get_db pins */jtag_tck]
	connect -prefix scan_mode [get_db ports scan_mode] [get_db pins */scan_mode]
	connect -prefix wrstn [get_db ports wrstn] [get_db pins */wrstn]
	connect -prefix select_wr [get_db ports select_wr] [get_db pins */select_wr]
	connect -prefix shift_wr [get_db ports shift_wr] [get_db pins */shift_wr]
	connect -prefix update_wr [get_db ports update_wr] [get_db pins */update_wr]
	connect -prefix wir_tm [get_db ports wir_tm] [get_db pins */wir_tm]

	#- Check DFT rules
	check_dft_rules
    }
}

##############################################################################
# STEP define_jtag_logic
##############################################################################
create_flow_step -name define_jtag_logic -owner design {

    #- Define an instruction register in order to add custom instructions for controlling
    #- Programmable MBIST.  
    define_jtag_instruction_register -name INSTR_REGISTER -length 5 -capture X01
    
    #- These instructions are the standard 1149.1 operations
    define_jtag_instruction -name EXTEST        -opcode 10000
    define_jtag_instruction -name SAMPLE        -opcode 10010
    define_jtag_instruction -name PRELOAD       -opcode 10010
    define_jtag_instruction -name BYPASS        -opcode 11111

    #- Define the custom PMBIST instructions.  The following 3 instructions allow
    #- tester control of internal  PMBIST controllers through the JTAG ports
    define_jtag_instruction -name MBISTSCH      -opcode 01000 -register MBISTSCH  -length 1
    define_jtag_instruction -name MBISTTPN      -opcode 01010 -register MBISTTPN  -length 1
    define_jtag_instruction -name MBISTCHK      -opcode 01100 -register MBISTCHK  -length 1

    #- Define 'MBISTAMR' instructions if programmable testplans are specified in the configuration file;
    #define_jtag_instruction -name MBISTAMR      -opcode 01110 -register MBISTAMR  -length 1
    #- Define 'MBISTROM' instructions if there are ROMs in the design;
    #define_jtag_instruction -name MBISTROM      -opcode 00110 -register MBISTROM  -length 1

    #- Define 'MBISTDIAG' instructions if diagnostics is specified in the configuration file;
    # define_jtag_instruction -name MBISTDIAG     -opcode 00100 -register MBISTDIAG -length 1
    # define_jtag_instruction -name MBISTROMDIAG  -opcode 00010 -register MBISTROMDIAG -length 1
    

}

##############################################################################
# STEP add_mbist_logic
##############################################################################
create_flow_step -name add_mbist_logic -owner design {
    
    #- Add MBIST logic as required
    #read_pmbist_memory_view -preview
    read_pmbist_memory_view -cdns_memory_view_file pmbist_inputs/[get_db flow_vars_design_name]_cdns_memory_view.txt 

    define_mbist_clock -name jtag_tck -period 50000 jtag_tck -is_jtag_tck 
    define_mbist_clock -name mbist_clk -period 2000 clk_i

    # define_mbist_clock -name mbist_clk \
    # 	-hookup_period 2000 \
    # 	-hookup_pin pin:tta_coprocessor_ss_wrapper/i_subsystem_clock_control/i_main_ckgate/inst_CKLNQD8BWP30P140LVT/Q \
    # 	-period 2000 \
    # 	-internal_clock_source clk_i


    set_db test_signal:[get_db flow_vars_design_name]/scan_mode_[get_db flow_vars_design_name] .pmbist_use test_block_async_reset
    set_db test_signal:[get_db flow_vars_design_name]/scan_mode_[get_db flow_vars_design_name] .pmbist_use test_clock_select

    # Note: these are only for mbist, deleted later
    # define_test_signal -function custom -name sel_cka   {port:tta_coprocessor_ss_wrapper/clk_ctrl[0]}
    # define_test_signal -function custom -name force_cka {port:tta_coprocessor_ss_wrapper/clk_ctrl[1]}
    # define_test_signal -function custom -name force_ckb {port:tta_coprocessor_ss_wrapper/clk_ctrl[2]}
    # define_test_signal -function custom -name clkena    {port:tta_coprocessor_ss_wrapper/clk_ctrl[3]}

    # define_dft_cfg_mode \
    # 	-mode_enable_high "sel_cka clkena scan_reset_[get_db flow_vars_design_name]" \
    # 	-mode_enable_low  "scan_mode_[get_db flow_vars_design_name] scan_enable_[get_db flow_vars_design_name] force_cka force_ckb" \
    # 	-name pmbist

    define_dft_cfg_mode \
	-mode_enable_high "scan_reset_[get_db flow_vars_design_name]" \
	-mode_enable_low  "scan_mode_[get_db flow_vars_design_name] scan_enable_[get_db flow_vars_design_name]" \
	-name pmbist

    add_pmbist \
	-dont_map \
	-module_prefix [get_db flow_vars_design_name] \
	-dft_cfg_mode pmbist \
	-config_file pmbist_inputs/[get_db flow_vars_design_name]_config_file.txt \
	-directory pmbist

    write_dft_pmbist_interface_files \
	-directory ./pmbist/ \
	-overwrite


    write_dft_pmbist_testbench \
	-directory ./pmbist \
	-ncsim_library "/userwork13/nmikkone/ballast/impl/dft_libs/tta_include_sim_blocks.v" \
	-create_embedded_test_options "prodschedule=parallel_parallel " \
	-sim_with_deposit_script \
	-irun_options "+DEFINE+no_warning" \
	

}

##############################################################################
# STEP add_scan_logic
##############################################################################
create_flow_step -name add_scan_logic -owner design {

    # These testports are only for mbist
    # delete_obj test_signal:[get_db flow_vars_design_name]/sel_cka
    # delete_obj test_signal:[get_db flow_vars_design_name]/force_cka
    # delete_obj test_signal:[get_db flow_vars_design_name]/force_ckb
    # delete_obj test_signal:[get_db flow_vars_design_name]/clkena
    
    #- Re-run DFT rule checks
    check_dft_rules 

    # DFT SIMPLE:
    #- Number of scan chains determined automatically
    #define_scan_chain -create_ports -sdi sdi -sdo sdo -terminal_lockup level_sensitive

    define_scan_chain -sdi scan_in0 -sdo scan_out0 -create_ports -name scan_chain_0

    if {[get_db flow_feature_synth_physical] || [get_db flow_feature_synth_spatial]} {
	connect_scan_chains \
	    -auto_create_chains -dont_exceed_min_number_of_scan_chains \
	    -physical -cluster_aggressively_high
    } else {
	connect_scan_chains \
	    -auto_create_chains -dont_exceed_min_number_of_scan_chains
	
    }
    

    

    #- Commit power intent rules
    #commit_power_intent

    #- Check power structures
    #check_power_structure

    if {[get_db flow_feature_synth_physical] || [get_db flow_feature_synth_spatial]} {

	#- Incrementally place the new DFT logic
	place_dft
    }

    uniquify [current_design] -verbose

    # connect shift enable signal to AICG TE-pins (can be done only after design is uniquified)
    # go through all instantiated cgs
    set_db ui_respects_preserve false
    foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
	disconnect [get_db pins $icg_inst/TE]
	connect [get_db ports scan_enable_[get_db flow_vars_design_name] ] [get_db pins $icg_inst/TE] -prefix DFT_AICG_TE_scan_enable_
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
