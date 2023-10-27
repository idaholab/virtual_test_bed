# input adapted from griffin/tests/moose_modules/reactor/empire_2d_coarse.i

[Mesh]
  [F1_1]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 8
    background_block_ids = '100 101'
    background_block_names = 'F1 F1_QUAD'
    duct_sizes ='14.8956'
    duct_sizes_style = apothem
    duct_block_ids = '101'
    duct_block_names = 'F1_QUAD'
    duct_intervals = 1
    polygon_size = 16.1765
    polygon_size_style = 'apothem'
    preserve_volumes = on
    quad_center_elements = false
  []
  [F1_2]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = 16.1765
    polygon_size_style = 'apothem'
    background_intervals = 1
    background_block_ids = 101
    background_block_names = 'F1_QUAD'
    ring_radii = '13.8'
    ring_intervals = '5'
    ring_block_ids = '100 101'
    ring_block_names = 'F1 F1_QUAD'
    preserve_volumes = off
    quad_center_elements = false
  []
  [Core_CM]
    type = PatternedHexMeshGenerator
    inputs = 'F1_1 F1_2'
  # Pattern ID 0  1
    pattern_boundary = none
    pattern =
              '0 0 0 0 0;
              0 0 1 1 0 0;
             0 1 0 0 0 1 0;
            0 1 0 0 0 0 1 0;
           0 0 0 0 0 0 0 0 0;
            0 1 0 0 0 0 1 0;
             0 1 0 0 0 1 0;
              0 0 1 1 0 0;
               0 0 0 0 0'
  []
  [half_CM]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '0 -1 0'
    input = Core_CM
    new_boundary = bottom
  []
  [twelfth_CM]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '${fparse -cos(pi/3)} ${fparse sin(pi/3)} 0'
    input = half_CM
    new_boundary = topleft
  []
  [trim_CM]
    type = PlaneDeletionGenerator
    point = '84.0556 48.5295 0'
    normal = '84.0556 48.5295 0'
    input = twelfth_CM
    new_boundary = right
  []
  [scale_CM]
    type = TransformGenerator
    input = trim_CM
    transform = SCALE
    vector_value = '0.01 0.01 0.01'
  []
[]
