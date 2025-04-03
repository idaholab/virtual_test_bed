# ------------------------------------------------------------------------------
# Description:
# gFHR input for testing purposes
# gFHR salt simulation
# Porous Flow Weakly Compressible Media Finite Volume
# ------------------------------------------------------------------------------
# THIS INPUT IS A GRIFFIN-ONLY VERSION USED FOR TESTING PURPOSES
# ------------------------------------------------------------------------------

# Set the conductivity type to one compatible with Griffin
pebble_bed_fluid_effective_conductivity_type=FunctorKappaFluid

# Include common input shared between full simulation and testing version
!include ../gFHR_pronghorn_ss_base.i
