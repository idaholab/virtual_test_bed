# ==============================================================================
# Full-core homogenized heat transfer model (null)
# Application: BISON (Sabertooth with child applications)
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 2023
# Author(s): Vincent Laboure
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

# Defining i as the axial layer index (1 being the top and 18 the bottom), we have the following block IDs:
# 1050 + i: fuel columns of type 1
# 1150 + i: fuel columns of type 2
# 1250 + i: fuel columns of type 3
# 1350 + i: fuel columns of type 4
# 1450 + i: RR columns
# 1550 + i: PR columns
# 2050 + i: CR column, type C
# 2150 + i: CR columns, type R1 without neutron sources for i = 5-6
# 2170 + i: CR columns, type R1 with neutron sources for i = 5-6 (only modeled during transient)
# 2250 + i: CR columns, type R2
# 2350 + i: I columns,
# 2450 + i: CR columns, type R3

# Block IDs of fuel regions
fuel_blocks = '
1055 1056 1057 1058 1059 1060 1061 1062 1063 1064
1155 1156 1157 1158 1159 1160 1161 1162 1163 1164
1255 1256 1257 1258 1259 1260 1261 1262 1263 1264
1355 1356 1357 1358 1359 1360 1361 1362 1363 1364
'

# fuel columns including the axial reflectors (since cooling will occur there)
full_fuel_blocks = '
1051 1052 1053 1054 1055 1056 1057 1058 1059 1060 1061 1062 1063 1064 1065 1066 1067 1068
1151 1152 1153 1154 1155 1156 1157 1158 1159 1160 1161 1162 1163 1164 1165 1166 1167 1168
1251 1252 1253 1254 1255 1256 1257 1258 1259 1260 1261 1262 1263 1264 1265 1266 1267 1268
1351 1352 1353 1354 1355 1356 1357 1358 1359 1360 1361 1362 1363 1364 1365 1366 1367 1368
'

fuel_blocks_33pin = '
1055 1056 1057 1058 1059 1060 1061 1062 1063 1064
1155 1156 1157 1158 1159 1160 1161 1162 1163 1164
'

fuel_blocks_31pin = '
1255 1256 1257 1258 1259 1260 1261 1262 1263 1264
1355 1356 1357 1358 1359 1360 1361 1362 1363 1364
'

rr_fuel_blocks_33pin = '
1051 1052 1053 1054 1065 1066 1067 1068
1151 1152 1153 1154 1165 1166 1167 1168
'

rr_fuel_blocks_31pin = '
1251 1252 1253 1254 1265 1266 1267 1268
1351 1352 1353 1354 1365 1366 1367 1368
'

# CR columns including the axial reflectors (since cooling will occur there)
full_cr_blocks = '
2051 2052 2053 2054 2055 2056 2057 2058 2059 2060 2061 2062 2063 2064 2065 2066 2067 2068
2151 2152 2153 2154 2155 2156 2157 2158 2159 2160 2161 2162 2163 2164 2165 2166 2167 2168
2171 2172 2173 2174 2175 2176 2177 2178 2179 2180 2181 2182 2183 2184 2185 2186 2187 2188
2251 2252 2253 2254 2255 2256 2257 2258 2259 2260 2261 2262 2263 2264 2265 2266 2267 2268
2451 2452 2453 2454 2455 2456 2457 2458 2459 2460 2461 2462 2463 2464 2465 2466 2467 2468
'

# Remaining blocks containing the removable, permanent reflectors, and instrumentation
full_pr_blocks = '
1451 1452 1453 1454 1455 1456 1457 1458 1459 1460 1461 1462 1463 1464 1465 1466 1467 1468
1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567 1568
2351 2352 2353 2354 2355 2356 2357 2358 2359 2360 2361 2362 2363 2364 2365 2366 2367 2368
'

rpv_blocks = '2'

Tinlet = 453.15 # fluid inlet temperature

rpv_outer_radius = 2.872 # m
vcs_radius = 4.00 # m

