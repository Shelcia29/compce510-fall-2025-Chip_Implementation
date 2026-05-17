
# Innovus
# read_db dbs/opt_signoff.enc{_?}


###########################################
# CONNECTIVITY
###########################################
puts "Running: check_connectivity -check_pg_ports -error 42424242"
redirect /dev/null {check_connectivity -check_pg_ports -error 42424242}
set metal10_errors 0
set metal11_errors 0

set metal10_errors [llength [get_db markers -if {.subtype==UnConnectedPin && .layer.name==Metal10}]]
set metal11_errors [llength [get_db markers -if {.subtype==UnConnectedPin && .layer.name==Metal11}]]

puts "  Errors on Metal10: $metal10_errors"
puts "  Errors on Metal11: $metal11_errors"
puts "\n"
delete_drc_markers

###########################################
# Routing DRC
###########################################
puts "Running: check_drc -check_only regular -limit 0"
redirect /dev/null {check_drc -check_only regular -limit 0}
set nonmetal1_errors 0

set nonmetal1_errors [llength [get_db markers -if {.layer.name!=Metal1}]]

puts "  Errors on non Metal1 layers: $nonmetal1_errors"
puts "\n"

delete_drc_markers


# Tempus
# read_db dbs/sta.enc{_?}
# run_flow -step read_parasitics

###########################################
# Parasitics
###########################################
puts "Running: report_annotated_parasitics"
redirect -variable rep_annotated_parasitics {report_annotated_parasitics}

set annotation_ok 0

foreach line [split ${rep_annotated_parasitics} "\n"] {
    
    if {[regexp {^\s*\|\s*total\s*\|\s*\d+\s*\|\s*\d+\s+(\S+)\s*\|} $line -> annotation]} {
        
        set annotation [regsub {%} $annotation {}]
        
        if {$annotation < 75.0} {
            puts "  ERROR: low annotation of parasitics ($annotation)"
            set annotation_ok 0
        } else {
            set annotation_ok 1
        }
    }
}
puts "\n"




###########################################
# Timing
###########################################
puts "Running: report_constraint"
redirect -variable rep_constr {report_constraint}

set chk_type setup
set violation_found 0
foreach line [split ${rep_constr} "\n"] {
    regexp {^\s*(max_delay/setup)\s*$} $line -> chk_type
    regexp {^\s*(min_delay/hold)\s*$} $line -> chk_type
    regexp {^\s*Check\s+type\s*:\s*(\S+)$} $line -> chk_type
    
    if {[regexp {VIOLATED} $line]} {
        puts "  Check: $chk_type VIOLATION"
        puts "  $line"
        set violation_found 1
    }
}
puts "\n"

puts "Running: report_clocks"
redirect -variable rep_clocks {report_clocks}

set clk_period
foreach line [split ${rep_clocks} "\n"] {

    if {[regexp {^\s*clk_i\s+clk_i\s+slow_0p9v_125c_cmax_func\s+(\S+)} $line -> clk_period]} {
        puts "  Clk_period: $clk_period"
    }
}
puts "\n"

puts "Running: check_timing -verbose"
redirect -variable chk_timing {check_timing -verbose}

foreach line [split ${chk_timing} "\n"] {

    if {[regexp {^\s*(\S+)\s+.+\s+(\S+)$} $line -> path view]} {
	set pinname [file tail $path]
        if {$pinname == "SI" ||
	    $pinname == "SE" ||
	    $pinname == "SN" ||
	    $pinname == "RDWEN" ||
            $pinname == "RN"} {
            continue
        }

	if {[regexp {BW} $pinname]} {
	    continue
	}

	if {[regexp {_scan_} $view]} {
	    if {$pinname == "D"} {
		continue
	    }

	    if {[regexp {i_ram/D} $line]} {
		continue
	    }
	}

	if {[regexp {_func} $view]} {
	    if {[regexp {lockup_latch} $line]} {
		continue
	    }

	    if {[regexp {scan_out_datapath_top} $line]} {
		continue
	    }

	    if {[regexp {i_clk_divider/inst_SDFFRX4/D} $line]} {
		continue
	    }
	}
    }
    puts $line
}
puts "\n"


puts "########################################################"
