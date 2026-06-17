# ==============================================================================
# Model description
# DLOFC Transient neutronics model coupled with TH and pebble temperature models
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 11, 2023
# Author(s): Dr. Mustafa Jaradat Dr. Sebastian Schunert, Dr. Javier Ortensi
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# initial_temperature     = 500.0 # (K)
total_power             = 250.0e+6  # Total reactor Power (W)
burnup_group_boundaries = '5.35E+13 1.070E+14 1.604E+14 2.139E+14 2.674E+14 3.209E+14 3.743E+14 4.278E+14 4.818E+14'
#==========================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file ='../xsections/HTR-PM_9G-Tnew.xml'
  library_name = 'HTR-PM'
  is_meter = true
[]
[TransportSystems]
  particle = neutron
  equation_type = transient
  G = 9
  ReflectingBoundary = 'left'
  VacuumBoundary = 'right top bottom'
  [diff]
    scheme = CFEM-Diffusion
    family = LAGRANGE
    order = FIRST
	  n_delay_groups = 6
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]
[Problem]
  restart_file_base                     = 'htr_pm_griffin_ss_out_cp/LATEST'
[]
# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  type           = MeshGeneratorMesh
  block_id       = '         1              2           3          4             5             6
                             7              8          61         71'
  block_name     = 'pebble_bed      upper_ref   lower_ref     cavity    hot_plenum   cold_plenum
                    radial_ref   carbon_brick    riser cr'
  #uniform_refine = 1
  [cartesian_mesh]
    type         = CartesianMeshGenerator
    dim          = 2
    # Total height: 16.8 m
    dx           = ' 0.250 0.250 0.250 0.250 0.250 0.250
                     0.010 0.050 0.130 0.080 0.080 0.080
 		                 0.200 0.120 0.125 0.125'
    ix           = ' 1 1 1 1 1 1
                     1 1 1 1 1 1
                     1 1 1 1'
    dy           = ' 0.400 0.400 0.100 0.100 0.800 0.300 0.200 0.300 0.216 0.412
                     0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
                     0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
                     0.760 0.712 0.300 0.400 0.400'
    # base: converges fine
    iy           = ' 1 1 1 1 2 1 1 1 1 1
                     1 1 1 1 1 1 1 1 1 1
                     1 1 1 1 1 1 1 1 1 1
                     2 2 1 1 1'
    subdomain_id = ' 8  8  8  8  8  8  8  8   8  8  8  8   8  8  8  8
                     8  8  8  8  8  8  8  8   8  8  8  8   8  8  8  8
                     7  7  7  7  7  7  7  7   7  7  7  7   7  7  8  8
                     7  7  7  7  7  7  7  7   7  7  7  7   7  7  8  8
                     5  5  5  5  5  5  5  5   5  7  7  7  61  7  8  8
                     3  3  3  3  3  3  7  7  71  7  7  7  61  7  8  8
                     3  3  3  3  3  3  7  7  71  7  7  7  61  7  8  8
                     3  3  3  3  3  3  7  7  71  7  7  7  61  7  8  8
                     3  3  3  3  3  3  7  7  71  7  7  7  61  7  8  8
                     3  3  3  3  3  3  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     1  1  1  1  1  1  7  7  71  7  7  7  61  7  8  8
                     4  4  4  4  4  4  7  7  71  7  7  7  61  7  8  8
                     4  2  2  2  2  2  7  7  71  7  7  7  61  7  8  8
                     6  6  6  6  6  6  6  6  71  6  6  6   6  7  8  8
                     7  7  7  7  7  7  7  7  71  7  7  7   7  7  8  8
                     8  8  8  8  8  8  8  8  71  8  8  8   8  8  8  8 '
 []
 [assign_material_id]
   type                   = SubdomainExtraElementIDGenerator
   input                  = cartesian_mesh
   extra_element_id_names = 'material_id'
   subdomains             = '1 2 3 4 5 6 7 8 61 71'
   extra_element_ids      = '1 1 1 1 1 1 1 1 1 1'
 []
  coord_type = RZ
