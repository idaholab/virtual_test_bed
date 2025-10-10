# ==============================================================================
# Full-core homogenized neutronics model (steady-state)
# Application: Griffin (Sabertooth with child applications)
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

# Block IDs of fuel regions (to be SPH corrected)
fuel_blocks = '
1055 1056 1057 1058 1059 1060 1061 1062 1063 1064
1155 1156 1157 1158 1159 1160 1161 1162 1163 1164
1255 1256 1257 1258 1259 1260 1261 1262 1263 1264
1355 1356 1357 1358 1359 1360 1361 1362 1363 1364
'

# Block IDs of non-fuel (CR, RR, I) stack regions to be SPH corrected (active core + one layer of axial reflector on top and bottom)
sph_nonfuel_blocks = '
1054                                                   1065
1154                                                   1165
1254                                                   1265
1354                                                   1365
1454 1455 1456 1457 1458 1459 1460 1461 1462 1463 1464 1465
2054 2055 2056 2057 2058 2059 2060 2061 2062 2063 2064 2065
2154 2155 2156 2157 2158 2159 2160 2161 2162 2163 2164 2165
2174 2175 2176 2177 2178 2179 2180 2181 2182 2183 2184 2185
2254 2255 2256 2257 2258 2259 2260 2261 2262 2263 2264 2265
2354 2355 2356 2357 2358 2359 2360 2361 2362 2363 2364 2365
2454 2455 2456 2457 2458 2459 2460 2461 2462 2463 2464 2465
'

# Block IDs of the part of the axial reflector to not be SPH corrected (3 layers on top and bottom)
axial_reflector_blocks = '
1051 1052 1053 1066 1067 1068 2051 2052 2053 2066 2067 2068
1151 1152 1153 1166 1167 1168 2151 2152 2153 2166 2167 2168 2171 2172 2173 2186 2187 2188
1251 1252 1253 1266 1267 1268 2251 2252 2253 2266 2267 2268
1351 1352 1353 1366 1367 1368 2351 2352 2353 2366 2367 2368
1451 1452 1453 1466 1467 1468 2451 2452 2453 2466 2467 2468
'

# Block IDs of the permanent reflector (PR)
radial_reflector_blocks = '
1551 1552 1553 1554 1555 1556 1557 1558 1559 1560 1561 1562 1563 1564 1565 1566 1567 1568
'

x1 = 4.06 # m - bottom of active fuel region
x2 = 1.16 # m - top of active fuel region
Tinlet = 453.15 # fluid inlet temperature
Toutlet = 593.15 # (expected) fluid outlet temperature

initial_decay_heat = 5.7472e5 # decay heat for 9MW steady-state, in W
total_power = 9e6 # total power (including decay heat), in W
fission_power = '${fparse total_power - initial_decay_heat}'

extension = '_9MW'

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/full_core/full_core_HTTR.e'
    exodus_extra_element_integers = 'material_id equivalence_id'
  []
  # Restart relies on the ExodusII_IO functionality, which only works with ReplicatedMesh.
  parallel_type = replicated
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 10
  VacuumBoundary = '1 2 3'
  use_custom_bxnorm_for_eigenvalue = true

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
    assemble_delay_jacobian = true
  []
[]

[Equivalence]
  type = SPH
  transport_system = diff
  compute_factors = false
  equivalence_library = '../cross_sections/HTTR_5x5${extension}_equiv_corrected.xml'
  library_name = 'HTTR_5x5_equiv${extension}'

  equivalence_grid_names = 'Tfuel Tmod'
  equivalence_grid_variables = 'Tfuel Tmod'
  sph_block = '${fuel_blocks} ${sph_nonfuel_blocks}'
[]

[PowerDensity]
  power = ${fission_power}
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
  # activates poison tracking
  poison_tracking_chains = 'XE135'
[]

[GlobalParams]
  # for materials
  library_file = '../cross_sections/HTTR_5x5${extension}_profiled_VR_kappa_adjusted.xml'
  library_name = 'HTTR_5x5${extension}'
  isotopes = 'pseudo'
  densities = '1.0'
  is_meter = true
  grid_names = 'Tfuel Tmod'
  grid_variables = 'Tfuel Tmod'
  constant_on = ELEMENT
[]

