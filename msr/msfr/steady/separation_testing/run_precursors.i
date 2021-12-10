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
mu = 0.0166 # viscosity [Pa s], from
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc9\
# 5c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-\
# for-the-molten-salt-fast-reactor.pdf

# Derived turbulent properties
#von_karman_const = 0.41
Sc_t = 1 # turbulent Schmidt number

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
  [fission_source]
    type = MooseVariableFVReal
    # Fission source is re-initalized by a transfer from neutronics
    [InitialCondition]
      type = FunctionIC
      function = 'fission_guess'
    []
    block = 'fuel pump hx'
  []

  # To advect the precursors
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
    initial_from_file_var = pressure
  []
[]

[Functions]
  # Guess to have a 3D power distribution
  # TODO: use a Bessel function radially
  [fission_guess]
    type = ParsedFunction
    value = '6.303329e+01/2.81543 * max(0, cos(x*pi/2/1.2))*max(0, cos(y*pi/2/1.1))'
  []
[]

[FVKernels]
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
  end_time = 1000
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
  [total_fission_source]
    type = ElementIntegralVariablePostprocessor
    variable = fission_source
    block = 'fuel pump hx'
  []
[]
