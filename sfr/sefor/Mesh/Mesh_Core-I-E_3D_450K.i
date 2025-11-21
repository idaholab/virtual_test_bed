################################################################################
## NEAMS Fast Reactor Application Driver                                      ##
## SEFOR Mesh Generation                                                      ##
## Input File Using MOOSE Reactor Module Mesh Generators                      ##
## Mesh Modification Input File for Griffin                                   ##
## Please contact the authors for mesh generation issues:                     ##
## - Dr. Donny Hartanto (hartantod.at.ornl.gov)                               ##
################################################################################

[Mesh]
### Block ID
#######################################################
# Fuel Assembly         Region        Mat      Block ID
#######################################################
# Standard FA           Fuel Pin      MOX        110 111
#                       Fuel Gap      Void       112
#                       Fuel Clad     SS316      113
#                       Central Pin   BeO        114 115
#                       Central gap   Void       116
#                       Central Clad  SS316      117
#                       Central Na    Na         118
#                       Central Duct  SS304      119
#                       Wire          SS304      120
#                       Coolant       Na         121
#                       Assm Duct     SS304      122
#                       Assm Gap      Na         123
# FA with 2 GP          Fuel Pin      MOX        210 211
#                       GP Pin        MOX        212 213
#                       Fuel Gap      Void       214
#                       Fuel Clad     SS316      215
#                       Central Pin   BeO        216 217
#                       Central gap   Void       218
#                       Central Clad  SS316      219
#                       Central Na    Na         220
#                       Central Duct  SS304      221
#                       Wire          SS304      222
#                       Coolant       Na         223
#                       Assm Duct     SS304      224
#                       Assm Gap      Na         225
# FA with 1 B4C         Fuel Pin      MOX        310 311
#                       Fuel Gap      Void       312
#                       Fuel Clad     SS316      313
#                       Abs Central   SS304      314 315
#                       Abs Pin       B4C        316
#                       Abs Cladding  SS316      317
#                       Central Pin   BeO        318 319
#                       Central gap   Void       320
#                       Central Clad  SS316      321
#                       Central Na    Na         322
#                       Central Duct  SS304      323
#                       Wire          SS304      324
#                       Coolant       Na         325
#                       Assm Duct     SS304      326
#                       Assm Gap      Na         327
# FA with 1 B4C & 1 GP  Fuel Pin      MOX        410 411
#                       GP Pin        UO2        412 413
#                       Fuel Gap      Void       414
#                       Fuel Clad     SS316      415
#                       Abs Central   SS304      416 417
#                       Abs Pin       B4C        418
#                       Abs Cladding  SS316      419
#                       Central Pin   BeO        420 421
#                       Central gap   Void       422
#                       Central Clad  SS316      423
#                       Central Na    Na         424
#                       Central Duct  SS304      425
#                       Wire          SS304      426
#                       Coolant       Na         427
#                       Assm Duct     SS304      428
#                       Assm Gap      Na         429
# FRED                  Pin           Void       510 511
#                       Clad          SS304      512
#                       Central Gap   Void       513
#                       Duct          SS304      514
#                       Assm Gap      Na         515
# Downcomer IV                                   601
# Downcomer OV                                   602
# Radial Reflector                               603
# Radial Shield                                  604
# Steel Void                                     605
# Na-Grid Plate                                 1001 1002
# Na-steel                                      2001 2002

accg_num_sectors = 12
wire_num_sectors = 8
hmg_num_sector_per_side = '2 2 2 2 2 2'
num_boundary_sectors = 6

