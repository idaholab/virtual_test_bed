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
| Avg. Fuel Temperature | K | 935.9 |
| Max. Fuel Temperature | K | 957.3 |
| Min. Fuel Temperature | K | 910.2 |
| Avg. Moderator Temperature | K | 935.2 |
| Max. Moderator Temperature | K | 954.4 |
| Min. Moderator Temperature | K | 910.5 |
| $k_{eff}$ | n/a | 1.048428 |

## Load Following Transient Results

!media media/mrad/nahpmr/hpmr_lf_power.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_lf_power
       caption=Time evolution of reactor power during a load following transient.

!media media/mrad/nahpmr/hpmr_lf_temp.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_lf_temp
       caption=Time evolution of representative fuel temperatures during a load following transient.

The model predicts that an abrupt reduction in heat removal capability triggers an immediate rise in core temperature. As illustrated in [hpmr_lf_temp], the average fuel temperature increases by ~25 K within several hundred seconds, with the maximum fuel temperature peaking near 975 K. The resulting negative reactivity feedback drives a rapid decline in reactor power (see [hpmr_lf_power]), falling below 5% of its initial steady-state value within 1,000 seconds. This power reduction subsequently cools the core below its initial steady-state temperature, prompting a power rebound that peaks at approximately 23% near 1,800 seconds after the initiation of the event. As temperatures rise again, power once more decreases. A second power rebound, peaking at ~17%, occurs at approximately 3,600 seconds. These oscillations are expected to continue with diminishing amplitude until the system reaches a new, lower-power equilibrium. These results are consistent with prior K‑HPMR studies utilizing the effective-conductance heat-pipe model.

## Startup Transient Results

!media media/mrad/nahpmr/hpmr_temp.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_temp_startup
       caption=Time evolution of the calculated average temperatures of different reactor components during the startup.

As predicted by the multiphysics model, during HPMR startup, the thermal evolution of three representative HPMR components is shown in [hpmr_temp_startup]. Reactor temperatures initially rise rapidly while the heat pipes remain inactive. At approximately 600 seconds, the rate of increase slows, signaling heat pipes activation. Temperatures subsequently approach asymptotic values several hours after the power ramping concludes at 3,600 seconds.

!media media/mrad/nahpmr/hp_front.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_hp_front
       caption=Time evolution of startup front position for the two representative heat pipes.

The progression of the startup fronts in representative heat pipes (see [hpmr_hp_front]) corroborates these trends: the vapor fronts reach the leading edge of the condenser at approximately 500 seconds and traverse its full length by approximately 1500-2000 seconds, coinciding with the temperature change observed in [hpmr_temp_startup]. This behavior is further validated by the heat removal rates shown in [hpmr_hp_ht_rm]. Overall, this work demonstrates that the LCVF heat pipe in Sockeye model can be successfully coupled with neutronics and solid heat conduction physics applications to create a full-core multiphysics HPMR model capable of capturing complex startup transients.

!media media/mrad/nahpmr/hp_ht_rm.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_hp_ht_rm
       caption=Time evolution of heat removal rate for the two representative heat pipes.