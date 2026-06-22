# ==============================================================================
# Model description:
# Step7 - Step6 plus control eod bypass.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 15, 2023 04:03 PM
# Author(s): Joseph R. Brennan, Dr. Sebastian Schunert, Dr. Mustafa K. Jaradat
#            and Dr. Paolo Balestra.
# ------------------------------------------------------------------------------
# Converted to the segregated SIMPLE solver by Alberic Seydoux on Jun 22, 2026.
# ==============================================================================
p_out                  = 5.84e6
rho_f                  = 5.3305
bed_porosity           = 0.39
bottom_reflector_Dh    = 0.1
c_drag_old             = 10
cp_f                   = 5200
pebble_diameter        = 0.06
power_fn_scaling       = 0.9792628
offset                 = -0.29119
thermal_mass_scaling   = 0.01
rho_s                  = 1780
cp_s                   = 1697
mass_flow_rate         = 64.3
riser_inner_radius     = 1.701
riser_outer_radius     = 1.871
flow_area              = '${fparse pi * (riser_outer_radius * riser_outer_radius - riser_inner_radius * riser_inner_radius)}'
flow_vel               = '${fparse mass_flow_rate / (flow_area * rho_f)}'
riser_Dh               = 0.17
control_rod_Dh         = 0.1
T_inlet                = 533.25
h_inlet                = '${fparse cp_f * T_inlet}'
advected_interp_method = 'upwind'
axial_coordinate_shift = 1.167
top_core               = 10.9515

