# All sequences end up in run-test-idle
# No error checking done on BSDL
# Possible to load data longer/shorter than register
# No error checking done on pinassign function
# Values printed after commands is sort of random depending on shell

namespace eval dft_utils {
    variable proc_opts
    array set proc_opts {
        read_bsdl {filename}
        report_jtag {}
        init_seqdef {file [-name name] [-reset [-trst|-tms]]}
        load_instruction {name [-value value]}
        finish_seqdef {[file]}
        update_seqdef {seqdef}
        create_mda_init {[-simple]}
        read_icl {filename}
        merge_icl {filename [-check_names]}
        add_icl_port {port -type type -module module}
        fix_icl_opcg_macro {[-check_ports] [-old]}
        fix_icl_jtag {[-mbist|-top] [-old]}
        write_icl {filename}
        read_pdl {{filename|-reset} [-top name]}
        merge_pdl {filename}
        set_pdl_wir_bits {}
        set_pdl_ports {-port port val}
        remove_icall {icall}
        update_pll_pdl {[-mbist [-old]]}
        fix_pdl_top {}
        write_pdl {filename}
        add_pdl_iprocs {[-mbist|-testmode testmode [-core core]] [-top] [-old]}
        add_pdl_func_reset {}
        add_pi_event {-pin pin -value value}
        calculate_pll_config {-r <int> -n <int> -m <int>}
        update_pll_pinassign {pinassign}
        int_to_bin {value [-pad pad] [-msb_first]}
        read_pinassign {pinassign|-reset}
        write_pinassign {pinassign}
        add_test_function {-pin pin -function function}
        delete_test_function {-pin pin [-function function] [-quiet]}
        delete_all_by_function {function}
        create_custom_tdr {-length <int> -name name [-create_ports [-clockdr pin]] [-generate_1687 dir] [-updatedr] [-scan -shift_enable test_signal -test_mode test_signal -test_clock test_clock]}
        add_wir_bits {values}
        reset_wir_bits {}
        print_usage {}
        create_mbist_pinassign {[-old] [file] [-mda -ema ema_value [-clk_ctrl ctrl_value]] [-simple]}
        create_pattern_control {-infile file [-testplans list] [-outfile file]}
        generate_cdns_memory_view {memory_list -source_directory path [-file filename] [-append] [-repair]}
        reset_mbist_config {}
        add_mbist_config {memory_list {-ignore | {-clock clock -location location}} [-mask|-no_mask] [-clock_mux] [-redundancy [-repair [-hard]]] [-pipelines num]}
        write_mbist_config {file}
        get_mbist_testplans {file [-pattern pattern]}
        create_iospeclist {-order port_list [-disabled_segments names] file}
        update_opcg_cells {-macro macro_list -trigger trigger [-ulvt]}
        create_memory_fault_file {file}
        generate_pinassign_genus {[-opcg] [-compression] [-extest]}
        generate_extest_coreinstancefile {cores -testmode mode}
        generate_opcg_pinassign {}
        set_pinassign_core {cores -mode mode}
        read_scan_abstract {file|-reset}
        add_dft_controllable {-from port -to port}
        write_scan_abstract {file}
        uniquify_scan_abstract {token}
        set_port_names {[-refclk port] [-refrstn port] [-jtag_tck port] [-jtag_reset port] [-jtag_tdi port]}
        create_upf_tb {file}
        set_pg {[-power power] [-ground ground]}
        add_prop_cycles {cycles [-wait_osc]}
        update_mbist_ports {file [-jtag_tdi name] [-jtag_reset name]}
        add_tb_memory_faults {file -faults file}
        find_constant_source {pin}
        create_mbist_init {}
        create_mda_header_from_sequence {[-module name] -in_file seqdef -out_file header [-index num] [-pattern_control file]}
    }

    variable proc_help
    array set proc_help {
        print_usage "Prints commands in namespace dft_utils"
    }
    
    variable seqdef_data
    variable seqdef_name
    # dict { name { address aval length lval } } ,length optional
    variable bsbl_instructions {}
    # dict { name pin } ,where name =tdi,tms,...
    variable bsdl_tap {}

    variable sequence 1
    variable sequence_name JTAG_Initialization_Sequence

    # PLL config values, from calculate_pll_config
    variable Tpll
    variable loop_ctrl
    variable R_div
    variable N_div
    variable M_div

    variable pinassign_data
    variable pinassign_regex {assign\s+pin\s*=\s*(\S+)\s+test_function\s*=([0-9a-zA-Z+\-,\s]+);}

    variable icl_data
    variable icl_top
    variable pdl_data
    variable pdl_top

    variable wir_extra_bits {}

    # Add per memory configs (mask etc) when writing view for config
    variable mbist_local_config [dict create]
    variable mbist_config_data {}
    variable mbist_config_testplans {}
    variable mbist_available_testplans {}
    # name address_orders address_updates data_backgrounds data_orientation algorithms programmed|hardwired
    # Detects peripheral faults around core select
    lappend mbist_available_testplans ptpn_cs_test {no-update shifted solid word cs_test hardwired}
    # detects multi-port faults, march_rw_s2pf- should work but simulation fails with x values
    lappend mbist_available_testplans ptpn_march_rw_s2pf- {fast-row linear solid word march_s2pf- hardwired}
    # detects peripheral faults around data port
    lappend mbist_available_testplans ptpn_march_samio {no-update shifted log2b word march_samio hardwired}
    # detects static simple 1-2 cells memory faults and static address decoder faults
    lappend mbist_available_testplans ptpn_march_ssp {fast-row linear solid word march_ssp hardwired}
    # detects peripheral faults around write mask
    lappend mbist_available_testplans ptpn_write_mask_test {no-update linear solid word write_mask_test hardwired}

    # epilogues and prologues
    variable mbist_repair_testplans {}
    lappend mbist_repair_testplans enable_bira_accum {prologue {assign accumra 1}}
    lappend mbist_repair_testplans move_bira_to_rru {epilogue {assign ra2rr 1 wait ra2rr 0}}
    lappend mbist_repair_testplans disable_bira_accum {prologue {assign accumra 0}}
    # Testplans ordered alphabetically, make sure this is between ptpn and rerun
    lappend mbist_repair_testplans px_move_bira_to_rru_disable_accum {epilogue {assign ra2rr 1 wait ra2rr 0 assign accumra 0}}

    variable abstract_data

    # As subsystems might have different names for refclk, refrstn, mbist
    # clk_i is used for mbist if block has no pll
    variable port_alias {refclk refclk refrstn refrstn jtag_tck jtag_tck jtag_reset jtag_reset jtag_tdi jtag_tdi clk_i clk_i}

    # For adding upf inits to tb file
    variable powers VDD
    variable grounds VSS

