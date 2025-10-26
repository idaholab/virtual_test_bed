# ==============================================================================
# Fuel element heat transfer model (steady-state)
# Application: BISON (Sabertooth with child applications)
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 2023
# Author(s): Vincent Laboure
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

fuel_blocks = '1'
sleeve_blocks = '2'
mod_blocks = '4'

h = 0.577 # height of a block in m
p = 0.36 # hexagonal pitch in m
Sblock = '${fparse 0.5 * sqrt(3) * p * p}' # Cross-section area of the hexagonal block in m^2
Vblock = '${fparse h * Sblock}' # volume of a block in m^3

npins = 31 # number of fuel channels in the current block
h_fuel = '${fparse 0.56 - 0.014}' # height of a fuel pin in m
inner_radius = 0.005 # inner radius of a fuel pin in m
outer_radius = 0.013 # outer radius of a fuel pin in m
Vfuel = '${fparse npins * h_fuel * pi * (outer_radius * outer_radius - inner_radius * inner_radius)}' # volume of fuel compacts in a block

multiplier = '${fparse Vblock / Vfuel}' # multiplier to obtain the scaled power density. Roughly 8.0 for 33 pins, 8.5 for 31 pins [units = none]

sleeve_outer_radius = 0.017 # outer radius of the sleeve in m
inner_outer_radius = 0.0205 # outer radius of the mesh in m

htc_homo_scaling = '${fparse 2 * pi * inner_outer_radius * npins / Sblock}'

# x1 = 4.06 # m - bottom of active fuel region
# x2 = 1.16 # m - top of active fuel region
Tinlet = 453.15 # fluid inlet temperature
Toutlet = 593.15 # (expected) fluid outlet temperature

stefan_boltzmann_constant = 5.670367e-8
eps1 = 0.8
eps2 = 0.8
cond = 0.2309 # He at 523K, 2.8MPa

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/fuel_element/HTTR_fuel_pin_2D_refined_m_5pins_axialref.e'
  []
  uniform_refine = 0 # do not modify if using ThermalContact
  coord_type = RZ
  rz_coord_axis = X
[]

[Variables]
  [temp]
  []
[]

[ICs]
  [fuel_ic]
    type = FunctionIC
    variable = temp
    block = '${fuel_blocks}'
    function = Tsolid_init_func
  []
  [mod_ic]
    type = FunctionIC
    variable = temp
    block = '${sleeve_blocks} ${mod_blocks}'
    function = Tsolid_init_func
  []
  [Tfluid_ic]
    type = FunctionIC
    variable = Tfluid
    function = Tsolid_init_func
  []
[]

[AuxVariables]
  [power_density]
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [scaled_power_density]
    block = '${fuel_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 525
  []
  [Tfluid] # fluid temperature from RELAP-7
    order = CONSTANT
    family = MONOMIAL
  []
  [Tfuel] # Tfuel variable for XS interpolation, no longer includes the sleeve!
    block = '${fuel_blocks}'
  []
  [Tsleeve] # Tsleeve variable for XS interpolation (weighted summation with graphite block temperature)
    block = '${sleeve_blocks}'
  []
  [inner_Twall]
    block = '${fuel_blocks} ${sleeve_blocks}'
    order = CONSTANT
    family = MONOMIAL
  []
  [bdy_heat_flux_aux]
    order = FIRST # not CONSTANT MONOMIAL! (or weird effects when evaluating the boundary integral) but has to be discontinuous
    family = L2_LAGRANGE
  []
  [bdy_heat_flux_layered_integral]
    order = CONSTANT
    family = MONOMIAL
  []
  [gap_conductance]
    block = '${fuel_blocks} ${sleeve_blocks}' # because we only want it defined over the active fuel region for proper averaging (won't change radially)
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 4e3
  []
  [Hw_inner] # heat transfer coefficient for the inner radius of fuel cooling channels [W/K/m^2]
    block = '${fuel_blocks} ${sleeve_blocks}' # because we only want it defined over the active fuel region for proper averaging (won't change radially)
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 500
  []
  [Hw_outer] # heat transfer coefficient for the outer radius of fuel cooling channels [W/K/m^2]
    block = '${mod_blocks} ${fuel_blocks} ${sleeve_blocks}' # also define on fuel pins because needed for equivalent gap conductance
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 500
  []