stefan_boltzmann_constant = 5.670367e-8
vcs_emissivity = 0.95
rpv_emissivity = 0.95

D_ext_fuel = 4.1e-2 # external diameter in m
npins_fuel33 = 33
npins_fuel31 = 31

D_ext_cr = 1.23e-1 # external diameter in m

p = 0.36 # hexagonal pitch in m
Sblock = '${fparse 0.5 * sqrt(3) * p * p}' # Cross-section area of the hexagonal block in m^2

# volume fractions of graphite for the 31 fuel, 33 fuel and CR blocks
vol_frac_fuel33 = '${fparse 1 - 0.25 * npins_fuel33 * pi * D_ext_fuel * D_ext_fuel / Sblock}'
vol_frac_fuel31 = '${fparse 1 - 0.25 * npins_fuel31 * pi * D_ext_fuel * D_ext_fuel / Sblock}'
vol_frac_cr = '${fparse 1 - 0.25 * 3            * pi * D_ext_cr * D_ext_cr / Sblock}' # use 3 instead of 2 because 3 holes (but only 2 CRs)

# weighting factor of sleeve temperature [see HTTR_XS.xlsx for computation]
# Tmod is defined, in the fuel blocks, as: xi * Tsleeve + (1 - xi) * Tsolid
xi31 = 0.142146 # 31-pin fuel blocks
xi33 = 0.154815 # 33-pin fuel blocks

extension = '_9MW'

[Problem]
  restart_file_base = neutronics_eigenvalue${extension}_moose_modules0_checkpoint_cp/LATEST
  force_restart = true
[]

[Mesh]
  file = neutronics_eigenvalue${extension}_moose_modules0_checkpoint_cp/LATEST
[]

[Variables]
  [Tsolid] # also wall temperature (moderator side) from Griffin to RELAP-7
  []
[]

[Functions]
  [T_init]
    type = ParsedFunction
    expression = '${Tinlet}'
  []
  [T_outside]
    type = ParsedFunction
    # set to 300 K to match temp with VCS operation (concrete bio shield temp)
    expression = 300 # change to piecewise function for transient without VCS
  []
  [decay_heat_power_density_func]
    # x in s
    # y in W/m^3
    type = PiecewiseLinear
    x = '0' # 8.64 86.4 259.2 432 864 1296 1728 2160 2592 3024 3456 3888 4320 8640 12960 17280 21600 25920 30240 34560 38880 43200 47520 51840 56160 60480 64800 69120 73440 77760 82080 86400'
    y = '5.7472e+5' # 4.2455e+5 2.8708e+5 2.3162e+5 2.0972e+5 1.8030e+5 1.6245e+5 1.4962e+5 1.3976e+5 1.3190e+5 1.2547e+5 1.2011e+5 1.1555e+5 1.1163e+5 8.9431e+4 7.9024e+4 7.2585e+4 6.8042e+4 6.4565e+4 6.1753e+4 5.9397e+4 5.7373e+4 5.5606e+4 5.4042e+4 5.2646e+4 5.1388e+4 5.0247e+4 4.9205e+4 4.8248e+4 4.7366e+4 4.6547e+4 4.5785e+4 4.5073e+4'
  []
  [ssteel_304_k]
    type = PiecewiseLinear # [W/mK]
    x = '300.0 400.0 500.0 600.0 800.0 1000.0'
    y = '14.9   16.7  18.3  19.7  22.6  25.4'
  []
  [IG110_k] # thermal conductivity divided by the temperature (dirty trick to make AnisoHeatConductionMaterial define a temperature-independent anistropic thermal conductivity)
    type = ParsedFunction
    symbol_values = '6.632e+01 -4.994e-02 1.712e-05' # [W/m/K]
    symbol_names = 'a0        a1         a2       '
    expression = '((a0 + a1 * t + a2 * t * t) - 1) / t'
  []
  [IG110_cp] # assumed to be the same as for H-451 graphite, taken from MHTGR-350-Appendices.r0.pdf
    type = ParsedFunction
    symbol_values = '0.54212 -2.42667e-6 -90.2725 -43449.3 1.59309e7 -1.43688e9 4184' # [J/kg/K]
    symbol_names = 'a0     a1          a2       a3       a4        a5         b'
    expression = 'if(t < 300, 712.76, (a0 + a1 * t + a2 / t + a3 / t / t + a4 / t / t / t + a5 / t / t / t / t) * b)'
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = Tsolid
    block = '${rpv_blocks}'
  []
  [aniso_heat_conduction]
    type = AnisoHeatConduction
    variable = Tsolid
    thermal_conductivity = aniso_thermal_conductivity
    block = '${full_fuel_blocks} ${full_cr_blocks} ${full_pr_blocks}' # all blocks but RPV
  []
  [heat_ie] # time term in heat conduction equation, no need for Steady-state
    type = HeatConductionTimeDerivative
    variable = Tsolid
    block = '${rpv_blocks}'
  []
  [aniso_heat_ie] # time term in heat conduction equation, no need for Steady-state
    type = HeatConductionTimeDerivative
    variable = Tsolid
    block = '${full_fuel_blocks} ${full_cr_blocks} ${full_pr_blocks}' # all blocks but RPV
    specific_heat = aniso_specific_heat
  []

  # conductance kernels (homogenized conduction + radiation through block-sleeve gap)
  [heat_loss_conductance_active_fuel]
    type = Removal
    variable = Tsolid
    block = '${fuel_blocks_31pin} ${fuel_blocks_33pin}'
    sigr = gap_conductance_mat
  []
  [heat_gain_conductance_active_fuel]
    type = MatCoupledForce
    variable = Tsolid
    v = inner_Twall
    block = '${fuel_blocks_31pin} ${fuel_blocks_33pin}'
    material_properties = gap_conductance_mat
  []

  # convection kernels (homogenized convection extracted by fuel and CR cooling channels)
  [heat_loss_convection_outer]
    type = Removal
    variable = Tsolid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    sigr = Hw_outer_homo_mat
  []
  [heat_gain_convection_outer]
    type = MatCoupledForce
    variable = Tsolid
    v = Tfluid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    material_properties = Hw_outer_homo_mat
  []
