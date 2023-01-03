bed_height = 10.0
bed_radius = 1.2
bed_porosity = 0.39
outlet_pressure = 5.5e6
T_fluid = 300
density = 8.6545
pebble_diameter = 0.06

mass_flow_rate = 60.0
flow_area = ${fparse pi * bed_radius * bed_radius}
flow_vel = ${fparse mass_flow_rate / flow_area / density}

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = ${bed_radius}
    ymin = 0
    ymax = ${bed_height}
    nx = 6
    ny = 40
  []
  coord_type = RZ
[]

[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[Modules]
  [NavierStokesFV]
    # general control parameters
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true

    # material property parameters
    density = rho
    dynamic_viscosity = mu

    # porous medium treatment parameters
    porosity = porosity

    # initial conditions
    initial_velocity = '0 0 0'
    initial_pressure = 5.4e6

    # boundary conditions
    inlet_boundaries = top
    momentum_inlet_types = fixed-velocity
    momentum_inlet_function = '0 -${flow_vel}'
    wall_boundaries = 'left right'
    momentum_wall_types = 'slip slip'
    outlet_boundaries = bottom
    momentum_outlet_types = fixed-pressure
    pressure_function = ${outlet_pressure}

    # friction control parameters
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
  []
[]

[Materials]
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid = ${T_fluid}
    speed = speed
    characteristic_length = ${pebble_diameter}
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fluid_properties_obj
    pebble_diameter =  ${pebble_diameter}
    porosity = porosity
    T_fluid = ${T_fluid}
    T_solid = ${T_fluid}
  []
[]

[AuxVariables]
  [porosity]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    initial_condition = ${bed_porosity}
  []
[]

[Executioner]
  type = Transient
  end_time = 100
  [TimeStepper]
    type = IterationAdaptiveDT
    iteration_window = 2
    optimal_iterations = 8
    cutback_factor = 0.8
    growth_factor = 2
    dt = 1e-3
  []
  dtmax = 5
  line_search = l2
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
[]

[Postprocessors]
  [inlet_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    boundary = 'top'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []

  [outlet_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    boundary = 'bottom'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []

  [inlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = top
    outputs = none
  []

  [outlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = bottom
    outputs = none
  []

  [pressure_drop]
    type = ParsedPostprocessor
    pp_names = 'inlet_pressure outlet_pressure'
    function = 'inlet_pressure - outlet_pressure'
  []

  [integral_density]
    type = ADElementIntegralFunctorPostprocessor
    functor = rho
    outputs = none
  []

  [average_density]
    type = ParsedPostprocessor
    pp_names = 'volume integral_density'
    function = 'integral_density / volume'
  []

  [integral_mu]
    type = ADElementIntegralFunctorPostprocessor
    functor = mu
    outputs = none
  []

  [average_mu]
    type = ParsedPostprocessor
    pp_names = 'volume integral_mu'
    function = 'integral_mu / volume'
  []

  [area]
    type = AreaPostprocessor
    boundary = bottom
    outputs = none
  []

  [volume]
    type = VolumePostprocessor
  []
[]

[Outputs]
  exodus = true
[]
