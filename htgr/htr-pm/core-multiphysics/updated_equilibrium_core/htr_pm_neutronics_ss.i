# ==============================================================================
# Model description
# Equilibrium core neutronics model coupled with TH and pebble temperature models
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 11, 2023
# Author(s): Dr. Mustafa Jaradat Dr. Sebastian Schunert, Dr. Javier Ortensi
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
initial_temperature     = 500.0 # (K)
total_power             = 250.0e+6  # Total reactor Power (W)
burnup_group_boundaries = '5.35E+13 1.070E+14 1.604E+14 2.139E+14 2.674E+14 3.209E+14 3.743E+14 4.278E+14 4.818E+14' 
# ==============================================================================
# parameters describing the reactor geometry
core_height             = 11.0
axial_reflector_height  = 3.228
fuel_radius             = 1.5
r_streamline_1          = 12.5e-2
r_streamline_2          = 37.5e-2
r_streamline_3          = 62.5e-2
r_streamline_4          = 87.5e-2
r_streamline_5          = 112.5e-2
r_streamline_6          = 137.5e-2
pebble_radius           = 3e-2
pebble_volume           = ${fparse 4/3*pi * pebble_radius * pebble_radius * pebble_radius}
residence_time          = 70.5
pebble_speed            = ${fparse core_height / (residence_time * 3600 * 24)}
area                    = ${fparse pi * fuel_radius * fuel_radius}
pebble_unloading_rate   = ${fparse pebble_speed * area * 0.61 / pebble_volume}
# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file = '../xsections/HTR-PM_9G-Tnew.xml'
  library_name = 'HTR-PM'
  is_meter     = true
[]
[TransportSystems]
  particle           = neutron
  equation_type      = eigenvalue
  G                  = 9
  ReflectingBoundary = 'left'
  VacuumBoundary     = 'right top bottom'
  [diff]
    scheme                       = CFEM-Diffusion
    family                       = LAGRANGE
    order                        = FIRST
	  n_delay_groups               = 6
    fission_source_as_material   = true
    assemble_scattering_jacobian = true
    assemble_fission_jacobian    = true
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
                     0.760 0.712 0.300 0.400 0.400 '
    # base: converges fine
    iy           = '1 1 1 1 2 1 1 1 1 1
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
    type = ConstantFunction
    value = '13.678'
  []
