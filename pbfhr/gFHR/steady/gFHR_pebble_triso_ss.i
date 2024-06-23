# ------------------------------------------------------------------------------
# Description:
# gFHR salt simulation
# Porous Flow Incompressible Media Finite Volume
# sprvel: superficial formulation of the velocities
# Use a reduced heat capacity to accelerate the steady state convergence
# ------------------------------------------------------------------------------
# Description:
# gFHR Pebble temperature model for equilibrium core calculation
# Currently using a Dirichlet BC
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Geometry and data.
pebble_center_core_radius = 1.38e-2 # pebble fuel free zone radius (graphite core) (m)
pebble_fuel_radius = 1.8e-2 # pebble fuel zone radius (m)
pebble_radius = 2.0e-2 # pebble radius (m)
pebble_volume = '${fparse 4/3*pi*pow(pebble_radius,3)}' # volume of the pebble (m3)
pebble_fuel_volume = '${fparse 4/3*pi*(pow(pebble_fuel_radius,3)-pow(pebble_center_core_radius,3))}' # volume of the pebble occupied by TRISO (m3)
kernel_radius = 2.125e-04 # kernel particle radius (m)
kernel_volume = '${fparse 4/3*pi*pow(kernel_radius,3)}' # volume of the kernel (m3)
triso_number = 9022 # Number of TRISO particles in a pebble