[]

[BCs]
  # for now, do not use BC out of the core to not lose heat (most of it should go back in the core since it pre-cools the helium)

  [RPV_in_BC] # FIXME: this BC adds energy to the RPV that is not removed from the fluid! (but only ~40kW for 9MW so about 0.6K error on the inlet fluid temperature)
    type = ConvectiveFluxFunction # (Robin BC)
    variable = Tsolid
    boundary = '200' # inner RPV
    coefficient = 30.7 # calculated value for 9MW forced convection # old value: 1e2 W/K/m^2 - arbitrary value
    T_infinity = T_init
  []
  [RPV_out_BC] # k \nabla T = h (T- T_inf) at RPV outer boundary
    type = ConvectiveFluxFunction # (Robin BC)
    variable = Tsolid
    boundary = '100' # outer RPV
    coefficient = 2.58 # calculated value for natural convection following NRC report method
    T_infinity = T_outside # matches Figure 13 value concrete shield
  []
  [radiative_BC] # radiation from RPV to bio shield
    type = InfiniteCylinderRadiativeBC
    boundary = '100' # outer RPV
    variable = Tsolid
    boundary_radius = ${rpv_outer_radius}
    boundary_emissivity = ${rpv_emissivity}
    cylinder_radius = ${vcs_radius}
    cylinder_emissivity = ${vcs_emissivity} # matching NRC value, 0.79 for inner RPV
    Tinfinity = T_outside # matches Figure 13 value concrete shield
  []
[]

[ThermalContact]
  [RPV_gap]
    type = GapHeatTransfer
    gap_geometry_type = 'CYLINDER'
    emissivity_primary = 0.8
    emissivity_secondary = 0.8 # varies from 0.6 to 1.0 in RPV paper, 0.79 in NRC paper
    variable = Tsolid # graphite -> rpv gap
    primary = '200'
    secondary = '1'
    gap_conductivity = 0.2091 # for He at 453K, 2.8 MPa
    quadrature = true
    cylinder_axis_point_1 = '0 0 0'
    cylinder_axis_point_2 = '5.22 0 0'
  []
