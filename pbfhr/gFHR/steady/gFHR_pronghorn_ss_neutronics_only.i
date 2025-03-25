# ------------------------------------------------------------------------------
# Description:
# gFHR input
# gFHR salt simulation
# Porous Flow Weakly Compressible Media Finite Volume
# sprvel: superficial formulation of the velocities
# ------------------------------------------------------------------------------
# THIS INPUT IS A NEUTRONICS-ONLY (GRIFFIN) VERSION
# ------------------------------------------------------------------------------

# Set the conductivity type to one compatible with Griffin
pebble_bed_fluid_effective_conductivity_type=FunctorKappaFluid

# Include input common to all physics
!include gFHR_pronghorn_ss_base.i
