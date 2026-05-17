tclmode
###########################################################################
# Written by Innovus
###########################################################################
# This LEC dofile script will run flat comparison to check the
# two netlists.
# To run it, you can start lec as ' lec -dofile (dofilescript) '
###########################################################################

# lib_files               A list of Liberty files (required)
set lib_files "/home/student/16/ex8/flow_matmul_sync_1/dbs/postroute.enc/libs/mmmc/slow_vdd1v0_basicCells.lib /home/student/16/ex8/flow_matmul_sync_1/dbs/postroute.enc/libs/mmmc/fast_vdd1v0_basicCells.lib"

#lef_files               A list of lef files
set lef_files [list /home/student/16/ex8/flow_matmul_sync_1/dbs/postroute.enc/libs/lef/gsclib045_tech.lef /home/student/16/ex8/flow_matmul_sync_1/dbs/postroute.enc/libs/lef/gsclib045_macro.lef]

# golden_verilog_files    A list of golden Verilog files (required)
set golden_verilog_files "/home/student/16/ex8/flow_matmul_sync_1/dbs/syn_opt.cdb/cmn/matmul_sync.v.gz"

# revised_verilog_files   A list of revised Verilog files (required)
set revised_verilog_files "fv/matmul_sync/opt_signoff/matmul_sync.revised.v.gz"

#mapping_file             Mapping file (required)
set mapping_file "fv/matmul_sync/opt_signoff/matmul_sync.map.mp"


########################################################################
# Sets up the log file and instructs the tool to display usage and other
# information.
##########################################################################
set_log_file logs/lec.opt_signoff.log -replace

info hostname
date
usage -auto -elapse

#########################################################################
# Change 'exit' to 'ON' to stop the script execution but not exit the tool.

set_dofile_abort exit

set_undefined_cell Black_box -noascend
set_rule_handling -limit 1000 *

##########################################################################
# READ LIBRARY
# library and design files
##########################################################################

read_lef_file -both $lef_files
read_library -liberty -replace -both $lib_files

read_design -verilog -replace -golden $golden_verilog_files
read_design -verilog -replace -revised $revised_verilog_files

##########################################################################
# GENERATE REPORTS
# design data, black boxes, floating signals and environment setup
##########################################################################

report_design_data
report_black_box -detail
report_floating_signals
report_environment

###########################################################################
# Specify user constraints
# add_pin_constraints (0/1) {primary_pin} -golden/revised
# add_ignored_outputs {primary_pin} -golden/revised

###########################################################################
# Specify renaming rules
# add_renaming_rule (rulename) (match-string) (substitution-string) [-golden |-revised |-both]

###########################################################################
# Change the number of threads to enable multithreading
set_parallel_option -threads 4 -norelease_license

############################################################################
# Enable auto analysis to help resolve issues due to sequential
# redundancy, sequential constant, clock gating, or sequential merging
# This option will automatically enable 'analyze abort -compare'
# to solve the aborts. 

set_analyze_option -auto -report_map -mapping_file $mapping_file
set_mapping_method -search_in_mapping_file

############################################################################
# Specify the modeling directives for constant opimization and clock gating.
set_flatten_model -seq_constant
set_flatten_model -gated_clock

############################################################################
#DFT constraints passed by Genus in the write_lec_dft_constraints design attribute

add_pin_constraints 0 scan_mode_matmul_sync -both
add_pin_constraints 0 scan_enable_matmul_sync -both


# Warning : Multiple pin constraints are added to the golden and revised designs.
#           There is a possibility that some valid functional modes
#           could be excluded from the formal verification process.
#           Please double check and make sure these pin constraints are all
#           expected and appropriate.

source fv/matmul_sync/opt_signoff/lec.opt_signoff.pre_compare

############################################################################
# FLATTEN, REMODEL AND MAP THE DESIGNS
set_system_mode lec

############################################################################
# GENERATE REPORTS
# mapped and unmapped key points
############################################################################

report_mapped_points -summary
report_unmapped_points -notmapped

############################################################################
# COMPARE DESIGNS
############################################################################

add_compared_points -all
compare

############################################################################
# GENERATE REPORTS
# compare data, mapped key points and verification information
############################################################################

report_compare_data -class nonequivalent -class abort -class notcompared
report_verification

report_statistics
puts "No of compare points = [get_compare_points -count]"
puts "No of diff points    = [get_compare_points -NONequivalent -count]"
puts "No of abort points   = [get_compare_points -abort -count]"
puts "No of unknown points = [get_compare_points -unknown -count]"
if {[get_compare_points -count] == 0} {
    puts "---------------------------------"
    puts "ERROR: No compare points detected"
    puts "---------------------------------"
}
if {[get_compare_points -NONequivalent -count] > 0} {
    puts "------------------------------------"
    puts "ERROR: Different Key Points detected"
    puts "------------------------------------"
}
if {[get_compare_points -abort -count] > 0} {
    puts "-----------------------------"
    puts "ERROR: Abort Points detected "
    puts "-----------------------------"
}
if {[get_compare_points -unknown -count] > 0} {
    puts "----------------------------------"
    puts "ERROR: Unknown Key Points detected"
    puts "----------------------------------"
}

exit
