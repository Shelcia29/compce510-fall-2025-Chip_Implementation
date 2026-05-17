# Time-stamp: <2025-09-02 09:26:09 qftele>
#- tech_dependent_steps-gpdk045.tcl : defines steps
# which are technology dependent

##############################################################################
# STEP config_static_rail_analysis
##############################################################################
create_flow_step -name config_static_rail_analysis -owner tuni {
    
    # Config static
    set_rail_analysis_config -reset
    set_rail_analysis_config \
        -accuracy hd \
        -method static \
        -analysis_view [get_db [get_db analysis_views -if {.is_dynamic}] .name] \
        -decap_cell_list [get_db [get_db base_cells *_DECAPX*] .name] \
        -filler_cell_list [get_db [get_db base_cells *_FILLX*] .name] \
        -ignore_decaps false \
        -ignore_fillers false \
        -enable_xp true \
        -write_movies true \
        -write_voltage_waveforms true \
        -power_grid_libraries [get_db flow_vars_voltus_file_list] \
        -temperature [get_db [get_db analysis_views -if {.is_dynamic}] .delay_corner.early_rc_corner.temperature] \
        -ict_em_models [get_db flow_vars_ict_em_models] \
        -process_techgen_em_rules true \
        -ignore_incomplete_net true \
        -em_peak_analysis true \
        -enable_2d_partition_extraction true \
        -enable_voltage_across_vias true \
        -extraction_tech_file [get_db [get_db analysis_views -if {.is_dynamic}] .delay_corner.early_rc_corner.qrc_tech_file] \
        -verbosity true

}

##############################################################################
# STEP config_dynamic_rail_analysis
##############################################################################
create_flow_step -name config_dynamic_rail_analysis -owner tuni {
    
    # Config dynamic
    set_rail_analysis_config -reset
    set_rail_analysis_config \
        -accuracy hd \
        -method dynamic \
        -analysis_view [get_db [get_db analysis_views -if {.is_dynamic}] .name] \
        -decap_cell_list [get_db [get_db base_cells *_DECAPX*] .name] \
        -filler_cell_list [get_db [get_db base_cells *_FILLX*] .name] \
        -ignore_decaps false \
        -ignore_fillers false \
        -enable_xp true \
        -write_movies true \
        -write_voltage_waveforms true \
        -power_grid_libraries [get_db flow_vars_voltus_file_list] \
        -temperature [get_db [get_db analysis_views -if {.is_dynamic}] .delay_corner.early_rc_corner.temperature] \
        -ict_em_models [get_db flow_vars_ict_em_models] \
        -process_techgen_em_rules true \
        -ignore_incomplete_net true \
        -em_peak_analysis true \
        -enable_voltage_across_vias true \
        -extraction_tech_file [get_db [get_db analysis_views -if {.is_dynamic}] .delay_corner.early_rc_corner.qrc_tech_file] \
        -verbosity true

}

##############################################################################
# STEP config_em_analysis
##############################################################################
create_flow_step -name config_em_analysis -owner tuni {
    
    # Config em
    set_db check_ac_limit_method {rms avg peak}
    set_db check_ac_limit_detailed true
    set_db check_ac_limit_toggle 1.0
    set_db check_ac_limit_use_qrc_tech true
    set_db check_ac_limit_ict_em_models [get_db flow_vars_ict_em_models] \
    set_db check_ac_limit_temperature 100 \
    set_db check_ac_limit_avg_recovery 0.5 \
    set_db check_ac_limit_report_db true \
    set_db check_ac_limit_out_file [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_p
refix]signal_em_toggle_based.rpt]
    
}
