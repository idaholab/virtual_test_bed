# ==============================================================================
# Model description:
# Step5 - Step4 plus reflector.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 15, 2023 04:03 PM
# Author(s): Joseph R. Brennan, Dr. Sebastian Schunert, Dr. Mustafa K. Jaradat
#            and Dr. Paolo Balestra.
# ------------------------------------------------------------------------------
# Converted to the segregated SIMPLE solver by Alberic Seydoux on Jun 19, 2026.
# ==============================================================================
advected_interp_method = 'upwind'
bed_radius = 1.2
bed_porosity = 0.39
outlet_pressure = 5.84e6
inlet_density = 5.2955
bottom_reflector_Dh = 0.1
pebble_diameter = 0.06
T_inlet = 533.25
h_inlet = 2.7729e6

# scales the heat source to integrate to 200 MW
power_fn_scaling = 0.9792628

# moves the heat source around axially to have the peak in the right spot
offset = -0.29119

# the y-coordinate of the top of the core
top_core = 9.7845

mass_flow_rate = 64.3
flow_area = '${fparse pi * bed_radius * bed_radius}'
flow_vel = '${fparse mass_flow_rate / flow_area / inlet_density}'

[Mesh]
  block_id = '1 2 3 4'
  block_name = 'pebble_bed cavity bottom_reflector side_reflector'

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = '0.20 0.20 0.20 0.20 0.20 0.20 0.010 0.055'
    ix = '1 1 1 1 1 1 1 1'

    dy = '0.1709 0.1709 0.1709 0.1709 0.1709
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

  [baffle]
    type = SideSetsBetweenSubdomainsGenerator
    input = side_reflector_bottom_reflector
    primary_block = 1
    paired_block = 2
    new_boundary = baffle
  []

  [bed_br_baffle]
    type = SideSetsBetweenSubdomainsGenerator
    input = baffle
    primary_block = 1
    paired_block = 3
    new_boundary = bed_br_baffle
  []

  [BreakBoundary]
    type = BreakBoundaryOnSubdomainGenerator
    input = bed_br_baffle
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
    new_boundary = 'inlet    outlet     bed_left  bed_left  bed_left  bed_right           bed_right                       bed_right'
  []

  coord_type = RZ
[]

[Problem]
  linear_sys_names = 'u_system v_system pressure_system energy_system solid_energy_system'
  previous_nl_solution_required = true
[]

[FluidProperties]
  [fp]
    type = HeliumFluidProperties
  []
[]

[UserObjects]
  [rc]
    type = PorousRhieChowMassFlux
    u = superficial_u
    v = superficial_v
    pressure = pressure
    rho = rho_aux
    porosity = porosity
    p_diffusion_kernel = p_diffusion
    pressure_baffle_sidesets = 'baffle bed_br_baffle'
    pressure_baffle_relaxation = 0.5
    reconstructed_pressure_gradient_feedback_relaxation = 1.0
    pressure_projection_method = consistent
    block = 'pebble_bed cavity bottom_reflector'
    use_flux_velocity_reconstruction = true
    use_reconstructed_pressure_gradient = true
    flux_velocity_reconstruction_relaxation = 1.0
    flux_velocity_reconstruction_zero_flux_sidesets = 'bed_left bed_right'
    use_interpolated_density_in_bernoulli_jump = true
    use_corrected_pressure_gradient = true
  []

  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = ${top_core}
    inner_radius = 0.0
    outer_radius = 1.2
  []
[]

[Variables]
  [superficial_u]
    type = MooseLinearVariableFVReal
    solver_sys = u_system
    initial_condition = 0.0
    block = 'pebble_bed cavity bottom_reflector'
  []
  [superficial_v]
    type = MooseLinearVariableFVReal
    solver_sys = v_system
    initial_condition = -${flow_vel}
    block = 'pebble_bed cavity bottom_reflector'
  []
  [pressure]
    type = MooseLinearVariableFVReal
    solver_sys = pressure_system
    initial_condition = ${outlet_pressure}
    block = 'pebble_bed cavity bottom_reflector'
  []

  [h_fluid]
    type = MooseLinearVariableFVReal
    solver_sys = energy_system
    initial_condition = ${h_inlet}
    block = 'pebble_bed cavity bottom_reflector'
  []

  [T_solid]
    type = MooseLinearVariableFVReal
    solver_sys = solid_energy_system
    initial_condition = ${T_inlet}
    block = 'pebble_bed bottom_reflector side_reflector'
  []
[]

