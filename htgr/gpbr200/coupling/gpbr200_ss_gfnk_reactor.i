# ==============================================================================
# Model description:
# Equilibrium core neutronics model coupled with TH and pebble temperature
# models.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 4, 2022 11:03 AM
# Author(s)(name alph): David Reger, Dr. Javier Ortensi, Dr. Paolo Balestra,
#   Dr. Ryan Stewart, Dr. Sebastian Schunert, Dr. Zachary Prince.
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Power ------------------------------------------------------------------------
total_power = 200.0e+6 # Total reactor Power (W)

# Initial values ---------------------------------------------------------------
initial_temperature = 900.0 # (K)

# Geometry ---------------------------------------------------------------------
pbed_porosity = 0.39
pbed_top = 11.3354 # Absolute height of the core top in the model (m).

# Pebble Geometry --------------------------------------------------------------
pebble_radius = 3.0e-2 # pebble radius (m)
pebble_shell_thickness = 5.0e-03 # pebble fuel free zone thickness (graphite shell) (m)
pebble_volume = '${fparse 4/3*pi*pebble_radius^3}' # volume of the pebble (m3)
pebble_core_volume = '${fparse 4/3*pi*(pebble_radius-pebble_shell_thickness)^3}' # volume of the pebble occupied by TRISO (m3)
kernel_radius = 2.1250e-04 # kernel particle radius (m)
kernel_volume = '${fparse 4/3*pi*kernel_radius^3}' # volume of the kernel (m3)
buffer_thickness = 1.00e-04 # Thickness of buffer (m)
buffer_radius = '${fparse kernel_radius + buffer_thickness}' # Outer radius of buffer (m)
ipyc_thickness = 4.00e-05 # Thickness of IPyC (m)
ipyc_radius = '${fparse buffer_radius + ipyc_thickness}' # Outer radius of IPyC (m)
sic_thickness = 3.50e-05 # Thickness of SiC (m)
sic_radius = '${fparse ipyc_radius + sic_thickness}' # Outer radius of SiC (m)
opyc_thickness = 4.00e-05 # Thickness of OPyC (m)
opyc_radius = '${fparse sic_radius + opyc_thickness}' # Outer radius of OPyC (m)
triso_volume = '${fparse 4/3*pi*opyc_radius^3}' # volume of the particle (m3)
filling_factor = 0.0934404551647307 # Particle filling factor
triso_number = '${fparse pebble_core_volume * filling_factor / triso_volume}' # number of TRISO particle in a pebble (//)

# Compositions -----------------------------------------------------------------
enrichment = 0.155 # Enrichment in weight fraction
rho_kernel_UCO = 10.4 # Density of UCO (g/cm3)
ACU = 0.3920 # Carbon to Uranium atom ratio in UCO
AOU = 1.4280 # Oxygen to Uranium atom ratio in UCO

MU235 = 235.043929918 # Molar density of U235 (g/mol)
MU238 = 238.050788247 # Molar density of U238 (g/mol)
MC = 12.010735897 # Molar density of Carbon (g/mol)
MO = 15.994914620 # Molar density of Oxygen (g/mol)
enrichment_n = '${fparse enrichment/MU235 / (enrichment/MU235 + (1-enrichment)/MU238)}' # Enrichment in nuclide fration
MUCO = '${fparse MU235*enrichment_n + MU238*(1-enrichment_n) + MC*ACU + MO*AOU}' # UCO molar density (g/mol)
rhon_kernel_UCO = '${fparse rho_kernel_UCO / MUCO * 0.6022140}' # Molar density of UCO (atom/b/cm)

# Kernel number densities (n/b/cm)
rhon_kernel_U235 = '${fparse rhon_kernel_UCO * enrichment_n}'
rhon_kernel_U238 = '${fparse rhon_kernel_UCO * (1 - enrichment_n)}'
rhon_kernel_C = '${fparse rhon_kernel_UCO * ACU}'
rhon_kernel_O = '${fparse rhon_kernel_UCO * AOU}'

