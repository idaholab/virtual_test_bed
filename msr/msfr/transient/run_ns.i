################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Transient 3D thermal hydraulics model                                      ##
## Laminar flow, addition of turbulence is WIP                                ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 4284  # density [kg / m^3]
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 # viscosity [Pa s], see steady/ reference
k = 1.7

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Turbulent properties
Pr_t = 1  # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Operating parameters
T_HX = 873.15 # heat exchanger temperature [K]

# Derived turbulent properties
mu_t = ${fparse nu_t * rho}  # dynamic eddy viscosity
epsilon_q = ${fparse nu_t / Pr_t}  # eddy diffusivity for heat
epsilon_c = ${fparse nu_t / Sc_t}  # eddy diffusivity for precursors

# Mass flow rate tuning
friction = 3.5.e3  # [kg / m^4]
pump_force = -71401.4  # [N / m^3]

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

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../steady/restart/run_ns_coupled_restart.e'
    use_for_exodus_restart = true
  []
  # Already deleted in sample_output
  [inactive]
    type = BlockDeletionGenerator
    input = fmg
    block = 'shield reflector'
  []
[]

[Problem]
  coord_type = 'RZ'
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    initial_from_file_var = v_x
    block = 'fuel pump hx'
  []
  [v_y]
    type = INSFVVelocityVariable
    initial_from_file_var = v_y
    block = 'fuel pump hx'
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    initial_from_file_var = pressure
    scaling = 100
  []
  [lambda]
    family = SCALAR
    order = FIRST
    initial_from_file_var = lambda
    block = 'fuel pump hx'
  []
  [T]
    type = MooseVariableFVReal
    initial_from_file_var = T
    block = 'fuel pump hx'
    scaling = 100
  []
  [c1]
    type = MooseVariableFVReal
    initial_from_file_var = c1
    block = 'fuel pump hx'
    scaling = 1e6
  []
  [c2]
    type = MooseVariableFVReal
    initial_from_file_var = c2
    block = 'fuel pump hx'
    scaling = 1e6
  []
  [c3]
    type = MooseVariableFVReal
    initial_from_file_var = c3
    block = 'fuel pump hx'
    scaling = 1e6
  []
  [c4]
    type = MooseVariableFVReal
    initial_from_file_var = c4
    block = 'fuel pump hx'
    scaling = 1e7
  []
  [c5]
    type = MooseVariableFVReal
    initial_from_file_var = c5
    block = 'fuel pump hx'
    scaling = 1e7
  []
  [c6]
    type = MooseVariableFVReal
    initial_from_file_var = c6
    block = 'fuel pump hx'
    scaling = 1e8
  []
[]

[AuxVariables]
  [mixing_len]
    type = MooseVariableFVReal
    initial_from_file_var = mixing_len
    block = 'fuel pump hx'
  []
  [power_density]
    type = MooseVariableFVReal
    initial_from_file_var = power_density
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_from_file_var = fission_source
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    velocity_interp_method = ${velocity_interp_method}
    vel = 'velocity'
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
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
    rho = ${rho}
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    advected_quantity = 'rhou'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
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
    pressure = pressure
    block = 'fuel pump hx'
  []

  [v_time]
    type = INSFVMomentumTimeDerivative
    variable = v_y
    rho = ${rho}
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    advected_quantity = 'rhov'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
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
    pressure = pressure
    block = 'fuel pump hx'
  []
  [v_buoyancy]
    type = INSFVMomentumBoussinesq
    variable = v_y
    T_fluid = T
    gravity = '0 -9.81 0'
    rho = ${rho}
    ref_temperature = 700
    momentum_component = 'y'
    block = 'fuel pump hx'
  []
  [v_gravity]
    type = FVBodyForce
    variable = v_y
    value = ${fparse -9.81 * rho}
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

  [heat_time]
    type = FVTimeKernel
    variable = T
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
    mu = 'mu_t'
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
    alpha = ${fparse 600 * 20e3 / rho / cp}
    block = 'hx'
    T_ambient = 873.15
  []

  [c1_time]
    type = FVTimeKernel
    variable = c1
  []
  [c2_time]
    type = FVTimeKernel
    variable = c2
  []
  [c3_time]
    type = FVTimeKernel
    variable = c3
  []
  [c4_time]
    type = FVTimeKernel
    variable = c4
  []
  [c5_time]
    type = FVTimeKernel
    variable = c5
  []
  [c6_time]
    type = FVTimeKernel
    variable = c6
  []
  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
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
[]

################################################################################
# BOUNDARY CONDITIONS
################################################################################

[FVBCs]
  [walls_u]
    type = INSFVNaturalFreeSlipBC
    boundary = 'shield_wall reflector_wall'
    variable = v_x
  []
  [walls_v]
    type = INSFVNaturalFreeSlipBC
    boundary = 'shield_wall reflector_wall'
    variable = v_y
  []
  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_x
    u = v_x
    v = v_y
    momentum_component = 'x'
    mu = 'mu_t'
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_y
    u = v_x
    v = v_y
    momentum_component = 'y'
    mu = 'mu_t'
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = 'fluid_symmetry'
    variable = pressure
  []
[]

[Functions]
  [pump_fun]
    type = PiecewiseConstant
    xy_data = '0.0 ${pump_force}
               2.0 ${fparse 0.5*pump_force}'
    direction = 'left'
  []
[]

[Controls]
  [pump_control]
    type = RealFunctionControl
    parameter = 'FVKernels/pump/value'
    function = 'pump_fun'
    execute_on = 'initial timestep_begin'
  []
[]

################################################################################
# MATERIALS
################################################################################

[Materials]
  [matprops_former_type]  # Yplus kernel not migrated to functor materials
    type = ADGenericFunctionMaterial
    prop_names = 'alpha'
    prop_values = '${fparse 600 * 20e3 / rho / cp}'
    block = 'fuel pump hx'
  []
  [ins_fv]
    type = INSFVMaterial
    u = 'v_x'
    v = 'v_y'
    pressure = 'pressure'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mixing_length = mixing_len
    mu = 'mu'
    block = 'fuel pump hx'
  []
  [friction]
    type = ADGenericConstantFunctorMaterial
    prop_names = 'friction_coef'
    prop_values = '${friction} '
    block = 'hx'
  []
  [functor_mat_properties]
    type = ADGenericConstantFunctorMaterial
    prop_names = 'cp_unitary mu_t alpha_b'
    prop_values = '1 ${mu_t} ${alpha}'
    block = 'fuel pump hx'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time-stepping parameters
  # The time step is imposed by the neutronics app
  start_time = 0.0
  end_time = 1e10
  dt = 1e10

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_reset'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-08
  nl_max_its = 20
  l_max_its = 50
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = v_x
    value_type = max
    block = 'fuel pump hx'
  []
  [max_T]
    type = ElementExtremeValue
    variable = T
    value_type = max
    block = 'fuel pump hx'
  []
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'hx_in'
    vel_x = v_x
    vel_y = v_y
    advected_interp_method = ${advected_interp_method}
    advected_mat_prop = ${rho}
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
  [power]
    type = Receiver
  []
[]
