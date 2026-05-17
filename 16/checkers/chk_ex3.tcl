puts "Start checking Exercise 3"

puts "Running: check_design"
redirect -variable check_design_report {check_design}
set unresolved 0
set undriven 0
set multidriven 0

foreach line [split ${check_design_report} "\n"] {
    if {[regexp {^Unresolved References\s+(\d+)\s*$} $line -> unresolved]} {
        if {$unresolved} {
            puts "Error: Design has unresolved references"
            puts "run: check_design -unresolved"
        }
    } elseif {[regexp {^(Undriven[^\d]+?)\s+(\d+)\s*$} $line -> undr_match undriven]} {
        if {$undriven} {
            puts "Error: Design has undriven $undr_match"
            puts "run: check_design -undriven"
        }
    } elseif {[regexp {^(Multidriven[^\d]+?)\s+(\d+)\s*$} $line -> multidr_match multidriven]} {
        if {$multidriven} {
            puts "Error: Design has multidriven $multidr_match"
            puts "run: check_design -multiple_driver"
        }
    }
}

puts "########################################################"
if {$unresolved || $undriven || $multidriven} {
    puts "FAIL"
} else {
    puts "Great success"
}