# Fractions of pebble volume
kernel_fraction = '${fparse kernel_volume * triso_number / pebble_volume}'

# Pebble volume densities (atoms/b/cm)
rhon_U235 = '${fparse rhon_kernel_U235 * kernel_fraction}'
rhon_U238 = '${fparse rhon_kernel_U238 * kernel_fraction}'

# Parameters describing pebble cycling -----------------------------------------
pebble_unloading_rate = '${fparse 1.5/60}' # pebbles per minute / seconds per minute.
burnup_limit_weight = 147.6 # MWd / kg
rho_U = '${fparse (rhon_U235*MU235 + rhon_U238*MU238) * 1.660539}' # Density of uranium in pebble volume (g/cm3)
burnup_conversion = '${fparse 1e9*3600*24*rho_U}' # Conversion from MWd/kg -> J/m3

# Blocks -----------------------------------------------------------------------
fuel_blocks = '5 6 7 8 9'
cns_disch_blocks = '14'
upref_blocks = '3 16'
upcav_blocks = '4'
lowref_blocks = '10 11 12 13'
crs_blocks = '17 22'
rdref_blocks = '1 2 15'
rpv_blocks = '18 19 20 21'
ref_blocks = '${cns_disch_blocks} ${upref_blocks}
              ${lowref_blocks}
              ${rdref_blocks}'

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  is_meter = true
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [pebble_bed]
    type = FileMeshGenerator
    file = ../data/streamline_mesh_in.e
    exodus_extra_element_integers = 'pebble_streamline_id pebble_streamline_layer_id material_id'
  []
  coord_type = RZ
  rz_coord_axis = Y
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  # Temperatures.
  [T_solid]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_temperature}
    block = '${fuel_blocks} ${ref_blocks} ${crs_blocks} ${rpv_blocks}' # Everything but upper cavity
  []

  # Porosity
  [porosity]
    family = MONOMIAL
    order = CONSTANT
    block = '${fuel_blocks}'
    initial_condition = ${pbed_porosity}
  []
[]

# ==============================================================================
# MATERIALS
# ==============================================================================
[Materials]
  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    library_file = '../data/gpbr200_microxs.xml'
    library_name = 'gpbr200_microxs'
    grid_names = 'tmod'
    grid_variables = 'T_solid'
    isotopes = 'Graphite'
    densities = '8.82418e-2'
    plus = true
    material_id = 2
    diffusion_coefficient_scheme = local
    block = '${ref_blocks}'
  []
  [crs]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '${crs_blocks}'
    library_file = '../data/gpbr200_microxs.xml'
    library_name = 'gpbr200_microxs'
    grid_names = 'tmod'
    grid_variables = 'T_solid'

    isotopes = ' Graphite;
                 Graphite   B10        B11;
                 Graphite'
    densities = '8.82418e-2
                 7.1628E-02 8.9463E-03  2.2229E-03
                 8.82418e-2'

    rod_segment_length = 1e3
    front_position_function = 'cr_front'
    segment_material_ids = '2 2 2'
    rod_withdrawn_direction = 'y'
    average_segment_id = segment_id
  []
  [cavity]
    type = ConstantNeutronicsMaterial
    block = '${upcav_blocks}'
    fromFile = true
    library_file = '../data/gpbr200_void.xml'
    material_id = 10
  []
[]

[Functions]
  # Function describing CR depth
  [cr_depth]
    type = ConstantFunction
    value = 1.747 # Range of control rod insertion: -1.318 -> 8.93
  []
  # Offset from reactor reference frame
  [cr_front]
    type = ParsedFunction
    expression = 'top - cr_depth'
    symbol_names = 'top cr_depth'
    symbol_values = '${pbed_top} cr_depth'
  []
[]

