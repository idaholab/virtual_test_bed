################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor TRISO Failure Model                                 ##
## Assembly Model for Calculating TRISO Operating Conditions                  ##
## BISON Child Application for Thermal Physics                                ##
################################################################################

num_sides = 36 # number of sides of heat pipe as a result of mesh polygonization
alpha = '${fparse 2 * pi / num_sides}'
perimeter_correction = '${fparse 0.5 * alpha / sin(0.5 * alpha)}' # polygonization correction factor for perimeter
# area_correction = ${fparse sqrt(alpha / sin(alpha))} # polygonization correction factor for area; this is not needed as mesh was not corrected for this.
area_correction = 1.0 # trivial value for non-corrected mesh
normal_factor = '${fparse perimeter_correction / area_correction}'

fuel_blocks = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08
               fuel_09 fuel_10 fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16
               fuel_17 fuel_18 fuel_19 fuel_20 fuel_21 fuel_22 fuel_23 fuel_24
               fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 fuel_31 fuel_32'

mono_blocks = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
               monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
               monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
               monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32'
hp_facing_blocks = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
                    monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
                    monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
                    monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32
                    top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4'
moderator_blocks = 'mod_01 mod_02 mod_03 mod_04 mod_05 mod_06 mod_07 mod_08
                    mod_09 mod_10 mod_11 mod_12 mod_13 mod_14 mod_15 mod_16
                    mod_17 mod_18 mod_19 mod_20 mod_21 mod_22 mod_23 mod_24
                    mod_25 mod_26 mod_27 mod_28 mod_29 mod_30 mod_31 mod_32'
mod_env_blocks = 'mod_envelope_01 mod_envelope_02 mod_envelope_03 mod_envelope_04 mod_envelope_05 mod_envelope_06 mod_envelope_07 mod_envelope_08
                  mod_envelope_09 mod_envelope_10 mod_envelope_11 mod_envelope_12 mod_envelope_13 mod_envelope_14 mod_envelope_15 mod_envelope_16
                  mod_envelope_17 mod_envelope_18 mod_envelope_19 mod_envelope_20 mod_envelope_21 mod_envelope_22 mod_envelope_23 mod_envelope_24
                  mod_envelope_25 mod_envelope_26 mod_envelope_27 mod_envelope_28 mod_envelope_29 mod_envelope_30 mod_envelope_31 mod_envelope_32'
non_fuel_blocks = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
                   monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
                   monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
                   monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32
                   mod_01 mod_02 mod_03 mod_04 mod_05 mod_06 mod_07 mod_08
                   mod_09 mod_10 mod_11 mod_12 mod_13 mod_14 mod_15 mod_16
                   mod_17 mod_18 mod_19 mod_20 mod_21 mod_22 mod_23 mod_24
                   mod_25 mod_26 mod_27 mod_28 mod_29 mod_30 mod_31 mod_32
                   mod_envelope_01 mod_envelope_02 mod_envelope_03 mod_envelope_04 mod_envelope_05 mod_envelope_06 mod_envelope_07 mod_envelope_08
                   mod_envelope_09 mod_envelope_10 mod_envelope_11 mod_envelope_12 mod_envelope_13 mod_envelope_14 mod_envelope_15 mod_envelope_16
                   mod_envelope_17 mod_envelope_18 mod_envelope_19 mod_envelope_20 mod_envelope_21 mod_envelope_22 mod_envelope_23 mod_envelope_24
                   mod_envelope_25 mod_envelope_26 mod_envelope_27 mod_envelope_28 mod_envelope_29 mod_envelope_30 mod_envelope_31 mod_envelope_32
                   top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
                   bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
