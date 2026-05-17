#######################################################################################################################
# Input clocks
########################################################################################################################
set clock_names [list clk_i]
set clock_ports(clk_i)    "clk_i"

#######################################################################################################################
# Reset port/pin names
########################################################################################################################
set reset_ports_list [list rst_ni]

########################################################################################################################
# Common info
########################################################################################################################
set input_clock_ports_list ""
foreach clock_name $clock_names {
    lappend input_clock_ports_list $clock_ports($clock_name)
}

########################################################################################################################
# Clock periods
########################################################################################################################
set clk_100_period 10.000
foreach clock_name $clock_names {
    set clock_periods($clock_name) ${clk_100_period}
}

########################################################################################################################
# Clock creation
########################################################################################################################
foreach clock_name $clock_names {
    create_clock -name $clock_name -period $clock_periods($clock_name) $clock_ports($clock_name) -add
    create_clock -name ${clock_name}_virtual -period $clock_periods($clock_name)
}

########################################################################################################################
# Clock uncertainties
########################################################################################################################
set clk_setup_uncert           0.205
set clk_hold_uncertainty       0.040

foreach clock_name $clock_names {
    set_clock_uncertainty -setup $clk_setup_uncert [get_clocks $clock_name]
    set_clock_uncertainty -setup $clk_setup_uncert [get_clocks ${clock_name}_virtual]
    set_clock_uncertainty -setup $clk_setup_uncert -from [get_clocks ${clock_name}_virtual] -to   [get_clocks $clock_name]
    set_clock_uncertainty -setup $clk_setup_uncert -to   [get_clocks ${clock_name}_virtual] -from [get_clocks $clock_name]
    set_clock_uncertainty -hold  $clk_hold_uncertainty [get_clocks $clock_name]
    set_clock_uncertainty -hold  $clk_hold_uncertainty [get_clocks ${clock_name}_virtual]
}

# --------------------------------------------------------------
# Clock duty cycle distortion
# --------------------------------------------------------------
set dsd 0.050
foreach clock_name $clock_names {
    set_clock_latency -source -fall -early \
        [expr {[expr 0.0-$dsd] * $clock_periods($clock_name)}] \
        [get_clocks $clock_name]

    set_clock_latency -source -fall -late \
        [expr {[expr 0.0+$dsd] * $clock_periods($clock_name)}] \
        [get_clocks $clock_name]
}

#######################################################################################################################
# Inputs and output constraints
#######################################################################################################################

# scan in / scan out
# Input ports
set_input_delay  [expr ($clock_periods(clk_i) * 0.85)] -clock clk_i_virtual -add_delay [get_ports "scan_in*"]
# Output ports
set_output_delay [expr ($clock_periods(clk_i) * 0.85)] -clock_fall -clock clk_i_virtual -add_delay [get_ports "scan_out*"]

# func ports
set_input_delay 1.0 -clock clk_i_virtual -add_delay [get_ports * -filter "direction==in && full_name != clk_i && full_name != *scan_in*"]
set_output_delay 1.0 -clock clk_i_virtual -add_delay [get_ports * -filter "direction==out && full_name != *scan_out*"]

#######################################################################################################################
# Exceptions
#######################################################################################################################

set_case_analysis 0  [get_ports "scan_enable*"]
set_case_analysis 1  [get_ports "scan_mode*"]
