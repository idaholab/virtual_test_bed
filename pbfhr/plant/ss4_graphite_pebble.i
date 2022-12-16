# ==============================================================================
# Model description
# Application : MOOSE Heat Conduction module
# ------------------------------------------------------------------------------
# Idaho Falls, INL, November 2, 2020
# Author(s): Dr. April Novak, Dr. Guillaume Giudicelli, Dr. Paolo Balestra
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - Graphite pebble heat conduction model
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Multiscale Core Thermal Hydraulics Analysis of the Pebble Bed Fluoride
#     Salt Cooled High Temperature Reactor (PB-FHR), A. Novak et al.
# [2] Technical Description of the “Mark 1” Pebble-Bed Fluoride-Salt-Cooled
#     High-Temperature Reactor (PB-FHR) Power Plant, UC Berkeley report 14-002
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------

inlet_T_fluid              = 8.73150000e+02
pebble_diameter            = 0.03

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = 'RSPHERICAL'
  type = GeneratedMesh
  dim = 1
  xmin = 0.0
  xmax = ${fparse pebble_diameter / 2}
  nx = 20
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T]
    initial_condition = ${inlet_T_fluid}
  []
[]

[Kernels]
  # inactive = 'time'
  [time]
    type = ADHeatConductionTimeDerivative
    variable = T
    specific_heat = 'cp_s'
    density_name = 'rho_s'
  []
  [diffusion]
    type = ADHeatConduction
    variable = T
    thermal_conductivity = 'k_s'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [right]
    type = PostprocessorDirichletBC
    variable = T
    postprocessor = pebble_surface_T
    boundary = 'right'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [graphite_matrix]
    type = ADGenericConstantMaterial
    prop_names = 'rho_s k_s cp_s'
    prop_values = '1600 15  1800'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Transient
  num_steps = 1
  petsc_options_iname = '-pc_type -pc_hypre_type'
  petsc_options_value = 'hypre boomeramg'
  solve_type = PJFNK
  nl_abs_tol = 1e-6

  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1
    cutback_factor     = 0.5
    growth_factor      = 4.0
  []
[]

[Preconditioning]
  [SMP_Newton]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options = '-snes_ksp_ew'
    petsc_options_iname = '-pc_type'
    petsc_options_value = ' lu     '
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================

[Postprocessors]
  # receive from macroscale solution
  [pebble_surface_T]
    type = Receiver
    default = 800
  []

  # compute from present solution
  [average_T]
    type = ElementAverageValue
    variable = T
  []
[]

[Outputs]
  exodus = false
  print_linear_residuals = false
[]
