##############################################################################
# STEP genus_to_modus
##############################################################################
create_flow_step -name genus_to_modus -owner flow {
}

############################################################################
# STEP write_sdf
############################################################################
create_flow_step -name write_sdf -owner tuni {
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    if {![file exists $out_dir]} {
        file mkdir $out_dir
    }

    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application sta     -gate_level_sim_model ${out_dir}/[get_db current_design .name].gatesim.sta.sdf.gz
    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application verilog -gate_level_sim_model ${out_dir}/[get_db current_design .name].gatesim.verilog.sdf.gz
    #write_sdf -recompute_parallel_arcs -delimiter "." -voltage 0.99:0.9:0.81 -temperature 125.0:25.0:-40.0 -process best:worst -target_application sta     ${out_dir}/[get_db current_design .name].sta.sdf.gz
    write_sdf -recompute_parallel_arcs -delimiter "." -voltage 1.1:1.0:0.9 -temperature 125.0:25.0:-0.0 -process best:worst -target_application verilog ${out_dir}/[get_db current_design .name].verilog.sdf.gz

}
