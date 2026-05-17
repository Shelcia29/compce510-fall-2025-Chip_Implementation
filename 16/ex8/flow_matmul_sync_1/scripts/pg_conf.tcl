#######################
# Variable definition #
#######################

if {[llength [get_db insts -if {.is_memory}]]} {
    set mem_psdl "dbs/fp_mem_grid.tcl"
    set FH [open $mem_psdl w]
    
    puts $FH "\{ PATTERN stripe_Metal4 \{ TYPE STRIPE \} \{ DIRECTION VERTICAL \} \{ WIDTH 0.48 0.48 \} \{ SPACING 0.9 \} \}"
    puts $FH "\{ REGION"
    puts $FH "  \{ AREA area_mems"
    foreach mem [get_db insts -if {.is_memory}] {
        puts $FH "    \{ [lindex [get_db $mem .bbox] 0] \}"
    }
    puts $FH "  \}"
    puts $FH "  \{ LAYER Metal4 \{ SNAPTO GRID \}"
    puts $FH "    \{ METAL Metal4_VDD_VSS stripe_Metal4 \{ NET VDD VSS \} \{ STEPDISTANCE 4.8 \} \}"
    puts $FH "  \}"
    puts $FH "\}"
    close $FH
    
    route_pg -psdl $mem_psdl
} else {
    puts "No memories in design, skipping memory grids"
}

set pg_psdl "dbs/fp_main_grid.tcl"
set FH [open $pg_psdl w]

set mem_halos ""
foreach mem [get_db insts -if {.is_memory}] {
    append mem_halos "    \{ [lindex [get_db $mem .place_halo_bbox] 0] \}"
}

puts $FH "\{ PATTERN Metal1_followpin \{ TYPE FOLLOWPIN \} \}"
puts $FH "\{ PATTERN staple_Metal2  \{ TYPE STAPLE \} \{ DIRECTION VERTICAL \}   \{ WIDTH 0.08 \} \{ LENGTH AUTO \} \}"
puts $FH "\{ PATTERN staple_Metal3  \{ TYPE STAPLE \} \{ DIRECTION HORIZONTAL \} \{ WIDTH 0.08 \} \{ LENGTH AUTO \} \}"
puts $FH "\{ PATTERN staple_Metal4  \{ TYPE STAPLE \} \{ DIRECTION VERTICAL \}   \{ WIDTH 0.08 \} \{ LENGTH AUTO \} \}"
puts $FH "\{ PATTERN staple_Metal5  \{ TYPE STAPLE \} \{ DIRECTION HORIZONTAL \} \{ WIDTH 0.08 \} \{ LENGTH AUTO \} \}"
puts $FH "\{ PATTERN stripe_Metal6  \{ TYPE STRIPE \} \{ DIRECTION VERTICAL \}   \{ WIDTH 0.32 \} \}"
puts $FH "\{ PATTERN stripe_Metal7  \{ TYPE STRIPE \} \{ DIRECTION HORIZONTAL \} \{ WIDTH 0.32 \} \}"
puts $FH "\{ PATTERN stripe_Metal8  \{ TYPE STRIPE \} \{ DIRECTION VERTICAL \}   \{ WIDTH 0.32 \} \}"
puts $FH "\{ PATTERN stripe_Metal9  \{ TYPE STRIPE \} \{ DIRECTION HORIZONTAL \} \{ WIDTH 0.32 \} \}"
puts $FH "\{ PATTERN stripe_Metal10 \{ TYPE STRIPE \} \{ DIRECTION VERTICAL \}   \{ WIDTH 4.4 \} \}"
puts $FH "\{ PATTERN stripe_Metal11 \{ TYPE STRIPE \} \{ DIRECTION HORIZONTAL \} \{ WIDTH 4.4 \} \}"

