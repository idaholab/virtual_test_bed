# ==============================================================================
# Model description:
# Step5 - Step4 plus reflector.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 15, 2023 04:03 PM
# Author(s): Joseph R. Brennan, Dr. Sebastian Schunert, Dr. Mustafa K. Jaradat
#            and Dr. Paolo Balestra.
# ==============================================================================
bed_radius = 1.2
outlet_pressure = 5.84e+6
T_inlet = 533.25
inlet_density = 5.2955
pebble_diameter = 0.06
thermal_mass_scaling = 1

mass_flow_rate = 64.3
flow_area = ${fparse pi * bed_radius * bed_radius}
flow_vel = ${fparse mass_flow_rate / flow_area / inlet_density}

# scales the heat source to integrate to 200 MW
power_fn_scaling = 0.9792628

# moves the heat source around axially to have the peak in the right spot
offset = -0.29119

# the y-coordinate of the top of the core
top_core = 9.7845

# hydraulic diameters (excluding bed where it's pebble diameter)
bottom_reflector_Dh = 0.1

[Mesh]
  block_id = '1 2 3 4'
  block_name = 'pebble_bed
                cavity
                bottom_reflector
                side_reflector'

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = '0.20 0.20 0.20 0.20 0.20 0.20 0.010 0.055'

    ix = '1 1 1 1 1 1 1 1'

    dy =  '0.1709 0.1709 0.1709 0.1709 0.1709
           0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
           0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
           0.458 0.712'

    iy = '2 2 1 1 1
          4 1 1 1 1 1 1 1 1 1
          1 1 1 1 1 1 1 1 1 4
          4 2'

    subdomain_id = '3 3 3 3 3 3 4 4
                    3 3 3 3 3 3 4 4
                    3 3 3 3 3 3 4 4
                    3 3 3 3 3 3 4 4
                    3 3 3 3 3 3 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    1 1 1 1 1 1 4 4
                    2 2 2 2 2 2 4 4
                    4 4 4 4 4 4 4 4'
  []

  [cavity_top]
    type = SideSetsAroundSubdomainGenerator
    input = cartesian_mesh
    block = 2
    normal = '0 1 0'
    new_boundary = cavity_top
  []

  [cavity_side]
    type = SideSetsAroundSubdomainGenerator
    input = cavity_top
    block = 2
    normal = '1 0 0'
    new_boundary = cavity_side
  []

  [side_reflector_bed]
    type = SideSetsBetweenSubdomainsGenerator
    input = cavity_side
    primary_block = 1
    paired_block = 4
    new_boundary = side_reflector_bed
  []

  [side_reflector_bottom_reflector]
    type = SideSetsBetweenSubdomainsGenerator
    input = side_reflector_bed
    primary_block = 3
    paired_block = 4
    new_boundary = side_reflector_bottom_reflector
  []

  [BreakBoundary]
    type = BreakBoundaryOnSubdomainGenerator
    input = side_reflector_bottom_reflector
    boundaries = 'left bottom'
  []

  [DeleteBoundary]
    type = BoundaryDeletionGenerator
    input = BreakBoundary
    boundary_names = 'left right top bottom'
  []

  [RenameBoundaryGenerator]
    type = RenameBoundaryGenerator
    input = DeleteBoundary
    old_boundary = 'cavity_top bottom_to_3 left_to_1 left_to_2 left_to_3 side_reflector_bed side_reflector_bottom_reflector cavity_side'
    new_boundary = 'inlet outlet bed_left bed_left bed_left bed_right bed_right bed_right'
  []

  coord_type = RZ
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
    block = 'pebble_bed bottom_reflector side_reflector'
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
    block = 'pebble_bed bottom_reflector'
  []
[]

[Modules]
  [NavierStokesFV]
    # general control parameters
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    add_energy_equation = true
    block = 'pebble_bed cavity bottom_reflector'

    # material property parameters
    density = rho
    dynamic_viscosity = mu
    thermal_conductivity = kappa

    # porous medium treatment parameters
    porosity = porosity
    porosity_interface_pressure_treatment = 'bernoulli'

    # initial conditions
    initial_velocity = '0 0 0'
    initial_pressure = 5.4e6
    initial_temperature = ${T_inlet}

    # inlet boundary conditions
    inlet_boundaries = inlet
    momentum_inlet_types = fixed-velocity
    momentum_inlet_function = '0 -${flow_vel}'
    energy_inlet_types = fixed-temperature
    energy_inlet_function = '${T_inlet}'

    # wall boundary conditions
    wall_boundaries = 'bed_left bed_right'
    momentum_wall_types = 'slip slip'
    energy_wall_types = 'heatflux heatflux'
    energy_wall_function = '0 0'

    # outlet boundary conditions
    outlet_boundaries = outlet
    momentum_outlet_types = fixed-pressure
    pressure_function = ${outlet_pressure}

    # friction control parameters
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'

    # energy equation parameters
    ambient_convection_blocks = 'pebble_bed bottom_reflector'
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'
  []
