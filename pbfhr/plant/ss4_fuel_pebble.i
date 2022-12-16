# ==============================================================================
# Model description
# Application : Pronghorn
# ------------------------------------------------------------------------------
# Idaho Falls, INL, November 2, 2020
# Author(s): Dr. April Novak, Dr. Guillaume Giudicelli, Dr. Paolo Balestra
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - Fuel pebble heat conduction model
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

inlet_T_fluid = 8.73150000e+02
total_power = 236.0e6 # W, from [2]
model_vol = 10.4      # active fuel region volume, from [2]

power_density = ${fparse total_power / model_vol}

# Material phase fractions
UO2_phase_fraction         = 1.20427291e-01
buffer_phase_fraction      = 2.86014816e-01
ipyc_phase_fraction        = 1.59496539e-01
sic_phase_fraction         = 1.96561801e-01
opyc_phase_fraction        = 2.37499553e-01

# Region phase fractions
TRISO_phase_fraction       = 3.09266232e-01
fuel_matrix_phase_fraction = 3.01037037e-01

# Pebble geometry
rcore                      = 1.20000000e-02
rfuel_matrix               = 1.40000000e-02
pebble_diameter            = 0.03

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = 'RSPHERICAL'
  [mesh]
    type = CartesianMeshGenerator
    dim = 1
    dx = '${rcore} ${fparse rfuel_matrix - rcore} ${fparse pebble_diameter/2 -
                                                    rfuel_matrix}'
    ix = '15 20 10'
    subdomain_id = '0 1 2'
  []

  [left]
    type = SideSetsAroundSubdomainGenerator
    block = 1
    new_boundary = 'fm_left'
    fixed_normal = true
    normal = '-1 0 0'
    input = mesh
  []
  [right]
    type = SideSetsAroundSubdomainGenerator
    block = 1
    new_boundary = 'fm_right'
    fixed_normal = true
    normal = '1 0 0'
    input = left
  []
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_fuel_matrix]
    initial_condition = ${inlet_T_fluid}
    block = '1'
  []
  [T_shell]
    initial_condition = ${inlet_T_fluid}
    block = '0 2'
  []
[]

[AuxVariables]
  [fuel_matrix_heat_source]
    initial_condition = ${power_density}
  []
[]

[Kernels]
  inactive = 'time time2'
  [time]
    type = ADHeatConductionTimeDerivative
    variable = T_fuel_matrix
    specific_heat = 'cp_s'
    density_name = 'rho_s'
  []
  [diffusion]
    type = ADHeatConduction
    variable = T_fuel_matrix
    thermal_conductivity = 'k_s'
  []
  [heat_source]
    type = HeatSrc
    variable = T_fuel_matrix
    heat_source = fuel_matrix_heat_source
    scaling_factor = ${fparse 1.0/fuel_matrix_phase_fraction}
  []

  [time2]
    type = ADHeatConductionTimeDerivative
    variable = T_shell
    specific_heat = 'cp_s'
    density_name = 'rho_s'
  []
  [diffusion2]
    type = ADHeatConduction
    variable = T_shell
    thermal_conductivity = 'k_s'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [right]
    type = PostprocessorDirichletBC
    variable = T_shell
    postprocessor = pebble_surface_T
    boundary = 'right'
  []
  [interface]
    type = LinearCombinationMatchedValueBC
    variable = T_fuel_matrix
    v = T_shell
    pp_names = 'particle_surface_T'
    pp_coefs = '-1.0'
    boundary = 'fm_left fm_right'
  []
[]

[InterfaceKernels]
  [diffusion]
    type = HeatDiffusionInterface
    variable = T_fuel_matrix
    neighbor_var = T_shell
    boundary = 'fm_left fm_right'
    k = 'k_s'
    k_neighbor = 'k_s'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[UserObjects]
  [pyc]
    type = PyroliticGraphite
  []
  [buffer]
    type = PorousGraphite
  []
  [UO2]
    type = FunctionSolidProperties
    rho_s = 11000.0
    cp_s = 400.0
    k_s = 3.5
  []
  [sic]
    type = FunctionSolidProperties
    rho_s = 3180.0
    cp_s = 1300.0
    k_s = 13.9
  []
  [pebble_graphite]
    type = FunctionSolidProperties
    rho_s = 1600.0
    cp_s = 1800.0
    k_s = 15.0
  []
  [triso]
    type = CompositeSolidProperties
    materials = 'UO2 buffer pyc sic pyc'
    fractions = '${UO2_phase_fraction} ${buffer_phase_fraction}
        ${ipyc_phase_fraction} ${sic_phase_fraction} ${opyc_phase_fraction}'
    k_mixing = 'parallel'
    rho_mixing = 'parallel'
    cp_mixing = 'parallel'
  []
  [compact]
    type = CompositeSolidProperties
    materials = 'triso pebble_graphite'
    fractions = '${TRISO_phase_fraction} ${fparse 1.0 - TRISO_phase_fraction}'
    k_mixing = 'chiew'
    rho_mixing = 'chiew'
    cp_mixing = 'chiew'
  []
  [pebble_core]
    type = FunctionSolidProperties
    rho_s = 1450.0
    cp_s = 1800.0
    k_s = 15.0
  []
