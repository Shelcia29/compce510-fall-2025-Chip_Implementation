# Flowkit v19.10-s008_1
# Time-stamp: <2025-09-02 10:04:59 qftele>
#- genus_steps.tcl : defines Genus based flow_steps

#===========================================================================
# Flow: synth
#===========================================================================

##############################################################################
# STEP create_cost_group
##############################################################################
create_flow_step -name create_cost_group -owner cadence {
    #- Clear existing path_groups
    get_db cost_groups -if {.name != default} -foreach {delete_obj $object}
    
    #- Add basic path_groups
    set mems [get_cells -hierarchical -filter "@is_memory_cell"]
    set icgs [filter_collection [all_registers] "@is_integrated_clock_gating_cell"]
    set regs [remove_from_collection [all_registers -edge_triggered] $icgs]

    foreach mode [get_db constraint_modes -if {.is_setup}] {
        set_interactive_constraint_mode $mode
        group_path -name in2out -from [all_inputs] -to [all_outputs]
        if {[sizeof_collection [get_cells $regs]] > 0} {
            group_path -name in2reg -from [all_inputs] -to $regs
            group_path -name reg2out -from $regs -to [all_outputs]
            group_path -name reg2reg -from $regs -to $regs
        }
        if {[sizeof_collection [get_cells $mems]] > 0} {
            group_path -name mem2reg -from $mems -to $regs
            group_path -name reg2mem -from $regs -to $mems
            group_path -name mem2mem -from $mems -to $mems
        }
        if {[sizeof_collection [get_cells $icgs]] > 0} {
            group_path -name reg2icg -from $regs -to $icgs
        }
    }
}

##############################################################################
# STEP set_dont_touch
##############################################################################
create_flow_step -name set_dont_touch -owner cadence {

    # set default dont touch from project settings
    if {[file exists [get_db flow_source_directory]/set_dont_touch.tcl]} {
	puts "\nInfo: Sourcing [get_db flow_source_directory]/set_dont_touch.tcl"
	source [get_db flow_source_directory]/set_dont_touch.tcl
	puts "\n"
    }

    # override project dont touch settings and/or add own
    if {[file exists scripts/set_dont_touch.tcl]} {
	puts "\nInfo: Sourcing scripts/set_dont_touch.tcl"
	source scripts/set_dont_touch.tcl
	puts "\n"
    }

}

##############################################################################
# Genus ungrouping management
##############################################################################
create_flow_step -name genus_manage_ungrouping -exclude_time_metric -owner tuni {
    foreach dpo [get_db insts -if {.base_cell.class != ""}] {
	if {[get_db $dpo .parent.name] != [get_db flow_vars_design_name]} {
	    set exit_loop false
	} else {
	    set exit_loop true
	}
	while {!$exit_loop} {
	    set dpo [get_db $dpo .parent]
	    set_db $dpo .ungroup_ok false
	    if {[string first [string tolower [get_db flow_vars_design_name]] [string tolower [get_db $dpo .parent.name]]] == 0} {
		set exit_loop true
	    }
	}
    }
}

##############################################################################
# Genus preserve instantiated cells management
##############################################################################
create_flow_step -name genus_manage_preserve -exclude_time_metric -owner tuni {
    foreach dpo [get_db insts -if {.base_cell.class != block* && .base_cell.class != ""}] {
	set_db $dpo .preserve true
    }
}

##############################################################################
# Genus uniquify design
##############################################################################
create_flow_step -name genus_uniquify_design -exclude_time_metric -owner tuni {
    set_db ui_respects_preserve false
    uniquify [current_design] -verbose
    set_db ui_respects_preserve true
}

##############################################################################
# Edit post elaborate netlist
##############################################################################
create_flow_step -name edit_post_elaborate_netlist -exclude_time_metric -owner tuni {
    if {[file exists [get_db flow_vars_data_directory]/scripts/edit_post_elaborate_netlist.tcl]} {
        source [get_db flow_vars_data_directory]/scripts/edit_post_elaborate_netlist.tcl
    }
}

