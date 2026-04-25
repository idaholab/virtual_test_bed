# Full Core GCMR Multiphysics Model with Fission Product Tracking

## Overview

This model extends the [Full Core GCMR Multiphysics Model](/GCMR_Core_Multiphysics_models.md) by incorporating spatially-resolved tracking of the two dominant fission product poisons: Xe-135 and Sm-149. The mesh, involved applications, and three-level Griffin–BISON–SAM MultiApp coupling are identical to the baseline model and their descriptions are not repeated here. Two targeted changes distinguish this model from the baseline:

1. A cross-section library tabulated over fission product concentrations (`GCMR_XS_Xe_TR.xml`) replaces the baseline library.
2. Griffin's `PowerDensity` block activates spatially-resolved tracking of the I-135 $\rightarrow$ Xe-135 and Pm-149 $\rightarrow$ Sm-149 decay chains.

The model is used to simulate a control rod insertion transient, demonstrating how fission product inventories evolve under a power reduction representative of a load-following maneuver.

## Fission Product Tracking Methodology

### Decay Chains

Two fission product chains are currently supported by Griffin's poison tracking capability: $^{135}$Xe and $^{149}$Sm, which are covered by this model.

The $^{135}$Xe decay chain is given by:

\begin{equation}
\frac{\partial N_I}{\partial t} = \sum_{g=1}^{G} \gamma_{I,g}\,\Sigma_{f,g}\,\phi_g - \lambda_I N_I,
\end{equation}

\begin{equation}
\frac{\partial N_{Xe}}{\partial t} = \lambda_I N_I + \sum_{g=1}^{G} \gamma_{Xe,g}\,\Sigma_{f,g}\,\phi_g - \lambda_{Xe} N_{Xe} - \sum_{g=1}^{G} \sigma_{Xe,g}\,\phi_g\,N_{Xe}
\end{equation}

where $N_I$ and $N_{Xe}$ are the $^{135}$I and $^{135}$Xe atomic densities in 1/(barn-cm). The densities are stored as array auxiliary variables. In addition, for any energy group of index $g$, $\gamma_{I,g}$ and $\gamma_{Xe,g}$ are the $^{135}$I and $^{135}$Xe effective fission yields, respectively; $\Sigma_{f,g}$ is the macroscopic fission cross section in 1/cm, $\phi_g$ is the scalar flux in 1/(barn-s), and $\sigma_{Xe,g}$ is the microscopic $^{135}$Xe absorption cross section in barns. Moreover, $\lambda_I$ and $\lambda_{Xe}$ are the $^{135}$I and $^{135}$Xe decay constants, respectively. Using similar notation, the $^{149}$Sm decay chain is given by:

\begin{equation}
\frac{\partial N_{Pm}}{\partial t} = \sum_{g=1}^{G} \gamma_{Pm,g}\,\Sigma_{f,g}\,\phi_g - \lambda_{Pm} N_{Pm},
\end{equation}

\begin{equation}
\frac{\partial N_{Sm}}{\partial t} = \lambda_{Pm} N_{Pm} - \sum_{g=1}^{G} \sigma_{Sm,g}\,\phi_g\,N_{Sm},
\end{equation}

with the subscripts Pm and Sm referring to $^{149}$Pm and $^{149}$Sm, respectively.

The aforementioned four isotopes (I-135, Xe-135, Pm-149, and Sm-149) are tracked as spatially-resolved fields within the fuel region and feed back into Griffin's neutronics solve at every time step through the cross-section library.

### Cross-Section Library

The baseline multiphysics model uses `GCMR_XS_2grid_detailed.xml`, tabulated over fuel temperature ($T_{fuel}$) and hydrogen stoichiometry in the YH moderator. This model instead uses `GCMR_XS_Xe_TR.xml`, which additionally incorporates the fission product concentrations, enabling the neutronics solver to account for the self-shielding and spectral effects of Xe-135 and Sm-149 as they evolve in space and time. For simplicity, `GCMR_XS_Xe_TR.xml` is only tabulated over fuel temperature ($T_{fuel}$) with three grid points (800K, 925K, and 1300K).

