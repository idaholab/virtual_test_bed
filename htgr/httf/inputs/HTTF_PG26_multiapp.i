# ==============================================================================
# High Temperature Transient Facility
# Main App solve of the PG-26 transient
# RELAP-7 input file
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 08/2022
# Author(s): Thomas Freyman, Dr. Lise Charlot
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - The mesh file is stored using git lfs
# ==============================================================================

# This imput file handles 3-D conduction and communicates back and forth with RELAP-7 sub apps
T_in = 400 # K
R_l = 0.009 # m
core_block_height = 0.198 # m
heater_P = ${fparse 0.004877258 * 16} # m
heater_SA = ${fparse heater_P * 10 * core_block_height} # m^2
# Necessary functions for the PG-26 Transient
[Functions]
  # Specific heat of core ceramic material
  [cp_greencast_fn]
    type = PiecewiseLinear
    x = '335.45 422.05 506.35 589.25 671.25 752.35 832.75 912.45 991.35 1069.75 1147.45 1224.55 1301.25 1377.65 1453.85 1529.95 1606.05 1682.25 1758.15 1834.25'
    y = '940 1100 1250 1260 1180 1180 1190 1200 1210 1250 1200 1200 1180 1190 1220 1290 1290 1290 3050 1270'
  []
  # Thermal conductivity of core ceramic material (reduced by 1 half to account for core block cracking)
  [k_greencast_half_fn]
    type = PiecewiseLinear
    x = '478.15 698.15 923.15 1143.15 1368.15'
    y = '2.625 1.79 1.415 1.245 1.235'
  []
  # Emissivity of core ceramic material
  [emissivity_greencast_fn]
    type = PiecewiseLinear
    x = '296.15 323.15 373.15 423.15'
    y = '0.927 0.918 0.9 0.869'
  []
  # Emissivity of reflector material
  [emissivity_SiC_fn]
    type = PiecewiseLinear
    x = '296.15 323.15 373.15 423.15'
    y = '0.875 0.864 0.840 0.801'
  []
  # Specific heat of reflector material
  [cp_SiC_fn]
    type = ConstantFunction
    value = 689
  []
  # Thermal conductivity of reflector material
  [k_SiC_fn]
    type = PiecewiseLinear
    x = '473.15 673.15'
    y = '16 66'
  []
  # Thermal conductivity of 304 stainless-steel used for core barrel, RPV, and RCCS panels
  [k_ss304_fn]
    type = PiecewiseLinear
    x = '300 1671 1727'
    y = '13.25 39.1619 20'
  []
  # Specific heat of 304 stainless-steel used for core barrel, RPV, and RCCS panels
  [cp_ss304_fn]
    type = PiecewiseLinear
    x = '300 400 500 600 700 800 900 1000 1100 1200 1300 1400 1500 1600 1671'
    y = '477.491 504.785 528.544 549.663 568.697 586.024 601.913 616.567 630.142 642.763 654.531 665.528 675.826 685.483 691.980'
  []
  # Thermal conductivity of fiberglass insulation
  [k_insulation_fn]
    type = PiecewiseLinear
    x = '311.15 533.15'
    y = '0.036 0.069'
  []
  # Creates a function with respect to time for the power output of heater bank 103/104 based on a data file from the PG-26 Transient
  [power_103_104]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_heater103_104_power.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
  # Converts power to surface heat flux based on recorded heater power output and heater channel surface area
  [q_103_104]
    type = ParsedFunction
    value = 'if(z<0.489,0, if(z>2.469,0,(heater_power / (42 * heater_SA))))'
    vars = 'core_block_height heater_power heater_SA'
    vals = '${core_block_height} power_103_104 ${heater_SA}'
  []
  # Creates a function with respect to time for the power output of heater bank 107/110 based on a data file from the PG-26 Transient
  [power_107_110]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_heater107_110_power.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
  # Converts power to surface heat flux based on recorded heater power output and heater channel surface area
  [q_107_110]
    type = ParsedFunction
    value = 'if(z<0.489,0, if(z>2.469,0,(heater_power / (42 * heater_SA))))'
    vars = 'core_block_height heater_power heater_SA'
    vals = '${core_block_height} power_107_110 ${heater_SA}'
  []
  # Function for the upper plenum coolant temperature which interacts with the top core surface
  [top_core_surface]
    type = ParsedFunction
    value = 'if(t<=0, 373.15, upcomer_outlet_main)'
    vals = 'upcomer_outlet_main'
    vars = 'upcomer_outlet_main'
  []
  # Function for the lower plenum coolant temperature which interacts with the bottom core surface
  # Uses a PostProcessor value T_out_bulk
  [bottom_core_surface]
    type = ParsedFunction
    value = 'if(t<= 0, 373.15, T_out_bulk)'
    vals = 'T_out_bulk'
    vars = 'T_out_bulk'
  []