##############################################################################
# Genus manage derating
##############################################################################
create_flow_step -name genus_manage_derating -exclude_time_metric -owner tuni {
    # Enable native socv
    #phys_enable_ocv -native_socv -design [current_design]
    global mmmc_vars
    foreach dc [get_db [get_db delay_corners -if {.is_setup}] .name] {
	if {![info exists mmmc_vars(${dc},flat_data_cell_early)] ||
	    ![info exists mmmc_vars(${dc},flat_data_cell_late)] ||
	    ![info exists mmmc_vars(${dc},flat_clock_cell_early)] ||
	    ![info exists mmmc_vars(${dc},flat_clock_cell_late)] ||
	    ![info exists mmmc_vars(${dc},flat_data_net_early)] ||
	    ![info exists mmmc_vars(${dc},flat_data_net_late)] ||
	    ![info exists mmmc_vars(${dc},flat_clock_net_early)] ||
	    ![info exists mmmc_vars(${dc},flat_clock_net_late)]} {
	    puts "Fatal: mmmc_vars(${dc},flat_\[clock|data\]_\[cell|net\]_\[early|late\]) not defined! Check mmmc_setup.tcl!"
	    exit 1
	}
	# Cell OCV
	# Data
	set_timing_derate -data  -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},flat_data_cell_early)
	set_timing_derate -data  -cell_delay -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_data_cell_late)
	# Clock
	set_timing_derate -clock -cell_delay -early -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_cell_early)
	set_timing_derate -clock -cell_delay -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_cell_late)
	
	# Wire OCV
	# Data
	set_timing_derate -data  -net_delay  -early -delay_corner ${dc} $mmmc_vars(${dc},flat_data_net_early)
	set_timing_derate -data  -net_delay  -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_data_net_late)
	# Clock
	set_timing_derate -clock -net_delay  -early -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_net_early)
	set_timing_derate -clock -net_delay  -late  -delay_corner ${dc} $mmmc_vars(${dc},flat_clock_net_late)
    }
}

##############################################################################
# Additional genus_update_names 
##############################################################################
create_flow_step -name genus_update_names -owner tuni {
    #  update_names -suffix _front -module
    update_names -prefix [get_db flow_vars_design_name]_ -module
}

##############################################################################
# Pre syn_generic extra commands
##############################################################################
create_flow_step -name pre_syn_generic -owner tuni {
    # If we're not doing scan insertion, exclude all instantiated clock gates from "clock gating".
    # Otherwise Genus will add RC_CG_INST* hierarchy to instantiated clock gates
    # which can then i.e. mess up STA constraints later on
    if {![get_feature -feature add_scan]} {
	# go through all instantiated cgs
	foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
	    puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
	    # prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
	    # Note, TE has to be connected manually to shift enable later on!
	    set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
	}
    }
}

##############################################################################
# STEP run_syn_generic
##############################################################################
create_flow_step -name run_syn_generic -owner cadence {
  #- Synthesize to generic gates
  if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
    syn_generic -physical
  } else {
    syn_generic
  }
}

##############################################################################
# Pre syn_map extra commands
##############################################################################
create_flow_step -name pre_syn_map -owner tuni {
    clock_gating import -hierarchical -verbose
    # If we're not doing scan insertion, set all clock gates as controllable.
    # Otherwise check_dft_rules will mark flops driven by them with errors
    # and they will not b replaced by scan flops. This will give optimistic
    # area numbers when doing synthesis trials
    if {![get_feature -feature add_scan]} {
	# go through all instantiated cgs
	foreach icg_inst [get_db [get_db insts -if {.base_name==inst_CKLNQD*}] .name] {
	    puts "Info: ICG: $icg_inst ([get_db [get_db insts $icg_inst] .base_cell.base_name])"
	    set_db [get_db pins $icg_inst/Q] .dft_controllable "[get_db pins $icg_inst/CP] non_inverting"

	    # prevent Genus from adding RC_CG_INST* hierarchy to instantiated clock gates
	    # Note, TE has to be connected manually to shift enable later on!
	    set_db [get_db insts $icg_inst] .lp_clock_gating_exclude true
	}
	# go through all automatically inserted cgs
	foreach aicg_inst [get_db [get_db insts *RC_CGIC_INST] .name] {
	    if {[llength [get_db pins $aicg_inst/CP]]} {
		set_db [get_db pins $aicg_inst/Q] .dft_controllable "[get_db pins $aicg_inst/CP] non_inverting"
	    } elseif {[llength [get_db pins $aicg_inst/CPN]]} {
		set_db [get_db pins $aicg_inst/Q] .dft_controllable "[get_db pins $aicg_inst/CPN] non_inverting"
	    } else {
		puts "Error: No CP nor CPN pin on inst: $aicg_inst. Cannot set cell output as dft_controllable"
	    }
	}
    }
    check_dft_rules
}