[]
[AuxVariables]
  [T_solid]
    family            = MONOMIAL
    order             = CONSTANT
    initial_condition = ${initial_temperature}
  []
  [T_fluid]
    family            = MONOMIAL
    order             = CONSTANT
    initial_condition = ${initial_temperature}
  []
  [Tfuel_avg]
    order  = CONSTANT
    family = MONOMIAL
  []
  [Tfuel_max]
    order  = CONSTANT
    family = MONOMIAL
  []
  [Tmod_avg]
    order  = CONSTANT
    family = MONOMIAL
  []
  [Tmod_max]
    order  = CONSTANT
    family = MONOMIAL
  []
  [Burnup]
    order             = CONSTANT
    family            = MONOMIAL
    components        = 10
    # use burnup midpoints and add one additional for discard group
    initial_condition = '2.675E+13 8.025E+13 1.337E+14 1.872E+14 2.407E+14 2.942E+14 3.476E+14 4.011E+14 4.546E+14 4.546E+14'
    outputs           = none
  []
  [Burnup_avg]
    order  = CONSTANT
    family = MONOMIAL
  []
  [porosity]
    family            = MONOMIAL
    order             = CONSTANT
    initial_condition = 0.39
    block             = 'pebble_bed'
  []
  [prompt_power_density]
    order  = CONSTANT
    family = MONOMIAL
  []
  [power_density2]
    order  = CONSTANT
    family = MONOMIAL
  []
  [power_peaking]
    order  = CONSTANT
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
[]
[AuxKernels]
  [Tfuel_avg_aux]
    type                   = PebbleAveragedAux
    block                  = pebble_bed
    variable               = Tfuel_avg
    array_variable         = triso_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types   = 1
    execute_on             = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_max_aux]             
    type                   = ArrayVarExtremeValueAux
    block                  = pebble_bed
    variable               = Tfuel_max
    array_variable         = triso_temperature
    value_type             = MAX
    execute_on             = 'INITIAL TIMESTEP_END'
  []
  [Tmod_avg_aux]
    type                   = PebbleAveragedAux
    block                  = pebble_bed
    variable               = Tmod_avg
    array_variable         = graphite_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types   = 1
    execute_on             = 'INITIAL TIMESTEP_END'
  []
  [Tmod_max_aux]
    type                   = ArrayVarExtremeValueAux
    block                  = pebble_bed
    variable               = Tmod_max
    array_variable         = graphite_temperature
    value_type             = MAX
    execute_on             = 'INITIAL TIMESTEP_END'
  []
  [Burnup_avg_aux]
    type                   = PebbleAveragedAux
    block                  = pebble_bed
    variable               = Burnup_avg
    array_variable         = Burnup
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types   = 1
    execute_on             = 'INITIAL TIMESTEP_END'
  []
 
  [prompt_power_density_aux]
    type                   = VectorReactionRate
    block                  = 'pebble_bed'
    scalar_flux            = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 
	                            sflux_g5 sflux_g6 sflux_g7 sflux_g8'
    variable               = prompt_power_density
    cross_section          = kappa_sigma_fission
    scale_factor           = power_scaling2
    dummies                = UnscaledTotalPower
    execute_on             = 'INITIAL timestep_end'
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
  [power_peaking_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = power_peaking
    args       = 'power_density'
    function   = 'power_density / 3.21525E+06'
    execute_on = 'timestep_end'
  []
[]

[UserObjects]
  [power_map]
    type        = VariableCartesianCoreMap
    variables   = 'power_density'
    block       = pebble_bed
    execute_on  = 'FINAL'
    output_in   = 'power_ss.out'
  []
  [isotopic_map]
    type      = VariableCartesianCoreMap
	  variables = ' isotope_density_U235    isotope_density_U236   isotope_density_U238  isotope_density_PU238
                 isotope_density_PU239   isotope_density_PU240  isotope_density_PU241  isotope_density_PU242
                 isotope_density_AM241  isotope_density_AM242M  isotope_density_CS135  isotope_density_CS137
                 isotope_density_XE135   isotope_density_XE136   isotope_density_I131   isotope_density_I135
                 isotope_density_SR90'
    block     = pebble_bed
    execute_on= 'FINAL'
    output_in = 'isotopics_ss.out'
  []
  [burnup_map]
    type       = VariableCartesianCoreMap
    variables  = 'Burnup_avg'
    block      = pebble_bed
    execute_on = 'FINAL'
    output_in  = 'burnup_ss.out'
  []
  [transport_solution]
    type             = TransportSolutionVectorFile
    transport_system = diff
    writing          = true
    execute_on       = 'FINAL'
  []
  [depletion_solution]
    type       = SolutionVectorFile
    var        = 'pebble_isotope_density  pebble_volume_fraction   graphite_temperature    
	                     triso_temperature           power_density  partial_power_density  
                         scaled_sflux_g0         scaled_sflux_g1        scaled_sflux_g2
                         scaled_sflux_g3         scaled_sflux_g4        scaled_sflux_g5
                         scaled_sflux_g6         scaled_sflux_g7        scaled_sflux_g8'
    writing    = true
    execute_on = 'FINAL'
  []
  [TH_solution]
    type       = SolutionVectorFile
    var        = 'T_solid T_fluid'
    writing    = true
    execute_on = 'FINAL'
  []
  [init_power_density]
    type       = SolutionVectorFile
    var        = 'prompt_power_density  decay_heat  pebble_isotope_density' 
    writing    = true
    execute_on = 'FINAL'
  []
[]
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

  [DepletionScheme]
    type                          = ConstantStreamlineEquilibrium
    pebble_unloading_rate         = ${pebble_unloading_rate}
    pebble_flow_rate_distribution = '0.027777778 0.083333333 0.138888889 0.194444444 0.25 0.305555556'
    burnup_limit                  = 4.818E+14
    major_streamline_axis         = y
    pebble_diameter               = 0.06
    material_ids                  = '1; 1; 1; 1; 1; 1'
    streamline_points = '${r_streamline_1} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_1} ${axial_reflector_height} 0;
                         ${r_streamline_2} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_2} ${axial_reflector_height} 0;
                         ${r_streamline_3} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_3} ${axial_reflector_height} 0;
                         ${r_streamline_4} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_4} ${axial_reflector_height} 0;
                         ${r_streamline_5} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_5} ${axial_reflector_height} 0;
                         ${r_streamline_6} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_6} ${axial_reflector_height} 0'
    streamline_segment_subdivisions = '20; 20; 20; 20; 20; 20'
    sweep_tol                       = 1e-7
    sweep_max_iterations            = 100
  []

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
    type           = CoupledFeedbackNeutronicsMaterial
    block          = 'upper_ref lower_ref'
    grid_names     = 'Tmod'
    grid_variables = 'T_solid'
    plus           = true
    isotopes       =   'Graphite    U235'
    densities      =  '6.25284E-02  0.0'
    material_id    = 1
  []
  # upper lower plenum at 80% density
  [plenum]
    type           = CoupledFeedbackNeutronicsMaterial
    block          = 'hot_plenum cold_plenum'
    grid_names     = 'Tmod'
    grid_variables = 'T_solid'
    plus           = true
    isotopes       =   'Graphite      U235'
    densities      =  '7.14611E-02   0.0'
    material_id    = 1
  []
  [reflector]
    type           = CoupledFeedbackNeutronicsMaterial
    block          = 'radial_ref carbon_brick'
    grid_names     = 'Tmod'
    grid_variables = 'T_solid'
    plus           = true
    isotopes       =   'Graphite     U235'
    densities      =  '8.93263E-02  0.0'
    material_id    = 1
  []
  [control_rod]
    type                    = CoupledFeedbackRoddedNeutronicsMaterial
    block                   = 'cr'
    grid_names              = 'Tmod  Tmod  Tmod'
    grid_variables          = 'T_solid  T_solid  T_solid'
    plus                    = true
	  isotopes                =  '   Graphite   U235 ;      Graphite            B10          B11            C12   U235;       Graphite            B10          B11            C12   U235'
    densities               =  ' 6.4277e-02     0.0     6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0      6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0'
	  segment_material_ids    = '1   1   1'
	  rod_segment_length      = 11.878
	  front_position_function = 'CR_bott'
	  rod_withdrawn_direction = 'y'
  []
  [riser]
    type           = CoupledFeedbackNeutronicsMaterial
    block          = 'riser'
    grid_names     = 'Tmod'
    grid_variables = 'T_solid'
    plus           = true
	  isotopes       =  'Graphite     U235'
    densities      =  '6.07419E-02   0.0'
    material_id    = 1
  []
  [cavity]
    type           = ConstantNeutronicsMaterial
    block          = 'cavity'
    fromFile       = false
    # computed from Serpent CMM
    diffusion_coef = '4.68857E-01 1.52760E-01 1.21025E-01 1.08241E-01  1.72433E-01  1.65906E-01  1.96579E-01  1.79868E-01  2.14727E-01'
    sigma_r        = '0 0 0 0 0 0 0 0 0'
    sigma_s        = ' 7.10949E-01 0 0 0 0 0 0 0 0
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
    type = FullSolveMultiApp
    input_files = 'htr-pm-flow-fv-ss.i'
    keep_solution_during_restore = true
    positions = '0 0 0'
    execute_on = 'TIMESTEP_END'
    #max_procs_per_app = 20
  []
