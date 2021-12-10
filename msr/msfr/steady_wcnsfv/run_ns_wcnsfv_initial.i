################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn input file to initialize velocity fields                         ##
## This runs a slow relaxation to steady state while ramping down the fluid   ##
## viscosity.                                                                 ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 'rho' # density from fluid properties
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
    scaling = 100
    #initial_from_file_var = pressure
    initial_condition = 1e5
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
  [temp_fluid]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    initial_condition = 800
  []
  [rho_var]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
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
    rho = 'rho_var'
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
    rho = 'rho_var'
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
    type = FunctorADMatPropElementalAux
    mat_prop = rho
    variable = rho_var
    execute_on = timestep_end
  []
[]

[FVBCs]
  [walls_u]
    type = INSFVWallFunctionBC    #rethink if we should put noslip just for the hx and pump.For this I need
    variable = v_x                #an intersection between shield_walls, reflector_walls and hx and pump.
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
    value = mu*(100*exp(-3*t)+1)
    vars = 'mu'
    vals = ${mu}
  []
[]

[Modules]
  [FluidProperties]
    [fp]
      type = FlibeFluidProperties  #!!!!!!!
    []
  []
[]

[Materials]
  [fluid_props]
    type = GeneralFunctorFluidProps
    fp = fp
    T_fluid = temp_fluid
    pressure = pressure
    mu_rampdown = rampdown_mu_func

    speed = 1
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
  []
  [not_used]
    type = ADGenericConstantMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
  [friction]
    type = ADGenericConstantFunctorMaterial
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
    solve_type = 'NEWTON'
  []
[]

[Executioner]
  type = Transient

  start_time = 0.0
  num_steps = 10
  dt = 0.001

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 2e-8
  nl_max_its = 22
  l_max_its = 50
  automatic_scaling = true
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  # execute_on = 'final'
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
