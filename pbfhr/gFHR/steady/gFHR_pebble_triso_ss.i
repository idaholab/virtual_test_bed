# ------------------------------------------------------------------------------
# Description:
# gFHR pebble heat conduction
# Finite Element - Continuous Galerkin
# Single pebble calculation, meant to be distributed over the volume using MultiApps
# ------------------------------------------------------------------------------
# Description:
# gFHR Pebble temperature model for equilibrium core calculation
# Currently using a Dirichlet BC for the pebble surface temperature
# ------------------------------------------------------------------------------
# THIS INPUT IS THE FULL-PHYSICS VERSION
# ------------------------------------------------------------------------------

# Base input shared between the regular simulation and the simulation used for testing purposes
!include gFHR_pebble_triso_ss_base.i
# Include Pronghorn-specific Materials and UserObjects
!include gFHR_pebble_triso_materials_and_user_objects_blocks_pronghorn.i