##############################################################################
# STEP run_syn_map
##############################################################################
create_flow_step -name run_syn_map -owner cadence {
  #- Synthesize to target library gates
  if {[get_feature -feature synth_spatial] || [get_feature -feature synth_physical]} {
    syn_map -physical
  } else {
    syn_map
  }
}

##############################################################################
# STEP run_syn_opt
##############################################################################
create_flow_step -name run_syn_opt -owner cadence {
  #- Synthesize to optimized gates
  if {[get_feature -feature synth_spatial]} {
    syn_opt -spatial
  } elseif {[get_feature -feature synth_physical]} {
    syn_opt -physical
  } else {
    syn_opt
  }
}

############################################################################
# STEP genus_to_clp
############################################################################
create_flow_step -name genus_to_clp -owner flow {
    #- create output location
    set design  [get_db current_design .name]
    set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
    file mkdir $out_dir
    
    #- write dofile for CLP
    write_clp_script \
	-design $design \
        -files_1801 [get_db flow_vars_power_intent] \
	-netlist [file join $out_dir $design.v.gz] \
	-log_file [file join [get_db flow_log_directory] clp.[get_db flow_report_name].log] \
	-clp_out_report [file join [get_db flow_report_directory] [get_db flow_report_name] clp.rpt] \
	> [file join [get_db current_design .verification_directory]  clp.[get_db flow_report_name].do]
    
    #- schedule the CLP flow
    #FlowtoolPredictHint ArgumentRandomise -branch
    #schedule_flow \
#	-flow clp \
#	-branch [get_db flow_report_name] \
#	-no_db \
#	-no_sync \
#	-tool_options "-nogui -lp -verify -do [file join [get_db current_design .verification_directory]  clp.[get_db flow_report_name].do]"

}

############################################################################
# STEP genus_to_lec
############################################################################
create_flow_step -name genus_to_lec -owner flow {
    #- create output location
    set design  [get_db current_design .name]
    if {[is_flow -quiet -inside flow:syn_opt] && [get_feature pnr_db_handoff]} {
        set out_dir [lindex [get_db flow_starting_db] 1]/cmn
    } else {
        set out_dir [file join [get_db flow_db_directory] [get_db flow_report_name]]
        file mkdir $out_dir
    }

    #- write dofile for LEC
    if {[is_flow -inside flow:syn_map]} {
        if {[file exists scripts/lec.pre_compare.tcl]} {
            write_do_lec \
                -top $design \
                -golden_design rtl \
                -revised_design fv_map \
                -pre_compare scripts/lec.pre_compare.tcl \
                -no_lp \
                -no_exit \
                -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
                > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
        } else {
            write_do_lec \
                -top $design \
                -golden_design rtl \
                -revised_design fv_map \
                -no_lp \
                -no_exit \
                -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
                > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
        }
	# Note, TL: From Benoit. Check if still needed!
	#- Add "analyze_datapath -flowgraph" to dofile
	file rename -force [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp]
	set file_r [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp] r]
	set file_w [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] w]
	
	while {![eof $file_r]} {
	    set line [gets $file_r]
	    if {[regexp {analyze_datapath[ \t]+-verbose;} $line]} {
		set line [regsub {(analyze_datapath[ \t]+-verbose;)} $line {analyze_datapath -flowgraph -verbose;}]
	    } elseif {[regexp "read_library.+-lp all.+" $line]} {
		set line [regsub -- "-lp all " $line ""]
	    }

	    puts $file_w $line
	}
	
	close $file_r
	close $file_w
	# Note, TL. Check if needed end!

    } else {
        if {[file exists scripts/lec.pre_compare.syn_opt.tcl]} {
            write_do_lec \
                -top $design \
                -golden_design fv_map \
                -revised_design [file join $out_dir $design.v.gz] \
                -pre_compare scripts/lec.pre_compare.syn_opt.tcl \
                 -no_lp \
                -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
                > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
        } else {
            write_do_lec \
                -top $design \
                -golden_design fv_map \
                -revised_design [file join $out_dir $design.v.gz] \
                -no_lp \
                -logfile [file join [get_db flow_log_directory] lec.[get_db flow_report_name].log] \
                > [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]
        }
	#- Add "analyze_datapath -flowgraph" to dofile
	file rename -force [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp]
	set file_r [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do.tmp] r]
	set file_w [open [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do] w]
	
	while {![eof $file_r]} {
	    set line [gets $file_r]
	    if {[regexp "read_library.+-lp all.+" $line]} {
		set line [regsub -- "-lp all " $line ""]
	    }

	    puts $file_w $line
	}
	
	close $file_r
	close $file_w

    }
    
    #- schedule the LEC flow
    #FlowtoolPredictHint ArgumentRandomise -branch
    #	schedule_flow \
	#	    -flow lec \
	#	    -branch [get_db flow_report_name] \
	#	    -no_db \
	#	    -no_sync \
	#	    -tool_options "-nogui -XL -do [file join [get_db current_design .verification_directory] lec.[get_db flow_report_name].do]"
}

