[Mesh]
  # ProxyMesh/ProxyMesh.e is a 2D mesh with the following block numbers
  # block  0 - Fuel TypeA
  # block  1 - Fuel TypeB
  # block  2 - Fuel TypeC
  # block  3 - Fuel TypeD
  # block  4 - Central Control Rod
  # block  5 - Intermediate ring Control Rods
  # block  6 - Outer ring Reflectors/Control Rods
  [fmg]
    type = FileMeshGenerator
    file = '../supporting_files/ProxyMesh.e'
  []
  # The next generator gives some axial character to the mesh
  # 9 layers, each 0.58 m long
  # The block ids are modified to have a layer number prepended, e.g.,
  # block 62 would therefore be layer 6 of the original block 2
  [extrude]
    type = AdvancedExtruderGenerator
    input = fmg
    heights = '0.58 0.58 0.58 0.58 0.58 0.58 0.58 0.58 0.58'
    num_layers = '1  1    1    1    1    1   1    1    1'
    direction = '0 0 1'
    subdomain_swaps = '0 10 1 11 2 12 3 13 4 14 5 15 6 16;
                       0 20 1 21 2 22 3 23 4 24 5 25 6 26;
                       0 30 1 31 2 32 3 33 4 34 5 35 6 36;
                       0 40 1 41 2 42 3 43 4 44 5 45 6 46;
                       0 50 1 51 2 52 3 53 4 54 5 55 6 56;
                       0 60 1 61 2 62 3 63 4 64 5 65 6 66;
                       0 70 1 71 2 72 3 73 4 74 5 75 6 76;
                       0 80 1 81 2 82 3 83 4 84 5 85 6 86;
                       0 90 1 91 2 92 3 93 4 94 5 95 6 96'
  []
  [rotate]
    type = TransformGenerator
    input = extrude
    transform = ROTATE
    vector_value = '0 -90 0'
  []
[]

# ===============================================
# This section sets up a dummy simulation
[Variables] # DUMMY. This variable is here there for the null-kernel
  [u]
  []
[]

[Kernels] # DUMMY. Residual is null and therefore there are no iterations
  [null]
    type = NullKernel
    variable = u
  []
[]

