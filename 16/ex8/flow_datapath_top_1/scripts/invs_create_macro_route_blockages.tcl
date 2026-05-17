
proc invs_create_macro_route_blockages { args } {
    
    foreach macro [get_db selected] {

        puts stdout "Info: Adding metal blockages around macro: [get_db $macro .name]"
	
        # get pins side. width -> y, length -> x
        set or_x [get_db $macro .location.x]
        set or_y [get_db $macro .location.y]
        set macro_width [get_db $macro .bbox.dx]
        set macro_length [get_db $macro .bbox.dy]
        
        # skip edges if on die edge
        set skip_l 0
        set skip_b 0
        set skip_r 0
        set skip_t 0

        set hl [get_db $macro .place_halo_left]
        set hb [get_db $macro .place_halo_bottom]
        set hr [get_db $macro .place_halo_right]
        set ht [get_db $macro .place_halo_top]
        
        if {$hl < 0.0005} {
            set skip_l 1
        }
        if {$hr < 0.0005} {
            set skip_r 1
        }
        if {$hb < 0.0005} {
            set skip_b 1
        }
        if {$ht < 0.0005} {
            set skip_t 1
        }

        set lx_mext [expr $or_x - $hl]
        set lx [expr $or_x + 0.0]
        set rx [expr $or_x + $macro_width]
        set rx_pext [expr $or_x + $macro_width + $hr]
        set by_mext [expr $or_y - $hb]
        set by [expr $or_y + 0.0]
        set uy [expr $or_y + $macro_length]
        set uy_pext [expr $or_y + $macro_length + $ht]

        ####################################
        # Block metal & via fill
        ####################################
        for {set lm 1} {$lm < 9} {incr lm} {
            set fill_llx $lx_mext
            set fill_lly $by_mext
            set fill_urx $rx_pext
            set fill_ury $uy_pext

            if {$skip_l} {
                set fill_llx $or_x
            }
            if {$skip_t} {
                set fill_ury [expr $or_y + $macro_length]
            }
            if {$skip_r} {
                set fill_urx [expr $or_x + $macro_width]
            }
            if {$skip_b} {
                set fill_lly $or_y
            }

            puts stdout "Info: create fill route blockage on layer M${lm} on top of [get_db $macro .name]"
            create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_fill -fills -layer M${lm} -area $fill_llx $fill_lly $fill_urx $fill_ury
            puts stdout "Info: create fill route blockage on layer VIA${lm} on top of [get_db $macro .name]"
            create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_fill -fills -layer VIA${lm} -area $fill_llx $fill_lly $fill_urx $fill_ury
        }

        ####################################
        # Block signal routing near macro
        ####################################
        for {set lm 1} {$lm < 9} {incr lm} {
            if {!$skip_l} {
                puts stdout "Info: create signal route blockage on layer M${lm} on left side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_l_signal_metal -except_pg_nets -layer M${lm} -area $lx_mext $by_mext $lx $uy_pext
                puts stdout "Info: create signal route blockage on layer VIA${lm} on left side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_l_signal_via -except_pg_nets -layer VIA${lm} -area $lx_mext $by_mext $lx $uy_pext
            }
            if {!$skip_r} {
                puts stdout "Info: create signal route blockage on layer M${lm} on right side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_r_signal_metal -except_pg_nets -layer M${lm} -area $rx $by_mext $rx_pext $uy_pext
                puts stdout "Info: create signal route blockage on layer VIA${lm} on right side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_r_signal_via -except_pg_nets -layer VIA${lm} -area $rx $by_mext $rx_pext $uy_pext
            }
        }
        if {!$skip_t} {
            foreach lm {M2 M4 M6 M8 VIA1 VIA2 VIA3 VIA4 VIA5 VIA6 VIA7} {
                puts stdout "Info: create route blockage on layer ${lm} on top side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_t -except_pg_nets -layer ${lm} -area $lx $uy $rx $uy_pext
            }
        }
        if {!$skip_b} {
            foreach lm {M2 M4 M6 M8 VIA1 VIA2 VIA3 VIA4 VIA5 VIA6 VIA7} {
                puts stdout "Info: create route blockage on layer ${lm} on bottom side of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_b -except_pg_nets -layer ${lm} -area $lx $by_mext $rx $by
            }
        }

        ####################################
        # Block VIAs on top of macro
        ####################################
        foreach lm {VIA1 VIA2 VIA3 VIA4 VIA5 VIA6 VIA7} {
            puts stdout "Info: create route via blockage on layer ${lm} on top of whole macro [get_db $macro .name]"
            create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_macro_via_b -except_pg_nets -layer ${lm} -area $lx $uy $rx $by
        }

        ####################################
        # Block PG-routing on top of macro
        ####################################
        for {set lm 5} {$lm < 11} {incr lm} {
            if {$lm < 7} {
                set red 0.1
            } else {
                set red 0.16
            }
            set block_llx [expr $lx + $red]
            set block_lly [expr $by + $red]
            set block_urx [expr $rx - $red]
            set block_ury [expr $uy - $red]
          
            if {$lm > 9} {
                puts stdout "Info: create temporary pg route blockage on layer M${lm} on top of [get_db $macro .name]"
                create_route_blockage -name m${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_pg -layer M${lm} -area $block_llx $block_lly $block_urx $block_ury
            }
            if {$lm < 10} {
                puts stdout "Info: create temporary pg route blockage on layer VIA${lm} on top of [get_db $macro .name]"
                create_route_blockage -name via${lm}_block_[regsub -all {\/} [get_db $macro .name] "_"]_pg -layer VIA${lm} -area $block_llx $block_lly $block_urx $block_ury
            }
        }
    }
}
