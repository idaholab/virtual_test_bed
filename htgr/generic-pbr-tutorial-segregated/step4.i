# ==============================================================================
# Model description:
# Step4 - Step3 plus solid conduction equation and a heat source in the
# pebble-bed.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 15, 2023 04:03 PM
# Author(s): Joseph R. Brennan, Dr. Sebastian Schunert, Dr. Mustafa K. Jaradat
#            and Dr. Paolo Balestra.
# ------------------------------------------------------------------------------
# Converted to the segregated SIMPLE solver by Alberic Seydoux on Jun 19, 2026.
# ==============================================================================
advected_interp_method = 'upwind'
bed_radius = 1.2
bed_height = 10.0
bed_porosity = 0.39
cavity_height = 0.5
outlet_pressure = 5.5e6
density = 8.7325
pebble_diameter = 0.06
T_inlet = 300
h_inlet = 1.56e6

# scales the heat source to integrate to 200 MW
power_fn_scaling = 0.88689239556

# moves the heat source around axially to have the peak in the right spot
offset = 0.56331

solid_thermal_conductivity = 20
alpha = 2e4

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
    input = rename_blocks
    primary_block = bed
    paired_block = cavity
    new_boundary = baffle
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
    pressure_baffle_sidesets = baffle
    pressure_baffle_relaxation = 0.5
    use_flux_velocity_reconstruction = true
    use_reconstructed_pressure_gradient = true
    flux_velocity_reconstruction_relaxation = 1.0
    reconstructed_pressure_gradient_feedback_relaxation = 1.0
    flux_velocity_reconstruction_zero_flux_sidesets = 'left right'
    use_interpolated_density_in_bernoulli_jump = true
    use_corrected_pressure_gradient = true
    pressure_projection_method = consistent
  []
[]

[Variables]
  [superficial_u]
    type = MooseLinearVariableFVReal
    solver_sys = u_system
    initial_condition = 0.0
  []
  [superficial_v]
    type = MooseLinearVariableFVReal
    solver_sys = v_system
    initial_condition = -${flow_vel}
  []
  [pressure]
    type = MooseLinearVariableFVReal
    solver_sys = pressure_system
    initial_condition = ${outlet_pressure}
  []

  [h_fluid]
    type = MooseLinearVariableFVReal
    solver_sys = energy_system
    initial_condition = ${h_inlet}
  []

  [T_solid]
    type = MooseLinearVariableFVReal
    solver_sys = solid_energy_system
    initial_condition = ${T_inlet}
    block = 'bed'
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
  []

  [fluid_energy_diffusion]
    type = LinearFVAnisotropicDiffusion
    variable = h_fluid
    diffusion_tensor = kappa_h
    use_nonorthogonal_correction = false
  []

  [fluid_solid_exchange]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = h_fluid
    h_solid_fluid = alpha
    cp = cp
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    block = 'bed'
  []

  [solid_energy_diffusion]
    type = LinearFVDiffusion
    variable = T_solid
    diffusion_coeff = kappa_s
    use_nonorthogonal_correction = false
    block = 'bed'
  []

  [source]
    type = LinearFVSource
    variable = T_solid
    source_density = heat_source_fn
    block = 'bed'
  []

  [convection_pebble_bed_fluid]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = T_solid
    h_solid_fluid = alpha
    cp = 1.0
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    block = 'bed'
  []
[]

