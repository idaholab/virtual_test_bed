# Multiphysics Results

A comprehensive multiphysics analysis of the 1/6 core HP-MR model was carried out for 
nominal steady-state operation and a load following transient scenario, coupling the 
Griffin CFEM-SN(1,3) neutronics solver, the BISON thermomechanical physics solver, and the Sockeye heat pipe solver.

## Steady-State Results

Under nominal full-power operation at ~2.07 MW, the coupled solver predicts the core 
performance metrics listed in [hpmr_ss]. At these conditions, all heat pipe operating 
parameters remain well within performance limits.

!table id=hpmr_ss caption=Key HP-MR operating parameters at steady state and nominal power
| Parameter | Unit | Thermomechanics | Thermal-only |
| - | - | - | - |
| Thermal Power (1/6 core) | kW | 345.6 | 345.6 |
| Avg. Fuel Temperature | K | 844.84 | 844.83 |
| Max. Fuel Temperature | K | 870.15 | 870.16 |
| Min. Fuel Temperature | K | 815.27 | 815.22 |
| Avg. Moderator Temperature | K | 843.20 | 843.19 |
| Max. Moderator Temperature | K | 864.93 | 864.94 |
| Min. Moderator Temperature | K | 815.89 | 815.84 |
| Avg. Heat Pipe Surface Temperature | K | 835.60 | 835.58 |
| $k_{eff}$ | n/a | 1.0484555 | 1.0485662 |

The thermomechanical model results are in close agreement with those from the thermal-only model, with differences attributable to the inclusion of thermal expansion. The predicted $k_{eff}$ values are 1.0484555 and 1.0485662 for the thermomechanics and thermal-only models, respectively — a reduction of only 0.0001107 $\Delta k$, or less than 0.01% $\Delta k/k$. Temperature predictions are similarly consistent, with average fuel temperatures of 844.84 K and 844.83 K - deviations of no more than 0.01 K. Maximum and minimum temperatures across all material regions likewise agree to within 0.05 K ([hpmr_ss_pt]).

These results confirm that, under nominal steady-state conditions, the inclusion of thermal expansion effects introduces negligible perturbations to the neutronics and thermal response of the HP-MR. The effective core geometry change due to thermal deformation is sufficiently small that neither neutron leakage nor the spatial power distribution is meaningfully altered, and the thermal feedback remains essentially unchanged between the two models.

The primary benefit of the thermomechanical model is providing spatially resolved stress and strain distributions throughout the fuel compact ([hpmr_ss_disp]), which are entirely inaccessible from the thermal-only analysis. This enables more rigorous evaluation of TRISO fuel particle performance under irradiation conditions.

!media media/mrad/K-HPMR_SS_PowTemp.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_ss_pt
       caption=Steady-state fuel compact power density and temperature

!media media/mrad/K-HPMR_SS_Disp.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_ss_disp
       caption=Steady-state fuel compact and whole core displacements

## Load Following Transient Results

A sudden reduction in secondary-loop heat removal initiates the load following transient. With condenser-side heat removal rendered nearly ineffective, heat pipe temperatures increase, driving up core temperature. This activates the reactor's inherent negative temperature reactivity feedback mechanism that autonomously suppresses reactor power.

This is clearly reflected in the core's thermal and power histories ([hpmr_lf_powtemp]). As the transient begins, average fuel and moderator temperatures increase, reaching a peak of ~900 K near t = 100 s. Simultaneously, the temperature-induced negative reactivity feedback rapidly curtails reactor power, which settles at ~50 kW within 200 seconds with no further significant variation. As this power suppression takes hold, temperatures recede and approach a new equilibrium of 846 K for the fuel and the moderator within the first 1000 seconds of the event. 

While the thermomechanics and thermal-only models produced similar results at steady-state, more noticeable differences emerge during the transient. The power response remains identical between the two models throughout the event, indicating that the reactivity feedback magnitude is not significantly affected by the inclusion of thermal expansion. However, the temperature histories show visible separation, particularly during the initial excursion peak. The thermal-only model predicts higher peak fuel and moderator temperatures compared to the thermomechanical model, with differences of up to ~2 K near t = 100 s. This divergence arises because thermal expansion in the thermomechanical model causes an immediate geometric response to the temperature rise, increasing neutron leakage and providing an additional, small negative reactivity contribution on top of the temperature feedback alone, which marginally moderates the temperature excursion. As the transient progresses and temperatures stabilize, the two models converge toward the same equilibrium, consistent with the near-identical steady-state results observed earlier. 

!media media/mrad/K-HPMR_TR_PowTemp.png
       style=display: block;margin-left:auto;margin-right:auto;width:100%;
       id=hpmr_lf_powtemp
       caption=Time evolution of reactor power, peak, and average fuel compact and moderator temperatures during the load following transient

The structural deformation of core tracks this thermal evolution ([hpmr_lf_disp_mag]). During the initial temperature excursion, thermal expansion causes an immediate increase in core displacement, peaking at a magnitude of approximately $1.4\text{ mm}$. Because the bottom surface is constrained, the largest displacements occur near the upper region of the core. As temperatures stabilize, the thermal expansion relaxes into a new nominal deformation profile.

!media media/mrad/K-HPMR_TR_Mag.png
       style=display: block;margin-left:auto;margin-right:auto;width:50%;
       id=hpmr_lf_disp_mag
       caption=Average displacement as a function of core height and time during the load following transient.

Examination of the displacement components ([hpmr_lf_disp_comp]) indicates that the overall deformation is dominated by axial expansion (disp_z). The resulting deformation field remains continuous throughout the transient, indicating that the load following event produces a predictable, thermally driven expansion rather than introducing localized mechanical distortion or significant differential expansion.

!media media/mrad/K-HPMR_TR_Disp.png
       style=display: block;margin-left:auto;margin-right:auto;width:100%;
       id=hpmr_lf_disp_comp
       caption=Time- and height-dependent displacement components during the load following transient.

These results demonstrate the passive load-following capability of the HP-MR design. A loss of secondary cooling is accommodated entirely through inherent temperature reactivity feedback, allowing the reactor to autonomously settle at a reduced, stable power output without any active control action. The comparison between thermomechanics and thermal-only models further shows that thermal expansion contributes a modest but physically consistent supplementary feedback during transients, reducing the severity of peak temperature excursions, while the overall system response and equilibrium state remain governed primarily by temperature reactivity feedback.
