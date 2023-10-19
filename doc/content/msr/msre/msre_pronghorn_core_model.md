# Molten Salt Reactor Experiment (MSRE) Pronghorn Model of the Core

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

The Pronghorn multidimensional core model is described to contextualize the overlapping of the SAM primary loop model and the Pronghorn core. 

<!--Not just the core: also the downcomer and plena --> 

This model of the MSRE utilizes Pronghorn to create a 2D, RZ (cylindrical coordinates), steady-state, medium-fidelity, coarse mesh thermal-hydraulics analysis of the core [!citep](mau23). The parts of the core are represented in [MSRE_pgh_blocks]. 

The core is represented with a vertical porosity of 0.22283. No rugosity is assumed when computing the friction factor. This model's normalized power source can be calculated by Griffin [!citep](Javi23), but in this instance we used a cosine-shaped power source, shown in [MSRE_pgh_power]. 

The salt flows down the `Downcomer`, through the `Lower Plenum` and up into the `Core`, is collected at the `Upper Plenum` and goes through the system through the `Outlet Pipe`. In the core, an anisotropic friction source coefficient keeps the flow approximately 1-Dimensional. 

!media msr/msre/MSRE_pgh_blocks.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_blocks
       caption=Subdomain in the axisymmetric Pronghorn model.

## Computational Model Description

The Pronghorn input file adopts a block structured syntax. This section covers the important blocks in the input file. 

#### Problem Parameters


The beginning of the input file lists the problem parameters the user can edit including the model's physical properties and initial conditions. 

We first define a few geometrical parameters for the core dimensions, which can be referred to lower in the input file. 

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=# Geometry end=core_bottom

The physical properties are defined in the next block. The core porosity is defined at a ration of 0.222831, calculated as the quotient of flow area by total core area. The porosity for the rest of the components is set to 1, full fluid region, but is editable by the user. 


!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=# Properties end=mfr

The hydraulic diameters of the bypass fuel channel and of the downcomer were respectively defined at 19.1 mm (milimeters) and 512.7 mm. The fluid blocks are defined to indicate the fluid regions. 


!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=# Hydraulic diameter end=lambda1_m

The following section focuses on the operational parameters. The mass flow rate was defined at 191.19 kilograms per second, with a core outlet pressure approximately atmospheric at 101.325 kiloPascals. The salt core inlet temperature is defined at to be 908.15 Kelvin (K) with an ambient room temperature defined to be 300K. Finally, this section defines the centrifugal pump force to be 98.2 kiloNewton (kN). Alpha is the heat exchange coefficient utilized in the convection fluid heat exchanger.

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=mfr end=# Hydraulic diameter

The end of the first section defines the delayed neutron group properties. 

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=lambda1_m end=[GlobalParams]

#### Mesh

This block defines the geometry of the core, as shown in [MSRE_pgh_mesh]. The mesh is defined in 2D cylindrical coordinates, 'RZ'. The first section associates a number ID to the name of a block so the subdomain id in the cartesian mesh can be defined in terms of the IDs. 

The large white region in the mesh is called the core. The lower plenum is in red, the upper plenum is in green, the downcomer is the dark blue, and the riser (outlet pipe) is shown hot pink. The core barrel, the metallic shell that wraps the core is in bright yellow (between the core and downcomer). 


!media msr/msre/MSRE_pgh_mesh.png
       style=width:25%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_mesh
       caption=Mesh of the axisymmetric Pronghorn model.

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=[Mesh] end=[] language=cpp 

### Constant Fields  

Through the ```Auxiliary Variables```, developers can define the variable type for porosity, power density, and the fission sources, along with their domain. The variable types, functions, and scaling factors are explained in detail [here](https://mooseframework.inl.gov/syntax/AuxVariables/index.html). 

The porosity variable is a constant field defined in the fluid blocks across the domain. 
The fluid blocks are defined at the top of the header and are substituted using the `$` sign. Recall that the `$` sign refers to variable substitutions. 

The power density is a constant field defined in the core and plena blocks. The initial conditions for both the power density and the fission source are a cosine guess, defined below. The neutron precursors, group C1 through C6, are also defined in the ```Auxiliary Variable``` block. 




!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i block=AuxVariables language=cpp 

This model's distribution of fission for the core and the sources are editable so developers can try their own fission distributions. The power function is defined radially and axially with the cosine shape. The cosine shape, or "guess," is defined as an object under the function system. 

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=[cosine_guess] end=[] include-end=true language=cpp 


!media msr/msre/MSRE_pgh_power.png 
       style=width:30%  ;margin-left:auto;margin-right:auto
       id=MSRE_pgh_power 
       caption=Normalized power source at steady state. 


### Fluid Properties

This block contains parameters applied to all the core components. The `fluid_properties_obj` refers to the primary salt F-Li-Be (Flibe), already defined within MOOSE. 

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i block=FluidProperties language=cpp


Fluid properties are further defined within the ```Navier Stokes Finite Volume``` action and the Materials block.

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=# fluid properties end=# Energy source-sink language=cpp

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i start=## Fluid end=[] language=cpp




### Porous Media Navier Stokes Equations

The ```Navier Stokes Finite Volume``` action was added to define fluid properties, compute the "weakly-compressible" flow, and to set up boundary conditions and the passive scalar advection. 

!listing msr/msre/SAM_Pgh/steady_state_pgh/MSRE_pgh_steadyState.i block=Modules  language=cpp 


## Results

The multi-dimensional velocity field becomes approximately 1D due to the anisotropic friction coefficient blocking flow in the horizontal direction. [MSRE_pgh_power] and [MSRE_pgh_velocity] show the power source distribution calculated by Griffin and the resultant velocity field respectively. [MSRE_pgh_pressure] and [MSRE_pgh_core_pressure] show the predicted pressure variation across the entire model and the core.

 The pressure of the salts is highest after the cooling in the heat exchanger as they flow down the downcomer. The pressure in the lower plenum is about equal as the salts commence to flow up the core, but the pressure drops in slightly different gradients depending on the proximity to the outlet pipe.  The gravity term has arbitrarily been turned off. 



!row!
!media msr/msre/MSRE_pgh_velocity.png
       style=width:31%;float:left;padding-top:2.5%;padding-right:5%
       id=MSRE_pgh_velocity
       caption=Vector plot of the velocity field colored with velocity magnitude (m/s).


!media msr/msre/MSRE_pgh_Pressure_var.png
       style=width:27%;float:left;padding-top:2.5%;padding-right:5%
       id=MSRE_pgh_pressure
       caption=Pressure variation across Pronghorn model (Pa).

!media msr/msre/MSRE_pgh_corePressure_var.png
       style=width:30%;float:left;padding-top:2.5%
       id=MSRE_pgh_core_pressure
       caption=Pressure variation across Pronghorn core (Pa).

!row-end!

## Execution

To apply for access to Pronghorn and HPC, please visit [NCRC](https://ncrcaims.inl.gov/). 
To run the Pronghorn model on:

#### INL HPC:


```language=Bash

module load use.moose moose-apps pronghorn

mpiexec -n 6 pronghorn-opt -i MSRE_pgh_steadyState.i
```

#### Local Device:

Note: need at least NCRC level 2 access to Pronghorn

```language=Bash

mamba deactivate

mamba activate pronghorn

mpiexec -n 6 pronghorn-opt -i MSRE_pgh_steadyState.i
```

Note: With source-code access to Pronghorn

```language=Bash
mpiexec -n 6 ~/projects/pronghorn/pronghorn-opt -i MSRE_pgh_steadyState.i 

```