###############################################################################
#   Standard Fuel Assembly
###############################################################################
##  Fuel pin
  [std_fuel_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '110 111  112     113'
    preserve_volumes = on
  []
# Central pin
  [std_central_pin_w_duct]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = ${hmg_num_sector_per_side}
    hexagon_size = 1.31158
#                       beo     gap     ss316
    ring_radii       = '0.98942 1.01239 1.11426'
    ring_intervals   = '2       1       1'
    ring_block_ids   = '114 115 116     117'
    background_intervals   = 1
    background_block_ids   = '118'
    duct_sizes       = '1.22244'
    duct_sizes_style = apothem
    duct_block_ids   = '119'
    duct_intervals   = '1'
    flat_side_up = true
    preserve_volumes = on
  []
# Wire pin
  [std_wire]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${wire_num_sectors}
#                       ss304
    ring_radii       = '0.31834'
    ring_intervals   = '1'
    ring_block_ids   = '120'
    preserve_volumes = on
  []

# Standard Fuel assembly
  [std_assm]
    type   = FlexiblePatternGenerator
    inputs = 'std_fuel_pin std_wire std_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 0 0 0 0;
                          1 1 1 1 1 1'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id   = '121'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '2'
  []
  [std_assm_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'std_assm'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '122'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [std_assm_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'std_assm_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id   = '123'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

###############################################################################
#   Fuel Assembly with 2 Guinea Pigs
###############################################################################
##  Fuel pin
  [gp2_fuel_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '210 211  214     215'
    preserve_volumes = on
  []
# GP Pin
  [gp2_gp_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '212 213  214     215'
    preserve_volumes = on
  []
# Central pin
  [gp2_central_pin_w_duct]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = ${hmg_num_sector_per_side}
    hexagon_size = 1.31158
#                       beo     gap     ss316
    ring_radii       = '0.98942 1.01239 1.11426'
    ring_intervals   = '2       1       1'
    ring_block_ids   = '216 217 218     219'
    background_intervals   = 1
    background_block_ids   = '220'
    duct_sizes       = '1.22244'
    duct_sizes_style = apothem
    duct_block_ids   = '221'
    duct_intervals   = '1'
    flat_side_up = true
    preserve_volumes = on
  []
# Wire pin
  [gp2_wire]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${wire_num_sectors}
#                       ss304
    ring_radii       = '0.31834'
    ring_intervals   = '1'
    ring_block_ids   = '222'
    preserve_volumes = on
  []

# standard fuel assembly with 2 GPs on top left (assembly 12)
  [assm12]
    type   = FlexiblePatternGenerator
    inputs = 'gp2_fuel_pin gp2_gp_pin gp2_wire gp2_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '1 0 0 0 0 1;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '223'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm12_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm12'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id    = '224'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm12_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm12_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '225'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 2 GPs on top right (assembly 13)
  [assm13]
    type   = FlexiblePatternGenerator
    inputs = 'gp2_fuel_pin gp2_gp_pin gp2_wire gp2_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 0 1 1 0;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '223'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm13_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm13'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '224'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm13_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm13_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '225'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

###############################################################################
#   Fuel Assembly with 1 B4C absorber
###############################################################################
##  Fuel pin
  [abs1_fuel_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '310 311  312     313'
    preserve_volumes = on
  []
# Absorber Pin
  [abs1_abs_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       ss304     b4c     ss316
    ring_radii       = '0.80133   1.13331 1.23518'
    ring_intervals   = '2         1       1'
    ring_block_ids   = '314 315   316     317'
    preserve_volumes = on
  []
# Central pin
  [abs1_central_pin_w_duct]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = ${hmg_num_sector_per_side}
    hexagon_size = 1.31158
#                       beo     gap     ss316
    ring_radii       = '0.98942 1.01239 1.11426'
    ring_intervals   = '2       1       1'
    ring_block_ids   = '318 319 320     321'
    background_intervals   = 1
    background_block_ids   = '322'
    duct_sizes       = '1.22244'
    duct_sizes_style = apothem
    duct_block_ids   = '323'
    duct_intervals   = '1'
    flat_side_up = true
    preserve_volumes = on
  []
# Wire pin
  [abs1_wire]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${wire_num_sectors}
#                       ss304
    ring_radii       = '0.31834'
    ring_intervals   = '1'
    ring_block_ids   = '324'
    preserve_volumes = on
  []

# standard fuel assembly with 1 B4C on top right (assembly 21)
  [assm21]
    type   = FlexiblePatternGenerator
    inputs = 'abs1_fuel_pin abs1_abs_pin abs1_wire abs1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 0 0 1 0;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '325'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm21_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm21'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '326'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm21_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm21_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '327'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 1 B4C on top right (assembly 23)
  [assm23]
    type   = FlexiblePatternGenerator
    inputs = 'abs1_fuel_pin abs1_abs_pin abs1_wire abs1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '1 0 0 0 0 0;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '325'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm23_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm23'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '326'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm23_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm23_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '327'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 1 B4C on bottom left (assembly 24)
  [assm24]
    type   = FlexiblePatternGenerator
    inputs = 'abs1_fuel_pin abs1_abs_pin abs1_wire abs1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 1 0 0 0 0;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '325'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm24_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm24'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '326'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm24_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm24_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '327'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 1 B4C on bottom right (assembly 25)
  [assm25]
    type   = FlexiblePatternGenerator
    inputs = 'abs1_fuel_pin abs1_abs_pin abs1_wire abs1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 1 0 0 0;
                          2 2 2 2 2 2'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '325'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '3'
  []
  [assm25_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm25'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '326'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm25_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm25_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '327'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

###############################################################################
#   Fuel Assembly with 1 Guinea Pig and 1 B4C Pin
###############################################################################
##  Fuel pin
  [abs1gp1_fuel_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '410 411  414     415'
    preserve_volumes = on
  []
# GP Pin
  [abs1gp1_gp_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       fuel     gap     ss316
    ring_radii       = '1.11426  1.13331 1.23518'
    ring_intervals   = '2        1       1'
    ring_block_ids   = '412 413  414     415'
    preserve_volumes = on
  []
# Absorber Pin
  [abs1gp1_abs_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       ss304     b4c     ss316
    ring_radii       = '0.80133   1.13331 1.23518'
    ring_intervals   = '2         1       1'
    ring_block_ids   = '416 417   418     419'
    preserve_volumes = on
  []
# Central pin
  [abs1gp1_central_pin_w_duct]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = ${hmg_num_sector_per_side}
    hexagon_size = 1.31158
#                       beo     gap     ss316
    ring_radii       = '0.98942 1.01239 1.11426'
    ring_intervals   = '2       1       1'
    ring_block_ids   = '420 421 422     423'
    background_intervals   = 1
    background_block_ids   = '424'
    duct_sizes       = '1.22244'
    duct_sizes_style = apothem
    duct_block_ids   = '425'
    duct_intervals   = '1'
    flat_side_up = true
    preserve_volumes = on
  []
# Wire pin
  [abs1gp1_wire]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${wire_num_sectors}
#                       ss304
    ring_radii       = '0.31834'
    ring_intervals   = '1'
    ring_block_ids   = '426'
    preserve_volumes = on
  []

# standard fuel assembly with 1 B4C rod at top left and 1 GP rod at top right (assembly 41)
  [assm41]
    type   = FlexiblePatternGenerator
    inputs = 'abs1gp1_fuel_pin abs1gp1_gp_pin abs1gp1_abs_pin abs1gp1_wire abs1gp1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 0 0 1 2;
                          3 3 3 3 3 3'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '427'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '4'
  []
  [assm41_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm41'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '428'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm41_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm41_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '429'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 1 B4C rod at right and 1 GP rod at bottom right (assembly 42)
  [assm42]
    type   = FlexiblePatternGenerator
    inputs = 'abs1gp1_fuel_pin abs1gp1_gp_pin abs1gp1_abs_pin abs1gp1_wire abs1gp1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '0 0 1 2 0 0;
                          3 3 3 3 3 3'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '427'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '4'
  []
  [assm42_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm42'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '428'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm42_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm42_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '429'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# standard fuel assembly with 1 B4C rod at bottom left and 1 GP rod at left (assembly 43)
  [assm43]
    type   = FlexiblePatternGenerator
    inputs = 'abs1gp1_fuel_pin abs1gp1_gp_pin abs1gp1_abs_pin abs1gp1_wire abs1gp1_central_pin_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
    circular_patterns  = '1 2 0 0 0 0;
                          3 3 3 3 3 3'
    circular_radii     = '2.78130 3.47540'
    circular_rotations = '90 0'
#                                Na
    background_subdomain_id    = '427'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '4'
  []
  [assm43_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'assm43'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id   = '428'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [assm43_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'assm43_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '429'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# FRED
  [fred_pin]
    type = AdvancedConcentricCircleGenerator
    num_sectors = ${accg_num_sectors}
#                       Void      SS316
    ring_radii       = '1.75726   2.11381'
    ring_intervals   = '2         1'
    ring_block_ids   = '510 511   512'
    preserve_volumes = on
  []
  [fred]
    type   = FlexiblePatternGenerator
    inputs = 'fred_pin'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 7.71667
#                                Void
    background_subdomain_id    = '513'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [fred_w_duct]
    type   = FlexiblePatternGenerator
    inputs = 'fred'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.02228
#                                Duct
    background_subdomain_id    = '514'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []
  [fred_w_duct_gap]
    type = FlexiblePatternGenerator
    inputs = 'fred_w_duct'
    use_auto_area_func = true
    boundary_type    = hexagon
    boundary_sectors = ${num_boundary_sectors}
    boundary_size    = 8.04775
#                                Na
    background_subdomain_id    = '515'
    extra_positions            = '0.0 0.0 0.0'
    extra_positions_mg_indices = '0'
  []

# Dummy mesh to fill core lattice
  [dummy]
    type = HexagonConcentricCircleAdaptiveBoundaryMeshGenerator
    num_sectors_per_side = ${hmg_num_sector_per_side}
    hexagon_size = 4.023875

    background_intervals = 1
    background_block_ids = '999'

    sides_to_adapt = '0 1 2 3 4 5'
    meshes_to_adapt_to = 'std_assm_w_duct_gap
                          std_assm_w_duct_gap
                          std_assm_w_duct_gap
                          std_assm_w_duct_gap
                          std_assm_w_duct_gap
                          std_assm_w_duct_gap'
  []

  [pattern_core]
    type = PatternedHexMeshGenerator
    inputs = 'fred_w_duct_gap   std_assm_w_duct_gap assm12_w_duct_gap
              assm13_w_duct_gap assm21_w_duct_gap   assm23_w_duct_gap
              assm24_w_duct_gap assm25_w_duct_gap   assm41_w_duct_gap
              assm42_w_duct_gap assm43_w_duct_gap   dummy'
    pattern_boundary = none
    generate_core_metadata = true

    pattern = '              11  11  11  11  11  11  11  11  11;
                           11  11  11  11  11  11  11  11  11  11;
                         11  11  11  11  1   1   1   11  11  11  11;
                       11  11  11  1   1   1   7   1   1   11  11  11;
                     11  11  1   1   4   1   3   1   1   1   1   11  11;
                   11  11  1   1   1   1   1   1   1   1   5   1   11  11;
                 11  11  1   1   1   1   1   5   1    9  1   1   1   11  11;
               11  11  11  1   1   8   1   1   1   1   1   6   1   11  11  11;
             11  11  11  1   4   1   1   1   0   1   1   1   1   1   11  11  11;
               11  11  11  1   1   1   1   1   1   4   1   1   1   11  11  11;
                 11  11  1   1   2   1   5   1   1   1   1   7   1   11  11;
                   11  11  1   1   1   1   1   10  1   1   1   1   11  11;
                     11  11  1   1   1   1   1   1   5   1   1   11  11;
                       11  11  11  1   1   4   1   1   1   11  11  11;
                         11  11  11  11  1   1   1   11  11  11  11;
                           11  11  11  11  11  11  11  11  11  11;
                             11  11  11  11  11  11  11  11  11'
  []

  [del_dummy]
    type = BlockDeletionGenerator
    input = 'pattern_core'
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

    heights    = '30.745  10.7870 0.9525 52.4291 0.9525 3.2820 0.9525 33.5227 0.7775 0.0962 0.0788 10.7082 0.0788 20.2390'
    num_layers = '6       2       1      10      1      1      1      7       1      1      1      2       1      4'
    direction  = '0 0 1'
#                       First axial to last axial, separated by ;
    subdomain_swaps = ' 110 1001  111 1002  112 1002  113 1002  114 1001  115 1002  116 1002  117 1002  118 1002  119 1002  120 1001  121 1001  122 1001  123 1001 
                        210 1001  211 1002  212 1001  213 1002  214 1002  215 1002  216 1001  217 1002  218 1002  219 1002  220 1002  221 1002  222 1001  223 1001  224 1001  225 1001 
                        310 1001  311 1002  312 1002  313 1002  314 1001  315 1002  316 1002  317 1002  318 1001  319 1002  320 1002  321 1002  322 1002  323 1002  324 1001  325 1001  326 1001  327 1001 
                        410 1001  411 1002  412 1001  413 1002  414 1002  415 1002  416 1001  417 1002  418 1002  419 1002  420 1001  421 1002  422 1002  423 1002  424 1002  425 1002  426 1001  427 1001  428 1001  429 1001 
                        510 1001  511 1002  512 1002  513 1001  514 1001  515 1001 
                        603 605;

                        110 170   111 171   112 172   113 173   114 174   115 175   116 176   117 177   118 178   119 179   120 180   121 181   122 182   123 183  
                        210 170   211 171   212 170   213 171   214 172   215 173   216 174   217 175   218 176   219 177   220 178   221 179   222 180   223 181   224 182   225 183  
                        310 370   311 371   312 372   313 373   314 374   315 375   316 376   317 377   318 378   319 379   320 380   321 381   322 382   323 383   324 384   325 385   326 386   327 387  
                        410 370   411 371   412 370   413 371   414 372   415 373   416 374   417 375   418 376   419 377   420 378   421 379   422 380   423 381   424 382   425 383   426 384   427 385   428 386   429 387;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 336   317 337   318 338   319 339   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 336   419 337   420 338   421 339   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        ;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 336   317 337   318 338   319 339   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 336   419 337   420 338   421 339   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        110 150   111 151   112 152   113 153   114 154   115 155   116 156   117 157   118 158   119 159   120 160   121 161   122 162   123 163  
                        210 150   211 151   212 150   213 151   214 152   215 153   216 154   217 155   218 156   219 157   220 158   221 159   222 160   223 161   224 162   225 163  
                        310 350   311 351   312 352   313 353   314 354   315 355   316 356   317 357   318 358   319 359   320 360   321 361   322 362   323 363   324 364   325 365   326 366   327 367  
                        410 350   411 351   412 350   413 351   414 352   415 353   416 354   417 355   418 356   419 357   420 358   421 359   422 360   423 361   424 362   425 363   426 364   427 365   428 366   429 367;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 336   317 337   318 338   319 339   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 336   419 337   420 338   421 339   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        ;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 336   317 337   318 338   319 339   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 336   419 337   420 338   421 339   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 395   317 337   318 338   319 339   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 395   419 337   420 338   421 339   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        110 130   111 131   112 132   113 133   114 134   115 135   116 136   117 137   118 138   119 139   120 140   121 141   122 142   123 143  
                        210 130   211 131   212 130   213 131   214 132   215 133   216 134   217 135   218 136   219 137   220 138   221 139   222 140   223 141   224 142   225 143  
                        310 330   311 331   312 332   313 333   314 334   315 335   316 395   317 337   318 378   319 379   320 340   321 341   322 342   323 343   324 344   325 345   326 346   327 347  
                        410 330   411 331   412 330   413 331   414 332   415 333   416 334   417 335   418 395   419 337   420 378   421 379   422 340   423 341   424 342   425 343   426 344   427 345   428 346   429 347;

                        110 170   111 171   112 172   113 173   114 174   115 175   116 176   117 177   118 178   119 179   120 180   121 181   122 182   123 183  
                        210 170   211 171   212 170   213 171   214 172   215 173   216 174   217 175   218 176   219 177   220 178   221 179   222 180   223 181   224 182   225 183  
                        310 370   311 371   312 372   313 373   314 374   315 375   316 376   317 377   318 378   319 379   320 380   321 381   322 382   323 383   324 384   325 385   326 386   327 387  
                        410 370   411 371   412 370   413 371   414 372   415 373   416 374   417 375   418 376   419 377   420 378   421 379   422 380   423 381   424 382   425 383   426 384   427 385   428 386   429 387;

                        110 170   111 171   112 172   113 173   114 174   115 175   116 176   117 177   118 178   119 179   120 180   121 181   122 182   123 183  
                        210 170   211 171   212 170   213 171   214 172   215 173   216 174   217 175   218 176   219 177   220 178   221 179   222 180   223 181   224 182   225 183  
                        310 370   311 371   312 372   313 373   314 374   315 375   316 376   317 377   318 2001  319 2002  320 380   321 381   322 382   323 383   324 384   325 385   326 386   327 387  
                        410 370   411 371   412 370   413 371   414 372   415 373   416 374   417 375   418 376   419 377   420 2001  421 2002  422 380   423 381   424 382   425 383   426 384   427 385   428 386   429 387;

                        110 2001  111 2002  112 2002  113 2002  114 2001  115 2002  116 2002  117 2002  118 2002  119 2002  120 2001  121 2001  122 2001  123 2001 
                        210 2001  211 2002  212 2001  213 2002  214 2002  215 2002  216 2001  217 2002  218 2002  219 2002  220 2002  221 2002  222 2001  223 2001  224 2001  225 2001 
                        310 2001  311 2002  312 2002  313 2002  314 2001  315 2002  316 2002  317 2002  318 2001  319 2002  320 2002  321 2002  322 2002  323 2002  324 2001  325 2001  326 2001  327 2001 
                        410 2001  411 2002  412 2001  413 2002  414 2002  415 2002  416 2001  417 2002  418 2002  419 2002  420 2001  421 2002  422 2002  423 2002  424 2002  425 2002  426 2001  427 2001  428 2001  429 2001 
                        603 605'
    top_boundary = 20000
    bottom_boundary = 30000
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim= 3
    nx = 35
    ny = 35
    nz = 34
    xmin = -87.0340
    xmax =  87.0340
    ymin = -87.0340
    ymax =  87.0340
    zmin =   0.0000
    zmax = 165.6018
  []
  [assign_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = 'core_3d'
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
  final_generator = 'assign_coarse_id'
[]
