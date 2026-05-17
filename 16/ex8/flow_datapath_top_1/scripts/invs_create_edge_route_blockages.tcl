
proc invs_create_edge_route_blockages { args } {

    # Blockage width for inner edges, bbox edges go to core
    #upvar margin margin
    parse_proc_arguments -args $args arguments
    if {[info exists arguments(-margin)]} {
        set margin $arguments(-margin)
        puts "Info: Setting margin to $margin"
    } else {
        set margin 1.8
        puts "Warning: No -margin attribute defined for [info script]"
        puts "Using default value of 1.8"
    }

    set core_llx [get_db [current_design] .core_bbox.ll.x]
    set core_lly [get_db [current_design] .core_bbox.ll.y]
    set core_urx [get_db [current_design] .core_bbox.ur.x]
    set core_ury [get_db [current_design] .core_bbox.ur.y]
    
    set boundary [lindex [get_db [current_design] .boundary] 0]
    # Put first point as last to make things simple
    lappend boundary [lindex $boundary 0]

    for {set i 0} {$i < [expr [llength $boundary] - 1]} {incr i} {
        set curr_x [lindex [lindex $boundary $i] 0]
        set curr_y [lindex [lindex $boundary $i] 1]
        set next_x [lindex [lindex $boundary [expr $i+1]] 0]
        set next_y [lindex [lindex $boundary [expr $i+1]] 1]
        
        if {$curr_x==$next_x} {
            # Vertical
            set mv_layers {Metal2 Metal4 Metal6 Metal8 Metal10 Via1 Via2 Via3 Via4 Via5 Via6 Via7 Via8 Via9 Via10}
            if {$curr_x < $core_llx} {
                # Left
                set area [list $curr_x $curr_y [expr $curr_x + $margin] $next_y]
                set name left
            } elseif {$curr_x > $core_urx} {
                # Right
                set area [list $curr_x $curr_y [expr $curr_x - $margin] $next_y]
                set name right
            } else {
                set name inner_${i}
                # Not bbox edge
                if {$curr_y < $next_y} {
                    # Left edge
                    set area [list $curr_x $curr_y [expr $next_x + $margin] $next_y]
                    if {[string match inner* $name]} {
                        # Need to fill corner
                        lset area 1 [expr [lindex $area 1] - $margin]
                    }
                } else {
                    # Right edge
                    set area [list $curr_x $curr_y [expr $next_x - $margin] $next_y]
                    if {[string match inner* $name]} {
                        # Need to fill corner
                        lset area 1 [expr [lindex $area 1] + $margin]
                    }
                }
                set name inner_${i}
            }
        } elseif {$curr_y==$next_y} {
            # Horizontal
            set mv_layers {Metal1 Metal3 Metal5 Metal7 Metal9 Metal11 Via1 Via2 Via3 Via4 Via5 Via6 Via7 Via8 Via9 Via10}
            if {$curr_y < $core_lly} {
                # Bottom
                set area [list $curr_x $curr_y $next_x [expr $curr_y + $margin]]
                set name bottom
            } elseif {$curr_y > $core_ury} {
                # Top
                set area [list $curr_x $curr_y $next_x [expr $curr_y - $margin]]
                set name top
            } else {
                set name inner_${i}
                # Not bbox edge
                if {$curr_x < $next_x} {
                    # Top edge
                    set area [list $curr_x $curr_y $next_x [expr $next_y - $margin]]
                    if {[string match inner* $name]} {
                        # Need to fill corner
                        lset area 0 [expr [lindex $area 0] - $margin]
                    }
                } else {
                    # Bottom edge
                    set area [list $curr_x $curr_y $next_x [expr $next_y + $margin]]
                    if {[string match inner* $name]} {
                        # Need to fill corner
                        lset area 0 [expr [lindex $area 0] + $margin]
                    }
                }
            }
        }

        foreach mv_layer $mv_layers {
            puts "Info: Creating routing blockage on edge #${i} for layer ${mv_layer}"
            create_route_blockage -except_pg_nets -layer ${mv_layer} \
                -name ${mv_layer}_${name}_edge_signal_blockage -area $area
        }
    }
}
define_proc_arguments invs_create_edge_route_blockages \
    -define_args {
        {-margin "Width of route blockage" 1.8 float optional}
    }
