# Flowkit v19.10-s008_1
# Time-stamp: <2025-11-11 10:34:33 qftele>


##############################################################################
## CONSTRAINT MODES
##############################################################################
foreach constraint_mode $mmmc_vars(constraint_modes) {
    create_constraint_mode -name $constraint_mode -sdc_files $mmmc_vars($constraint_mode,sdc_files)
}

array unset tcs
array unset rcs
array unset ocs
foreach dc $mmmc_vars(delay_corners) {
    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # temperature
    set temp_val "0.0"
    if {${temp} == "m40c" || ${temp} == "M40C"} {
        set temp_val "-40.0"
    } elseif {${temp} == "125c" || ${temp} == "125C"} {
        set temp_val "125.0"
    } elseif {${temp} == "25c" || ${temp} == "25C"} {
        set temp_val "25.0"
    } elseif {${temp} == "85c" || ${temp} == "85C"} {
        set temp_val "85.0"
    } else {
        set temp_val "0.0"
    }
    
    # voltage
    set volt_val "0.9"
    set volt_val [regsub {[v|V]} [regsub {[p|P]} $volt "."] ""]
    

    ## LIBRARY SETS
    if {[get_db program_short_name] == "genus"} {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_nldm)
    } elseif {[get_db program_short_name] == "innovus"} {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
    } elseif {[get_db program_short_name] == "tempus"} {
        if {[info exist $mmmc_vars(${dc},timing_lvf)] && [info exist $mmmc_vars(${dc},timing_socv)]} {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_lvf) -socv $mmmc_vars(${dc},timing_socv)
        } else {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
        }
    } elseif {[get_db program_short_name] == "voltus"} {
        if {[info exist $mmmc_vars(${dc},timing_lvf)] && [info exist $mmmc_vars(${dc},timing_socv)]} {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_lvf) -socv $mmmc_vars(${dc},timing_socv)
        } else {
            create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
        }
    } else {
	create_library_set -name "${corn}_${volt}_${temp}_ls" -timing $mmmc_vars(${dc},timing_ecsm)
    }

    ## OPERATING CONDITIONS
    if {![info exists ocs("${volt}_${temp}")]} {
	create_opcond -name "${volt}_${temp}" -process 1.0 -voltage $volt_val -temperature $temp_val
	set ocs("${volt}_${temp}") 1
    }

    ## TIMING CONDITIONS
    if {![info exists tcs("${corn}_${volt}_${temp}")]} {
	create_timing_condition -name "${corn}_${volt}_${temp}" -library_sets "${corn}_${volt}_${temp}_ls" -opcond "${volt}_${temp}"
	set tcs("${corn}_${volt}_${temp}") 1
    }
    
    ## RC CORNERS
    if {![info exists rcs("${rc}_${temp}")]} {
	create_rc_corner -name "${rc}_${temp}" -qrc_tech $mmmc_vars("${rc}_${temp}",qrc_tech) -temperature $mmmc_vars("${rc}_${temp}",temperature)
	set rcs("${rc}_${temp}") 1
    }

    ## DELAY CORNERS
    create_delay_corner -name ${dc} -timing_condition "${corn}_${volt}_${temp}" -rc_corner "${rc}_${temp}"

    ## ANALYSIS VIEWS
    foreach constraint_mode $mmmc_vars(constraint_modes) {
	create_analysis_view -name "${dc}_${constraint_mode}" -delay_corner $dc -constraint_mode $constraint_mode
    }
}

##############################################################################
## ACTIVE VIEWS
##############################################################################
if {[get_db program_short_name] == "genus"} {
  set_analysis_view \
    -setup             [get_db flow_vars_setup_synth_active_views]  \
    -leakage           [get_db flow_vars_power_view] \
    -dynamic           [get_db flow_vars_power_view]
} elseif {[get_db program_short_name] == "innovus"} {
  set_analysis_view \
    -setup             [get_db flow_vars_setup_pnr_active_views]  \
    -hold              [get_db flow_vars_hold_pnr_active_views]  \
    -leakage           [get_db flow_vars_power_view] \
    -dynamic           [get_db flow_vars_power_view]
} else {
  set_analysis_view \
    -setup             [get_db flow_vars_setup_sta_active_views]  \
    -hold              [get_db flow_vars_hold_sta_active_views]  \
    -leakage           [get_db flow_vars_power_view] \
    -dynamic           [get_db flow_vars_power_view]
}

