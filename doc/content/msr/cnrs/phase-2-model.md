# Phase 2: Time-dependent Multiphysics Coupling

This phase is comprised of a sole task which a fully coupled time dependent simulation
of the cavity problem.
This problem is modeled using two inputs, too.
These inputs are the transport solve input, and the Navier-Stokes solve.
The transport solve input has a structure similar to that of the transport input
in Step 1.3.
The difference in in assigning a ```transient``` equation type instead of 
```eigenvalue```, and changing ```type``` input in ```Executioner``` block
to Transient

!listing msr/cnrs/s21/cnrs_s21_griffin_neutronics.i block=TransportSystems


Instructions for the exection process are placed in the ```Executioner``` block
as follows

!listing msr/cnrs/s21/cnrs_s21_griffin_neutronics.i block=Executioner


On the Navier-Stokes solve side, the problem is still executed as a transient 
solver.
However, instead of running the problem for a long time to achieve steady state,
the problem is defined as follows

!listing msr/cnrs/s21/cnrs_s21_ns_flow.i block=Executioner

