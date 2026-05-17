################################################################################
# Time-stamp: <2025-07-24 23:16:30 qftele>

# report macros after elaboration to see if linking is ok
puts "\nInfo: All macros in design:"
get_db insts -if {.is_macro==true} -foreach {puts [get_db $object .name]}
puts "\n"


# print memories into a text file (/reports folder)
set fp [open [get_db flow_report_directory]/[get_db flow_vars_design_name].memories.txt w]
if {[llength [get_db insts -if {.is_memory}]] > 0} {
    get_db insts -if {.is_memory} -foreach {puts $fp "[get_db $object .name] : [get_db $object .base_cell.name]"}
} else {
    puts $fp "no memories found"
}

close $fp

check_design -multiple_driver -unresolved -undriven > [get_db flow_report_directory]/elaboration/check_design_fatal.txt

break
