# Molten Salt Reactor Experiment (MSRE) Multiphysics Model Results

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized, documented, and uploaded by Andres Fierro*

This section will cover both the Steady State and Transient Results from the MSRE multiphysics model.

## Steady State Results

The multi-dimensional velocity field becomes approximately 1D due to the anisotropic friction coefficient blocking flow in the horizontal direction as seen in [MSRE_pgh_fields] (center). [MSRE_pgh_fields] (right) and [MSRE_pgh_fields] (left) show the power source distribution calculated by Griffin and the resultant temperature field respectively. The simulation predicts a temperature increase of about 60 K (kelvin) in the core. The temperature variation predicted across the downcomer is small.

!media msr/msre/MSRE_pgh_fields.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_fields
       caption=Fuel Salt Temperature - left (K), Fuel salt velocity - center (m/s), and Power density - right (W/m$^3$).

Additionally, the steady-state delayed neutron precursor group distributions calculated via Pronghorn are shown in [MSRE_pgh_dnps]. Here the long lived delayed neutron precursor group 1 is well mixed throughout the reactor core, whereas the short lived neutron precursor group 6 is centralized and decays in the reactor core.

!media msr/msre/MSRE_pgh_dnps.png
       style=width:110%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_dnps
       caption=Long lived DNP Group 1 (left), Medium lived DNP group 3(center), and short lived DNP group 6 (right).


## Execution

To apply for access to Griffin and HPC, please visit [NCRC](https://ncrcaims.inl.gov/).
To run the multiphysics model on:

#### INL HPC:


```language=Bash

module load use.moose moose-apps bluecrab

mpiexec -n 6 blue_crab-opt -i neu.i
```

#### Local Device:

Note: With NCRC level 2 access to BlueCrab, once you have installed the mamba environment:

```language=Bash

mamba deactivate

mamba activate bluecrab

mpiexec -n 6 blue_crab-opt -i neu.i
```

Note: With source-code access to BlueCrab, once you have compiled the executable you may run:

```language=Bash
mpiexec -n 6 ~/projects/bluecrab/blue_crab-opt -i neu.i

```


## Transient Results

For the transient results, we tested a reactivity insertion of 19 percent-mili (pcm) at 5 MegaWatts, from ORNL (Oak Ridge National Laboratory) reports [!citep](steffy1970). Note: because there are no control rods in the Griffin model, the increase was achieved by temporarily artificially increasing the fission cross-section of the fuel. The multiphsyics model successfully captured the thermal oscillations induced by the density-Doppler power-temperature relationship.

The method converges reliably and efficiently, with a maximum of 15 iterations but usually less than ten iterations in the tested case. This coupling method converges faster than comparable methods, achieving less error than the domain-segregated method or a standalone SAM model. This may be due to the improved temperature resolution in the core. Note that as the limit of the time-step goes to zero, the domain-overlapping and the domain-segregated should yield same results.

!media msr/msre/MSRE_reactivity_insertion_5MW.png
       style=width:80%;margin-left:auto;margin-right:auto
       id=Convergence Velocity
       caption=Error Comparison, [!citep](Mau23).
