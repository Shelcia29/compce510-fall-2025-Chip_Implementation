# Flowkit v19.10-s008_1
# Time-stamp: <2025-10-25 15:41:10 qftele>

# Copyright (C) 2014 Cadence Design Systems, Inc.
# All Rights Reserved.
# CCRNI-0013
#
# This work is protected by copyright laws and contains Cadence proprietary
# and confidential information.  No part of this file may be reproduced,
# modified, re-published, used, disclosed or distributed in any way, in any
# medium, whether in whole or in part, without prior written permission from
# Cadence Design Systems, Inc.
#
#==============================================================================
#- run_flow.tcl: source this file to define required flow objects and consume
#                all customizations

###############################################################################
# Flow Setup
###############################################################################
# Generated using: Flowkit v19.10-s008_1
# Command: write_flow_template -type block -tools {genus innovus tempus} -enable_feature opt_early_cts -optional_feature {dft_compressor dft_simple flow_express opt_eco opt_em opt_postcts_hold_disable opt_postroute_split opt_signoff report_clp report_inline report_lec sta_eco synth_spatial}

###############################################################################
# Define Flow Features
###############################################################################

# +--------------------------+--------------------------------------------------------------------------------+----------+
# | Feature                  | Description                                                                    | Value    |
# +--------------------------+--------------------------------------------------------------------------------+----------+
# | clock_design             | Run skew based clock expansion                                                 | disabled |
# | clock_flexible_htree     | Build flexible H-tree structure for clock nets                                 | disabled |
# --- the following features are mutually exclusive (dft_style group)
# | dft_compressor           | Add flow support for scan chains with compression insertion                    | optional |
# | dft_simple               | Add flow support for scan chain insertion                                      | optional |
# ---
# | flow_express             | Enable express synthesis and implementation flow                               | optional |
# | opt_early_cts            | Implement early clock tree for use during prects optimization (LIMITED ACCESS) | enabled  |
# | opt_eco                  | Run opt_design during eco flow                                                 | optional |
# | opt_em                   | Run EM (Electromigration) optimization during implementation flow              | optional |
# | opt_postcts_hold_disable | Disable postcts hold fixing                                                    | optional |
# | opt_postcts_split        | Run postcts opt_design for setup and hold as separate steps                    | disabled |
# | opt_postroute_split      | Run postroute opt_design for setup and hold as separate steps                  | optional |
# | opt_preroute             | Run combined preroute optimization flow (LIMITED ACCESS)                       | disabled |
# | opt_route                | Run combined postroute optimization flow (LIMITED ACCESS)                      | disabled |
# | opt_signoff              | Run opt_signoff during implementation flow                                     | optional |
# | report_clp               | Add CLP dofile generation and checks to the flow                               | optional |
# --- the following features are mutually exclusive (report_style group)
# | report_defer             | Defer report generation                                                        | disabled |
# | report_inline            | Run report generation as part of parent flow versus schedule_flow              | optional |
# | report_none              | Disable report generation                                                      | disabled |
# ---
# | report_lec               | Add LEC dofile generation and checks to the flow                               | optional |
# | route_secondary_nets     | Route secondary PG nets before route_design                                    | disabled |
# | route_track_opt          | Adds track based optimization to route_design                                  | disabled |
# | sta_dmmmc                | Use distributed MMMC architecture for running STA runs                         | disabled |
# | sta_eco                  | Run opt_signoff during signoff flow                                            | optional |
# | sta_glitch               | Add glitch analysis reports to STA flow                                        | disabled |
# --- the following features are mutually exclusive (synth_style group)
# | synth_hybrid             | Physically aware synthesis flow with logical final optimization                | disabled |
# | synth_physical           | Full physically aware synthesis flow                                           | disabled |
# | synth_spatial            | Physically aware synthesis flow with spatial final optimization                | optional |
# ---
# +--------------------------+--------------------------------------------------------------------------------+----------+

