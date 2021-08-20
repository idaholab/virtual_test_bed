[Mesh]
  uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    file = 'msfr_rz_mesh.e'
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
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
  [v_x]
    order = CONSTANT
    family = MONOMIAL
  []
  [v_y]
    order = CONSTANT
    family = MONOMIAL
  []
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 873.15 # in degree K
  []
  [mixing_len]
    order = CONSTANT
    family = MONOMIAL
  []
  [pressure]
    order = CONSTANT
    family = MONOMIAL
  []
  [lambda]
    family = SCALAR
    order = FIRST
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
    library_file = 'msfr_xs.xml'
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
    library_file = 'msfr_xs.xml'
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
    library_file = 'msfr_xs.xml'
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

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 50'
  l_max_its = 50

  free_power_iterations = 4  # important to obtain fundamental mode eigenvalue

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
    input_files = 'msfr_ns.i'
    execute_on = 'timestep_end'
    no_backup_and_restore = true
  []
  #[TH_initialization]
  #  type = FullSolveMultiApp
  #  input_files = 'msfr_ns_2_initial.i'
  #  execute_on = 'INITIAL'
  #[]
[]

[Transfers]

  #Initialization Transfers
  #[v_x_initial]
  #  type = MultiAppProjectionTransfer
  #  multi_app = TH_initialization
  #  direction = from_multiapp
  #  source_variable = v_x
  #  variable = v_x
  #[]
  #[v_y_initial]
  #  type = MultiAppProjectionTransfer
  #  multi_app = TH_initialization
  #  direction = from_multiapp
  #  source_variable = v_y
  #  variable = v_y
  #[]
  #[pressure_initial]
  #  type = MultiAppProjectionTransfer
  #  multi_app = TH_initialization
  #  direction = from_multiapp
  #  source_variable = pressure
  #  variable = pressure
  #[]
  #[T_initial]
  #  type = MultiAppProjectionTransfer
  #  multi_app = TH_initialization
  #  direction = from_multiapp
  #  source_variable = T
  #  variable = tfuel
  #[]

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
  [fuel_temperature]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = tfuel
    variable = T
  []
  #[v_x_to]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = to_multiapp
  #  source_variable = v_x
  #  variable = v_x
  #[]
  #[v_y_to]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = to_multiapp
  #  source_variable = v_y
  #  variable = v_y
  #[]
  #[pressure_to]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = to_multiapp
  #  source_variable = pressure
  #  variable = pressure
  #[]
  [c1_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6_to]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = to_multiapp
    source_variable = 'c6'
    variable = 'c6'
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
  #[v_x_from]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = from_multiapp
  #  source_variable = v_x
  #  variable = v_x
  #[]
  #[v_y_from]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = from_multiapp
  #  source_variable = v_y
  #  variable = v_y
  #[]
  #[pressure_from]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = from_multiapp
  #  source_variable = pressure
  #  variable = pressure
  #[]
  #[lambda_from]
  #  type = MultiAppProjectionTransfer
  #  multi_app = ns
  #  direction = from_multiapp
  #  source_variable = lambda
  #  variable = lambda
  #[]


[]