[]

[AuxVariables]
  [power_density]
    block = '${fuel_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [scaled_initial_power_density] # necessary for the transient to make the decay heat proportional to the initial power
    block = '${fuel_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [decay_heat_power_density]
    block = '${fuel_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [heat_source_tot]
    block = '${fuel_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [Tfuel] # fuel temperature to transfer back to Griffin
    order = CONSTANT
    family = MONOMIAL
  []
  [Tsleeve] # sleeve temperature from BISON (only for fueled blocks)
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod] # moderator temperature: xi * Tsleeve + (1 - xi) * Tsolid (in the fuel blocks), Tsolid otherwise
    block = '${fuel_blocks} ${rr_fuel_blocks_33pin} ${rr_fuel_blocks_31pin} ${full_cr_blocks} ${full_pr_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [inner_Twall] # wall temperature (fuel side) from BISON to RELAP-7
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Tfluid] # fluid temperature from RELAP-7
    order = CONSTANT
    family = MONOMIAL
  []
  [average_axial_tsolid]
    block = '${full_fuel_blocks}' #' ${full_cr_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Tinit_var]
    block = '${rpv_blocks}'
  []
  [T_inf_outside]
    block = '${rpv_blocks}'
  []
  [RPV_convection_removal]
    block = '${rpv_blocks}'
  []
  [layered_averaged_power_density]
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [heat_balance]
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    order = FIRST
    family = L2_LAGRANGE
  []
  [gap_conductance] # homogenized gap conductance for the inner radius of fuel cooling channels [W/K/m^3]
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Hw_inner] # heat transfer coefficient for the inner radius of fuel cooling channels [W/K/m^2] (not homogenized because only meant to be transferred to BISON)
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Hw_outer] # heat transfer coefficient for the inner radius of fuel cooling channels [W/K/m^2] (not homogenized because only meant to be transferred to BISON)
    block = '${full_fuel_blocks}' # No need to include the CR blocks because only meant to be transferred to BISON for a homogeneous full-core heat transfer model
    order = CONSTANT
    family = MONOMIAL
  []
  [Hw_outer_homo] # homogenized heat transfer coefficient for the outer radius of cooling channels [W/K/m^3]
    # Homogenization performed in the RELAP inputs  because scaling depends on the number of pins
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [assign_initial_power_density]
    type = NormalizationAux
    block = '${fuel_blocks}'
    variable = scaled_initial_power_density
    source_variable = power_density
    normalization = ptot
    execute_on = 'initial'
  []
  [assign_decay_heat_power_density]
    type = ScaleAux
    block = '${fuel_blocks}'
    variable = decay_heat_power_density
    source_variable = scaled_initial_power_density
    multiplying_pp = decay_heat_pp
    execute_on = 'initial timestep_begin timestep_end'
  []
  [assign_heat_source_tot]
    type = ParsedAux
    block = '${fuel_blocks}'
    variable = heat_source_tot
    expression = 'power_density + decay_heat_power_density'
    coupled_variables = 'power_density decay_heat_power_density'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [assign_T_inf_outside] # needs to be time dependent for the case without VCS
    type = FunctionAux
    block = '${rpv_blocks}'
    variable = T_inf_outside
    function = T_outside
    execute_on = 'initial timestep_begin timestep_end'
  []
  [assign_average_axial_tsolid]
    type = SpatialUserObjectAux
    variable = average_axial_tsolid
    user_object = average_axial_temperature_UO
    block = '${full_fuel_blocks}' #' ${full_cr_blocks}'
    execute_on = 'timestep_end'
  []
  [assign_layered_averaged_power_density]
    type = SpatialUserObjectAux
    variable = layered_averaged_power_density
    user_object = average_power_UO
    block = '${fuel_blocks}'
    execute_on = 'timestep_end'
  []

  [heat_balance_active_fuel]
    type = ParsedAux
    variable = heat_balance
    block = '${fuel_blocks}'
    expression = 'gap_conductance * (inner_Twall - Tsolid) + Hw_outer_homo * (Tfluid - Tsolid)'
    coupled_variables = 'gap_conductance inner_Twall Tsolid Hw_outer_homo Tfluid'
  []
  [heat_balance_convection_rr_cr]
    type = ParsedAux
    variable = heat_balance
    block = '${rr_fuel_blocks_31pin} ${rr_fuel_blocks_33pin} ${full_cr_blocks}'
    expression = 'Hw_outer_homo * (Tfluid - Tsolid)'
    coupled_variables = 'Hw_outer_homo Tfluid Tsolid'
  []

  [RPV_convection_removal_aux]
    type = ParsedAux
    variable = RPV_convection_removal
    block = '${rpv_blocks}'
    expression = '${stefan_boltzmann_constant} * ${rpv_emissivity} * ${vcs_emissivity} * ${vcs_radius} / (${vcs_emissivity} * ${vcs_radius} + ${rpv_emissivity} * ${rpv_outer_radius} * (1 - ${vcs_emissivity})) * (pow(Tsolid, 4) - pow(T_inf_outside,4))'
    coupled_variables = 'T_inf_outside Tsolid'
  []

  [assign_Tmod_fuelblocks31]
    type = ParsedAux
    variable = Tmod
    block = '${fuel_blocks_31pin}'
    expression = '${xi31} * Tsleeve + (1 - ${xi31}) * Tsolid'
    coupled_variables = 'Tsleeve Tsolid'
    execute_on = 'timestep_end'
  []
  [assign_Tmod_fuelblocks33]
    type = ParsedAux
    variable = Tmod
    block = '${fuel_blocks_33pin}'
    expression = '${xi33} * Tsleeve + (1 - ${xi33}) * Tsolid'
    coupled_variables = 'Tsleeve Tsolid'
    execute_on = 'timestep_end'
  []
  [assign_Tmod_elsewhere]
    type = ParsedAux
    variable = Tmod
    block = ' ${rr_fuel_blocks_33pin} ${rr_fuel_blocks_31pin} ${full_cr_blocks} ${full_pr_blocks}'
    expression = 'Tsolid'
    coupled_variables = 'Tsolid'
    execute_on = 'timestep_end'
  []
