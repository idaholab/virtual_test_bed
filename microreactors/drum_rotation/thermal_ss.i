fuel_blocks =  '1 2'
moderator_blocks = '3 4'
monolith_blocks = '8 22' # For now fill the air gap with monolith
reflector_blocks = '10 11 14 15'
drum_blocks = '13'

solid_blocks = '1 2 3 4 8 10 11 13 14 15 22'
# hp_blocks = '6 7 5 20 21'

# Hexagon math
r = ${fparse 16.1765 / 100} # Apothem (set by generator)
d = ${fparse 4 / sqrt(3) * r} # Long diagonal
x_center = ${fparse 9 / 4 * d}
y_center = ${fparse r}

[Mesh]
  [main]
    type = FileMeshGenerator
    file = empire_2d_CD_fine_in.e
  []
  [add_sideset_hp]
    type = SideSetsBetweenSubdomainsGenerator
    input = main
    primary_block = '8' # add 16 so the HP boundary extends into the upper axial reflector
    paired_block =  '7'
    new_boundary = 'hp'
  []
  [add_sideset_inner_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_hp
    primary_block = '4'
    paired_block =  '5'
    new_boundary = 'gap_mod_inner'
  []
  [add_sideset_outer_mod_gap]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_sideset_inner_mod_gap
    primary_block = '8'
    paired_block =  '5'
    new_boundary = 'gap_mod_outer'
  []
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

[Variables]
  [Tsolid]
    initial_condition = 950
    block = '${solid_blocks}'
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = Tsolid
    block = '${solid_blocks}'
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = Tsolid
    block = '${fuel_blocks}'
    v = power_density
  []
[]

[AuxVariables]
  [power_density]
    block = '${fuel_blocks}'
    family = MONOMIAL
    order = FIRST
    initial_condition = 2.3e6
  []
  [htc_hp_var]
    block = '${monolith_blocks}'
    initial_condition = 3e2
  []
  [Tsink_hp_var]
    block = '${monolith_blocks}'
    initial_condition = 900
  []
[]

[BCs]
  [hp_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = Tsolid
    boundary = 'hp' # inside of heat pipe
    htc = htc_hp_var
    T_infinity = Tsink_hp_var # eventually, will be given by Sockeye
  []
  [rrefl_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = Tsolid
    boundary = 'right' # reflector cooling
    htc = 50 # arbitrary (but small) HTC
    T_infinity = 500 # arbitrary Tsink
  []
[]

[ThermalContact]
  [RPV_gap]
    type = GapHeatTransfer
    gap_geometry_type = 'PLATE'
    emissivity_primary = 0.8
    emissivity_secondary = 0.8 # varies from 0.6 to 1.0 in RPV paper, 0.79 in NRC paper
    variable = Tsolid # graphite -> rpv gap
    primary = 'gap_mod_inner'
    secondary = 'gap_mod_outer'
    gap_conductivity = 0.08 # W/m/K, typical thermal connectivity for air at 1000C
    quadrature = true
  []
[]

[Functions]
  [cos_theta_hat]
    type = ParsedFunction
    expression = '(cos(theta*pi/180) * (xc - x) + sin(theta*pi/180) * (yc - y)) / (sqrt((xc-x)^2+(yc-y)^2))'
    symbol_names = 'theta xc yc'
    symbol_values = 'drum_position ${x_center} ${y_center}'
  []
  [drum_k]
    type = ParsedFunction
    expression = 'if(cost < cos45, 200, 20)'
    symbol_names = 'cost cos45'
    symbol_values = 'cos_theta_hat 0.7071067811865476'
  []
  [drum_cp]
    type = ParsedFunction
    expression = 'if(cost < cos45, 1825, 1000)'
    symbol_names = 'cost cos45'
    symbol_values = 'cos_theta_hat 0.7071067811865476'
  []
  [drum_rho]
    type = ParsedFunction
    expression = 'if(cost < cos45, 1.85376e3, 2.52e3)'
    symbol_names = 'cost cos45'
    symbol_values = 'cos_theta_hat 0.7071067811865476'
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

  ### THERMAL CONDUCTIVITY ###
  # units of W/m-K
  [fuel_kappa]
    type = HeatConductionMaterial
    block = '${fuel_blocks}'
    # temp = Tsolid
    thermal_conductivity = 19 # W/m/K
    specific_heat = 300 # reasonable value
  []
  [moderator_kappa]
    type = HeatConductionMaterial
    block = '${moderator_blocks}'
    # temp = Tsolid
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [monolith_thermal_props]
    type = HeatConductionMaterial
    block = '${monolith_blocks}'
    # temp = Tsolid
    thermal_conductivity = 70 # typical value for G348 graphite
    specific_heat = 1830 # typical value for G348 graphite
  []
  [reflector_kappa]
    type = HeatConductionMaterial
    block = '${reflector_blocks}'
    # temp = Tsolid
    thermal_conductivity = 200 # W/m/K, typical value for Be
    specific_heat = 1825 # typical value for Be
  []

  [drum_material]
    type = GenericFunctionMaterial
    block = '${drum_blocks}'
    prop_names  = 'thermal_conductivity    specific_heat density   thermal_conductivity_dT'
    prop_values = 'drum_k                  drum_cp        drum_rho 0'
  []
[]

[Executioner]
  type = Steady
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 300'
  line_search = 'none'

  l_tol = 1e-02
  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-8

  l_max_its = 50
  nl_max_its = 25
[]

[Postprocessors]
  [drum_position]
    type = Receiver
    default = 90
  []
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
[]

[UserObjects]
  [thermal_initial]
    type = SolutionVectorFile
    var = 'Tsolid power_density'
    folder = 'binary_90'
    execute_on = final
  []
[]

[Outputs]
  console = false
  exodus = true
[]