[LinearFVBCs]
  [inlet_u]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = superficial_u
    functor = 0.0
  []
  [inlet_v]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = superficial_v
    functor = -${flow_vel}
  []
  [inlet_rho]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = rho_aux
    functor = ${density}
  []

  [pressure-extrapolation]
    type = LinearFVExtrapolatedPressureBC
    boundary = top
    variable = pressure
    use_two_term_expansion = true
  []

  [outlet_u]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = bottom
    variable = superficial_u
    use_two_term_expansion = true
    assume_fully_developed_flow = true
  []
  [outlet_v]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = bottom
    variable = superficial_v
    use_two_term_expansion = true
    assume_fully_developed_flow = true
  []
  [outlet_p]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = bottom
    variable = pressure
    functor = ${outlet_pressure}
  []

  [symmetry_u]
    type = LinearFVVelocitySymmetryBC
    boundary = 'left right'
    variable = superficial_u
    u = superficial_u
    v = superficial_v
    momentum_component = x
  []
  [symmetry_v]
    type = LinearFVVelocitySymmetryBC
    boundary = 'left right'
    variable = superficial_v
    u = superficial_u
    v = superficial_v
    momentum_component = y
  []
  [pressure_symmetric]
    type = LinearFVPressureSymmetryBC
    boundary = 'left right'
    variable = pressure
    HbyA_flux = 'HbyA'
  []

  [top_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = top
    variable = h_fluid
    functor = ${h_inlet}
  []

  [side_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = 'left right'
    variable = h_fluid
    functor = 0.0
  []

  [bottom_h_fluid]
    type = LinearFVAdvectionDiffusionOutflowBC
    boundary = bottom
    variable = h_fluid
    use_two_term_expansion = false
  []

  [side_T_solid]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = 'left right'
    variable = T_solid
    functor = 0.0
    diffusion_coeff = kappa_s
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
  []

  [fluid_props]
    type = GeneralFunctorFluidProps
    fp = fp
    pressure = pressure
    T_fluid = T_fluid
    speed = speed
    porosity = porosity
    characteristic_length = ${pebble_diameter}
  []

  [porosity]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'bed ${bed_porosity} cavity 1'
  []

  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    fp = fp
    pebble_diameter = ${pebble_diameter}
    porosity = porosity
    T_fluid = T_fluid
    T_solid = T_solid
    block = bed
  []

  [drag_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = '0 0 0 0 0 0'
    block = cavity
  []

  [fluid_enthalpy_material]
    type = LinearFVEnthalpyFunctorMaterial
    pressure = pressure
    T_fluid = T_fluid
    h = h_fluid
    fp = fp
  []

  [kappa_f_pebble_bed]
    type = FunctorLinearPecletKappaFluid
    porosity = porosity
    block = bed
  []

  [kappa_f_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = cavity
  []

  [kappa_h_material]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa_h'
    prop_values = 'kappa_over_cp_x kappa_over_cp_y kappa_over_cp_z'
  []

  [solid_k]
    type = GenericFunctorMaterial
    prop_names = 'kappa_s'
    prop_values = '${solid_thermal_conductivity}'
    block = bed
  []

  [alpha_mat]
    type = GenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '${alpha}'
    block = bed
  []
[]

[AuxVariables]
  [rho_aux]
    type = MooseLinearVariableFVReal
  []

  [T_fluid]
    type = MooseLinearVariableFVReal
    initial_condition = ${T_inlet}
  []

  [cp_var]
    type = MooseLinearVariableFVReal
  []

  [kappa_x]
    type = MooseLinearVariableFVReal
  []

  [kappa_y]
    type = MooseLinearVariableFVReal
  []

  [kappa_z]
    type = MooseLinearVariableFVReal
  []

  [kappa_over_cp_x]
    type = MooseLinearVariableFVReal
  []

  [kappa_over_cp_y]
    type = MooseLinearVariableFVReal
  []

  [kappa_over_cp_z]
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

  [fluid_temperature]
    type = FunctorAux
    variable = T_fluid
    functor = T_from_p_h
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_cp]
    type = FunctorAux
    variable = cp_var
    functor = cp
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_x]
    type = ADFunctorVectorElementalAux
    variable = kappa_x
    functor = kappa
    component = 0
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_y]
    type = ADFunctorVectorElementalAux
    variable = kappa_y
    functor = kappa
    component = 1
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_z]
    type = ADFunctorVectorElementalAux
    variable = kappa_z
    functor = kappa
    component = 2
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_x]
    type = ParsedAux
    variable = kappa_over_cp_x
    coupled_variables = 'kappa_x cp_var'
    expression = 'kappa_x / cp_var'
    enable_jit = false
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_y]
    type = ParsedAux
    variable = kappa_over_cp_y
    coupled_variables = 'kappa_y cp_var'
    expression = 'kappa_y / cp_var'
    enable_jit = false
    execute_on = 'INITIAL NONLINEAR'
  []

  [assign_kappa_over_cp_z]
    type = ParsedAux
    variable = kappa_over_cp_z
    coupled_variables = 'kappa_z cp_var'
    expression = 'kappa_z / cp_var'
    enable_jit = false
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

  [enthalpy_inlet]
    type = RhieChowMassFlowRate
    boundary = top
    rhie_chow_user_object = rc
    advected_quantity = h_fluid
    advected_interp_method = 'upwind'
    outputs = none
  []

  [enthalpy_outlet]
    type = RhieChowMassFlowRate
    boundary = bottom
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
    block = bed
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

  momentum_absolute_tolerance = '1e-1 1e-8'
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
