## GCMR TH simulation with inter-assembly bypass flow
## 3D heat conduction input file
## Application: MOOSE heat conduction module
## POC: Lise Charlot lise.charlot at inl.gov
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

# Assembly parameters
assembly_height = 2.
nb_assembly = 61

radius_fuel = 0.00794 # m
section_fuel_channel = '${fparse pi * radius_fuel * radius_fuel}'

T_in = 889 # K

nb_fuel_ring1 = 6
nb_fuel_ring2 = 6
nb_fuel_ring3 = 12
nb_fuel_ring4 = 18

factor_density_ring1 = 1.3
factor_density_ring2 = 1.25
factor_density_ring3 = 1.2
factor_density_ring4 = 1

tot_power = 15e6 # W
tot_power_assembly = '${fparse tot_power / (nb_assembly)}' # W

power_channel_min_avg = '${fparse tot_power_assembly / (nb_fuel_ring1 * factor_density_ring1 + nb_fuel_ring2 * factor_density_ring2 + nb_fuel_ring3 * factor_density_ring3 + nb_fuel_ring4 * factor_density_ring4)}'
density_channel_min_avg = '${fparse power_channel_min_avg / (section_fuel_channel * assembly_height)}'

density_ring1_avg = '${fparse factor_density_ring1 * density_channel_min_avg}'
density_ring2_avg = '${fparse factor_density_ring2 * density_channel_min_avg}'
density_ring3_avg = '${fparse factor_density_ring3 * density_channel_min_avg}'
density_ring4_avg = '${fparse factor_density_ring4 * density_channel_min_avg}'

B = 0.5
A = '${fparse (1 - B) * pi / 2}'
norm = 1.09261675156

[GlobalParams]
  # Reduces transfers efficiency for now, can be removed once transferred fields are checked
  bbox_factor = 10
[]

[Mesh]
  [file_mesh]
    type = FileMeshGenerator
    file = mesh_bypass_in.e
  []
[]

[Functions]
  [graphite_specific_heat_fn]
    type = PiecewiseLinear
    x = '300 400 500  600  700  800  900  1000 1100 1200 1300 1400 1500 1600 1700 1800 1900 2000 2100 2200 2300 2400 2500 2600 2700 2800 2900 3000'
    y = '713 995 1230 1400 1540 1640 1730 1790 1850 1890 1930 1970 2000 2020 2050 2070 2090 2100 2120 2130 2150 2160 2170 2180 2200 2210 2220 2220'
  []

  [f_r]
    type = ParsedFunction
    symbol_names = 'A B r_core'
    symbol_values = '${A} ${B} 0.85'
    expression = 'B + A * cos(pi * sqrt(x^2 + y^2) / r_core /2.)'
  []

  [f_z]
    type = ParsedFunction
    symbol_names = 'A B  norm assembly_height'
    symbol_values = '${A} ${B} ${norm} ${assembly_height}'
    expression = 'norm * (B+ A * sin(pi * z / assembly_height))'
  []

  [density_ring1_fn]
    type = ParsedFunction
    symbol_names = 'f_z density_ring1_avg f_r'
    symbol_values = 'f_z ${density_ring1_avg} f_r'
    expression = 'density_ring1_avg * f_z * f_r'
  []
  [density_ring2_fn]
    type = ParsedFunction
    symbol_names = 'f_z density_ring2_avg f_r'
    symbol_values = 'f_z ${density_ring2_avg} f_r'
    expression = 'density_ring2_avg * f_z *f_r'
  []
  [density_ring3_fn]
    type = ParsedFunction
    symbol_names = 'f_z density_ring3_avg f_r'
    symbol_values = 'f_z ${density_ring3_avg} f_r'
    expression = 'density_ring3_avg * f_z *f_r'
  []
  [density_ring4_fn]
    type = ParsedFunction
    symbol_names = 'f_z density_ring4_avg f_r'
    symbol_values = 'f_z ${density_ring4_avg} f_r'
    expression = 'density_ring4_avg * f_z * f_r'
  []
[]
[Materials]
  [graphite_thermal]
    type = HeatConductionMaterial
    #       matrix channels   reflector   moderator_pincell
    block = ' 1 2 3 4 5 6        10  12          101 103 250'
    temp = T
    thermal_conductivity = 40 # W/(m.K)
    specific_heat_temperature_function = graphite_specific_heat_fn # J/(kg.K)
  []

  [fuel_thermal]
    type = HeatConductionMaterial
    #         fuel_pincell
    block = '301 303 401 403 501 503 601 603'
    temp = T
    thermal_conductivity = 5 # W/(m.K)
    specific_heat = 300 # J/(kg.K)
  []

  [graphite_density]
    type = Density
    #       matrix channels   reflector   moderator_pincell
    block = ' 1 2 3 4 5 6        10   12          101 103 250'
    density = 2160 # kg/m3
  []

  [fuel_density]
    type = Density
    #         fuel_pincell
    block = '301 303 401 403 501 503 601 603'
    density = 10970 # kg/m3
  []
[]

