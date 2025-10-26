# ==============================================================================
# Model description
# Equilibrium core neutronics model coupled with TH and pebble temperature models
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 11, 2022
# Author(s): Dr. Sebastian Schunert, Dr. Javier Ortensi, Dr. Mustafa Jaradat
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
INITIAL_temperature = 500.0 # (K)
#total_power = 250.0e+6  # Total reactor Power (W)
burnup_group_boundaries = '5.35E+13 1.070E+14 1.604E+14 2.139E+14 2.674E+14 3.209E+14 3.743E+14 4.278E+14 4.818E+14' 
DHF_1                   =  0.0099013
DHF_2                   =  0.0132799
DHF_3                   =  0.0146952
DHF_4                   =  0.0136383
DHF_5                   =  0.0067246
DHF_6                   =  0.0060207
DHF_tot                 =  0.06426
# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file ='../xsections/HTR-PM_9G-Tnew.xml'
  library_name = 'HTR-PM'
  is_meter = true
[]
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
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
  type = MeshGeneratorMesh
  block_id = '      1            2           3         4       5          6 
                    7            8          61         71'
  block_name = 'pebble_bed    upper_ref lower_ref cavity hot_plenum cold_plenum
                radial_ref carbon_brick	riser cr' 
 [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    # Total height: 16.8 m
    dx = ' 0.250 0.250 0.250 0.250 0.250 0.250
           0.010 0.050 0.130
           0.080 0.080 0.080 
           0.200 0.120 0.125 0.125'
    ix = ' 1 1 1 1 1 1
           1 1 1
           1 1 1
           1 1 1 1'
    dy = ' 0.400 0.400 0.100 0.100
           0.800 0.300 0.200 0.300 0.216 0.412
           0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
           0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
           0.760 0.712 0.300
           0.400 0.400 '
    # base: converges fine
    iy = '1 1 1 1
          2 1 1 1 1 1
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
   type = SubdomainExtraElementIDGenerator
   input = cartesian_mesh
   extra_element_id_names = 'material_id'
   subdomains = '1 2 3 4 5 6 7 8 61 71'
   extra_element_ids = '1 1 1 1 1 1 1 1 1 1'
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
    family = MONOMIAL
    order = CONSTANT
    INITIAL_condition = ${INITIAL_temperature}
  []
  [T_fluid]
    family = MONOMIAL
    order = CONSTANT
    INITIAL_condition = ${INITIAL_temperature}
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
  [Burnup]
    order = CONSTANT
    family = MONOMIAL
    components = 10
    # use burnup midpoints and add one additional for discard group
    INITIAL_condition = '2.675E+13 8.025E+13 1.337E+14 1.872E+14 2.407E+14 2.942E+14 3.476E+14 4.011E+14 4.546E+14 4.546E+14'
    outputs = none
  []
  [Burnup_avg]
    order = CONSTANT
    family = MONOMIAL
  []
  [prompt_power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [decay_power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [power_density]
    order = CONSTANT
    family = MONOMIAL
  []
  [decay_heat_fraction]
    order = CONSTANT
    family = MONOMIAL
  []
  [pden_avg]
    order = CONSTANT
    family = MONOMIAL
  []
  [pden_max]
    order = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F1]
    order  = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F2]
    order  = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F3]
    order  = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F4]
    order  = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F5]
    order  = CONSTANT
    family = MONOMIAL
  []
  [decay_PD_F6]
    order  = CONSTANT
    family = MONOMIAL
  []
  [power_peaking]
    order = CONSTANT
    family = MONOMIAL
  []
  [porosity]
    family = MONOMIAL
    order = CONSTANT
    INITIAL_condition = 0.39
    block = 'pebble_bed'
  []