[Mesh]
  type = MeshGeneratorMesh

  block_id = '1 2 3 4 5 6 7 8'
  block_name = 'pebble_bed cavity bottom_reflector side_reflector bottom_plenum upper_plenum riser control_rods'

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = '0.20 0.20 0.20 0.20 0.20 0.20
          0.010 0.055
          0.13
          0.102 0.102 0.102
          0.17
          0.120'

    ix = '1 1 1 1 1 1
          1 1
          1
          1 1 1
          2
          1'

    dy = '0.100 0.100 0.967
          0.1709 0.1709 0.1709 0.1709 0.1709
          0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
          0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465 0.4465
          0.458 0.712'

    iy = '1 2 2
          2 2 1 1 1
          4 1 1 1 1 1 1 1 1 1
          1 1 1 1 1 1 1 1 1 4
          4 2'

    subdomain_id = '4 4 4 4 4 4 4 4 4 4 4 4 4 4
                    4 4 4 4 4 4 4 4 4 4 4 4 4 4
                    5 5 5 5 5 5 5 5 5 4 4 4 7 4
                    3 3 3 3 3 3 4 4 8 4 4 4 7 4
                    3 3 3 3 3 3 4 4 8 4 4 4 7 4
                    3 3 3 3 3 3 4 4 8 4 4 4 7 4
                    3 3 3 3 3 3 4 4 8 4 4 4 7 4
                    3 3 3 3 3 3 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    1 1 1 1 1 1 4 4 8 4 4 4 7 4
                    2 2 2 2 2 2 6 6 6 6 6 6 7 4
                    4 4 4 4 4 4 4 4 4 4 4 4 4 4'
  []

  [cavity_top]
    type = SideSetsAroundSubdomainGenerator
    input = cartesian_mesh
    block = 2
    normal = '0 1 0'
    new_boundary = cavity_top
  []

  [upper_plenum_top]
    type = SideSetsAroundSubdomainGenerator
    input = cavity_top
    block = 6
    normal = '0 1 0'
    new_boundary = upper_plenum_top
  []

  [upper_plenum_bottom]
    type = ParsedGenerateSideset
    input = upper_plenum_top
    combinatorial_geometry = 'abs(y - 11.335) < 1e-3'
    included_subdomains = 6
    included_neighbors = 4
    new_sideset_name = upper_plenum_bottom
  []

  [up_riser_baffle]
    type = SideSetsAroundSubdomainGenerator
    input = upper_plenum_bottom
    block = 6
    normal = '1 0 0'
    new_boundary = up_riser_baffle
  []

  [baffle_cav_up]
    type = SideSetsBetweenSubdomainsGenerator
    input = up_riser_baffle
    primary_block = 6
    paired_block = 2
    new_boundary = baffle_cav_up
  []

  [side_reflector_bed]
    type = SideSetsBetweenSubdomainsGenerator
    input = baffle_cav_up
    primary_block = 4
    paired_block = 1
    new_boundary = side_reflector_bed
  []

  [bottom_plenum_bottom]
    type = SideSetsAroundSubdomainGenerator
    input = side_reflector_bed
    block = 5
    new_boundary = bottom_plenum_bottom
    normal = '0 -1 0'
  []

  [bottom_plenum_top]
    type = SideSetsBetweenSubdomainsGenerator
    input = bottom_plenum_bottom
    primary_block = 5
    paired_block = 4
    normal = '0 1 0'
    new_boundary = bottom_plenum_top
  []

  [control_rod_right]
    type = SideSetsAroundSubdomainGenerator
    input = bottom_plenum_top
    block = 8
    normal = '1 0 0'
    new_boundary = control_rod_right
  []

  [control_rod_left]
    type = SideSetsAroundSubdomainGenerator
    input = control_rod_right
    block = 8
    normal = '-1 0 0'
    new_boundary = control_rod_left
  []

  [control_rods_bottom_plenum]
    type = SideSetsBetweenSubdomainsGenerator
    input = control_rod_left
    primary_block = 8
    paired_block = 5
    new_boundary = control_rod_outlet
  []

  [control_rods_upper_plenum]
    type = SideSetsBetweenSubdomainsGenerator
    input = control_rods_bottom_plenum
    primary_block = 8
    paired_block = 6
    new_boundary = control_rod_inlet
  []

  [outlet]
    type = SideSetsAroundSubdomainGenerator
    input = control_rods_upper_plenum
    block = 5
    normal = '1 0 0'
    new_boundary = outlet
  []

  [cr_top]
    type = ParsedGenerateSideset
    input = outlet
    combinatorial_geometry = 'abs(y - 10.9515) < 1e-6'
    included_subdomains = 6
    included_neighbors = 4
    new_sideset_name = cr_top
  []

  [side_reflector_bottom_reflector]
    type = SideSetsBetweenSubdomainsGenerator
    input = cr_top
    primary_block = 3
    paired_block = 4
    new_boundary = side_reflector_bottom_reflector
  []

  [baffle_cav_bed]
    type = SideSetsBetweenSubdomainsGenerator
    input = side_reflector_bottom_reflector
    primary_block = 1
    paired_block = 2
    new_boundary = baffle_cav_bed
  []

  [bed_br_baffle]
    type = SideSetsBetweenSubdomainsGenerator
    input = baffle_cav_bed
    primary_block = 1
    paired_block = 3
    new_boundary = bed_br_baffle
  []

  [br_bp_baffle]
    type = SideSetsBetweenSubdomainsGenerator
    input = bed_br_baffle
    primary_block = 3
    paired_block = 5
    new_boundary = br_bp_baffle
  []

  [riser_right]
    type = SideSetsAroundSubdomainGenerator
    input = br_bp_baffle
    block = 7
    normal = '1 0 0'
    new_boundary = riser_right
  []

  [riser_left]
    type = ParsedGenerateSideset
    input = riser_right
    combinatorial_geometry = 'abs(x - 1.701) < 1e-3'
    included_subdomains = 7
    included_neighbors = 4
    new_sideset_name = riser_left
  []

  [inlet]
    type = SideSetsAroundSubdomainGenerator
    input = riser_left
    block = 7
    normal = '0 -1 0'
    new_boundary = inlet
  []

  [riser_top]
    type = SideSetsAroundSubdomainGenerator
    input = inlet
    block = 7
    normal = '0 1 0'
    new_boundary = riser_top
  []

  [BreakBoundary]
    type = BreakBoundaryOnSubdomainGenerator
    input = riser_top
    boundaries = 'left'
  []

  [DeleteBoundary]
    type = BoundaryDeletionGenerator
    input = BreakBoundary
    boundary_names = 'left right top bottom'
  []

  [RenameBoundaryGenerator]
    type = RenameBoundaryGenerator
    input = DeleteBoundary
    old_boundary = ' left_to_1 left_to_2 left_to_3 left_to_4 left_to_5 side_reflector_bed side_reflector_bottom_reflector bottom_plenum_bottom bottom_plenum_top cavity_top       upper_plenum_top cr_top           control_rod_left control_rod_right riser_left  riser_right riser_top'
    new_boundary = '     bed_left  bed_left  bed_left  bed_left  bed_left  bed_right          bed_right                      horizontal_walls    horizontal_walls horizontal_walls horizontal_walls horizontal_walls riser_walls      riser_walls       riser_walls riser_walls horizontal_walls'
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
    rho = 'rho_aux'
    porosity = 'porosity'
    p_diffusion_kernel = p_diffusion

    pressure_baffle_sidesets = 'baffle_cav_bed baffle_cav_up bed_br_baffle up_riser_baffle control_rod_inlet control_rod_outlet br_bp_baffle'
    pressure_baffle_relaxation = 1.0

    reconstructed_pressure_gradient_feedback_relaxation = 1.0
    pressure_projection_method = consistent

    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'

    debug_baffle = false

    use_flux_velocity_reconstruction = true
    use_reconstructed_pressure_gradient = true
    flux_velocity_reconstruction_relaxation = 1.0
    flux_velocity_reconstruction_zero_flux_sidesets = 'bed_left bed_right horizontal_walls riser_walls'

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

