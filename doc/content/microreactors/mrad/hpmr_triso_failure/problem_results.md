# Multiphysics results

A systematic multiphysics analysis was completed in the unit-cell HP-MR model for steady state operation by coupling the Griffin DFEM-SN(1,3) neutronics solver, the BISON thermal physics solver, the Sockeye heat-pipe thermal performance solver, and the BISON solid mechanics solver. The resulting temperature, pressure, and power density output were then used to statistically determine failure rates for the HP-MR TRISO fuel particle, accounting for inevitable variations in fuel particle geometry that will inescapably arise during fuel particle fabrication. In this section, the simulation results are discussed.

## Unit-Cell Steady State Simulation Results

At the nominal power of ~1.8 kW, the Griffin-BISON-Sockeye model predicts the steady state operating parameters shown in [hpmr_ss].

!media media/mrad/hpmr_triso/unit_cell_thermo.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_ss
       caption=Axial distributions of HP-MR unit-cell fuel thermo-mechanical properties. The small peak near the bottom of the power density profile is due to thermal flux returning from the bottom beryllium reflector.

## Unit-Cell TRISO Fuel Failure Rates

The thermo-mechanical properties plotted above give rise to the following axial distributions of IPyC and SiC layer failure rates for the HP-MR TRISO fuel, plotted in [hpmr_triso], after 10 years of steady-state operation. A stochastic convergence study determined 20,000 samples were sufficient to establish convergence in the stochastic analysis. Below results show spatially-averaged results at 32 axial locations in the HP-MR unit cell.

!media media/mrad/hpmr_triso/unitcell_triso.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_triso
       caption=Axial distribution of spatially-averaged IPyC and SiC failure probabilities in HP-MR TRISO fuel.

The failure rate of IPyC layer varies parabolically along the axial profile of the unit-cell, with local maxima at the top and bottom of the unit-cell and a minimum near the unit-cell midplane, which inversely correlated to the power density curve in [hpmr_ss]. Lower temperature at the unit-cell edges leads to increased stresses in TRISO particles, largely due to enhanced material stiffness, limited stress relaxation mechanisms, and thermal expansion mismatches among layers.

The SiC layer failure rate maintains 0 % across the axial profile of the unit-cell. Because the TRISO particle is only considered to have failed if the SiC layer fails, the overall TRISO failure rate within the steady-state unit-cell HP-MR is 0%. Therefore, though the IPyC layer cracks in a small percentage of particles at each axial step, the steady-state HP-MR operates within thermo-mechanical limits of the TRISO fuel.