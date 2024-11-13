## make file into multiple small files? add [diag]s?




# ###########################################################################
#   Created by: Olin Calvin (INL)
#   Start Date: Jun 29, 2023
#   Revision Date: Aug 9, 2023
#   Version Number: 96
#   Project: AGN Reactor
#   Description: Research reactor with some control rod channels
#   Input units: cm
#   Mesh units: cm
# ###########################################################################

# Abbreviations used:
# AG: Air Gap
# AT: Aluminum Tank
# CIF: Central Irradiation Facility
# IG: Inner Graphite
# OG: Outer Graphite
# TRI: Triangular elements
# QUAD: Quadrilateral elements
# RT: Reactor Tank
# UBP: Upper Beam Port
# XYDG: XYDelaunayGenerator
# TF: Thermal Fuse

# Used for more easily calling pi in functions
# constant_names = 'pi'
# constant_expressions = '${fparse pi}'

# Reactor dimensions
# Radii and thicknesses
core_radius = 12.8
ig_thickness = 3.3
# fparse lets us calculate things via mathematical operations
ig_radius = '${fparse ${core_radius} + ${ig_thickness}}'
at_thickness = 0.165
at_radius = '${fparse ${ig_radius} + ${at_thickness}}'
og_thickness = 20.0
og_radius = '${fparse ${at_radius} + ${og_thickness}}'
lead_thickness = 10.0
lead_radius = '${fparse ${og_radius} + ${lead_thickness}}'
ag_thickness = 0.435
ag_radius = '${fparse ${lead_radius} + ${ag_thickness}}'
rt_thickness = 0.8
rt_radius = '${fparse ${ag_radius} + ${rt_thickness}}'
water_thickness = 55.0
water_radius = '${fparse ${rt_radius} + ${water_thickness}}'
# This is used for the outer background of PCCMG
# We will delete this later, but it needs to be big enough to encompass the outermost ring of the reactor.
# In theory, will the apothem style as long as this is bigger than the outermost ring radius, it should be fine.
# reactor_bg_size = '${fparse ${water_radius} + 1.0}'

# Control rod channels
# SR has same radii
sr_inner_radius = 2.3
sr_outer_radius = 2.5
# For PCCMG we have to give a background large enough to not conflict with the inner rings
sr_bg_size = '${fparse ${sr_outer_radius} + 0.5}'
# CCR, guessing this is the same as the SRs?
ccr_inner_radius = 2.3
ccr_outer_radius = 2.5
ccr_bg_size = '${fparse ccr_outer_radius + 0.5}'
# FCR
fcr_inner_radius = 1.15
fcr_outer_radius = 1.35
fcr_bg_size = '${fparse fcr_outer_radius + 0.5}'
# X-Y positions of the CENTER of each rod
sr1_x_pos = 5.0
sr1_y_pos = 5.0
sr2_x_pos = 5.0
sr2_y_pos = -5.0
ccr_x_pos = -5.0
ccr_y_pos = 5.0
fcr_x_pos = -5.0
fcr_y_pos = -5.0
# CIF
# With uniform extrusion this will end up as a square, so be aware of that.
#cif_inner_radius = 1.1
cif_inner_radius = 0.63365
#cif_outer_thickness = 0.33
cif_outer_thickness = ${cif_inner_radius}
cif_outer_radius = '${fparse cif_inner_radius + cif_outer_thickness}'

# Because of modeling the CIF as a square, the channel is no longer large enough to accommodate the circular thermal fuse
# So we model the thermal fuse as a square which will fit and is much easier to model.
tf_side_length = 2.41054
tf_half_side_length = '${fparse tf_side_length / 2.0}'
tf_num_segments = 2
tf_support_radius = 0.79375

# angle from the origin to where the CIF intersects with the core boundary
cif_core_angle = '${fparse asin(cif_outer_radius / core_radius)}'
pi_minus_2_cca = '${fparse pi-2*cif_core_angle}'
double_pi_minus_4_cca = '${fparse 2*pi-4*cif_core_angle}'
cif_core_y_coord = '${fparse core_radius * sin(cif_core_angle)}'
cif_core_x_coord = '${fparse core_radius * cos(cif_core_angle)}'
# angle from the origin the where the CIF intersects with the inner graphite
cif_ig_angle = '${fparse asin(cif_outer_radius / ig_radius)}'
pi_minus_2_ciga = '${fparse pi-2*cif_ig_angle}'
pi_minus_3_ciga = '${fparse pi-3*cif_ig_angle}'
# double_pi_minus_4_ciga = '${fparse 2*pi-4*cif_ig_angle}'
cif_ig_y_coord = '${fparse ig_radius * sin(cif_ig_angle)}'
cif_ig_x_coord = '${fparse ig_radius * cos(cif_ig_angle)}'
cif_ig_core_angle = '${fparse acos(core_radius * cos(cif_core_angle) / ig_radius)}'
# angle from the origin where the CIF intersects with the Al tank
cif_at_angle = '${fparse asin(cif_outer_radius / at_radius)}'
pi_minus_2_cata = '${fparse pi-2*cif_at_angle}'
pi_minus_3_cata = '${fparse pi-3*cif_at_angle}'
# double_pi_minus_4_cata = '${fparse 2*pi-4*cif_at_angle}'
cif_at_y_coord = '${fparse at_radius * sin(cif_at_angle)}'
cif_at_x_coord = '${fparse at_radius * cos(cif_at_angle)}'
cif_at_ig_angle = '${fparse acos(ig_radius * cos(cif_ig_angle) / at_radius)}'

# Upper Beam Port dimensions
ubp_center_x_coord = 21.5
# ubp_inner_radius = 5.0
ubp_inner_radius = 2.2683
# ubp_al_thickness = 0.119
ubp_al_thickness = ${ubp_inner_radius}
ubp_outer_radius = '${fparse ubp_inner_radius + ubp_al_thickness}'
ubp_x_coord_1 = '${fparse ubp_center_x_coord - ubp_outer_radius}'
ubp_x_coord_2 = '${fparse ubp_x_coord_1 + ubp_al_thickness}'
ubp_x_coord_3 = '${fparse ubp_x_coord_2 + 2*ubp_inner_radius}'
ubp_x_coord_4 = '${fparse ubp_x_coord_3 + ubp_al_thickness}'

# There are lots of angles needed for the intersections between the UBPs and the outer radial regions
# The way I structure this to make the naming "easier" or at least more concise,
# I structure the angles as follows
# Starting from the x=0 midplane of the reactor and moving in the positive x-direction
# the angles are numbered 1, 2, 3, 4.
# Same numbering for the y-coordinates of the intersections.
# angle from the origin where the CIF intersects with the UBP within the outer graphite
cif_ubp_og_inner_radius = '${fparse sqrt(cif_outer_radius*cif_outer_radius + ubp_x_coord_1*ubp_x_coord_1)}'
cif_ubp_og_inner_angle = '${fparse atan(cif_outer_radius / ubp_x_coord_1)}'
# pi_minus_2_cuoia = '${fparse pi-2*cif_ubp_og_inner_angle}'
# pi_minus_3_cuoia = '${fparse pi-3*cif_ubp_og_inner_angle}'
# double_pi_minus_4_cuoia = '${fparse 2*pi-4*cif_ubp_og_inner_angle}'
cif_uoi_y_coord = '${fparse cif_ubp_og_inner_radius * sin(cif_ubp_og_inner_angle)}'
# cif_uoi_x_coord = '${fparse cif_ubp_og_inner_radius * cos(cif_ubp_og_inner_angle)}'
cif_uoi_at_angle = '${fparse acos(at_radius * cos(cif_at_angle) / cif_ubp_og_inner_radius)}'
# UBP Outer Graphite Angles
ubp_og_angle_1 = '${fparse acos(ubp_x_coord_1 / og_radius)}'
ubp_og_y_coord_1 = '${fparse og_radius*sin(ubp_og_angle_1)}'
ubp_og_angle_2 = '${fparse acos(ubp_x_coord_2 / og_radius)}'
ubp_og_y_coord_2 = '${fparse og_radius*sin(ubp_og_angle_2)}'
ubp_og_angle_3 = '${fparse acos(ubp_x_coord_3 / og_radius)}'
ubp_og_y_coord_3 = '${fparse og_radius*sin(ubp_og_angle_3)}'
ubp_og_angle_4 = '${fparse acos(ubp_x_coord_4 / og_radius)}'
ubp_og_y_coord_4 = '${fparse og_radius*sin(ubp_og_angle_4)}'
cif_og_angle = '${fparse asin(cif_outer_radius / og_radius)}'
cif_og_x_coord = '${fparse og_radius*cos(cif_og_angle)}'

# UBP Lead Angles
ubp_lead_angle_1 = '${fparse acos(ubp_x_coord_1 / lead_radius)}'
ubp_lead_y_coord_1 = '${fparse lead_radius*sin(ubp_lead_angle_1)}'
ubp_lead_angle_2 = '${fparse acos(ubp_x_coord_2 / lead_radius)}'
ubp_lead_y_coord_2 = '${fparse lead_radius*sin(ubp_lead_angle_2)}'
ubp_lead_angle_3 = '${fparse acos(ubp_x_coord_3 / lead_radius)}'
ubp_lead_y_coord_3 = '${fparse lead_radius*sin(ubp_lead_angle_3)}'
ubp_lead_angle_4 = '${fparse acos(ubp_x_coord_4 / lead_radius)}'
ubp_lead_y_coord_4 = '${fparse lead_radius*sin(ubp_lead_angle_4)}'
cif_lead_angle = '${fparse asin(cif_outer_radius / lead_radius)}'
cif_lead_x_coord = '${fparse lead_radius*cos(cif_lead_angle)}'

# UBP Air Gap Angles
ubp_ag_angle_1 = '${fparse acos(ubp_x_coord_1 / ag_radius)}'
ubp_ag_y_coord_1 = '${fparse ag_radius*sin(ubp_ag_angle_1)}'
ubp_ag_angle_2 = '${fparse acos(ubp_x_coord_2 / ag_radius)}'
ubp_ag_y_coord_2 = '${fparse ag_radius*sin(ubp_ag_angle_2)}'
ubp_ag_angle_3 = '${fparse acos(ubp_x_coord_3 / ag_radius)}'
ubp_ag_y_coord_3 = '${fparse ag_radius*sin(ubp_ag_angle_3)}'
ubp_ag_angle_4 = '${fparse acos(ubp_x_coord_4 / ag_radius)}'
ubp_ag_y_coord_4 = '${fparse ag_radius*sin(ubp_ag_angle_4)}'
cif_ag_angle = '${fparse asin(cif_outer_radius / ag_radius)}'
cif_ag_x_coord = '${fparse ag_radius*cos(cif_ag_angle)}'

# UBP Reactor Tank Angles
ubp_rt_angle_1 = '${fparse acos(ubp_x_coord_1 / rt_radius)}'
ubp_rt_y_coord_1 = '${fparse rt_radius*sin(ubp_rt_angle_1)}'
ubp_rt_angle_2 = '${fparse acos(ubp_x_coord_2 / rt_radius)}'
ubp_rt_y_coord_2 = '${fparse rt_radius*sin(ubp_rt_angle_2)}'
ubp_rt_angle_3 = '${fparse acos(ubp_x_coord_3 / rt_radius)}'
ubp_rt_y_coord_3 = '${fparse rt_radius*sin(ubp_rt_angle_3)}'
ubp_rt_angle_4 = '${fparse acos(ubp_x_coord_4 / rt_radius)}'
ubp_rt_y_coord_4 = '${fparse rt_radius*sin(ubp_rt_angle_4)}'
cif_rt_angle = '${fparse asin(cif_outer_radius / rt_radius)}'
cif_rt_x_coord = '${fparse rt_radius*cos(cif_rt_angle)}'

# UBP Water Angles
ubp_water_angle_1 = '${fparse acos(ubp_x_coord_1 / water_radius)}'
ubp_water_y_coord_1 = '${fparse water_radius*sin(ubp_water_angle_1)}'
ubp_water_angle_2 = '${fparse acos(ubp_x_coord_2 / water_radius)}'
ubp_water_y_coord_2 = '${fparse water_radius*sin(ubp_water_angle_2)}'
ubp_water_angle_3 = '${fparse acos(ubp_x_coord_3 / water_radius)}'
ubp_water_y_coord_3 = '${fparse water_radius*sin(ubp_water_angle_3)}'
ubp_water_angle_4 = '${fparse acos(ubp_x_coord_4 / water_radius)}'
ubp_water_y_coord_4 = '${fparse water_radius*sin(ubp_water_angle_4)}'
cif_water_angle = '${fparse asin(cif_outer_radius / water_radius)}'
cif_water_x_coord = '${fparse water_radius*cos(cif_water_angle)}'

# Meshing Refinement Parameters
# Impact how coarse/fine the mesh is
# How many sides we want the polygons used for the overall reactor to have.
# We can't mesh an actual circle, so this determines how "close" to a circle we are
# reactor_polygon_num_sides = '12'
# This one is smaller so we sacrifice some refinement
sr_polygon_num_sides = '8'
ccr_polygon_num_sides = ${sr_polygon_num_sides}
fcr_polygon_num_sides = ${sr_polygon_num_sides}
# We can then divide each side into a number of sectors for further refinement.
# This should be an even number
# rp_nsps: reactor polygon number of sectors per side
# rp_nsps = 6
sr_nsps = 2
ccr_nsps = ${sr_nsps}
fcr_nsps = ${sr_nsps}
# Technically you can vary the number of sectors on each side of a polygon, but we will keep things uniform for now.
# Define the vector here which we can then just pass into the mesh generator
# reactor_polygon_num_sectors_per_side_vector = '${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps} ${rp_nsps}'
sr_polygon_num_sectors_per_side_vector = '${sr_nsps} ${sr_nsps} ${sr_nsps} ${sr_nsps} ${sr_nsps} ${sr_nsps} ${sr_nsps} ${sr_nsps}'
ccr_polygon_num_sectors_per_side_vector = '${ccr_nsps} ${ccr_nsps} ${ccr_nsps} ${ccr_nsps} ${ccr_nsps} ${ccr_nsps} ${ccr_nsps} ${ccr_nsps}'
fcr_polygon_num_sectors_per_side_vector = '${fcr_nsps} ${fcr_nsps} ${fcr_nsps} ${fcr_nsps} ${fcr_nsps} ${fcr_nsps} ${fcr_nsps} ${fcr_nsps}'

# Block IDs and Names
# Note: Sometimes you'll do something to the mesh and you might lose the block ID or block name
# along the way. So I might have a mesh block which is just re-assigning IDs/names as a result.
core_block_id = 10
core_block_name = core
core_cif_wall_block_id = 11
core_cif_wall_block_name = core_cif_wall
# core_cif_channel_block_id = 12
# core_cif_channel_block_name = core_cif_channel
# temp_core_block_name = temp_core
ig_block_id = 20
ig_block_name = ig
ig_quad_block_id = 21
ig_quad_block_name = ig_quad
ig_cif_wall_block_id = 22
ig_cif_wall_block_name = ig_cif_wall
# ig_cif_channel_block_id = 23
# ig_cif_channel_block_name = ig_cif_channel
at_block_id = 30
at_block_name = at
at_quad_block_id = 31
at_quad_block_name = at_quad
at_cif_wall_block_id = 32
at_cif_wall_block_name = at_cif_wall
# at_cif_channel_block_id = 33
# at_cif_channel_block_name = at_cif_channel
og_block_id = 40
og_block_name = og
og_cif_wall_block_id = 41
og_cif_wall_block_name = og_cif_wall
# og_cif_channel_block_id = 42
# og_cif_channel_block_name = og_cif_channel
og_ubp_wall_block_id = 43
og_ubp_wall_block_name = og_ubp_wall
og_ubp_channel_block_id = 44
og_ubp_channel_block_name = og_ubp_channel
og_cif_wall_ubp_wall_block_id = 45
og_cif_wall_ubp_wall_block_name = og_cif_wall_ubp_wall
og_cif_wall_ubp_channel_block_id = 46
og_cif_wall_ubp_channel_block_name = og_cif_wall_ubp_channel
# og_cif_channel_ubp_wall_block_id = 47
# og_cif_channel_ubp_wall_block_name = og_cif_channel_ubp_wall
# og_cif_channel_ubp_channel_block_id = 48
# og_cif_channel_ubp_channel_block_name = og_cif_channel_ubp_channel
lead_block_id = 50
lead_block_name = lead
lead_quad_block_id = 51
lead_quad_block_name = lead_quad
lead_cif_wall_block_id = 52
lead_cif_wall_block_name = lead_cif_wall
# lead_cif_channel_block_id = 53
# lead_cif_channel_block_name = lead_cif_channel
lead_ubp_wall_block_id = 54
lead_ubp_wall_block_name = lead_ubp_wall
lead_ubp_channel_block_id = 55
lead_ubp_channel_block_name = lead_ubp_channel
ag_block_id = 60
ag_block_name = ag
ag_cif_wall_block_id = 61
ag_cif_wall_block_name = ag_cif_wall
# ag_cif_channel_block_id = 62
# ag_cif_channel_block_name = ag_cif_channel
ag_ubp_wall_block_id = 63
ag_ubp_wall_block_name = ag_ubp_wall
ag_ubp_channel_block_id = 64
ag_ubp_channel_block_name = ag_ubp_channel
ag_quad_block_id = 65
ag_quad_block_name = ag_quad
rt_block_id = 70
rt_block_name = rt
rt_quad_block_id = 71
rt_quad_block_name = rt_quad
rt_cif_wall_block_id = 72
rt_cif_wall_block_name = rt_cif_wall
# rt_cif_channel_block_id = 73
# rt_cif_channel_block_name = rt_cif_channel
rt_ubp_wall_block_id = 74
rt_ubp_wall_block_name = rt_ubp_wall
rt_ubp_channel_block_id = 75
rt_ubp_channel_block_name = rt_ubp_channel
water_block_id = 80
water_block_name = water
# Need special ID for QUAD elements
water_quad_block_id = 81
water_quad_block_name = water_quad
water_cif_wall_block_id = 82
water_cif_wall_block_name = water_cif_wall
# water_cif_channel_block_id = 83
# water_cif_channel_block_name = water_cif_channel
water_ubp_wall_block_id = 84
water_ubp_wall_block_name = water_ubp_wall
water_ubp_channel_block_id = 85
water_ubp_channel_block_name = water_ubp_channel
cif_wall_block_id = 90
# cif_wall_block_name = cif_wall
cif_channel_block_id = 91
cif_channel_block_name = cif_channel
cif_channel_quad_block_id = 92
cif_channel_quad_block_name = cif_channel_quad
bp_wall_block_id = 100
# bp_wall_block_name = bp_wall
bp_channel_block_id = 101
bp_channel_block_name = bp_channel
fuel_plate_1_block_id = 110
fuel_plate_1_block_name = fuel_plate_1
fuel_plate_2_block_id = '${fparse fuel_plate_1_block_id + 1}'
fuel_plate_2_block_name = fuel_plate_2
fuel_plate_3_block_id = '${fparse fuel_plate_2_block_id + 1}'
fuel_plate_3_block_name = fuel_plate_3
fuel_plate_4_block_id = '${fparse fuel_plate_3_block_id + 1}'
fuel_plate_4_block_name = fuel_plate_4
fuel_plate_5_block_id = '${fparse fuel_plate_4_block_id + 1}'
fuel_plate_5_block_name = fuel_plate_5
fuel_plate_6_block_id = '${fparse fuel_plate_5_block_id + 1}'
fuel_plate_6_block_name = fuel_plate_6
fuel_plate_7_block_id = '${fparse fuel_plate_6_block_id + 1}'
fuel_plate_7_block_name = fuel_plate_7
fuel_plate_8_block_id = '${fparse fuel_plate_7_block_id + 1}'
fuel_plate_8_block_name = fuel_plate_8
fuel_plate_9_block_id = '${fparse fuel_plate_8_block_id + 1}'
fuel_plate_9_block_name = fuel_plate_9
rad_block_id = '${fparse fuel_plate_9_block_id + 1}'
rad_block_name = rad
fuel_plate_1_quad_block_id = 130
# fuel_plate_1_quad_block_name = fuel_plate_1_quad
fuel_plate_2_quad_block_id = '${fparse fuel_plate_1_quad_block_id + 1}'
# fuel_plate_2_quad_block_name = fuel_plate_2_quad
fuel_plate_3_quad_block_id = '${fparse fuel_plate_2_quad_block_id + 1}'
# fuel_plate_3_quad_block_name = fuel_plate_3_quad
fuel_plate_4_quad_block_id = '${fparse fuel_plate_3_quad_block_id + 1}'
# fuel_plate_4_quad_block_name = fuel_plate_4_quad
fuel_plate_5_quad_block_id = '${fparse fuel_plate_4_quad_block_id + 1}'
fuel_plate_5_quad_block_name = fuel_plate_5_quad
fuel_plate_6_quad_block_id = '${fparse fuel_plate_5_quad_block_id + 1}'
fuel_plate_6_quad_block_name = fuel_plate_6_quad
fuel_plate_7_quad_block_id = '${fparse fuel_plate_6_quad_block_id + 1}'
fuel_plate_7_quad_block_name = fuel_plate_7_quad
fuel_plate_8_quad_block_id = '${fparse fuel_plate_7_quad_block_id + 1}'
fuel_plate_8_quad_block_name = fuel_plate_8_quad
fuel_plate_9_quad_block_id = '${fparse fuel_plate_8_quad_block_id + 1}'
fuel_plate_9_quad_block_name = fuel_plate_9_quad
rad_quad_block_id = '${fparse fuel_plate_9_quad_block_id + 1}'
rad_quad_block_name = rad_quad
tf_block_id = 200
tf_block_name = tf
tf_quad_block_id = '${fparse tf_block_id + 1}'
tf_quad_block_name = tf_quad
tf_support_block_id = 210
tf_support_block_name = tf_support
# tf_support_quad_block_id = '${fparse tf_support_block_id + 1}'
# tf_support_quad_block_name = tf_support_quad
sr1_inner_block_id = 1011
sr1_inner_block_name = sr1_inner
sr1_outer_block_id = 1012
sr1_outer_block_name = sr1_outer
sr2_inner_block_id = 1021
sr2_inner_block_name = sr2_inner
sr2_outer_block_id = 1022
sr2_outer_block_name = sr2_outer
ccr_inner_block_id = 1031
ccr_inner_block_name = ccr_inner
ccr_outer_block_id = 1032
ccr_outer_block_name = ccr_outer
fcr_inner_block_id = 1041
fcr_inner_block_name = fcr_inner
fcr_outer_block_id = 1042
fcr_outer_block_name = fcr_outer
# We assign this block ID/name whenever we plan to delete something.
# If we see this in the final mesh, we messed up somewhere!
to_delete_block_id = 10000
to_delete_block_name = to_delete