[LinearFVKernels]
  [u_advection]
    type = PorousLinearWCNSFVMomentumFlux
    variable = superficial_u
    advected_interp_method = ${advected_interp_method}
    mu = mu
    u = superficial_u
    v = superficial_v
    momentum_component = 'x'
    rhie_chow_user_object = rc
    use_nonorthogonal_correction = false
    porosity_outside_divergence = true
    use_two_point_stress_transmissibility = true
  []
  [v_advection]
    type = PorousLinearWCNSFVMomentumFlux
    variable = superficial_v
    advected_interp_method = ${advected_interp_method}
    mu = mu
    u = superficial_u
    v = superficial_v
    momentum_component = 'y'
    rhie_chow_user_object = rc
    use_nonorthogonal_correction = false
    porosity_outside_divergence = true
    use_two_point_stress_transmissibility = true
  []
  [u_pressure]
    type = LinearFVMomentumPressureUO
    variable = superficial_u
    momentum_component = 'x'
    rhie_chow_user_object = rc
    porosity = porosity
    use_corrected_gradient = true
  []
  [v_pressure]
    type = LinearFVMomentumPressureUO
    variable = superficial_v
    momentum_component = 'y'
    rhie_chow_user_object = rc
    porosity = porosity
    use_corrected_gradient = true
  []
  [p_diffusion]
    type = LinearFVAnisotropicDiffusionJump
    variable = pressure
    diffusion_tensor = Ainv
    rhie_chow_user_object = rc
    use_nonorthogonal_correction = false
  []
  [HbyA_divergence]
    type = LinearFVDivergence
    variable = pressure
    face_flux = HbyA
    force_boundary_execution = true
  []

  [u_friction]
    type = LinearFVMomentumPorousFriction
    variable = superficial_u
    Forchheimer_name = Forchheimer_coefficient
    Darcy_name = Darcy_coefficient
    porosity = porosity
    rho = rho_aux
    mu = mu
    u = superficial_u
    v = superficial_v
    momentum_component = 'x'
  []

  [v_friction]
    type = LinearFVMomentumPorousFriction
    variable = superficial_v
    Forchheimer_name = Forchheimer_coefficient
    Darcy_name = Darcy_coefficient
    porosity = porosity
    rho = rho_aux
    mu = mu
    u = superficial_u
    v = superficial_v
    momentum_component = 'y'
  []

  [fluid_energy_advection]
    type = LinearFVEnergyAdvection
    variable = h_fluid
    advected_quantity = enthalpy
    advected_interp_method = ${advected_interp_method}
    rhie_chow_user_object = rc
    block = 'pebble_bed cavity bottom_reflector'
  []

  [fluid_energy_diffusion]
    type = LinearFVAnisotropicDiffusion
    variable = h_fluid
    diffusion_tensor = kappa_h
    use_nonorthogonal_correction = false
    block = 'pebble_bed cavity bottom_reflector'
  []

  [fluid_solid_exchange]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = h_fluid
    h_solid_fluid = alpha
    cp = cp
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    block = 'pebble_bed bottom_reflector'
  []

  [solid_energy_diffusion]
    type = LinearFVAnisotropicDiffusion
    variable = T_solid
    diffusion_tensor = effective_thermal_conductivity
    use_nonorthogonal_correction = false
    block = 'pebble_bed bottom_reflector side_reflector'
  []

  [source]
    type = LinearFVSource
    variable = T_solid
    source_density = heat_source_fn
    block = 'pebble_bed'
  []

  [convection_pebble_bed_fluid]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = T_solid
    h_solid_fluid = alpha
    cp = 1.0
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    block = 'pebble_bed bottom_reflector'
  []
[]