[]
[Transfers]
  [power_density_to_flow]
	  type = MultiAppNearestNodeTransfer
    to_multi_app = flow
    source_variable = power_density
    variable = power_density
	  fixed_meshes = true
	  execute_on = 'TIMESTEP_END'
  []
  [T_solid_from_flow]
	  type = MultiAppNearestNodeTransfer
    from_multi_app = flow
    source_variable = T_solid
    variable = T_solid
	  execute_on = 'TIMESTEP_END'
	  fixed_meshes = true
  []
  [T_fluid_from_flow]
	  type = MultiAppNearestNodeTransfer
    from_multi_app = flow
    source_variable = T_fluid
    variable = T_fluid
	  execute_on = 'TIMESTEP_END'
	  fixed_meshes = true
  []
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [max_T_solid]
    type       = ElementExtremeValue
    variable   = T_solid
    execute_on = 'initial timestep_end'
  []
  [Tsolid_core]
    type       = ElementAverageValue
    variable   = T_solid
    execute_on = 'initial timestep_end'
  []
  [Tfluid_core]
    type       = ElementAverageValue
    variable   = T_fluid
    execute_on = 'initial timestep_end'
  []
  [Tfuel_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Tfuel_avg
    execute_on = 'initial timestep_end'
  []
  [Tfuel_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    value_type = max
	  variable   = Tfuel_avg
    execute_on = 'initial timestep_end'
  []
  [Tmod_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Tmod_avg
    execute_on = 'initial timestep_end'
  []
  [Tmod_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    variable   = Tmod_max
    value_type = max
    execute_on = 'initial timestep_end'
  []
  [Burnup_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Burnup_avg
    execute_on = 'initial timestep_end'
  []
  
  [UnscaledTotalPower]
    type                = FluxRxnIntegral
    block               = 'pebble_bed'
    cross_section       = kappa_sigma_fission
    coupled_flux_groups = 'sflux_g0 sflux_g1 sflux_g2
                           sflux_g3 sflux_g4 sflux_g5
                           sflux_g6 sflux_g7 sflux_g8'
    execute_on          = 'transfer timestep_end'
  []
  [power_scaling2]
    type        = PowerModulateFactor
    power_pp    = UnscaledTotalPower
    rated_power = 2.344921322E+08
    execute_on  = 'transfer timestep_end'
  []
  [prompt_power]
    type        = ElementIntegralVariablePostprocessor
    block       = 'pebble_bed'
    variable    = prompt_power_density
    execute_on  = 'transfer timestep_end'
  []
  [total_power2]
    type        = ElementIntegralVariablePostprocessor
    block       = 'pebble_bed'
    variable    = power_density2
	  execute_on  = 'transfer timestep_end'
  []
  [avg_power_density]
    type        = ElementAverageValue
    block       = 'pebble_bed'
    variable    = power_density
    execute_on  = 'transfer timestep_end'
  []
  [power_peak]
    type        = ElementExtremeValue
    variable    = power_peaking
    value_type  = max
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
  type                  = Eigenvalue
  solve_type            = PJFNKMO
  constant_matrices     = true
  petsc_options_iname   = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value   = 'hypre boomeramg 100'
  line_search           = l2 #none
  # Linear/nonlinear iterations.
  l_max_its             = 200
  l_tol                 = 1e-3
  nl_max_its            = 200
  nl_rel_tol            = 1e-5
  nl_abs_tol            = 1e-6
  fixed_point_max_its   = 50
  fixed_point_rel_tol   = 1e-5
  fixed_point_abs_tol   = 1e-6
  free_power_iterations = 4
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]
[Outputs]
  file_base  = htr_pm_griffin_ss_out
  exodus     = true
  csv        = true
  perf_graph = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
