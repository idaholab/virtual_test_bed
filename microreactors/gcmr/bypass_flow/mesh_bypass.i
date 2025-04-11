## GCMR TH simulation with inter-assembly bypass flow
## Mesh input file
## Application: MOOSE reactor module
## POC: Lise Charlot lise.charlot at inl.gov
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

# parameters of the coolant channels

radius_coolant = 0.00635 # m

# other parameters of the assembly

lattice_pitch = 0.022 # m
pincell_apothem = '${fparse lattice_pitch / 2}'

# Apothem of PolygonConcentricCircleMeshGenerator:
#
#                 #
#             #       #
#         #               #
#         #<------        #
#         #               #
#             #       #
#                 #

assembly_radius = '${fparse 5 * lattice_pitch}'
assembly_apothem = '${fparse sqrt(3) / 2 * assembly_radius}'
radius_fuel = 0.00794 # m

[Mesh]

  ###  Create Pin Unit Cells

  [moderator_pincell]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '1'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${fparse pincell_apothem / 2 }'
    ring_intervals = '2'
    ring_block_ids = '103 101' # 103 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  [coolant_pincell]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '2'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${radius_coolant}'
    ring_intervals = '2'
    ring_block_ids = '203 201' # 203 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []
  [fuel_pincell_ring1]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '3'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${radius_fuel}'
    ring_intervals = '3'
    ring_block_ids = '303 301' # 303 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []

  [fuel_pincell_ring2]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '4'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${radius_fuel}'
    ring_intervals = '3'
    ring_block_ids = '403 401' # 403 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []

  [fuel_pincell_ring3]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '5'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${radius_fuel}'
    ring_intervals = '3'
    ring_block_ids = '503 501' # 503 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []

  [fuel_pincell_ring4]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2 '
    background_intervals = 2.
    background_block_ids = '6'
    polygon_size = ${pincell_apothem}
    polygon_size_style = 'apothem'
    ring_radii = '${radius_fuel}'
    ring_intervals = '3'
    ring_block_ids = '603 601' # 603 is tri mesh
    preserve_volumes = on
    quad_center_elements = false
  []

  ### Create Fuel assembly

  [fuel_assembly]
    type = PatternedHexMeshGenerator
    inputs = 'coolant_pincell fuel_pincell_ring1 fuel_pincell_ring2 fuel_pincell_ring3 fuel_pincell_ring4 moderator_pincell'
    # Pattern ID     0                 1                  2                  3                  4                   5
    hexagon_size = ${assembly_apothem}
    background_block_id = 10
    background_intervals = 2
    duct_block_ids = '12 11'
    duct_sizes_style = apothem
    duct_sizes = '${fparse assembly_apothem - 0.0008} ${fparse assembly_apothem - 0.0005}'
    duct_intervals = '3 1'
    pattern = '4 4 0 4 4;
              4 0 3 3 0 4;
             0 3 2 0 2 3 0;
            4 3 0 1 1 0 3 4;
           4 0 2 1 5 1 2 0 4;
            4 3 0 1 1 0 3 4;
             0 3 2 0 2 3 0;
              4 0 3 3 0 4;
               4 4 0 4 4'
  []

  # ###  Create the core pattern

  [core]
    type = PatternedHexMeshGenerator
    inputs = 'fuel_assembly'
    pattern_boundary = none
    generate_core_metadata = true
    pattern = '0 0 0 0 0;
              0 0 0 0 0 0;
             0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0;
              0 0 0 0 0 0;
               0 0 0 0 0'

  []

  ###  Add Core reflector

  [reflector]
    type = PeripheralRingMeshGenerator
    input = core
    peripheral_layer_num = 2
    peripheral_ring_radius = 0.9
    input_mesh_external_boundary = 10000
    peripheral_ring_block_id = 250
    peripheral_ring_block_name = reflector
  []

  ###  Extrude to 3D

  [extrude]
    type = AdvancedExtruderGenerator
    input = reflector
    heights = '2'
    num_layers = '10'

    direction = '0 0 1'
    top_boundary = 2000
    bottom_boundary = 3000
  []

  ###  Create the boundary with the flow channel and  delete coolant channels block

  [add_coolant_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    input = extrude
    primary_block = '2'
    paired_block = '201'
    new_boundary = coolant_boundary
  []

  [fuel_assembly_final]
    type = BlockDeletionGenerator
    block = '201 203'
    input = add_coolant_boundary
  []

  ###  Add bypass boundary and delete bypass blocks

  [add_bypass_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    input = fuel_assembly_final
    primary_block = '12'
    paired_block = '11'
    new_boundary = bypass_boundary
  []
  [add_bypass_boundary_out]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_bypass_boundary
    primary_block = '250'
    paired_block = '11'
    new_boundary = bypass_boundary
  []
  [remove_bypass]
    type = BlockDeletionGenerator
    block = '11'
    input = add_bypass_boundary_out
  []

  ### Rotate to match subchannel mesh orientation
  [rotate]
    type = TransformGenerator
    input = remove_bypass
    transform = ROTATE
    vector_value = '0 0 90'
  []
[]
