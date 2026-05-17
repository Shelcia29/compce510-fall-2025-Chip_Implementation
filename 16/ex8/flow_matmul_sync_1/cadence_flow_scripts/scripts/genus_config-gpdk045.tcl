# Flowkit v19.10-s008_1
# Time-stamp: <2025-09-02 09:55:33 qftele>
################################################################################
# Genus attributes
#
#  Flow_steps used to drive tool behavior.  Most typically these are root level
#  attributes.  All root attributes can be listed by using 'report_obj -all' or
#  by category using 'report_obj -all -verbose'
#
#  Further attribute help can be obtained by using the command 'help <ATTRIBUTE>'
#
#  Two flow_steps are provided to allow users to specify tool level configs.
#  Users may add additional flow_steps to the file which also direct tool behaviour.
#
#    init_elaborate: specify tool settings before a design has been loaded.  These are
#                    typically attributes in the 'hdl' and 'lib_*' categories.
#
#    init_genus:     specify tool settings after a design has been loaded via init_design
#
################################################################################

##############################################################################
# STEP init_elaborate
##############################################################################
create_flow_step -name init_elaborate -owner flow {

    # Tool settings
    set_db information_level 9
    
    # TL: Warns for each missing io port in def...
    suppress_messages PHYS-156
    # TL: Warns about multiple connections to power pins
    suppress_messages PHYS-2381

    # HDL attributes [get_db -category hdl]
    #-------------------------------------------------------------------------------
    if {![get_db flow_feature_disable_naming_rules]} {
	puts "Info: Setting naming rules"
	set_db hdl_array_naming_style %s_%d
	set_db hdl_instance_array_naming_style %s_%d
	set_db hdl_generate_index_style   %s_%d
	set_db hdl_generate_separator _
	set_db hdl_bus_wire_naming_style %s_%d
	set_db hdl_record_naming_style %s_%s
    }
    if {[get_feature -feature flow_express]} {
	# track RTL filename, row & column information for e.g. removed registers
	set_db hdl_track_filename_row_col true
    }
    set_db hdl_max_loop_limit 32768
    # Add, TL. new variable because of LTEMOD rtl, new in genus 18.73 (not official release)
    #set_db hdl_array_read_mux_opto true
    # Don't use scan ports for functional stuff
    set_db use_scan_seqs_for_non_dft 		false
    # Do not optimize away any logic which has floating nets in RTL
    set_db hdl_unconnected_value none
    # Do not set top name to a monstrous string with all non-default parameter values
    set_db hdl_parameterize_module_name false
    # no ungrouping to see hierarchy areas
    #set_db auto_ungroup none

    # Note, TL: temp fix for "interface signals using configurations bug"
    set_db hdl_link_hier_inst_across_hdl_libraries true

}

##############################################################################
# STEP init_genus
##############################################################################
create_flow_step -name init_genus -owner flow {

    # Tool settings
    set_db information_level 9

    # Timing attributes  [get_db -category tim]
    #-------------------------------------------------------------------------------
    set_db ocv_mode                         true
  
    if {[get_feature -feature dft_simple] || [get_feature -feature dft_compressor]} {
	# DFT attributes  [get_db -category dft]
	#-------------------------------------------------------------------------------
	set_db dft_wait_for_license true
	
    }
    # automatic identification is a must to preserve synchronizer connections
    set_db dft_auto_identify_shift_register true

    # No identification for other test signals
    set_db dft_identify_internal_test_clocks false
    set_db dft_identify_test_signals false
    set_db dft_identify_top_level_test_clocks false
    set_db dft_include_controllable_pins_in_abstract_model allmodes


    # Optimization attributes  [get_db -category netlist]
    #-------------------------------------------------------------------------------
    if {[get_feature -feature flow_express]} {
	set_db syn_generic_effort express
	set_db syn_map_effort     express
	set_db syn_opt_effort     express
    } else {
	set_db syn_generic_effort medium
	set_db syn_map_effort medium
	set_db syn_opt_effort medium
    }
    set_db lp_insert_clock_gating true
    set_db auto_ungroup both
    
    # Datapath attributes  [get_db -category dp]
    #-------------------------------------------------------------------------------
  
    # Leakage Power attributes  [get_db -category lp_opt lib_ui]
    #-------------------------------------------------------------------------------
    set_db leakage_power_effort medium
  
    # Physical Synthesis attributes  [get_db -category phys]
    #-------------------------------------------------------------------------------
    set_db design_process_node              22
    if {[get_feature -feature flow_express]} {
	set_db design_flow_effort               express
    }
    if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
	# Physical Synthesis attributes  [get_db -category phys]
	#-------------------------------------------------------------------------------
	if {[array names env INNOVUSHOME] != ""} {
	    set_db innovus_executable               $env(INNOVUSHOME)/tools/bin/innovus
	} else {
	    set_db innovus_executable               /opt/soc/eda/cadence/INNOVUS191/tools/bin/innovus
	}
	set_db phys_checkout_innovus_license    false

	if {[file exists scripts/innovus_config.tcl]} {
	    set_db invs_preload_script              scripts/innovus_config.tcl
	    set_db invs_postload_script             ""
	} else {
	    set_db invs_preload_script              [get_db flow_source_directory]/innovus_config.tcl
	    set_db invs_postload_script             ""
	}
	set_db invs_temp_dir $env(TMPDIR)/invs_temp_dir

	set_db number_of_routing_layers 7

	# # Clock gating setup
	set_db base_cell:TLATNTSCAX4 .dont_use false
	set_db current_design .lp_clock_gating_cell TLATNTSCAX4

	set_db current_design .max_dynamic_power 0.06
	set_db current_design .lp_power_optimization_weight 0.5

	set_db lp_power_analysis_effort high
	set_db lp_power_unit mW
    }

    # DFT helper procedures
    source -quiet [get_db flow_source_directory]/dft_utils.tcl

}
