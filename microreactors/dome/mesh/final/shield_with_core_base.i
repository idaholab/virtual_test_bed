# Mesh for final DOME shield design, plus fictional core.
# Units: [m]
#
# For questions, contact:
# - Joshua Hansel: joshua.hansel@inl.gov
# - Chaitee Godbole: chaiteemilind.godbole@inl.gov
#
# The following terminology is used to describe mesh:
# "front":  -y
# "back":   +y
# "left":   -x
# "right":  +x
# "bottom": -z
# "top":    +z
#
# The origin (0,0,0) is taken as the bottom, left, front corner of the system.
#
# Blocks:
# - airgap_watertank: gap between tank wall and (side walls + back walls)
# - airgap_door1: gap between door_1 and door_2
# - airgap_door2: gap between door_2 and system behind door_2
# - cavity: cavity between core and shield
# - ceiling_1: bottom interior ceiling
# - ceiling_2: top interior ceiling
# - ceiling_3: right, top ceiling
# - ceiling_4: back, top ceiling
# - ceiling_5: left, top ceiling
# - door_1: front part of door
# - door_2: back part of door
# - floor_1: door floor
# - floor_2: side + back + bottom interior floor
# - floor_3: top interior floor
# - ground: ground (beneath floor)
# - tankwall: tank walls
# - wall_1: left wall
# - wall_2: back wall
# - wall_3: right wall
# - water_tank: water tank interior
#
# Boundaries:
# - system_xmin: left surface of system
# - system_xmax: right surface of system
# - system_ymin: front surface of system
# - system_ymax: back surface of system
# - system_zmin: bottom surface of system
# - system_zmax: top surface of system
#
# TODOS:
# - consider combining some blocks (like side and back pieces with same material)
# - clean up sideset creation - used named variables
# - delete extraneous sidesets/nodesets

