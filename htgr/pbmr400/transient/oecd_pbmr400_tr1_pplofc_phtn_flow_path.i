# ==============================================================================
# PBMR-400 steady-state phase 1 exercise 3, NEA/NSC/DOC(2013)10.
# SUBAPP1 Thermal-hydraulics only with provided power density
# FENIX input file
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 10/12/2019
# Author(s): Dr. Paolo Balestra, Dr. Sebastian Schunert
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - This input may only be run after a checkpoint has been generated with the
# steady state input
# - all units in SI
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------
heat_capacity_multiplier  = 1.0 # Multiply reflector solid heat structures heat capacity for steady state to speed convergence / stabilize (//).
# Geometry ---------------------------------------------------------------------
pebble_bed_top_height        = 15.35    # Z-coordinate of the top of the pebble bed (m).
inner_radius                 = 1.000    # X-coordinate of inner wall of the pebble bed (m).
outer_radius                 = 1.850    # X-coordinate of outer wall of the pebble bed (m).
global_emissivity            = 0.80     # All the materials has the same emissivity (//).
pebble_bed_porosity          = 0.39     # Pebble bed porosity (//).
# fluid_channels_porosity      = 0.20     # 20% is assumed in regions where the He flows in graphite areas (//).
reactor_inlet_free_flow_area = 8.1870   # Reactor inlet free (no graphite) flow area (m2)
pebbles_diameter             = 0.06     # Diameter of the pebbles (m).

# Properties -------------------------------------------------------------------
reactor_total_mfr        = 192.70   # Total reactor He mass flow rate (kg/s).
reactor_inlet_T_fluid    = 773.15   # He temperature  at the inlet of the lower inlet plenum (K).
core_outlet_pressure     = 9e+6     # Pressure at the at the outlet of the outlet plenum (Pa)
reactor_inlet_free_rho_u = ${fparse -reactor_total_mfr/reactor_inlet_free_flow_area } # Inlet free  mass flux in the  -x direction  (kg/m2s).

[GlobalParams]
  pebble_diameter = ${pebbles_diameter}
  acceleration = ' 0.00 -9.81 0.00 ' # Gravity acceleration (m/s2).
  fp = fluid_properties_obj
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = RZ
  file = '../steady/oecd_pbmr400_ss1_phtn_flow_path_cp/LATEST'
[]

[Problem]
  kernel_coverage_check = false

  restart_file_base = '../steady/oecd_pbmr400_ss1_phtn_flow_path_cp/LATEST'
  skip_additional_restart_data = true
  force_restart = true
[]

# ==============================================================================
# VARIABLES, AUXILIARY VARIABLES, INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================

[Variables]
  [pressure]
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [superficial_rho_u]
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [superficial_rho_v]
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_fluid]
    scaling = 1e-3
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_solid]
    scaling = 1e-4
    block = ' 1 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
[]

[AuxVariables]
  [T_solid_element_average]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [porosity]
    block = ' 1 2 14 15 16 17 18 '
  []
  [power_density]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [normalized_power_density]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [rho]
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_x]
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_y]
    block = ' 1 2 14 15 16 17 18 '
  []
  [courant_number]
    block = ' 1 2 14 15 16 17 18 '
    family = MONOMIAL
    order = CONSTANT
  []
  [alpha]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 14 15 16 17 18 '
  []
  [k_s]
    family = MONOMIAL
    order = CONSTANT
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [kappa_s]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [Re]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_fuel]
    block = ' 1 '
  []
  [T_mod]
    block = ' 1 '
  []
  [T_kernel]
    block = ' 1 '
  []
[]

[Functions]
  [mfr_scaling_function]
    # A reduction in reactor inlet coolant mass flow from nominal (192.7 kg/s)
    # to 0.0 kg/s over 13 seconds. The mass flow ramp is assumed linear.
    type = PiecewiseLinear
    x = '0.0 13.0 180000.0'
    y = '${reactor_inlet_free_rho_u}
        0.0
        0.0'
  []
  [pressure_scaling_function]
    # A reduction in reactor helium outlet pressure from nominal (90 bar) to 60
    # bar over 13 seconds. The pressure ramp is assumed linear.
    type = PiecewiseLinear
    x = '0.0 13.0 400.0 180000.0'
    # y = '${core_outlet_pressure}
    #     73.612e5
    #     73.612e5
    #     73.612e5'
    y = '${core_outlet_pressure}
         60.0e5
         60.0e5
         60.0e5'
  []
  [drag_function]
    # A reduction in reactor helium outlet pressure from nominal (90 bar) to 60
    # bar over 13 seconds. The pressure ramp is assumed linear.
    type = PiecewiseConstant
    x = '0.0  13.0 180000.0'
    y = '1.0 1.0 10000.0'
    direction = right
  []
  [conditional_function]
     type = ParsedFunction
     value = 't >= 13.0 & switch>0'
     vals = switch
     vars = switch
  []
  [courant_condition_fun]
    type = ParsedFunction
    value = 'a/b'
    vars = 'a b'
    vals = 'time_step_pp min_courant_num'
  []
  [dts]
     type = PiecewiseLinear
     x = '0.0   13.0  16.0  5000.0 60000.0 125000 180000.0'
     y = '1.0   0.1   0.1   120.0  1800.0  3600.0 3600.0'
  []
