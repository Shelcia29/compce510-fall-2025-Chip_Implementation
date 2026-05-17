# Time-stamp: <2025-06-08 21:46:07 qftele>
# set bist controller as ungroup false

if {0} {
if {![file isdirectory dbs]} {
    file mkdir dbs
}
if {![file isdirectory dbs/syn_opt]} {
    file mkdir dbs/syn_opt
}

set_db [get_db hinsts i_ethss_bist_ctrl] .ungroup_ok false
set_db [get_db modules ethss_bist_ctrl] .boundary_opto strict_no

if {![file exists [get_db flow_vars_bist_signals]]} {
    puts "Error: [get_db flow_vars_bist_signals] file does not exist!"
    exit
}
set bist_sig_file [open [get_db flow_vars_bist_signals] r]
puts "Info: Reading bist signal definitions from [get_db flow_vars_bist_signals]"
set path ""
set hier_sig ""
set top_sig ""
array unset wire_widths
set mem_conns 0
set bist_map_file [open dbs/syn_opt/bist_signal_mapping.txt w]

while {[gets $bist_sig_file line] >=0 } {
    if {[regexp {^\s*//\s*synthesis\s+translate_off\s*$} $line]} {
	puts "Info: Start parsing memory connections from [info script]"
	set mem_conns 1
	continue
    } elseif {[regexp {^\s*//\s*synthesis\s+translate_on\s*$} $line]} {
	set mem_conns 0
    }

    # Take wire widths
    if {[regexp {^\s*wire\s*\[(.+?):\d+\]\s*(\w+)\s*;\s*$} $line -> idx_high sig_name]} {
	set wire_widths($sig_name) [expr [expr $idx_high] + 1]
    } elseif {[regexp {^\s*wire\s+(\w+)\s*;\s*$} $line -> sig_name]} {
	set wire_widths($sig_name) 1
    }

    if {$mem_conns == 0} {
	continue
    }

    set go 0
    if {[regexp {^\s*//(\S+)\s*$} $line -> path]} {
	puts "Info: Parsing pins for $path"
    } elseif {[regexp {^\s*assign\s+(\S+)\s*=\s*(\S+?Q[A|B])\s*;\s*$} $line -> top_sig hier_sig]} {
	set go 1
    } elseif {[regexp {^\s*assign\s+(\S+)\s*=\s*(\S+)\s*;\s*$} $line -> hier_sig top_sig]} {
	set go 1
    }

    if {$go == 0} {
	continue
    }

    for {set i 0} {$i < $wire_widths($top_sig)} {incr i} {
	if {$wire_widths($top_sig) == 1} {
	    set postfix ""
	} else {
	    set postfix "_$i"
	}

	#set hier_sig_p "[regsub -all {\.} $hier_sig "/"]$postfix"
	#set hier_net [get_db nets $hier_sig_p]
	set top_sig_p $top_sig$postfix
	set top_hnet [get_db hnets $top_sig_p]
	if {[regexp {Q[A|B]} $top_sig_p]} {
	    puts $bist_map_file "[get_db $top_hnet .name] [get_db $top_hnet .loads.name]"
	} else {
	    puts $bist_map_file "[get_db $top_hnet .name] [get_db $top_hnet .drivers.name]"
	}
	#set_db $top_hnet .dont_touch true
	#set_db $hier_net .dont_touch true
    }
}

close $bist_map_file
}