set_db flow_template_type {block}
set_db flow_template_version {1}
set_db flow_template_feature_definition {flow_express {} report_schedule {} report_defer 0 report_none 0 report_clp {} report_lec {} dft_simple {} dft_compressor {} synth_hybrid 0 synth_spatial {} synth_physical {} opt_early_cts 1 opt_preroute 0 clock_design 0 clock_flexible_htree 0 opt_postcts_hold_disable {} opt_postcts_split 0 route_track_opt 0 route_secondary_nets {} opt_postroute_split {} opt_route 0 opt_signoff {} opt_em {} opt_eco {} sta_dmmmc 0 sta_glitch 0 sta_eco {} run_joules_power {} generate_models {} disable_naming_rules {} dont_use_ulvt {} add_mbist {} add_scan {} add_opcg {} add_bscan {} add_1500 {} run_atpg {} run_dft {} full_atpg {} add_pvs_fill {} add_pegasus_beol_fill {} add_pvs_feol_fill {} add_pegasus_feol_fill {} check_drc_pvs {} check_drc_pegasus {} check_lvs_pvs {} check_lvs_pegasus {} fix_route_drc {} pnr_db_handoff {} rail_analysis {}}
define_feature flow_express -description {Enable express synthesis and implementation flow} -type bool
define_feature report_schedule -description {Run report generation as a separate thread (note uses additional license) vs inline} -type bool
define_feature report_clp -description {Add CLP dofile generation and checks to the flow} -type bool
define_feature report_lec -description {Add LEC dofile generation and checks to the flow} -type bool
define_feature dft_simple -description {Add flow support for scan chain insertion} -type bool
define_feature dft_compressor -description {Add flow support for scan chains with compression insertion} -type bool
define_feature synth_spatial -description {Physically aware synthesis flow with spatial final optimization} -type bool
define_feature synth_physical -description {Physically aware synthesis flow with full phgysical final optimization} -type bool
define_feature opt_postcts_hold_disable -description {Disable postcts hold fixing} -type bool
define_feature route_secondary_nets -description {Route secondary PG nets before route_design} -type bool
define_feature opt_postroute_split -description {Run postroute opt_design for setup and hold as separate steps} -type bool
define_feature opt_signoff -description {Run opt_signoff during implementation flow} -type bool
define_feature rail_analysis -description {Run rail analysis in Voltus after flow} -type bool
define_feature opt_em -description {Run EM (Electromigration) optimization during implementation flow} -type bool
define_feature opt_eco -description {Run opt_design during eco flow} -type bool
define_feature sta_eco -description {Run opt_signoff during signoff flow} -type bool
define_feature add_pvs_fill -description {Insert metal fill using PVS} -type bool
define_feature add_pegasus_beol_fill -description {Insert metal fill using PEGASUS} -type bool
define_feature add_pvs_feol_fill -description {Insert FEOL fill using PVS} -type bool
define_feature add_pegasus_feol_fill -description {Insert FEOL fill using PEGASUS} -type bool
if {![is_attribute flow_feature_run_joules_power -obj_type root]} { define_attribute flow_feature_run_joules_power -help_string {Generate TCF with Joules} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_generate_models -obj_type root]} { define_attribute flow_feature_generate_models -help_string {Generate ETM and LEF models} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_disable_naming_rules -obj_type root]} { define_attribute flow_feature_disable_naming_rules -help_string {No naming rules} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_dont_use_ulvt -obj_type root]} { define_attribute flow_feature_dont_use_ulvt -help_string {Disable ULVT usage until opt_signoff} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_add_mbist -obj_type root]} { define_attribute flow_feature_add_mbist -help_string {add mbist logic} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_add_scan -obj_type root]} { define_attribute flow_feature_add_scan -help_string {add scan chains} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_add_opcg -obj_type root]} { define_attribute flow_feature_add_opcg -help_string {add opcg logic} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_add_bscan -obj_type root]} { define_attribute flow_feature_add_bscan -help_string {add boundary scan chains} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_add_1500 -obj_type root]} { define_attribute flow_feature_add_1500 -help_string {add 1500 wrapper logic} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_run_atpg -obj_type root]} { define_attribute flow_feature_run_atpg -help_string {Do ATPG in Modus} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_run_dft -obj_type root]} { define_attribute flow_feature_run_dft -help_string {Run DFT pattern generation and simulation after STA} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_full_atpg -obj_type root]} { define_attribute flow_feature_full_atpg -help_string {Create unlimited ATPG patterns} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_check_drc_pvs -obj_type root]} { define_attribute flow_feature_check_drc_pvs -help_string {Check DRC using PVS} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_check_drc_pegasus -obj_type root]} { define_attribute flow_feature_check_drc_pegasus -help_string {Check DRC using Pegasus} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_check_lvs_pvs -obj_type root]} { define_attribute flow_feature_check_lvs_pvs -help_string {Check LVS using PVS} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_check_lvs_pegasus -obj_type root]} { define_attribute flow_feature_check_lvs_pegasus -help_string {Check LVS using PEGASUS} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_fix_route_drc -obj_type root]} { define_attribute flow_feature_fix_route_drc -help_string {Check & fix regular route DRCs after route & postroute} -obj_type root -category flow -data_type bool -default false }
if {![is_attribute flow_feature_pnr_db_handoff -obj_type root]} { define_attribute flow_feature_pnr_db_handoff -help_string {Use DB handoff to PNR instead of netlist handoff} -obj_type root -category flow -data_type bool -default false }


