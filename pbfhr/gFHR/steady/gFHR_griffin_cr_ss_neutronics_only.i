# Coupled neutronics-thermal-fluids model to streamline method for equilibrium core
# The pebble model resolution is based on fluids mesh
#
# 4 energy group structure [eV] :
#   1.96403000E+07  1.95007703E+05
#   1.95007703E+05  1.75647602E+01
#   1.75647602E+01  2.33006096E+00
#   2.33006096E+00  1.10002700E-04
# ------------------------------------------------------------------------------
# THIS INPUT IS A NEUTRONICS-ONLY (GRIFFIN) VERSION
# ------------------------------------------------------------------------------

# Specify the pebble fuel input file
pebble_conduction_input_file = 'gFHR_pebble_triso_ss_neutronics_only.i'

# Specify the flow subapp input file
flow_subapp_input_file = 'gFHR_pronghorn_ss_neutronics_only.i'

# Include input common to all physics
!include gFHR_griffin_cr_ss_base.i
