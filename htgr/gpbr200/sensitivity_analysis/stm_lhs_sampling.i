# ==============================================================================
# Model description:
# Latin hypercube sampling for select parameters and quantities of interest for
# GPBR200 equilibrium core model.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, May 29, 2025
# Author(s)(name alph): Dr. Zachary Prince
# ==============================================================================

!include stm_base_sampling.i

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
  [sample]
    type = LatinHypercube
    distributions = 'kr ff enrich pur bul power'
    num_rows = 10000
    min_procs_per_row = 4
    execute_on = PRE_MULTIAPP_SETUP
  []
[]