[Executioner]
  type = SIMPLE
  momentum_l_abs_tol = 1e-12
  pressure_l_abs_tol = 1e-14
  momentum_l_tol = 0
  pressure_l_tol = 0
  rhie_chow_user_object = rc
  momentum_systems = 'u_system v_system'
  pressure_system = pressure_system
  momentum_equation_relaxation = 0.4
  pressure_variable_relaxation = 0.3
  num_iterations = 1000
  pressure_absolute_tolerance = 1e-8
  momentum_absolute_tolerance = '1e-8 1e-8'
  momentum_petsc_options_iname = '-pc_type -pc_hypre_type'
  momentum_petsc_options_value = 'hypre boomeramg'
  pressure_petsc_options_iname = '-pc_type -pc_hypre_type'
  pressure_petsc_options_value = 'hypre boomeramg'
  print_fields = false
  continue_on_max_its = false

  energy_system = energy_system
  energy_l_abs_tol = 1e-12
  energy_l_tol = 0
  energy_equation_relaxation = 0.8
  energy_field_relaxation = 1.0
  energy_absolute_tolerance = 1e-8
  energy_petsc_options_iname = '-pc_type -pc_hypre_type'
  energy_petsc_options_value = 'hypre boomeramg'

  solid_energy_system = solid_energy_system
  solid_energy_l_abs_tol = 1e-10
  solid_energy_l_tol = 0
  solid_energy_field_relaxation = 1.0
  solid_energy_absolute_tolerance = 1e-8
  solid_energy_petsc_options_iname = '-pc_type -pc_hypre_type'
  solid_energy_petsc_options_value = 'hypre boomeramg'
[]

[Variables]
  [superficial_u]
    type = MooseLinearVariableFVReal
    solver_sys = u_system
    initial_condition = 1e-6
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []
  [superficial_v]
    type = MooseLinearVariableFVReal
    solver_sys = v_system
    initial_condition = 1e-6
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []
  [pressure]
    type = MooseLinearVariableFVReal
    solver_sys = pressure_system
    initial_condition = ${p_out}
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [h_fluid]
    type = MooseLinearVariableFVReal
    solver_sys = energy_system
    initial_condition = ${h_inlet}
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [T_solid]
    type = MooseLinearVariableFVReal
    solver_sys = solid_energy_system
    initial_condition = ${T_inlet}
    block = 'pebble_bed bottom_reflector side_reflector bottom_plenum upper_plenum riser control_rods'
  []
[]

[LinearFVKernels]
  [u_advection]
    type = PorousLinearWCNSFVMomentumFlux
    variable = superficial_u
    advected_interp_method = ${advected_interp_method}
    mu = 'mu'
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
    mu = 'mu'
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
    porosity = 'porosity'
    use_corrected_gradient = true
  []
  [v_pressure]
    type = LinearFVMomentumPressureUO
    variable = superficial_v
    momentum_component = 'y'
    rhie_chow_user_object = rc
    porosity = 'porosity'
    use_corrected_gradient = true
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
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [fluid_energy_diffusion]
    type = LinearFVAnisotropicDiffusion
    variable = h_fluid
    diffusion_tensor = kappa_h
    use_nonorthogonal_correction = false
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [fluid_solid_exchange]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = h_fluid
    h_solid_fluid = alpha
    cp = cp
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    block = 'pebble_bed'
  []

  [solid_energy_diffusion]
    type = LinearFVAnisotropicDiffusion
    variable = T_solid
    diffusion_tensor = effective_thermal_conductivity
    use_nonorthogonal_correction = false
    block = 'pebble_bed bottom_reflector side_reflector bottom_plenum upper_plenum riser control_rods'
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

  [fluid_solid_exchange_br]
    type = LinearFVEnthalpyVolumetricHeatTransfer
    variable = h_fluid
    h_solid_fluid = alpha
    cp = cp
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    block = 'bottom_reflector'
  []
[]