### Griffin Input Configuration

The `PowerDensity` block activates fission product tracking through the `poison_tracking_chains` parameter:

!listing microreactors/gcmr/core/Multiphysics/steady_state_fp/MP_Griffin_ss_fp.i block=PowerDensity

The steady-state `UserObjects` block writes the converged neutron flux and poison density fields to files at the end of the run, providing physically consistent initial conditions for the transient:

!listing microreactors/gcmr/core/Multiphysics/steady_state_fp/MP_Griffin_ss_fp.i block=UserObjects

The transient `UserObjects` block reads those saved fields at initialization:

!listing microreactors/gcmr/core/Multiphysics/transient_fp/MP_Griffin_tr_fp.i block=UserObjects

## Steady-State with Equilibrium Fission Products

The coupled steady-state simulation runs fixed-point iterations between Griffin (eigenvalue transport with CMFD acceleration) and the BISON–SAM sub-application until temperatures and fission product concentrations converge simultaneously. Temperature results are consistent with the baseline model (see [/GCMR_Core_Multiphysics_models.md]).

At equilibrium, I-135 and Xe-135 concentration fields closely mirror the neutron flux distribution, peaking in the high-flux inner assemblies. Sm-149 reaches a nearly homogeneous equilibrium distribution because its long-lived Pm-149 precursor smooths spatial gradients before Sm-149 is produced.

## Control Rod Insertion Transient

### Scenario Description

Starting from the equilibrium full-power state, the control rods are instantaneously repositioned at $t = 0$ from their fully withdrawn position (2.2 m) to nearly fully inserted (0.2 m), driving a rapid power reduction representative of a reactor shutdown transient. The simulation is carried out to 10 hours in order to largely capture the post-shutdown evolution of Xe-135 and Sm-149 as they approach their new equilibrium concentrations during reactor shutdown.

### Power Response

[cr_fp_pow] shows the reactor power evolution following the control rod insertion. The large negative reactivity insertion from the rods causes an immediate power drop. Due to the significant negative reactivity introduced, the temperature feedback effects are not sufficient to stabilize the reactor at an reduced power level, so the power drops to a marginal level monotonically without any oscillations or plateaus.

!media media/gcmr/FCMP/cr_fp_pow.png
      id=cr_fp_pow
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Reactor power evolution during the control rod insertion transient.

### Fission Product Inventory Evolution

[cr_fp_evolve] shows the time evolution of the average concentrations of the four tracked isotopes during the first 10 hours following the control rod insertion, normalized to their values at steady state (pre-transient).

!media media/gcmr/FCMP/cr_fp_evolve.png
      id=cr_fp_evolve
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Evolution of I-135, Xe-135, Pm-149, and Sm-149 concentrations following the control rod insertion, normalized to their values at the first timestep.

Following the power reduction:

- +I-135+ exhibits the most rapid decline, dropping to roughly 35% of its initial value within 10 hours, consistent with its ~6.57-hour half-life and the abrupt loss of its fission-driven production source.
- +Xe-135+ decreases monotonically and more gradually than I-135, falling to approximately 78% of its initial value at 10 hours. The decline reflects the combined effects of reduced production from both fission and I-135 decay, partially offset by the lower neutron burnout rate in the post-insertion low-flux environment.
- +Pm-149+ decreases slightly to about 88% of its initial value. Given the quick shutdown, the generation of Pm-149 is halted, and the reduction rate is consistent with its ~53-hour half-life.
- +Sm-149+ remains mostly constant over the 10-hour window, with a marginal increase due to the decay of Pm-149. As the equilibrium Sm-149 concentration is two orders of magnitude higher than Pm-149, the decay of Pm-149 has a negligible impact on Sm-149 levels.

