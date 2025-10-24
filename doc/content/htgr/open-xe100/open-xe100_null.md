# Griffin Open Xe-100 Null Transient

## Input Description

!listing htgr/open-xe100/xe100_null.i

This input file is identical to the steady-state case, except for the following:

### TransportSystems

The `equation_type` is set to transient, and the `diff` sub-block has the following
additional parameters:

`fission_source_aux = true`, this adds the prompt fission source and DNPs as
auxiliary variables.\\ 
`assemble_delay_jacobian = true`, tells Griffin to include the delayed term when
assembling the Jacobian.\\ 
`linear_fsrc_in_time = true`, uses linear interpolation between the current
and old fission sources to evaluate delayed neutron precursors (DNPs).\\ 
`dnp_integration_scheme = backward-Euler`, use the backward-Euler method for
solving the DNP equations.\\ 
`initialize_iqs_adjoint_flux = true`, provides constant adjoint fluxes
as the weighting functions for IQS.

!listing htgr/open-xe100/xe100_null.i block=TransportSystems

### Executioner

The `Executioner` type is set to IQS. The IQS method is discussed in detail in
Stewart et al. [!citep](Stewart2022). The purpose of this null transient is to
confirm the steady-state solution and to generate PKE parameters.

Some notable additional parameters are:

`do_iqs_transient = true`, this selects the IQS time integration scheme.\\ 
`pke_param_csv = true`, this outputs a `csv` file with PKE parameters.\\ 
`add_periods_in_outputs = true`, this prints reactor asymptotic and measured period.\\ 
`snesmf_reuse_base = false`, this specifies that the matrix-free Jacobian
approximation should not reuse the previous function evaluation.

!listing htgr/open-xe100/xe100_null.i block=Executioner

## Running the Simulation

Griffin can be run on Linux, Unix, MacOS, and Windows in WSL. Griffin can be run
from the shell prompt as shown below:

```language=bash

griffin-opt -i xe100_null.i

```

\\ 

### Links

[Griffin Open Xe-100 index](open-xe100/index.md)

[Griffin Open Xe-100 steady-state](open-xe100/open-xe100_ss.md)

[Griffin Open Xe-100 IQS transient](open-xe100/open-xe100_iqs.md)

[Griffin Open Xe-100 PKE transient](open-xe100/open-xe100_pke.md)

[Griffin Open Xe-100 results](open-xe100/open-xe100_results.md)

[Griffin Open Xe-100 model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/open-xe100)