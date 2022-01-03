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

# Turbulent properties
Pr_t = 1  # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Operating parameters
T_HX = 873.15 # heat exchanger temperature [K]

# Mass flow rate tuning, for heat exchanger pressure and temperature drop
friction = 3.5e3  # [kg / m^4]
pump_force = -20000. # [N / m^3]

# Delayed neutron precursor parameters. Lambda values are decay constants in
# [1 / s]. Beta values are production fractions.
lambda1 = 0.0133104
lambda2 = 0.0305427
lambda3 = 0.115179
lambda4 = 0.301152
lambda5 = 0.879376
lambda6 = 2.91303
beta1 = 8.42817e-05
beta2 = 0.000684616
beta3 = 0.000479796
beta4 = 0.00103883
beta5 = 0.000549185
beta6 = 0.000184087

[GlobalParams]
  u = v_x
  v = v_y
  pressure = pressure
  temperature = T

  advected_interp_method = ${advected_interp_method}
  velocity_interp_method = ${velocity_interp_method}
  mu = 'mu'
  rho = ${rho}
  mixing_length = 'mixing_len'
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    block = 'fuel pump hx'
    standard_body_forces = true
  []
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
    # file = 'restart/run_ns_coupled_restart.e'
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
    scaling = 1
    # initial_condition = ${T_HX}
    initial_from_file_var = T
  []
  [c1]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c1
  []
  [c2]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c2
  []
  [c3]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c3
  []
  [c4]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
    initial_from_file_var = c4
  []
  [c5]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
    initial_from_file_var = c5
  []
  [c6]
    type = MooseVariableFVReal
    scaling = 1e6
    block = 'fuel pump hx'
    initial_from_file_var = c6
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
  [fission_source]
    type = MooseVariableFVReal
    # Fission source is re-initalized by a transfer from neutronics
    [InitialCondition]
      type = FunctionIC
      function = 'fission_guess'
    []
    block = 'fuel pump hx'
  []
  [eddy_viscosity]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []

  # Variables for comparing
  [v_x_var]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
    initial_from_file_var = v_x
  []
  [v_y_var]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
    initial_from_file_var = v_y
  []
  [pressure_var]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 0.1
    initial_from_file_var = pressure
  []
  [T_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1
    # initial_condition = ${T_HX}
    initial_from_file_var = T
  []
  [c1_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c1
  []
  [c2_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c2
  []
  [c3_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
    initial_from_file_var = c3
  []
  [c4_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
    initial_from_file_var = c4
  []
  [c5_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
    initial_from_file_var = c5
  []
  [c6_var]
    type = MooseVariableFVReal
    scaling = 1e6
    block = 'fuel pump hx'
    initial_from_file_var = c6
  []

  # Variables for comparing
  [v_x_comp]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
  []
  [v_y_comp]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
  []
  [pressure_comp]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
  []
  [T_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c1_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c2_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c3_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c4_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c5_comp]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [c6_comp]
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
  [fission_guess]
    type = ParsedFunction
    value = '6.303329e+01/2.81543 * max(0, cos(x*pi/2/1.2))*max(0, cos(y*pi/2/1.1))'
  []
  [rampdown_mu_func]
    type = ParsedFunction
    value = mu*(100*exp(-3*t)+1)
    vars = 'mu'
    vals = ${mu}
  []
  [ad_rampdown_mu_func]
    type = ADParsedFunction
    value = mu*(100*exp(-3*t)+1)
    vars = 'mu'
    vals = ${mu}
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
    mixing_length = mixing_len
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
    mixing_length = mixing_len
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
  #[v_gravity]
  #  type = INSFVMomentumGravity
  #  variable = v_y
  #  gravity = '0 -9.81 0'
  #  block = 'fuel pump hx'
  #  momentum_component = 'y'
  #[]

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

  # [heat_time]
  #   type = INSFVEnergyTimeDerivative
  #   variable = T
  #   rho = '1'
  #   cp_name = 'cp_unitary'
  # []
  # [heat_advection]
  #   type = INSFVScalarFieldAdvection
  #   variable = T
  #   block = 'fuel pump hx'
  # []
  # [heat_diffusion]
  #   type = FVDiffusion
  #   coeff = ${fparse k / rho / cp}
  #   variable = T
  #   block = 'fuel pump hx'
  # []
  # [heat_turb_diffusion]
  #   type = INSFVMixingLengthScalarDiffusion
  #   schmidt_number = ${Pr_t}
  #   variable = T
  #   block = 'fuel pump hx'
  # []
  # [heat_src]
  #   type = FVCoupledForce
  #   variable = T
  #   v = power_density
  #   coef = ${fparse 1 / rho / cp}
  #   block = 'fuel pump hx'
  # []
  # [heat_sink]
  #   type = NSFVEnergyAmbientConvection
  #   variable = T
  #   # Compute the coefficient as 600 m^2 / m^3 surface area density times a heat
  #   # transfer coefficient of 20 kW / m^2 / K
  #   alpha = 'alpha'
  #   block = 'hx'
  #   T_ambient = ${T_HX}
  # []

  [heat_time]
    type = INSFVEnergyTimeDerivative
    variable = T
    cp_name = 'cp'
  []
  [heat_advection]
    type = INSFVEnergyAdvection
    variable = T
    block = 'fuel pump hx'
  []
  [heat_diffusion]
    type = FVDiffusion
    coeff = '${k}'
    variable = T
    block = 'fuel pump hx'
  []
  [heat_turb_diffusion]
    type = WCNSFVMixingLengthEnergyDiffusion
    schmidt_number = ${Pr_t}
    variable = T
    block = 'fuel pump hx'
    cp = 'cp'
  []
  [heat_src]
    type = FVCoupledForce
    variable = T
    v = power_density
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

  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    block = 'fuel pump hx'
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    block = 'fuel pump hx'
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    block = 'fuel pump hx'
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    block = 'fuel pump hx'
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    block = 'fuel pump hx'
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    block = 'fuel pump hx'
  []
  [c1_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c1
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c2_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c2
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c3_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c3
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c4_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c4
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c5_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c5
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c6_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c6
    block = 'fuel pump hx'
    mixing_length = mixing_len
  []
  [c1_src]
    type = FVCoupledForce
    variable = c1
    v = fission_source
    coef = ${beta1}
    block = 'fuel pump hx'
  []
  [c2_src]
    type = FVCoupledForce
    variable = c2
    v = fission_source
    coef = ${beta2}
    block = 'fuel pump hx'
  []
  [c3_src]
    type = FVCoupledForce
    variable = c3
    v = fission_source
    coef = ${beta3}
    block = 'fuel pump hx'
  []
  [c4_src]
    type = FVCoupledForce
    variable = c4
    v = fission_source
    coef = ${beta4}
    block = 'fuel pump hx'
  []
  [c5_src]
    type = FVCoupledForce
    variable = c5
    v = fission_source
    coef = ${beta5}
    block = 'fuel pump hx'
  []
  [c6_src]
    type = FVCoupledForce
    variable = c6
    v = fission_source
    coef = ${beta6}
    block = 'fuel pump hx'
  []
  [c1_decay]
    type = FVReaction
    variable = c1
    rate = ${lambda1}
    block = 'fuel pump hx'
  []
  [c2_decay]
    type = FVReaction
    variable = c2
    rate = ${lambda2}
    block = 'fuel pump hx'
  []
  [c3_decay]
    type = FVReaction
    variable = c3
    rate = ${lambda3}
    block = 'fuel pump hx'
  []
  [c4_decay]
    type = FVReaction
    variable = c4
    rate = ${lambda4}
    block = 'fuel pump hx'
  []
  [c5_decay]
    type = FVReaction
    variable = c5
    rate = ${lambda5}
    block = 'fuel pump hx'
  []
  [c6_decay]
    type = FVReaction
    variable = c6
    rate = ${lambda6}
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
  [wall_shear_stress]
    type = WallFunctionWallShearStressAux
    variable = wall_shear_stress
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    mu = 'mu_mat' # FIXME, transition to functors, use total_viscosity
  []
  [wall_yplus]
    type = WallFunctionYPlusAux
    variable = wall_yplus
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    mu = 'mu_mat' # FIXME, transition to functors, use total_viscosity
  []
  [turbulent_viscosity]
    type = INSFVMixingLengthTurbulentViscosityAux
    variable = eddy_viscosity
    block = 'fuel pump hx'
  []

  [comp_vx]
    type = ParsedAux
    variable = 'v_x_comp'
    args = 'v_x v_x_var'
    function = '(v_x - v_x_var) / v_x_var * 100'
  []
  [comp_vy]
    type = ParsedAux
    variable = 'v_y_comp'
    args = 'v_y v_y_var'
    function = '(v_y - v_y_var) / v_y_var * 100'
  []
  [comp_pressure]
    type = ParsedAux
    variable = 'pressure_comp'
    args = 'pressure pressure_var'
    function = '(pressure - pressure_var) / pressure_var * 100'
  []
  [comp_T]
    type = ParsedAux
    variable = 'T_comp'
    args = 'T T_var'
    function = '(T - T_var) / T_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c1]
    type = ParsedAux
    variable = 'c1_comp'
    args = 'c1 c1_var'
    function = '(c1 - c1_var) / c1_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c2]
    type = ParsedAux
    variable = 'c2_comp'
    args = 'c2 c2_var'
    function = '(c2 - c2_var) / c2_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c3]
    type = ParsedAux
    variable = 'c3_comp'
    args = 'c3 c3_var'
    function = '(c3 - c3_var) / c3_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c4]
    type = ParsedAux
    variable = 'c4_comp'
    args = 'c4 c4_var'
    function = '(c4 - c4_var) / c4_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c5]
    type = ParsedAux
    variable = 'c5_comp'
    args = 'c5 c5_var'
    function = '(c5 - c5_var) / c5_var * 100'
    block = 'fuel pump hx'
  []
  [comp_c6]
    type = ParsedAux
    variable = 'c6_comp'
    args = 'c6 c6_var'
    function = '(c6 - c6_var) / c6_var * 100'
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
    mu = 'total_viscosity'
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_y
    momentum_component = 'y'
    mu = 'total_viscosity'
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
    prop_values = 'rampdown_mu_func'
    block = 'fuel pump hx'
  []
  [heat_exchanger_coefficient]
    type = ADGenericFunctionMaterial
    prop_names = 'alpha'
    prop_values = '${fparse 600 * 20e3}'
    block = 'fuel pump hx'
  []
  [boussinesq]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha_b'
    prop_values = '${alpha}'
  []
  [mu]
    type = ADGenericFunctorMaterial
    prop_names = 'mu'
    prop_values = 'ad_rampdown_mu_func'
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
    type = ADGenericFunctorMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
  [friction]
    type = ADGenericFunctorMaterial
    prop_names = 'friction_coef'
    prop_values = '${friction} '
    block = 'hx'
  []
  [cp]
    type = ADGenericFunctorMaterial
    prop_names = 'cp'
    prop_values = '${cp}'
    block = 'fuel pump hx'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Functions]
  [dts]
    type = PiecewiseConstant
    x = '0    100'
    y = '0.1 2.5'
  []
[]

[Executioner]
  type = Transient

  # Time stepping parameters
  start_time = 0.0
  end_time = 20
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
  [total_fission_source]
    type = ElementIntegralVariablePostprocessor
    variable = fission_source
    block = 'fuel pump hx'
  []
[]
