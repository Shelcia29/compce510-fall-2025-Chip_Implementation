
# Scan mode disabled

set_case_analysis 0  [get_ports "scan_enable*"]
set_case_analysis 0  [get_ports "scan_mode*"]

set_false_path -to   [get_ports "scan_out*"]
set_false_path -from [get_ports "scan_in*"]
