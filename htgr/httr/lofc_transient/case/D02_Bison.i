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

p = 0.36 # hexagonal pitch in m
Sblock = '${fparse 0.5 * sqrt(3) * p * p}' # Cross-section area of the hexagonal block in m^2

npins = 31 # number of fuel channels in the current block
h_fuel = '${fparse 0.56 - 0.014}' # height of a fuel pin in m
inner_radius = 0.005 # inner radius of a fuel pin in m
outer_radius = 0.013 # outer radius of a fuel pin in m
Vfuelpin = '${fparse h_fuel * pi * (outer_radius * outer_radius - inner_radius * inner_radius)}'

sleeve_outer_radius = 0.017 # outer radius of the sleeve in m
inner_outer_radius = 0.0205 # outer radius of the mesh in m

htc_homo_scaling = '${fparse 2 * pi * inner_outer_radius * npins / Sblock}'

Tinlet = 453.15 # fluid inlet temperature
Toutlet = 593.15 # (expected) fluid outlet temperature

stefan_boltzmann_constant = 5.670367e-8
eps1 = 0.8
eps2 = 0.8
cond = 0.2309 # He at 523K, 2.8MPa


 [Problem]
  restart_file_base = './A01b_Griffin_restarts_cp/LATEST'
 []

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../supporting_files/compact_mesh_in.e'
  []
  uniform_refine = 0 # do not modify if using ThermalContact
  coord_type = RZ
  rz_coord_axis = Y
[]

[Variables]
  [temp]
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
  []
  [Hw_inner] # heat transfer coefficient for the inner radius of fuel cooling channels [W/K/m^2]
    block = '${fuel_blocks} ${sleeve_blocks}' # because we only want it defined over the active fuel region for proper averaging (won't change radially)
    order = CONSTANT
    family = MONOMIAL
  []
  [Hw_outer] # heat transfer coefficient for the outer radius of fuel cooling channels [W/K/m^2]
    block = '${mod_blocks} ${fuel_blocks} ${sleeve_blocks}' # also define on fuel pins because needed for equivalent gap conductance
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Kernels]
  [heat]
    type = HeatConduction
    variable = temp
  []
  [heat_ie] # omit to speed up steady state convergence
    type = HeatConductionTimeDerivative
    variable = temp
  []
  [heat_source]
    type = CoupledForce
    variable = temp
    block = '${fuel_blocks}'
    v = scaled_power_density
  []
[]

[AuxKernels]
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
  [set_Tfluid]
    type = ParsedAux
    variable = Tfluid
    functor_names = 'avg_Tfluid'
    functor_symbols = 'avg_T'
    expression = 'avg_T'
  []
  [set_Tmod]
    type = ParsedAux
    variable = Tmod
    functor_names = 'avg_Tmod'
    functor_symbols = 'avg_T'
    expression = 'avg_T'
  []
  [set_Hw_inner]
    type = ParsedAux
    variable = Hw_inner
    functor_names = 'avg_htc'
    functor_symbols = 'avg_h'
    expression = 'avg_h'
  []
  [set_Hw_outer]
    type = ParsedAux
    variable = Hw_outer
    functor_names = 'avg_htc'
    functor_symbols = 'avg_h'
    expression = 'avg_h'
  []
  [set_pow_dens]
    type = ParsedAux
    variable = scaled_power_density
    functor_names = 'avg_pin_power'
    functor_symbols = 'avg_pow'
    expression = 'avg_pow/${Vfuelpin}'
  []
[]

[ThermalContact]
  [gap_top]
    type = GapHeatTransfer
    gap_geometry_type = 'PLATE'
    emissivity_primary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    emissivity_secondary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    primary = sleeve_top
    secondary = fuel_top
    gap_conductivity = 0.2735 # He at 668K, 2.8 MPa - Original: 1e-5 W/m/K, Shi PhD: 0.35 (but no gap on the inside)
    variable = temp
    quadrature = true
  []

  [gap_side]
    type = GapHeatTransfer
    gap_geometry_type = 'CYLINDER'
    emissivity_primary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    emissivity_secondary = 0.8 # MHTGR: 0.85, Shi PhD: 0.8
    primary = sleeve_inner
    secondary = fuel_side
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
    primary = block_inner
    secondary = sleeve_outer
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
    boundary = 'neumann sleeve_bot'
  []

  [outside_bc]
    type = CoupledConvectiveHeatFluxBC
    variable = temp
    boundary = 'block_outer'
    T_infinity = Tmod
    htc = 1e5
  []

  # # For RELAP-7
  [convective_inner]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'sleeve_outer'
    variable = temp
    T_infinity = Tfluid
    htc = Hw_inner
  []
  [convective_outer]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'block_inner'
    variable = temp
    T_infinity = Tfluid
    htc = Hw_outer
  []
[]

[Functions]
  [Tsolid_init_func] # initial guess for moderator/fluid temperature
    type = ParsedFunction
    expression = '${Tinlet} + (5.22 - x) * (${Toutlet} - ${Tinlet}) / 5.22'
  # Functions for the compact k and Cp (and rho) are obtained using the tpmain Fortran script with a packing fraction of 0.3, burnup = 0, fluence = 0
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
  automatic_scaling = true
  compute_scaling_once = false

  start_time = -100.0
  end_time = 64800
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
    boundary = 'sleeve_outer'
    variable = temp
    direction = x
    bounds = '1.16 1.74 2.32 2.9 3.48 4.06' # for 9 axial elements
    execute_on = 'nonlinear timestep_end'
  []
  [bdy_heat_flux_UO]
    type = LayeredSideIntegral
    boundary = 'block_outer'
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
    boundary = sleeve_outer
    execute_on = 'initial timestep_end'
  []
  [avg_Tfluid_var]
    type = ElementAverageValue
    variable = Tfluid
    execute_on = 'initial timestep_end'
  []
  [avg_Tmod_var]
    type = ElementAverageValue
    variable = Tmod
    execute_on = 'initial timestep_end'
  []
  [avg_Tmod]
    type = Receiver
    default = 525
  []
  [avg_htc]
    type = Receiver
    default = 500
  []
  [avg_pin_power]
    type = Receiver
    default = 1e3
  []
  [convection_sleeve_fluid]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = Tfluid
    htc_var = Hw_outer
    T_solid = temp
    boundary = 'block_inner'
  []
  [convection_mod_fluid]
    type = ConvectiveHeatTransferSideIntegral
    T_fluid_var = Tfluid
    htc_var = Hw_inner
    T_solid = temp
    boundary = 'sleeve_outer'
  []
  [bdy_heat_flux]
    type = ConvectiveHeatTransferSideIntegral
    boundary = 'block_outer'
    T_solid = temp
    T_fluid_var = Tmod
    htc = 1e5
  []
  [bdy_heat_flux_tot]
    type = ParsedPostprocessor
    expression = '${npins} * bdy_heat_flux'
    pp_names = 'bdy_heat_flux'
  []
  [avg_Tfluid]
    type = Receiver
    default = 500
  []
  [avg_temp]
    type = ElementAverageValue
    variable = temp
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  csv = true
  exodus = true
  time_step_interval = 100
[]
