################################################################################
# Project level Library setup
################################################################################
# Time-stamp: <2025-09-29 00:44:20 qftele>

set PROJECT "Ballast"
set LIBRARY_SETUP_VERSION "v1.0"
puts "Info: LIBRARY SETUP: $PROJECT : $LIBRARY_SETUP_VERSION"

# Directory structure
set_db flow_vars_stdcell_path                               "/opt/soc/tech/GPDK045/gsclib045"
set_db flow_vars_dft_data_directory                         [exec pwd]/dft_lib
set_db flow_vars_dft_library                                "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"
set_db flow_vars_dft_ncsim_library                          "[get_db flow_vars_dft_data_directory]/dft_lib_specify.v"

# STD CELL dont use list
set_db flow_vars_dont_use_list                              [list "{.name==*FOOFOO*}" "{.name==*FIIFAA*}" ]


################################################################################
# Physical information of macros & std cells
################################################################################
set io_lef_filelist [list ]
set io_gds_filelist [list ]
set io_spi_filelist [list ]

# PADs
lappend io_lef_filelist ""
lappend io_gds_filelist ""
lappend io_spi_filelist ""

set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $io_lef_filelist]
set_db flow_vars_io_gds_list $io_gds_filelist
set_db flow_vars_io_spi_list $io_spi_filelist

set stdcell_lef_filelist [list ]
set stdcell_gds_filelist [list ]
set stdcell_spi_filelist [list ]

# Add LEF
lappend stdcell_lef_filelist [get_db flow_vars_stdcell_path]/lef/gsclib045_macro.lef

set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $stdcell_lef_filelist]
set_db flow_vars_stdcell_gds_list $stdcell_gds_filelist
set_db flow_vars_stdcell_spi_list $stdcell_spi_filelist

# Add slow & fast
foreach dc $mmmc_vars(delay_corners) {
    set mmmc_vars(${dc},timing_nldm) [list \
                                         ]
    set mmmc_vars(${dc},timing_ecsm) [list \
                                         ]
    # PAD .lib
    if {[regexp {slow} $dc]} {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/slow_vdd1v0_basicCells.lib
    } else {
        lappend mmmc_vars(${dc},timing_nldm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
        lappend mmmc_vars(${dc},timing_ecsm) [get_db flow_vars_stdcell_path]/timing/fast_vdd1v0_basicCells.lib
    }
}
