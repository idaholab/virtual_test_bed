# Neutronics Results

## Analysis Method

The MHTGR-350 benchmark is based on the conceptual design by General Atomics.
In other words, this reactor has not been built.
As such, there is no real-world data to compare with the solutions of the benchmark
participant's codes.
Therefore, the presented results are compared with statistical metrics derived from
all the participant solutions. We will introduce these statistical metrics below.

The mean value ($\mu$) was calculated for various parameters of interest. The associated
standard deviation (SD) and the relative SD (RSD) of the calculated parameters were also
determined according to the following formulas where $N$ is the number of participants
solutions:

\begin{equation}
  \mu = \frac{1}{N} \sum_{i=1}^{N} x_i
\end{equation}

\begin{equation}
  SD = \sqrt{\frac{1}{N}\sum_{i=1}^{N}(x_i-\mu)^2}
\end{equation}

\begin{equation}
  RSD = 100\frac{SD}{\mu}
\end{equation}

Axial and radial averaging of solutions was computed using appropriate weights to consider
regions with different volumes.
The weights were normalized to 1.

\begin{equation}
  \mu = \sum_{i=1}^I w_i x_i
\end{equation}

\begin{equation}
  \sum_{i=1}^I w_i = 1
\end{equation}

The RSD indicates the degree of consistency between the results provided by participants:
a small RSD for a given parameter indicates consistency between the various codes and
data used, whereas a large RSD indicates a poor agreement.
For this benchmark, it was assumed that a good agreement between participants results
has been obtained when the RSD is less than the maximum shown in [table_rsd].
Conversely, if the quantities under comparison (e.g. eigenvalue, power, or flux) have an RSD larger than
the ones shown in [table_rsd], it was considered to indicate a poor agreement between
participants results.
It is noted that a low RSD does not mean that all the participants calculated the correct value;
rather that they calculated a similar value.
A reference result was not calculated for this problem, instead the mean values are used as the comparison
basis.
The statistical limitations inherent in the determination of the mean and variance
values for such a small data set are recognized.

!table id=table_rsd caption=Maximum RSD for various parameters ([!cite](mhtgr_benchmark)).
| Parameter | Maximum RSD (%) |
|     -     |       -         |
| $k_{eff}$ |      0.1        |
| CR Worth  |      2.0        |
| Axial offset |      2.5     |
| Axially averaged power distribution | 2.0 |
| Radially averaged power distribution | 2.0 |

The definition of CR worth, $\Delta \rho_{CR}$, used in the benchmark is:

\begin{equation}
  \Delta \rho_{CR} = \frac{k_{out}-k_{in}}{k_{out}k_{in}}
\end{equation}

where,

$k_{out}$ = eigenvalue with CR out

$k_{in}$ = eigenvalue with CR in.

The axial offset is defined as:

\begin{equation}
  AO = \frac{P_{top}-P_{bottom}}{P_{top}+P_{bottom}}
\end{equation}

where,

$P_{top}$ = total power produced in the top half of the core

$P_{bottom}$ = total power produced in the bottom half of the core.


## Numerical results for the one-sixth block control rod homogenization

A comparison of key integral parameters from the various participants is shown in
[eigenvalue_tri] through [ao_tri] with the statistical mean value $\pm$1 SD.
The statistics compiled from the submittals are included in [table_results].
The two distinct groupings can be observed again in the eigenvalue data.
The mean value for the transport solvers is 184 pcm higher than diffusion.
The SDs for transport and diffusion solutions are very similar, near 12 pcm.
When these statistics are combined, the SD is still within 100 pcm of the mean value.
The mean value for the CR worth is 1,108 pcm.
The difference in the CR worth predicted by transport and diffusion is within 30 pcm.
The RSD for diffusion, at ~1%, is twice that of the transport solvers and
leads to a combined value of 1.64%.
The axial offset has a mean of 0.148 and an RSD of 1.85%.

!media eigenvalue_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=eigenvalue_tri
       caption=Eigenvalue comparison -- 1/6 block ([!cite](mhtgr_inl)).

!media cr_worth_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=cr_worth_tri
       caption=CR worth comparison [pcm] -- 1/6 block ([!cite](mhtgr_inl)).

!media ao_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=ao_tri
       caption=Axial offset comparison [%] -- 1/6 block ([!cite](mhtgr_inl)).

