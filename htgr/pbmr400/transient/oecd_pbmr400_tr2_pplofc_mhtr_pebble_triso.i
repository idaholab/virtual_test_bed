# ==============================================================================
# PBMR-400 pebble/TRISO 1-D model, NEA/NSC/DOC(2013)10
# SUBAPP2 Pebble/TRISO 1-D model, Pebble surface temp and power density supplied
# by TH MAIN1 TH app.
# FENIX input file
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 01/20/2020
# Author(s): Dr. Paolo Balestra, Dr. Sebastian Schunert
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - tr2: Transient simulation sub app level 2
# - mhtr: Moose for heat transfer calculation
# - pebble_triso: Simulation of the single pebble and TRISO particle
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Geometry and data ------------------------------------------------------------
pebble_radius              = 3.0e-2 # pebble radius (m)
pebble_shell_thickness     = 5.0e-03 # pebble fuel free zone thickness (graphite shell) (m)
pebble_volume              = ${fparse 4/3*pi*pebble_radius^3} # volume of the pebble (m3)
pebble_core_volume         = ${fparse 4/3*pi*(pebble_radius-pebble_shell_thickness)^3} # volume of the pebble occupied by TRISO (m3)

kernel_radius              = 2.50e-04
kernel_volume              = ${fparse 4/3*pi*kernel_radius^3} # volume of the kernel (m3)
triso_number               = 15000 # number of TRISO particle in a pebble (//)

pebble_bed_porosity        = 0.39 # Pebble bed porosity (//)

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = 'RSPHERICAL'
  block_id = ' 1 2 3 4 5 6 7 '
  block_name = ' core
                 shell
                 kernel
                 buffer
                 ipyc
                 sic
                 opyc '
  dim = 1
  [pebble_mesh]
    type = CartesianMeshGenerator
    dim = 1

    # Uniform mesh.
    dx = ' 2.50e-02 5.00e-03 '
    ix = ' 15 3 '
    subdomain_id = ' 1 2 '

    # Isocoric mesh.
    # dx = ' 1.5749e-02 4.0935e-03 2.8715e-03 2.2860e-03
    #        1.8777e-03 1.6466e-03 1.4757e-03 '
    # subdomain_id = ' 1 1 1 1
    #                  2 2 2 '

  []
  [triso_mesh]
    type = CartesianMeshGenerator
    dim = 1

    # Uniform mesh.
    dx = ' 2.50e-04 9.50e-05 4.00e-05 3.50e-05 4.00e-05 '
    ix = ' 21 8 3 3 3 '
    subdomain_id = ' 3 4 5 6 7 '

    # Isocoric mesh.
    # dx = ' 1.7334e-04 4.5055e-05 3.1605e-05
    #        2.4629e-05 2.0861e-05 1.8270e-05 1.6359e-05 1.4881e-05
    #        1.4335e-05 1.3274e-05 1.2391e-05
    #        1.2358e-05 1.1634e-05 1.1007e-05
    #        1.0707e-05 1.0200e-05 9.7486e-06 9.3442e-06 '
    # subdomain_id = ' 3 3 3
    #                  4 4 4 4 4
    #                  5 5 5
    #                  6 6 6
    #                  7 7 7 7 '
  []
  [mesh_combine]
    type = CombinerGenerator
    inputs = ' pebble_mesh triso_mesh'
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
  [pebble_center]
    type = SideSetsAroundSubdomainGenerator
    block = ' 1 '
    fixed_normal = -1
    normal = ' 1 0 0 '
    input = triso_surface
    new_boundary = pebble_center
  []
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_pebble]
    block = ' 1 2 '
  []
  [T_triso]
    block = ' 3 4 5 6 7 '
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
    type = HeatSrc
    variable = T_pebble
    heat_source = porous_media_power_density
    scaling_factor = ${fparse 1/(1-pebble_bed_porosity)*pebble_volume/pebble_core_volume}
    block = ' 1 '
  []
  [triso_diffusion]
    type = ADHeatConduction
    variable = T_triso
    thermal_conductivity = 'k_s'
    block = ' 3 4 5 6 7 '
  []
  [kernel_heat_source]
    type = HeatSrc
    variable = T_triso
    heat_source = porous_media_power_density
    scaling_factor = ${fparse 1/(1-pebble_bed_porosity)*pebble_volume/triso_number/kernel_volume}
    block = ' 3 '
  []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [porous_media_power_density]
    block = ' 1 3 '
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  # Pebble.
  [pebble_core]
    type = PronghornSolidMaterialPT
    T_solid = T_pebble
    solid = pebble_core
    block = ' 1 '
  []
  [pebble_shell]
    type = PronghornSolidMaterialPT
    T_solid = T_pebble
    solid = gmatrix
    block = ' 2 '
  []

  # TRISO.
  [kernel]
    type = PronghornSolidMaterialPT
    T_solid = T_triso
    solid = kernel
    block = ' 3 '
  []
  [buffer]
    type = PronghornSolidMaterialPT
    T_solid = T_triso
    solid = buffer
    block = ' 4 '
  []
  [ipyc]
    type = PronghornSolidMaterialPT
    T_solid = T_triso
    solid = ipyc
    block = ' 5 '
  []
  [sic]
    type = PronghornSolidMaterialPT
    T_solid = T_triso
    solid = sic
    block = ' 6 '
  []
  [opyc]
    type = PronghornSolidMaterialPT
    T_solid = T_triso
    solid = opyc
    block = ' 7 '
  []
