# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 0.1: Velocity field
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428.
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

alpha = 2.0e-4
rho = 2.0e+3
cp = 3.075e+3
k = 1.0e-3
mu = 5.0e+1

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
        boussinesq_approximation = true
        gravity = '0 -9.81 0'
        thermal_expansion = ${alpha}

        # Initial conditions
        initial_velocity = '0.5 0 0'
        initial_pressure = 1e5
        ref_temperature = 900

        # Boundary conditions
        inlet_boundaries = 'top'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '0.5 0'

        wall_boundaries = 'left right bottom'
        momentum_wall_types = 'noslip noslip noslip'

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
        energy_inlet_types = 'fixed-temperature'
        energy_inlet_functors = 900
        energy_wall_types = 'heatflux heatflux heatflux'
        energy_wall_functors = '0 0 0'

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
    prop_names = 'k rho mu'
    prop_values = '${k} ${rho} ${mu}'
  []
  [cp]
    type = ADGenericFunctorMaterial
    # prop_names = 'cp dcp_dt'
    # prop_values = '${cp} 0'
    prop_names = 'cp'
    prop_values = '${cp}'
  []
[]

[Postprocessors]
  [Tfuel_avg]
    type = ElementAverageValue
    variable = T_fluid
  []
[]

[VectorPostprocessors]
  [AA_line_values_left]
    type = LineValueSampler
    start_point = '0 0.995 0'
    end_point = '2 0.995 0'
    variable = 'vel_x vel_y'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [AA_line_values_right]
    type = LineValueSampler
    start_point = '0 1.005 0'
    end_point = '2 1.005 0'
    variable = 'vel_x vel_y'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [BB_line_values_left]
    type = LineValueSampler
    start_point = '0.995 0 0'
    end_point = '0.995 2 0'
    variable = 'vel_x vel_y'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
  [BB_line_values_right]
    type = LineValueSampler
    start_point = '1.005 0 0'
    end_point = '1.005 2 0'
    variable = 'vel_x vel_y'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 10000
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1 # chosen to obtain convergence with first coupled iteration
    growth_factor = 2
  []
  steady_state_detection = true
  steady_state_tolerance = 1e-8
  steady_state_start_time = 10
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  line_search = 'none'
  nl_rel_tol = 1e-7
  nl_abs_tol = 2e-7
  nl_max_its = 200
  l_max_its = 200
  automatic_scaling = true
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
    execute_on = 'FINAL'
  []
[]

