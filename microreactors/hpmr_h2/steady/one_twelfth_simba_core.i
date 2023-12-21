# 1/12th core mesh generation input modified and adapted from a full-core mesh by Shikhar Khumar

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
    pattern = '1 0 1 0 1 0 1 0 1;
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
    duct_sizes = '16.0765'
    duct_sizes_style = 'apothem'
    duct_block_ids = '22'
    duct_block_names = 'AIR'
    duct_intervals = 1
    hexagon_size = '16.1765'
    pattern = '0 0 0 0 0 0 0 0 0;
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
    pattern = '0 0 0 0 0 0 0 0 0;
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
    inputs = 'Assembly_1 Assembly_1 Assembly_1 Assembly_1 Assembly_1 Assembly_1'
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
  []
  [cd_1]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 345
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [cd_2]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 285
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [cd_3]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 225
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [cd_4]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 165
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [cd_5]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 105
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [cd_6]
    type = AzimuthalBlockSplitGenerator
    input = cd_0
    start_angle = 45
    angle_range = 90
    old_blocks = 13
    new_block_ids = 12
    new_block_names = 'CR'
    preserve_volumes = true
  []
  [Core]
    type = PatternedHexMeshGenerator
    inputs = 'Assembly_1 Assembly_1 Assembly_1 AIRHOLE REFL cd_1 cd_2 cd_3 cd_4 cd_5 cd_6'
    # Pattern ID   0            1          2         3     4    5    6    7    8    9   10
    generate_core_metadata = true
    pattern_boundary = none
    pattern = '4 4  4  4 4;
              4 4 10 10 4 4;
             4 9 1 2 1 5 4;
            4 9 2 0 0 2 5 4;
           4 4 1 0 3 0 1 4 4;
            4 8 2 0 0 2 6 4;
             4 8 1 2 1 6 4;
              4 4 7 7 4 4;
               4 4 4 4 4'
  []
  [deleter_1]
    type = PlaneDeletionGenerator
    point = '0 97.059 0'
    normal = '0 1 0'
    input = Core
    new_boundary = side
  []
  [deleter_2]
    type = PlaneDeletionGenerator
    point = '0 -97.059 0'
    normal = '0 -1 0'
    input = deleter_1
    new_boundary = side
  []
  [deleter_3]
    type = PlaneDeletionGenerator
    point = '84.0556 48.5295 0'
    normal = '84.0556 48.5295 0'
    input = deleter_2
    new_boundary = side
  []
  [deleter_4]
    type = PlaneDeletionGenerator
    point = '-84.0556 48.5295 0'
    normal = '-84.0556 48.5295 0'
    input = deleter_3
    new_boundary = side
  []
  [deleter_5]
    type = PlaneDeletionGenerator
    point = '84.0556 -48.5295 0'
    normal = '84.0556 -48.5295 0'
    input = deleter_4
    new_boundary = side
  []
  [main]
    type = PlaneDeletionGenerator
    point = '-84.0556 -48.5295 0'
    normal = '-84.0556 -48.5295 0'
    input = deleter_5
    new_boundary = side
  []

  # Cut to a 1/12th geometry
  [subdomains_tri]
    type = ParsedSubdomainMeshGenerator
    input = main
    combinatorial_geometry = 'y < 0' # & x < 0.9 & y > 0.1 & y < 0.9'
    excluded_subdomain_ids = '2 4 5 7 8 11 12 13 15 21 22'
    block_id = 100
  []
  [subdomains_quad]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_tri
    combinatorial_geometry = 'y < 0'
    excluded_subdomain_ids = '1 3 6 10 14 20 100'
    block_id = 101
  []
  [subdomains_tri2]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_quad
    combinatorial_geometry = 'y > x / sqrt(3)'
    excluded_subdomain_ids = '2 4 5 7 8 11 12 13 15 21 22 101'
    block_id = 200
  []
  [subdomains_quad2]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_tri2
    combinatorial_geometry = 'y > x / sqrt(3)'
    excluded_subdomain_ids = '1 3 6 10 14 20 100 100 200'
    block_id = 201
  []

  [deleter]
    type = BlockDeletionGenerator
    input = subdomains_quad2
    block = '100 101 200 201'
  []

  [add_outside_sidesets]
    type = SideSetsFromNormalsGenerator
    input = deleter
    new_boundary = 'bottom right topleft'
    normals = '0 -1 0
               ${fparse 0.5 * sqrt(3)} 0.5 0
               -0.5 ${fparse 0.5 * sqrt(3)} 0'
  []

  [scale] # scale to meters
    type = TransformGenerator
    input = add_outside_sidesets
    transform = scale
    vector_value = '0.01 0.01 0.01'
  []

  [extruder]
    type = NonuniformMeshExtruderGenerator
    input = scale
    extrusion_vector = '0 0 1'
    layer_thickness = '0.2 1.6 0.2'
    layer_subdivisions = '2 16 2'
    bottom_sideset = back
    top_sideset = front

    existing_subdomains = '1 2 3 4 5 6 7 8'
    layers = '0 2'
    new_ids = '18 19 18 19 19 18 19 19
               16 17 16 17 17  6  7 17' # axial reflector replaces HP only at the bottom
  []
[]
