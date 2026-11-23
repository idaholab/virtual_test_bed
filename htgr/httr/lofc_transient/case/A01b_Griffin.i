initial_flux = 1.129998e+13            # From A01a
initial_iodine = 1.13269367601798e-08    # From A01a
initial_xenon = 5.80898692527134e-09  # From A01a
xenon_worth = 4.0                      # From Serpent
big_lambda = 1.02731e-3                # Generation time
source = 5.0
beta_eff = 0.00556247                  # Regular Beta_eff

# Source compensation
disturbance = -0.0   # [$] for testing
# rho_star is used to offset the source
rho_star = ${fparse -source * big_lambda / 30.0e6 / beta_eff + disturbance}

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
  # Beta = 0.00556247, from 1-2. HTTR Data for Loss-of-Forced Cooling Analyses
  [xenon_reactivity]
    type = ParsedFunction
    expression = '-xe_worth * pp_xe_135 / ${initial_xenon}'
    symbol_names =  'xe_worth pp_xe_135'
    symbol_values = '${xenon_worth} pp_xe_135'
  []
  [fuel_feedback]
    type = ParsedFunction
    expression = '(T - Tref)*rho_coeff'
    symbol_names = 'T Tref rho_coeff'
    symbol_values = 'Tfuel 1000.0 -4.49e-5'
  []
  [modr_feedback]
    type = ParsedFunction
    expression = '(T - Tref)*rho_coeff'
    symbol_names = 'T Tref rho_coeff'
    symbol_values = 'Tmodr 900.0 -2.42e-5'
  []

  [reactivity_total]
    type = ParsedFunction


    expression = '(rho0 + xenon_reactivity) * beta +
                  fuel_feedback + modr_feedback'
    symbol_names =  'beta
                     rho0
                     xenon_reactivity
                     fuel_feedback
                     modr_feedback'
    symbol_values = '0.00556247
                     ${fparse xenon_worth + rho_star}
                     xenon_reactivity
                     fuel_feedback
                     modr_feedback'
  []
  [set_flux]
    type = ParsedFunction
    symbol_names =  'n'
    symbol_values = 'n'
    # Same as A01a
    # The flux value below was determined manually to
    # result in the i_135_2_xe_135_ratio pp to be about 2.0
    # matching Serpent
    expression = 'n * 3.76666e5'
  []
  [timestep]
     type = PiecewiseConstant
     x = '0.0   0.2   0.6  1   100 1000 10000'
     y = '0.001 0.005 0.01 0.1 1.0 10.0 50.0'
     direction = left
  []
[]

[AuxVariables]
  [flux_g0]
    initial_condition = ${initial_flux}
  []

  [Burnup] # Not real burnup, just Xe135/I135 dynamics
  []
[]

[AuxKernels]
  # this auxkernel sets flux_g0 everywhere in the domain
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
    values = ${big_lambda}
  []
  [ic_precursor]
    type = ScalarComponentIC
    variable = precursor
    values = '7.055765e+09 1.995329e+10 4.685045e+09 3.434529e+09 2.725337e+08 3.894502e+07'
  []
[]

[PKE]
  n_delayed_groups = 6
  # n can be arbitrarily scaled, we select n = 1.0e-8 * flux
  # flux will be 1 neutron / s / cm^2 initially
  amplitude_variable = n
  DNP_variable = precursor
  DN_fraction_aux = beta
  DNP_decay_constant_aux = lambda
  mean_generation_time_aux = Lambda
  reactivity_aux = rho
[]

[ScalarKernels]
  [src]
    type = ParsedODEKernel
    variable = n
    expression = "${fparse -source}"
  []
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
    isotope_densities = 'U235 1e8
                         I135 ${initial_iodine}
                         XE135 ${initial_xenon}'
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
    force_preaux = true
    execute_on = 'initial timestep_end'
  []

  [pp_reactivity_total]
    type = FunctionValuePostprocessor
    function = reactivity_total
    execute_on = 'initial timestep_end'
  []
  [pp_reactivity_fuel]
    type = FunctionValuePostprocessor
    function = fuel_feedback
    execute_on = 'initial timestep_end'
  []
  [pp_reactivity_modr]
    type = FunctionValuePostprocessor
    function = modr_feedback
    execute_on = 'initial timestep_end'
  []

  [pp_rho]
    type = ScalarVariable
    variable = rho
  []

  [pp_xenon_reactivity]
    type = FunctionValuePostprocessor
    function = xenon_reactivity
    execute_on = 'initial timestep_end'
  []

  [Tfuel]
    type = ConstantPostprocessor
    value = 1000.0
    execute_on = 'initial timestep_end'
  []
  [Tmodr]
    type = ConstantPostprocessor
    value = 900.0
    execute_on = 'initial timestep_end'
  []
  [T_fuelCompact_avg]
    type = Receiver
  []
  [T_fuelBlock_avg]
    type = Receiver
  []
  [T_mod_avg]
    type = Receiver
  []
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-8
  nl_max_its = 50

  start_time = 0
  end_time = 10000.0
  error_on_dtmin = false
  dtmax = 100
  dtmin = 1e-6

  automatic_scaling = true
  abort_on_solve_fail = true

    [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1.0e-5
    cutback_factor     = 0.5
    growth_factor      = 2.00
    # iteration_window = 4
    optimal_iterations = 8
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
    file_base = 'results/A01b'
  []
    [exodus]
    type = Exodus
    execute_on = 'initial timestep_end'
  []
  [restarts]
    type = Checkpoint
    execute_on = 'FINAL'
  []
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    input_files = 'B01_Proxy.i'
    catch_up = true
    max_catch_up_steps = 4
  []
[]
[Postprocessors]
  [power_n]
    type = ScalarVariable
    variable = n
  []
  [power_total]
    type = ParsedPostprocessor
    expression = '30.0e6 * power_n / 30.0e6'
    pp_names = 'power_n'
  []
[]
[Transfers]
  [pp_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = sub_app
    from_postprocessor = power_total
    to_postprocessor = total_power
  []
  [T_fuelCompact_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sub_app
    from_postprocessor = T_fuelCompact_avg
    to_postprocessor = T_fuelCompact_avg
    reduction_type = average
  []
  [T_fuelBlock_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sub_app
    from_postprocessor = T_fuelBlock_avg
    to_postprocessor = T_fuelBlock_avg
    reduction_type = average
  []
  [T_mod_avg_pp_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sub_app
    from_postprocessor = T_mod_avg
    to_postprocessor = T_mod_avg
    reduction_type = average
  []
[]
