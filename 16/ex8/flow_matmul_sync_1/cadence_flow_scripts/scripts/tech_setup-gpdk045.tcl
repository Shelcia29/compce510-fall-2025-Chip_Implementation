################################################################################
# Project level Technology setup
################################################################################
# Time-stamp: <2025-11-08 15:27:43 qftele>

set TECHNOLOGY "gpdk045"
set TECH_SETUP_VERSION "v1.0"
puts "Info: TECHNOLOGY SETUP: $TECHNOLOGY : $TECH_SETUP_VERSION"

# Directory structure
set_db flow_vars_lef_tech_file                             "/opt/soc/tech/GPDK045/gsclib045/lef/gsclib045_tech.lef"
set_db flow_vars_qrc_tech_directory                        "/opt/soc/tech/GPDK045/gsclib045/qrc"
set_db flow_vars_gdsout_stream_map_file                    "/opt/soc/tech/GPDK045/gsclib045/oa22/gsclib045/gsclib045.layermap"

# Technology files

# Physical Info
set tech_lef_filelist [list ]
lappend tech_lef_filelist                                   [get_db flow_vars_lef_tech_file]
# Note, flow_vars_lef_list should be empty at this point, and tech lef MUST be the first .lef file read in!
set_db flow_vars_lef_list $tech_lef_filelist