!table id=table_results caption=Mean and SD for global parameters -- 1/6 block ([!cite](mhtgr_inl)).
| Parameter | $k_{eff}$ | CR worth (pcm) | Axial offset |
|    -      |     -     |        -       |       -      |
| Mean (diffusion solvers) | 1.06673 | 1094.4 | 0.149 |
| SD (diffusion solvers)   | 1.36E-4 |  10.3  | 1.13E-3 |
| RSD (diffusion solvers)  | 1.27E-2 |  0.937 | 0.757 |
| - | - | - | - |
| Mean (transport solvers) | 1.06857 | 1126.8 | 0.146 |
| SD (transport solvers)   | 1.10E-4 | 5.49   | 3.14E-3 |
| RSD (transport solvers)  | 1.03E-2 | 0.487  | 2.16  |
| - | - | - | - |
| Mean (all solvers) | 1.06752 | 1108.3 | 0.148 |
| SD (all solvers)   | 9.22E-4 | 18.2   | 2.73E-3 |
| RSD (all solvers)  | 8.64E-2 | 1.64   | 1.85  |

The mean and RSD values of the radially averaged axial power distribution (APD) are
shown in [radial_average_apd_tri] and [radial_average_apd_rsd_tri].
The top peaked distribution for this core is consistent with the axial offset results.
The RSD is highest near the top and bottom reflectors with a maximum of 1.6% near the bottom.
The solutions show good agreement through most of the active core region within 0.5%.
It was found that the diffusion solutions tend to under-predict the power
near the axial fuel-reflector interface.
The transport solutions remain within 1.0% of the mean value, but the diffusion
solutions have a lot more variability (transport plots may be found in [!cite](mhtgr_inl)).
This can arise from discrepancies in the modelling, solution method,
but it can also stem from poor convergence of the solution.
The diffusion solvers that rely on FEM discretization (INSTANT-P1, Rattlesnake, and CAPP) display
similar behavior, whereas the other diffusion methods are more scattered.

!media radial_average_apd_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=radial_average_apd_tri
       caption=Radially averaged axial power distribution -- 1/6 block ([!cite](mhtgr_inl)).

!media radial_average_apd_rsd_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=radial_average_apd_rsd_tri
       caption=Radially averaged axial power distribution RSD -- 1/6 block ([!cite](mhtgr_inl)).

The mean and RSD values of the axially averaged radial power distribution (RPD) are
shown in [mean_axial_average_rpd_tri] and [rsd_axial_average_rpd_tri].
Two main factors affect the shape of the power: 1) the loading pattern; and 2) the proximity to reflectors.
As expected, once-burned locations near the reflectors exhibit the highest power densities.
These locations also have the largest magnitude of the RSD but are within 1.2% of the mean value.
When compared to the transport solutions, the diffusion solvers tend to over-predict the power
in the ring near the inner reflector region and under-predict the power in the outer ring by the replaceable
reflector ([!cite](mhtgr_inl)).

!media mean_axial_average_rpd_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=mean_axial_average_rpd_tri
       caption=Mean value of the axially averaged radial power distribution -- 1/6 block ([!cite](mhtgr_inl)).

!media rsd_axial_average_rpd_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=rsd_axial_average_rpd_tri
       caption=RSD of the axially averaged radial power distribution -- 1/6 block ([!cite](mhtgr_inl)).

The radially averaged flux distribution and RSD for the fast, epithermal and thermal energy
ranges are shown in [radial_average_flux_tri].
The thermal flux in the active core for this EOEC MHTGR350 is on the order of $4 \cdot 10^{13} \frac{n}{cm^2
\cdot sec}$ and is three and six times larger in magnitude than
the epithermal and fast fluxes, respectively.
The flux shape tends to flatten as the neutron energy is decreased since
large neutron migration lengths characterize this core and neutrons will
spatially distribute in the lower energy groups.
The RSD for the fast group is highest near the bottom reflector,
which is consistent with the RSD in the power shape from
[radial_average_apd_tri], since fast neutrons emerge directly from fission sites, even though the deviation
is higher for the flux with a peak value near 2.4%.
The epithermal flux includes two regions that have high deviation,
the bottom of the core (2.1%) and the region near the power peak (1.8%).
The thermal flux has the largest values of the RSD (2.4%) near the thermal peak,
about 5 meters from the bottom of the active core.

!media radial_average_flux_tri.png
       style=width:100%;margin-left:auto;margin-right:auto
       id=radial_average_flux_tri
       caption=Mean value and RSD of the radially averaged fast, epithermal, and thermal flux distribution -- full ([!cite](mhtgr_inl)).

!alert! note
The cross-section data used in the calculations consists of 26 energy groups to better
capture the reflector effects, which dominate the neutron physics in this core design.
In the analysis of the data, the 26 groups are condensed into three energy ranges as shown in
[energy_bounds].

