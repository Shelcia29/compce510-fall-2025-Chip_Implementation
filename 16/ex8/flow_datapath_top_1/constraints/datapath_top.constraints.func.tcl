#

set clock_names [list clk_i]

set clock_ports(clk_i) "clk_i"

set reset_ports_list [list rst_ni]

#set all_memories [get_cells -hierarchical -filter "(ref_name =~ TS5*) && is_hierarchical == false"]

set input_clock_ports_list ""
foreach clock_name $clock_names {
    lappend input_clock_ports_list $clock_ports($clock_name)
}

set clk_66_period 15.150    ;
set clk_80_period 12.500    ;
set clk_100_period 10.000    ;
set clk_125_period 8.000    ;
set clk_250_period 4.000    ;
set clk_333_period 3.000    ;
set clk_500_period 2.000    ;
set clk_666_period 1.501    ;
set clk_1000_period 1.000    ;
set clk_1500_period 0.660    ;
set clk_2000_period 0.500    ;

set clock_periods(clk_i) ${clk_250_period}

foreach clock_name $clock_names {
    create_clock -name $clock_name -period $clock_periods($clock_name) $clock_ports($clock_name) -add
    create_clock -name ${clock_name}_virtual -period $clock_periods($clock_name)
}

set clk_setup_uncert           0.055
set clk_hold_uncertainty       0.040

foreach clock_name $clock_names {
    set_clock_uncertainty -setup $clk_setup_uncert [get_clocks $clock_name]
    set_clock_uncertainty -setup $clk_setup_uncert [get_clocks ${clock_name}_virtual]
    set_clock_uncertainty -setup $clk_setup_uncert -from [get_clocks ${clock_name}_virtual] -to   [get_clocks $clock_name]
    set_clock_uncertainty -setup $clk_setup_uncert -to   [get_clocks ${clock_name}_virtual] -from [get_clocks $clock_name]
    set_clock_uncertainty -hold  $clk_hold_uncertainty [get_clocks $clock_name]
    set_clock_uncertainty -hold  $clk_hold_uncertainty [get_clocks ${clock_name}_virtual]
}

# DSD
foreach clock_name $clock_names {
    # PLL output clock +-2%
    set dsd 0.020

    set_clock_latency -source -fall -early \
        [expr {[expr 0.0-$dsd] * $clock_periods($clock_name)}] \
        [get_clocks $clock_name]

    set_clock_latency -source -fall -late \
        [expr {[expr 0.0+$dsd] * $clock_periods($clock_name)}] \
        [get_clocks $clock_name]
}

#----------------------------------------------------------------------------
# generated clocks
#----------------------------------------------------------------------------
create_generated_clock -name clk_div \
    -source [get_pins i_clk_divider/inst_SDFFRX4/CK] \
    -divide_by 2 \
    -master_clock [get_clocks clk_i] \
    -add \
    i_clk_divider/inst_SDFFRX4/Q

    
# clock groups
set_clock_groups -name all_clocks -asynchronous \
    -group [get_clocks "clk_div"] \
    -group [get_clocks "clk_i clk_i_virtual"]

#----------------------------------------------------------------------------
# constraints in nanoseconds
#----------------------------------------------------------------------------
set clock_name "clk_i"
set tight_core_input_setup [expr $clock_periods($clock_name) * 0.7]
set tight_core_output_setup [expr $clock_periods($clock_name) * 0.7]
set relaxed_core_input_setup [expr $clock_periods($clock_name) * 0.3]
set relaxed_core_output_setup [expr $clock_periods($clock_name) * 0.3]
set tight_core_input_hold [expr $clock_periods($clock_name) * 0.1]
set tight_core_output_hold [expr $clock_periods($clock_name) * 0.1]
set relaxed_core_input_hold [expr $clock_periods($clock_name) * 0.3]
set relaxed_core_output_hold [expr $clock_periods($clock_name) * 0.3]

# Reset constraints
set_input_delay  [expr $clock_periods($clock_name) * 0.7] -max -clock ${clock_name}_virtual [get_ports rst_ni]
set_input_delay  [expr $clock_periods($clock_name) * 0.7] -min -clock ${clock_name}_virtual [get_ports rst_ni] -add
set_multicycle_path 2 -setup -from [get_ports rst_ni]
set_multicycle_path 1 -hold -from [get_ports rst_ni]

# Input ports
set_input_delay  $tight_core_input_setup  -max -clock clk_div [get_ports * -filter "direction==in && full_name =~*data*"]
set_input_delay  $relaxed_core_input_hold -min -clock clk_div [get_ports * -filter "direction==in && full_name =~*data*"] -add
set_input_delay  $tight_core_input_setup  -max -clock ${clock_name}_virtual [get_ports * -filter "direction==in && full_name !~*data* && full_name !~*clk* && full_name !~*rst*"]
set_input_delay  $relaxed_core_input_hold -min -clock ${clock_name}_virtual [get_ports * -filter "direction==in && full_name !~*data* && full_name !~*clk* && full_name !~*rst*"] -add
# Output ports
set_output_delay $relaxed_core_output_setup -max -clock clk_div [get_ports * -filter "direction==out && full_name =~*result*"]
set_output_delay $relaxed_core_output_hold  -min -clock clk_div [get_ports * -filter "direction==out && full_name =~*result*"] -add