[]
# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[Functions]
  [CR_bott]
    type = PiecewiseLinear
    x = ' 0.000    13.000    16.000    1.8e+5  '
    y = '13.678    13.678     1.800    1.800'
  []
  [dt_max_fn]
    type = PiecewiseLinear
    x = '-10 0 16 30 1000 5000 20000 100000 200000 500000'
    y = '  1 1 1  1  50   100  200   400   400   500'
  []
  [del_t_function]
    type  = ParsedFunction
    expression  = 'dt'
    symbol_names = 'dt'
    symbol_values = 'dt'
  []
[]
[AuxVariables]
  [T_solid]
    family = MONOMIAL
    order = CONSTANT
  []
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
  []
  [Tfuel_avg]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tfuel_max]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod_avg]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod_max]
    order = CONSTANT
    family = MONOMIAL
  []
  [porosity]
    family = MONOMIAL
    order = CONSTANT
    # reloaded from file
    # initial_condition = 0.39
    block = 'pebble_bed'
  []
  [del_t]
    type = MooseVariableFVReal
  []
  [prompt_power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [decay_heat_bybg]
    family = MONOMIAL
    order = CONSTANT
    components = 10
    block = 'pebble_bed'
  []
  [decay_heat]
    family = MONOMIAL
    order = CONSTANT
    block = 'pebble_bed'
  []
  [power_peaking]
    order = CONSTANT
    family = MONOMIAL
  []
  [pden_avg]
    order  = CONSTANT
    family = MONOMIAL
  []
  [pden_max]
    order  = CONSTANT
    family = MONOMIAL
  []
[]
[AuxKernels]
  [Tfuel_avg]
    type = PebbleAveragedAux
    block = 1
    variable = Tfuel_avg
    array_variable = triso_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_max]
    type = ArrayVarExtremeValueAux
    block = 1
    variable = Tfuel_max
    array_variable = triso_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_avg]
    type = PebbleAveragedAux
    block = 1
    variable = Tmod_avg
    array_variable = graphite_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_max]
    type = ArrayVarExtremeValueAux
    block = 1
    variable = Tmod_max
    array_variable = graphite_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [del_t_aux]
    type     = FunctionAux
    variable = del_t
    function = del_t_function
  []
  [power_peaking]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = power_peaking
    coupled_variables = 'power_density'
    expression        = 'power_density / 3.21525E+06'
    execute_on = 'INITIAL timestep_end'
  []
  [pden_max_aux]
    type           = ArrayVarExtremeValueAux
    block          = 'pebble_bed'
    variable       = pden_max
    array_variable = partial_power_density
    value_type     = MAX
    execute_on     = 'INITIAL TIMESTEP_END'
  []
  [pden_avg_aux]
    type                   = PebbleAveragedAux
    block                  = 'pebble_bed'
    variable               = pden_avg
    array_variable         = partial_power_density
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types   = 1
    execute_on             = 'INITIAL TIMESTEP_END'
  []
[]
# ==============================================================================
# MATERIALS
# ==============================================================================
[PebbleBed]
  block                           = 'pebble_bed'
  power                           = ${fparse total_power}
  integrated_power_postprocessor  = total_power
  power_density_variable          = power_density
  family                          = MONOMIAL
  order                           = CONSTANT

  porosity_name                   = porosity
  burnup_group_boundaries         = ${burnup_group_boundaries}

  # cross section data
  library_file                    = '../xsections/HTR-PM_9G-Tnew.xml'
  library_name                    = 'HTR-PM'
  burnup_grid_name                = 'Burnup'
  fuel_temperature_grid_name      = 'Tfuel'
  moderator_temperature_grid_name = 'Tmod'
  # avoid physicality check (old XS library)
  dtl_physicality = DISABLE

  # transmutation data
  dataset                         = ISOXML
  isoxml_data_file                = '../xsections/DRAGON5_DT_DH_295.xml'
  isoxml_lib_name                 = 'DRAGON'

  # initial_moderator_temperature   = ${initial_temperature}
  # initial_fuel_temperature        = ${initial_temperature}
  n_fresh_pebble_types            = 1
  fresh_pebble_compositions       = 'fresh_pebble'
  track_isotopes                  = '  U235    U236    U238   PU238   PU239   PU240   PU241   PU242   AM241
                                     AM242M   CS135   CS137   XE135   XE136    I131    I135    SR90'

  # pebble conduction
  pebble_conduction_input_file                = 'pebble_triso.i'
  pebble_positions_file                       = 'pebble_heat_pos.txt'
  surface_temperature_sub_app_postprocessor   = T_surface
  surface_temperature_main_app_variable       = T_solid
  power_sub_app_postprocessor                 = pebble_power_density
  fuel_temperature_sub_app_postprocessor      = T_fuel
  moderator_temperature_sub_app_postprocessor = T_mod
  decay_heat                                  = true
