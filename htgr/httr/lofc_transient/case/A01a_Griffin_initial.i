# We need to define a dummy mesh
# to allow for Depletion (# Not real burnup, just Xe135/I135 dynamics)
[Mesh]
  [gmg]
    type = GeneratedIDMeshGenerator
    dim = 1
    depletion_ids = 0
    material_ids = 1
  []
[]

[Functions]
  # For the initialization run we set reactivity to 0.0
  [reactivity_total]
    type = ParsedFunction
    expression = 'rho0'
    symbol_names =  'rho0'
    symbol_values = '0.0'
  []
  [set_flux]
    type = ParsedFunction
    symbol_names =  'n'
    symbol_values = 'n'
    # The flux value below was determined manually to
    # result in the i_135_2_xe_135_ratio pp to be about 2.0
    # matching Serpent
    expression = 'n * 3.76666e5'
  []
  [timestep]
     type = PiecewiseConstant
     x = '100 1000 10000 30000 1e7'
     y = '1   50   250    1000 10000'
     direction = right
  []
[]

[AuxVariables]
  [flux_g0]
  []

  [Burnup] # Not real burnup, just Xe135/I135 dynamics
  []
[]

[AuxKernels]
  # this auxkernel sets flux_g0 everywhere in the domain
  # to be equal to 1e8 * n, flux_g0 is in units of neutrons / s / cm^2
  [flux_g0]
    type = FunctionAux
    variable = flux_g0
    function = set_flux
    execute_on = 'linear timestep_end initial'
  []
[]

[ICs]
  # initial flux is zero: startup
  [ic_n]
    type = ScalarComponentIC
    variable = n
    values = 30.0e6
  []
  [ic_beta]
    type = ScalarComponentIC
    variable = beta
    values = '1.80965e-04 1.25003e-03 1.08868e-03 2.15254e-03 6.48521e-04 2.41736e-04'
  []
  [ic_lambda]
    type = ScalarComponentIC
    variable = lambda
    values = '0.0124830 0.0304912 0.1130980 0.3050370 1.1581700 3.0210500'
  []
  [ic_Lambda]
    type = ScalarComponentIC
    variable = Lambda
    values = 1.02731e-3
  []
[]

[PKE]
  n_delayed_groups = 6
  amplitude_variable = n
  DNP_variable = precursor
  DN_fraction_aux = beta
  DNP_decay_constant_aux = lambda
  mean_generation_time_aux = Lambda
  reactivity_aux = rho
[]

[AuxScalarKernels]
  [rho]
    type = FunctionScalarAux
    variable = rho
    function = reactivity_total
    execute_on = 'initial linear'
  []
[]

[Compositions]
  [fuel]
    type = IsotopeComposition
    # This is not a physical value but it ensures that the concentration
    # of U235 is virtually constant during the transient
    isotope_densities = 'U235 1e8'
    density_type = atomic
    skip_density_check = true
    composition_ids = 1
  []
[]

[Materials]
  [Mat_1]
    type = DepletionNeutronicsMaterial
    block = 0

    # multigroup cross section
    library_file = '../supporting_files/XE135_Benchmark_XS.xml'
    library_name = 'XE135-BENCHMARK'

    #multiphysics variables
    grid_names = 'Burnup'
    grid_variables = 'Burnup'

    # transport system flux
    scalar_fluxes = 'flux_g0'

    # decay & transmutation data
    dataset = 'ISOXML'
    isoxml_data_file = '../supporting_files/XE135_Benchmark_DT.xml'
    isoxml_lib_name = 'XE135_Bench_DT'

    # bateman solver
    bateman_solver = 'CRAMPFD'
    cram_pfd_order = 16
    cram_matrix_inversion_scheme = direct

    dbgmat = false
    print_number_densities = 'ALL'
  []
[]

[Postprocessors]
  # Output value to A01b
  [pp_xe_135]
    type = DepletionAtomicDensityPP
    depletion_material = Mat_1
    depletion_id = 0
    isotope = XE135
    execute_on = 'initial timestep_end'
  []
  # Output value to A01b
  [pp_i_135]
    type = DepletionAtomicDensityPP
    depletion_material = Mat_1
    depletion_id = 0
    isotope = I135
    execute_on = 'initial timestep_end'
  []

  [pp_u_235]
    type = DepletionAtomicDensityPP
    depletion_material = Mat_1
    depletion_id = 0
    isotope = U235
    execute_on = 'initial timestep_end'
  []

  [pp_flux_average]
    type = ElementAverageValue
    variable = flux_g0
  []

  [pp_i_135_2_xe_135_ratio]
    type = ParsedPostprocessor
    expression = 'pp_i_135/pp_xe_135'
    pp_names = 'pp_i_135 pp_xe_135'
  []

  [pp_n]
    type = ScalarVariable
    variable = n
  []

  [pp_rho]
    type = ScalarVariable
    variable = rho
  []
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-5
  nl_max_its = 50

  automatic_scaling = true

  start_time = 0
  end_time = 1.0e7


  [TimeSteppers]
    [ts1]
      type = FunctionDT
      function = timestep
    []
  []
[]

[Outputs]
  [console]
    type = Console
    # These changes are important, the code slows down a lot if we don't
    # turn these off
    execute_scalars_on = 'NONE'
    execute_postprocessors_on = 'FINAL'
  []
  [csv]
    type = CSV
    file_base = 'results/A01a'
  []
[]

[Postprocessors]
  [power_n]
    type = ScalarVariable
    variable = n
  []
  [power]
    type = ParsedPostprocessor
    expression = '28.1e6 * power_n / 5.0e8'
    pp_names = 'power_n'
  []
[]
