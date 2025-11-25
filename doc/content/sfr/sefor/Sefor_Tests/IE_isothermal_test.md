# SEFOR Core I-E Isothermal Test 

# Isothermal Test

Isothermal tests were conducted in Core I-E to determine the temperature coefficients of reactivity in SEFOR. During the tests, the primary coolant was gradually heated from 350 °F to 760 °F using a primary loop trace heating system. After reaching 760 °F, sodium was cooled to about 700 °F and was then reheated back to 760 °F.  Coolant inlet and outlet temperatures were monitored by resistance temperature detectors (RTDs), while the in-vessel coolant temperature was measured by thermocouples (T/Cs). The uncertainties assigned to the RTD measurements were ± 2.5 °F, and the uncertainties for the T/Cs were much smaller and were about ± 0.5 °F[!citep](Noble1970sefor). 

The heating rate was about 20 °F per hour for ensuring good convergence of temperatures within the core. In the isothermal tests, the radial reflector positions were adjusted to compensate for the negative reactivity feedback developed during the test. Reactor power was kept small at about 600 W. Coolant temperatures and reflector positions were recorded every 15 minutes. The reactivity feedback corresponding to the elevated core temperatures were derived based on the calibrated reflector worth.  

## Criticality

For assessing the accuracy of the Griffin neutronic model for Core I-E, Griffin-calculated multiplication factor at the uniform temperature of 450 K, along with corresponding Shift Monte Carlo reference result, are summarized in [k_eff]. The Griffin result is consistent with the Shift result. For Core I-E, the measured excess reactivity with all ten reflectors up to cover the fuel region is estimated to be about 3.4$. With βeff = 327 pcm, the numerical model predicted k-effs agree with the measured k-eff within 120 pcm. 

!table id=k_eff caption=Multiplication factor of SEFOR core I-E compared with reference results and experimental data
| Code                                 | $k_{eff}$       | Diff. (pcm) |
| :-                                   | -               | -           |
| Shift                                | 1.01102±0.00004 | -22         |
| Griffin                              | 1.01240         | 116         |
| Experiment ($\beta_{eff}$ = 327 pcm) | 1.01124         | Ref.        |

## Reactivity Feedback

The negative reactivity feedback measured in these tests represents the combined effects of Doppler broadening of nuclear cross sections, and thermal expansions of structures, fuels and coolant in the reactor core. Reactivity feedback in SEFOR isothermal tests were computed using Griffin deterministic model with "flux_moment_primal_variable" turned on. The total reactivity feedback was calculated as the differences between the multiplication factors of the core static states at different temperature points, with temperature dependent cross section libraries generated from MC$^2$-3 and updated active core geometry according to the thermal expansion coefficients listed in [l_alpha]. 

!table id=l_alpha caption=Linear thermal expansion coefficients used for modeling SEFOR isothermal tests
|Materials | (294, 449)K | (449, 677)K |
| :- | - | - |
| Reflector (Ni based) | 1.6197E-05 | 1.7212E-05 |
| Insulator (UO2)      | 0.0000E+00 | 7.0240E-06 |
| Fuel (MOX)           | 5.0869E-06 | 6.1418E-06 |
| Gap (spring)         | 1.3540E-04 | 1.3162E-04 |
| Steel 304            | 1.7174E-05 | 1.8077E-05 |
| Steel 316            | 1.6631E-05 | 1.7535E-05 |
| BeO                  | 6.6887E-06 | 8.3156E-06 |
| B4C                  | 4.5000E-06 | 4.5000E-06 |

Similarly, Shift models were also used to compute the total reactivity feedback and compare against experimental results. Core geometries at different temperatures were adjusted and detail discussions on modeling the isothermal tests were documented in [!citep](Yan2025sefor).

!media media/sefor/IE_isothermal.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=IE_isothermal
      caption= Calculated and measured isothermal reactivity feedback for SEFOR Core I-E

[IE_isothermal] plotted the calculated total reactivity feedback from the SEFOR isothermal tests, obtained using the Monte Carlo Shift models and the Griffin neutronic models. Both models showed excellent agreement to the experiment, demonstrated very good accuracy of this VTB model in predicting the SEFOR reactor feedback effects using the NEAMS tools. As summarized in [IE_isothermal_t], the numerical models for core I-E only slightly underestimated the total reactivity feedback by about 3%-6% when core temperature increased from 350 °F to 760 °F.

!table id=IE_isothermal_t caption=Comparison of the calculated total reactivity feedback with experimental value for isothermal tests conducted in core I-E and core temperatures rose from 350 °F to 760 °F
|             | integral ∆ρ (cents) |   C/E    |
| :- | - | - |
| Measurement | -253.90                         |   ---    |
| Shift       | -240.82 ± 2.76                  |  0.9485  |
| Griffin     | -239.40                         |  0.9429  |

