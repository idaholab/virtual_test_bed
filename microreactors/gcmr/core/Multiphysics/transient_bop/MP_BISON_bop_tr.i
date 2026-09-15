################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Transient                                ##
## Balance of Plant (BOP) Loop Coupling                                       ##
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
non_yh_blocks = '${fuel_blocks} ${poison_blocks} ${ref_blocks} ${he_void_blocks} ${small_parts_blocks} ${monolith_blocks}'

external_bdries = 'top_boundary bottom_boundary side'
# symmetric_bdries = 'cut_surf'
coolant_channel_bdries = 'coolant_channel_surf'

TsInit = 400 # 873.15 # Solid initial temperature
Tcin = 400 # 873.15
# radiusTransfer = 0.015 # r + 0.009. Extends past the first mesh cell surrounding the coolant channel.

coolant_full_points_filename = '../component_positions/cc_positions_sixth.txt'
mod_points_filename = '../component_positions/mod_positions_sixth.txt'

start_time = -2e5

[Problem]
  restart_file_base = '../steady_state_bop/MP_Griffin_bop_ss_out_bison0_cp_cp/LATEST'
  # force_restart = true
[]

[GlobalParams]
  flux_conversion_factor = 1
[]

[Mesh]
  parallel_type = DISTRIBUTED
  file = '../steady_state_bop/MP_Griffin_bop_ss_out_bison0_cp_cp/LATEST'
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
  # For SS we may turn this off to achieve faster equilibrium
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
    family = L2_LAGRANGE # transfer to FIRST L2_LAGRANGE gives a weird integrated power...
    order = FIRST
    # initial_condition = 3e6 #W/m3
  []
  ##
  [Tfuel]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
  []
  [stoich_griffin]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 1.94
  []
  [hfluid] # Heat Transfer coefficient
    # Calculated by SAM and then transfered with the scaling factor.
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 1000.00
    block = '1000 1003 monolith'
    # block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
    block = '1000 1003 monolith'
    # block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
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
  [Tm_trans]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = ${Tcin}
    block = ${mod_blocks}
  []
  [stoich]
    order = CONSTANT
    family = MONOMIAL
    block = ${mod_blocks}
    # initial_condition = 1.94
  []

  [cc_flux_aux]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 0
    block = '1000 1003 monolith'
  []
  [heating_density]
    # initial_condition = 0
    family = MONOMIAL
    order = CONSTANT
    block = '1000 1003 monolith'
  []
[]