[Materials]
  [fuel_sph]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '${fuel_blocks}'
    plus = true
  []
  [nonfuel_sph]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '${sph_nonfuel_blocks}'
  []
  [nonsph]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '${axial_reflector_blocks} ${radial_reflector_blocks}'
  []
[]

[AuxVariables]
  [Tfuel]
    initial_condition = 620
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod]
    # initial_condition = 700
    order = FIRST
    family = L2_LAGRANGE
  []
[]

[ICs]
  [Tmod_ic]
    type = FunctionIC
    variable = Tmod
    function = Tsolid_init_func
  []
[]

[Functions]
  [Tsolid_init_func] # initial guess for moderator temperature
    type = ParsedFunction
    # value = '${Tinlet} + (5.22 - x) * (${Toutlet} - ${Tinlet}) / 5.22'
    expression = 'if(x < ${x2}, ${Toutlet},
             if(x > ${x1}, ${Tinlet},
                          (${Tinlet} - ${Toutlet}) * (x - ${x2}) / (${x1} - ${x2}) + ${Toutlet}))'
  []
[]

[Postprocessors]
  [Tm_avg]
    type = ElementAverageValue
    variable = Tmod
    execute_on = 'initial timestep_end'
  []
  [Tf_avg]
    type = ElementAverageValue
    variable = Tfuel
    execute_on = 'initial timestep_end'
  []
  [Tm_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tmod
    execute_on = 'initial timestep_end'
  []
  [Tf_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tfuel
    execute_on = 'initial timestep_end'
  []
  [NI_avg]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 0
    block = '${fuel_blocks}'
  []
  [NXe_avg]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 1
    block = '${fuel_blocks}'
  []
[]

[UserObjects]
  [ss_temperatures]
    type = SolutionVectorFile
    var = 'Tfuel Tmod'
    writing = true
    execute_on = 'final'
  []
  [restart_poison_densities]
    type = SolutionVectorFile
    var = 'poison_tracking'
    writing = true
    execute_on = 'final'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    off_diag_row = '
                       sflux_g1
                       sflux_g2
                       sflux_g3
                       sflux_g4
                       sflux_g5 sflux_g5
                       sflux_g6 sflux_g6 sflux_g6 sflux_g6
                       sflux_g7 sflux_g7 sflux_g7
                       sflux_g8 sflux_g8 sflux_g8
                       sflux_g9
                      '
    off_diag_column = '
                       sflux_g0
                       sflux_g1
                       sflux_g2
                       sflux_g3
                       sflux_g4 sflux_g6
                       sflux_g5 sflux_g7 sflux_g8 sflux_g9
                       sflux_g6 sflux_g8 sflux_g9
                       sflux_g6 sflux_g7 sflux_g9
                       sflux_g8
                      '
  []
[]

[Executioner]
  type = Eigenvalue

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = none # default seems bad for convergence

  free_power_iterations = 2

  automatic_scaling = true
  nl_abs_tol = 1e-11
  nl_rel_tol = 1e-11
  l_tol = 1e-2

  fixed_point_rel_tol = 1e-7
  fixed_point_abs_tol = 5e-6 # may start stagnating below that tolerance (double check)
  fixed_point_max_its = 5 #10
  accept_on_max_fixed_point_iteration = true
  disable_fixed_point_residual_norm_check = false
[]

[MultiApps]
  [moose_modules]
    type = FullSolveMultiApp
    positions = '0 0 0'
    input_files = full_core_ht_steady.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true # to restart from the latest solve of the multiapp (for pseudo-transient)
  []
[]

[Transfers]
  [pdens_to_modules]
    type = MultiAppProjectionTransfer
    to_multi_app = moose_modules
    source_variable = power_density
    variable = power_density
    execute_on = 'timestep_end'
  []
  [tmod_from_modules]
    type = MultiAppProjectionTransfer
    from_multi_app = moose_modules
    source_variable = Tmod
    variable = Tmod
    execute_on = 'timestep_end'
  []
  [tfuel_from_modules]
    type = MultiAppProjectionTransfer
    from_multi_app = moose_modules
    source_variable = Tfuel
    variable = Tfuel
    execute_on = 'timestep_end'
  []
[]

[Outputs]
  file_base = neutronics_eigenvalue${extension}

  [exodus]
    type = Exodus
    overwrite = true
  []

  csv = true
  perf_graph = true
[]
