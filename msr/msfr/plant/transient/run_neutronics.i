################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application input file                                        ##
## Transient neutronics model                                                 ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    # when changing restart file, adapt power_scaling postprocessor
    # if not exactly 3e9 -> initial was not completely converged
    file = '../steady/restart/run_neutronics_restart.e'
    use_for_exodus_restart = true
  []
[]

################################################################################
# EQUATION SYSTEM SETUP
################################################################################

[TransportSystems]
  particle = neutron
  equation_type = transient
  restart_transport_system = true

  G = 6

  VacuumBoundary = 'outer'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
    fission_source_aux = true
  []
[]

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 600
    initial_from_file_var = tfuel
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
    initial_from_file_var = c1
    block = 'fuel pump hx'
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = c2
    block = 'fuel pump hx'
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = c3
    block = 'fuel pump hx'
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = c4
    block = 'fuel pump hx'
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = c5
    block = 'fuel pump hx'
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    initial_from_file_var = c6
    block = 'fuel pump hx'
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
    # no need to initalize, initialized by auxkernels
    # initial_from_file_var = dnp
    block = 'fuel pump hx'
  []
  [power_density]
    order = CONSTANT
    family = MONOMIAL
    # no need to initalize, initialized by auxkernels
    # initial_from_file_var = 'power_density'
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'initial timestep_begin final'
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

################################################################################
# CROSS SECTIONS
################################################################################

[Materials]
  [fuel]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../../mgxs/msfr_xs_extended.xml'
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
    library_file = '../../mgxs/msfr_xs_extended.xml'
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
    library_file = '../../mgxs/msfr_xs_extended.xml'
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
  end_time = 200.0
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

  line_search = 'none'
  nl_abs_tol = 1e-7
  nl_forced_its = 1
  l_abs_tol = 1e-7
  l_max_its = 200

  # Fixed point iteration parameters
  fixed_point_max_its = 3
  accept_on_max_fixed_point_iteration = true
  fixed_point_abs_tol = 1e-50
[]

################################################################################
# SIMULATION OUTPUT
################################################################################

[Outputs]
  csv = true
  exodus = true
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
  hide = 'dnp'
[]

[Postprocessors]
  [power_scaling]
    type = Receiver
    outputs = none
    default = 4.1682608293957647e+18
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = 'initial timestep_begin timestep_end'
    outputs = all
    block = 'fuel pump hx'
  []
[]

################################################################################
# MULTIAPPS and TRANSFERS for flow simulation
################################################################################

[MultiApps]
  [ns]
    type = TransientMultiApp
    input_files = 'run_ns.i'
    execute_on = 'timestep_begin'
    catch_up = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppInterpolationTransfer
    to_multi_app = ns
    source_variable = power_density
    variable = power_density
  []
  [fission_source]
    type = MultiAppShapeEvaluationTransfer
    to_multi_app = ns
    source_variable = fission_source
    variable = fission_source
  []
  [c1]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'c6'
    variable = 'c6'
  []
  [T]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = ns
    source_variable = 'T_fluid'
    variable = 'tfuel'
  []
[]
