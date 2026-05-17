# Flowkit v19.10-s008_1
# Time-stamp: <2025-06-08 21:36:12 qftele>
################################################################################
# This file contains 'create_flow_step' content for steps which are required
# in an implementation flow, but whose contents are specific.  Review  all
# <PLACEHOLDER> content and replace with commands and options more appropriate
# for the design being implemented. Any new flowstep definitions should be done
# using the 'flow_config.tcl' file.
################################################################################


##############################################################################
# STEP elaborate_design
##############################################################################
create_flow_step -name elaborate_design -owner design {
    if {[get_db current_design] eq ""} {
	#- setup library information
	global mmmc_vars
	if {[file exists scripts/mmmc_config.tcl]} {
	    read_mmmc             scripts/mmmc_config.tcl
	} else {
	    read_mmmc             [get_db flow_source_directory]/mmmc_config.tcl
	}
	read_physical         -lef [get_db flow_vars_lef_list]
	
	#- read and elaborate design
	#read_hdl
	if {[file exists scripts/compile_[get_db flow_vars_design_name].tcl]} {
	    puts "\nInfo: Sourcing scripts/compile_[get_db flow_vars_design_name].tcl"
	    source scripts/compile_[get_db flow_vars_design_name].tcl
	    puts "\n"
	} else {
	    puts "\nFatal: Compile-script not found! (scripts/compile_[get_db flow_vars_design_name].tcl)"
	    puts "             Run make create_genustech\n"
	    exit
	}

	# Check for non-default parameters for toplevel
	set topname [get_db flow_vars_design_name]
	if {[get_db flow_vars_design_top] != ""} {
	    set topname [get_db flow_vars_design_top]
	}
	if {[get_db flow_vars_elaboration_parameters] != ""} {
	    elaborate -parameters "[get_db flow_vars_elaboration_parameters]" ${topname}
	} else {
	    elaborate ${topname}
	}
	
	# possible post-elaborate step
	if {[file exists scripts/post_elaborate.tcl]} {
	    puts "\nInfo: Sourcing scripts/post_elaborate.tcl"
	    source scripts/post_elaborate.tcl
	    puts "\n"
	} elseif {[file exists [get_db flow_source_directory]/post_elaborate.tcl]} {
	    puts "\nInfo: Sourcing [get_db flow_source_directory]/post_elaborate.tcl"
	    source [get_db flow_source_directory]/post_elaborate.tcl
	    puts "\n"
	}
	
	# report macros after elaboration to see if linking is ok
	puts "\nInfo: All macros in design:"
	get_db insts -if {.is_macro==true} -foreach {puts [get_db $object .name]}
	puts "\n"
	
	
	# print memories into a text file (/reports folder)
	set fp [open [get_db flow_report_directory]/[get_db flow_vars_design_name].memories.txt w]
	if {[llength [get_db insts -if {.is_memory}]] > 0} {
	    get_db insts -if {.is_memory} -foreach {puts $fp "[get_db $object .name] : [get_db $object .base_cell.name]"}
	} else {
	    puts $fp "no memories found"
	}
	
	close $fp
    }

    if {![get_db flow_feature_disable_naming_rules]} {
	write_db -to_file [get_db flow_database_directory]/syn_generic.elaborate_design.db
    }

    report_messages -warning > [get_db flow_report_directory]/elaboration/report_messages_warnings.txt
    report_messages -error > [get_db flow_report_directory]/elaboration/report_messages_errors.txt
    check_design -multiple_driver -unresolved -undriven > [get_db flow_report_directory]/elaboration/check_design_fatal.txt
    check_design -unloaded -unloaded_comb > [get_db flow_report_directory]/elaboration/check_design_unloaded.txt
    check_design -combo_loops > [get_db flow_report_directory]/elaboration/check_design_combo_loops.txt
}

##############################################################################
# STEP init_design
##############################################################################
create_flow_step -name init_design -owner design {

    #- optionally setup power intent from UPF/CPF/1801
    if {[file exists [get_db flow_vars_power_intent]]} {
	read_power_intent -1801 [get_db flow_vars_power_intent]
    }

    #- initialize library and design information
    init_design

    #- load floorplan (created by using "write_def <DEF FILE> -no_core_cells -no_special_net -no_std_cells")
    if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
	set_db find_fuzzy_match true
	read_def  [get_db flow_vars_floorplan_def]
    }

    #- add cells and commit power rules
    if {[file exists [get_db flow_vars_power_intent]]} {
	commit_power_intent
    }

    update_names -suffix _cn -name_collision -max_length 1000 [get_db current_design] 

    #- load tool configs which require design information
    if {[file exists scripts/[get_db program_short_name]_config.tcl]} {
	uplevel #0 source -quiet scripts/[get_db program_short_name]_config.tcl
    } else {
	uplevel #0 source -quiet [file join [get_db flow_source_directory] [get_db program_short_name]_config.tcl]
    }

    if {[get_db flow_feature_disable_naming_rules]} {
	write_db -to_file [get_db flow_database_directory]/syn_generic.init_design.disable_naming_rules.db
    } else {
	write_db -to_file [get_db flow_database_directory]/syn_generic.init_design.db
    }
}
