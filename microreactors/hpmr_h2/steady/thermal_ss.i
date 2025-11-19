# ##################################################################################################################
# AUTHORS:            Stefano Terlizzi and Vincent Labouré
# DATE:               June 2023
# ORGANIZATION:       Idaho National Laboratory (INL), C-110
# CITATION:           S. Terlizzi and V. Labouré. (2023).
#                     "Asymptotic hydrogen redistribution analysis in yttrium-hydride-moderated heat-pipe-cooled
#                     microreactors using DireWolf", Annals of Nuclear Energy, Vol. 186, 109735.
# DESCRIPTION:        Model for heat conduction and hydrogen migration.
# FUNDS:              This work was supported by INL Laboratory Directed Research&
#                     Development (LDRD) Program under U.S. Department of Energy (DOE) Idaho Operations Office,
#                     United States of America contract DE-AC07-05ID14517.
# ##################################################################################################################
# Block assignment
fuel_blocks = '1 2'
moderator_blocks = '3 4'
monolith_blocks = '8 22' # For now fill the air gap with monolith
reflector_blocks = '10 11 13 14 15 16 17 18 19'
upper_reflector_blocks = '16 17'
absorber_blocks = '12'
# for radial reflector BC
rrefl_htc = 25 # W/m^2/K arbitrary (but small) HTC
rrefl_Tsink = 800 # K, arbitrary Tsink
T_init = 950
# Parameter to perform sensitivity analysis on Q, heat of transport
qvalue_multiplier = 1.0

# This provides the initial mesh before we modify it below
!include one_twelfth_simba_core.i