[]

[UserObjects]
  # Single component materials.
  [kernel]
    type = FunctionSolidProperties
    k_s = '1/(0.035 + 2.25e-4*t) + 8.30e-11*t^3'
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []
  [buffer]
    type = FunctionSolidProperties
    k_s = 0.5
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []
  [ipyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []
  [sic]
    type = FunctionSolidProperties
    k_s = 16.0
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []
  [opyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []
  [gmatrix]
    type = FunctionSolidProperties
    k_s = 26.0
    rho_s = 1.0 #dummy
    cp_s = 1.0 #dummy
  []

  # Mixtures.
  [triso]
    type = CompositeSolidProperties
    materials = 'kernel buffer ipyc sic opyc'
    fractions = '0.1605 0.2613 0.1644 0.1749 0.2388' # volume fractions.
    k_mixing = 'series'
  []
  [pebble_core]
    type = CompositeSolidProperties
    materials = 'triso gmatrix'
    fractions = '0.0935 0.9065' # volume fractions.
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
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Transient # Pseudo transient to reach steady state.
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  line_search = l2

  # Problem time parameters.
  dt = 1e+15 # Let the parent app control time steps.
  reset_dt = true
  start_time = 0.0

  # Linear/nonlinear iterations.
  nl_abs_tol = 1e-8

[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  # Feedbacks between peble and TRISO.
  [pebble_core_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = ' 1 '
    execute_on = 'LINEAR'
  []
  [pebble_core_center_temp]
    type = NodalExtremeValue
    variable = T_pebble
    block = ' 1 '
    value_type = max
    execute_on = 'LINEAR'
  []

  # Feedbacks from the fluid app
  [pebble_surface_temp]
    type = Receiver
  []

  # Feedbacks to the fluid app
  [moderator_average_temp]
    type = ElementAverageValue
    variable = T_pebble
    block = ' 1 '
  []
  [fuel_average_temp]
    type = ElementAverageValue
    variable = T_triso
    block = ' 3 '
  []

  # Feedbacks benchmark.
  # [moderator_average_temp]
  #   type = ElementAverageValue
  #   variable = T_pebble
  #   block = ' 1 2 '
  # []
  # [fuel_average_temp]
  #   type = ElementAverageValue
  #   variable = T_pebble
  #   block = ' 1 '
  # []
[]

[Outputs]
  file_base = oecd_pbmr400_tr2_lf40_mhtr_pebble_triso
  exodus = false
  csv = false
  console = false
[]