[Executioner]
  type = Transient
  start_time = 0
  end_time = 10000.0
  error_on_dtmin = false
  dtmax = 100.0
  dtmin = 1e-6
    [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1.0e-5
    cutback_factor     = 0.5
    growth_factor      = 2.00
    # iteration_window = 4
    optimal_iterations = 8
  []
[]

# ===============================================
# Handling the input from the PRK solver
[Postprocessors]
  [total_power] # This pp is set from the kinetics simulation
    type = Receiver
  []
  [T_fuelCompact_avg]
    type = Receiver
  []
  [T_fuelBlock_avg]
    type = Receiver
  []
  [T_mod_avg]
    type = Receiver
  []
[]

[AuxVariables] # This is what we are after, we want to expand
               # the power input from PRK to a 3D field
  [power]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 0.0
  []
[]

[Postprocessors] # This pp checks that the incoming total power is
                 # properly expanded. We should have exactly
                 # total_power_check = total_power
  [total_power_check]
    type = ElementIntegralVariablePostprocessor
    variable = power
  []
[]

# ===============================================
# Here we actually set the power profiles per block
# Notice that we have neglected neutron scattering based heating and
# gamma heating by lumping all the heat generation onto the
# fuel blocks
[GlobalParams]
  variable = power
  functor_symbols = P
  functor_names = total_power
  constant_names = 'V'
  constant_expressions = '0.065097398'
[]

[AuxKernels]

  [FTA1] type = ParsedAux expression = ' 0.0131566 / (6*V) * P' block = '70'[]
  [FTA2] type = ParsedAux expression = ' 0.0428676 / (6*V) * P' block = '60'[]
  [FTA3] type = ParsedAux expression = ' 0.0578152 / (6*V) * P' block = '50'[]
  [FTA4] type = ParsedAux expression = ' 0.0492582 / (6*V) * P' block = '40'[]
  [FTA5] type = ParsedAux expression = ' 0.0395363 / (6*V) * P' block = '30'[]

  [FTB1] type = ParsedAux expression = ' 0.0135701 / (6*V) * P' block = '71'[]
  [FTB2] type = ParsedAux expression = ' 0.0445521 / (6*V) * P' block = '61'[]
  [FTB3] type = ParsedAux expression = ' 0.0601347 / (6*V) * P' block = '51'[]
  [FTB4] type = ParsedAux expression = ' 0.0502453 / (6*V) * P' block = '41'[]
  [FTB5] type = ParsedAux expression = ' 0.0402631 / (6*V) * P' block = '31'[]

  [FTC1] type = ParsedAux expression = ' 0.0288152 / (12*V) * P' block = '72'[]
  [FTC2] type = ParsedAux expression = ' 0.0838721 / (12*V) * P' block = '62'[]
  [FTC3] type = ParsedAux expression = ' 0.1108335 / (12*V) * P' block = '52'[]
  [FTC4] type = ParsedAux expression = ' 0.0906384 / (12*V) * P' block = '42'[]
  [FTC5] type = ParsedAux expression = ' 0.0721358 / (12*V) * P' block = '32'[]

  [FTD1] type = ParsedAux expression = ' 0.0196652 / (6*V) * P' block = '73'[]
  [FTD2] type = ParsedAux expression = ' 0.0444692 / (6*V) * P' block = '63'[]
  [FTD3] type = ParsedAux expression = ' 0.0546083 / (6*V) * P' block = '53'[]
  [FTD4] type = ParsedAux expression = ' 0.0466155 / (6*V) * P' block = '43'[]
  [FTD5] type = ParsedAux expression = ' 0.0369445 / (6*V) * P' block = '33'[]

[]

# Since the Pronghorn model uses average rings we create a UO here
# which provide the appropriate integrals along each ring and layer
[UserObjects]
  [powerUO_ring1]
    type = LayeredIntegral
    variable = power
    direction = y
    direction_min = 0.0
    direction_max = 5.22
    num_layers = 9
    block = '10 20 30 40 50 60 70 80 90'
  []
  [powerUO_ring2]
    type = LayeredIntegral
    variable = power
    direction = y
    direction_min = 0.0
    direction_max = 5.22
    num_layers = 9
    block = '11 21 31 41 51 61 71 81 91'
  []
  [powerUO_ring3]
    type = LayeredIntegral
    variable = power
    direction = y
    direction_min = 0.0
    direction_max = 5.22
    num_layers = 9
    block = '12 22 32 42 52 62 72 82 92
             13 23 33 43 53 63 73 83 93'
  []
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
    file_base = proxy_csv/proxy
  []
[]

[MultiApps]
  [pronghorn_app]
    type = TransientMultiApp
    app_type = PronghornApp
    input_files = 'C01_Pronghorn.i'
    positions = '0 -4.5 0'
    catch_up = true
    max_catch_up_steps = 4
    output_in_position = true
  []
[]
[Transfers]
  [ring1_transfer]
    type = MultiAppUserObjectTransfer
    to_multi_app = pronghorn_app
    variable = power_ring1
    user_object = powerUO_ring1
    block = '11'
  []
  [ring2_transfer]
    type = MultiAppUserObjectTransfer
    to_multi_app = pronghorn_app
    variable = power_ring2
    user_object = powerUO_ring2
    block = '21'
  []
  [ring3_transfer]
    type = MultiAppUserObjectTransfer
    to_multi_app = pronghorn_app
    variable = power_ring3
    user_object = powerUO_ring3
    block = '31'
  []
  [T_fuelCompact_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = pronghorn_app
    from_postprocessor = T_fuelCompact_avg
    to_postprocessor = T_fuelCompact_avg
    reduction_type = average
  []
  [T_fuelBlock_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = pronghorn_app
    from_postprocessor = T_fuelBlock_avg
    to_postprocessor = T_fuelBlock_avg
    reduction_type = average
  []
  [T_mod_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = pronghorn_app
    from_postprocessor = T_mod_avg
    to_postprocessor = T_mod_avg
    reduction_type = average
  []
[]