[LinearFVBCs]
  [inlet_u]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = superficial_u
    functor = 0
  []
  [inlet_v]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = superficial_v
    functor = ${flow_vel}
  []
  [inlet_rho]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = rho_aux
    functor = ${rho_f}
  []

  [pressure-extrapolation]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = 'inlet'
    variable = pressure
    functor = 0
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
    functor = ${p_out}
  []

  [symmetry_u]
    type = LinearFVVelocitySymmetryBC
    boundary = 'bed_left bed_right riser_walls horizontal_walls riser_walls'
    variable = superficial_u
    u = superficial_u
    v = superficial_v
    momentum_component = x
  []
  [symmetry_v]
    type = LinearFVVelocitySymmetryBC
    boundary = 'bed_left bed_right horizontal_walls riser_walls'
    variable = superficial_v
    u = superficial_u
    v = superficial_v
    momentum_component = y
  []
  [pressure_symmetric]
    type = LinearFVPressureSymmetryBC
    boundary = 'bed_left bed_right horizontal_walls riser_walls'
    variable = pressure
    HbyA_flux = 'HbyA'
  []

  [top_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = inlet
    variable = h_fluid
    functor = h_from_p_T
  []

  [side_h_fluid]
    type = LinearFVAdvectionDiffusionFunctorNeumannBC
    boundary = 'bed_left bed_right horizontal_walls riser_walls'
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
    boundary = 'bed_left horizontal_walls riser_walls'
    variable = T_solid
    functor = 0.0
    diffusion_coeff = k_s
  []

  [inlet_T_fluid]
    type = LinearFVAdvectionDiffusionFunctorDirichletBC
    boundary = 'inlet'
    variable = T_fluid
    functor = ${T_inlet}
  []
[]

[Functions]
  [heat_source_fn]
    type = ParsedFunction
    expression = '${power_fn_scaling} * (-1.0612e4 * pow((y-${axial_coordinate_shift})+${offset}, 4) + 1.5963e5 * pow((y-${axial_coordinate_shift})+${offset}, 3)
                   -6.2993e5 * pow((y-${axial_coordinate_shift})+${offset}, 2) + 1.4199e6 * ((y-${axial_coordinate_shift})+${offset}) + 5.5402e4)'
  []

  [rho_parsed]
    type = ParsedFunction
    expression = 'if((y-${axial_coordinate_shift}) < 10, 2.65 + 0.11*exp(0.40*(y-${axial_coordinate_shift})), 8.60161)'
  []

[]

