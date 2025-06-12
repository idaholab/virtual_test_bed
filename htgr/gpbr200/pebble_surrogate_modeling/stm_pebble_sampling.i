[ParameterStudy]
  input = gpbr200_ss_bsht_pebble_triso.i
  parameters = 'kernel_radius
                filling_factor
                Postprocessors/pebble_surface_temp/default
                Postprocessors/porous_media_power_density/default'
  quantities_of_interest = 'fuel_average_temp/value moderator_average_temp/value'

  sampling_type = lhs
  num_samples = 10000
  distributions = 'uniform uniform uniform uniform'
  uniform_lower_bound = '1.5e-4 0.05 300 0'
  uniform_upper_bound = '3.0e-4 0.2 2273 4.0e7'

  compute_statistics = false
  sampler_column_names = 'kernel_radius filling_factor pebble_surface_temp porous_media_power_density'
  output_type = csv
[]
