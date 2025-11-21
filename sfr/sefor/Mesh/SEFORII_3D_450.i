# ========================================================
# SEFOR Core I-I Mesh File at 450 K
# Developer: Ahmed Amin Abdelhameed (Argonne National Lab)
# ========================================================
[Mesh]

##################################################################################
# Assembly Type          | Region          | Material | Block ID | Element       #
##################################################################################
# Standard FA            | Fuel Pin        | MOX      | 111      | tri           #
#                        | Fuel Gap        | Void     | 112      | quad          #
#                        | Fuel Clad       | SS316    | 113      | quad          #
#                        | Central Pin     | BeO      | 114      | tri           #
#                        | Central Gap     | Void     | 115      | quad          #
#                        | Central Clad    | SS304    | 116      | quad          #
#                        | Central Na      | Na       | 117      | quad          #
#                        | Central Duct    | SS304    | 118      | quad          #
#                        | Wire            | SS304    | 119      | tri           #
#                        | Coolant         | Na       | 120      | tri           #
#                        | Assm Duct       | SS304    | 121      | tri           #
#                        | Assm Gap        | Na       | 122      | tri           #
##################################################################################
# FA with 1 GP           | Fuel Pin        | MOX      | 211      | tri           #
#                        | GP Pin          | MOX      | 212      | tri           #
#                        | Fuel Gap        | Void     | 213      | quad          #
#                        | Fuel Clad       | SS316    | 214      | quad          #
#                        | Central Pin     | BeO      | 215      | tri           #
#                        | Central Gap     | Void     | 216      | quad          #
#                        | Central Clad    | SS304    | 217      | quad          #
#                        | Central Na      | Na       | 218      | quad          #
#                        | Central Duct    | SS304    | 219      | quad          #
#                        | Wire            | SS304    | 220      | tri           #
#                        | Coolant         | Na       | 221      | tri           #
#                        | Assm Duct       | SS304    | 222      | tri           #
#                        | Assm Gap        | Na       | 223      | tri           #
##################################################################################
# FA with 1 B4C          | Fuel Pin        | MOX      | 311      | tri           #
#                        | Fuel Gap        | Void     | 312      | quad          #
#                        | Fuel Clad       | SS316    | 313      | quad          #
#                        | Abs Central     | SS304    | 314      | tri           #
#                        | Abs Pin         | B4C      | 315      | quad          #
#                        | Abs Cladding    | SS304    | 316      | quad          #
#                        | Central Pin     | BeO      | 317      | tri           #
#                        | Central Gap     | Void     | 318      | quad          #
#                        | Central Clad    | SS304    | 319      | quad          #
#                        | Central Na      | Na       | 320      | quad          #
#                        | Central Duct    | SS304    | 321      | quad          #
#                        | Wire            | SS304    | 322      | tri           #
#                        | Coolant         | Na       | 323      | tri           #
#                        | Assm Duct       | SS304    | 324      | tri           #
#                        | Assm Gap        | Na       | 325      | tri           #
##################################################################################
# FA with 1 B4C & 1 GP   | Fuel Pin        | MOX      | 411      | tri           #
#                        | GP Pin          | UO2      | 412      | tri           #
#                        | Fuel Gap        | Void     | 413      | quad          #
#                        | Fuel Clad       | SS316    | 414      | quad          #
#                        | Abs Central     | SS304    | 415      | tri           #
#                        | Abs Pin         | B4C      | 416      | quad          #
#                        | Abs Cladding    | SS304    | 417      | quad          #
#                        | Central Pin     | BeO      | 418      | tri           #
#                        | Central Gap     | Void     | 419      | quad          #
#                        | Central Clad    | SS304    | 420      | quad          #
#                        | Central Na      | Na       | 421      | quad          #
#                        | Central Duct    | SS304    | 422      | quad          #
#                        | Wire            | SS304    | 423      | tri           #
#                        | Coolant         | Na       | 424      | tri           #
#                        | Assm Duct       | SS304    | 425      | tri           #
#                        | Assm Gap        | Na       | 426      | tri           #
##################################################################################
# FRED                   | Pin             | Void     | 511      | tri           #
#                        | Clad            | SS304    | 512      | quad          #
#                        | Central Gap     | Void     | 513      | tri           #
#                        | Duct            | SS304    | 514      | tri           #
#                        | Assm Gap        | Na       | 515      | tri           #
##################################################################################
# FA with 2GP & 1 B4C    | Fuel Pin        | MOX      | 811      | tri           #
#                        | GP Pin          | UO2      | 812      | tri           #
#                        | Fuel Gap        | Void     | 813      | quad          #
#                        | Fuel Clad       | SS316    | 814      | quad          #
#                        | Abs Central     | SS304    | 815      | tri           #
#                        | Abs Pin         | B4C      | 816      | quad          #
#                        | Abs Cladding    | SS304    | 817      | quad          #
#                        | Central Pin     | BeO      | 818      | tri           #
#                        | Central Gap     | Void     | 819      | quad          #
#                        | Central Clad    | SS304    | 820      | quad          #
#                        | Central Na      | Na       | 821      | quad          #
#                        | Central Duct    | SS304    | 822      | quad          #
#                        | Wire            | SS304    | 823      | tri           #
#                        | Coolant         | Na       | 824      | tri           #
#                        | Assm Duct       | SS304    | 825      | tri           #
#                        | Assm Gap        | Na       | 826      | tri           #
##################################################################################
# IFA                    | Fuel Pin        | MOX      | 911      | tri   & 111   #
#                        | Fuel Gap        | Void     | 912      | quad  & 112   #
#                        | Fuel Clad       | SS316    | 913      | quad  & 113   #
#                        | IFA Hole        | Void     | 914      | tri   & 9799  #
#                        | IFA Fuel        | MOX      | 915      | quad  & 979   #
#                        | IFA Fuel Gap    | Void     | 916      | quad  & 112   #
#                        | Fuel Clad       | SS316    | 917      | quad  & 113   #
#                        | Central Pin     | BeO      | 918      | tri   & 114   #
#                        | Central Gap     | Void     | 919      | quad  & 115   #
#                        | Central Clad    | SS304    | 920      | quad  & 116   #
#                        | Central Na      | Na       | 921      | quad  & 117   #
#                        | Central Duct    | SS304    | 922      | quad  & 118   #
#                        | Wire            | SS304    | 923      | tri   & 119   #
#                        | Coolant         | Na       | 924      | tri   & 120   #
#                        | Assm Duct       | SS304    | 925      | tri   & 121   #
#                        | Assm Gap        | Na       | 926      | tri   & 122   #
##################################################################################
# Downcomer IV                                          601        quad          #
# Downcomer OV                                          602        quad          #
# Radial Reflector                                      603        quad          #
# Radial Shield                                         604        quad          #
# Steel Void                                            605        quad          #
# Na-Grid Plate                                        1001&1002                 #
# Na-Steel                                             2001&2002                 #
##################################################################################

