################################################################
# This is the MOOSE input file to generate the mesh that can be
# used for the 1/6 core Heat-Pipe Microreactor Multiphysics
# simulations (Griffin neutronics simulation).
# Running this input requires MOOSE Reactor Module Objects
# Users should use
# --mesh-only HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry.e
# command line argument to generate
# exodus file for further Multiphysics simulations.
################################################################
[GlobalParams]
  create_outward_interface_boundaries = false
[]

[Mesh]
  # Moderator pins
  [Mod_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1.15
    polygon_size_style ='apothem'
    ring_radii = '0.825 0.92'
    ring_intervals = '2 1'
    ring_block_ids = '103 100 101' # 103 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  # Heat Pipe pins
  [HP_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1.15
    polygon_size_style ='apothem'
    ring_radii = '0.97 1.07'
    ring_intervals = '2 1'
    ring_block_ids = '203 200 201' # 203 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  # Fuel pins
  [Fuel_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1.15
    polygon_size_style ='apothem'
    ring_radii = '1'
    ring_intervals = '2'
    ring_block_ids = '303 301'  # 303 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  # Assembly mesh with all the three types of pins
  [Patterned]
    type = PatternedHexMeshGenerator
    inputs = 'Fuel_hex HP_hex Mod_hex'
    hexagon_size = 13.376
    background_block_id = 10
    background_intervals = 1
    pattern = '1 0 1 0 1 0 1;
              0 2 0 2 0 2 0 0;
             1 0 1 0 1 0 1 2 1;
            0 2 0 2 0 2 0 0 0 0;
           1 0 1 0 1 0 1 2 1 2 1;
          0 2 0 2 0 2 0 0 0 0 0 0;
         1 0 1 0 1 0 1 2 1 2 1 2 1;
          0 2 0 2 0 2 0 0 0 0 0 0;
           1 0 1 0 1 0 1 2 1 2 1;
            0 2 0 2 0 2 0 0 0 0;
             1 0 1 0 1 0 1 2 1;
              0 2 0 2 0 2 0 0;
               1 0 1 0 1 0 1'
  []
  # Control drum at 12 o'clock
  [cd0_12]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '3 4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_12]
    type = AzimuthalBlockSplitGenerator
    input = cd0_12
    start_angle = 45
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 6 o'clock
  [cd0_6]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '0 1'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_6]
    type = AzimuthalBlockSplitGenerator
    input = cd0_6
    start_angle = 225
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 9 o'clock
  [cd0_9]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned Patterned'
    sides_to_adapt = '0 4 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_9]
    type = AzimuthalBlockSplitGenerator
    input = cd0_9
    start_angle = 135
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 3 o'clock
  [cd0_3]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned Patterned'
    sides_to_adapt = '1 2 3'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_3]
    type = AzimuthalBlockSplitGenerator
    input = cd0_3
    start_angle = 315
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 1 o'clock
  [cd0_1]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned Patterned'
    sides_to_adapt = '2 3 4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_1]
    type = AzimuthalBlockSplitGenerator
    input = cd0_1
    start_angle = 15
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 2 o'clock
  [cd0_2]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '2 3'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_2]
    type = AzimuthalBlockSplitGenerator
    input = cd0_2
    start_angle = 345
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 4 o'clock
  [cd0_4]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '1 2'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_4]
    type = AzimuthalBlockSplitGenerator
    input = cd0_4
    start_angle = 285
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 5 o'clock
  [cd0_5]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = ' Patterned Patterned Patterned'
    sides_to_adapt = '0 1 2'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_5]
    type = AzimuthalBlockSplitGenerator
    input = cd0_5
    start_angle = 255
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 7 o'clock
  [cd0_7]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = ' Patterned Patterned Patterned'
    sides_to_adapt = '0 1 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_7]
    type = AzimuthalBlockSplitGenerator
    input = cd0_7
    start_angle = 195
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 8 o'clock
  [cd0_8]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '0 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_8]
    type = AzimuthalBlockSplitGenerator
    input = cd0_8
    start_angle = 165
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 10 o'clock
  [cd0_10]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned'
    sides_to_adapt = '4 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_10]
    type = AzimuthalBlockSplitGenerator
    input = cd0_10
    start_angle = 105
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Control drum at 11 o'clock
  [cd0_11]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned Patterned Patterned'
    sides_to_adapt = '3 4 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 502'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  [cd_11]
    type = AzimuthalBlockSplitGenerator
    input = cd0_11
    start_angle = 75
    angle_range = 90
    old_blocks = 502
    new_block_ids = 503
  []
  # Reflector blocks * 6
  [ref_0]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '0'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_1]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '1'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_2]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '2'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_3]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '3'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_4]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_5]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    meshes_to_adapt_to = 'Patterned'
    sides_to_adapt = '5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  # Central void region
  [air_center]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side= '4 4 4 4 4 4'
    meshes_to_adapt_to = 'Patterned Patterned Patterned Patterned Patterned Patterned'
    sides_to_adapt = '0 1 2 3 4 5'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '600 601'
  []
  # Dummy assembly to help form a regular hexagonal core pattern
  # This will be deleted later
  [dummy]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '700 701'
       # external_boundary_id = 9998
  []
  # Stitching assemblies together to form the core mesh
  [core]
    type = PatternedHexMeshGenerator
    inputs = 'Patterned cd_1 cd_2 cd_3 cd_4 cd_5 cd_6 cd_7 cd_8 cd_9 cd_10 cd_11 cd_12 ref_0 ref_1 ref_2 ref_3 ref_4 ref_5 dummy air_center'
    # Pattern ID  0       1    2    3    4    5    6    7    8    9    10    11    12    13    14    15    16    17    18   19       20
    pattern_boundary = none
    generate_core_metadata = true
    pattern = '19 17 12 16 19;
             17 11  0  0  1 16;
           10  0  0  0  0  0  2;
          18 0  0   0  0  0  0 15;
        19  9  0  0  20  0  0  3 19;
          18 0  0   0  0  0  0 15;
            8  0  0  0  0  0  4;
             13  7  0  0  5 14;
               19 13  6 14 19'
    rotate_angle = 60
    assign_control_drum_id = true
  []
  # Delete the dummy assemblies
  [del_dummy]
    type = BlockDeletionGenerator
    block = '700 701'
    input = core
    new_boundary = 10000
  []
  # Add peripheral circular region
  [add_outer_shield]
    type = PeripheralRingMeshGenerator
    input = del_dummy
    peripheral_layer_num = 1
    peripheral_ring_radius = 115.0
    input_mesh_external_boundary = 10000
    peripheral_ring_block_id = 250
    peripheral_ring_block_name = outer_shield
 []
 # trim the full core to 1/6 core
 [del_1]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '10 17.32 0'
    input = add_outer_shield
    new_boundary = 147
  []
  [del_2]
    type = PlaneDeletionGenerator
    point = '0 0 0'
    normal = '10 -17.32 0'
    input = del_1
    new_boundary = 147
  []
  # extrusion
  [extrude]
     type = AdvancedExtruderGenerator
     input = del_2
     heights = '20 160 20'
     # Use `num_layers = '6 16 6'` for BISON mesh
     num_layers = '1 8 1'
     # biased upper and lower reflector mesh, uncomment for BISON mesh
     # biases = '1.6 1.0 0.625'
     direction = '0 0 1'
     top_boundary = 2000
     bottom_boundary = 3000
  []
  # Define some special reflector blocks
  [reflector_bottom_quad]
    type = ParsedSubdomainMeshGenerator
    input = extrude
    combinatorial_geometry = 'z<=20'
    block_id = 1000
    excluded_subdomain_ids= '103 203 303 250 400 401 500 501 502 503 504 600 601'
  []
  [reflector_bottom_tri]
    type = ParsedSubdomainMeshGenerator
    input = reflector_bottom_quad
    combinatorial_geometry = 'z<=20'
    block_id = 1003
    excluded_subdomain_ids= '1000 250 400 401 500 501 502 503 504 600 601'
  []
  [reflector_top_quad]
    type = ParsedSubdomainMeshGenerator
    input = reflector_bottom_tri
    combinatorial_geometry = 'z>=180'
    block_id = 1000
    excluded_subdomain_ids= '103 203 303 200 201 250 400 401 500 501 502 503 504 600 601'
  []
  [reflector_top_tri]
    type = ParsedSubdomainMeshGenerator
    input = reflector_top_quad
    combinatorial_geometry = 'z>=180'
    block_id = 1003
    excluded_subdomain_ids= '1000 200 201 203 250 400 401 500 501 502 503 504 600 601'
  []
  # Assgin block names
  [rename_blocks]
    type = RenameBlockGenerator
    old_block = '     101       100         103          201        200           203            301       303        400            401         10      503      600         601        504          500                501          502         1000           1003'
    new_block = ' mod_ss moderator_quad moderator_tri hp_ss  heat_pipes_quad heat_pipes_tri fuel_quad fuel_tri reflector_tri reflector_quad monolith B4C air_gap_tri air_gap_quad air_gap_quad reflector_tri  reflector_quad reflector_quad reflector_quad reflector_tri'
    input = reflector_top_tri
  []
  # Assign boundary names
  [rename_boundaries]
    type = RenameBoundaryGenerator
    input = rename_blocks
    old_boundary = ' 10000 2000 3000 147'
    new_boundary = ' side top bottom side_mirror'
  []
  # Scale to m unit for general MOOSE application
  # Note that is_meter needs to be true in Griffin
  [scale]
    type = TransformGenerator
    input = rename_boundaries
    transform = SCALE
    vector_value = '1e-2 1e-2 1e-2'
  []
  # Rotate to the desired orientation for simulation
  [rotate_end]
    type = TransformGenerator
    input = scale
    transform = ROTATE
    vector_value = '0 0 -120'
  []
[]
