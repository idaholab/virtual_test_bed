# ==============================================================================
# Model description:
# This input takes the results from running stm_lhs_sampling.i and performs
# global sensitivity analysis using polynomial chaos methodology. The result is
# a JSON file containing the mean and standard deviation of the quantities of
# interest, as well as first, total, and second order Sobol indices w.r.t. every
# sampled parameter.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, June 9, 2025
# Author(s)(name alph): Dr. Zachary Prince
# ==============================================================================

# Kernel radius (m) ------------------------------------------------------------
kernel_radius_min = 1.5e-4
kernel_radius_max = 3.0e-4

# Filling factor ---------------------------------------------------------------
filling_factor_min = 0.05
filling_factor_max = 0.15

# Enrichment -------------------------------------------------------------------
enrichment_min = 0.05
enrichment_max = 0.2

# Pebble unloading rate (pebbles per second) -----------------------------------
pebble_unloading_rate_min = '${fparse 1.0/60}'
pebble_unloading_rate_max = '${fparse 3.0/60}'

# Burnup limit (MWD/kg) --------------------------------------------------------
burnup_limit_weight_min = 131.2 # MWd / kg
burnup_limit_weight_max = 164 # MWd / kg

# Total power (W) --------------------------------------------------------------
total_power_min = 180e6
total_power_max = 220e6

[StochasticTools]
[]

[Distributions]
  [kr]
    type = Uniform
    lower_bound = ${kernel_radius_min}
    upper_bound = ${kernel_radius_max}
  []
  [ff]
    type = Uniform
    lower_bound = ${filling_factor_min}
    upper_bound = ${filling_factor_max}
  []
  [enrich]
    type = Uniform
    lower_bound = ${enrichment_min}
    upper_bound = ${enrichment_max}
  []
  [pur]
    type = Uniform
    lower_bound = ${pebble_unloading_rate_min}
    upper_bound = ${pebble_unloading_rate_max}
  []
  [bul]
    type = Uniform
    lower_bound = ${burnup_limit_weight_min}
    upper_bound = ${burnup_limit_weight_max}
  []
  [power]
    type = Uniform
    lower_bound = ${total_power_min}
    upper_bound = ${total_power_max}
  []
[]

[Samplers]
  [params]
    type = CSVSampler
    samples_file = stm_lhs_sampling_processed.csv
    column_names = 'kernel_radius
                    filling_factor
                    enrichment
                    pebble_unloading_rate
                    burnup_limit_weight
                    total_power'
  []
[]

[VectorPostprocessors]
  [qois]
    type = CSVReaderVectorPostprocessor
    csv_file = stm_lhs_sampling_processed.csv
  []
[]

[GlobalParams]
  sampler = params
  distributions = 'kr ff enrich pur bul power'
  order = 4
  regression_type = ols
[]

[Trainers]
  [train_eigenvalue]
    type = PolynomialChaosTrainer
    response = 'qois/data:eigenvalue:value'
    execute_on = timestep_begin
  []
  [train_pebble_power_max]
    type = PolynomialChaosTrainer
    response = 'qois/data:pebble_power_max:value'
    execute_on = timestep_begin
  []
  [train_peaking_factor]
    type = PolynomialChaosTrainer
    response = 'qois/data:peaking_factor:value'
    execute_on = timestep_begin
  []
  [train_Tfuel_max]
    type = PolynomialChaosTrainer
    response = 'qois/data:Tfuel_max:value'
    execute_on = timestep_begin
  []
  [train_Trpv_max]
    type = PolynomialChaosTrainer
    response = 'qois/data:Trpv_max:value'
    execute_on = timestep_begin
  []
[]

[Surrogates]
  [model_eigenvalue]
    type = PolynomialChaos
    trainer = train_eigenvalue
  []
  [model_pebble_power_max]
    type = PolynomialChaos
    trainer = train_pebble_power_max
  []
  [model_peaking_factor]
    type = PolynomialChaos
    trainer = train_peaking_factor
  []
  [model_Tfuel_max]
    type = PolynomialChaos
    trainer = train_Tfuel_max
  []
  [model_Trpv_max]
    type = PolynomialChaos
    trainer = train_Trpv_max
  []
[]

[Reporters]
  [stats]
    type = PolynomialChaosReporter
    pc_name = 'model_eigenvalue
               model_pebble_power_max
               model_peaking_factor
               model_Tfuel_max
               model_Trpv_max'
    statistics = 'mean stddev'
    include_sobol = true
  []
[]

[Outputs]
  json = true
  execute_on = timestep_end
[]
