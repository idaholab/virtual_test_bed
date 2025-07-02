# ==============================================================================
# Model description:
# Base stochastic tools sampling input for GPBR200 equilibrium core model.
# Cannot be run on its own without a sampler named "sample" defined.
# This sampler must have six columns representing:
#     1. TRISO kernel radius (m)
#     2. Particle filling factor
#     3. U235 enrichment in weight fraction
#     4. Pebble unloading rate (pebbles/second)
#     5. Burnup limit (MWd/kgHM)
#     6. Reactor thermal power (W)
# The output is a CSV file with the provided samples and five QoIs:
#     1. Eigenvalue
#     2. Max fuel temperature (K)
#     3. Max RPV temperature (K)
#     4. Max pebble power (W)
#     5. Peaking factor
# ------------------------------------------------------------------------------
# Idaho Falls, INL, May 29, 2025
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

[MultiApps]
  [sub]
    type = SamplerFullSolveMultiApp
    input_files = gpbr200_ss_gfnk_reactor.i
    sampler = sample
    mode = batch-reset
    min_procs_per_app = 4
    ignore_solve_not_converge = true
  []
[]

[Controls]
  [param]
    type = MultiAppSamplerControl
    sampler = sample
    multi_app = sub
    param_names = 'kernel_radius
                   filling_factor
                   enrichment
                   pebble_unloading_rate
                   burnup_limit_weight
                   total_power'
  []
[]

[Reporters]
  [storage]
    type = StochasticMatrix
    sampler = sample
    sampler_column_names = 'kernel_radius
                            filling_factor
                            enrichment
                            pebble_unloading_rate
                            burnup_limit_weight
                            total_power'
    parallel_type = ROOT
  []
[]

[Transfers]
  [data]
    type = SamplerReporterTransfer
    from_multi_app = sub
    sampler = sample
    stochastic_reporter = storage
    from_reporter = 'eigenvalue/value
                     Tfuel_max/value
                     Trpv_max/value
                     pebble_power_max/value
                     peaking_factor/value'
  []
[]

[Outputs]
  csv = true
  execute_on = 'TIMESTEP_END'
[]