##############################################################################
# STEP genus_to_modus
##############################################################################
create_flow_step -name genus_to_modus -owner flow {
    set design_name [get_db current_design .name]
    set out_dir [file join [get_db flow_working_directory] atpg]
    
    #- write atpg files
    if {[get_feature -feature dft_compressor]} {
        foreach f [glob -nocomplain -directory $out_dir *.pinassign] {
            file delete -force $f
        }
        
        write_dft_atpg \
            [get_db current_design] \
            -library "[get_db flow_vars_dft_library]" \
            -ncsim_library "[get_db flow_vars_dft_ncsim_library]" \
            -continue_with_severe \
            -compression \
            -directory $out_dir \
            -run_from_directory \
            -hier_test_core \
            -serial -delay
        
        # Some changes will be done
        file rename -force $out_dir/[get_db flow_vars_design_name].pdl \
            $out_dir/[get_db flow_vars_design_name].template.pdl
        file rename -force $out_dir/[get_db flow_vars_design_name].icl \
            $out_dir/[get_db flow_vars_design_name].template.icl

        foreach pinassign [glob -nocomplain -directory $out_dir *.pinassign] {
            if {[regexp WIR_SCAN $pinassign]} {continue}
            file rename -force $pinassign [regsub {\.pinassign} $pinassign {.template.pinassign}]
        }

        # Scan ports not always written to pinassigns
        set extest_chains [llength [get_db actual_scan_chains *1500*]]
        set sdos [llength [get_db test_signals -if {.function==compress_sdo}]]
        if {$extest_chains>$sdos} {
            set extest_chains $sdos
        }
        foreach pinassign [glob -nocomplain -directory $out_dir *.template.pinassign] {
            if {[file exists $pinassign]} {
                dft_utils::read_pinassign $pinassign
                for {set i 0} {$i < $sdos} {incr i} {
                    set sdo [get_db [get_db test_signals -if {.function==compress_sdo && .index==$i}] .pin.name]
                    set sdi [get_db [get_db test_signals -if {.function==compress_sdi && .index==$i}] .pin.name]
                    dft_utils::delete_test_function -quiet -pin $sdi
                    dft_utils::delete_test_function -quiet -pin $sdo
                    if {![regexp EXTEST $pinassign]||$i<$extest_chains} {
                        dft_utils::add_test_function -pin $sdi -function SI
                        dft_utils::add_test_function -pin $sdo -function SO
                    }
                }
                dft_utils::write_pinassign $pinassign
            }
        }

    } else {
        write_dft_atpg \
            [get_db current_design] \
            -library "[get_db flow_vars_dft_library]" \
            -ncsim_library "[get_db flow_vars_dft_ncsim_library]" \
            -continue_with_severe \
            -directory $out_dir \
            -run_from_directory \
            -serial -delay
    }

    # Copy templates
    file copy -force [get_db flow_vars_dft_data_directory]/templates/runmodus_atpg.tcl $out_dir/runmodus.tcl
    file copy -force [get_db flow_vars_dft_data_directory]/templates/run_simulator $out_dir
    file copy -force [get_db flow_vars_dft_data_directory]/templates/generate_mem_udp.do $out_dir

    # Need to send memory models through conformal
    set mem_models [list]
    set other_models [list]
    foreach verilog [get_db flow_vars_dft_library] {
        if {[string match /opt/soc/work/mem/*_atpg.v $verilog]} {
            lappend mem_models $verilog
        } else {
            lappend other_models $verilog
        }
    }

    # Replace placeholders
    exec sed -i s:DFT_LIBRARY:\{[concat $other_models memory_udp_models.v]\}:g $out_dir/runmodus.tcl
    exec sed -i s:DFT_NCSIM_LIBRARY:\"[get_db flow_vars_dft_ncsim_library]\":g $out_dir/run_simulator
    exec sed -i s:MEM_PATH:\{$mem_models\}:g $out_dir/generate_mem_udp.do

    catch {exec -ignorestderr lec -xl -nogui $out_dir/generate_mem_udp.do}

}

##############################################################################
# STEP genus_to_innovus
##############################################################################
create_flow_step -name genus_to_innovus -owner cadence {
  #- Apply change_name rules
  update_names \
    [get_db current_design] \
    -force \
    -verilog \
    -module \
    -append_log \
    -log [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]design.change_names.rpt]
  
  #- prevent SDCs from having set_timing_derate and group_path since these are ignored by innovus
  set_db write_sdc_exclude {set_timing_derate group_path}
  
  #- write output files
  if {![get_feature -feature pnr_db_handoff]} {
      
      # Old netlist handoff:
      write_design \
          -innovus \
          -gzip_files \
          -basename [file normalize [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db current_design .name]]]
      
      set_db flow_post_db_overwrite [list tcl [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db current_design .name].invs_setup.tcl] [get_db flow_startup_directory] {}]
  }  
}

##############################################################################
# Write init script for Innovus
##############################################################################
create_flow_step -name release2pnr -owner tuni {

    # WA : write scandef here because write_design doesn't generate scandef
    if {[get_feature -feature dft_simple] || [get_feature -feature dft_compressor]} {
        write_scandef > [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].scan.def.gz]
    }
    
    set release_script "[file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].release2pnr.tcl]"
    
    set FH [open $release_script w]
    puts $FH "# Design Import"
    puts $FH "###########################################################"
    if {[file exists scripts/mmmc_config.tcl]} {
        puts $FH "read_mmmc scripts/mmmc_config.tcl"
    } else {
        puts $FH "read_mmmc \[get_db flow_source_directory\]/mmmc_config.tcl"
    }
    puts $FH ""
    puts $FH "read_physical -lef \[get_db flow_vars_lef_list\]"
    puts $FH ""
    
    #- read the netlist
    puts $FH "read_netlist [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].v.gz]"
    puts $FH ""
    
    #- read power intent from 1801
    puts $FH "read_power_intent -1801 \[get_db flow_vars_power_intent\]"
    puts $FH ""
    
    #- initialize library and design information
    puts $FH "init_design"
    puts $FH ""
    
    #- add cells and commint power rules
    puts $FH "#commit_power_intent"
    puts $FH ""
    
    #- Load Scan Chains
    if {[get_feature -feature add_scan]} {
        puts $FH "read_def [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].scan.def.gz]"
        puts $FH ""
    }
    
    ## Reading common preserve file for dont_touch and dont_use preserve settings
    puts $FH ""
    if {[get_feature -feature synth_spatial]} {
        puts $FH "read_taf [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].preserve.taf.gz]"
    } else {
        puts $FH "source [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].preserve.tcl]"
    }
    puts $FH ""
    
    close $FH
    
    set_db flow_post_db_overwrite $release_script

}

#===========================================================================
# Flow: report_genus
#===========================================================================

############################################################################
# STEP schedule_report_generic
############################################################################
create_flow_step -name schedule_report_generic -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_synth \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

############################################################################
# STEP schedule_report_map
############################################################################
create_flow_step -name schedule_report_map -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_synth \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

############################################################################
# STEP schedule_report_synth
############################################################################
create_flow_step -name schedule_report_synth -owner cadence -exclude_time_metric {
    schedule_flow \
	-flow report_synth \
	-branch [get_db flow_branch] \
	-include_in_metrics
}

##############################################################################
# STEP report_area_genus
##############################################################################
create_flow_step -name report_area_genus -owner cadence -exclude_time_metric -categories design {
  report_area -min_count 5000 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.summary.rpt]
  report_dp                   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area.datapath.rpt]
}

##############################################################################
# STEP report_timing_summary_late_genus
##############################################################################
create_flow_step -name report_timing_summary_late_genus -owner cadence -exclude_time_metric -categories setup {
  report_timing_summary -checks {setup drv} > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.analysis_summary.rpt]
  report_timing_summary -checks {setup drv} -expand_views > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.view_summary.rpt]
  report_timing_summary -checks {setup drv} -expand_views -expand_clocks launch_capture  > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]setup.group_summary.rpt]
  report_qor > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]qor.rpt]
}

############################################################################
# STEP report_dft_genus
############################################################################
create_flow_step -name report_dft_genus -owner cadence -exclude_time_metric {
    report_scan_setup        > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]scan.setup.rpt]
    
    if {[is_flow -inside flow:syn_opt]} {
	report_scan_chains       > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]scan.chains.rpt]
	if {[llength [get_db actual_scan_chains]] > 0} {
	    write_scandef            > [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.def]
            # By default compression chains are written to abstract. For hierarchical integration has to be fullscan
            if {[get_feature -feature dft_compressor] && [get_db dft_add_test_compression_new_flow]} {
                # spatial synthesis seems to delete scan clock in some cases, redefine it here
                foreach name [list jtag_tck_[get_db flow_vars_design_name] jtag_tck] {
                    set tck_port [get_db ports $name]
                    if {[llength $tck_port]} {
                        if {$tck_port ni [get_db [get_db test_clocks] .sources]} {
                            define_test_clock -name jtag_tck_[get_db flow_vars_design_name] $tck_port
                        }
                        break
                    }
                }

                define_dft_cfg_mode -name FULLSCAN -type scan \
                    -mode_enable_low [get_db test_signals -if {.function==compression_enable || .function==spread_enable}]

                check_dft_rules -dft_cfg_mode FULLSCAN

                for {set i 0} {$i < [get_db dft_compression_num_scanin]} {incr i} {
                    define_scan_chain -name FULLSCAN_$i \
                        -sdi [get_db [get_db test_signals -if {.function==compress_sdi && .index==$i}] .pin] \
                        -sdo [get_db [get_db test_signals -if {.function==compress_sdo && .index==$i}] .pin] \
                        -dft_configuration_mode FULLSCAN \
                        -multi_mode -analyze
                }

                write_dft_abstract_model -write_as_libcell -dft_cfg_mode FULLSCAN > \
                    [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]

                # input->inout arcs aren't written to abstract
                # TODO deleting self controllable definition would be good as now scan out
                # controllables overwrite them but it requires the order to always be same
                dft_utils::read_scan_abstract [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
                foreach port [get_db ports -if {.is_user_scan_out}] {
                    set controllable [report_dft_trace_back -continue $port]
                    if {[get_db $controllable .obj_type]!="port"} {
                        continue
                    }
                    dft_utils::add_dft_controllable -from [get_db $controllable .name] -to [get_db $port .name]
                }
                dft_utils::write_scan_abstract [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]

                delete_obj [get_db dft_configuration_modes FULLSCAN]
                check_dft_rules

                report_core_wrapper_cell -report_flops > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]core_wrapper.rpt]
            } else {
                write_dft_abstract_model -write_as_libcell > [file join [get_db flow_db_directory] [get_db flow_report_name] [get_db flow_report_prefix][get_db current_design .name].scan.abstract]
            }
	}
    }
}

##############################################################################
# STEP report_power_genus
##############################################################################
create_flow_step -name report_power_genus -owner cadence -exclude_time_metric -categories power {
  report_gates -power   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]power.all.rpt]
  report_clock_gating   > [file join [get_db flow_report_directory]/[get_db flow_report_name] [get_db flow_report_prefix]power.clock_gating.rpt]
  report_power -depth 0 > [file join [get_db flow_report_directory]/[get_db flow_report_name] [get_db flow_report_prefix]power.design.rpt]
}

############################################################################
# STEP report_congestion_genus
############################################################################
create_flow_step -name report_congestion_genus -owner cadence -exclude_time_metric {
    report ple            > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.ple.rpt]
    report congestion     > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.congestion.rpt]
    gui_pv_snapshot -overwrite              [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.placement.gif]
    gui_pv_snapshot -overwrite -congestion  [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]physical.congestion.gif]
}

##############################################################################
# Genus generate activity file with Joules
##############################################################################
create_flow_step -name generate_activity_file -exclude_time_metric -owner tuni {
    if {[get_db flow_feature_run_joules_power]} {
	set ::rtls::use_joules_write_parsers 1
	set_db lp_enable_jls_sdb_flow 1
	set_default_activity -pin_types primary_input -duty 0 -freq 0
	set_default_activity -pin_types seq_out -duty 0 -freq 0

	read_stimulus \
	    -file [lindex [get_db flow_vars_tcf_file] 0] \
	    -dut_instance [lindex [get_db flow_vars_tcf_file] 1] \
	    -frame 30 \
	    -start -end 25261ns \
	    -scrub_prep -resim_cg_enables

	propagate_activity -mode time_based
	#compute_ideal_power -mode time_based
	#compute_power -mode time_based

	#write_tcf > [get_db flow_database_directory]/[get_db flow_vars_design_name].tcf
	if {![file exists [get_db flow_report_directory]/joules]} {file mkdir [get_db flow_report_directory]/joules}
	report_sdb_annotation > [get_db flow_report_directory]/joules/report_sdb_annotation.txt
    }
}

##############################################################################
# Genus read activity file
##############################################################################
create_flow_step -name genus_read_activity_file -exclude_time_metric -owner tuni {
    if {[file exists [get_db flow_vars_tcf_file]]} {
	read_tcf "[get_db flow_vars_tcf_file]"
    } else {
	puts "Error: TCF file not found [get_db flow_vars_tcf_file]! Skipping reading activity file"
    }
}

##############################################################################
# generate TCF file
##############################################################################
create_flow_step -name genus_write_tcf -owner tuni {

    if {[get_db flow_feature_run_joules_power]} {
	compute_ideal_power -mode time_based
	compute_power -mode time_based
	report_power -unit uW -format %.4f -by_leaf_instance > [get_db flow_report_directory]/joules/report_power_by_leaf_instance_[get_db flow_vars_design_name].rpt
	report_power -unit uW -format %.4f -by_libcell > [get_db flow_report_directory]/joules/report_power_by_libcell_[get_db flow_vars_design_name].rpt
    }

    write_tcf >  [file join [get_db flow_database_directory] [get_db flow_report_name] [get_db [current_design] .name].tcf]

}

##############################################################################
# Run additional reporting from procedures.tcl
##############################################################################
create_flow_step -name load_additional_procedures -owner tuni {
    if {[file exists [get_db flow_vars_data_directory]/scripts/procedures.tcl]} {
	puts "Info: Sourcing [get_db flow_vars_data_directory]/scripts/procedures.tcl"
	source [get_db flow_vars_data_directory]/scripts/procedures.tcl

	report_latches
	report_clkgates
	report_flip_flops_without_async_reset_or_set
	SearchLargeRegBanks 512
    }
}

##############################################################################
# Report e.g. removed registers
##############################################################################
create_flow_step -name report_design_genus -owner tuni {
    report_sequential -deleted          > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]removed_registers.rpt]
    # check timing intent for each mode (in active views) separately
    array unset cmode_done
    foreach view_dpo [get_db analysis_views -if {.is_active && (.is_setup || .is_hold)}] {
        set cmode [get_db $view_dpo .constraint_mode.name]
        if {![info exists cmode_done($cmode)]} {
            check_timing_intent -view $view_dpo -verbose        > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check_timing_intent.${cmode}.rpt]
            set cmode_done($cmode) 1
        } else {
            continue
        }
    }

    check_design -all                   > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]check_design.rpt]
    report_clocks                       > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]clocks.rpt]
    report_case_analysis                > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]case_analysis.rpt]
    report_area -detail                 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]area_detail.rpt]
    report_design_rules                 > [file join [get_db flow_report_directory] [get_db flow_report_name] [get_db flow_report_prefix]report_design_rules.rpt]
}

##############################################################################
# Report clock tree cells
##############################################################################
create_flow_step -name genus_print_clock_tree_cells -owner design {
}
