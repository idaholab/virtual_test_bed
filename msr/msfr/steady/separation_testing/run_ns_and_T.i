################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Relaxation towards Steady state 3D thermal hydraulics model                ##
################################################################################

# The flow in this simulation should be initialized with a previous flow
# solution (isothermal, heated or multiphysics) OR using a viscosity rampdown
# An isothermal solution can be generated using 'run_ns_initial.i', and is
# saved in 'restart/run_ns_initial_restart.e'
# A heated solution, with a flat power distribution, can be generated with
# this script 'run_ns.i', and is saved in 'restart/run_ns_restart.e'
# A coupled neutronics-coarse TH solution can be generated with
# 'run_neutronics.i', saved in 'run_neutronics_ns_restart.e'

# Numerical scheme
advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 # viscosity [Pa s], from
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc9\
# 5c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-\
# for-the-molten-salt-fast-reactor.pdf
k = 1.7

# Derived turbulent properties
#von_karman_const = 0.41
Pr_t = 1  # turbulent Prandtl number

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Operating parameters
T_HX = 873.15 # heat exchanger temperature [K]

# Mass flow rate tuning, for heat exchanger pressure and temperature drop
friction = 3.5e3  # [kg / m^4]
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
  mixing_length = 'mixing_len'
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  [restart]
    type = FileMeshGenerator
    use_for_exodus_restart = true
    # Depending on the file chosen, the initialization of variables should be
    # adjusted. The following variables can be initalized:
    # - v_x, v_y, p, lambda from isothermal simulation
    # file = 'restart/run_ns_initial_restart.e'
    # - v_x, v_y, p, T, lambda, c_ifrom cosine heated simulation
    file = 'restart/run_ns_restart.e'
    # - v_x, v_y, p, T, lambda, c_i from coupled multiphysics simulation
    # file = 'restart/run_neutronics_ns_restart.e'
  []
  [min_radius]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y-0.) < 1e-10 & x < 1.8'
    input = restart
    new_sideset_name = min_core_radius
    normal = '0 1 0'
  []
  [hx_top]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y > 0'
    included_subdomain_ids = '3'
    included_neighbor_ids = '1'
    fixed_normal = true
    normal = '0 1 0'
    new_sideset_name = 'hx_top'
    input = 'min_radius'
  []
  [hx_bot]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y <-0.6'
    included_subdomain_ids = '3'
    included_neighbor_ids = '1'
    fixed_normal = true
    normal = '0 -1 0'
    new_sideset_name = 'hx_bot'
    input = 'hx_top'
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
    block = 'fuel pump hx'
    initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
    initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 0.1
    initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
    block = 'fuel pump hx'
    initial_from_file_var = lambda
    scaling = 1000
  []
  [T]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 100
    # initial_condition = ${T_HX}
    initial_from_file_var = T
  []
[]

[AuxVariables]
  [mixing_len]
    type = MooseVariableFVReal
    initial_from_file_var = mixing_len
    block = 'fuel pump hx'
  []
  [wall_shear_stress]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [wall_yplus]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [power_density]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    # Power density is re-initalized by a transfer from neutronics
    [InitialCondition]
      type = FunctionIC
      function = 'power_guess'
    []
  []
  [eddy_viscosity]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
[]

[Functions]
  # Guess to have a 3D power distribution
  # TODO: use a Bessel function radially
  [power_guess]
    type = ParsedFunction
    value = '3e9/2.81543 * max(0, cos(x*pi/2/1.2))*max(0, cos(y*pi/2/1.1))'
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    pressure = pressure
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
  [v_buoyancy]
    type = INSFVMomentumBoussinesq
    variable = v_y
    T_fluid = T
    gravity = '0 -9.81 0'
    ref_temperature = 1000
    momentum_component = 'y'
    block = 'fuel'
    alpha_name = 'alpha_b'
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

  [heat_time]
    type = INSFVEnergyTimeDerivative
    variable = T
    rho = '1'
    cp_name = 'cp_unitary'
  []
  [heat_advection]
    type = INSFVScalarFieldAdvection
    variable = T
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [heat_diffusion]
    type = FVDiffusion
    coeff = ${fparse k / rho / cp}
    variable = T
    block = 'fuel pump hx'
  []
  [heat_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Pr_t}
    variable = T
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [heat_src]
    type = FVCoupledForce
    variable = T
    v = power_density
    coef = ${fparse 1 / rho / cp}
    block = 'fuel pump hx'
  []
  [heat_sink]
    type = NSFVEnergyAmbientConvection
    variable = T
    # Compute the coefficient as 600 m^2 / m^3 surface area density times a heat
    # transfer coefficient of 20 kW / m^2 / K
    alpha = 'alpha'
    block = 'hx'
    T_ambient = ${T_HX}
  []
