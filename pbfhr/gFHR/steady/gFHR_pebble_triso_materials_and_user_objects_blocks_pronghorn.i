[Materials]
  [pebble_fuel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = pebble_fuel
    block = 'pfuel'
  []
  [pebble_graphite_core]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = gcore
    block = 'pcore'
  []
  [pebble_graphite_shel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_pebble
    solid = gmatrix
    block = 'pshell'
  []

  # TRISO.
  [kernel]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = kernel
    block = 'kernel'
  []
  [buffer]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = buffer
    block = 'buffer'
  []
  [ipyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = ipyc
    block = 'ipyc'
  []
  [sic]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = sic
    block = 'sic'
  []
  [opyc]
    type = PronghornSteadyStateSolidMaterial
    T_solid = T_triso
    solid = opyc
    block = 'opyc'
  []
[]

[UserObjects]
  [kernel]
    type = FunctionSolidProperties
    k_s = '1/(0.035 + 2.25e-4*t) + 8.30e-11*t^3'
    rho_s = 10500.0
    cp_s = 320.0
  []
  [buffer]
    type = FunctionSolidProperties
    k_s = 0.7
    rho_s = 1050.0
    cp_s = 1760.0
  []
  [ipyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1900.0
    cp_s = 1760.0
  []
  [sic]
    type = FunctionSolidProperties
    k_s = 16.0
    rho_s = 3180.0
    cp_s = 1242.0
  []
  [opyc]
    type = FunctionSolidProperties
    k_s = 4.0
    rho_s = 1900.0
    cp_s = 1760.0
  []
  [gmatrix]
    type = FunctionSolidProperties
    k_s = 32.4
    rho_s = 1740.0
    cp_s = 1760.0
  []
  [gcore]
    type = FunctionSolidProperties
    k_s = 30.0
    rho_s = 1410.0
    cp_s = 1760.0
  []

  # Mixtures.
  [triso]
    type = CompositeSolidProperties
    materials = '  kernel     buffer        ipyc        sic        opyc    '
    fractions = '0.122819817 0.267788699 0.170012025 0.18412303 0.255256428' # volume fractions.
    k_mixing = 'series'
  []
  [pebble_fuel]
    type = CompositeSolidProperties
    materials = 'triso gmatrix'
    fractions = '0.220003 0.779997' # volume fractions.
    k_mixing = 'chiew'
  []
[]

