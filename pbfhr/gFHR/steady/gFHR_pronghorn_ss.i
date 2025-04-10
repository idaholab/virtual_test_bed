# ------------------------------------------------------------------------------
# Description:
# gFHR input
# gFHR salt simulation
# Porous Flow Weakly Compressible Media Finite Volume
# sprvel: superficial formulation of the velocities
# ------------------------------------------------------------------------------
# THIS INPUT IS THE FULL-PHYSICS VERSION
# ------------------------------------------------------------------------------

# Set the conductivity type using the Pronghorn model
pebble_bed_fluid_effective_conductivity_type=FunctorLinearPecletKappaFluid

# Include common input shared between full simulation and testing version
!include gFHR_pronghorn_ss_base.i

# Set a parameter specifically required by the FunctorLinearPecletKappaFluid conductivity type
FunctorMaterials/pebble_bed_fluid_effective_conductivity/porosity=porosity_energy
