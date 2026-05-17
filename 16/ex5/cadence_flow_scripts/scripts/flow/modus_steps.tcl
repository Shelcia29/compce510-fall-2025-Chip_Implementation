# Flowkit v19.10-s011_1
#- modus_steps.tcl : defines Modus based flow_steps

#=============================================================================
# Flow: dft
#=============================================================================

##############################################################################
# STEP dft_start
##############################################################################
create_flow_step -name dft_start -owner cadence {

    file delete -force [get_db flow_vars_data_directory]/dft
    
    define_attribute dft_simulated_tests \
        -category user_flow \
        -data_type string \
        -default "" \
        -help_string "DFT simulated tests, list of dicts" \
        -obj_type root

    define_attribute dft_unsimulated_tests \
        -category user_flow \
        -data_type string \
        -default "" \
        -help_string "DFT unsimulated tests, list of dicts" \
        -obj_type root

    define_attribute dft_verification_directory \
        -category user_flow \
        -data_type string \
        -default "" \
        -help_string "Directory of DFT verification" \
        -obj_type root

    define_attribute dft_running_simulations \
        -category user_flow \
        -data_type string \
        -default "" \
        -help_string "pids of simulations" \
        -obj_type root

    source -quiet [get_db flow_source_directory]/../scripts_global/utilities/dft_utils.tcl
    set_db workdir [get_db flow_vars_data_directory]/dft
}

##############################################################################
# STEP schedule_atpg
##############################################################################
create_flow_step -name schedule_atpg -owner cadence {
    if {[file exists [get_db flow_vars_data_directory]/atpg]} {
        set testmodes [list]
        foreach tm [dict keys $allowed_testmodes] {
            # Genus 21 doesn't generate decompression mode pinassigns
            if {[file exists [get_db flow_vars_data_directory]/atpg/[get_db flow_vars_design_name].[regsub COMPRESSION_DECOMP $tm COMPRESSION].template.pinassign]} {
                lappend testmodes $tm
            }
        }
        puts $testmodes

        
        if {[file exists [get_db flow_vars_data_directory]/atpg/[get_db flow_vars_design_name].WIR_SCAN.pinassign]} {
            # Create 1500 mode modeinits
            run_flow -flow hier_test_1687
        } else {
            set_option coremigrationdir ""
        }
        
        foreach tm $testmodes {
            set_option testmode $tm
            run_flow -flow atpg -reset
        }

        if {[get_option coremigrationdir]!=""} {
            # Migrate
            run_flow -flow hier_test_1500
        }
    }
}

##############################################################################
# STEP schedule_mbist
##############################################################################
create_flow_step -name schedule_mbist -owner cadence {
    if {[file exists [get_db flow_vars_data_directory]/pmbist]} {
        set_option testmode 1149_patt
        run_flow -flow mbist

        set_db workdir [get_db workdir]
        if {[llength [get_db ports mda_tdi]]} {
            set_option testmode mda
            run_flow -flow mbist -reset
        }
    }
}

##############################################################################
# STEP schedule_bscan
##############################################################################
create_flow_step -name schedule_bscan -owner cadence {
    if {[file exists [get_db flow_vars_data_directory]/bscan_verification]} {
        run_flow -flow bscan
    }
}

##############################################################################
# STEP build_model
##############################################################################
create_flow_step -name build_model -owner cadence {
    if {[file exists [get_db flow_vars_data_directory]/atpg/[get_db flow_vars_design_name].WIR_SCAN.pinassign]} {
        set_option core yes
    }

    build_model

    # For legacy reasons so this doesn't have to be in different configs
    if {[llength [get_db ports jtag_tck*]]==1} {
        dft_utils::set_port_names -jtag_tck [get_db [get_db ports jtag_tck*] .name]
    }
}

##############################################################################
# STEP edit_model
##############################################################################
create_flow_step -name edit_model -owner cadence {
    # There seems to be a bug in Modus causing undriven nets in model
    
    array unset nets
    set fp [open [get_db workdir]/testresults/logs/log_build_model r]
    while {[gets $fp line]>=0} {
        if {[string match *TEI-143* $line]} {
            regexp {.*'(.*)'.*'cell[[:space:]]+(.*)'.*'(.*)'.*} $line -> net cell file
            lappend nets($cell) $net
        }
    }
    close $fp

    set fp [open [get_db workdir]/testresults/[get_db flow_vars_design_name].editfile w]

    foreach {module net_l} [array get nets] {
        foreach net $net_l {
            set cell [get_db hinsts -if {.module.base_name==$module}]
            set hnet [get_db $cell .local_hnets -if {.base_name==$net}]
            if {[get_db $hnet .loads]==""} {
                # Empty nets also reported
                continue
            }
            set hport [get_db $hnet .loads -if {.obj_type==hport}]
            if {[llength $hport]!=1} {
                # !!! Might not always work
                set hport [get_db $hport -expr {[llength $obj(.drivers)]==2}]
            }
            set nnet [get_db $hport .hnet]
            set pins [get_db $hnet .loads -if {.obj_type==hpin||.obj_type==pin}]
            foreach pin $pins {
                puts $fp "move pin [get_db $pin .base_name] instance [get_db $pin .instance.base_name] to net [get_db $nnet .base_name] in cell [get_db $cell .module.name];"
            }
        }
    }
    close $fp

    # TODO skipped, check if still causes issues
    #edit_model -editfile [get_db workdir]/testresults/[get_db flow_vars_design_name].editfile

}