#################################################################################
#   Standard Fuel Assembly (FA #15)
#################################################################################
    [fuel_rod_15]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        #                 MOX      Void    SS316
        ring_block_ids = '111      112     113'
        preserve_volumes = on
    []
        [Tightener_Rod_15]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6  
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
        # Na
        background_block_ids = '117'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        #                 BeO     Void    SS304
        ring_block_ids = '114     115     116'
        # SS304
        duct_block_ids   = '118'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_sizes_style = 'apothem'
        preserve_volumes = on
        quad_center_elements = false
    []
    [Tightener_Rod_tr_15]
        type = TransformGenerator
        input = Tightener_Rod_15
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [side_rod_15]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        #                SS304
        ring_block_ids = '119'
        preserve_volumes = on
    []
    [FL_FA_15]
        type = FlexiblePatternGenerator
        inputs = 'fuel_rod_15 side_rod_15 Tightener_Rod_tr_15'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 0 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        # Na
        background_subdomain_id = '120'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_15]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_15'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        # SS304
        background_subdomain_id = '121'
        verify_holes = false
    []
    [FA_15]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_15'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        # Na
        background_subdomain_id = '122'
        verify_holes = false
    []
###############################################################################
#   Fuel Assemblies with 1 Guinea Pig
###############################################################################
    [gp1_fuel_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        ring_block_ids = '211      213     214'
        preserve_volumes = on
    [] 
    [gp1_GP_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.1113   1.1303  1.2319'
        ring_intervals = '1 1 1 '
        ring_block_ids = '212      213     214'
        preserve_volumes = on
    []
    [gp1_Tightener_Rod]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6  
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
        background_block_ids = '218'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        ring_block_ids = '215     216     217'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_block_ids   = '219'
        duct_sizes_style = 'apothem'
        preserve_volumes = on
        quad_center_elements = false
    []
    [gp1_Tightener_Rod_tr]
        type = TransformGenerator
        input = gp1_Tightener_Rod
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [gp1_side_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        ring_block_ids = '220'
        preserve_volumes = on
    []
    [FL_FA_9]
        type = FlexiblePatternGenerator
        inputs = 'gp1_fuel_rod gp1_side_rod gp1_Tightener_Rod_tr gp1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 3 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '221'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_9]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_9'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '222'
        verify_holes = false
    []
    [FA_9]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_9'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '223'
        verify_holes = false
    []
    [FL_FA_10]
        type = FlexiblePatternGenerator
        inputs = 'gp1_fuel_rod gp1_side_rod gp1_Tightener_Rod_tr gp1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '3 0 0 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '221'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_10]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_10'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '222'
        verify_holes = false
    []
    [FA_10]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_10'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '223'
        verify_holes = false
    []
    [FL_FA_11]
        type = FlexiblePatternGenerator
        inputs = 'gp1_fuel_rod gp1_side_rod gp1_Tightener_Rod_tr gp1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 0 0 3 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '221'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_11]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_11'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '222'
        verify_holes = false
    []
    [FA_11]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_11'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '223'
        verify_holes = false
    []
###############################################################################
#   Fuel Assemblies with 1 B4C absorber
###############################################################################
    [abs1_fuel_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        ring_block_ids = '311      312     313'
        preserve_volumes = on
    []
    [abs1_Absorber_Rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '0.80133   1.13331 1.23518'
        ring_intervals = '1 1 1'
        ring_block_ids = '314       315     316'
    []
    [abs1_Tightener_Rod]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6  
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
        background_block_ids = '320'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        ring_block_ids = '317     318     319'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_block_ids   = '321'
        duct_sizes_style = 'apothem'
        preserve_volumes = on
        quad_center_elements = false
    []
    [abs1_Tightener_Rod_tr]
        type = TransformGenerator
        input = abs1_Tightener_Rod
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [abs1_side_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        ring_block_ids = '322'
        preserve_volumes = on
    []
    [FL_FA_4]
        type = FlexiblePatternGenerator
        inputs = 'abs1_fuel_rod abs1_side_rod abs1_Tightener_Rod_tr abs1_Absorber_Rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '3 0 0 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '323'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_4]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_4'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '324'
        verify_holes = false
    []
    [FA_4]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_4'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '325'
        verify_holes = false
    []
    [FL_FA_5]
        type = FlexiblePatternGenerator
        inputs = 'abs1_fuel_rod abs1_side_rod abs1_Tightener_Rod_tr abs1_Absorber_Rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 3 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '323'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_5]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_5'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '324'
        verify_holes = false
    []
    [FA_5]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_5'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '325'
        verify_holes = false
    []
    [FL_FA_6]
        type = FlexiblePatternGenerator
        inputs = 'abs1_fuel_rod abs1_side_rod abs1_Tightener_Rod_tr abs1_Absorber_Rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 0 0 3 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '323'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_6]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_6'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '324'
        verify_holes = false
    []
    [FA_6]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_6'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '325'
        verify_holes = false
    []

    [FL_FA_7]
        type = FlexiblePatternGenerator
        inputs = 'abs1_fuel_rod abs1_side_rod abs1_Tightener_Rod_tr abs1_Absorber_Rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 0 3 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '323'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_7]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_7'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '324'
        verify_holes = false
    []
    [FA_7]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_7'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '325'
        verify_holes = false
    []

    [FL_FA_8]
        type = FlexiblePatternGenerator
        inputs = 'abs1_fuel_rod abs1_side_rod abs1_Tightener_Rod_tr abs1_Absorber_Rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 0 0 0 3'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '323'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_8]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_8'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '324'
        verify_holes = false
    []
    [FA_8]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_8'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '325'
        verify_holes = false
    []
###############################################################################
#   Fuel Assembly with 1 Guinea Pig and 1 B4C Pin
###############################################################################
##  Fuel pin
    [abs1gp1_fuel_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        ring_block_ids = '411      413     414'
        preserve_volumes = on
    []
    [abs1gp1_GP_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.1113   1.1303  1.2319'
        ring_intervals = '1 1 1 '
        ring_block_ids = '412      413     414'
         preserve_volumes = on
    []
    [abs1gp1_Absorber_Rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '0.80133   1.13331 1.23518'
        ring_intervals = '1 1 1'
        ring_block_ids = '415      416     417'
        preserve_volumes = on
    []
    [abs1gp1_Tightener_Rod]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6  
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
        background_block_ids = '421'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        ring_block_ids = '418     419     420'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_block_ids   = '422'
        duct_sizes_style = 'apothem'
        preserve_volumes = on
        quad_center_elements = false
    
    []
    [abs1gp1_Tightener_Rod_tr]
        type = TransformGenerator
        input = abs1gp1_Tightener_Rod
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [abs1gp1_side_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        ring_block_ids = '423 '
        preserve_volumes = on
    []
    [FL_FA_13]
        type = FlexiblePatternGenerator
        inputs = 'abs1gp1_fuel_rod abs1gp1_side_rod abs1gp1_Tightener_Rod_tr abs1gp1_Absorber_Rod abs1gp1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '3 4 0 0 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '424'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_13]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_13'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '425'
        verify_holes = false
    []
    [FA_13]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_13'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '426'
        verify_holes = false
    []

    [FL_FA_14]
        type = FlexiblePatternGenerator
        inputs = 'abs1gp1_fuel_rod abs1gp1_side_rod abs1gp1_Tightener_Rod_tr abs1gp1_Absorber_Rod abs1gp1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 3 4 0 0'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '424'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_14]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_14'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '425'
        verify_holes = false
    []
    [FA_14]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_14'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '426'
        verify_holes = false
    []

###############################################################################
#   FRED
###############################################################################
    [Fred_Device]
           type = AdvancedConcentricCircleGenerator
           num_sectors = 24
           ring_radii = '1.75726 2.11381'
           ring_intervals = '1  1 '
           ring_block_ids   = '511       512'
           preserve_volumes = on
    []
    [FRED_FA]
        type = FlexiblePatternGenerator
        inputs = 'Fred_Device'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id    = '513'
        verify_holes = false
    []
    [FRED_FA_d]
        type = FlexiblePatternGenerator
        inputs = 'FRED_FA'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '514'
        verify_holes = false
    []
    [FA_1]
        type = FlexiblePatternGenerator
        inputs = 'FRED_FA_d'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '515'
        verify_holes = false
    []
    
###############################################################################
#   Fuel Assembly with 2 Guinea Pig and 1 B4C Pin
###############################################################################
    [gp2abs1_fuel_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        ring_block_ids = '811      813     814'
        preserve_volumes = on
    
    []
    [gp2abs1_GP_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.1113   1.1303  1.2319'
        ring_intervals = '1 1 1 '
        ring_block_ids   = '812      813     814'
        preserve_volumes = on
    []
    [gp2abs1_Absorber_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.80133   1.13331 1.23518'
        ring_intervals = '1 1 1'
        ring_block_ids   = '815      816     817'
        preserve_volumes = on
    []
     [gp2abs1_Tightener_Rod]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
        background_block_ids = '821'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        ring_block_ids   = '818     819     820'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_sizes_style = 'apothem'
        preserve_volumes = on
        quad_center_elements = false
        duct_block_ids   = '822'
    []
    [gp2abs1_Tightener_Rod_tr]
        type = TransformGenerator
        input = gp2abs1_Tightener_Rod
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [gp2abs1_side_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        ring_block_ids = '823'
        preserve_volumes = on
    []
    [FL_FA_12]
        type = FlexiblePatternGenerator
        inputs = 'gp2abs1_fuel_rod gp2abs1_side_rod gp2abs1_Tightener_Rod_tr gp2abs1_Absorber_rod gp2abs1_GP_rod'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '3 0 0 0 4 4'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '824'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [Standard_FA_d_12]
        type = FlexiblePatternGenerator
        inputs = 'FL_FA_12'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
         background_subdomain_id = '825'
        verify_holes = false
    []
    [FA_12]
        type = FlexiblePatternGenerator
        inputs = 'Standard_FA_d_12'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '826'
        verify_holes = false
    []
###############################################################################
#  IFA
###############################################################################

    [IFA_fuel_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 36
        ring_radii = '1.11426  1.13331 1.23518'
        ring_intervals = '1 1 1 '
        ring_block_ids   = '911      912     913'
        preserve_volumes = on
    []
    [IFA_FuelRod_w_IFA]
            type = AdvancedConcentricCircleGenerator
            num_sectors = 36
            ring_radii = '0.184690 1.11426  1.13331 1.23518'
            ring_intervals = '1 1 1 1'
            ring_block_ids = '914  915   916   917'
            preserve_volumes = on
    []
    [IFA_Tightener_Rod]
        type = PolygonConcentricCircleMeshGenerator
        num_sides = 6  
        num_sectors_per_side = '6 6 6 6 6 6'
        background_intervals = 1
         background_block_ids   = '921'
        polygon_size = 1.31158
        ring_radii = '0.98942 1.01239 1.11426'
        ring_intervals = '1 1 1'
        ring_block_ids   = '918     919     920'
        duct_sizes = '1.22244'
        duct_intervals = '1'
        duct_sizes_style = 'apothem'
        duct_block_ids   = '922'
        preserve_volumes = on
        quad_center_elements = false
    []
    [IFA_Tightener_Rod_tr]
        type = TransformGenerator
        input = IFA_Tightener_Rod
        transform = ROTATE
        vector_value = '90. 0. 0.'
    []
    [IFA_side_rod]
        type = AdvancedConcentricCircleGenerator
        num_sectors = 12
        ring_radii = '0.31834'
        ring_intervals = '1'
        ring_block_ids   = '923'
        preserve_volumes = on
    []
    [IFA]
        type = FlexiblePatternGenerator
        inputs = 'IFA_fuel_rod IFA_side_rod IFA_Tightener_Rod_tr IFA_FuelRod_w_IFA'
        boundary_type = HEXAGON
        boundary_size = '7.71667'
        boundary_sectors = 10
        circular_patterns = '0 0 3 0 0 3'
        circular_radii = '2.7813'
        circular_rotations = 90
        desired_area = 0.05
        background_subdomain_id = '924'
        rect_pitches_x = 3.47540
        rect_pitches_y = 5.9182
        rect_patterns = '1 1;
                         1 1'
        extra_positions = '3.47540 0.0 0.0
                          -3.47540 0.0 0.0
                           0.0 0.0 0.0'
        extra_positions_mg_indices = '1 1 2'
        verify_holes = false
    []
    [IFA_d]
        type = FlexiblePatternGenerator
        inputs = 'IFA'
        boundary_type = HEXAGON
        boundary_size = '8.02228'
        boundary_sectors = 10
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '925'
        verify_holes = false
    []
    [FA_2]
        type = FlexiblePatternGenerator
        inputs = 'IFA_d'
        boundary_type = HEXAGON
        boundary_size = '8.04775'
        boundary_sectors = 12
        extra_positions = '0.0 0.0 0.0'
        extra_positions_mg_indices = '0'
        background_subdomain_id = '926'
        verify_holes = false
    []

###############################################################################
#  Dummy
###############################################################################
  [dummy]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = '6 6 6 6 6 6'
    hexagon_size = 4.023875

    background_intervals = 1
    background_block_ids = '999'

    sides_to_adapt = '0 1 2 3 4 5'
    meshes_to_adapt_to = 'FA_15
                          FA_15
                          FA_15
                          FA_15
                          FA_15
                          FA_15'
  []
[core]
    type = PatternedHexMeshGenerator
    inputs = 'FA_1 FA_2 dummy FA_4 FA_5 FA_6 FA_7 FA_8 FA_9 FA_10 FA_11 FA_12 FA_13 FA_14 FA_15'
    pattern_boundary = none
    generate_core_metadata = true
    pattern =
    '                2   2   2   2   2   2   2   2;
                  2   2   2  14  14  14   2   2   2;
                2   2   1  14  14  14  14  14   2   2;
              2  14  14   4  14  13  14   5  14  14   2;
            2  14  14  14  14  14  14  14  14  14  14   2;
          2  14  14  14  10  14  14  14  14  14  14  14   2;
        2   2  14  14  14   6  14  14   3   8  14  14   2   2;
      2   2  14   3  14  14  14   0  14  14  14   3  14   2   2;
        2   2  14  14  14  14   1  14  14  14  14  14   2   2;
          2  14  14  11  14  14   7  14  14  12  14  14   2;
            2  14  14  14  14   9  14  14  14  14  14   2;
              2  14  14   5  14  14  14   4  14  14   2;
                2   2  14  14  14  14  14  14   2   2;
                  2   2   2  14  14  14   2   2   2;
                    2   2   2   2   2   2   2   2'
                    
    rotate_angle = 90
[]

[del_dummy]
    type = BlockDeletionGenerator
    input = 'core'
    block = '999'
    new_boundary = 10000
  []

  [downcomer_iv]
    type = PeripheralRingMeshGenerator
    input = 'del_dummy'

    peripheral_layer_num   = 2
    peripheral_ring_radius = 53.486
    peripheral_ring_block_id =  '601'
    input_mesh_external_boundary = 10000
  []

  [downcomer_ov]
    type = PeripheralRingMeshGenerator
    input = 'downcomer_iv'

    peripheral_layer_num   = 1
    peripheral_ring_radius = 58.4860
    peripheral_ring_block_id =  '602'
    input_mesh_external_boundary = 10000
  []

  [radial_reflector]
    type = PeripheralRingMeshGenerator
    input = 'downcomer_ov'

    peripheral_layer_num   = 2
    peripheral_ring_radius = 73.5530
    peripheral_ring_block_id =  '603'
    input_mesh_external_boundary = 10000
  []

  [radial_shield]
    type = PeripheralRingMeshGenerator
    input = 'radial_reflector'

    peripheral_layer_num   = 1
    peripheral_ring_radius = 87.0340
    peripheral_ring_block_id =  '604'
    input_mesh_external_boundary = 10000
  []

  [core_3d]
    type = AdvancedExtruderGenerator
    input = 'radial_shield'
    heights    = '30.745    8.890    0.953    0.918    0.953    33.849    0.953    6.351    0.953    8.569    1.714    0.953    3.175    0.953    0.354    0.953    6.981    0.953    17.859    6.398    0.952    0.510    0.952    9.298    20.239'
    num_layers = '6       2    1    1    1    6    1    2    1    2    1    1    1    1    1    1    2    1    3    2    1    1    1    2    4'
    direction  = '0 0 1'
    subdomain_swaps =   '111    1001    112    1002    113    1002    114    1001    115    1002    116    1002    117    1002    118    1002    119    1001    120    1001    121    1001    122    1001
                 211    1001    212    1001    213    1002    214    1002    215    1001    216    1002    217    1002    218    1002    219    1002    220    1001    221    1001    222    1001    223    1001
                 311    1001    312    1002    313    1002    314    1001    315    1002    316    1002    317    1001    318    1002    319    1002    320    1002    321    1002    322    1001    323    1001    324    1001    325    1001
                 411    1001    412    1001    413    1002    414    1002    415    1001    416    1002    417    1002    418    1001    419    1002    420    1002    421    1002    422    1002    423    1001    424    1001    425    1001    426    1001
                 511    1001    512    1002    513    1001    514    1001    515    1001
                 811    1001    812    1001    813    1002    814    1002    815    1001    816    1002    817    1002    818    1001    819    1002    820    1002    821    1002    822    1002    823    1001    824    1001    825    1001    826    1001
                 911    1001    912    1002    913    1002    914    1001    915    1002    916    1002    917    1002    918    1001    919    1002    920    1002    921    1002    922    1002    923    1001    924    1001    925    1001    926    1001
                 603    605;

                 111    131        112    132        113    133        114    134        115    135        116    136        117    137        118    138        119    139        120    140     121    141        122    142
                 211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                 311    331     312    332     313    333     314    334        315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                 411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                 511    531     512    532     513    533     514    534     515    535
                 811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                 911    131      912    132     913    133     914    131     915    155     916    132     917    133     918    134     919    135     920    136     921    137     922    138     923    139     924    140     925    141     926    142
                 ;

                  111    131        112    132        113    133        114    134        115    135        116    136        117    137        118    138        119    139        120    140    121    141        122    142
                  211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                  311    331     312    332     313    333     314    334        315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                  411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                  511    531     512    532     513    533     514    534     515    535
                  811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                  911    931     912    932     913    933     914    934     915    935     916    936     917    937     918    938     919    939     920    940     921    941     922    942     923    943     924    944     925    945     926    946
                   ;

                 111    131     112    132     113    133     114    134     115    135     116    136     117    137     118    138     119    139     120    140     121    141     122    142
                 211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                 311    331     312    332     313    333     314    334     315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                 411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                 511    531     512    532     513    533     514    534     515    535
                 811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                 911    947     912    948     913    949     914    950     915    951     916    952     917    953     918    954     919    955     920    956     921    957     922    958     923    959     924    960        925    961     926    962
                 ;

                 111    143      112    144        113    145      114    146     115    147     116    148     117    149     118    150     119    151     120    152     121    153     122    154
                 211    143     212    143     213    144     214    145     215    146     216    147     217    148     218    149     219    150     220    151     221    152     222    153     223    154
                 311    346     312    347     313    348        314    349     315    350     316    351     317    352     318    353     319    354     320    355     321    356     322    357     323    358        324    359       325    360
                 411    346     412    346     413    347     414    348     415    349     416    350     417    351     418    352     419    353     420    354     421    355     422    356     423    357     424    358     425    359     426    360
                 511    531     512    532     513    533     514    534     515    535
                 811    346     812    346     813    347     814    348     815    349     816    350     817    351     818    352     819    353     820    354     821    355     822    356     823    357     824    358     825    359     826    360
                 911    963     912    964     913    965     914    966     915    967     916    968     917    969     918    970     919    971     920    972     921    973     922    974     923    975     924    976     925    977     926    978
                 ;

                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363     314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432     413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    111      912    112    913    113     914    9799    915    979     916    112     917    113     918    114     919    115     920    116     921    117     922    118     923    119     924    120     925    121     926    122
                  ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363     314    364     315    365     316    366     317    367     318    368     319    369     320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432     413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    980     912    981     913    982     914    983     915    984     916    985     917    986     918    987     919    988     920    989     921    990     922    991     923    992     924    993     925    994     926    995
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1031    912    1032    913    1033    914    1034    915    1035    916    1036    917    1037    918    1038    919    1039    920    1040    921    1041    922    1042    923    1043    924    1044    925    1045    926    1046
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363     314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432     413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1047    912    1048    913    1049    914    1050    915    1051    916    1052    917    1053    918    1054    919    1055    920    1056    921    1057    922    1058    923    1059    924    1060    925    1061    926    1062
                 ;

                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    111      912    112     913    113     914    111     915    979     916    112     917    113     918    114     919    115     920    116     921    117     922    118     923    119     924    120     925    121     926    122;

                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1063    912    1064    913    1065    914    1066    915    1067    916    1068    917    1069    918    1070    919    1071    920    1072    921    1073    922    1074    923    1075    924    1076    925    1077    926    1078
                 ;
                 111    143      112    144        113    145      114    146     115    147     116    148     117    149     118    150     119    151     120    152     121    153     122    154
                 211    143     212    143     213    144     214    145     215    146     216    147     217    148     218    149     219    150     220    151     221    152     222    153     223    154
                 311    346     312    347     313    348        314    349     315    350     316    351     317    352     318    353     319    354     320    355     321    356     322    357     323    358        324    359       325    360
                 411    346     412    346     413    347     414    348     415    349     416    350     417    351     418    352     419    353     420    354     421    355     422    356     423    357     424    358     425    359     426    360
                 511    531     512    532     513    533     514    534     515    535
                 811    346     812    346     813    347     814    348     815    349     816    350     817    351     818    352     819    353     820    354     821    355     822    356     823    357     824    358     825    359     826    360
                 911    1079    912    1080    913    1081    914    1082    915    1083    916    1084    917    1085    918    1086    919    1087    920    1088    921    1089    922    1090    923    1091    924    1092    925    1093    926    1094
                 ;


                 111    156     112    157     113    158     114    159     115    160     116    161     117    162     118    163     119    164     120    165     121    166     122    167
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    376        312    377        313    378        314    379        315    380     316    381     317    382     318    383     319    384     320    385     321    386     322    387     323    388     324    389     325    390
                 411    376     412    376     413    377     414    378     415    379     416    380     417    381     418    382     419    383     420    384     421    385     422    386     423    387     424    388     425    389     426    390
                 511    531     512    532     513    533     514    534     515    535
                 811    376     812    376     813    377     814    378     815    379     816    380     817    381     818    382     819    383     820    384     821    385     822    386     823    387     824    388     825    389     826    390
                 911    1095    912    1096    913    1097    914    1098    915    1099    916    1100    917    1101    918    1102    919    1103    920    1104    921    1105    922    1106    923    1107    924    1108    925    1109    926    1110
                 ;
                 111    143      112    144        113    145      114    146     115    147     116    148     117    149     118    150     119    151     120    152     121    153     122    154
                 211    143     212    143     213    144     214    145     215    146     216    147     217    148     218    149     219    150     220    151     221    152     222    153     223    154
                 311    346     312    347     313    348        314    349     315    350     316    351     317    352     318    353     319    354     320    355     321    356     322    357     323    358        324    359       325    360
                 411    346     412    346     413    347     414    348     415    349     416    350     417    351     418    352     419    353     420    354     421    355     422    356     423    357     424    358     425    359     426    360
                 511    531     512    532     513    533     514    534     515    535
                 811    346     812    346     813    347     814    348     815    349     816    350     817    351     818    352     819    353     820    354     821    355     822    356     823    357     824    358     825    359     826    360
                 911    1111    912    1112    913    1113    914    1114    915    1115    916    1116    917    1117    918    1118    919    1119    920    1120    921    1121    922    1122    923    1123    924    1124    925    1125    926    1126
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1127    912    1128    913    1129    914    1130    915    1131    916    1132    917    1133    918    1134    919    1135    920    1136    921    1137    922    1138    923    1139    924    1140    925    1141    926    1142
                 ;

                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1143    912    1144    913    1145    914    1146    915    1147    916    1148    917    1149    918    1150    919    1151    920    1152    921    1153    922    1154    923    1155    924    1156    925    1157    926    1158
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1159    912    1160    913    1161    914    1162    915    1163    916    1164    917    1165    918    1166    919    1167    920    1168    921    1169    922    1170    923    1171    924    1172    925    1173    926    1174
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1175    912    1176    913    1177    914    1178    915    1179    916    1180    917    1181    918    1182    919    1183    920    1184    921    1185    922    1186    923    1187    924    1188    925    1189    926    1190
                 ;
                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    111      912    112     913    113     914    111     915    979     916    112     917    113     918    114     919    115     920    116     921    117     922    118     923    119     924    120     925    121     926    122
                 ;

                 111    111     112    112     113    113     114    114     115    115     116    116     117    117     118    118     119    119     120    120     121    121     122    122
                 211    231     212    232     213    233     214    234     215    235     216    236     217    237     218    238     219    239     220    240     221    241     222    242     223    243
                 311    361     312    362     313    363        314    364     315    365     316    366     317    367      318    368      319    369      320    370     321    371     322    372     323    373     324    374     325    375
                 411    431     412    432        413    433     414    434     415    435     416    436     417    437     418    438     419    439     420    440     421    441     422    442     423    443     424    444     425    445     426    446
                 511    531     512    532     513    533     514    534     515    535
                 811    831     812    832     813    833     814    834     815    835     816    836     817    837     818    838     819    839     820    840     821    841     822    842     823    843     824    844     825    845     826    846
                 911    1191    912    1192    913    1193    914    1194    915    1195    916    1196    917    1197    918    1198    919    1199    920    1200    921    1201    922    1202    923    1203    924    1204    925    1205    926    1206
                 ;
                 111    143      112    144        113    145      114    146     115    147     116    148     117    149     118    150     119    151     120    152     121    153     122    154
                 211    143     212    143     213    144     214    145     215    146     216    147     217    148     218    149     219    150     220    151     221    152     222    153     223    154
                 311    346     312    347     313    348        314    349     315    350     316    351     317    352     318    353     319    354     320    355     321    356     322    357     323    358        324    359       325    360
                 411    346     412    346     413    347     414    348     415    349     416    350     417    351     418    352     419    353     420    354     421    355     422    356     423    357     424    358     425    359     426    360
                 511    531     512    532     513    533     514    534     515    535
                 811    346     812    346     813    347     814    348     815    349     816    350     817    351     818    352     819    353     820    354     821    355     822    356     823    357     824    358     825    359     826    360
                 911    1207    912    1208    913    1209    914    1210    915    1211    916    1212    917    1213    918    1214    919    1215    920    1216    921    1217    922    1218    923    1219    924    1220    925    1221    926    1222
                 ;
                 111    131        112    132        113    133        114    134        115    135        116    136        117    137        118    138        119    139        120    140     121    141        122    142
                 211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                 311    331     312    332     313    333     314    334        315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                 411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                 511    531     512    532     513    533     514    534     515    535
                 811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                 911    1223    912    1224    913    1225    914    1226    915    1227    916    1228    917    1229    918    1230    919    1231    920    1232    921    1233    922    1234    923    1235    924    1236    925    1237    926    1238
                 ;
                 111    131        112    132        113    133        114    134        115    135        116    136        117    137        118    138        119    139        120    140     121    141        122    142
                 211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                 311    331     312    332     313    333     314    334        315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                 411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                 511    531     512    532     513    533     514    534     515    535
                 811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                 911    1239    912    1240    913    1241    914    1242    915    1243    916    1244    917    1245    918    1246    919    1247    920    1248    921    1249    922    1250    923    1251    924    1252    925    1253    926    1254
                 ;

                 111    131        112    132        113    133        114    134        115    135        116    136        117    137        118    138        119    139        120    140     121    141        122    142
                 211    131     212    131     213    132     214    133     215    134     216    135     217    136     218    137     219    138     220    139     221    140     222    141        223    142
                 311    331     312    332     313    333     314    334        315    335     316    336     317    337     318    338     319    339     320    340     321    341     322    342     323    343     324    344     325    345
                 411    331     412    331     413    332     414    333     415    334     416    335     417    336     418    337     419    338     420    339     421    340     422    341     423    342     424    343     425    344     426    345
                 511    531     512    532     513    533     514    534     515    535
                 811    331     812    331     813    332     814    333     815    334     816    335     817    336     818    337     819    338     820    339     821    340     822    341     823    342     824    343     825    344     826    345
                 911    131      912    132     913    133     914    131     915    155     916    132     917    133     918    134     919    135     920    136     921    137     922    138     923    139     924    140     925    141     926    142
                 ;
                 111    2001    112    2002    113    2002    114    2001    115    2002    116    2002    117    2002    118    2002    119    2001    120    2001    121    2001    122    2001
                 211    2001    212    2001    213    2002    214    2002    215    2001    216    2002    217    2002    218    2002    219    2002    220    2001    221    2001    222    2001    223    2001
                 311    2001    312    2002    313    2002    314    2001    315    2002    316    2002    317    2001    318    2002    319    2002    320    2002    321    2002    322    2001    323    2001    324    2001    325    2001
                 411    2001    412    2001    413    2002    414    2002    415    2001    416    2002    417    2002    418    2001    419    2002    420    2002    421    2002    422    2002    423    2001    424    2001    425    2001    426    2001
                 511    531     512    532     513    533     514    534     515    535
                 811    2001    812    2001    813    2002    814    2002    815    2001    816    2002    817    2002    818    2001    819    2002    820    2002    821    2002    822    2002    823    2001    824    2001    825    2001    826    2001
                 911    2001    912    2002    913    2002    914    2001    915    2002    916    2002    917    2002    918    2001    919    2002    920    2002    921    2002    922    2002    923    2001    924    2001    925    2001    926    2001
                 603    605'

    top_boundary = 20000
    bottom_boundary = 30000
  []
  final_generator = 'core_3d'
[]

