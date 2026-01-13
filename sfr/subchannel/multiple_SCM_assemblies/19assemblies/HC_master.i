# This heat conduction model (main app) drives a multiapp setup where subchannel hexagonal ducts (solid wrappers)
# and an interwrapper (liquid sodium interwrapper between the ducts) are modeled and the temperature field is retrieved.
# This model treats the liquid sodium interwrapper as a solid and only heat conduction is considered.
# The calculated inner duct_wall axial heat flux [W/m] is transfered to 19 SCM models that run in parallel as multiapps.
# The method of coupling is domain decomposition:
# As mentioned above the heat conduction solution sends linear heat rate calculated on the inner duct surfaces to SCM
# and retrieves inner duct surface temperature from SCM. All other surfaces of the model has a Neuman BC.
##################### Instructions ###########################
# Create mesh file: abr_19assemblies_in.e
# run with : mpiexec -n N location-of-executable -i HC_master.i --keep-cout -w
# Units are SI

# physics parameters
inlet_temperature = 653.15

## fluid properties
#####  Density #####
# A12 = 1.00423e3
# A13 = -0.21390
# A14 = -1.1046e-5
# rho = '${fparse A12 + A13 * inlet_temperature + A14 * inlet_temperature * inlet_temperature}'
# #### Viscosity
# A52 = 3.6522e-5
# A53 = 0.16626
# A54 = -4.56877e1
# A55 = 2.8733e4
# mu = '${fparse A52 + A53 / inlet_temperature + A54 / inlet_temperature / inlet_temperature +
#         A55 / (inlet_temperature * inlet_temperature * inlet_temperature)} '
# #### Specific heat at constant pressure
# A28 = 7.3898e5
# A29 = 3.154e5
# A30 = 1.1340e3
# A31 = -2.2153e-1
# A32 = 1.1156e-4
# dt = '${fparse 2503.3 - inlet_temperature}'
# cp = '${fparse A28 / dt / dt + A29 / dt + A30 + A31 * dt + A32 * dt * dt}'
#### Heat conduction coefficient
A48 = 1.1045e2
A49 = -6.5112e-2
A50 = 1.5430e-5
A51 = -2.4617e-9
k_sodium = '${fparse A48 + A49 * inlet_temperature + A50 * inlet_temperature * inlet_temperature +
        A51 * inlet_temperature * inlet_temperature * inlet_temperature} '

# wrapper properties
k_wrapper = 15

wrapper_blocks = 'duct_wall'
inter_wrapper_blocks = 'inter_wrapper'

[Mesh]
  [fmesh]
    type = FileMeshGenerator
    file = 'abr_19assemblies_in.e'
  []
  coord_type = XYZ
[]

[Materials]
  [wall_heat_conductor]
    type = HeatConductionMaterial
    thermal_conductivity = ${k_wrapper}
    block = ${wrapper_blocks}
  []
  [sodium_heat_conductor]
    type = HeatConductionMaterial
    thermal_conductivity = ${k_sodium}
    block = ${inter_wrapper_blocks}
  []
[]

[Variables]
  [T_wrapper]
    order = FIRST
    family = LAGRANGE
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = T_wrapper
    block = '${wrapper_blocks} ${inter_wrapper_blocks}'
  []
[]

[BCs]
  [T_wrapper_inside_wall]
    type = MatchedValueBC
    variable = T_wrapper
    boundary = 'prsb_interface_00 prsb_interface_01 prsb_interface_02 prsb_interface_03
                prsb_interface_04 prsb_interface_05 prsb_interface_06 prsb_interface_07
                prsb_interface_08 prsb_interface_09 prsb_interface_10 prsb_interface_11
                prsb_interface_12 prsb_interface_13 prsb_interface_14 prsb_interface_15
                prsb_interface_16 prsb_interface_17 prsb_interface_18'
    v = duct_surface_temperature
  []
  [outside_bc]
    type = NeumannBC
    variable = T_wrapper
    boundary = '10000 inlet_interwrapper outlet_interwrapper'
  []
[]

[AuxVariables]
  [duct_surface_temperature]
    initial_condition = ${inlet_temperature}
  []

  [duct_heat_flux]
    order = CONSTANT
    family = MONOMIAL
    block = ${wrapper_blocks}
    initial_condition = 0
  []
[]