##############################################################################
# STEP hier_test_1687_start
##############################################################################
create_flow_step -name hier_test_1687_start -owner cadence {
    # This step is for creating modeinits from 1687 files
    set_db dft_verification_directory [get_db flow_vars_data_directory]/atpg
    set_option testmode WIR_SCAN
    set_option assignfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].WIR_SCAN.pinassign
    set_option modedef FULLSCAN_BYPASS
    set_option experiment ijtag
    set_option allowflushedmeasures yes

    set_option coremigrationdir [get_db workdir]/hier_migration

    dft_utils::read_icl [get_db dft_verification_directory]/[get_db flow_vars_design_name].template.icl
    dft_utils::read_pdl [get_db dft_verification_directory]/[get_db flow_vars_design_name].template.pdl \
        -top [get_db flow_vars_design_name]
    
    if {[regexp OPCG $testmodes]} {
        source -quiet [get_db dft_verification_directory]/opcg_config.tcl
        if {![info exists wir_bits]} {set wir_bits {}}
        dft_utils::calculate_pll_config -r $R -n $N -m $M
        dft_utils::add_wir_bits $wir_bits
        
        dft_utils::fix_icl_opcg_macro -check_ports
        
        dft_utils::update_pll_pdl
        dft_utils::add_pdl_func_reset
    }
    
    dft_utils::write_icl [get_db dft_verification_directory]/[get_db flow_vars_design_name].icl
    dft_utils::write_pdl [get_db dft_verification_directory]/[get_db flow_vars_design_name].pdl
}

##############################################################################
# STEP hier_test_1500_start
##############################################################################
create_flow_step -name hier_test_1500_start -owner cadence {
    # Empty
}

##############################################################################
# STEP atpg_start
##############################################################################
create_flow_step -name atpg_start -owner cadence {
    set_db dft_verification_directory [get_db flow_vars_data_directory]/atpg
    set_option modedef [dict get $allowed_testmodes [get_option testmode]]
    set_option allowflushedmeasures yes
    set_db workdir [get_db workdir]

    if {[file exists [get_db dft_verification_directory]/scan_config.tcl]} {
        source [get_db dft_verification_directory]/scan_config.tcl
    }

    if {[regexp COMPRESSION [get_option testmode]]} {
        set_option experiment [get_db flow_vars_design_name]_compression
    } else {
        set_option experiment [get_db flow_vars_design_name]_atpg
    }
    
    if {[file exists [get_db flow_vars_data_directory]/scripts/[get_db flow_vars_design_name].[get_option testmode].pinassign]} {
        set_option assignfile [get_db flow_vars_data_directory]/scripts/[get_db flow_vars_design_name].[get_option testmode].pinassign
    } else {
        set scan_clk [dict get $dft_utils::port_alias jtag_tck]
        dft_utils::read_pinassign [get_db dft_verification_directory]/[get_db flow_vars_design_name].[regsub COMPRESSION_DECOMP [get_option testmode] COMPRESSION].template.pinassign
        # Scan clock sometimes incorrect
        dft_utils::delete_test_function -pin $scan_clk -quiet
        dft_utils::add_test_function -pin $scan_clk -function -EC
        # Mask incorrect
        if {[regexp COMPRESSION [get_option testmode]]} {
            dft_utils::add_test_function -pin $scan_clk -function -CML
            dft_utils::delete_test_function -pin [get_db [get_db ports mask_enable*] .name]
            dft_utils::add_test_function -pin [get_db [get_db ports mask_enable*] .name] -function -CME
        }
        # OPCG load inputs incorrect, automatically assigned to all scan_ins
        dft_utils::delete_all_by_function OLI
        if {[regexp OPCG [get_option testmode]]} {
            dft_utils::add_test_function -pin $scan_clk -function -OLC
        }
        # Scan in pads get incorrect ZTC
        dft_utils::delete_all_by_function ZTC
        dft_utils::write_pinassign [get_db dft_verification_directory]/[get_db flow_vars_design_name].[get_option testmode].pinassign
        set_option assignfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].[get_option testmode].pinassign
    }
    
    if {[file exists [get_db flow_vars_data_directory]/scripts/[get_db flow_vars_design_name].[get_option testmode].seqdef]} {
        set_option seqdef [get_db flow_vars_data_directory]/scripts/[get_db flow_vars_design_name].[get_option testmode].seqdef
    } elseif {[file exists [get_db dft_verification_directory]/[get_db flow_vars_design_name].[get_option testmode].seqdef]} {
        set_option seqdef [get_db dft_verification_directory]/[get_db flow_vars_design_name].[get_option testmode].seqdef
    } elseif {[file exists [get_db workdir]/testresults/TBDseqPatt.Set[get_option testmode]]} {
        set_option seqdef [get_db workdir]/testresults/TBDseqPatt.Set[get_option testmode]
        if {[regexp OPCG [get_option testmode]]} {
            # build_testmode doesn't add scan_enable to sequence and will error
            dft_utils::update_seqdef [get_option seqdef]
            dft_utils::add_pi_event -pin [get_db [get_db ports *scan_enable*] .base_name] -value 1
            dft_utils::finish_seqdef
        }
    } else {
        set_option seqdef {}
    }
    
    if {[info exists scan_mode_prop_cycles]} {
        if {[get_option seqdef]!=""} {
            dft_utils::update_seqdef [get_option seqdef]
        } else {
            set_option seqdef [get_db dft_verification_directory]/[get_db flow_vars_design_name].[get_option testmode].seqdef
            dft_utils::init_seqdef [get_option seqdef] -name modeinit
        }
        dft_utils::add_prop_cycles $scan_mode_prop_cycles
        dft_utils::finish_seqdef
    }
}