!table id=energy_bounds caption=Energy boundaries.
| Group name | Group number | Energy range (eV) | - |
| - | - | - | - |
| - | - | Upper | Lower |
| Fast       | 1-4 | 1.96E+07 | 9.47E+04 |
| Epithermal | 5-15 | 9.47E+04 | 4.93 |
| Thermal    | 16-26 | 4.93 | 1.10E-04 |

!alert-end!

The mean value and RSD of the axially averaged neutron flux distributions are included in
[axial_average_radial_fast_flux_tri] through [axial_average_radial_thermal_flux_tri].
These values are axially averaged over the layers in the active core region only.
The flux values shown contain the radial reflector regions.
The fast flux magnitude in [axial_average_radial_fast_flux_tri] rapidly decreases, by a factor of 3 to 4, in the first reflector ring as
fast neutrons from the active core encounter reflector regions.
The magnitude drops further another order of magnitude on each subsequent
reflector ring as one moves further away from the source of fast neutrons to the core boundary.
The RSD for the fast flux remains within 2.5% of the mean in the active core region,
but quickly increases for each subsequent reflector ring to ~8% and ~12% for the first two reflector rings.
Larger uncertainties are observed in the permanent reflector with values near 20% and a maximum of 40%.
This can be attributed to differences in methods and modelling.
Diffusion tends to have a poor representation of the flux near a void boundary compared to transport.

!media axial_average_radial_fast_flux_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=axial_average_radial_fast_flux_tri
       caption=Mean value and RSD of the axially averaged (active core region) radial fast flux distribution from all solutions -- 1/6 block ([!cite](mhtgr_inl)).

The epithermal flux distribution in [axial_average_radial_epi_flux_tri] has a similar shape to
the fast flux but with a peak that is slightly broader
(i.e. encompasses parts of the first ring of reflectors, after which it quickly diminishes).
The RSD for epithermal fluxes remain within 2% of the mean in the
active core region, but increases for each subsequent reflector ring to ~3.0-4.0% for
the first two reflector rings.
In the permanent reflector the RSD values are near 5% and a maximum of about 9%.

!media axial_average_radial_epi_flux_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=axial_average_radial_epi_flux_tri
       caption=Mean value and RSD of the axially averaged (active core region) radial epithermal flux distribution from all solutions -- 1/6 block ([!cite](mhtgr_inl)).

Finally, the thermal flux distribution ([axial_average_radial_thermal_flux_tri])
is characterized by a high peak in the central
reflector region with a magnitude of $1.5 \cdot 10^{14} \frac{n}{cm^2\cdot sec}$.
This magnitude decreases to $~4.0 \cdot 10^{13} \frac{n}{cm^2\cdot sec}$ in the active core region,
as thermal neutrons encounter fuel, and another, smaller peak in the replaceable reflector region.
After this last region, the thermal flux remains relatively flat into the permanent reflector.
The RSD for thermal fluxes exhibits a different behavior than the other energy ranges,
where the values remain within 2% of the mean in the active core and reflector regions.

!media axial_average_radial_thermal_flux_tri.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=axial_average_radial_thermal_flux_tri
       caption=Mean value and RSD of the axially averaged (active core region) radial thermal flux distribution from all solutions -- 1/6 block ([!cite](mhtgr_inl)).

## Conclusions

Overall, the results from these exercises show good agreement among the various models.

!alert note
This page only contains results for the 1/6th control rod homogenization scheme. The conclusions are derived from the full work of the exercise that can be found in [!cite](mhtgr_inl).

The conclusions from this exercise are:

- The transport solvers produce eigenvalues that are ~190 pcm above the diffusion solutions for both homogenizations.

- When diffusion and transport eigenvalues are evaluated together the standard deviation (SD) is within 100 pcm of the mean.

- The type of control rod (CR) homogenization used does not have a large effect on the eigenvalue due to the shallow insertion of the CR bank in this configuration.

- Transport solvers calculate a CR worth that is 30 pcm above that of the diffusion estimate. The relative standard deviation (RSD) in the calculation of the CR worth is less than 1% for the independent solver groups, diffusion and transport, but the combined statistical values are within 1.7%.

- The worth of the CR is very sensitive to the CR homogenization, with 275 pcm higher CR worth using the one-sixth CR homogenisation.

- The CR homogenization has a significant effect on the power distribution. The full homogenisation over-predicts the radially averaged power on the top of the core by 5% and under-predicts the power at the bottom of the core by -2.6%. The radial power distributions (RPDs) show a maximum difference of 23.97% between the two CR homogenisations at the top level of the active core region.

- The CR homogenization produces thermal flux differences of 22% in the active core.
