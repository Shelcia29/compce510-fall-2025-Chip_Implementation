#!/usr/bin/bash

tail -200 logs/lec.syn_map.log
echo "LEC SYN_MAP"
read -n 1 k <&1

tail -200 logs/lec.syn_opt.log
echo "LEC SYN_OPT"
read -n 1 k <&1

tail -200 logs/lec.floorplan.log
echo "LEC FLOORPLAN"
read -n 1 k <&1

tail -200 logs/lec.opt_signoff.log
echo "LEC OPT_SIGNOFF"
read -n 1 k <&1

tail -200 logs/lec.lvs.opt_signoff.log
echo "LEC LVS"
read -n 1 k <&1