[]
[AuxKernels]
  [Tfuel_avg]
    type = PebbleAveragedAux
    block = pebble_bed
    variable = Tfuel_avg
    array_variable = triso_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_max]
    type = ArrayVarExtremeValueAux
    block = pebble_bed
    variable = Tfuel_max
    array_variable = triso_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_avg]
    type = PebbleAveragedAux
    block = pebble_bed
    variable = Tmod_avg
    array_variable = graphite_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_max]
    type = ArrayVarExtremeValueAux
    block = pebble_bed
    variable = Tmod_max
    array_variable = graphite_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Burnup_avg]
    type = PebbleAveragedAux
    block = pebble_bed
    variable = Burnup_avg
    array_variable = Burnup
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [prompt_power_density]
    type = VectorReactionRate
    block = 'pebble_bed'
    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 
                   sflux_g5 sflux_g6 sflux_g7 sflux_g8'
    variable = prompt_power_density
    cross_section = kappa_sigma_fission
    scale_factor = power_scaling
    dummies = UnscaledTotalPower
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F1_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F1
    args       = 'prompt_power_density'
    function   = '${DHF_1} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F2_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F2
    args       = 'prompt_power_density'
    function   = '${DHF_2} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F3_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F3
    args       = 'prompt_power_density'
    function   = '${DHF_3} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F4_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F4
    args       = 'prompt_power_density'
    function   = '${DHF_4} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F5_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F5
    args       = 'prompt_power_density'
    function   = '${DHF_5} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_PD_F6_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_PD_F6
    args       = 'prompt_power_density'
    function   = '${DHF_6} * prompt_power_density/(1-${DHF_tot})'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [decay_power_density_aux]
    type       = ParsedAux
    block      = 'pebble_bed'
    variable   = decay_power_density
    args       = 'decay_PD_F1 decay_PD_F2 decay_PD_F3 decay_PD_F4 decay_PD_F5 decay_PD_F6'
    function   = 'decay_PD_F1 + decay_PD_F2 + decay_PD_F3 + decay_PD_F4 + decay_PD_F5 + decay_PD_F6'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [power_density]
    type = ParsedAux
    block = 'pebble_bed'
    variable = power_density
    args = 'prompt_power_density decay_power_density'
    function = 'prompt_power_density + decay_power_density'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [pden_max]
    type = ArrayVarExtremeValueAux
    block = 'pebble_bed'
    variable = pden_max
    array_variable = partial_power_density
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pden_avg]
    type = PebbleAveragedAux
    block = 'pebble_bed'
    variable = pden_avg
    array_variable = partial_power_density
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [power_peaking]
    type = ParsedAux
    block = 'pebble_bed'
    variable = power_peaking
    args = 'power_density'
    function = 'power_density / 3.21525E+06'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[UserObjects]
  [power_map]
    type = VariableCartesianCoreMap
    variables = 'power_density'
    block = pebble_bed
    execute_on = 'FINAL'
    output_in = 'power_ss.out'
  []
  [isotopic_map]
    type = VariableCartesianCoreMap
	variables = 'isotope_density_U235 isotope_density_U236 isotope_density_U238 isotope_density_PU238
                 isotope_density_PU239 isotope_density_PU240 isotope_density_PU241 isotope_density_PU242
                 isotope_density_AM241 isotope_density_AM242M isotope_density_CS135 isotope_density_CS137
                 isotope_density_XE135 isotope_density_XE136 isotope_density_I131 isotope_density_I135
                 isotope_density_SR90'
    block = pebble_bed
    execute_on = 'FINAL'
    output_in = 'isotopics_ss.out'
  []
  [burnup_map]
    type = VariableCartesianCoreMap
    variables = 'Burnup_avg'
    block = pebble_bed
    execute_on = 'FINAL'
    output_in = 'burnup_ss.out'
  []
  [transport_solution]
    type = TransportSolutionVectorFile
    transport_system = diff
    writing = true
    execute_on = 'FINAL'
  []
  [depletion_solution]
    type = SolutionVectorFile
    var = 'pebble_isotope_density pebble_volume_fraction graphite_temperature triso_temperature 
	         power_density partial_power_density
		       pebble_bed_depletion_sflux_g0 pebble_bed_depletion_sflux_g1
           pebble_bed_depletion_sflux_g2 pebble_bed_depletion_sflux_g3
           pebble_bed_depletion_sflux_g4 pebble_bed_depletion_sflux_g5
           pebble_bed_depletion_sflux_g6 pebble_bed_depletion_sflux_g7
           pebble_bed_depletion_sflux_g8 '
    writing = true
    execute_on = 'FINAL'
  []
  [TH_solution]
    type = SolutionVectorFile
    var = 'T_solid T_fluid'
    writing = true
    execute_on = 'FINAL'
  []
  [init_power_density]
    type = SolutionVectorFile
    var = 'prompt_power_density decay_power_density decay_PD_F1 decay_PD_F2 decay_PD_F3 decay_PD_F4 decay_PD_F5 decay_PD_F6' 
    writing = true
    execute_on = 'FINAL'
  []