puts $FH "\{ REGION \{ COREAREA \}"
puts $FH "  \{ LAYER Metal1"
puts $FH "    \{ METAL Metal1_VDD Metal1_followpin \{ NET VDD \} \}"
puts $FH "    \{ METAL Metal1_VSS Metal1_followpin \{ NET VSS \} \}"
puts $FH "  \}"
puts $FH "\}"
puts $FH "\{ REGION \{ DESIGNAREA \}"
puts $FH "  \{ LAYER Metal2 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal2_VDD staple_Metal2 \{ NET VDD \} \{ STEPDISTANCE 16.0 * BEFORESNAPPING \} \{ OFFSET 4.4 * \} \{ FOLLOW * Metal1_VDD \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "    \{ METAL Metal2_VSS staple_Metal2 \{ NET VSS \} \{ STEPDISTANCE 16.0 * BEFORESNAPPING \} \{ OFFSET 13.2 * \} \{ FOLLOW * Metal1_VSS \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal3 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal3_VDD staple_Metal3 \{ NET VDD \} \{ FOLLOW Metal2_VDD Metal1_VDD \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "    \{ METAL Metal3_VSS staple_Metal3 \{ NET VSS \} \{ FOLLOW Metal2_VSS Metal1_VSS \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal4 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal4_VDD staple_Metal4 \{ NET VDD \} \{ FOLLOW Metal2_VDD Metal3_VDD \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "    \{ METAL Metal4_VSS staple_Metal4 \{ NET VSS \} \{ FOLLOW Metal2_VSS Metal3_VSS \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal5 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal5_VDD staple_Metal5 \{ NET VDD \} \{ FOLLOW Metal4_VDD Metal3_VDD \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "    \{ METAL Metal5_VSS staple_Metal5 \{ NET VSS \} \{ FOLLOW Metal4_VSS Metal3_VSS \} \{ ALIGNMENT CENTER CENTER \} \}"
puts $FH "  \}"
puts $FH "\}"
puts $FH "\{ REGION \{ DESIGNAREA \}"
puts $FH "  \{ LAYER Metal6 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal6_VDD stripe_Metal6 \{ NET VDD \} \{ FOLLOW * Metal4_VDD \} \{ STEPDISTANCE 16.0 * BEFORESNAPPING \} \{ OFFSET 4.4 * \} \}"
puts $FH "    \{ METAL Metal6_VSS stripe_Metal6 \{ NET VSS \} \{ FOLLOW * Metal4_VSS \} \{ STEPDISTANCE 16.0 * BEFORESNAPPING \} \{ OFFSET 13.2 * \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal7 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal7_VDD stripe_Metal7 \{ NET VDD \} \{ STEPDISTANCE * 16.0 BEFORESNAPPING \} \{ OFFSET * 4.4 \} \}"
puts $FH "    \{ METAL Metal7_VSS stripe_Metal7 \{ NET VSS \} \{ STEPDISTANCE * 16.0 BEFORESNAPPING \} \{ OFFSET * 13.2 \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal8 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal8_VDD stripe_Metal8 \{ NET VDD \} \{ FOLLOW Metal6_VDD * \} \}"
puts $FH "    \{ METAL Metal8_VSS stripe_Metal8 \{ NET VSS \} \{ FOLLOW Metal6_VSS * \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal9 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal9_VDD stripe_Metal9 \{ NET VDD \} \{ FOLLOW * Metal7_VDD \} \}"
puts $FH "    \{ METAL Metal9_VSS stripe_Metal9 \{ NET VSS \} \{ FOLLOW * Metal7_VSS \} \}"
puts $FH "  \}"
puts $FH "\}"
puts $FH "\{ REGION \{ DESIGNAREA \}"
puts $FH "  \{ LAYER Metal10 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal10_VDD stripe_Metal10 \{ NET VDD \} \{ STEPDISTANCE 16 BEFORESNAPPING \} \{ OFFSET 4.4 * \} \}"
puts $FH "    \{ METAL Metal10_VSS stripe_Metal10 \{ NET VSS \} \{ STEPDISTANCE 16 BEFORESNAPPING \} \{ OFFSET 13.2 * \} \}"
puts $FH "  \}"
puts $FH "  \{ LAYER Metal11 \{ SNAPTO GRID \}"
puts $FH "    \{ METAL Metal11_VDD stripe_Metal11 \{ NET VDD \} \{ STEPDISTANCE 16 BEFORESNAPPING \} \{ OFFSET * 4.4 \} \}"
puts $FH "    \{ METAL Metal11_VSS stripe_Metal11 \{ NET VSS \} \{ STEPDISTANCE 16 BEFORESNAPPING \} \{ OFFSET * 13.2 \} \}"
puts $FH "  \}"
puts $FH "\}"
close $FH
route_pg -psdl $pg_psdl