[AuxKernels]
  [HEAT_FLUX]
    type = DiffusionFluxAux
    diffusivity = ${k_wrapper}
    variable = duct_heat_flux
    diffusion_variable = T_wrapper
    component = normal
    boundary = 'prsb_interface_00 prsb_interface_01 prsb_interface_02 prsb_interface_03
                prsb_interface_04 prsb_interface_05 prsb_interface_06 prsb_interface_07
                prsb_interface_08 prsb_interface_09 prsb_interface_10 prsb_interface_11
                prsb_interface_12 prsb_interface_13 prsb_interface_14 prsb_interface_15
                prsb_interface_16 prsb_interface_17 prsb_interface_18'
    execute_on = 'initial timestep_end'
  []
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  fixed_point_max_its = 3
  fixed_point_min_its = 3
  fixed_point_rel_tol = 1e-3
  fixed_point_abs_tol = 1e-3

  [Quadrature]
    order = THIRD
    side_order = FOURTH
  []
[]

[Postprocessors]
  # Total diffusive heat loss through central duct and the rest
  [center_duct_heat_loss_00]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_00
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_01]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_01
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_02]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_02
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_03]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_03
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_04]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_04
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_05]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_05
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_06]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_06
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_07]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_07
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_08]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_08
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_09]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_09
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_10]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_10
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_11]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_11
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_12]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_12
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_13]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_13
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
    [center_duct_heat_loss_14]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_14
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_15]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_15
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_16]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_16
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_17]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_17
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
  [center_duct_heat_loss_18]
    type        = ADSideDiffusiveFluxIntegral
    variable    = T_wrapper
    boundary    = prsb_interface_18
    diffusivity = ${k_wrapper}
    execute_on='timestep_end'
  []
[]

[Outputs]
  exodus = true
  csv = true
  print_linear_residuals = false
[]

################################################################################
######    A multiapp that couples heat conduction to subchannel via duct interface
################################################################################

[MultiApps]
  [subchannel]
    type = FullSolveMultiApp
    input_files = 'fuel_assembly_center.i fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i
    fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i
    fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i
    fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i
    fuel_assembly_1.i fuel_assembly_1.i fuel_assembly_1.i'
    execute_on = 'timestep_end'
    positions = '0          0            0
                 0.140704  -0.0812355    0
                 0.140704   0.0812355    0
                 0          0.162471     0
                -0.140704   0.0812355    0
                -0.140704  -0.0812355    0
                 0         -0.162471     0
                 0.281408  -0.162471     0
                 0.281408   0            0
                 0.281408   0.162471     0
                 0.140704   0.2437065    0
                 0          0.324942     0
                -0.140704   0.2437065    0
                -0.281408   0.162471     0
                -0.281408   0            0
                -0.281408  -0.162471     0
                -0.140704  -0.2437065    0
                 0         -0.324942     0
                 0.140704  -0.2437065    0'
    max_procs_per_app = 1
    output_in_position = true
    bounding_box_padding = '0 0 0.1'
  []
[]

[Transfers]
  [q_duct] # send duct heat flux from heat conduction solve, to SCM
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = subchannel
    source_variable = duct_heat_flux
    variable = duct_heat_flux
    greedy_search = true
    from_boundaries = 'prsb_interface_00 prsb_interface_01 prsb_interface_02 prsb_interface_03
                prsb_interface_04 prsb_interface_05 prsb_interface_06 prsb_interface_07
                prsb_interface_08 prsb_interface_09 prsb_interface_10 prsb_interface_11
                prsb_interface_12 prsb_interface_13 prsb_interface_14 prsb_interface_15
                prsb_interface_16 prsb_interface_17 prsb_interface_18'
    execute_on = 'timestep_end'
    from_postprocessors_to_be_preserved = 'center_duct_heat_loss_00 center_duct_heat_loss_01 center_duct_heat_loss_02 center_duct_heat_loss_03 center_duct_heat_loss_04 center_duct_heat_loss_05 center_duct_heat_loss_06
    center_duct_heat_loss_07 center_duct_heat_loss_08 center_duct_heat_loss_09 center_duct_heat_loss_10 center_duct_heat_loss_11
    center_duct_heat_loss_12 center_duct_heat_loss_13 center_duct_heat_loss_14 center_duct_heat_loss_15 center_duct_heat_loss_16
    center_duct_heat_loss_17 center_duct_heat_loss_18'
    to_postprocessors_to_be_preserved = 'Total_Net_Power_Through_Duct'
    allow_skipped_adjustment = true
  []

  [T_duct] # retrieve Tduct from SCM solve
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = subchannel
    source_variable = Tduct
    variable = duct_surface_temperature
    greedy_search = true
    to_boundaries = 'prsb_interface_00 prsb_interface_01 prsb_interface_02 prsb_interface_03
                prsb_interface_04 prsb_interface_05 prsb_interface_06 prsb_interface_07
                prsb_interface_08 prsb_interface_09 prsb_interface_10 prsb_interface_11
                prsb_interface_12 prsb_interface_13 prsb_interface_14 prsb_interface_15
                prsb_interface_16 prsb_interface_17 prsb_interface_18'
    execute_on = 'timestep_end'
  []
[]