[]

[Materials]
  # upper and lower reflectors at 70% density
  [axial_reflector]
    type = CoupledFeedbackNeutronicsMaterial
    block = 'upper_ref lower_ref'
    grid_names = 'Tmod'
    grid_variables = 'T_solid'
    plus = true
    isotopes =   'Graphite    U235'
    densities =  '6.25284E-02  0.0'
    material_id = 1
  []
  # upper lower plenum at 80% density
  [plenum]
    type = CoupledFeedbackNeutronicsMaterial
    block = 'hot_plenum cold_plenum'
    grid_names = 'Tmod'
    grid_variables = 'T_solid'
    plus = true
    isotopes =   'Graphite      U235'
    densities =  '7.14611E-02   0.0'
    material_id = 1
  []
  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    block = 'radial_ref carbon_brick'
    grid_names = 'Tmod'
    grid_variables = 'T_solid'
    plus = true
    isotopes =   'Graphite     U235'
    densities =  '8.93263E-02  0.0'
    material_id = 1
  []
  # control_rod at 68% density
  [control_rod]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = 'cr'
    grid_names = 'Tmod  Tmod  Tmod'
    grid_variables = 'T_solid  T_solid  T_solid'
    plus = true
    #isotopes  =  '   Graphite   U235 ;      Graphite            C12           B10          B11   U235;        Graphite            C12           B10          B11   U235'
    #densities =  '6.074191E-02    0.0   6.074191E-02   8.734066E-03  8.734066E-04  7.860660E-03    0.0    6.074191E-02   8.734066E-03  8.734066E-04  7.860660E-03    0.0'
	  isotopes  =  '   Graphite   U235 ;      Graphite            B10          B11            C12   U235;       Graphite            B10          B11            C12   U235'
    densities =  ' 6.4277e-02     0.0     6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0      6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0'
	  segment_material_ids = '1   1   1'
	  rod_segment_length = 11.878
	  front_position_function = 'CR_bott'
	  rod_withdrawn_direction = 'y'
  []
  # riser at 68% density
  [riser]
    type = CoupledFeedbackNeutronicsMaterial
    block = 'riser'
    grid_names = 'Tmod'
    grid_variables = 'T_solid'
    plus = true
	  isotopes  =  'Graphite     U235'
    densities =  '6.07419E-02	0.0'
    material_id = 1
  []
  [cavity]
    type = ConstantNeutronicsMaterial
    block = 'cavity'
    fromFile = false
    # computed from Serpent CMM
	  neutron_speed  = '1.164872386937E+09 1.225755729920E+08 1.358941921623E+07 3.924789509810E+06 2.395847846182E+06 1.814298529894E+06 1.399342656828E+06 7.200528593684E+05 2.911858619061E+05'
    diffusion_coef = '4.68857E-01 1.52760E-01 1.21025E-01 1.08241E-01  1.72433E-01  1.65906E-01  1.96579E-01  1.79868E-01  2.14727E-01'
    sigma_r = '0 0 0 0 0 0 0 0 0'
    sigma_s = ' 7.10949E-01 0 0 0 0 0 0 0 0
                0 2.18207E+00 0 0 0 0 0 0 0
                0 0 2.75425E+00 0 0 0 0 0 0
                0 0 0 3.07955E+00 0 0 0 0 0
                0 0 0 0 1.93312E+00 0 0 0 0
                0 0 0 0 0 2.00917E+00 0 0 0
                0 0 0 0 0 0 1.69567E+00 0 0
                0 0 0 0 0 0 0 1.85321E+00 0
                0 0 0 0 0 0 0 0 1.55236E+00'

    diffusion_coefficient_scheme = user_supplied
  []
