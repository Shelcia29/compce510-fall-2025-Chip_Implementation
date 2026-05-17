#!/usr/bin/bash

# Make script stop if any glob doesn't match
shopt -s failglob

if [[ -z ${MODULE_NAME} ]]; then
    echo "Error: MODULE_NAME is not set"
    echo "use: setenv MODULE_NAME <your toplevel name>"
    exit
fi

# Formal verification

# 1st RTL to syn_map
echo "Adding exit to file " fv/*/lec.syn_map.do
if [[ $# > 1 ]]; then
    echo "More than 1 matches for lec.syn_map.do -files, check your directories"
    exit
fi
echo -e "\nexit -f\n" >> fv/*/lec.syn_map.do

echo -e "\nRunning syn_map LEC"
lec -XL -nogui fv/*/lec.syn_map.do &> /dev/null &

# 2nd syn_map to syn_opt
echo -e "\nRunning syn_opt LEC with " fv/*/lec.syn_opt.do
if [[ $# > 1 ]]; then
    echo "More than 1 matches for lec.syn_opt.do -files, check your directories"
    exit
fi
lec -XL -nogui fv/*/lec.syn_opt.do &> /dev/null &


# 3rd lvs to opt_signoff
echo -e "\nRunning LVS LEC with " fv/*/opt_signoff/lec.lvs.opt_signoff.do
if [[ $# > 1 ]]; then
    echo "More than 1 matches for lec.lvs.opt_signoff.do -files, check your directories"
    exit
fi
lec -XL -lp -nogui fv/*/opt_signoff/lec.lvs.opt_signoff.do &> /dev/null &

# ATPG & simulation
cd atpg

# Modify simulation vectors from parallel to serial
echo -e "\nModifying runmodus.atpg.tcl"
sed -i.orig 's/scanformat\s*parallel/scanformat serial/g' runmodus.atpg.tcl
sed -i 's/FULLSCAN /FULLSCAN_INTERNAL /g' runmodus.atpg.tcl
sed -i "s|${MODULE_NAME}\.test_netlist\.v|\.\./dbs/opt_signoff/${MODULE_NAME}\.v\.gz|g" runmodus.atpg.tcl

echo -e "\nLaunching modus"
modus -files runmodus.atpg.tcl

# 1st simulation without SDF
echo -e "\nModifying run_fullscan_sim"
sed -i.orig 's/FULLSCAN/FULLSCAN_INTERNAL/g' run_fullscan_sim
sed -i "s|${MODULE_NAME}\.test_netlist\.v|\.\./dbs/opt_signoff/${MODULE_NAME}\.v\.gz|g" run_fullscan_sim
echo "Running 1st simulation without SDF"
./run_fullscan_sim &> /dev/null &

# 2nd simulation with SDF
echo -e "\nCompiling SDF"
xmsdfc ../dbs/opt_signoff.sta/${MODULE_NAME}.verilog.sdf.gz -output ${MODULE_NAME}.verilog.sdf.gz.X

echo -e "\nCreating sdf_min.cmd"
echo "COMPILED_SDF_FILE = \"${MODULE_NAME}.verilog.sdf.gz.X\"," > sdf_min.cmd
echo "SCOPE = \"atpg_FULLSCAN_INTERNAL_${MODULE_NAME}_atpg.${MODULE_NAME}_inst\"," >> sdf_min.cmd
echo "MTM_CONTROL = \"MINIMUM\";" >> sdf_min.cmd

echo -e "\nCreating sdf_max.cmd"
echo "COMPILED_SDF_FILE = \"${MODULE_NAME}.verilog.sdf.gz.X\"," > sdf_max.cmd
echo "SCOPE = \"atpg_FULLSCAN_INTERNAL_${MODULE_NAME}_atpg.${MODULE_NAME}_inst\"," >> sdf_max.cmd
echo "MTM_CONTROL = \"MAXIMUM\";" >> sdf_max.cmd

echo -e "\nCopying run_fullscan_sim_sdf to run_fullscan_min_sim_sdf"
cp run_fullscan_sim_sdf run_fullscan_min_sim_sdf
echo -e "\nCopying run_fullscan_sim_sdf to run_fullscan_max_sim_sdf"
cp run_fullscan_sim_sdf run_fullscan_max_sim_sdf

echo -e "\nModifying run_fullscan_min_sim_sdf"
sed -i.orig "s|+sdf_file+DEFAULT\.sdf|-sdf_cmd_file sdf_min.cmd|g" run_fullscan_min_sim_sdf
sed -i 's/+define+TIMING/+define+NTC \\\n\t+define+RECREM \\\n\t-negdelay \\\n\t-sdfstats unannotated_paths_min\.rpt \\\n\t-ntc_level 3 \\\n\t-caint \\\n\t-nowarn NTCDMIN/g' run_fullscan_min_sim_sdf
sed -i 's/VER\.FULLSCAN_TIMED/VER\.FULLSCAN_INTERNAL/g' run_fullscan_min_sim_sdf
sed -i 's/FULLSCAN_TIMED\.log/FULLSCAN_INTERNAL_SDF_MIN\.log/g' run_fullscan_min_sim_sdf
sed -i "s|${MODULE_NAME}\.test_netlist\.v|\.\./dbs/opt_signoff/${MODULE_NAME}\.v\.gz|g" run_fullscan_min_sim_sdf
echo "Running 2nd simulation with SDF MIN"
./run_fullscan_min_sim_sdf &> /dev/null &

echo -e "\nModifying run_fullscan_max_sim_sdf"
sed -i.orig "s|+sdf_file+DEFAULT\.sdf|-sdf_cmd_file sdf_max.cmd|g" run_fullscan_max_sim_sdf
sed -i 's/+define+TIMING/+define+NTC \\\n\t+define+RECREM \\\n\t-negdelay \\\n\t-sdfstats unannotated_paths_max\.rpt \\\n\t-ntc_level 3 \\\n\t-caint \\\n\t-nowarn NTCDMIN/g' run_fullscan_max_sim_sdf
sed -i 's/VER\.FULLSCAN_TIMED/VER\.FULLSCAN_INTERNAL/g' run_fullscan_max_sim_sdf
sed -i 's/FULLSCAN_TIMED\.log/FULLSCAN_INTERNAL_SDF_MAX\.log/g' run_fullscan_max_sim_sdf
sed -i "s|${MODULE_NAME}\.test_netlist\.v|\.\./dbs/opt_signoff/${MODULE_NAME}\.v\.gz|g" run_fullscan_max_sim_sdf
echo "Running 2nd simulation with SDF MAX"
./run_fullscan_max_sim_sdf &> /dev/null &

cd ..

