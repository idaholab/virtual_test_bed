initial_iodine = 1.13269367601798e-08    # From A01a
initial_xenon = 5.80898692527134e-09  # From A01a
xenon_worth = 4.0                      # From Serpent
big_lambda = 1.02731e-3                # Generation time
source = 5.0                        #Fixed source strength divided by n_0
beta_eff = 0.00556247                  # Regular Beta_eff
nomPow = 30.0e6                     #Nominal total thermal power (fission + decay)
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

 [Problem]
  restart_file_base = './A01b_Griffin_restarts_cp/LATEST'
  force_restart = true
  allow_initial_conditions_with_restart = false
 []

[Functions]
  # Beta = 0.00556247, from 1-2. HTTR Data for Loss-of-Forced Cooling Analyses
  [xenon_reactivity]
    type = ParsedFunction
    expression = '-xe_worth * pp_xe_135 / ${initial_xenon}'
    symbol_names =  'xe_worth pp_xe_135'
    symbol_values = '${xenon_worth} pp_xe_135'
  []
  [Tfuel]
    type = PiecewiseLinear
    xy_data = '0.0 1000.0'
  []
  [Tmodr]
    type = PiecewiseLinear
    xy_data = '0.0 900.0'
  []
  [fuel_feedback]
    type = ParsedFunction
    expression = '(T - Tref)*rho_coeff'
    symbol_names = 'T Tref rho_coeff'
    symbol_values = 'T_fuelCompact_avg 1.181049e+03 -4.25e-5'
  []
  [modr_feedback]
    type = ParsedFunction
    expression = '(T - Tref)*rho_coeff'
    symbol_names = 'T Tref rho_coeff'
    symbol_values = 'T_mod_avg 9.973594e+02 -2.36e-5'
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
  [timestep]
     type = PiecewiseConstant
     x = ' -100 0.0  1000 10000 32400 39600'
     y = '5.0   5.0   10.0   50.0   50.   10.0'
     direction = left
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
  [flux_g0]
    type = FunctionAux
    variable = flux_g0
    function = set_flux
    execute_on = 'linear timestep_end initial'
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
  has_initial_equilibrium = false
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
    # execute_on = 'initial timestep_begin'
  []
[]

[Functions]
  [set_flux]
    type = ParsedFunction
    symbol_names =  'n'
    symbol_values = 'n'
    expression = 'n * 3.76666e5'
  []
  [decay_heat_fn]
    type = PiecewiseLinear
    x =  '-1000.0 0.0 0.1 108.64 186.4 359.2 532 904 1396 1828 2200 2692 3114 3566 4078 4520 8740 13060 17380 21700'
    y = '  0.0639  0.0639 0.0639 0.0472 0.0319 0.02547 0.0233 0.0200 0.0183 0.0166 0.0155 0.0147 0.0139 0.0133 0.0128 0.0124 0.0099 0.0087 0.0081 0.0076'
    #x = '-1000 100000000'
    #y = '  0.0639  0.0639'
    scale_factor = 30e6
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
    force_preaux = true
  []
  # Output value to A01b
  [pp_i_135]
    type = DepletionAtomicDensityPP
    depletion_material = Mat_1
    depletion_id = 0
    isotope = I135
    execute_on = 'initial timestep_end'
    force_preaux = true
  []

  [pp_u_235]
    type = DepletionAtomicDensityPP
    depletion_material = Mat_1
    depletion_id = 0
    isotope = U235
    execute_on = 'initial timestep_end'
    force_preaux = true
  []

  [pp_flux_average]
    type = ElementAverageValue
    variable = flux_g0
    force_preaux = true
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
    force_preaux = true
  []
  [pp_reactivity_fuel]
    type = FunctionValuePostprocessor
    function = fuel_feedback
    execute_on = 'initial timestep_end'
    force_preaux = true
  []
  [pp_reactivity_modr]
    type = FunctionValuePostprocessor
    function = modr_feedback
    execute_on = 'initial timestep_end'
    force_preaux = true
  []

  [pp_rho]
    type = ScalarVariable
    variable = rho
    force_preaux = true
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
    force_preaux = true
  []
  [Tmodr]
    type = ConstantPostprocessor
    value = 900.0
    execute_on = 'initial timestep_end'
    force_preaux = true
  []
  [T_mod_avg]
    type = Receiver
    force_preaux = true
  []
  [T_fuelCompact_avg]
    type = Receiver
    force_preaux = true

  []
  [T_fuelBlock_avg]
    type = Receiver
    force_preaux = true
  []
[]

[Executioner]
  type = Transient
  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-8
  nl_max_its = 50
  # fixed_point_max_its = 3
  # fixed_point_min_its = 1
  # accept_on_max_fixed_point_iteration = true
  # scheme = Crank-Nicolson

  start_time = -100.0
  # end_time = 172800
  end_time = 64800
  # end_time = 604800

  automatic_scaling = true
  abort_on_solve_fail = true


  [TimeSteppers]
    [ts1]
      type = FunctionDT
      function = timestep
    []
[]

[Outputs]
  [console]
    type = Console
    # These changes are important, the code slows down a lot if we don't
    # turn these off
    # execute_scalars_on = 'FINAL'
    # execute_postprocessors_on = 'FINAL'
  []
  [csv]
    type = CSV
    file_base = 'results/A02b'
    time_step_interval = 5
  []
    [exodus]
    type = Exodus
    time_step_interval = 100
  []
[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    input_files = 'B02_Proxy.i'
    catch_up = true
    max_catch_up_steps = 4
  []
[]
[Postprocessors]
  [power_n]
    type = ScalarVariable
    variable = n
    force_preaux = true
  []
  [fission_power]
    type = ParsedPostprocessor
    expression = '28.083e6 * power_n / 30.0e6'
    pp_names = 'power_n'
    execute_on = 'INITIAL TIMESTEP_END'
    force_preaux = true
  []
  [decay_power]
    type = FunctionValuePostprocessor
    function = decay_heat_fn
    execute_on = 'INITIAL TIMESTEP_END'
    force_preaux = true
  []
  [power]
    type = ParsedPostprocessor
    expression = '28.083e6 * power_n / 30.0e6 + decay_power' #27.921
    pp_names = 'power_n decay_power'
    execute_on = 'INITIAL TIMESTEP_END'
    force_preaux = true
  []
  [power_step]
    type = ParsedPostprocessor
    expression = '${nomPow} / power * 1.0'
    pp_names = 'power'
  []
  [dt]
  type = TimestepSize
[]
[]
[Transfers]
  [pp_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = sub_app
    from_postprocessor = power
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
