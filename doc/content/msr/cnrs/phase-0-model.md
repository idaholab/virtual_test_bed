# Phase 0 Model: Steady State Single Physics

*Contact: Mustafa Jaradat, Mustafa.Jaradat\@inl.gov*

*Model summarized and documented by Dr. Khaldoon Al-Dawood*

This exercise is comprized of three stady state single physics steps.
The inputs provided in this step will be gradually improved as the complexity of 
the steps will improve.
In the following is a description of each stepa of Phase 0 in addition to explanation
of the input files.

## Step 0.1:

The purpose of this exercise is to calculate the steady state velocity field given a
fixed lid velocity of 5 m/s.
This problem is solved using pronghorn software which uses the Navier-Stokes module 
in MOOSE.
The conservation of mass principle is expressed as

$\nabla.\vec{u} = 0$

where $\vec{u}$ is the velocity vector.

The conservation of momentum is expressed as

$\frac{\partial \vec{u}}{\partial t} + \vec{u}.\nabla \vec{u} = -\frac{1}{\rho_\circ} \nabla p + \mu\nabla^2\vec{u} + \vec{g}\left(1-\alpha\left(T-T_\circ\right)\right)$

where $p$ is pressure, $\mu$ is the viscosity, $\vec{g}$ is the gravity vector, $T$ is the temperature, and $\alpha$ is the thermal expansion coefficient.

Finally, the conservation of energy is expressed as

$\rho_\circ c_p \frac{\partial T}{\partial t} + \rho_\circ \vec{u}.\nabla T = \kappa_f \nabla^2T + q^{\prime \prime \prime}$

The model starts by defining some fluid properties as follows

```
alpha = 2.0e-4
rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1
```

The mesh used in solving the problem is described in the pronghorn input file 
as follows

!listing msr/cnrs/s01/cnrs_s01_ns_flow.i block=Mesh


The modeling of the momentum and energy equation and the setup are presented to the NavierStokesFV block as follows
The instructions of the modeling of the flow characteristics and conservation equations
is done with the ```Modules``` block and ```NavierStokesFV``` sub-block, specifically.
Following is a description of the ```Modules``` block used in the modeling in this 
step of Phase 0.

!listing msr/cnrs/s01/cnrs_s01_ns_flow.i block=Modules

This block defines lots of characteristics of the fluid modeling including the 
utilization of energy equation, boundary conditions, numerical scheme, and so on.

Fluid properties to support the modeling process can be defined in the ```Material``` block.
As in the following, the ```Materials``` block uses defined material properties
provided in the beginning of the input file as described above.

!listing msr/cnrs/s01/cnrs_s01_ns_flow.i block=Materials

The problem is solved as a transient that is allowed to converge by selecting a
long time for the simulation in addition to setting up a tolerence for the detection 
of achieving the steady state.
These characteristics of the simulation in addition to others such as the solver 
type are identified in the ```Executioner``` block of the input file as follows.

!listing msr/cnrs/s01/cnrs_s01_ns_flow.i block=Executioner


### Step 0.1 Results

The results for the first step of phase 0 are composed of the velocity field in 
addition to a mesh refinemnet study to demonstrate the influence of the refinement
on the vertical components of the velocity.
The results are collected across the horizontal AA` line and the vertical BB` line 
from the problem description.
The horizontal velocity component distribution along AA` and BB` are

!media media/msr/cnrs/step01-results-a.png
  style=width:70%

The vertical velocity component distribution along AA` and BB` are

!media media/msr/cnrs/step01-results-b.png
  style=width:70%

The vertical velocity component distribution along BB` as the mesh is refined is
as follows

!media media/msr/cnrs/step01-results-c.png
  style=width:70%

## Step 0.2:

This exercise models a steady state neutronic solution using griffin.
The problem gemetry remains the same as step 0.1.
The mesh is defined in a similar fashion to the earlier presentation and it is
presented in this subsection for completeness.

!listing msr/cnrs/s02/cnrs_s02_griffin_neutronics.i block=Mesh


The input uses the fuel temperature to adjust the fuel density
according to the expression

$\text{Fuel Density Fraction} = 1.0 - 0.0002\times (T_\text{fuel}-900)$

Although this adjustment of density is not useful in this step, it will be useful 
in the next step of the benchmark where the obtained temperature distribution is used 
to adjust the fuel salt density.

An eigenvalue solution of the multigroup neutron diffusion equation is performed
with six energy groups.
These characteristics and others including problem boundary conditions are defined
in the ```TransportSystems``` block as follows

!listing msr/cnrs/s02/cnrs_s02_griffin_neutronics.i block=TransportSystems

Finally, the ```Executioner``` block is defined as follows

!listing msr/cnrs/s02/cnrs_s02_griffin_neutronics.i block=Executioner


### Step 02 Results:

The results for this step include observing the fission rate density distribution
and examining the influence of mesh refinment. 
Due to the length of the results, this documentation will only show the fission 
rate distribution along AA` which is as follows

!media media/msr/cnrs/step02-results.png
  style=width:50%

For results on the mesh refinement, the reader is referred to the publication 
[!citep](jaradat2024verification).

## Step 0.3

In this exercise, the temperature field is obtained based on the velocity field 
and the power density profile.
Thus, to solve this exercise, the solutions of steps 0.1 and 0.2 need to be obtained
and provided to obtain the solution of this exercise.
Following is a description of the setup for this exercise input.


This requires a Navier-Stokes solve to obtain the velocity field and a neutronic
solve to obtain the power density distribution.
The main input in this step is referred defines an input that performs the linking between 
the neutronic solve and the Navier-Stokes solve.
The main file defines a set ov variables as follows

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=Variables

These variables will be read from the solutions of step 0.1 and step 0.2.
Auxiliary variables that are imported from the solutions of 0.1 and 0.2 are also
defined as

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=AuxVariables

The boundary conditions are also defined as

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=FVBCs

To obtain the solution of the previous two steps to be implemented in the solution
of this step, a ```MultiApps``` block is used to identify the inputs as follows

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=MultiApps

where ```cnrs_s01_ns_flow.i``` is the input of step 0.1, and ```cnrs_s02_griffin_neutronics.i```
is the input for step 0.2.
The requested variables transfer between the three inputs for steps 0.1, 0.2, and
0.3 is defined in the ```Transfers``` block as follows

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=Transfers

notice that the Navier-Stokes solve is expected to provide the velocity field.
The neutronic solve is expected to provide the power density distribution.
Note that the fuel temperature is used to adjust the density but it is not used to
update the cross section.

Finally, characteristics of executing the problem are defined in the ```Executioner```
block as follows

!listing msr/cnrs/s03/cnrs_s03_ns_flow.i block=Executioner

### Step 03 Results

The fuel salt temperature distribution along AA` and BB` are as follows

!media media/msr/cnrs/step03-results.png
  style=width:70%