Notably, the classical post-shutdown Xe-135 peak (the "xenon pit") is not predicted by this model. Following the control rod insertion, the Xe-135 inventory decreases monotonically rather than transiently rising before relaxing to a new equilibrium. This behavior is attributed to the relatively low average power density of the GCMR core: at low flux levels, the I-135 $\rightarrow$ Xe-135 decay source is insufficient to overcome the loss terms, so no net Xe-135 buildup occurs after the power reduction. This behavior is related to the I-135/Xe-135 equilibrium ratio at the initial full-power state ($N_I/N_{Xe}$)$_{eq}$, which is positively correlated with the neutron flux and thus the power density. During control rod insertion, for simplicity, assuming the power density or neutron flux is eliminated instantaneously, the Xe-135 evolution is then governed by:

\begin{equation}
\frac{\partial N_{Xe}}{\partial t} = \lambda_I N_I - \lambda_{Xe} N_{Xe}
\end{equation}

To have a transient Xe-135 peak, the above equation must have a positive value at $t = 0$, which requires

\begin{equation}
\left(\frac{N_I}{N_{Xe}}\right)_{eq} > \frac{\lambda_{Xe}}{\lambda_I} ~ \approx 0.719
\end{equation}

Thus, this ratio above defines the threshold for the initial conditions to yield a transient Xe-135 peak. In the GCMR core, the initial equilibrium I-135/Xe-135 ratio is below this threshold, so no peak occurs. A simple parametric study using the neutronics-only component of this multiphysics model yields the following table.

| Normalized GCMR Power | ($N_I/N_{Xe}$)$_{eq}$ | Xe Peak |
|---|---|---|
| 0.3  | 0.699 | No |
| +1.0 (this case)+ | +0.717+ | +No+ |
| 3.0 | 0.768 | Yes |
| 10.0 | 0.945 | Yes |
| 30.0 | 1.436 | Yes |
| 100.0 | 3.113 | Yes |

Thus, the specific GCMR design and operating conditions lead to an initial I-135/Xe-135 ratio that is just below the threshold for a transient Xe-135 peak, so the model predicts a monotonic decline in Xe-135 rather than a post-shutdown peak. This behavior highlights the importance of accurately modeling the fission product inventory and its feedback on neutronics.

Notably, the low power density of the GCMR also leads to a low equilibrium Pm-149/Sm-149 ratio, so that Sm-149 change is negligible during the transient. In a system operating at a higher power density, the Pm-149/Sm-149 ratio would be higher, so the shutdown-induced drop in Pm-149 would lead to a more significant increase in Sm-149 during the transient.

### Spatial Fission Product Distributions

[cr_fp_profiles] presents the spatial distributions of all four isotopes at representative times during the transient.

!media media/gcmr/FCMP/cr_fp_profiles.png
      id=cr_fp_profiles
      style=display: block;margin-left:auto;margin-right:auto;width:90%;
      caption=Spatial distributions of I-135, Xe-135, Pm-149, and Sm-149 at representative times during the control rod insertion transient. I-135, Xe-135, and Pm-149 closely follow the neutron flux distribution; Sm-149 shows a more homogeneous distribution.

The spatial results confirm that I-135, Xe-135, and Pm-149 closely track the local neutron flux. Both I-135 and Pm-149 generation is directly tied to fission, so their concentrations are dependent on the local flux. Xe-135 is produced both from fission and from I-135 decay, and its removal is due to both decay and neutron absorption. At low flux conditions as in this case, as Xe-135 decay is the dominant removal mechanism, the equilibrium Xe-135 profile follows the flux profile. On the other hand, as Sm-149 is produced by Pm-149 decay and is removed only by neutron absorption, the flux term cancels out in its equilibrium concentration. So, the Sm-149 distribution is more homogeneous than the other three isotopes.