# This is the ID we use when assigning boundary IDs
boundary_id_index_01 = 10001
boundary_id_index_02 = '${fparse boundary_id_index_01 + 1}'
boundary_id_index_03 = '${fparse boundary_id_index_02 + 1}'
boundary_id_index_04 = '${fparse boundary_id_index_03 + 1}'
boundary_id_index_05 = '${fparse boundary_id_index_04 + 1}'
boundary_id_index_06 = '${fparse boundary_id_index_05 + 1}'
boundary_id_index_07 = '${fparse boundary_id_index_06 + 1}'
boundary_id_index_08 = '${fparse boundary_id_index_07 + 1}'
boundary_id_index_09 = '${fparse boundary_id_index_08 + 1}'
boundary_id_index_10 = '${fparse boundary_id_index_09 + 1}'
boundary_id_index_11 = '${fparse boundary_id_index_10 + 1}'
boundary_id_index_12 = '${fparse boundary_id_index_11 + 1}'
boundary_id_index_13 = '${fparse boundary_id_index_12 + 1}'
boundary_id_index_14 = '${fparse boundary_id_index_13 + 1}'
boundary_id_index_15 = '${fparse boundary_id_index_14 + 1}'
boundary_id_index_16 = '${fparse boundary_id_index_15 + 1}'
boundary_id_index_17 = '${fparse boundary_id_index_16 + 1}'
boundary_id_index_18 = '${fparse boundary_id_index_17 + 1}'
boundary_id_index_19 = '${fparse boundary_id_index_18 + 1}'
boundary_id_index_20 = '${fparse boundary_id_index_19 + 1}'
boundary_id_index_21 = '${fparse boundary_id_index_20 + 1}'
boundary_id_index_22 = '${fparse boundary_id_index_21 + 1}'
boundary_id_index_23 = '${fparse boundary_id_index_22 + 1}'
boundary_id_index_24 = '${fparse boundary_id_index_23 + 1}'
boundary_id_index_25 = '${fparse boundary_id_index_24 + 1}'
boundary_id_index_26 = '${fparse boundary_id_index_25 + 1}'
boundary_id_index_27 = '${fparse boundary_id_index_26 + 1}'
boundary_id_index_28 = '${fparse boundary_id_index_27 + 1}'
boundary_id_index_30 = '${fparse boundary_id_index_28 + 1}'
boundary_id_index_40 = '${fparse boundary_id_index_30 + 1}'
boundary_id_index_41 = '${fparse boundary_id_index_40 + 1}'
boundary_id_index_45 = '${fparse boundary_id_index_41 + 1}'

xydg_area = 1.5

# Number of intervals used by ParsedCurveGenerators
# Number of intervals on semi-circle curves
semi_circle_num_intervals = 30
# Number of intervals on the curve between the 2 beam ports
curve_between_bp_num_intervals = 24
# Outer Graphite UBP number of intervals
og_ubp_num_intervals = 24
lead_ubp_num_intervals = 10
ag_ubp_num_intervals = 1
rt_ubp_num_intervals = 1
water_ubp_num_intervals = 40
water_past_ubp_num_intervals = '${fparse 2*curve_between_bp_num_intervals}'
# Number of intervals for the thickness of the UBP walls
ubp_wall_num_intervals = 1
# Number of intervals in the UBP channel
ubp_channel_num_intervals = 8
cif_wall_num_intervals = 1
# cif_channel_num_intervals = 1
cif_core_num_intervals = 24
ig_num_intervals = 4
at_num_intervals = 1
# Number of outer graphite intervals before UBP
og_num_intervals_before_ubp = 1

[GlobalParams]
  # For debugging
  # show_info = true
[]

