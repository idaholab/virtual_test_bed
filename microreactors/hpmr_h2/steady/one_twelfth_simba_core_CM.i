# 1/12th core coarse mesh generation input modified and adapted from a full-core mesh by Shikhar Khumar

[Mesh]
  [F1_1]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '100'
    background_block_names = 'F1'
    polygon_size = 16.1765
    polygon_size_style = 'apothem'
    preserve_volumes = on
    quad_center_elements = false
  []
  [F1_2]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 9
    background_block_ids = '100 101'
    background_block_names = 'F1 F1_QUAD'
    polygon_size = 16.1765
    polygon_size_style = 'apothem'
    preserve_volumes = on
    quad_center_elements = false
  []
  [Core_CM]
    type = PatternedHexMeshGenerator
    inputs = 'F1_1 F1_2'
    # Pattern ID  0   1
    pattern_boundary = none
    pattern = '0 0 0 0 0;
              0 0 0 0 0 0;
             0 0 1 1 1 0 0;
            0 0 1 1 1 1 0 0;
           0 0 1 1 0 1 1 0 0;
            0 0 1 1 1 1 0 0;
             0 0 1 1 1 0 0;
              0 0 0 0 0 0;
               0 0 0 0 0'
  []
  [deleter_1_CM]
    type = PlaneDeletionGenerator
    point = '0 97.059 0'
    normal = '0 1 0'
    input = Core_CM
    new_boundary = side
  []
  [deleter_2_CM]
    type = PlaneDeletionGenerator
    point = '0 -97.059 0'
    normal = '0 -1 0'
    input = deleter_1_CM
    new_boundary = side
  []
  [deleter_3_CM]
    type = PlaneDeletionGenerator
    point = '84.0556 48.5295 0'
    normal = '84.0556 48.5295 0'
    input = deleter_2_CM
    new_boundary = side
  []
  [deleter_4_CM]
    type = PlaneDeletionGenerator
    point = '-84.0556 48.5295 0'
    normal = '-84.0556 48.5295 0'
    input = deleter_3_CM
    new_boundary = side
  []
  [deleter_5_CM]
    type = PlaneDeletionGenerator
    point = '84.0556 -48.5295 0'
    normal = '84.0556 -48.5295 0'
    input = deleter_4_CM
    new_boundary = side
  []
  [coarse_mesh]
    type = PlaneDeletionGenerator
    point = '-84.0556 -48.5295 0'
    normal = '-84.0556 -48.5295 0'
    input = deleter_5_CM
    new_boundary = side
  []

  # Cut to a 1/12th geometry
  [subdomains_tri]
    type = ParsedSubdomainMeshGenerator
    input = coarse_mesh
    combinatorial_geometry = 'y < 0' # & x < 0.9 & y > 0.1 & y < 0.9'
    excluded_subdomain_ids = '101'
    block_id = 1000
  []
  [subdomains_quad]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_tri
    combinatorial_geometry = 'y < 0'
    excluded_subdomain_ids = '100 1000'
    block_id = 1001
  []
  [subdomains_tri2]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_quad
    combinatorial_geometry = 'y > x / sqrt(3)'
    excluded_subdomain_ids = '101 1001'
    block_id = 2000
  []
  [subdomains_quad2]
    type = ParsedSubdomainMeshGenerator
    input = subdomains_tri2
    combinatorial_geometry = 'y > x / sqrt(3)'
    excluded_subdomain_ids = '100 1001 2000'
    block_id = 2001
  []

  [deleter]
    type = BlockDeletionGenerator
    input = subdomains_quad2
    block = '1000 1001 2000 2001'
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
  []
[]
