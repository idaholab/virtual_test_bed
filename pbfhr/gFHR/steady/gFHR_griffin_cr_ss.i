#  OFFICIAL USE ONLY
#  May be exempt from public release under the Freedom of Information Act
#  (5 U.S.C. 552), exemption number and category: 4 Commercial/Proprietary
#  Review required before public release Name/Org: Javier Ortensi C110.
#  Date: 11/4/2021. Guidance (if applicable): N/A
# ==============================================================================
# Model description:
# Coupled neutronics-thermal-fluids model to streamline method for equilibrium core
# The pebble model resolution is based on fluids mesh
#
# 4 energy group structure:
#   1.96403000E+07  1.95007703E+05
#   1.95007703E+05  1.75647602E+01
#   1.75647602E+01  2.33006096E+00
#   2.33006096E+00  1.10002700E-04
# ------------------------------------------------------------------------------
# Idaho Falls, INL, October 21, 2021
# Author(s): Javier Ortensi
# Modified: Stefano Terlizzi
# Modified (July 2023 and after): Vincent Laboure
# MODEL PARAMETERS
# ==============================================================================
# parameters describing the reactor geometry --------------------------------------------
core_height = 3.0947
active_core_radius = 1.2
porosity = 0.4011505932

# parameters describing the pebbles --------------------------------------------
burnup_group_boundaries = '1.8688E+14 3.7375E+14 5.6063E+14 7.4750E+14 9.3438E+14 1.1213E+15 1.280E+15 1.3509E+15'
burnup_group_avg = '9.3440E+13 2.8032E+14 4.6719E+14 6.5407E+14 8.4094E+14 1.0278E+15 1.2007E+15 1.3155E+15 1.3155E+15' # use burnup midpoints and add one additional for discard group
burnup_limit = 1.3509E+15

pebble_radius = 2e-2
pebble_volume = '${fparse 4 / 3 * pi * pebble_radius * pebble_radius * pebble_radius}'
streamline_flow_fraction = '0.0625 0.1875 0.3125 0.4375' # 4 streamline

residence_time = 65.25 # time in days to approximate 8 passes
pebble_speed = '${fparse core_height/ (residence_time * 3600 * 24)}'
pebble_flow_area = '${fparse pi * active_core_radius * active_core_radius}'
pebble_unloading_rate = '${fparse pebble_speed * pebble_flow_area * (1.0 - porosity) / pebble_volume}'

# Power --------------------------------------------
total_power = 280.0e+6 # Total reactor Power (W)

# Initial values  --------------------------------------------
initial_temperature = 873.15 # (K)
Rho = 1973.8 # kg/m^3 900.0 K
Rho_ref = 1973.8 # kg/m^3

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file = '../data/gFHR_4g_pebble.xml'
  library_name = 'gFHR'
  is_meter = true
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 4
  ReflectingBoundary = 'left'
  VacuumBoundary = 'right top bottom'

  [diff]
    scheme = CFEM-Diffusion
    family = LAGRANGE
    order = FIRST
    n_delay_groups = 6
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
    diffusion_kernel_type = vector
  []
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  block_id = '     1        3          4      5      6'
  block_name = 'pebble_bed  reflector   ss downcomer  cr'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = '0.9 0.3 0.156 0.444 0.02 0.05 0.04'
    ix = ' 12   4    4     4    1     1    1'

    dy = '0.6 0.30947 2.47576 0.30947 0.6'
    iy = '  8    4       32       4     8'

    subdomain_id = '
   3 3 3 3 4 5 4
   2 2 6 3 4 5 4
   1 2 6 3 4 5 4
   2 2 6 3 4 5 4
   3 3 6 3 4 5 4'
  []

  [assign_material_id]
    type = SubdomainExtraElementIDGenerator
    subdomains = '1 2 3 4 5 6 '
    extra_element_id_names = 'material_id'
    extra_element_ids = '1 2 3 4 5 2'
    input = cartesian_mesh
  []
  [merge]
    type = RenameBlockGenerator
    input = assign_material_id
    old_block = '1 2 3 4 5 6'
    new_block = '1 1 3 4 5 6'
  []
  coord_type = RZ
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [Tsolid]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = '${initial_temperature}'
  []
  [Rho]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = '${Rho}'
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
    components = 9
    # use burnup midpoints and add one additional for discard group
    initial_condition = ${burnup_group_avg}
    # outputs = none
  []
  [Burnup_avg]
    order = CONSTANT
    family = MONOMIAL
  []
  [porosity]
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
[]

