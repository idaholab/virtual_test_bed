# ==============================================================================
# Model description
# Single Pebble temperature model
# ------------------------------------------------------------------------------
# Idaho Falls, INL, September 29, 2022
# Author(s): Dr. Sebastian Schunert, Dr. Javier Ortensi, Dr. Mustafa Jaradat
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Geometry and data ------------------------------------------------------------
pebble_radius              = 3.0e-2                                                    # pebble radius (m)
pebble_shell_thickness     = 5.0e-03                                                   # pebble fuel free zone thickness (graphite shell) (m)
pebble_volume              = ${fparse 4/3*pi*pow(pebble_radius,3)}                          # volume of the pebble (m3)
pebble_core_volume         = ${fparse 4/3*pi*pow(pebble_radius-pebble_shell_thickness,3)} # volume of the pebble occupied by TRISO (m3)
kernel_radius              = 2.50e-04                         # kernel particle radius (m)
kernel_volume              = ${fparse 4/3*pi*pow(kernel_radius,3)} # volume of the kernel (m3)
triso_number               = 11668                            # number of TRISO particle in a pebble (//)
initial_temperature        = 500.0 # (K)

# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  block_id = ' 1 2 3 4 5 6 7 '
  block_name = ' core
                 shell
                 kernel
                 buffer
                 ipyc
                 sic
                 opyc'
  dim = 1
  [pebble_mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = ' 2.50e-02 5.00e-03 '
    ix = ' 15 3 '
    subdomain_id = ' 1 2 '

  []
  [triso_mesh]
    type = CartesianMeshGenerator
    dim = 1
   	dx = ' 2.50e-04 9.00e-05 4.00e-05 3.50e-05 4.00e-05 '
    ix = ' 21 8 3 3 3 '
    subdomain_id = ' 3 4 5 6 7 '
  []
  [mesh_combine]
    type = CombinerGenerator
    inputs = 'pebble_mesh triso_mesh'
  []
  [pebble_surface]
    type = SideSetsAroundSubdomainGenerator
    block = ' 2 '
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = mesh_combine
    new_boundary = pebble_surface
  []
  [triso_surface]
    type = SideSetsAroundSubdomainGenerator
    block = ' 7 '
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = pebble_surface
    new_boundary = triso_surface
  []
[]

[Debug]
  show_material_props = true
[]

[Problem]
  coord_type = 'RSPHERICAL'
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_pebble]
    block = ' 1 2 '
    initial_condition = ${initial_temperature}
  []
  [T_triso]
    block = ' 3 4 5 6 7 '
    initial_condition = ${initial_temperature}
  []
[]