[AuxScalarKernels]
  [power_scale]
    type = FunctionScalarAux
    variable = power_density_scalar
    function = 'if((t-${start_time})<=0,0,if((t-${start_time})>3600,1.0,(t-${start_time})/3600))'
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
  [assign_stoich_g_yh]
    type = NormalizationAux
    variable = stoich_griffin
    source_variable = stoich
    execute_on = 'timestep_end'
    block = ${mod_blocks}
  []
  [assign_stoich_g_nyh]
    type = SpatialUserObjectAux
    variable = stoich_griffin
    user_object = stoich_avg
    execute_on = 'timestep_end'
    block = ${non_yh_blocks}
  []
  [Tw_trans] # Coolant temperature.
    type = SpatialUserObjectAux
    variable = Tw_trans
    user_object = Tw_UO
    block = 'monolith reflector_quad reflector_tri'
  []
  [Tm_trans]
    type = SpatialUserObjectAux
    variable = Tm_trans
    user_object = Tm_UO
    block = ${mod_blocks}
  []
  ##
  [cc_flux_aux]
    type = SpatialUserObjectAux
    variable = cc_flux_aux
    user_object = cc_flux
    block = '1000 1003 monolith'
  []
  [hd]
    type = NormalizationAux
    variable = heating_density
    source_variable = cc_flux_aux
    # converting factor flux*(2*pi*r)/(pi*r*r) = 2/r
    # for linear case, r_corr = 0.00613996, we may use r_corr * sin(2pi/12/2)*2*12/(pi*r*r) = 337.226 compared to 333.33
    normal_factor = 337.226 # ${fparse 2.0/0.006}
    block = '1000 1003 monolith'
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
  # #we can assume perfect insulation for simplicity for now
  # [outside_bc]
  #   type = ConvectiveFluxFunction # (Robin BC)
  #   variable = temp
  #   boundary = ${external_bdries}
  #   coefficient = 0.15 # W/K/m^2
  #   T_infinity = 300 # K air temperature at the top of the core
  # []
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
    thermal_conductivity = 5 #0.15 # W/m/K
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
    density = 1000 #180
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
  [Tm_UO]
    type = NearestPointLayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${mod_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
    points_file = ${mod_points_filename}
  []

  [Tf_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${fuel_blocks}
  []
  [stoich_avg]
    type = LayeredAverage
    variable = stoich
    direction = z
    num_layers = 100
    block = ${mod_blocks}
  []

  [cc_flux]
    type = LayeredSideDiffusiveFluxAverage
    direction = z
    diffusivity = thermal_conductivity
    num_layers = 100
    variable = temp
    execute_on = 'INITIAL TIMESTEP_END'
    boundary = ${coolant_channel_bdries}
  []
[]

[Positions]
  [cc_positions]
    type = FilePositions
    files = ${coolant_full_points_filename}
    outputs = none
  []
  [mod_positions]
    type = FilePositions
    files = ${mod_points_filename}
    outputs = none
  []
[]

[MultiApps]
  [htgr]
    type = TransientMultiApp
    app_type = ThermalHydraulicsApp
    input_files = 'MP_THM_loop_bop_tr.i'
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    sub_cycling = true
    max_failures = 1e6
    # make sure the line is within the blocks
    positions = '-0.007 0 -0.1'
  []
  [coolant_full_MA]
    type = TransientMultiApp
    app_type = ThermalHydraulicsApp
    positions_objects = cc_positions
    bounding_box_padding = ' 0.1 0.1 0.1'
    input_files = 'MP_SAM_bop_tr.i'
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    cli_args = AuxKernels/scale_htc/function='0.997090723*htc'
    # cli_args: this is a conversion to help with the energy balance.
    sub_cycling = true
    max_failures = 1e6
  []
[]

[Transfers]
  # To loop
  [hd]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = htgr
    source_variable = heating_density
    variable = heating_density
    from_blocks = '1000 1003 monolith'
    to_blocks = 'core/coolant_channel'
    error_on_miss = false
  []
  # from loop
  [core_in_T]
    type = MultiAppPostprocessorTransfer
    from_multi_app = htgr
    from_postprocessor = core_T_in
    to_postprocessor = core_in_T
    reduction_type = average
  []
  [core_out_P]
    type = MultiAppPostprocessorTransfer
    from_multi_app = htgr
    from_postprocessor = core_p_out
    to_postprocessor = core_out_P
    reduction_type = average
  []
  [core_in_vel]
    type = MultiAppPostprocessorTransfer
    from_multi_app = htgr
    from_postprocessor = core_v_in
    to_postprocessor = core_in_vel
    reduction_type = average
  []

  [send_core_in_T]
    type = MultiAppPostprocessorTransfer
    to_multi_app = coolant_full_MA
    from_postprocessor = core_in_T
    to_postprocessor = core_in_T
  []
  [send_core_out_P]
      type = MultiAppPostprocessorTransfer
      to_multi_app = coolant_full_MA
      from_postprocessor = core_out_P
      to_postprocessor = core_out_P
  []
  [send_core_in_vel]
      type = MultiAppPostprocessorTransfer
      to_multi_app = coolant_full_MA
      from_postprocessor = core_in_vel
      to_postprocessor = core_in_vel
  []

  # coolant_full
  [Tw_to_coolant]
    # Wall temperature from user object is transferred to fluid domain.
    type = MultiAppNearestNodeTransfer
    to_multi_app = coolant_full_MA
    source_variable = Tw_trans # Exists in solid.
    variable = T_wall # Exists in coolant.
    # execute_on = 'TIMESTEP_END'
    fixed_meshes = true
  []
  [Tfluid_from_coolant]
    # Fluid temperature from fluid domain is transferred to solid domain.
    type = MultiAppNearestNodeTransfer
    from_multi_app = coolant_full_MA
    source_variable = Tfluid_trans
    variable = Tfluid # Exists in solid.
    # execute_on = 'TIMESTEP_END'
    fixed_meshes = true
  []
  [hfluid_from_coolant]
    # Convective HTC from fluid domain is transferred to solid domain.
    type = MultiAppNearestNodeTransfer
    from_multi_app = coolant_full_MA
    source_variable = hfluid_trans
    variable = hfluid # Exists in solid.
    # execute_on = 'TIMESTEP_END'
    fixed_meshes = true
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

  solve_type = 'PJFNK'
  # petsc_options = '-snes_ksp_ew'
  # petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  # petsc_options_value = 'lu       superlu_dist                  101' #51

  line_search = 'none'

  l_max_its = 25
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-8
  nl_max_its = 30

  start_time = 0 #${start_time}
  end_time = 10000
  dtmax = 2 # 5
  dtmin = 1e-6

  # Fixed point might not be needed for ss simulation
  # fixed_point_max_its = 5
  # accept_on_max_fixed_point_iteration = true
  # fixed_point_rel_tol = 5e-8
  # fixed_point_abs_tol = 5e-8

  automatic_scaling = true
  compute_scaling_once = false

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    growth_factor = 2.0
    cutback_factor = 0.8
    cutback_factor_at_failure = 0.8
    optimal_iterations = 15
    timestep_limiting_postprocessor = dt_limit
  []
[]

[Postprocessors]
  [_t]
    type = TimePostprocessor
    outputs = 'none'
  []
  [dt_limit]
    type = ParsedPostprocessor
    expression = 'delt:=_t-t0;if(delt<3600,10,if(delt<10800,100,1000))'
    pp_names = '_t'
    constant_names = 't0'
    constant_expressions = '${start_time}'
  []
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
    expression = 'mirror_heat+ext_heat+cc_heat'
  []

  # from loop
  [core_in_vel]
    type = Receiver
    default = 0
  []
  [core_in_T]
    type = Receiver
    default = 400
  []
  [core_out_P]
    type = Receiver
    default = 7e6
  []

  # flux/density
  [avg_cc_flux]
    type = SideAverageValue
    variable = cc_flux_aux
    boundary = ${coolant_channel_bdries}
  []
  [int_cc_flux]
    type =  SideIntegralVariablePostprocessor
    variable = cc_flux_aux
    boundary = ${coolant_channel_bdries}
  []
  [avg_hd]
    type = ElementAverageValue
    variable = heating_density
    block = '1000 1003 monolith'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = true
  [console]
    type = Console
    verbose = true
  []
  [exodus]
    type = Exodus
    execute_on = 'FINAL'
    # simulation_time_interval = 60
    # enable = false
  []
  [cp]
    type = Checkpoint
    additional_execute_on = 'FINAL'
    enable = false
  []
[]