###############################################################################
# Define Flow Attributes
###############################################################################

#- Define attribute for flow script path
if { ![is_attribute -obj_type root flow_source_directory] } {
  define_attribute flow_source_directory \
    -category flow \
    -data_type string \
    -default "" \
    -help_string "Flow script source location" \
    -obj_type root
}
set_db flow_source_directory [file dirname [file normalize [info script]]]

#- Define attribute for flow include files
if { ![is_attribute -obj_type root flow_include_files]} {
  define_attribute flow_include_files \
    -category flow \
    -data_type string \
    -default "" \
    -help_string "Files to use in flow customization" \
    -obj_type root
}

#- Define attribute for report name
if { ![is_attribute -obj_type root flow_report_name]} {
  define_attribute flow_report_name \
    -category flow \
    -data_type string \
    -default "" \
    -help_string "Name to use during report generation" \
    -obj_type root
}

#- Define attribute for report prefix
if { ![is_attribute -obj_type root flow_report_prefix]} {
  define_attribute flow_report_prefix \
    -category flow \
    -data_type string \
    -default "" \
    -help_string "File prefix to use during report generation" \
    -obj_type root
}




###############################################################################
# Load Flow Files
###############################################################################

if {[file exists scripts/flow/common_steps.tcl]} {
    source -quiet scripts/flow/common_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow common_steps.tcl]
}
if {[file exists scripts/flow/genus_steps.tcl]} {
    source -quiet scripts/flow/genus_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow genus_steps.tcl]
}
if {[file exists scripts/flow/innovus_steps.tcl]} {
    source -quiet scripts/flow/innovus_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow innovus_steps.tcl]
}
if {[file exists scripts/flow/tempus_steps.tcl]} {
    source -quiet scripts/flow/tempus_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow tempus_steps.tcl]
}
if {[file exists scripts/flow/voltus_steps.tcl]} {
    source -quiet scripts/flow/voltus_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow voltus_steps.tcl]
}
if {[file exists scripts/flow/modus_steps.tcl]} {
    source -quiet scripts/flow/modus_steps.tcl
} else {
    source -quiet [file join [file dirname [info script]] flow modus_steps.tcl]
}
if {[file exists scripts/design_config.tcl]} {
    source -quiet scripts/design_config.tcl
} else {
    source -quiet [file join [file dirname [info script]] design_config.tcl]
}

###############################################################################
# Define Implementation Subflows
###############################################################################