[]

[Kernels]
  [heat]
    type = HeatConduction
    variable = temp
  []
  # [heat_ie] # omit to speed up steady state convergence
  #   type = HeatConductionTimeDerivative
  #   variable = temp
  # []
  [heat_source]
    type = CoupledForce
    variable = temp
    block = '${fuel_blocks}'
    v = scaled_power_density
  []
[]

[AuxKernels]
  [GetPowerDensity]
    type = ScaleAux
    variable = scaled_power_density
    source_variable = power_density
    multiplier = ${multiplier}
  []
  [setTfuel]
    type = CoupledAux
    variable = Tfuel
    coupled = temp
    block = '${fuel_blocks}'
  []
  [setTsleeve]
    type = CoupledAux
    variable = Tsleeve
    coupled = temp
    block = '${sleeve_blocks}'
  []
  [set_inner_Twall]
    type = SpatialUserObjectAux
    variable = inner_Twall
    user_object = inner_wall_temp_UO
    block = '${fuel_blocks} ${sleeve_blocks}'
    execute_on = 'nonlinear timestep_end'
  []
  [set_bdy_heat_flux_aux]
    type = ParsedAux
    variable = bdy_heat_flux_aux
    block = '${mod_blocks}'
    expression = '1e5 * (temp - Tmod)'
    coupled_variables = 'temp Tmod'
    execute_on = 'nonlinear timestep_end'
  []
  [set_bdy_heat_flux_layered_integral]
    type = SpatialUserObjectAux
    variable = bdy_heat_flux_layered_integral
    user_object = bdy_heat_flux_UO
    # block = '${mod_blocks}'
    execute_on = 'nonlinear timestep_end'
  []
  [set_gap_conductance]
    type = ParsedAux
    variable = gap_conductance
    block = '${fuel_blocks} ${sleeve_blocks}' # because we only want it defined over the active fuel region for proper averaging (won't change radially)
    expression = '(${cond} / ${inner_outer_radius} / log(${inner_outer_radius} / ${sleeve_outer_radius}) + ${stefan_boltzmann_constant} * (inner_Twall * inner_Twall + Tmod * Tmod) * (inner_Twall + Tmod) / (1 / ${eps1} + 1 / ${eps2} - 1) * 0.5 * (${inner_outer_radius} + ${sleeve_outer_radius}) / ${inner_outer_radius}) * ${htc_homo_scaling}'
    coupled_variables = 'Tmod inner_Twall'
    execute_on = 'nonlinear timestep_end'
  []
[]

[ThermalContact]
  [gap_top]
    type = GapHeatTransfer
    gap_geometry_type = 'PLATE'
    emissivity_primary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    emissivity_secondary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    # coarser side should be primary
    # (in theory using quadrature = true should make it independent but other errors appear and not exactly conservative)
    primary = Sleeve_top
    secondary = Fuel_top
    gap_conductivity = 0.2735 # He at 668K, 2.8 MPa - Original: 1e-5 W/m/K, Shi PhD: 0.35 (but no gap on the inside)
    variable = temp
    quadrature = true
  []

  [gap_side]
    type = GapHeatTransfer
    gap_geometry_type = 'CYLINDER'
    emissivity_primary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    emissivity_secondary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    primary = Sleeve_side
    secondary = Fuel_side
    gap_conductivity = 0.2735 # He at 668K, 2.8 MPa - Original: 1e-5 W/m/K, Shi PhD: 0.35 (but no gap on the inside)
    variable = temp
    quadrature = true
  []

  # only use during transient (numerical issues during steady-state and amount of energy through gap should be very small in steady-state)
  [cooling_channel]
    type = GapHeatTransfer
    gap_geometry_type = 'CYLINDER'
    emissivity_primary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    emissivity_secondary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    primary = Inner_outer_ring
    secondary = Relap7_Tw
    gap_conductivity = 0.2309 # He at 523K, 2.8MPa
    variable = temp
    quadrature = true
  []
[]

