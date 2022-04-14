################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn input file to initialize velocity fields                         ##
## This runs a slow relaxation to steady state while ramping down the fluid   ##
## viscosity.                                                                 ##
################################################################################

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
mu = 0.0166 # viscosity [Pa s]
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c\
# 9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
# Derived turbulent properties
von_karman_const = 0.41

# Mass flow rate tuning
friction = 4.0e3  # [kg / m^4]
pump_force = -20000. # [N / m^3]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/msfr_rz_mesh.e'
  []
  [min_radius]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y-0.) < 1e-10 & x < 1.8'
    input = fmg
    new_sideset_name = min_core_radius
    normal = '0 1 0'
  []
  [delete_unused]
    type = BlockDeletionGenerator
    input = min_radius
    block = 'shield reflector'
  []
[]

[Problem]
  kernel_coverage_check = false
  coord_type = 'RZ'
  rz_coord_axis = Y
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[Modules]
  [NavierStokesFV]
    # General parameters
    simulation_type = 'transient'
    compressibility = 'incompressible'
    turbulence_handling = 'mixing-length'
    gravity = '0 -9.81 0'

    # Material properties
    density = ${rho}
    dynamic_viscosity = 'mu'

    # Initial conditions
    initial_velocity = '1e-6 1e-6 0'
    initial_pressure = 1e5
    initial_temperature = 0.0

    # Boundary conditions
    wall_boundaries = 'shield_wall reflector_wall fluid_symmetry'
    momentum_wall_types = 'wallfunction wallfunction symmetry'

    # Pressure pin for incompressible flow
    pin_pressure = true
    pinned_pressure_type = average
    pinned_pressure_value = 1e5

    # Turbulence parameters
    von_karman_const = ${von_karman_const}
    mixing_length_delta = 0.1
    mixing_length_walls = 'shield_wall reflector_wall'
    mixing_length_aux_execute_on ='initial'

    # Heat exchanger friction
    friction_blocks = 'hx'
    friction_types = 'FORCHHEIMER'
    friction_coeffs = ${friction}

    # Numerical scheme
    mass_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'
  []
[]

[FVKernels]
  [pump]
    type = INSFVBodyForce
    variable = vel_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
    rhie_chow_user_object = 'ins_rhie_chow_interpolator'
  []
[]

################################################################################
# MATERIALS
################################################################################

[Functions]
  [rampdown_mu_func]
    type = ParsedFunction
    value = mu*(100*exp(-3*t)+1)
    vars = 'mu'
    vals = ${mu}
  []
  # Functor materials expect AD functors, to fix with MOOSE
  [ad_rampdown_mu_func]
    type = ADParsedFunction
    value = mu*(100*exp(-3*t)+1)
    vars = 'mu'
    vals = ${mu}
  []
[]

[Materials]
  [mu]
    type = ADGenericFunctorMaterial      #defines mu artificially for numerical convergence
    prop_names = 'mu rho'                     #it converges to the real mu eventually.
    prop_values = 'ad_rampdown_mu_func ${rho}'
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
  dt = 0.3
  num_steps = 5
  # end_time = 1.5
  #
  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   optimal_iterations = 10
  #   dt = 0.3
  #   timestep_limiting_postprocessor = 1
  # []

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-6
  nl_max_its = 12    # fail early and try again with a shorter time step
  l_max_its = 50
  automatic_scaling = true
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  csv = true
  [restart]
    type = Exodus
    execute_on = 'final'
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
    block = 'fuel pump hx'
  []
  [mu_value]
    type = FunctionValuePostprocessor
    function = rampdown_mu_func
  []
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'min_core_radius'
    vel_x = vel_x
    vel_y = vel_y
    advected_mat_prop = ${rho}
  []
[]
