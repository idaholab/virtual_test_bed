# ==============================================================================
# Model description
# NULL Transient neutronics model coupled with TH and pebble temperature models 
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 11, 2023
# Author(s): Dr. Mustafa Jaradat Dr. Sebastian Schunert, Dr. Javier Ortensi
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
initial_temperature     = 500.0 # (K)
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
    fission_source_as_material = true
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
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
[]
[Problem]
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
    vals  = 'dt'
    vars  = 'dt'
    value = 'dt'
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
    initial_condition = 0.39
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
  [power_density2]
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
  [dpden_avg]
    order  = CONSTANT
    family = MONOMIAL
  []
  [dpden_max]
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
  [prompt_power_density_aux]
    type          = VectorReactionRate
    block         = 'pebble_bed'
    scalar_flux   = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 
	                   sflux_g5 sflux_g6 sflux_g7 sflux_g8'
    variable      = prompt_power_density
    cross_section = kappa_sigma_fission
    scale_factor  = power_scaling2
    dummies       = UnscaledTotalPower
    execute_on    = 'INITIAL timestep_end'
  []
  [isotope_density_aux]
    type                    = ArrayVarBatemanSolve
    variable                = pebble_isotope_density
    dataset                 = ISOXML
    isoxml_data_file        = '../xsections/DRAGON5_DT_DH_295.xml'
    isoxml_lib_name         = 'DRAGON'
    execute_on              = 'INITIAL TIMESTEP_BEGIN'
    # transmutation parameters
    scalar_flux             = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 
	                             sflux_g5 sflux_g6 sflux_g7 sflux_g8'
    scalar_flux_scaling     = power_scaling #2.0946120E+18
    burnup_group_boundaries = ${burnup_group_boundaries}
    burnup_grid_name        = 'Burnup'
    array_grid_names        = 'Tfuel Tmod'
    array_grid_variables    = 'triso_temperature graphite_temperature'
    library_file            = '../xsections/HTR-PM_9G-Tnew.xml'
    library_name            = 'HTR-PM'
  []
  [decay_heat_bybg_aux]
    type                   = ArrayVarIsotopeDecayHeatAux
    variable               = decay_heat_bybg
    isotopic_composition   = pebble_isotope_density
    dataset                = ISOXML
    isoxml_data_file       = '../xsections/DRAGON5_DT_DH_295.xml'
    isoxml_lib_name        = 'DRAGON'
    execute_on             = 'INITIAL timestep_end'
  []
  [decay_heat_aux]
    type                   = ArrayVarReductionAux
    variable               = decay_heat
    array_variable         = decay_heat_bybg
    execute_on             = 'INITIAL timestep_end'
  []
  [power_density2_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = power_density2
    args       = 'prompt_power_density decay_heat'
    function   = 'prompt_power_density + decay_heat'
    execute_on = 'INITIAL timestep_end'
  []
  [power_peaking]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = power_peaking
    args       = 'power_density'
    function   = 'power_density / 3.21525E+06'
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
  [dpden_max_aux]
    type           = ArrayVarExtremeValueAux
    block          = 'pebble_bed'
    variable       = dpden_max
    array_variable = decay_heat_bybg
    value_type     = MAX
    execute_on     = 'INITIAL TIMESTEP_END'
  []
  [dpden_avg_aux]
    type                   = PebbleAveragedAux
    block                  = 'pebble_bed'
    variable               = dpden_avg
    array_variable         = decay_heat_bybg
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types   = 1
    execute_on             = 'INITIAL TIMESTEP_END'
  []
[]
[UserObjects]
  [transport_solution]
    type             = TransportSolutionVectorFile
    transport_system = diff
    writing          = false
    execute_on       = 'INITIAL'
    scale_with_keff  = false
  []
  [depletion_solution]
    type        = SolutionVectorFile
    var         = 'pebble_isotope_density  pebble_volume_fraction   graphite_temperature    
	                      triso_temperature           power_density  partial_power_density ' 
    writing     = false
    execute_on  = 'INITIAL'
  []
  [TH_solution]
    type        = SolutionVectorFile
    var         = 'T_solid T_fluid'
	  loading_var = 'T_solid T_fluid'
    writing     = false
    execute_on  = 'INITIAL'
  []
  [init_power_density]
    type        = SolutionVectorFile
    var         =  'prompt_power_density  decay_heat ' 
    loading_var = 'prompt_power_density  decay_heat ' 
	  writing     = false
    execute_on  = 'INITIAL'
  []
[]
# ==============================================================================
# MATERIALS
# ==============================================================================
# ==============================================================================
# MATERIALS
# ==============================================================================
[PebbleDepletion]
  block                           = 'pebble_bed'
  power                           = ${fparse total_power}
  integrated_power_postprocessor  = total_power
  power_density_variable          = power_density
  family                          = MONOMIAL
  order                           = CONSTANT  
  
  porosity_name                   = porosity
  burnup_group_boundaries         = ${burnup_group_boundaries}
  strictness                      = 0

  # cross section data
  library_file                    = '../xsections/HTR-PM_9G-Tnew.xml'
  library_name                    = 'HTR-PM'
  burnup_grid_name                = 'Burnup'
  fuel_temperature_grid_name      = 'Tfuel'
  moderator_temperature_grid_name = 'Tmod'

  # transmutation data
  dataset                         = ISOXML
  isoxml_data_file                = '../xsections/DRAGON5_DT_DH_295.xml'
  isoxml_lib_name                 = 'DRAGON'
  
  initial_moderator_temperature   = ${initial_temperature}
  initial_fuel_temperature        = ${initial_temperature}
  n_fresh_pebble_types            = 1
  fresh_pebble_isotopes           = '       U234       U235       U238        O16        O17
                                        Graphite       SI28       SI29       SI30        C12'
  fresh_pebble_isotope_densities  = ' 1.0887E-07 1.3550E-05 1.4209E-04 3.1137E-04 1.1837E-07
                                      8.5357E-02 3.1399E-04 1.5944E-05 1.0510E-05 3.4044E-04'
  track_isotopes                  = '  U235    U236    U238   PU238   PU239   PU240   PU241   PU242   AM241 
                                     AM242M   CS135   CS137   XE135   XE136    I131    I135    SR90'
  decay_heat                      = true
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
# ==============================================================================
# MultiApps & Transfers
# ==============================================================================
[MultiApps]
  [flow]
    type                         = TransientMultiApp
    input_files                  = 'htr-pm-flow-fv-tr-null.i'
    positions                    = '0 0 0'
    execute_on                   = 'TIMESTEP_END'
  []
  [pebble0]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble1]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble2]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble3]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble4]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble5]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble6]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble7]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble8]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
  [pebble9]
    type                         = FullSolveMultiApp
    input_files                  = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file               = 'pebble_heat_pos.txt'
    execute_on                   = 'TIMESTEP_END'
    # max_procs_per_app = 4
  []