    proc read_bsdl {args} {
        internal::read_args $args
        
        variable bsdl_instructions
        variable bsdl_tap
        set bsbl_instructions [dict create]
        set bsdl_tap [dict create]
        set fpr [open $filename r]
        set opcode_start 0
        set length_start 0
        while {[gets $fpr line]>=0} {
            if {[regexp INSTRUCTION_OPCODE $line]} {
                set opcode_start 1
            } elseif {$opcode_start==1} {
                regexp {\"\s*(\S+)\s+\(\s*(\S+)\s*\)} $line -> name opcode
                dict lappend bsdl_instructions $name opcode $opcode
                if {[regexp {;} $line]} {
                    set opcode_start 0
                }
            } elseif {[regexp REGISTER_ACCESS $line]} {
                set length_start 1
            } elseif {$length_start==1} {
                if {[regexp {\"\s*(\S+)\s*\[(\d+)\]} $line -> name length]} {
                    dict lappend bsdl_instructions $name length $length
                }
                if {[regexp {;} $line]} {
                    set length_start 0
                }
            } elseif {[regexp {attribute\s+TAP_SCAN_IN\s+of\s+(\S+):} $line -> name]} {
                dict lappend bsdl_tap tdi $name
            } elseif {[regexp {attribute\s+TAP_SCAN_MODE\s+of\s+(\S+):} $line -> name]} {
                dict lappend bsdl_tap tms $name
            } elseif {[regexp {attribute\s+TAP_SCAN_OUT\s+of\s+(\S+):} $line -> name]} {
                dict lappend bsdl_tap tdo $name
            } elseif {[regexp {attribute\s+TAP_SCAN_CLOCK\s+of\s+(\S+):} $line -> name]} {
                dict lappend bsdl_tap tck $name
            } elseif {[regexp {attribute\s+TAP_SCAN_RESET\s+of\s+(\S+):} $line -> name]} {
                dict lappend bsdl_tap trst $name
            }
        }
        close $fpr
    }

    proc report_jtag {args} {
        internal::read_args $args
        
        variable bsdl_tap
        variable bsdl_instructions
        puts "JTAG tap:"
        dict for {name pin} $bsdl_tap {
            puts "  JTAG signal ${name}, pin $pin"
        }
        puts "JTAG instructions:"
        dict for {name val} $bsdl_instructions {
            puts "  $name"
            puts "    opcode [dict get $val opcode]"
            if {[dict exists $val length]} {
                puts "    length [dict get $val length]"
            }
        }
    }

    proc init_seqdef {args} {
        internal::read_args $args
        
        variable seqdef_data
        variable seqdef_name
        variable sequence
        variable sequence_name

        if {$name!=""} {
            set sequence_name $name
        }
        set seqdef_name $file
        set seqdef_data {}
        lappend seqdef_data "TBDpatt_Format (mode=node, model_entity_form=name)\;"
        lappend seqdef_data "\[ Define_Sequence $sequence_name $sequence (modeinit)\;"
        
        if {$reset==1} {
            if {$tms==1} {
                internal::add_tms_reset
            } else {
                internal::add_trst_reset
            }
        }
    }

    proc load_instruction {args} {
        internal::read_args $args
        
        variable bsdl_instructions

        if {$name in [dict keys $bsdl_instructions]} {
            internal::load_ir [dict get $bsdl_instructions $name opcode]
            
            if {$dr==1} {
                internal::load_dr $value
            }
        } else {
            error "JTAG instruction $name not found"
        }
    }

    proc finish_seqdef {args} {
        internal::read_args $args
        
        variable seqdef_data
        variable seqdef_name
        variable sequence
        variable sequence_name
        
        set fp [open $seqdef_name w]
        foreach line $seqdef_data {
            puts $fp $line
        }
        puts $fp "\]  Define_Sequence $sequence_name $sequence;"
        close $fp
    }

    proc update_seqdef {args} {
        internal::read_args $args
        
        # Prepare seqdef to write additional events at end, finish_seqdef needed after
        # Assumes there is only one Define_Sequence in file
        variable seqdef_data
        variable seqdef_name
        variable sequence
        variable sequence_name

        set seqdef_name $seqdef
        set seqdef_data {}
        set fp [open $seqdef r]

        while {[gets $fp line]>=0} {
            if {[regexp {\[\s*Define_Sequence\s+(\S+)} $line -> name]} {
                set sequence_name $name
                if {[regexp {\[\s*Define_Sequence\s+\S+\s+([0-9]+)} $line -> sequence_num]} {
                    set sequence $sequence_num
                } else {
                    # Set sequence to 1 to make things easier
                    regsub $sequence_name $line "$sequence_name 1" line
                    set sequence 1
                }
            } elseif {[regexp {\]\s*Define_Sequence} $line]} {
                break
            } elseif {[regexp {Event\s+([0-9.]+)} $line -> odometer]} {
                set pattern [expr [lindex [split $odometer "."] end-1] + 1]
            }
            lappend seqdef_data $line
        }
        close $fp

        if {[info exists pattern]} {
            internal::set_pattern $pattern
        }
    }

    proc add_pi_event {args} {
        internal::read_args $args
        
        if {$value ni {1 0 Z}} {
            error "Value has to be 1, 0 or Z"
        }
        
        internal::add_pattern
        internal::add_stim_pi [list [list $pin $value]]
        internal::finish_pattern
    }

    proc create_mda_init {args} {
        internal::read_args $args

        variable port_alias
        variable Tpll
        
        # 12.5 MHz to not scale vectors
        internal::add_pattern
        internal::add_start_osc [dict get $port_alias refclk] 40.0 40.0
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_stim_pi [list [list [dict get $port_alias refrstn] 0] \
                                   [list [dict get $port_alias jtag_reset] 1] {mda_tdi 0}]
        if {!$simple} {
            internal::add_stim_pi {{pll_ctrl_valid 0}}
        } else {
            set half [expr $Tpll / 2000.0]
            internal::add_start_osc [dict get $port_alias clk_i] $half $half 0
        }
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_wait_osc [dict get $port_alias refclk] 10
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_stim_pi [list [list [dict get $port_alias refrstn] 1]]
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_wait_osc [dict get $port_alias refclk] 10
        internal::finish_pattern

        if {$simple} {return}
        
        internal::add_pattern
        internal::add_stim_pi {{pll_ctrl_valid 1}}
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_wait_osc [dict get $port_alias refclk] 10000
        internal::finish_pattern
    }

    # For jtag init in cores
    proc create_mbist_init {args} {
        internal::read_args $args

        variable port_alias
        variable Tpll
        
        internal::add_pattern
        internal::add_start_osc [dict get $port_alias jtag_tck] 40.0 40.0
        internal::finish_pattern

        set half [expr $Tpll / 2000.0]
        internal::add_pattern
        internal::add_start_osc [dict get $port_alias clk_i] $half $half 0
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_stim_pi [list [list [dict get $port_alias jtag_reset] 1]]
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_wait_osc [dict get $port_alias jtag_tck] 5
        internal::finish_pattern
        
        internal::add_pattern
        internal::add_stim_pi [list [list [dict get $port_alias jtag_reset] 0]]
        internal::finish_pattern
    }

    proc read_pinassign {args} {
        internal::read_args $args
        
        variable pinassign_data

        set pinassign_data {}
        if {!$reset} {
            set fp [open $pinassign r]
            foreach line [split [read $fp] \n] {
                lappend pinassign_data $line
            }
            close $fp
        }
    }

    proc write_pinassign {args} {
        internal::read_args $args
        
        variable pinassign_data
        
        set fp [open $pinassign w]
        foreach line $pinassign_data {
            puts $fp $line
        }
        close $fp
    }

    # Function can be multiple values, ie +SE,-TC
    proc add_test_function {args} {
        internal::read_args $args
        
        variable pinassign_data
        variable pinassign_regex
        
        # TODO value checking

        set i 0
        set found 0
        foreach line $pinassign_data {
            if {[regexp $pinassign_regex $line -> fpin functions]} {
                if {$fpin==$pin||[regsub -all {\"} $fpin {}]==$pin} {
                    set flist [split [join $functions ""] ","]
                    foreach func [split $function ","] {
                        set curr_found 0
                        if {$func in $flist} {
                            return
                        }

                        set ffunct [string range $func 1 end]
                        foreach f $flist {
                            if {$ffunct==[string range $f 1 end]} {
                                puts "Warning: replacing existing value of pin $pin function $func"
                                #regsub -- $f $line $func line
                                set line [string map [list $f $func] $line]
                                set found 1
                                set curr_found 1
                                break
                            }
                        }
                        if {$curr_found} {continue}

                        #regsub -- $functions $line "$functions,$func" line
                        set line [string map [list $functions $functions,$func] $line]
                        set found 1
                        continue
                    }
                    # Should only have one definition for pin
                    break
                }
            }
            incr i
        }
        
        if {$found==1} {
            set pinassign_data [lreplace $pinassign_data $i $i $line]
        } else {
            lappend pinassign_data "assign pin=$pin test_function=$function;"
        }
        set dummy 1
    }

    # Can use function with or without value, eg TC, -ES, oTI
    proc delete_test_function {args} {
        internal::read_args $args
        
        variable pinassign_data
        variable pinassign_regex

        set i 0
        set found 0
        foreach line $pinassign_data {
            if {[regexp -- $pinassign_regex $line -> fpin functions]} {
                if {$fpin==$pin||[regsub -all -- {\"} $fpin {}]==$pin} {
                    if {$function==0} {
                        set line ""
                        set found 1
                        break
                    }
                    
                    set flist [split [join $functions ""] ","]
                    if {$function in $flist} {
                        set new_functs [lsearch -inline -all -not -exact $flist $function]
                        set found 1
                    }
                    
                    set ffunct [string range $function 1 end]
                    foreach f $flist {
                        if {$ffunct==[string range $f 1 end]||$function==[string range $f 1 end]} {
                            set new_functs [lsearch -inline -all -not -exact $flist $f]
                            set found 1
                            break
                        }
                    }

                    if {$found==1} {
                        if {[llength $new_functs]} {
                            regsub -- [string map {+ \\+} $functions] $line [join $new_functs ,] line
                        } else {
                            set line ""
                        }
                        break
                    } else {
                        error "No $function defined for pin $pin"
                    }
                }
            }
            incr i
        }
        
        if {$found==0} {
            if {$quiet} {
                return 1
            }
            error "No pin $pin found"
        }
        
        if {$line==""} {
            set pinassign_data [lreplace $pinassign_data $i $i]
        } else {
            set pinassign_data [lreplace $pinassign_data $i $i $line]
        }
        set dummy 1
    }

    proc delete_all_by_function {args} {
        internal::read_args $args
        
        variable pinassign_data
        variable pinassign_regex

        foreach line $pinassign_data {
            if {[regexp -- $pinassign_regex $line -> fpin functions]} {
                if {[regexp $function $functions]} {
                    delete_test_function -pin $fpin -function $function
                }
            }
        }
    }

    proc calculate_pll_config {args} {
        internal::read_args $args
        
        variable R_div
        variable N_div
        variable M_div
        variable Tpll
        variable loop_ctrl

        set ref_freq 30e6
        set Fvco [expr $ref_freq * 2 * ($n+1) / ($r+1)]
        set Fpll [expr $Fvco / 2 / pow(2, $m)]
        set Tpll [expr int(1e12 / $Fpll)]

        set freq_bands {
            { 6.49e9 7.14e9 }
            { 6.17e9 6.84e9 }
            { 5.86e9 6.56e9 }
            { 5.54e9 6.27e9 }
            { 5.21e9 5.97e9 }
            { 4.86e9 5.66e9 }
            { 4.50e9 5.33e9 }
            { 4.13e9 4.99e9 }
            { 3.74e9 4.63e9 }
            { 3.33e9 4.26e9 }
            { 2.90e9 3.88e9 }
            { 2.45e9 3.48e9 }
            { 1.97e9 3.10e9 }
            { 1.67e9 2.70e9 }
            { 1.37e9 2.40e9 }
            { 1.07e9 2.10e9 }
        }
        
        set i 15
        foreach band $freq_bands {
            if {$Fvco > [lindex $band 0] && $Fvco < [lindex $band 1]} {
                set loop_val $i
                break
            }
            incr i -1
        }
        if {$i==-1} {
            error "Invalid pll config values"
        }
        
        set R_div [int_to_bin $r -pad 4]
        set N_div [int_to_bin $n -pad 10]
        set M_div [int_to_bin $m -pad 3]

        # 0:11 bits used to set LDO voltages, using recommended values 0xC, 0x4, 0x4
        # LSB first
        set loop_ctrl 001000100011[int_to_bin $loop_val -pad 4]
    }

    proc add_wir_bits {args} {
        internal::read_args $args

        variable wir_extra_bits

        set wir_extra_bits {*}$values
    }

    proc reset_wir_bits {args} {
        internal::read_args $args

        variable wir_extra_bits

        set wir_extra_bits {}
    }

    # jtag by default
    proc create_mbist_pinassign {args} {
        internal::read_args $args

        variable Tpll
        variable loop_ctrl
        variable R_div
        variable N_div
        variable M_div
        variable port_alias

        read_pinassign -reset
        if {!$mda} {
            if {$old} {
                add_test_function -pin [dict get $port_alias refclk] -function -OSC
                add_test_function -pin [dict get $port_alias jtag_tck] -function -TCK
                add_test_function -pin [dict get $port_alias jtag_tck] -function -ES
            } else {
                add_test_function -pin [dict get $port_alias jtag_tck] -function -OSC
            }
            add_test_function -pin [dict get $port_alias jtag_tdi] -function TDI
            if {!$simple} {
                add_test_function -pin [dict get $port_alias refclk] -function oTI
                add_test_function -pin jtag_amu_tdo -function TDO
                add_test_function -pin WRCK -function -SC
                add_test_function -pin ShiftWR -function -TI
                add_test_function -pin UpdateWR -function -TI
                add_test_function -pin WIR_SEL -function -TI
                add_test_function -pin WRSTN -function +TI
            } else {
                add_test_function -pin [dict get $port_alias clk_i] -function oTI
                # Can't control ema, don't care
                foreach port [get_db [get_db ports ema*] .name] {
                    add_test_function -pin $port -function -TI
                }
                foreach port [get_db [get_db ports {scan_enable* opcg_enable* scan_mode*}] .name] {
                    add_test_function -pin $port -function -TI
                }
                add_test_function -pin [dict get $port_alias refrstn] -function -TI
                add_test_function -pin [dict get $port_alias refclk] -function -TI
                foreach port [get_db ports jtag_*] {
                    if {[get_db $port .name] in [list [dict get $port_alias jtag_reset] \
                                                     [dict get $port_alias jtag_tck] \
                                                     [dict get $port_alias jtag_tdi]]} {
                        continue
                    }
                    add_test_function -pin [get_db $port .name] -function -TI
                }
            }
            add_test_function -pin retention_pause_continue -function -TI
            if {[llength [get_db ports mda_tdi]]} {
                foreach port [get_db ports {mda_mode mda_tdi}] {
                    add_test_function -pin [get_db $port .name] -function -TI
                }
            }
        } else {
            add_test_function -pin [dict get $port_alias refclk] -function -OSC
            
            foreach pin [get_db ports {scan_enable* opcg_load* scan_mode* WRCK ShiftWR \
                                           UpdateWR WIR_SEL WRSTN retention_pause_continue}] {
                add_test_function -pin [get_db $pin .name] -function -TI
            }
            foreach pin [list temmda_reset_sum] {
                add_test_function -pin $pin -function +TI
            }
            
            for {set i 0} {$i < [string length $ema]} {incr i} {
                if {[string index [string reverse $ema] $i]} {
                    add_test_function -pin ema_[get_db current_design .name][$i] -function +TI
                } else {
                    add_test_function -pin ema_[get_db current_design .name][$i] -function -TI
                }
            }
            # clk_ctrl is used as flag to tell this is a wrapper module
            # This is really bad but bit 3 should always be 1
            if {$clk_ctrl} {
                for {set i 0} {$i < 8} {incr i} {
                    if {$i==5} {
                        set func -TI
                    } else {
                        set func +TI
                    }
                    add_test_function -pin pll_enable[$i] -function $func
                }
                for {set i 0} {$i < [string length $loop_ctrl]} {incr i} {
                    if {[string index $loop_ctrl $i]} {
                        set func +TI
                    } else {
                        set func -TI
                    }
                    add_test_function -pin pll_loop_ctrl[$i] -function $func
                }
                for {set i 0} {$i < [string length $R_div$N_div$M_div]} {incr i} {
                    if {[string index $R_div$N_div$M_div $i]} {
                        set func +TI
                    } else {
                        set func -TI
                    }
                    add_test_function -pin pll_div_ctrl[$i] -function $func
                }
                for {set i 0} {$i < [string length $clk_ctrl]} {incr i} {
                    if {[string index [string reverse $clk_ctrl] $i]} {
                        set func +TI
                    } else {
                        set func -TI
                    }
                    add_test_function -pin clk_ctrl[$i] -function $func
                }
            } else {
                add_test_function -pin [dict get $port_alias clk_i] -function oTI
            }
            # This is a bit lazy but should be fine
            foreach port [get_db ports jtag_*] {
                if {[get_db $port .name]==[dict get $port_alias jtag_reset]} {
                    set func +TI
                } else {
                    set func -TI
                }
                add_test_function -pin [get_db $port .name] -function $func
            }
        }

        if {$file==""} {
            set file [get_db [get_db designs] .name].MBIST.jtag.pinassign
        }
        write_pinassign $file
    }

    proc create_pattern_control {args} {
        internal::read_args $args

        variable Tpll

        if {$outfile==0} {
            regsub {template} $infile $Tpll outfile
        }

        set fpr [open $infile r]
        set fpw [open $outfile w]
        while {[gets $fpr line]>=0} {
            regsub {(stclk.+?)[0-9]+02} $line \\1$Tpll line
            regsub {(stclk.+?)[0-9]+03} $line \\1[expr $Tpll * 2] line
            regsub {(stclk.+?)[0-9]+04} $line \\1[expr $Tpll * 3] line
            regsub {(stclk.+?)[0-9]+05} $line \\1[expr $Tpll * 4] line
            if {$testplans!=0} {
                if {[regexp {testplan_list\s*=(.*)} $line -> available_tps]} {
                    set used_tps {}
                    foreach tp $testplans {
                        if {$tp in $available_tps} {
                            lappend used_tps $tp
                        }
                    }
                    regsub {testplan_list\s*=(.*)} $line testplan_list=$used_tps line
                }
            }
            puts $fpw $line
        }
        close $fpr
        close $fpw
    }

    proc update_mbist_ports {args} {
        internal::read_args $args

        if {$jtag_tdi==0} {
            set jtag_tdi jtag_tdi
        }
        if {$jtag_reset==0} {
            set jtag_reset jtag_reset
        }

        set fp [open $file r]
        set orig_data [split [read $fp] \n]
        close $fp

        set fp [open $file w]
        foreach line $orig_data {
            regsub jtag_tdi $line $jtag_tdi line
            regsub jtag_reset $line $jtag_reset line
            puts $fp $line
        }
        close $fp
    }
    
    proc update_pll_pinassign {args} {
        internal::read_args $args
        
        variable R_div
        variable N_div
        variable M_div
        variable loop_ctrl

        array set conf_pins \
            [list \
                 JTAG_R_DIV $R_div \
                 JTAG_N_DIV $N_div \
                 JTAG_M_DIV $M_div \
                 JTAG_LOOP_CTRL $loop_ctrl \
                ]
        
        read_pinassign $pinassign
        
        foreach {pin val} [array get conf_pins] {
            for {set i 0} {$i<[string length $val]} {incr i} {
                if {[string index $val $i]=="0"} {
                    set logic -
                } elseif {[string index $val $i]=="1"} {
                    set logic +
                } else {
                    continue
                }
                add_test_function -pin ${pin}\[$i\] -function ${logic}TI
            }
        }
        
        write_pinassign $pinassign
    }

    proc int_to_bin {args} {
        internal::read_args $args
        
        set temp {}
        while {$value>0} {
            set temp $temp[expr $value % 2]
            set value [expr $value / 2]
        }
        set value $temp
        
        if {$pad!=0} {
            set zeros [string repeat 0 $pad]
            if {[string length $value]>$pad} {
                puts "Warning [lindex [info level 0] 0]: value is larger than defined with -pad. MSB(s) will be lost"
            }
            set value [string range $value$zeros 0 [expr $pad - 1]]
        }

        if {$msb_first==0} {
            return $value
        } else {
            return [string reverse $value]
        }
    }
    
    proc print_usage {args} {
        internal::read_args $args
        
        variable proc_opts
        foreach {p o} [array get proc_opts] {
            puts "$p $o"
        }
    }

    # TODO scan doesn't work, rtl issue
    proc create_custom_tdr {args} {
        internal::read_args $args
        
        set design [current_design]

        set read_opts {}

        if {$updatedr} {
            lappend read_opts -define UPDATEDR
        }
        if {$scan} {
            lappend read_opts -define SCAN
        }
        
        read_hdl -sv [get_db flow_source_directory]/../../dft/test_data_register.sv \
            {*}$read_opts

        elaborate -parameters $length \
            test_data_register

        set_top_module $design

        # TODO this is old syntax but new one can't instantiate design?
        create_inst -name ${name}_tdr [get_db designs test_data_register]

        delete_obj [get_db designs test_data_register]
        vcd

        puts "Created JTAG test data register $name"

        # TODO clockdr port is not created, there seems to a bug in modus where
        # having multiple scan interfaces in pdl will cause the clock of the
        # first one to be used to shift data of others. Due to this any
        # subsystem tdr clockdrs should be connected to WRCK
        if {$create_ports} {
            create_port_bus -input -name ${name}_shiftdr
            create_port_bus -input -name ${name}_decode
            create_port_bus -input -name ${name}_tdi
            create_port_bus -output -name ${name}_tdo

            connect [get_db ports ${name}_shiftdr] [get_db hpins ${name}/shiftdr]
            connect [get_db ports ${name}_decode] [get_db hpins ${name}/decode]
            connect [get_db ports ${name}_tdi] [get_db hpins ${name}/tdi]
            connect [get_db hpins ${name}/tdo] [get_db ports ${name}_tdo]

            connect 0 [get_db hpins ${name}/rst]

            if {$updatedr} {
                create_port_bus -input -name ${name}_updatedr
                connect [get_db ports ${name}_updatedr] [get_db hpins ${name}/updatedr]
            }
            
            if {$clockdr!="0"} {
                connect $clockdr [get_db hpins ${name}/clockdr]
            }

        }

        if {$scan} {
            connect [get_db $shift_enable .dft_hookup_pin] \
                [get_db hpins ${name}/scan_enable]
            
            connect [get_db $test_mode .dft_hookup_pin] \
                [get_db hpins ${name}/test_mode]
            
            connect [get_db $test_clock .dft_hookup_pin] \
                [get_db hpins ${name}/scan_clk]

            check_dft_rules
            
            define_scan_abstract_segment \
                -name ${name}_segment \
                -instance [get_db hinsts $name] \
                -sdi SI -sdo SO \
                -clock_port scan_clk -rise \
                -shift_enable_port scan_enable \
                -active high \
                -test_mode_port test_mode \
                -test_mode_active high \
                -length $length

            set insts [get_db [get_db hinsts $name] .insts -if {.lib_cells!=""}]
            set_db [get_db $insts -if {!.is_flop}] .preserve true
            set_db [get_db $insts -if {.is_latch}] .lp_clock_gating_exclude true

            define_test_clock -name ${name}_test_clock \
                -domain [get_db $test_clock .domain] \
                [get_db pins ${name}/scan_mux/Z]
            
        } else {
            set_db [get_db hinsts $name] .dft_dont_scan true
        }
        
        if {$generate_1687!=0} {
            set dir $generate_1687
            internal::create_tdr_icl $name $length $dir 1
            internal::create_tdr_pdl $name $length $dir 1
        }
    }

    proc read_icl {args} {
        internal::read_args $args

        variable icl_data
        variable icl_top
        set icl_data {}
        
        set fp [open $filename r]
        while {[gets $fp line]>=0} {
            lappend icl_data $line
        }
        close $fp

        # Top module assumed to be first
        foreach line $icl_data {
            if {[regexp {Module\s+([a-zA-Z0-9_]+)} $line -> name]} {
                set icl_top $name
                break
            }
        }
    }

    # This assumes that an instance with name filename of module module_name
    # is found on top level of icl to modify
    # Also assumes first module is top level
    # -check_names is modus only
    proc merge_icl {args} {
        internal::read_args $args

        variable icl_data

        set i 0
        set hierarchy 0
        set found 0
        foreach line $icl_data {
            if {[regexp \{ $line]} {
                incr hierarchy
                set found 1
            }
            if {[regexp \} $line]} {
                incr hierarchy -1
            }
            if {$found && $hierarchy==0} {
                break
            }
            incr i
        }
        
        set inport_types {TCKPort ResetPort UpdateEnPort SelectPort ShiftEnPort ScanInPort DataInPort}
        set inports {}
        set name [lindex [split [file tail $filename] .] 0]
        set fp [open $filename r]
        while {[gets $fp line]>=0} {
            lappend icl_data $line
            if {[regexp {Module\s+(\S+)\s+} $line -> module_name]} {continue}
            if {[regexp {\s*(\S+)\s+} $line -> type]} {
                if {$type in $inport_types} {
                    regexp {\s*\S+\s+([0-9a-zA-Z\-_]+)} $line -> port
                    lappend inports $port
                    set top_port ${name}_$port
                    if {$check_names} {
                        set top_port [get_db [internal::fanin $name.$port] .name]
                    }
                    regsub $port $line $top_port line
                    set icl_data [linsert $icl_data $i $line]
                    incr i
                } elseif {$type == "ScanOutPort"} {
                    regexp {ScanOutPort\s+([0-9a-zA-Z\-_]+)\s*\{\s*Source\s+([0-9a-zA-Z\-_\[\]]+)} $line -> port pin
                    regsub {\[} $pin {\\\0} pin
                    regsub {\]} $pin {\\\0} pin
                    regsub $pin $line $name.$port line
                    set top_port ${name}_$port
                    if {$check_names} {
                        set top_port [get_db [internal::fanout $name.$port] .name]
                    }
                    regsub $port $line $top_port line
                    set icl_data [linsert $icl_data $i $line]
                    incr i
                }
            }
        }
        close $fp
        set icl_data [linsert $icl_data $i {}]
        incr i

        set icl_data [linsert $icl_data $i "    Instance $name Of $module_name \{"]
        incr i
        foreach port $inports {
            set top_port ${name}_$port
            if {$check_names} {
                # TODO if this is needed at toplevel this can be pin
                set top_port [get_db [internal::fanin $name.$port] .name]
            }
            set icl_data [linsert $icl_data $i "        InputPort $port = $top_port;"]
            incr i
        }
        set icl_data [linsert $icl_data $i "    \}"]
        set dummy 1
    }

    # Can only add inputs
    proc add_icl_port {args} {
        internal::read_args $args

        variable icl_data

        set i 0
        set found 0
        set hierarchy 0
        set module_re [subst -nocommands -nobackslashes {Module\s+$module[\s|\{]}]
        foreach line $icl_data {
            if {[regexp {\{} $line]} {incr hierarchy}
            if {[regexp {\}} $line]} {incr hierarchy -1}
            incr i
            if {[regexp $module_re $line]} {
                set insert_line $i
                set found 1
            } elseif {$found} {
                if {$hierarchy==1} {
                    if {[regexp $port $line]} {
                        puts "Port $port already defined for module $module"
                        return
                    }
                } elseif {$hierarchy==0} {
                    set found 0
                }
            }
        }
        set port_decl "    $type $port;"
        set icl_data [linsert $icl_data $insert_line $port_decl]
        set dummy 1
    }

    # OPCG macro testmode ports are incorrectly generated. Fix to point to wir
    # TODO OPCGMODE is defined twice as SelectPort and DataInPort. Seems to work for now but could be fixed
    proc fix_icl_opcg_macro {args} {
        internal::read_args $args

        variable icl_data
        variable port_alias

        if {$old} {
            set sel_to_data {sel_test_mode sel_opcg_enable}
        } else {
            set sel_to_data {sel_test_mode}
        }
        set sel_to_data [join $sel_to_data "|"]

        # Only 1 test_mode port can be defined due to this
        set i 0
        set re [subst -nobackslashes -nocommands {ToSelectPort\s+($sel_to_data)(.+)}]
        foreach line $icl_data {
            if {[regsub {(TESTMODE\s*=\s*)[a-zA-Z0-9\._]+} $line \\1wir_instance.sel_test_mode line]} {
                set icl_data [lreplace $icl_data $i $i $line]
            } elseif {[regexp $re $line -> port end]} {
                # Not like above due to {} in line
                set line "    DataOutPort $port $end"
                set icl_data [lreplace $icl_data $i $i $line]
            }
            incr i
        }

        if {$check_ports} {
            # Find ports of instances
            set ports {}
            set found 0
            set i -1
            foreach line $icl_data {
                incr i
                if {[regexp {Instance\s+([a-zA-Z0-9_]+)\s+Of\s+([a-zA-Z0-9_]+)} $line -> inst module]} {
                    set found 1
                } elseif {$found} {
                    # Hopefully clean names, [] not checked
                    if {[regexp {InputPort\s+([a-zA-Z0-9_]+)\s*=\s*([a-zA-Z0-9_\.]*)} $line -> iport tport]} {
                        # Signals from other modules assumed fine
                        if {[regexp {\.} $tport]} {continue}
                        if {[regexp {JTAG_INSTRUCTION_DECODE} $tport]} {continue}
                        if {$tport=="" && $iport=="PGMCLK"} {
                            # Program clock missing pin as tricks done in genus
                            regsub {=} $line "=[dict get $port_alias jtag_tck]" line
                            set icl_data [lreplace $icl_data $i $i $line]
                            continue
                        } elseif {$tport=="" && $iport=="PGMSI"} {
                            set fi [internal::fanin $inst.$iport]
                            set tport [get_db [lsearch -inline -regexp $fi scan_in] .name]
                            regsub {=} $line "=$tport" line
                            set icl_data [lreplace $icl_data $i $i $line]
                        }
                        dict set ports $module $iport $tport
                    } elseif {[regexp {\}} $line]} {
                        set found 0
                    }
                }
            }

            variable icl_top
            # Create ports for topmodule that feed instances
            # Remove invalid port statements
            set found 0
            set i 0
            foreach line $icl_data {
                if {[regexp {Module\s+([a-zA-Z0-9_]+)} $line -> module]} {
                    if {$module ni [dict keys $ports]} {
                        puts "Nothing to fix for module $module"
                        set found 0
                    } else {
                        set found 1
                    }
                } elseif {$found} {
                    if {[regexp {([a-zA-Z0-9_]+)\s+([a-zA-Z0-9_]+)} $line -> type port]} {
                        if {$port in [dict keys [dict get $ports $module]]} {
                            add_icl_port [dict get $ports $module $port] -type $type -module $icl_top
                        }
                    } elseif {[regexp {\}} $line]} {
                        set found 0
                    }
                } elseif {[regexp {Port\s+;} $line]} {
                    set icl_data [lreplace $icl_data $i $i ""]
                } elseif {[regexp ScanOutPort $line] && [llength [set dummy $line]]==2} {
                    set icl_data [lreplace $icl_data $i $i ""]
                }
                
                incr i  
            }
        }
    }

    proc fix_icl_jtag {args} {
        internal::read_args $args

        variable icl_data
        variable port_alias

        if {!$mbist} {
            set i 0
            foreach line $icl_data {
                if {[regexp {ResetPort\s+pad_trst} $line]} {
                    set line "    TRSTPort pad_trst;"
                } elseif {[regexp {DataInPort\s+pad_tms} $line]} {
                    set line "    TMSPort pad_tms;"
                } elseif {[regexp {DataInPort\s+pad_tdi} $line]} {
                    set line "    ScanInPort pad_tdi;"
                } elseif {[regexp {DataInPort\s+pad_tck} $line]} {
                    set line "    TCKPort pad_tck;"
                } else {
                    incr i
                    continue
                }
                set icl_data [lreplace $icl_data $i $i $line]
                incr i
            }
        } else {
            # Some (all?) of these are not really needed
            variable icl_top
            add_icl_port [dict get $port_alias jtag_reset] -type DataInPort -module $icl_top
            add_icl_port jtag_runidle -type DataInPort -module $icl_top
            add_icl_port jtag_shiftdr -type DataInPort -module $icl_top
            add_icl_port jtag_updatedr -type DataInPort -module $icl_top
            add_icl_port jtag_capturedr -type DataInPort -module $icl_top
            add_icl_port [dict get $port_alias jtag_tdi] -type DataInPort -module $icl_top
            add_icl_port retention_pause_continue -type DataInPort -module $icl_top
            foreach decode [get_db [get_db ports jtag_instruction_decode*] .name] {
                add_icl_port $decode -type DataInPort -module $icl_top
            }

            if {$old} {
                # Scaling with correct refclk frequency causes miscompares
                # Not really jtag related
                set i 0
                foreach line $icl_data {
                    if {[regexp OSC_UPTIME $line]} {
                        regsub {[0-9\.]+} $line 40000 line
                        set icl_data [lreplace $icl_data $i $i $line]
                    } elseif {[regexp OSC_PERIOD $line]} {
                        regsub {[0-9\.]+} $line 80000 line
                        set icl_data [lreplace $icl_data $i $i $line]
                    } elseif {[regexp OSC_PULSESPERCYCLE $line]} {
                        # Shouldn't have other oscillators
                        set line [regsub {\d+} $line 0]
                        set icl_data [lreplace $icl_data $i $i $line]
                    }
                    incr i
                }
            } else {
                # Modus 21 needs jtag tck as -OSC, can have refclk as oTI
                set tck [dict get $port_alias jtag_tck]
                set re [subst -nobackslash {TCKPort\s$tck}]
                set i 0
                foreach line $icl_data {
                    if {[regexp $re $line]} {
                        set icl_data [lreplace $icl_data $i $i "    ClockPort $tck \{"]
                        set icl_data [linsert $icl_data [incr i] "        Attribute OSC_UPTIME = \"40000 ps\";"]
                        set icl_data [linsert $icl_data [incr i] "        Attribute OSC_PULSESPERCYCLE = \"1\";"]
                        set icl_data [linsert $icl_data [incr i] "        Attribute OSC_POLARITY = \"+\";"]
                        set icl_data [linsert $icl_data [incr i] "        Attribute OSC_PERIOD = \"80000 ps\";"]
                        set icl_data [linsert $icl_data [incr i] "    \}"]
                    } elseif {[regexp OSC_PULSESPERCYCLE $line]} {
                        # Shouldn't have other oscillators
                        set line [regsub {\d+} $line 0]
                        set icl_data [lreplace $icl_data $i $i $line]
                    }
                    incr i
                }
            }
        }
    }

    proc write_icl {args} {
        internal::read_args $args

        variable icl_data
        
        set fp [open $filename w]
        foreach line $icl_data {
            puts $fp $line
        }
        close $fp
    }
    
    
    proc read_pdl {args} {
        internal::read_args $args

        variable pdl_data
        variable pdl_top
        set pdl_data {}

        if {!$reset} {
            set fp [open $filename r]
            while {[gets $fp line]>=0} {
                lappend pdl_data $line
            }
            close $fp
        }
        set pdl_top $top
        
    }

    # Merges file to pdl_data
    proc merge_pdl {args} {
        internal::read_args $args

        variable pdl_data
        variable pdl_top
        
        set fp [open $filename r]
        while {[gets $fp line]>=0} {
            # if {[regexp {iProcsForModule\s+([a-zA-Z0-9_]+)} $line -> module_name]} {
            #     regsub $module_name $line ${pdl_top}_$module_name line
            # }
            lappend pdl_data $line
        }
        close $fp
        set dummy 1
    }

    proc fix_pdl_top {args} {
        internal::read_args $args

        variable pdl_data
        variable pdl_top

        set i 0
        foreach line $pdl_data {
            # TODO use proc below
            if {[regexp jtag_dft_disable $line]} {
                regsub {1} $line 0 line
                set pdl_data [lreplace $pdl_data $i $i $line]
            }
            incr i
        }
    }

    # TODO sets for all modes
    proc set_pdl_wir_bits {args} {
        internal::read_args $args

        variable pdl_data
        variable wir_extra_bits

        set wir_bits $wir_extra_bits
        
        set iproc_regex {iProc\s+Load\S+}
        
        set i 0
        set iproc_found 0
        foreach line $pdl_data {
            # Change wir values
            if {[regexp $iproc_regex $line]} {
                set iproc_found 1
            } elseif {$iproc_found} {
                foreach {bit val} $wir_bits {
                    if {[regexp $bit $line]} {
                        regsub {(iCall\s+Set.+\s)[01]} $line \\1$val line
                        set pdl_data [lreplace $pdl_data $i $i $line]
                    }
                }
                if {[regexp \} $line]} {
                    # Fails if there are lists made with {}
                    set iproc_found 0
                }
            }
            incr i
        }
    }
    
    # TODO sets for all modes
    proc set_pdl_ports {args} {
        internal::read_args $args

        variable pdl_data
        
        set iproc_regex {iProc\s+Load\S+ports}
        
        set i 0
        set iproc_found 0
        foreach line $pdl_data {
            # Change wir values
            if {[regexp $iproc_regex $line]} {
                set iproc_found 1
            } elseif {$iproc_found} {
                if {[regexp $port $line]} {
                    regsub {(iCall\s+Set.+\s)[01]} $line \\1$val line
                    set pdl_data [lreplace $pdl_data $i $i $line]
                }
                if {[regexp \} $line]} {
                    # Fails if there are lists made with {}
                    set iproc_found 0
                }
            }
            incr i
        }
    }

    proc remove_icall {args} {
        internal::read_args $args

        variable pdl_data
        
        set iproc_regex {iProc\s+Load\S+ports}
        
        set i 0
        set iproc_found 0
        foreach line $pdl_data {
            # Change wir values
            if {[regexp $iproc_regex $line]} {
                set iproc_found 1
            } elseif {$iproc_found} {
                if {[regexp $icall $line]} {
                    set pdl_data [lreplace $pdl_data $i $i]
                    incr i -1
                }
                if {[regexp \} $line]} {
                    # Fails if there are lists made with {}
                    set iproc_found 0
                }
            }
            incr i
        }
    }
    
    
    proc update_pll_pdl {args} {
        internal::read_args $args

        variable pdl_data
        variable N_div
        variable M_div
        variable R_div
        variable loop_ctrl
        variable wir_extra_bits

        foreach conf {N_div M_div R_div loop_ctrl} {
            for {set i 0} {$i < [string length [set $conf]]} {incr i} {
                lappend wir_extra_bits [string toupper $conf]_$i [string index [set $conf] $i]
            }
        }

        if {$mbist} {
            if {$old} {
                add_pdl_iprocs -mbist -old
            } else {
                add_pdl_iprocs -mbist
            }
        }
        set wait_cycles 17000

        set osc_found 0
        set i 0
        foreach line $pdl_data {
            # Set wait_osc cycles
            if {[regexp WaitOsc $line]} {
                set osc_found 1
            } elseif {$osc_found} {
                if {[regexp \} $line]} {
                    set osc_found 0
                }
                set pdl_data [lreplace $pdl_data $i $i [regsub -all {[0-9]+} $line $wait_cycles]]
            }
            incr i
        }
        set_pdl_wir_bits
    }

    proc add_pdl_iprocs {args} {
        internal::read_args $args

        variable pdl_data
        variable pdl_top
        variable port_alias
        variable Tpll

        lappend pdl_data "iProcsForModule $pdl_top;"

        if {$mbist} {
            if {!$top} {
                # Create top pdl function and use bypass
                # Dont iCall StartOsc as it contains ppis, all blocks should have refclk
                lappend pdl_data "iProc LoadMBIST_ports \{ \} \{"
                foreach decode [get_db [get_db ports jtag_instruction_decode*] .name] {
                    lappend pdl_data "    iWrite $decode 0;"
                }
                lappend pdl_data "    iWrite retention_pause_continue 0;"
                lappend pdl_data "    iWrite jtag_runidle 0;"
                lappend pdl_data "    iWrite jtag_shiftdr 0;"
                lappend pdl_data "    iWrite jtag_updatedr 0;"
                lappend pdl_data "    iWrite jtag_runidle 0;"
                lappend pdl_data "    iWrite [dict get $port_alias jtag_tdi] 0;"
                lappend pdl_data "\}"
                lappend pdl_data ""
                lappend pdl_data "iProc SetMBIST_$Tpll \{ \} \{"
                lappend pdl_data "    iCall WRAPPER_RESET;"
                lappend pdl_data "    iCall LoadBYPASS;"
                lappend pdl_data "    iApply;"
                lappend pdl_data "    iCall LoadBYPASS_ports;"
                lappend pdl_data "    iApply;"
                lappend pdl_data "    iClock [dict get $port_alias refclk];"
                if {!$old} {
                    lappend pdl_data "    iClock [dict get $port_alias jtag_tck];"
                }
                lappend pdl_data "    iWrite [dict get $port_alias refrstn] 0;"
                lappend pdl_data "    iWrite [dict get $port_alias jtag_reset] 1;"
                lappend pdl_data "    iCall LoadMBIST_ports;"
                lappend pdl_data "    iApply;"
                lappend pdl_data "    iRunLoop -sck [dict get $port_alias refclk] 5;"
                lappend pdl_data "    iWrite [dict get $port_alias refrstn] 1;"
                lappend pdl_data "    iWrite [dict get $port_alias jtag_reset] 0;"
                lappend pdl_data "    iApply;"
                lappend pdl_data "    iCall WaitOsc;"
                lappend pdl_data "\}"
            } else {
                
                lappend pdl_data "iProc SetMBIST_$Tpll \{"
                #lappend pdl_data "    iWrite [dict get $port_alias refrstn] 0;"
                #lappend pdl_data "    iApply;"
                #lappend pdl_data "    iWrite [dict get $port_alias refrstn] 1;"
                #lappend pdl_data "    iApply;"
                lappend pdl_data "    iCall LoadINIT_TS_ports;"
                lappend pdl_data "    iApply;"
                #lappend pdl_data "    iClock [dict get $port_alias refclk];"
                #lappend pdl_data "    iApply;"
                foreach c [get_db [get_db [get_db designs] .local_hinsts] .core_instance.name] {
                    lappend pdl_data "    iCall $c.LoadBYPASS;"
                }
                lappend pdl_data "    iCall wir_instance.LoadINIT_TS;"
                lappend pdl_data "    iApply;"
                #lappend pdl_data "    iClock [dict get $port_alias jtag_tck];"
                #lappend pdl_data "    iRunLoop -sck [dict get $port_alias refclk] 17000;"
                lappend pdl_data "\}"
                lappend pdl_data ""
            }
        } elseif {$top} {
            # dft disable gets wrong value for some reason, maybe wrong place to fix it
            set i 0
            set iproc_regex {iProc\s+LoadINIT_TSports}
            set iproc_found 0
            foreach line $pdl_data {
                if {[regexp $iproc_regex $line]} {
                    set iproc_found 1
                } elseif {$iproc_found} {
                    if {[regexp {jtag_dft_disable} $line]} {
                        regsub {1} $line 0 line
                        set pdl_data [lreplace $pdl_data $i $i $line]
                        break
                    }
                }
                incr i
            }

        } elseif {$testmode!=""} {
            set cores [get_db [get_db [get_db designs] .local_hinsts] .core_instance.name]

            lappend pdl_data "iProc $testmode \{"
            lappend pdl_data "    iCall LoadINIT_TS_ports;"
            lappend pdl_data "    iApply;"
            #lappend pdl_data "    iReset;"
            if {[regexp {OPCG|MBIST} $testmode]} {
                lappend pdl_data "    iCall StartOsc;"
                lappend pdl_data "    iApply;"
                #lappend pdl_data "    iCall func_reset;"
                #lappend pdl_data "    iApply;"
            }

            # Note LoadTESTMODE used here also for cores. Could be an issue
            # Also kind of hidden but EXTEST_OPCG uses EXTEST testmodes, shouldn't change names
            if {$core==0} {
                set core_mode [regsub EXTEST_OPCG $testmode EXTEST]
            } else {
                set core_mode BYPASS
            }
            foreach c $cores {
                if {$c==$core} {
                    lappend pdl_data "    iCall $c.Load$testmode;"
                } else {
                    lappend pdl_data "    iCall $c.Load$core_mode;"
                }
            }
            lappend pdl_data "    iCall wir_instance.Load$testmode;"
            lappend pdl_data "    iApply;"
            
            if {[regexp {OPCG|MBIST} $testmode]} {
                lappend pdl_data "    iCall WaitOsc;"
            }
            lappend pdl_data "\}"
        }
        
        set dummy 1
    }

    # Add reset for opcg modes
    proc add_pdl_func_reset {args} {
        internal::read_args $args

        variable pdl_data
        variable pdl_top
        variable port_alias

        set load_found 0
        set set_found 0
        set i 0
        foreach line $pdl_data {
            if {[regexp {iProc\s+Load.+OPCG_ports} $line]} {
                set load_found 1
            } elseif {$load_found} {
                if {[regexp refrstn $line]} {
                    regsub {\d+} $line 0 line
                }
                set pdl_data [lreplace $pdl_data $i $i $line]
                if {[regexp {\}} $line]} {
                    set load_found 0
                }
            } elseif {[regexp {iProc\s+Set.+OPCG} $line]} {
                set set_found 1
            } elseif {$set_found} {
                if {[regexp {\}} $line]} {
                    set set_found 0
                    set pdl_data [linsert $pdl_data $i "    iCall release_reset;"]
                    incr i
                }
            }
            incr i
        }
        lappend pdl_data "iProcsForModule $pdl_top;"
        lappend pdl_data "iProc release_reset \{\} \{"
        lappend pdl_data "    iWrite refrstn 1;"
        lappend pdl_data "    iApply;"
        lappend pdl_data "    iRunLoop -sck [dict get $port_alias refclk] 10;"
        lappend pdl_data "\}"
        set dummy 1
    }

    # Add delay cycles to allow power gate enables to propagate
    proc add_prop_cycles {args} {
        internal::read_args $args

        variable port_alias

        if {!$wait_osc} {
            internal::add_pattern begin_loop
            internal::add_repeat $cycles
            internal::finish_pattern
            internal::add_pattern
            internal::add_pulse [dict get $port_alias jtag_tck]
            internal::finish_pattern
            internal::add_pattern end_loop
            internal::finish_pattern
        } else {
            internal::add_pattern
            internal::add_wait_osc [dict get $port_alias jtag_tck] $cycles
            internal::finish_pattern
        }
    }
    
    
    proc write_pdl {args} {
        internal::read_args $args

        variable pdl_data

        set fp [open $filename w]
        foreach line $pdl_data {
            puts $fp $line
        }
        close $fp
    }

    # Special cases are probably if width is not divisible by 4
    proc generate_cdns_memory_view {args} {
        internal::read_args $args

        if {$file==""} {
            set file pmbist/[get_db flow_vars_design_name]_cdns_memory_view.txt
        }

        if {$append} {
            set fpw [open $file a]
        } else {
            set fpw [open $file w]
        }

        variable mbist_local_config

        foreach mem {*}$memory_list {
            # Assumes input is list of lib_cells
            set mem_lib_cell $mem
            set mem [get_db [get_db lib_cells *$mem] .base_name]
            if {![regexp {(.+)_([0-9]+)x([0-9]+)_(LL_|HP_|)M([0-9]+)(W*)(B*)((?:_PG)*)((?:_R)*)} \
                      [lindex [split $mem /] end] -> type words width mvt mux wt mask pg redundancy]} {
                error "Memory name $mem not matched to regex"
            }
            set no_action {ret1n dftrambyp}
            set tie_hi {}
            set tie_lo {}
            set port_alias {}
            if {$type=="RF_2P_HD_SVT"} {
                lappend no_action emaa emab emasa
                lappend no_action sea seb
                lappend no_action sia sib
                lappend no_action soa sob
                lappend no_action stov
                if {$mask=="B"} {
                    lappend port_alias wemn wenb
                    lappend port_alias twemn twenb
                }
                # chip enable used as write enable
                lappend port_alias wen cenb
                lappend port_alias twen tcenb
                
            } elseif {$type=="RF_SP_HD_SVT"} {
                lappend no_action ema emaw emas
                lappend no_action se si so
                if {$mask=="B"} {
                    lappend port_alias wemn wen
                    lappend port_alias twemn twen
                    lappend port_alias wen gwen
                    lappend port_alias twen tgwen
                    lappend port_alias weny gweny
                }
                
            } elseif {$type=="DP_HD_SVT"} {
                puts "Warning: generation for this type is untested"
                # TODO as aliases are for both ports might need .1 .2
                lappend no_action emaa emawa emasa
                lappend no_action emab emawb emasb
                lappend tie_lo colldisn
                if {$mask=="B"} {
                    lappend port_alias wemn wena
                    lappend port_alias twemn twena
                    lappend port_alias wemn wenb
                    lappend port_alias twemn twenb
                }
                lappend port_alias wen gwena
                lappend port_alias twen tgwena
                lappend port_alias wen gwenb
                lappend port_alias twen tgwenb
                
            } elseif {$type=="SP_UHD_SVT"} {
                lappend no_action ema emaw emas
                lappend no_action se si so 
                lappend no_action stov
                if {$mask=="B"} {
                    lappend port_alias wemn wen
                    lappend port_alias twemn twen
                }
                # Unlike RF_SP gwen is used even without mask
                lappend port_alias wen gwen
                lappend port_alias twen tgwen
                lappend port_alias weny gweny
            } else {
                error "Pins not defined for type $type"
            }
            
            if {$pg!=""} {
                lappend no_action ret2n prdyn pgen
            }
            if {$redundancy!=""} {
                lappend port_alias cre cre1
                lappend port_alias cre cre2
                lappend port_alias cra fca1
                lappend port_alias cra fca2
            }
            dict lappend mbist_local_config $mem mask $mask
            dict lappend mbist_local_config $mem redundancy $redundancy
            
            # Address partition copied from .memlib mentor model
            set columns {}
            set rows {}
            set banks {}
            set fpr [open $source_directory/$mem/$mem.memlib r]
            set found 0
            while {[gets $fpr line]>=0} {
                if {[regexp {LogicalAddressMap} $line]} {set found 1}
                if {$found} {
                    if {[regexp {ColumnAddress.+:.+\[([0-9:]+)} $line -> column]} {
                        lappend columns $column
                    } elseif {[regexp {RowAddress.+:.+\[([0-9:]+)} $line -> row]} {
                        lappend rows $row
                    } elseif {[regexp {BankAddress.+:.+\[([0-9:]+)} $line -> bank]} {
                        lappend banks $bank
                    } elseif {[regexp {\}} $line]} {
                        break
                    }
                }
            }
            close $fpr

            set columns [lsort -decreasing $columns]
            set rows [lsort -decreasing $rows]
            set banks [lsort -decreasing $banks]
            
            foreach addr {columns rows banks} {
                set temp {}
                set val [set $addr]
                # Very dirty but if address goes to double digits it probably should be reversed (TODO not always)
                if {[string length [lindex [split [lindex $val end] :] 0]]>1} {
                    set val [lsort $val]
                }
                set temp [lindex $val 0]
                for {set i 1; set j 0} {$i < [llength $val]} {incr i} {
                    if {[lindex [split [lindex $temp $j] :] end]==[expr [lindex $val $i] + 1]} {
                        lset temp $j [lindex [split [lindex $temp $j] :] 0]:[lindex $val $i]
                    } else {
                        lappend temp [lindex $val $i]
                        incr j
                    }
                }
                set $addr $temp
            }
                

            set row_order {}
            set bank_order {}
            set column_order {}
            # Reverse order for half of mem
            set mux_values {}
            for {set i 0} {$i<$mux} {incr i} {lappend mux_values $i}
            lappend column_order order [list data 0:[expr $width/2-1]] [lreverse $mux_values]
            lappend column_order order [list data [expr $width/2]:[expr $width - 1]] $mux_values
            # These are special cases for redundancy, supposedly physical layout has to be different as well
            if {$width in {18 142 22 74 146}} {
                set column_order {}
                lappend column_order order [list data 0:[expr $width/2-2]] [lreverse $mux_values]
                lappend column_order order [list data [expr $width/2-1]:[expr $width - 1]] $mux_values
            }
            
            puts $fpw "\{"
            puts $fpw "  module \{ $mem_lib_cell \}"
            puts $fpw "  \{"
            puts $fpw "    address_limit $words"
            puts $fpw "    "
            puts $fpw "    read_delay 2"
            puts $fpw "    "
            puts $fpw "    port_action"
            puts $fpw "    \{"
            foreach na $no_action {
                puts $fpw "      $na x"
            }
            foreach hi $tie_hi {
                puts $fpw "      $hi 1"
            }
            foreach lo $tie_lo {
                puts $fpw "      $lo 0"
            }
            puts $fpw "    \}"
            puts $fpw "    "
            puts $fpw "    port_alias"
            puts $fpw "    \{"
            foreach {pin alias} $port_alias {
                puts $fpw "      $pin $alias"
            }
            puts $fpw "    \}"
            puts $fpw "    "
            puts $fpw "    address_partition"
            puts $fpw "    \{"
            puts $fpw "      column $columns $column_order"
            puts $fpw "      row $rows $row_order"
            if {[llength $banks]} {
                puts $fpw "      bank $banks $bank_order"
            }
            puts $fpw "    \}"
            if {$redundancy!=""} {
                puts $fpw "    "
                puts $fpw "    redundancy \{"
                set data_l "\{[expr $width/2 - 1]:0\}"
                set data_h "\{[expr $width - 1]:[expr $width/2]\}"
                set map_l "\{enable cre1 data 0:[expr $width/2 - 1] fca1\[[expr int(ceil(log($width/2)/log(2))) - 1]:0\] shift_right_integer\}"
                set map_h "\{enable cre2 data 0:[expr $width/2 - 1] fca2\[[expr int(ceil(log($width/2)/log(2))) - 1]:0\] shift_left_integer\}"
                # Known special cases
                if {$width==18} {
                    set data_l "\{7:0\}"
                    set data_h "\{17:8\}"
                    set map_l "\{enable cre1 data 0:7 fca1\[2:0\] shift_right_integer\}"
                    set map_h "\{enable cre2 data 0:9 fca2\[3:0\] shift_left_integer\}"
                } elseif {$width==142} {
                    set data_l "\{69:0\}"
                    set data_h "\{141:70\}"
                    set map_l "\{enable cre1 data 0:69 fca1\[6:0\] shift_right_integer\}"
                    set map_h "\{enable cre2 data 0:71 fca2\[6:0\] shift_left_integer\}"
                } elseif {$width==22} {
                    set data_l "\{9:0\}"
                    set data_h "\{21:10\}"
                    set map_l "\{enable cre1 data 0:9 fca1\[3:0\] shift_right_integer\}"
                    set map_h "\{enable cre2 data 0:11 fca2\[3:0\] shift_left_integer\}"
                } elseif {$width==74} {
                    set data_l "\{35:0\}"
                    set data_h "\{73:36\}"
                    set map_l "\{enable cre1 data 0:35 fca1\[5:0\] shift_right_integer\}"
                    set map_h "\{enable cre2 data 0:37 fca2\[5:0\] shift_left_integer\}"
                } elseif {$width==146} {
                    set data_l "\{71:0\}"
                    set data_h "\{145:72\}"
                    set map_l "\{enable cre1 data 0:71 fca1\[6:0\] shift_right_integer\}"
                    set map_h "\{enable cre2 data 0:73 fca2\[6:0\] shift_left_integer\}"
                }
                puts $fpw "      column data $data_l"
                puts $fpw "      map $map_l"
                puts $fpw "      column data $data_h"
                puts $fpw "      map $map_h"
                puts $fpw "    \}"
            }
            puts $fpw "  \}"
            puts $fpw "\}"
            puts $fpw ""
        }
        close $fpw
    }

    proc reset_mbist_config {args} {
        internal::read_args $args

        variable mbist_config_data
        set mbist_config_data {}
    }

    proc add_mbist_config {args} {
        internal::read_args $args

        variable mbist_config_data
        variable mbist_config_testplans
        variable mbist_local_config

        set default_testplans {ptpn_march_ssp ptpn_cs_test ptpn_march_samio ptpn_march_rw_s2pf-}

        # mem can be a list of instances, sharing has to be defined for specific instances
        # if mem is memory cell sharing not possible
        # Also shared resources have to be for a single type of memory
        foreach mem {*}$memory_list {
            if {[llength [get_db insts $mem]]} {
                set mem_name [get_db -u [get_db insts $mem] .lib_cell.base_name]
                if {[llength $mem_name]!=1} {
                    error "Memories have to be of same type"
                }
            } else {
                set mem_name [get_db [get_db lib_cells [list $mem */$mem]] .base_name]
            }
            
            if {$ignore} {
                lappend mbist_config_data "\{"
                lappend mbist_config_data "  ignore \{"
                foreach m $mem {
                    lappend mbist_config_data "    $m"
                }
                lappend mbist_config_data "  \}"
                lappend mbist_config_data "\}"
                lappend mbist_config_data ""
                continue
            }
            set testplans $default_testplans
            if {[dict get $mbist_local_config $mem_name mask]=="B" && !$no_mask || $mask} {
                lappend testplans ptpn_write_mask_test
            }
            if {[dict get $mbist_local_config $mem_name redundancy]!=""} {
                lappend testplans enable_bira_accum px_move_bira_to_rru_disable_accum rerun_ptpn_march_ssp
            }
            
            set mbist_config_testplans [lsort -u [concat $mbist_config_testplans $testplans]]

            lappend mbist_config_data "\{"
            lappend mbist_config_data "  target"
            lappend mbist_config_data "  \{"
            foreach m $mem {
                lappend mbist_config_data "    $m"
            }
            lappend mbist_config_data "  \}"
            lappend mbist_config_data "  "
            lappend mbist_config_data "  \{"
            lappend mbist_config_data "    sharing_limit [llength $mem]"
            lappend mbist_config_data "    "
            lappend mbist_config_data "    location \{$location\}"
            lappend mbist_config_data "    "
            lappend mbist_config_data "    clock $clock"
            lappend mbist_config_data "    "
            if {$clock_mux} {
                lappend mbist_config_data "    clock_mux"
                lappend mbist_config_data "    "
            }
            lappend mbist_config_data "    testplans"
            lappend mbist_config_data "    \{"
            foreach tp $testplans {
                lappend mbist_config_data "      $tp"
            }
            lappend mbist_config_data "    \}"
            lappend mbist_config_data "    "
            lappend mbist_config_data "    failure_recording"
            lappend mbist_config_data "    \{"
            lappend mbist_config_data "      diagnostics \{none\}"
            if {$redundancy} {
                lappend mbist_config_data "      redundancy_analysis \{shared\}"
                if {$repair} {
                    if {$hard} {
                        lappend mbist_config_data "      self_repair \{soft enable_hri\}"
                    } else {
                        lappend mbist_config_data "      self_repair \{soft\}"
                    }
                }
            } else {
                lappend mbist_config_data "      redundancy_analysis \{none\}"
                lappend mbist_config_data "      self_repair \{none\}"
            }
            lappend mbist_config_data "      fault_tolerance \{none\}"
            lappend mbist_config_data "    \}"
            lappend mbist_config_data "    "
            lappend mbist_config_data "    interface_control"
            lappend mbist_config_data "    \{"
            lappend mbist_config_data "      outputs"
            lappend mbist_config_data "      \{"
            lappend mbist_config_data "        comparators"
            lappend mbist_config_data "        \{"
            lappend mbist_config_data "            engine_local"
            lappend mbist_config_data "            shared"
            lappend mbist_config_data "        \}"
            lappend mbist_config_data "        pipeline_stages $pipelines"
            lappend mbist_config_data "      \}"
            lappend mbist_config_data "      logic_test none"
            lappend mbist_config_data "    \}"
            lappend mbist_config_data "  \}"
            lappend mbist_config_data "\}"
            lappend mbist_config_data ""
        }
    }

    proc write_mbist_config {args} {
        internal::read_args $args

        variable mbist_config_data
        variable mbist_config_testplans
        variable mbist_available_testplans
        variable mbist_repair_testplans

        foreach tp $mbist_config_testplans {
            if {$tp in [dict keys $mbist_available_testplans] || [regsub rerun_ $tp {}] in $mbist_available_testplans} {
                set params [dict get $mbist_available_testplans [regsub rerun_ $tp {}]]
                lappend mbist_config_data "testplan"
                lappend mbist_config_data "\{"
                lappend mbist_config_data "  name $tp"
                lappend mbist_config_data "  address_orders \{[lindex $params 0]\}"
                lappend mbist_config_data "  address_updates \{[lindex $params 1]\}"
                lappend mbist_config_data "  data_backgrounds \{[lindex $params 2]\}"
                lappend mbist_config_data "  data_orientation [lindex $params 3]"
                lappend mbist_config_data "  algorithms \{[lindex $params 4]\}"
                lappend mbist_config_data "  [lindex $params 5]"
                lappend mbist_config_data "\}"
                lappend mbist_config_data ""
            } elseif {$tp in [dict keys $mbist_repair_testplans]} {
                lappend mbist_config_data "testplan"
                lappend mbist_config_data "\{"
                lappend mbist_config_data "  name $tp"
                lappend mbist_config_data "  address_orders \{nu\}"
                lappend mbist_config_data "  [dict get $mbist_repair_testplans $tp]"
                lappend mbist_config_data "  hardwired"
                lappend mbist_config_data "\}"
                lappend mbist_config_data ""
            }
        }
        # Hardwired algorithms
        lappend mbist_config_data "algorithm_constraints"
        lappend mbist_config_data "\{"
        lappend mbist_config_data "  log2b_limit 1"
        lappend mbist_config_data "\}"
        lappend mbist_config_data ""

        set fp [open $file w]
        foreach line $mbist_config_data {
            puts $fp $line
        }
        close $fp
    }

    # Read available testplans from test def
    proc get_mbist_testplans {args} {
        internal::read_args $args

        set ret {}
        set fp [open $file r]
        while {[gets $fp line]>=0} {
            if {[regexp {name\s+(.+)} $line -> name]} {
                if {$pattern!=0 && [string match $pattern $name] || $pattern==0} {
                    lappend ret $name
                }
            }
        }
        close $fp
        return $ret
    }

    # For some of the ports order of statements is important
    proc create_iospeclist {args} {
        internal::read_args $args

        set types {}

        upvar local_macro_exportdir local_macro_exportdir

        if {[llength [get_db boundary_scan_segments]]} {
            delete_obj [get_db boundary_scan_segments]
        }
        
        if {$disabled_segments==0} {
            set disabled_segments {}
        }
        
        foreach port [dict keys $order] {
            set type [get_db [get_db [get_db ports $port] .net.loads -if {.obj_type==pin}] .inst.base_cell.base_name]
            if {$type ni $types && $type!=""} {
                lappend types $type
            }
        }

        set bcell_types {in out inout clkin}
        set non_bcell_types {none low high segment tdi tms tck trst tdo}
        set jtag_types {tdi tms tck trst tdo}

        set fp [open $file w]
        puts $fp "TOP_MODULE_NAME = [get_db flow_vars_design_name]"
        puts $fp "BOUDARY_TYPE = IEEE_11491"
        puts $fp ""
        foreach type $types {
            if {[llength [get_db lib_pins *$type/C]]} {
                puts $fp "IOCELL_OUTPUT = $type/C"
            }
            if {[llength [get_db lib_pins *$type/OEN]]} {
                puts $fp "IOCELL_ENABLE = $type/!OEN"
            }
            if {[llength [get_db lib_pins *$type/I]]} {
                puts $fp "IOCELL_INPUT = $type/I"
            }
        }
        puts $fp ""
        
        foreach {port type} $order {
            if {$type ni $bcell_types && $type ni $non_bcell_types} {
                error "Invalid type $type for port $port"
            }

            if {$type!="segment"} {
                set inst [get_db [get_db [get_db ports $port] .net.loads -if {.obj_type==pin}] .inst.name]
                set cell [get_db [get_db insts $inst] .base_cell.base_name]
                if {[llength $cell]>1} {
                    puts "Warning: multidriven port $port, skipping"
                    set type none
                }
                puts $fp "$port \\"
                if {$type in $bcell_types} {
                    if {$type=="in"} {
                        set bcell_type BC_IN
                        set sys_use input
                    } elseif {$type=="out"} {
                        set bcell_type BC_OUT
                        set sys_use output3
                    } elseif {$type=="clkin"} {
                        set bcell_type BC_CLKIN
                        set sys_use clock
                    } elseif {$type=="inout"} {
                        set bcell_type BC_BIDIR
                        set sys_use bidir
                    }
                    
                    puts $fp "    bcell_type=$bcell_type \\"
                    puts $fp "    bcell_required=true \\"
                    puts $fp "    sys_use=$sys_use \\"
                    puts $fp "    cell=$cell \\"
                    if {$type=="in"||$type=="inout"} {
                        puts $fp "    bdy_in=$inst/C \\"
                    }
                    if {$type=="out"||$type=="inout"} {
                        puts $fp "    bdy_out=$inst/I \\"
                        puts $fp "    bdy_enable=$inst/OEN \\"
                        puts $fp "    sys_enable=$inst/OEN"
                        puts $fp ""
                        puts $fp "$inst/OEN bcell_type=BC_ENAB_NT \\"
                        puts $fp "    sys_use=enable \\"
                        puts $fp "    bcell_required=true"
                    }
                } else {
                    if {$type in $jtag_types} {
                        puts $fp "    bdy_use=$type \\"
                        puts $fp "    cell=$cell \\"
                    } else {
                        if {$type=="low"} {
                            puts $fp "    COMP_ENAB=0 \\"
                        } elseif {$type=="high"} {
                            puts $fp "    COMP_ENAB=1 \\"
                        }
                        puts $fp "    sys_use=none \\"
                    }
                    puts $fp "    bcell_required=false \\"
                }
                puts $fp ""
            } else {
                # Macros must be defined in local_macro_setup
                set name $port
                
                if {$name in $disabled_segments} {
                    puts "Warning: disabled reading segment $name and set port types to none"
                    set inst [get_db insts -if {.base_cell.base_name==$name}]
                    foreach port [get_db [get_db $inst .pins -if {.direction==inout}] .net.loads -if {.obj_type==port}] {
                        puts $fp "[get_db $port .name] sys_use=none bcell_required=false"
                    }
                    continue
                }
                if {$name ni [array names local_macro_exportdir]} {
                    error "Segment $name not in local_macro_exportdir"
                }
                set path $local_macro_exportdir($name)
                
                puts "Running define_boundary_scan_segment for $name"

                # Note: in old flows clockdr and updatedr were clocks, now they are clock enables and they will have to be reconnected
                # TODO go back to old way, it is better
                define_boundary_scan_segment \
                    -name ${name}_bscan_segment \
                    -lib_cell $name \
                    -tdi bscan_tdi \
                    -tdo bscan_tdo \
                    -mode_a bscan_mode_a \
                    -mode_b bscan_mode_b \
                    -mode_c bscan_mode_c \
                    -highz bscan_highz \
                    -clockdr bscan_clockdr_enable \
                    -shiftdr bscan_shiftdr \
                    -updatedr bscan_updatedr_enable \
                    -bsdl_file $path/jtag/$name.segment.bsdl
                lappend added_segments $name

                puts $fp "# Start of $name"
                # Read subsystem bscan configuration into toplevel file
                if {[file exists $path/jtag/iospeclist]} {
                    set seg_fp [open $path/jtag/iospeclist r]
                } else {
                    puts "Warning: using iospeclist from scripts"
                    set seg_fp [open $path/scripts/iospeclist r]
                }
                set ss_pins [get_db [get_db insts -if {.base_cell.base_name==$name}] .pins -if {.direction==inout}]
                while {![eof $seg_fp]} {
                    set line [gets $seg_fp]
                    set first [lindex [concat {*}[split $line]] 0]
                    
                    # = messes get_db
                    if {!($first=="" || [string match "*=*" $first])} {
                        set ss_pin [lsearch -regexp -inline $ss_pins [string map {\[ \\\[} [string map {\] \\\]} $first]]]
                        if {[llength $ss_pin]} {
                            # Name might be different in subsystem and top
                            set top_pin [get_db [get_db $ss_pin .net.loads -if {.obj_type==port}] .name]
                            puts $fp "$top_pin bcell_segment=${name}_bscan_segment"
                        }
                    }
                    
                }
                close $seg_fp
                puts $fp "# End of $name"
                puts $fp ""
            }
        }
        close $fp
    }

    proc update_opcg_cells {args} {
        internal::read_args $args

        set top [get_db [current_design] .name]
        
        read_hdl -library DFT -language v2001 [get_db flow_vars_dft_data_directory]/opcg_macro.v
        elaborate opcg_macro
        read_hdl -library DFT -language v2001 [get_db flow_vars_dft_data_directory]/opcg_trigger.v
        elaborate opcg_trigger
        
        #::legacy::set_attribute hdl_v2001 {{opcg_domain=1}{max_num_pulses=2}{counter_length=0}{domain_blocking=0}{los=0}} [::legacy::find / -$::nvs::subdesign opcg_macro]
        #::legacy::set_attribute hdl_v2001 {{opcg_trigger=1}{delay_cycles=5}} [::legacy::find / -$::nvs::subdesign opcg_trigger]

        foreach module {opcg_macro opcg_trigger} {
            set_top_module $module
            uniquify [current_design]
            if {$ulvt} {
                foreach inst [get_db insts -if {.lib_cell!=""}] {
                    change_link \
                        -instances $inst \
                        -base_cell [string map {LVT ULVT} [get_db $inst .base_cell.name]]
                }
            }
        }
        
        set_top_module $top

        set opcg_macros [get_db hinsts $macro]
        set opcg_trigs [get_db hinsts $trigger]

        change_link \
            -instances $opcg_macros \
            -design_name [get_db designs opcg_macro] \
            -copy_attributes
        change_link \
            -instances $opcg_trigs \
            -design_name [get_db designs opcg_trigger] \
            -copy_attributes
        
        set opcg_hinsts [get_db hinsts [concat $macro $trigger]]
        
        set insts [get_db $opcg_hinsts .insts -if {.lib_cell!=""}]
        set_db $insts .preserve true
        # Ungroup so that clock gates match genus inserted ones for sta
        ungroup -simple [get_db [get_db $insts -if {.is_latch}] .hinst]
        set_db [get_db $insts -if {.is_latch}] .lp_clock_gating_exclude true
        set_db [concat $opcg_hinsts [get_db $opcg_hinsts .hinsts]] .ungroup_ok false

        delete_obj [get_db designs {opcg_macro opcg_trigger}]
        vcd
    }

    proc create_memory_fault_file {args} {
        internal::read_args $args

        set fpw [open $file w]

        foreach mem [get_db insts -if {.is_memory}] {
            regexp {(\d+)x(\d+)} [get_db $mem .base_cell.base_name] -> address width
            set path [get_db flow_vars_design_name]_inst.[string map {/ .} [get_db $mem .name]].u1
            puts $fpw "deposit $path.add_fault.address 'd[expr int(rand()*$address)]"
            puts $fpw "deposit $path.add_fault.bitPlace 'd[expr int(rand()*$width)]"
            puts $fpw "deposit $path.add_fault.fault_type 'd[expr int(rand()*2)]"
            puts $fpw "deposit $path.add_fault.red_fault 'd0"
            puts $fpw "task $path.add_fault"
            puts $fpw ""
        }
        close $fpw

        # For new flow create faults in testbench, arguments as is to not require changes to flows
        set fpw [open [string map {.tcl .v} $file] w]
        puts $fpw "    `ifdef MEMORY_FAULTS"
        foreach mem [get_db insts -if {.is_memory}] {
            regexp {(\d+)x(\d+)} [get_db $mem .base_cell.base_name] -> address width
            set path [get_db flow_vars_design_name]_inst.[string map {/ .} [get_db $mem .name]].u1
            puts $fpw "        $path.add_fault('d[expr int(rand()*$address)], 'd[expr int(rand()*$width)], 'd[expr int(rand()*2)], 'd0);"
        }
        puts $fpw "    `endif"
        close $fpw
    }

    proc add_tb_memory_faults {args} {
        internal::read_args $args

        set inst $::env(MODULE_NAME)_inst

        set initial_found 0
        
        set fp [open $file r]
        set data [split [read $fp] \n]
        close $fp
        set fpw [open $file w]
        foreach line $data {
            # begin should be on line after initial
            puts $fpw $line
            if {[regexp initial $line]} {
                set initial_found 1
            } elseif {$initial_found} {
                set fpr [open $faults r]
                while {[gets $fpr line]>=0} {
                    puts $fpw $line
                }
                set initial_found 0
            }
        }
        close $fpw
    }


    # All clocks should be -, not checked
    proc generate_pinassign_genus {args} {
        internal::read_args $args

        read_pinassign -reset

        if {$extest} {
            set non_top_sis {}
            set non_top_sos {}

            foreach ts [get_db test_bus_ports -if {.function==compress_sdi}] {
                if {[get_db $ts .dft_hookup_pin.obj_type]=="pin" && [get_db $ts .dft_hookup_pin.inst.is_macro]} {
                    lappend non_top_sis [get_db [report_dft_trace_back -continue [get_db $ts .dft_hookup_pin]] .name]
                }
            }
            foreach ts [get_db test_signals -if {.function==compress_sdo}] {
                set endpoint [report_dft_trace_back -continue [get_db $ts .dft_hookup_pin]]
                if {[get_db $endpoint .inst.is_macro]} {
                    lappend non_top_sos [get_db $ts .pin.name]
                }
            }
        }

        foreach ts [get_db test_signals] {
            if {[get_db $ts .pin.obj_type]!="port"} continue

            set pin [get_db $ts .pin.name]
            set type [get_db $ts .function]
            if {[get_db $ts .active]=="high"} {
                set act +
                set inv -
            } else {
                set act -
                set inv +
            }

            if {$type=="shift_enable"} {
                add_test_function -pin $pin -function ${act}SE
                if {$opcg} {
                    # Assumes scan enable is always trigger
                    add_test_function -pin $pin -function ${act}GO
                }
            } elseif {$type=="custom"||$type=="test_mode"||$type=="async_set_reset"} {
                add_test_function -pin $pin -function ${act}TI
            } elseif {$type=="opcg_enable"} {
                if {$opcg} {
                    add_test_function -pin $pin -function ${act}TI
                } else {
                    add_test_function -pin $pin -function ${inv}TI
                }
            } elseif {$type=="opcg_load"} {
                if {$opcg} {
                    add_test_function -pin $pin -function ${act}OLE,${inv}SE,${inv}TC
                } else {
                    add_test_function -pin $pin -function ${inv}TI
                }
            } elseif {$type=="compress_sdi"||$type=="scan_in"} {
                #if {$extest && $pin in $non_top_sis} {continue}
                add_test_function -pin $pin -function SI
            } elseif {$type=="compress_sdo"||$type=="scan_out"} {
                #if {$extest && $pin in $non_top_sos} {continue}
                add_test_function -pin $pin -function SO
            } elseif {$type=="mask_enable"} {
                if {$compression} {
                    add_test_function -pin $pin -function ${inv}CME
                } else {
                    add_test_function -pin $pin -function ${inv}TI
                }
            } elseif {$type=="mask_load"} {
                if {$compression} {
                    add_test_function -pin $pin -function ${act}CMLE,${inv}SE,${inv}TC
                } else {
                    add_test_function -pin $pin -function ${inv}TI
                }
            } elseif {$type=="serial_wrck"} {
                add_test_function -pin $pin -function -EC
            } elseif {$type=="wir_test"} {
                # TODO always inactive
                add_test_function -pin $pin -function ${inv}TI
            } elseif {$type=="serial_sdi"||$type=="serial_sdo"} {
                # Not added to pinassign
            } else {
                puts "Warning: pin $pin unknown function $type"
            }
        }

        foreach tc [get_db test_clocks] {
            if {[get_db $tc .sources.obj_type]!="port"} continue

            set pin [get_db $tc .sources.name]
            set type [get_db $tc .function]

            if {$type=="compression_clock"} {
                add_test_function -pin $pin -function -CML
            } elseif {$type=="dft_clock"} {
                # This might be a bit risky as dft_clock is very generic, but in current flow it is mask and opcg clock
                add_test_function -pin $pin -function -EC
                if {$opcg} {
                    add_test_function -pin $pin -function -OLC
                }
                if {$compression} {
                    add_test_function -pin $pin -function -CML
                }
            } else {
                puts "Warning: pin $pin unknown function $type"
            }
        }

        if {$opcg} {
            generate_opcg_pinassign
        }

        if {$compression} {
            # no test signals/bus ports available so have to go by name
            if {[regexp {21\.} [get_db program_major_version]]} {
                set si int_ci
                set so int_co
            } else {
                error "Different genus version, check compression naming"
            }
            foreach pin [get_db -match_hier hpins COMPACTOR/$si*] {
                add_test_function -pin [string map {/ .} [get_db $pin .name]] -function CHO
            }
            foreach pin [get_db -match_hier hpins COMPACTOR/$so*] {
                add_test_function -pin [string map {/ .} [get_db $pin .name]] -function CHI
            }
        }
    }

    proc generate_extest_coreinstancefile {args} {
        internal::read_args $args
        
        variable pinassign_data

        read_pinassign -reset

        foreach core $cores {
            lappend pinassign_data "module=[get_db $core .base_cell.name] coreinstance=[get_db $core .name] testmode=$testmode;"
        }
    }

    # TODO figure out what domain latency should really be
    # TODO program bits by name
    proc generate_opcg_pinassign {args} {
        internal::read_args $args

        variable pinassign_data

        foreach domain [get_db [get_db opcg_domains] .base_name] {
            set out_pin [get_db [get_db [get_db hinsts *[get_db dft_prefix]$domain] .hpins -if {.base_name==OPCGCLK}] .net.drivers]
            set cutpoint [get_db [get_db $out_pin .inst.pins -if {.base_name==I0}] .net.drivers.name]
            lappend pinassign_data "cutpoints \"[string map {/ .} $cutpoint]\"=+$domain.ppi;"
            lappend pinassign_data "assign ppi=$domain.ppi test_function=-SC;"
            lappend pinassign_data ""
        }

        # Should be the same always
        lappend pinassign_data "OPCG type=STANDARD load_type=SERIAL_SETUP"
        foreach pll [get_db osc_sources] {
            set domain [get_db opcg_domains -if {.osc_source==$pll}]
            set in_freq [join [list [internal::ps_to_mhz [get_db $pll .max_input_period]] \
                                   [internal::ps_to_mhz [get_db $pll .min_input_period]] \
                                   [internal::ps_to_mhz [get_db $pll .min_input_period]]] ", "]
            set out_freq [join [list [internal::ps_to_mhz [get_db $pll .max_output_period]] \
                                    [internal::ps_to_mhz [get_db $domain .min_domain_period]] \
                                    [internal::ps_to_mhz [get_db $pll .min_output_period]]] ", "]
            lappend pinassign_data "    PLL_NAME = [get_db $pll .base_name] \{"
            lappend pinassign_data "        PLL_IN_OSC = \"[get_db $pll .ref_clock_pin.base_name]\";"
            lappend pinassign_data "        PLL_IN_FREQ = ($in_freq) MHZ;"
            lappend pinassign_data "        PLL_OUT_OSC = \"[string map {/ .} [get_db $domain .location.net.name]]\";"
            lappend pinassign_data "        PLL_OUT_FREQ = ($out_freq) MHZ;"
            lappend pinassign_data "    \}"
            lappend pinassign_data ""
        }

        foreach domain [get_db opcg_domains] {
            set macro [string map {/ .} [get_db [get_db hinsts *[get_db dft_prefix][get_db $domain .base_name]] .name]]
            # Same as generated, min is /2 for some reason
            set freq [join [list [internal::ps_to_mhz [expr [get_db $domain .min_domain_period] * 2]] \
                                [internal::ps_to_mhz [get_db $domain .min_domain_period]] \
                                [internal::ps_to_mhz [get_db $domain .min_domain_period]]] ", "]
            # TODO is there a better way to find this
            set trigger [get_db [get_db test_signals -if {.function==shift_enable && .pin.obj_type==port}] .pin.name]
            lappend pinassign_data "    DOMAIN_NAME = [get_db $domain .base_name] \{"
            lappend pinassign_data "        DOMAIN_IN_CLOCK = \"[string map {/ .} [get_db $domain .location.net.name]]\";"
            lappend pinassign_data "        DOMAIN_FREQ = ($freq);"
            lappend pinassign_data "        DOMAIN_PPI = [get_db $domain .base_name].ppi;"
            lappend pinassign_data "        DOMAIN_GO_LATENCY = (20, 24);"
            lappend pinassign_data "        DOMAIN_GO_REF = \"[string map {/ .} [get_db $domain .location.net.name]]\";"
            lappend pinassign_data "        DOMAIN_GO = \"$trigger\";"
            lappend pinassign_data "        DOMAIN_PROGRAM \{"
            lappend pinassign_data "            DOMAIN_REG = [get_db $domain .base_name].pulse_gen \{"
            lappend pinassign_data "                DOMAIN_REG_TYPE = CLOCK_HIGH_GATE_SR"
            lappend pinassign_data "                DOMAIN_REG_BITS = (\"$macro.i_opcg_pgm_reg.shift_reg_reg_1\","
            lappend pinassign_data "                                   \"$macro.i_opcg_pgm_reg.shift_reg_reg_0\");"
            lappend pinassign_data "            \}"
            lappend pinassign_data "        \}"
            lappend pinassign_data "    \}"
            lappend pinassign_data ""
        }

        lappend pinassign_data ";"
        lappend pinassign_data ""

        set dummy 1
    }

    proc set_pinassign_core {args} {
        internal::read_args $args

        variable pinassign_data

        lappend pinassign_data ""
        foreach core $cores {
            lappend pinassign_data "coreinstance = $core testmode = $mode;"
        }

        set dummy 1
    }
    
    # TODO, probably not needed
    proc load_subsystem_tdr {args} {
        internal::read_args $args

        variable bsdl_tap
        variable R
        variable N
        variable M
        variable loop_ctrl
        set bsdl_tap {}
        dict append bsdl_tap tdi PLL_CONFIG_tdi tdo PLL_CONFIG_tdo tck PLL_CONFIG_clockdr
        dft_utils::add_pi_event -pin PLL_CONFIG_shiftdr -value 1
        dft_utils::add_pi_event -pin PLL_CONFIG_decode -value 1
        foreach val [split $R ""] {
            dft_utils::internal::load_tap
        }
    }

    proc read_scan_abstract {args} {
        internal::read_args $args

        variable abstract_data
        set abstract_data {}
        if {$reset} {
            return
        }
        set fp [open $file r]
        while {[gets $fp line]>=0} {
            lappend abstract_data $line
        }
    }

    proc add_dft_controllable {args} {
        internal::read_args $args

        variable abstract_data

        set i 0
        set found 0
        foreach line $abstract_data {
            if {[regexp dft_controllable_proc $line]} {
                set found 1
            } elseif {$found && [regexp \} $line]} {
                set line "    ::legacy::set_attribute dft_controllable \"\[::legacy::find \$inst_name -maxdepth 2 -pin -\$::nvs::hpin $from\] non_inverting\" \[::legacy::find \$inst_name -maxdepth 2 -pin -\$::nvs::hpin $to\]"
                set abstract_data [linsert $abstract_data $i $line]
                break
            }
            incr i
        }
        if {$i==[llength $abstract_data]} {
            puts "Error: dft_controllable_proc not found"
        }
    }
    
    proc write_scan_abstract {args} {
        internal::read_args $args

        variable abstract_data
        set fp [open $file w]
        foreach line $abstract_data {
            puts $fp $line
        }
        close $fp
    }

    proc uniquify_scan_abstract {args} {
        internal::read_args $args

        variable abstract_data
        set i 0
        foreach line $abstract_data {
            if {[regexp {define_test_bus_port.+-name\s+(\S+)} $line -> old_name]} {
                set line [regsub $old_name $line ${old_name}_$token]
                set abstract_data [lreplace $abstract_data $i $i $line]
            }
            incr i
        }
    }

    proc set_port_names {args} {
        internal::read_args $args

        variable port_alias
        foreach port {refclk refrstn jtag_tck jtag_reset jtag_tdi} {
            if {[set $port]!=0} {
                dict set port_alias $port [set $port]
            }
        }
    }

    proc set_pg {args} {
        internal::read_args $args

        variable powers
        variable grounds

        if {$power!=0} {
            set powers $power
        }
        if {$ground!=0} {
            set grounds $ground
        }
    }

    # Initialize powers in tb
    proc create_upf_tb {args} {
        internal::read_args $args

        variable powers
        variable grounds

        set inst $::env(MODULE_NAME)_inst

        set initial_found 0
        
        set fpr [open $file r]
        set fpw [open [regsub {\.v} $file .upf.v] w]
        while {[gets $fpr line]>=0} {
            if {[regexp {\bmodule} $line]} {
                puts $fpw "import UPF::*;"
            }
            puts $fpw $line
            if {[regexp initial $line]} {
                set initial_found 1
            } elseif {$initial_found} {
                foreach vdd $powers {
                    puts $fpw "\$supply_on(\"$inst.$vdd\", 0.9);"
                }
                foreach vss $grounds {
                    puts $fpw "\$supply_on(\"$inst.$vss\", 0.0);"
                }
                set initial_found 0
            }
        }
        close $fpr
        close $fpw
    }

    proc find_constant_source {args} {
        internal::read_args $args

        set driver [get_db $pin .net.drivers]
        if {[get_db $driver .obj_type]=="pin"} {
            if {[get_db $driver .dft_constant_value]!="no_value"} {
                set pins [get_db $driver .inst.pins -if {.direction==in&&.dft_constant_value!=no_value&&.inst.is_combinational}]
                if {[llength $pins]} {
                    foreach pin $pins {
                        puts $pin
                        find_constant_source $pin
                    }
                } else {
                    puts "^^^  STARTPOINT  ^^^"
                }
            }
        } else {
            puts $pin
        }
    }

    # SIU numbers not particularly relevant
    proc create_mda_header_from_sequence {args} {
        internal::read_args $args

        set fpw [open $out_file w]
        puts $fpw "// Naming: <subsystem>_<instruction>_<testplan>_<step>_<type>_<reg>"
        puts $fpw "// instruction = PROD_RUN (Load data and start operation)"
        puts $fpw "//             = MBISTCHK (Shift results into read register)"
        puts $fpw "//"
        puts $fpw "// type = LOAD_DATA (data to write)"
        puts $fpw "//      = READ_DATA (data that should be read if no faults)"
        puts $fpw "//      = READ_MASK (mask to use with previous)"
        puts $fpw "//      = WAIT_CYCLES (number of sysctrl clock cycles to wait until operation done."
        puts $fpw "//                     This is redundant and it should be enough to wait until mda_done is high)"
        puts $fpw "//"
        puts $fpw "// In general all steps should be run, they target different memories"
        puts $fpw "// Reg number means register to write to, 2 -> MBIST_CTRL_DIN_2_ADDRESS etc."
        puts $fpw "//"
        puts $fpw "// rising edge on msb of data 9 starts operation, so this has to be set to 0 between each instruction"
        puts $fpw "// After loading MBISTCHK at least 320 cycles should be waited to allow shifting results completely"
        puts $fpw ""
        
        if {$pattern_control!=0} {
            set fpr [open $pattern_control r]
            while {[gets $fpr line]>=0} {
                regexp {siu=([0-9]+)} $line -> siu
                if {[regexp {target=[0-9]+:(.+):lib_cell} $line -> target]} {
                    lappend targets($siu) $target
                }
            }
            close $fpr

            for {set i 0} {$i < [array size targets]} {incr i} {
                puts $fpw "// siu $i targets"
                foreach target $targets($i) {
                    puts $fpw "//   $target"
                }
            }
            puts $fpw ""
        }

        if {[file extension $in_file]==".gz"} {
            file copy -force $in_file ./.sequence.gz
            exec gzip -df ./.sequence.gz
            set fpr [open ./.sequence r]
        } else {
            set fpr [open $in_file r]
        }

        set steps {MBISTTPN MBISTSCH PROD_RUN Runtime MBISTCHK}
        set out_l 315
        set index [int_to_bin $index -pad 4]
        set start 1
        
        set i 0
        set found 0
        set tp 0
        set num 0
        set ls 0
        set acc_ls ""
        while {[gets $fpr line]>=0} {
            set step [lindex $steps $i]
            
            if {([regexp MBIST $step] && [regexp [subst -nobackslashes {Loading\s+TDR.+$step}] $line]) \
                || ($step=="PROD_RUN" && [regexp [subst -nobackslashes {Performing\s+RUN.+$step}] $line])} {
                unset tp
                unset num
                unset ls
                while {[gets $fpr line]>=0} {
                    if {[regexp Testplan $line]} {
                        gets $fpr line
                        set tp [lindex [join [split $line]] end]
                    } elseif {[regexp Step $line]} {
                        gets $fpr line
                        set num [lindex [join [split $line]] end]
                    } elseif {[regexp {load\s+string} $line]} {
                        gets $fpr line
                        set ls [lindex [join [split $line]] end]
                        if {$step=="MBISTCHK"} {
                            set rd ""
                            set rm ""
                            set j 0
                            while {[gets $fpr line]>=0} {
                                if {[regexp Pattern $line]} {
                                    set found 0
                                    while {[gets $fpr line]>=0} {
                                        if {[regexp {mda_tdo.+([01])} $line -> val]} {
                                            set found 1
                                            set rd $rd$val
                                            set rm ${rm}1
                                        }
                                        if {[regexp Pattern $line]} {
                                            if {!$found} {
                                                set rd ${rd}0
                                                set rm ${rm}0
                                            }
                                            break
                                        }
                                    }
                                    incr j
                                    if {$j==[string length $ls]} {break}
                                }
                            }
                        }
                    }
                    if {[info exists num]&&[info exists tp]&&[info exists ls]} {break}
                }

                # tpn, chk start from reset, also stay in reset after chk
                if {$step=="MBISTTPN"} {
                    set ls 1$ls
                } elseif {$step=="MBISTCHK"} {
                    set ls [string range 1$ls 0 end-1]
                }

                # Combine tpn, sch, prod_run to single op
                if {$step in {MBISTTPN MBISTSCH}} {
                    set acc_ls $acc_ls$ls
                } else {
                    set words 10
                    set name [string toupper ${module}_${step}_${tp}_${num}_load_data]
                    set full_ctrl [string reverse [string range [string map {2 0} $acc_ls$ls][string repeat 0 320] 0 $out_l]$index$start]
                    for {set j 0} {$j < $words} {incr j} {
                        puts $fpw "#define ${name}_[expr $words-$j-1] 0b[string range $full_ctrl [expr $j*32] [expr ($j+1)*32]]"
                    }
                    set acc_ls ""

                    if {$step=="MBISTCHK"} {
                        # Only 2 words need to be checked
                        set words 2
                        set name_rd [string toupper ${module}_${step}_${tp}_${num}_read_data]
                        set name_rm [string toupper ${module}_${step}_${tp}_${num}_read_mask]
                        set full_rd [string reverse [string range $rd[string repeat 0 64] 0 64]]
                        set full_rm [string reverse [string range $rm[string repeat 0 64] 0 64]]
                        puts $fpw ""
                        for {set j 0} {$j < $words} {incr j} {
                            puts $fpw "#define ${name_rd}_[expr $words-$j-1] 0b[string range $full_rd [expr $j*32] [expr ($j+1)*32]]"
                            puts $fpw "#define ${name_rm}_[expr $words-$j-1] 0b[string range $full_rm [expr $j*32] [expr ($j+1)*32]]"
                        }
                    }
                }
                incr i
            } elseif {$step=="Runtime" && [regexp {Wait_Osc.+cycles\s*=\s*([0-9]+)} $line -> cycles]} {
                while {[gets $fpr line]>=0} {
                    if {[regexp {load\s+string} $line]} {
                        gets $fpr line
                        set ls [lindex [join [split $line]] end]
                        set cycles [expr $cycles + [string length $ls]]
                        break
                    }
                }
                puts $fpw ""
                puts $fpw "#define [string toupper ${module}_PROD_RUN_${tp}_${num}_wait_cycles] $cycles"
                puts $fpw ""
                incr i
            }
            if {$i==[llength $steps]} {
                puts $fpw ""
                set i 0
            }
        }
        
        close $fpr
        close $fpw
        file delete ./.sequence
    }

    namespace eval internal {
        # A lot of error checking missing, eg multiple same arguments, missing value
        # In opts string name of opt will be upvared , eg -opt val -> upvar opt temp; set temp val
        # If opt has no value (is bool) -option -> upvar option temp; set temp 1
        # Default for unnamed option is "", 0 for others
        # Will "succeed" with {-opt1|-opt2 -opt3} when only -opt3 defined, TODO fix
        # Can't have optional unnamed with any complex strings ie opt1|{-opt2|-opt3} won't work correctly
        # TODO might have a bad uplevel/upvar somewhere, option value might cause naming clash
        upvar proc_opts proc_opts
        upvar proc_help proc_help
        proc read_args {arguments} {
            variable proc_opts
            variable proc_help
            set caller [lindex [split [lindex [info level -1] 0] ":"] end]
            if {$caller ni [array names proc_opts]} {
                error "Missing proc_opts for $caller"
            }
            set opts $proc_opts($caller)
            set hierarchy top
            set unnamed ""
            set unnamed_optional 0
            set found 0
            set exclusive_found 0
            # Add spaces so splitting is easy
            regsub -all {\{} $opts " \{ " opts
            regsub -all {\}} $opts " \} " opts
            regsub -all {\[} $opts " \[ " opts
            regsub -all {\]} $opts " \] " opts
            regsub -all {\|} $opts " | " opts
            set opts [lsearch -all -inline -not -exact [split $opts] {}]
            if {"-help" in $arguments||"-h" in $arguments} {
                puts "Usage: $caller $opts"
                if {$caller in [array names proc_help]} {
                    puts $proc_help($caller)
                }
                return -level 2 0
            }
            
            for {set i 0} {$i < [llength $opts]} {incr i} {
                set opt [lindex $opts $i]
                if {$opt=="\{"} {
                    lappend hierarchy mandatory
                    set found 0
                    set exclusive_found 0
                    continue
                } elseif {$opt=="\["} {
                    lappend hierarchy optional
                    set found 0
                    set exclusive_found 0
                    continue
                } elseif {$opt=="\}"} {
                    if {[lindex $hierarchy end]=="mandatory"} {
                        set hierarchy [lrange $hierarchy 0 end-1]
                        if {!$found && $unnamed==""} {
                            error "Missing argument"
                        }
                    } else {
                        error "[lindex [info level 0] 0]: Invalid option string"
                    }
                    continue
                } elseif {$opt=="\]"} {
                    if {[lindex $hierarchy end]=="optional"} {
                        set hierarchy [lrange $hierarchy 0 end-1]
                    } else {
                        error "[lindex [info level 0] 0]: Invalid option string"
                    }
                    continue
                } elseif {$opt=="|"} {
                    if {$found} {
                        set exclusive_found 1
                    }
                    if {$unnamed!=""} {
                        set unnamed_optional 1
                    }
                    if {![llength $hierarchy]} {
                        error "[lindex [info level 0] 0]: Invalid option string"
                    }
                    continue
                } elseif {[string index $opt 0]=="-"} {
                    set next_first_char [string index [lindex $opts [expr $i + 1]] 0]
                    set no_value_chars {- \{ \} \[ \] |}
                    set no_value 1
                    if {$next_first_char ni $no_value_chars && [llength $opts]>[expr $i + 1]} {
                        set no_value 0
                        incr i
                    }
                    upvar [string range $opt 1 end] temp
                    if {$opt in $arguments} {
                        if {$exclusive_found} {
                            error "Multiple exclusive arguments defined"
                        }
                        set found 1
                        if {$no_value} {
                            set temp 1
                        } else {
                            uplevel [list set [lindex $opts $i] 0]
                            set index [expr [lsearch $arguments $opt] + 1]
                            set temp [lindex $arguments $index]
                            set arguments [lreplace $arguments $index $index]
                        }
                        set arguments [lsearch -all -inline -not -exact $arguments $opt]
                    } else {
                        # Default value is 0 for everything
                        uplevel [list set [string range $opt 1 end] 0]
                    }
                    
                } else {
                    # Unnamed option
                    if {$unnamed!=""} {
                        error "Multiple unnamed options for $caller"
                    }
                    if {!$exclusive_found} {
                        set unnamed $opt
                    }
                    # TODO possibly dirty fix and might have broken something
                    if {[lindex $hierarchy end]=="optional"} {
                        set unnamed_optional 1
                    }
                }
            }
            if {$unnamed!=""} {
                if {[llength $arguments]>1} {
                    error "Unknown option [lindex $arguments end]"
                } elseif {![llength $arguments]} {
                    if {$unnamed_optional} {
                        uplevel [list set $unnamed ""]
                    } else {
                        # If {unnamed|-other} and no arguments specified, will get here
                        error "Missing argument $unnamed"
                    }
                }
                # Can't have multiple levels of hierarchy when unnamed is optional or this check fails
                if {$exclusive_found} {
                    error "Multiple exclusive arguments defined"
                }
                uplevel [list set $unnamed $arguments]
            } elseif {[llength $arguments]} {
                error "Unknown option [lindex $arguments end]"
            }
        }
        
        upvar seqdef_data seqdef_data
        upvar sequence sequence
        upvar bsdl_tap bsdl_tap
        variable pattern 1
        variable event 1
        
        proc load_ir {instruction} {
            variable seqdef_data
            lappend seqdef_data "# Move to shift-ir"
            foreach bit {1 1 0 0} {
                move_tap $bit
            }
            lappend seqdef_data "# Load ir LSB first"
            set l [expr [string length $instruction] - 1]
            while {$l>0} {
                load_tap [string index $instruction $l]
                incr l -1
            }
            lappend seqdef_data "# Load final bit, move to exit-1-ir"
            load_tap [string index $instruction 0] -finish
            lappend seqdef_data "# Move to update-ir"
            move_tap 1
            lappend seqdef_data "# Move to run-test-idle"
            move_tap 0
        }
        
        proc load_dr {value} {
            variable seqdef_data
            lappend seqdef_data "# Move to shift-dr"
            foreach bit {1 0 0} {
                move_tap $bit
            }
            lappend seqdef_data "# Load dr LSB first"
            set l [expr [string length $value] - 1]
            while {$l>0} {
                load_tap [string index $value $l]
                incr l -1
            }
            lappend seqdef_data "# Load final bit, move to exit-1-dr"
            load_tap [string index $value 0] -finish
            lappend seqdef_data "# Move to update-dr"
            move_tap 1
            lappend seqdef_data "# Move to run-test-idle"
            move_tap 0
        }

        proc add_tms_reset {} {
            #TODO
        }
        
        proc add_trst_reset {} {
            variable seqdef_data
            variable bsdl_tap
            lappend seqdef_data "# Test-logic-reset"
            add_pattern
            add_stim_pi [list [list [dict get $bsdl_tap trst] 0] \
                             [list [dict get $bsdl_tap tms] 1]]
            finish_pattern
            lappend seqdef_data "# Stay in test-logic-reset"
            add_pattern
            add_stim_pi [list [list [dict get $bsdl_tap trst] 1]]
            finish_pattern
            puts $seqdef "# Move to run-test-idle"
            move_tap 0
        }

        proc move_tap {tms_value} {
            variable bsdl_tap
            add_pattern
            add_stim_pi [list [list [dict get $bsdl_tap tms] $tms_value]]
            add_pulse [dict get $bsdl_tap tck]
            finish_pattern
        }

        proc load_tap {tdi_value args} {
            variable bsdl_tap
            add_pattern
            if {"-finish" ni $args} {
                set pi_list [list [list [dict get $bsdl_tap tdi] $tdi_value]]
            } else {
                set pi_list [list [list [dict get $bsdl_tap tdi] $tdi_value] \
                                 [list [dict get $bsdl_tap tms] 1]]
            }
            add_stim_pi $pi_list
            add_pulse [dict get $bsdl_tap tck]
            finish_pattern
        }

        proc add_pattern {{type static}} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            set event 1
            lappend seqdef_data "\[ Pattern $sequence.$pattern (pattern_type = $type);"
        }
        
        proc finish_pattern {} {
            variable seqdef_data
            variable sequence
            variable pattern
            lappend seqdef_data "\] Pattern $sequence.$pattern;"
            incr pattern
        }
        
        proc add_stim_pi {pi_list} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            lappend seqdef_data "  Event $sequence.$pattern.$event Stim_PI ():"
            foreach pi $pi_list {
                lappend seqdef_data "    \"[lindex $pi 0]\"=[lindex $pi 1]"
            }
            set seqdef_data [lreplace $seqdef_data end end [lindex $seqdef_data end]\;]
            incr event
        }
        
        proc add_pulse {pin} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            lappend seqdef_data "  Event $sequence.$pattern.$event Pulse ():"
            lappend seqdef_data "    \"$pin\"=+;"
            incr event
        }

        proc add_repeat {num} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            lappend seqdef_data "  Event $sequence.$pattern.$event Repeat ():"
            lappend seqdef_data "    $num;"
            incr event
        }

