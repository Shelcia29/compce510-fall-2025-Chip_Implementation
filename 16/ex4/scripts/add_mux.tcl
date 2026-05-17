#

add_user_test_point -location i_clk_divider/inst_SDFFRX4/Q -cell CLKMX2X4  -cfi A -cfo Y  -connect {B clk_i} -connect {S0 scan_mode_datapath_top} -name fix_clk

add_user_test_point -location i_rst_sync2/inst_SDFFRX4/Q -cell CLKMX2X4  -cfi A -cfo Y  -connect {B rst_ni} -connect {S0 scan_mode_datapath_top} -name fix_rst