set syn_generic_steps {block_start init_elaborate elaborate_design init_design init_genus manage_uncertainty set_dont_use set_dont_touch genus_manage_preserve genus_manage_derating genus_manage_ungrouping genus_uniquify_design edit_post_elaborate_netlist}
if {[get_feature -feature add_mbist]|| [get_feature -feature add_bscan]} { lappend syn_generic_steps define_jtag_logic }
if {[get_feature -feature add_bscan]} { lappend syn_generic_steps add_jtag_logic }
if {[get_feature -feature add_scan]} { lappend syn_generic_steps init_scan }
if {[get_feature -feature add_mbist]} { lappend syn_generic_steps add_mbist_logic }
if {[get_feature -feature add_scan]} { lappend syn_generic_steps genus_add_dft_constraints }
lappend syn_generic_steps create_cost_group generate_activity_file genus_read_activity_file pre_syn_generic run_syn_generic block_finish
if {![get_feature -feature report_schedule]} { lappend syn_generic_steps report_synth }
if {[get_feature -feature report_schedule]} { lappend syn_generic_steps schedule_report_generic }
if {[get_db flow_feature_run_joules_power]} {
	create_flow -name syn_generic -owner cadence -tool genus -tool_options "-wait 2160 -lic_startup_options Joules_RTL_Power -disable_user_startup" $syn_generic_steps 
} else {
	create_flow -name syn_generic -owner cadence -tool genus -tool_options "-wait 2160 -disable_user_startup" $syn_generic_steps
}

set syn_map_steps {block_start init_genus pre_syn_map run_syn_map block_finish}
if {![get_feature -feature report_schedule]} { lappend syn_map_steps report_synth }
if {[get_feature -feature report_schedule]} { lappend syn_map_steps schedule_report_map }
if {[get_feature -feature report_lec]} { lappend syn_map_steps genus_to_lec }
create_flow -name syn_map -owner cadence -tool genus -tool_options "-wait 2160 -disable_user_startup" $syn_map_steps

set syn_opt_steps {block_start init_genus}
if {[get_feature -feature add_scan]} { lappend syn_opt_steps add_scan_logic genus_add_dft_constraints }
lappend syn_opt_steps run_syn_opt genus_update_names load_additional_procedures block_finish
if {![get_feature -feature report_schedule]} { lappend syn_opt_steps report_synth }
if {[get_feature -feature report_schedule]} { lappend syn_opt_steps schedule_report_synth }
if {[get_feature -feature report_lec]} { lappend syn_opt_steps genus_to_lec }
if {[get_feature -feature report_clp]} { lappend syn_opt_steps genus_to_clp }
if {[get_feature -feature add_scan]} { lappend syn_opt_steps genus_to_modus }
lappend syn_opt_steps genus_to_innovus genus_write_tcf
if {![get_feature -feature pnr_db_handoff]} { lappend syn_opt_steps release2pnr }
if {[get_db flow_feature_run_joules_power]} {
	create_flow -name syn_opt -owner cadence -tool genus -tool_options "-wait 2160 -lic_startup_options Joules_RTL_Power -disable_user_startup" $syn_opt_steps
} else {
	create_flow -name syn_opt -owner cadence -tool genus -tool_options "-wait 2160 -disable_user_startup" $syn_opt_steps
}

set floorplan_steps {block_start init_innovus init_floorplan check_tracks set_dont_use set_stdcell_opts manage_uncertainty innovus_manage_derating create_path_groups innovus_activate_pnr_views}
lappend floorplan_steps block_finish
if {[get_db flow_feature_generate_models]} { lappend floorplan_steps generate_abstract innovus_generate_etm }
#if {[get_db flow_feature_generate_models]} { lappend floorplan_steps generate_abstract }
if {![get_feature -feature report_schedule]} { lappend floorplan_steps report_floorplan }
if {[get_feature -feature report_schedule]} { lappend floorplan_steps schedule_report_floorplan }
if {[get_feature -feature report_lec]} { lappend floorplan_steps innovus_to_lec }
if {[get_feature -feature report_clp]} { lappend floorplan_steps innovus_to_clp }
create_flow -name floorplan -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $floorplan_steps

set prects_steps {block_start init_innovus add_clock_spec pre_run_place_opt run_place_opt block_finish}
if {![get_feature -feature report_schedule]} { lappend prects_steps report_prects }
if {[get_feature -feature report_schedule]} { lappend prects_steps schedule_report_prects }
create_flow -name prects -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $prects_steps

