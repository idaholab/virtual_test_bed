################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application base input file                                   ##
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
    # file = '../steady/restart_multisys/multiphysics_out.e'
    file = '../steady/run_neutronics_restart.e'
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

[Problem]
  allow_initial_conditions_with_restart = true
[]

[PowerDensity]
  power = 3e9
  power_density_variable = power_density
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[AuxVariables]
  [power_density]
    order = CONSTANT
    family = MONOMIAL
    # no need to initialize, initialized by auxkernels
    # initial_from_file_var = 'power_density'
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
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
                         -pc_gamg_sym_graph -pc_gamg_use_parallel_coarse_grid_solver
                         -mg_levels_1_pc_type -mg_coarse_pc_type
                         -mg_coarse_sub_pc_factor_levels -mg_coarse_sub_pc_factor_mat_ordering_type'
  petsc_options_value = ' 100   gamg  false
                          true  1
                          asm   asm
                          1     rcm'

  line_search = 'none'
  nl_abs_tol = 1e-7
  nl_forced_its = 1
  l_abs_tol = 1e-7
  l_max_its = 200

  # Fixed point iteration parameters
  # fixed_point_max_its = 3
  # accept_on_max_fixed_point_iteration = true
  # fixed_point_abs_tol = 1e-50
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
  hide = 'dnp power_scaling'
[]
