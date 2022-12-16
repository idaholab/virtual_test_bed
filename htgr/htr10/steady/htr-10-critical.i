# ==============================================================================
# Model description
# Application : Griffin
# ------------------------------------------------------------------------------
# Idaho Falls, INL, May 31st, 2022
# Author(s): Javier Ortensi
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - HTR Critical Configuration GRIFFIN neutronics input
# - MainApp
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Benchmark Analysis of the HTR-10 with the MAMMOTH Reactor Physics
#     Application, J. Ortensi et al.
# [2] Evaluation of high temperature gas cooled reactor performance: benchmark
#     analysis related to initial testing of the httr and htr-10.
#     Technical Report IAEA-TECDOC-1382, International Reactor Physics
#     Experiment Evaluation Project, 2003.
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

absorption_blocks = '10 11 12 13 14 15 16 17 18 20 21 22 30 31 32 40 41 42 43 44 45 46 50 52'
fuel_blocks = '16 17 20 21 30 31'
non_fuel_blocks = '10 11 12 13 14 15 18 22 32 42 43 44 45 46 50 52'
TDC_blocks = '40 41'

# State ------------------------------------------------------------------------
# see state on xs library
# Power ------------------------------------------------------------------------

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  coupled_flux_groups = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5 sflux_g6 sflux_g7 sflux_g8 sflux_g9'
  scalar_flux = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5 sflux_g6 sflux_g7 sflux_g8 sflux_g9'
  library_file = '../data/xs/htr-10-XS.xml'
  library_name = 'htr-10-critical'
  grid_names = 'default'
  grid = '1'
  plus = 1
  isotopes = 'pseudo'
  densities = '1.0'
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [./fmg]
    type = FileMeshGenerator
    file = '../data/mesh/htr-10-critical-a-rev6.e'
    exodus_extra_element_integers = 'eqv_id material_id'
  [../]
  [./eqvid]
    type = ExtraElementIDCopyGenerator
    input = fmg
    source_extra_element_id = eqv_id
    target_extra_element_ids = 'equivalence_id'
  [../]
  # These modifiers are used to remove the boronated bricks that surround the core
  # from the original mesh
  [./delete_bricks]
    type = BlockDeletionGenerator
    input = eqvid
    block = '3 4 5'
  [../]
  [./sideset_side]
    type = ParsedGenerateSideset
    input = delete_bricks
    combinatorial_geometry = 'sqrt(x*x+y*y) > 165.0'
    new_sideset_name = 1
  [../]
  [./sideset_bot]
    type = ParsedGenerateSideset
    input = sideset_side
    combinatorial_geometry = 'z < 41'
    included_subdomains = '10 11 12'
    normal = '0 0 -1'
    new_sideset_name = 2
  [../]
  [./sideset_top]
    type = ParsedGenerateSideset
    input = sideset_bot
    combinatorial_geometry = 'z > 490'
    included_subdomains = '52 45 46'
    normal = '0 0 1'
    new_sideset_name = 3
  [../]
[]

[Equivalence]
  type = SPH
  transport_system = diff
  compute_factors = false
  equivalence_grid_names = 'default'
  equivalence_grid = '1'
  equivalence_library = '../data/sph/htr-10-Diff-SPH.xml'
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
  [./AbsorptionRR]
    order = FIRST
    family = MONOMIAL
    block = ${absorption_blocks}
  [../]
  [./NuFissionRR]
    order = FIRST
    family = MONOMIAL
    block = ${fuel_blocks}
  [../]
[]

[AuxKernels]
  [./AbsorptionRR]
    type = VectorReactionRate
    block = ${absorption_blocks}
    variable = AbsorptionRR
    cross_section = sigma_absorption
    scale_factor = power_scaling
    dummies = _unscaled_total_power
    execute_on = timestep_end
  [../]
  [./nuFissionRR]
    type = VectorReactionRate
    block = ${fuel_blocks}
    variable = NuFissionRR
    cross_section = nu_sigma_fission
    scale_factor = power_scaling
    dummies = _unscaled_total_power
    execute_on = timestep_end
  [../]
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [./fissile]
    type = MixedMatIDNeutronicsMaterial
    block = ${fuel_blocks}
  [../]
  [./non_fissile]
    type = MixedMatIDNeutronicsMaterial
    block = ${non_fuel_blocks}
  [../]
  [./TDC-materials]
    type = MixedMatIDNeutronicsMaterial
    block = ${TDC_blocks}
  [../]
[]

[PowerDensity]
  power = 1
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
[]

# ==============================================================================
# TRANSPORT SYSTEMS
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 10
  VacuumBoundary = '1 2 3'

  [./diff]
   scheme = CFEM-Diffusion
   n_delay_groups = 0
   family = LAGRANGE
   order = FIRST
   assemble_scattering_jacobian = true
   assemble_fission_jacobian = true
  [../]
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Eigenvalue

  # Preconditioned JFNK (default)
  solve_type = 'PJFNKMO'
  constant_matrices = true
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  free_power_iterations = 1
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-7
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================
[MultiApps]
[]

[Transfers]
[]

# ==============================================================================
# RESTART
# ==============================================================================
[RestartVariables]
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [./power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = ${fuel_blocks}
  [../]
  [./nufission]
    type = ElementIntegralVariablePostprocessor
    variable = NuFissionRR
    block = ${fuel_blocks}
  [../]
  [./absorption]
    type = ElementIntegralVariablePostprocessor
    variable = AbsorptionRR
    block = ${absorption_blocks}
  [../]
  [./RR_Generation]
    type = FluxRxnIntegral
    cross_section = nu_sigma_fission
    block = ${fuel_blocks}
  [../]
  [./RR_Absorption]
    type = FluxRxnIntegral
    cross_section = sigma_absorption
    block = ${absorption_blocks}
  [../]
  [./RR_Leakage]
    type = PartialSurfaceCurrent
    boundary = '1 2 3'
    transport_system = diff
  [../]
[]

[Outputs]
 file_base = out_HTR-10_critical
 interval = 1
 exodus = true
 csv = true
 [./console]
   type = Console
 [../]
[]