set cts_steps {block_start init_innovus manage_uncertainty add_clock_tree add_tieoffs}
lappend cts_steps block_finish
#if {[get_db flow_feature_generate_models]} { lappend cts_steps innovus_activate_all_views extract_rc write_parasitics innovus_generate_etm }
if {![get_feature -feature report_schedule]} { lappend cts_steps report_postcts }
if {[get_feature -feature report_schedule]} { lappend cts_steps schedule_report_postcts }
create_flow -name cts -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $cts_steps

set postcts_steps {block_start init_innovus innovus_save_latency_files}
if {![get_feature -feature opt_postcts_hold_disable]} { lappend postcts_steps run_opt_postcts_hold }
lappend postcts_steps block_finish
if {![get_feature -feature report_schedule]} { lappend postcts_steps report_postcts }
if {[get_feature -feature report_schedule]} { lappend postcts_steps schedule_report_postcts }
create_flow -name postcts -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $postcts_steps

set route_steps {block_start init_innovus add_fillers}
if {[get_feature -feature route_secondary_nets]} { lappend route_steps run_route_secondary_nets }
lappend route_steps run_route
if {[get_feature -feature fix_route_drc]} { lappend route_steps fix_route_drc }
lappend route_steps block_finish
if {![get_feature -feature report_schedule]} { lappend route_steps report_postroute }
if {[get_feature -feature report_schedule]} { lappend route_steps schedule_report_postroute }
create_flow -name route -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $route_steps

set postroute_steps {block_start init_innovus set_dont_use manage_uncertainty}
if {[get_feature -feature opt_postroute_split]} { lappend postroute_steps run_opt_postroute_setup }
if {[get_feature -feature opt_postroute_split]} { lappend postroute_steps run_opt_postroute_hold }
if {![get_feature -feature opt_postroute_split]} { lappend postroute_steps run_opt_postroute }
if {[get_feature -feature route_secondary_nets]} { lappend postroute_steps run_route_eco_secondary_nets }
if {[get_feature -feature fix_route_drc]} { lappend postroute_steps fix_route_drc fix_via4_r4_m5_drc }
if {![get_feature -feature opt_signoff] && [get_feature -feature add_pvs_fill]} { lappend postroute_steps trim_metal_fill }
if {![get_feature -feature opt_signoff] && [get_feature -feature add_pvs_fill]} { lappend postroute_steps write_stream_for_fill }
if {![get_feature -feature opt_signoff] && [get_feature -feature add_pvs_fill]} { lappend postroute_steps run_pvs_metal_fill }
#if {![get_feature -feature opt_signoff] && [get_feature -feature add_pvs_fill]} { lappend postroute_steps trim_metal_fill }
lappend postroute_steps block_finish
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em]} { lappend postroute_steps extract_rc write_parasitics }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em]} { lappend postroute_steps innovus_export_design }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em] && [get_db flow_feature_generate_models]} { lappend postroute_steps generate_abstract innovus_generate_etm }
if {![get_feature -feature report_schedule]} { lappend postroute_steps report_postroute }
if {[get_feature -feature report_schedule]} { lappend postroute_steps schedule_report_postroute }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em] && [get_feature -feature report_lec]} { lappend postroute_steps write_lec_constraints }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em] && [get_feature -feature report_lec]} { lappend postroute_steps innovus_to_lec }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em] && [get_feature -feature report_clp]} { lappend postroute_steps innovus_to_clp }
if {![get_feature -feature opt_signoff] && ![get_feature -feature opt_em]} { lappend postroute_steps innovus_to_tempus schedule_signoff }
create_flow -name postroute -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $postroute_steps

