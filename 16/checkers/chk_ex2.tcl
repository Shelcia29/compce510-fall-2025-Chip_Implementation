puts "Start checking Exercise 2"


set check_timing_ok 0
set check_timing_intent_total 4242
puts "Running: check_timing_intent -verbose"
redirect -variable check_timing_intent {check_timing_intent -verbose}
foreach line [split ${check_timing_intent} "\n"] {
    if {[regexp {Total:\s+(\d+)} $line -> check_timing_intent_total]} {
	puts "Lint total: ${check_timing_intent_total}"

	if {$check_timing_intent_total == 0} {
	    puts "Check_timing OK"
	    set check_timing_ok 1
	} else {
	    puts "Check_timing NOK"
	    set check_timing_ok 0
	}
    }
}


set clk_target_period 5000.0
set clk_period_ok 42
set clk_latency_ok 0
set clk_target_uncert 145.0
set clk_uncert_ok 42
puts "Running: report_clocks"
redirect -variable report_clocks {report_clocks}
set go_descr 0
set go_latency 0
foreach line [split ${report_clocks} "\n"] {

    if {[regexp {\s*Clock\s+Description\s*} $line]} {
	set go_descr 1
	set go_latency 0
	set go_relationship 0
    } elseif {[regexp {\s*Clock\s+Network\s+Latency\s*} $line]} {
	set go_descr 0
	set go_latency 1
	set go_relationship 0
    }
    
    if {$go_descr} {
	if {[regexp {^\s*slow_0p9v_125c_cmax_func\s+(\S+)\s+(\S+)} $line -> descr_name descr_period]} {
	    if {[expr $descr_period - $clk_target_period] < 0.001} {
		puts "Clock period OK"
		if {$clk_period_ok} {
		    set clk_period_ok 1
		}
	    } else {
		puts "Clock period NOK"
		set clk_period_ok 0
	    }
	}
    }

    if {$go_latency} {
	if {[regexp {^\s*slow_0p9v_125c_cmax_func\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\([^\)]+\))\s+(\S+)\s+(\S+)} $line -> latency_name latency_nrise latency_nfall latency_srise latency_sfall latency_uncert_rise latency_uncert_fall]} {
	    if {[expr $latency_uncert_rise - $clk_target_uncert] < 0.001} {
		puts "Rise uncertainty OK"
		if {$clk_uncert_ok} {
		    set clk_uncert_ok 1
		}
	    } else {
		puts "Rise uncertainty NOK"
		set clk_uncert_ok 0
	    }

	    if {[expr $latency_uncert_fall - $clk_target_uncert] < 0.001} {
		puts "Fall uncertainty OK"
		if {$clk_uncert_ok} {
		    set clk_uncert_ok 1
		}
	    } else {
		puts "Fall uncertainty NOK"
		set clk_uncert_ok 0
	    }
	}
    }
}

set timing_slack_ok 0
puts "Running: report_timing -path_type endpoint"
redirect -variable report_timing_endpoint {report_timing -path_type endpoint}
foreach line [split ${report_timing_endpoint} "\n"] {
    
    if {[regexp {^\s*(\d+)\s+(\d+)\s+(\S+)\s+(\S+)\s+slow_0p9v_125c_cmax_func\s*$} $line -> rte_id rte_slack rte_endpoint rte_group]} {
	if {$rte_id == 1} {
	    if {$rte_slack < -0.01} {
		puts "Error: Negative slack at endpoint $rte_endpoint (group $rte_group)"
	    } else {
		puts "Timing slack OK"
		set timing_slack_ok 1
	    }
	}
    }
	
}

puts "########################################################"
if {!$check_timing_ok || !$clk_period_ok || !$clk_uncert_ok || !$timing_slack_ok} {
    puts "FAIL"
} else {
    puts "Great success"
}
