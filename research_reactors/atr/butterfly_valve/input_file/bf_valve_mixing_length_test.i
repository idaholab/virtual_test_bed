mu = 0.001 # viscosity [Pa*s]
rho = 986.737 # density [kg/m^3]
von_karman_const = 0.41

advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/0deg_cubit_coarse_mesh.e'
  []
[]

[GlobalParams]
  rhie_chow_user_object = 'ins_rhie_chow_interpolator'
[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        compressibility = 'incompressible'

        density = '${rho}'
        dynamic_viscosity = '${mu}'

        # Initial conditions
        initial_velocity = '0.1 0 0'
        initial_pressure = 0

        # Boundary conditions
        inlet_boundaries = 'Inlet'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '2.051481762 0 0'

        wall_boundaries = 'Walls Valve Symmetry'
        momentum_wall_types = 'noslip noslip symmetry'

        outlet_boundaries = 'Outlet'
        momentum_outlet_types = 'fixed-pressure'
        pressure_functors = '0'

        mass_advection_interpolation = '${advected_interp_method}'
        momentum_advection_interpolation = '${advected_interp_method}'
        velocity_interpolation = '${velocity_interp_method}'
      []
    []
    [Turbulence]
      [mixing_length]
        turbulence_handling = 'mixing-length'
        von_karman_const = ${von_karman_const}
        mixing_length_delta = 0.005
      []
    []
  []
[]

[Functions]
  [rampdown_mu_func]
    type = ParsedFunction
    expression = 'if(t<= 5, mu*(100*exp(-3*t)+1), 0.000463*exp(-3*(t-5))+0.000537)'
    symbol_names = 'mu'
    symbol_values = ${mu}
  []
[]

[FunctorMaterials]
  [mu]
    type = ADGenericFunctorMaterial #defines mu artificially for numerical convergence
    prop_names = 'mu rho' #it converges to the real mu eventually.
    prop_values = 'rampdown_mu_func ${rho}'
  []
  [velocity_vector]
    type = ADGenericVectorFunctorMaterial
    prop_names = vel_vec
    prop_values = 'vel_x vel_y vel_z'
  []
[]

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 0.0
  end_time = 8

  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    # Start small, or improve the initial condition
    dt = 0.0125
    timestep_limiting_postprocessor = 'dt_limit'
  []

  # Time integration scheme
  scheme = 'implicit-euler'

  # Solver Parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -snes_max_it -l_max_it -max_nl_its'
  petsc_options_value = 'lu       NONZERO                25           50        20        '
  line_search = 'none'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-10
  automatic_scaling = true
  scaling_group_variables = 'vel_x vel_y vel_z; pressure'
[]

[Outputs]
  exodus = true
  csv = true
  hide = 'dt_limit'
[]

[Postprocessors]
  [mu_value]
    type = FunctionValuePostprocessor
    function = rampdown_mu_func
  []
  [dt_limit]
    type = Receiver
    default = 1
  []
  [pressure_drop]
    type = PressureDrop
    pressure = pressure
    boundary = 'Inlet Outlet'
    upstream_boundary = 'Outlet'
    downstream_boundary = 'Inlet'
  []
  [pressure_drop_weighted]
    type = PressureDrop
    pressure = pressure
    boundary = 'Inlet Outlet'
    upstream_boundary = 'Outlet'
    downstream_boundary = 'Inlet'
    weighting_functor = 'vel_vec'
  []
  [mdot_in]
    type = VolumetricFlowRate
    boundary = Inlet
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = '${rho}'
    subtract_mesh_velocity = false
  []
  [mdot_out]
    type = VolumetricFlowRate
    boundary = Outlet
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = '${rho}'
    subtract_mesh_velocity = false
  []
[]
