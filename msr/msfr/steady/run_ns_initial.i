################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn input file to initialize velocity fields                         ##
## This runs a slow relaxation to steady state while ramping down the fluid   ##
## viscosity.                                                                 ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

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

  vel = 'velocity'
  advected_interp_method = ${advected_interp_method}
  velocity_interp_method = ${velocity_interp_method}
  mu = 'mu'
  rho = ${rho}
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
    #initial_from_file_var = mixing_len
  []
  [wall_shear_stress]
    type = MooseVariableFVReal
  []
  [wall_yplus]
    type = MooseVariableFVReal
  []
  [power_density]
    type = MooseVariableFVReal
  []
  [fission_source]
    type = MooseVariableFVReal
  []
  [eddy_viscosity]
    type = MooseVariableFVReal
    #initial_from_file_var = eddy_viscosity
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
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    advected_quantity = 'rhou'
    block = 'fuel pump hx'
  []
  [u_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_x
    mixing_length = mixing_len
    momentum_component = 'x'
  []
  [u_molecular_diffusion]
    type = FVDiffusion
    variable = v_x
    coeff = 'mu'
    block = 'fuel pump hx'
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
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    advected_quantity = 'rhov'
    block = 'fuel pump hx'
  []
  [v_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_y
    rho = ${rho}
    mixing_length = mixing_len
    momentum_component = 'y'
  []
  [v_molecular_diffusion]
    type = FVDiffusion
    variable = v_y
    coeff = 'mu'
    block = 'fuel pump hx'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v_y
    momentum_component = 'y'
    block = 'fuel pump hx'
  []

  [pump]
    type = FVBodyForce
    variable = v_y
    value = ${pump_force}
    block = 'pump'
  []

  [friction_hx_x]
    type = INSFVMomentumFriction
    variable = v_x
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
  []
  [friction_hx_y]
    type = INSFVMomentumFriction
    variable = v_y
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
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
    mu = 'mu_mat'
  []
  [wall_yplus]
    type = WallFunctionYPlusAux
    variable = wall_yplus
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    mu = 'mu_mat'
  []
  [turbulent_viscosity]
    type = INSFVMixingLengthTurbulentViscosityAux
    variable = eddy_viscosity
    mixing_length = mixing_len
    block = 'fuel pump hx'
  []
[]

################################################################################
# BOUNDARY CONDITIONS
################################################################################

[FVBCs]
  [walls_u]
    type = INSFVWallFunctionBC    #rethink if we should put noslip just for the hx and pump.For this I need
    variable = v_x                #an intersection between shield_walls, reflector_walls and hx and pump.
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
  [mu_mat]  # Yplus kernel not migrated to functor materials
    type = ADGenericFunctionMaterial      #defines mu artificially for numerical convergence
    prop_names = 'mu_mat'                     #it converges to the real mu eventually.
    prop_values = 'rampdown_mu_func'
  []
  [mu]
    type = ADGenericFunctorMaterial      #defines mu artificially for numerical convergence
    prop_names = 'mu'                     #it converges to the real mu eventually.
    prop_values = 'ad_rampdown_mu_func'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mixing_length = mixing_len
    mu = 'mu'
    block = 'fuel pump hx'
  []
  [ins_fv]
    type = INSFVMaterial
    block = 'fuel pump hx'
  []
  [not_used]
    type = ADGenericFunctorMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
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

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Functions]
  [dts]
    type = PiecewiseConstant
    x = '0   0.4 0.8 1   2.2 4.0  4.3 5   8.8 9.2 9.8'
    y = '0.2 0.4 0.2 0.4 0.1 0.05 0.1 0.2 0.4 0.8 2'
  []
[]

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 0.0
  end_time = 15

  [TimeStepper]
    type = FunctionDT
    function = dts
  []
  timestep_tolerance = 1e-13 # to avoid round off errors

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu 50'
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
    fv = false # see MOOSE #18817
  []
[]
