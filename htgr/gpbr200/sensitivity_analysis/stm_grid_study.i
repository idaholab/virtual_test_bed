# ==============================================================================
# Model description:
# Grid study for select parameters and quantities of interest for GPBR200
# equilibrium core model.
# ------------------------------------------------------------------------------
# Idaho Falls, INL, May 29, 2025
# Author(s)(name alph): Dr. Zachary Prince
# ==============================================================================

!include stm_base_sampling.i

# Nominal parameter values -----------------------------------------------------
kernel_radius = 2.1250e-04
filling_factor = 0.0934404551647307 # Particle filling factor
enrichment = 0.155 # Enrichment in weight fraction
pebble_unloading_rate = '${fparse 1.5/60}' # pebbles per minute / seconds per minute.
burnup_limit_weight = 147.6 # MWd / kg
total_power = 200.0e+6 # Total reactor Power (W)

# Grid stepping ----------------------------------------------------------------
ngrid = 12
kernel_radius_step = '${fparse (kernel_radius_max - kernel_radius_min) / (ngrid - 1)}'
filling_factor_step = '${fparse (filling_factor_max - filling_factor_min) / (ngrid - 1)}'
enrichment_step = '${fparse (enrichment_max - enrichment_min) / (ngrid - 1)}'
pebble_unloading_rate_step = '${fparse (pebble_unloading_rate_max - pebble_unloading_rate_min) / (ngrid - 1)}'
burnup_limit_weight_step = '${fparse (burnup_limit_weight_max - burnup_limit_weight_min) / (ngrid - 1)}'
total_power_step = '${fparse (total_power_max - total_power_min) / (ngrid - 1)}'

[Samplers]
  [sample]
    type = Cartesian1D
    nominal_values = '${kernel_radius} ${filling_factor} ${enrichment} ${pebble_unloading_rate} ${burnup_limit_weight} ${total_power}'
    linear_space_items = '${kernel_radius_min} ${kernel_radius_step} ${ngrid}
                          ${filling_factor_min} ${filling_factor_step} ${ngrid}
                          ${enrichment_min} ${enrichment_step} ${ngrid}
                          ${pebble_unloading_rate_min} ${pebble_unloading_rate_step} ${ngrid}
                          ${burnup_limit_weight_min} ${burnup_limit_weight_step} ${ngrid}
                          ${total_power_min} ${total_power_step} ${ngrid}'
    min_procs_per_row = 4
    execute_on = PRE_MULTIAPP_SETUP
  []
[]
