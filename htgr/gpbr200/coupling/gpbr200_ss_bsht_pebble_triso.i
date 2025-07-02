# ==============================================================================
# Model description:
# Equilibrium core neutronics model coupled with TH and pebble temperature
# models.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 5, 2022 14:09 PM
# Author(s)(name alph): David Reger, Dr. Javier Ortensi, Dr. Paolo Balestra,
#   Dr. Ryan Stewart, Dr. Sebastian Schunert, Dr. Zachary Prince.
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Geometry ---------------------------------------------------------------------
pebble_radius = 3.0e-2 # pebble radius (m)
pebble_shell_thickness = 5.0e-03 # pebble fuel free zone thickness (graphite shell) (m)
pebble_volume = '${fparse 4/3*pi*pebble_radius^3}' # volume of the pebble (m3)
pebble_core_volume = '${fparse 4/3*pi*(pebble_radius-pebble_shell_thickness)^3}' # volume of the pebble occupied by TRISO (m3)

kernel_radius = 2.1250e-04 # kernel particle radius (m)
kernel_volume = '${fparse 4/3*pi*kernel_radius^3}' # volume of the kernel (m3)
buffer_thickness = 1.00e-04 # Thickness of buffer (m)
ipyc_thickness = 4.00e-05 # Thickness of IPyC (m)
sic_thickness = 3.50e-05 # Thickness of SiC (m)
opyc_thickness = 4.00e-05 # Thickness of OPyC (m)

triso_radius = '${fparse kernel_radius + buffer_thickness + ipyc_thickness + sic_thickness + opyc_thickness}'
triso_volume = '${fparse 4/3*pi*triso_radius^3}' # volume of the particle (m3)

filling_factor = 0.0934404551647307 # Particle filling factor

# ICs --------------------------------------------------------------------------
initial_temperature = 1000.0 # (K)
initial_power = 10e6 # (W)

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  block_id = '     1     2      3      4    5   6    7'
  block_name = 'core shell kernel buffer ipyc sic opyc'
  coord_type = RSPHERICAL
  [pebble_mesh]
    type = CartesianMeshGenerator
    dim = 1
    # Uniform mesh.
    dx = '2.50e-02 5.00e-03'
    ix = '15 3'
    subdomain_id = '1 2'
  []
  [triso_mesh]
    type = CartesianMeshGenerator
    dim = 1
    # Uniform mesh.
    dx = '${kernel_radius} ${buffer_thickness} ${ipyc_thickness} ${sic_thickness} ${opyc_thickness}'
    ix = '21 8 3 3 3'
    subdomain_id = '3 4 5 6 7'
  []
  [mesh_combine]
    type = CombinerGenerator
    inputs = 'pebble_mesh triso_mesh'
  []
  [pebble_surface]
    type = SideSetsAroundSubdomainGenerator
    input = mesh_combine
    block = '2'
    fixed_normal = 1
    normal = '1 0 0'
    new_boundary = pebble_surface
  []
  [triso_surface]
    type = SideSetsAroundSubdomainGenerator
    input = pebble_surface
    block = '7'
    fixed_normal = 1
    normal = '1 0 0'
    new_boundary = triso_surface
  []
[]

# ==============================================================================
# VARIABLES, KERNELS, AND BOUNDARY CONDITIONS
# ==============================================================================
[Variables]
  [T_pebble]
    block = '1 2'
    initial_condition = ${initial_temperature}
  []
  [T_triso]
    block = '3 4 5 6 7'
    initial_condition = ${initial_temperature}
  []
[]

[Kernels]
  # Pebble
  [pebble_diffusion]
    type = ADHeatConduction
    variable = T_pebble
    block = '1 2'
  []
  [pebble_core_heat_source]
    type = BodyForce
    variable = T_pebble
    postprocessor = porous_media_power_density
    value = '${fparse pebble_volume/pebble_core_volume}'
    block = '1'
  []
  # TRISO
  [triso_diffusion]
    type = ADHeatConduction
    variable = T_triso
    block = '3 4 5 6 7'
  []
  [kernel_heat_source]
    type = BodyForce
    variable = T_triso
    postprocessor = porous_media_power_density
    value = '${fparse pebble_volume*triso_volume/filling_factor/pebble_core_volume/kernel_volume}'
    block = '3'
  []
[]

[BCs]
  [pebble_surface_temp]
    type = PostprocessorDirichletBC
    variable = T_pebble
    postprocessor = pebble_surface_temp
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
# MATERIALS
# ==============================================================================
[Materials]
  # Pebble.
  [pebble_core]
    type = ADGraphiteMatrixThermal
    block = '1'
    temperature = T_pebble
    graphite_grade = A3_3_1800
    packing_fraction = ${filling_factor}
    flux_conversion_factor = 1.0 # Only used for irradiation correction
    fast_neutron_fluence = 10e25
  []
  [pebble_shell]
    type = ADGraphiteMatrixThermal
    block = '2'
    temperature = T_pebble
    graphite_grade = A3_3_1800
    packing_fraction = 0
    flux_conversion_factor = 0.8 # Only used for irradiation correction
    fast_neutron_fluence = 10e25
  []

  # TRISO.
  [kernel]
    type = ADUCOThermal
    block = '3'
    temperature = T_triso
    # These do not matter since they are only relevant to heat capacity
    initial_enrichment = 0.155
    O_U = 1.5
    C_U = 0.4
  []
  [buffer]
    type = ADBufferThermal
    block = '4'
    initial_density = 1050.0
  []
  [ipyc]
    type = ADHeatConductionMaterial
    block = '5'
    thermal_conductivity = 4.0
    specific_heat = 1900.0
  []
  [sic]
    type = ADMonolithicSiCThermal
    block = '6'
    temperature = T_triso
    thermal_conductivity_model = MILLER
  []
  [opyc]
    type = ADHeatConductionMaterial
    block = '7'
    thermal_conductivity = 4.0
    specific_heat = 1900.0
  []

  # Density
  [density]
    type = ADPiecewiseConstantByBlockMaterial
    prop_name = 'density'
    subdomain_to_prop_value = '1 1740.0
                               2 1740.0
                               3 10500.0
                               4 1050.0
                               5 1900.0
                               6 3180.0
                               7 1900.0'
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
  nl_rel_tol = 1e-40
  nl_abs_tol = 1e-9
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]

[Postprocessors]
  # Pebble/TRISO interaction.
  [pebble_core_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = '1'
    execute_on = 'LINEAR'
  []

  # FROM transfer.
  [pebble_surface_temp]
    type = Receiver
    default = ${initial_temperature}
  []
  [porous_media_power_density]
    type = Receiver
    default = ${initial_power}
  []

  # TO transfer.
  [fuel_average_temp]
    type = ElementAverageValue
    variable = T_triso
    block = ' 3 '
  []
  [moderator_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = ' 1 2 '
  []
[]

[Outputs]
  console = false
[]
