# =============================================================================
# Timing constraint
# =============================================================================
# Clock freq: 100 MHz = 10ns
set Tclk 10
set clk_port "clk"
set rst_net "reset"
set inout_port ""

#---------------------------------------------------------------------------
# Max capacitance on input & output port nets
#---------------------------------------------------------------------------
set max_cap_limit 0.05
set_max_capacitance $max_cap_limit [get_ports *]

create_clock -name ideal_clk -period $Tclk [get_ports $clk_port]
set_clock_uncertainty   -setup 0.1  [get_clocks {ideal_clk}]
set_clock_uncertainty   -hold 0.1 [get_clocks {ideal_clk}]
set_clock_transition    -rise -max 0.1 [get_clocks {ideal_clk}]
set_clock_transition    -fall -max 0.1 [get_clocks {ideal_clk}]



# ideal networks
# do not optimize clk network
set_ideal_network [get_ports $clk_port]
set_dont_touch_network [get_ports $clk_port]



set_input_delay -max [expr $Tclk*0.7] -clock ideal_clk [remove_from_collection [all_inputs] [get_ports $clk_port]]
set_output_delay -max [expr $Tclk*0.7] -clock ideal_clk [all_outputs]

# =============================================================================
# Enviornement attribute constraint
# =============================================================================


set_max_fanout 10 [current_design]
#---------------------------------------------------------------------------
# Output loads
#---------------------------------------------------------------------------
set lmax 0.100  ; # Default maximum output load (pF)
set lmin 0.001  ; # Default minimum output load (pF)

set_load -max $lmax [all_outputs]
set_load -min $lmin [all_outputs]



set_max_transition 0.1 [all_inputs]




