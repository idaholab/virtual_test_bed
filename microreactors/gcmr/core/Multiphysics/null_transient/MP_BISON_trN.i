################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Null Transient                           ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_BISON_base.i

external_bdries = 'top_boundary bottom_boundary side'

# TsInit = 873.15 # Solid initial temperature
# Tcin = 873.15

[Problem]
  restart_file_base = '../steady_state/MP_Griffin_ss_out_bison0_cp_cp/LATEST'
  force_restart = true
[]

[Mesh]
  file = '../steady_state/MP_Griffin_ss_out_bison0_cp_cp/LATEST'
[]

[Kernels]
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  []
[]

[AuxVariables]
  [hfluid] # Heat Transfer coefficient
    # initial_condition = 1000.00
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    # initial_condition = ${Tcin}
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
[]

[BCs]
  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = ${external_bdries}
    coefficient = 0.15 # W/K/m^2
    T_infinity = 300 # K air temperature at the top of the core
  []
[]

[MultiApps]
  [coolant_channel]
    type = TransientMultiApp
    app_type = ThermalHydraulicsApp
    positions_objects = cc_positions
    bounding_box_padding = ' 0.1 0.1 0.1'
    input_files = 'MP_SAM_trN.i'
    execute_on = 'INITIAL TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    cli_args = AuxKernels/scale_htc/expression='0.997090723*htc'
    # cli_args: this is a conversion to help with the energy balance.
    sub_cycling = true
  []
[]

[Transfers]
  [Tw_to_coolant]
    to_multi_app = coolant_channel
  []
  [Tfluid_from_coolant]
    from_multi_app = coolant_channel
  []
  [hfluid_from_coolant]
    from_multi_app = coolant_channel
  []
[]

[Executioner]
  nl_abs_tol = 1e-8

  start_time = 0
  end_time = 500
  dtmax = 1e4
  dtmin = 0.1
  dt = 1
[]

[Outputs]
  csv = false
  [exodus]
    enable = true
  []
  checkpoint = false
[]
