# Lotus Molten Chloride Reactor (LMCR) Results

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized, documented, and uploaded by Rodrigo de Oliveira and Samuel Walker*

This section will cover the steady state results from the LMCR multiphysics model.

## Steady State Results

[LMCR_pgh_fluxes] displays the normalized neutron flux for three selected groups: group 1 (second fastest), group 4 (epithermal), and group 8 (thermal-most group). Group 0 is not presented since its small cross section in this high-energy group leads to significant neutron leakage, providing limited insights into flux behavior. Generally, the fluxes behave as expected, with fast fluxes leaking from the center of the reactor and the thermal flux diffusing into the reflector. Notably, the thermal group experiences a non-negligible neutron flux diffusing into the reflector, generating a flux peak shifted from the center of the reactor due to the larger current of reflected neutrons. However, on average, the neutron fluxes are higher at the center of the reactor. Consequently, while analyzing [LMCR_pgh_power_density] for power density, it is anticipated that most of the power density is produced towards the center of the reactor.

!media msr/lotus/mcre_fluxes.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=LMCR_pgh_fluxes
       caption=Normalized steady-state fluxes in LMCR. Specifically, group 1 (second fastest), group 4(epithermal), and group 8 (thermal-most group) are presented from left to right [!citep](M3mcr2023).

!media msr/lotus/mcre_power_density.png
       style=width:60%;margin-left:auto;margin-right:auto
       id=LMCR_pgh_power_density
       caption= LMCR Power density (W/m$^3$) [!citep](M3mcr2023).

Additionally, the steady-state delayed neutron precursor group distributions calculated via Pronghorn are shown in [LMCR_pgh_dnps]. Here the long lived delayed neutron precursor group 1 is well mixed throughout the reactor core and primary loop, whereas the short lived neutron precursor group 6 is centralized and decays in the reactor core.

!media msr/lotus/mcre_dnps.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=LMCR_pgh_dnps
       caption=Normalized distribution of the six neutron precursor families during steady-state operation [!citep](M3mcr2023).

Family 1, characterized by a significantly longer decay rate compared to the smaller timescales involved in the advection process, experiences an approximate homogenization throughout the fuel salt loop. However, as the decay rate of the precursor family increases, a distinct spatial distribution begins to emerge for the neutron precursors. Regardless of the family, the precursors exist in the reactor core due to their production via fission and then decay in the return pipe before re-entering the reactor core. The distribution of neutron precursors in the core exhibits noticeable advection skewness, highlighting the impact of advection on the precursor distribution.

The steady-state velocity field during reactor operation is depicted in [LMCR_pgh_velocities]. The figure illustrates how the liquid nuclear fuel exits the reactor core through the upper elbow connected to the pump. As the fuel passes through the pump region, the superficial velocity homogenizes due to the porous friction forces. The fuel salt then circulates through the return pipe.

!media msr/lotus/mcre_velocities.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=LMCR_pgh_velocities
       caption=Velocity fields during steady-state reactor operation for LMCR. (left) Velocity magnitutde, (center) velocity in vertical direction, (right) velocity in horizontal direction [!citep](M3mcr2023).

At the elbows, the flow follows the expected flow profile, characterized by centripetal flow acceleration. Specifically, the flow accelerates towards the closed edge of the elbow and then deflects towards the open edge downstream. Achieving this correct behavior was possible through the calibration of the turbulent mixing length in the turbulence model. It should be noted that using a suggested mixing length model of 7% of the hydraulic diameter of the pipe would result in over-diffusive and incorrect results.

Upon passing through the last elbow in the return pipe, the fuel salt flow enters the reactor. This elbow imposes a significant acceleration towards the center of the geometry, which, without the mixing plate, would lead to a non-uniform flow profile in the reactor core. To address this, the porous medium friction model in the mixing plate was carefully calibrated to yield a uniformized flux in the reactor cavity, minimizing entry effects. As depicted in [LMCR_pgh_velocities], this calibration results in a velocity that is larger at the center of the reactor while remaining approximately uniform axially and azimuthally.

The temperature field in the fuel salt and the reactor reflector is illustrated in [LMCR_pgh_temps]. As anticipated, the low power and substantial thermal capacity of the molten salt result in an approximately uniform temperature field across the reactor core. Only a minimal temperature difference of approximately ∼ 0.8K is observed between the outlet and inlet of the reactor cavity.

!media msr/lotus/mcre_temps.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=LMCR_pgh_temps
       caption=Steady-state temperature field for the fuel (left) and reflector (right) during LMCR operation [!citep](M3mcr2023).

In the reflector, the temperature varies primarily radially as heat is conducted from the reactor wall into the lateral walls. Notably, no significant axial temperature gradients are obtained for the neutron reflector, which aligns with the expectation due to the presumed perfectly insulated top and bottom faces.

## Execution

To apply for access to Griffin and HPC, please visit [NCRC](https://ncrcaims.inl.gov/).

To run the multiphysics model on:

#### INL HPC:


```language=Bash

qsub -I -l select=4:ncpus=48 -l walltime=02:00:00 -P moose

module load use.moose moose-apps bluecrab

mpiexec -n 192 blue_crab-opt -i run_neutronics_9_group.i
```
