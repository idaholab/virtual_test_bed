# Authored: Joseph R. Brennan, Mentor: Mustafa K. Jaradat, Sebastian Schunert, and Paolo Balestra
bed_height = 10.0
bed_radius = 1.2
cavity_height = 0.5
bed_porosity = 0.39
outlet_pressure = 5.5e6
density = 8.7325
pebble_diameter = 0.06
T_inlet = 300
thermal_mass_scaling = 1

mass_flow_rate = 60.0
flow_area = ${fparse pi * bed_radius * bed_radius}
flow_vel = ${fparse mass_flow_rate / flow_area / density}

# scales the heat source to integrate to 200 MW
power_fn_scaling = 0.88689239556

# moves the heat source around axially to have the peak in the right spot
offset = 0.56331

[Mesh]
  [gen]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${bed_radius}'
    ix = '6'
    dy = '${bed_height} ${cavity_height}'
    iy = '40            2'
    subdomain_id = '1 2'
  []

  [rename_blocks]
    type = RenameBlockGenerator
    old_block = '1 2'
    new_block = 'pebble_bed cavity'
    input = gen
  []
  coord_type = RZ
[]

[Debug]
  show_functors = true
[]

[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[Functions]
  [heat_source_fn]
    type = ParsedFunction
    expression = '${power_fn_scaling} * (-1.0612e4 * pow(y+${offset}, 4) + 1.5963e5 * pow(y+${offset}, 3)
                   -6.2993e5 * pow(y+${offset}, 2) + 1.4199e6 * (y+${offset}) + 5.5402e4)'
  []
[]

[Variables]
  [T_solid]
    type = INSFVEnergyVariable
    initial_condition = ${T_inlet}
    block = 'pebble_bed'
  []
[]

[FVKernels]
  [energy_storage]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    rho = rho_s
    cp = cp_s
    is_solid = true
    scaling = ${thermal_mass_scaling}
    porosity = porosity
  []

  [solid_energy_diffusion]
    type = FVAnisotropicDiffusion
    variable = T_solid
    coeff = 'effective_thermal_conductivity'
  []

  [source]
    type = FVBodyForce
    variable = T_solid
    function = heat_source_fn
    block = 'pebble_bed'
  []

  [convection_pebble_bed_fluid]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = 'alpha'
  []
[]

[Modules]
  [NavierStokesFV]
    # general control parameters
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    add_energy_equation = true

    # material property parameters
    density = rho
    dynamic_viscosity = mu
    specific_heat = cp
    thermal_conductivity = kappa

    # porous medium treatment parameters
    porosity = porosity
    porosity_interface_pressure_treatment = 'bernoulli'

    # initial conditions
    initial_velocity = '0 0 0'
    initial_pressure = 5.4e6
    initial_temperature = '${T_inlet}'

    # inlet boundary conditions
    inlet_boundaries = top
    momentum_inlet_types = fixed-velocity
    momentum_inlet_function = '0 -${flow_vel}'
    energy_inlet_types = fixed-temperature
    energy_inlet_function = '${T_inlet}'

    # wall boundary conditions
    wall_boundaries = 'left right'
    momentum_wall_types = 'slip slip'
    energy_wall_types = 'heatflux heatflux'
    energy_wall_function = '0 0'

    # outlet boundary conditions
    outlet_boundaries = bottom
    momentum_outlet_types = fixed-pressure
    pressure_function = ${outlet_pressure}

    # friction control parameters
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'

    # energy equation parameters
    ambient_convection_blocks = 'pebble_bed'
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'
  []
[]

[AuxVariables]
  [source_var]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [source_aux]
    type = FunctionAux
    variable = source_var
    block = pebble_bed
    function = heat_source_fn
  []
[]

[Materials]
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid =  T_fluid
    speed = speed
    characteristic_length = ${pebble_diameter}
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fluid_properties_obj
    pebble_diameter =  ${pebble_diameter}
    porosity = porosity
    T_fluid = T_fluid
    T_solid = T_solid
    block = 'pebble_bed'
  []

  [drag_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = '0 0 0 0 0 0'
    block = cavity
  []

  [porosity_material]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'pebble_bed ${bed_porosity}
                               cavity 1'
  []

  [effective_solid_thermal_conductivity_pb]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = '20 20 20'
    block = 'pebble_bed'
  []

  [alpha_mat]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '2e4'
    block = 'pebble_bed'
  []

  [generic_mat]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s  cp_s'
    prop_values = '2000  300'
  []

  [kappa_f_pebble_bed]
    type = FunctorLinearPecletKappaFluid
    porosity = porosity
    block = 'pebble_bed'
  []

  [kappa_f_mat_no_pebble_bed]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = 'cavity'
  []
[]

[Executioner]
  type = Transient
  end_time = 10000
  [TimeStepper]
    type = IterationAdaptiveDT
    iteration_window = 2
    optimal_iterations = 8
    cutback_factor = 0.8
    growth_factor = 2
    dt = 0.05
  []
  line_search = l2
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 15
  automatic_scaling = true
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

  [enthalpy_inlet]
    type = VolumetricFlowRate
    boundary = top
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    advected_quantity = 'rho_cp_temp'
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_outlet]
    type = VolumetricFlowRate
    boundary = bottom
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    advected_quantity = 'rho_cp_temp'
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_balance]
    type = ParsedPostprocessor
    pp_names = 'enthalpy_inlet enthalpy_outlet'
    function = 'enthalpy_inlet + enthalpy_outlet'
  []

  [heat_source_integral]
    type = ElementIntegralFunctorPostprocessor
    functor = heat_source_fn
    block = 'pebble_bed'
  []
[]

[Outputs]
  exodus = true
[]
