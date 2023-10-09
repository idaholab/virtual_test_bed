################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn input file to initialize velocity fields                         ##
## This runs a slow relaxation to steady state while ramping down the fluid   ##
## viscosity.                                                                 ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

# Material properties
rho = 4284 # density [kg / m^3]  (@1000K)
mu = 0.0166 # viscosity [Pa s]
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c\
# 9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
# Derived turbulent properties
von_karman_const = 0.41

# Mass flow rate tuning
friction = 4.0e3 # [kg / m^4]
pump_force = -20000. # [N / m^3]

[GlobalParams]
  rhie_chow_user_object = 'ins_rhie_chow_interpolator'
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  # uniform_refine = 1
  # coord_type = 'RZ'
  # rz_coord_axis = Y
  [fmg]
    type = FileMeshGenerator
    # file = '1_16_MSFR_Fine.e'
    # file = 'run_ns_initial_full_in.e'
    file = 'Full_MSFR_Coarse.e'
  []
  [fix]
    type = ParsedGenerateSideset
    input = fmg
    included_boundaries = 'Wall'
    combinatorial_geometry = 'x < 10000000'
    include_only_external_sides = true
    new_sideset_name = 'Wall_new'
  []
  [delete_bad]
    type = BoundaryDeletionGenerator
    input = fix
    boundary_names = 'Wall'
  []
  [rename]
    type = RenameBoundaryGenerator
    input = 'delete_bad'
    old_boundary = 'Wall_new'
    new_boundary = 'Wall'
  []
  [z_top]
    type = TransformGenerator
    input = rename
    transform = 'ROTATE'
    vector_value = '0 -90 0'
  []

  # MISC
  # [rename]
  #   type = RenameBlockGenerator
  #   input = 'hx_top'
  #   old_block = 'msfr'
  #   new_block = 'fuel'
  # []
  # [refine]
  #   type = RefineBlockGenerator
  #   input = 'delete_unused'
  #   block = 'fuel hx pump'
  #   refinement = '1'
  # []
  # [very_top]
  #   type = ParsedGenerateSideset
  #   combinatorial_geometry = 'y > 1.3226'
  #   new_sideset_name = 'top_top'
  #   input = 'refine'
  # []
  construct_side_list_from_node_list = true
[]

[Problem]
  kernel_coverage_check = false
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[Modules]
  [NavierStokesFV]
    # General parameters
    compressibility = 'incompressible'
    gravity = '0 0 -9.81'

    # Material properties
    density = ${rho}
    dynamic_viscosity = 'mu'

    # Initial conditions
    initial_velocity = '1e-6 1e-6 1e-6'
    initial_pressure = 1e5
    initial_temperature = 600.0

    # Boundary conditions
    wall_boundaries = 'Wall'
    momentum_wall_types = 'wallfunction'

    # Pressure pin for incompressible flow
    pin_pressure = true
    pinned_pressure_type = average-uo
    pinned_pressure_value = 1e5

    # Turbulence parameters
    turbulence_handling = 'mixing-length'
    von_karman_const = ${von_karman_const}
    mixing_length_delta = 0.1
    mixing_length_walls = 'Wall'
    mixing_length_aux_execute_on = 'initial'

    # Heat exchanger friction
    friction_blocks = 'HX'
    friction_types = 'FORCHHEIMER'
    friction_coeffs = ${friction}

    # Numerical scheme
    mass_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'

    # momentum_two_term_bc_expansion = false
    # pressure_two_term_bc_expansion = false
  []
[]

[FVKernels]
  [pump]
    type = INSFVBodyForce
    variable = vel_y
    functor = ${pump_force}
    block = 'Pump'
    momentum_component = 'y'
  []
[]

[FVBCs]
  # [top_top]
  #   type = FVDirichletBC
  #   variable = pressure
  #   value = 1e5
  #   boundary = 'top_top'
  # []
  # [top_top]
  #   type = INSFVOutletPressureBC
  #   variable = pressure
  #   function = 1e5
  #   boundary = 'top_top'
  # []
[]

################################################################################
# MATERIALS
################################################################################

[Functions]
  [rampdown_mu_func]
    type = ParsedFunction
    expression = mu*(100*exp(-3*t)+1)
    symbol_names = 'mu'
    symbol_values = ${mu}
  []
[]

[Materials]
  [mu]
    type = ADGenericFunctorMaterial #defines mu artificially for numerical convergence
    prop_names = 'mu rho' #it converges to the real mu eventually.
    prop_values = 'rampdown_mu_func ${rho}'
  []
  #[not_used]
  #  type = ADGenericFunctorMaterial
  #  prop_names = 'not_used'
  #  prop_values = 0
  #  block = 'shield reflector'
  #[]
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 0.0
  end_time = 17

  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    dt = 0.3
    timestep_limiting_postprocessor = 'dt_limit'
  []

  # Time integration scheme
  scheme = 'implicit-euler'

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-6
  nl_max_its = 12 # fail early and try again with a shorter time step
  l_max_its = 50
  automatic_scaling = true

[]

[Debug]
  show_var_residual_norms = true
[]

################################################################################
# Initialize from 2D
################################################################################

[MultiApps]
  [init]
    type = FullSolveMultiApp
    input_files = 'run_ns.i'
    execute_on = 'INITIAL'
    positions = "0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0
                 0 0 0"
    cli_args = "Problem/solve=false;Mesh/alpha_rotation=0
                Problem/solve=false;Mesh/alpha_rotation=22.5
                Problem/solve=false;Mesh/alpha_rotation=45
                Problem/solve=false;Mesh/alpha_rotation=67.5
                Problem/solve=false;Mesh/alpha_rotation=90
                Problem/solve=false;Mesh/alpha_rotation=112.5
                Problem/solve=false;Mesh/alpha_rotation=135
                Problem/solve=false;Mesh/alpha_rotation=157.5
                Problem/solve=false;Mesh/alpha_rotation=180
                Problem/solve=false;Mesh/alpha_rotation=202.5
                Problem/solve=false;Mesh/alpha_rotation=225
                Problem/solve=false;Mesh/alpha_rotation=247.5
                Problem/solve=false;Mesh/alpha_rotation=270
                Problem/solve=false;Mesh/alpha_rotation=292.5
                Problem/solve=false;Mesh/alpha_rotation=315
                Problem/solve=false;Mesh/alpha_rotation=337.5"
    # output_in_position = true
    run_in_position = true
  []
[]

[Transfers]
  [vel_x]
    type = MultiAppNearestNodeTransfer
    from_multi_app = init
    source_variable = vel_x
    variable = vel_x
  []
  [vel_y]
    type = MultiAppNearestNodeTransfer
    from_multi_app = init
    source_variable = vel_y
    variable = vel_y
  []
  [vel_z]
    type = MultiAppNearestNodeTransfer
    from_multi_app = init
    source_variable = vel_z
    variable = vel_z
  []
  [pressure]
    type = MultiAppNearestNodeTransfer
    from_multi_app = init
    source_variable = pressure
    variable = pressure
  []
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  csv = true
  hide = 'dt_limit'
  [restart]
    type = Exodus
    execute_on = 'final'
  []
  [check]
    type = Exodus
  []
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = vel_x
    value_type = max
    block = 'MSFR Pump HX'
  []
  [mu_value]
    type = FunctionValuePostprocessor
    function = rampdown_mu_func
  []
  [mdot]
    type = VolumetricFlowRate
    boundary = 'hx_top'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = ${rho}
  []
  [dt_limit]
    type = Receiver
    default = 1
  []
[]
