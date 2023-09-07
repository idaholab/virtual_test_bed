#  High Temperature Engineering Test Reactor (HTTR) Loss-of-Forced Cooling (LOFC) Model

If using or modifying this model, please cite:

Vincent Labouré, Javier Ortensi, Nicolas Martin, Paolo Balestra, Derek Gaston, Yinbin Miao, Gerhard Strydom, "Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments", Annals of Nuclear Energy, Volume 189, 2023, 109838, ISSN 0306-4549, https://doi.org/10.1016/j.anucene.2023.109838. (https://www.sciencedirect.com/science/article/pii/S0306454923001573)


A detailed description of the model can be found in the following report:

Vincent M Laboure, Matilda A Lindell, Javier Ortensi, Gerhard Strydom and Paolo Balestra, "FY22 Status Report on the ART-GCR CMVB and CNWG International Collaborations." INL/RPT-22-68891-Rev000 Web. doi:10.2172/1893099.


# Files

## Cross section Files

The cross sections are located in vtb_httr/cross_sections.

Multigroup cross-section library - HTTR_5x5_9MW_profiled_VR_kappa_adjusted.xml

SPH factor library - HTTR_5x5_9MW_equiv_corrected.xml

## Mesh Files

Mesh files are located under vtb_httr/mesh.

Griffin full-core mesh -  full_core/full_core_HTTR.e

Full-core heat transfer mesh - full_core/thermal_mesh_in.e

BISON 5-pin mesh - fuel_element/HTTR_fuel_pin_2D_refined_m_5pins_axialref.e


## Input Files

Input files are located in vtb_httr/steady_state_and_null_transient.

Steady-state:

Griffin model - neutronics_eigenvalue.i

Full-core heat transfer model - full_core_ht_steady.i

BISON 5-pin model - fuel_elem_steady.i

RELAP-7 Control Rod Assembly thermal-hydraulics model - thermal_hydraulics_CR_steady.i

RELAP-7 Fuel Assembly thermal-hydraulics model - thermal_hydraulics_fuel_pins_steady.i


Null-transient:

Griffin model - neutronics_null.i

Full-core heat transfer model - full_core_ht_null.i

BISON 5-pin model - fuel_elem_null.i

RELAP-7 Control Rod Assembly thermal-hydraulics model - thermal_hydraulics_CR_null.i

RELAP-7 Fuel Assembly thermal-hydraulics model - thermal_hydraulics_fuel_pins_null.i


# Execution

In all cases (steady-state and null-transient - which should be executed in this order), run the Griffin input with Sabertooth.

For instance, on INL HPC

module load use.moose moose-apps sabertooth

mpiexec sabertooth-opt -i neutronics_eigenvalue.i

mpiexec sabertooth-opt -i neutronics_null.i

