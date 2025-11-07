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
  [CD]
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
    replace_inner_ring_with_delaunay_mesh = true
    inner_ring_desired_area = (1-(x*x+y*y)/13.8/13.8)+(x*x+y*y)/13.8/13.8*0.2
  []
  [Core]
    type = PatternedHexMeshGenerator
    inputs = 'Assembly_1 Assembly_1 Assembly_1 AIRHOLE REFL CD'
  # Pattern ID   0            1          2         3     4   5
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

  #
  # Cut the core for 1/12th mesh
  #
  [half]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '0 -1 0'
    input = Core
    new_boundary = bottom
  []
  [twelfth]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '${fparse -cos(pi/3)} ${fparse sin(pi/3)} 0'
    input = half
    new_boundary = topleft
  []
  [trim]
    type = PlaneDeletionGenerator
    point = '84.0556 48.5295 0'
    normal = '${fparse sin(pi/3)} ${fparse cos(pi/3)} 0'
    input = twelfth
    new_boundary = right
  []
  [boundary_clean_up]
    type = BoundaryDeletionGenerator
    input = trim
    boundary_names = 'bottom topleft right'
    operation = keep
  []

  #
  # Add an EEID for assigning multigroup xs libraries
  #
  [mglib_id]
    type = SubdomainExtraElementIDGenerator
    input = boundary_clean_up
    subdomains = '1 2 3 4 5 6 7 8 10 11 14 15 13 20 21 22'
    extra_element_id_names = material_id
    extra_element_ids = '1001 1001 1002 1002 1002 1004 1004 1003     1005 1005 1005 1005 1006 1007 1007 1007'
    #                    fuel      moderator      hpipe     monolith be                  drum air
  []

  #
  # F1_1 to trim_CM to create a coarse mesh
  #
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
    normal = '${fparse sin(pi/3)} ${fparse cos(pi/3)} 0'
    input = twelfth_CM
    new_boundary = right
  []

  #
  # Add coarse element id
  #
  [assign_coarse_elem_id]
    type = CoarseMeshExtraElementIDGenerator
    input = mglib_id
    coarse_mesh = trim_CM
    extra_element_id_name = coarse_element_id
  []

  #
  # Scale the mesh to length unit in meter for multiphysics
  #
  [scale]
    type = TransformGenerator
    input = assign_coarse_elem_id
    transform = SCALE
    vector_value = '0.01 0.01 0.01'
  []

  #
  # Add boundaries for thermal conduction
  #
  [add_sideset_hp]
    type = SideSetsBetweenSubdomainsGenerator
    input = scale
    primary_block = '8' # add 16 so the HP boundary extends into the upper axial reflector
    paired_block =  '7'
    new_boundary = 'hp'
  []
  [add_sideset_inner_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_hp
    primary_block = '4'
    paired_block =  '5'
    new_boundary = 'gap_mod_inner'
  []
  [add_sideset_outer_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_inner_mod_gap
    primary_block = '8'
    paired_block =  '5'
    new_boundary = 'gap_mod_outer'
  []
[]