[]

[Compositions]
  [fresh_pebble]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = 'U234 1.0887E-07
                         U235 1.3550E-05
                         U238 1.4209E-04
                         O16 3.1137E-04
                         O17 1.1837E-07
                         Graphite 8.5357E-02
                         SI28 3.1399E-04
                         SI29 1.5944E-05
                         SI30 1.0510E-05
                         C12 3.4044E-04'
  []
[]

# ==============================================================================
# MultiApps & Transfers
# ==============================================================================
[MultiApps]
  [flow]
    type                         = TransientMultiApp
    input_files                  = 'htr-pm-flow-fv-tr-dlofc.i'
    positions                    = '0 0 0'
    execute_on                   = 'TIMESTEP_END'
  []
[]
[Transfers]
  [power_density_to_flow]
	  type              = MultiAppShapeEvaluationTransfer
    to_multi_app      = flow
    source_variable   = power_density
    variable          = power_density
	  execute_on        = 'TIMESTEP_END'
  []
  [T_solid_from_flow]
    type              = MultiAppNearestNodeTransfer
    from_multi_app    = flow
    source_variable   = T_solid
    variable          = T_solid
    execute_on        = 'TIMESTEP_END'
  []
  [T_fluid_from_flow]
    type              = MultiAppNearestNodeTransfer
    from_multi_app    = flow
    source_variable   = T_fluid
    variable          = T_fluid
    execute_on        = 'TIMESTEP_END'
  []
[]
# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient

  # solver parameters
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = l2 #none
  # Linear/nonlinear iterations.
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 50
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-6
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-5
  fixed_point_abs_tol = 1e-6

  # time stepping
  start_time = 0
  end_time = 6.0e5
  auto_advance = true
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.05
    timestep_limiting_postprocessor = dt_max_pp
    optimal_iterations = 10
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Outputs]
  file_base  = htr_pm_griffin_tr_dlofc_out
  exodus     = true
  csv        = true
  perf_graph = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
[Postprocessors]
  [dt]
    type = TimestepSize
  []
  [dt_max_pp]
    type       = FunctionValuePostprocessor
    function   = dt_max_fn
    execute_on = TIMESTEP_BEGIN
  []
  [max_T_solid]
    type       = ElementExtremeValue
    variable   = T_solid
    execute_on  = 'initial timestep_end'
  []
  [Tsolid_core]
    type       = ElementAverageValue
    variable   = T_solid
    execute_on  = 'initial timestep_end'
  []
  [Tfluid_core]
    type       = ElementAverageValue
    variable   = T_fluid
    execute_on  = 'initial timestep_end'
  []
  [Tfuel_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Tfuel_avg
    execute_on  = 'initial timestep_end'
  []
  [Tfuel_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    value_type = max
	  variable   = Tfuel_avg
    execute_on  = 'initial timestep_end'
  []
  [Tmod_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Tmod_avg
    execute_on  = 'initial timestep_end'
  []
  [Tmod_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    variable   = Tmod_max
    value_type = max
    execute_on  = 'initial timestep_end'
  []
  [UnscaledTotalPower]
    type                = FluxRxnIntegral
    block               = 'pebble_bed'
    cross_section       = kappa_sigma_fission
    coupled_flux_groups = 'sflux_g0 sflux_g1 sflux_g2
                           sflux_g3 sflux_g4 sflux_g5
                           sflux_g6 sflux_g7 sflux_g8'
    execute_on          = 'initial'
  []
  [prompt_power]
    type        = ElementIntegralVariablePostprocessor
    block       = 'pebble_bed'
    variable    = prompt_power_density
    execute_on  = 'initial timestep_end'
  []
  [decay_heat]
    type = ElementIntegralVariablePostprocessor
    variable = total_pebble_decay_heat
    block = 'pebble_bed'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [power_peak]
    type        = ElementExtremeValue
    variable    = power_peaking
    value_type  = max
    execute_on  = 'initial timestep_end'
  []
[]