[]
# Creates a mesh from supplied file
[Mesh]
  [fileMesh]
    type = FileMeshGenerator
    file = 3D_HTTF_full_core.e
  []
[]
# Variable to be solved in main app
[Variables]
  [temperature]
    family = LAGRANGE
    order = FIRST
  []
[]
# Applies initial conditions to temperature variable
[ICs]
  # Intiial condition for 400 K blocks
  [400_temperature_ic]
    type = ConstantIC
    variable = temperature
    value = ${T_in}
    block = 'core reflector core_barrel'
  []
  # Initial condition for 300 K blocks
  [300_temperature_ic]
    type = ConstantIC
    variable = temperature
    value = 300
    block = 'RPV RCCS_inner_panel RCCS_outer_panel RCCS_insulation'
  []
[]
# Sub apps which interact with main app
[MultiApps]
  # Sub app for the upcomer
  [upcomer]
    type = TransientMultiApp
    input_files = 'upcomer.i'
    positions_file = '../positions/upcomer_positions.txt' # Overwrites Component position supplied in upcomer.i
    app_type = RELAP7App
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 24
    output_in_position = true
    sub_cycling = true
    output_sub_cycles = true
    max_catch_up_steps = 1e4
    max_failures = 10000
  []
  # Sub app for the coolant and bypass channels
  [relap]
    type = TransientMultiApp
    # List of input files used
    input_files = 'large_coolant.i medium_coolant.i small_coolant.i small_bypass.i large_bypass.i'
    # List of corresponding position files used to overwrite position supplied in relap input files
    positions_file = '../positions/large_coolant_positions.txt ../positions/medium_coolant_positions.txt ../positions/small_coolant_positions.txt ../positions/small_bypass_positions.txt ../positions/large_bypass_positions.txt'
    app_type = RELAP7App
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 24
    output_in_position = true
    sub_cycling = true
    output_sub_cycles = true
    max_catch_up_steps = 1e4
    max_failures = 10000
  []
  # Sub app for the RCCS
  [RCCS]
    type = TransientMultiApp
    input_files = 'RCCS.i'
    positions_file = '../positions/RCCS_positions.txt' # Overwrites position supplied in RCCS.i
    app_type = RELAP7App
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    sub_cycling = true
    output_sub_cycles = true
    max_catch_up_steps = 1e4
    max_failures = 10000
  []