[Mesh]
  # shift such that bottom of floor (top of ground) is at z=0
  [ground_shift_mg]
    type = TransformGenerator
    input = cartesian_mg # defined by file which includes this one
    transform = TRANSLATE
    vector_value = '0 0 -${dz_ground}'
  []
  [renumber_cartesian_mg]
    type = RenameBlockGenerator
    input = ground_shift_mg
    old_block = 0
    new_block = 10
  []
  [renumber_boundaries_mg]
    type = RenameBoundaryGenerator
    input = renumber_cartesian_mg
    new_boundary = '101 102 103 104 105 100'
    old_boundary = '1 2 3 4 5 0'
  []
  [rename_boundaries_mg]
    type = RenameBoundaryGenerator
    input = renumber_boundaries_mg
    old_boundary = 'left right front back top bottom'
    new_boundary = 'system_xmin system_xmax system_zmax system_zmin system_ymax system_ymin'
  []

  # define blocks
  [ground_mg]
    type = ParsedSubdomainMeshGenerator
    input = rename_boundaries_mg
    combinatorial_geometry = 'z < ${zmax_ground}'
    block_id = 300
    block_name = ground
  []
  [airgap_watertank_mg]
    type = ParsedSubdomainMeshGenerator
    input = ground_mg
    combinatorial_geometry = 'x > ${t_wall} & x < ${fparse dx_system-t_wall} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall} & z > ${fparse dz_floor2} & z < ${fparse dz_floor2+dz_cavity}'
    block_id = 211
    block_name = 'airgap_watertank'
  []
  [airgap_door2_mg]
    type = ParsedSubdomainMeshGenerator
    input = airgap_watertank_mg
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${fparse ymax_airgap2-dy_airgap2} & y < ${ymax_airgap2} & z > ${dz_floor1} & z < ${dz_system}'
    block_id = 212
    block_name = 'airgap_door2'
  []
  [door_2]
    type = ParsedSubdomainMeshGenerator
    input = airgap_door2_mg
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${fparse dy_door1+dy_airgap1} & y < ${fparse dy_door1+dy_airgap1+dy_door2} & z > ${dz_floor1} & z < ${dz_system}'
    block_id = 213
    block_name = 'door_2'
  []
  [airgap_door1_mg]
    type = ParsedSubdomainMeshGenerator
    input = door_2
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${dy_door1} & y < ${fparse dy_door1+dy_airgap1 } & z > ${dz_floor1} & z < ${dz_system}'
    block_id = 214
    block_name = 'airgap_door1'
  []
  [door_1]
    type = ParsedSubdomainMeshGenerator
    input = airgap_door1_mg
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > 0 & y < ${fparse dy_door1 } & z > ${dz_floor1} & z < ${dz_system}'
    block_id = 215
    block_name = 'door_1'
  []
  [floor_1]
    type = ParsedSubdomainMeshGenerator
    input = door_1
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > 0 & y < ${dy_floor1} & z > 0 & z < ${dz_floor1}'
    block_id = 216
    block_name = 'floor_1'
  []
  [floor_2]
    type = ParsedSubdomainMeshGenerator
    input = floor_1
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${fparse dy_floor1} & y < ${dy_system} & z > 0 & z < ${zmax_floor2}'
    block_id = 217
    block_name = 'floor_2'
  []
  [floor_3]
    type = ParsedSubdomainMeshGenerator
    input = floor_2
    combinatorial_geometry = 'x > ${xmin_floor3} & x < ${fparse xmin_floor3+dx_floor3} & y > ${ymax_airgap2} & y < ${fparse ymax_airgap2+dy_floor3} & z > ${fparse dz_floor2-dz_floor3} & z < ${zmax_floor3}'
    block_id = 218
    block_name = 'floor_3'
  []
  [wall_1]
    type = ParsedSubdomainMeshGenerator
    input = floor_3
    combinatorial_geometry = 'x > 0 & x < ${t_wall } & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall} & z > ${dz_floor2} & z < ${fparse dz_floor2+dz_wall}'
    block_id = 219
    block_name = wall_1
  []
  [wall_2]
    type = ParsedSubdomainMeshGenerator
    input = wall_1
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${fparse dy_system-t_wall} & y < ${dy_system} & z > ${dz_floor2} & z < ${fparse dz_floor2+dz_wall}'
    block_id = 220
    block_name = wall_2
  []
  [wall_3]
    type = ParsedSubdomainMeshGenerator
    input = wall_2
    combinatorial_geometry = 'x > ${fparse xmin_cavity+t_water+dx_cavity} & x < ${dx_system} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall} & z > ${dz_floor2} & z < ${fparse dz_floor2+dz_wall}'
    block_id = 221
    block_name = wall_3
  []
  [ceiling_3]
    type = ParsedSubdomainMeshGenerator
    input = wall_3
    combinatorial_geometry = 'x > ${fparse xmin_cavity+t_water+dx_cavity} & x < ${dx_system} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall } & z > ${fparse dz_floor2+dz_wall} & z < ${dz_system}'
    block_id = 222
    block_name = 'ceiling_3'
  []
  [ceiling_4]
    type = ParsedSubdomainMeshGenerator
    input = ceiling_3
    combinatorial_geometry = 'x > 0 & x < ${dx_system} & y > ${fparse dy_system-t_wall} & y < ${dy_system} & z > ${fparse dz_floor2+dz_wall} & z < ${dz_system}'
    block_id = 223
    block_name = 'ceiling_4'
  []
  [ceiling_5]
    type = ParsedSubdomainMeshGenerator
    input = ceiling_4
    combinatorial_geometry = 'x > 0 & x < ${t_wall} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall } & z > ${fparse dz_floor2+dz_wall} & z < ${dz_system}'
    block_id = 224
    block_name = 'ceiling_5'
  []
  [ceiling_2]
    type = ParsedSubdomainMeshGenerator
    input = ceiling_5
    combinatorial_geometry = 'x > ${t_wall} & x < ${fparse  xmin_cavity+dx_cavity+t_water} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall } & z > ${fparse dz_system-dz_ceiling2} & z < ${dz_system}'
    block_id = 225
    block_name = 'ceiling_2'
  []
  [ceiling_1]
    type = ParsedSubdomainMeshGenerator
    input = ceiling_2
    combinatorial_geometry = 'x > ${t_wall} & x < ${fparse  xmin_cavity+dx_cavity+t_water} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall } & z > ${zmin_ceiling1} & z < ${fparse dz_system-dz_ceiling2}'
    block_id = 226
    block_name = 'ceiling_1'
  []
  [tankwall_part1_mg]
    type = ParsedSubdomainMeshGenerator
    input = ceiling_1
    combinatorial_geometry = 'x > ${fparse t_wall+t_airgap_water} & x < ${fparse  dx_system-t_wall-t_airgap_water} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall-t_airgap_water } & z > ${fparse dz_floor2} & z < ${fparse dz_floor2+dz_cavity}'
    block_id = 227
    block_name = 'tankwall'
  []
  [water_tank]
    type = ParsedSubdomainMeshGenerator
    input = tankwall_part1_mg
    combinatorial_geometry = 'x > ${fparse t_wall + t_airgap_water + t_tankwall} & x < ${fparse  dx_system-t_wall-t_airgap_water-t_tankwall} & y > ${fparse ymax_airgap2+t_tankwall} & y < ${fparse dy_system-t_wall-t_airgap_water-t_tankwall} & z > ${fparse dz_floor2+t_tankwall} & z < ${fparse dz_floor2+dz_cavity-t_tankwall}'
    block_id = 228
    block_name = 'water_tank'
  []
  [tankwall_part2_mg]
    type = ParsedSubdomainMeshGenerator
    input = water_tank
    combinatorial_geometry = 'x > ${fparse xmin_cavity-t_tankwall} & x < ${fparse dx_system-t_wall-t_water+t_tankwall} & y > ${ymax_airgap2} & y < ${fparse dy_system-t_wall-t_water+t_tankwall} & z > ${fparse dz_floor2} & z < ${fparse dz_floor2+dz_cavity}'
    block_id = 227
    block_name = 'tankwall'
  []
  [cavity_mg]
    type = ParsedSubdomainMeshGenerator
    input = tankwall_part2_mg
    combinatorial_geometry = 'x > ${xmin_cavity} & x < ${fparse xmin_cavity+dx_cavity} & y > ${ymin_cavity} & y < ${ymax_cavity} & z > ${fparse dz_floor2} & z < ${fparse dz_floor2+dz_cavity}'
    block_id = 230
    block_name = cavity
  []
[]