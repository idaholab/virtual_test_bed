# ==============================================================================
# Model description
# Single Pebble temperature model
# ------------------------------------------------------------------------------
# Idaho Falls, INL, September 29, 2022
# Author(s): Dr. Sebastian Schunert, Dr. Javier Ortensi, Dr. Mustafa Jaradat
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

!include pebble_triso.i

# the steady state case needs an initialization
[Variables]
  [T_pebble]
    initial_condition = ${initial_temperature}
  []
  [T_triso]
    initial_condition = ${initial_temperature}
  []
[]