##############################################################################
# STEP mbist_start
##############################################################################
create_flow_step -name mbist_start -owner cadence {
    set_db dft_verification_directory [get_db flow_vars_data_directory]/pmbist
    set_option modedef CORESCAN.mbist
    set_option allowflushedmeasures yes
}

##############################################################################
# STEP bscan_start
##############################################################################
create_flow_step -name bscan_start -owner cadence {
    set_db dft_verification_directory [get_db flow_vars_data_directory]/bscan_verification
    set_option testmode 1149
    set_option bsdlinput [get_db flow_vars_data_directory]/jtag/[get_db flow_vars_design_name].bsdl
    set_option bsdlpkgpath [get_db flow_vars_data_directory]/jtag/
    set_option allowflushedmeasures yes
}

##############################################################################
# STEP build_testmode
##############################################################################
create_flow_step -name build_testmode -owner cadence {
    build_testmode
}

##############################################################################
# STEP read_icl
##############################################################################
create_flow_step -name read_icl -owner cadence {
    read_icl \
        -iclfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].icl \
        -top [get_db flow_vars_design_name]
}

##############################################################################
# STEP migrate_pdl_tests
##############################################################################
create_flow_step -name migrate_pdl_tests -owner cadence {
    migrate_pdl_tests \
        -descfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].descfile \
        -pdlfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].pdl \
        -generatemodeinit yes
}

##############################################################################
# STEP build_core_migration_model
##############################################################################
create_flow_step -name build_core_migration_model -owner cadence {
    build_core_migration_model \
        -modeltype complete \
        -modifynames yes
}

##############################################################################
# STEP prepare_1500_bypass
##############################################################################
create_flow_step -name prepare_1500_bypass -owner cadence {
    # Bypass is part of standard but possible to not implement
    if {[file exists [get_db dft_verification_directory]/[get_db flow_vars_design_name].BYPASS.pinassign]} {
        build_testmode \
            -testmode BYPASS \
            -assignfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].BYPASS.pinassign \
            -seqdef [get_db workdir]/testresults/TBDseqPatt.SetBYPASS \
            -modedef FULLSCAN_BYPASS \
            -allowflushedmeasures yes

        # Note: testmode not verified but assumed fine

        prepare_core_migration_info \
            -testmode BYPASS
    }
}

##############################################################################
# STEP report_test_structures
##############################################################################
create_flow_step -name report_test_structures -owner cadence {
    report_test_structures \
        -reportscanchain all
    
    verify_test_structures \
        -xclockanalysis yes
}

##############################################################################
# STEP build_faultmodel
##############################################################################
create_flow_step -name build_faultmodel -owner cadence {
    build_faultmodel \
        -includedynamic yes \
        -overwrite yes
}

##############################################################################
# STEP prepare_opcg_test_sequences
##############################################################################
create_flow_step -name prepare_opcg_test_sequences -owner cadence {
    if {[regexp OPCG [get_option testmode]]} {
        prepare_opcg_test_sequences \
            -read yes
    }
}

