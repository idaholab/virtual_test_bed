# Coupled neutronics-thermal-fluids model to streamline method for equilibrium core
# ------------------------------------------------------------------------------
# THIS INPUT IS A NEUTRONICS-ONLY (GRIFFIN) VERSION USED FOR TESTING PURPOSES
# ------------------------------------------------------------------------------

# Specify the pebble fuel input file
pebble_conduction_input_file = 'testing/gFHR_pebble_triso_ss_neutronics_only.i'

# Specify the flow subapp input file
flow_subapp_input_file = 'testing/gFHR_pronghorn_ss_testing.i'

# Base input shared between the regular simulation and the simulation used for testing purposes
!include ../gFHR_griffin_cr_ss_base.i
