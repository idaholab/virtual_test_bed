# ==============================================================================
# Parellel subset simulation setup to perform rare-event analysis
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[StochasticTools] #Configures the overall stochastic analysis and settings
[]

[Distributions] # Defines distributions for input paramters
  [INF] #Infiltration amount
    type = Uniform
    lower_bound = 0
    upper_bound = 1
  []

  [E] #Youngs modulus [Pa]
    type = Uniform
    lower_bound = 9e9
    upper_bound = 15e9
  []
  [K] #Thermal conductivity [W/mK]
    type = Uniform
    lower_bound = 25
    upper_bound = 100
  []
  [PD] #Power density [W/m^3]
    type = Uniform
    lower_bound = 2e6
    upper_bound = 5e7
  []
  [nu] #Poisson ratio
    type = Uniform
    lower_bound = 0.13
    upper_bound = 0.21
  []
  [Tinf] #Salt temperature [K]
    type = Uniform
    lower_bound = 823
    upper_bound = 1023
  []
  [htc] #Heat transfer coefficient [W/m^2K]
    type = Uniform
    lower_bound = 3500
    upper_bound = 5500
  []
  [CTE] #Coefficient of thermal expansion [1/K]
    type = Uniform
    lower_bound = 3.5e-6
    upper_bound = 6.0e-6
  []
[]

[Samplers] # Defines the sampler methods
  [sample]
    type = ParallelSubsetSimulation
    distributions = 'INF E K PD nu Tinf htc CTE'
    num_samplessub = 1000 #Number of simulations within a subset
    num_subsets = 5 #total number of subsets
    num_parallel_chains = 100 #Number of parellel simulations run concurrently
    output_reporter = 'constant/reporter_transfer:maxstress:value'
    inputs_reporter = 'adaptive_MC/inputs'
    seed = 1012
    execute_on = 'PRE_MULTIAPP_SETUP'
  []
[]

[MultiApps] #Manages the execution of sub-applications within the main simulation
  [sub]
    type = SamplerFullSolveMultiApp
    input_files = 'Baseline_Input.i'
    sampler = sample
  []
[]

[Transfers] # Facilitates transfer of data between main and sub app
  [reporter_transfer]
    type = SamplerReporterTransfer
    from_reporter = 'maxstress/value'
    stochastic_reporter = 'constant'
    from_multi_app = sub
    sampler = sample
  []
[]

[Controls]
  [cmdline] #Passes inputs to simulation based on sampler output
    type = MultiAppSamplerControl
    multi_app = sub
    sampler = sample
    param_names = 'INF E K PD nu Tinf htc CTE'
  []
[]

[Reporters]
  [constant]
    type = StochasticReporter
    outputs = none
  []
  [adaptive_MC] # Guides input selection towards rare-event
    type = AdaptiveMonteCarloDecision
    output_value = constant/reporter_transfer:maxstress:value
    inputs = 'inputs'
    sampler = sample
  []
[]

[Executioner]
  type = Transient
[]

[Outputs]
  [out]
    type = JSON
  []
[]