[]
# Variables, AuxVariables, and post-processors transferred between main app and sub apps
[Transfers]
  # Wall temperature of coolant and bypass channels
  [Twall_to_relap]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = relap
    variable = T_wall_channel # AuxVariable name in relap-7 input files
    source_user_object = Twall_for_relap_uo # Corresponding main app UserObject
  []
  # Fluid temperature received from relap-7
  [tfluid_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = relap
    source_variable = T # variable name in relap-7
    variable = tfluid # AuxVariable name in main app
  []
  # Convective heat transfer coefficient received from relap-7
  [Hw_channel_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = relap
    source_variable = Hw_chan # AuxVariable name in relap-7
    variable = Hw_channel # AuxVariable name in main app
  []
  # Wall temperature of core barrel outer surface
  [Twall_barrel_relap]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = upcomer
    variable = T_wall_barrel # AuxVariable name in relap-7
    source_user_object = Twall_barrel_relap_uo # Corresponding main app UserObject
  []
  # Wall temperature of RPV inner surface
  [Twall_RPV_relap]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = upcomer
    variable = T_wall_RPV # AuxVariable name in relap-7
    source_user_object = Twall_RPV_relap_uo # Corresponding main app UserObject
  []
  # Fluid temperature received from relap-7
  [tfluid_upcomer_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = upcomer
    source_variable = T # variable name in relap-7
    variable = tfluid_upcomer # AuxVariable name in main app
  []
  # Convective heat transfer coefficient for core barrel received from relap-7
  [Hw_barrel_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = upcomer
    source_variable = Hw_barrel # AuxVariable name in relap-7
    variable = Hw_cb # AuxVariable name in main app
  []
  # Convective heat transfer coefficient for core barrel received from relap-7
  [Hw_RPV_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = upcomer
    source_variable = Hw_RPV # AuxVariable name in relap-7
    variable = Hw_vessel # AuxVariable name in main app
  []
  # Wall temperature of RCCS inner panel surface
  [Twall_RCCS_inner]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = RCCS
    variable = T_wall_inner # AuxVariable name in relap-7
    source_user_object = Twall_RCCS_inner_uo # Corresponding main app UserObject
  []
  # Wall temperature of RCCS inner panel surface
  [Twall_RCCS_outer]
    type = MultiAppGeneralFieldUserObjectTransfer
    to_multi_app = RCCS
    variable = T_wall_outer # AuxVariable name in relap-7
    source_user_object = Twall_RCCS_outer_uo # Corresponding main app UserObject
  []
  # Convective heat transfer coefficient for RCCS inner panel received from relap-7
  [Hw_RCCS_inner]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = RCCS
    source_variable = Hw_inner # AuxVariable name in relap-7
    variable = Hw_in # AuxVariable name in main app
  []
   # Convective heat transfer coefficient for RCCS outer panel received from relap-7
  [Hw_RCCS_outer]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = RCCS
    source_variable = Hw_outer # AuxVariable name in relap-7
    variable = Hw_out # AuxVariable name in main app
  []
  # Fluid temperature received from relap-7
  [tfluid_RCCS_from_relap]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = RCCS
    source_variable = T # variable name in relap-7
    variable = tfluid_RCCS # AuxVariable name in main app
  []
  # Mass flow rate entering core from relap-7
  [mdot_in_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = relap
    from_postprocessor = mdot_in # PostProcessor name in relap-7
    to_postprocessor = mdot_in_total # PostProcessor name in main app
    reduction_type = sum # sums the received relap-7 PostProcessors to obtain total core inlet mass flow rate
    execute_on = 'TIMESTEP_END'
  []
  # Single coolant and bypass channel outlet mass flow rate from relap-7
  [mdot_out_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = relap
    from_postprocessor = mdot_out # PostProcessor name in relap-7
    to_postprocessor = mdot_out_total # PostProcessor name in main app
    reduction_type = sum # Sums the received relap-7 PostProcessors to obtain total core outlet mass flow rate
    execute_on = 'TIMESTEP_END'
  []
  # Receives outlet temperature from the upcomer
  [upcomer_outlet_temp]
    type = MultiAppPostprocessorTransfer
    from_multi_app = upcomer
    from_postprocessor = temp # PostProcessor name in relap-7
    to_postprocessor = upcomer_outlet_main # PostProcessor name in main app
    reduction_type = average # Takes average of single value which results in the single value
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Sends outlet temperature from the upcomer to coolant and bypass channel input files
  [upcomer_to_relap]
    type = MultiAppPostprocessorTransfer
    to_multi_app = relap
    from_postprocessor = upcomer_outlet_main # PostProcessor name in main app
    to_postprocessor = upcomer_outlet # PostProcessor name in relap-7
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Receives and sums the weighted outlet temperatures from the coolant and bypass channels
  [Tout_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = relap
    from_postprocessor = T_out_weighted # PostProcessor name in relap-7
    to_postprocessor = T_out_bulk # PostProcessor name in main app
    reduction_type = sum # Sums weighted coolant and bypass channel outlet temperatures to obtain rough total outlet temperature
    execute_on = 'TIMESTEP_END'
  []
[]
# Performs heat transfer between structures which do not exactly touch
[ThermalContact]
  # Solves conductive and radiative heat transfer between reflector outer surface and core barrel inner surface
  [reflector_to_barrel]
    type = GapHeatTransfer
    primary = reflector_outside # Outside surface side set of the reflector
    quadrature = true
    secondary = core_barrel_inside # Inside surface side set of the core barrel
    emissivity_primary = 0.85 # emissivity of reflector
    emissivity_secondary = 0.5 # emissivity of core barrel
    variable = temperature
    gap_conductivity = 0.16 # conductivity of helium gas, small amount of gas is present in the gap
  []
  # Solves conductive and radiative heat transfer between core barrel outer surface and RPV inner surface
  [barrel_to_RPV]
    type = GapHeatTransfer
    primary = core_barrel_outside # Outside surface side set of the core barrel
    quadrature = true
    secondary = RPV_inside # Inside surface of the RPV
    emissivity_primary = 0.5 # emissivity of core barrel
    emissivity_secondary = 0.5 # emissivity of RPV
    gap_conductivity = 0.16 # conductivity of helium gas, present in the upcomer
    variable = temperature
  []
  # Solves conductive and radiative heat transfer between RPV outer surface and RCCS inner surface
  [RPV_to_RCCS]
    type = GapHeatTransfer
    primary = RPV_outside # Outside surface of RPV
    quadrature = true
    secondary = inner_panel_RPVside # RCCS surface facing the RPV
    emissivity_primary = 0.5 # emissivity of RPV
    emissivity_secondary = 0.5 # emissivity of RCCS
    gap_conductivity = 0.025 # conductivity of air, present between RPV and RCCS
    variable = temperature
  []
[]
# UserObjects used in Transfers
[UserObjects]
  # Determines wall temperature for the side set 'all_channels' and applies them to the positions listed in 'all_coolant_positions.txt'
  [Twall_for_relap_uo]
    type = NearestPointLayeredSideAverage
    boundary = 'all_channels'
    variable = temperature
    direction = z
    num_layers = 112 # number of axial elements used in relap-7
    points_file = '../positions/all_coolant_positions.txt'
    execute_on = 'TIMESTEP_END'
  []
  # Determines wall temperature for the side set 'core_barrel_outside' and applies it to the positions listed in 'upcomer.txt'
  [Twall_barrel_relap_uo]
    type = NearestPointLayeredSideAverage
    boundary = 'core_barrel_outside'
    variable = temperature
    direction = z
    num_layers = 28 # number of axial elements used in relap-7
    points_file = '../positions/upcomer_positions.txt'
    execute_on = 'TIMESTEP_END'
  []
  # Determines wall temperature for the side set 'RPV_inside' and applies it to the positions listed in 'upcomer.txt'
  [Twall_RPV_relap_uo]
    type = NearestPointLayeredSideAverage
    boundary = 'RPV_inside'
    variable = temperature
    direction = z
    num_layers = 35 # number of axial elements used in relap-7
    points_file = '../positions/upcomer_positions.txt'
    execute_on = 'TIMESTEP_END'
  []
  # Determines wall temperature for the side set 'inner_panel_WaterSide' and applies it to the positions listed in 'RCCS.txt'
  [Twall_RCCS_inner_uo]
    type = NearestPointLayeredSideAverage
    boundary = 'inner_panel_WaterSide'
    variable = temperature
    direction = z
    num_layers = 35 # number of axial elements used in relap-7
    points_file = '../positions/RCCS_positions.txt'
    execute_on = 'TIMESTEP_END'
  []
  # Determines wall temperature for the side set 'outer_panel_WaterSide' and applies it to the positions listed in 'RCCS.txt'
  [Twall_RCCS_outer_uo]
    type = NearestPointLayeredSideAverage
    boundary = 'outer_panel_WaterSide'
    variable = temperature
    direction = z
    num_layers = 35 # number of axial elements used in relap-7
    points_file = '../positions/RCCS_positions.txt'
    execute_on = 'TIMESTEP_END'
  []
[]
# Kernels used to solve for heat conduction and the variable temperature
[Kernels]
  # Allows for time dependency
  [transient]
    type = HeatConductionTimeDerivative
    variable = temperature
  []
  # Solves heat conduction equation
  [heatConduction]
    type = HeatConduction
    variable = temperature
  []
[]
# AuxVariables used from Transfers
[AuxVariables]
  # fluid temperature in the coolant and bypass channels
  [tfluid]
    initial_condition = 373.15
  []
  # Convective heat transfer coefficient in the coolant and bypass channels
  [Hw_channel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 100
  []
  # fluid temperature of the upcomer
  [tfluid_upcomer]
    initial_condition = 373.15
  []
  # Convective heat transfer coefficient between the upcomer and core barrel
  [Hw_cb]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 100
  []
  # Convective heat transfer coefficient between the upcomer and RPV
  [Hw_vessel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 100
  []
  # Coolant temperature in the RCCS
  [tfluid_RCCS]
    initial_condition = 300
  []
  # Convective heat transfer coefficient between the RCCS and inner panel
  [Hw_in]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 100
  []
  # Convective heat transfer coefficient between the RCCS and outer panel
  [Hw_out]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 100
  []
  # Bulk fluid temperature at the core outlet
  [T_infinity_bottom]
  []
  # Bulk fluid temperature at the core top surface
  [T_infinity_top]
  []
[]
# Applies parameters to necessary AuxKernels
[AuxKernels]
  # Applies the value from the function bottom_core_surface to AuxVariable T_infinity_bottom
  [T_infinity_bottom_aux]
    type = FunctionAux
    variable = T_infinity_bottom
    function = bottom_core_surface
  []
  # Applies the value from the function top_core_surface to AuxVariable T_infinity_top
  [T_infinity_top_aux]
    type = FunctionAux
    variable = T_infinity_top
    function = top_core_surface
  []
[]
# Boundary Conditions for main app solve
[BCs]
  # Couples upper plenum coolant temperature T_infinity_top to the core top surface
  [inlet_active_core_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'core_top'
    htc = Hw_channel
    T_infinity = T_infinity_top
  []
  # Couples upper plenum coolant temperature T_infinity_top to the core reflector surface
  [inlet_reflector_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'reflector_top'
    htc = Hw_channel
    T_infinity = T_infinity_top
  []
  # Couples upper plenum coolant temperature T_infinity_top to the core barrel top surface
  [inlet_core_barrel_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'core_barrel_top'
    htc = Hw_channel
    T_infinity = T_infinity_top
  []
  # Couples lower plenum coolant temperature T_infinity_bottom to the reflector bottom surface
  [outlet_reflector_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'reflector_bottom'
    htc = Hw_channel
    T_infinity = T_infinity_bottom
  []
  # Couples lower plenum coolant temperature T_infinity_bottom to the core bottom surface
  [outlet_active_core_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'core_bottom'
    htc = Hw_channel
    T_infinity = T_infinity_bottom
  []
  # Couples lower plenum coolant temperature T_infinity_bottom to the core barrel bottom surface
  [outlet_core_barrel_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'core_barrel_bottom'
    htc = Hw_channel
    T_infinity = T_infinity_bottom
  []
  # Couples upcomer coolant temperature to core barrel outer surface
  [outside_core_barrel]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'core_barrel_outside'
    htc = Hw_cb
    T_infinity = tfluid_upcomer
  []
  # Couples upcomer coolant temperature to RPV inner surface
  [inside_RPV]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'RPV_inside'
    htc = Hw_vessel
    T_infinity = tfluid_upcomer
  []
  # Couples RCCS coolant temperature to RCCS inner panel surface
  [inner_panel_RCCS]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'inner_panel_WaterSide'
    htc = Hw_in
    T_infinity = tfluid_RCCS
  []
  # Couples RCCS coolant temperature to RCCS outer panel surface
  [outer_panel_RCCS]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'outer_panel_WaterSide'
    htc = Hw_out
    T_infinity = tfluid_RCCS
  []
  # Couples ambient air convection to outside surface of the RPV
  [outside_RCCS]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'insulation_outside'
    htc = 15
    T_infinity = 295
  []
  # Couples coolant and bypass channel temperature to core surface
  [coolant_channel_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temperature
    boundary = 'large_coolant medium_coolant small_coolant small_bypass large_bypass' # Mesh side sets in the core where this applies
    htc = Hw_channel
    T_infinity = tfluid
  []
  # Applies a constant heat flux to the side set heater_bank_107 using the Function q_107_110
  [heater_107]
    type = FunctionNeumannBC
    boundary = 'heater_bank_107'
    function = q_107_110
    variable = temperature
  []
  # Applies a constant heat flux to the side set heater_bank_110 using the Function q_107_110
  [heater_110]
    type = FunctionNeumannBC
    boundary = 'heater_bank_110'
    function = q_107_110
    variable = temperature
  []
  # Applies a constant heat flux to the side set heater_bank_103 using the Function q_103_104
  [heater_103]
    type = FunctionNeumannBC
    boundary = 'heater_bank_103'
    function = q_103_104
    variable = temperature
  []
  # Applies a constant heat flux to the side set heater_bank_104 using the Function q_103_104
  [heater_104]
    type = FunctionNeumannBC
    boundary = 'heater_bank_104'
    function = q_103_104
    variable = temperature
  []
[]
# Applies material properties to mesh blocks based on supplied functions and constant values
[Materials]
  [greencast_k_cp]
    type = HeatConductionMaterial
    block = 'core'
    temp = temperature
    thermal_conductivity_temperature_function = k_greencast_half_fn
    specific_heat_temperature_function = cp_greencast_fn
  []
  [greencast_rho]
    type = Density
    block = 'core'
    density = 2912
  []
  [steel_rho]
    type = Density
    block = 'core_barrel RPV RCCS_inner_panel RCCS_outer_panel'
    density = 8050
  []
  [SiC_k_cp]
    type = HeatConductionMaterial
    block = 'reflector'
    temp = temperature
    thermal_conductivity_temperature_function = k_SiC_fn
    specific_heat_temperature_function = cp_SiC_fn
  []
  [SiC_rho]
    type = Density
    block = 'reflector'
    density = 2370
  []
  [steel_k_cp]
    type = HeatConductionMaterial
    block = 'core_barrel RPV RCCS_inner_panel RCCS_outer_panel'
    temp = temperature
    thermal_conductivity_temperature_function = k_ss304_fn
    specific_heat_temperature_function = cp_ss304_fn
  []
  [insulation_rho]
    type = Density
    block = 'RCCS_insulation'
    density = 91
  []
  [insulation_k_cp]
    type = HeatConductionMaterial
    block = 'RCCS_insulation'
    temp = temperature
    thermal_conductivity_temperature_function = k_insulation_fn
    specific_heat = 700
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
  scheme = 'bdf2'
  # petsc options for large 3-D heat conduction problem
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 100 0.8'
  solve_type = 'NEWTON'
  line_search = 'basic'
  start_time = 0
  dtmin = 0.1
  dtmax = 1000
  end_time = 270000
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
  []
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 15
  # Allows for Picard Iterations
  fixed_point_rel_tol = 1e-6
  fixed_point_abs_tol = 1e-7
  fixed_point_max_its = 5
  accept_on_max_fixed_point_iteration = true
[]
[Outputs]
  exodus = true
  csv = true
  perf_graph = true
  file_base = 'HTTF_PG26_transient'
[]
# Records desired data for comparison to experimental instrumentation
[Postprocessors]
  # Counts number of picard iterations required during multi-app execution
  [picard_its]
    type = NumFixedPointIterations
    execute_on = 'initial timestep_end'
  []
  # Core Fluid Temps
  [TF-1318]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.260299988} -0.120230003 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1332]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.026030001} -0.285540009 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1306]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.182210007} 0.285540009 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1320]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.338390015} 0.01503 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1334]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.182210007} -0.285540009 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1308]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.286329987} 0.285540009 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1322]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.390450012} 0.105199997 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1336]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.286329987} -0.285540009 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1504]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l -0.026030002} 0.258540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1518]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.0005 + 0.260299988} -0.120230003 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1532]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.026030001} -0.285540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1506]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.182210007} 0.285540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1520]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.338390015} 0.01503 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1534]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.182210007} -0.285540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1508]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.286329987} 0.285540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1522]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.390450012} 0.105199997 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1536]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.286329987} -0.285540009 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1704]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.026030001} 0.285540009 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1718]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.260299988} -0.120230003 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1732]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.026030001} -0.285540009 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1734]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.182210007} -0.285540009 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1708]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + -0.286329987} 0.285540009 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TF-1736]
    type = PointValue
    variable = tfluid
    point = '${fparse R_l + 0.286329987} -0.285540009 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