set opt_signoff_steps {block_start init_innovus manage_uncertainty run_opt_signoff}
if {[get_feature -feature route_secondary_nets]} { lappend opt_signoff_steps run_route_eco_secondary_nets }
if {[get_feature -feature fix_route_drc]} { lappend opt_signoff_steps fix_route_drc }
if {[get_feature -feature add_pvs_fill] || [get_feature -feature add_pegasus_beol_fill]} { lappend opt_signoff_steps trim_metal_fill }
if {[get_feature -feature add_pvs_fill] || [get_feature -feature add_pegasus_beol_fill]} { lappend opt_signoff_steps write_stream_for_fill }
if {[get_feature -feature add_pvs_fill]} { lappend opt_signoff_steps run_pvs_metal_fill }
if {[get_feature -feature add_pegasus_beol_fill]} { lappend opt_signoff_steps run_pegasus_metal_fill }
#if {[get_feature -feature add_pvs_fill]} { lappend opt_signoff_steps trim_metal_fill }
lappend opt_signoff_steps block_finish
if {![get_feature -feature opt_em]} { lappend opt_signoff_steps innovus_activate_all_views innovus_manage_derating extract_rc write_parasitics }
if {![get_feature -feature opt_em]} { lappend opt_signoff_steps innovus_export_design }
if {[get_feature -feature add_pvs_feol_fill]} { lappend opt_signoff_steps run_pvs_feol_fill }
if {[get_feature -feature add_pegasus_feol_fill]} { lappend opt_signoff_steps run_pegasus_feol_fill }
if {![get_feature -feature opt_em] && [get_feature -feature check_drc_pvs]} { lappend opt_signoff_steps schedule_check_drc_pvs }
if {![get_feature -feature opt_em] && [get_feature -feature check_drc_pegasus]} { lappend opt_signoff_steps schedule_check_drc_pegasus }
if {![get_feature -feature opt_em] && [get_feature -feature check_lvs_pvs]} { lappend opt_signoff_steps schedule_check_lvs_pvs }
if {![get_feature -feature opt_em] && [get_feature -feature check_lvs_pegasus]} { lappend opt_signoff_steps schedule_check_lvs_pegasus }
#if {![get_feature -feature opt_em] && [get_db flow_feature_generate_models]} { lappend opt_signoff_steps generate_abstract innovus_generate_etm }
if {![get_feature -feature opt_em] && [get_db flow_feature_generate_models]} { lappend opt_signoff_steps generate_abstract }
if {![get_feature -feature report_schedule]} { lappend opt_signoff_steps report_postroute }
if {[get_feature -feature report_schedule]} { lappend opt_signoff_steps schedule_report_postroute }
if {![get_feature -feature opt_em] && [get_feature -feature report_lec]} { lappend opt_signoff_steps write_lec_constraints }
if {![get_feature -feature opt_em] && [get_feature -feature report_lec]} { lappend opt_signoff_steps innovus_to_lec }
if {![get_feature -feature opt_em] && [get_feature -feature report_clp]} { lappend opt_signoff_steps innovus_to_clp }
if {![get_feature -feature opt_em]} { lappend opt_signoff_steps innovus_to_tempus }
create_flow -name opt_signoff -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $opt_signoff_steps

set opt_em_steps {block_start add_em_activity run_fix_ac_limit}
lappend opt_em_steps block_finish extract_rc write_parasitics
if {[get_db flow_feature_generate_models]} { lappend opt_em_steps generate_etm }
if {![get_feature -feature report_schedule]} { lappend opt_em_steps report_postroute }
if {[get_feature -feature report_schedule]} { lappend opt_em_steps schedule_report_postroute }
lappend opt_em_steps innovus_to_tempus schedule_signoff
create_flow -name opt_em -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $opt_em_steps

set eco_steps {eco_start init_innovus init_eco run_place_eco run_route_eco}
if {[get_feature -feature opt_eco]} { lappend eco_steps run_opt_eco }
if {[get_feature -feature add_pvs_fill]} { lappend eco_steps add_metal_fill_incremental }
lappend eco_steps eco_finish
if {![get_feature -feature report_schedule]} { lappend eco_steps report_postroute }
if {[get_feature -feature report_schedule]} { lappend eco_steps schedule_report_postroute }
lappend eco_steps extract_rc write_parasitics innovus_to_tempus schedule_signoff
create_flow -name eco -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" $eco_steps

###############################################################################
# Define Reporting Subflows
###############################################################################