[LinearFVBCs]
  [inlet_u]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = superficial_u
    functor = 0.0
  []
  [inlet_v]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = superficial_v
    functor = -${flow_vel}
  []
  [inlet_rho]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = rho_aux
    functor = ${inlet_density}
  []

  [pressure-extrapolation]
    type = LinearFVExtrapolatedPressureBC
    boundary = inlet
    variable = pressure
    use_two_term_expansion = true
  []

  [outlet_u]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = outlet
    variable = superficial_u
    use_two_term_expansion = true
    assume_fully_developed_flow = true
  []
  [outlet_v]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = outlet
    variable = superficial_v
    use_two_term_expansion = true
    assume_fully_developed_flow = true
  []
  [outlet_p]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = outlet
    variable = pressure
    functor = ${outlet_pressure}
  []

  [symmetry_u]
    type = LinearFVVelocitySymmetryBC
    boundary = 'bed_left bed_right'
    variable = superficial_u
    u = superficial_u
    v = superficial_v
    momentum_component = x
  []
  [symmetry_v]
    type = LinearFVVelocitySymmetryBC
    boundary = 'bed_left bed_right'
    variable = superficial_v
    u = superficial_u
    v = superficial_v
    momentum_component = y
  []
  [pressure_symmetric]
    type = LinearFVPressureSymmetryBC
    boundary = 'bed_left bed_right'
    variable = pressure
    HbyA_flux = 'HbyA'
  []

  [top_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = h_fluid
    functor = ${h_inlet}
  []

  [side_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = 'bed_left bed_right'
    variable = h_fluid
    functor = 0.0
  []

  [bottom_h_fluid]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = outlet
    variable = h_fluid
    use_two_term_expansion = false
  []

  [side_T_solid]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = bed_left
    variable = T_solid
    functor = 0.0
    diffusion_coeff = k_s
  []
[]

[Functions]
  [heat_source_fn]
    type = ParsedFunction
    expression = '${power_fn_scaling} * (-1.0612e4 * pow(y+${offset}, 4) + 1.5963e5 * pow(y+${offset}, 3)
                   -6.2993e5 * pow(y+${offset}, 2) + 1.4199e6 * (y+${offset}) + 5.5402e4)'
  []
[]

[FunctorMaterials]
  [speed_material]
    type = PINSFVSpeedFunctorMaterial
    superficial_vel_x = superficial_u
    superficial_vel_y = superficial_v
    porosity = porosity
    block = 'pebble_bed cavity bottom_reflector'
  []

  [characteristic_length]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = characteristic_length
    subdomain_to_prop_value = 'pebble_bed       ${pebble_diameter}
                               bottom_reflector ${bottom_reflector_Dh}'
  []

  [fluid_props]
    type = GeneralFunctorFluidProps
    fp = fp
    pressure = pressure
    T_fluid = T_fluid
    speed = speed
    porosity = porosity
    block = 'pebble_bed cavity bottom_reflector'
    characteristic_length = characteristic_length
  []

  [porosity]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'pebble_bed       ${bed_porosity}
                               cavity           1
                               bottom_reflector 0.3
                               side_reflector   0'
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fp
    pebble_diameter = ${pebble_diameter}
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

  [graphite_rho_and_cp_bed]
    type = GenericFunctorMaterial
    prop_names = 'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 26'
    block = 'pebble_bed'
  []

  [graphite_rho_and_cp_side_reflector]
    type = GenericFunctorMaterial
    prop_names = 'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 ${fparse 1 * 26}'
    block = 'side_reflector'
  []

  [graphite_rho_and_cp_bottom_reflector]
    type = GenericFunctorMaterial
    prop_names = 'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 ${fparse 0.7 * 26}'
    block = 'bottom_reflector'
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
    pebble_diameter = ${pebble_diameter}
    acceleration = '0.00 -9.81 0.00 '
  []

  [effective_pebble_bed_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'kappa_s kappa_s kappa_s'
    block = 'pebble_bed'
  []

  [effective_reflector_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'k_s k_s k_s'
    block = 'bottom_reflector side_reflector'
  []

  [fluid_enthalpy_material]
    type = LinearFVEnthalpyFunctorMaterial
    pressure = pressure
    T_fluid = T_fluid
    h = h_fluid
    fp = fp
    block = 'pebble_bed cavity bottom_reflector'
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

  [kappa_h_material]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa_h'
    prop_values = 'kappa_over_cp_x kappa_over_cp_y kappa_over_cp_z'
    block = 'pebble_bed cavity bottom_reflector'
  []

  [pebble_bed_alpha]
    type = FunctorKTAPebbleBedHTC
    T_solid = T_solid
    T_fluid = T_fluid
    mu = mu
    porosity = porosity
    pressure = pressure
    fp = fp
    pebble_diameter = ${pebble_diameter}
    block = 'pebble_bed'
  []

  [reflector_alpha]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '2e4'
    block = 'bottom_reflector'
  []
[]

[AuxVariables]
  [rho_aux]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [T_fluid]
    type = MooseLinearVariableFVReal
    initial_condition = ${T_inlet}
    block = 'pebble_bed cavity bottom_reflector'
  []

  [cp_var]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_x]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_y]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_z]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_over_cp_x]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_over_cp_y]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

  [kappa_over_cp_z]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector'
  []

[]

