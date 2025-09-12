# Phase 1 Model: Steady State MultiPhysics Coupling

This phase of the benchmark is concerned with the steady state multiphysics solution.
It is comprised of four steps and following is a description of the four steps and 
their inputs.

## Step 1.1

In this step, the influence of the delayed neutron precursor drift on the reactivity 
and delayed neutron source distribution is explored.
This step comprises a neutronic and Navier-Stokes solves.
The neutronics solve is performed as a diffusion problem as defined in step 0.2.
The main input file contains instructions to perform a neutronic solution.
The characteristics of the transport solve are defined ```TransportSystems```
block as follows

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=TransportSystems

The power of the problem from which the power density will be normalized can be
defined in the ```PowerDensity``` block as follows

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=PowerDensity

auxiliary variables for the problem are defined in the ```AuxVariables```  block
as follows

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=AuxVariables

where pronghorn will be used to obtain the temperature distributions and the 
delayed neutron precursor distributions.
Operations to act on the auxiliary variables are defined in the ```AuxKernels```
block

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=AuxKernels

The characteristics of executing the calculations are provided in the 
```Executioner``` block as follows

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=Executioner

To obtain the temperature and delayed neutron precursor distribution, pronghorn 
is used to performed these thermo-fluid calculations.
A ```MultiApps``` block is used to call the pronghorn solver as in the following 
block of code

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=MultiApps

where ''cnrs_s01_ns_flow.i'' is the pronghorn input.
The transfer of variables between Griffin and pronghorn is instructed through the
```Transfers``` block, where the fission source is obtained using Griffin and sent
to pronghorn. 
Then pronghorn is used to calculate the distribution of the precursor

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=Transfers


The pronghorn input to obtain the delayed neutron precursor distribution and fuel
temperature is similar in structure to the input developed in step 0.1.
Some differences in the input file for the Navier-Stokes solve include modifying 
the input to include introducing the ```fission_source``` as an auxiliary variable
that pronghorn will expect to receive from the Griffin Solve.

!listing msr/cnrs/s11/cnrs_s11_griffin_neutronics.i block=AuxVariables

### Step 1.1 Results

The delayed neutron source distribution along AA` and BB` are collected from 
the results of the Griffin run. 
These are as follows

!media media/msr/cnrs/step11-results.png
  style=width:70%


## Step 1.2

This step resembles step 1.1 with the difference being in introducing the temperature
feedback.
The problem is treated as a transport solve coupled with two Navier-Stokes solves
as will be described later.
The transport solve is specified in the ```TransportSystems``` block as follows

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=TransportSystems


The power density in the fuel salt normalization given a reactor power is instructed
in the ```PowerDensity``` as follows

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=PowerDensity


A set of auxiliary variables which will be obtained using other applications
(i.e. pronghorn) are defined as follows.
These variables include the temperature distributions in the fuel, flow field,
and delayed neutron precursor distribution which are obtained using Navier-Stokes
solves as will be demonstrated later.

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=AuxVariables


Compared to the previous step (i.e. Step 1.1), there will be two pronghorn Navier-Stokes
solutions to apply the temperature feedback.
These are called in a ```MultiApps``` fashion as 

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=MultiApps


The first solve (i.e. ```ns_flow```)  will be used to solve for the flow field 
(i.e. velocity field) and the delayed neutron precursor distribution.
The input for the first solve will be the ```fission_source``` obtained by the Griffin 
transport solve.
The second solve (i.e. ```ns_temp```) is used to solve for the 
temperature distribution given the fission source solution obtained by the transport
solve.
The inputs for the second solve are velocity field obtained by the ```ns_flow``` 
solve, and the power density obtained by the Griffin transport solve. 
The instructions of data transfer between the transport solve and the two Navier-Stokes
solves are provided in the ```Transfers``` block as follows

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=Transfers


Te sequence of ```TransportSystems``` solve, ```ns_flow``` solve, and ```ns_temp```
solve is performed till the convergence criteria is met.
These are specified in the main input file (i.e. Griffin solve), within the 
```Executioner``` block as follows

!listing msr/cnrs/s12/cnrs_s12_griffin_neutronics.i block=Executioner

### Step 1.2 Results

The fuel salt temperature distribution along AA` and BB` is collected and plotted as follows

!media media/msr/cnrs/step12-results-a.png
  style=width:70%

The fission rate density is also reported along AA` and BB` in this exercise

!media media/msr/cnrs/step12-results-b.png
  style=width:70%

## Step 1.3:

In this step, the coupled multiphysics modeling is performed with zero fuel salt
lid velocity.
This means the flow is only driven by natural circulation and without forced convection.

The modeling of this problem takes two solvers.
The first is a transport solve specified through the ```TransportSystems``` block

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=TransportSystems


Power density instructions are provided in the ```PowerDensity``` block

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=PowerDensity


The set of auxiliary variables that will be obtained using the Navier-Stokes solves 
are defined as follows

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=AuxVariables


The transport solve characteristics and the tolerances to converge the problem 
are specified as follows

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=Executioner


The Navier-Stokes solve input is specified through the ```MultiApps``` block
as

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=MultiApps


Then the data transfer between the transport solve and the Navier-Stokes solve are
managed through the ```Transfers``` block

!listing msr/cnrs/s13/cnrs_s13_griffin_neutronics.i block=Transfers

### Step 1.3 Results

The horizontal velocity component distribution along AA` is reported in [step13-results-a].

!media media/msr/cnrs/step13-results-a.png
  style=width:60%
  id=step13-results-a

The vertical velocity component distribution along AA` and BB` is also reported
in [step13-results-b].

!media media/msr/cnrs/step13-results-b.png
  style=width:80%
  id=step13-results-b

The fuel salt temperature distribution along AA` and BB` in this exercise is reported
in [step13-results-c].

!media media/msr/cnrs/step13-results-c.png
  style=width:80%
  id=step13-results-c

Finally, the delayed neutron source distribution along AA` and BB` is reported
in [step13-results-d].

!media media/msr/cnrs/step13-results-d.png
  style=width:80%
  id=step13-results-d

## Step 1.4:

This phase performs a similar task to that of Step 1.3 for a combination of 
reactor power and lid velocities.
The set of reactor powers and lid velocities are presented in the following table

|  Lid Velocity   | Reactor Power |
| --------------- | ------------- |
|        0.0      |       1.0E9   |
|        0.1      |       0.2E9   |
|        0.1      |       0.4E9   |
|        0.1      |       0.6E9   |
|        0.1      |       0.8E9   |
|        0.1      |       1.0E9   |
|        0.2      |       0.2E9   |
|        0.2      |       0.4E9   |
|        0.2      |       0.6E9   |
|        0.2      |       0.8E9   |
|        0.2      |       1.0E9   |
|        0.3      |       0.2E9   |
|        0.3      |       0.4E9   |
|        0.3      |       0.6E9   |
|        0.3      |       0.8E9   |
|        0.3      |       1.0E9   |
|        0.4      |       0.2E9   |
|        0.4      |       0.4E9   |
|        0.4      |       0.6E9   |
|        0.4      |       0.8E9   |
|        0.4      |       1.0E9   |
|        0.5      |       0.2E9   |
|        0.5      |       0.4E9   |
|        0.5      |       0.6E9   |
|        0.5      |       0.8E9   |
|        0.5      |       1.0E9   |


A shell script is used to run all these cases.


### Step 1.4 Results

In this exercise, the reported results are the delayed neutron precursor density
distribution depending on the lid velocity

!media media/msr/cnrs/step14-results.png
  style=width:70%
