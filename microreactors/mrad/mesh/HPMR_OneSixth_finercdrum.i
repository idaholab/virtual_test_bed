#####################################################################
# This is the MOOSE input file to generate the mesh that can be
# used for the 1/6 core Heat-Pipe Microreactor Multiphysics
# simulations (BISON thermal simulation).
# Running this input requires MOOSE Reactor Module Objects
# Users should use
# --mesh-only HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry_fine.e
# command line argument to generate
# exodus file for further Multiphysics simulations.
#####################################################################
[Mesh]
  # Moderator pins
  [Mod_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1.15
    polygon_size_style = 'apothem'
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
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    # inner background boundary layer, only for BISON mesh
    background_inner_boundary_layer_bias = 1.5
    background_inner_boundary_layer_intervals = 3
    background_inner_boundary_layer_width = 0.03
    polygon_size = 1.15
    polygon_size_style = 'apothem'
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
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1.15
    polygon_size_style = 'apothem'
    ring_radii = '1'
    ring_intervals = '2'
    ring_block_ids = '303 301' # 303 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  # Assembly mesh with all the three types of pins
  [Patterned_o]
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
  [Patterned]
    type = PatternedHexPeripheralModifier
    input = Patterned_o
    input_mesh_external_boundary = 10000
    new_num_sector = 120
    num_layers = 1
  []
  # Control drum at 12 o'clock
  [cd_12]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '3 4'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5012'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 6 o'clock
  [cd_6]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '0 1'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5006'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 9 o'clock
  [cd_9]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '0 4 5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5009'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 3 o'clock
  [cd_3]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '1 2 3'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5003'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 1 o'clock
  [cd_1]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '2 3 4'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5001'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 2 o'clock
  [cd_2]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '2 3'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5002'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 4 o'clock
  [cd_4]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '1 2'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5004'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 5 o'clock
  [cd_5]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '0 1 2'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5005'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 7 o'clock
  [cd_7]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '0 1 5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5007'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 8 o'clock
  [cd_8]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '0 5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5008'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 10 o'clock
  [cd_10]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned'
    sides_to_adapt = '4 5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5010'
    preserve_volumes = true
    is_control_drum = true
  []
  # Define the absorber section
  # Control drum at 11 o'clock
  [cd_11]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned Patterned Patterned'
    sides_to_adapt = '3 4 5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = 504
    ring_radii = '12.25 13.25'
    ring_intervals = '2 1'
    ring_block_ids = '500 501 5011'
    preserve_volumes = true
    is_control_drum = true
  []
  [ref_0]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '0'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_1]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '1'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_2]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '2'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_3]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '3'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_4]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '4'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  [ref_5]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Patterned'
    sides_to_adapt = '5'
    num_sectors_per_side = '120 120 120 120 120 120'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '400 401'
  []
  # Central void region
  [air_center]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = '120 120 120 120 120 120'
    inputs = 'Patterned Patterned Patterned Patterned Patterned Patterned'
    sides_to_adapt = '0 1 2 3 4 5'
    hexagon_size = 13.376
    background_intervals = 2
    background_block_ids = '600 601'
  []
  # Dummy assembly to help form a regular hexagonal core pattern
  # This will be deleted later
  [dummy]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = '120 120 120 120 120 120'
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
    # Use `peripheral_layer_num = 2` for BISON mesh
    peripheral_layer_num = 2
    peripheral_ring_radius = 115.0
    input_mesh_external_boundary = 10000
    peripheral_ring_block_id = 250
    peripheral_ring_block_name = outer_shield
    # Peripheral boundary layer, only for BISON mesh
    peripheral_outer_boundary_layer_bias = 0.625
    peripheral_outer_boundary_layer_intervals = 3
    peripheral_outer_boundary_layer_width = 2
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
     subdomain_swaps = '101  1000  100  1000  103  1003    201  201      200  200   203  203    250  250  301  1000   303  1003  400     400  401     401    10  1000  503     503  600  600     601   601    504      504      500   500   501   501  10000 1009  5001   5001 5002   5002 5003   5003   5004   5004   5005  5005   5006  5006   5007  5007   5008  5008   5009  5009   5010  5010    5011  5011    5012  5012;
                        101 101     100 100     103 103     201 201     200 200     203 203     250  250  301   301      303    303     400    400  401     401    10   10      503    503  600 600    601   601    504     504     500     500     501     501  10000 10000 5001   5001 5002   5002 5003   5003   5004     5004   5005  5005   5006  5006   5007  5007   5008  5008   5009  5009   5010  5010    5011  5011    5012  5012;
                        101  1000  100  1000  103  1003    201  1000  200  1000  203  1003   250  250  301  1000   303  1003  400     400  401      401     10  1000  503    503  600 600    601   601    504    504      500   500   501   501   10000 1008  5001   5001 5002   5002 5003   5003   5004   5004   5005  5005   5006  5006   5007  5007   5008  5008   5009  5009   5010  5010    5011  5011    5012  5012'

     # biased upper and lower reflector mesh, only for BISON mesh
     #biases = '1.6 1.0 0.625'
     direction = '0 0 1'
     top_boundary = 2000
     bottom_boundary = 3000
   []
  ## Define some special reflector blocks
  #[reflector_bottom_quad]
  #  type = ParsedSubdomainMeshGenerator
  #  input = extrude
  #  combinatorial_geometry = 'z<=20'
  #  block_id = 1000
  #  excluded_subdomain_ids = '103 203 303 250 400 401 500 501 502 503 504 600 601'
  #[]
  #[reflector_bottom_tri]
  #  type = ParsedSubdomainMeshGenerator
  #  input = reflector_bottom_quad
  #  combinatorial_geometry = 'z<=20'
  #  block_id = 1003
  #  excluded_subdomain_ids = '1000 250 400 401 500 501 502 503 504 600 601'
  #[]
  #[reflector_top_quad]
  #  type = ParsedSubdomainMeshGenerator
  #  input = reflector_bottom_tri
  #  combinatorial_geometry = 'z>=180'
  #  block_id = 1000
  #  excluded_subdomain_ids = '103 203 303 200 201 250 400 401 500 501 502 503 504 600 601'
  #[]
  #[reflector_top_tri]
  #  type = ParsedSubdomainMeshGenerator
  #  input = reflector_top_quad
  #  combinatorial_geometry = 'z>=180'
  #  block_id = 1003
  #  excluded_subdomain_ids = '1000 200 201 203 250 400 401 500 501 502 503 504 600 601'
  #[]
  ## Assgin block names
  #[rename_blocks]
  #  type = RenameBlockGenerator
  #   old_block_id = '     101       100         103          201        200           203            301       303        400            401         10     600         601        504          500                501          502                  1003'
  #   new_block_name = ' mod_ss moderator_quad moderator_tri hp_ss  heat_pipes_quad heat_pipes_tri fuel_quad fuel_tri reflector_tri reflector_quad monolith  air_gap_tri air_gap_quad air_gap_quad reflector_tri  reflector_quad Drum_channel     reflector'
  #  input = extrude
  #[]
 # Assign boundary names
  [rename_boundaries]
    type = RenameBoundaryGenerator
    input = extrude
    old_boundary = '10000 2000 3000 147'
    new_boundary = 'side top bottom side_mirror'
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
  ## A series of process to prepare the mesh for BISON simulation
  #[split_hp_ss]
  #  type = SubdomainBoundingBoxGenerator
  #  input = rotate_end
  #  block_id = 1201
  #  block_name = 'hp_ss_up'
  #  restricted_subdomains = 'hp_ss'
  #  bottom_left = '-100 -100 1.8'
  #  top_right = '100 100 3.0'
  #[]
  #[add_exterior_ht_low]
  #  type = SideSetsBetweenSubdomainsGenerator
  #  input = split_hp_ss
  #  paired_block = 'hp_ss'
  #  primary_block = 'monolith'
  #  new_boundary = 'heat_pipe_ht_surf_low'
  #[]
  #[add_exterior_ht_up]
  #  type = SideSetsBetweenSubdomainsGenerator
  #  input = add_exterior_ht_low
  #  paired_block = 'hp_ss_up'
  #  primary_block = 'reflector_quad'
  #  new_boundary = 'heat_pipe_ht_surf_up'
  #[]
  #[add_exterior_bot]
  #  type = SideSetsBetweenSubdomainsGenerator
  #  input = add_exterior_ht_up
  #  paired_block = 'heat_pipes_quad heat_pipes_tri hp_ss'
  #  primary_block = 'reflector_quad reflector_tri'
  #  new_boundary = 'heat_pipe_ht_surf_bot'
  #[]
  #[merge_hp_surf]
  #  type = RenameBoundaryGenerator
  #  input = add_exterior_bot
  #  old_boundary = 'heat_pipe_ht_surf_low heat_pipe_ht_surf_up'
  #  new_boundary = 'heat_pipe_ht_surf heat_pipe_ht_surf'
  #[]
  #[remove_hp]
  #  type = BlockDeletionGenerator
  #  input = merge_hp_surf
  #  block = 'hp_ss hp_ss_up heat_pipes_quad heat_pipes_tri'
  #[]
  #
  ## remove extra nodesets to limit the size of the mesh
  #[clean_up]
  #  type = BoundaryDeletionGenerator
  #  input = remove_hp
  #  boundary_names = '1 3'
  #[]
[]
