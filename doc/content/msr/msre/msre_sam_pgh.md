# Molten Salt Reactor Experiment (MSRE) Sam-Pronghorn Domain Overlapping Coupling 

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

This model features the Overlapping Domain Coupling method, through the `Action` in BlueCRAB `[OverlappingDomainCoupling]`, to couple the thermal hydraulics of the system and core over a wide range of reactor operating conditions. SAM offers a 1D plant-wide view, Pronghorn offers a detailed multi-dimensional analysis of advanced reactor cores and integral loops. The action overlaps the `Downcomer`, `Core`, and `Plena` to automatically make Pronghorn incorporate volumetric sources into the overlapped SAM components. 

SAM and Pronghorn are available independently or together via BlueCRAB. Pronghorn simulates the multi-dimensional core thermal hydraulics and SAM simulates the 1D system representation. [coupled_mesh_labeled] shows the coupled models. Note that the SAM model collapse the 2D mesh into 1D simplifications. 



!media msr/msre/MSRE_coupled_mesh_labeled.png
       style=width:80%;margin-left:auto;margin-right:auto
       id=coupled_mesh_labeled
       caption=Coupled SAM-Pronghorn labeled mesh.


#### Overlapping Domain Coupling Description

The overlapping domain multi-dimensional coupling action, described in [!cite](Mau23), couples the SAM System model to the Pronghorn core model. The domain overlapping coupling abstracts the Pronghorn core in an overlapping SAM component. It also automatically sets up boundary conditions for the multi-dimensional core simulation.

 To perform a steady state relaxation transient, to obtain initial conditions, the `Action` transfers information between SAM and Pronghorn until they are equivalent: their differences converge within a tolerance. The behavior of the multi-dimensional core and the approximate components converge within a tolerance in terms of pressure drop temperature increase.

 The transient method uses the same information transfer between SAM and Pronghorn, but they are iterated every time-step through a fixed-point iteration method until they are equivalent.  

Through the custom action `[OverlappingDomainCouplings]`, provided the user has access to BlueCRAB in addition to Pronghorn and SAM, the `Action` will set up all additional objects and equations required. This action adds versatility by allowing multiple inlets and outlets, complex geometries, dealing with inertial forces implicitly, among other features. 

## Computational Model Parameters


#### Overlapping Domain Coupling Action

This action block defines the overlapping boundaries, the information to transfer, and gives the command to execute on the SAM MultiApp. The boundaries and the volumetric information is collected via `Postprocessors`, some of which are automatically added by the action.  

The boundaries are specified as the $downcomer$_$inlet$ and the $pump$_$outlet$. The boundaries are oriented as $in$ and $out$ respectively. Their cross-sectional areas are defined along with corresponding connected components $pipe3$_$s2$ and $pipe1$_$s1$. 

!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i start=[OverlappingDomainCoupling] end=boundary_massflowrate_names language=cpp

Subsequently, the names of the `Postprocessors` evaluating the properties at the boundaries are defined. Some initial conditions are provided for the first step.


!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i start=boundary_massflowrate_names end=overlapped_branch_name language=cpp


!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i start=enthalpy_functor end=initial_boundary_temperatures include-end=true language=cpp

The block relates the names of the passive scalars to the transfer action that sends and receives them in SAM. Here, the decay constant and the initial conditions are defined.


!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i start=system_level_passive_scalar_names end=hydrodynamic_iteration_type language=cpp

Finally, the action calls the SAM file "MSRE_coupled.i" to perform the information transfer through the `Postprocessors`. 

!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i start=hydrodynamic_iteration_type end=[] language=cpp


#### Postprocessing

When reading this file, the user must note that the `Postprocessors` are divided into two `Postprocessors` blocks. The first block is dedicated to receiving the precursors passive scalars from SAM (this will not be utilized until the Domain-overlapping coupling), and the second `Postprocessors` block is dedicated to sending information like pressure, enthalpy, temperature, and mass-flow-rate to the SAM model. 

Shown below is the second `Postprocessors` block: 

!listing msr/msre/SAM_Pgh/coupled/MSRE_coupled.i block=Postprocessors  language=cpp 


## Steady State Results


!media msr/msre/MSRE_coupled_T.png
       style=width:51%;margin-left:auto;margin-right:auto
       id=coupled_temperature
       caption=Coupled SAM-Pronghorn temperature model (K), [!citep](Mau23).

The Overlapping domain coupling method achieves a MSRE model that provides consistent pressure, mass flow-rate, enthalpy, and passive scalars between the two apps. In [coupled_temperature], we find that the heat source incorporated by Pronghorn into the the overlapped SAM components matches SAM's response. The simulation predicts a temperature increase of about 60 K (kelvin) in the core. The temperature variation predicted across the downcomer is small. The mass-flow averages, velocities, and accelerations predicted by Pronghorn at the exit of the core match the SAM predictions. 

## Transient Results

For the transient results, we tested a reactivity insertion of 19 percent-mili (pcm) at 5 MegaWatts, from ORNL (Oak Ridge National Laboratory) reports [!citep](steffy1969). Note: because there are no control rods in the Griffin model, the increase was achieved by temporarily artificially increasing the fission cross-section of the fuel. The Pronghorn model successfully captured the thermal oscillations induced by the density-Doppler power-temperature relationship.  

The method converges reliably and efficiently, with a maximum of 15 iterations but usually less than ten iterations in the tested case. This coupling method converges faster than comparable methods, achieving less error than the domain-segregated method or a standalone SAM model. This may be due to the improved temperature resolution in the core. Note that as the limit of the time-step goes to zero, the domain-overlapping and the domain-segregated should yield same results.  

!media msr/msre/MSRE_reactivity_insertion_5MW.png
       style=width:45%;margin-left:auto;margin-right:auto
       id=Convergence Velocity
       caption=Error Comparison, [!citep](Mau23).



## Execution

To apply for access to SAM, Pronghorn, and HPC (INL's High Performance Computing supercomputer), please visit [NCRC](https://ncrcaims.inl.gov/). 
To run the coupled model:

#### INL HPC:


```language=Bash

module load use.moose moose-apps bluecrab

mpiexec -n 6 bluecrab-opt -i MSRE_coupled.i
```

#### Local Device:

Note: Need at least NCRC level 2 access to BlueCRAB

```language=Bash
mamba deactivate

mamba activate bluecrab


mpiexec -n 6 bluecrab-opt -i MSRE_coupled.i
```

Note: With source-code access to BlueCRAB

```language=Bash

mpiexec -n 6 ~/projects/bluecrab/bluecrab-opt -i MSRE_coupled.i  
```

