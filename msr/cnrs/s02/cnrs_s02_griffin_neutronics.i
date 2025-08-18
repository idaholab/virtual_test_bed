# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 0.2: Neutronics
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428.
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

[GlobalParams]
  isotopes = 'pseudo'
  densities = 'densityf'
  library_file = '../xs/msr_cavity_xslib.xml'
  library_name = 'CNRS-Benchmark'
  grid_names = 'Tfuel'
  grid_variables = 'tfuel'
  is_meter = true
  plus = 1
[]

[Mesh]
  type = MeshGeneratorMesh
  block_id = '1'
  block_name = 'cavity'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '1.0 1.0'
    ix = '100 100'
    dy = '1.0 1.0'
    iy = '100 100'
    subdomain_id = ' 1 1
                     1 1'
  []
  [assign_material_id]
    type = SubdomainExtraElementIDGenerator
    input = cartesian_mesh
    extra_element_id_names = 'material_id'
    subdomains = '1'
    extra_element_ids = '1'
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  VacuumBoundary = 'left bottom right top'
  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 8
    family = LAGRANGE
    order = FIRST
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]

[PowerDensity]
  power = 1.0e9
  power_density_variable = power_density
  integrated_power_postprocessor = total_power
  power_scaling_postprocessor = Normalization
  family = LAGRANGE
  order = FIRST
[]

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900
  []
  [densityf]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0
  []
  [FRD]
    order  = FIRST
    family = L2_LAGRANGE
  []
[]

[AuxKernels]
  [density_fuel]
    type = ParsedAux
    block = 'cavity'
    variable = densityf
    coupled_variables = 'tfuel'
    expression = '(1.0-0.0002*(tfuel-900.0))'
    execute_on = 'INITIAL timestep_end'
  []
  [fission_rate_density]
    type = VectorReactionRate
    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
    cross_section = sigma_fission
    variable = FRD
    scale_factor = Normalization
    block = 'cavity'
  []
[]

[Materials]
  [fuel_salt]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 'cavity'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  free_power_iterations = 2
  line_search = none #l2
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 200
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
[]

[VectorPostprocessors]
  [AA_line_values_left]
    type = LineValueSampler
    start_point = '0 0.995 0'
    end_point = '2 0.995 0'
    variable = 'FRD'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [AA_line_values_right]
    type = LineValueSampler
    start_point = '0 1.005 0'
    end_point = '2 1.005 0'
    variable = 'FRD'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = x
  []
  [BB_line_values_left]
    type = LineValueSampler
    start_point = '0.995 0 0'
    end_point = '0.995 2 0'
    variable = 'FRD'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
  [BB_line_values_right]
    type = LineValueSampler
    start_point = '1.005 0 0'
    end_point = '1.005 2 0'
    variable = 'FRD'
    num_points = 201
    execute_on = 'FINAL'
    sort_by = y
  []
[]

[Outputs]
  exodus = true
  [csv]
    type = CSV
    execute_on = 'FINAL'
  []
[]
