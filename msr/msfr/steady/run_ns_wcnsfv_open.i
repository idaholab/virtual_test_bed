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
# 'run_neutronics.i', saved in 'restart/run_neutronics_ns_restart.e'

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 # viscosity [Pa s]
k = 1.7 # thermal conductivity [W / m / K]
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc9\
# 5c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-\
# for-the-molten-salt-fast-reactor.pdf

# Turbulent properties
Pr_t = 10 # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Operating parameters
inlet_T = 873.15 # heat exchanger temperature [K]

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
  T_fluid = T

  rhie_chow_user_object = 'rc'
  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  mu = 'mu'
  rho = 'rho'
  drho_dt = 'drho_dt'
  cp = 'cp'
  dcp_dt = 'dcp_dt'
  mixing_length = 'mixing_len'
  fp = fp
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
    file = 'restart/run_ns_wcnsfv_restart.e'
    # - v_x, v_y, p, T, lambda, c_i from coupled multiphysics simulation
    # file = 'restart/run_ns_coupled_restart.e'
  []

  # Remove the volumetric HX and add the inlet and outlet
  # Only needs to be done if starting from a closed loop
  [add_region]
    type = SubdomainBoundingBoxGenerator
    input = restart
    block_id = 144
    bottom_left = '1.9 -0.89 0'
    top_right = '2.35 0.89 0'
  []
  [add_inlet]
    type = SideSetsAroundSubdomainGenerator
    input = add_region
    new_boundary = 'inlet'
    block = 'fuel'
    normal = '0 1 0'
    fixed_normal = true
    normal_tol = 1e-8
  []
  [add_outlet]
    type = ParsedGenerateSideset
    input = add_inlet
    combinatorial_geometry = 'x>1.9 & y>0.885 & y<0.895'
    new_sideset_name = 'outlet'
  []
  [delete_region]
    type = BlockDeletionGenerator
    input = add_outlet
    block = '144'
  []
[]

[Problem]
  coord_type = 'RZ'
  rz_coord_axis = Y
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS
################################################################################

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    block = 'fuel'
    initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    block = 'fuel'
    initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel'
    initial_condition = 1e5
    # initial_from_file_var = pressure
  []
  [T]
    type = INSFVEnergyVariable
    block = 'fuel'
    initial_condition = ${inlet_T}
    # initial_from_file_var = T
  []
  [c1]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c1
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.02
    []
  []
  [c2]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c2
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.1
    []
  []
  [c3]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c3
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.03
    []
  []
  [c4]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c4
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.04
    []
  []
  [c5]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c5
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.01
    []
  []
  [c6]
    type = MooseVariableFVReal
    block = 'fuel'
    # initial_from_file_var = c6
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = 0.001
    []
  []
[]

[AuxVariables]
  [mixing_len]
    type = MooseVariableFVReal
    initial_from_file_var = mixing_len
    block = 'fuel'
  []
  [power_density]
    type = MooseVariableFVReal
    block = 'fuel'
    # Power density is re-initalized by a transfer from neutronics
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = ${fparse 3e9/2.81543}
    []
  []
  [fission_source]
    type = MooseVariableFVReal
    # Fission source is re-initalized by a transfer from neutronics
    [InitialCondition]
      type = FunctionIC
      function = 'cosine_guess'
      scaling_factor = ${fparse 6.303329e+01/2.81543}
    []
    block = 'fuel'
  []

  # For visualization purposes
  [eddy_viscosity]
    type = MooseVariableFVReal
    block = 'fuel'
  []
  [wall_shear_stress]
    type = MooseVariableFVReal
    block = 'fuel'
  []
  [wall_yplus]
    type = MooseVariableFVReal
    block = 'fuel'
  []
[]

[Functions]
  # Guess to have a 3D power distribution
  [cosine_guess]
    type = ParsedFunction
    value = 'max(0, cos(x*pi/2/1.2))*max(0, cos(y*pi/2/1.1))'
  []
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    block = 'fuel'
  []
[]