set report_synth_steps {report_start init_genus report_area_genus report_timing_summary_late_genus report_late_paths report_power_genus report_design_genus genus_print_clock_tree_cells}
if {[get_feature -feature add_scan]} { lappend report_synth_steps report_dft_genus }
if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} { lappend report_synth_steps report_congestion_genus }
lappend report_synth_steps report_finish
create_flow -name report_synth -owner cadence -tool genus -tool_options "-wait 2160 -disable_user_startup" $report_synth_steps

create_flow -name fv_genus -owner cadence -tool genus {flow_step:genus_to_lec}
create_flow -name lec -owner cadence -tool lec

create_flow -name clp_genus -owner cadence -tool genus {flow_step:genus_to_clp}
create_flow -name clp -owner cadence -tool lec

create_flow -name report_floorplan -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" {report_start init_innovus report_area_innovus report_route_drc report_finish}

create_flow -name report_prects -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" {report_start init_innovus report_area_innovus report_timing_late_innovus report_late_paths report_power_innovus report_finish}

create_flow -name report_postcts -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" {report_start init_innovus report_area_innovus report_timing_early_innovus report_early_paths report_timing_late_innovus report_late_paths report_clock_timing report_power_innovus report_finish}

create_flow -name report_postroute -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" {report_start init_innovus report_area_innovus report_timing_early_innovus report_early_paths report_timing_late_innovus report_late_paths report_clock_timing report_power_innovus report_route_process report_route_drc report_route_density report_finish}

create_flow -name fv_innovus -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" {flow_step:innovus_to_lec}

#create_flow -name atpg -owner cadence -tool modus -tool_options -disable_user_startup {atpg_start init_modus build_model build_testmodes verify_test_structures build_faultmodel define_timing_static_atpg run_static_atpg commit_static_atpg write_verilog_parallel write_verilog_serial write_tester_format atpg_finish}
create_flow -name dft   -owner cadence -tool modus -tool_options -disable_user_startup {init_modus dft_start build_model edit_model build_faultmodel schedule_atpg schedule_mbist schedule_bscan report_dft}
create_flow -name hier_test_1687 -owner cadence -tool modus -tool_options -disable_user_startup {hier_test_1687_start build_testmode read_icl migrate_pdl_tests}
create_flow -name hier_test_1500 -owner cadence -tool modus -tool_options -disable_user_startup {hier_test_1500_start build_core_migration_model prepare_1500_bypass prepare_core_migration}
create_flow -name atpg  -owner cadence -tool modus -tool_options -disable_user_startup {atpg_start build_testmode report_test_structures define_timing_atpg prepare_opcg_test_sequences run_atpg report_untested write_verilog_atpg write_verilog_parallel commit_atpg schedule_simulation}
create_flow -name mbist -owner cadence -tool modus -tool_options -disable_user_startup {mbist_start create_mbist_interface_files build_testmode create_embedded_test write_verilog_mbist schedule_simulation create_mda_headers}
create_flow -name bscan -owner cadence -tool modus -tool_options -disable_user_startup {bscan_start build_testmode verify_11491_boundary write_verilog_bscan schedule_simulation}

# Tempus
set sta_steps {signoff_start init_tempus tempus_load_latency_files tempus_set_propagated_clock read_parasitics manage_uncertainty tempus_manage_derating update_timing check_timing report_timing_late report_late_paths report_timing_early report_early_paths write_sdf}
if {[get_db flow_feature_generate_models]} { lappend sta_steps tempus_generate_etm }
if {[get_feature -feature sta_eco]} { lappend sta_steps write_timing_db }
if {[get_feature -feature sta_eco]} { lappend sta_steps schedule_sta_eco }
lappend sta_steps signoff_finish post_sta
create_flow -name sta -owner cadence -tool tempus -tool_options "-wait 2160 -disable_user_startup" $sta_steps

# QRC
create_flow -name extract -owner cadence -tool qrc -tool_options "-lic_queue"

