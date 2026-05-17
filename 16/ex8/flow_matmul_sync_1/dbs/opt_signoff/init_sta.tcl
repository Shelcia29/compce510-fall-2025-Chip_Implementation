read_mmmc [get_db flow_source_directory]/mmmc_config.tcl
set netlist_list [list \
dbs/opt_signoff/matmul_sync.v.gz \
]

# All subsystems need to be defined in local_macro_setup!
foreach {blockname blockpath} [array get local_macro_exportdir] {
    lappend netlist_list ${blockpath}/dbs/opt_signoff/${blockname}.v.gz
}

read_netlist "${netlist_list}"
set STA_SIGNOFF 1
init_design
read_power_intent -1801 /home/student/16/ex8/flow_matmul_sync_1/constraints/matmul_sync.upf
commit_power_intent -verbose
set_db flow_report_name opt_signoff
read_activity_file -format TCF dbs/syn_opt/matmul_sync.tcf
