################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application input file                                        ##
## Steady state neutronics model                                              ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  uniform_refine = 1
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/msfr_rz_mesh.e'
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 6

  VacuumBoundary = 'outer'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
    fission_source_aux = true

    # For PJFNKMO
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]

[PowerDensity]
  power = 3e9
  power_density_variable = power_density
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[GlobalParams]
  # No displacement modeled
  # fixed_meshes = true
[]

################################################################################
# AUXILIARY SYSTEM
################################################################################

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 873.15 # in degree K
    block = 'fuel pump hx'
  []
  # TODO: remove once we have block restricted transfers
  [tfuel_constant]
    initial_condition = 873.15 # in degree K
    block = 'reflector shield'
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'timestep_begin final'
  []
[]

################################################################################
# CROSS SECTIONS
################################################################################

[Materials]
  [fuel]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 2
    block = 'fuel pump hx'
  []
  [shield]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel_constant'
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 5
    block = 'shield'
  []
  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel_constant'
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 1
    block = 'reflector'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 50'
  l_max_its = 50

  free_power_iterations = 4  # important to obtain fundamental mode eigenvalue

  nl_abs_tol = 1e-9
  fixed_point_abs_tol = 1e-9
  fixed_point_max_its = 20
[]

################################################################################
# MULTIAPPS and TRANSFERS for flow simulation
################################################################################

[MultiApps]
  [ns]
    type = FullSolveMultiApp
    input_files = 'run_ns.i'
    execute_on = 'timestep_end'
    no_backup_and_restore = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = ns
    source_variable = power_density
    variable = power_density
  []
  [fission_source]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = ns
    source_variable = fission_source
    variable = fission_source
  []

  [c1]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c6'
    variable = 'c6'
  []
  [T]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'T_fluid'
    variable = 'tfuel'
  []
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  checkpoint = true
  [restart]
    type = Exodus
    execute_on = 'final'
    file_base = 'run_neutronics_restart'
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
