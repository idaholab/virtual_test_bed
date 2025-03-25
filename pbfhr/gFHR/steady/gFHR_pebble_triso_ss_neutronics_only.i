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
# THIS INPUT IS A NEUTRONICS-ONLY (GRIFFIN) VERSION
# ------------------------------------------------------------------------------

# Include input common to all physics
!include gFHR_pebble_triso_ss_base.i
# Include Materials (ADGenericConstantMaterials) recognized by Griffin
!include gFHR_pebble_triso_materials_block_neutronics_only.i
