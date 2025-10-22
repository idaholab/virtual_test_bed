# Reactor Physics Models

## Cross Section Generation

The cross-section preparation capability for PBRs in Griffin is not currently available. Thus, the benchmark relied on the lattice code DRAGON [!citep](reitsma2013pbmr) to prepare microscopic cross sections. 

The DRAGON data libraries used in this work are based on the ENDF/B-VIII.r0 evaluation. For the neutron self-shielding method, the SHEM 281 group library was used with the subgroup projection method [!citep](hebert2009development). The double heterogeneity treatment is based on the H\'ebert method. A current-coupled collision probability (CCCP) flux solution is used for spatial homogenization and energy condensation of microscopic cross sections. The intra-core neutron leakage affects the local spectrum significantly, and it will have an impact on the cross-section homogenization. Nevertheless, this approach with the generated cross sections serves as an initial set to perform preliminary calculations until more sophisticated methods are available in Griffin.
The nominal depletion values are as follows:

| Parameter | Value |
| :-------- | :----:|
| Fuel temperature K | 898.0 |
| Moderator temperature K | 803.0 |
| Neutron flux n/cm2/sec | 1.521 $\times 10^{14}$ |

Two models were built in DRAGON.
These are a pebble model and a pebble ensemble as show in [dragon-model].
The cross sections were prepared in 9 energy group structure and the transmutaion and decay chain has 295 isotopes.

!media htrpm_coremultiphysics/dragon-models.png
  style=width:50%
  id=dragon-model
  caption=Dragon models.


## Neutronics Model

A neutronics model of the HTR-PM core was developed with Griffin using an axisymmetric (R-Z) geometry with homogenized core regions. Griffin solves steady-state neutron diffusion equation and pebble   streamline calculations which solves 1D streamline advection transmutation equation for pebble depletion.
The model is shown in [htr-pm-griffin-model].

!media /htrpm_coremultiphysics/htr-pm-griffin-model.png
  style=width:50%
  id=htr-pm-griffin-model
  caption=Griffin model.

The Griffin model uses six equally spaced streamlines to represent pebble depletion that are centered within the active core elements. The streamlines are located at radii of $r=12.5, 37.5, 62.5, 87.5, 112.5, 137.5$ cm. Pebble velocity is assumed to be uniform so that the fraction of the volumetric flow rate of pebbles through each channel is proportional to the channel area. The six channels are straight down and end at the bottom of the pebble bed. 

The heavy metal loading of $7$ g per pebble, the average discharge burnup of $90$ MWd/kg, the average power density, and the packing fraction of $0.61$, the total irradiation time in the core is estimated to be $1,055$ days, which corresponds to $70$ days per pass in the 15-pass core design The pebble speed ($15.6$ cm/d) and pebble reloading rates ($5,949$ pebbles per day). The discharge burnup of $90$~MWd/kg or $4.82E+14$ $J/m^3$. A total of 10 burnup groups forms the base discretization of the burnup variable. 

The local decay heat power in Griffin is computed from the decay released by fission products as a function of time along with provided by the neutron transmutation and decay chain.

The steady state neutronics calculation is run through bluecrab using the following command

```
 mpirun -np 48 blue_crab-opt -i  htr_pm_neutronics_ss.i
```

The steady state input is composed of blocks. 
Initially, the cross sections are imported in the ```GlobalParams``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=GlobalParams

The characteristics of the transport solution are identified as

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=TransportSystems

The mesh is identified as and contains assignment of materials IDs through ```assign_material_id```as follows:

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Mesh

Coordinate type is defined as 

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Problem

Depletion for the pebbles is defined using the ```PebbleDepletion``` block as

!listing htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=PebbleDepletion

Materials are defined using the ```Materials``` block as

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Materials

Execution parameters for the problem are defined as

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Preconditioning

Finally, the execution characteristics of the problem are defined with the ```Executioner``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Executioner

Output selections are made 

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Outputs




## Equilibrium Core Calculations

The equilibrium core is attained via the streamline depletion method available in Griffin [!citep](schunert2020nrc).
In this depletion approach, a 2D and 3D core flux solution is mapped to 1D axial streamlines.
A set of 1D steady-state advection-transmutation equations for all isotopes are solved in each
streamline. Griffin assumes that the pebble loading and unloading rates are identical.
Full details on the equilibrium model can be found in [!citep](jaradat2023gas).

The depletion setup is requested through the Griffin input.
Specifically, in the input, the definition of the ```PebbleDepeletion``` as in the following is used to define 
the fuel as depletable material as

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=PebbleDepletion

## Decay Heat Calculation

A decay heat model was added for the equilibrium core model to properly perform the loss of
forced cooling transients. The decay heat source is mainly important for transient analyses when
the fission power is reduced to zero due to negative reactivity insertion. In steady state, the decay
heat is assumed to be included in the energy released per fission, and, thus, assumed to have the
same distribution as the prompt fission power. In this decay heat model, the fission products are
grouped into a few decay heat precursor groups (KD), and each group has its unique decay heat
fraction ($f_k$) and constant ($\lambda_k$).
Details on the decay model can be found in [!citep](jaradat2023gas).


To calculate the decay heat using Griffin, ```AuxVaraibles``` for the decay heat is defined and then using an ```AuxKernal``` the methods of how it is calculated is defined.
Here is definition of the HTR-PM neutronic model ```AuxVariables```

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=AuxVariables

The ```AuxKernals``` for the HTR-PM neutronic model are defined as:

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=AuxKernels

## Multiphysics

Linking the neutronic solution calculation with thermal fluid solution (which is presented in the next section) is done using the ```MultiApps``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=MultiApps

The passing of data is done through defining the following block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_ss.i block=Transfers


The setup of the applications is described in [apps_setup_3].
Given the cross sections generated using DRAGON, Griffin is the main app that runs.
The neutronics calculation (a depletion step) is run, this is followed by running the pebble/Triso conduction model which obtains pebble temperatures.
Then Pronghorn is run to perform thermal conduction uses the solution from the conduction model to calculate the coolant temperature.

!media /htrpm_coremultiphysics/apps_setup_3.png
  style=width:50%
  id=apps_setup_3
  caption=Application setup for equilibrium core calculation.