[FVKernels]
  [mass_time]
    type = WCNSFVMassTimeDerivative
    variable = pressure
    block = 'fuel'
  []
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    block = 'fuel'
  []

  [u_time]
    type = WCNSFVMomentumTimeDerivative
    variable = v_x
    momentum_component = 'x'
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    block = 'fuel'
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
    block = 'fuel'
    momentum_component = 'x'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = v_x
    momentum_component = 'x'
    block = 'fuel'
  []

  [v_time]
    type = WCNSFVMomentumTimeDerivative
    variable = v_y
    momentum_component = 'y'
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    block = 'fuel'
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
    block = 'fuel'
    momentum_component = 'y'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v_y
    momentum_component = 'y'
    block = 'fuel'
  []
  [v_gravity]
    type = INSFVMomentumGravity
    variable = v_y
    gravity = '0 -9.81 0'
    block = 'fuel'
    momentum_component = 'y'
  []

  [heat_time]
    type = WCNSFVEnergyTimeDerivative
    variable = T
  []
  [heat_advection]
    type = INSFVEnergyAdvection
    variable = T
    block = 'fuel'
  []
  [heat_diffusion]
    type = FVDiffusion
    coeff = '${k}'
    variable = T
    block = 'fuel'
  []
  [heat_turb_diffusion]
    type = WCNSFVMixingLengthEnergyDiffusion
    schmidt_number = ${Pr_t}
    variable = T
    block = 'fuel'
    cp = 'cp'
  []
  [heat_src]
    type = FVCoupledForce
    variable = T
    v = power_density
    block = 'fuel'
  []

  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    block = 'fuel'
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    block = 'fuel'
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    block = 'fuel'
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    block = 'fuel'
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    block = 'fuel'
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    block = 'fuel'
  []
  [c1_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c1
    block = 'fuel'
  []
  [c2_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c2
    block = 'fuel'
  []
  [c3_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c3
    block = 'fuel'
  []
  [c4_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c4
    block = 'fuel'
  []
  [c5_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c5
    block = 'fuel'
  []
  [c6_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c6
    block = 'fuel'
  []
  [c1_src]
    type = FVCoupledForce
    variable = c1
    v = fission_source
    coef = ${beta1}
    block = 'fuel'
  []
  [c2_src]
    type = FVCoupledForce
    variable = c2
    v = fission_source
    coef = ${beta2}
    block = 'fuel'
  []
  [c3_src]
    type = FVCoupledForce
    variable = c3
    v = fission_source
    coef = ${beta3}
    block = 'fuel'
  []
  [c4_src]
    type = FVCoupledForce
    variable = c4
    v = fission_source
    coef = ${beta4}
    block = 'fuel'
  []
  [c5_src]
    type = FVCoupledForce
    variable = c5
    v = fission_source
    coef = ${beta5}
    block = 'fuel'
  []
  [c6_src]
    type = FVCoupledForce
    variable = c6
    v = fission_source
    coef = ${beta6}
    block = 'fuel'
  []
  [c1_decay]
    type = FVReaction
    variable = c1
    rate = ${lambda1}
    block = 'fuel'
  []
  [c2_decay]
    type = FVReaction
    variable = c2
    rate = ${lambda2}
    block = 'fuel'
  []
  [c3_decay]
    type = FVReaction
    variable = c3
    rate = ${lambda3}
    block = 'fuel'
  []
  [c4_decay]
    type = FVReaction
    variable = c4
    rate = ${lambda4}
    block = 'fuel'
  []
  [c5_decay]
    type = FVReaction
    variable = c5
    rate = ${lambda5}
    block = 'fuel'
  []
  [c6_decay]
    type = FVReaction
    variable = c6
    rate = ${lambda6}
    block = 'fuel'
  []
[]

[AuxKernels]
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
    block = 'fuel'
    execute_on = 'initial'
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
    momentum_component = 'x'
  []
  [walls_v]
    type = INSFVWallFunctionBC
    variable = v_y
    boundary = 'shield_wall reflector_wall'
    momentum_component = 'y'
  []

  [inlet_mass]
    type = WCNSFVMassFluxBC
    variable = pressure
    boundary = 'inlet'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_v_x]
    type = WCNSFVMomentumFluxBC
    variable = v_x
    boundary = 'inlet'
    mdot_pp = 0
    area_pp = 'surface_inlet'
    rho = 'rho'
    momentum_component = 'x'
  []
  [inlet_v_y]
    type = WCNSFVMomentumFluxBC
    variable = v_y
    boundary = 'inlet'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
    momentum_component = 'y'
  []
  [inlet_T]
    type = WCNSFVEnergyFluxBC
    variable = T
    boundary = 'inlet'
    temperature_pp = 'inlet_T'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
    cp = 'cp'
  []
  [inlet_c1]
    type = WCNSFVScalarFluxBC
    variable = c1
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c1'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_c2]
    type = WCNSFVScalarFluxBC
    variable = c2
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c2'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_c3]
    type = WCNSFVScalarFluxBC
    variable = c3
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c1'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_c4]
    type = WCNSFVScalarFluxBC
    variable = c4
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c2'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_c5]
    type = WCNSFVScalarFluxBC
    variable = c5
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c1'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []
  [inlet_c6]
    type = WCNSFVScalarFluxBC
    variable = c6
    boundary = 'inlet'
    scalar_value_pp = 'inlet_c2'
    mdot_pp = 'inlet_mdot'
    area_pp = 'surface_inlet'
    rho = 'rho'
  []

  [outlet_p]
    type = INSFVOutletPressureBC
    boundary = 'outlet'
    function = '1e5'
    variable = 'pressure'
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

[Modules]
  [FluidProperties]
    [fp]
      type = SimpleFluidProperties
      density0 = '${fparse rho + 1000*drho_dT}'
      thermal_expansion = '${alpha}'
      viscosity = '${mu}'
      thermal_conductivity = '${k}'
      cp = '${cp}'
    []
  []
[]

[Materials]
  [fluid_props]
    type = GeneralFunctorFluidProps
    mu_rampdown = 1
    block = 'fuel'
    force_define_density = true
    # Below not used, for porous flow
    characteristic_length = 1
    speed = 1
    porosity = 1
  []
  [heat_exchanger_coefficient]
    type = ADGenericFunctionMaterial
    prop_names = 'alpha'
    prop_values = '${fparse 600 * 20e3}'
    block = 'fuel'
  []
  [boussinesq]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha_b'
    prop_values = '${alpha}'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mu = 'mu'
    block = 'fuel'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    block = 'fuel'
  []
  # [not_used]
  #   type = ADGenericFunctorMaterial
  #   prop_names = 'not_used'
  #   prop_values = 0
  #   block = 'shield reflector'
  # []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Functions]
  [dts]
    type = PiecewiseConstant
    x = '0    100'
    y = '0.75 2.5'
  []
[]

[Executioner]
  type = Transient

  # Time stepping parameters
  start_time = 0.0
  end_time = 21
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

  nl_rel_tol = 1e-9
  nl_abs_tol = 2e-7
  nl_max_its = 15
  l_max_its = 50

  automatic_scaling = true
  compute_scaling_once = true
  resid_vs_jac_scaling_param = 1
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  # hide = 'flow_inlet flow_outlet flow_T_inlet flow_T_outlet'
  [restart]
    type = Exodus
    overwrite = true
  []
  # Reduce base output
  # print_linear_converged_reason = false
  # print_linear_residuals = false
  # print_nonlinear_converged_reason = false
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = v_x
    value_type = max
    block = 'fuel'
  []
  [inlet_mdot]
    type = Receiver
<<<<<<< HEAD
    default = -1.8e4
=======
    default = 1.8e4
>>>>>>> 040a92cd240cb2f9059afc0b338884cb75894c6c
  []
  [inlet_T]
    type = Receiver
    default = ${inlet_T}
  []
  [inlet_c1]
    type = Receiver
    default = 0
  []
  [inlet_c2]
    type = Receiver
    default = 0
  []
  [inlet_c3]
    type = Receiver
    default = 0
  []
  [inlet_c4]
    type = Receiver
    default = 0
  []
  [inlet_c5]
    type = Receiver
    default = 0
  []
  [inlet_c6]
    type = Receiver
    default = 0
  []
  [surface_inlet]
    type = AreaPostprocessor
    boundary = 'inlet'
    execute_on = 'initial'
  []

  # TODO: weakly compressible, switch to mass flow rate
  [flow_inlet]
    type = InternalVolumetricFlowRate
    boundary = 'inlet'
    vel_x = v_x
    vel_y = v_y
  []
  [flow_outlet]
    type = InternalVolumetricFlowRate
    boundary = 'outlet'
    vel_x = v_x
    vel_y = v_y
  []
  [flow_T_inlet]
    type = InternalVolumetricFlowRate
    boundary = 'outlet'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
  []
  [flow_T_outlet]
    type = InternalVolumetricFlowRate
    boundary = 'inlet'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'T'
  []
  [dT]
    type = ParsedPostprocessor
    function = '-flow_T_outlet / flow_outlet + flow_T_inlet / flow_inlet'
    pp_names = 'flow_inlet flow_T_inlet flow_outlet flow_T_outlet'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'fuel'
  []
  [total_fission_source]
    type = ElementIntegralVariablePostprocessor
    variable = fission_source
    block = 'fuel'
  []
[]
