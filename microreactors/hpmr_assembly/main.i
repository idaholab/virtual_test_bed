# Main input file for heat-pipe cooled microreactor assembly

graph_blocks = 'monolith monolith_tri brefl brefl_tri trefl trefl_tri'
fuel_blocks  = 'fuel'

initial_T_asm = 1200.0
initial_T_hp = ${units 800 degC -> K}

alpha_fuel = 0.359
alpha_graphite = 0.539
alpha_helium = 0.102

rho_fuel = 10970.0
rho_graphite = 1806.0
rho_helium = 0.0476

rho_fuel_compact = ${fparse alpha_fuel * rho_fuel + alpha_graphite * rho_graphite + alpha_helium * rho_helium}

# This factor is used to accelerate the steady-state convergence. A real
# transient should use a factor of 1.
cp_scale_factor = 1e-5

n_hp = 7
hp_axial_offset = 0.2 # axial offset for heat pipes; equal to reflector height
length_hp_core = 1.8 # length of heat pipes in the core block
n_elems_hp = 36 # number of axial heat pipe elements coupled to the core

emissivity_hp = 0.4
emissivity_graphite = 0.4
k_gap = 0.38 # helium at high temperature
r_hp = 0.0105 # heat pipe radius
gap_thickness = 0.01e-2
r_hole = ${fparse r_hp + gap_thickness}

# This power density corresponds to 140 kW, or 20 kW per heat pipe
power_density_fuel = 1.285e7

# Heat pipe index numbering:
#   0 1
#  2 3 4
#   5 6
apoth = ${fparse 0.02782 / 2}
x1 = ${fparse 2 * apoth * cos(30*pi/180)}
y1 = ${fparse 2 * apoth * sin(30*pi/180) + 2 * apoth}
x4 = ${fparse 2 * x1}
y4 = 0
x0 = -${x1}
y0 =  ${y1}
x2 = -${x4}
y2 = 0
x3 = 0
y3 = 0
x5 = -${x1}
y5 = -${y1}
x6 =  ${x1}
y6 = -${y1}

hp_positions = '
  ${x0} ${y0} ${hp_axial_offset}
  ${x1} ${y1} ${hp_axial_offset}
  ${x2} ${y2} ${hp_axial_offset}
  ${x3} ${y3} ${hp_axial_offset}
  ${x4} ${y4} ${hp_axial_offset}
  ${x5} ${y5} ${hp_axial_offset}
  ${x6} ${y6} ${hp_axial_offset}'

[Mesh]
  [file]
    type = FileMeshGenerator
    file = mesh.e
  []
[]

[Variables]
  [temperature]
    initial_condition = ${initial_T_asm}
  []
[]

[Kernels]
  [time_derivative]
    type = HeatConductionTimeDerivative
    variable = temperature
  []
  [heat_source]
    type = CoupledForce
    variable = temperature
    block = ${fuel_blocks}
    v = ${power_density_fuel}
  []
  [heat_conduction]
    type = HeatConduction
    variable = temperature
  []
[]

[FunctorMaterials]
  [gap_heat_flux_fmat]
    type = ADCylindricalGapHeatFluxFunctorMaterial
    emissivity_inner = ${emissivity_hp}
    emissivity_outer = ${emissivity_graphite}
    k_gap = ${k_gap}
    r_inner = ${r_hp}
    r_outer = ${r_hole}
    T_inner = T_hp
    T_outer = temperature
    total_heat_flux_name = heat_flux_hp
  []
[]

[BCs]
  [hp_holes_bc]
    type = FunctorNeumannBC
    variable = temperature
    boundary = 'hp_holes'
    functor = heat_flux_hp
    flux_is_inward = true
  []
[]

[AuxVariables]
  [power_density_fuel]
    initial_condition = ${power_density_fuel}
  []
  [T_hp]
    initial_condition = ${initial_T_hp}
  []
[]

