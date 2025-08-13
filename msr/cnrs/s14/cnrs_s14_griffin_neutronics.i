# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 1.4: Full coupling
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
    external_dnp_variable = 'dnp'
    fission_source_aux = true
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
  [tfuel_avg]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900
  []
  [densityf]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.0
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 8
  []
  [dnp0]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp1]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp2]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp3]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp4]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp5]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp6]
    order = CONSTANT
    family = MONOMIAL
  []
  [dnp7]
    order = CONSTANT
    family = MONOMIAL
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
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'dnp0 dnp1 dnp2 dnp3 dnp4 dnp5 dnp6 dnp7'
    execute_on = 'initial timestep_begin final'
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
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  free_power_iterations = 2
  line_search = none #l2
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 200
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-6
  fixed_point_min_its = 3
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-5
  fixed_point_abs_tol = 1e-6
[]

[MultiApps]
  [ns_flow]
    type = FullSolveMultiApp
    input_files = cnrs_s14_ns_flow.i
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  # Send to flow simulation to generate heat and precursors
  [power_dens]
    type = MultiAppProjectionTransfer
    to_multi_app = ns_flow
    source_variable = 'power_density'
    variable = 'power_density'
    execute_on = 'timestep_end'
  []
  [fission_source]
    type = MultiAppProjectionTransfer
    to_multi_app = ns_flow
    source_variable = fission_source
    variable = fission_source
    execute_on = 'timestep_end'
  []

  # Retrieve temperature and precursors distribution
  [fuel_temp]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'T_fluid'
    variable = 'tfuel'
    execute_on = 'timestep_end'
  []
  [Tfuel_avg]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    from_multi_app = ns_flow
    postprocessor = Tfuel_avg
    source_variable = 'tfuel_avg'
    execute_on = 'timestep_end'
  []
  [c1]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp0'
    variable = 'dnp0'
    execute_on = 'timestep_end'
  []
  [c2]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp1'
    variable = 'dnp1'
    execute_on = 'timestep_end'
  []
  [c3]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp2'
    variable = 'dnp2'
    execute_on = 'timestep_end'
  []
  [c4]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp3'
    variable = 'dnp3'
    execute_on = 'timestep_end'
  []
  [c5]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp4'
    variable = 'dnp4'
    execute_on = 'timestep_end'
  []
  [c6]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp5'
    variable = 'dnp5'
    execute_on = 'timestep_end'
  []
  [c7]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp6'
    variable = 'dnp6'
    execute_on = 'timestep_end'
  []
  [c8]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'dnp7'
    variable = 'dnp7'
    execute_on = 'timestep_end'
  []
[]

[AuxKernels]
  [dnp0_scale]
    type = ScaleAux
    variable = dnp0
    source_variable = dnp0
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp1_scale]
    type = ScaleAux
    variable = dnp1
    source_variable = dnp1
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp2_scale]
    type = ScaleAux
    variable = dnp2
    source_variable = dnp2
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp3_scale]
    type = ScaleAux
    variable = dnp3
    source_variable = dnp3
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp4_scale]
    type = ScaleAux
    variable = dnp4
    source_variable = dnp4
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp5_scale]
    type = ScaleAux
    variable = dnp5
    source_variable = dnp5
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp6_scale]
    type = ScaleAux
    variable = dnp6
    source_variable = dnp6
    multiplying_pp = Normalization
    execute_on = 'final'
  []
  [dnp7_scale]
    type = ScaleAux
    variable = dnp7
    source_variable = dnp7
    multiplying_pp = Normalization
    execute_on = 'final'
  []
[]

[Postprocessors]
  [Tfuel_avg2]
    type = ElementAverageValue
    variable = tfuel
    execute_on = 'timestep_end'
  []
[]

[Outputs]
  csv = true
  [exodus]
    type = Exodus
    additional_execute_on = 'final'
  []
[]

# For step 21 restart from steady state
[UserObjects]
  [transport_solution]
    type = TransportSolutionVectorFile
    transport_system = diff
    writing = true
    execute_on = 'FINAL'
  []
  [TH_solution]
    type = SolutionVectorFile
    var = 'tfuel densityf dnp0 dnp1 dnp2 dnp3 dnp4 dnp5 dnp6 dnp7'
    writing = true
    execute_on = 'FINAL'
  []
[]
