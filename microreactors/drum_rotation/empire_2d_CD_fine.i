r = ${fparse 16.1765 / 100} # Apothem (set by generator)
d = ${fparse 4 / sqrt(3) * r} # Long diagonal
x_center = ${fparse 9 / 4 * d}
y_center = ${fparse r}

[Mesh]
  [FUEL_pin]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '8'
    background_block_names = 'MONOLITH'
    polygon_size = 1.075
    polygon_size_style = 'apothem'
    ring_radii = '1.0'
    ring_intervals = '3'
    ring_block_ids = '1 2'
    ring_block_names = 'FUEL FUEL_QUAD'
    preserve_volumes = on
    quad_center_elements = false
  []
  [MOD_pin]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '8'
    background_block_names = 'MONOLITH'
    polygon_size = 1.075
    polygon_size_style = 'apothem'
    ring_radii = '0.975 1'
    ring_intervals = '3 1'
    ring_block_ids = '3 4 5'
    ring_block_names = 'MOD MOD_QUAD MGAP'
    preserve_volumes = on
    quad_center_elements = false
  []
  [HPIPE_pin]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '8'
    background_block_names = 'MONOLITH'
    polygon_size = 1.075
    polygon_size_style = 'apothem'
    ring_radii = '1.0'
    ring_intervals = '3'
    ring_block_ids = '6 7'
    ring_block_names = 'HPIPE HPIPE_QUAD'
    preserve_volumes = on
    quad_center_elements = false
  []
  [AIRHOLE_CELL]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 3
    background_block_ids = '20 21'
    background_block_names = 'AIRHOLE AIRHOLE_QUAD'
    polygon_size = 1.075
    polygon_size_style = 'apothem'
    preserve_volumes = on
    quad_center_elements = false
  []
  [REFL_CELL]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 2
    background_block_ids = '14 15'
    background_block_names = 'REFL REFL_QUAD'
    polygon_size = 1.075
    polygon_size_style = 'apothem'
    preserve_volumes = on
    quad_center_elements = false
  []
  [Assembly_1]
    type = PatternedHexMeshGenerator
    inputs = 'MOD_pin HPIPE_pin FUEL_pin'
    # Pattern ID  0        1        2
    background_intervals = 1
    background_block_id = '8'
    background_block_name = 'MONOLITH'
    duct_sizes = '16.0765'
    duct_sizes_style = 'apothem'
    duct_block_ids = '22'
    duct_block_names = 'AIR'
    duct_intervals = 1
    hexagon_size = '16.1765'
    pattern =
              '1 0 1 0 1 0 1 0 1;
              0 2 2 2 2 2 2 2 2 0;
             1 2 1 0 1 0 1 0 1 2 1;
            0 2 0 2 2 2 2 2 2 0 2 0;
           1 2 1 2 1 0 1 0 1 2 1 2 1;
          0 2 0 2 0 2 2 2 2 0 2 0 2 0;
         1 2 1 2 1 2 1 0 1 2 1 2 1 2 1;
        0 2 0 2 0 2 0 2 2 0 2 0 2 0 2 0;
       1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1;
        0 2 0 2 0 2 0 2 2 0 2 0 2 0 2 0;
         1 2 1 2 1 2 1 0 1 2 1 2 1 2 1;
          0 2 0 2 0 2 2 2 2 0 2 0 2 0;
           1 2 1 2 1 0 1 0 1 2 1 2 1;
            0 2 0 2 2 2 2 2 2 0 2 0;
             1 2 1 0 1 0 1 0 1 2 1;
              0 2 2 2 2 2 2 2 2 0;
               1 0 1 0 1 0 1 0 1'
  []
  [AIRHOLE]
    type = PatternedHexMeshGenerator
    inputs = 'AIRHOLE_CELL'
  # Pattern ID       0
    background_intervals = 1
    background_block_id = '21'
    background_block_name = 'AIRHOLE_QUAD'
    duct_sizes ='16.0765'
    duct_sizes_style = 'apothem'
    duct_block_ids = '22'
    duct_block_names = 'AIR'
    duct_intervals = 1
    hexagon_size = '16.1765'
    pattern =
              '0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 0'
  []
  [REFL]
    type = PatternedHexMeshGenerator
    inputs = 'REFL_CELL'
  # Pattern ID    0
    background_intervals = 1
    background_block_id = '15'
    background_block_name = 'REFL_QUAD'
    duct_sizes = '16.0765'
    duct_sizes_style = 'apothem'
    duct_block_ids = '22'
    duct_block_names = 'AIR'
    duct_intervals = 1
    hexagon_size = '16.1765'
    pattern =
              '0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 0'
  []
  [cd_0]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Assembly_1 Assembly_1 Assembly_1 Assembly_1 Assembly_1 Assembly_1'
    sides_to_adapt = '0 1 2 3 4 5'
    num_sectors_per_side = '8 8 8 8 8 8'
    hexagon_size = 16.1765
    background_intervals = 3
    background_block_ids = 11
    background_block_names = 'CRREFL_QUAD'
    ring_radii = '13.8 14.8'
    ring_intervals = '5 3'
    ring_block_ids = '10 11 13'
    ring_block_names = 'CRREFL CRREFL_QUAD CRREFL_DYNAMIC'
    preserve_volumes = true
    is_control_drum = true
    # quad_center_elements = true
    # center_quad_factor = 0.1
  []
  [Core]
    type = PatternedHexMeshGenerator
    inputs = 'Assembly_1 Assembly_1 Assembly_1 AIRHOLE REFL cd_0'
  # Pattern ID   0            1          2         3     4    5
    generate_core_metadata = true
    pattern_boundary = none
    pattern =
              '4 4 4 4 4;
              4 4 5 5 4 4;
             4 5 1 2 1 5 4;
            4 5 2 0 0 2 5 4;
           4 4 1 0 3 0 1 4 4;
            4 5 2 0 0 2 5 4;
             4 5 1 2 1 5 4;
              4 4 5 5 4 4;
               4 4 4 4 4'
  []

  [half]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '0 -1 0'
    input = Core
  []
  [twelfth]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '${fparse -cos(pi/3)} ${fparse sin(pi/3)} 0'
    input = half
  []
  [trim]
    type = PlaneDeletionGenerator
    point = '84.0556 48.5295 0'
    normal = '84.0556 48.5295 0'
    input = twelfth
  []
  [scale]
    type = TransformGenerator
    input = trim
    transform = SCALE
    vector_value = '0.01 0.01 0.01'
  []

  [drum]
    type = FileMeshGenerator
    file = drum_in.e
  []
  [drum_insert]
    type = XYDelaunayGenerator
    boundary = cd_0
    holes = 'drum'
    stitch_holes = true
    refine_holes = false
  []
  [drum_scale]
    type = TransformGenerator
    input = drum_insert
    transform = SCALE
    vector_value = '0.01 0.01 0.01'
  []
  [drum_rotate]
    type = TransformGenerator
    input = drum_scale
    transform = ROTATE
    vector_value = '0 0 30'
  []
  [drum_move]
    type = TransformGenerator
    input = drum_rotate
    transform = TRANSLATE
    vector_value = '${x_center} ${y_center} 0'
  []
  [drum_blocks]
    type = RenameBlockGenerator
    input = drum_move
    old_block = '0'
    new_block = '10'
  []
  [drum_boundary]
    type = SideSetsAroundSubdomainGenerator
    input = drum_blocks
    block = 10
    new_boundary = 'drum_outer'
  []
  [drum_remove]
    type = BlockDeletionGenerator
    input = scale
    block = 'CRREFL CRREFL_QUAD CRREFL_DYNAMIC'
    new_boundary = 'drum_inner'
  []
  [stitch]
    type = StitchedMeshGenerator
    inputs = 'drum_boundary drum_remove'
    stitch_boundaries_pairs = 'drum_outer drum_inner'
    clear_stitched_boundary_ids = false
  []
  [bottom_boundary]
    type = SideSetsFromNormalsGenerator
    input = stitch
    normals = '0 -1 0'
    new_boundary = 'bottom'
  []
  [topleft_boundary]
    type = SideSetsFromNormalsGenerator
    input = bottom_boundary
    normals = '${fparse -cos(pi/3)} ${fparse sin(pi/3)} 0'
    new_boundary = 'topleft'
  []
  [right_boundary]
    type = SideSetsFromNormalsGenerator
    input = topleft_boundary
    normals = '84.0556 48.5295 0'
    new_boundary = 'right'
  []
[]
