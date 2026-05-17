# Flowkit v19.10-s008_1
# Time-stamp: <2025-06-08 13:38:10 qftele>
################################################################################
# Tempus attributes
#
#  Attributes used to drive tool behavior.  Most typically these are root level
#  attributes.  All root attributes can be listed by using 'report_obj -all' or
#  by category using 'report_obj -all -verbose'
#
#  Further attribute help can be obtained by using the command 'help <ATTRIBUTE>'
#
#  The init_tempus flow_step is provided to specify tool level configs after a
#  design has been loaded via the init_design flow_step or specified as a
#  flow_starting_db from a subsequent flow (ie postroute).
#
################################################################################

##############################################################################
# STEP init_tempus
##############################################################################
create_flow_step -name init_tempus -owner flow {
  # Design attributes  [get_db -category design]
  #-------------------------------------------------------------------------------
  set_db design_process_node                        22

  # Timing attributes  [get_db -category timing]
  #-------------------------------------------------------------------------------
  set_db timing_report_fields                               {timing_point net edge cell user_derate transition load delay arrival annotation}

  set_db si_aggressor_alignment                             timing_aware_edge       
  
  # do not split report_constraint lines to enable scripting
  set_table_style -no_frame_fix_width -nosplit

  # Delaycal attributes  [get_db -category delaycal]
  #-------------------------------------------------------------------------------

  # set_delay_cal_mode -siAware true
  set_db delaycal_enable_si                         true
  # set_delay_cal_mode -ewm_type simulation -equivalent_waveform_model propagation
  set_db delaycal_ewm_type simulation
  set_db delaycal_equivalent_waveform_model propagation

  # Note TL, true is more conservative
  set_db delaycal_enable_quiet_receivers_for_hold true
  # Note TL, true is more accurate
  set_db delaycal_advanced_pin_cap_mode true 
  # Note TL, true is more accurate
  set_db delaycal_accurate_receiver_out_load true

  set_db timing_analysis_socv                       false
  set_db timing_analysis_cppr                       both
  set_db timing_analysis_type                       ocv

  set_db timing_socv_rc_variation_mode                      false

  # set_global timing_disable_retime_clock_path_slew_propagation false
  set_db timing_disable_retime_clock_path_slew_propagation false

  if {[get_feature -feature sta_eco]} {
    
    # Opt Signoff attributes  [get_db -category opt_signoff]
    #-------------------------------------------------------------------------------
    set_db opt_signoff_allow_multiple_incremental     true
    if {[file exists [file join [get_db flow_report_directory] [get_db flow_report_name]]]} {
      set_db opt_signoff_write_eco_opt_db             [get_db flow_report_directory]/[get_db flow_report_name]/sta_eco_timing_db
    }
    if {[file exists [file join [get_db flow_report_directory] [get_db flow_report_name] sta_eco_timing_db]]} {
      set_db opt_signoff_read_eco_opt_db              [get_db flow_report_directory]/[get_db flow_report_name]/sta_eco_timing_db
    }
  }
}