[Materials]
  [fast_neutron_fluence]
    type = ParsedMaterial
    property_name = fast_neutron_fluence
    expression = 0.0
  []
  [matrix_thermal_props]
    type = GraphiteMatrixThermal
    block = ${fuel_blocks}
    temperature = temperature
    graphite_grade = IG_110
    packing_fraction = 0.359
    etc_model = DEMT
    flux_conversion_factor = 0.0
    TRISO_conductivity = 4.13
    TRISO_specific_heat = 748.72
    specific_heat_scale_factor = ${cp_scale_factor}
    outputs = all
  []
  [fuel_compact_density]
    type = Density
    block = ${fuel_blocks}
    density = '${rho_fuel_compact}'
  []
  [graph_density]
    type = Density
    block = ${graph_blocks}
    density = '${rho_graphite}'
  []
  [graph]
    type = GraphiteMatrixThermal
    block = ${graph_blocks}
    temperature = temperature
    graphite_grade = IG_110
    packing_fraction = 0.0
    flux_conversion_factor = 0.0
    specific_heat_scale_factor = ${cp_scale_factor}
  []
[]

[MultiApps]
  [hp_app]
    type = TransientMultiApp
    app_type = SockeyeApp
    input_files = 'sockeye.i'
    positions = ${hp_positions}
    max_procs_per_app = 1
    output_in_position = true
    sub_cycling = true
    max_failures = 1000
    execute_on = 'TIMESTEP_END'
  []
[]

[UserObjects]
  [heat_flux_hp_uo]
    type = NearestPointLayeredSideAverageFunctor
    functor = heat_flux_hp
    boundary = 'hp_holes'
    num_layers = ${n_elems_hp}
    direction = z
    points = ${hp_positions}
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Transfers]
  # Send heat pipe heat flux to sub-app
  [heat_flux_hp_to_hp_app]
    type = MultiAppUserObjectTransfer
    to_multi_app = hp_app
    user_object = heat_flux_hp_uo
    variable = q_ext
  []

  # Send discrete perimeter to sub-app
  [perimeter_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = hp_app
    from_postprocessor = hp_holes_perimeter
    to_postprocessor = P_ext
  []

  # Receive heat pipe outer cladding temperature from sub-app
  [T_from_hp_app]
    type = MultiAppUserObjectTransfer
    variable = T_hp
    boundary = 'hp_holes'
    from_multi_app = hp_app
    user_object = T_hp_uo
    nearest_sub_app = true
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2

  [TimeStepper]
    type = SolutionTimeAdaptiveDT
    dt = 0.01
  []
  dtmin = 0.01

  steady_state_detection = true
  steady_state_tolerance = 1e-8

  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 30 0.7'

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-7
  l_tol = 1e-7

  fixed_point_max_its = 15
  fixed_point_rel_tol = 1e-7
  fixed_point_abs_tol = 1e-7
[]

[Postprocessors]
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density_fuel
    block = ${fuel_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [Tavg_fuel]
    type = ElementAverageValue
    variable = temperature
    block = ${fuel_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmax_fuel]
    type = ElementExtremeValue
    variable = temperature
    block = ${fuel_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tavg_monolith]
    type = ElementAverageValue
    variable = temperature
    block = 'monolith monolith_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmax_monolith]
    type = ElementExtremeValue
    variable = temperature
    block = 'monolith monolith_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tavg_brefl]
    type = ElementAverageValue
    variable = temperature
    block = 'brefl brefl_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmax_brefl]
    type = ElementExtremeValue
    variable = temperature
    block = 'brefl brefl_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tavg_trefl]
    type = ElementAverageValue
    variable = temperature
    block = 'trefl trefl_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmax_trefl]
    type = ElementExtremeValue
    variable = temperature
    block = 'trefl trefl_tri'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tavg_hp_holes]
    type = SideAverageValue
    variable = T_hp
    boundary = 'hp_holes'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmax_hp_holes]
    type = SideExtremeValue
    variable = T_hp
    boundary = 'hp_holes'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [hp_holes_area]
    type = AreaPostprocessor
    boundary = 'hp_holes'
    execute_on = 'INITIAL'
  []
  [hp_holes_perimeter]
    type = ParsedPostprocessor
    pp_names = 'hp_holes_area'
    function = 'hp_holes_area / ${fparse n_hp * length_hp_core}'
    execute_on = 'INITIAL'
  []
[]

[Outputs]
  file_base = 'main'

  print_linear_residuals = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  perf_graph = true

  exodus = true
  csv = true
  [console]
    type = Console
    execute_postprocessors_on = 'NONE'
    outlier_variable_norms = false
  []
[]
