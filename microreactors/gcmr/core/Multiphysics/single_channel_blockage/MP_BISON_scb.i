################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Single Coolant Channel Blockage          ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

fuel_blocks = '400 4000 40000 401 4001 40001'
# fuel_blocks = 'fuel_in fuel_mid fuel_out fuel_tri_in fuel_tri_mid fuel_tri_out'
# he_channel_blocks = '200 201'
# he_channel_blocks = 'coolant coolant_tri'
mod_blocks = '100 101'
# mod_blocks = 'moderator moderator_tri'
poison_blocks = '19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903'
# poison_blocks = 'bp0_1 bp0_2 bp0_3 bp0_4 bp0_5 bp0_tr_1 bp0_tr_2 bp0_tr_3 bp0_tr_4 bp0_tr_5 bp1_1 bp1_2 bp1_3 bp1_4 bp1_5 bp1_tr_1 bp1_tr_2 bp1_tr_3 bp1_tr_4 bp1_tr_5'
ref_blocks = '1000 1003 250 600 602 1777 1773'
# ref_blocks = 'reflector_quad reflector_tri rad_ref cd_radial1 cd_radial2 control_ref control_ref_tri'
he_void_blocks = '300 301 604'
# he_void_blocks = 'control_hole control_hole_tri cd_coolant'

cd_poison_blocks = '603'
fecral_blocks = '103'
cr_blocks = '102'
small_parts_blocks = '${cd_poison_blocks} ${fecral_blocks} ${cr_blocks}'
monolith_blocks = '10'

non_fuel_blocks = '${mod_blocks} ${poison_blocks} ${ref_blocks} ${he_void_blocks} ${small_parts_blocks} ${monolith_blocks}'

external_bdries = 'top_boundary bottom_boundary side'
# symmetric_bdries = 'cut_surf'
coolant_channel_bdries = 'coolant_channel_surf'

# TsInit = 873.15 # Solid initial temperature
# Tcin = 873.15
# radiusTransfer = 0.015 # r + 0.009. Extends past the first mesh cell surrounding the coolant channel.

coolant_full_points_filename = '../component_positions/cc_positions_sixth.txt'

[Problem]
  restart_file_base = '../steady_state/MP_Griffin_ss_out_bison0_cp_cp/LATEST'
  force_restart = true
[]

[GlobalParams]
  flux_conversion_factor = 1
[]

[Mesh]
  parallel_type = DISTRIBUTED
  file = '../steady_state/MP_Griffin_ss_out_bison0_cp_cp/LATEST'
[]

[Variables]
  [temp]
    # initial_condition = ${TsInit}
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
    type = MatCoupledForce
    variable = temp
    block = ${fuel_blocks}
    v = power_density
    material_properties = power_density_scalar_mat
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_blocks}
    family = L2_LAGRANGE
    order = FIRST
    # initial_condition = 3e6 #W/m^3
  []
  [Tfuel]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
  []
  [hfluid] # Heat Transfer coefficient
    # Calculated by SAM and then transfered with the scaling factor.
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 1000.00
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [power_density_scalar]
    family = SCALAR
    order = FIRST
    # initial_condition = 1.0
  []
  [Tw_trans] # Coolant temperature.
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
[]

[AuxKernels]
  [assign_tfuel_f]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${fuel_blocks}
  []
  [assign_tfuel_nf]
    type = SpatialUserObjectAux
    variable = Tfuel
    user_object = Tf_avg
    execute_on = 'timestep_end'
    block = ${non_fuel_blocks}
  []
  [Tw_trans] # Coolant temperature.
    type = SpatialUserObjectAux
    variable = Tw_trans
    user_object = Tw_UO
    block = 'monolith reflector_quad reflector_tri'
  []
[]

[BCs]
  [coolant_bc]
    type = CoupledConvectiveHeatFluxBC
    T_infinity = Tfluid
    htc = hfluid
    boundary = ${coolant_channel_bdries}
    variable = temp
  []
  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = ${external_bdries}
    coefficient = 0.15 # W/K/m^2
    T_infinity = 300 # K air temperature at the top of the core
  []
[]