non_mod_blocks = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
                  monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
                  monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
                  monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32
                  fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08
                  fuel_09 fuel_10 fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16
                  fuel_17 fuel_18 fuel_19 fuel_20 fuel_21 fuel_22 fuel_23 fuel_24
                  fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 fuel_31 fuel_32
                  mod_envelope_01 mod_envelope_02 mod_envelope_03 mod_envelope_04 mod_envelope_05 mod_envelope_06 mod_envelope_07 mod_envelope_08
                  mod_envelope_09 mod_envelope_10 mod_envelope_11 mod_envelope_12 mod_envelope_13 mod_envelope_14 mod_envelope_15 mod_envelope_16
                  mod_envelope_17 mod_envelope_18 mod_envelope_19 mod_envelope_20 mod_envelope_21 mod_envelope_22 mod_envelope_23 mod_envelope_24
                  mod_envelope_25 mod_envelope_26 mod_envelope_27 mod_envelope_28 mod_envelope_29 mod_envelope_30 mod_envelope_31 mod_envelope_32
                  top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
                  bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
hp_surfs = 'HP_surf'

[GlobalParams]
  flux_conversion_factor = 1
[]

[Mesh]
  file = ../mesh/3D_unit_cell_FY21_simple_YAN_40sections_5cm_axial_dist_bison.e
[]

[Variables]
  [temp]
    initial_condition = 800
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = temp
  []
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = temp
    block = ${fuel_blocks}
    v = power_density
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_blocks}
    family = L2_LAGRANGE
    order = FIRST
    #initial_condition = 4e6 #only used for standalone testing
  []
  [Tfuel]
    # block = ${fuel_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod]
    # block = ${moderator_blocks}
  []
  [hp_temp_aux]
    block = ${hp_facing_blocks}
  []
  [flux_uo] #auxvariable to hold heat pipe surface flux from UserObject
    order = CONSTANT
    family = MONOMIAL
  []
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxKernels]
  [assign_tfuel_in_fuel]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${fuel_blocks}
  []
  [assign_tfuel_in_nonfuel]
    type = SpatialUserObjectAux
    variable = Tfuel
    user_object = avg_fuel_temp
    execute_on = 'timestep_end'
    block = ${non_fuel_blocks}
  []
  [assign_tmod_in_mod]
    type = NormalizationAux
    variable = Tmod
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${moderator_blocks}
  []
  [assign_tmod_in_nonmod]
    type = SpatialUserObjectAux
    variable = Tmod
    user_object = avg_mod_temp
    execute_on = 'timestep_end'
    block = ${non_mod_blocks}
  []
  [flux_uo]
    type = SpatialUserObjectAux
    variable = flux_uo
    user_object = flux_uo
  []
[]

[BCs]
  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = 'top bottom'
    coefficient = 100 # W/K/m^2
    T_infinity = 800 # K air temperature at the top of the core 800
  []
  [hp_temp]
    type = CoupledConvectiveHeatFluxBC
    boundary = ${hp_surfs}
    variable = temp
    T_infinity = hp_temp_aux
    htc = 750 #air gap k=0.15 W/mK, th=0.0002 m
  []
[]

[Materials]
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${fuel_blocks}
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is neutron fluence over 0.1MeV
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${mono_blocks}
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is neutron fluence over 0.1MeV
    temperature = temp
  []
  [normalized_matrix_conductivity]
    type = ParsedMaterial
    expression = 'thermal_conductivity/nf'
    property_name = normalized_matrix_conductivity
    block = ${mono_blocks}
    material_property_names = thermal_conductivity
    constant_names = nf
    constant_expressions = '${normal_factor}'
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = ${moderator_blocks}
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [SS_envelop_pipes_thermal]
    type = HeatConductionMaterial
    block = ${mod_env_blocks}
    thermal_conductivity = 13.8 # W/m/K at 300k
    specific_heat = 482.9 # at 300k
  []
  [axial_reflector_thermal]
    type = HeatConductionMaterial
    block = 'top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
             bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
    temp = temp
    thermal_conductivity = 199 # W/m/K
    specific_heat = 1867 # random value
  []
  [fuel_density]
    type = Density
    block = ${fuel_blocks}
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = ${moderator_blocks}
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = ${mono_blocks}
    density = 1806
  []
  [SS_Envelop_density]
    type = Density
    block = ${mod_env_blocks}
    density = 7950
  []
  [axial_reflector_density]
    type = Density
    block = 'top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
             bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
    density = 1848
  []
[]

