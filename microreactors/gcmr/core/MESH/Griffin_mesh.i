[Mesh]
  [YH_pin]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.693 0.7 0.75'
    ring_intervals = '2 1 1'
    ring_block_ids = '101 100 102 103'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [Coolant_hole]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.6'
    ring_intervals = '2'
    ring_block_ids = '201 200'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [Control_hole]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.95'
    ring_intervals = '2'
    ring_block_ids = '301 300'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [TRISO_fuel_in]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.85'
    ring_intervals = '2'
    ring_block_ids = '401 400'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [TRISO_fuel_mid]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.85'
    ring_intervals = '2'
    ring_block_ids = '4001 4000'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

    [TRISO_fuel_out]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.85'
    ring_intervals = '2'
    ring_block_ids = '40001 40000'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [Poison_LBP0]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.25'
    ring_intervals = '2'
    ring_block_ids = '501 500'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

  [Poison_LBP1]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '2 2 2 2 2 2'
    background_intervals = 1
    background_block_ids = '10'
    polygon_size = 1
    polygon_size_style ='apothem'
    ring_radii = '0.25'
    ring_intervals = '2'
    ring_block_ids = '5001 5000'
    preserve_volumes = on
    #quad_center_elements = true
    #external_boundary_id = 100
    #interface_boundary_id_shift = 100
  []

    [centralFA]
    type = PatternedHexMeshGenerator
    inputs = 'YH_pin Coolant_hole  TRISO_fuel_in Poison_LBP0  Control_hole  Poison_LBP1   TRISO_fuel_out  TRISO_fuel_mid'
    #           0          1            2           3          4            5             6               7
    hexagon_size = 10.4
    pattern =
                      '3  1  2  2  1  3;
                    1  0  2  1  2  0  1;
                  2  2  1  2  2  1  2  2;
                2  1  2  3  1  3  2  1  2;
              1  2  2  1  2  2  1  2  2  1;
            3  0  1  3  2  1  2  3  1  0  3;
            1  2  2  1  2  2  1  2  2  1;
            2  1  2  3  1  3  2  1  2;
            2  2  1  2  2  1  2  2;
            1  0  2  1  2  0  1;
            3  1  2  2  1  3'

    #id_name = 'material_id'
    #assign_type = 'cell'
  background_block_id = 10
  background_intervals = 1
   []

  [Innercore]
    type = PatternedHexMeshGenerator
    inputs = 'YH_pin Coolant_hole  TRISO_fuel_in Poison_LBP0  Control_hole  Poison_LBP1   TRISO_fuel_out  TRISO_fuel_mid'
    #           0          1            2           3         4
    hexagon_size = 10.4
    pattern =
                      '3  1  2  2  1  3;
                    1  0  2  1  2  0  1;
                  2  2  1  2  2  1  2  2;
                2  1  2  3  1  3  2  1  2;
              1  2  2  1  2  2  1  2  2  1;
            3  0  1  3  2  1  2  3  1  0  3;
            1  2  2  1  2  2  1  2  2  1;
            2  1  2  3  1  3  2  1  2;
            2  2  1  2  2  1  2  2;
            1  0  2  1  2  0  1;
            3  1  2  2  1  3'

    #id_name = 'material_id'
    #assign_type = 'cell'
  background_block_id = 10
  background_intervals = 1
   []

    [dummy]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side= '2 2 2 2 2 2'
    hexagon_size = 10.4
    background_intervals = 1
    background_block_ids = '700'
   []

    [Outercore]
    type = PatternedHexMeshGenerator
    inputs = 'YH_pin Coolant_hole  TRISO_fuel_in Poison_LBP0  Control_hole  Poison_LBP1   TRISO_fuel_out  TRISO_fuel_mid'
    #           0          1            2           3         4             5             6              7
    hexagon_size = 10.4
    pattern =
                      '7  1  7  7  1  7;
                    1  0  7  1  7  0  1;
                  7  7  1  7  7  1  7  7;
                7  1  7  5  1  5  7  1  7;
              1  7  7  1  7  7  1  7  7  1;
            7  0  1  5  7  4  7  5  1  0  7;
            1  7  7  1  7  7  1  7  7  1;
            7  1  7  5  1  5  7  1  7;
            7  7  1  7  7  1  7  7;
            1  0  7  1  7  0  1;
            7  1  7  7  1  7'

    #id_name = 'material_id'
    #assign_type = 'cell'
    background_block_id = 10
    background_intervals = 1
   []

    [Outercore2]
    type = PatternedHexMeshGenerator
    inputs = 'YH_pin Coolant_hole  TRISO_fuel_in Poison_LBP0  Control_hole  Poison_LBP1   TRISO_fuel_out  TRISO_fuel_mid'
    #           0          1            2           3         4             5             6
    hexagon_size = 10.4
    pattern =
                      '7  1  7  7  1  7;
                    1  0  7  1  7  0  1;
                  7  7  1  7  7  1  7  7;
                7  1  7  5  1  5  7  1  7;
              1  7  7  1  7  7  1  7  7  1;
            7  0  1  5  7  4  7  5  1  0  7;
            1  7  7  1  7  7  1  7  7  1;
            7  1  7  5  1  5  7  1  7;
            7  7  1  7  7  1  7  7;
            1  0  7  1  7  0  1;
            7  1  7  7  1  7'

    #id_name = 'material_id'
    #assign_type = 'cell'
    background_block_id = 10
    background_intervals = 1
   []

    [Innercore2]
    type = PatternedHexMeshGenerator
    inputs = 'YH_pin Coolant_hole  TRISO_fuel_in Poison_LBP0  Control_hole  Poison_LBP1   TRISO_fuel_out  TRISO_fuel_mid'
    #           0          1            2           3         4             5             6               7
    hexagon_size = 10.4
    pattern =
                      '6  1  6  6  1  6;
                    1  0  6  1  6  0  1;
                  6  6  1  6  6  1  6  6;
                6  1  6  5  1  5  6  1  6;
              1  6  6  1  6  6  1  6  6  1;
            6  0  1  5  6  1  6  5  1  0  6;
            1  6  6  1  6  6  1  6  6  1;
            6  1  6  5  1  5  6  1  6;
            6  6  1  6  6  1  6  6;
            1  0  6  1  6  0  1;
            6  1  6  6  1  6'

    #id_name = 'material_id'
    #assign_type = 'cell'
    background_block_id = 10
    background_intervals = 1
   []

 [cd0_12]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2'
    sides_to_adapt = '3 4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_12]
    type = AzimuthalBlockSplitGenerator
    input = cd0_12
    start_angle = 45
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_6]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2'
    sides_to_adapt = '0 1'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_6]
    type = AzimuthalBlockSplitGenerator
    input = cd0_6
    start_angle = 225
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_9]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 Innercore2'
    sides_to_adapt = '0 5 4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_9]
    type = AzimuthalBlockSplitGenerator
    input = cd0_9
    start_angle = 135
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_3]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 Innercore2'
    sides_to_adapt = '1 2 3'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_3]
    type = AzimuthalBlockSplitGenerator
    input = cd0_3
    start_angle = 315
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_1]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 Innercore2'
    sides_to_adapt = '2 3 4'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_1]
    type = AzimuthalBlockSplitGenerator
    input = cd0_1
    start_angle = 15
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_2]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2  Innercore2'
    sides_to_adapt = '2 3'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_2]
    type = AzimuthalBlockSplitGenerator
    input = cd0_2
    start_angle = 345
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_4]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 '
    sides_to_adapt = '1 2'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_4]
    type = AzimuthalBlockSplitGenerator
    input = cd0_4
    start_angle = 285
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_5]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs =  'Innercore2 Innercore2 Innercore2'
    sides_to_adapt = '0 1 2'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []
  [cd_5]
    type = AzimuthalBlockSplitGenerator
    input = cd0_5
    start_angle = 255
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []
  [cd0_7]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = ' Innercore2 Innercore2 Innercore2'
    sides_to_adapt = '0 1 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_7]
    type = AzimuthalBlockSplitGenerator
    input = cd0_7
    start_angle = 195
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_8]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 '
    sides_to_adapt = '0 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_8]
    type = AzimuthalBlockSplitGenerator
    input = cd0_8
    start_angle = 165
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

  [cd0_10]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Innercore2 Innercore2 '
    sides_to_adapt = ' 4 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_10]
    type = AzimuthalBlockSplitGenerator
    input = cd0_10
    start_angle = 105
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []
  [cd0_11]
    type =HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    inputs = 'Outercore  Outercore Outercore'
    sides_to_adapt = '3 4 5'
    num_sectors_per_side= '4 4 4 4 4 4'
    hexagon_size = 10.4
    background_intervals = 2
    background_block_ids = 604
    ring_radii = '9 10'
    ring_intervals = '1 1'
    ring_block_ids = '600 602'
    preserve_volumes = true
    is_control_drum = true
  []

  [cd_11]
    type = AzimuthalBlockSplitGenerator
    input = cd0_11
    start_angle = 75
    angle_range = 90
    old_blocks = 602
    new_block_ids = 603
  []

    [core]
    type = PatternedHexMeshGenerator
    inputs = 'Innercore Innercore2 Outercore dummy cd_1 cd_2 cd_3 cd_4 cd_5 cd_6 cd_7 cd_8 cd_9 cd_10 cd_11 cd_12 Outercore2  centralFA'
    #         0         1          2         3     4    5    6    7    8    9    10   11   12   13    14    15    16         17
    pattern_boundary = none
    generate_core_metadata = true
    #external_boundary_id = 9000
    #external_boundary_name = side

  pattern =
        '3  3  3  15  3  3  3;
        3  14  1  1  1  1  4  3;
      3  1  1   16  16  16  1  1  3;
    13  1  16  2  2  2  2  16  1  5;
   3  1  16  2  0  0  0  2  16  1  3;
  3  1  16   2  0  0  0  0  2  16  1  3;
