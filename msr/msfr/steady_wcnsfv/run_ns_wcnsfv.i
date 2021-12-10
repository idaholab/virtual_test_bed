################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn input file to initialize velocity fields                         ##
## This runs a slow relaxation to steady state while ramping down the fluid   ##
## viscosity.                                                                 ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

initialize = 1 # 1 to start without a restart file

# Material properties
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c\
# 9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
# Derived turbulent properties
von_karman_const = 0.41
Pr_t = ${fparse 4000 * 2000}  # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Mass flow rate tuning
friction = 3.1e3  # [kg / m^4]
pump_force = -60000. # [N / m^3]

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
  two_term_boundary_expansion = true

  u = v_x
  v = v_y
  pressure = pressure

  vel = 'velocity'
  advected_interp_method = ${advected_interp_method}
  velocity_interp_method = ${velocity_interp_method}
  rho = 'rho_var'
  mu = 'mu'
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  # uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    # file = '../mesh/msfr_rz_mesh.e'
    file = 'gold/run_ns_wcnsfv_out.e'
    use_for_exodus_restart = true
  []
  [min_radius]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y-0.) < 1e-10 & x < 1.8'
    input = fmg
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
    # initial_condition = 1e-6
  []
  [v_y]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
    initial_from_file_var = v_y
    # initial_condition = 1e-6
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 10
    initial_from_file_var = pressure
    # initial_condition = 1e5 # Pa
  []
  [T]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 10
    initial_from_file_var = T
    # initial_condition = 900 # K
  []
  [c1]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c2]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c3]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c4]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
  []
  [c5]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    scaling = 1e5
  []
  [c6]
    type = MooseVariableFVReal
    scaling = 1e6
    block = 'fuel pump hx'
  []