[]
[Transfers]
  [power_density_to_flow]
	  type              = MultiAppNearestNodeTransfer
    to_multi_app      = flow
    source_variable   = power_density2
    variable          = power_density
    fixed_meshes      = true
	  execute_on        = 'TIMESTEP_END'
  []
  [T_solid_from_flow]
    type              = MultiAppNearestNodeTransfer
    from_multi_app    = flow
    source_variable   = T_solid
    variable          = T_solid
    execute_on        = 'TIMESTEP_END'
    fixed_meshes      = true
	# relaxation_factor = '0.5 0.5'
  []
  [T_fluid_from_flow]
    type              = MultiAppNearestNodeTransfer
    from_multi_app    = flow
    source_variable   = T_fluid
    variable          = T_fluid
    execute_on        = 'TIMESTEP_END'
    fixed_meshes      = true
  []
  [pebble_send_Tsolid0]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble0
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid1]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble1
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid2]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble2
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid3]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble3
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid4]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble4
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid5]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble5
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid6]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble6
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid7]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble7
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid8]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble8
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  [pebble_send_Tsolid9]
    type              = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app      = pebble9
    postprocessor     = T_surface
    source_variable   = T_solid
  []
  # TO Pebble Partial power density.
  [pebble_send_ppd0]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble0
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 0
  []
  [pebble_send_ppd1]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble1
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 1
  []
  [pebble_send_ppd2]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble2
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 2
  []
  [pebble_send_ppd3]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble3
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 3
  []
  [pebble_send_ppd4]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble4
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 4
  []
  [pebble_send_ppd5]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble5
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 5
  []
  [pebble_send_ppd6]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble6
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 6
  []
  [pebble_send_ppd7]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble7
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 7
  []
  [pebble_send_ppd8]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble8
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 8
  []
  [pebble_send_ppd9]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app              = pebble9
    postprocessor             = pebble_power_density
    source_variable           = partial_power_density
    source_variable_component = 9
  []
  # FROM Pebble T_mod (Pebble average temperature)
  [pebble_receive_T_mod_0]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble0
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 0
  []
  [pebble_receive_T_mod_1]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble1
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 1
  []
  [pebble_receive_T_mod_2]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble2
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 2
  []
  [pebble_receive_T_mod_3]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble3
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 3
  []
  [pebble_receive_T_mod_4]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble4
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 4
  []
  [pebble_receive_T_mod_5]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble5
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 5
  []
  [pebble_receive_T_mod_6]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble6
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 6
  []
  [pebble_receive_T_mod_7]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble7
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 7
  []
  [pebble_receive_T_mod_8]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble8
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 8
  []
  [pebble_receive_T_mod_9]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble9
    postprocessor             = T_mod
    source_variable           = graphite_temperature
    source_variable_component = 9
  []
  # FROM Pebble T_fuel (TRISO average temperature)
  [pebble_receive_T_fuel_0]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble0
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 0
  []
  [pebble_receive_T_fuel_1]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble1
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 1
  []
  [pebble_receive_T_fuel_2]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble2
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 2
  []
  [pebble_receive_T_fuel_3]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble3
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 3
  []
  [pebble_receive_T_fuel_4]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble4
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 4
  []
  [pebble_receive_T_fuel_5]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble5
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 5
  []
  [pebble_receive_T_fuel_6]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble6
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 6
  []
  [pebble_receive_T_fuel_7]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble7
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 7
  []
  [pebble_receive_T_fuel_8]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble8
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 8
  []
  [pebble_receive_T_fuel_9]
    type                      = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app            = pebble9
    postprocessor             = T_fuel
    source_variable           = triso_temperature
    source_variable_component = 9
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
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  
  start_time = 0
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.05
    timestep_limiting_postprocessor = dt_max_pp
    optimal_iterations = 10
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []
  end_time = 6.0e5
  auto_advance = true
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
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
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
  [power_scaling2]
    type        = PowerModulateFactor
    power_pp    = UnscaledTotalPower
    rated_power = 2.344921322E+08 #2.344934400E+08 #2.33935E+08 # Power * (1-DHF_tot)
    execute_on  = 'initial'
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
  [decay_heat2]
    type = ElementIntegralVariablePostprocessor
    variable = decay_heat
    block = 'pebble_bed'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [total_power2]
    type        = ElementIntegralVariablePostprocessor
    block       = 'pebble_bed'
    variable    = power_density2
	  execute_on  = 'initial timestep_end'
  []
  [power_peak]
    type        = ElementExtremeValue
    variable    = power_peaking
    value_type  = max
    execute_on  = 'initial timestep_end'
  []
[]
[Outputs]
  file_base  = htr_pm_griffin_tr_null_out
  exodus     = true
  csv        = true
  perf_graph = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
