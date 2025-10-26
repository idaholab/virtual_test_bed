# Griffin Open Xe-100 IQS Transient

The IQS (Improved Quasi-static) method is used to solve transient spatial kinetics
by factorizing flux into space-dependent and time-dependent components. Both
components include the flux amplitude and flux shape, but the amplitude is only
dependent on time, while the shape is dependent on position and time. By assuming
that the shape is weakly dependent on time, a "quasi-static" treatment can be done
by not computing the shape at each time step. The shape calculation is computationally
expensive relative to the amplitude, so the IQS method can significantly reduce
the computational cost of a transient simulation.

## Input Description

!listing htgr/open-xe100/xe100_iqs.i

This input file is nearly identical to the null transient case, except for the following:

### AuxKernels

This block contains a temperature ramp for the reflector to initiate the transient.
It calls the `temp_feedback_ref` function.

!listing htgr/open-xe100/xe100_iqs.i block=AuxKernels

### Functions

This block has the `temp_feedback_ref` function, which causes a step change in
the reflector temperature by 1 K at 4 seconds.

!listing htgr/open-xe100/xe100_iqs.i block=Functions

## Running the Simulation

Griffin can be run on Linux, Unix, MacOS, and Windows in WSL. Griffin can be run
from the shell prompt as shown below

```language=bash

griffin-opt -i xe100_iqs.i

```

\\ 

### Links

[Griffin Open Xe-100 index](open-xe100/index.md)

[Griffin Open Xe-100 steady-state](open-xe100/open-xe100_ss.md)

[Griffin Open Xe-100 null transient](open-xe100/open-xe100_null.md)

[Griffin Open Xe-100 PKE transient](open-xe100/open-xe100_pke.md)

[Griffin Open Xe-100 results](open-xe100/open-xe100_results.md)

[Griffin Open Xe-100 model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/open-xe100)