[Materials]
  [power_density_scalar_mat]
    type = ParsedMaterial
    property_name = power_density_scalar_mat
    postprocessor_names = power_density_scalar_pp
    expression = power_density_scalar_pp
  []
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${fuel_blocks}
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = 'monolith'
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = ${mod_blocks}
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [YH_liner_Cr_thermal]
    type = ChromiumThermal
    block = 102
    temperature = temp
    outputs = all
  []
  [YH_Cladding_thermal]
    type = FeCrAlThermal
    block = 103
    temperature = temp
    outputs = all
  []
  [Poison_blocks_thermal]
    type = HeatConductionMaterial
    block = ${poison_blocks}
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # random value
  []

  [control_rod_thermal]
    type = HeatConductionMaterial
    block = 603 #B4C
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # random value
  []

  [Reflector_thermal]
    type = BeOThermal
    block = ${ref_blocks}
    fluence_conversion_factor = 1
    temperature = temp
    outputs = all
  []

  [airgap_thermal]
    type = HeatConductionMaterial
    block = ${he_void_blocks} # Helium filled in the control rod hole
    temp = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197 # random value
  []

  [fuel_density]
    type = Density
    block = ${fuel_blocks}
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = ${mod_blocks}
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = 10
    density = 1806
  []
  [YH_Liner_Cr_density]
    type = Density
    block = 102
    density = 7190
  []
  [YH_Cladding_density]
    type = Density
    block = 103
    density = 7250
  []
  [Poison_blocks_density]
    type = Density
    block = ${poison_blocks}
    density = 2510
  []
  [control_rod_density]
    type = Density
    block = 603 #B4C
    density = 2510
  []
  [airgap_density]
    type = Density
    block = ${he_void_blocks} #helium
    density = 180
  []

  [reflector_density]
    type = GenericConstantMaterial
    block = ${ref_blocks}
    prop_names = 'density fast_neutron_fluence porosity'
    prop_values = '3000 0 0'
  []
[]

[UserObjects]
  # UserObject to convert the temperature distribution on the inner coolant
  # surface to a 1D profile.
  [Tw_UO]
    type = NearestPointLayeredSideAverage
    variable = temp
    direction = z
    num_layers = 100
    boundary = ${coolant_channel_bdries}
    execute_on = 'TIMESTEP_END'
    points_file = ${coolant_full_points_filename}
  []
  [Tf_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${fuel_blocks}
  []
[]

[Positions]
  [cc_positions]
    type = FilePositions
    files = ${coolant_full_points_filename}
    outputs = none
  []
[]

[MultiApps]
  [coolant_channel]
    type = TransientMultiApp
    app_type = ThermalHydraulicsApp
    positions_objects = cc_positions
    bounding_box_padding = ' 0.1 0.1 0.1'
    input_files = 'MP_SAM_scb.i'
    execute_on = 'INITIAL TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    cli_args_files = 'cli_args_file.txt'
    sub_cycling = true
  []
[]

[Transfers]
  [Tw_to_coolant]
    # Wall temperature from user object is transferred to fluid domain.
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = coolant_channel
    source_variable = Tw_trans # Exists in solid.
    variable = T_wall # Exists in coolant.
  []
  [Tfluid_from_coolant]
    # Fluid temperature from fluid domain is transferred to solid domain.
    type = MultiAppGeneralFieldNearestLocationTransfer
    assume_nearest_app_holds_nearest_location = true
    from_multi_app = coolant_channel
    source_variable = Tfluid_trans
    variable = Tfluid # Exists in solid.
  []
  [hfluid_from_coolant]
    # Convective HTC from fluid domain is transferred to solid domain.
    type = MultiAppGeneralFieldNearestLocationTransfer
    assume_nearest_app_holds_nearest_location = true
    from_multi_app = coolant_channel
    source_variable = hfluid_trans
    variable = hfluid # Exists in solid.
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = 'none'

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8

  start_time = 0
  end_time = 3000
  dtmax = 1e4
  dtmin = 0.1
  dt = 100
[]

[Postprocessors]
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${mod_blocks}
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${mod_blocks}
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${mod_blocks}
    value_type = min
  []
  [monolith_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = 10
  []
  [monolith_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = 10
  []
  [monolith_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = 10
    value_type = min
  []
  [heatpipe_surface_temp_avg]
    type = SideAverageValue
    variable = temp
    boundary = ${coolant_channel_bdries}
  []
  [power_density]
    type = ElementIntegralVariablePostprocessor
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end transfer'
  []
  [power_density_scalar_pp]
    type = ScalarVariable
    variable = power_density_scalar
    execute_on = 'initial timestep_end'
  []
  [cc_heat]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = ${coolant_channel_bdries}
    diffusivity = thermal_conductivity
  []
  [ext_heat]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'side bottom_boundary top_boundary'
    diffusivity = thermal_conductivity
  []
  [mirror_heat]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'cut_surf'
    diffusivity = thermal_conductivity
  []
  [total_heat]
    type = ParsedPostprocessor
    pp_names = 'mirror_heat ext_heat cc_heat'
    function = 'mirror_heat+ext_heat+cc_heat'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = true
  [exodus]
    type = Exodus
    enable = true
  []
  wall_time_checkpoint = false
[]
