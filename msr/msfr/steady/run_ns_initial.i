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

[GlobalParams]
  u = v_x
  v = v_y
  pressure = pressure

  rhie_chow_user_object = 'rc'
  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  mu = 'mu'
  rho = ${rho}
  mixing_length = 'mixing_len'
[]

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

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    #initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = lambda
  []
[]

[AuxVariables]
  [mixing_len]
    type = MooseVariableFVReal
  []
  [wall_shear_stress]
    type = MooseVariableFVReal
  []
  [wall_yplus]
    type = MooseVariableFVReal
  []
  [eddy_viscosity]
    type = MooseVariableFVReal
  []
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    block = 'fuel pump hx'
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    block = 'fuel pump hx'
  []
  [mean_zero_pressure]
    type = FVScalarLagrangeMultiplier
    variable = pressure
    lambda = lambda
    block = 'fuel pump hx'
  []

  [u_time]
    type = INSFVMomentumTimeDerivative
    variable = v_x
    momentum_component = 'x'
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    block = 'fuel pump hx'
    momentum_component = 'x'
  []
  [u_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_x
    momentum_component = 'x'
  []
  [u_molecular_diffusion]
    type = INSFVMomentumDiffusion
    variable = v_x
    block = 'fuel pump hx'
    momentum_component = 'x'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = v_x
    momentum_component = 'x'
    block = 'fuel pump hx'
  []

  [v_time]
    type = INSFVMomentumTimeDerivative
    variable = v_y
    momentum_component = 'y'
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    block = 'fuel pump hx'
    momentum_component = 'y'
  []
  [v_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_y
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_molecular_diffusion]
    type = INSFVMomentumDiffusion
    variable = v_y
    block = 'fuel pump hx'
    momentum_component = 'y'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v_y
    momentum_component = 'y'
    block = 'fuel pump hx'
  []
  [v_gravity]
    type = INSFVMomentumGravity
    variable = v_y
    gravity = '0 -9.81 0'
    block = 'fuel pump hx'
    momentum_component = 'y'
  []

  [pump]
    type = INSFVBodyForce
    variable = v_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
  []

  [friction_hx_x]
    type = INSFVMomentumFriction
    variable = v_x
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
    momentum_component = 'x'
  []
  [friction_hx_y]
    type = INSFVMomentumFriction
    variable = v_y
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
    momentum_component = 'y'
  []
[]

[AuxKernels]
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'shield_wall reflector_wall'
    variable = mixing_len
    execute_on = 'initial'
    block = 'fuel'
    von_karman_const = ${von_karman_const}
    delta = 0.1 # capping parameter (m)
  []
  [wall_shear_stress]
    type = WallFunctionWallShearStressAux
    variable = wall_shear_stress
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    mu = 'total_viscosity'
  []
  [wall_yplus]
    type = WallFunctionYPlusAux
    variable = wall_yplus
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    mu = 'total_viscosity'
  []
  [turbulent_viscosity]
    type = INSFVMixingLengthTurbulentViscosityAux
    variable = eddy_viscosity
    block = 'fuel pump hx'
  []
[]

################################################################################
# BOUNDARY CONDITIONS
################################################################################

[FVBCs]
  [walls_u]
    type = INSFVWallFunctionBC
    variable = v_x
    boundary = 'shield_wall reflector_wall'
    momentum_component = x
  []
  [walls_v]
    type = INSFVWallFunctionBC
    variable = v_y
    boundary = 'shield_wall reflector_wall'
    momentum_component = y
  []

  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_x
    momentum_component = 'x'
    mu = total_viscosity
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_y
    momentum_component = 'y'
    mu = total_viscosity
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = 'fluid_symmetry'
    variable = pressure
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
    prop_names = 'mu'                     #it converges to the real mu eventually.
    prop_values = 'ad_rampdown_mu_func'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mu = 'mu'
    block = 'fuel pump hx'
  []
  #[not_used]
  #  type = ADGenericFunctorMaterial
  #  prop_names = 'not_used'
  #  prop_values = 0
  #  block = 'shield reflector'
  #[]
  [friction]
    type = ADGenericFunctorMaterial
    prop_names = 'friction_coef'
    prop_values = ${friction}
    block = 'hx'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 0.0
  end_time = 15

  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    dt = 0.3
    timestep_limiting_postprocessor = 1
  []

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
    variable = v_x
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
    vel_x = v_x
    vel_y = v_y
    advected_mat_prop = ${rho}
  []
[]
