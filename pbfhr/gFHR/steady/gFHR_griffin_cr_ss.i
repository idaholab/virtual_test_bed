# Coupled neutronics-thermal-fluids model to streamline method for equilibrium core
# The pebble model resolution is based on fluids mesh
# ------------------------------------------------------------------------------
# THIS INPUT IS THE FULL-PHYSICS VERSION
# ------------------------------------------------------------------------------

# Specify the pebble fuel input file
pebble_conduction_input_file = 'gFHR_pebble_triso_ss.i'

# Specify the flow subapp input file
flow_subapp_input_file = 'gFHR_pronghorn_ss.i'

# Base input shared between the regular simulation and the simulation used for testing purposes
!include gFHR_griffin_cr_ss_base.i