# Core Solid Temps
  [TS-1301]
    type = PointValue
    variable = temperature
    point = '0.0 0.0 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1302]
    type = PointValue
    variable = temperature
    point = '-0.05206 0.1297 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1303]
    type = PointValue
    variable = temperature
    point = '-0.01508 0.2555 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1311]
    type = PointValue
    variable = temperature
    point = '-0.1822 0.1226 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1317]
    type = PointValue
    variable = temperature
    point = '0.2213 -0.12023 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1305]
    type = PointValue
    variable = temperature
    point = '-0.169195 0.25548 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1319]
    type = PointValue
    variable = temperature
    point = '0.29934 0.01528 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1333]
    type = PointValue
    variable = temperature
    point = '0.169555 -0.25548 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1307]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.25548 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1312]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.33062 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1321]
    type = PointValue
    variable = temperature
    point = '0.377435 0.12023 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1326]
    type = PointValue
    variable = temperature
    point = '0.43151 0.07514 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1501]
    type = PointValue
    variable = temperature
    point = '0.0 0.0 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1502]
    type = PointValue
    variable = temperature
    point = '-0.05206 0.1297 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1503]
    type = PointValue
    variable = temperature
    point = '-0.01508 0.2555 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1505]
    type = PointValue
    variable = temperature
    point = '-0.169195 0.25548 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1507]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.25548 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1512]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.33062 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1517]
    type = PointValue
    variable = temperature
    point = '0.2213 -0.12023 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1521]
    type = PointValue
    variable = temperature
    point = '0.377435 0.12023 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1526]
    type = PointValue
    variable = temperature
    point = '0.43151 0.07514 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1535]
    type = PointValue
    variable = temperature
    point = '0.273315 -0.2475 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1701]
    type = PointValue
    variable = temperature
    point = '0.0 0.0 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1702]
    type = PointValue
    variable = temperature
    point = '-0.05206 0.1297 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1716]
    type = PointValue
    variable = temperature
    point = '0.05206 -0.1297 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1703]
    type = PointValue
    variable = temperature
    point = '-0.01508 0.2555 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1711]
    type = PointValue
    variable = temperature
    point = '-0.1822 0.1226 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1725]
    type = PointValue
    variable = temperature
    point = '0.20824 0.07514 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1717]
    type = PointValue
    variable = temperature
    point = '0.2213 -0.12023 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1739]
    type = PointValue
    variable = temperature
    point = '0.169195 0.142765 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1731]
    type = PointValue
    variable = temperature
    point = '0.02603 0.24045 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1705]
    type = PointValue
    variable = temperature
    point = '-0.169195 0.25548 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1719]
    type = PointValue
    variable = temperature
    point = '0.29934 0.01528 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1733]
    type = PointValue
    variable = temperature
    point = '0.169195 -0.25548 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1707]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.25548 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1712]
    type = PointValue
    variable = temperature
    point = '-0.2733 0.33062 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1740]
    type = PointValue
    variable = temperature
    point = '0.286329987 -0.33062 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1735]
    type = PointValue
    variable = temperature
    point = '0.273315 -0.2475 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  # Permanent Reflector Temps
  [TS-1310]
    type = PointValue
    variable = temperature
    point = '-0.586013245 0.338334900 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1324]
    type = PointValue
    variable = temperature
    point = '0.668529541 0 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1338]
    type = PointValue
    variable = temperature
    point = '0.33162561 -0.574392395 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1510]
    type = PointValue
    variable = temperature
    point = '-0.586013245 0.338334900 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1524]
    type = PointValue
    variable = temperature
    point = '0.668529541 0 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1538]
    type = PointValue
    variable = temperature
    point = '0.33162561 -0.574392395 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1710]
    type = PointValue
    variable = temperature
    point = '-0.586013245 0.338334900 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1724]
    type = PointValue
    variable = temperature
    point = '0.668529541 0 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1738]
    type = PointValue
    variable = temperature
    point = '0.33162561 -0.574392395 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  # Side Reflector Temps
  [TS-1309]
    type = PointValue
    variable = temperature
    point = '-0.308024994 0.383226837 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1313]
    type = PointValue
    variable = temperature
    point = '-0.348463013 0.423207550 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1314]
    type = PointValue
    variable = temperature
    point = '-0.270369995 0.468294586 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1315]
    type = PointValue
    variable = temperature
    point = '-0.192283264 0.513377991 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1323]
    type = PointValue
    variable = temperature
    point = '0.489929993 -0.075139999 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1327]
    type = PointValue
    variable = temperature
    point = '0.540739990 0.090169998 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1328]
    type = PointValue
    variable = temperature
    point = '0.540739990 0 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1329]
    type = PointValue
    variable = temperature
    point = '0.540739990 -0.090169998 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1337]
    type = PointValue
    variable = temperature
    point = '0.177875000 -0.458366852 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1341]
    type = PointValue
    variable = temperature
    point = '0.348463013 -0.423207550 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1342]
    type = PointValue
    variable = temperature
    point = '0.270369995 -0.468294586 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1343]
    type = PointValue
    variable = temperature
    point = '0.192283264 -0.513377991 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1509]
    type = PointValue
    variable = temperature
    point = '-0.308024994 0.383226837 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1513]
    type = PointValue
    variable = temperature
    point = '-0.348463013 0.423207550 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1514]
    type = PointValue
    variable = temperature
    point = '-0.270369995 0.468294586 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1515]
    type = PointValue
    variable = temperature
    point = '-0.192283264 0.513377991 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1523]
    type = PointValue
    variable = temperature
    point = '0.489929993 -0.075139999 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1527]
    type = PointValue
    variable = temperature
    point = '0.540739990 0.090169998 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1528]
    type = PointValue
    variable = temperature
    point = '0.540739990 0 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1529]
    type = PointValue
    variable = temperature
    point = '0.540739990 -0.090169998 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1537]
    type = PointValue
    variable = temperature
    point = '0.177875000 -0.458366852 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1541]
    type = PointValue
    variable = temperature
    point = '0.348463013 -0.423207550 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1542]
    type = PointValue
    variable = temperature
    point = '0.270369995 -0.468294586 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1543]
    type = PointValue
    variable = temperature
    point = '0.192283264 -0.513377991 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1709]
    type = PointValue
    variable = temperature
    point = '-0.308024994 0.383226837 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1713]
    type = PointValue
    variable = temperature
    point = '-0.348463013 0.423207550 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1714]
    type = PointValue
    variable = temperature
    point = '-0.270369995 0.468294586 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1715]
    type = PointValue
    variable = temperature
    point = '-0.192283264 0.513377991 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1723]
    type = PointValue
    variable = temperature
    point = '0.489929993 -0.075139999 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1727]
    type = PointValue
    variable = temperature
    point = '0.540739990 0.090169998 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1728]
    type = PointValue
    variable = temperature
    point = '0.540739990 0 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1729]
    type = PointValue
    variable = temperature
    point = '0.540739990 -0.090169998 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1737]
    type = PointValue
    variable = temperature
    point = '0.177875000 -0.458366852 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1741]
    type = PointValue
    variable = temperature
    point = '0.348463013 -0.423207550 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1742]
    type = PointValue
    variable = temperature
    point = '0.270369995 -0.468294586 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-1743]
    type = PointValue
    variable = temperature
    point = '0.192283264 -0.513377991 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  # RPV Temps
  [TS-7301]
    type = PointValue
    variable = temperature
    point = '-0.409734985 0.709681824 1.083'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-7302]
    type = PointValue
    variable = temperature
    point = '-0.409734985 0.709681824 1.479'
    execute_on = 'TIMESTEP_END FINAL'
  []
  [TS-7303]
    type = PointValue
    variable = temperature
    point = '-0.409734985 0.709681824 1.876'
    execute_on = 'TIMESTEP_END FINAL'
  []
  # Outlet mass flow rate received from Transfers
  [mdot_out_total]
    type = Receiver
    execute_on = 'TIMESTEP_END'
  []
  # Inlet mass flow rate received from Transfers
  [mdot_in_total]
    type = Receiver
    execute_on = 'TIMESTEP_END'
  []
  # Outlet temperature of the upcomer received from Transfers
  [upcomer_outlet_main]
    type = Receiver
    execute_on = 'TIMESTEP_BEGIN'
  []
  # Bulk coolant outlet temperature received from Transfers
  [T_out_bulk]
    type = Receiver
    execute_on = 'TIMESTEP_END'
  []
[]