##############################################################################
# STEP define_timing_atpg
##############################################################################
create_flow_step -name define_timing_atpg -owner cadence {
    # Protects from possible TSV-054 and TSV-059
    read_sdc \
        -tsvconstraints

    # Possible multicycles need to be read in
    if {[file exists [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.atpg_opcg.tcl]} {
        read_sdc -sdc [get_db flow_vars_data_directory]/constraints/[get_db flow_vars_design_name].constraints.atpg_opcg.tcl
    }
}

##############################################################################
# STEP run_atpg
##############################################################################
create_flow_step -name run_atpg -owner cadence {

    # Few faults can be found for extest so limit patterns
    if {[regexp EXTEST $tm]} {
        set max [get_option maxpatterns]
        set_option maxpatterns 2
    }
    
    if {[regexp OPCG [get_option testmode]]} {
        create_logic_delay_tests \
            -latchsimulation pessimistic \
            -testsequence [get_db workdir]/testresults/TBDseqDef.[get_option testmode].dynamic.list
    } else {
        create_logic_tests \
            -latchsimulation pessimistic
    }
    
    if {[regexp EXTEST $tm]} {
        set_option maxpatterns $max
    }
    
    write_toggle_gram

}

##############################################################################
# STEP report_untested
##############################################################################
create_flow_step -name report_untested -owner cadence {
    report_faults \
        -faultstatus {untestable aborted} \
        -includecollapsed yes
}

##############################################################################
# STEP write_verilog_parallel
##############################################################################
create_flow_step -name write_verilog_parallel -owner cadence {

    if {[get_feature -feature full_atpg]} {
        write_vectors \
            -language verilog \
            -scanformat parallel \
            -exportdir [get_db workdir]/testresults/verilog_parallel \
            -inexperiment [get_option experiment] \
            -xvalue 1
        
        set tests [list]
        foreach MTM {MAXIMUM MINIMUM} {
            lappend tests [dict create name [file tail [get_db workdir]]_[get_option testmode]_[get_option experiment] \
                               file_pattern [get_db workdir]/testresults/verilog_parallel/VER.[get_option testmode].[get_option experiment].data.logic.ex1.ts*.verilog \
                               testbench    [get_db workdir]/testresults/verilog_parallel/VER.[get_option testmode].[get_option experiment].mainsim.v \
                               log          [get_db workdir]/sim_logs/sim.[get_option testmode]_parallel_SDF_$MTM.log \
                               MTM          $MTM \
                               extra_opts   {-gateloopwarn -allowredefinition} ]
        }
        set_db dft_unsimulated_tests [concat [get_db dft_unsimulated_tests] $tests]
    }
    
}

##############################################################################
# STEP write_verilog_atpg
##############################################################################
create_flow_step -name write_verilog_atpg -owner cadence {

    write_vectors \
        -language verilog \
        -scanformat serial \
        -exportdir [get_db workdir]/testresults/verilog \
        -inexperiment [get_option experiment] \
        -xvalue 1

    set tests [list]
    if {[get_feature -feature full_atpg]} {
        # Only run scan shift with serial
        set patt [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option experiment].data.scan.ex1.ts*.verilog
        # Also run with maximum delays
        set delays {MINIMUM MAXIMUM}
    } else {
        set patt [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option experiment].data.logic.ex1.ts*.verilog
        set delays MINIMUM
    }
    
    foreach MTM $delays {
        lappend tests [dict create name [file tail [get_db workdir]]_[get_option testmode]_[get_option experiment] \
                           file_pattern $patt \
                           testbench    [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option experiment].mainsim.v \
                           log          [get_db workdir]/sim_logs/sim.[get_option testmode]_SDF_$MTM.log \
                           MTM          $MTM \
                           extra_opts   -gateloopwarn ]
    }
    set_db dft_unsimulated_tests [concat [get_db dft_unsimulated_tests] $tests]

}

##############################################################################
# STEP commit_atpg
##############################################################################
create_flow_step -name commit_atpg -owner cadence {
    commit_tests \
        -inexperiment [get_option experiment]
}

##############################################################################
# STEP prepare_core_migration
##############################################################################
create_flow_step -name prepare_core_migration -owner cadence {
    set_db workdir [get_db workdir]
    puts "Migrating testmodes [get_db testmodes]"
    foreach tm [get_db testmodes] {
        if {[regexp INTEST $tm]} {
            prepare_core_migration_data \
                -testmode [get_db $tm .name]
        }
    }
}

##############################################################################
# STEP create_mbist_interface_files
##############################################################################
create_flow_step -name create_mbist_interface_files -owner cadence {
    # Create interface files from templates based on mbist config
    # TODO these should be separated, maybe run hier_test flow for jtag

    set_db workdir [get_db workdir]

    if {[get_option testmode]=="1149_patt"} {
        # MBIST can be inserted without wir, in that case pll doesn't exists in block
        set 1687_dir [get_db flow_vars_data_directory]/atpg
            
        if {[file exists $1687_dir/[get_db flow_vars_design_name].template.icl]} {
            source [get_db dft_verification_directory]/mbist_config.tcl
            
            if {![info exists wir_bits]} {set wir_bits {}}
            dft_utils::calculate_pll_config -r $R -n $N -m $M
            dft_utils::create_mbist_pinassign [get_db workdir]/[get_db flow_vars_design_name].MBIST.pinassign
            set Tpll $dft_utils::Tpll

            dft_utils::create_pattern_control \
                -infile [get_db dft_verification_directory]/testresults/testmode_data/[get_db flow_vars_design_name]_template_pattern_control.txt

            dft_utils::reset_wir_bits
            dft_utils::add_wir_bits [concat $wir_bits scan_mode 0 mbist_mode 1]
            
            dft_utils::read_pdl $1687_dir/[get_db flow_vars_design_name].template.pdl -top [get_db flow_vars_design_name]
            dft_utils::update_pll_pdl -mbist
            dft_utils::write_pdl [get_db workdir]/[get_db flow_vars_design_name].MBIST.pdl
            
            dft_utils::read_icl $1687_dir/[get_db flow_vars_design_name].template.icl
            dft_utils::fix_icl_opcg_macro -check_ports
            dft_utils::fix_icl_jtag -mbist
            dft_utils::write_icl [get_db workdir]/[get_db flow_vars_design_name].MBIST.icl
            
            set fp [open [get_db dft_verification_directory]/[get_db flow_vars_design_name].descfile w]
            puts $fp "Algorithm SetMBIST_$Tpll;"
            close $fp
            
            if {![llength [get_db testmodes WIR_SCAN]]} {
                build_testmode \
                    -name WIR_SCAN \
                    -assignfile $1687_dir/[get_db flow_vars_design_name].WIR_SCAN.pinassign \
                    -modedef FULLSCAN_BYPASS \
                    -allowflushedmeasures yes
            }

            read_icl \
                -iclfile [get_db workdir]/[get_db flow_vars_design_name].MBIST.icl \
                -top [get_db flow_vars_design_name] \
                -testmode WIR_SCAN
            
            migrate_pdl_tests \
                -testmode WIR_SCAN \
                -experiment ijtag \
                -descfile [get_db dft_verification_directory]/[get_db flow_vars_design_name].descfile \
                -pdlfile [get_db workdir]/[get_db flow_vars_design_name].MBIST.pdl \
                -generatemodeinit yes
            
            set_option assignfile [get_db workdir]/[get_db flow_vars_design_name].MBIST.pinassign
            set_option seqdef [get_db workdir]/testresults/TBDseqPatt.SetMBIST_$Tpll
        } else {
            if {[file exists [get_db workdir]/testresults/testmode_data/[get_db flow_vars_design_name]_template_pattern_control.txt]} {
                set dft_utils::Tpll 0
                dft_utils::create_pattern_control \
                    -infile [get_db workdir]/testresults/testmode_data/[get_db flow_vars_design_name]_template_pattern_control.txt
            }
            
            set_option assignfile [get_db workdir]/[get_db flow_vars_design_name].MBIST.[get_option testmode].pinassign
            dft_utils::create_mbist_pinassign -simple [get_option testmode]
            if {[info exists mbist_port_ti]} {
                dft_utils::read_pinassign [get_option assignfile]
                foreach pair $mbist_port_ti {
                    if {[lindex $pair 1]} {
                        set function +TI
                    } else {
                        set function -TI
                    }
                    dft_utils::add_test_function -pin [lindex $pair 0] -function $function
                }
                dft_utils::write_pinassign [get_option assignfile]
            }
            set_option seqdef [get_db workdir]/[get_db flow_vars_design_name].[get_option testmode].seqdef
            dft_utils::init_seqdef [get_option seqdef] -name modeinit
            dft_utils::create_mbist_init
            dft_utils::finish_seqdef
        }
        
        if {[info exists mbist_mode_prop_cycles]} {
            if {[get_option seqdef]!=""} {
                dft_utils::update_seqdef [get_option seqdef]
            } else {
                set_option seqdef [get_db workdir]/[get_db flow_vars_design_name].[get_option testmode].seqdef
                dft_utils::init_seqdef [get_option seqdef] -name modeinit
            }
            dft_utils::add_prop_cycles $mbist_mode_prop_cycles
            dft_utils::finish_seqdef
        }

    } elseif {[get_option testmode]=="mda"} {
        if {![info exists mda_ema]} {
            set mda_ema 1111111111111111
        }
        if {![info exists mda_clk_ctrl]} {
            set mda_clk_ctrl 00001000
        }
        
        set seqdef [get_db workdir]/testresults/mda_modeinit.seqdef
        dft_utils::init_seqdef $seqdef -name mda_init
        if {[llength [get_db ports pll_ctrl_valid]]} {
            dft_utils::create_mbist_pinassign -mda \
                -ema $mda_ema [get_db workdir]/[get_db flow_vars_design_name].MBIST.mda.pinassign \
                -clk_ctrl $mda_clk_ctrl
            dft_utils::create_mda_init
        } else {
            # HPC cores don't have common clock interface
            dft_utils::create_mbist_pinassign -mda \
                -ema $mda_ema [get_db workdir]/[get_db flow_vars_design_name].MBIST.mda.pinassign
            if {[info exists mbist_port_ti]} {
                dft_utils::read_pinassign [get_option assignfile]
                foreach pair $mbist_port_ti {
                    if {[lindex $pair 1]} {
                        set function +TI
                    } else {
                        set function -TI
                    }
                    dft_utils::add_test_function [lindex $pair 0] -function $function
                }
                dft_utils::write_pinassign [get_option assignfile]
            }
            dft_utils::create_mda_init -simple
        }
        dft_utils::finish_seqdef
        
        set_option assignfile [get_db workdir]/[get_db flow_vars_design_name].MBIST.mda.pinassign
        set_option seqdef $seqdef
    }

}

##############################################################################
# STEP create_embedded_test
##############################################################################
create_flow_step -name create_embedded_test -owner cadence {
    # Tpll calculated in create_mbist_interface_files

    set_option interfacefiledir [get_db flow_vars_data_directory]/pmbist/testresults/testmode_data
    set_option interfacefilelist [list [get_db flow_vars_design_name]_mbistchk_tdr_map.txt \
                                      [get_db flow_vars_design_name]_mbistsch_tdr_map.txt \
                                      [get_db flow_vars_design_name]_mbisttpn_tdr_map.txt \
                                      [get_db flow_vars_design_name]_${Tpll}_pattern_control.txt \
                                      [get_db flow_vars_design_name]_test_def.txt]

    # Jtag mode assumed to be internal clock source, repair run only in mda if available
    if {[get_option testmode]=="1149_patt"} {
        # Modus gets confused without this
        set_db workdir [get_db workdir]

        set_option createpatterns jtag_production
        set_option customtestplans \
            [dft_utils::get_mbist_testplans [get_option interfacefiledir]/[get_db flow_vars_design_name]_test_def.txt -pattern ptpn*]
        set_option customexperiment MBIST_ATE_PROD_1_ICS
        #set_option inexperiment [get_db [get_db testmodes 1149_patt] .experiments.name]
    } elseif {[get_option testmode]=="mda"} {
        set_option createpatterns pmda_production
        
        set_option customexperiment MBIST_ATE_DIRECTACCESS_1
        #set_option inexperiment MBIST_ATE_DIRECTACCESS_1
        if {"enable_bira_accum" in [dft_utils::get_mbist_testplans [get_option interfacefiledir]/[get_db flow_vars_design_name]_test_def.txt]} {
            set_option customtestplans {enable_bira_accum ptpn_march_ssp px_move_bira_to_rru_disable_accum rerun_ptpn_march_ssp}
        } else {
            set_option customtestplans \
                [dft_utils::get_mbist_testplans [get_option interfacefiledir]/[get_db flow_vars_design_name]_test_def.txt -pattern ptpn*]
        }
    }
        
    create_embedded_test \
        -block [get_db flow_vars_design_name] \
        -buildtestmode no \
        -cleanstart yes \
        -prodschedule parallel_parallel

}

##############################################################################
# STEP write_verilog_mbist
##############################################################################
create_flow_step -name write_verilog_mbist -owner cadence {

    # Default teststrobe is one clock cycle from falling edge, tdo driven on rising edge
    set_option inexperiment [get_db [get_db testmodes [get_option testmode]] .experiments.name]
    write_vectors \
        -language verilog \
        -keyeddata yes \
        -keyeddatakey PMBISTFailDataSync \
        -compresspatterns no \
        -exportdir [get_db workdir]/testresults/verilog

    # Only some delays used here to reduce runtime
    set tests [list]
    foreach MTM {MAXIMUM} {
        set tb [file tail [get_db workdir]]_[get_option testmode]_[get_option inexperiment]
        lappend tests [dict create name $tb \
                           file_pattern [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option inexperiment].data.logic.ex1.ts1.verilog \
                           testbench    [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option inexperiment].mainsim.v \
                           log          [get_db workdir]/sim_logs/sim.[get_option inexperiment]_SDF_$MTM.log \
                           MTM          $MTM \
                           extra_opts   -gateloopwarn
                          ]
    }
    if {[file exists [get_db dft_verification_directory]/generate_mbist_faults.v]} {
        dft_utils::add_tb_memory_faults -faults [get_db dft_verification_directory]/generate_mbist_faults.v \
            [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option inexperiment].mainsim.v
        # This might take a long time when running full tests so skipped except when repair available
        if {[get_option testmode]=="mda" && "enable_bira_accum" in [dft_utils::get_mbist_testplans [get_option interfacefiledir]/[get_db flow_vars_design_name]_test_def.txt]} {
            set faults 2
            foreach MTM {MINIMUM} {
                lappend tests [dict create name [file tail [get_db workdir]]_[get_option testmode]_[get_option inexperiment] \
                                   file_pattern [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option inexperiment].data.logic.ex1.ts1.verilog \
                                   testbench    [get_db workdir]/testresults/verilog/VER.[get_option testmode].[get_option inexperiment].mainsim.v \
                                   log          [get_db workdir]/sim_logs/sim.[get_option inexperiment]_faults_SDF_$MTM.log \
                                   MTM          $MTM \
                                   extra_opts   [list -gateloopwarn -define MEMORY_FAULTS] \
                                   faults_expected $faults ]
            }
        }
    }
    set_db dft_unsimulated_tests [concat [get_db dft_unsimulated_tests] $tests]
}

##############################################################################
# STEP create_mda_headers
##############################################################################
create_flow_step -name create_mda_headers -owner cadence {
    set_db workdir [get_db workdir]
    if {[llength [get_db ports mda_tdi]]} {
        unset_option customtestplans ""
        unset_option customexperiment
        
        create_embedded_test \
            -block [get_db flow_vars_design_name] \
            -buildtestmode no \
            -cleanstart yes \
            -prodschedule parallel_parallel
        
        # Subsystem can't really know this, probably has to be redone at top
        if {![info exists index]} {
            set index 0
        }

        dft_utils::create_mda_header_from_sequence \
            -in_file [glob -directory [get_db dft_verification_directory]/testresults/testmode_data/sources *.MBIST_ATE_DIRECTACCESS_1.gz] \
            -out_file [get_db workdir]/[get_db flow_vars_design_name]_mda.h -module [get_db flow_vars_design_name] -index $index \
            -pattern_control [get_option interfacefiledir]/[get_db flow_vars_design_name]_${Tpll}_pattern_control.txt
    }
        
}

##############################################################################
# STEP verify_11491_boundary
##############################################################################
create_flow_step -name verify_11491_boundary -owner cadence {
    verify_11491_boundary \
        -verify all
    
}

##############################################################################
# STEP write_verilog_bscan
##############################################################################
create_flow_step -name write_verilog_bscan -owner cadence {

    foreach tm {1149 TB_EXTEST_CAP_UPDT} {
        write_vectors \
            -inexperiment 11491expt \
            -testmode $tm \
            -language verilog \
            -exportdir [get_db workdir]/testresults/verilog \
            -scanformat serial
        
        set tests [list]
        foreach MTM {MAXIMUM MINIMUM} {
            lappend tests [dict create name [file tail [get_db workdir]]_${tm}_11491expt \
                               file_pattern [get_db workdir]/testresults/verilog/VER.$tm.11491expt.data.logic.ex1.ts*.verilog \
                               testbench    [get_db workdir]/testresults/verilog/VER.$tm.11491expt.mainsim.v \
                               log          [get_db workdir]/sim_logs/sim.${tm}_SDF_$MTM.log \
                               MTM          $MTM ]
        }
    }
    set_db dft_unsimulated_tests [concat [get_db dft_unsimulated_tests] $tests]
}

##############################################################################
# STEP write_tester_format
##############################################################################
create_flow_step -name write_tester_format -owner cadence {
    write_vectors
}

##############################################################################
# STEP schedule_simulation
##############################################################################
create_flow_step -name schedule_simulation -owner cadence {

    set env(WORKDIR) [get_db dft_verification_directory]

    if {[info exists dft_synth_flow]} {
        set netlist [get_db flow_vars_data_directory]/dbs/syn_opt/[get_db flow_vars_design_name].v.gz
    } else {
        set netlist [get_db flow_vars_data_directory]/dbs/opt_signoff/[get_db flow_vars_design_name].v.gz
    }
    set com_opts  [concat -define ARM_DISABLE_EMA_CHECK -define CLKPLL_NO_REFERENCE_CLOCK_MONITORING \
                       -define ARM_FAULT_MODELING -define NTC -define RECREM \
                       -sv [get_db flow_vars_dft_ncsim_library] $netlist -nowarn RECOME]
    set elab_opts [list -negdelay -sdfstats unannotated_paths.rpt -ntc_level 3 -nowarn CSINFI \
                       -nowarn CUVWSI -nowarn CUVWSP -nowarn NTCDMIN -nowarn SDFNCAP]
    if {[file exists [get_db flow_vars_data_directory]/scripts/sdf.cmd]} {
        lappend elab_opts [list -sdf_cmd_file [get_db flow_vars_data_directory]/scripts/sdf.cmd]
    } else {
        lappend elab_opts [list -sdf_cmd_file [get_db flow_vars_data_directory]/compiled_sdf/sdf.cmd]
    }
    if {[info exists dft_synth_flow]||[info exists sim_no_delay]} {
        set elab_opts [list -seq_udp_delay 10ps -delay_mode zero ]
    } else {
        set elab_opts {}
    }

    set simulated [get_db dft_simulated_tests]
    foreach test [get_db dft_unsimulated_tests] {
        set name [dict get $test name]
        set testfiles [dict get $test file_pattern]
        set testbench [dict get $test testbench]
        set env(TESTBENCH) $name
        set env(MTM) [dict get $test MTM]
        set log [dict get $test log]
        if {"extra_opts" in [dict keys $test]} {
            set extra_opts [dict get $test extra_opts]
        } else {
            set extra_opts ""
        }

        set sim_opts [list -exit +unknown_pin_off]
        foreach tf [glob $testfiles] {
            regexp {ts([0-9]+)} $tf -> file_num
            lappend sim_opts "+TESTFILE${file_num}=$tf"
        }

        lappend com_opts $testbench

        # To run multiple simulations at once
        # TODO might be possible without this and could speed up compilation
        set temp_dir xrun_temp_[expr int(rand()*1000000)]
        while {[file exists $temp_dir]} {
            set temp_dir xrun_temp_[expr int(rand()*1000000)]
        }
        file mkdir $temp_dir
        lappend extra_opts -xmlibdirpath $temp_dir
        
        # Running exec xrun looks for modus executables
        set xrun [exec which xrun]
        set pid [exec {*}[concat $xrun -64bit -top $name $com_opts $elab_opts $sim_opts $extra_opts -l $log > /dev/null &]]
        dict append test pid $pid
        dict append test temp_dir $temp_dir
        lappend simulated $test
    }
    
    set_db dft_simulated_tests $simulated
    set_db dft_unsimulated_tests [list]
}

##############################################################################
# STEP report_dft
##############################################################################
create_flow_step -name report_dft -owner cadence {
    set i 0
    set waiting {}
    foreach test [get_db dft_simulated_tests] {
        lappend waiting [dict get $test pid]
    }
    while {[llength $waiting]} {
        set j 0
        foreach pid $waiting {
            if {![file exists /proc/$pid]} {
                set waiting [lreplace $waiting $j $j]
            } else {
                incr j
            }
        }
        if {$i==0} {
            set i 5
            puts "Waiting for [llength $waiting] simulations, pids $waiting"
        }
        # exec to reap zombie processes
        exec sleep 60
        incr i -1
    }
    
    # Modus 19 and 21 report simulation differently
    if {[lindex [split [get_db program_major_version] /] 0]>19} {
        set re {Total\s+Failed\s+Tests.+([0-9]+)}
    } else {
        set re {TVE-203[^0-9]+([0-9]+)}
    }
    set failed [list]
    foreach test [get_db dft_simulated_tests] {
        if {[file exists [dict get $test log]]} {
            set fp [open [dict get $test log] r]
            set finished 0
            while {![eof $fp]} {
                gets $fp line
                if {[regexp $re $line -> num]} {
                    set finished 1
                    if {![dict exists $test faults_expected] && $num > 0} {
                        lappend failed $test
                    } elseif {[dict exists $test faults_expected] && $num != [dict get $test faults_expected]} {
                        lappend failed $test
                    }
                }
            }            
            if {$finished == "0"} {
                lappend failed $test
            }
            close $fp
        } else {
            lappend failed $test
        }
        file delete -force [dict get $test temp_dir]
    }

    set fp [open [get_db workdir]/sim_logs/dft_simulations_summary.log w]
    if {[llength $failed]} {
        puts $fp "Failed tests:"
        puts $fp ""
        foreach test $failed {
            dict for {opt value} $test {
                puts $fp "${opt}: [join $value]"
            }
            puts $fp ""
        }
        puts ""
        puts ""
        puts "============================================================="
        puts "  Warning: failed simulations"
        puts "  See dft/sim_logs/dft_simulations_summary.log for details"
        puts "============================================================="
        puts ""
        puts ""
    } else {
        puts $fp "No failed tests"
    }
    
    puts $fp ""
    puts $fp "Test details:"
    puts $fp ""
    foreach test [get_db dft_simulated_tests] {
        dict for {opt value} $test {
            if {$opt in {pid temp_dir}} {continue}
            puts $fp "${opt}: [join $value]"
        }
        puts $fp ""
    }
    close $fp
}
