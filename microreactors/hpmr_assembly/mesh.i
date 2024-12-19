# Mesh input file for a heat-pipe-cooled microreactor assembly
# This input must be run with BISON
#
# Execute as:
#   <app_name>-opt -i mesh.i --mesh-only mesh.e

asm_apothem = ${fparse 17.368 / 2}
cell_apothem = ${fparse 2.782 / 2}
num_sectors_per_side = '2 2 2 2 2 2'

asm_pitch = ${fparse asm_apothem * 2 / sqrt(3)}

R_fuel = 0.95
R_hp_hole = 1.06

n_hp = 7
length_hp = 1.8

[Mesh]
 [fuel_cell]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    flat_side_up = false
    num_sectors_per_side = ${num_sectors_per_side}
    polygon_size = ${cell_apothem}
    ring_radii = '${R_fuel}'
    ring_intervals = '1'
    ring_block_ids = '1'
    ring_block_names = 'fuel'
    quad_center_elements = true
    background_intervals = '1'
    background_block_ids = '2'
    background_block_names = 'monolith'
    preserve_volumes = on
  []
  [heatpipe_cell]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    flat_side_up = false
    num_sectors_per_side = ${num_sectors_per_side}
    polygon_size = ${cell_apothem}
    ring_radii = '${R_hp_hole}'
    ring_intervals = '1'
    ring_block_ids = '3'
    ring_block_names = 'heatpipe'
    quad_center_elements = true
    background_intervals = '1'
    background_block_ids = '2'
    background_block_names = 'monolith'
    preserve_volumes = on
  []
  [dummy_cell]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    flat_side_up = false
    num_sectors_per_side = ${num_sectors_per_side}
    polygon_size = ${cell_apothem}
    background_block_ids = '4'
  []

  [asm_interior]
    type = PatternedHexMeshGenerator
    inputs = 'dummy_cell fuel_cell heatpipe_cell'
    rotate_angle = 0
    pattern_boundary = none
    pattern = '   0 1 1 0;
                 1 1 2 1 1;
                1 2 1 1 2 1;
               0 1 1 2 1 1 0;
                1 2 1 1 2 1;
                 1 1 2 1 1;
                  0 1 1 0'
    id_name = 'pin_id'
  []

  # delete dummy blocks
  [delete_dummy_blocks]
    type = BlockDeletionGenerator
    input = asm_interior
    block = '4'
  []

  # create hex assembly boundary line
  [periphery_boundary]
    type = PolyLineMeshGenerator
    points = '${fparse asm_pitch * cos(pi / 6)} ${fparse asm_pitch * sin(pi / 6)} 0.0
              ${fparse asm_pitch * cos(pi / 6 + pi / 3)} ${fparse asm_pitch * sin(pi / 6 + pi / 3)} 0.0
              ${fparse asm_pitch * cos(pi / 6 + pi * 2 / 3)} ${fparse asm_pitch * sin(pi / 6 + pi * 2 / 3)} 0.0
              ${fparse asm_pitch * cos(pi / 6 + pi * 3 / 3)} ${fparse asm_pitch * sin(pi / 6 + pi * 3 / 3)} 0.0
              ${fparse asm_pitch * cos(pi / 6 + pi * 4 / 3)} ${fparse asm_pitch * sin(pi / 6 + pi * 4 / 3)} 0.0
              ${fparse asm_pitch * cos(pi / 6 + pi * 5 / 3)} ${fparse asm_pitch * sin(pi / 6 + pi * 5 / 3)} 0.0'
    loop = true
  []
  # add background meshes of hex assembly and merge with hex cells
  [hex_assem]
    type = XYDelaunayGenerator
    boundary = 'periphery_boundary'
    holes = 'delete_dummy_blocks'
    stitch_holes = 'true'
    refine_holes = 'false'
    add_nodes_per_boundary_segment = 15
    refine_boundary = false
    desired_area = 0.5
    smooth_triangulation = true
  []

  # Before extrusion:
  #   0: periphery (same as monolith, but triangular instead of quad elements)
  #   1: fuel
  #   2: monolith
  #   3: heatpipe
  #
  # After extrusion:
  #   1: brefl
  #   2: brefl_tri
  #   3: trefl
  #   4: trefl_tri
  #   5: monolith
  #   6: monolith_tri
  #   7: fuel
  #   8: heatpipe
  [extrude]
    type = NonuniformMeshExtruderGenerator
    input = hex_assem
    extrusion_vector = '0 0 1'
    layer_thickness =    '20.0 160.0 20.0'
    layer_subdivisions = '   4    32    4'
    existing_subdomains = '0 1 2 3'
    layers = '0 1 2'
    new_ids = '2 1 1 1
               6 7 5 8
               4 3 3 8'
    bottom_sideset = 'bottom'
    top_sideset = 'top'
  []

  [rename_blocks]
    type = RenameBlockGenerator
    input = extrude
    old_block = '1     2         3     4         5        6            7    8'
    new_block = 'brefl brefl_tri trefl trefl_tri monolith monolith_tri fuel heatpipe'
  []
  [hp_holes_sideset]
    type = SideSetsBetweenSubdomainsGenerator
    input = rename_blocks
    new_boundary = 'hp_holes'
    primary_block = 'monolith trefl'
    paired_block = 'heatpipe'
  []
  [delete_heatpipe_block]
    type = BlockDeletionGenerator
    input = hp_holes_sideset
    block = 'heatpipe'
  []

  [rotate]
    type = TransformGenerator
    input = delete_heatpipe_block
    transform = ROTATE
    vector_value = '30 0 0'
  []
  [scale_cm_to_m]
    type = TransformGenerator
    input = rotate
    transform = SCALE
    vector_value = '0.01 0.01 0.01'
  []
[]

[Postprocessors]
  [hp_holes_area]
    type = AreaPostprocessor
    boundary = 'hp_holes'
    execute_on = 'INITIAL'
  []
  [P_hp_hole]
    type = ParsedPostprocessor
    pp_names = 'hp_holes_area'
    function = 'hp_holes_area / ${fparse n_hp * length_hp}'
    execute_on = 'INITIAL'
  []
[]

[Problem]
  solve = false
[]

[Executioner]
  type = Steady
[]

[Outputs]
  file_base = 'mesh'
  csv = true
  exodus = true
[]