[Mesh]
  # remove blocks and add sidesets to apply boundary conditions
  [add_sideset_hp]
    type = SideSetsBetweenSubdomainsGenerator
    input = extruder
    primary_block = '8 17' # add 16 so the HP boundary extends into the upper axial reflector
    paired_block = '7'
    new_boundary = 'hp'
  []
  [add_sideset_inner_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_hp
    primary_block = '4'
    paired_block = '5'
    new_boundary = 'gap_mod_inner'
  []
  [add_sideset_outer_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_inner_mod_gap
    primary_block = '8'
    paired_block = '5'
    new_boundary = 'gap_mod_outer'
  []
  [add_sideset_central_hole]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_outer_mod_gap
    primary_block = '22'
    paired_block = '21'
    new_boundary = 'central_hole'
  []
  [remove_blocks] # remove HPs, moderator gap and central shutdown cooling hole
    type = BlockDeletionGenerator
    input = add_sideset_central_hole
    block = '6 7 5 20 21'
  []
[]

[Variables]
  [Tsolid]
    initial_condition = ${T_init} # set all the temperatures to T_sink in Sockeye to allow a smooth ramp-up
  []
  [ch]
    initial_condition = 1.8
    block = ${moderator_blocks}
  []
[]

[Kernels]
  # Heat conduction
  [heat_time_derivative]
    type = HeatConductionTimeDerivative
    variable = Tsolid
  []
  [heat_conduction]
    type = HeatConduction
    variable = Tsolid
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = Tsolid
    block = '${fuel_blocks}'
    v = power_density
  []
  # Hydrogen redistribution
  [ch_time_derivative]
    type = TimeDerivative
    variable = ch
    block = ${moderator_blocks}
  []
  [ch_dxdx]
    type = MatDiffusion
    variable = ch
    diffusivity = D
    block = ${moderator_blocks}
  []
  [soretDiff]
    type = ThermoDiffusion
    variable = ch
    temp = Tsolid
    heat_of_transport = Q
    mass_diffusivity = D
    block = ${moderator_blocks}
  []
[]

[AuxVariables]
  [power_density]
    block = '${fuel_blocks}'
    family = MONOMIAL
    order = FIRST
    initial_condition = 2302579.81614
  []
  # add upper_reflector_blocks blocks because HP cooling occurs there too
  [htc_hp_var]
    block = '${monolith_blocks} ${upper_reflector_blocks}'
    initial_condition = 372
  []
  [Tsink_hp_var]
    block = '${monolith_blocks} ${upper_reflector_blocks}'
    initial_condition = 900
  []
  [Tfuel_layered_average]
    order = CONSTANT
    family = MONOMIAL
    block = '${fuel_blocks}'
  []
[]

[BCs]
  [hp_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = Tsolid
    boundary = 'hp' # inside of heat pipe
    htc = htc_hp_var # given by Sockeye
    T_infinity = Tsink_hp_var # given by Sockeye
  []
  [rrefl_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = Tsolid
    boundary = 'right' # reflector cooling
    htc = ${rrefl_htc}
    T_infinity = ${rrefl_Tsink}
  []
[]

[ThermalContact]
  [moderator_gap]
    type = GapHeatTransfer
    emissivity_primary = 0.8
    emissivity_secondary = 0.8
    variable = Tsolid
    primary = 'gap_mod_inner'
    secondary = 'gap_mod_outer'
    gap_conductivity = 0.08 # W/m/K, typical thermal connectivity for air at 1000C
    quadrature = true
  []
[]

[Materials]
  #### DENSITY #####
  # units of kg/m^3
  [fuel_density]
    type = Density
    block = '${fuel_blocks}'
    density = 14.3e3 # same as in Serpent input
  []
  [moderator_density]
    type = Density
    block = '${moderator_blocks}'
    density = 4.3e3 # same as in Serpent input
  []
  [monolith_density]
    type = Density
    block = '${monolith_blocks}'
    density = 1.8e3 # same as in Serpent input
  []
  [reflector_density]
    type = Density
    block = '${reflector_blocks}'
    density = 1.85376e3 # same as in Serpent input
  []
  [absorber_density]
    type = Density
    block = '${absorber_blocks}'
    density = 2.52e3 # same as in Serpent input
  []
  ### THERMAL CONDUCTIVITY ###
  # units of W/m-K
  [fuel_kappa]
    type = HeatConductionMaterial
    block = '${fuel_blocks}'
    thermal_conductivity = 19 # W/m/K
    specific_heat = 300 # reasonable value
  []
  [moderator_kappa]
    type = HeatConductionMaterial
    block = '${moderator_blocks}'
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [monolith_thermal_props]
    type = HeatConductionMaterial
    block = '${monolith_blocks}'
    thermal_conductivity = 70 # typical value for G348 graphite
    specific_heat = 1830 # typical value for G348 graphite
  []
  [reflector_kappa]
    type = HeatConductionMaterial
    block = '${reflector_blocks}'
    thermal_conductivity = 200 # W/m/K, typical value for Be
    specific_heat = 1825 # typical value for Be
  []
  [absorber_kappa]
    type = HeatConductionMaterial
    block = '${absorber_blocks}'
    thermal_conductivity = 20 # W/m/K, typical value for B4C
    specific_heat = 1000 # typical value for Be
  []
  # Material properties for migration. D can e adjusted for convergence in steady-state
  [moderator_diffusivity]
    type = GenericConstantMaterial
    block = ${moderator_blocks}
    prop_names = 'D Q'
    prop_values = '1 ${fparse 5.3e3 * qvalue_multiplier}'
  []
[]

[Functions]
[]

[Executioner]
  type = Transient
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 300'
  line_search = 'none'
  automatic_scaling = true

  l_tol = 1e-02
  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-8

  l_max_its = 50
  nl_max_its = 25

  start_time = 0
  end_time = 3e4

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.5
    dt = 0.01 # the initial timestep should be very small to avoid discrepancy due to lagging at the beginning of each new Richardson iteration
  []
  dtmax = 5e3 # convergence of the global energy balance has less to do with the dt and end_time and more with the actual number of time steps!! (at least after the internal balance in both models is really close to 0)
  dtmin = 1e-3
[]

[UserObjects]
  [average_Twall_hp]
    type = NearestPointLayeredSideAverage
    boundary = 'hp'
    variable = Tsolid
    direction = z
    bounds = '0.2 2.0' # evaporator section - could add more layers but delta T less than 50K (do it after seeing if it messes with Sockeye)
    points_file = 'twelfth_core_hp_centers.txt' # assembly centers
    execute_on = 'initial timestep_end'
  []
[]

[MultiApps]
  [sockeye]
    type = TransientMultiApp
    positions_file = 'twelfth_core_hp_centers.txt' # 101 HPs
    app_type = SockeyeApp
    input_files = 'heatpipe_vapor_only.i'
    execute_on = 'timestep_end'
    max_procs_per_app = 1
    sub_cycling = true
    max_failures = 1000 # number of times the sub-app is allowed to cut its timesteps before the master-app cuts it
    output_in_position = true
    cli_args = 'weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1
                weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=0.5
                weight=1 weight=1 weight=0.5 weight=1 weight=0.5 weight=0.5 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1
                weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1
                weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1
                weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=1 weight=0.5 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=0.5
                weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1 weight=1'
  []
[]

[Transfers]
  [to_sockeye_twall]
    type = MultiAppUserObjectTransfer
    to_multi_app = sockeye
    variable = T_ext_var
    user_object = average_Twall_hp
  []
  [from_sub_htc]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = sockeye
    variable = htc_hp_var
    postprocessor = htc_equiv_cond
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
  [from_sub_tsink]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = sockeye
    variable = Tsink_hp_var
    postprocessor = T_secondary #T_evap
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
  [total_power_from_condensers]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sockeye
    from_postprocessor = 'total_condenser_power'
    to_postprocessor = 'total_condenser_power'
    reduction_type = sum
  []
[]

[Postprocessors]
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = ${fuel_blocks}
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${fuel_blocks}
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${fuel_blocks}
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = ${moderator_blocks}
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${moderator_blocks}
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${moderator_blocks}
    value_type = min
  []
  [monolith_temp_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = ${monolith_blocks}
  []
  [monolith_temp_max]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${monolith_blocks}
  []
  [monolith_temp_min]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${monolith_blocks}
    value_type = min
  []
  [refl_temp_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = ${reflector_blocks}
  []
  [refl_temp_max]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${reflector_blocks}
  []
  [refl_temp_min]
    type = ElementExtremeValue
    variable = Tsolid
    block = ${reflector_blocks}
    value_type = min
  []
  [heatpipe_surface_temp_avg]
    type = SideAverageValue
    variable = Tsolid
    boundary = 'hp'
  []
  [hp_bc_heat_flux]
    type = ConvectiveHeatTransferSideIntegral
    boundary = 'hp'
    T_solid = Tsolid
    T_fluid_var = Tsink_hp_var
    htc_var = htc_hp_var
    execute_on = 'initial timestep_end'
  []
  [rrefl_heat_flux]
    type = ConvectiveHeatTransferSideIntegral
    boundary = 'right'
    T_solid = Tsolid
    T_fluid = ${rrefl_Tsink}
    htc = ${rrefl_htc}
    execute_on = 'initial timestep_end'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    block = '${fuel_blocks}'
    variable = power_density
    execute_on = 'initial timestep_begin timestep_end'
  []
  [fuel_volume]
    type = VolumePostprocessor
    block = '${fuel_blocks}'
  []
  [hp_surface]
    type = AreaPostprocessor
    boundary = 'hp'
  []
  [Tsink_hp_var_avg]
    type = SideAverageValue
    variable = Tsink_hp_var
    # block = ${monolith_blocks}
    boundary = 'hp'
  []
  [htc_hp_var_avg]
    type = SideAverageValue
    variable = htc_hp_var
    boundary = 'hp'
  []
  [total_condenser_power]
    type = Receiver
  []
  [global_energy_balance] # balance performed globally (i.e. using the heat flux out of the condenser, much more difficult to bring to 0 than if using hp_bc_heat_flux)
    type = ParsedPostprocessor
    expression = '(total_power - total_condenser_power - rrefl_heat_flux) / total_power'
    pp_names = 'total_power total_condenser_power rrefl_heat_flux'
  []
  [ch_avg]
    type = ElementAverageValue
    variable = ch
    block = ${moderator_blocks}
  []
  [ch_max]
    type = ElementExtremeValue
    variable = ch
    block = ${moderator_blocks}
  []
  [ch_min]
    type = ElementExtremeValue
    variable = ch
    block = ${moderator_blocks}
    value_type = min
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = true
  [exodus]
    type = Exodus
    overwrite = true
    show = 'Tsolid power_density Tsink_hp_var htc_hp_var ch'
  []
[]
