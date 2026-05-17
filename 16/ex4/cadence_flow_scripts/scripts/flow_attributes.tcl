# User custom attributes definition
set flow_vars [dict create]

# Directory structure
dict lappend flow_vars flow_vars_data_directory                                 description   "Path to the input data"
dict lappend flow_vars flow_vars_data_directory                                 type          string
dict lappend flow_vars flow_vars_data_directory                                 default       ""
dict lappend flow_vars flow_vars_dft_data_directory                             description   "Path to the DFT input data"
dict lappend flow_vars flow_vars_dft_data_directory                             type          string
dict lappend flow_vars flow_vars_dft_data_directory                             default       ""
dict lappend flow_vars flow_vars_dft_library                                    description   "Path to the DFT std cell library"
dict lappend flow_vars flow_vars_dft_library                                    type          string
dict lappend flow_vars flow_vars_dft_library                                    default       ""
dict lappend flow_vars flow_vars_dft_ncsim_library                              description   "Path to the DFT include library"
dict lappend flow_vars flow_vars_dft_ncsim_library                              type          string
dict lappend flow_vars flow_vars_dft_ncsim_library                              default       ""
dict lappend flow_vars flow_vars_memory_path                                    description   "Path to memory libs"
dict lappend flow_vars flow_vars_memory_path                                    type          string
dict lappend flow_vars flow_vars_memory_path                                    default       ""
dict lappend flow_vars flow_vars_stdcell_path                                   description   "Path to stdcell libs"
dict lappend flow_vars flow_vars_stdcell_path                                   type          string
dict lappend flow_vars flow_vars_stdcell_path                                   default       ""
dict lappend flow_vars flow_vars_qrc_tech_directory                             description   "Path to qrc technology directory"
dict lappend flow_vars flow_vars_qrc_tech_directory                             type          string
dict lappend flow_vars flow_vars_qrc_tech_directory                             default       ""

# Technology files
dict lappend flow_vars flow_vars_lef_tech_file                                  description   "Path to lef technology file"
dict lappend flow_vars flow_vars_lef_tech_file                                  type          string
dict lappend flow_vars flow_vars_lef_tech_file                                  default       ""
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              description   "Path to PVS DRC rule file"
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_drc_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          description   "Path to Pegasus DRC rule file"
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_drc_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              description   "Path to PVS LVS rule file"
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              type          string
dict lappend flow_vars flow_vars_pvs_lvs_rule_file                              default       ""
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          description   "Path to PEGASUS LVS rule file"
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          type          string
dict lappend flow_vars flow_vars_pegasus_lvs_rule_file                          default       ""
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          description   "Path to PVS antenna rule file"
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          type          string
dict lappend flow_vars flow_vars_pvs_antenna_rule_file                          default       ""
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      description   "Path to Pegasus antenna rule file"
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      type          string
dict lappend flow_vars flow_vars_pegasus_antenna_rule_file                      default       ""
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       description   "Path to PVS metal fill rule file"
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       type          string
dict lappend flow_vars flow_vars_pvs_metal_fill_rule_file                       default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   description   "Path to PEGASUS metal fill rule file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_rule_file                   default       ""
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        description   "Path to PVS FEOL fill rule file"
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        type          string
dict lappend flow_vars flow_vars_pvs_feol_fill_rule_file                        default       ""
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    description   "Path to PEGASUS FEOL fill rule file"
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    type          string
dict lappend flow_vars flow_vars_pegasus_feol_fill_rule_file                    default       ""
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         type          string
dict lappend flow_vars flow_vars_gdsout_stream_map_file                         default       ""
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      description   "Path to PEGASUS metal fill stream out map file"
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      type          string
dict lappend flow_vars flow_vars_pegasus_metal_fill_gdsout_stream_map_file      default       ""
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          description   "Path to stream in map file"
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          type          string
dict lappend flow_vars flow_vars_gdsin_stream_map_file                          default       ""
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         description   "Path to stream out map file"
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         type          string
dict lappend flow_vars flow_vars_gdsout_layer_map_table                         default       ""
dict lappend flow_vars flow_vars_ict_em_models                                  description   "Path to ict em models"
dict lappend flow_vars flow_vars_ict_em_models                                  type          string
dict lappend flow_vars flow_vars_ict_em_models                                  default       ""