[]
[AuxVariables]
  [mixing_len]
    type = MooseVariableFVReal
    initial_from_file_var = mixing_len
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
    initial_from_file_var = eddy_viscosity
  []
  # Temporary, while we sort out if GeneralFunctorFluidProps should accept rho as
  # a variable, a material property, or both
  [rho_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    initial_from_file_var = rho_var
  []
  [mu_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    # initial_from_file_var = rho_var
  []
[]

[FVKernels]
  [mass_time]
    type = WCNSFVMassTimeDerivative
    variable = pressure
    drho_dt = drho_dt
  []
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    block = 'fuel pump hx'
    rho = 'rho'
  []

  [u_time]
    type = WCNSFVMomentumTimeDerivative
    variable = v_x
    drho_dt = drho_dt
    rho = 'rho'
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    advected_quantity = 'rhou'
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [u_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_x
    mixing_length = mixing_len
    momentum_component = 'x'
    rho = rho_var
  []
  [u_molecular_diffusion]      #Modify this
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
    type = WCNSFVMomentumTimeDerivative
    variable = v_y
    drho_dt = drho_dt
    rho = 'rho'
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    advected_quantity = 'rhov'
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [v_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_y
    mixing_length = mixing_len
    momentum_component = 'y'
    rho = rho_var
  []
  [v_molecular_diffusion]      #Modify this
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

  [heat_time]
    type = WCNSFVEnergyTimeDerivative
    variable = T
    drho_dt = drho_dt
    rho = 'rho'
    dcp_dt = dcp_dt
    cp = 'cp'
    block = 'fuel pump hx'
  []
  [heat_advection]
    type = INSFVScalarFieldAdvection
    variable = T
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    advected_quantity = 'rho_cp_temp'
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = 'rho'
    block = 'fuel pump hx'
  []
  [heat_diffusion]
    type = FVDiffusion
    coeff = k
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
    block = 'fuel pump hx'
  []
  [heat_sink]
    type = NSFVEnergyAmbientConvection
    variable = T
    # Compute the coefficient as 600 m^2 / m^3 surface area density times a heat
    # transfer coefficient of 20 kW / m^2 / K
    alpha = ${fparse 600 * 20e3}
    block = 'hx'
    T_ambient = 873.15
  []

  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    block = 'fuel pump hx'
    rho = 'rho'
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
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'shield_wall reflector_wall'
    variable = mixing_len
    execute_on = 'initial'
    block = 'fuel'
    von_karman_const = ${von_karman_const}
    delta = 0.1 # capping parameter (m)
  []
  # [wall_shear_stress]
  #   type = WallFunctionWallShearStressAux
  #   variable = wall_shear_stress
  #   walls = 'shield_wall reflector_wall'
  #   block = 'fuel'
  #   rho = 4000 #////////////////////////////
  # []
  # [wall_yplus]
  #   type = WallFunctionYPlusAux
  #   variable = wall_yplus
  #   walls = 'shield_wall reflector_wall'
  #   block = 'fuel'
  #   rho = 4000 #////////////////////////////
  # []
  [turbulent_viscosity]
    type = INSFVMixingLengthTurbulentViscosityAux
    variable = eddy_viscosity
    mixing_length = mixing_len
    block = 'fuel pump hx'
  []
  [copy_rho]
    type = FunctorMatPropElementalAux
    mat_prop = rho
    variable = rho_var
    execute_on = timestep_end
  []
  # TODO Remove once regular material property output works for functors
  [copy_mu]
    type = FunctorMatPropElementalAux
    mat_prop = mu
    variable = mu_var
    execute_on = timestep_end
  []
[]

[FVBCs]
  [walls_u]
    type = INSFVWallFunctionBC    # rethink if we should put noslip just for the hx and pump. For this I need
    variable = v_x                # an intersection between shield_walls, reflector_walls and hx and pump.
    boundary = 'shield_wall reflector_wall'
    momentum_component = x
    rho = 'rho'
  []
  [walls_v]
    type = INSFVWallFunctionBC
    variable = v_y
    boundary = 'shield_wall reflector_wall'
    momentum_component = y
    rho = 'rho'
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
    value = 'if(initialize_bool=1, 10*exp(-3*t)+1, 1)'
    vals = 'initialize_bool'
    vars = 'initialize_bool'
  []
[]

[Modules]
  [FluidProperties]
    [fp]
      # type = LiFThF4UF4TRUF3FluidProperties
      type = FlibeFluidProperties
    []
  []
[]

[Materials]
  [fluid_props]
    type = GeneralFunctorFluidProps
    fp = fp
    T_fluid = T
    pressure = pressure
    rho = 'rho_var'
    speed = 1
    mu_rampdown = rampdown_mu_func
    characteristic_length = 1
    porosity = 1
    block = 'fuel pump hx'
  []

  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    mixing_length = mixing_len
    mu = 'mu'
    block = 'fuel pump hx'
    rho = 'rho'
  []
  [ins_fv]
    type = INSFVMaterial
    block = 'fuel pump hx'
    rho = 'rho'
    temperature = T
  []
  [not_used]
    type = ADGenericConstantMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
  [friction]
    type = ADGenericConstantMaterial
    prop_names = 'friction_coef'
    prop_values = ${friction}
    block = 'hx'
  []
[]
[Debug]
  show_actions = true
  show_var_residual_norms = true
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Preconditioning]
  [SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  []
[]

[Functions]
  [time_steps]
    type = PiecewiseConstant
    x = '0    2   4'
    y = '0.01 0.1 0.2'
  []
[]

[Executioner]
  type = Transient

  start_time = 0.0
  end_time = 5

  [TimeStepper]
    type = FunctionDT
    function = time_steps
  []

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 3e-8
  nl_max_its = 22
  l_max_its = 50
  automatic_scaling = true
  off_diagonals_in_auto_scaling = true

  steady_state_detection  = true
  steady_state_tolerance  = 1e-8
  steady_state_start_time = 0.5
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  # hide = 'initialize_bool min_hx_P max_hx_P mdot_hx_bot mdot_hx_top'
[]

[Postprocessors]
  [initialize_bool]
    type = Receiver
    default = ${initialize}
  []
  # [num_failed]
  #   type = CumulativeValuePostprocessor
  #   execute_on = FAILED
  # []

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
  [mu_multiplier]
    type = FunctionValuePostprocessor
    function = rampdown_mu_func
  []
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'min_core_radius'
    vel_x = v_x
    vel_y = v_y
    advected_variable = 'rho_var'
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
  # [max_hx_P]
  #   type = SideAverageValue
  #   variable = 'pressure'
  #   boundary = 'hx_top'
  # []
  # [min_hx_P]
  #   type = SideAverageValue
  #   variable = 'pressure'
  #   boundary = 'hx_bot'
  # []
  # [dP_hx]
  #   type = DifferencePostprocessor
  #   value1 = max_hx_P
  #   value2 = min_hx_P
  # []
[]
