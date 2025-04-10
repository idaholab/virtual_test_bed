# ------------------------------------------------------------------------------
# Description:
# gFHR Pebble temperature model for equilibrium core calculation
# Currently using a Dirichlet BC for the pebble surface temperature
# ------------------------------------------------------------------------------
# THIS INPUT IS A SIMPLIFIED VERSION USING ONLY GRIFFIN FOR TESTING PURPOSES
# ------------------------------------------------------------------------------

# Base input shared between the regular simulation and the simulation used for testing purposes
!include ../gFHR_pebble_triso_ss_base.i
# Include Materials (ADGenericConstantMaterials) recognized by Griffin
!include gFHR_pebble_triso_materials_block_neutronics_only.i