[]
# ==============================================================================
# MATERIALS
# ==============================================================================
[PebbleDepletion]
  block = pebble_bed
  scale_factor = power_scaling
  burnup_grid_name = 'Burnup'
  fuel_temperature_grid_name = 'Tfuel'
  moderator_temperature_grid_name = 'Tmod'
  # transmutation data
  dataset = ISOXML
  isoxml_data_file = '../xsections/DRAGON5_DT.xml'
  isoxml_lib_name = 'DRAGON'
  burnup_group_boundaries = ${burnup_group_boundaries}
  n_fresh_pebble_types = 1
  INITIAL_moderator_temperature = ${INITIAL_temperature}
  INITIAL_fuel_temperature = ${INITIAL_temperature}
  track_isotopes = 'U235 U236 U238 PU238 PU239 PU240 PU241 PU242 AM241 AM242M CS135 CS137 XE135 XE136 I131 I135 SR90'
[]              
[Materials]
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
  [control_rod]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = 'cr'
    grid_names = 'Tmod  Tmod  Tmod'
    grid_variables = 'T_solid  T_solid  T_solid'
    plus = true
    isotopes  =  '   Graphite   U235 ;      Graphite            B10          B11            C12   U235;       Graphite            B10          B11            C12   U235'
    densities =  ' 6.4277e-02     0.0     6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0      6.4277e-02     1.6373e-03   5.9938e-03     1.6004e-02    0.0'
    segment_material_ids = '1   1   1'
    rod_segment_length = 11.878
    front_position_function = 'CR_bott'
    rod_withdrawn_direction = 'y'
  []
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
  [streamline]
    type = FullSolveMultiApp
    input_files = 'depletion_sub.i'
    keep_solution_during_restore = true
    execute_on = 'INITIAL TIMESTEP_END'
    max_procs_per_app = 6
  []
  [flow]
    type = FullSolveMultiApp
    input_files = 'htr-pm-flow-fv-ss.i'
    keep_solution_during_restore = true
    positions = '0 0 0'
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 20
  []
  [pebble0]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble1]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble2]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble3]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble4]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble5]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble6]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble7]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble8]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
  [pebble9]
    type = FullSolveMultiApp
    input_files = 'pebble_triso.i'
    keep_solution_during_restore = true
    positions_file = 'pebble_heat_pos.txt'
    execute_on = 'TIMESTEP_END'
  []