[AuxKernels]
  [assign_rho_aux]
    type = FunctorAux
    variable = rho_aux
    block = 'pebble_bed cavity bottom_reflector'
    functor = 'rho'
    execute_on = 'INITIAL NONLINEAR'
  []

  [fluid_temperature]
    type = FunctorAux
    variable = T_fluid
    functor = T_from_p_h
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_cp]
    type = FunctorAux
    variable = cp_var
    functor = cp
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_x]
    type = ADFunctorVectorElementalAux
    variable = kappa_x
    functor = kappa
    component = 0
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_y]
    type = ADFunctorVectorElementalAux
    variable = kappa_y
    functor = kappa
    component = 1
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_z]
    type = ADFunctorVectorElementalAux
    variable = kappa_z
    functor = kappa
    component = 2
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_x]
    type = ParsedAux
    variable = kappa_over_cp_x
    coupled_variables = 'kappa_x cp_var'
    expression = 'kappa_x / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_y]
    type = ParsedAux
    variable = kappa_over_cp_y
    coupled_variables = 'kappa_y cp_var'
    expression = 'kappa_y / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_z]
    type = ParsedAux
    variable = kappa_over_cp_z
    coupled_variables = 'kappa_z cp_var'
    expression = 'kappa_z / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector'
    execute_on = 'INITIAL NONLINEAR'
  []
[]

[Postprocessors]
  [inlet_pressure]
    type = SideAverageFunctorPostprocessor
    functor = pressure
    functor_argument = face
    boundary = inlet
    outputs = none
  []

  [outlet_pressure]
    type = SideAverageFunctorPostprocessor
    functor = pressure
    functor_argument = face
    boundary = outlet
    outputs = none
  []

  [pressure_drop]
    type = ParsedPostprocessor
    pp_names = 'inlet_pressure outlet_pressure'
    expression = 'inlet_pressure - outlet_pressure'
  []

  [inlet_mfr]
    type = RhieChowMassFlowRate
    boundary = inlet
    rhie_chow_user_object = rc
  []
  [outlet_mfr]
    type = RhieChowMassFlowRate
    boundary = outlet
    rhie_chow_user_object = rc
  []

  [enthalpy_inlet]
    type = RhieChowMassFlowRate
    boundary = inlet
    rhie_chow_user_object = rc
    advected_quantity = h_fluid
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_outlet]
    type = RhieChowMassFlowRate
    boundary = outlet
    rhie_chow_user_object = rc
    advected_quantity = h_fluid
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_balance]
    type = ParsedPostprocessor
    pp_names = 'enthalpy_inlet enthalpy_outlet'
    expression = 'enthalpy_inlet + enthalpy_outlet'
  []

  [heat_source_integral]
    type = ElementIntegralFunctorPostprocessor
    functor = heat_source_fn
    block = pebble_bed
  []

  [outlet_temperature_flow]
    type = RhieChowMassFlowRate
    boundary = outlet
    rhie_chow_user_object = rc
    advected_quantity = T_fluid
    outputs = none
  []

  [mass_flux_weighted_Tf_out]
    type = ParsedPostprocessor
    pp_names = 'outlet_temperature_flow outlet_mfr'
    expression = 'outlet_temperature_flow / outlet_mfr'
  []
[]

[Executioner]
  type = SIMPLE
  momentum_l_abs_tol = 1e-14
  pressure_l_abs_tol = 1e-16
  momentum_l_tol = 0
  pressure_l_tol = 0
  rhie_chow_user_object = rc
  momentum_systems = 'u_system v_system'
  pressure_system = pressure_system
  momentum_equation_relaxation = 0.1
  pressure_variable_relaxation = 1.0
  num_iterations = 1000
  pressure_absolute_tolerance = 1e-8

  momentum_absolute_tolerance = '1e-6 1e-8'
  momentum_petsc_options_iname = '-pc_type -pc_hypre_type'
  momentum_petsc_options_value = 'hypre boomeramg'
  pressure_petsc_options_iname = '-pc_type -pc_hypre_type'
  pressure_petsc_options_value = 'hypre boomeramg'
  continue_on_max_its = false

  energy_system = energy_system
  energy_l_abs_tol = 1e-12
  energy_l_tol = 0
  energy_equation_relaxation = 0.9
  energy_field_relaxation = 1.0
  energy_absolute_tolerance = 1e-8
  energy_petsc_options_iname = '-pc_type -pc_hypre_type'
  energy_petsc_options_value = 'hypre boomeramg'

  solid_energy_system = solid_energy_system
  solid_energy_l_abs_tol = 1e-12
  solid_energy_l_tol = 0
  solid_energy_field_relaxation = 1.0
  solid_energy_absolute_tolerance = 1e-8
  solid_energy_petsc_options_iname = '-pc_type -pc_hypre_type'
  solid_energy_petsc_options_value = 'hypre boomeramg'
[]

[Outputs]
  exodus = true
  csv = true
[]
