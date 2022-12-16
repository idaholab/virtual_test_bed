################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Transient 3D thermal hydraulics model                                      ##
## Laminar flow, addition of turbulence is WIP                                ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

## WARNING

# This input is present for documentation purposes. It is not actively
# maintained and should not be used under any circumstance.

## WARNING

# This simulation restarts from the steady state multiphysics coupled
# calculation Exodus output for the Pronghorn input. This can be re-generated
# in that folder by running run_neutronics.i with Griffin and Pronghorn
# coupled.

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 # viscosity [Pa s], see steady/ reference
k = 1.7 # thermal conductivity [W / m / K]

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Turbulent properties
Pr_t = 10 # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Operating parameters
T_HX = 873.15 # heat exchanger temperature [K]

# Mass flow rate tuning
friction = 4e3  # [kg / m^4]
pump_force = -20000  # [N / m^3]

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
  u = 'v_x'
  v = 'v_y'
  pressure = 'pressure'
  temperature = 'T'

  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  mu = 'mu'
  rho = ${rho}
  mixing_length = 'mixing_len'
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    block = 'fuel pump hx'
  []
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    file = '../steady/restart/run_ns_coupled_restart.e'
    use_for_exodus_restart = true
  []
  # If already deleted in the restart exodus, then remove this block
  # [inactive]
  #   type = BlockDeletionGenerator
  #   input = fmg
  #   block = 'shield reflector'
  # []
[]

################################################################################
# EQUATIONS: VARIABLES & KERNELS
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
  []
  [c1]
    type = MooseVariableFVReal
    initial_from_file_var = c1
    block = 'fuel pump hx'
  []
  [c2]
    type = MooseVariableFVReal
    initial_from_file_var = c2
    block = 'fuel pump hx'
  []
  [c3]
    type = MooseVariableFVReal
    initial_from_file_var = c3
    block = 'fuel pump hx'
  []
  [c4]
    type = MooseVariableFVReal
    initial_from_file_var = c4
    block = 'fuel pump hx'
  []
  [c5]
    type = MooseVariableFVReal
    initial_from_file_var = c5
    block = 'fuel pump hx'
  []
  [c6]
    type = MooseVariableFVReal
    initial_from_file_var = c6
    block = 'fuel pump hx'
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
  []
  [c2_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c2
    block = 'fuel pump hx'
  []
  [c3_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c3
    block = 'fuel pump hx'
  []
  [c4_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c4
    block = 'fuel pump hx'
  []
  [c5_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c5
    block = 'fuel pump hx'
  []
  [c6_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c6
    block = 'fuel pump hx'
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
    type = INSFVWallFunctionBC
    variable = v_x
    boundary = 'shield_wall reflector_wall'
    momentum_component = 'x'
  []
  [walls_v]
    type = INSFVWallFunctionBC
    variable = v_y
    boundary = 'shield_wall reflector_wall'
    momentum_component = 'y'
  []
  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    variable = v_x
    boundary = 'fluid_symmetry'
    momentum_component = 'x'
    mu = 'total_viscosity'
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    variable = v_y
    boundary = 'fluid_symmetry'
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
  [matprops_former_type]  # Yplus kernel not migrated to functor materials
    type = ADGenericFunctionMaterial
    prop_names = 'alpha'
    prop_values = '${fparse 600 * 20e3}'
    block = 'fuel pump hx'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    block = 'fuel pump hx'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mu = 'mu'
    block = 'fuel pump hx'
  []
  [friction]
    type = ADGenericFunctorMaterial
    prop_names = 'friction_coef'
    prop_values = '${friction} '
    block = 'hx'
  []
  [functor_mat_properties]
    type = ADGenericFunctorMaterial
    prop_names = 'cp alpha_b mu'
    prop_values = '${cp} ${alpha} ${mu}'
    block = 'fuel pump hx'
  []
[]

################################################################################
# PUMP COASTDOWN PARAMETERS
################################################################################

[Functions]
  [pump_fun]
    type = PiecewiseConstant
    xy_data = '0.0 1
               4.0 0.5'
    direction = 'left'
  []
[]

[Controls]
  [pump_control]
    type = RealFunctionControl
    parameter = 'FVKernels/pump/scaling_factor'
    function = 'pump_fun'
    execute_on = 'initial timestep_begin'
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
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 50'
  line_search = 'none'
  nl_rel_tol = 1e-9
  nl_abs_tol = 2e-08
  nl_max_its = 20
  l_max_its = 50

  automatic_scaling = true
  resid_vs_jac_scaling_param = 1
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
  hide = 'max_v flow_hx_bot flow_hx_top min_flow_T max_flow_T'
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
    boundary = 'min_core_radius'
    vel_x = v_x
    vel_y = v_y
    advected_mat_prop = ${rho}
  []
  # TODO: weakly compressible, switch to mass flow rate
  [flow_hx_bot]
    type = InternalVolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = v_x
    vel_y = v_y
  []
  [flow_hx_top]
    type = InternalVolumetricFlowRate
    boundary = 'hx_top'
    vel_x = v_x
    vel_y = v_y
  []
  [max_flow_T]
    type = InternalVolumetricFlowRate
    boundary = 'hx_top'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
  []
  [min_flow_T]
    type = InternalVolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
  []
  [dT]
    type = ParsedPostprocessor
    function = '-max_flow_T / flow_hx_bot + min_flow_T / flow_hx_top'
    pp_names = 'max_flow_T min_flow_T flow_hx_bot flow_hx_top'
  []
  [power]
    type = Receiver
  []
  [pump]
    type = FunctionValuePostprocessor
    function = 'pump_fun'
  []
[]
