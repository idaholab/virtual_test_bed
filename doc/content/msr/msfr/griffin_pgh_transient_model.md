# MSFR Griffin-Pronghorn Transient Model

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

*Model link: [Griffin-Pronghorn Transient Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/transient)*

!tag name=MSFR Griffin-Pronghorn Transient Model pairs=reactor_type:MSR
                       reactor:MSFR
                       geometry:core
                       simulation_type:multiphysics
                       input_features:multiapps
                       transient:ULOF
                       codes_used:BlueCrab;Griffin;Pronghorn;MOOSE_NavierStokes
                       computing_needs:Workstation
                       fiscal_year:2021
                       sponsor:NRIC
                       institution:INL

In addition to the steady-state MSFR model, the Virtual Test Bed also contains
an example transient model. This model is intended to represent a partial
loss-of-flow accident. The exact mechanism is unspecified here (it could be a
sudden flow blockage or a group of pump trips), but it will be modeled by reducing the pumping force by a factor of 2.

## Transient kernels

The setup of MOOSE variables, kernels, boundary conditions, etc. is similar to
the [steady-state model](msfr/griffin_pgh_model.md). The only difference is that the fluid flow model is using a `Transient` executioner instead of a
`Steady` one.

The neutronics model can be made transient by simply switching the parameter
`equation_type = eigenvalue` to `equation_type = transient` in the
`TransportSystems` block,

!listing msr/msfr/transient/run_neutronics.i block=TransportSystems

## Initialization

The [steady-state model](msfr/griffin_pgh_model.md) will be re-used here in
order to initialize the solution for the transient. The MOOSE Framework provides
several different methods for initializing one model with the result of another.

- Exodus restart: A simulation can be "restarted" from an output solution saved
  in an Exodus file.
- Checkpoint restart: A simulation can also be restarted using MOOSE's custom
  checkpoint file format.
- Initial MultiApp: A simulation can be run from scratch via the MultiApp
  system, and the resulting solution can then be transferred over to the main
  application.

This example will use both the Exodus restart.
The fluid dynamics app, in particular, will use the Exodus method. Note that the
`[Mesh]` block references an output file created by the steady-state simulation.
(An Exodus file might contain just a mesh, or it might contain a mesh and a set
of solution fields.) Also note the parameter, `use_for_exodus_restart = true`:

!listing msr/msfr/transient/run_ns.i block=Mesh/restart

With an Exodus restart, we must also specify which variables will be initialized
from the input Exodus file. Here, all of the variables are initialized from
Exodus. Note the `initial_from_file_var` parameters in these variables,

!listing msr/msfr/transient/run_ns.i block=Variables

The Exodus restart method is desirable because it allows the user to run many
transient simulations without having to repeatedly re-initialize the solution.
However, the Exodus restart method cannot presently be used with Griffin
simulations that use the `external_dnp_var` feature. (See Griffin issue #177.)
As a fall-back, the neutronics solution will instead be initialized via the
MultiApp approach.

Like the fluids app, the mesh for the neutronics app will be set using the
output of the steady-state simulation. This ensures mesh consistency between the
steady and transient simulations.

!listing msr/msfr/transient/run_neutronics.i block=Mesh/fmg

## Pump control

Here the partial loss-of-flow event is modeled by reducing the pump force. This
is done through the Control system. The following block will modify the relevant
parameter at each time step, and it will evaluate the specified function
(`pump_fun`) to find the desired value:

!listing msr/msfr/transient/run_ns.i block=Controls/pump_control

The function is defined elsewhere in the input file as,

!listing msr/msfr/transient/run_ns.i block=Functions/pump_fun

Note that a step function is used here. At $t = 2~\text{s}$, the pumping force
instantly drops to half its initial value. Note that a more complex model could
be implemented by specifying additional $(x, y)$ points in the function or by
using e.g. a `PiecewiseLinear` or `ParsedFunction` instead of
`PiecewiseConstant`.