[]

[UserObjects]
  [average_power_UO]
    type = NearestPointLayeredAverage
    block = '${fuel_blocks}'
    variable = heat_source_tot
    direction = x
    points_file = '../mesh/centers_fuel_blocks.txt' # fuel column centers
    bounds = '1.16 1.74 2.32 2.90 3.48 4.06' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_Tsolid_UO]
    type = NearestPointLayeredAverage
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    variable = Tsolid
    direction = x
    points_file = '../mesh/centers_relap.txt' # fuel and CR column centers
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_inner_Twall_UO]
    type = NearestPointLayeredAverage
    block = '${fuel_blocks}'
    variable = inner_Twall
    direction = x
    points_file = '../mesh/centers_fuel_blocks.txt' # fuel and CR column centers
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_htc_inner_UO]
    type = NearestPointLayeredAverage
    block = '${fuel_blocks}'
    variable = Hw_inner
    direction = x
    points_file = '../mesh/centers_fuel_blocks.txt' # fuel and CR column centers
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_htc_outer_UO]
    type = NearestPointLayeredAverage
    block = '${full_fuel_blocks}'
    variable = Hw_outer
    direction = x
    points_file = '../mesh/centers_fuel_blocks.txt' # fuel and CR column centers
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_Tfluid_UO]
    type = NearestPointLayeredAverage
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    variable = Tfluid
    direction = x
    points_file = '../mesh/centers_relap.txt' # fuel and CR column centers
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_begin timestep_end'
  []
  [average_axial_temperature_UO] # for postprocessing only (e.g. to get an idea of the axial average temperature)
    type = LayeredAverage
    block = '${full_fuel_blocks}' #' ${full_cr_blocks}'
    variable = Tsolid
    direction = x
    bounds = '0 0.145 0.29 0.435 0.58 0.725 0.87 1.015 1.16 1.305 1.45 1.595 1.74 1.885 2.03 2.175 2.32 2.465 2.61 2.755 2.9 3.045 3.19 3.335 3.48 3.625 3.77 3.915 4.06 4.205 4.35 4.495 4.64 4.785 4.93 5.075 5.22' # for 36 axial elements
    execute_on = 'timestep_begin timestep_end'
  []