[Mesh]
  [top_half_core_boundary]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_core_angle};
                 t2:=t+3*${cif_core_angle};
                 x1:=${core_radius}*cos(t1);
                 x2:=${core_radius}*cos(t2);
                 if(t<${fparse pi-2*cif_core_angle},x1,x2)'
    y_formula = 't1:=t+${cif_core_angle};
                 y1:=${core_radius}*sin(t1);
                 y2:=${cif_core_y_coord};
                 if(t<${fparse pi-2*cif_core_angle},y1,y2)'
    section_bounding_t_values = '0 ${fparse pi-2*cif_core_angle} ${fparse 2*pi-4*cif_core_angle}'
    nums_segments = '${semi_circle_num_intervals} ${cif_core_num_intervals}'
    is_closed_loop = true
  []
  # Try to use PCCMG instead of XYDG since there are inner and outer rings of the rods.
  [sr1_base]
    type = PolygonConcentricCircleMeshGenerator
    polygon_size_style = apothem
    polygon_size = ${sr_bg_size}
    num_sides = ${sr_polygon_num_sides}
    num_sectors_per_side = ${sr_polygon_num_sectors_per_side_vector}
    background_intervals = 1
    # I'm just making these up
    ring_radii = '${sr_inner_radius} ${sr_outer_radius}'
    ring_intervals = '1 1'
    # This means we will have quads everywhere, which avoids TRI/QUAD conflicts
    # during block ID assignment and looks better a lot of the time.
    quad_center_elements = true
    background_block_ids = '${to_delete_block_id}'
    background_block_names = '${to_delete_block_name}'
    ring_block_ids = '${sr1_inner_block_id} ${sr1_outer_block_id}'
    ring_block_names = '${sr1_inner_block_name} ${sr1_outer_block_name}'
    interface_boundary_id_shift = 10
  []
  # Delete background around SR1
  [sr1_delete_bg]
    type = BlockDeletionGenerator
    input = sr1_base
    block = '${to_delete_block_name}'
    new_boundary = ${boundary_id_index_01}
  []
  [sr1_transform]
    type = TransformGenerator
    input = sr1_delete_bg
    transform = TRANSLATE
    vector_value = '${sr1_x_pos} ${sr1_y_pos} 0.0'
  []
  # Now add the CCR
  [ccr_base]
    type = PolygonConcentricCircleMeshGenerator
    polygon_size_style = apothem
    polygon_size = ${ccr_bg_size}
    num_sides = ${ccr_polygon_num_sides}
    num_sectors_per_side = ${ccr_polygon_num_sectors_per_side_vector}
    background_intervals = 1
    ring_radii = '${ccr_inner_radius} ${ccr_outer_radius}'
    ring_intervals = '1 1'
    # This means we will have quads everywhere, which avoids TRI/QUAD conflicts
    # during block ID assignment and looks better a lot of the time.
    quad_center_elements = true
    background_block_ids = '${to_delete_block_id}'
    background_block_names = '${to_delete_block_name}'
    ring_block_ids = '${ccr_inner_block_id} ${ccr_outer_block_id}'
    ring_block_names = '${ccr_inner_block_name} ${ccr_outer_block_name}'
    interface_boundary_id_shift = 30
  []
  # Delete background around CCR
  [ccr_delete_bg]
    type = BlockDeletionGenerator
    input = ccr_base
    block = '${to_delete_block_name}'
    new_boundary = ${boundary_id_index_03}
  []
  [ccr_transform]
    type = TransformGenerator
    input = ccr_delete_bg
    transform = TRANSLATE
    vector_value = '${ccr_x_pos} ${ccr_y_pos} 0.0'
  []
  # This is what actually meshes the core region and around the holes we carved
  [xydg_mesh_top_half_core]
    type = XYDelaunayGenerator
    boundary = 'top_half_core_boundary'
    holes = 'sr1_transform ccr_transform'
    stitch_holes = 'true true'
    refine_holes = 'false false'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = false #true
    output_subdomain_name = ${core_block_id}
    output_boundary = ${boundary_id_index_05}
    desired_area = ${xydg_area}
  []
  # Top half of the core cif outer thickess
  [top_half_cif_core_outer_boundary]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_core_angle};
                 t2:=(t-${cif_outer_radius})+3*${cif_core_angle};
                 x1:=${core_radius}*cos(t1);
                 x2:=-${cif_core_x_coord};
                 x3:=${core_radius}*cos(t2);
                 x4:=${cif_core_x_coord};
                 if(t<${pi_minus_2_cca},x1,if(t<${fparse pi_minus_2_cca + cif_outer_radius},x2,if(t<${fparse double_pi_minus_4_cca+cif_outer_radius},x3,x4)))'
    y_formula = 't1:=${cif_core_y_coord}-(t-${pi_minus_2_cca});
                 t2:=${cif_core_y_coord}-${cif_outer_radius}+(t-(${double_pi_minus_4_cca}+${cif_outer_radius}));
                 y1:=${cif_core_y_coord};
                 y2:=t1;
                 y3:=${cif_core_y_coord}-${cif_outer_radius};
                 y4:=t2;
                 if(t<${pi_minus_2_cca},y1,if(t<${fparse pi_minus_2_cca + cif_outer_radius},y2,if(t<${fparse double_pi_minus_4_cca+cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0 ${pi_minus_2_cca} ${fparse pi_minus_2_cca + cif_outer_radius} ${fparse double_pi_minus_4_cca+cif_outer_radius} ${fparse double_pi_minus_4_cca+2*cif_outer_radius}'
    nums_segments = '${cif_core_num_intervals} ${cif_wall_num_intervals} ${cif_core_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_cif_core_outer]
    type = XYDelaunayGenerator
    boundary = 'top_half_cif_core_outer_boundary'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${core_cif_wall_block_id}
    output_boundary = ${boundary_id_index_06}
    desired_area = ${xydg_area}
  []
  [stitch_core_and_cif_outer]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_core xydg_mesh_top_half_cif_core_outer'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_05} ${boundary_id_index_06}'
  []
  [top_half_ig_core_boundary]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_ig_angle};
                 t2:=t+3*${cif_ig_angle};
                 t3:=t+3*${cif_ig_angle}-${cif_ig_core_angle}+${cif_core_angle};
                 t4:=t+3*${cif_ig_angle}-2*${cif_ig_core_angle}+2*${cif_core_angle};
                 x1:=${ig_radius}*cos(t1);
                 x2:=${ig_radius}*cos(t2);
                 x3:=${core_radius}*cos(t3);
                 x4:=${ig_radius}*cos(t4);
                 if(t<${pi_minus_2_ciga},x1,if(t<${fparse pi_minus_3_ciga+cif_ig_core_angle},x2,if(t<${fparse pi_minus_3_ciga+cif_ig_core_angle+pi-2*cif_core_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_ig_angle};
                 t3:=t+3*${cif_ig_angle}-${cif_ig_core_angle}+${cif_core_angle};
                 y1:=${ig_radius}*sin(t1);
                 y2:=${cif_ig_y_coord};
                 y3:=-${core_radius}*sin(t3);
                 y4:=${cif_ig_y_coord};
                 if(t<${pi_minus_2_ciga},y1,if(t<${fparse pi_minus_3_ciga+cif_ig_core_angle},y2,if(t<${fparse pi_minus_3_ciga+cif_ig_core_angle+pi-2*cif_core_angle},y3,y4)))'
    section_bounding_t_values = '0 ${pi_minus_2_ciga} ${fparse pi_minus_3_ciga+cif_ig_core_angle} ${fparse pi_minus_3_ciga+cif_ig_core_angle+pi-2*cif_core_angle} ${fparse pi_minus_3_ciga+cif_ig_core_angle+pi-2*cif_core_angle+cif_ig_core_angle-cif_ig_angle}'
    nums_segments = '${semi_circle_num_intervals} ${ig_num_intervals} ${semi_circle_num_intervals} ${ig_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_ig]
    type = XYDelaunayGenerator
    boundary = 'top_half_ig_core_boundary'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ig_block_id}
    output_boundary = ${boundary_id_index_07}
    desired_area = ${xydg_area}
  []
  [stitch_ig_and_core]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_ig stitch_core_and_cif_outer'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_07} ${boundary_id_index_05}'
  []
  [top_half_right_ig_cif_wall]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_ig_angle};
                 t2:=t-${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius} + pi_2 - ${cif_ig_core_angle};
                 x1:=${ig_radius}*cos(t1);
                 x2:=${cif_core_x_coord};
                 x3:=-${ig_radius}*cos(t2);
                 x4:=${cif_ig_x_coord};
                 if(t<${fparse cif_ig_core_angle - cif_ig_angle},x1,if(t<${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius},x2,if(t<${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius + cif_ig_core_angle - cif_ig_angle},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_ig_core_angle - cif_ig_angle};
                 t2:=t-${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius + cif_ig_core_angle - cif_ig_angle + cif_outer_radius};
                 y1:=${cif_ig_y_coord};
                 y2:=${cif_outer_radius}-t1;
                 y3:=${cif_ig_y_coord} - ${cif_outer_radius};
                 y4:=${cif_outer_radius}+t2;
                 if(t<${fparse cif_ig_core_angle - cif_ig_angle},y1,if(t<${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius},y2,if(t<${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius + cif_ig_core_angle - cif_ig_angle},y3,y4)))'
    section_bounding_t_values = '0 ${fparse cif_ig_core_angle - cif_ig_angle} ${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius} ${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius + cif_ig_core_angle - cif_ig_angle} ${fparse cif_ig_core_angle - cif_ig_angle + cif_outer_radius + cif_ig_core_angle - cif_ig_angle + cif_outer_radius}'
    nums_segments = '${ig_num_intervals} ${cif_wall_num_intervals} ${ig_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_right_ig_cif_wall]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ig_cif_wall'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ig_cif_wall_block_id}
    output_boundary = ${boundary_id_index_08}
    desired_area = ${xydg_area}
  []
  [rename_boundaries_1]
    type = RenameBoundaryGenerator
    input = stitch_ig_and_core
    old_boundary = '${boundary_id_index_06} ${boundary_id_index_07}'
    new_boundary = '${boundary_id_index_09} ${boundary_id_index_09}'
  []
  [stitch_right_ig_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_right_ig_cif_wall rename_boundaries_1'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_08} ${boundary_id_index_09}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_left_ig_cif_wall]
    type = SymmetryTransformGenerator
    input = xydg_mesh_right_ig_cif_wall
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_2]
    type = RenameBoundaryGenerator
    input = xydg_mesh_left_ig_cif_wall
    old_boundary = '${boundary_id_index_08}'
    new_boundary = '${boundary_id_index_10}'
  []
  [stitch_left_ig_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_2 stitch_right_ig_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_10} ${boundary_id_index_09}'
  []
  [top_half_at_core_boundary]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_at_angle};
                 t2:=t+3*${cif_at_angle};
                 t3:=t+3*${cif_at_angle}-${cif_at_ig_angle}+${cif_ig_angle};
                 t4:=t+3*${cif_at_angle}-2*${cif_at_ig_angle}+2*${cif_ig_angle};
                 x1:=${at_radius}*cos(t1);
                 x2:=${at_radius}*cos(t2);
                 x3:=${ig_radius}*cos(t3);
                 x4:=${at_radius}*cos(t4);
                 if(t<${pi_minus_2_cata},x1,if(t<${fparse pi_minus_3_cata+cif_at_ig_angle},x2,if(t<${fparse pi_minus_3_cata+cif_at_ig_angle+pi-2*cif_ig_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_at_angle};
                 t3:=t+3*${cif_at_angle}-${cif_at_ig_angle}+${cif_ig_angle};
                 y1:=${at_radius}*sin(t1);
                 y2:=${cif_at_y_coord};
                 y3:=-${ig_radius}*sin(t3);
                 y4:=${cif_at_y_coord};
                 if(t<${pi_minus_2_cata},y1,if(t<${fparse pi_minus_3_cata+cif_at_ig_angle},y2,if(t<${fparse pi_minus_3_cata+cif_at_ig_angle+pi-2*cif_ig_angle},y3,y4)))'
    section_bounding_t_values = '0 ${pi_minus_2_cata} ${fparse pi_minus_3_cata+cif_at_ig_angle} ${fparse pi_minus_3_cata+cif_at_ig_angle+pi-2*cif_ig_angle} ${fparse pi_minus_3_cata+cif_at_ig_angle+pi-2*cif_ig_angle+cif_at_ig_angle-cif_at_angle}'
    nums_segments = '${semi_circle_num_intervals} ${at_num_intervals} ${semi_circle_num_intervals} ${at_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_at]
    type = XYDelaunayGenerator
    boundary = 'top_half_at_core_boundary'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${at_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_at_and_ig]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_at stitch_left_ig_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_09}'
  []
  [rename_boundaries_3]
    type = RenameBoundaryGenerator
    input = stitch_at_and_ig
    old_boundary = '${boundary_id_index_08} ${boundary_id_index_09} ${boundary_id_index_10} ${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12} ${boundary_id_index_12} ${boundary_id_index_12} ${boundary_id_index_12}'
  []
  [top_half_right_at_cif_wall]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_at_angle};
                 t2:=t-${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius} + pi_2 - ${cif_at_ig_angle};
                 x1:=${at_radius}*cos(t1);
                 x2:=${cif_ig_x_coord};
                 x3:=-${at_radius}*cos(t2);
                 x4:=${cif_at_x_coord};
                 if(t<${fparse cif_at_ig_angle - cif_at_angle},x1,if(t<${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius},x2,if(t<${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius + cif_at_ig_angle - cif_at_angle},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_at_ig_angle - cif_at_angle};
                 t2:=t-${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius + cif_at_ig_angle - cif_at_angle + cif_outer_radius};
                 y1:=${cif_at_y_coord};
                 y2:=${cif_outer_radius}-t1;
                 y3:=${cif_at_y_coord} - ${cif_outer_radius};
                 y4:=${cif_outer_radius}+t2;
                 if(t<${fparse cif_at_ig_angle - cif_at_angle},y1,if(t<${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius},y2,if(t<${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius + cif_at_ig_angle - cif_at_angle},y3,y4)))'
    section_bounding_t_values = '0 ${fparse cif_at_ig_angle - cif_at_angle} ${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius} ${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius + cif_at_ig_angle - cif_at_angle} ${fparse cif_at_ig_angle - cif_at_angle + cif_outer_radius + cif_at_ig_angle - cif_at_angle + cif_outer_radius}'
    nums_segments = '${at_num_intervals} ${cif_wall_num_intervals} ${at_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_right_at_cif_wall]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_at_cif_wall'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${at_cif_wall_block_id}
    output_boundary = ${boundary_id_index_13}
    desired_area = ${xydg_area}
  []
  [stitch_right_at_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_right_at_cif_wall rename_boundaries_3'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_13} ${boundary_id_index_12}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_left_at_cif_wall]
    type = SymmetryTransformGenerator
    input = xydg_mesh_right_at_cif_wall
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_4]
    type = RenameBoundaryGenerator
    input = xydg_mesh_left_at_cif_wall
    old_boundary = '${boundary_id_index_13}'
    new_boundary = '${boundary_id_index_14}'
  []
  [stitch_left_at_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_4 stitch_right_at_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_14} ${boundary_id_index_12}'
  []
  # These names are getting long...
  [top_half_og_between_beam_ports]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_ubp_og_inner_angle};
                 t2:=t+${cif_at_angle} - ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle};
                 t3:=t-${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata}+pi_2-${cif_uoi_at_angle};
                 t4:=t-${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius} + ${fparse pi + ubp_og_angle_1};
                 x1:=${cif_ubp_og_inner_radius}*cos(t1);
                 x2:=${at_radius}*cos(t2);
                 x3:=${cif_ubp_og_inner_radius}*cos(t3);
                 x4:=-${ubp_x_coord_1};
                 x5:=${og_radius}*cos(t4);
                 x6:=${ubp_x_coord_1};
                 if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle},x1,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata},x2,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle},x3,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius},x4,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius + pi - 2*ubp_og_angle_1},x5,x6)))))'
    y_formula = 't1:=t+${cif_at_angle} - ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle};
                 t2:=t-${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle} + ${cif_outer_radius};
                 t3:=t-${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius} + ${fparse pi + ubp_og_angle_1};
                 t4:=${ubp_og_y_coord_1} - (t - ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius + pi - 2*ubp_og_angle_1});
                 y1:=${cif_uoi_y_coord};
                 y2:=${at_radius}*sin(t1);
                 y3:=${cif_uoi_y_coord};
                 y4:=t2;
                 y5:=-${og_radius}*sin(t3);
                 y6:=t4;
                 if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle},y1,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata},y2,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle},y3,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius},y4,if(t<${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius + pi - 2*ubp_og_angle_1},y5,y6)))))'
    section_bounding_t_values = '0
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle}
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata}
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle}
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius}
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius + pi - 2*ubp_og_angle_1}
                                 ${fparse cif_uoi_at_angle - cif_ubp_og_inner_angle + pi_minus_2_cata + cif_uoi_at_angle - cif_ubp_og_inner_angle + ubp_og_y_coord_1 - cif_outer_radius + pi - 2*ubp_og_angle_1 + (ubp_og_y_coord_1 - cif_outer_radius)}'
    nums_segments = '${og_num_intervals_before_ubp} ${semi_circle_num_intervals} ${og_num_intervals_before_ubp} ${og_ubp_num_intervals} ${curve_between_bp_num_intervals} ${og_ubp_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_og_between_beam_ports]
    type = XYDelaunayGenerator
    boundary = 'top_half_og_between_beam_ports'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_block_id}
    output_boundary = ${boundary_id_index_15}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_og_between_beam_ports]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_og_between_beam_ports stitch_left_at_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_15} ${boundary_id_index_12}'
  []
  [top_half_lead_between_beam_ports]
    type = ParsedCurveGenerator
    x_formula = 't1:=t-${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1}+${ubp_og_angle_1};
                 t2:=t-${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1}+pi_2+${ubp_lead_angle_1};
                 x1:=${ubp_x_coord_1};
                 x2:=${og_radius}*cos(t1);
                 x3:=-${ubp_x_coord_1};
                 x4:=${lead_radius}*cos(t2);
                 if(t<${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1},x1,if(t<${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1},x2,if(t<${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1},x3,x4)))'
    y_formula = 't1:=${ubp_lead_y_coord_1}-t;
                 t2:=t-${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1}+${ubp_og_angle_1};
                 t3:=t-${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1}+${ubp_og_y_coord_1};
                 t4:=t-${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1}+pi_2+${ubp_lead_angle_1};
                 y1:=t1;
                 y2:=${og_radius}*sin(t2);
                 y3:=t3;
                 y4:=-${lead_radius}*sin(t4);
                 if(t<${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1},y1,if(t<${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1},y2,if(t<${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1},y3,y4)))'
    section_bounding_t_values = '0 ${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1} ${fparse ubp_lead_y_coord_1 - ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1} ${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1} ${fparse 2*ubp_lead_y_coord_1 - 2*ubp_og_y_coord_1 + pi - 2*ubp_og_angle_1 + pi - 2*ubp_lead_angle_1}'
    nums_segments = '${lead_ubp_num_intervals} ${curve_between_bp_num_intervals} ${lead_ubp_num_intervals} ${curve_between_bp_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_lead_between_beam_ports]
    type = XYDelaunayGenerator
    boundary = 'top_half_lead_between_beam_ports'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_block_id}
    output_boundary = ${boundary_id_index_16}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_lead_between_beam_ports]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_lead_between_beam_ports stitch_top_half_og_between_beam_ports'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_16} ${boundary_id_index_15}'
  []
  [top_half_ag_between_beam_ports]
    type = ParsedCurveGenerator
    x_formula = 't1:=t-${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1}+${ubp_lead_angle_1};
                 t2:=t-${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1}+pi_2+${ubp_ag_angle_1};
                 x1:=${ubp_x_coord_1};
                 x2:=${lead_radius}*cos(t1);
                 x3:=-${ubp_x_coord_1};
                 x4:=${ag_radius}*cos(t2);
                 if(t<${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1},x1,if(t<${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1},x2,if(t<${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1},x3,x4)))'
    y_formula = 't1:=${ubp_ag_y_coord_1}-t;
                 t2:=t-${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1}+${ubp_lead_angle_1};
                 t3:=t-${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1}+${ubp_lead_y_coord_1};
                 t4:=t-${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1}+pi_2+${ubp_ag_angle_1};
                 y1:=t1;
                 y2:=${lead_radius}*sin(t2);
                 y3:=t3;
                 y4:=-${ag_radius}*sin(t4);
                 if(t<${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1},y1,if(t<${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1},y2,if(t<${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1},y3,y4)))'
    section_bounding_t_values = '0 ${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1} ${fparse ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1} ${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1} ${fparse 2*ubp_ag_y_coord_1 - 2*ubp_lead_y_coord_1 + pi - 2*ubp_lead_angle_1 + pi - 2*ubp_ag_angle_1}'
    nums_segments = '${ag_ubp_num_intervals} ${curve_between_bp_num_intervals} ${ag_ubp_num_intervals} ${curve_between_bp_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_ag_between_beam_ports]
    type = XYDelaunayGenerator
    boundary = 'top_half_ag_between_beam_ports'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_block_id}
    output_boundary = ${boundary_id_index_17}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_ag_between_beam_ports]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_ag_between_beam_ports stitch_top_half_lead_between_beam_ports'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_17} ${boundary_id_index_16}'
  []
  [top_half_rt_between_beam_ports]
    type = ParsedCurveGenerator
    x_formula = 't1:=t-${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1}+${ubp_ag_angle_1};
                 t2:=t-${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1}+pi_2+${ubp_rt_angle_1};
                 x1:=${ubp_x_coord_1};
                 x2:=${ag_radius}*cos(t1);
                 x3:=-${ubp_x_coord_1};
                 x4:=${rt_radius}*cos(t2);
                 if(t<${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1},x1,if(t<${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1},x2,if(t<${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1},x3,x4)))'
    y_formula = 't1:=${ubp_rt_y_coord_1}-t;
                 t2:=t-${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1}+${ubp_ag_angle_1};
                 t3:=t-${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1}+${ubp_ag_y_coord_1};
                 t4:=t-${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1}+pi_2+${ubp_rt_angle_1};
                 y1:=t1;
                 y2:=${ag_radius}*sin(t2);
                 y3:=t3;
                 y4:=-${rt_radius}*sin(t4);
                 if(t<${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1},y1,if(t<${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1},y2,if(t<${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1},y3,y4)))'
    section_bounding_t_values = '0 ${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1} ${fparse ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1} ${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1} ${fparse 2*ubp_rt_y_coord_1 - 2*ubp_ag_y_coord_1 + pi - 2*ubp_ag_angle_1 + pi - 2*ubp_rt_angle_1}'
    nums_segments = '${rt_ubp_num_intervals} ${curve_between_bp_num_intervals} ${rt_ubp_num_intervals} ${curve_between_bp_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_rt_between_beam_ports]
    type = XYDelaunayGenerator
    boundary = 'top_half_rt_between_beam_ports'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_block_id}
    output_boundary = ${boundary_id_index_18}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_rt_between_beam_ports]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_rt_between_beam_ports stitch_top_half_ag_between_beam_ports'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_18} ${boundary_id_index_17}'
  []
  [top_half_water_between_beam_ports]
    type = ParsedCurveGenerator
    x_formula = 't1:=t-${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1}+${ubp_rt_angle_1};
                 t2:=t-${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1}+pi_2+${ubp_water_angle_1};
                 x1:=${ubp_x_coord_1};
                 x2:=${rt_radius}*cos(t1);
                 x3:=-${ubp_x_coord_1};
                 x4:=${water_radius}*cos(t2);
                 if(t<${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1},x1,if(t<${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1},x2,if(t<${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1},x3,x4)))'
    y_formula = 't1:=${ubp_water_y_coord_1}-t;
                 t2:=t-${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1}+${ubp_rt_angle_1};
                 t3:=t-${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1}+${ubp_rt_y_coord_1};
                 t4:=t-${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1}+pi_2+${ubp_water_angle_1};
                 y1:=t1;
                 y2:=${rt_radius}*sin(t2);
                 y3:=t3;
                 y4:=-${water_radius}*sin(t4);
                 if(t<${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1},y1,if(t<${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1},y2,if(t<${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1},y3,y4)))'
    section_bounding_t_values = '0 ${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1} ${fparse ubp_water_y_coord_1 - ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1} ${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1} ${fparse 2*ubp_water_y_coord_1 - 2*ubp_rt_y_coord_1 + pi - 2*ubp_rt_angle_1 + pi - 2*ubp_water_angle_1}'
    nums_segments = '${water_ubp_num_intervals} ${curve_between_bp_num_intervals} ${water_ubp_num_intervals} ${curve_between_bp_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_water_between_beam_ports]
    type = XYDelaunayGenerator
    boundary = 'top_half_water_between_beam_ports'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_block_id}
    output_boundary = ${boundary_id_index_19}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_water_between_beam_ports]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_water_between_beam_ports stitch_top_half_rt_between_beam_ports'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_19} ${boundary_id_index_18}'
  []
  [rename_boundaries_5]
    type = RenameBoundaryGenerator
    input = stitch_top_half_water_between_beam_ports
    old_boundary = '${boundary_id_index_12} ${boundary_id_index_13} ${boundary_id_index_14} ${boundary_id_index_15} ${boundary_id_index_16} ${boundary_id_index_17} ${boundary_id_index_18} ${boundary_id_index_19}'
    new_boundary = '${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20} ${boundary_id_index_20}'
  []
  # CIF wall under the outer graphite before the UBP starts
  [top_half_right_og_before_ubp_cif_wall]
    type = ParsedCurveGenerator
    x_formula = 't1:=${ubp_x_coord_1}-t;
                 t2:=t+${fparse at_radius*cos(cif_at_angle)}-${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius};
                 x1:=t1;
                 x2:=${fparse at_radius*cos(cif_at_angle)};
                 x3:=t2;
                 x4:=${ubp_x_coord_1};
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle)},x1,
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius},x2,
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius + (ubp_x_coord_1 - at_radius*cos(cif_at_angle))},x3,x4)))'
    y_formula = 't1:=${cif_outer_radius}-(t-${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle)});
                 t2:=t-${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius + (ubp_x_coord_1 - at_radius*cos(cif_at_angle))};
                 y1:=${cif_outer_radius};
                 y2:=t1;
                 y3:=0;
                 y4:=t2;
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle)},y1,
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius},y2,
                 if(t<${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius + (ubp_x_coord_1 - at_radius*cos(cif_at_angle))},y3,y4)))'
    section_bounding_t_values = '
    0
    ${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle)}
    ${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius}
    ${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius + (ubp_x_coord_1 - at_radius*cos(cif_at_angle))}
    ${fparse ubp_x_coord_1 - at_radius*cos(cif_at_angle) + cif_outer_radius + (ubp_x_coord_1 - at_radius*cos(cif_at_angle)) + cif_outer_radius}'
    nums_segments = '${og_num_intervals_before_ubp} ${cif_wall_num_intervals} ${og_num_intervals_before_ubp} ${cif_wall_num_intervals}'
    is_closed_loop = true
    constant_names = pi_2
    constant_expressions = '${fparse pi}'
  []
  [xydg_mesh_top_half_right_og_before_ubp_cif_wall]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_og_before_ubp_cif_wall'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_cif_wall_block_id}
    output_boundary = ${boundary_id_index_21}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_og_before_ubp_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_og_before_ubp_cif_wall rename_boundaries_5'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_21} ${boundary_id_index_20}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_og_before_ubp_cif_wall]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_og_before_ubp_cif_wall
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_6]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_og_before_ubp_cif_wall
    old_boundary = '${boundary_id_index_21}'
    new_boundary = '${boundary_id_index_22}'
  []
  [stitch_top_half_left_og_before_ubp_cif_wall]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_6 stitch_top_half_right_og_before_ubp_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_22} ${boundary_id_index_20}'
  []
  # CIF wall intersection with the UBP wall
  [top_half_right_ubp_cif_wall_1]
    type = ParsedCurveGenerator
    x_formula = 't1:=${ubp_x_coord_1}+t;
                 t2:=${ubp_x_coord_2}-(t-${fparse ubp_x_coord_2 - ubp_x_coord_1 + cif_outer_radius});
                 x1:=t1;
                 x2:=${ubp_x_coord_2};
                 x3:=t2;
                 x4:=${ubp_x_coord_1};
                 if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1},x1,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + cif_outer_radius},x2,if(t<${fparse 2*ubp_x_coord_2 - 2*ubp_x_coord_1 + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=${cif_outer_radius}-(t-${fparse ubp_x_coord_2 - ubp_x_coord_1});
                 t2:=(t-${fparse 2*ubp_x_coord_2 - 2*ubp_x_coord_1 + cif_outer_radius});
                 y1:=${cif_outer_radius};
                 y2:=t1;
                 y3:=0;
                 y4:=t2;
                 if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1},y1,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + cif_outer_radius},y2,if(t<${fparse 2*ubp_x_coord_2 - 2*ubp_x_coord_1 + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0 ${fparse ubp_x_coord_2 - ubp_x_coord_1} ${fparse ubp_x_coord_2 - ubp_x_coord_1 + cif_outer_radius} ${fparse 2*ubp_x_coord_2 - 2*ubp_x_coord_1 + cif_outer_radius} ${fparse 2*ubp_x_coord_2 - 2*ubp_x_coord_1 + 2*cif_outer_radius}'
    nums_segments = '${ubp_wall_num_intervals} ${cif_wall_num_intervals} ${ubp_wall_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_cif_wall_1]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_cif_wall_1'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_cif_wall_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_23}
    desired_area = ${xydg_area}
  []
  [rename_boundaries_7]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_og_before_ubp_cif_wall
    old_boundary = '${boundary_id_index_22} ${boundary_id_index_21} ${boundary_id_index_20}'
    new_boundary = '${boundary_id_index_24} ${boundary_id_index_24} ${boundary_id_index_24}'
  []
  [stitch_top_half_right_ubp_cif_wall_1]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_cif_wall_1 rename_boundaries_7'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_23} ${boundary_id_index_24}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_cif_wall_1]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_cif_wall_1
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_8]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_cif_wall_1
    old_boundary = '${boundary_id_index_23}'
    new_boundary = '${boundary_id_index_25}'
  []
  [stitch_top_half_left_ubp_cif_wall_1]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_8 stitch_top_half_right_ubp_cif_wall_1'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_25} ${boundary_id_index_24}'
  []
  [rename_boundaries_9]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_cif_wall_1
    old_boundary = '${boundary_id_index_23} ${boundary_id_index_24} ${boundary_id_index_25}'
    new_boundary = '${boundary_id_index_26} ${boundary_id_index_26} ${boundary_id_index_26}'
  []
  # UBP inner wall in outer graphite
  [top_half_right_ubp_inner_wall_in_og]
    type = ParsedCurveGenerator
    x_formula = 't1:=${ubp_x_coord_1}+t;
                 t2:=t-${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius}+${ubp_og_angle_2};
                 x1:=t1;
                 x2:=${ubp_x_coord_2};
                 x3:=${og_radius}*cos(t2);
                 x4:=${ubp_x_coord_1};
                 if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1},x1,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius},x2,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius + ubp_og_angle_1 - ubp_og_angle_2},x3,x4)))'
    y_formula = 't1:=${cif_outer_radius}+(t-${fparse ubp_x_coord_2 - ubp_x_coord_1});
                 t2:=t-${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius}+${ubp_og_angle_2};
                 t3:=${ubp_og_y_coord_1}-(t-${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius + ubp_og_angle_1 - ubp_og_angle_2});
                 y1:=${cif_outer_radius};
                 y2:=t1;
                 y3:=${og_radius}*sin(t2);
                 y4:=t3;
                 if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1},y1,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius},y2,if(t<${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius + ubp_og_angle_1 - ubp_og_angle_2},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_x_coord_2 - ubp_x_coord_1}
                                 ${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius}
                                 ${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius + ubp_og_angle_1 - ubp_og_angle_2}
                                 ${fparse ubp_x_coord_2 - ubp_x_coord_1 + ubp_og_y_coord_2 - cif_outer_radius + ubp_og_angle_1 - ubp_og_angle_2 + ubp_og_y_coord_1 - cif_outer_radius}'
    nums_segments = '${ubp_wall_num_intervals} ${og_ubp_num_intervals} ${ubp_wall_num_intervals} ${og_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_inner_wall_in_og]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_inner_wall_in_og'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_27}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_inner_wall_in_og]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_9 xydg_mesh_top_half_right_ubp_inner_wall_in_og'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_26} ${boundary_id_index_27}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_inner_wall_in_og]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_inner_wall_in_og
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_10]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_inner_wall_in_og
    old_boundary = '${boundary_id_index_27}'
    new_boundary = '${boundary_id_index_28}'
  []
  [stitch_top_half_left_ubp_inner_wall_in_og]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_10 stitch_top_half_right_ubp_inner_wall_in_og'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_28} ${boundary_id_index_26}'
  []
  # In theory we can jump back and start reusing earlier boundary IDs
  [rename_boundaries_11]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_inner_wall_in_og
    old_boundary = '${boundary_id_index_28} ${boundary_id_index_27} ${boundary_id_index_26}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP inner wall in lead
  [top_half_right_ubp_inner_wall_in_lead]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_og_angle_2};
                 t2:=${ubp_lead_angle_1}-(t-${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1});
                 x1:=${og_radius}*cos(t1);
                 x2:=${ubp_x_coord_1};
                 x3:=${lead_radius}*cos(t2);
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2},x1,if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1},x2,if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1 + ubp_lead_angle_1 - ubp_lead_angle_2},x3,x4)))'
    y_formula = 't1:=t+${ubp_og_angle_2};
                 t2:=t-${fparse ubp_og_angle_1 - ubp_og_angle_2}+${ubp_og_y_coord_1};
                 t3:=${ubp_lead_angle_1}-(t-${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1});
                 t4:=${ubp_lead_y_coord_2}-(t-${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1 + ubp_lead_angle_1 - ubp_lead_angle_2});
                 y1:=${og_radius}*sin(t1);
                 y2:=t2;
                 y3:=${lead_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2},y1,if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1},y2,if(t<${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1 + ubp_lead_angle_1 - ubp_lead_angle_2},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_og_angle_1 - ubp_og_angle_2}
                                 ${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1}
                                 ${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1 + ubp_lead_angle_1 - ubp_lead_angle_2}
                                 ${fparse ubp_og_angle_1 - ubp_og_angle_2 + ubp_lead_y_coord_1 - ubp_og_y_coord_1 + ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_lead_y_coord_2 - ubp_og_y_coord_2}'
    nums_segments = '${ubp_wall_num_intervals} ${lead_ubp_num_intervals} ${ubp_wall_num_intervals} ${lead_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_inner_wall_in_lead]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_inner_wall_in_lead'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_inner_wall_in_lead]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_11 xydg_mesh_top_half_right_ubp_inner_wall_in_lead'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_10} ${boundary_id_index_11}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_inner_wall_in_lead]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_inner_wall_in_lead
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_12]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_inner_wall_in_lead
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_inner_wall_in_lead]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_12 stitch_top_half_right_ubp_inner_wall_in_lead'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_13]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_inner_wall_in_lead
    old_boundary = '${boundary_id_index_12} ${boundary_id_index_11} ${boundary_id_index_10}'
    new_boundary = '${boundary_id_index_13} ${boundary_id_index_13} ${boundary_id_index_13}'
  []
  # UBP inner wall in ag
  [top_half_right_ubp_inner_wall_in_ag]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_lead_angle_2};
                 t2:=${ubp_ag_angle_1}-(t-${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1});
                 x1:=${lead_radius}*cos(t1);
                 x2:=${ubp_x_coord_1};
                 x3:=${ag_radius}*cos(t2);
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2},x1,if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1},x2,if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + ubp_ag_angle_1 - ubp_ag_angle_2},x3,x4)))'
    y_formula = 't1:=t+${ubp_lead_angle_2};
                 t2:=t-${fparse ubp_lead_angle_1 - ubp_lead_angle_2}+${ubp_lead_y_coord_1};
                 t3:=${ubp_ag_angle_1}-(t-${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1});
                 t4:=${ubp_ag_y_coord_2}-(t-${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + ubp_ag_angle_1 - ubp_ag_angle_2});
                 y1:=${lead_radius}*sin(t1);
                 y2:=t2;
                 y3:=${ag_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2},y1,if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1},y2,if(t<${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + ubp_ag_angle_1 - ubp_ag_angle_2},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_lead_angle_1 - ubp_lead_angle_2}
                                 ${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1}
                                 ${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + ubp_ag_angle_1 - ubp_ag_angle_2}
                                 ${fparse ubp_lead_angle_1 - ubp_lead_angle_2 + ubp_ag_y_coord_1 - ubp_lead_y_coord_1 + ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2}'
    nums_segments = '${ubp_wall_num_intervals} ${ag_ubp_num_intervals} ${ubp_wall_num_intervals} ${ag_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_inner_wall_in_ag]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_inner_wall_in_ag'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_14}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_inner_wall_in_ag]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_inner_wall_in_ag rename_boundaries_13'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_14} ${boundary_id_index_13}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_inner_wall_in_ag]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_inner_wall_in_ag
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_14]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_inner_wall_in_ag
    old_boundary = '${boundary_id_index_14}'
    new_boundary = '${boundary_id_index_15}'
  []
  [stitch_top_half_left_ubp_inner_wall_in_ag]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_14 stitch_top_half_right_ubp_inner_wall_in_ag'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_15} ${boundary_id_index_13}'
  []
  [rename_boundaries_15]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_inner_wall_in_ag
    old_boundary = '${boundary_id_index_15} ${boundary_id_index_14} ${boundary_id_index_13}'
    new_boundary = '${boundary_id_index_16} ${boundary_id_index_16} ${boundary_id_index_16}'
  []
  # UBP inner wall in rt
  [top_half_right_ubp_inner_wall_in_rt]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_ag_angle_2};
                 t2:=${ubp_rt_angle_1}-(t-${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1});
                 x1:=${ag_radius}*cos(t1);
                 x2:=${ubp_x_coord_1};
                 x3:=${rt_radius}*cos(t2);
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2},x1,if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1},x2,if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + ubp_rt_angle_1 - ubp_rt_angle_2},x3,x4)))'
    y_formula = 't1:=t+${ubp_ag_angle_2};
                 t2:=t-${fparse ubp_ag_angle_1 - ubp_ag_angle_2}+${ubp_ag_y_coord_1};
                 t3:=${ubp_rt_angle_1}-(t-${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1});
                 t4:=${ubp_rt_y_coord_2}-(t-${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + ubp_rt_angle_1 - ubp_rt_angle_2});
                 y1:=${ag_radius}*sin(t1);
                 y2:=t2;
                 y3:=${rt_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2},y1,if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1},y2,if(t<${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + ubp_rt_angle_1 - ubp_rt_angle_2},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_ag_angle_1 - ubp_ag_angle_2}
                                 ${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1}
                                 ${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + ubp_rt_angle_1 - ubp_rt_angle_2}
                                 ${fparse ubp_ag_angle_1 - ubp_ag_angle_2 + ubp_rt_y_coord_1 - ubp_ag_y_coord_1 + ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2}'
    nums_segments = '${ubp_wall_num_intervals} ${rt_ubp_num_intervals} ${ubp_wall_num_intervals} ${rt_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_inner_wall_in_rt]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_inner_wall_in_rt'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_17}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_inner_wall_in_rt]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_inner_wall_in_rt rename_boundaries_15'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_17} ${boundary_id_index_16}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_inner_wall_in_rt]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_inner_wall_in_rt
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_16]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_inner_wall_in_rt
    old_boundary = '${boundary_id_index_17}'
    new_boundary = '${boundary_id_index_18}'
  []
  [stitch_top_half_left_ubp_inner_wall_in_rt]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_16 stitch_top_half_right_ubp_inner_wall_in_rt'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_18} ${boundary_id_index_16}'
  []
  [rename_boundaries_17]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_inner_wall_in_rt
    old_boundary = '${boundary_id_index_18} ${boundary_id_index_17} ${boundary_id_index_16}'
    new_boundary = '${boundary_id_index_19} ${boundary_id_index_19} ${boundary_id_index_19}'
  []
  # UBP inner wall in water
  [top_half_right_ubp_inner_wall_in_water]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_rt_angle_2};
                 t2:=${ubp_water_angle_1}-(t-${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1});
                 x1:=${rt_radius}*cos(t1);
                 x2:=${ubp_x_coord_1};
                 x3:=${water_radius}*cos(t2);
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2},x1,if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1},x2,if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1 + ubp_water_angle_1 - ubp_water_angle_2},x3,x4)))'
    y_formula = 't1:=t+${ubp_rt_angle_2};
                 t2:=t-${fparse ubp_rt_angle_1 - ubp_rt_angle_2}+${ubp_rt_y_coord_1};
                 t3:=${ubp_water_angle_1}-(t-${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1});
                 t4:=${ubp_water_y_coord_2}-(t-${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1 + ubp_water_angle_1 - ubp_water_angle_2});
                 y1:=${rt_radius}*sin(t1);
                 y2:=t2;
                 y3:=${water_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2},y1,if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1},y2,if(t<${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1 + ubp_water_angle_1 - ubp_water_angle_2},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_rt_angle_1 - ubp_rt_angle_2}
                                 ${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1}
                                 ${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1 + ubp_water_angle_1 - ubp_water_angle_2}
                                 ${fparse ubp_rt_angle_1 - ubp_rt_angle_2 + ubp_water_y_coord_1 - ubp_rt_y_coord_1 + ubp_water_angle_1 - ubp_water_angle_2 + ubp_water_y_coord_2 - ubp_rt_y_coord_2}'
    nums_segments = '${ubp_wall_num_intervals} ${water_ubp_num_intervals} ${ubp_wall_num_intervals} ${water_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_inner_wall_in_water]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_inner_wall_in_water'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_20}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_inner_wall_in_water]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_inner_wall_in_water rename_boundaries_17'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_20} ${boundary_id_index_19}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_inner_wall_in_water]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_inner_wall_in_water
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_18]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_inner_wall_in_water
    old_boundary = '${boundary_id_index_20}'
    new_boundary = '${boundary_id_index_21}'
  []
  [stitch_top_half_left_ubp_inner_wall_in_water]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_18 stitch_top_half_right_ubp_inner_wall_in_water'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_21} ${boundary_id_index_19}'
  []
  [rename_boundaries_19]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_inner_wall_in_water
    old_boundary = '${boundary_id_index_19} ${boundary_id_index_20} ${boundary_id_index_21}'
    new_boundary = '${boundary_id_index_22} ${boundary_id_index_22} ${boundary_id_index_22}'
  []
  # CIF outer wall in UBP channel
  [top_half_right_cif_wall_in_ubp_channel]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_x_coord_2};
                 t2:=${ubp_x_coord_3}-(t-${fparse ubp_x_coord_3 - ubp_x_coord_2 + cif_outer_radius});
                 x1:=t1;
                 x2:=${ubp_x_coord_3};
                 x3:=t2;
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2},x1,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + cif_outer_radius},x2,if(t<${fparse 2*ubp_x_coord_3 - 2*ubp_x_coord_2 + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse ubp_x_coord_3 - ubp_x_coord_2};
                 t2:=${cif_outer_radius}-(t-${fparse 2*ubp_x_coord_3 - 2*ubp_x_coord_2 + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2},y1,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + cif_outer_radius},y2,if(t<${fparse 2*ubp_x_coord_3 - 2*ubp_x_coord_2 + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2}
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2 + cif_outer_radius}
                                 ${fparse 2*ubp_x_coord_3 - 2*ubp_x_coord_2 + cif_outer_radius}
                                 ${fparse 2*ubp_x_coord_3 - 2*ubp_x_coord_2 + 2*cif_outer_radius}'
    nums_segments = '${ubp_channel_num_intervals} ${cif_wall_num_intervals} ${ubp_channel_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_ubp_channel]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_ubp_channel'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_cif_wall_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_23}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_ubp_channel]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_ubp_channel rename_boundaries_19'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_23} ${boundary_id_index_22}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_ubp_channel]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_ubp_channel
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_20]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_ubp_channel
    old_boundary = '${boundary_id_index_23}'
    new_boundary = '${boundary_id_index_24}'
  []
  [stitch_top_half_left_cif_wall_in_ubp_channel]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_20 stitch_top_half_right_cif_wall_in_ubp_channel'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_24} ${boundary_id_index_22}'
  []
  [rename_boundaries_21]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_ubp_channel
    old_boundary = '${boundary_id_index_22} ${boundary_id_index_23} ${boundary_id_index_24}'
    new_boundary = '${boundary_id_index_25} ${boundary_id_index_25} ${boundary_id_index_25}'
  []
  # Outer graphite in UBP channel
  [top_half_right_og_in_ubp_channel]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_x_coord_2};
                 t2:=t-${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius}+${ubp_og_angle_3};
                 x1:=t1;
                 x2:=${ubp_x_coord_3};
                 x3:=${og_radius}*cos(t2);
                 x4:=${ubp_x_coord_2};
                 if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2},x1,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius},x2,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius + ubp_og_angle_2 - ubp_og_angle_3},x3,x4)))'
    y_formula = 't1:=t-${fparse ubp_x_coord_3 - ubp_x_coord_2}+${cif_outer_radius};
                 t2:=t-${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius}+${ubp_og_angle_3};
                 t3:=${ubp_og_y_coord_2}-(t-${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius + ubp_og_angle_2 - ubp_og_angle_3});
                 y1:=${cif_outer_radius};
                 y2:=t1;
                 y3:=${og_radius}*sin(t2);
                 y4:=t3;
                 if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2},y1,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius},y2,if(t<${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius + ubp_og_angle_2 - ubp_og_angle_3},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2}
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius}
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius + ubp_og_angle_2 - ubp_og_angle_3}
                                 ${fparse ubp_x_coord_3 - ubp_x_coord_2 + ubp_og_y_coord_3 - cif_outer_radius + ubp_og_angle_2 - ubp_og_angle_3 + ubp_og_y_coord_2 - cif_outer_radius}'
    nums_segments = '${ubp_channel_num_intervals} ${og_ubp_num_intervals} ${ubp_channel_num_intervals} ${og_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_og_in_ubp_channel]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_og_in_ubp_channel'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_26}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_og_in_ubp_channel]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_og_in_ubp_channel rename_boundaries_21'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_26} ${boundary_id_index_25}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_og_in_ubp_channel]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_og_in_ubp_channel
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_22]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_og_in_ubp_channel
    old_boundary = '${boundary_id_index_26}'
    new_boundary = '${boundary_id_index_27}'
  []
  [stitch_top_half_left_og_in_ubp_channel]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_22 stitch_top_half_right_og_in_ubp_channel'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_27} ${boundary_id_index_25}'
  []
  [rename_boundaries_23]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_og_in_ubp_channel
    old_boundary = '${boundary_id_index_27} ${boundary_id_index_26} ${boundary_id_index_25}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP channel in lead
  [top_half_right_ubp_channel_in_lead]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_og_angle_3};
                 t2:=${ubp_lead_angle_2}-(t-${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2});
                 x1:=${og_radius}*cos(t1);
                 x2:=${ubp_x_coord_2};
                 x3:=${lead_radius}*cos(t2);
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3},x1,if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2},x2,if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2 + ubp_lead_angle_2 - ubp_lead_angle_3},x3,x4)))'
    y_formula = 't1:=t+${ubp_og_angle_3};
                 t2:=t-${fparse ubp_og_angle_2 - ubp_og_angle_3}+${ubp_og_y_coord_2};
                 t3:=${ubp_lead_angle_2}-(t-${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2});
                 t4:=${ubp_lead_y_coord_3}-(t-${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2 + ubp_lead_angle_2 - ubp_lead_angle_3});
                 y1:=${og_radius}*sin(t1);
                 y2:=t2;
                 y3:=${lead_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3},y1,if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2},y2,if(t<${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2 + ubp_lead_angle_2 - ubp_lead_angle_3},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_og_angle_2 - ubp_og_angle_3}
                                 ${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2}
                                 ${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2 + ubp_lead_angle_2 - ubp_lead_angle_3}
                                 ${fparse ubp_og_angle_2 - ubp_og_angle_3 + ubp_lead_y_coord_2 - ubp_og_y_coord_2 + ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_lead_y_coord_3 - ubp_og_y_coord_3}'
    nums_segments = '${ubp_channel_num_intervals} ${lead_ubp_num_intervals} ${ubp_channel_num_intervals} ${lead_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_channel_in_lead]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_channel_in_lead'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_channel_in_lead]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_channel_in_lead rename_boundaries_23'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_channel_in_lead]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_channel_in_lead
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_24]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_channel_in_lead
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_channel_in_lead]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_24 stitch_top_half_right_ubp_channel_in_lead'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_25]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_channel_in_lead
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP channel in air gap
  [top_half_right_ubp_channel_in_ag]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_lead_angle_3};
                 t2:=${ubp_ag_angle_2}-(t-${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2});
                 x1:=${lead_radius}*cos(t1);
                 x2:=${ubp_x_coord_2};
                 x3:=${ag_radius}*cos(t2);
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3},x1,if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2},x2,if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2 + ubp_ag_angle_2 - ubp_ag_angle_3},x3,x4)))'
    y_formula = 't1:=t+${ubp_lead_angle_3};
                 t2:=t-${fparse ubp_lead_angle_2 - ubp_lead_angle_3}+${ubp_lead_y_coord_2};
                 t3:=${ubp_ag_angle_2}-(t-${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2});
                 t4:=${ubp_ag_y_coord_3}-(t-${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2 + ubp_ag_angle_2 - ubp_ag_angle_3});
                 y1:=${lead_radius}*sin(t1);
                 y2:=t2;
                 y3:=${ag_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3},y1,if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2},y2,if(t<${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2 + ubp_ag_angle_2 - ubp_ag_angle_3},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_lead_angle_2 - ubp_lead_angle_3}
                                 ${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2}
                                 ${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2 + ubp_ag_angle_2 - ubp_ag_angle_3}
                                 ${fparse ubp_lead_angle_2 - ubp_lead_angle_3 + ubp_ag_y_coord_2 - ubp_lead_y_coord_2 + ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3}'
    nums_segments = '${ubp_channel_num_intervals} ${ag_ubp_num_intervals} ${ubp_channel_num_intervals} ${ag_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_channel_in_ag]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_channel_in_ag'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_channel_in_ag]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_channel_in_ag rename_boundaries_25'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_channel_in_ag]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_channel_in_ag
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_26]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_channel_in_ag
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_channel_in_ag]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_26 stitch_top_half_right_ubp_channel_in_ag'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_27]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_channel_in_ag
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP channel in reactor tank
  [top_half_right_ubp_channel_in_rt]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_ag_angle_3};
                 t2:=${ubp_rt_angle_2}-(t-${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2});
                 x1:=${ag_radius}*cos(t1);
                 x2:=${ubp_x_coord_2};
                 x3:=${rt_radius}*cos(t2);
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3},x1,if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2},x2,if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2 + ubp_rt_angle_2 - ubp_rt_angle_3},x3,x4)))'
    y_formula = 't1:=t+${ubp_ag_angle_3};
                 t2:=t-${fparse ubp_ag_angle_2 - ubp_ag_angle_3}+${ubp_ag_y_coord_2};
                 t3:=${ubp_rt_angle_2}-(t-${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2});
                 t4:=${ubp_rt_y_coord_3}-(t-${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2 + ubp_rt_angle_2 - ubp_rt_angle_3});
                 y1:=${ag_radius}*sin(t1);
                 y2:=t2;
                 y3:=${rt_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3},y1,if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2},y2,if(t<${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2 + ubp_rt_angle_2 - ubp_rt_angle_3},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_ag_angle_2 - ubp_ag_angle_3}
                                 ${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2}
                                 ${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2 + ubp_rt_angle_2 - ubp_rt_angle_3}
                                 ${fparse ubp_ag_angle_2 - ubp_ag_angle_3 + ubp_rt_y_coord_2 - ubp_ag_y_coord_2 + ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3}'
    nums_segments = '${ubp_channel_num_intervals} ${rt_ubp_num_intervals} ${ubp_channel_num_intervals} ${rt_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_channel_in_rt]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_channel_in_rt'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_channel_in_rt]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_channel_in_rt rename_boundaries_27'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_channel_in_rt]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_channel_in_rt
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_28]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_channel_in_rt
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_channel_in_rt]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_28 stitch_top_half_right_ubp_channel_in_rt'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_29]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_channel_in_rt
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP channel in water
  [top_half_right_ubp_channel_in_water]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_rt_angle_3};
                 t2:=${ubp_water_angle_2}-(t-${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2});
                 x1:=${rt_radius}*cos(t1);
                 x2:=${ubp_x_coord_2};
                 x3:=${water_radius}*cos(t2);
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3},x1,if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2},x2,if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2 + ubp_water_angle_2 - ubp_water_angle_3},x3,x4)))'
    y_formula = 't1:=t+${ubp_rt_angle_3};
                 t2:=t-${fparse ubp_rt_angle_2 - ubp_rt_angle_3}+${ubp_rt_y_coord_2};
                 t3:=${ubp_water_angle_2}-(t-${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2});
                 t4:=${ubp_water_y_coord_3}-(t-${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2 + ubp_water_angle_2 - ubp_water_angle_3});
                 y1:=${rt_radius}*sin(t1);
                 y2:=t2;
                 y3:=${water_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3},y1,if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2},y2,if(t<${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2 + ubp_water_angle_2 - ubp_water_angle_3},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_rt_angle_2 - ubp_rt_angle_3}
                                 ${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2}
                                 ${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2 + ubp_water_angle_2 - ubp_water_angle_3}
                                 ${fparse ubp_rt_angle_2 - ubp_rt_angle_3 + ubp_water_y_coord_2 - ubp_rt_y_coord_2 + ubp_water_angle_2 - ubp_water_angle_3 + ubp_water_y_coord_3 - ubp_rt_y_coord_3}'
    nums_segments = '${ubp_channel_num_intervals} ${water_ubp_num_intervals} ${ubp_channel_num_intervals} ${water_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_channel_in_water]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_channel_in_water'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_ubp_channel_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_channel_in_water]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_channel_in_water rename_boundaries_29'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_channel_in_water]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_channel_in_water
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_30]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_channel_in_water
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_channel_in_water]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_30 stitch_top_half_right_ubp_channel_in_water'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_31]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_channel_in_water
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in UBP outer_wall
  [top_half_right_cif_wall_in_ubp_outer_wall]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_x_coord_3};
                 t2:=${ubp_x_coord_4}-(t-${fparse ubp_x_coord_4 - ubp_x_coord_3 + cif_outer_radius});
                 x1:=t1;
                 x2:=${ubp_x_coord_4};
                 x3:=t2;
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3},x1,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + cif_outer_radius},x2,if(t<${fparse 2*ubp_x_coord_4 - 2*ubp_x_coord_3 + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse ubp_x_coord_4 - ubp_x_coord_3};
                 t2:=${cif_outer_radius}-(t-${fparse 2*ubp_x_coord_4 - 2*ubp_x_coord_3 + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3},y1,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + cif_outer_radius},y2,if(t<${fparse 2*ubp_x_coord_4 - 2*ubp_x_coord_3 + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3}
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3 + cif_outer_radius}
                                 ${fparse 2*ubp_x_coord_4 - 2*ubp_x_coord_3 + cif_outer_radius}
                                 ${fparse 2*ubp_x_coord_4 - 2*ubp_x_coord_3 + 2*cif_outer_radius}'
    nums_segments = '${ubp_wall_num_intervals} ${cif_wall_num_intervals} ${ubp_wall_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_ubp_outer_wall]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_ubp_outer_wall'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_cif_wall_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_ubp_outer_wall]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_ubp_outer_wall rename_boundaries_31'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_ubp_outer_wall]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_ubp_outer_wall
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_32]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_ubp_outer_wall
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_ubp_outer_wall]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_32 stitch_top_half_right_cif_wall_in_ubp_outer_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_33]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_ubp_outer_wall
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # Outer graphite in UBP outer wall
  [top_half_right_og_in_ubp_outer_wall]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_x_coord_3};
                 t2:=t-${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius}+${ubp_og_angle_4};
                 x1:=t1;
                 x2:=${ubp_x_coord_4};
                 x3:=${og_radius}*cos(t2);
                 x4:=${ubp_x_coord_3};
                 if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3},x1,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius},x2,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius + ubp_og_angle_3 - ubp_og_angle_4},x3,x4)))'
    y_formula = 't1:=t-${fparse ubp_x_coord_4 - ubp_x_coord_3}+${cif_outer_radius};
                 t2:=t-${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius}+${ubp_og_angle_4};
                 t3:=${ubp_og_y_coord_3}-(t-${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius + ubp_og_angle_3 - ubp_og_angle_4});
                 y1:=${cif_outer_radius};
                 y2:=t1;
                 y3:=${og_radius}*sin(t2);
                 y4:=t3;
                 if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3},y1,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius},y2,if(t<${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius + ubp_og_angle_3 - ubp_og_angle_4},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3}
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius}
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius + ubp_og_angle_3 - ubp_og_angle_4}
                                 ${fparse ubp_x_coord_4 - ubp_x_coord_3 + ubp_og_y_coord_4 - cif_outer_radius + ubp_og_angle_3 - ubp_og_angle_4 + ubp_og_y_coord_3 - cif_outer_radius}'
    nums_segments = '${ubp_wall_num_intervals} ${og_ubp_num_intervals} ${ubp_wall_num_intervals} ${og_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_og_in_ubp_outer_wall]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_og_in_ubp_outer_wall'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_og_in_ubp_outer_wall]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_og_in_ubp_outer_wall rename_boundaries_33'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_og_in_ubp_outer_wall]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_og_in_ubp_outer_wall
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_34]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_og_in_ubp_outer_wall
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_og_in_ubp_outer_wall]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_34 stitch_top_half_right_og_in_ubp_outer_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_35]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_og_in_ubp_outer_wall
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP outer wall in lead
  [top_half_right_ubp_outer_wall_in_lead]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_og_angle_4};
                 t2:=${ubp_lead_angle_3}-(t-${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3});
                 x1:=${og_radius}*cos(t1);
                 x2:=${ubp_x_coord_3};
                 x3:=${lead_radius}*cos(t2);
                 x4:=${ubp_x_coord_4};
                 if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4},x1,if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3},x2,if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3 + ubp_lead_angle_3 - ubp_lead_angle_4},x3,x4)))'
    y_formula = 't1:=t+${ubp_og_angle_4};
                 t2:=t-${fparse ubp_og_angle_3 - ubp_og_angle_4}+${ubp_og_y_coord_3};
                 t3:=${ubp_lead_angle_3}-(t-${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3});
                 t4:=${ubp_lead_y_coord_4}-(t-${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3 + ubp_lead_angle_3 - ubp_lead_angle_4});
                 y1:=${og_radius}*sin(t1);
                 y2:=t2;
                 y3:=${lead_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4},y1,if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3},y2,if(t<${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3 + ubp_lead_angle_3 - ubp_lead_angle_4},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_og_angle_3 - ubp_og_angle_4}
                                 ${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3}
                                 ${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3 + ubp_lead_angle_3 - ubp_lead_angle_4}
                                 ${fparse ubp_og_angle_3 - ubp_og_angle_4 + ubp_lead_y_coord_3 - ubp_og_y_coord_3 + ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_lead_y_coord_4 - ubp_og_y_coord_4}'
    nums_segments = '${ubp_wall_num_intervals} ${lead_ubp_num_intervals} ${ubp_wall_num_intervals} ${lead_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_outer_wall_in_lead]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_outer_wall_in_lead'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_outer_wall_in_lead]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_outer_wall_in_lead rename_boundaries_35'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_outer_wall_in_lead]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_outer_wall_in_lead
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_36]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_outer_wall_in_lead
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_outer_wall_in_lead]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_36 stitch_top_half_right_ubp_outer_wall_in_lead'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_37]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_outer_wall_in_lead
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP outer wall in air gap
  [top_half_right_ubp_outer_wall_in_ag]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_lead_angle_4};
                 t2:=${ubp_ag_angle_3}-(t-${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3});
                 x1:=${lead_radius}*cos(t1);
                 x2:=${ubp_x_coord_3};
                 x3:=${ag_radius}*cos(t2);
                 x4:=${ubp_x_coord_4};
                 if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4},x1,if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3},x2,if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3 + ubp_ag_angle_3 - ubp_ag_angle_4},x3,x4)))'
    y_formula = 't1:=t+${ubp_lead_angle_4};
                 t2:=t-${fparse ubp_lead_angle_3 - ubp_lead_angle_4}+${ubp_lead_y_coord_3};
                 t3:=${ubp_ag_angle_3}-(t-${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3});
                 t4:=${ubp_ag_y_coord_4}-(t-${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3 + ubp_ag_angle_3 - ubp_ag_angle_4});
                 y1:=${lead_radius}*sin(t1);
                 y2:=t2;
                 y3:=${ag_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4},y1,if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3},y2,if(t<${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3 + ubp_ag_angle_3 - ubp_ag_angle_4},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_lead_angle_3 - ubp_lead_angle_4}
                                 ${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3}
                                 ${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3 + ubp_ag_angle_3 - ubp_ag_angle_4}
                                 ${fparse ubp_lead_angle_3 - ubp_lead_angle_4 + ubp_ag_y_coord_3 - ubp_lead_y_coord_3 + ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_ag_y_coord_4 - ubp_lead_y_coord_4}'
    nums_segments = '${ubp_wall_num_intervals} ${ag_ubp_num_intervals} ${ubp_wall_num_intervals} ${ag_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_outer_wall_in_ag]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_outer_wall_in_ag'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_outer_wall_in_ag]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_outer_wall_in_ag rename_boundaries_37'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_outer_wall_in_ag]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_outer_wall_in_ag
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_38]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_outer_wall_in_ag
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_outer_wall_in_ag]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_38 stitch_top_half_right_ubp_outer_wall_in_ag'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_39]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_outer_wall_in_ag
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP outer wall in reactor tank
  [top_half_right_ubp_outer_wall_in_rt]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_ag_angle_4};
                 t2:=${ubp_rt_angle_3}-(t-${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3});
                 x1:=${ag_radius}*cos(t1);
                 x2:=${ubp_x_coord_3};
                 x3:=${rt_radius}*cos(t2);
                 x4:=${ubp_x_coord_4};
                 if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4},x1,if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3},x2,if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3 + ubp_rt_angle_3 - ubp_rt_angle_4},x3,x4)))'
    y_formula = 't1:=t+${ubp_ag_angle_4};
                 t2:=t-${fparse ubp_ag_angle_3 - ubp_ag_angle_4}+${ubp_ag_y_coord_3};
                 t3:=${ubp_rt_angle_3}-(t-${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3});
                 t4:=${ubp_rt_y_coord_4}-(t-${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3 + ubp_rt_angle_3 - ubp_rt_angle_4});
                 y1:=${ag_radius}*sin(t1);
                 y2:=t2;
                 y3:=${rt_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4},y1,if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3},y2,if(t<${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3 + ubp_rt_angle_3 - ubp_rt_angle_4},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_ag_angle_3 - ubp_ag_angle_4}
                                 ${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3}
                                 ${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3 + ubp_rt_angle_3 - ubp_rt_angle_4}
                                 ${fparse ubp_ag_angle_3 - ubp_ag_angle_4 + ubp_rt_y_coord_3 - ubp_ag_y_coord_3 + ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_rt_y_coord_4 - ubp_ag_y_coord_4}'
    nums_segments = '${ubp_wall_num_intervals} ${rt_ubp_num_intervals} ${ubp_wall_num_intervals} ${rt_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_outer_wall_in_rt]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_outer_wall_in_rt'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_outer_wall_in_rt]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_outer_wall_in_rt rename_boundaries_39'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_outer_wall_in_rt]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_outer_wall_in_rt
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_40]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_outer_wall_in_rt
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_outer_wall_in_rt]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_40 stitch_top_half_right_ubp_outer_wall_in_rt'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_41]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_outer_wall_in_rt
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # UBP outer_wall in water
  [top_half_right_ubp_outer_wall_in_water]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_rt_angle_4};
                 t2:=${ubp_water_angle_3}-(t-${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3});
                 x1:=${rt_radius}*cos(t1);
                 x2:=${ubp_x_coord_3};
                 x3:=${water_radius}*cos(t2);
                 x4:=${ubp_x_coord_4};
                 if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4},x1,if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3},x2,if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3 + ubp_water_angle_3 - ubp_water_angle_4},x3,x4)))'
    y_formula = 't1:=t+${ubp_rt_angle_4};
                 t2:=t-${fparse ubp_rt_angle_3 - ubp_rt_angle_4}+${ubp_rt_y_coord_3};
                 t3:=${ubp_water_angle_3}-(t-${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3});
                 t4:=${ubp_water_y_coord_4}-(t-${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3 + ubp_water_angle_3 - ubp_water_angle_4});
                 y1:=${rt_radius}*sin(t1);
                 y2:=t2;
                 y3:=${water_radius}*sin(t3);
                 y4:=t4;
                 if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4},y1,if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3},y2,if(t<${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3 + ubp_water_angle_3 - ubp_water_angle_4},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_rt_angle_3 - ubp_rt_angle_4}
                                 ${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3}
                                 ${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3 + ubp_water_angle_3 - ubp_water_angle_4}
                                 ${fparse ubp_rt_angle_3 - ubp_rt_angle_4 + ubp_water_y_coord_3 - ubp_rt_y_coord_3 + ubp_water_angle_3 - ubp_water_angle_4 + ubp_water_y_coord_4 - ubp_rt_y_coord_4}'
    nums_segments = '${ubp_wall_num_intervals} ${water_ubp_num_intervals} ${ubp_wall_num_intervals} ${water_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ubp_outer_wall_in_water]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ubp_outer_wall_in_water'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_ubp_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ubp_outer_wall_in_water]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ubp_outer_wall_in_water rename_boundaries_41'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ubp_outer_wall_in_water]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ubp_outer_wall_in_water
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_42]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ubp_outer_wall_in_water
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ubp_outer_wall_in_water]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_42 stitch_top_half_right_ubp_outer_wall_in_water'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_43]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ubp_outer_wall_in_water
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in outer graphite passed the UBP outer wall
  [top_half_right_cif_wall_in_og_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${ubp_x_coord_4};
                 t2:=${cif_og_x_coord}-(t-${fparse cif_og_x_coord - ubp_x_coord_4 + cif_outer_radius});
                 x1:=t1;
                 x2:=${cif_og_x_coord};
                 x3:=t2;
                 x4:=${ubp_x_coord_4};
                 if(t<${fparse cif_og_x_coord - ubp_x_coord_4},x1,if(t<${fparse cif_og_x_coord - ubp_x_coord_4 + cif_outer_radius},x2,if(t<${fparse 2*cif_og_x_coord - 2*ubp_x_coord_4 + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_og_x_coord - ubp_x_coord_4};
                 t2:=${cif_outer_radius}-(t-${fparse 2*cif_og_x_coord - 2*ubp_x_coord_4 + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse cif_og_x_coord - ubp_x_coord_4},y1,if(t<${fparse cif_og_x_coord - ubp_x_coord_4 + cif_outer_radius},y2,if(t<${fparse 2*cif_og_x_coord - 2*ubp_x_coord_4 + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse cif_og_x_coord - ubp_x_coord_4}
                                 ${fparse cif_og_x_coord - ubp_x_coord_4 + cif_outer_radius}
                                 ${fparse 2*cif_og_x_coord - 2*ubp_x_coord_4 + cif_outer_radius}
                                 ${fparse 2*cif_og_x_coord - 2*ubp_x_coord_4 + 2*cif_outer_radius}'
    nums_segments = '${ubp_channel_num_intervals} ${cif_wall_num_intervals} ${ubp_channel_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_og_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_og_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_cif_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_og_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_og_after_ubp rename_boundaries_43'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_og_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_og_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_44]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_og_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_og_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_44 stitch_top_half_right_cif_wall_in_og_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_45]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_og_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # Outer graphite passed the UBP outer wall
  [top_half_right_og_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_og_angle};
                 t2:=t-${fparse ubp_og_angle_4 - cif_og_angle + ubp_og_y_coord_4 - cif_outer_radius}+${ubp_x_coord_4};
                 x1:=${og_radius}*cos(t1);
                 x2:=${ubp_x_coord_4};
                 x3:=t2;
                 if(t<${fparse ubp_og_angle_4 - cif_og_angle},x1,if(t<${fparse ubp_og_angle_4 - cif_og_angle + ubp_og_y_coord_4 - cif_outer_radius},x2,x3))'
    y_formula = 't1:=t+${cif_og_angle};
                 t2:=${ubp_og_y_coord_4}-(t-${fparse ubp_og_angle_4 - cif_og_angle});
                 y1:=${og_radius}*sin(t1);
                 y2:=t2;
                 y3:=${cif_outer_radius};
                 if(t<${fparse ubp_og_angle_4 - cif_og_angle},y1,if(t<${fparse ubp_og_angle_4 - cif_og_angle + ubp_og_y_coord_4 - cif_outer_radius},y2,y3))'
    section_bounding_t_values = '0
                                 ${fparse ubp_og_angle_4 - cif_og_angle}
                                 ${fparse ubp_og_angle_4 - cif_og_angle + ubp_og_y_coord_4 - cif_outer_radius}
                                 ${fparse ubp_og_angle_4 - cif_og_angle + ubp_og_y_coord_4 - cif_outer_radius + cif_og_x_coord - ubp_x_coord_4}'
    nums_segments = '${og_ubp_num_intervals} ${og_ubp_num_intervals} ${ubp_channel_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_og_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_og_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${og_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_og_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_og_after_ubp rename_boundaries_45'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_og_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_og_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_46]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_og_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_og_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_46 stitch_top_half_right_og_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_47]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_og_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in lead passed the UBP outer wall
  [top_half_right_cif_wall_in_lead_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_og_x_coord};
                 t2:=${cif_lead_x_coord}-(t-${fparse cif_lead_x_coord - cif_og_x_coord + cif_outer_radius});
                 x1:=t1;
                 x2:=${cif_lead_x_coord};
                 x3:=t2;
                 x4:=${cif_og_x_coord};
                 if(t<${fparse cif_lead_x_coord - cif_og_x_coord},x1,if(t<${fparse cif_lead_x_coord - cif_og_x_coord + cif_outer_radius},x2,if(t<${fparse 2*cif_lead_x_coord - 2*cif_og_x_coord + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_lead_x_coord - cif_og_x_coord};
                 t2:=${cif_outer_radius}-(t-${fparse 2*cif_lead_x_coord - 2*cif_og_x_coord + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse cif_lead_x_coord - cif_og_x_coord},y1,if(t<${fparse cif_lead_x_coord - cif_og_x_coord + cif_outer_radius},y2,if(t<${fparse 2*cif_lead_x_coord - 2*cif_og_x_coord + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse cif_lead_x_coord - cif_og_x_coord}
                                 ${fparse cif_lead_x_coord - cif_og_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_lead_x_coord - 2*cif_og_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_lead_x_coord - 2*cif_og_x_coord + 2*cif_outer_radius}'
    nums_segments = '${lead_ubp_num_intervals} ${cif_wall_num_intervals} ${lead_ubp_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_lead_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_lead_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_cif_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_lead_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_lead_after_ubp rename_boundaries_47'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_lead_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_lead_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_48]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_lead_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_lead_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_48 stitch_top_half_right_cif_wall_in_lead_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_49]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_lead_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # Lead passed the UBP outer wall
  [top_half_right_lead_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_lead_angle};
                 t2:=${ubp_og_angle_4}-(t-${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4});
                 t3:=${cif_og_x_coord}+(t-${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4 + ubp_og_angle_4 - cif_og_angle});
                 x1:=${lead_radius}*cos(t1);
                 x2:=${ubp_x_coord_4};
                 x3:=${og_radius}*cos(t2);
                 x4:=t3;
                 if(t<${fparse ubp_lead_angle_4 - cif_lead_angle},x1,if(t<${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4},x2,if(t<${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4 + ubp_og_angle_4 - cif_og_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_lead_angle};
                 t2:=${ubp_lead_y_coord_4}-(t-${fparse ubp_lead_angle_4 - cif_lead_angle});
                 t3:=${ubp_og_angle_4}-(t-${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4});
                 y1:=${lead_radius}*sin(t1);
                 y2:=t2;
                 y3:=${og_radius}*sin(t3);
                 y4:=${cif_outer_radius};
                 if(t<${fparse ubp_lead_angle_4 - cif_lead_angle},y1,if(t<${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4},y2,if(t<${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4 + ubp_og_angle_4 - cif_og_angle},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_lead_angle_4 - cif_lead_angle}
                                 ${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4}
                                 ${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4 + ubp_og_angle_4 - cif_og_angle}
                                 ${fparse ubp_lead_angle_4 - cif_lead_angle + ubp_lead_y_coord_4 - ubp_og_y_coord_4 + ubp_og_angle_4 - cif_og_angle + cif_lead_x_coord - cif_og_x_coord}'
    nums_segments = '${curve_between_bp_num_intervals} ${lead_ubp_num_intervals} ${og_ubp_num_intervals} ${lead_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_lead_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_lead_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${lead_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_lead_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_lead_after_ubp rename_boundaries_49'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_lead_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_lead_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_50]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_lead_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_lead_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_50 stitch_top_half_right_lead_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_51]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_lead_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in air gap passed the UBP outer wall
  [top_half_right_cif_wall_in_ag_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_lead_x_coord};
                 t2:=${cif_ag_x_coord}-(t-${fparse cif_ag_x_coord - cif_lead_x_coord + cif_outer_radius});
                 x1:=t1;
                 x2:=${cif_ag_x_coord};
                 x3:=t2;
                 x4:=${cif_lead_x_coord};
                 if(t<${fparse cif_ag_x_coord - cif_lead_x_coord},x1,if(t<${fparse cif_ag_x_coord - cif_lead_x_coord + cif_outer_radius},x2,if(t<${fparse 2*cif_ag_x_coord - 2*cif_lead_x_coord + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_ag_x_coord - cif_lead_x_coord};
                 t2:=${cif_outer_radius}-(t-${fparse 2*cif_ag_x_coord - 2*cif_lead_x_coord + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse cif_ag_x_coord - cif_lead_x_coord},y1,if(t<${fparse cif_ag_x_coord - cif_lead_x_coord + cif_outer_radius},y2,if(t<${fparse 2*cif_ag_x_coord - 2*cif_lead_x_coord + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse cif_ag_x_coord - cif_lead_x_coord}
                                 ${fparse cif_ag_x_coord - cif_lead_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_ag_x_coord - 2*cif_lead_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_ag_x_coord - 2*cif_lead_x_coord + 2*cif_outer_radius}'
    nums_segments = '${ag_ubp_num_intervals} ${cif_wall_num_intervals} ${ag_ubp_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_ag_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_ag_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_cif_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_ag_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_ag_after_ubp rename_boundaries_51'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_ag_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_ag_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_52]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_ag_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_ag_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_52 stitch_top_half_right_cif_wall_in_ag_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_53]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_ag_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # ag passed the UBP outer wall
  [top_half_right_ag_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_ag_angle};
                 t2:=${ubp_lead_angle_4}-(t-${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4});
                 t3:=${cif_lead_x_coord}+(t-${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4 + ubp_lead_angle_4 - cif_lead_angle});
                 x1:=${ag_radius}*cos(t1);
                 x2:=${ubp_x_coord_4};
                 x3:=${lead_radius}*cos(t2);
                 x4:=t3;
                 if(t<${fparse ubp_ag_angle_4 - cif_ag_angle},x1,if(t<${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4},x2,if(t<${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4 + ubp_lead_angle_4 - cif_lead_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_ag_angle};
                 t2:=${ubp_ag_y_coord_4}-(t-${fparse ubp_ag_angle_4 - cif_ag_angle});
                 t3:=${ubp_lead_angle_4}-(t-${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4});
                 y1:=${ag_radius}*sin(t1);
                 y2:=t2;
                 y3:=${lead_radius}*sin(t3);
                 y4:=${cif_outer_radius};
                 if(t<${fparse ubp_ag_angle_4 - cif_ag_angle},y1,if(t<${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4},y2,if(t<${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4 + ubp_lead_angle_4 - cif_lead_angle},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_ag_angle_4 - cif_ag_angle}
                                 ${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4}
                                 ${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4 + ubp_lead_angle_4 - cif_lead_angle}
                                 ${fparse ubp_ag_angle_4 - cif_ag_angle + ubp_ag_y_coord_4 - ubp_lead_y_coord_4 + ubp_lead_angle_4 - cif_lead_angle + cif_ag_x_coord - cif_lead_x_coord}'
    nums_segments = '${curve_between_bp_num_intervals} ${ag_ubp_num_intervals} ${curve_between_bp_num_intervals} ${ag_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_ag_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_ag_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${ag_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_ag_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_ag_after_ubp rename_boundaries_53'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_ag_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_ag_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_54]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_ag_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_ag_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_54 stitch_top_half_right_ag_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_55]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_ag_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in reactor tank passed the UBP outer wall
  [top_half_right_cif_wall_in_rt_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_ag_x_coord};
                 t2:=${cif_rt_x_coord}-(t-${fparse cif_rt_x_coord - cif_ag_x_coord + cif_outer_radius});
                 x1:=t1;
                 x2:=${cif_rt_x_coord};
                 x3:=t2;
                 x4:=${cif_ag_x_coord};
                 if(t<${fparse cif_rt_x_coord - cif_ag_x_coord},x1,if(t<${fparse cif_rt_x_coord - cif_ag_x_coord + cif_outer_radius},x2,if(t<${fparse 2*cif_rt_x_coord - 2*cif_ag_x_coord + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_rt_x_coord - cif_ag_x_coord};
                 t2:=${cif_outer_radius}-(t-${fparse 2*cif_rt_x_coord - 2*cif_ag_x_coord + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse cif_rt_x_coord - cif_ag_x_coord},y1,if(t<${fparse cif_rt_x_coord - cif_ag_x_coord + cif_outer_radius},y2,if(t<${fparse 2*cif_rt_x_coord - 2*cif_ag_x_coord + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse cif_rt_x_coord - cif_ag_x_coord}
                                 ${fparse cif_rt_x_coord - cif_ag_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_rt_x_coord - 2*cif_ag_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_rt_x_coord - 2*cif_ag_x_coord + 2*cif_outer_radius}'
    nums_segments = '${rt_ubp_num_intervals} ${cif_wall_num_intervals} ${rt_ubp_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_rt_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_rt_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_cif_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_rt_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_rt_after_ubp rename_boundaries_55'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_rt_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_rt_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_56]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_rt_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_rt_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_56 stitch_top_half_right_cif_wall_in_rt_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_57]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_rt_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # rt passed the UBP outer wall
  [top_half_right_rt_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_rt_angle};
                 t2:=${ubp_ag_angle_4}-(t-${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4});
                 t3:=${cif_ag_x_coord}+(t-${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4 + ubp_ag_angle_4 - cif_ag_angle});
                 x1:=${rt_radius}*cos(t1);
                 x2:=${ubp_x_coord_4};
                 x3:=${ag_radius}*cos(t2);
                 x4:=t3;
                 if(t<${fparse ubp_rt_angle_4 - cif_rt_angle},x1,if(t<${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4},x2,if(t<${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4 + ubp_ag_angle_4 - cif_ag_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_rt_angle};
                 t2:=${ubp_rt_y_coord_4}-(t-${fparse ubp_rt_angle_4 - cif_rt_angle});
                 t3:=${ubp_ag_angle_4}-(t-${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4});
                 y1:=${rt_radius}*sin(t1);
                 y2:=t2;
                 y3:=${ag_radius}*sin(t3);
                 y4:=${cif_outer_radius};
                 if(t<${fparse ubp_rt_angle_4 - cif_rt_angle},y1,if(t<${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4},y2,if(t<${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4 + ubp_ag_angle_4 - cif_ag_angle},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_rt_angle_4 - cif_rt_angle}
                                 ${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4}
                                 ${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4 + ubp_ag_angle_4 - cif_ag_angle}
                                 ${fparse ubp_rt_angle_4 - cif_rt_angle + ubp_rt_y_coord_4 - ubp_ag_y_coord_4 + ubp_ag_angle_4 - cif_ag_angle + cif_rt_x_coord - cif_ag_x_coord}'
    nums_segments = '${curve_between_bp_num_intervals} ${rt_ubp_num_intervals} ${curve_between_bp_num_intervals} ${rt_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_rt_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_rt_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${rt_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_rt_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_rt_after_ubp rename_boundaries_57'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_rt_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_rt_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_58]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_rt_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_rt_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_58 stitch_top_half_right_rt_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_59]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_rt_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # CIF outer wall in water passed the UBP outer wall
  [top_half_right_cif_wall_in_water_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_rt_x_coord};
                 t2:=${cif_water_x_coord}-(t-${fparse cif_water_x_coord - cif_rt_x_coord + cif_outer_radius});
                 x1:=t1;
                 x2:=${cif_water_x_coord};
                 x3:=t2;
                 x4:=${cif_rt_x_coord};
                 if(t<${fparse cif_water_x_coord - cif_rt_x_coord},x1,if(t<${fparse cif_water_x_coord - cif_rt_x_coord + cif_outer_radius},x2,if(t<${fparse 2*cif_water_x_coord - 2*cif_rt_x_coord + cif_outer_radius},x3,x4)))'
    y_formula = 't1:=t-${fparse cif_water_x_coord - cif_rt_x_coord};
                 t2:=${cif_outer_radius}-(t-${fparse 2*cif_water_x_coord - 2*cif_rt_x_coord + cif_outer_radius});
                 y1:=0;
                 y2:=t1;
                 y3:=${cif_outer_radius};
                 y4:=t2;
                 if(t<${fparse cif_water_x_coord - cif_rt_x_coord},y1,if(t<${fparse cif_water_x_coord - cif_rt_x_coord + cif_outer_radius},y2,if(t<${fparse 2*cif_water_x_coord - 2*cif_rt_x_coord + cif_outer_radius},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse cif_water_x_coord - cif_rt_x_coord}
                                 ${fparse cif_water_x_coord - cif_rt_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_water_x_coord - 2*cif_rt_x_coord + cif_outer_radius}
                                 ${fparse 2*cif_water_x_coord - 2*cif_rt_x_coord + 2*cif_outer_radius}'
    nums_segments = '${water_ubp_num_intervals} ${cif_wall_num_intervals} ${water_ubp_num_intervals} ${cif_wall_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_cif_wall_in_water_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_cif_wall_in_water_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_cif_wall_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_cif_wall_in_water_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_cif_wall_in_water_after_ubp rename_boundaries_59'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_cif_wall_in_water_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_cif_wall_in_water_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_60]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_cif_wall_in_water_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_cif_wall_in_water_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_60 stitch_top_half_right_cif_wall_in_water_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_61]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_cif_wall_in_water_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # water passed the UBP outer wall
  [top_half_right_water_after_ubp]
    type = ParsedCurveGenerator
    x_formula = 't1:=t+${cif_water_angle};
                 t2:=${ubp_rt_angle_4}-(t-${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4});
                 t3:=${cif_rt_x_coord}+(t-${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4 + ubp_rt_angle_4 - cif_rt_angle});
                 x1:=${water_radius}*cos(t1);
                 x2:=${ubp_x_coord_4};
                 x3:=${rt_radius}*cos(t2);
                 x4:=t3;
                 if(t<${fparse ubp_water_angle_4 - cif_water_angle},x1,if(t<${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4},x2,if(t<${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4 + ubp_rt_angle_4 - cif_rt_angle},x3,x4)))'
    y_formula = 't1:=t+${cif_water_angle};
                 t2:=${ubp_water_y_coord_4}-(t-${fparse ubp_water_angle_4 - cif_water_angle});
                 t3:=${ubp_rt_angle_4}-(t-${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4});
                 y1:=${water_radius}*sin(t1);
                 y2:=t2;
                 y3:=${rt_radius}*sin(t3);
                 y4:=${cif_outer_radius};
                 if(t<${fparse ubp_water_angle_4 - cif_water_angle},y1,if(t<${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4},y2,if(t<${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4 + ubp_rt_angle_4 - cif_rt_angle},y3,y4)))'
    section_bounding_t_values = '0
                                 ${fparse ubp_water_angle_4 - cif_water_angle}
                                 ${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4}
                                 ${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4 + ubp_rt_angle_4 - cif_rt_angle}
                                 ${fparse ubp_water_angle_4 - cif_water_angle + ubp_water_y_coord_4 - ubp_rt_y_coord_4 + ubp_rt_angle_4 - cif_rt_angle + cif_water_x_coord - cif_rt_x_coord}'
    nums_segments = '${water_past_ubp_num_intervals} ${water_ubp_num_intervals} ${curve_between_bp_num_intervals} ${water_ubp_num_intervals}'
    is_closed_loop = true
  []
  [xydg_mesh_top_half_right_water_after_ubp]
    type = XYDelaunayGenerator
    boundary = 'top_half_right_water_after_ubp'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${water_block_id}
    output_boundary = ${boundary_id_index_11}
    desired_area = ${xydg_area}
  []
  [stitch_top_half_right_water_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'xydg_mesh_top_half_right_water_after_ubp rename_boundaries_61'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_11} ${boundary_id_index_10}'
  []
  # We can reflect about the Y-axis and reuse the previously made mesh.
  [xydg_mesh_top_half_left_water_after_ubp]
    type = SymmetryTransformGenerator
    input = xydg_mesh_top_half_right_water_after_ubp
    mirror_normal_vector = '1 0 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_62]
    type = RenameBoundaryGenerator
    input = xydg_mesh_top_half_left_water_after_ubp
    old_boundary = '${boundary_id_index_11}'
    new_boundary = '${boundary_id_index_12}'
  []
  [stitch_top_half_left_water_after_ubp]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_62 stitch_top_half_right_water_after_ubp'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_12} ${boundary_id_index_10}'
  []
  [rename_boundaries_63]
    type = RenameBoundaryGenerator
    input = stitch_top_half_left_water_after_ubp
    old_boundary = '${boundary_id_index_10} ${boundary_id_index_11} ${boundary_id_index_12}'
    new_boundary = '${boundary_id_index_10} ${boundary_id_index_10} ${boundary_id_index_10}'
  []
  # We can reflect about the X-axis and reuse the previously made mesh.
  [bottom_half_reactor]
    type = SymmetryTransformGenerator
    input = rename_boundaries_63
    mirror_normal_vector = '0 1 0'
    mirror_point = '0 0 0'
  []
  [rename_boundaries_87]
    type = RenameBoundaryGenerator
    input = bottom_half_reactor
    old_boundary = '${boundary_id_index_10}'
    new_boundary = '${boundary_id_index_11}'
  []
  # Delete blocks for meshing the FCR and SR2
  [delete_bottom_core_blocks]
    type = BlockDeletionGenerator
    input = rename_boundaries_87
    block = '1011 1012 1031 1032 ${core_block_id}'
    new_boundary = '${boundary_id_index_20}'
  []
  # The deletion has created a void where the deleted pin cells were. We now assign a block ID to the deleted area
  [rebuild_bottom_core_block]
    type = LowerDBlockFromSidesetGenerator
    input = delete_bottom_core_blocks
    sidesets = '${boundary_id_index_20}'
    new_block_id = '6123'
    new_block_name = 'rebuilt_bottom_core_block'
  []
  # Next we mesh the area with the new block ID, removing the void
  # In reality, we need to use XYDG to actually "mesh" this, this is just an intermediate step for using XYDG
  [remesh_bottom_core_block]
    type = BlockToMeshConverterGenerator
    input = rebuild_bottom_core_block
    target_blocks = 'rebuilt_bottom_core_block'
  []
  # Now if we had a dozen or so of these rods with the same dimensions I would translate and copy the same meshes
  # over and over again so we could avoid doing a fully re-declaration.
  # However, since we have 3(?) rods of the same size which may need unique block IDs, I just go ahead and explicitly define SR2, CCR, and FCR
  [sr2_base]
    type = PolygonConcentricCircleMeshGenerator
    polygon_size_style = apothem
    polygon_size = ${sr_bg_size}
    num_sides = ${sr_polygon_num_sides}
    num_sectors_per_side = ${sr_polygon_num_sectors_per_side_vector}
    background_intervals = 1
    ring_radii = '${sr_inner_radius} ${sr_outer_radius}'
    ring_intervals = '1 1'
    # This means we will have quads everywhere, which avoids TRI/QUAD conflicts
    # during block ID assignment and looks better a lot of the time.
    quad_center_elements = true
    background_block_ids = '${to_delete_block_id}'
    background_block_names = '${to_delete_block_name}'
    ring_block_ids = '${sr2_inner_block_id} ${sr2_outer_block_id}'
    ring_block_names = '${sr2_inner_block_name} ${sr2_outer_block_name}'
    interface_boundary_id_shift = 20
  []
  # Delete background around SR2
  [sr2_delete_bg]
    type = BlockDeletionGenerator
    input = sr2_base
    block = '${to_delete_block_name}'
    new_boundary = ${boundary_id_index_21}
  []
  [sr2_transform]
    type = TransformGenerator
    input = sr2_delete_bg
    transform = TRANSLATE
    vector_value = '${sr2_x_pos} ${sr2_y_pos} 0.0'
  []
  # Now add the FCR
  [fcr_base]
    type = PolygonConcentricCircleMeshGenerator
    polygon_size_style = apothem
    polygon_size = ${fcr_bg_size}
    num_sides = ${fcr_polygon_num_sides}
    num_sectors_per_side = ${fcr_polygon_num_sectors_per_side_vector}
    background_intervals = 1
    ring_radii = '${fcr_inner_radius} ${fcr_outer_radius}'
    ring_intervals = '1 1'
    # This means we will have quads everywhere, which avoids TRI/QUAD conflicts
    # during block ID assignment and looks better a lot of the time.
    quad_center_elements = true
    background_block_ids = '${to_delete_block_id}'
    background_block_names = '${to_delete_block_name}'
    ring_block_ids = '${fcr_inner_block_id} ${fcr_outer_block_id}'
    ring_block_names = '${fcr_inner_block_name} ${fcr_outer_block_name}'
    interface_boundary_id_shift = 40
  []
  # Delete background around FCR
  [fcr_delete_bg]
    type = BlockDeletionGenerator
    input = fcr_base
    block = '${to_delete_block_name}'
    new_boundary = ${boundary_id_index_22}
  []
  [fcr_transform]
    type = TransformGenerator
    input = fcr_delete_bg
    transform = TRANSLATE
    vector_value = '${fcr_x_pos} ${fcr_y_pos} 0.0'
  []
  [xydg_mesh_core_around_fcr_and_sr2]
    type = XYDelaunayGenerator
    boundary = 'remesh_bottom_core_block'
    holes = 'sr2_transform fcr_transform'
    stitch_holes = 'true true'
    refine_holes = 'false false'
    add_nodes_per_boundary_segment = 0
    refine_boundary = false
    smooth_triangulation = true
    output_subdomain_name = ${core_block_id}
    output_boundary = ${boundary_id_index_23}
    desired_area = 1.0
  []
  [stitch_remeshed_bottom_core_region]
    type = StitchedMeshGenerator
    inputs = 'delete_bottom_core_blocks xydg_mesh_core_around_fcr_and_sr2'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_20} ${boundary_id_index_23}'
  []
  [stitch_core_halves]
    type = StitchedMeshGenerator
    inputs = 'rename_boundaries_63 stitch_remeshed_bottom_core_region'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_10} ${boundary_id_index_11}'
  []
  [rename_boundaries_88]
    type = RenameBoundaryGenerator
    input = stitch_core_halves
    old_boundary = '10020'
    new_boundary = ${boundary_id_index_10}
  []
  # SRs, CCR, and FCR all get weird IDs from the XYDG meshing
  [rename_rod_blocks]
    type = RenameBlockGenerator
    input = rename_boundaries_88
    old_block = '1011 1012 1021 1022 1031 1032 1041 1042'
    new_block = '${sr1_inner_block_id} ${sr1_outer_block_id} ${sr2_inner_block_id} ${sr2_outer_block_id} ${ccr_inner_block_id} ${ccr_outer_block_id} ${fcr_inner_block_id} ${fcr_outer_block_id}'
  []
  # Delete core cif region to then remesh with the thermal fuse
  [delete_core_cif_wall]
    type = BlockDeletionGenerator
    input = rename_rod_blocks
    block = ${core_cif_wall_block_id}
    new_boundary = ${boundary_id_index_30}
  []
  [rebuild_core_cif_wall]
    type = LowerDBlockFromSidesetGenerator
    input = delete_core_cif_wall
    sidesets = '${boundary_id_index_30}'
    new_block_id = '7123'
    new_block_name = 'rebuilt_core_cif_wall'
  []
  [remesh_core_cif_wall]
    type = BlockToMeshConverterGenerator
    input = rebuild_core_cif_wall
    target_blocks = 'rebuilt_core_cif_wall'
  []
  # Used ParsedCurveGenerator to model the thermal fuse
  [tf_square]
    type = ParsedCurveGenerator
    x_formula = 't1:=t-${tf_half_side_length};
                 t2:=${tf_half_side_length};
                 t3:=${tf_half_side_length}-(t-${fparse 2*tf_side_length});
                 t4:=-${tf_half_side_length};
                 x1:=t1;
                 x2:=t2;
                 x3:=t3;
                 x4:=t4;
                 if(t<${tf_side_length},x1,if(t<${fparse 2*tf_side_length},x2,if(t<${fparse 3*tf_side_length},x3,x4)))'
    y_formula = 't1:=-${tf_half_side_length};
                 t2:=t-${fparse 3*tf_half_side_length};
                 t3:=${tf_half_side_length};
                 t4:=${tf_half_side_length}-(t-${fparse 3 * tf_side_length});
                 y1:=t1;
                 y2:=t2;
                 y3:=t3;
                 y4:=t4;
                 if(t<${tf_side_length},y1,if(t<${fparse 2*tf_side_length},y2,if(t<${fparse 3*tf_side_length},y3,y4)))'
    section_bounding_t_values = '0 ${tf_side_length} ${fparse 2*tf_side_length} ${fparse 3*tf_side_length} ${fparse 4*tf_side_length}'
    nums_segments = '${tf_num_segments} ${tf_num_segments} ${tf_num_segments} ${tf_num_segments}'
    is_closed_loop = true
  []
  [tf_pcc]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 4
    num_sectors_per_side = '${tf_num_segments} ${tf_num_segments} ${tf_num_segments} ${tf_num_segments}'
    background_intervals = 1
    ring_radii = '${tf_support_radius}'
    ring_intervals = 1
    ring_block_ids = '${tf_support_block_id}'
    ring_block_names = '${tf_support_block_name}'
    background_block_ids = '${tf_quad_block_id}'
    background_block_names = '${tf_quad_block_name}'
    polygon_size = ${tf_half_side_length}
    polygon_size_style = apothem
  []
  # Need to rotate 45 degrees because of how PCCMG renders the mesh
  [rotate_tf]
    type = TransformGenerator
    input = tf_pcc
    transform = ROTATE
    vector_value = '45 0 0'
  []
  # Rename Boundaries because otherwise there will be problems
  [rename_boundaries_100]
    type = RenameBoundaryGenerator
    input = rotate_tf
    old_boundary = '1 10000'
    new_boundary = '${boundary_id_index_40} ${boundary_id_index_41}'
  []
  [xydg_tf]
    type = XYDelaunayGenerator
    boundary = remesh_core_cif_wall
    holes = 'rename_boundaries_100'
    stitch_holes = 'true'
    refine_holes = 'false'
    # one point of the CIF "hole" is not properly found inside the outer boundary
    verify_holes = 'false'
    output_boundary = ${boundary_id_index_45}
    smooth_triangulation = true
    desired_area = ${xydg_area}
    output_subdomain_name = ${core_cif_wall_block_id}
  []
  [stitch_cif_with_tf_to_core]
    type = StitchedMeshGenerator
    inputs = 'xydg_tf delete_core_cif_wall'
    clear_stitched_boundary_ids = false
    prevent_boundary_ids_overlap = false
    stitch_boundaries_pairs = '${boundary_id_index_45} ${boundary_id_index_30}'
  []
  # Map block names to block IDs
  [rename_blocks_final_2d]
    type = RenameBlockGenerator
    input = stitch_cif_with_tf_to_core
    old_block = '${core_block_id}   ${core_cif_wall_block_id}   ${ig_block_id}   ${ig_cif_wall_block_id}   ${at_block_id}   ${at_cif_wall_block_id}   ${og_block_id}   ${og_cif_wall_block_id}   ${og_cif_wall_ubp_wall_block_id}   ${og_ubp_wall_block_id}   ${og_ubp_channel_block_id}   ${og_cif_wall_ubp_channel_block_id}   ${og_cif_wall_ubp_wall_block_id}   ${lead_block_id}   ${lead_cif_wall_block_id}   ${lead_ubp_wall_block_id}   ${lead_ubp_channel_block_id}   ${ag_block_id}   ${ag_cif_wall_block_id}   ${ag_ubp_wall_block_id}   ${ag_ubp_channel_block_id}   ${rt_block_id}   ${rt_cif_wall_block_id}   ${rt_ubp_wall_block_id}   ${rt_ubp_channel_block_id}   ${water_block_id}   ${water_cif_wall_block_id}   ${water_ubp_wall_block_id}   ${water_ubp_channel_block_id}   ${sr1_inner_block_id}   ${sr1_outer_block_id}   ${sr2_inner_block_id}   ${sr2_outer_block_id}   ${ccr_inner_block_id}   ${ccr_outer_block_id}   ${fcr_inner_block_id}   ${fcr_outer_block_id} ${tf_quad_block_id}     ${tf_support_block_id}'
    new_block = '${core_block_name} ${core_cif_wall_block_name} ${ig_block_name} ${ig_cif_wall_block_name} ${at_block_name} ${at_cif_wall_block_name} ${og_block_name} ${og_cif_wall_block_name} ${og_cif_wall_ubp_wall_block_name} ${og_ubp_wall_block_name} ${og_ubp_channel_block_name} ${og_cif_wall_ubp_channel_block_name} ${og_cif_wall_ubp_wall_block_name} ${lead_block_name} ${lead_cif_wall_block_name} ${lead_ubp_wall_block_name} ${lead_ubp_channel_block_name} ${ag_block_name} ${ag_cif_wall_block_name} ${ag_ubp_wall_block_name} ${ag_ubp_channel_block_name} ${rt_block_name} ${rt_cif_wall_block_name} ${rt_ubp_wall_block_name} ${rt_ubp_channel_block_name} ${water_block_name} ${water_cif_wall_block_name} ${water_ubp_wall_block_name} ${water_ubp_channel_block_name} ${sr1_inner_block_name} ${sr1_outer_block_name} ${sr2_inner_block_name} ${sr2_outer_block_name} ${ccr_inner_block_name} ${ccr_outer_block_name} ${fcr_inner_block_name} ${fcr_outer_block_name} ${tf_quad_block_name} ${tf_support_block_name}'
  []
  # Extrude from 2D to 3D
  [extrude]
    type = AdvancedExtruderGenerator
    input = rename_blocks_final_2d
    # Layer 01: Water
    # Layer 02: Steel
    # Layer 03: Lead
    # Layer 04: Al Tank/Graphite
    # Layer 05: Graphite & TF Support
    # Layer 06: Fuel Plate 1 & TF Support
    # Layer 07: BP & FP 1 & TF Support
    # Layer 08: BP & FP 2 & TF Support
    # Layer 09: BP & FP 3 & TF Support
    # Layer 10: BP & FP 3 & TF
    # Layer 11: FP 3 & TF
    # Layer 12: FP 3 & CIF
    # Layer 13: FP 4 & CIF
    # Layer 14: FP 4
    # Layer 15: BP & FP 4
    # Layer 16: BP & FP 5
    # Layer 17: BP & FP 6
    # Layer 18: BP & FP 7
    # Layer 19: BP & FP 8
    # Layer 20: BP & FP 9
    # Layer 21: BP & RAD
    # Layer 22: RAD
    # Layer 23: Graphite
    # Layer 24: Al Tank/Graphite
    # Layer 25: Lead
    # Layer 26: Thermal Column Void?
    # Layer 27: Thermal Column
    # Layer 28: Water
    #             1     2   3  4 5    6      7      8 9      10     11     12     13     14     15     16  17  18  19 20 21     22     23   24 25 26  27 28
    heights = '17.11 0.8 10 2 29.5 1.2134 2.7866 4 1.7452 0.5414 1.0461 0.6673 1.8673 1.5961 0.5366 1.9 1.9 1.9 1  1  0.8366 0.1634 21.8 2  10 0.8 60 1.29'
    num_layers = '1     1   1  1 1    1      1      1 1      1      1      1      1      1      1      1   1   1   1  1  1      1      1    1  1  1   1  1'
    direction = '0 0 1'
    # This is where we swap the block id for each extruded block created by 'heights'. So for a given height where there is only water, we swap all block ids to the water block id
    # For the beam ports and CIF, I DO NOT swap these block ids to a single CIF/BP block id, rather I will use a rename block generator for that.
    # Note that we also need quad block ids for materials that cover elements on an entire axial plane because the SR, CCR, and FCR are composed of QUAD elements which must have different block IDs from TRI elements
    # This also strips the names from the blocks so we'll need to re-assign those
    subdomain_swaps = '
    ${core_block_id} ${water_block_id}
    ${core_cif_wall_block_id} ${water_block_id}
    ${ig_block_id} ${water_block_id}
    ${ig_cif_wall_block_id} ${water_block_id}
    ${at_block_id} ${water_block_id}
    ${at_cif_wall_block_id} ${water_block_id}
    ${og_block_id} ${water_block_id}
    ${og_cif_wall_block_id} ${water_block_id}
    ${og_ubp_wall_block_id} ${water_block_id}
    ${og_ubp_channel_block_id} ${water_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${water_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${water_block_id}
    ${lead_block_id} ${water_block_id}
    ${lead_cif_wall_block_id} ${water_block_id}
    ${lead_ubp_wall_block_id} ${water_block_id}
    ${lead_ubp_channel_block_id} ${water_block_id}
    ${ag_block_id} ${water_block_id}
    ${ag_cif_wall_block_id} ${water_block_id}
    ${ag_ubp_wall_block_id} ${water_block_id}
    ${ag_ubp_channel_block_id} ${water_block_id}
    ${rt_block_id} ${water_block_id}
    ${rt_cif_wall_block_id} ${water_block_id}
    ${rt_ubp_wall_block_id} ${water_block_id}
    ${rt_ubp_channel_block_id} ${water_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${water_quad_block_id}
    ${sr1_outer_block_id} ${water_quad_block_id}
    ${sr2_inner_block_id} ${water_quad_block_id}
    ${sr2_outer_block_id} ${water_quad_block_id}
    ${ccr_inner_block_id} ${water_quad_block_id}
    ${ccr_outer_block_id} ${water_quad_block_id}
    ${fcr_inner_block_id} ${water_quad_block_id}
    ${fcr_outer_block_id} ${water_quad_block_id}
    ${tf_quad_block_id} ${water_quad_block_id}
    ${tf_support_block_id} ${water_block_id}
    ;
    ${core_block_id} ${rt_block_id}
    ${core_cif_wall_block_id} ${rt_block_id}
    ${ig_block_id} ${rt_block_id}
    ${ig_cif_wall_block_id} ${rt_block_id}
    ${at_block_id} ${rt_block_id}
    ${at_cif_wall_block_id} ${rt_block_id}
    ${og_block_id} ${rt_block_id}
    ${og_cif_wall_block_id} ${rt_block_id}
    ${og_ubp_wall_block_id} ${rt_block_id}
    ${og_ubp_channel_block_id} ${rt_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${rt_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${rt_block_id}
    ${lead_block_id} ${rt_block_id}
    ${lead_cif_wall_block_id} ${rt_block_id}
    ${lead_ubp_wall_block_id} ${rt_block_id}
    ${lead_ubp_channel_block_id} ${rt_block_id}
    ${ag_block_id} ${rt_block_id}
    ${ag_cif_wall_block_id} ${rt_block_id}
    ${ag_ubp_wall_block_id} ${rt_block_id}
    ${ag_ubp_channel_block_id} ${rt_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${rt_quad_block_id}
    ${sr1_outer_block_id} ${rt_quad_block_id}
    ${sr2_inner_block_id} ${rt_quad_block_id}
    ${sr2_outer_block_id} ${rt_quad_block_id}
    ${ccr_inner_block_id} ${rt_quad_block_id}
    ${ccr_outer_block_id} ${rt_quad_block_id}
    ${fcr_inner_block_id} ${rt_quad_block_id}
    ${fcr_outer_block_id} ${rt_quad_block_id}
    ${tf_quad_block_id} ${rt_quad_block_id}
    ${tf_support_block_id} ${rt_block_id}
    ;
    ${core_block_id} ${lead_block_id}
    ${core_cif_wall_block_id} ${lead_block_id}
    ${ig_block_id} ${lead_block_id}
    ${ig_cif_wall_block_id} ${lead_block_id}
    ${at_block_id} ${lead_block_id}
    ${at_cif_wall_block_id} ${lead_block_id}
    ${og_block_id} ${lead_block_id}
    ${og_cif_wall_block_id} ${lead_block_id}
    ${og_ubp_wall_block_id} ${lead_block_id}
    ${og_ubp_channel_block_id} ${lead_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${lead_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${lead_block_id}
    ${lead_block_id} ${lead_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_block_id} ${ag_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_quad_block_id} ${lead_quad_block_id}
    ${tf_support_block_id} ${lead_block_id}
    ;
    ${core_block_id} ${at_block_id}
    ${core_cif_wall_block_id} ${at_block_id}
    ${ig_block_id} ${at_block_id}
    ${ig_cif_wall_block_id} ${at_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_quad_block_id} ${at_quad_block_id}
    ${tf_support_block_id} ${at_block_id}
    ;
    ${core_block_id} ${ig_block_id}
    ${core_cif_wall_block_id} ${ig_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_quad_block_id} ${ag_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_1_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_1_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_quad_block_id} ${ag_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_1_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_1_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${tf_quad_block_id} ${ag_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_2_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_2_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${tf_quad_block_id} ${ag_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_3_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_3_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${tf_quad_block_id} ${ag_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_3_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_3_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${tf_support_block_id} ${tf_block_id}
    ;
    ${core_block_id} ${fuel_plate_3_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_3_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_support_block_id} ${tf_block_id}
    ;
    ${core_block_id} ${fuel_plate_3_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_cif_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_cif_wall_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_support_block_id} ${core_cif_wall_block_id}
    ${tf_quad_block_id} ${cif_channel_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_4_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_cif_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_cif_wall_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_support_block_id} ${core_cif_wall_block_id}
    ${tf_quad_block_id} ${cif_channel_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_4_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_4_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${tf_support_block_id} ${fuel_plate_4_block_id}
    ${tf_quad_block_id} ${fuel_plate_4_quad_block_id}
    ;
    ${core_block_id} ${fuel_plate_4_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_4_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${tf_support_block_id} ${fuel_plate_4_block_id}
    ${tf_quad_block_id} ${fuel_plate_4_quad_block_id}
    ;
    ${tf_support_block_id} ${fuel_plate_5_block_id}
    ${tf_quad_block_id}   ${fuel_plate_5_quad_block_id}
    ${sr1_inner_block_id} ${fuel_plate_5_quad_block_id}
    ${sr1_outer_block_id} ${fuel_plate_5_quad_block_id}
    ${sr2_inner_block_id} ${fuel_plate_5_quad_block_id}
    ${sr2_outer_block_id} ${fuel_plate_5_quad_block_id}
    ${ccr_inner_block_id} ${fuel_plate_5_quad_block_id}
    ${ccr_outer_block_id} ${fuel_plate_5_quad_block_id}
    ${fcr_inner_block_id} ${fuel_plate_5_quad_block_id}
    ${fcr_outer_block_id} ${fuel_plate_5_quad_block_id}
    ${core_block_id} ${fuel_plate_5_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_5_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${fuel_plate_6_block_id}
    ${tf_quad_block_id}   ${fuel_plate_6_quad_block_id}
    ${sr1_inner_block_id} ${fuel_plate_6_quad_block_id}
    ${sr1_outer_block_id} ${fuel_plate_6_quad_block_id}
    ${sr2_inner_block_id} ${fuel_plate_6_quad_block_id}
    ${sr2_outer_block_id} ${fuel_plate_6_quad_block_id}
    ${ccr_inner_block_id} ${fuel_plate_6_quad_block_id}
    ${ccr_outer_block_id} ${fuel_plate_6_quad_block_id}
    ${fcr_inner_block_id} ${fuel_plate_6_quad_block_id}
    ${fcr_outer_block_id} ${fuel_plate_6_quad_block_id}
    ${core_block_id} ${fuel_plate_6_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_6_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${fuel_plate_7_block_id}
    ${tf_quad_block_id}   ${fuel_plate_7_quad_block_id}
    ${sr1_inner_block_id} ${fuel_plate_7_quad_block_id}
    ${sr1_outer_block_id} ${fuel_plate_7_quad_block_id}
    ${sr2_inner_block_id} ${fuel_plate_7_quad_block_id}
    ${sr2_outer_block_id} ${fuel_plate_7_quad_block_id}
    ${ccr_inner_block_id} ${fuel_plate_7_quad_block_id}
    ${ccr_outer_block_id} ${fuel_plate_7_quad_block_id}
    ${fcr_inner_block_id} ${fuel_plate_7_quad_block_id}
    ${fcr_outer_block_id} ${fuel_plate_7_quad_block_id}
    ${core_block_id} ${fuel_plate_7_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_7_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${fuel_plate_8_block_id}
    ${tf_quad_block_id}   ${fuel_plate_8_quad_block_id}
    ${sr1_inner_block_id} ${fuel_plate_8_quad_block_id}
    ${sr1_outer_block_id} ${fuel_plate_8_quad_block_id}
    ${sr2_inner_block_id} ${fuel_plate_8_quad_block_id}
    ${sr2_outer_block_id} ${fuel_plate_8_quad_block_id}
    ${ccr_inner_block_id} ${fuel_plate_8_quad_block_id}
    ${ccr_outer_block_id} ${fuel_plate_8_quad_block_id}
    ${fcr_inner_block_id} ${fuel_plate_8_quad_block_id}
    ${fcr_outer_block_id} ${fuel_plate_8_quad_block_id}
    ${core_block_id} ${fuel_plate_8_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_8_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${fuel_plate_9_block_id}
    ${tf_quad_block_id}   ${fuel_plate_9_quad_block_id}
    ${sr1_inner_block_id} ${fuel_plate_9_quad_block_id}
    ${sr1_outer_block_id} ${fuel_plate_9_quad_block_id}
    ${sr2_inner_block_id} ${fuel_plate_9_quad_block_id}
    ${sr2_outer_block_id} ${fuel_plate_9_quad_block_id}
    ${ccr_inner_block_id} ${fuel_plate_9_quad_block_id}
    ${ccr_outer_block_id} ${fuel_plate_9_quad_block_id}
    ${fcr_inner_block_id} ${fuel_plate_9_quad_block_id}
    ${fcr_outer_block_id} ${fuel_plate_9_quad_block_id}
    ${core_block_id} ${fuel_plate_9_block_id}
    ${core_cif_wall_block_id} ${fuel_plate_9_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${rad_block_id}
    ${tf_quad_block_id}   ${rad_quad_block_id}
    ${sr1_inner_block_id} ${rad_quad_block_id}
    ${sr1_outer_block_id} ${rad_quad_block_id}
    ${sr2_inner_block_id} ${rad_quad_block_id}
    ${sr2_outer_block_id} ${rad_quad_block_id}
    ${ccr_inner_block_id} ${rad_quad_block_id}
    ${ccr_outer_block_id} ${rad_quad_block_id}
    ${fcr_inner_block_id} ${rad_quad_block_id}
    ${fcr_outer_block_id} ${rad_quad_block_id}
    ${core_block_id} ${rad_block_id}
    ${core_cif_wall_block_id} ${rad_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_ubp_wall_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${rad_block_id}
    ${tf_quad_block_id}   ${rad_quad_block_id}
    ${sr1_inner_block_id} ${rad_quad_block_id}
    ${sr1_outer_block_id} ${rad_quad_block_id}
    ${sr2_inner_block_id} ${rad_quad_block_id}
    ${sr2_outer_block_id} ${rad_quad_block_id}
    ${ccr_inner_block_id} ${rad_quad_block_id}
    ${ccr_outer_block_id} ${rad_quad_block_id}
    ${fcr_inner_block_id} ${rad_quad_block_id}
    ${fcr_outer_block_id} ${rad_quad_block_id}
    ${core_block_id} ${rad_block_id}
    ${core_cif_wall_block_id} ${rad_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${ig_block_id}
    ${tf_quad_block_id}   ${ig_quad_block_id}
    ${sr1_inner_block_id} ${ig_quad_block_id}
    ${sr1_outer_block_id} ${ig_quad_block_id}
    ${sr2_inner_block_id} ${ig_quad_block_id}
    ${sr2_outer_block_id} ${ig_quad_block_id}
    ${ccr_inner_block_id} ${ig_quad_block_id}
    ${ccr_outer_block_id} ${ig_quad_block_id}
    ${fcr_inner_block_id} ${ig_quad_block_id}
    ${fcr_outer_block_id} ${ig_quad_block_id}
    ${core_block_id} ${ig_block_id}
    ${core_cif_wall_block_id} ${ig_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ;
    ${tf_support_block_id} ${at_block_id}
    ${tf_quad_block_id}   ${at_quad_block_id}
    ${core_block_id} ${at_block_id}
    ${core_cif_wall_block_id} ${at_block_id}
    ${ig_block_id} ${at_block_id}
    ${ig_cif_wall_block_id} ${at_block_id}
    ${at_cif_wall_block_id} ${at_block_id}
    ${og_cif_wall_block_id} ${og_block_id}
    ${og_ubp_wall_block_id} ${og_block_id}
    ${og_ubp_channel_block_id} ${og_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${og_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${og_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${at_quad_block_id}
    ${sr1_outer_block_id} ${at_quad_block_id}
    ${sr2_inner_block_id} ${at_quad_block_id}
    ${sr2_outer_block_id} ${at_quad_block_id}
    ${ccr_inner_block_id} ${at_quad_block_id}
    ${ccr_outer_block_id} ${at_quad_block_id}
    ${fcr_inner_block_id} ${at_quad_block_id}
    ${fcr_outer_block_id} ${at_quad_block_id}
    ;
    ${tf_support_block_id} ${lead_block_id}
    ${tf_quad_block_id}   ${lead_quad_block_id}
    ${core_block_id} ${lead_block_id}
    ${core_cif_wall_block_id} ${lead_block_id}
    ${ig_block_id} ${lead_block_id}
    ${ig_cif_wall_block_id} ${lead_block_id}
    ${at_block_id} ${lead_block_id}
    ${at_cif_wall_block_id} ${lead_block_id}
    ${og_block_id} ${lead_block_id}
    ${og_cif_wall_block_id} ${lead_block_id}
    ${og_ubp_wall_block_id} ${lead_block_id}
    ${og_ubp_channel_block_id} ${lead_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${lead_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${lead_block_id}
    ${lead_block_id} ${lead_block_id}
    ${lead_cif_wall_block_id} ${lead_block_id}
    ${lead_ubp_wall_block_id} ${lead_block_id}
    ${lead_ubp_channel_block_id} ${lead_block_id}
    ${ag_block_id} ${ag_block_id}
    ${ag_cif_wall_block_id} ${ag_block_id}
    ${ag_ubp_wall_block_id} ${ag_block_id}
    ${ag_ubp_channel_block_id} ${ag_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${lead_quad_block_id}
    ${sr1_outer_block_id} ${lead_quad_block_id}
    ${sr2_inner_block_id} ${lead_quad_block_id}
    ${sr2_outer_block_id} ${lead_quad_block_id}
    ${ccr_inner_block_id} ${lead_quad_block_id}
    ${ccr_outer_block_id} ${lead_quad_block_id}
    ${fcr_inner_block_id} ${lead_quad_block_id}
    ${fcr_outer_block_id} ${lead_quad_block_id}
    ;
    ${tf_support_block_id} ${ig_block_id}
    ${tf_quad_block_id}   ${ig_quad_block_id}
    ${core_block_id} ${ig_block_id}
    ${core_cif_wall_block_id} ${ig_block_id}
    ${ig_block_id} ${ig_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${ig_block_id}
    ${og_block_id} ${ig_block_id}
    ${og_cif_wall_block_id} ${ig_block_id}
    ${og_ubp_wall_block_id} ${ig_block_id}
    ${og_ubp_channel_block_id} ${ig_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${ig_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${ig_block_id}
    ${lead_block_id} ${ig_block_id}
    ${lead_cif_wall_block_id} ${ig_block_id}
    ${lead_ubp_wall_block_id} ${ig_block_id}
    ${lead_ubp_channel_block_id} ${ig_block_id}
    ${ag_block_id} ${ig_block_id}
    ${ag_cif_wall_block_id} ${ig_block_id}
    ${ag_ubp_wall_block_id} ${ig_block_id}
    ${ag_ubp_channel_block_id} ${ig_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${ig_quad_block_id}
    ${sr1_outer_block_id} ${ig_quad_block_id}
    ${sr2_inner_block_id} ${ig_quad_block_id}
    ${sr2_outer_block_id} ${ig_quad_block_id}
    ${ccr_inner_block_id} ${ig_quad_block_id}
    ${ccr_outer_block_id} ${ig_quad_block_id}
    ${fcr_inner_block_id} ${ig_quad_block_id}
    ${fcr_outer_block_id} ${ig_quad_block_id}
    ;
    ${core_block_id} ${ig_block_id}
    ${core_cif_wall_block_id} ${ig_block_id}
    ${ig_block_id} ${ig_block_id}
    ${ig_cif_wall_block_id} ${ig_block_id}
    ${at_block_id} ${ig_block_id}
    ${at_cif_wall_block_id} ${ig_block_id}
    ${og_block_id} ${ig_block_id}
    ${og_cif_wall_block_id} ${ig_block_id}
    ${og_ubp_wall_block_id} ${ig_block_id}
    ${og_ubp_channel_block_id} ${ig_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${ig_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${ig_block_id}
    ${lead_block_id} ${ig_block_id}
    ${lead_cif_wall_block_id} ${ig_block_id}
    ${lead_ubp_wall_block_id} ${ig_block_id}
    ${lead_ubp_channel_block_id} ${ig_block_id}
    ${ag_block_id} ${ig_block_id}
    ${ag_cif_wall_block_id} ${ig_block_id}
    ${ag_ubp_wall_block_id} ${ig_block_id}
    ${ag_ubp_channel_block_id} ${ig_block_id}
    ${rt_cif_wall_block_id} ${rt_block_id}
    ${rt_ubp_wall_block_id} ${rt_block_id}
    ${rt_ubp_channel_block_id} ${rt_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${ig_quad_block_id}
    ${sr1_outer_block_id} ${ig_quad_block_id}
    ${sr2_inner_block_id} ${ig_quad_block_id}
    ${sr2_outer_block_id} ${ig_quad_block_id}
    ${ccr_inner_block_id} ${ig_quad_block_id}
    ${ccr_outer_block_id} ${ig_quad_block_id}
    ${fcr_inner_block_id} ${ig_quad_block_id}
    ${fcr_outer_block_id} ${ig_quad_block_id}
    ${tf_support_block_id} ${ig_block_id}
    ${tf_quad_block_id}   ${ig_quad_block_id}
    ;
    ${core_block_id} ${water_block_id}
    ${core_cif_wall_block_id} ${water_block_id}
    ${ig_block_id} ${water_block_id}
    ${ig_cif_wall_block_id} ${water_block_id}
    ${at_block_id} ${water_block_id}
    ${at_cif_wall_block_id} ${water_block_id}
    ${og_block_id} ${water_block_id}
    ${og_cif_wall_block_id} ${water_block_id}
    ${og_ubp_wall_block_id} ${water_block_id}
    ${og_ubp_channel_block_id} ${water_block_id}
    ${og_cif_wall_ubp_wall_block_id} ${water_block_id}
    ${og_cif_wall_ubp_channel_block_id} ${water_block_id}
    ${lead_block_id} ${water_block_id}
    ${lead_cif_wall_block_id} ${water_block_id}
    ${lead_ubp_wall_block_id} ${water_block_id}
    ${lead_ubp_channel_block_id} ${water_block_id}
    ${ag_block_id} ${water_block_id}
    ${ag_cif_wall_block_id} ${water_block_id}
    ${ag_ubp_wall_block_id} ${water_block_id}
    ${ag_ubp_channel_block_id} ${water_block_id}
    ${rt_block_id} ${water_block_id}
    ${rt_cif_wall_block_id} ${water_block_id}
    ${rt_ubp_wall_block_id} ${water_block_id}
    ${rt_ubp_channel_block_id} ${water_block_id}
    ${water_cif_wall_block_id} ${water_block_id}
    ${water_ubp_wall_block_id} ${water_block_id}
    ${water_ubp_channel_block_id} ${water_block_id}
    ${sr1_inner_block_id} ${water_quad_block_id}
    ${sr1_outer_block_id} ${water_quad_block_id}
    ${sr2_inner_block_id} ${water_quad_block_id}
    ${sr2_outer_block_id} ${water_quad_block_id}
    ${ccr_inner_block_id} ${water_quad_block_id}
    ${ccr_outer_block_id} ${water_quad_block_id}
    ${fcr_inner_block_id} ${water_quad_block_id}
    ${fcr_outer_block_id} ${water_quad_block_id}
    ${tf_support_block_id} ${water_block_id}
    ${tf_quad_block_id}   ${water_quad_block_id}
    '
  []
  [cif_bp_block_id_changes]
    type = RenameBlockGenerator
    input = extrude
    old_block = '
    ${core_cif_wall_block_id}
    ${ig_cif_wall_block_id}
    ${at_cif_wall_block_id}
    ${og_cif_wall_block_id}    ${og_ubp_wall_block_id}     ${og_ubp_channel_block_id}
    ${lead_cif_wall_block_id}  ${lead_ubp_wall_block_id}   ${lead_ubp_channel_block_id}
    ${ag_cif_wall_block_id}    ${ag_ubp_wall_block_id}     ${ag_ubp_channel_block_id}
    ${rt_cif_wall_block_id}    ${rt_ubp_wall_block_id}     ${rt_ubp_channel_block_id}
    ${water_cif_wall_block_id} ${water_ubp_wall_block_id}  ${water_ubp_channel_block_id}
    '
    new_block = '
    ${cif_wall_block_id}
    ${cif_wall_block_id}
    ${cif_wall_block_id}
    ${cif_wall_block_id}  ${bp_wall_block_id}     ${bp_channel_block_id}
    ${cif_wall_block_id}  ${bp_wall_block_id}     ${bp_channel_block_id}
    ${cif_wall_block_id}  ${bp_wall_block_id}     ${bp_channel_block_id}
    ${cif_wall_block_id}  ${bp_wall_block_id}     ${bp_channel_block_id}
    ${cif_wall_block_id}  ${bp_wall_block_id}     ${bp_channel_block_id}
    '
  []
  # Homogenize walls with channels
  [remove_walls]
    type = RenameBlockGenerator
    input = cif_bp_block_id_changes
    old_block = '${cif_wall_block_id} ${bp_wall_block_id}'
    new_block = '${cif_channel_block_id} ${bp_channel_block_id}'
  []
  # Map block names to block IDs
  [rename_blocks_final_3d]
    type = RenameBlockGenerator
    input = remove_walls
    old_block = '
    ${cif_channel_block_id} ${cif_channel_quad_block_id}
    ${bp_channel_block_id}
    ${fuel_plate_1_block_id} ${fuel_plate_2_block_id} ${fuel_plate_3_block_id} ${fuel_plate_4_block_id} ${fuel_plate_5_block_id} ${fuel_plate_6_block_id} ${fuel_plate_7_block_id} ${fuel_plate_8_block_id} ${fuel_plate_9_block_id} ${rad_block_id}
    ${fuel_plate_5_quad_block_id} ${fuel_plate_6_quad_block_id} ${fuel_plate_7_quad_block_id} ${fuel_plate_8_quad_block_id} ${fuel_plate_9_quad_block_id} ${rad_quad_block_id}
    ${ig_block_id}   ${ig_quad_block_id}
    ${at_block_id}   ${at_quad_block_id}
    ${og_block_id}
    ${lead_block_id}   ${lead_quad_block_id}
    ${ag_block_id}   ${ag_quad_block_id}
    ${rt_block_id}   ${rt_quad_block_id}
    ${water_block_id}   ${water_quad_block_id}
    ${sr1_inner_block_id}   ${sr1_outer_block_id}   ${sr2_inner_block_id}   ${sr2_outer_block_id}   ${ccr_inner_block_id}   ${ccr_outer_block_id}   ${fcr_inner_block_id}   ${fcr_outer_block_id}
    ${tf_block_id}  ${tf_quad_block_id} ${tf_support_block_id}
    '
    new_block = '
    ${cif_channel_block_name} ${cif_channel_quad_block_name}
    ${bp_channel_block_name}
    ${fuel_plate_1_block_name} ${fuel_plate_2_block_name} ${fuel_plate_3_block_name} ${fuel_plate_4_block_name} ${fuel_plate_5_block_name} ${fuel_plate_6_block_name} ${fuel_plate_7_block_name} ${fuel_plate_8_block_name} ${fuel_plate_9_block_name} ${rad_block_name}
    ${fuel_plate_5_quad_block_name} ${fuel_plate_6_quad_block_name} ${fuel_plate_7_quad_block_name} ${fuel_plate_8_quad_block_name} ${fuel_plate_9_quad_block_name} ${rad_quad_block_name}
    ${ig_block_name} ${ig_quad_block_name}
    ${at_block_name} ${at_quad_block_name}
    ${og_block_name}
    ${lead_block_name} ${lead_quad_block_name}
    ${ag_block_name}  ${ag_quad_block_name}
    ${rt_block_name} ${rt_quad_block_name}
    ${water_block_name} ${water_quad_block_name}
    ${sr1_inner_block_name} ${sr1_outer_block_name} ${sr2_inner_block_name} ${sr2_outer_block_name} ${ccr_inner_block_name} ${ccr_outer_block_name} ${fcr_inner_block_name} ${fcr_outer_block_name}
    ${tf_block_name} ${tf_quad_block_name} ${tf_support_block_name}
    '
  []
  final_generator = rename_blocks_final_3d
  [diag]
    type = MeshDiagnosticsGenerator
    input = rename_blocks_final_3d
    examine_element_overlap = WARNING
    examine_element_types = WARNING
    examine_element_volumes = WARNING
    examine_non_conformality = WARNING
    examine_nonplanar_sides = INFO
    examine_sidesets_orientation = WARNING
    search_for_adaptivity_nonconformality = WARNING
    check_local_jacobian = WARNING
  []
[]

[Problem]
  kernel_coverage_check = false
  solve = false
[]

[Executioner]
  type = Steady
[]

[GlobalParams]
  execute_on = 'final'
[]

# [Postprocessors] doesn't work, 'the following blocks (ids) do not exist on the mesh: Fuel (65535) and Monolith (65535)'
# [Fuel]
#   type = VolumePostprocessor
#   block = 'Fuel'
# []
#   [Monolith]
#     type = VolumePostprocessor
#     block = 'Monolith'
#   []
# []

[AuxVariables]
  [unused]
  []
[]

[Reporters]
  [mesh_info]
    type = MeshInfo
  []
[]

[Outputs]
  file_base = '3D_AGN_201'
  exodus = true
  csv = true
  json = true
[]