[MultiApps]
  [sockeye]
    type = TransientMultiApp
    app_type = SockeyeApp
    positions = '0.0 0.0 0.15' #bottom of the heat pipe
    input_files = 'MP_ss_sockeye.i'
    execute_on = 'timestep_begin' # execute on timestep begin because hard to have a good initial guess on heat flux
    max_procs_per_app = 1
    sub_cycling = true
  []
  [bison_TM]
    type = TransientMultiApp
    app_type = BisonApp
    positions = '0.0 0.0 0.0' #bottom of the heat pipe
    input_files = 'MP_ss_bison_TM.i'
    execute_on = 'timestep_begin'
  []
[]

[Transfers]
  [from_sockeye_temp]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sockeye
    source_variable = hp_temp_aux
    variable = hp_temp_aux
    execute_on = 'timestep_begin'
  []
  [to_sockeye_flux]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sockeye
    source_variable = flux_uo
    variable = master_flux
    execute_on = 'timestep_begin'
  []
  [from_bison_TM_dispx]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_TM
    variable = disp_x
    source_variable = disp_x
    execute_on = 'timestep_begin'
    power = 0
    num_points = 1
  []
  [from_bison_TM_dispy]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_TM
    variable = disp_y
    source_variable = disp_y
    execute_on = 'timestep_begin'
    power = 0
    num_points = 1
  []
  [from_bison_TM_dispz]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_TM
    variable = disp_z
    source_variable = disp_z
    execute_on = 'timestep_begin'
    power = 0
    num_points = 1
  []
  [to_bison_TM_temp]
    type = MultiAppGeometricInterpolationTransfer
    to_multi_app = bison_TM
    variable = temp
    source_variable = temp
    execute_on = 'timestep_begin'
    power = 0
    num_points = 1
  []
  [axial_pressure_1]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_1
    to_postprocessor = axial_pressure_1
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_2]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_2
    to_postprocessor = axial_pressure_2
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_3]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_3
    to_postprocessor = axial_pressure_3
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_4]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_4
    to_postprocessor = axial_pressure_4
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_5]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_5
    to_postprocessor = axial_pressure_5
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_6]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_6
    to_postprocessor = axial_pressure_6
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_7]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_7
    to_postprocessor = axial_pressure_7
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_8]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_8
    to_postprocessor = axial_pressure_8
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_9]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_9
    to_postprocessor = axial_pressure_9
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_10]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_10
    to_postprocessor = axial_pressure_10
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_11]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_11
    to_postprocessor = axial_pressure_11
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_12]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_12
    to_postprocessor = axial_pressure_12
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_13]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_13
    to_postprocessor = axial_pressure_13
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_14]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_14
    to_postprocessor = axial_pressure_14
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_15]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_15
    to_postprocessor = axial_pressure_15
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_16]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_16
    to_postprocessor = axial_pressure_16
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_17]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_17
    to_postprocessor = axial_pressure_17
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_18]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_18
    to_postprocessor = axial_pressure_18
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_19]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_19
    to_postprocessor = axial_pressure_19
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_20]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_20
    to_postprocessor = axial_pressure_20
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_21]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_21
    to_postprocessor = axial_pressure_21
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_22]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_22
    to_postprocessor = axial_pressure_22
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_23]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_23
    to_postprocessor = axial_pressure_23
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_24]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_24
    to_postprocessor = axial_pressure_24
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_25]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_25
    to_postprocessor = axial_pressure_25
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_26]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_26
    to_postprocessor = axial_pressure_26
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_27]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_27
    to_postprocessor = axial_pressure_27
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_28]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_28
    to_postprocessor = axial_pressure_28
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_29]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_29
    to_postprocessor = axial_pressure_29
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_30]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_30
    to_postprocessor = axial_pressure_30
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_31]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_31
    to_postprocessor = axial_pressure_31
    execute_on = 'initial timestep_begin'
  []
  [axial_pressure_32]
    type = MultiAppPostprocessorTransfer
    reduction_type = average
    from_multi_app = bison_TM
    from_postprocessor = axial_pressure_32
    to_postprocessor = axial_pressure_32
    execute_on = 'initial timestep_begin'
  []
[]

