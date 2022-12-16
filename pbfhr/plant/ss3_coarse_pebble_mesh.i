# ==============================================================================
# Model description
# Application : any MOOSE application
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 10, 2020
# Author(s): Dr. Guillaume Giudicelli, Dr. Paolo Balestra
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - Coarse mesh to run fuel and graphite pebble calculations
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

total_power = 236.0e6 # W, from [2]
model_vol = 10.4      # active fuel region volume, from [2]

power_density = ${fparse total_power / model_vol}

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = RZ
  [read_mesh]
    type = FileMeshGenerator
    file = '../meshes/core_coarse.e'
  []
  [delete_1]
    type = BlockDeletionGenerator
    input = read_mesh
    block = '1 2 5 6 7 8 9'
  []
[]

[Problem]
  kernel_coverage_check = false
  skip_nl_system_check = true
[]

[Debug]
  show_material_props = true
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
[]

[FVKernels]
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [temp_solid]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900.0
    fv = true
  []
  [power_distribution]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = ${power_density}
    fv = true
    block = '3'
  []
  [max_T_UO2]
    block = '3'
  []
  [average_T_UO2]
    block = '3'
  []
  [average_T_matrix]
    block = '3'
  []
  [average_T_shell]
    block = '3'
  []
  [average_T_graphite]
    block = '4'
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
[]
# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
[]

[FVBCs]
[]
# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Transient

  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1
    cutback_factor     = 0.5
    growth_factor      = 4.0
  []
[]

# ==============================================================================
# MULTIAPPS FOR PEBBLE MODEL
# ==============================================================================
[MultiApps]
  [fuel_pebble]
    type = CentroidMultiApp
    execute_on = 'TIMESTEP_END'
    input_files = 'ss4_fuel_pebble.i'
    cli_args = 'Outputs/console=false'
    output_in_position = true
    block = '3'
    # Use a lighter application for performance
    # app_type = PronghornApp
    # library_path = "/Users/giudgl-mac/projects/pronghorn/lib"
    max_procs_per_app = 1
  []
  [graphite_pebble]
    type = CentroidMultiApp
    execute_on = 'TIMESTEP_END'
    input_files = 'ss4_graphite_pebble.i'
    cli_args = 'Outputs/console=false'
    output_in_position = true
    block = '4'
    # Use a lighter application for performance
    # app_type = HeatConductionApp
    # library_path = "/Users/giudgl-mac/projects/moose/modules/heat_conduction/lib"
    max_procs_per_app = 1
  []
[]

[Transfers]
  [fuel_matrix_heat_source]
    type = MultiAppVariableValueSampleTransfer
    to_multi_app = fuel_pebble
    source_variable = power_distribution
    variable = fuel_matrix_heat_source
  []
  [pebble_surface_temp_1]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = fuel_pebble
    source_variable = temp_solid
    postprocessor = pebble_surface_T
  []
  [pebble_surface_temp_2]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = graphite_pebble
    source_variable = temp_solid
    postprocessor = pebble_surface_T
  []

  # received for visualization purposes only
  [max_T_UO2]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = fuel_pebble
    postprocessor = max_T_UO2
    variable = max_T_UO2
  []
  [average_T_UO2]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = fuel_pebble
    postprocessor = average_T_UO2
    variable = average_T_UO2
  []
  [average_T_matrix]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = fuel_pebble
    postprocessor = average_T_matrix
    variable = average_T_matrix
  []
  [average_T_graphite]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = graphite_pebble
    postprocessor = average_T
    variable = average_T_graphite
  []
  [average_T_shell]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = fuel_pebble
    postprocessor = average_T_shell
    variable = average_T_shell
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [max_Ts]
    type = ElementExtremeValue
    variable = 'temp_solid'
  []
  [max_Tuo2]
    type = ElementExtremeValue
    variable = 'max_T_UO2'
    block = '3'
  []
[]

[Outputs]
  exodus = true
[]
