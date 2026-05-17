###############################################
# Place all EM related stuff into own file
# Time-stamp: <2025-06-08 21:36:52 qftele>
###############################################

############################################################################
# STEP add_em_activity
############################################################################
create_flow_step -name add_em_activity -owner design {
    set_default_switching_activity -global_activity 0.2
    
    if {[file exists [get_db flow_vars_tcf_file]]} {
	read_activity_file [get_db flow_vars_tcf_file]
    } else {
	puts "Error: TCF file not defined for EM activity"
    }
    
    propagate_activity -set_net_freq true
}

############################################################################
# STEP run_fix_ac_limit
############################################################################
create_flow_step -name run_fix_ac_limit -owner design {
    #- report EM violations before fixing
    check_ac_limits \
	-out_file [file join [get_db flow_report_directory] [get_db flow_report_name] em.pre_fix_ac_limit.rpt] \
	-effort low
    
    #- fix reported EM violations
    fix_ac_limit_violations \
	-use_report_file [file join [get_db flow_report_directory] [get_db flow_report_name] em.pre_fix_ac_limit.rpt] \
	-exclude_io true \
	-fix_nets_category data_only
    
    #- report EM violations after fixing
    check_ac_limits \
	-out_file [file join [get_db flow_report_directory] [get_db flow_report_name] em.post_fix_ac_limit.rpt] \
	-effort low
}