[AuxKernels]
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
  [Tfuel_avg]
    type = PebbleAveragedAux
    block = 'pebble_bed'
    variable = Tfuel_avg
    array_variable = triso_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_max]
    type = ArrayVarExtremeValueAux
    block = 'pebble_bed'
    variable = Tfuel_max
    array_variable = triso_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_avg]
    type = PebbleAveragedAux
    block = 'pebble_bed'
    variable = Tmod_avg
    array_variable = graphite_temperature
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_max]
    type = ArrayVarExtremeValueAux
    block = 'pebble_bed'
    variable = Tmod_max
    array_variable = graphite_temperature
    value_type = MAX
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Burnup_avg]
    type = PebbleAveragedAux
    block = 'pebble_bed'
    variable = Burnup_avg
    array_variable = Burnup
    pebble_volume_fraction = pebble_volume_fraction
    n_fresh_pebble_types = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [porosity]
    type = FunctionAux
    block = 'pebble_bed'
    variable = porosity
    function = porosity_f
    execute_on = 'INITIAL'
  []
[]

[Functions]
  [porosity_f]
    type = PiecewiseMulticonstant
    direction = 'right right'
    data_file = '../data/gFHR_porosity.txt'
  []
  [CR_pos_f]
    type = ConstantFunction
    value = '2.614' #Note that when position is 3.6947 CR is withdrawn
  []
[]

[UserObjects]
  [transport_solution_cr]
    type = TransportSolutionVectorFile
    transport_system = diff
    writing = true
    execute_on = 'FINAL'
  []
  [depletion_solution_cr]
    type = SolutionVectorFile
    var = 'pebble_isotope_density pebble_volume_fraction graphite_temperature triso_temperature total_power_density partial_power_density
           Rho Tsolid'
    writing = true
    execute_on = 'FINAL'
  []
[]

# ==============================================================================
# DEPLETION
# ==============================================================================
[PebbleDepletion]
  block = 'pebble_bed'
  # scale_factor = power_scaling

  power = ${total_power}
  integrated_power_postprocessor = total_power
  power_density_variable = total_power_density
  family = MONOMIAL
  order = CONSTANT

  burnup_grid_name = 'Burnup'
  fuel_temperature_grid_name = 'Tfuel'
  moderator_temperature_grid_name = 'Tmod'
  additional_grid_name_variable_mapping = 'Rho Rho'

  # coolant settings
  coolant_composition_name = coolant
  coolant_density_variable = 'Rho'
  #coolant_atomic_densities = 'LI6 4.38333E-07 LI7 2.40010E-02 BE9 1.20001E-02 F19 4.80084E-02' # equilibrium values
  coolant_density_ref = ${Rho_ref}

  # transmutation data
  dataset = ISOXML
  isoxml_data_file = '../data/DRAGON5_DT.xml'
  isoxml_lib_name = 'DRAGON'
  #strictness = 0 # to avoid errors in ISOXML w.r.t. unphysical branching ratios for DH pseudos
  dtl_physicality = RATIO_SUM

  # Isotopic options
  n_fresh_pebble_types = 1
  #fresh_pebble_isotopes = 'U234           U235            U238            C12              O16              O17            Graphite          SI28        SI29              SI30           pseudo_G'
  #fresh_pebble_compositions = 'U234 1.43856269E-08 U235 5.09162564E-05 U238  2.06863668E-04 C12 9.03720735E-04 O16 3.86545726E-04 O17 1.46942583E-07 Graphite  4.81177028E-03 SI28 7.14571157E-04 SI29  3.63004146E-05 SI30 2.39580131E-05 pseudo_G 7.41205513E-02'
  fresh_pebble_compositions = pebble
  track_isotopes = 'U235 U236 U238 PU238 PU239 PU240 PU241 PU242 AM241 AM242M CS135 CS137 XE135 XE136 I131 I135 SR90'
  decay_heat = true

  # Pebble options
  porosity_name = porosity
  burnup_group_boundaries = ${burnup_group_boundaries}

  # Tabulation data.
  initial_moderator_temperature = '${initial_temperature}'
  initial_fuel_temperature = '${initial_temperature}'

  [DepletionScheme]
    type = ConstantStreamlineEquilibrium

    # Streamline definition
    major_streamline_axis = y
    streamline_points = '0.152  0.6 0  0.152  3.69469 0;
                         0.450  0.6 0  0.450  3.69469 0;
                         0.750  0.6 0  0.750  3.69469 0;
                         1.1248 0.6 0  1.1248 3.69469 0;'
    streamline_segment_subdivisions = '20; 20; 20; 20' # looks like there are 40 axial elements so choose number that will align with the neutronics mesh
    #material_ids = '1; 1; 1; 1'

    # Pebble options
    pebble_unloading_rate = ${pebble_unloading_rate}
    pebble_flow_rate_distribution = ${streamline_flow_fraction}
    pebble_diameter = '${fparse pebble_radius * 2.0}'
    burnup_limit = '${burnup_limit}'

    # Solver parameters
    sweep_tol = 1e-8
    sweep_max_iterations = 100

    # Output
    exodus_streamline_output = false
  []

  # pebble conduction
  pebble_conduction_input_file = 'gFHR_pebble_triso_ss.i'
  pebble_positions_file = '../data/pebble_heat_pos_16r_40z.txt'
  surface_temperature_sub_app_postprocessor = T_surface
  surface_temperature_main_app_variable = Tsolid
  power_sub_app_postprocessor = pebble_power_density
  fuel_temperature_sub_app_postprocessor = T_fuel
  moderator_temperature_sub_app_postprocessor = T_mod
