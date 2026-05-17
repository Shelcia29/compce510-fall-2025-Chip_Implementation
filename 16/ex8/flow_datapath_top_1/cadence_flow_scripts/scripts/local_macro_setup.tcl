################################################################################
# Local setup for macros in hierarchical designs
# Setup lef & libs fr tools, regardless of whether DUT contains any macros
################################################################################
# Time-stamp: <2025-06-08 21:45:30 qftele>
#########################################################################################################
# Macro info
# List versions of macros used in DUT
#########################################################################################################
array set local_macro_exportdir {
}

# Set here paths for all subblocks your design instantiates
#array set local_macro_exportdir {
#    axi_cdc_split_intf_dst_h   /userwork8/tlehtine/projects/riscv/impl_development/flow_axi_cdc_split_intf_dst_h_1
#    axi_cdc_split_intf_src_h   /userwork8/tlehtine/projects/riscv/impl_development/flow_axi_cdc_split_intf_src_h_1
#}

set macro_scan_abstract_filelist [list ]
set macro_lef_filelist [list ]
set macro_gds_filelist [list ]
# Go through global settings for macros and see if there's a local override
foreach {blockname blockpath} [array get global_macro_exportdir] {

    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT"
	continue
    }

    if {[info exists local_macro_exportdir($blockname)]} {
	if {[string compare $blockpath $local_macro_exportdir($blockname)]} {
	    puts "Warning([info script]): Overriding global setting for $blockname ->"
	    puts "\#OLD\#: $blockpath"
	    puts "\#NEW\#: $local_macro_exportdir($blockname)"
	    set blockpath $local_macro_exportdir($blockname)
	}
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # LEF
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/opt_signoff"
	exit 1
    }

    # GDS
    if {[file exists $blockpath/models/opt_signoff/$blockname.gds.gz]} {
	lappend macro_gds_filelist $blockpath/dbs/opt_signoff/$blockname.gds.gz
    } else {
	puts "Error([info script]): .gds not found for block $blockname from $blockpath/models/opt_signoff"
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib ($dc: $corn $volt $temp $rc) not found for block $blockname from $blockpath/models/opt_signoff.sta"
	    exit 1
	}
    }
}

# sanity check to see if global setting are missing block which are defined in local settings!
foreach {blockname blockpath} [array get local_macro_exportdir] {
    # do not read in a model for DUT
    if {![string compare $blockname [get_db flow_vars_design_name]]} {
	puts "Info([info script]): Skipping reading in model for $blockname since it's DUT. Remove the definition from local macro settings!"
	continue
    }

    set found 0
    if {[info exists global_macro_exportdir($blockname)]} {
	set found 1
    }

    if {!$found} {
	puts "Warning([info script]): Global setting for $blockname set in local setting not found from global settings! Report this to project toplevel!"	
    } else {
	# it was found so it's already set
	continue
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # LEF
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/opt_signoff"
	exit 1
    }

    # GDS
    if {[file exists $blockpath/dbs/opt_signoff/$blockname.gds.gz]} {
	lappend macro_gds_filelist $blockpath/dbs/opt_signoff/$blockname.gds.gz
    } else {
	puts "Error([info script]): .gds not found for block $blockname from $blockpath/dbs/opt_signoff"
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib ($dc: $corn $volt $temp $rc) not found for block $blockname from $blockpath/models/opt_signoff.sta"
	    exit 1
	}
    }
}

########################################################################
# Manual hacks for dirty models
########################################################################
# .lefs
#lappend macro_lef_filelist /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/apb_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_LOG_DEPTH2_A_DATA_SIZE80_D_DATA_SIZE80_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_MASTER0_NB_SLAVE1.lef
#lappend macro_lef_filelist /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/corehw_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_CB_LOG_DEPTH2_CB_A_DATA_SIZE80_CB_D_DATA_SIZE80_CB_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_AXI_MASTER1_NB_AXI_SLAVE1_NB_AXILITE_SLAVE0.lef
# .libs
foreach dc $mmmc_vars(delay_corners) {
#    lappend mmmc_vars(${dc},timing_nldm) /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/apb_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_LOG_DEPTH2_A_DATA_SIZE80_D_DATA_SIZE80_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_MASTER0_NB_SLAVE1.lib
#    lappend mmmc_vars(${dc},timing_ecsm) /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/apb_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_LOG_DEPTH2_A_DATA_SIZE80_D_DATA_SIZE80_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_MASTER0_NB_SLAVE1.lib
#    lappend mmmc_vars(${dc},timing_nldm) /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/corehw_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_CB_LOG_DEPTH2_CB_A_DATA_SIZE80_CB_D_DATA_SIZE80_CB_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_AXI_MASTER1_NB_AXI_SLAVE1_NB_AXILITE_SLAVE0.lib
#    lappend mmmc_vars(${dc},timing_ecsm) /userwork8/tlehtine/projects/riscv/impl_first/flow28_ballast_top_16/models/corehw_ss_wrapper_AXI_ADDR_WIDTH32_AXI_DATA_WIDTH32_AXI_ID_WIDTH7_AXI_USER_WIDTH6_CB_LOG_DEPTH2_CB_A_DATA_SIZE80_CB_D_DATA_SIZE80_CB_B_DATA_SIZE15_PLL_CTRL_WIDTH32_CLK_CTRL_WIDTH8_NB_AXI_MASTER1_NB_AXI_SLAVE1_NB_AXILITE_SLAVE0.lib
}

# lef_filelist originally set in libray_setup.tcl
puts "Info: Adding macro info to flow_vars_lef_list in [info script]"
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $macro_lef_filelist]

puts "Info: Adding macro info to flow_vars_macro_gds_list in [info script]"
set_db flow_vars_macro_gds_list [concat [get_db flow_vars_macro_gds_list] $macro_gds_filelist]

puts "Info: re-writing flow_vars_scan_abstracts in [info script]"
set_db flow_vars_scan_abstracts $macro_scan_abstract_filelist