[]

[Materials]
  [graphite_moderator]
    type = AnisoHeatConductionMaterial
    block = '${full_fuel_blocks} ${full_cr_blocks} ${full_pr_blocks}' # all blocks but RPV
    temperature = Tsolid
    base_name = 'aniso'
    reference_temperature = 0.0
    thermal_conductivity_temperature_coefficient_function = IG110_k
    thermal_conductivity = '1    0    0
                            0 0.54    0
                            0    0 0.54' # isotropic for testing only, otherwise one in the x-direction
    specific_heat = IG110_cp
  []
  # The base graphite densities come from table 1.27 of the NEA/NSC/DOC(2006)1 report and are then corrected with the volume fraction of graphite in each block
  [graphite_density_fuel33]
    type = Density
    block = '${fuel_blocks_33pin}'
    density = '${fparse 1770 * vol_frac_fuel33}'
  []
  [graphite_density_fuel31]
    type = Density
    block = '${fuel_blocks_31pin}'
    density = '${fparse 1770 * vol_frac_fuel31}'
  []
  [graphite_density_rr_fuel33]
    type = Density
    block = '${rr_fuel_blocks_33pin}'
    density = '${fparse 1760 * vol_frac_fuel33}'
  []
  [graphite_density_rr_fuel31]
    type = Density
    block = '${rr_fuel_blocks_31pin}'
    density = '${fparse 1760 * vol_frac_fuel31}'
  []
  [graphite_density_cr]
    type = Density
    block = '${full_cr_blocks}'
    density = '${fparse 1770 * vol_frac_cr}'
  []
  [graphite_density_rest]
    type = Density
    block = '${full_pr_blocks}'
    density = '${fparse 1760}' # In reality, the actual PR blocks are made of PGX graphite of density 1.732 g/cc but here we assume IG110 graphite for now.
  []
  [ss304_rpv]
    type = HeatConductionMaterial
    block = '${rpv_blocks}'
    thermal_conductivity_temperature_function = ssteel_304_k
    specific_heat = 500 # J/kg/K
    temp = Tsolid
  []
  [ss304_density]
    type = Density
    block = '${rpv_blocks}'
    density = 8000 # typical value for ss304 in kg/m^3
  []
  [gap_conductance_mat]
    type = Variable2Material
    block = '${fuel_blocks}'
    variables = 'gap_conductance'
    prop_names = 'gap_conductance_mat'
  []
  [Hw_outer_mat]
    type = Variable2Material
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    variables = Hw_outer_homo
    prop_names = Hw_outer_homo_mat
  []
[]

