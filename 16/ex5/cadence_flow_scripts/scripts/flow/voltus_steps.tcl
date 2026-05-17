# Generated using: Flowkit 23.16-e002_1
#- voltus_steps.tcl : defines Voltus based flow_steps

##############################################################################
# STEP report_power
##############################################################################
create_flow_step -name report_power -owner cadence {
  report_power \
    -pg_pin \
    -out_dir [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name]]
}

##############################################################################
# STEP report_rail
##############################################################################
create_flow_step -name report_rail -owner cadence {
  report_rail  \
    -output_dir [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name] VOLTUS] \
      -type domain  \
      ALL
}

##############################################################################
# STEP set_pg_nets
##############################################################################
create_flow_step -name set_pg_nets -owner tuni {

    # chk if design has bumps, then take top PG-IOs from them
    if {[llength [get_db bumps]]} {
        set top_layer [lindex [lsort -dict -dec [get_db [get_db layers -if {.type==routing}] .route_index]] 0]
    } else {
        set top_layer [lindex [lsort -dict -dec [get_db [get_db layers -if {.type==routing}] .route_index]] 1]
    }
    
    foreach pg_port [get_db pg_ports .name] {
        write_power_pads \
            -format xy \
            -auto_fetch \
            -layer [get_db [get_db layers -if {.route_index==${top_layer}}] .name] \
            -net ${pg_port} \
            -voltage_source_file ${pg_port}.pp
    }

    # Mod files, they have ports on all layers
    foreach pg_port [get_db pg_ports .name] {
        exec grep " [get_db [get_db layers -if {.route_index==${top_layer}}] .name]" ${pg_port}.pp > ${pg_port}_mod.pp
    }


    foreach pg_port [get_db pg_ports .name] {
        set_power_pads \
            -format xy \
            -net ${pg_port} \
            -file ${pg_port}_mod.pp
    }

    
    foreach pg_port [get_db pg_ports] {
        if {[regexp {VDDPST} [get_db ${pg_port} .name]]} {
            set max_voltage 1.98
        } elseif {[regexp {VSS} [get_db ${pg_port} .name]]} {
            set max_voltage 0.0
        } else {
            set max_voltage 0.99
        }
        if {$max_voltage > 0.001} {
            set threshold [expr $max_voltage - ($max_voltage * 0.1)]
        } else {
            set threshold 0.09
        }
        set_pg_nets \
            -net [get_db ${pg_port} .name] \
            -voltage $max_voltage \
            -threshold ${threshold}
    }
}

##############################################################################
# STEP add_switching_activity
##############################################################################
create_flow_step -name add_switching_activity -owner tuni {
    
    foreach pd [get_db power_domains] {
        
        set_rail_analysis_domain \
            -domain_name [get_db $pd .name] \
            -power_nets [get_db [get_db $pd .primary_power_net] .name] \
            -ground_nets [get_db [get_db $pd .primary_ground_net] .name] \
            -threshold 0.10
    }

    set_default_switching_activity \
        -clock_gates_output 2.0 \
        -global_activity 0.2 \
        -input_activity 0.3

    set_dynamic_power_simulation \
        -period 5ns \
        -resolution 50ps
}

##############################################################################
# STEP run_static_rail_analysis
##############################################################################
create_flow_step -name run_static_rail_analysis -owner tuni {
    
    set_power_output_dir \
        [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name] VOLTUS]

    set_db power_view [get_db [get_db analysis_views -if {.is_dynamic}] .name]
    set_db power_write_db true
    set_db power_db_name static_vectorless_voltus_res.db
    set_db power_write_static_currents true
    set_db power_method static

    report_power

    set_dynamic_rail_simulation \
        -resolution 50ps

    set pgs [list ]
    foreach pg_port [get_db pg_ports .name] {
        lappend pgs [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name] VOLTUS static_${pg_port}.ptiavg]
    }

    set_power_data -reset
    set_power_data \
        -format current \
        ${pgs}

}

##############################################################################
# STEP run_dynamic_rail_analysis
##############################################################################
create_flow_step -name run_dynamic_rail_analysis -owner tuni {
    
    set_power_output_dir \
        [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name] VOLTUS]

    set_db power_view [get_db [get_db analysis_views -if {.is_dynamic}] .name]
    set_db power_write_db true
    set_db power_db_name dynamic_vectorless_voltus_res.db
    set_db power_write_static_currents true
    set_db power_method dynamic_vectorless

    report_power

    set_dynamic_rail_simulation \
        -resolution 100ps

    set pgs [list ]
    foreach pg_port [get_db pg_ports .name] {
        lappend pgs [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db [lindex [get_db flow_hier_path] end] .name] VOLTUS dynamic_${pg_port}.ptiavg]
    }

    set_power_data -reset
    set_power_data \
        -format current \
        ${pgs}

}

##############################################################################
# STEP run_em_analysis
##############################################################################
create_flow_step -name run_em_analysis -owner tuni {
    
    check_ac_limits
}
