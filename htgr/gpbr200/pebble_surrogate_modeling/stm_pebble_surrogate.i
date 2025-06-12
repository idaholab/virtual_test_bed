[StochasticTools]
[]

[Samplers]
  [csv]
    type = CSVSampler
    samples_file = stm_pebble_sampling_csv_study_results_0001.csv
    column_names = 'kernel_radius filling_factor pebble_surface_temp porous_media_power_density'
  []
[]

[VectorPostprocessors]
  [data]
    type = CSVReaderVectorPostprocessor
    csv_file = stm_pebble_sampling_csv_study_results_0001.csv
    outputs = none
  []
[]

[GlobalParams]
  sampler = csv
  cv_type = k_fold
  regression_type = ols
[]

[Trainers]
  [pr1_Tfuel_train]
    type = PolynomialRegressionTrainer
    max_degree = 1
    response = data/fuel_average_temp:value
    cv_surrogate = pr1_Tfuel
    execute_on = TIMESTEP_BEGIN
  []
  [pr1_Tmod_train]
    type = PolynomialRegressionTrainer
    max_degree = 1
    response = data/moderator_average_temp:value
    cv_surrogate = pr1_Tmod
    execute_on = TIMESTEP_BEGIN
  []

  [pr2_Tfuel_train]
    type = PolynomialRegressionTrainer
    max_degree = 2
    response = data/fuel_average_temp:value
    cv_surrogate = pr2_Tfuel
    execute_on = TIMESTEP_BEGIN
  []
  [pr2_Tmod_train]
    type = PolynomialRegressionTrainer
    max_degree = 2
    response = data/moderator_average_temp:value
    cv_surrogate = pr2_Tmod
    execute_on = TIMESTEP_BEGIN
  []

  [pr4_Tfuel_train]
    type = PolynomialRegressionTrainer
    max_degree = 4
    response = data/fuel_average_temp:value
    cv_surrogate = pr4_Tfuel
    execute_on = TIMESTEP_BEGIN
  []
  [pr4_Tmod_train]
    type = PolynomialRegressionTrainer
    max_degree = 4
    response = data/moderator_average_temp:value
    cv_surrogate = pr4_Tmod
    execute_on = TIMESTEP_BEGIN
  []

  [pr6_Tfuel_train]
    type = PolynomialRegressionTrainer
    max_degree = 6
    response = data/fuel_average_temp:value
    cv_surrogate = pr6_Tfuel
    execute_on = TIMESTEP_BEGIN
  []
  [pr6_Tmod_train]
    type = PolynomialRegressionTrainer
    max_degree = 6
    response = data/moderator_average_temp:value
    cv_surrogate = pr6_Tmod
    execute_on = TIMESTEP_BEGIN
  []
[]

[Surrogates]
  [pr1_Tfuel]
    type = PolynomialRegressionSurrogate
    trainer = pr1_Tfuel_train
  []
  [pr1_Tmod]
    type = PolynomialRegressionSurrogate
    trainer = pr1_Tmod_train
  []

  [pr2_Tfuel]
    type = PolynomialRegressionSurrogate
    trainer = pr2_Tfuel_train
  []
  [pr2_Tmod]
    type = PolynomialRegressionSurrogate
    trainer = pr2_Tmod_train
  []

  [pr4_Tfuel]
    type = PolynomialRegressionSurrogate
    trainer = pr4_Tfuel_train
  []
  [pr4_Tmod]
    type = PolynomialRegressionSurrogate
    trainer = pr4_Tmod_train
  []

  [pr6_Tfuel]
    type = PolynomialRegressionSurrogate
    trainer = pr6_Tfuel_train
  []
  [pr6_Tmod]
    type = PolynomialRegressionSurrogate
    trainer = pr6_Tmod_train
  []
[]

[Reporters]
  [cv]
    type = CrossValidationScores
    models = 'pr1_Tfuel pr1_Tmod
              pr2_Tfuel pr2_Tmod
              pr4_Tfuel pr4_Tmod
              pr6_Tfuel pr6_Tmod'
    execute_on = TIMESTEP_END
  []
[]

[Outputs]
  json = true
  [model]
    type = SurrogateTrainerOutput
    trainers = 'pr1_Tfuel_train pr1_Tmod_train
                pr2_Tfuel_train pr2_Tmod_train
                pr4_Tfuel_train pr4_Tmod_train
                pr6_Tfuel_train pr6_Tmod_train'
  []
[]