[Compositions]
  [uco]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = '
      U235 ${rhon_kernel_U235}
      U238 ${rhon_kernel_U238}
      C12 ${rhon_kernel_C}
      O16 ${rhon_kernel_O}
    '
  []
  [buffer]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = 'Graphite 5.26466317651E-02'
  []
  [PyC]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = 'Graphite 9.52653336702E-02'
  []
  [SiC]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = '
      SI28 4.43270697709E-02
      SI29 2.25082086520E-03
      SI30 1.48375772443E-03
      C12  4.80616002990E-02
    '
  []
  [matrix]
    type = IsotopeComposition
    density_type = atomic
    isotope_densities = 'Graphite 8.67415932892E-02'
  []
  [triso]
    type = Triso
    compositions = 'uco buffer PyC SiC PyC'
    radii = '${kernel_radius} ${buffer_radius} ${ipyc_radius} ${sic_radius} ${opyc_radius}'
  []
  [triso_fill]
    type = StochasticComposition
    background_composition = matrix
    packing_fractions = ${filling_factor}
    triso_particles = triso
  []
  [pebble]
    type = Pebble
    compositions = 'triso_fill matrix'
    radii = '${fparse pebble_radius - pebble_shell_thickness} ${pebble_radius}'
  []
[]

# ==============================================================================
# PEBBLE DEPLETION
# ==============================================================================
[PebbleDepletion]
  block = '${fuel_blocks}'

  # Power.
  power = ${total_power}
  integrated_power_postprocessor = total_power
  power_density_variable = total_power_density
  family = MONOMIAL
  order = CONSTANT

  # Cross section data.
  library_file = '../data/gpbr200_microxs.xml'
  library_name = 'gpbr200_microxs'
  fuel_temperature_grid_name = 'tfuel'
  moderator_temperature_grid_name = 'tmod'
  burnup_grid_name = 'burnup'
  constant_grid_values = 'kernrad ${fparse kernel_radius * 1000}
                          fillfact ${filling_factor}
                          enrich ${enrichment}'

  # Transmutation data.
  dataset = ISOXML
  isoxml_data_file = '../data/gpbr200_dtl.xml'
  isoxml_lib_name = 'gpbr200_dtl'
  # Some of the branching ratios in the DTL are unphysical, which Griffin will
  # throw a warning for unless this is specified.
  dtl_physicality = 'SILENT'

  # Isotopic options
  n_fresh_pebble_types = 1
  fresh_pebble_compositions = 'pebble'

  # Pebble options
  porosity_name = porosity
  maximum_burnup = '${fparse 196.8 * burnup_conversion}'
  num_burnup_bins = 12

  # Tabulation data.
  initial_moderator_temperature = '${initial_temperature}'
  initial_fuel_temperature = '${initial_temperature}'

  [DepletionScheme]
    type = ConstantStreamlineEquilibrium

    # Streamline definition
    major_streamline_axis = y

    # Pebble options
    pebble_unloading_rate = ${pebble_unloading_rate}
    pebble_flow_rate_distribution = '0.12919675255653704 0.3237409742330389 0.16364127845178317 0.1970045449547337 0.1864164498039072'
    pebble_diameter = '${fparse pebble_radius * 2.0}'
    burnup_limit = '${fparse burnup_limit_weight * burnup_conversion}'

    # Solver parameters
    sweep_tol = 1e-8
    sweep_max_iterations = 20

    # Output
    exodus_streamline_output = false
  []

  diffusion_coefficient_scheme = local
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 9
  ReflectingBoundary = 'rinner'
  VacuumBoundary = 'rtop rbottom router'
  [diff]
    scheme = CFEM-Diffusion
    family = LAGRANGE
    order = FIRST
    n_delay_groups = 6
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
    block = '${fuel_blocks} ${upcav_blocks} ${ref_blocks} ${crs_blocks}' # Excluding RPV and Barrel
  []
[]

