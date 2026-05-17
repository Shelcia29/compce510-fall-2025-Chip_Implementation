################################################################################
# Setup for macros in hierarchical designs
################################################################################
# Time-stamp: <2025-09-02 09:47:10 qftele>

set MACRO_SETUP_VERSION "v1.0"
puts "Info: MACRO SETUP: $MACRO_SETUP_VERSION"

#########################################################################################################
# Macro info
# List all DUT versions of all macros in project
#########################################################################################################
array set global_macro_exportdir {
}

#########################################################################################################
# Global IPs
#########################################################################################################

# .lefs
set ip_lef_filelist [list ]
# PLL
lappend ip_lef_filelist ""

set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $ip_lef_filelist]

# .libs
foreach dc $mmmc_vars(delay_corners) {

    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

    # PLL .lib
    lappend mmmc_vars(${dc},timing_nldm) ""
    lappend mmmc_vars(${dc},timing_ecsm) ""
    lappend mmmc_vars(${dc},timing_lvf) ""
}