[UserObjects]
  [flux_uo]
    type = LayeredSideDiffusiveFluxAverage
    direction = z
    num_layers = 100
    variable = temp
    diffusivity = normalized_matrix_conductivity
    execute_on = linear
    boundary = ${hp_surfs}
  []
  [avg_fuel_temp]
    type = LayeredAverage
    direction = z
    num_layers = 100
    variable = temp
    block = ${fuel_blocks}
  []
  [avg_mod_temp]
    type = LayeredAverage
    direction = z
    num_layers = 100
    variable = temp
    block = ${moderator_blocks}
  []
[]

[Executioner]
  type = Transient

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-7

  nl_max_its = 20
  fixed_point_max_its = 1

  start_time = 0
  end_time = '${fparse 10 * 365.25 * 24 * 3600}'
  dtmin = 1e-6
  dt = 1e7
[]

[Postprocessors]
  [hp_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = ${hp_surfs}
    diffusivity = normalized_matrix_conductivity
    execute_on = 'initial timestep_end'
    outputs = none
  []
  [topbottom_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'top bottom'
    diffusivity = 199 #TC of reflector
    execute_on = 'initial timestep_end'
    outputs = none
  []
  [total_heat_integral]
    type = LinearCombinationPostprocessor
    pp_names = 'hp_heat_integral topbottom_heat_integral'
    pp_coefs = '1 1'
    outputs = none
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${fuel_blocks}
    outputs = none
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
    outputs = none
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
    value_type = min
    outputs = none
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${moderator_blocks}
    outputs = none
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${moderator_blocks}
    outputs = none
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${moderator_blocks}
    value_type = min
    outputs = none
  []
  [monolith_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${mono_blocks}
    outputs = none
  []
  [monolith_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${mono_blocks}
    outputs = none
  []
  [monolith_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${mono_blocks}
    value_type = min
    outputs = none
  []
  [heatpipe_surface_temp_avg]
    type = SideAverageValue
    variable = temp
    boundary = ${hp_surfs}
    outputs = none
  []
  [power_density]
    type = ElementIntegralVariablePostprocessor
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end'
    outputs = none
  []
  [axial_temp_1]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_01
    outputs = 'pp_fuelsampler_temp_1'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_1]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_01
    outputs = 'pp_fuelsampler_pow_1'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_2]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_02
    outputs = 'pp_fuelsampler_temp_2'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_2]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_02
    outputs = 'pp_fuelsampler_pow_2'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_3]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_03
    outputs = 'pp_fuelsampler_temp_3'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_3]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_03
    outputs = 'pp_fuelsampler_pow_3'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_4]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_04
    outputs = 'pp_fuelsampler_temp_4'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_4]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_04
    outputs = 'pp_fuelsampler_pow_4'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_5]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_05
    outputs = 'pp_fuelsampler_temp_5'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_5]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_05
    outputs = 'pp_fuelsampler_pow_5'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_6]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_06
    outputs = 'pp_fuelsampler_temp_6'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_6]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_06
    outputs = 'pp_fuelsampler_pow_6'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_7]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_07
    outputs = 'pp_fuelsampler_temp_7'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_7]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_07
    outputs = 'pp_fuelsampler_pow_7'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_8]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_08
    outputs = 'pp_fuelsampler_temp_8'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_8]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_08
    outputs = 'pp_fuelsampler_pow_8'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_9]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_09
    outputs = 'pp_fuelsampler_temp_9'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_9]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_09
    outputs = 'pp_fuelsampler_pow_9'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_10]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_10
    outputs = 'pp_fuelsampler_temp_10'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_10]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_10
    outputs = 'pp_fuelsampler_pow_10'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_11]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_11
    outputs = 'pp_fuelsampler_temp_11'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_11]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_11
    outputs = 'pp_fuelsampler_pow_11'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_12]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_12
    outputs = 'pp_fuelsampler_temp_12'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_12]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_12
    outputs = 'pp_fuelsampler_pow_12'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_13]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_13
    outputs = 'pp_fuelsampler_temp_13'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_13]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_13
    outputs = 'pp_fuelsampler_pow_13'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_14]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_14
    outputs = 'pp_fuelsampler_temp_14'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_14]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_14
    outputs = 'pp_fuelsampler_pow_14'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_15]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_15
    outputs = 'pp_fuelsampler_temp_15'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_15]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_15
    outputs = 'pp_fuelsampler_pow_15'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_16]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_16
    outputs = 'pp_fuelsampler_temp_16'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_16]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_16
    outputs = 'pp_fuelsampler_pow_16'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_17]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_17
    outputs = 'pp_fuelsampler_temp_17'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_17]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_17
    outputs = 'pp_fuelsampler_pow_17'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_18]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_18
    outputs = 'pp_fuelsampler_temp_18'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_18]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_18
    outputs = 'pp_fuelsampler_pow_18'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_19]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_19
    outputs = 'pp_fuelsampler_temp_19'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_19]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_19
    outputs = 'pp_fuelsampler_pow_19'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_20]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_20
    outputs = 'pp_fuelsampler_temp_20'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_20]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_20
    outputs = 'pp_fuelsampler_pow_20'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_21]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_21
    outputs = 'pp_fuelsampler_temp_21'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_21]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_21
    outputs = 'pp_fuelsampler_pow_21'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_22]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_22
    outputs = 'pp_fuelsampler_temp_22'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_22]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_22
    outputs = 'pp_fuelsampler_pow_22'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_23]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_23
    outputs = 'pp_fuelsampler_temp_23'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_23]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_23
    outputs = 'pp_fuelsampler_pow_23'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_24]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_24
    outputs = 'pp_fuelsampler_temp_24'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_24]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_24
    outputs = 'pp_fuelsampler_pow_24'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_25]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_25
    outputs = 'pp_fuelsampler_temp_25'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_25]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_25
    outputs = 'pp_fuelsampler_pow_25'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_26]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_26
    outputs = 'pp_fuelsampler_temp_26'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_26]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_26
    outputs = 'pp_fuelsampler_pow_26'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_27]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_27
    outputs = 'pp_fuelsampler_temp_27'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_27]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_27
    outputs = 'pp_fuelsampler_pow_27'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_28]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_28
    outputs = 'pp_fuelsampler_temp_28'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_28]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_28
    outputs = 'pp_fuelsampler_pow_28'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_29]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_29
    outputs = 'pp_fuelsampler_temp_29'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_29]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_29
    outputs = 'pp_fuelsampler_pow_29'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_30]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_30
    outputs = 'pp_fuelsampler_temp_30'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_30]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_30
    outputs = 'pp_fuelsampler_pow_30'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_31]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_31
    outputs = 'pp_fuelsampler_temp_31'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_31]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_31
    outputs = 'pp_fuelsampler_pow_31'
    execute_on = 'initial timestep_end'
  []
  [axial_temp_32]
    type = ElementAverageValue
    variable = 'Tfuel'
    block = fuel_32
    outputs = 'pp_fuelsampler_temp_32'
    execute_on = 'initial timestep_end'
  []
  [axial_pow_32]
    type = ElementAverageValue
    variable = 'power_density'
    block = fuel_32
    outputs = 'pp_fuelsampler_pow_32'
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_1]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_1'
  []
  [axial_pressure_2]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_2'
  []
  [axial_pressure_3]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_3'
  []
  [axial_pressure_4]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_4'
  []
  [axial_pressure_5]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_5'
  []
  [axial_pressure_6]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_6'
  []
  [axial_pressure_7]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_7'
  []
  [axial_pressure_8]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_8'
  []
  [axial_pressure_9]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_9'
  []
  [axial_pressure_10]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_10'
  []
  [axial_pressure_11]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_11'
  []
  [axial_pressure_12]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_12'
  []
  [axial_pressure_13]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_13'
  []
  [axial_pressure_14]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_14'
  []
  [axial_pressure_15]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_15'
  []
  [axial_pressure_16]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_16'
  []
  [axial_pressure_17]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_17'
  []
  [axial_pressure_18]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_18'
  []
  [axial_pressure_19]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_19'
  []
  [axial_pressure_20]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_20'
  []
  [axial_pressure_21]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_21'
  []
  [axial_pressure_22]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_22'
  []
  [axial_pressure_23]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_23'
  []
  [axial_pressure_24]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_24'
  []
  [axial_pressure_25]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_25'
  []
  [axial_pressure_26]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_26'
  []
  [axial_pressure_27]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_27'
  []
  [axial_pressure_28]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_28'
  []
  [axial_pressure_29]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_29'
  []
  [axial_pressure_30]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_30'
  []
  [axial_pressure_31]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_31'
  []
  [axial_pressure_32]
    type = Receiver
    outputs = 'pp_fuelsampler_pressure_32'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  # checkpoint = true
  # exodus = true
  # csv=false
  [pp_fuelsampler_temp_1]
    type = CSV
    file_base = 'fuelsample/tempdata1'
  []
  [pp_fuelsampler_pow_1]
    type = CSV
    file_base = 'fuelsample/powdata1'
  []
  [pp_fuelsampler_temp_2]
    type = CSV
    file_base = 'fuelsample/tempdata2'
  []
  [pp_fuelsampler_pow_2]
    type = CSV
    file_base = 'fuelsample/powdata2'
  []
  [pp_fuelsampler_temp_3]
    type = CSV
    file_base = 'fuelsample/tempdata3'
  []
  [pp_fuelsampler_pow_3]
    type = CSV
    file_base = 'fuelsample/powdata3'
  []
  [pp_fuelsampler_temp_4]
    type = CSV
    file_base = 'fuelsample/tempdata4'
  []
  [pp_fuelsampler_pow_4]
    type = CSV
    file_base = 'fuelsample/powdata4'
  []
  [pp_fuelsampler_temp_5]
    type = CSV
    file_base = 'fuelsample/tempdata5'
  []
  [pp_fuelsampler_pow_5]
    type = CSV
    file_base = 'fuelsample/powdata5'
  []
  [pp_fuelsampler_temp_6]
    type = CSV
    file_base = 'fuelsample/tempdata6'
  []
  [pp_fuelsampler_pow_6]
    type = CSV
    file_base = 'fuelsample/powdata6'
  []
  [pp_fuelsampler_temp_7]
    type = CSV
    file_base = 'fuelsample/tempdata7'
  []
  [pp_fuelsampler_pow_7]
    type = CSV
    file_base = 'fuelsample/powdata7'
  []
  [pp_fuelsampler_temp_8]
    type = CSV
    file_base = 'fuelsample/tempdata8'
  []
  [pp_fuelsampler_pow_8]
    type = CSV
    file_base = 'fuelsample/powdata8'
  []
  [pp_fuelsampler_temp_9]
    type = CSV
    file_base = 'fuelsample/tempdata9'
  []
  [pp_fuelsampler_pow_9]
    type = CSV
    file_base = 'fuelsample/powdata9'
  []
  [pp_fuelsampler_temp_10]
    type = CSV
    file_base = 'fuelsample/tempdata10'
  []
  [pp_fuelsampler_pow_10]
    type = CSV
    file_base = 'fuelsample/powdata10'
  []
  [pp_fuelsampler_temp_11]
    type = CSV
    file_base = 'fuelsample/tempdata11'
  []
  [pp_fuelsampler_pow_11]
    type = CSV
    file_base = 'fuelsample/powdata11'
  []
  [pp_fuelsampler_temp_12]
    type = CSV
    file_base = 'fuelsample/tempdata12'
  []
  [pp_fuelsampler_pow_12]
    type = CSV
    file_base = 'fuelsample/powdata12'
  []
  [pp_fuelsampler_temp_13]
    type = CSV
    file_base = 'fuelsample/tempdata13'
  []
  [pp_fuelsampler_pow_13]
    type = CSV
    file_base = 'fuelsample/powdata13'
  []
  [pp_fuelsampler_temp_14]
    type = CSV
    file_base = 'fuelsample/tempdata14'
  []
  [pp_fuelsampler_pow_14]
    type = CSV
    file_base = 'fuelsample/powdata14'
  []
  [pp_fuelsampler_temp_15]
    type = CSV
    file_base = 'fuelsample/tempdata15'
  []
  [pp_fuelsampler_pow_15]
    type = CSV
    file_base = 'fuelsample/powdata15'
  []
  [pp_fuelsampler_temp_16]
    type = CSV
    file_base = 'fuelsample/tempdata16'
  []
  [pp_fuelsampler_pow_16]
    type = CSV
    file_base = 'fuelsample/powdata16'
  []
  [pp_fuelsampler_temp_17]
    type = CSV
    file_base = 'fuelsample/tempdata17'
  []
  [pp_fuelsampler_pow_17]
    type = CSV
    file_base = 'fuelsample/powdata17'
  []
  [pp_fuelsampler_temp_18]
    type = CSV
    file_base = 'fuelsample/tempdata18'
  []
  [pp_fuelsampler_pow_18]
    type = CSV
    file_base = 'fuelsample/powdata18'
  []
  [pp_fuelsampler_temp_19]
    type = CSV
    file_base = 'fuelsample/tempdata19'
  []
  [pp_fuelsampler_pow_19]
    type = CSV
    file_base = 'fuelsample/powdata19'
  []
  [pp_fuelsampler_temp_20]
    type = CSV
    file_base = 'fuelsample/tempdata20'
  []
  [pp_fuelsampler_pow_20]
    type = CSV
    file_base = 'fuelsample/powdata20'
  []
  [pp_fuelsampler_temp_21]
    type = CSV
    file_base = 'fuelsample/tempdata21'
  []
  [pp_fuelsampler_pow_21]
    type = CSV
    file_base = 'fuelsample/powdata21'
  []
  [pp_fuelsampler_temp_22]
    type = CSV
    file_base = 'fuelsample/tempdata22'
  []
  [pp_fuelsampler_pow_22]
    type = CSV
    file_base = 'fuelsample/powdata22'
  []
  [pp_fuelsampler_temp_23]
    type = CSV
    file_base = 'fuelsample/tempdata23'
  []
  [pp_fuelsampler_pow_23]
    type = CSV
    file_base = 'fuelsample/powdata23'
  []
  [pp_fuelsampler_temp_24]
    type = CSV
    file_base = 'fuelsample/tempdata24'
  []
  [pp_fuelsampler_pow_24]
    type = CSV
    file_base = 'fuelsample/powdata24'
  []
  [pp_fuelsampler_temp_25]
    type = CSV
    file_base = 'fuelsample/tempdata25'
  []
  [pp_fuelsampler_pow_25]
    type = CSV
    file_base = 'fuelsample/powdata25'
  []
  [pp_fuelsampler_temp_26]
    type = CSV
    file_base = 'fuelsample/tempdata26'
  []
  [pp_fuelsampler_pow_26]
    type = CSV
    file_base = 'fuelsample/powdata26'
  []
  [pp_fuelsampler_temp_27]
    type = CSV
    file_base = 'fuelsample/tempdata27'
  []
  [pp_fuelsampler_pow_27]
    type = CSV
    file_base = 'fuelsample/powdata27'
  []
  [pp_fuelsampler_temp_28]
    type = CSV
    file_base = 'fuelsample/tempdata28'
  []
  [pp_fuelsampler_pow_28]
    type = CSV
    file_base = 'fuelsample/powdata28'
  []
  [pp_fuelsampler_temp_29]
    type = CSV
    file_base = 'fuelsample/tempdata29'
  []
  [pp_fuelsampler_pow_29]
    type = CSV
    file_base = 'fuelsample/powdata29'
  []
  [pp_fuelsampler_temp_30]
    type = CSV
    file_base = 'fuelsample/tempdata30'
  []
  [pp_fuelsampler_pow_30]
    type = CSV
    file_base = 'fuelsample/powdata30'
  []
  [pp_fuelsampler_temp_31]
    type = CSV
    file_base = 'fuelsample/tempdata31'
  []
  [pp_fuelsampler_pow_31]
    type = CSV
    file_base = 'fuelsample/powdata31'
  []
  [pp_fuelsampler_temp_32]
    type = CSV
    file_base = 'fuelsample/tempdata32'
  []
  [pp_fuelsampler_pow_32]
    type = CSV
    file_base = 'fuelsample/powdata32'
  []
  [pp_fuelsampler_pressure_1]
    type = CSV
    file_base = 'fuelsample/pressuredata1'
  []
  [pp_fuelsampler_pressure_2]
    type = CSV
    file_base = 'fuelsample/pressuredata2'
  []
  [pp_fuelsampler_pressure_3]
    type = CSV
    file_base = 'fuelsample/pressuredata3'
  []
  [pp_fuelsampler_pressure_4]
    type = CSV
    file_base = 'fuelsample/pressuredata4'
  []
  [pp_fuelsampler_pressure_5]
    type = CSV
    file_base = 'fuelsample/pressuredata5'
  []
  [pp_fuelsampler_pressure_6]
    type = CSV
    file_base = 'fuelsample/pressuredata6'
  []
  [pp_fuelsampler_pressure_7]
    type = CSV
    file_base = 'fuelsample/pressuredata7'
  []
  [pp_fuelsampler_pressure_8]
    type = CSV
    file_base = 'fuelsample/pressuredata8'
  []
  [pp_fuelsampler_pressure_9]
    type = CSV
    file_base = 'fuelsample/pressuredata9'
  []
  [pp_fuelsampler_pressure_10]
    type = CSV
    file_base = 'fuelsample/pressuredata10'
  []
  [pp_fuelsampler_pressure_11]
    type = CSV
    file_base = 'fuelsample/pressuredata11'
  []
  [pp_fuelsampler_pressure_12]
    type = CSV
    file_base = 'fuelsample/pressuredata12'
  []
  [pp_fuelsampler_pressure_13]
    type = CSV
    file_base = 'fuelsample/pressuredata13'
  []
  [pp_fuelsampler_pressure_14]
    type = CSV
    file_base = 'fuelsample/pressuredata14'
  []
  [pp_fuelsampler_pressure_15]
    type = CSV
    file_base = 'fuelsample/pressuredata15'
  []
  [pp_fuelsampler_pressure_16]
    type = CSV
    file_base = 'fuelsample/pressuredata16'
  []
  [pp_fuelsampler_pressure_17]
    type = CSV
    file_base = 'fuelsample/pressuredata17'
  []
  [pp_fuelsampler_pressure_18]
    type = CSV
    file_base = 'fuelsample/pressuredata18'
  []
  [pp_fuelsampler_pressure_19]
    type = CSV
    file_base = 'fuelsample/pressuredata19'
  []
  [pp_fuelsampler_pressure_20]
    type = CSV
    file_base = 'fuelsample/pressuredata20'
  []
  [pp_fuelsampler_pressure_21]
    type = CSV
    file_base = 'fuelsample/pressuredata21'
  []
  [pp_fuelsampler_pressure_22]
    type = CSV
    file_base = 'fuelsample/pressuredata22'
  []
  [pp_fuelsampler_pressure_23]
    type = CSV
    file_base = 'fuelsample/pressuredata23'
  []
  [pp_fuelsampler_pressure_24]
    type = CSV
    file_base = 'fuelsample/pressuredata24'
  []
  [pp_fuelsampler_pressure_25]
    type = CSV
    file_base = 'fuelsample/pressuredata25'
  []
  [pp_fuelsampler_pressure_26]
    type = CSV
    file_base = 'fuelsample/pressuredata26'
  []
  [pp_fuelsampler_pressure_27]
    type = CSV
    file_base = 'fuelsample/pressuredata27'
  []
  [pp_fuelsampler_pressure_28]
    type = CSV
    file_base = 'fuelsample/pressuredata28'
  []
  [pp_fuelsampler_pressure_29]
    type = CSV
    file_base = 'fuelsample/pressuredata29'
  []
  [pp_fuelsampler_pressure_30]
    type = CSV
    file_base = 'fuelsample/pressuredata30'
  []
  [pp_fuelsampler_pressure_31]
    type = CSV
    file_base = 'fuelsample/pressuredata31'
  []
  [pp_fuelsampler_pressure_32]
    type = CSV
    file_base = 'fuelsample/pressuredata32'
  []
[]