# Design info
dict lappend flow_vars flow_vars_rtl_root_dir                                   description   "Design RTL root directory"
dict lappend flow_vars flow_vars_rtl_root_dir                                   type          string
dict lappend flow_vars flow_vars_rtl_root_dir                                   default       ""
dict lappend flow_vars flow_vars_design_name                                    description   "Top level design name"
dict lappend flow_vars flow_vars_design_name                                    type          string
dict lappend flow_vars flow_vars_design_name                                    default       ""
dict lappend flow_vars flow_vars_design_top                                     description   "Top entity name to be elaborated"
dict lappend flow_vars flow_vars_design_top                                     type          string
dict lappend flow_vars flow_vars_design_top                                     default       ""
dict lappend flow_vars flow_vars_power_intent                                   description   "Path to the power intent file"
dict lappend flow_vars flow_vars_power_intent                                   type          string
dict lappend flow_vars flow_vars_power_intent                                   default       ""
dict lappend flow_vars flow_vars_floorplan_def                                  description   "Path to the floorplan def file"
dict lappend flow_vars flow_vars_floorplan_def                                  type          string
dict lappend flow_vars flow_vars_floorplan_def                                  default       ""
dict lappend flow_vars flow_vars_tcf_file                                       description   "Path to the activity file generated by joules"
dict lappend flow_vars flow_vars_tcf_file                                       type          string
dict lappend flow_vars flow_vars_tcf_file                                       default       ""
dict lappend flow_vars flow_vars_bist_signals                                   description   "Generated verilog file which specifies bist signal connectivity"
dict lappend flow_vars flow_vars_bist_signals                                   type          string
dict lappend flow_vars flow_vars_bist_signals                                   default       ""
dict lappend flow_vars flow_vars_scan_abstracts                                 description   "Subblock scan abstract file paths"
dict lappend flow_vars flow_vars_scan_abstracts                                 type          string
dict lappend flow_vars flow_vars_scan_abstracts                                 default       ""
dict lappend flow_vars flow_vars_elaboration_parameters                         description   "Design toplevel parameters"
dict lappend flow_vars flow_vars_elaboration_parameters                         type          string
dict lappend flow_vars flow_vars_elaboration_parameters                         default       ""

# MMMC info
dict lappend flow_vars flow_vars_constraint_modes                               description   "Define the list of constraint modes"
dict lappend flow_vars flow_vars_constraint_modes                               type          string
dict lappend flow_vars flow_vars_constraint_modes                               default       ""
dict lappend flow_vars flow_vars_setup_synth_active_views                       description   "Define the list of setup active analysis views for Synthesis"
dict lappend flow_vars flow_vars_setup_synth_active_views                       type          string
dict lappend flow_vars flow_vars_setup_synth_active_views                       default       ""
dict lappend flow_vars flow_vars_setup_pnr_active_views                         description   "Define the list of setup active analysis views for P&R"
dict lappend flow_vars flow_vars_setup_pnr_active_views                         type          string
dict lappend flow_vars flow_vars_setup_pnr_active_views                         default       ""
dict lappend flow_vars flow_vars_setup_sta_active_views                         description   "Define the list of setup active analysis views for STA"
dict lappend flow_vars flow_vars_setup_sta_active_views                         type          string
dict lappend flow_vars flow_vars_setup_sta_active_views                         default       ""
dict lappend flow_vars flow_vars_hold_views                                     description   "Define the list of hold analysis views"
dict lappend flow_vars flow_vars_hold_views                                     type          string
dict lappend flow_vars flow_vars_hold_views                                     default       ""
dict lappend flow_vars flow_vars_hold_pnr_active_views                          description   "Define the list of hold active analysis views for P&R"
dict lappend flow_vars flow_vars_hold_pnr_active_views                          type          string
dict lappend flow_vars flow_vars_hold_pnr_active_views                          default       ""
dict lappend flow_vars flow_vars_hold_sta_active_views                          description   "Define the list of hold active analysis views for STA"
dict lappend flow_vars flow_vars_hold_sta_active_views                          type          string
dict lappend flow_vars flow_vars_hold_sta_active_views                          default       ""
dict lappend flow_vars flow_vars_power_view                                     description   "Define the power analysis view"
dict lappend flow_vars flow_vars_power_view                                     type          string
dict lappend flow_vars flow_vars_power_view                                     default       ""
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            description   "Define the the list of different VTs that should be loaded in the tool"
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            type          string
dict lappend flow_vars flow_vars_mmmc_vt_flavor_list                            default       ""

