################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_BISON_base.i

# fuel_blocks = 'fuel_in fuel_mid fuel_out fuel_tri_in fuel_tri_mid fuel_tri_out'
he_channel_blocks = '200 201'

external_bdries = 'top_boundary bottom_boundary side'

TsInit = 873.15 # Solid initial temperature
Tcin = 873.15

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/BISON_mesh_in.e'
    # file = 'bison-mesh.cpr'
  []
  [bdg_full]
    type = BlockDeletionGenerator
    input = fmg
    block = ${he_channel_blocks}
    new_boundary = ${coolant_channel_bdries}
  []
  [mod_surf]
    type = SideSetsBetweenSubdomainsGenerator
    input = bdg_full
    primary_block = 103
    paired_block = 10
    new_boundary = 'mod_surf'
  []
[]

[Variables]
  [temp]
    initial_condition = ${TsInit}
  []
[]

[Kernels]
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  []
[]

[AuxVariables]
  [power_density]
    initial_condition = 3e6 # W/m^3
  []
  [Tfuel]
    initial_condition = ${Tcin}
  []
  [hfluid] # Heat Transfer coefficient
    initial_condition = 1000.00
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    initial_condition = ${Tcin}
    block = 'monolith reflector_quad reflector_tri' # Can set it on the monolith or coolant.
  []
  [power_density_scalar]
    initial_condition = 1.0
  []
  [Tw_trans] # Coolant temperature.
    initial_condition = ${Tcin}
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
    input_files = 'MP_SAM_ss.i'
    execute_on = 'INITIAL TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    cli_args = "AuxKernels/scale_htc/expression='0.997090723*htc'"
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

  start_time = -2.5e5 # negative start time so we can start running from t = 0
  end_time = 0
  dtmax = 1e4
  dtmin = 0.1

  [TimeStepper]
   type = TimeSequenceStepper
   time_sequence = '-250000 -249990 -249980 -249960 -249920 -249840 -249680 -249360 -248720 -247440 -244880 -239760 -230000 -220000 -210000 -200000 -190000 -180000 -170000 -160000 -150000 -140000 -130000 -120000 -110000 -100000 -90000 -80000 -70000 -60000 -50000 -40000 -30000 -20000 -10000 0'
 []
[]

[Outputs]
  csv = false
  [exodus]
    execute_on = 'TIMESTEP_END'
    enable = false
    start_time = -1e-8 # Write Exodus on the last timestep
  []
  [cp]
    type = Checkpoint
    wall_time_interval = '300' # Only write a checkpoint file every 5 minutes of wall time
    execute_on = FINAL
  []
[]
