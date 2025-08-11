# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 0.3: Temperature field
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428.
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1
geometric_tolerance = 1e-3
cavity_l = 2.0
lid_velocity = 0.5

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    pressure = pressure
  []
[]

[Mesh]
  type = MeshGeneratorMesh
  block_id = '1'
  block_name = 'cavity'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '1.0 1.0'
    ix = '100 100'
    dy = '1.0 1.0'
    iy = '100 100'
    subdomain_id = ' 1 1
                     1 1'
  []
[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        compressibility = 'incompressible'

        density = ${rho}
        dynamic_viscosity = 'mu'

        # Boussinesq parameters
        boussinesq_approximation = false
        gravity = '0 -9.81 0'

        # Initial conditions
        initial_velocity = '0.5 0 0'
        initial_pressure = 1e5

        # Boundary conditions
        wall_boundaries = 'left right bottom top'
        momentum_wall_types = 'noslip noslip noslip noslip'
        momentum_wall_functors = '0 0; 0 0; 0 0; lid_function 0'

        pin_pressure = true
        pinned_pressure_type = average
        pinned_pressure_value = 1e5

        # Numerical Scheme
        momentum_advection_interpolation = 'upwind'
        mass_advection_interpolation = 'upwind'
      []
    []
    [FluidHeatTransfer]
      [energy]
        initial_temperature = 900
        thermal_conductivity = 'k'
        specific_heat = 'cp'

        # Boundary conditions
        energy_wall_types = 'heatflux heatflux fixed-temperature fixed-temperature'
        energy_wall_functors = '0 0 0 1'

        # Volumetric heat sources and sinks
        ambient_temperature = 900
        ambient_convection_alpha = 1e6
        external_heat_source = power_density

        # Numerical Scheme
        energy_advection_interpolation = 'upwind'
        energy_two_term_bc_expansion = true
        energy_scaling = 1e-3
      []
    []
  []
[]

[FunctorMaterials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k mu rho'
    prop_values = '${cp} ${k} ${mu} ${rho}'
  []
[]

[AuxVariables]
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    [AuxKernel]
      type = VectorMagnitudeAux
      x = vel_x
      y = vel_y
    []
  []
  [power_density]
    type = MooseVariableFVReal
  []
[]

[Functions]
  [lid_function]
    type = ParsedFunction
    expression = 'if (x > ${geometric_tolerance}, if (x < ${fparse cavity_l - geometric_tolerance}, ${lid_velocity}, 0.0), 0.0)'
  []
[]

[Executioner]
  # Solving the steady-state versions of these equations
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1.5e-8
  nl_forced_its = 2
  automatic_scaling = true

  # MultiApps fixed point iteration parameters
  fixed_point_min_its = 2
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-5
  fixed_point_abs_tol = 1e-5
[]

[VectorPostprocessors]
  [AA_line_values_left]
    type = LineValueSampler
    start_point = '0 0.995 0'
    end_point = '2 0.995 0'
    variable = 'T_fluid'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [AA_line_values_right]
    type = LineValueSampler
    start_point = '0 1.005 0'
    end_point = '2 1.005 0'
    variable = 'T_fluid'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [BB_line_values_left]
    type = LineValueSampler
    start_point = '0.995 0 0'
    end_point = '0.995 2 0'
    variable = 'T_fluid'
	  num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
  [BB_line_values_right]
    type = LineValueSampler
    start_point = '1.005 0 0'
    end_point = '1.005 2 0'
    variable = 'T_fluid'
	  num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
[]

[MultiApps]
  [ns_flow]
    type = FullSolveMultiApp
    input_files = cnrs_s01_ns_flow.i
    cli_args = "Outputs/exodus=false;Outputs/active=''"
    execute_on = 'initial'
  []
  [griffin_neut]
    type = FullSolveMultiApp
    input_files = cnrs_s02_griffin_neutronics.i
    cli_args = "PowerDensity/family=MONOMIAL;PowerDensity/order=CONSTANT"
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  # Initialization
  [x_vel]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'vel_x'
    variable = 'vel_x'
    execute_on = 'initial'
  []
  [y_vel]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'vel_y'
    variable = 'vel_y'
    execute_on = 'initial'
  []
  [pres]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'pressure'
    variable = 'pressure'
    execute_on = 'initial'
  []

  # Multiphysics coupling
  [power_dens]
    type = MultiAppCopyTransfer
    from_multi_app = griffin_neut
    source_variable = 'power_density'
    variable = 'power_density'
    execute_on = 'timestep_end'
  []
  [temp]
    type = MultiAppCopyTransfer
    to_multi_app = griffin_neut
    source_variable = 'T_fluid'
    variable = 'tfuel'
    execute_on = 'timestep_end'
  []
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
    execute_on = 'FINAL'
  []
[]
