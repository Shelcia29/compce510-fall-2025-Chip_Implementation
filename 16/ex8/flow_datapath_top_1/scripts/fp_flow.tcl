#read_db dbs/floorplan.init_floorplan.ERROR.enc/
read_db dbs/floorplan.enc/

# No explanation for these settings.
set_db floorplan_snap_place_blockage inst
set_db floorplan_row_site_height any
set_db floorplan_row_site_width any
set_db floorplan_minimum_sites 10
set_db floorplan_narrow_channel_threshold 8.18

set_db floorplan_check_types {basic odd_even_site_row macro_pin color place alignment_following_pin alignment_partition_clone partition same_length_site narrow_channel}

#################################################################
# create floorplan shape & place pins
#################################################################
# next ones define core margins. Use enough spacing
set_db floorplan_user_define_grid {1.8 1.8 0.0 0.0}
set_db floorplan_snap_core_grid manufacturing
set_db floorplan_snap_die_grid manufacturing
set_db floorplan_snap_block_grid user_define
set_db floorplan_snap_constraint_grid user_define
set_db floorplan_snap_io_grid inst

# Define variables for floorplan size.
# Target a utilization of 60%
# X-size should be a multiple of 0.2
# Y-size should be a multiple of 1.71
set die_x [expr 0.2 * 15000]
set die_y [expr 1.71 * 1750]

# Margin sets a spacing between the die-area edge of the floorplan (where
# pins are placed) and the core-area where standard cells are placed
# margins are more or less "magic numbers"
set x_margin 4.0
set y_margin 3.42

set core_y_targ [expr $die_y - [expr 2 * $y_margin]]
set core_x_targ [expr $die_x - [expr 2 * $x_margin]]

# To create a floorplan from scratch:
create_floorplan -core_margins_by die -site CoreSite -core_size $core_x_targ $core_y_targ $x_margin $y_margin $x_margin $y_margin -no_snap_to_grid

# If a DEF-template is available, use the following command instead of "create_floorplan":
#read_def /path_to_def/design.def.gz

# If reading in a DEF-template, remove power routing, endcaps & welltaps + all blockages.
# If not reading in a DEF-file, these commands just do not do anything.
delete_routes -type special
delete_filler -prefix ENDCAP
delete_filler -prefix WELLTAP
# Note, there shouldn't be any preplaced standard cells in DEF!
# unplace_obj -insts 
set_db selected [get_db route_blockages]
delete_selected_from_floorplan 
set_db selected [get_db place_blockages]
delete_selected_from_floorplan 


# Then start placing your memories and macros
# Set snapping options for memory grid
# What snapping grid should you use? What this affects is that do power grids align between
# a macro/mem & toplevel
set_db floorplan_user_define_grid {4.0 3.2 16.0 16.15}

# Place MEMs manually here
# Note: normally pins are placed after power grid, now we need pins placement for datapath-analysis
edit_pin -pin_width 0.08 -pin_depth 0.25 -fix_overlap 1 -unit track -spread_direction counterclockwise -side left -layer 7 -spread_type start -spacing 5 -start "0.0 2700.0" -pin [get_db [get_db ports * -if {.direction==in}] .name]
edit_pin -pin_width 0.08 -pin_depth 0.25 -fix_overlap 1 -unit track -spread_direction counterclockwise -side bottom -layer 8 -spread_type start -spacing 5 -start "100.0 0.0" -pin [get_db [get_db ports * -if {.direction==out}] .name]

# Set snapping options for macro grid

# Place MACROs manually here
#set_db floorplan_user_define_grid {xx xx xx xx}

# automatic macro placement
source scripts/golden_mimic_power_mesh.tcl
set_db place_global_align_macro true
set_db place_design_refine_macro true
set_db place_global_place_io_pins false
place_design -concurrent_macros -no_pre_place_opt
unplace_obj -insts

set_macro_place_constraint -all_macros -orientation R0
set_macro_place_constraint -min_space_to_macro 40.0
set_macro_place_constraint -halo_sharing true
set_macro_place_constraint -honor_strict_spacing_constraint true
set_macro_place_constraint -max_io_pin_group_keep_out "40 20"
place_macro_detail
# create missing rows/recreate rows
delete_row -all
create_row -site CoreSite

# Create a placement halo around all macros. Standard cells cannot be placed
# right next to memories or macros or they will create DRC errors
create_place_halo -halo_deltas 2.0 1.71 2.0 1.71 -snap_to_site -all_macros

# split_row removes placement rows from under memories, macros and hard placement blockages (such as halos)
split_row

# there should not be any errors in check_floorplan
set_db floorplan_user_define_grid {0.2 1.71 0.2 1.71}
check_floorplan

#################################################################
# Add endcaps
#################################################################
# Note: No endcaps in gpdk045

#################################################################
# Add welltaps
#################################################################
# Note: No welltaps in gpdk045

#################################################################
# Route blockages 
#################################################################
# Create edge blockages for routes along sides to prevent crosstalk from routing to/from toplevel
set_db selected ""
source scripts/invs_create_edge_route_blockages.tcl
invs_create_edge_route_blockages -margin 2.0

#################################################################
# Create power grid
#################################################################

# CREATE POWER GRID
source scripts/pg_conf.tcl

# pins already placed before...

# After pins are all ok: fix all ports locations
set_db [get_db ports] .place_status fixed

#################################################################
# Write DEF
#################################################################
# Def-file is what is used to give synthesis-software information about floorplan:
# size, placement of pins, memories, macros, etc.
write_def -floorplan -no_std_cells floorplan_def/[get_db [current_design] .name].def.gz     
