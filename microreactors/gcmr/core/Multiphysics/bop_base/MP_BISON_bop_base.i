################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State and Transient               ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
## Common base for the steady state and transient inputs                      ##
################################################################################

!include ../common/MP_BISON_base.i

TsInit = 400 # 873.15 # Solid initial temperature
Tcin = 400 # 873.15

mod_points_filename = '../component_positions/mod_positions_sixth.txt'

start_time = -2e5

[AuxVariables]
  [stoich_griffin]
    order = CONSTANT
    family = MONOMIAL
  []
  [hfluid] # Heat Transfer coefficient
    block = '1000 1003 monolith'
    # block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    block = '1000 1003 monolith'
    # block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tm_trans]
    order = CONSTANT
    family = MONOMIAL
    block = ${mod_blocks}
  []
  [stoich]
    order = CONSTANT
    family = MONOMIAL
    block = ${mod_blocks}
  []

  [cc_flux_aux]
    order = CONSTANT
    family = MONOMIAL
    block = '1000 1003 monolith'
  []
  [heating_density]
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
    # all blocks except the yttrium hydride moderator
    block = '${fuel_blocks} ${poison_blocks} ${ref_blocks} ${he_void_blocks} ${small_parts_blocks} ${monolith_blocks}'
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

[UserObjects]
  [Tm_UO]
    type = NearestPointLayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${mod_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
    points_file = ${mod_points_filename}
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
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    cli_args = AuxKernels/scale_htc/expression='0.997090723*htc'
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
    to_multi_app = coolant_full_MA
  []
  [Tfluid_from_coolant]
    from_multi_app = coolant_full_MA
  []
  [hfluid_from_coolant]
    from_multi_app = coolant_full_MA
  []
[]

[Executioner]
  solve_type = 'PJFNK'

  l_max_its = 25
  nl_abs_tol = 1e-5
  nl_max_its = 30

  dtmin = 1e-6

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
  csv = true
  [console]
    type = Console
    verbose = true
  []
  [exodus]
    execute_on = 'FINAL'
    # simulation_time_interval = 60
    # enable = false
  []
  [cp]
    type = Checkpoint
    additional_execute_on = 'FINAL'
  []
[]
