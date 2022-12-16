# ==============================================================================
# Model description
# Application : Griffin
# ------------------------------------------------------------------------------
# Idaho Falls, INL, June 23th, 2022
# Author(s): Nicolas Martin
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - VTR GRIFFIN standalone neutronics input
# - MasterApp
# ==============================================================================
# - The Model has been built based on [1].
# ------------------------------------------------------------------------------
# [1] Heidet, F. and Roglans-Ribas, J. Core design activities of the
#       versatile test reactor -- conceptual phase. EPJ Web Conf. 247(2021)
#       01010. doi:10.1051/epjconf/202124701010.
#       URL https://doi.org/10.1051/epjconf/202124701010.
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# State ------------------------------------------------------------------------
initial_fuel_temperature = 600. # (K)
initial_salt_temperature = 595.  # (K)
initial_cr_fraction = 0.0
# Power ------------------------------------------------------------------------
tpow = 300e6 #(300 MW)

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  is_meter = true
  grid_names = 'tfuel tcool cr'
  grid_variables = 'tfuel tcool cr'
  library_file = 'xs/vtr_xs_verification.xml'
  library_name = 'vtr_xs'
  isotopes = 'pseudo'
  densities = '1.0'
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = mesh/vtr_core.e
    exodus_extra_element_integers = 'equivalence_id material_id'
  []
  [eqvid]
    type = ExtraElementIDCopyGenerator
    input = fmg
    source_extra_element_id = equivalence_id
    target_extra_element_ids = 'equivalence_id'
  []
[]

[Equivalence]
  type = SPH
  transport_system = CFEM-Diffusion
  equivalence_library = 'sph/vtr_sph_verification.xml'
  library_name = 'vtr_xs'
  compute_factors = false
  equivalence_grid_names  = 'tfuel tcool cr'
  equivalence_grid_variables = 'tfuel tcool cr'
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
  [tfuel]
    initial_condition = ${initial_fuel_temperature}
  []
  [tcool]
    initial_condition = ${initial_salt_temperature}
  []
  [cr]
   family = MONOMIAL
   order = CONSTANT
   initial_condition = ${initial_cr_fraction}
  []
[]

[AuxKernels]
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
  [cr_withdrawal]
    type  = ConstantFunction
    value = 1.92 # 1.92 = fully out, 0.88 = fully in
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 1
    plus = 1
  []
  [refl_shield_sr] # reflector, shield, SR assemblies
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 2
    plus = 0
  []
  [control_rods] # control rods modeled via RoddedNeutronicsMaterial
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = 3
    segment_material_ids = '115 116 115' # 115 = non-abs, 116=abs
    rod_segment_length = 1.0424
    front_position_function = cr_withdrawal
    rod_withdrawn_direction = y # Y-axis is the one vertical
    isotopes = 'pseudo; pseudo; pseudo'
    densities='1.0 1.0 1.0'
    plus = 0
  []
[]

[PowerDensity]
  power = ${tpow}
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
# EXECUTION PARAMETERS
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  VacuumBoundary = '1 2 3'
  [CFEM-Diffusion]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    family = LAGRANGE
    order = FIRST
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]

[Executioner]
  type = Eigenvalue
  solve_type = 'PJFNKMO'
  constant_matrices = true
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 100'

  [Quadrature]
    order = FOURTH
  []
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
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Debug]
[]

[Outputs]
  file_base = out_griffin_only
  exodus = true
  csv = true
  perf_graph = true
  [console]
    type = Console
  []
[]