[]

# ==============================================================================
# KERNEL AND AUXKERNELS
# ==============================================================================
[Kernels]
  # Equation 0 (mass conservation).
  [mass_time]
    type = MassTimeDerivative
    variable = pressure
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [mass_space]
    type = PressurePoisson
    variable = pressure
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []

  # Equation 1 (x momentum conservation).
  [x_momentum_pressure]
    type = MomentumPressureGradient
    variable = superficial_rho_u
    component = 0
    divergence = false
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [x_momentum_friction_source]
    type = MomentumFrictionForce
    variable = superficial_rho_u
    component = 0
    block = ' 1 2 14 15 16 17 18 '
  []
  [x_momentum_gravity_source]
    type = MomentumGravityForce
    variable = superficial_rho_u
    component = 0
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []

  # Equation 2 (y momentum conservation).
  [y_momentum_pressure]
    type = MomentumPressureGradient
    variable = superficial_rho_v
    component = 1
    divergence = false
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [y_momentum_friction_source]
    type = MomentumFrictionForce
    variable = superficial_rho_v
    component = 1
    block = ' 1 2 14 15 16 17 18 '
  []
  [y_momentum_gravity_source]
    type = MomentumGravityForce
    variable = superficial_rho_v
    component = 1
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []

  # Equation 3 (fluid energy conservation).
  [fluid_energy_time]
    type = FluidEnergyTime
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_space]
    type = FluidEnergyAdvection
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_diffuson]
    type = FluidEnergyDiffusiveFlux
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_solid_fluid_source]
    type = FluidSolidConvection
    variable = T_fluid
    T_solid = T_solid
    single_equation_SUPG = true
    block = ' 1 14 15 16 17 18 '
  []

  # Equation 4 (solid energy conservation).
  [solid_energy_time]
    type = SolidEnergyTime
    variable = T_solid
    porosity = porosity
    block = ' 1 '
  []
  [solid_energy_diffusion]
    type = SolidEnergyDiffusion
    variable = T_solid
    block = ' 1 '
  []
  [solid_energy_fluid_convection]
    type = SolidFluidConvection
    variable = T_solid
    block = ' 1  '
  []
  [solid_energy_heatsrc]
    type = CoupledForce
    variable = T_solid
    v = power_density
    block = ' 1 '
  []

  # Equation 4b (solid energy conservation passive structures).
  [passive_structures_energy_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T_solid
    specific_heat = 'cp_s'
    density_name = 'rho_s'
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [passive_structures_energy_diffusion]
    type = ADHeatConduction
    variable = T_solid
    thermal_conductivity = 'k_s'
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
[]

[AuxKernels]
  [T_solid_element_average]
    type = ParsedAux
    variable = T_solid_element_average
    function = T_solid
    args = T_solid
    block = ' 1 '
  []

  [courant_number]
    type = INSCourant
    u = vel_x
    v = vel_y
    variable = courant_number
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []

  [rho]
    type = FluidDensityAux
    variable = rho
    p = pressure
    T = T_fluid
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_x]
    type = ParsedAux
    variable = vel_x
    function = 'superficial_rho_u / porosity / rho'
    args = 'superficial_rho_u porosity rho'
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_y]
    type = ParsedAux
    variable = vel_y
    function = 'superficial_rho_v / porosity / rho'
    args = 'superficial_rho_v porosity rho'
    block = ' 1 2 14 15 16 17 18 '
  []
  [alpha]
    type = ADMaterialRealAux
    variable = alpha
    property = alpha
    block = ' 1 14 15 16 17 18 '
  []
  [k_s]
    type = ADMaterialRealAux
    variable = k_s
    property = k_s
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [kappa_s]
    type = ADMaterialRealAux
    variable = kappa_s
    property = kappa_s
    block = ' 1 '
  []
  [Re]
    type = ADMaterialRealAux
    variable = Re
    property = Re
    block = ' 1 2 14 15 16 17 18 '
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[Materials]
  # Non linear variables and stabilization.
  [non_linear_variables]
    type = MixedSuperficialVarMaterial
    pressure = pressure
    T_fluid = T_fluid
    superficial_rho_u = superficial_rho_u
    superficial_rho_v = superficial_rho_v
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_properties]
    type = PronghornFluidProps
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [scalar_tau_for_stabilization]
    type = ScalarTau
    block = ' 1 2 14 15 16 17 18 '
  []

  # Drag coefficients.
  [pebble_bed_drag_coefficient]
    type = KTADragCoefficients
    T_solid = T_solid
    porosity = porosity
    block = ' 1 '
  []
  [top_cavity_drag_coefficient]
    # type = FunctionIsotropicDragCoefficients
    type = FunctionSimpleIsotropicDragCoefficients
    W = 10.0
    # Darcy_coefficient = 0.0
    # Forchheimer_coefficient = 10.0
    block = ' 2 '
  []
  [partial_density_drag_coefficient]
    # type = FunctionIsotropicDragCoefficients
    type = FunctionSimpleIsotropicDragCoefficients
    W = 1.0
    # Darcy_coefficient = 0.0
    # Forchheimer_coefficient = 0.013
    block = ' 17 18 '
  []
  [partial_density_drag_coefficient01]
    # type = FunctionIsotropicDragCoefficients
    type = FunctionSimpleIsotropicDragCoefficients
    W = drag_function
    # Darcy_coefficient = 0.0
    # Forchheimer_coefficient = 0.013
    block = ' 14 15 16 '
  []

  # Fluid effective conductivity.
  [pebble_bed_fluid_effective_conductivity]
    type = LinearPecletKappaFluid
    # wall_distance = bed_geometry
    # scaling_factor = 0.5
    porosity = porosity
    block = ' 1 '
  []
  [partial_density_cavity_fluid_effective_conductivity]
    type = KappaFluid
    block = ' 2 14 15 16 17 18 '
  []

  # Heat exchange coefficients.
  [pebble_bed_alpha]
    type = KTAPebbleBedHTC
    T_solid = T_solid
    porosity = porosity
    bed_entrance = top
    wall_distance = bed_geometry
    block = ' 1 '
  []
  [partial_density_cavity_dummy_pebble_bed_alpha]
    type = ADGenericConstantMaterial
    prop_names = 'alpha'
    prop_values = '1e-10'
    block = ' 14 15 16 17 18 '
  []
  [gaps_dummy_htc]
    type = ADGenericConstantMaterial
    prop_names = 'dummy_htc'
    prop_values = '1e-10'
    block = ' 9 11 12 '
  []

  # Solid conduction properties.
  [pebble_bed_solid_effective_conductivity]
    type = PebbleBedKappaSolid
    T_solid = T_solid
    porosity = porosity
    solid_conduction = ZBS
    emissivity = ${global_emissivity}
    infinite_porosity = ${pebble_bed_porosity}
    Youngs_modulus = 9e+9
    Poisson_ratio = 0.1360
    lattice_parameters = interpolation
    coordination_number = You
    wall_distance = bed_geometry # Requested by solid_conduction = ZBS
    block = ' 1 '
  []
  [pebble_bed_full_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1780.0 ${fparse 1697.0*heat_capacity_multiplier} 26.0'
    block = ' 1 '
  []
  [reflector_full_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1780.0 ${fparse 1697.0*heat_capacity_multiplier} 26.0 '
    block = ' 3 4 5 6 '
  []
  [channels_partial_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1424.0 ${fparse 1697.0*heat_capacity_multiplier} 20.8 '
    block = ' 14 15 16 17 18 '
  []
  [core_barrel_steel]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 7800.0 ${fparse 540.0*heat_capacity_multiplier} 17.0 '
    block = ' 7 8 10 '
  []
  [rpv_steel]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 7800.0 ${fparse 525.0*heat_capacity_multiplier} 38.0 '
    block = ' 12 '
  []
[]

[UserObjects]
  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = ${pebble_bed_top_height}
    inner_radius = ${inner_radius}
    outer_radius = ${outer_radius}
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[Controls]
  [outlet_closing]
    type = ConditionalFunctionEnableControl
    conditional_function = conditional_function
    # disable_objects = 'BCs::pressure_outlet BCs::pressure_inlet BCs::superficial_rho_v_inlet BCs::T_fluid_inlet'
    disable_objects = 'BCs::pressure_outlet'
    enable_objects = 'BCs::superficial_rho_u_oultet_close'
    # disable_objects = 'BCs::pressure_outlet BCs::pressure_inlet BCs::superficial_rho_v_inlet BCs::T_fluid_inlet  Materials::partial_density_drag_coefficient'
    # enable_objects = 'BCs::superficial_rho_u_oultet_close Materials::partial_density_drag_coefficient_in  Materials::partial_density_drag_coefficient_out'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[BCs]
  # Inlet flow.
  [pressure_inlet]
    type = MassSpecifiedMomentumBC
    variable = pressure
    specified_momentum_function = 'mfr_scaling_function 0.0'
    porosity = porosity
    superficial = true
    boundary = 'reactor_inlet'
  []
  [superficial_rho_u_inlet]
    type = FunctionDirichletBC
    variable = superficial_rho_u
    function = mfr_scaling_function
    boundary = 'reactor_inlet'
  []
  [superficial_rho_v_inlet]
    type = DirichletBC
    variable = superficial_rho_v
    value = 0.0
    boundary = 'reactor_inlet'
  []
  [T_fluid_inlet]
    type = DirichletBC
    variable = T_fluid
    value = ${reactor_inlet_T_fluid}
    boundary = 'reactor_inlet'
  []

  # Outlet flow.
  [pressure_outlet]
    type = FunctionDirichletBC
    variable = pressure
    function = pressure_scaling_function
    # function = ${core_outlet_pressure}
    boundary = 'reactor_outlet'
  []
  [superficial_rho_u_oultet_close]
    type = DirichletBC
    variable = superficial_rho_u
    value = 0.0
    # boundary = ' reactor_outlet reactor_inlet_close'
    boundary = 'reactor_outlet'
    enable = false
  []

  # Fluid solid walls.
  [superficial_rho_u_vertical_walls]
    type = DirichletBC
    variable = superficial_rho_u
    value = 0.0
    boundary = ' core_inner core_outer reactor_inlet_vertical_walls '
  []
  [superficial_rho_v_horizontal_walls]
    type = DirichletBC
    variable = superficial_rho_v
    value = 0.0
    boundary = ' core_top core_bottom reactor_inlet_horizontal_walls '
  []

  # Radial conduction/radiation trough the Air gap BCs.
  [T_solid_conduction]
    type = ThermalResistanceBC
    variable = T_solid
    emissivity = 1e-10
    htc = 'dummy_htc'
    thermal_conductivities = 0.03 # Stagnant Air.
    inner_radius = 3.2800
    conduction_thicknesses = 1.340
    T_ambient = 293.15
    boundary = right
  []
  [T_solid_radiation]
    type = InfiniteCylinderRadiativeBC
    variable = T_solid
    cylinder_emissivity = ${global_emissivity}
    boundary_emissivity = ${global_emissivity}
    boundary_radius = 3.280
    cylinder_radius = 4.620
    Tinfinity = 293.15
    boundary = right
  []
[]

[ThermalContact]
  [reflector_to_barrel]
    type = GapHeatTransfer
    variable = T_solid
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    gap_geometry_type = CYLINDER
    primary = reflector_barrel_gap_outer
    secondary = reflector_barrel_gap_inner
    gap_conductivity = 0.33 # Stagnant He.
  []
  [barrel_to_rpv]
    type = GapHeatTransfer
    variable = T_solid
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    gap_geometry_type = CYLINDER
    primary = barrel_rpv_gap_outer
    secondary = barrel_rpv_gap_inner
    gap_conductivity = 0.33 # Stagnant He.
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
  active = SMP

  [SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
    petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type
                            -ksp_gmres_restart '
    petsc_options_value = ' lu superlu_dist 50 '
  []

  # [FSP]
  #   type = FSP
  #   solve_type = 'PJFNK'
  #   topsplit = ' ts '
  #   petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type
  #                           -ksp_gmres_restart '
  #   petsc_options_value = ' lu superlu_dist 50 '
  #
  #   [ts]
  #     splitting = ' p v Tf Ts '
  #     splitting_type = additive
  #   []
  #
  #   [p]
  #     vars = pressure
  #     petsc_options_iname = ' -pc_type -ksp_type '
  #     petsc_options_value = ' hypre preonly '
  #   []
  #
  #   [Ts]
  #     vars = T_solid
  #     petsc_options_iname = ' -pc_type -ksp_type '
  #     petsc_options_value = ' hypre preonly '
  #   []
  #
  #   [v]
  #     vars = ' superficial_rho_u superficial_rho_v '
  #     petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type -ksp_type '
  #     petsc_options_value = ' lu superlu_dist preonly '
  #   []
  #
  #   [Tf]
  #     vars = T_fluid
  #     petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type -ksp_type '
  #     petsc_options_value = ' lu superlu_dist preonly '
  #   []
  #
  # []

[]

[Executioner]
  type = Transient # Pseudo transient to reach steady state.

  petsc_options = ' -snes_converged_reason '
  line_search = 'l2'

  # Problem time parameters.
  # dt = 1e+15 # Let the main app control time steps.
  # reset_dt = true
  start_time = 0.0

  # Iterations parameters.
  l_max_its = 50
  l_tol     = 1e-3

  nl_max_its = 25
  nl_rel_tol = 1e-3
  nl_abs_tol = 1e-2

  # [TimeStepper]
  #   type = PostprocessorDT
  #   postprocessor = min_courant_num
  #   scale = 50
  #   dt = 1e-2
  #   cutback_factor_at_failure = 0.25
  # []
  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1e-2
    cutback_factor     = 0.5
    growth_factor      = 2.00
    # time_t = '0.0   13.0  16.0  5000.0 60000.0 125000 180000.0'
    # reject_large_step = true
    # timestep_limiting_function = dts
    timestep_limiting_postprocessor = timestep_pp
    # reject_large_step_threshold = 0.5
    # force_step_every_function_point = true
    optimal_iterations = 4
  []
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================
[MultiApps]
  [pebble_triso]
    type = CentroidMultiApp
    input_files = 'oecd_pbmr400_tr2_pplofc_mhtr_pebble_triso.i'
    output_in_position = true
    max_procs_per_app = 1
    block = ' 1 '
  []
[]

[Transfers]
  [pebble_surface_temp]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble_triso
    source_variable = T_solid
    postprocessor = pebble_surface_temp
  []
  [pebble_heat_source]
    type = MultiAppVariableValueSampleTransfer
    to_multi_app = pebble_triso
    source_variable = power_density
    variable = porous_media_power_density
  []
  [T_mod]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = pebble_triso
    variable = T_mod
    num_points = 4
    postprocessor = moderator_average_temp
  []
  [T_fuel]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = pebble_triso
    variable = T_fuel
    num_points = 4
    postprocessor = fuel_average_temp
  []
  [T_kernel]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = pebble_triso
    variable = T_kernel
    num_points = 4
    postprocessor = pebble_core_center_temp
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]

[Postprocessors]
  [timestep_pp]
    type = FunctionValuePostprocessor
    function = dts
  []
  [min_courant_num]
    type = ElementExtremeValue
    value_type = 'min'
    variable = courant_number
    block = ' 1 2 14 15 16 17 18 '
  []
  [time_step_pp]
    type = TimestepSize
    # allow_duplicate_execution_on_initial = true
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END FINAL'
  []
  [courant_condition]
    type = FunctionValuePostprocessor
    function = courant_condition_fun
  []
  [T_fluid_avg]
    type = ElementAverageValue
    variable = T_fluid
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_solid_avg]
    type = ElementAverageValue
    variable = T_solid
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_mod_avg]
    type = ElementAverageValue
    variable = T_mod
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_fuel_avg]
    type = ElementAverageValue
    variable = T_fuel
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [Tt_pow]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block =  ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []

  [he_vol_tt]
    type = VolumePostprocessor
    block = ' 1 2 14 15 16 17 18 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [pressure_avg]
    type = ElementAverageValue
    variable = pressure
    block = ' 1 2 14 15 16 17 18 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [he_mass_tt]
    type = ElementIntegralVariablePostprocessor
    variable = rho
    block = ' 1 2 14 15 16 17 18 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [he_temp_avg]
    type = ElementAverageValue
    variable = T_fluid
    block = ' 1 2 14 15 16 17 18 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [trip_valve]
    type = FunctionValuePostprocessor
    function = conditional_function
    execute_on = 'INITIAL LINEAR TIMESTEP_END FINAL'
  []
  [switch]
    type = VolumePostprocessor
    execute_on = 'TIMESTEP_END FINAL'
  []
[]

[Outputs]
  file_base = oecd_pbmr400_tr1_pplofc_phtn_flow_path
  print_linear_residuals = false
  exodus = true
  csv = true
  execute_on = 'INITIAL TIMESTEP_END FINAL'
[]