# Initial values.
initial_temperature = 873.15 # (K)
initial_power_density = 3.34e+07 # (W/m3)

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]

  block_id = '1     2     3      4      5      6    7   8'
  block_name = 'pcore pfuel pshell kernel buffer ipyc sic opyc'
  dim = 1

  [pebble_mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = '1.38e-02 4.20e-03 2.00e-03'
    ix = '3        6       3'
    subdomain_id = '1        2       3'
  []
  [triso_mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = '2.125e-04 1.00e-04 4.00e-05 3.50e-05 4.00e-05'
    ix = '4         3         3         3         3'
    subdomain_id = '4         5         6         7         8'
  []
  [mesh_combine]
    type = CombinerGenerator
    inputs = 'pebble_mesh triso_mesh'
  []
  [pebble_surface]
    type = SideSetsAroundSubdomainGenerator
    block = '3'
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = mesh_combine
    new_boundary = pebble_surface
  []
  [triso_surface]
    type = SideSetsAroundSubdomainGenerator
    block = '8'
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = pebble_surface
    new_boundary = triso_surface
  []
  coord_type = 'RSPHERICAL'
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_pebble]
    block = 'pcore pfuel pshell'
    initial_condition = ${initial_temperature}
  []
  [T_triso]
    block = 'kernel buffer ipyc sic opyc'
    initial_condition = ${initial_temperature}
  []
[]

[Kernels]
  # Pebble.
  [pebble_diffusion]
    type = ADHeatConduction
    variable = T_pebble
    thermal_conductivity = 'k_s'
    block = 'pcore pfuel pshell'
  []
  [pebble_fuel_heat_source]
    type = CoupledForce
    block = 'pfuel'
    v = pebble_power_density
    variable = T_pebble
  []
  # TRISO.
  [triso_diffusion]
    type = ADHeatConduction
    variable = T_triso
    thermal_conductivity = 'k_s'
    block = 'kernel buffer ipyc sic opyc'
  []
  [kernel_heat_source]
    type = CoupledForce
    block = 'kernel'
    v = kernel_power_density
    variable = T_triso
  []
[]

[AuxVariables]
  [dummy_pden]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0 # used for scaling the
  []
  [pebble_power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [pfuel_power_density]
    order = CONSTANT
    family = MONOMIAL
    block = 'pfuel'
  []
  [kernel_power_density]
    order = CONSTANT
    family = MONOMIAL
    block = 'kernel'
  []
[]

[AuxKernels]
  # we need an AuxKernel that can set a constant value based on a pp
  [pebble_power_density]
    type = ScaleAux
    source_variable = dummy_pden
    variable = pebble_power_density
    multiplying_pp = pebble_power_density
  []
  [pfuel_power_density]
    type = ParsedAux
    block = 'pfuel'
    variable = pfuel_power_density
    expression = 'pebble_power_density * ${fparse pebble_volume / pebble_fuel_volume}'
    coupled_variables = 'pebble_power_density'
  []
  [kernel_power_density]
    type = ParsedAux
    block = 'kernel'
    variable = kernel_power_density
    expression = 'pebble_power_density * ${fparse pebble_volume / triso_number / kernel_volume}'
    coupled_variables = 'pebble_power_density'
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [pebble_fuel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = pebble_fuel
    block = 'pfuel'
  []
  [pebble_graphite_core]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = gcore
    block = 'pcore'
  []
  [pebble_graphite_shel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = gmatrix
    block = 'pshell'
  []

  # TRISO.
  [kernel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = kernel
    block = 'kernel'
  []
  [buffer]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = buffer
    block = 'buffer'
  []
  [ipyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = ipyc
    block = 'ipyc'
  []
  [sic]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = sic
    block = 'sic'
  []
  [opyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = opyc
    block = 'opyc'
  []
[]

[UserObjects]
  [kernel]
    type = FunctionSolidProperties
    k_s = '1/(0.035 + 2.25e-4*t) + 8.30e-11*t^3'
    rho_s = 10500.0
    cp_s = 320.0
  []
  [buffer]
    type = FunctionSolidProperties
    k_s = 0.7
    rho_s = 1050.0
    cp_s = 1760.0
  []
  [ipyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1900.0
    cp_s = 1760.0
  []
  [sic]
    type = FunctionSolidProperties
    k_s = 16.0
    rho_s = 3180.0
    cp_s = 1242.0
  []
  [opyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1900.0
    cp_s = 1760.0
  []
  [gmatrix]
    type = FunctionSolidProperties
    k_s = 32.4
    rho_s = 1740.0
    cp_s = 1760.0
  []
  [gcore]
    type = FunctionSolidProperties
    k_s = 30.0
    rho_s = 1410.0
    cp_s = 1760.0
  []

  # Mixtures.
  [triso]
    type = CompositeSolidProperties
    materials = '  kernel     buffer        ipyc        sic        opyc    '
    fractions = '0.122819817 0.267788699 0.170012025 0.18412303 0.255256428' # volume fractions.
    k_mixing = 'series'
  []
  [pebble_fuel]
    type = CompositeSolidProperties
    materials = 'triso gmatrix'
    fractions = '0.220003 0.779997' # volume fractions.
    k_mixing = 'chiew'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [pebble_surface_temp]
    type = PostprocessorDirichletBC
    variable = T_pebble
    postprocessor = T_surface
    boundary = 'pebble_surface'
  []
  [triso_surface_temp]
    type = PostprocessorDirichletBC
    variable = T_triso
    postprocessor = pebble_fuel_average_temp
    boundary = 'triso_surface'
  []
[]
# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Steady
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  line_search = 'l2'

  # Automatic scaling.
  automatic_scaling = true

  # Linear/nonlinear iterations.
  nl_rel_tol = 1e-40
  nl_abs_tol = 1e-5
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]

[Postprocessors]
  [pebble_int_power]
    type = ElementIntegralVariablePostprocessor
    variable = pebble_power_density
    block = 'pcore pfuel pshell'
    execute_on = 'TIMESTEP_END'
  []
  [pfuel_int_power]
    type = ElementIntegralVariablePostprocessor
    variable = pfuel_power_density
    block = 'pfuel'
    execute_on = 'TIMESTEP_END'
  []
  [triso_int_power]
    type = ElementIntegralVariablePostprocessor
    variable = kernel_power_density
    block = 'kernel'
    execute_on = 'TIMESTEP_END'
  []
  [triso_total_power]
    type = ParsedPostprocessor
    expression = 'triso_int_power * ${triso_number}'
    pp_names = 'triso_int_power'
    execute_on = 'TIMESTEP_END'
  []

  # FROM Griffin
  [pebble_power_density]
    type = Receiver
    default = ${initial_power_density}
  []
  [T_surface]
    type = Receiver
    default = ${initial_temperature}
  []

  # Pebble TRISO comunication.
  [pebble_fuel_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = 'pfuel'
    execute_on = 'INITIAL LINEAR TIMESTEP_END'
  []

  # TO Griffin.
  [T_mod]
    type = ElementAverageValue
    variable = T_pebble
    block = 'pcore pfuel pshell'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_fuel]
    type = ElementAverageValue
    variable = T_triso
    block = 'kernel'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Outputs]
  exodus = false
  csv = false
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
  console = false # turn this to true or comment it out to turn on console output
[]