[FunctorMaterials]
  [speed_material]
    type = PINSFVSpeedFunctorMaterial
    superficial_vel_x = superficial_u
    superficial_vel_y = superficial_v
    porosity = porosity
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [characteristic_length_mat]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = characteristic_length
    subdomain_to_prop_value = 'pebble_bed       ${pebble_diameter}
                               bottom_reflector ${bottom_reflector_Dh}
                               riser            ${riser_Dh}
                               control_rods     ${control_rod_Dh}'
  []

  [fluid_props]
    type = GeneralFunctorFluidProps
    fp = fp
    pressure = pressure
    T_fluid = T_fluid
    speed = speed
    porosity = porosity
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    characteristic_length = characteristic_length
  []

  [solid_thermal_mass]
    type = ADParsedFunctorMaterial
    property_name = solid_thermal_mass
    expression = '${thermal_mass_scaling} * ${rho_s} * ${cp_s} * (1 - eps)'
    functor_names  = 'porosity'
    functor_symbols = 'eps'
    block = 'pebble_bed bottom_reflector side_reflector bottom_plenum upper_plenum riser control_rods'
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

  [drag_new_convention]
    type = ADParsedFunctorMaterial
    expression = '${c_drag_old} * rho_fluid / porosity / fluid_mu'
    property_name = c_drag
    functor_symbols = 'rho_fluid porosity fluid_mu'
    functor_names = 'rho porosity mu'
  []

  [drag_cavity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = 'c_drag c_drag c_drag 0 0 0'
    block = 'cavity'
  []

  [drag_upper_plenum]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = 'c_drag c_drag c_drag 0 0 0'
    block = 'upper_plenum'
  []

  [drag_bottom_plenum]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = 'c_drag c_drag c_drag 0 0 0'
    block = 'bottom_plenum'
  []

  [drag_bottom_reflector_riser]
    type = FunctorChurchillDragCoefficients
    block = 'bottom_reflector riser'
    multipliers = '1e4 1 1e4'
  []

  [Darcy_control_rods]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient'
    prop_values = '0 0 0'
    block = 'control_rods'
  []

  [quad_drag_new_convention]
    type = ADParsedFunctorMaterial
    expression = '1000 * 2 / porosity / speed'
    property_name = new_g
    functor_symbols = 'porosity speed'
    functor_names = 'porosity speed'
    block = 'control_rods'
  []

  [Forchheimer_control_rods]
    type = LinearFrictionFactorFunctorMaterial
    porosity = porosity
    functor_name = Forchheimer_coefficient
    superficial_vel_x = superficial_u
    superficial_vel_y = superficial_v
    f = 0
    g = new_g
    B = '1 1 1'
    block = 'control_rods'
  []

  [porosity]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'pebble_bed       ${bed_porosity}
                               cavity           1
                               bottom_reflector 0.3
                               side_reflector   0
                               bottom_plenum    0.2
                               upper_plenum     0.2
                               riser            0.32
                               control_rods     0.32'
  []

  [fluid_enthalpy_material]
    type = LinearFVEnthalpyFunctorMaterial
    pressure = pressure
    T_fluid = T_fluid
    h = h_fluid
    fp = fp
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
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

  [graphite_rho_and_cp_riser_control_rods]
    type = GenericFunctorMaterial
    prop_names = 'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 ${fparse 0.68 * 26}'
    block = 'riser control_rods'
  []

  [graphite_rho_and_cp_plenums]
    type = GenericFunctorMaterial
    prop_names = 'rho_s  cp_s k_s'
    prop_values = '1780.0 1697 ${fparse 0.8 * 26}'
    block = 'bottom_plenum upper_plenum'
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
    block = 'bottom_reflector
             side_reflector
             bottom_plenum
             upper_plenum
             riser
             control_rods'
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
    block = 'cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_h_material]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa_h'
    prop_values = 'kappa_over_cp_x kappa_over_cp_y kappa_over_cp_z'
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
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
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [porosity_aux]
    type = MooseLinearVariableFVReal
  []

  [T_fluid]
    type = MooseLinearVariableFVReal
    initial_condition = ${T_inlet}
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [cp_var]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_x]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_y]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_z]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_over_cp_x]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_over_cp_y]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []

  [kappa_over_cp_z]
    type = MooseLinearVariableFVReal
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
  []
[]

[AuxKernels]
  [assign_rho_aux]
    type = FunctorAux
    variable = rho_aux
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    functor = 'rho'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_porosity_aux]
    type = FunctorAux
    variable = porosity_aux
    functor = 'porosity'
    execute_on = 'initial timestep_end'
  []

  [fluid_temperature]
    type = FunctorAux
    variable = T_fluid
    functor = T_from_p_h
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_cp]
    type = FunctorAux
    variable = cp_var
    functor = cp
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_x]
    type = ADFunctorVectorElementalAux
    variable = kappa_x
    functor = kappa
    component = 0
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_y]
    type = ADFunctorVectorElementalAux
    variable = kappa_y
    functor = kappa
    component = 1
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_z]
    type = ADFunctorVectorElementalAux
    variable = kappa_z
    functor = kappa
    component = 2
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_over_cp_x]
    type = ParsedAux
    variable = kappa_over_cp_x
    coupled_variables = 'kappa_x cp_var'
    expression = 'kappa_x / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_over_cp_y]
    type = ParsedAux
    variable = kappa_over_cp_y
    coupled_variables = 'kappa_y cp_var'
    expression = 'kappa_y / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

  [assign_kappa_over_cp_z]
    type = ParsedAux
    variable = kappa_over_cp_z
    coupled_variables = 'kappa_z cp_var'
    expression = 'kappa_z / cp_var'
    enable_jit = false
    block = 'pebble_bed cavity bottom_reflector bottom_plenum upper_plenum riser control_rods'
    execute_on = 'INITIAL NONLINEAR TIMESTEP_END'
  []

[]

[Postprocessors]
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

  [cr_mfr]
    type = RhieChowMassFlowRate
    boundary = control_rod_outlet
    rhie_chow_user_object = rc
    outputs = none
  []

  [cr_mfr_fraction]
    type = ParsedPostprocessor
    pp_names = 'cr_mfr inlet_mfr'
    expression = 'abs(cr_mfr / inlet_mfr * 100)'
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
    expression = 'inlet_pressure - outlet_pressure'
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
    expression = 'abs(enthalpy_outlet) - abs(enthalpy_inlet)'
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

[Outputs]
  exodus = true
  csv = true
  console = true
  print_linear_residuals = true
  execute_on = 'TIMESTEP_END'
[]
