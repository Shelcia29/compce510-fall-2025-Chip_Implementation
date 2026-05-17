# Chip Design, Ex#2; constraints for func-mode template file
# Author: Tero Lehtinen

# 1.
# Give meaningful names for clocks
# If no other reason exists, clock name should be exactly the same as port name (NOT like the example given here)
set clock_names [list clk_i]

# 2.
# Map clock names to actual clock ports
set clock_ports(clk_i) clk_i

# 3.
# Set type of clock.
# It can be either:
# External: clock is fed into the chip via a regular IO-cell, this causes a lot of uncertainty.
# Oscillator: clock is coming from an external oscillator via a specialized clock input cell. Uncertainty is minimal.
# Internal: clock is generated inside of the chip. Uncertainty is low.
set clock_types(clk_i)    internal

# List of clock periods in nanoseconds for certain frequencies.
# Do not modify these.
set clk_66_period 15.150    ;
set clk_80_period 12.500    ;
set clk_100_period 10.000    ;
set clk_125_period 8.000    ;
set clk_500_period 2.000    ;
set clk_666_period 1.501    ;
set clk_1000_period 1.000    ;
set clk_1500_period 0.660    ;
set clk_2000_period 0.500    ;

# 4.
# Map period to each clock
set clock_periods(clk_i) 5

# 5.
# Create the actual clocks in the tool.
# Command for clock creation is "create_clock"
# See: "man create_clock"
# Note: You need to create two clock objects for each real clock:
#       create_clock foo1
#       create_clock foo1_virtual
#       The "_virtual" -clock is used for IO constraining
#       For the "regular" (not _virtual) -clock define:
#       a. name
#       b. period
#       c. port
#       d. "-add" -attribute (why is this needed?)
#       And for the "_virtual" -clock only name and period are needed
foreach clock_name [array names clock_ports] {
    create_clock -name clk_i -period 5 clk_i -add
    create_clock -name clk_i_virtual -period 5
}

# Procedure to calculate clock uncertainty.
# Do not modify.
proc calc_uncertainty {period clock_type} {

    # clock_types: internal/external
    if {$clock_type eq "external"} {
        # Large jitter for external clocks!
        # Jitter = 6% of clock period
        set jitter [expr {0.06 * $period}]
    } elseif {$clock_type eq "oscillator"} {
        # Small jitter for external oscillator (50ps) (+20ps of implementation uncert)
	set jitter [expr 0.050 + 0.020]
    } else {
	# Jitter = 1.5% * clock period + 50ps + 20ps of implementation uncert
	set jitter [expr {0.015 * $period + 0.050 + 0.020}]
     }
    
    # on top of jitter, we add wire and cell uncertainties in mmmc setup
    return $jitter
}

# 6.
# Define clock clock uncertainties for setup & hold
# Clock uncertainty is defined either -from/-to between different clock objects
# or inside of a single clock object
# hold uncertainty value is 20ps, do not modify. This is "additional" hold uncertainty. "real" uncertainty is most likely
# already added into standard cell library timing information
set clk_hold_uncertainty 0.020
foreach clock_name [array names clock_ports] {
    set uncert [expr [calc_uncertainty $clock_periods($clock_name) $clock_types($clock_name)]/1000]
    puts "Setting clock uncertainty for $clock_name (period: $clock_periods($clock_name), clock_type: $clock_types($clock_name)) to $uncert"

    set_clock_uncertainty -setup \
        $uncert \
        [get_clocks $clock_name]

    set_clock_uncertainty -setup \
        $uncert \
        [get_clocks ${clock_name}_virtual]

    set_clock_uncertainty -setup \
        $uncert \
	-from [get_clocks $clock_name] \
	-to [get_clocks $clock_name]
    
    set_clock_uncertainty -setup \
        $uncert \
	-from [get_clocks $clock_name] \
	-to [get_clocks $clock_name]

    set_clock_uncertainty -hold \
        $uncert \
        [get_clocks $clock_name]

    set_clock_uncertainty -hold \
        $uncert \
	-from [get_clocks $clock_name] \
	-to [get_clocks $clock_name]

    set_clock_uncertainty -hold \
        $uncert \
	-from [get_clocks $clock_name] \
	-to [get_clocks $clock_name]

}

# DSD (duty-cycle distortion)
# this is modeled by shifting falling edge of clock +- some value
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

# 7.
# clock groups
# Just fill in the names of your clocks
set_clock_groups -name all_clocks -asynchronous \
    -group [get_clocks "clk_i clk_i_virtual"]

#----------------------------------------------------------------------------
# Only one clock in design, so use a variable to make code more readable
#----------------------------------------------------------------------------
set clock_name [lindex [array names clock_ports] 0]
    
#----------------------------------------------------------------------------
# IO constraints
#----------------------------------------------------------------------------
# 8.
# Give values for tight and relaxed constraints relative to clock period
set tight_core_input_setup [expr $clock_periods($clock_name) * 0.7]
set tight_core_output_setup [expr $clock_periods($clock_name) * 0.7]
set relaxed_core_input_setup [expr $clock_periods($clock_name) * 0.3]
set relaxed_core_output_setup [expr $clock_periods($clock_name) * 0.3]
set tight_core_input_hold [expr $clock_periods($clock_name) * 0.1]
set tight_core_output_hold [expr $clock_periods($clock_name) * 0.1]
set relaxed_core_input_hold [expr $clock_periods($clock_name) * 0.3]
set relaxed_core_output_hold [expr $clock_periods($clock_name) * 0.3]

# 9.
# Reset-port needs a special constraint. Many times if reset would be handled the same way as other functional signals
# then the design would not meet timing requirements on high speed clock domains. Why?
# Give an input delay constraint for your reset-port and add a multicycle-path to it.
# Hint: "man set_input_delay" & "man set_multicycle_path".
# Why is it ok to add a multicycle path for reset? Can it be added to any signal which does not meet timing?
set_input_delay $tight_core_input_setup -max  -clock clk_i_virtual rst_ni
# Note: Library issue. Skip adding a multicycle exception to reset
#set_multicycle_path <multicycle value for setup analysis?> -setup -from <reset portname?>
#set_multicycle_path <multicycle value for hold analysis?> -hold -from <reset portname?>

# 10.
# Constrain all input port for both setup & hold analysis
# Again: "man set_input_delay"
# Hint: SDC command to get all input ports except clock ports and reset ports:
# get_ports * -filter "direction==in && full_name != <clock portname?> && full_name != <reset portname?>"
# Note, you need the "-add" -attribute if you have previously set a constraint for a port and you want to add another one.
# Without "-add" -attribute the earlier constrain will be overwritten
# Input ports
get_ports * -filter "direction==in && full_name != clk_i && full_name != rst_ni"
set_input_delay $tight_core_input_setup -min -clock clk_i_virtual [get_ports * -filter "direction==in && full_name != clk_i && full_name != rst_ni"]
set_input_delay $tight_core_input_hold -max -clock clk_i_virtual [get_ports * -filter "direction==in && full_name != clk_i && full_name != rst_ni"]
                                                                        				 
# Output ports	
set_output_delay $relaxed_core_output_setup -min -clock clk_i_virtual [get_ports * -filter "direction==out && full_name != clk_i && full_name != rst_ni"]
set_output_delay $relaxed_core_output_hold -max -clock clk_i_virtual [get_ports * -filter "direction==out && full_name != clk_i && full_name != rst_ni"]