[Kernels]
  [pebble_diffusion]
    type = ADHeatConduction
    variable = T_pebble
    thermal_conductivity = 'k_s'
    block = ' 1 2 '
  []

  [pebble_core_heat_source]
    type =  HeatSource
    variable = T_pebble
    postprocessor = pebble_power_density
    value = ${fparse pebble_volume/pebble_core_volume}
    block = ' 1 '
  []

  [triso_diffusion]
    type = ADHeatConduction
    variable = T_triso
    thermal_conductivity = 'k_s'
    block = ' 3 4 5 6 7 '
  []
  [kernel_heat_source]
    type = HeatSource
    variable = T_triso
    postprocessor = pebble_power_density
    value = ${fparse pebble_volume/triso_number/kernel_volume}
    block = ' 3 '
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [pebble_core]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = pebble_core
    block = ' 1 '
    output_properties = k_s
  []
  [pebble_shell]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = gmatrix
    block = ' 2 '
    output_properties = k_s
  []

  # TRISO.
  [kernel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = kernel
    block = ' 3 '
    output_properties = k_s
  []
  [buffer]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = buffer
    block = ' 4 '
    output_properties = k_s
  []
  [ipyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = ipyc
    block = ' 5 '
    output_properties = k_s
  []
  [sic]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = sic
    block = ' 6 '
    output_properties = k_s
  []
  [opyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = opyc
    block = ' 7 '
    output_properties = k_s
  []
[]

[Functions]
  [uo2_k]
    type = ParsedFunction
    value = 'if(bnp = 0, (115.8/(7.5408+17.692*(t/1000)+3.6142*(t/1000)^2)+7410.5*(t/1000)^(-5./2.)*exp(-16.35/(t/1000))),
           (115.8/(7.5408+17.692*(t/1000)+3.6142*(t/1000)^2)+7410.5*(t/1000)^(-5./2.)*exp(-16.35/(t/1000)))*
           (1.09/bnp^(3.265)+0.0643*sqrt(t/bnp))*atan(1./(1.09/bnp^(3.265)+0.0643*sqrt(t/bnp)))*
           (1+0.019*bnp/(3.-0.019*bnp)*(1.+exp(-(t-1200)/100))^(-1))*
           (1.-0.2/(1+exp((t-900.)/80.))) )'
    vars = 'bnp'
    vals = 'fima'
  []
  [buffer_k]
    type = ParsedFunction
    value = 244.3/2*t^(-0.574)*(970/(2.2*(1930.-970)+970))*(1.-0.336*(1.-exp(-1.005*gam))-3.50e-2*gam)
    vars = 'gam'
    vals = 'fluence'
  []
  [pyc_k]
    type = ParsedFunction
    value = 244.3*t^(-0.574)*(1900/(2.2*(1930.-1900)+1900))*(1.-0.336*(1.-exp(-1.005*gam))-3.50e-2*gam)
    vars = 'gam'
    vals = 'fluence'
  []
  [sic_k]
    type = ParsedFunction
    value = (17885/t+2.)*exp(-0.1277*gam)
    vars = 'gam'
    vals = 'fluence'
  []
  [gmatrix_k]
    type = ParsedFunction
    value = 47.4*(1-9.7556E-4*(t-373.15)*exp(-6.036E-4*(t-273.15)))*(1740/(2.2*(1700.-1740)+1740))*(1.-0.336*(1.-exp(-1.005*gam))-3.50e-2*gam)
    vars = 'gam'
    vals = 'fluence'
  []
  [fluence]
    type = ParsedFunction
    value = 7.41611E-06*bnp*bnp*bnp-5.36979E-06*bnp*bnp+1.37527E-02*bnp-4.48921E-02
    vars = 'bnp'
    vals = 'burnup'
  []
  [fima]
    type = ParsedFunction
    value = -2.022642E-06*bnp*bnp+1.053601E-03*bnp
    vars = 'bnp'
    vals = 'burnup'
  []
[]

[UserObjects]
  [kernel]
    type = FunctionSolidProperties
    k_s =  uo2_k
  []
  [buffer]
    type = FunctionSolidProperties
    k_s = buffer_k
  []
  [ipyc]
    type = FunctionSolidProperties
    k_s = pyc_k
  []
  [sic]
    type = FunctionSolidProperties
    k_s = sic_k
  []
  [opyc]
    type = FunctionSolidProperties
    k_s = pyc_k
  []
  [gmatrix]
    type = FunctionSolidProperties
    k_s = gmatrix_k
  []

  # Mixtures.
  [triso]
    type = CompositeSolidProperties
    materials = 'kernel buffer ipyc sic opyc'
    fractions =  '0.1659  0.2514  0.1653  0.1762  0.2412' # volume fractions.
    k_mixing = 'series'
  []
  [pebble_core]
    type = CompositeSolidProperties
    materials = 'triso gmatrix'
	  fractions = '0.090484107  0.909515893' # volume fractions.
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
    postprocessor = pebble_core_average_temp
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
  # Linear/nonlinear iterations.
  nl_abs_tol = 1e-8
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]

[Postprocessors]
  # transferred to this app
  [pebble_power_density]
    type = Receiver
    default = 5.36E+06
  []
  [burnup] # MWd/kg
    type = Receiver
    default = 0
  []
  [pebble_core_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = ' 1 '
    execute_on = 'INITIAL LINEAR'
  []
  [T_mod]
    type = ElementAverageValue
    variable = T_pebble
    block = ' 1 2 '
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_fuel]
    type = ElementAverageValue
    variable = T_triso
    block = ' 3 '
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_surface]
    type = Receiver
    default = ${initial_temperature}
  []
[]

[Outputs]
  exodus = false
  csv = false
  console = false
[]
