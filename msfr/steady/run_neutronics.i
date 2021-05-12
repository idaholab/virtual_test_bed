[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/msfr_rz_mesh.e'
  []
[]

[Outputs]
  exodus = true
[]

[Problem]
  coord_type = 'RZ'
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
  []
[]

[PowerDensity]
  power = 3e9
  power_density_variable = power_density
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 700 # in degree C
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'timestep_begin'
  []
[]

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
    grid_variables = 'tfuel'
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
    grid_variables = 'tfuel'
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 1
    block = 'reflector'
  []
[]

[Executioner]
  type = Eigenvalue
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -c_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  free_power_iterations = 4
  nl_abs_tol = 1e-9
  picard_max_its = 100
[]

[VectorPostprocessors]
  [eigenvalues]
    type = Eigenvalues
    inverse_eigenvalue = true
  []
[]

[Postprocessors]
  [eigenvalue_out]
    type = VectorPostprocessorComponent
    vectorpostprocessor = eigenvalues
    vector_name = eigen_values_real
    index = 0
  []
[]

[MultiApps]
  [ns]
    type = FullSolveMultiApp
    input_files = 'run_ns.i'
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  [power_density]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = power_density
    variable = power_density
  []
  [fission_source]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = fission_source
    variable = fission_source
  []
  [c1]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c6'
    variable = 'c6'
  []
  [T]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'T'
    variable = 'tfuel'
  []
[]
