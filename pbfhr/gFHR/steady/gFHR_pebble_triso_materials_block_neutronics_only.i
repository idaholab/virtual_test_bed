[Materials]
  [pebble_fuel]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'pfuel'
  []
  [pebble_graphite_core]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'pcore'
  []
  [pebble_graphite_shel]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'pshell'
  []

  # TRISO.
  [kernel]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'kernel'
  []
  [buffer]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'buffer'
  []
  [ipyc]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'ipyc'
  []
  [sic]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'sic'
  []
  [opyc]
    type = ADGenericConstantMaterial
    prop_names = 'k_s'
    prop_values = '10'
    block = 'opyc'
  []
[]
