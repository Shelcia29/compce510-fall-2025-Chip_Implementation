##############################################################################
# Project level Mode & Corner definitions
##############################################################################
# Time-stamp: <2025-09-23 16:49:18 qftele>

set MMMC_SETUP_VERSION "v1.0"
# $TECHNOLOGY is set in tech_setup.tcl
puts "Info: MMMC SETUP: $TECHNOLOGY : $MMMC_SETUP_VERSION"

# Delay corner list
set mmmc_vars(delay_corners) \
    [list \
	 slow_0p9v_125c_cmax \
	 fast_1p1v_0c_cmin \
	 ]


# Read .lib -files
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # qrc techfile
    set mmmc_vars("${rc}_${temp}",qrc_tech) "[get_db flow_vars_qrc_tech_directory]/gpdk045.tch"
    # temperature
    if {${temp} == "m40c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "-40"
    } elseif {${temp} == "125c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "125"
    } elseif {${temp} == "0c"} {
	set mmmc_vars("${rc}_${temp}",temperature) "0"
    } else {
	set mmmc_vars("${rc}_${temp}",temperature) "25"
    }


    ###########################################
    # OCVs &  Clock uncertainties for FLAT OCV
    ###########################################

    # use following uncertainties
    # FUNC:
    # setup:
    # clock jitter: defined through clock cycle
    # TECH uncertainty: 25ps
    # extra uncertainty (implementation): 20ps
    # extra uncertainty (signoff STA): 0ps
    # hold:
    # TECH uncertainty (SSG): 50ps
    # TECH uncertainty (fast): 40ps
    # extra uncertainty (implementation): 15ps
    # extra uncertainty (signoff STA): 0ps

    # Note, add 1% OCV on top of previous to match LVF
    # so flat values below have 0.01 added (subtracted) because of this

    # setup in slow, 0.81v, -40C/125c, cmax
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	($rc eq "cmax")} {
	
	# -2.0% + -3.7% (10mV V-margin) + -0.6% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.927"
	# +2.0% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.03"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_cell_early)   "1.0"
	# + 6.9% on data cell
	set mmmc_vars(${dc},flat_data_cell_late)    "1.079"

	# -6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.93"
	# +6.0% for clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.07"
	# hold not checked in this corner
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# +6.0 for data net
	set mmmc_vars(${dc},flat_data_net_late)    "1.07"

    # hold in slow, 0.81v, -40c/125c, cmax
    } elseif {$corn eq "slow" &&
	      $volt eq "0p9v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.2% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.882"
	# +3.2% for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.042"
	# -9.7% + -7.0% (20mV V-margin) + -0.6% (10c T-margin) for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.817"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmax
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmax")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.103"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# -8.5% for launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "0.905"
	# no derate on capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.0"
	# -8.5% for data net
	set mmmc_vars(${dc},flat_data_net_early)   "0.905"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    # hold in fast, 0.99v, -40c/0c/125c, cmin
    } elseif {$corn eq "fast" &&
	      $volt eq "1p1v" &&
	      ($temp eq "m40c" || $temp eq "0c" || $temp eq "125c") &&
	      ($rc eq "cmin")} {
	
	# -3.7% for launching clock cell
	set mmmc_vars(${dc},flat_clock_cell_early)  "0.953"
	# +3.7% + +5.1% (30mV V-margin) + 0.5% (10c T-margin) for capturing clock cell
	set mmmc_vars(${dc},flat_clock_cell_late)   "1.083"
	# -12.1% for data
	set mmmc_vars(${dc},flat_data_cell_early)   "0.869"
	# setup not checked
	set mmmc_vars(${dc},flat_data_cell_late)    "1.0"

	# no derate on launching clock net
	set mmmc_vars(${dc},flat_clock_net_early)  "1.0"
	# +8.5% for capturing clock net
	set mmmc_vars(${dc},flat_clock_net_late)   "1.075"
	# no derate for data net
	set mmmc_vars(${dc},flat_data_net_early)   "1.0"
	# setup not checked
	set mmmc_vars(${dc},flat_data_net_late)    "1.0"

    } else {
	puts "Fatal: delay corner ${dc} OCVs not defined (corner: $corn, voltage: $volt, temperature: $temp, rc: ${rc})"
	exit 1
    }

    ###########################################
    # OCVs &  Clock uncertainties for SOCV
    ###########################################

    # Note, only voltage and temperature OCVs needed

    # Early & late variation factors from:
    set mmmc_vars(early_rc_variation_factor) 0.06
    set mmmc_vars(late_rc_variation_factor) 0.06

    set mmmc_vars(timing_socv_analysis_nsigma_multiplier) 3

    # slow, 0.81v, -40c
    if {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "m40c"} {
        
        # DATA  @ 20.3mV : 7.4%
        # DATA  @ 10c    : 0.9%
        # CLOCK @ 20.3mV : 5.4%
        # CLOCK @ 10c    : 0.7%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.054"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.061"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.083"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "125c"} {
       
        # DATA  @ 20.3mV : 5.0%
        # DATA  @ 10c    : 0.3%
        # CLOCK @ 20.3mV : 3.5%
        # CLOCK @ 10c    : 0.2%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.037"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.037"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.053"

    } elseif {$corn eq "slow" &&
	$volt eq "0p9v" &&
	$temp eq "0c"} {
       
        # DATA  @ 20.3mV : 6.6%
        # DATA  @ 10c    : 0.8%
        # CLOCK @ 20.3mV : 4.9%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.055"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.055"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "m40c"} {
       
        # DATA  @ 45mV   : 7.4%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 5.1%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.057"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.057"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.079"

     } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "125c"} {

        # DATA  @ 45mV   : 5.8%
        # DATA  @ 10c    : 0.5%
        # CLOCK @ 45mV   : 3.6%
        # CLOCK @ 10c    : 0.6%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.042"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.042"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.063"

    } elseif {$corn eq "fast" &&
	$volt eq "1p1v" &&
	$temp eq "0c"} {

        # DATA  @ 45mV   : 7.0%
        # DATA  @ 10c    : 0.4%
        # CLOCK @ 45mV   : 4.7%
        # CLOCK @ 10c    : 0.4%

        # For setup only derate clock
	set mmmc_vars(${dc},socv_clock_cell_late)   "0.051"
	set mmmc_vars(${dc},socv_data_cell_late)    "0.0"
        # For hold in slow derate data & launching clock
	set mmmc_vars(${dc},socv_clock_cell_early)  "-0.051"
	set mmmc_vars(${dc},socv_data_cell_early)   "-0.074"

     } else {
        puts "Fatal: corner / voltage / temperature combination not allowed (corner: $corn, voltage: $volt, temperature: $temp)"
        exit 1
    }
}

# Constraint mode list
set mmmc_vars(constraint_modes) [get_db flow_vars_constraint_modes]

foreach cm $mmmc_vars(constraint_modes) {
    if {[get_db program_short_name] == "genus"} {
#	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
#	} else {
#	    set mmmc_vars(${cm},sdc_files) [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.dummy.tcl
#	}
    } else {
	if {${cm} == "func"} {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.hier_dft.tcl \
						]
	} else {
	    set mmmc_vars(${cm},sdc_files) [list [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.${cm}.tcl \
						[get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].boundary_conditions.tcl \
						]
	}
    }
}