[]
[Transfers]
  # depletion simulation
  [from_nearest_streamline_transfer]
    type = MultiAppNearestStreamlineTransfer
    block = pebble_bed
    from_multi_app = streamline
    major_streamline_axis = y
    primary_variable_names = 'pebble_isotope_density pebble_volume_fraction'
    secondary_variable_names = 'pebble_isotope_density pebble_volume_fraction'
  []
  [to_nearest_streamline_transfer]
    type = MultiAppNearestStreamlineTransfer
    block = pebble_bed
    to_multi_app = streamline
    major_streamline_axis = y
    primary_variable_names = 'graphite_temperature triso_temperature partial_power_density
                              pebble_bed_depletion_sflux_g0 pebble_bed_depletion_sflux_g1
                              pebble_bed_depletion_sflux_g2 pebble_bed_depletion_sflux_g3
                              pebble_bed_depletion_sflux_g4 pebble_bed_depletion_sflux_g5
                              pebble_bed_depletion_sflux_g6 pebble_bed_depletion_sflux_g7
                              pebble_bed_depletion_sflux_g8 porosity'
    secondary_variable_names = 'graphite_temperature triso_temperature partial_power_density
                                sflux_g0 sflux_g1 sflux_g2
                                sflux_g3 sflux_g4 sflux_g5
                                sflux_g6 sflux_g7 sflux_g8 porosity'
  []
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
  [pebble_send_Tsolid0]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble0
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid1]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble1
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid2]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble2
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid3]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble3
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid4]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble4
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid5]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble5
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid6]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble6
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid7]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble7
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid8]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble8
    postprocessor = T_surface
    source_variable = T_solid
  []
  [pebble_send_Tsolid9]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble9
    postprocessor = T_surface
    source_variable = T_solid
  []
  # TO Pebble Partial power density.
  [pebble_send_ppd0]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble0
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 0
  []
  [pebble_send_ppd1]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble1
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 1
  []
  [pebble_send_ppd2]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble2
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 2
  []
  [pebble_send_ppd3]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble3
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 3
  []
  [pebble_send_ppd4]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble4
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 4
  []
  [pebble_send_ppd5]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble5
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 5
  []
  [pebble_send_ppd6]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble6
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 6
  []
  [pebble_send_ppd7]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble7
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 7
  []
  [pebble_send_ppd8]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble8
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 8
  []
  [pebble_send_ppd9]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble9
    postprocessor = pebble_power_density
    source_variable = partial_power_density
    source_variable_component = 9
  []
  # FROM Pebble T_mod (Pebble average temperature)
  [pebble_receive_T_mod_0]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble0
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 0
  []
  [pebble_receive_T_mod_1]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble1
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 1
  []
  [pebble_receive_T_mod_2]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble2
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 2
  []
  [pebble_receive_T_mod_3]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble3
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 3
  []
  [pebble_receive_T_mod_4]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble4
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 4
  []
  [pebble_receive_T_mod_5]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble5
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 5
  []
  [pebble_receive_T_mod_6]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble6
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 6
  []
  [pebble_receive_T_mod_7]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble7
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 7
  []
  [pebble_receive_T_mod_8]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble8
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 8
  []
  [pebble_receive_T_mod_9]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble9
    postprocessor = T_mod
    source_variable = graphite_temperature
    source_variable_component = 9
  []
  # FROM Pebble T_fuel (TRISO average temperature)
  [pebble_receive_T_fuel_0]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble0
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 0
  []
  [pebble_receive_T_fuel_1]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble1
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 1
  []
  [pebble_receive_T_fuel_2]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble2
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 2
  []
  [pebble_receive_T_fuel_3]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble3
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 3
  []
  [pebble_receive_T_fuel_4]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble4
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 4
  []
  [pebble_receive_T_fuel_5]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble5
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 5
  []
  [pebble_receive_T_fuel_6]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble6
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 6
  []
  [pebble_receive_T_fuel_7]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble7
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 7
  []
  [pebble_receive_T_fuel_8]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble8
    postprocessor = T_fuel
    source_variable = triso_temperature
    source_variable_component = 8
  []
  [pebble_receive_T_fuel_9]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble9
    postprocessor = T_fuel
    source_variable = triso_temperature
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
  type = Eigenvalue
  solve_type = PJFNKMO
  constant_matrices = true
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = l2 #none
  # Linear/nonlinear iterations.
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 200
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-6
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-5
  fixed_point_abs_tol = 1e-6
  # Power iterations.
  free_power_iterations = 4
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [max_T_solid]
    type = ElementExtremeValue
    variable = T_solid
  []
  [Tsolid_core]
    type = ElementAverageValue
    variable = T_solid
  []
  [Tfluid_core]
    type = ElementAverageValue
    variable = T_fluid
  []
  [Tfuel_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Tfuel_avg
  []
  [Tfuel_max]
    type = ElementExtremeValue
    block = 'pebble_bed'
    value_type = max
	variable = Tfuel_avg
  []
  [Tmod_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Tmod_avg
  []
  [Tmod_max]
    type = ElementExtremeValue
    block = 'pebble_bed'
    variable = Tmod_max
    value_type = max
  []
  [Burnup_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Burnup_avg
  []
  [UnscaledTotalPower]
    type = FluxRxnIntegral
    block = 'pebble_bed'
    cross_section  = kappa_sigma_fission
    coupled_flux_groups = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 
                           sflux_g5 sflux_g6 sflux_g7 sflux_g8'
    execute_on = 'transfer TIMESTEP_END'
  []
  [power_scaling]
    type = PowerModulateFactor
    power_pp = UnscaledTotalPower
    rated_power = 2.33935E+08 # Power * (1-DHF_tot)
    execute_on = 'transfer TIMESTEP_END'
  []
  [prompt_power]
    type = ElementIntegralVariablePostprocessor
    block = 'pebble_bed'
    variable = prompt_power_density
    execute_on = 'transfer TIMESTEP_END'
  []
  [decay_power]
    type = ElementIntegralVariablePostprocessor
    block = 'pebble_bed'
    variable = decay_power_density
    execute_on = 'transfer TIMESTEP_END'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    block = 'pebble_bed'
    variable = power_density
    execute_on = 'transfer TIMESTEP_END'
  []
  [avg_power_density]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = power_density
    execute_on = 'transfer TIMESTEP_END'
  []
  [power_peak]
    type = ElementExtremeValue
    variable = power_peaking
    value_type = max
  []
[]
[Debug]
  show_var_residual_norms = false
[]
[Outputs]
  file_base = htr_pm_griffin_ss_out
  exodus = true
  csv = true
  perf_graph = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