[]

[Materials]
  [fuel_matrix]
    type = PronghornSolidMaterialPT
    T_solid = T_fuel_matrix     # dummy because all properties are constant
    solid = compact
    block = '1'
  []
  [shell]
    type = PronghornSolidMaterialPT
    T_solid = T_shell
    solid = pebble_graphite
    block = '2'
  []
  [core]
    type = PronghornSolidMaterialPT
    T_solid = T_shell
    solid = pebble_core
    block = '0'
  []
[]

# ==============================================================================
# MULTIAPPS FOR TRISO MODEL
# ==============================================================================
[MultiApps]
  [particle]
    type = TransientMultiApp
    execute_on = 'TIMESTEP_BEGIN'
    input_files = 'ss5_fuel_matrix.i'
  []
[]

[Transfers]
  [particle_heat_source]
    type = MultiAppVariableValueSampleTransfer
    to_multi_app = particle
    source_variable = fuel_matrix_heat_source
    variable = fuel_matrix_heat_source
  []
  [particle_surface_temp]
    type = MultiAppPostprocessorTransfer
    from_multi_app = particle
    from_postprocessor = surface_T
    to_postprocessor = particle_surface_T
    reduction_type = average
  []

  # for visualization
  [max_T_UO2]
    type = MultiAppPostprocessorTransfer
    from_multi_app = particle
    from_postprocessor = max_T_UO2
    to_postprocessor = max_T_UO2_microscale
    reduction_type = average
  []
  [average_T_UO2]
    type = MultiAppPostprocessorTransfer
    from_multi_app = particle
    from_postprocessor = average_T_UO2
    to_postprocessor = average_T_UO2_microscale
    reduction_type = average
  []
  [average_T_matrix]
    type = MultiAppPostprocessorTransfer
    from_multi_app = particle
    from_postprocessor = average_T_matrix
    to_postprocessor = average_T_matrix_microscale
    reduction_type = average
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

  # Fixed point iteration parameters
  fixed_point_force_norms = true
  fixed_point_abs_tol = 1e-2
  fixed_point_max_its = 5

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
    petsc_options_iname = '-pc_type' #-pc_factor_mat_solver_package'
    petsc_options_value = ' lu     ' # mumps                       '
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  # receive from macroscale solution
  [pebble_surface_T]
    type = Receiver
    default = ${inlet_T_fluid}
  []

  # receive from microscale solution
  [particle_surface_T]
    type = Receiver
  []
  [max_T_UO2_microscale]
    type = Receiver
  []
  [average_T_UO2_microscale]
    type = Receiver
  []
  [average_T_matrix_microscale]
    type = Receiver
  []

  # compute from present solution
  [max_T_fuel_matrix_mesoscale]
    type = ElementExtremeValue
    variable = T_fuel_matrix
    value_type = max
    block = '1'
  []
  [average_T_shell]
    type = ElementAverageValue
    variable = T_shell
    block = '0 2'
  []
  [average_T_fuel_matrix]
    type = ElementAverageValue
    variable = T_fuel_matrix
    block = '1'
  []

  # summations of mesoscale and microscale solutions
  [max_T_UO2]
    type = LinearCombinationPostprocessor
    pp_names = 'max_T_UO2_microscale max_T_fuel_matrix_mesoscale'
    pp_coefs = '1.0 1.0'
  []
  [average_T_UO2]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_UO2_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  []
  [average_T_matrix]
    type = LinearCombinationPostprocessor
    pp_names = 'average_T_matrix_microscale average_T_fuel_matrix'
    pp_coefs = '1.0 1.0'
  []
[]

[Outputs]
  exodus = false
  print_linear_residuals = false
  hide = 'max_T_UO2_microscale average_T_UO2_microscale average_T_matrix
          average_T_matrix_microscale particle_surface_T pebble_surface_T'
[]