[]

[AuxKernels]
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
    block = 'fuel pump hx'
  []
[]

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

[Materials]
  [mu_mat]  # Yplus kernel not migrated to functor materials
    type = ADGenericFunctionMaterial
    prop_names = 'mu_mat'
    prop_values = '${mu}'
    block = 'fuel pump hx'
  []
  [heat_exchanger_coefficient]
    type = ADGenericFunctionMaterial
    prop_names = 'alpha'
    prop_values = '${fparse 600 * 20e3 / rho / cp}'
    block = 'fuel pump hx'
  []
  [boussinesq]
    type = ADGenericFunctionFunctorMaterial
    prop_names = 'alpha_b'
    prop_values = '${alpha}'
  []
  [mu]
    type = ADGenericFunctionFunctorMaterial
    prop_names = 'mu'
    prop_values = '${mu}'
    block = 'fuel pump hx'
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
    type = ADGenericFunctionFunctorMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
  [friction]
    type = ADGenericFunctionFunctorMaterial
    prop_names = 'friction_coef'
    prop_values = '${friction} '
    block = 'hx'
  []
  [cp]
    type = ADGenericFunctionFunctorMaterial
    prop_names = 'cp_unitary'
    prop_values = '1'
    block = 'fuel pump hx'
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
    x = '0    100'
    y = '1.25 2.5'
  []
[]

[Executioner]
  type = Transient

  # Time stepping parameters
  start_time = 0.0
  end_time = 100
  # [TimeStepper]
  #   # This time stepper makes the time step grow exponentially
  #   # It can only be used with proper initialization
  #   type = IterationAdaptiveDT
  #   dt = 10  # chosen to obtain convergence with first coupled iteration
  #   growth_factor = 2
  # []
  [TimeStepper]
    type = FunctionDT
    function = dts
  []
  steady_state_detection  = true
  steady_state_tolerance  = 1e-8
  steady_state_start_time = 10

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 50'
  line_search = 'none'

  nl_rel_tol = 1e-10
  nl_abs_tol = 2e-8
  nl_max_its = 15
  l_max_its = 50

  # automatic_scaling = true
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
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
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'min_core_radius'
    vel_x = v_x
    vel_y = v_y
    advected_interp_method = ${advected_interp_method}
    advected_mat_prop = ${rho}
    fv = false # see MOOSE #18817
  []
  [mdot_hx_bot]
    type = InternalVolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = v_x
    vel_y = v_y
    # advected_variable = 'rho_var'  # add when postprocessor uses face values properly
    fv = false # see MOOSE #18817
  []
  [mdot_hx_top]
    type = InternalVolumetricFlowRate
    boundary = 'hx_top'
    vel_x = v_x
    vel_y = v_y
    # advected_variable = 'rho_var'
    fv = false # see MOOSE #18817
  []
  [max_mdot_T]
    type = InternalVolumetricFlowRate
    boundary = 'hx_top'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
    fv = false # see MOOSE #18817
  []
  [min_mdot_T]
    type = InternalVolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
    fv = false # see MOOSE #18817
  []
  [dT]
    type = ParsedPostprocessor
    function = '-max_mdot_T / mdot_hx_bot + min_mdot_T / mdot_hx_top'
    pp_names = 'max_mdot_T min_mdot_T mdot_hx_bot mdot_hx_top'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'fuel pump hx'
  []
[]