# Voltus
set static_rail_analysis_steps {signoff_start init_voltus read_parasitics add_switching_activity set_pg_nets config_static_rail_analysis run_static_rail_analysis report_rail signoff_finish}
create_flow -name static_rail_analysis -owner tuni -tool voltus -tool_options -disable_user_startup $static_rail_analysis_steps
set dynamic_rail_analysis_steps {signoff_start init_voltus read_parasitics add_switching_activity set_pg_nets config_dynamic_rail_analysis run_dynamic_rail_analysis report_rail signoff_finish}
create_flow -name dynamic_rail_analysis -owner tuni -tool voltus -tool_options -disable_user_startup $dynamic_rail_analysis_steps
set em_analysis_steps {signoff_start init_voltus read_parasitics add_switching_activity set_pg_nets config_em_analysis run_em_analysis report_rail signoff_finish}
create_flow -name em_analysis -owner tuni -tool voltus -tool_options -disable_user_startup $em_analysis_steps

create_flow -name sta_eco -owner cadence -tool tempus -tool_options "-wait 2160 -disable_user_startup -eco" {signoff_start init_tempus read_parasitics run_sta_opt_signoff write_eco signoff_finish}

create_flow -name signoff -owner cadence -tool innovus -tool_options "-wait 2160 -disable_user_startup" schedule_signoff_subflows

###############################################################################
# Define Block Flow
###############################################################################
set block_steps {syn_generic syn_map syn_opt floorplan prects cts}
if {![get_feature -feature opt_postcts_hold_disable]} { lappend block_steps postcts }
lappend block_steps route
if {![get_feature -feature flow_express]} { lappend block_steps postroute }
if {![get_feature -feature flow_express] && [get_feature -feature opt_signoff]} { lappend block_steps opt_signoff }
if {![get_feature -feature flow_express] && [get_feature -feature opt_em]} { lappend block_steps opt_em }
if {![get_feature -feature flow_express] } { lappend block_steps sta }
if {![get_feature -feature flow_express] && [get_feature -feature rail_analysis]} { lappend block_steps static_rail_analysis dynamic_rail_analysis em_analysis}
if {![get_feature -feature flow_express] && [get_feature -feature run_dft]} { lappend block_steps dft }

create_flow -name block -owner cadence -skip_metric $block_steps
if {[get_db program_short_name] ni {modus voltus}} {
    set_db flow_current flow:block
} else {
    # Different attribute in some programs
    set_db flow_top flow:block
}

###############################################################################
# Load Flow & Tool Customizations
###############################################################################

#- Include master flow config file
if {[file exists scripts/flow_config.tcl]} {
    puts "## FLOWKIT: sourcing scripts/flow_config.tcl"
    source -quiet scripts/flow_config.tcl
} else {
    puts "## FLOWKIT: sourcing [file join [file dirname [info script]] flow_config.tcl]"
    source -quiet [file join [file dirname [info script]] flow_config.tcl]
}
#- Include tool and user specified config files
foreach file [get_db flow_include_files] {
    if {![file exists scripts/$file] && ![file exists [file join [file dirname [info script]] $file]]} {
	error "## FLOWKIT include file $file not found in scripts/ or in [file dirname [info script]]"
    } else {
	if {[file exists scripts/$file]} {
	    puts "## FLOWKIT: checking include file scripts/$file for PLACEHOLDER content"
	    set FH [open scripts/$file]
	} else {
	    puts "## FLOWKIT: checking include file [file join [file dirname [info script]] $file] for PLACEHOLDER content"
	    set FH [open [file join [file dirname [info script]] $file]]
	}
	set lines [read $FH]
	close $FH
	set count 0
	foreach line [split $lines "\n"] {
	    incr count
	    if {[regexp {^\s*\#} $line]} {continue}
	    if {[regexp {PLACEHOLDER} $line]} {
		error "## FLOWKIT([file tail $file]) $count : has unreplaced PLACEHOLDER\n\t$line"
	    }
	}
    }
    if {[file exists scripts/$file]} {
	puts "## FLOWKIT: sourcing include file scripts/$file"
	source -quiet scripts/$file
    } else {
	puts "## FLOWKIT: sourcing include file [file join [file dirname [info script]] $file]"
	source -quiet [file join [file dirname [info script]] $file]
    }
}
