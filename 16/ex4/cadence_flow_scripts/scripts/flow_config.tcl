# Flowkit v19.10-s008_1
# Time-stamp: <2025-06-08 21:42:33 qftele>
################################################################################
# This file contains content which is used to customize the refererence flow
# process.  Commands such as 'create_flow', 'create_flow_step' and 'edit_flow'
# would be most prevalent.  For example:
#
# create_flow_step -name write_sdf -owner user -write_db {
#   write_sdf [get_db flow_report_directory]/[get_db flow_report_name].sdf
# }
#
# edit_flow -after flow_step:innovus_report_late_timing -append flow_step:write_sdf
#
################################################################################

################################################################################
# FLOW INCLUDE FILES
################################################################################
set_db flow_include_files {genus_config.tcl innovus_config.tcl tempus_config.tcl modus_config.tcl dft_config.tcl em_config.tcl flow_existing_step_overwrite.tcl}

if {[file exists scripts/flow_attributes.tcl]} {
    source -quiet scripts/flow_attributes.tcl
} else {
    source [file join [get_db flow_source_directory] flow_attributes.tcl]
}

# DESIGN SPECIFIC SETUP
if {[file exists scripts/design_setup.tcl]} {
    puts "Info: Sourcing scripts/design_setup.tcl"
    source scripts/design_setup.tcl
} else {
    puts "Fatal: scripts/design_setup.tcl not found. Exiting"
    exit 1
}
# Read setup files. First project-level setup, then local overrides
# TECHNOLOGY

if {[file exists scripts/tech_setup.tcl]} {
    puts "Warning: Overriding project technology setup from local folder"
    puts "Info: Sourcing scripts/tech_setup.tcl"
    source scripts/tech_setup.tcl
} elseif {[file exists [get_db flow_source_directory]/tech_setup.tcl]} {
    puts "Info: Sourcing [get_db flow_source_directory]/tech_setup.tcl"
    source [get_db flow_source_directory]/tech_setup.tcl
}
# MMMC

if {[file exists [get_db flow_source_directory]/mmmc_setup.tcl]} {
    puts "Info: Sourcing [get_db flow_source_directory]/mmmc_setup.tcl"
    source [get_db flow_source_directory]/mmmc_setup.tcl
}

if {[file exists scripts/mmmc_setup.tcl]} {
    puts "Warning: Overriding project mmmc setup from local folder"
    puts "Info: Sourcing scripts/mmmc_setup.tcl"
    source scripts/mmmc_setup.tcl
}

# LIBRARIES

if {[file exists scripts/library_setup.tcl]} {
    puts "Warning: Overriding project library setup from local folder"
    puts "Info: Sourcing scripts/library_setup.tcl"
    source scripts/library_setup.tcl
} elseif {[file exists [get_db flow_source_directory]/library_setup.tcl]} {
    puts "Info: Sourcing [get_db flow_source_directory]/library_setup.tcl"
    source [get_db flow_source_directory]/library_setup.tcl
}

# MACRO SETUP
if {[file exists [get_db flow_source_directory]/global_macro_setup.tcl]} {
    puts "Info: Sourcing [get_db flow_source_directory]/global_macro_setup.tcl"
    source [get_db flow_source_directory]/global_macro_setup.tcl
}
if {[file exists scripts/local_macro_setup.tcl]} {
    puts "Warning: Overriding project macro setup from local folder"
    puts "Info: Sourcing scripts/local_macro_setup.tcl"
    source scripts/local_macro_setup.tcl
} else {
    puts "Info: Sourcing \"default\" local_macro_setup -file from [get_db flow_source_directory]/local_macro_setup.tcl"
    source [get_db flow_source_directory]/local_macro_setup.tcl
}

################################################################################
# FLOW CPU AND HOST SETTINGS
################################################################################
create_flow_step -name init_mcpu -owner flow {
    # Multi host/cpu attributes
    #-----------------------------------------------------------------------------
    # The FLOWTOOL_NUM_CPUS is an environment variable which should be exported by
    # the specified dist script.  This connects the number of CPUs being reserved
    # for batch jobs with the current flow scripts.  The LSB_MAX_NUM_PROCESSORS is
    # a typical environment variable exported by distribution platforms and is
    # useful for ensuring all interactive jobs are using the reserved amount of CPUs.
    if {[info exists ::env(FLOWTOOL_NUM_CPUS)]} {
	set max_cpus $::env(FLOWTOOL_NUM_CPUS)
    } elseif {[info exists ::env(LSB_MAX_NUM_PROCESSORS)]} {
	set max_cpus $::env(LSB_MAX_NUM_PROCESSORS)
    } else {
	set max_cpus 8
    }

    switch -glob [get_db program_short_name] {
	joules*       -
	genus*        {
	    set_db max_cpus_per_server                $max_cpus
	}
	innovus*      -
	tempus*       -
	voltus*       {
	    set_multi_cpu_usage -verbose -local_cpu   $max_cpus
	    if {[get_feature -feature opt_signoff]} {
		if {[is_flow -inside flow:opt_signoff]} {
		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
		    set_distributed_hosts                             -local
		}
	    }
	    if {[get_feature -feature sta_eco]} {
		if {[is_flow -inside flow:sta_eco]} {
		    set_multi_cpu_usage -verbose -remote_host         1 -cpu_per_remote_host $max_cpus
		    set_distributed_hosts                             -local
		}
	    }
	}
	default       {}
    }
}
edit_flow -after Cadence.plugin.flowkit.read_db.pre -append flow_step:init_mcpu
edit_flow -after Cadence.plugin.flowkit.read_db.post -append flow_step:init_mcpu

################################################################################
# FLOW FEATURES
################################################################################
# Enable flow features for implementation and related reporting flows by using
# the flollowing example syntax:
#  set_feature flow:cts -feature setup_views -value "view1 view2"
#  set_feature flow:cts -feature hold_views -value "view3"
################################################################################
