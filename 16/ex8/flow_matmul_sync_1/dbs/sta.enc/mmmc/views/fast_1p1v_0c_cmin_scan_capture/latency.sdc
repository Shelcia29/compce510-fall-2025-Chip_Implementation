set_clock_latency -source -early -min -fall -0.5 [get_clocks {clk_i}]
set_clock_latency -source -early -max -fall -0.5 [get_clocks {clk_i}]
set_clock_latency -source -late -min -fall 0.5 [get_clocks {clk_i}]
set_clock_latency -source -late -max -fall 0.5 [get_clocks {clk_i}]