[Postprocessors]
  [Tsolid_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tsolid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tsolid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_fuel_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_fuel_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tsolid
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_fuel_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tsolid
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_pr_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = '${full_pr_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_pr_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tsolid
    block = '${full_pr_blocks}'
    execute_on = 'initial linear'
  []
  [Tsolid_pr_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tsolid
    block = '${full_pr_blocks}'
    execute_on = 'initial linear'
  []
  [Tfuel_avg]
    type = ElementAverageValue
    variable = Tfuel
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tfuel_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tfuel
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tfuel_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tfuel
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsleeve_avg]
    type = ElementAverageValue
    variable = Tsleeve
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsleeve_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tsleeve
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tsleeve_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tsleeve
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tmod_avg]
    type = ElementAverageValue
    variable = Tmod
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tmod_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tmod
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Tmod_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tmod
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [Trpv_avg]
    type = ElementAverageValue
    variable = Tsolid
    block = '${rpv_blocks}'
    execute_on = 'initial linear'
  []
  [Trpv_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tsolid
    block = '${rpv_blocks}'
    execute_on = 'initial linear'
  []
  [Trpv_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tsolid
    block = '${rpv_blocks}'
    execute_on = 'initial linear'
  []
  [ptot]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [ptot_decay]
    type = ElementIntegralVariablePostprocessor
    variable = decay_heat_power_density
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [decay_heat_pp]
    type = FunctionValuePostprocessor
    function = decay_heat_power_density_func
    execute_on = 'initial timestep_begin timestep_end'
  []
  [pdens_avg]
    type = ElementAverageValue
    variable = power_density
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [net_heat_src_avg]
    type = ElementAverageValue
    variable = heat_balance
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [net_heat_src_max]
    type = ElementExtremeValue
    value_type = max
    variable = heat_balance
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [net_heat_src_min]
    type = ElementExtremeValue
    value_type = min
    variable = heat_balance
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [net_heat_src_tot]
    type = ElementIntegralVariablePostprocessor
    variable = heat_balance
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [Tfluid_avg]
    type = ElementAverageValue
    variable = Tfluid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [Tfluid_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tfluid
    block = '${full_fuel_blocks} ${full_cr_blocks}'
    execute_on = 'initial linear'
  []
  [rpv_convective_in]
    type = ConvectiveHeatTransferSideIntegral
    T_solid = Tsolid
    boundary = '200'
    T_fluid_var = Tinit_var
    htc = 30.7 # calculated value for 9MW forced convection
  []
  [rpv_convective_out]
    type = ConvectiveHeatTransferSideIntegral
    T_solid = Tsolid
    boundary = '100'
    T_fluid_var = T_inf_outside
    htc = 2.58 # calculated value for natural convection following NRC report method
  []
  [rpv_radiative_out]
    type = SideIntegralVariablePostprocessor
    variable = RPV_convection_removal
    boundary = '100'
  []
  [bison_total_power]
    type = Receiver
  []
  [bison_total_bdy_heat_flux]
    type = Receiver
  []
  [Tfluid_out]
    type = Receiver
  []
  [delta_H]
    type = Receiver
  []
  [gap_cond_max]
    type = ElementExtremeValue
    value_type = max
    variable = gap_conductance
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
  [gap_cond_min]
    type = ElementExtremeValue
    value_type = min
    variable = gap_conductance
    block = '${fuel_blocks}'
    execute_on = 'initial linear'
  []
[]

[Executioner]
  type = Transient
  automatic_scaling = true
  compute_scaling_once = false
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  start_time = 0
  end_time = 50
  dt = 10

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
  fixed_point_rel_tol = 1e-3
  fixed_point_abs_tol = 1e-7

  line_search = none # default seems bad for convergence
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    positions_file = '../mesh/centers_relap_33pins.txt
                      ../mesh/centers_relap_31pins.txt'
    input_files = 'fuel_elem_null.i'
    cli_args = 'npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33
                npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31'
    execute_on = 'timestep_begin'
    output_in_position = true
  []
  [relap]
    type = TransientMultiApp
    positions_file = '../mesh/centers_relap_33pins.txt
                      ../mesh/centers_relap_31pins.txt
                      ../mesh/centers_relap_CR.txt'

    # the first 12 positions are fuel with 33 pins, the next 18 are fuel with 31 pins, the last 16 are CR
    input_files = 'thermal_hydraulics_fuel_pins_null.i
                   thermal_hydraulics_fuel_pins_null.i
                   thermal_hydraulics_CR_null.i'

    cli_args = 'npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33 npins=33
                npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31 npins=31
                npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2  npins=2'

    execute_on = 'timestep_end'
    max_procs_per_app = 1
    sub_cycling = true
  []
[]

[Transfers]
  [pdens_to_bison]
    type = MultiAppUserObjectTransfer
    to_multi_app = bison
    user_object = average_power_UO
    variable = power_density
  []
  [tmod_to_bison]
    type = MultiAppUserObjectTransfer
    to_multi_app = bison
    user_object = average_Tsolid_UO
    variable = Tmod
  []
  [tfluid_to_bison]
    type = MultiAppInterpolationTransfer
    to_multi_app = bison
    source_variable = Tfluid
    variable = Tfluid
  []
  [htc_inner_to_bison]
    type = MultiAppInterpolationTransfer
    to_multi_app = bison
    source_variable = Hw_inner
    variable = Hw_inner
  []
  [htc_outer_to_bison]
    type = MultiAppInterpolationTransfer
    to_multi_app = bison
    source_variable = Hw_outer
    variable = Hw_outer
  []
  [inner_twall_to_relap]
    type = MultiAppInterpolationTransfer
    to_multi_app = relap
    source_variable = inner_Twall
    variable = T_wall:1
  []
  [tmod_to_relap]
    type = MultiAppUserObjectTransfer
    to_multi_app = relap
    user_object = average_Tsolid_UO
    variable = T_wall:2
  []
  [tmod_to_relap_topbottom]
    type = MultiAppUserObjectTransfer
    to_multi_app = relap
    user_object = average_Tsolid_UO
    variable = T_wall
  []
  [tfuel_from_bison]
    type = MultiAppUserObjectTransfer
    from_multi_app = bison
    user_object = average_Tfuel_UO
    variable = Tfuel
    nearest_sub_app = true
  []
  [tsleeve_from_bison]
    type = MultiAppUserObjectTransfer
    from_multi_app = bison
    user_object = average_Tsleeve_UO
    variable = Tsleeve
    nearest_sub_app = true
  []
  [twall_from_bison]
    type = MultiAppUserObjectTransfer
    from_multi_app = bison
    user_object = inner_wall_temp_UO
    variable = inner_Twall
    nearest_sub_app = true
  []
  [heat_source_from_bison]
    type = MultiAppUserObjectTransfer
    from_multi_app = bison
    user_object = gap_conductance_UO
    variable = gap_conductance
    nearest_sub_app = true
  []
  [total_power_from_bison]
    type = MultiAppPostprocessorTransfer
    from_multi_app = bison
    from_postprocessor = 'fuel_block_total_power'
    to_postprocessor = 'bison_total_power'
    reduction_type = sum
  []
  [bison_heat_flux]
    type = MultiAppPostprocessorTransfer
    from_multi_app = bison
    from_postprocessor = 'bdy_heat_flux_tot'
    to_postprocessor = 'bison_total_bdy_heat_flux'
    reduction_type = sum
  []
  [tfluid_from_relap]
    type = MultiAppUserObjectTransfer
    from_multi_app = relap
    variable = Tfluid
    user_object = avg_Tfluid_UO
    nearest_sub_app = true
  []
  [hw_inner_from_relap]
    type = MultiAppUserObjectTransfer
    from_multi_app = relap
    variable = Hw_inner
    user_object = avg_Hw_inner_UO
    nearest_sub_app = true
  []
  [hw_outer_from_relap]
    type = MultiAppUserObjectTransfer
    from_multi_app = relap
    variable = Hw_outer
    user_object = avg_Hw_outer_UO
    nearest_sub_app = true
  []
  [hw_outer_homo_from_relap]
    type = MultiAppUserObjectTransfer
    from_multi_app = relap
    variable = Hw_outer_homo
    user_object = avg_Hw_outer_homo_UO
    nearest_sub_app = true
  []
  [tout_from_relap]
    type = MultiAppPostprocessorTransfer
    from_multi_app = relap
    from_postprocessor = Tout_weighted
    to_postprocessor = Tfluid_out
    reduction_type = sum
  []
  [deltaH_from_relap]
    type = MultiAppPostprocessorTransfer
    from_multi_app = relap
    from_postprocessor = delta_H
    to_postprocessor = delta_H
    reduction_type = sum
  []
[]

[Outputs]
  [exodus]
    type = Exodus
    overwrite = true
  []
  csv = true
[]