[]

# ==============================================================================
# COMPOSITIONS & MATERIALS
# ==============================================================================
[Compositions]
  [coolant]
    type = IsotopeComposition
    isotope_densities = 'LI6 4.38333E-07
                         LI7 2.40010E-02
                         BE9 1.20001E-02
                         F19 4.80084E-02'
    density_type = atomic
  []
  [pebble]
    type = IsotopeComposition
    isotope_densities = 'U234 1.43856269E-08
                         U235 5.09162564E-05
                         U238  2.06863668E-04
                         C12 9.03720735E-04
                         O16 3.86545726E-04
                         O17 1.46942583E-07
                         Graphite  4.81177028E-03
                         SI28 7.14571157E-04
                         SI29  3.63004146E-05
                         SI30 2.39580131E-05
                         pseudo_G 7.41205513E-02'
    density_type = atomic
  []
[]

[Materials]
  [CR_dynamic]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = 'cr'
    grid_names = 'Tsolid Tsolid Tsolid'
    grid_variables = 'Tsolid Tsolid Tsolid'
    isotopes = 'pseudo; pseudo; pseudo'
    densities = '1.0 1.0 1.0'
    rod_segment_length = 3.0947
    front_position_function = 'CR_pos_f'
    segment_material_ids = '7 6 7'
    rod_withdrawn_direction = 'y'
    plus = true
  []
  [downcomer]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 'downcomer'
    grid_names = 'Rho'
    grid_variables = 'Rho'
    isotopes = 'pseudo'
    densities = '1.0'
  []
  [non-pebble-bed-regions]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 'reflector ss'
    grid_names = 'Tsolid'
    grid_variables = 'Tsolid'
    isotopes = 'pseudo'
    densities = '1.0'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO
  # only set this flag to true after testing that the matrix is not spectrum dependent
  constant_matrices = false
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = l2

  #Linear/nonlinear iterations.
  l_tol = 1e-3
  l_max_its = 100

  nl_max_its = 50
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8

  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-7
  fixed_point_abs_tol = 1e-8

  # Power iterations.
  free_power_iterations = 2
[]

# ==============================================================================
# MultiApps & Transfers
# ==============================================================================
[MultiApps]
  [flow]
    type = FullSolveMultiApp
    input_files = 'gFHR_pronghorn_ss.i'
    keep_solution_during_restore = true
    positions = '0 -0.09 0'
    execute_on = 'TIMESTEP_END FINAL'
    max_procs_per_app = 12
  []
[]

[Transfers]
  #Pronghorn flow simulation transfer
  [power_density_to_flow]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = flow
    source_variable = total_power_density
    variable = power_density
    from_postprocessors_to_be_preserved = total_power
    to_postprocessors_to_be_preserved = total_power
    #fixed_meshes = true
  []
  [Tsolid_from_flow]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = flow
    source_variable = T_solid
    variable = Tsolid
    #fixed_meshes = true
  []
  [Rho_from_flow]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = flow
    source_variable = rho_var
    variable = Rho
    #fixed_meshes = true
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================

[Postprocessors]
  [Tsolid_core]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Tsolid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Rho_core]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Rho
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Tfuel_avg
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfuel_max]
    type = ElementExtremeValue
    block = 'pebble_bed'
    variable = Tfuel_max
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Tmod_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Tmod_avg
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tmod_max]
    type = ElementExtremeValue
    block = 'pebble_bed'
    variable = Tmod_max
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Burnup_avg]
    type = ElementAverageValue
    block = 'pebble_bed'
    variable = Burnup_avg
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tsolid_reflector]
    type = ElementAverageValue
    block = 'reflector'
    variable = Tsolid
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Debug]
  show_var_residual_norms = false
[]

[DefaultElementQuality]
  aspect_ratio_upper_bound = 1e6
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
  console = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
