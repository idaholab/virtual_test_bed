# Multiphysics results

A systematic multiphysics analysis was completed in the unit-cell HP-MR model for steady state operation by coupling the Griffin DFEM-SN(1,3) neutronics solver, the BISON thermal physics solver, the Sockeye heat-pipe thermal performance solver, and the BISON tensor mechanics solver. The resulting temperature, pressure, and power density output were then used to statistically determine failure rates for the HP-MR TRISO fuel particle, accounting for inevitable variations in fuel particle geometry that will inescapably arise during fuel particle fabrication. In this section, the simulation results are discussed.

## Unit-Cell Steady State Simulation Results

At the nominal power of ~1.8 kW, the Griffin-BISON-Sockeye model predicts the steady state operating parameters shown in [hpmr_ss].

!media media/mrad/hpmr_triso/unit_cell_thermo.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_ss
       caption=Axial distributions of HP-MR unit-cell fuel thermo-mechanical properties. The small peak near the bottom of the power density profile is due to thermal flux returning from the bottom beryllium reflector.

## Unit-Cell TRISO Fuel Failure Rates

The thermo-mechanical properties plotted above give rise to the following axial distributions of IPyC and SiC layer failure rates for the HP-MR TRISO fuel, plotted in [hpmr_ipyc] and [hpmr_sic], respectively, after 10 years of steady-state operation.

!media media/mrad/hpmr_triso/unitcell_IPyC.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_ipyc
       caption=Axial distribution of spatially-averaged IPyC crack rate in HP-MR TRISO fuel.

!media media/mrad/hpmr_triso/unitcell_SiC.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_sic
       caption=Axial distribution of spatially-averaged SiC crack rate in HP-MR TRISO fuel.

The crack rate of IPyC layer, with some statistical randomness, clearly varies parabolically along the axial profile of the unit-cell, with local maxima at the top and bottom of the unit-cell and a minimum near the unit-cell midplane. This variation is due to the combined variations of principal stresses and strength of the IPyC layer across the unit-cell. 

The crack rate of the SiC layer is zero across the axial profile of the unit-cell. Because the TRISO particle is only considered to have failed if the SiC layer fails, the overall TRISO failure rate within the steady-state unit-cell HP-MR is 0%. Therefore, though the IPyC layer cracks in a small percentage of particles at each axial step, the steady-state HP-MR operates within thermo-mechanical limits of the TRISO fuel.