[]

[UserObjects]
  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = ${top_core}
    inner_radius = 0.0
    outer_radius = 1.2
  []
[]

[Materials]
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid = T_fluid
    speed = speed
    characteristic_length = characteristic_length
    block = 'pebble_bed cavity bottom_reflector'
  []

  [graphite_rho_and_cp_bed]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 26'
    block = 'pebble_bed'
  []

  [graphite_rho_and_cp_side_reflector]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s kappa_s'
    prop_values = '1780.0 1697 ${fparse 1 * 26}'
    block = 'side_reflector'
  []

  [graphite_rho_and_cp_bottom_reflector]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s kappa_s'
    prop_values = '1780.0 1697 ${fparse 0.7 * 26}'
    block = 'bottom_reflector'
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fluid_properties_obj
    pebble_diameter =  ${pebble_diameter}
    porosity = porosity
    T_fluid = T_fluid
    T_solid = T_solid
    block = pebble_bed
  []

  [drag_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = '0 0 0 0 0 0'
    block = 'cavity'
  []

  [drag_bottom_reflector]
    type = FunctorChurchillDragCoefficients
    multipliers = '1e4 1 1e4'
    block = 'bottom_reflector'
  []

  [porosity_material]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'pebble_bed       0.39
                               cavity           1
                               bottom_reflector 0.3
                               side_reflector   0'
  []

  [kappa_s_pebble_bed]
    type = FunctorPebbleBedKappaSolid
    T_solid = T_solid
    porosity = porosity
    solid_conduction = ZBS
    emissivity = 0.8
    infinite_porosity = 0.39
    Youngs_modulus = 9e+9
    Poisson_ratio = 0.1360
    lattice_parameters = interpolation
    coordination_number = You
    wall_distance = bed_geometry
    block = 'pebble_bed'
    pebble_diameter =  ${pebble_diameter}
    acceleration = '0.00 -9.81 0.00 '
  []

  [effective_pebble_bed_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'kappa_s kappa_s kappa_s'
    block = 'pebble_bed
             bottom_reflector
             side_reflector'
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
    block = 'cavity bottom_reflector'
  []

  [pebble_bed_alpha]
    type = FunctorKTAPebbleBedHTC
    T_solid = T_solid
    T_fluid = T_fluid
    mu = mu
    porosity = porosity
    pressure = pressure
    fp = fluid_properties_obj
    pebble_diameter =  ${pebble_diameter}
    block = 'pebble_bed'
  []

  [reflector_alpha]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '2e4'
    block = 'bottom_reflector'
  []

  [characteristic_length]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = characteristic_length
    subdomain_to_prop_value = 'pebble_bed       ${pebble_diameter}
                               bottom_reflector ${bottom_reflector_Dh}'
  []
[]

[Executioner]
  type = Transient
  end_time = 100000
  [TimeStepper]
    type = IterationAdaptiveDT
    iteration_window = 2
    optimal_iterations = 8
    cutback_factor = 0.8
    growth_factor = 1.6
    dt = 5e-3
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
    boundary = 'inlet'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []

  [outlet_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    boundary = 'outlet'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []

  [inlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = inlet
    outputs = none
  []

  [outlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = outlet
    outputs = none
  []

  [pressure_drop]
    type = ParsedPostprocessor
    pp_names = 'inlet_pressure outlet_pressure'
    function = 'inlet_pressure - outlet_pressure'
  []

  [enthalpy_inlet]
    type = VolumetricFlowRate
    boundary = inlet
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    advected_quantity = 'rho_cp_temp'
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_outlet]
    type = VolumetricFlowRate
    boundary = outlet
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
    block = pebble_bed
  []

  [mass_flux_weighted_Tf_out]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    density = rho
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    boundary = outlet
    advected_quantity = T_fluid
  []
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]
