# Na-HPMR Multiphysics Results

Multiphysics analysis was completed in the 1/6 core HP-MR model for the steady state operation of the Na-HPMR by coupling the Griffin high-fidelity neutronics with CFEM-SN(1,3) neutronics solver, the BISON heat conduction model, and the Sockeye heat-pipe performance model. In this section, the simulation results are discussed.

## Steady State Results

!media media/mrad/HPMR_Na_ss.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_na_ss
       caption=Steady state operation conditions as predicted by the Na-HPMR multiphysics model.

At the nominal power of ~2.07 MW, the Griffin-BISON-Sockeye model predicts the steady state operating conditions shown in [hpmr_na_ss] with key parameters summarized in [hpmr_na_ss_tab]

!table id=hpmr_na_ss_tab caption=Key Na-HPMR operating parameters at steady state at nominal power
| Parameter | Unit | Value |
| - | - | - |
| Thermal Power (1/6 core) | kW | 345.6 |
| Avg. Fuel Temperature | K | 939.6 |
| Max. Fuel Temperature | K | 964.3 |
| Min. Fuel Temperature | K | 914.4 |
| Avg. Moderator Temperature | K | 937.4 |
| Max. Moderator Temperature | K | 959.1 |
| Min. Moderator Temperature | K | 910.5 |
| $k_{eff}$ | n/a | 1.055887 |