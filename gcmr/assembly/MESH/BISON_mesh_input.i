[Mesh]
  [YH_pin]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 2
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.843 0.85 0.900'
    ring_intervals = '3 2 2'
    ring_block_ids = '100 100 102 103'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []

  [Coolant_hole_full]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 2
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.6'
    ring_intervals = '3'
    ring_block_ids = '200 200'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []

  [Coolant_hole_half]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.6'
    ring_intervals = '3'
    ring_block_ids = '700 701'
    preserve_volumes = on
    quad_center_elements = false
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []

  [Control_hole]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.99'
    ring_intervals = '3'
    ring_block_ids = '300 300'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []


  [TRISO_fuel]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 2
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.9'
    ring_intervals = '4'
    ring_block_ids = '400 400'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []
  [TRISO_fuel_boundary]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.9'
    ring_intervals = '3'
    ring_block_ids = '401 400'
    preserve_volumes = on
    quad_center_elements = false
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []
  [Poison]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '4 4 4 4 4 4'
    background_intervals = 2
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.25'
    ring_intervals = '3'
    ring_block_ids = '500 500'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []

  [Patterned]
    #type = HexIDPatternedMeshGenerator#PatternedHexMeshGenerator
    type = CutHexIDPatternedMeshGenerator
    # inputs = 'YH_pin Coolant_hole_full Control_hole TRISO_fuel Poison Coolant_hole_half'
    #           0          1               2               3       4           5 
    inputs = 'YH_pin Coolant_hole_full Control_hole TRISO_fuel Poison Coolant_hole_half TRISO_fuel_boundary'
    #           0          1            2           3       4             5                     6
       
    external_boundary_id = 9000
    external_boundary_name = side
    pattern = 
              '6 5 6 6 5 6 ;
              5 3 3 1 3 3 5 ;
             6 3 1 3 4 1 3 6 ;
            6 1 0 3 1 3 3 1 6 ;
           5 3 3 1 3 3 1 0 3 5;
          6 3 1 3 3 2 3 3 1 3 6;
           5 3 4 1 3 3 1 3 3 5;
            6 1 3 3 1 3 4 1 6;
             6 3 1 0 3 1 3 6;
              5 3 3 1 3 3 5;
               6 5 6 6 5 6'
    id_name = 'material_id'
    assign_type = 'cell'
   []
   [Del_full_coolant_holes]
    type = BlockDeletionGenerator
    block = 200
    new_boundary="full_coolant_surf"
    input = Patterned
  [../]

  [Del_half_coolant_holes]
    type = BlockDeletionGenerator
    block = "700 701"
    new_boundary="half_coolant_surf"
    input = Del_full_coolant_holes
  [../]
    [extrude]
     type = FancyExtruderGenerator
     #input = rename_4
     input = Del_half_coolant_holes
     heights = '20 160 20'
     num_layers = '3 5 3'
     direction = '0 0 1'
     top_boundary = 2000
     bottom_boundary = 2001

    #  elem_integer_names_to_swap = 'material_id'
    #  elem_integers_swaps = '1 1;
    #                         1 1;
    #                         1 1'
  []

  [reflector_bottom_quad]
    type = ParsedSubdomainMeshGenerator
    input = extrude
    combinatorial_geometry = 'z<=20'
    block_id = 8000
    excluded_subdomain_ids= '401'
  []

  [reflector_bottom_tri]
    type = ParsedSubdomainMeshGenerator
    input = reflector_bottom_quad
    combinatorial_geometry = 'z<=20'
    block_id = 8001
    excluded_subdomain_ids= '8000'
  []
  [reflector_top_quad]
    type = ParsedSubdomainMeshGenerator
    input = reflector_bottom_tri
    combinatorial_geometry = 'z>=180'
    block_id = 8000
    excluded_subdomain_ids= '401 300'
  []
  [reflector_top_tri]
    type = ParsedSubdomainMeshGenerator
    input = reflector_top_quad
    combinatorial_geometry = 'z>=180'
    block_id = 8001
    excluded_subdomain_ids= '8000 300'
  []

  
  [control_top]
    type = ParsedSubdomainMeshGenerator
    input = reflector_top_tri
    combinatorial_geometry = 'z>=180'
    block_id = 600
    excluded_subdomain_ids= '8000 8001 401'
  []
  [rename_blocks]
    type = RenameBlockGenerator
    old_block_id = '     10        100    102   103     400   401      300  500   600      8000          8001'
    new_block_name = 'monolith moderator  Cr  FECRAL   Fuel Fuel_tri   Air  B4C control  reflector   reflector_tri'
    input = control_top
  []
  # [rename_blocks]
  #   type = RenameBlockGenerator
  #   old_block_id = '     10        100    102   103    400  300  500   600          8000 '
  #   new_block_name = 'monolith moderator  Cr  FECRAL   Fuel Air  B4C control     reflector'
  #   input = control_top
  # []
  
  [rename_sidesets]
    type = RenameBoundaryGenerator
    input = rename_blocks
    old_boundary = '    2000           2001    '
    new_boundary = 'top_boundary bottom_boundary'
  []
  
  [scale] # unit convert from cm to m
    type = TransformGenerator
    input = rename_sidesets
    transform = SCALE
    vector_value = '1e-2 1e-2 1e-2'
  []
  
[]

[Executioner]
  type = Steady
[]

[Problem]
  solve = false
[]

[AuxVariables]
  [material_id]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [set_material_id]
    type = ElemExtraIDAux
    variable = material_id
    extra_id_name = material_id
    execute_on = 'initial'
  []
[]

[Outputs]
  exodus = true
  execute_on = final
[]