[Executioner]
  type = Eigenvalue
  solve_type = 'PJFNKMO'
  constant_matrices = true
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
  line_search = none

  # Linear/nonlinear iterations.
  l_max_its = 100
  l_tol = 1e-3

  nl_max_its = 50
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-9

  # Fixed point iterations.
  fixed_point_min_its = 15
  fixed_point_max_its = 200
  custom_pp = eigenvalue
  custom_abs_tol = 5e-5
  custom_rel_tol = 1e-50
  disable_fixed_point_residual_norm_check = true

  # Power iterations.
  free_power_iterations = 4
  extra_power_iterations = 20
[]

# ==============================================================================
# MULTIAPPS AND TRANSFERS
# ==============================================================================
[Positions]
  [element]
    type = ElementCentroidPositions
    block = ${fuel_blocks}
  []
[]

[MultiApps]
  # Reactor TH.
  [pronghorn_th]
    type = FullSolveMultiApp
    input_files = gpbr200_ss_phth_reactor.i
    keep_solution_during_restore = true
    execute_on = 'TIMESTEP_END'
  []

  # Pebble conduction
  [pebble_conduction]
    type = FullSolveMultiApp
    input_files = gpbr200_ss_bsht_pebble_triso.i
    no_restore = true
    positions_objects = 'element element element element element
                         element element element element element
                         element element element'
    cli_args = 'kernel_radius=${kernel_radius};filling_factor=${filling_factor}'
    execute_on = TIMESTEP_BEGIN
  []
[]

[Transfers]
  # TO Pronghorn.
  [to_pronghorn_total_power_density]
    type = MultiAppCopyTransfer
    to_multi_app = pronghorn_th
    source_variable = total_power_density
    variable = power_density
  []

  # FROM Pronghorn.
  [from_pronghorn_Tsolid]
    type = MultiAppCopyTransfer
    from_multi_app = pronghorn_th
    source_variable = T_solid
    variable = T_solid
  []

  # To pebble conduction
  [to_pebble_conduction_Tsolid]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble_conduction
    postprocessor = pebble_surface_temp
    source_variable = T_solid
  []
  [to_pebble_conduction_power_density]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble_conduction
    postprocessor = porous_media_power_density
    source_variable = partial_power_density
    map_array_variable_components_to_child_apps = true
  []

  # From pebble conduction
  [from_pebble_conduction_Tfuel]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble_conduction
    postprocessor = fuel_average_temp
    source_variable = triso_temperature
    map_array_variable_components_to_child_apps = true
  []
  [from_pebble_conduction_Tmod]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = pebble_conduction
    postprocessor = moderator_average_temp
    source_variable = graphite_temperature
    map_array_variable_components_to_child_apps = true
  []
[]

# ==============================================================================
# POSTPROCESSING AND OUTPUTS
# ==============================================================================

[AuxVariables]
  # Max temperatures and power
  [Tfuel_max]
    family = MONOMIAL
    order = CONSTANT
    block = '${fuel_blocks}'
  []
  [Tmod_max]
    family = MONOMIAL
    order = CONSTANT
    block = '${fuel_blocks}'
  []
  [ppd_max]
    family = MONOMIAL
    order = CONSTANT
    block = '${fuel_blocks}'
  []
[]

[AuxKernels]
  # Max temperatures and power
  [Tfuel_max_aux]
    type = ArrayVarReductionAux
    variable = Tfuel_max
    array_variable = triso_temperature
    value_type = max
    execute_on = TIMESTEP_END
  []
  [Tmod_max_aux]
    type = ArrayVarReductionAux
    variable = Tmod_max
    array_variable = graphite_temperature
    value_type = max
    execute_on = TIMESTEP_END
  []
  [ppd_max_aux]
    type = ArrayVarReductionAux
    variable = ppd_max
    array_variable = partial_power_density
    value_type = max
    execute_on = TIMESTEP_END
  []
[]

[Outputs]
  csv = true
  exodus = true
[]