        proc add_start_osc {pin up down {ppc 1}} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            lappend seqdef_data "  Event $sequence.$pattern.$event Start_Osc (pulses_per_cycle=$ppc, up $up ns, down $down ns):"
            lappend seqdef_data "    \"$pin\"=+;"
            incr event
        }

        proc add_wait_osc {pin cycles} {
            variable seqdef_data
            variable sequence
            variable pattern
            variable event
            lappend seqdef_data "  Event $sequence.$pattern.$event Wait_Osc (cycles=$cycles, off):"
            lappend seqdef_data "    \"$pin\";"
            incr event
        }

        proc set_async_osc {name} {
            variable seqdef_data
            set i 0
            set found 0
            foreach line $seqdef_data {
                if {[regexp Start_Osc $line]} {
                    set found $i
                }
                if {$found} {
                    if {[regexp $name $line]} {
                        set line [lindex $seqdef_data $found]
                        if {[regexp pulses_per_cycle $line]} {
                            set line [regsub {pulses_per_cycle[^,\)]*} $line pulses_per_cycle=0]
                        } else {
                            set line [regsub {\)} $line ,pulses_per_cycle=0\)]
                        }
                        set seqdef_data [lreplace $seqdef_data $found $found $line]
                        break
                    } elseif {[regexp \] $line]} {
                        set found 0
                    }
                }
                incr i
            }
        }
        
        proc set_pattern {val} {
            variable pattern
            set pattern $val
        }

        # TODO assumes updatedr is always available
        proc create_tdr_icl {name length dir {check_names 0}} {
            if {$check_names} {
                set module_name [get_db flow_vars_design_name]_[get_db [get_db hinsts $name] .module.base_name]
            } else {
                set module_name "test_data_register"
            }
            set msb [expr $length - 1]
            set fp [open $dir/$name.icl w]
            puts $fp "Module $module_name \{"
            puts $fp "    TCKPort clockdr ;"
            puts $fp "    UpdateEnPort updatedr ;"
            puts $fp "    SelectPort decode ;"
            puts $fp "    ShiftEnPort shiftdr ;"
            puts $fp "    ScanInPort tdi ;"
            puts $fp "    ScanOutPort tdo \{ Source out\[$msb\] ; \}"
            puts $fp "    ScanRegister out\[0:${msb}\] \{ ScanInSource tdi ; \}"
            puts $fp "    ScanInterface ${name}_scan \{ Port tdi; Port tdo; Port decode; Port shiftdr; \}"
            puts $fp "\}"
            close $fp
        }

        proc create_tdr_pdl {name length dir {check_names 0}} {
            if {$check_names} {
                set module_name [get_db flow_vars_design_name]_[get_db [get_db hinsts $name] .module.base_name]
            } else {
                set module_name test_data_register
            }
            set fp [open $dir/$name.pdl w]
            puts $fp "iProcsForModule $module_name ;"
            puts $fp ""
            puts $fp "iProc Set${name}_pins \{val\} \{"
            puts $fp "    iWrite out \$val ;"
            puts $fp "\}"
            close $fp
        }
        
        # TODO assumes updatedr is always available
        proc create_tdr_pinassign {name length dir {check_names 0}} {
            set fp [open $dir/$name.pinassign]
            puts $fp "assign pin clockdr test_function=-ES;"
            puts $fp ""
        }

        # modus doesn't have all_fanin, crude substitute
        # TODO might have issues with prim pins
        proc fanin {pin} {
            set endpoints {}
            set to_check [get_db pins $pin][get_db hpins $pin]
            while {[llength $to_check]} {
                set checking [lindex $to_check 0]
                foreach ll [get_db $checking .net.drivers] {
                    if {[get_db $ll .obj_type]=="port"} {
                        lappend endpoints $ll
                    } elseif {[get_db $ll .obj_type]=="prim_pin"} {
                        if {[llength [get_db $ll .prim.inst]]&&[get_db $ll .prim.inst.is_sequential]} {
                            lappend endpoints $ll
                        } elseif {[llength [get_db $ll .prim.inst]]} {
                            set to_check [concat $to_check [get_db $ll .inst.pins -if {.direction==in}]]
                        }
                    } elseif {[get_db $ll .inst.is_sequential]} {
                        lappend endpoints $ll
                    } else {
                        set to_check [concat $to_check [get_db $ll .inst.pins -if {.direction==in}]]
                    }
                }
                set to_check [lsearch -all -inline -not -exact $to_check $checking]
            }
            return [lsort -u $endpoints]
        }

        proc fanout {pin} {
            set endpoints {}
            set to_check [get_db pins $pin][get_db hpins $pin]
            while {[llength $to_check]} {
                set checking [lindex $to_check 0]
                foreach ll [get_db $checking .net.loads] {
                    if {[get_db $ll .obj_type]=="port"} {
                        lappend endpoints $ll
                    } elseif {[get_db $ll .obj_type]=="prim_pin"} {
                        if {[llength [get_db $ll .prim.inst]]&&[get_db $ll .prim.inst.is_sequential]} {
                            lappend endpoints $ll
                        } elseif {[llength [get_db $ll .prim.inst]]} {
                            set to_check [concat $to_check [get_db $ll .inst.pins -if {.direction==in}]]
                        }
                    } elseif {[get_db $ll .inst.is_sequential]} {
                        lappend endpoints $ll
                    } else {
                        set to_check [concat $to_check [get_db $ll .inst.pins -if {.direction==in}]]
                    }
                }
                set to_check [lsearch -all -inline -not -exact $to_check $checking]
            }
            return [lsort -u $endpoints]
        }

        proc ps_to_mhz {period} {
            return [format "%.2f" [expr 1e6/$period]]
        }
    }
}

puts "INFO: dft_utils available"