[BCs]
  [Neumann]
    type = NeumannBC
    variable = temp
    value = 0.0
    boundary = 'Neumann Sleeve_bot'
  []

  [outside_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temp
    boundary = 'Outer_outer_ring'
    T_infinity = Tmod
    htc = 1e5
  []

  # For RELAP-7
  [convective_inner]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'Relap7_Tw'
    variable = temp
    T_infinity = Tfluid
    htc = Hw_inner
  []
  [convective_outer]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'Inner_outer_ring'
    variable = temp
    T_infinity = Tfluid
    htc = Hw_outer
  []
[]

[Functions]
  [Tsolid_init_func] # initial guess for moderator/fluid temperature
    type = ParsedFunction
    expression = '${Tinlet} + (5.22 - x) * (${Toutlet} - ${Tinlet}) / 5.22'
    # value = 'if(x < ${x2}, ${Toutlet},
    #          if(x > ${x1}, ${Tinlet},
    #                       (${Tinlet} - ${Toutlet}) * (x - ${x2}) / (${x1} - ${x2}) + ${Toutlet}))'
  []
  # Functions for the compact k and Cp (and rho) are obtained using the tpmain Fortran script with a packing fraction of 0.3, burnup = 0, fluence = 0
  # FIXME: recompute with real burnup and fluence
  [compact_k]
    type = ParsedFunction
    symbol_values = '-4.438e-09 2.569e-05 -5.186e-02 5.111e+01' # [W/m/K]
    symbol_names = 'a3         a2         a1        a0'
    expression = 'a0 + a1 * t + a2 * t * t + a3 * t * t * t'
  []
  [compact_cp] # assumed to be the same as for H-451 graphite, taken from MHTGR-350-Appendices.r0.pdf
    type = ParsedFunction
    symbol_values = '-2.408e-10 1.468e-06 -3.379e-03 3.654e+00 -2.875e+02' # [J/kg/K]
    symbol_names = 'a4         a3        a2         a1        a0'
    expression = 'a0 + a1 * t + a2 * t * t + a3 * t * t * t + a4 * t * t * t * t'
  []
  [IG110_k]
    type = ParsedFunction
    symbol_values = '6.632e+01 -4.994e-02 1.712e-05' # [W/m/K]
    symbol_names = 'a0        a1         a2'
    expression = 'a0 + a1 * t + a2 * t * t'
  []
  [IG110_cp] # assumed to be the same as for H-451 graphite, taken from MHTGR-350-Appendices.r0.pdf
    type = ParsedFunction
    symbol_values = '0.54212 -2.42667e-6 -90.2725 -43449.3 1.59309e7 -1.43688e9 4184' # [J/kg/K]
    symbol_names = 'a0     a1          a2       a3       a4        a5         b'
    expression = 'if(t < 300, 712.76, (a0 + a1 * t + a2 / t + a3 / t / t + a4 / t / t / t + a5 / t / t / t / t) * b)'
  []
[]

[Materials]
  [Fuel_compact]
    type = HeatConductionMaterial
    block = '${fuel_blocks}'
    temp = temp
    thermal_conductivity_temperature_function = compact_k
    specific_heat_temperature_function = compact_cp
  []
  [Fuel_sleeve]
    type = HeatConductionMaterial
    block = '${sleeve_blocks} ${mod_blocks}'
    temp = temp
    thermal_conductivity_temperature_function = IG110_k
    specific_heat_temperature_function = IG110_cp
  []
  [Fuel_compact_density]
    type = Density
    block = '${fuel_blocks}'
    density = 2573 # kg/m^3 - obtained using the tpmain Fortran script with a packing fraction of 0.3
  []
  [Fuel_sleeve_density]
    type = Density
    block = '${sleeve_blocks} ${mod_blocks}'
    density = 1770 # kg/m^3 - comes from table 1.27 of the NEA/NSC/DOC(2006)1 report
  []
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'

  start_time = 0
  end_time = 5e6
  timestep_tolerance = 1e-4
  #
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
  []
[]

[UserObjects]
  [inner_wall_temp_UO]
    type = LayeredSideAverage
    boundary = 'Relap7_Tw'
    variable = temp
    direction = x
    bounds = '1.16 1.74 2.32 2.9 3.48 4.06' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
  [bdy_heat_flux_UO]
    type = LayeredSideIntegral
    boundary = 'Outer_outer_ring'
    variable = bdy_heat_flux_aux
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.9 3.48 4.06 4.64 5.22' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
  [gap_conductance_UO]
    type = LayeredAverage
    block = '${fuel_blocks} ${sleeve_blocks}'
    variable = gap_conductance
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.9 3.48 4.06 4.64 5.22' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
  [average_Tfuel_UO]
    type = LayeredAverage
    block = '${fuel_blocks}'
    variable = Tfuel
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.9 3.48 4.06 4.64 5.22' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
  [average_Tsleeve_UO]
    type = LayeredAverage
    block = '${sleeve_blocks}'
    variable = Tsleeve
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.9 3.48 4.06 4.64 5.22' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
[]

[Postprocessors]
  [fuel_k_average]
    type = ElementAverageMaterialProperty
    block = '${fuel_blocks}'
    mat_prop = 'thermal_conductivity'
  []
  [graphite_k_average]
    type = ElementAverageMaterialProperty
    block = '${sleeve_blocks} ${mod_blocks}'
    mat_prop = 'thermal_conductivity'
  []
  [TotalPower]
    type = ElementIntegralVariablePostprocessor
    block = '${fuel_blocks}'
    variable = scaled_power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_block_total_power]
    type = ParsedPostprocessor
    expression = '${npins} * TotalPower'
    pp_names = 'TotalPower'
    execute_on = 'initial timestep_end'
  []
  [avg_homo_gap_conductance]
    type = ElementAverageValue
    variable = gap_conductance
    block = '${fuel_blocks} ${sleeve_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_gap_conductance]
    type = ParsedPostprocessor
    expression = 'avg_homo_gap_conductance / ${htc_homo_scaling}'
    pp_names = 'avg_homo_gap_conductance'
    execute_on = 'initial timestep_end'
  []
  [avg_htc_inner]
    type = ElementAverageValue
    variable = Hw_inner
    block = '${fuel_blocks} ${sleeve_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_htc_outer]
    type = ElementAverageValue
    variable = Hw_outer
    block = '${mod_blocks}' #  True average should be computed on mod_blocks to avoid bias towards active fuel regions
    execute_on = 'initial timestep_end'
  []
  [avg_Tfuel]
    type = ElementAverageValue
    variable = temp
    block = '${fuel_blocks}'
    execute_on = 'initial timestep_end'
  []
  [max_Tfuel]
    type = ElementExtremeValue
    variable = temp
    value_type = max
    block = '${fuel_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_Tsleeve]
    type = ElementAverageValue
    variable = temp
    block = '${sleeve_blocks}'
    execute_on = 'initial timestep_end'
  []
  [max_Tsleeve]
    type = ElementExtremeValue
    variable = temp
    value_type = max
    block = '${sleeve_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_scaled_pdensity]
    type = ElementAverageValue
    variable = scaled_power_density
    block = '${fuel_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_pdensity]
    type = ElementAverageValue
    variable = power_density
    block = '${fuel_blocks}'
    execute_on = 'initial timestep_end'
  []
  [avg_Twall]
    type = SideAverageValue
    variable = temp
    boundary = Relap7_Tw
    execute_on = 'initial timestep_end'
  []
  [avg_Tfluid]
    type = ElementAverageValue
    variable = Tfluid
    execute_on = 'initial timestep_end'
  []
  [avg_Tmod]
    type = ElementAverageValue
    variable = Tmod
    execute_on = 'initial timestep_end'
  []
  [convection_sleeve_fluid]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = Tfluid
    htc_var = Hw_outer
    T_solid = temp
    boundary = 'Inner_outer_ring'
  []
  [convection_mod_fluid]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = Tfluid
    htc_var = Hw_inner
    T_solid = temp
    boundary = 'Relap7_Tw'
  []
  [bdy_heat_flux]
    type = ConvectiveHeatTransferSideIntegral
    boundary = 'Outer_outer_ring'
    T_solid = temp
    T_fluid_var = Tmod
    htc = 1e5
  []
  [bdy_heat_flux_tot]
    type = ParsedPostprocessor
    expression = '${npins} * bdy_heat_flux'
    pp_names = 'bdy_heat_flux'
  []
[]

[Outputs]
  csv = true
[]
