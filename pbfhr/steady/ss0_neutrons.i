# ==============================================================================
# Model description
# Application : Griffin
# ------------------------------------------------------------------------------
# Idaho Falls, INL, September 7th, 2020
# Author(s): Dr. Guillaume Giudicelli, Dr. Paolo Balestra
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - MK1-FHR GRIFFIN neutronics input
# - MasterApp
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Multiscale Core Thermal Hydraulics Analysis of the Pebble Bed Fluoride
#     Salt Cooled High Temperature Reactor (PB-FHR), A. Novak et al.
# [2] Technical Description of the “Mark 1” Pebble-Bed Fluoride-Salt-Cooled
#     High-Temperature Reactor (PB-FHR) Power Plant, UC Berkeley report 14-002
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

initial_fuel_temperature = 1073.15 # (K)
initial_salt_temperature = 923.15  # (K)

# Power ------------------------------------------------------------------------
total_power          = ${fparse 236.0e6} # Total reactor Power (W)
dh_fract             = 6.426e-2               # Decay heat fraction at t = 0.0s.
fis_fract            = ${fparse 1 - dh_fract} # Fission power fraction at t = 0.0s.

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file = "cross_sections/2-D_8Gt_multiregions_transient.xml"
  library_name = 2-D_8Gt
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 8

  ReflectingBoundary = 'reflector_surface'
  VacuumBoundary = 'brick_surface top bottom'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    family = LAGRANGE
    order = FIRST
    # verbose = 2
  []
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

# Save time by using a previously computed solution
# restart_file = 'mk1_fhr.e'  # uncomment near bottom of input file to use restart

[Mesh]
  coord_type = RZ
  uniform_refine = 2
  [mesh_reader]
    type = FileMeshGenerator
    file = '../meshes/core_pronghorn.e'
  []
  [new_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    input = mesh_reader
    primary_block = '9'
    paired_block = '10'
    new_boundary = 'brick_surface'
  []
  [delete_bricks]
    type = BlockDeletionGenerator
    input = new_boundary
    block = '10'
  []
  [reflector]
    type = SideSetsFromNormalsGenerator
    input = delete_bricks
    new_boundary = 'reflector_surface'
    normals = '-1 0 0'
  []
  [top_bottom]
    type = SideSetsFromNormalsGenerator
    input = reflector
    new_boundary = 'top bottom'
    normals = '0 1 0 0 -1 0'
  []
[]

[Problem]
  # restart_file_base = 'ss0_neutrons_Checkpoint_cp/LATEST'
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
[]

[Kernels]
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [Tfuel]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_fuel_temperature}
    block = '1 2 3 4 5 6 7 8 9'  #FIXME
  []
  [Tsalt]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_salt_temperature}
    block = '1 2 3 4 5 6 7 8 9'  #FIXME
  []
  [CR_insertion]
    family = MONOMIAL
    order = CONSTANT
    block = '1 2'
  []
  [fission_power_density] # Energy fraction released Instantaneously from fission (W).
    family = MONOMIAL
    order = CONSTANT
  []
  [decay_heat_power_density] # Energy fraction released by fission products (W).
    family = MONOMIAL
    order = CONSTANT
  []
  [total_power_density] # Total Energy released from fission events (W).
    family = MONOMIAL
    order = CONSTANT
  []
  [scaled_sflux_g0]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g1]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g2]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g3]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g4]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g5]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g6]
    family = LAGRANGE
    order = FIRST
  []
  [scaled_sflux_g7]
    family = LAGRANGE
    order = FIRST
  []
[]

