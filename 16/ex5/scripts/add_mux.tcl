
set sel scan_enable_[get_db flow_vars_design_name]

set fixpin i_rst_sync2/inst_SDFFRX4/Q
add_user_test_point \
    -cell [get_db lib_cells */MX2X4] \
    -name scan_rst_mux_1 \
    -location [get_db pins $fixpin] \
    -cfi A -cfo Y -connect {B rst_ni} -connect [list S0 $sel]

set sel scan_mode_[get_db flow_vars_design_name]

set fixpin i_clk_divider/inst_SDFFRX4/Q
add_user_test_point \
    -cell [get_db lib_cells */MX2X4] \
    -name scan_clk_mux_1 \
    -location [get_db pins $fixpin] \
    -cfi A -cfo Y -connect {B clk_i} -connect [list S0 $sel]
