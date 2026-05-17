################################################################################
# Local setup for macros in hierarchical designs
# Setup lef & libs fr tools, regardless of whether DUT contains any macros
################################################################################
# Time-stamp: <2025-10-30 09:01:30 qftele>
#########################################################################################################
# Macro info
# List versions of macros used in DUT
#########################################################################################################
if {1} {
array unset global_macro_exportdir

set macro_scan_abstract_filelist [list ]
set macro_lef_filelist [list ]


array unset memarray

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
	    set $blockpath $local_macro_exportdir($blockname)
	}
    }

    # scan abstract for DFT
    if {[file exists $blockpath/dbs/syn_opt/$blockname.scan.abstract]} {
	lappend macro_scan_abstract_filelist $blockpath/dbs/syn_opt/$blockname.scan.abstract
    } else {
	puts "Error([info script]): scan abstract not found for block $blockname from $blockpath/dbs/syn_opt"
    }

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/opt_signoff"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/opt_signoff.sta"
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

    # MACROs
    if {[file exists $blockpath/models/opt_signoff/$blockname.lef]} {
	lappend macro_lef_filelist $blockpath/models/opt_signoff/$blockname.lef
    } else {
	puts "Fatal([info script]): .lef not found for block $blockname from $blockpath/models/opt_signoff"
	exit 1
    }

    # Read .lib -files
    # mmmc_vars(delay_corners) is set in mmmc_setup.tcl
    foreach dc $mmmc_vars(delay_corners) {

	regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	if {[file exists $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib]} {
	    lappend mmmc_vars(${dc},timing_nldm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	    lappend mmmc_vars(${dc},timing_ecsm) $blockpath/models/opt_signoff.sta/$blockname.${corn}_${volt}_${temp}_${rc}.lib
	} else {
	    puts "Fatal([info script]): .lib not found for block $blockname from $blockpath/models/opt_signoff.sta"
	    exit 1
	}
    }
}

########################################################################
# Memories
########################################################################

set memory_gds_filelist [list]
set memory_spi_filelist [list]
foreach {memdir memlist} [array get memarray] {

    set mem_directory ./models
    foreach mem $memlist {

        lappend macro_lef_filelist ${mem_directory}/${mem}.lef

        # lappend macro_scan_abstract_filelist ${mem_directory}/${mem}/${mem}.ctl
        #lappend dft_library ${mem_directory}/model/verilog/${mem}.v
        #lappend dft_ncsim_library ${mem_directory}/model/verilog/${mem}.v

        #lappend memory_gds_filelist ${mem_directory}/gds/${mem}.gds

        #lappend memory_spi_filelist ${mem_directory}/cdl/${mem}.cdl

        foreach dc $mmmc_vars(delay_corners) {

	    regexp {([^_]+)_([^_]+)_([^_]+)_([\w]+)} $dc -> corn volt temp rc

	    if {[regexp {SS} $dc]} {
		set volt "0P720V"
		set temp "125C"
	    } else {
		set volt "0P880V"
		set temp "M40C"
	    }
	    

            lappend mmmc_vars(${dc},timing_nldm) ${mem_directory}/${mem}.slow_0p9v_125c_cmax_func.lib
            lappend mmmc_vars(${dc},timing_ccs) ${mem_directory}/${mem}.slow_0p9v_125c_cmax_func.lib
            #lappend mmmc_vars(${dc},timing_lvf) ${mem_directory}/${mem}/${mem}_${corn}g_${rc}_${volt}_${volt}_${temp}.lib_ecsm_tv
        }
    }
}

########################################################################
# Manual hacks for dirty models
########################################################################
# .lefs
# .libs

# lef_filelist originally set in libray_setup.tcl
puts "Info: Adding macro info to flow_vars_lef_list in [info script]"
set_db flow_vars_lef_list [concat [get_db flow_vars_lef_list] $macro_lef_filelist]
set pll_idx [lsearch -regexp [get_db flow_vars_lef_list] {CLKPLL}]
set_db flow_vars_lef_list [lreplace [get_db flow_vars_lef_list] $pll_idx $pll_idx]

puts "Info: re-writing flow_vars_scan_abstracts in [info script]"
set_db flow_vars_scan_abstracts $macro_scan_abstract_filelist
}
