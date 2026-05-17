add_search_path . /opt/soc/eda/cadence/DDI231/GENUS231/tools.lnx86/lib/tech -library -both
read_library -liberty -both \
    /home/student/16/ex8/flow_datapath_top_1/../flow_matmul_sync_1/models/floorplan/matmul_sync.slow_0p9v_125c_cmax.lib \
    /home/student/16/ex8/flow_datapath_top_1/models/IN22FDX_S1DU_BFUG_W00256B032M04C128.slow_0p9v_125c_cmax_func.lib \
    /opt/soc/tech/GPDK045/gsclib045/timing/slow_vdd1v0_basicCells.lib