[Variables]
  [T]
    initial_condition = ${T_in}
  []
[]

[AuxVariables]
  [T_wall_bypass]
    initial_condition = ${T_in}
  []
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${T_in}
  []
  [htc]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 1000
  []
  [power_density]
  []
  [SumWij]
  []
  [T_bypass]
    initial_condition = ${T_in}
  []
  [htc_bypass]
    initial_condition = 30
  []
  [flux_bypass]
    initial_condition = 0
  []
[]

[AuxKernels]
  [density_ring1_aux]
    type = FunctionAux
    function = density_ring1_fn
    variable = power_density
    block = '301 303'
    execute_on = 'INITIAL'
  []
  [density_ring2_aux]
    type = FunctionAux
    function = density_ring2_fn
    variable = power_density
    block = '401 403'
    execute_on = 'INITIAL'
  []
  [density_ring3_aux]
    type = FunctionAux
    function = density_ring3_fn
    variable = power_density
    block = '501 503'
    execute_on = 'INITIAL'
  []
  [density_ring4_aux]
    type = FunctionAux
    function = density_ring4_fn
    variable = power_density
    block = '601 603'
    execute_on = 'INITIAL'
  []
  [T_wall_bypass_aux]
    type = SpatialUserObjectAux
    user_object = T_wall_bypass_uo
    variable = T_wall_bypass
  []
  [flux_aux]
    type = ParsedAux
    coupled_variables = 'T_bypass T_wall_bypass htc_bypass'
    variable = flux_bypass
    expression = 'htc_bypass * (T_wall_bypass - T_bypass)'
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = T
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = T
    block = '301 303 401 403 501 503 601 603'
    v = power_density
  []
[]

[BCs]
  [cooling_channels]
    type = CoupledConvectiveHeatFluxBC
    boundary = coolant_boundary
    T_infinity = T_fluid
    htc = htc
    variable = T
  []
  [bypass_conv]
    type = CoupledConvectiveHeatFluxBC
    boundary = bypass_boundary
    T_infinity = T_bypass
    htc = htc_bypass
    variable = T
  []
  [outer_to_env]
    type = CoupledConvectiveHeatFluxBC
    boundary = 10000
    T_infinity = 800
    htc = 10
    variable = T
  []
[]

[UserObjects]
  [T_wall_bypass_uo]
    type = NearestPointLayeredSideAverage
    variable = T
    boundary = bypass_boundary
    direction = z
    num_layers = 51
    points_file = bypass_positions.txt
  []
  [T_wall_coolant_uo]
    type = NearestPointLayeredSideAverage
    variable = T
    boundary = coolant_boundary
    direction = z
    num_layers = 51
    points_file = channel_centers.txt
  []

[]
[Postprocessors]
  [fuel_power]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = T_fluid
    htc_var = htc
    T_solid = T
    boundary = coolant_boundary
  []
  [heat_balance]
    type = ParsedPostprocessor
    pp_names = 'total_power fuel_power heat_bypass'
    function = '(total_power - fuel_power - heat_bypass )/total_power'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    block = '301 303 401 403 501 503 601 603'
    variable = power_density
  []
  [heat_bypass]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = T_bypass
    htc_var = htc_bypass
    T_solid = T
    boundary = bypass_boundary
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'

  nl_abs_tol = 1e-10

  automatic_scaling = true
  compute_scaling_once = false

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  fixed_point_abs_tol = 1e-8
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-7
  accept_on_max_fixed_point_iteration = true
[]

[Outputs]
  [out]
    type = Exodus
  []
[]

[MultiApps]
  [bypass_flow]
    type = FullSolveMultiApp
    positions = '0 0 0'
    input_files = bypass.i
    max_procs_per_app = 1
    execute_on = ' TIMESTEP_END'
    bounding_box_padding = '0.01 0.01 0.01'
    ignore_solve_not_converge = true
    keep_solution_during_restore = true
  []
  [channel_flow]
    type = FullSolveMultiApp
    positions_file = 'channel_centers.txt'
    input_files = cooling_channel.i
    max_procs_per_app = 1
    execute_on = 'TIMESTEP_END'
    bounding_box_padding = '0.1 0.1 0.1'
    output_in_position = true
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [T_wall_to_coolant]
    type = MultiAppGeneralFieldUserObjectTransfer
    source_user_object = T_wall_coolant_uo
    variable = T_wall
    to_multi_app = channel_flow
  []
  [T_coolant]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = channel_flow
    source_variable = T
    variable = T_fluid
  []
  [htc_coolant]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = channel_flow
    source_variable = htc
    variable = htc
  []

  [flux_to_bypass]
    type = MultiAppGeometricInterpolationTransfer
    source_variable = flux_bypass
    variable = flux
    to_multi_app = bypass_flow
  []
  [T_bypass]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bypass_flow
    source_variable = T
    variable = T_bypass
  []
  [htc_bypass]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bypass_flow
    source_variable = htc
    variable = htc_bypass
  []
  [SumWij]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bypass_flow
    source_variable = SumWij
    variable = SumWij
  []
[]