3  12  1  2  0  0  17  0  0  2  1  6  3;
  3  1  16  2  0  0  0  0  2  16  1  3;
   3  1  16  2   0  0   0   2  16  1  3;
    11  1  16  2   2  2   2  16  1  7;
       3  1  1  16  16  16  1  1  3;
       3    10  1   1  1   1  8  3;
          3   3  3  9  3  3   3'

    rotate_angle = 0
    #id_name = 'material_id'
    #assign_type = 'cell'
   []

   [del_dummy]
     type = BlockDeletionGenerator
     block = '700 '
     input = core
     new_boundary = 10000
   []

   [ADD_outer_shield]
     type = PeripheralRingMeshGenerator
     input = del_dummy
     peripheral_layer_num = 2
     peripheral_ring_radius = 120.1
     input_mesh_external_boundary = 10000
     peripheral_ring_block_id = 250
     #peripheral_ring_block_name = outer_shield
   []

   [del_1]
     type = PlaneDeletionGenerator
     point = '0 0 0'
     normal = '10 17.32 0'
     input = ADD_outer_shield
     new_boundary = 147
   []

   [del_2]
     type = PlaneDeletionGenerator
     point = '0 0 0'
     normal = '10 -17.32 0'
     input = del_1
     new_boundary = 147
   []

   [extrude]
     type = FancyExtruderGenerator
     input = del_2
     heights = '20 40 40 40 40 40 20'
     num_layers ='2 4 4  4  4  4 2'
     subdomain_swaps = '10    1000    500 1000    501  1003   5001  1003  5000  1000  400 1000 401 1003 4000 1000 4001 1003 40000 1000 40001 1003 101 1003 100 1000 102 1000 103 1000 301 1003 300 1000;
                        500   19000  501  19003  5001  19900  5000  19903;
                        500   29000  501  29003  5001  29900  5000  29903;
                        500   39000  501  39003  5001  39900  5000  39903;
                        500   49000  501  49003  5001  49900  5000  49903;
                        500   59000  501  59003  5001  59900  5000  59903;
                        10     1000    500  1000  501      1003   5001  1003  5000  1000  400 1000 401 1003 4000 1000 4001 1003 40000 1000 40001 1003 101 1003 100 1000 102 1000 103 1000 301 1773 300 1777'
      direction = '0 0 1'
      top_boundary = 2000
      bottom_boundary = 3000
     []

    [rename_blocks]
      type = RenameBlockGenerator
      old_block_id =   ' 10      100        101           102  103     200     201          400     401          4000     4001          40000    40001          300          301                  600         602          603        604          1000              1003            19000  29000  39000  49000  59000  19003  29003  39003  49003  59003  19900  29900  39900  49900  59900  19903  29903  39903  49903  59903  1777 1773  250'
      new_block_name = 'monolith moderator  moderator_tri Cr   FECRAL  coolant coolant_tri  Fuel_in Fuel_tri_in  Fuel_mid Fuel_tri_mid  Fuel_out Fuel_tri_out   Control_hole Control_hole_tri     CD_Radial1  CD_Radial2   CD_poison  CD_coolant   reflector_quad    reflector_tri   BP0_1  BP0_2  BP0_3  BP0_4  BP0_5  BP0_tr_1  BP0_tr_2  BP0_tr_3  BP0_tr_4  BP0_tr_5  BP1_1  BP1_2  BP1_3  BP1_4  BP1_5  BP1_tr_1  BP1_tr_2  BP1_tr_3  BP1_tr_4  BP1_tr_5 Control_ref Control_ref_tri Rad_ref'
      input = extrude
    []

    [rename_sidesets]
      type = RenameBoundaryGenerator
      input = rename_blocks
      old_boundary = '2000         3000            10000  147 '
      new_boundary = 'top_boundary bottom_boundary side   cut_surf'
   []

   [scale] # unit convert from cm to m
     type = TransformGenerator
     input = rename_sidesets
     transform = SCALE
     vector_value = '1e-2 1e-2 1e-2'
   []
[]
