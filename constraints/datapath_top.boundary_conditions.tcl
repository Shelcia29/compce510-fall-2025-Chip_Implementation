# boundary constraints
#---------------------------------------------------------------------------
# Max capacitance on input & output port nets
#---------------------------------------------------------------------------
set max_cap_limit 0.005
set_max_capacitance $max_cap_limit [get_ports *]

#---------------------------------------------------------------------------
# Driving cell
#---------------------------------------------------------------------------
# 20ps fast transition
set in_trans_min 0.020
# limit for data transition is 250ps
set in_trans_max_data 0.250
# limit for clock transition is 150ps
set in_trans_max_clock 0.150
set_driving_cell -min -lib_cell CLKINVX4   -from_pin A -pin Y     [get_ports * -filter {direction==in && full_name!=clk_i}] -input_transition_fall $in_trans_min -input_transition_rise $in_trans_min
set_driving_cell -max -lib_cell CLKINVX4    -from_pin A -pin Y     [get_ports * -filter {direction==in && full_name!=clk_i}] -input_transition_fall $in_trans_max_data -input_transition_rise $in_trans_max_data
set_driving_cell -min -lib_cell CLKINVX4    -from_pin A -pin Y     [get_ports clk_i] -input_transition_fall $in_trans_min -input_transition_rise $in_trans_min
set_driving_cell -max -lib_cell CLKINVX4    -from_pin A -pin Y     [get_ports clk_i] -input_transition_fall $in_trans_max_clock -input_transition_rise $in_trans_max_clock

#---------------------------------------------------------------------------
# Max transitions
#---------------------------------------------------------------------------
set_max_transition $in_trans_max_data [current_design]
set_max_fanout 32 [current_design]

# Tighter max transition (45ps) for output ports
set output_trans_max_data 0.045
set_max_transition $output_trans_max_data [all_outputs]

#---------------------------------------------------------------------------
# Output loads
#---------------------------------------------------------------------------
set lmax 0.010  ; # Default maximum output load (pF)
set lmin 0.001  ; # Default minimum output load (pF)

set_load -max $lmax [all_outputs]
set_load -min $lmin [all_outputs]