# Physical info
dict lappend flow_vars flow_vars_lef_list                                       description   "Lef file list definition"
dict lappend flow_vars flow_vars_lef_list                                       type          string
dict lappend flow_vars flow_vars_lef_list                                       default       ""
dict lappend flow_vars flow_vars_stdcell_gds_list                               description   "Stdcell GDS file list definition"
dict lappend flow_vars flow_vars_stdcell_gds_list                               type          string
dict lappend flow_vars flow_vars_stdcell_gds_list                               default       ""
dict lappend flow_vars flow_vars_stdcell_spi_list                               description   "Stdcell SPICE file list definition"
dict lappend flow_vars flow_vars_stdcell_spi_list                               type          string
dict lappend flow_vars flow_vars_stdcell_spi_list                               default       ""
dict lappend flow_vars flow_vars_memory_gds_list                                description   "Memory GDS file list definition"
dict lappend flow_vars flow_vars_memory_gds_list                                type          string
dict lappend flow_vars flow_vars_memory_gds_list                                default       ""
dict lappend flow_vars flow_vars_memory_spi_list                                description   "Memory SPICE file list definition"
dict lappend flow_vars flow_vars_memory_spi_list                                type          string
dict lappend flow_vars flow_vars_memory_spi_list                                default       ""
dict lappend flow_vars flow_vars_io_gds_list                                    description   "IO GDS file list definition"
dict lappend flow_vars flow_vars_io_gds_list                                    type          string
dict lappend flow_vars flow_vars_io_gds_list                                    default       ""
dict lappend flow_vars flow_vars_io_spi_list                                    description   "IO SPICE file list definition"
dict lappend flow_vars flow_vars_io_spi_list                                    type          string
dict lappend flow_vars flow_vars_io_spi_list                                    default       ""
dict lappend flow_vars flow_vars_macro_gds_list                                 description   "Macro GDS file list definition"
dict lappend flow_vars flow_vars_macro_gds_list                                 type          string
dict lappend flow_vars flow_vars_macro_gds_list                                 default       ""
dict lappend flow_vars flow_vars_macro_spi_list                                 description   "Macro SPICE file list definition"
dict lappend flow_vars flow_vars_macro_spi_list                                 type          string
dict lappend flow_vars flow_vars_macro_spi_list                                 default       ""
dict lappend flow_vars flow_vars_dont_use_list                                  description   "dont_use cell list definition"
dict lappend flow_vars flow_vars_dont_use_list                                  type          string
dict lappend flow_vars flow_vars_dont_use_list                                  default       ""
dict lappend flow_vars flow_vars_sdf_list                                       description   "Macro SDF file list definition"
dict lappend flow_vars flow_vars_sdf_list                                       type          string
dict lappend flow_vars flow_vars_sdf_list                                       default       ""
dict lappend flow_vars flow_vars_voltus_file_list                               description   "Voltus file list definition"
dict lappend flow_vars flow_vars_voltus_file_list                               type          string
dict lappend flow_vars flow_vars_voltus_file_list                               default       ""

# Transform all dict to attribute
foreach myAttr [dict keys $flow_vars] {
  if { ![is_attribute -obj_type root $myAttr]} {
    define_attribute $myAttr \
      -category user_flow \
      -data_type [dict get $flow_vars $myAttr type] \
      -default [dict get $flow_vars $myAttr default] \
      -help_string [dict get $flow_vars $myAttr description] \
      -obj_type root
    }
}