[AuxKernels]
  [fission_power_density]
    type = ScaleAux
    multiplier = ${fis_fract}
    variable = fission_power_density
    source_variable = inst_power_density
  []
  [decay_heat_power_density]
    type = ScaleAux
    multiplier = ${dh_fract}
    variable = decay_heat_power_density
    source_variable = inst_power_density
  []
  [total_power_density]
    type = ParsedAux
    function = 'fission_power_density + decay_heat_power_density'
    args = 'fission_power_density decay_heat_power_density'
    variable = total_power_density
    execute_on = 'INITIAL timestep_end'
  []
  [scale_flux_g0]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g0
    variable = scaled_sflux_g0
  []
  [scale_flux_g1]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g1
    variable = scaled_sflux_g1
  []
  [scale_flux_g2]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g2
    variable = scaled_sflux_g2
  []
  [scale_flux_g3]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g3
    variable = scaled_sflux_g3
  []
  [scale_flux_g4]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g4
    variable = scaled_sflux_g4
  []
  [scale_flux_g5]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g5
    variable = scaled_sflux_g5
  []
  [scale_flux_g6]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g6
    variable = scaled_sflux_g6
  []
  [scale_flux_g7]
    type = ScaleAux
    multiplying_pp = power_scaling
    source_variable = sflux_g7
    variable = scaled_sflux_g7
  []
  [rod_insertion]
    type = FunctionAux
    function = control_rod_position
    variable = 'CR_insertion'
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
  [control_rod_position]
    type = PiecewiseLinear
    x = '0 10'
    y = '2 2'
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[PowerDensity]
  power = ${fparse total_power * fis_fract}
  power_density_variable = inst_power_density
  integrated_power_postprocessor = total_power
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[Materials]
  # TODO: Make a Tsalt_ave variable to propagate effect of Tsalt to other regions
  # TODO: Generate cross sections for the plenum region separately
  [inner_reflector]
    type = CoupledFeedbackNeutronicsMaterial  #FIXME
    grid_names = 'Tfuel Tsalt CR'
    grid_variables = 'Tfuel Tsalt CR_insertion'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100000
    block = 1
  []
  [control_rod]
    type = CoupledFeedbackNeutronicsMaterial  #FIXME
    grid_names = 'Tfuel Tsalt CR'
    grid_variables = 'Tfuel Tsalt CR_insertion'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100001
    block = 2
  []
  [pebble_bed]
    type = CoupledFeedbackNeutronicsMaterial
    grid_names = 'Tfuel Tsalt'
    grid_variables = 'Tfuel Tsalt'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100002
    block = 3
  []
  [pebble_reflector]
    type = CoupledFeedbackNeutronicsMaterial  #FIXME
    grid_names = 'Tfuel Tsalt'
    grid_variables = 'Tfuel Tsalt'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100007
    block = 4
  []
  [outer_reflector]
    type = CoupledFeedbackNeutronicsMaterial  #FIXME
    grid_names = 'Tfuel Tsalt'
    grid_variables = 'Tfuel Tsalt'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100008
    block = '5 6'
  []
  [barrel_vessel]
    type = CoupledFeedbackNeutronicsMaterial  #FIXME
    grid_names = 'Tfuel Tsalt'
    grid_variables = 'Tfuel Tsalt'
    plus = true
    diffusion_coefficient_scheme = local
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 100009
    block = '7 8 9'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Eigenvalue

  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 100'
  line_search = none
  snesmf_reuse_base = false

  # Linear/nonlinear iterations
  l_max_its = 100
  l_tol = 1e-3

  nl_max_its = 50
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-5

  # Power iterations, before the non-linear solve
  free_power_iterations = 2

  # Fixed point iterations
  fixed_point_abs_tol = 1e-6
  fixed_point_rel_tol = 1e-6
  fixed_point_max_its = 10
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================

[MultiApps]
  [thermo]
    type = FullSolveMultiApp
    input_files = 'ss1_combined.i'
    execute_on = 'timestep_end' # once power distribution is computed
    positions = '0.0 0.0 0.0'
  []
[]

[Transfers]
  [power_tosub]
    type = MultiAppProjectionTransfer
    to_multi_app = thermo
    source_variable = total_power_density
    variable = power_distribution
    to_postprocessors_to_be_preserved = power
    from_postprocessors_to_be_preserved = total_power
    execute_on = 'timestep_end' # overwrite initial condition
  []
  [Tcoolant_fromsub]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = thermo
    source_variable = T_fluid
    variable = Tsalt
    execute_on = 'timestep_end'
  []
  [Tfuel_fromsub]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = thermo
    source_variable = T_solid
    variable = Tfuel
    execute_on = 'timestep_end'
  []
  [num_fixed_point]
    type = MultiAppPostprocessorTransfer
    to_multi_app = thermo
    from_postprocessor = num_fixed_point
    to_postprocessor = num_fixed_point
  []
[]

# ==============================================================================
# RESTART
# ==============================================================================

# [RestartVariables]
#   [initial_guess]
#     exodus_filename = ${restart_file}
#     variable_names = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5
#                       sflux_g6 sflux_g7'
#     target_variable_names = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5
#                              sflux_g6 sflux_g7'
#   []
#   [initial_guess_aux]
#     exodus_filename = ${restart_file}
#     variable_names = 'Tfuel Tsalt fission_power_density decay_heat_power_density total_power_density'
#     target_variable_names = 'Tfuel Tsalt fission_power_density decay_heat_power_density total_power_density'
#     to_system = 'AUXILIARY'
#   []
# []

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================

[Postprocessors]
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = total_power_density
    block = '3'
    execute_on = 'transfer'
  []

  # For convergence study
  [h]
    type = AverageElementSize
    outputs = 'console csv'
    execute_on = 'timestep_end'
  []
  [max_power]
    type = ElementExtremeValue
    variable = total_power_density
    block = '3'
  []
  [num_fixed_point]
    type = NumFixedPointIterations
  []
[]

[Outputs]
  exodus = true
  csv = true
  [Checkpoint]
    type = Checkpoint
    execute_on = 'FINAL'
  []
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
