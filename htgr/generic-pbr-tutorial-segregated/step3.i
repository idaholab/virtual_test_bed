# ==============================================================================
# Model description:
# Step3 - Step2 with cavity on top.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 15, 2023 04:03 PM
# Author(s): Joseph R. Brennan, Dr. Sebastian Schunert, Dr. Mustafa K. Jaradat
#            and Dr. Paolo Balestra.
# ------------------------------------------------------------------------------
# Converted to the segregated SIMPLE solver by Alberic Seydoux on Jun 18, 2026.
# ==============================================================================
advected_interp_method = 'upwind'
bed_radius = 1.2
bed_height = 10.0
cavity_height = 0.5
bed_porosity = 0.39
outlet_pressure = 5.5e6
T_fluid = 300
density = 8.6545
pebble_diameter = 0.06

mass_flow_rate = 60.0
flow_area = '${fparse pi * bed_radius * bed_radius}'
flow_vel = '${fparse mass_flow_rate / flow_area / density}'

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
    new_block = 'bed cavity'
    input = gen
  []

  [baffle]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = bed
    paired_block = cavity
    new_boundary = baffle
    input = rename_blocks
  []
  coord_type = RZ
[]

[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[Problem]
  linear_sys_names = 'u_system v_system pressure_system'
  previous_nl_solution_required = true
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
    pressure_baffle_sidesets = baffle
    pressure_baffle_relaxation = 0.1
    debug_baffle = false
    use_interpolated_density_in_bernoulli_jump = true
    use_flux_velocity_reconstruction = true
    use_reconstructed_pressure_gradient = true
    flux_velocity_reconstruction_relaxation = 1.0
    flux_velocity_reconstruction_zero_flux_sidesets = 'right left'
    pressure_gradient_limiter = baffle
    pressure_gradient_limiter_blend = 0.0
    use_corrected_pressure_gradient = true
    reconstructed_pressure_gradient_feedback_relaxation = 1.0
    pressure_projection_method = consistent
  []
[]

[Variables]
  [superficial_u]
    type = MooseLinearVariableFVReal
    solver_sys = u_system
    initial_condition = 0
  []
  [superficial_v]
    type = MooseLinearVariableFVReal
    solver_sys = v_system
    initial_condition = -${flow_vel}
  []
  [pressure]
    type = MooseLinearVariableFVReal
    solver_sys = pressure_system
    initial_condition = 5.4e6
  []
[]

[FunctorMaterials]
  [speed_material]
    type = PINSFVSpeedFunctorMaterial
    superficial_vel_x = superficial_u
    superficial_vel_y = superficial_v
    porosity = porosity
  []

  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid = ${T_fluid}
    speed = speed
    characteristic_length = ${pebble_diameter}
    neglect_derivatives_of_density_time_derivative = false
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fluid_properties_obj
    pebble_diameter = ${pebble_diameter}
    porosity = porosity
    T_fluid = ${T_fluid}
    T_solid = ${T_fluid}
    block = bed
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
    subdomain_to_prop_value = 'bed    ${bed_porosity}
                               cavity 1'
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
  [p_diffusion]
    type = LinearFVAnisotropicDiffusionJump
    variable = pressure
    diffusion_tensor = Ainv
    rhie_chow_user_object = rc
    use_nonorthogonal_correction = false
    debug_baffle_jump = false
  []
  [HbyA_divergence]
    type = LinearFVDivergence
    variable = pressure
    face_flux = HbyA
    force_boundary_execution = true
  []
[]

[LinearFVBCs]
  [top_u]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = superficial_u
    functor = 0.0
  []

  [bottom_u]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = bottom
    variable = superficial_u
    use_two_term_expansion = false
  []

  [top_v]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = superficial_v
    functor = -${flow_vel}
  []

  [bottom_v]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = bottom
    variable = superficial_v
    use_two_term_expansion = false
  []

  [symmetry-u]
    type = LinearFVVelocitySymmetryBC
    boundary = 'left right'
    variable = superficial_u
    u = superficial_u
    v = superficial_v
    momentum_component = x
  []

  [symmetry-v]
    type = LinearFVVelocitySymmetryBC
    boundary = 'left right'
    variable = superficial_v
    u = superficial_u
    v = superficial_v
    momentum_component = y
  []

  [top_p]
    type = LinearFVExtrapolatedPressureBC
    boundary = top
    variable = pressure
    use_two_term_expansion = true
  []

  [bottom_p]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = bottom
    variable = pressure
    functor = ${outlet_pressure}
  []

  [pressure-symmetry]
    type = LinearFVPressureSymmetryBC
    boundary = 'left right'
    variable = pressure
    HbyA_flux = 'HbyA'
  []
[]

[AuxVariables]
  [rho_aux]
    type = MooseLinearVariableFVReal
  []
[]

[AuxKernels]
  [assign_rho_aux]
    type = FunctorAux
    variable = rho_aux
    functor = rho
    execute_on = 'INITIAL NONLINEAR'
  []
[]

[Postprocessors]
  [inlet_mfr]
    type = RhieChowMassFlowRate
    boundary = top
    rhie_chow_user_object = rc
  []

  [outlet_mfr]
    type = RhieChowMassFlowRate
    boundary = bottom
    rhie_chow_user_object = rc
  []

  [inlet_pressure]
    type = SideAverageFunctorPostprocessor
    functor = pressure
    functor_argument = face
    boundary = top
    outputs = none
  []

  [outlet_pressure]
    type = SideAverageFunctorPostprocessor
    functor = pressure
    functor_argument = face
    boundary = bottom
    outputs = none
  []

  [pressure_drop]
    type = ParsedPostprocessor
    pp_names = 'inlet_pressure outlet_pressure'
    expression = 'inlet_pressure - outlet_pressure'
  []

  [integral_density]
    type = ADElementIntegralFunctorPostprocessor
    functor = rho
    outputs = none
  []

  [average_density]
    type = ParsedPostprocessor
    pp_names = 'volume integral_density'
    expression = 'integral_density / volume'
  []

  [integral_mu]
    type = ADElementIntegralFunctorPostprocessor
    functor = mu
    outputs = none
  []

  [average_mu]
    type = ParsedPostprocessor
    pp_names = 'volume integral_mu'
    expression = 'integral_mu / volume'
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

[Executioner]
  type = SIMPLE
  momentum_l_abs_tol = 1e-14
  pressure_l_abs_tol = 1e-14
  momentum_l_tol = 0
  pressure_l_tol = 0
  rhie_chow_user_object = rc
  momentum_systems = 'u_system v_system'
  pressure_system = pressure_system
  momentum_equation_relaxation = 0.4
  pressure_variable_relaxation = 1.0
  num_iterations = 1000
  pressure_absolute_tolerance = 1e-8
  momentum_absolute_tolerance = '1e-3 1e-8'
  momentum_petsc_options_iname = '-pc_type -pc_hypre_type'
  momentum_petsc_options_value = 'hypre boomeramg'
  pressure_petsc_options_iname = '-pc_type -pc_hypre_type'
  pressure_petsc_options_value = 'hypre boomeramg'
  continue_on_max_its = false
[]

[Outputs]
  exodus = true
  csv = true
[]
