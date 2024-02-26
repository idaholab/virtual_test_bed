# ==============================================================================
# Model description
# Application : Pronghorn
# ------------------------------------------------------------------------------
# Idaho Falls, INL, November 2, 2020
# Author(s): Dr. April Novak, Dr. Guillaume Giudicelli, Dr. Paolo Balestra
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - TRISO particle heat conduction model
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Multiscale Core Thermal Hydraulics Analysis of the Pebble Bed Fluoride
#     Salt Cooled High Temperature Reactor (PB-FHR), A. Novak et al.
# [2] Technical Description of the “Mark 1” Pebble-Bed Fluoride-Salt-Cooled
#     High-Temperature Reactor (PB-FHR) Power Plant, UC Berkeley report 14-002
# ==============================================================================
# Notes:
# - The temperature is shifted to have a 0 average over the microscale.
# - The input may be run separately by activating the time derivative kernel
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------

# Phase fractions at all scales in the pebble
fuel_matrix_phase_fraction = 3.01037037e-01
TRISO_phase_fraction       = 3.09266232e-01
UO2_phase_fraction         = 1.20427291e-01

# TRISO particle geometry
rUO2                       = 2.00000000e-04
rbuffer                    = 3.00000000e-04
ripyc                      = 3.35000000e-04
rSiC                       = 3.70000000e-04
ropyc                      = 4.05000000e-04
stainsby_sphere_radius     = 5.98886039e-04

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = 'RSPHERICAL'
  type = MeshGeneratorMesh
  block_id ='1 2 3 4 5 6'
  block_name = 'uo2 buffer ipyc sic opyc graphite_matrix'

  [gen_mesh]
    type = CartesianMeshGenerator
    dim = 1

    dx = '${rUO2} ${fparse rbuffer - rUO2} ${fparse ripyc - rbuffer}
          ${fparse rSiC - ripyc} ${fparse ropyc - rSiC}
          ${fparse stainsby_sphere_radius - ropyc}'
    ix = '20 10 4 4 4 20'
    subdomain_id = '1 2 3 4 5 6'
  []
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_unshifted]
  []
[]

[AuxVariables]
  [fuel_matrix_heat_source]
  []
  [T]
  []
[]

[Kernels]
  inactive = 'time'
  [time]
    type = ADHeatConductionTimeDerivative
    variable = T_unshifted
    specific_heat = 'cp_s'
    density_name = 'rho_s'
    block = '1 2 3 4 5 6'
  []
  [diffusion]
    type = ADHeatConduction
    variable = T_unshifted
    thermal_conductivity = 'k_s'
    block = '1 2 3 4 5 6'
  []
  [heat_source]
    type = HeatSrc
    variable = T_unshifted
    heat_source = fuel_matrix_heat_source
    scaling_factor = ${fparse 1.0/fuel_matrix_phase_fraction/TRISO_phase_fraction/UO2_phase_fraction}
    block = '1'
  []
  [heat_sink_for_zero_average_over_matrix]
    type = HeatSrc
    variable = T_unshifted
    heat_source = fuel_matrix_heat_source
    scaling_factor = ${fparse - 1.0/fuel_matrix_phase_fraction}
    block = '1 2 3 4 5 6'
  []
[]

[AuxKernels]
  # Shift variable to average 0
  [T]
    type = ShiftedAux
    variable = T
    unshifted_variable = T_unshifted
    shift_postprocessor = negative_average_T_unshifted
    execute_on = 'TIMESTEP_END'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [right]
    type = DirichletBC
    variable = T_unshifted
    value = 0.0
    boundary = 'right'
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
  [graphite_matrix]
    type = FunctionSolidProperties
    rho_s = 1600.0
    cp_s = 1800.0
    k_s = 15.0
  []
[]

[Materials]
  # the temperature coupled to these materials is not actually used since all
  # properties are constant w.r.t. temperature
  [pyc]
    type = PronghornSolidMaterialPT
    solid = pyc
    block = '3 5'
    T_solid = T_unshifted
  []
  [UO2]
    type = PronghornSolidMaterialPT
    solid = UO2
    block = '1'
    T_solid = T_unshifted
  []
  [buffer]
    type = PronghornSolidMaterialPT
    solid = buffer
    block = '2'
    T_solid = T_unshifted
  []
  [SiC]
    type = PronghornSolidMaterialPT
    solid = sic
    block = '4'
    T_solid = T_unshifted
  []
  [graphite_matrix]
    type = PronghornSolidMaterialPT
    solid = graphite_matrix
    block = '6'
    T_solid = T_unshifted
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
  nl_abs_tol = 1e-6

  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1
    cutback_factor     = 0.5
    growth_factor      = 4.0
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [average_T_unshifted]
    type = ElementAverageValue
    variable = T_unshifted
    execute_on = 'LINEAR'
  []
  [negative_average_T_unshifted]
    type = ScalePostprocessor
    value = average_T_unshifted
    scaling_factor = -1.0
    execute_on = 'TIMESTEP_END'
  []
  [surface_T]
    type = PointValue
    variable = T
    point = '${stainsby_sphere_radius} 0.0 0.0'
    execute_on = 'TIMESTEP_END'
  []

  # for visualization only
  [max_T_UO2]
    type = ElementExtremeValue
    variable = T
    value_type = max
    block = '1'
    execute_on = 'TIMESTEP_END'
  []
  [average_T_UO2]
    type = ElementAverageValue
    variable = T
    block = '1'
    execute_on = 'TIMESTEP_END'
  []
  [average_T_matrix]
    type = ElementAverageValue
    variable = T
    block = '6'
    execute_on = 'TIMESTEP_END'
  []
[]

[Outputs]
  print_linear_residuals = false
  hide = 'average_T_unshifted negative_average_T_unshifted'
[]
