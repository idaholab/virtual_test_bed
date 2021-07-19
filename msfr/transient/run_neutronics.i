################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application input file                                        ##
## Transient neutronics model                                                 ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../steady/sample_output/run_neutronics_out.e'
  []
[]

[Outputs]
  csv = true
  exodus = true
[]

[Problem]
  coord_type = 'RZ'
[]

[TransportSystems]
  particle = neutron
  equation_type = transient

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

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
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
  [power_density]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'initial nonlinear'
  []
  [power_density]
    type = VectorReactionRate
    variable = power_density
    cross_section = kappa_sigma_fission
    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
    scale_factor = power_scaling
    execute_on = 'initial timestep_begin'
    block = 'fuel pump hx'
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

[Functions]
  [timestep]
    type = PiecewiseConstant
    x = '0.5  10   20    25   1e6'
    y = '0.2  0.1  0.25  0.5  1.0'
    direction = right
  []
[]

[Executioner]
  type = Transient
  scheme = implicit-euler
  start_time = 0.0
  end_time = 10.0
  dt = 0.25
  solve_type = PJFNK
  petsc_options_iname = '-ksp_gmres_restart -pc_type  -pc_use_amat
                         -pc_gamg_sym_graph -pc_mg_levels  -pc_gamg_use_parallel_coarse_grid_solver
                         -mg_levels_1_pc_type -mg_coarse_pc_type
                         -mg_coarse_sub_pc_factor_levels -mg_coarse_sub_pc_factor_mat_ordering_type'
  petsc_options_value = ' 100   gamg  false
                          true   2      1
                          asm   asm
                          1     rcm'
  nl_abs_tol = 1e-8
  nl_forced_its = 1
  l_abs_tol = 1e-8
  l_max_its = 200
  fixed_point_max_its = 3
  accept_on_max_fixed_point_iteration = true
  fixed_point_abs_tol = 1e-50
  line_search = 'none'
[]

[MultiApps]
  [init]
    type = FullSolveMultiApp
    input_files = '../steady/run_neutronics.i'
    execute_on = 'initial'
  []
  [ns]
    type = TransientMultiApp
    input_files = 'run_ns.i'
    execute_on = 'timestep_begin'
  []
[]

[Postprocessors]
  [power_scaling]
    type = Receiver
    outputs = none
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = 'initial linear'
    outputs = all
  []
[]

[Transfers]
  [init_solution]
    type = TransportSystemVariableTransfer
    multi_app = init
    direction = from_multiapp
    from_transport_system = diff
    to_transport_system = diff
  []
  [init_power_scaling]
    type = MultiAppPostprocessorTransfer
    multi_app = init
    direction = from_multiapp
    reduction_type = minimum
    from_postprocessor = power_scaling
    to_postprocessor = power_scaling
  []
  [init_tfuel]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = tfuel
    variable = tfuel
  []
  [init_c1]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c1
    variable = c1
  []
  [init_c2]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c2
    variable = c2
  []
  [init_c3]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c3
    variable = c3
  []
  [init_c4]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c4
    variable = c4
  []
  [init_c5]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c5
    variable = c5
  []
  [init_c6]
    type = MultiAppCopyTransfer
    multi_app = init
    direction = from_multiapp
    source_variable = c6
    variable = c6
  []
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
  [power]
    type = MultiAppPostprocessorTransfer
    multi_app = ns
    direction = to_multiapp
    reduction_type = minimum
    from_postprocessor = power
    to_postprocessor = power
  []
  [c1]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c1'
    variable = 'c1'
    execute_on = 'initial timestep_end'
  []
  [c2]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c2'
    variable = 'c2'
    execute_on = 'initial timestep_end'
  []
  [c3]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c3'
    variable = 'c3'
    execute_on = 'initial timestep_end'
  []
  [c4]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c4'
    variable = 'c4'
    execute_on = 'initial timestep_end'
  []
  [c5]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c5'
    variable = 'c5'
    execute_on = 'initial timestep_end'
  []
  [c6]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'c6'
    variable = 'c6'
    execute_on = 'initial timestep_end'
  []
  [T]
    type = MultiAppProjectionTransfer
    multi_app = ns
    direction = from_multiapp
    source_variable = 'T'
    variable = 'tfuel'
  []
[]
