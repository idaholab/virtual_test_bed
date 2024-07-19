# gFHR Steady state simulation results

*Contact: Dr. Mustafa Jaradat, Mustafa.Jaradat\@inl.gov*

*Sponsor: Dr. Steve Bajorek (NRC)*

*Model summarized, documented, and uploaded by Dr. Mustafa Jaradat and Dr. Samuel Walker*

Here we report the steady state results of this coupled multiphysics simulation.

The power multiphysics coupling methodology is shown in [multiphysics_coupling].

!media gFHR/gFHR_multiphysics_coupling.png
  caption=  Multiphysics coupling for the asymptotic core calculation from [!citep](gFHR_report).
  id=multiphysics_coupling
  style=width:100%;margin-left:auto;margin-right:auto

The power distribution peaks radially at the center of the RZ model as expected shown in [power_radial_core] and peaks axially at the bottom of the core shown in [power_axial_core]. Overall the Griffin power profile appears to be consistent with the Kairos Power Advanced Core Simulator (KPACS). Currently, the Griffin solutions overpredict the axial and radial peaking away from the side and top reflector regions. We expect the Griffin solutions to further improve as new cross-section preparation capability becomes available.

!media gFHR/gFHR_Power_Radial_Core.png
  caption=  Griffin radial power shape of the equilibrium core gFHR from [!citep](gFHR_report).
  id=power_radial_core
  style=width:100%;margin-left:auto;margin-right:auto

!media gFHR/gFHR_Power_Axial_Core.png
  caption=  Griffin axial power shape of the equilibrium core gFHR from [!citep](gFHR_report).
  id=power_axial_core
  style=width:100%;margin-left:auto;margin-right:auto

The coefficients of reactivity for the gFHR equilibrium core are shown in [reactivity_comparison]. Note that the current Griffin tabulation does not separate the coolant temperature and density, thus both components of the reactivity feedback are included in the Griffin result. Both the fuel and void coefficient of reactivity are consistent with the KPACS results, but the two coefficients that rely on graphite thermal scattering (moderator and reflector) do not. This could be attributed to differences in the S(α,β) thermal scattering treatment between the data sets, but further work is warranted to resolve this discrepancy.

!table id=reactivity_comparison caption= Coefficients of reactivity for the equilibrium core from [!citep](gFHR_report).
| Reactivity coefficient              | KPACS [!citep](gFHR)            | Griffin (4G)                   |
| :---------------------------------- | :------------------------------ |:------------------------------ |
| Fuel temperature $[$pcm/K$]$        | -4.56 $\pm$ 0.12                | -4.59                          |
| Moderator temperature $[$pcm/K$]$   | -0.4 $\pm$ 0.12                 | -0.84                          |
| Reflector temperature $[$pcm/K$]$   | 0.92 $\pm$ 0.12                 |  0.37                          |
| Void $[$pcm/void %$]$               | -48.19 $\pm$ 9.05               | -59.34                         |
| Coolant Temperature $[$pcm/K$]$     | -1.2 $\pm$ 0.12                 |  ---                           |

Global results from the coupled steady-state calculation are included in [coupled_equilibrium]. Here again the burnup limit is adjusted to produce a 1% $\Delta$$k$/$k$ reactivity bias, which slightly increases the discharge burnup for the coupled model. The coupled model includes nine burnup groups, each with distinctive fuel and moderator temperatures in each core mesh zone. The maximum fuel and moderator temperatures are approximately 5% higher than the core average with the current model where only the fuel includes temperature-dependent thermophysical properties. We expect this to increase in the future when we incorporate the temperature and fluence dependence of the various materials.

!table id=coupled_equilibrium caption= Coupled equilibrium core results from [!citep](gFHR_report).
| Parameter                             | Value                           |
| :------------------------------------ | :------------------------------ |
| $k$$_{eff}$                            | 1.01                            |
| Discharge burnup $[$EFPD$]$           | 468.2                           |
| Discharge burnup $[$MWd/kg$]$         | 153.8                           |
| FLiBe average density $[$$kg$/$m^3$$]$ | 1,982.5                         |
| T$_{avg}^{fuel}$ $[$K$]$                | 953.6                           |
| T$_{max}^{fuel}$ $[$K$]$               | 1004.7                          |
| T$_{avg}^{mod}$ $[$K$]$                 | 928.9                           |
| T$_{max}^{mod}$ $[$K$]$                | 973.3                           |
| T$_{avg}^{ref}$ $[$K$]$                | 858.9                           |

The solid and fluid temperature fields are shown in [temperatures], and fluid density and pressure in [density_pressure]. The peak temperatures are observed at the top of the active core region with a 300 K gradient across the height of the core. Temperature peaks in the solid materials appear near the reflector zones consistent with power peaks. The lower temperature in the reactor vessel and barrel reveal the enhanced heat transfer to and from the inlet coolant flow in the downcomer region. The current model of the fluidic diode exhibits a pressure gradient of 40 kPa with a temperature gradient of 80 K.

!media gFHR/gFHR_Temperature.png
  caption=  Steady-state core thermal solution from [!citep](gFHR_report).
  id=temperatures
  style=width:100%;margin-left:auto;margin-right:auto

!media gFHR/gFHR_density_pressure.png
  caption=  Steady-state core fluid density and pressure from [!citep](gFHR_report).
  id=density_pressure
  style=width:100%;margin-left:auto;margin-right:auto

  The velocity field in [velocity] shows an average velocity of 1 m/s in the downcomer region, except for the regions with sharp turns in which velocity increases due to the sudden changes in the flow direction. The flow area then expands when entering the core, thus reducing the velocity to 0.3 m/s. In the steady-state configuration for this model, no flow is allowed to pass through the fluidic diode, and it all exits at the core outlet.

!media gFHR/gFHR_velocity_fields.png
  caption=  Steady-state fluid velocity $[$m/s$]$ from [!citep](gFHR_report).
  id=velocity
  style=width:60%;margin-left:auto;margin-right:auto

## Execution

To apply for access to Bluecrab, Griffin, Pronghorn, and HPC, please visit [NCRC](https://ncrcaims.inl.gov/).

To run the multiphysics model on:

### INL HPC:

```language=Bash

module load use.moose moose-apps bluecrab

mpiexec -n 48 blue_crab-opt -i gFHR_griffin_cr_ss.i
```

### Local Device:

Note: With NCRC level 2 access to BlueCrab, once you have installed the blue_crab environment with conda:

```language=Bash

conda deactivate
conda activate bluecrab

mpiexec -n 48 blue_crab-opt -i gFHR_griffin_cr_ss.i
```

Note: With source-code access to BlueCrab, once you have compiled the executable you may run:

```language=Bash
mpiexec -n 48 ~/projects/bluecrab/blue_crab-opt -i gFHR_griffin_cr_ss.i

```
