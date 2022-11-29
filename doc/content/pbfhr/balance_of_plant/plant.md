# MK1-FHR plant model

*Contact: Guillaume Giudicelli, guillaume.giudicelli.at.inl.gov*

The [multiphysics core model](pbfhr/steady/griffin_pgh_model.md), which uses Griffin for neutronics and Pronghorn for
coarse mesh porous media CFD, is coupled with the [balance of plant model](pbfhr/pbfhr_sam/pbfhr_sam.md),
which uses SAM for 1D thermal hydraulics of the primary and secondary loops.

!media media/pbfhr/plant/coupling_scheme.png
       caption=Coupling scheme for the Mk1-FHR plant model
       style=width:100%

## Modifications to the core 2D-RZ model

The connection between the core model and the balance of plant simulation is made through the
inlet and outlet of the core in the primary loop. Instead of a fixed inlet mass flow rate
and a fixed outlet pressure like in the previous model, those quantities will be provided by the
simulation of the rest of the primary loop.

The boundary information, collected in SAM, is passed between the applications using
[Transfers](https://mooseframework.inl.gov/syntax/Transfers/index.html).
In particular, the `MultiAppPostprocessorsTransfer` from SAM enables the transfer of multiple
[postprocessors](https://mooseframework.inl.gov/syntax/Postprocessors/index.html)
by a single object.

!listing pbfhr/plant/ss1_combined.i block=Transfers/receive_flow_BCs

The outlet pressure is passed from SAM to Pronghorn and stored in a
[Receiver](https://mooseframework.inl.gov/source/postprocessors/Receiver.html), as are the
core inlet mass flow rate and temperature.

!listing pbfhr/plant/ss1_combined.i block=Postprocessors/inlet_mdot Postprocessors/inlet_temp_fluid Postprocessors/outlet_pressure

The boundary conditions are modified appropriately to use the boundary information newly stored in those Postprocessors.
Flux boundary conditions are utilized as they are naturally conservative in a finite volume method.
The fluxes for the mass, momentum and energy equations are all provided, computed by
the boundary conditions based on the mass flow rates, local density and inlet surface area.

!listing pbfhr/plant/ss1_combined.i block=Modules/NavierStokesFV start=inlet_boundaries end=pressure_function include-end=True

In the other direction of the coupling, the boundary conditions that will be passed to SAM are collected using
side integrals and flow rate postprocessors. These are executed at the end of each time step
and collect the outlet flow conditions as well as the inlet pressure. The inlet temperature
is also computed in case of a flow reversal.

!listing pbfhr/plant/ss1_combined.i block=Postprocessors/pressure_in Postprocessors/mass_flow_out Postprocessors/T_flow_out Postprocessors/T_flow_in

The `Transfer` system is once again leveraged, this time to send data to SAM. The modifications to the
SAM input are detailed in the next section.

!listing pbfhr/plant/ss1_combined.i block=Transfers/send_flow_BCs

## Modifications to the balance of plant 1D model

The initial [SAM model](pbfhr/pbfhr_sam/pbfhr_sam.md) of the Mk1-FHR models the entire primary and secondary loop
as well as a selection of passive systems. A 1D model of the core is present in the primary loop, providing a heat source
as well as estimating the coolant travel time in the core and the pressure drop from friction in the pebble bed.
This 1D core component is removed in the coupled model, as it is replaced with a 2D RZ Pronghorn model of the core.
The `Transfer` previously shown populates the following `Receiver` postprocessors:

!listing pbfhr/plant/ss2_primary.i block=Postprocessors/Core_outlet_mdot Postprocessors/Core_outlet_T Postprocessors/Core_inlet_pressure Postprocessors/Core_inlet_T_reversal

SAM uses velocity rather than mass flow rates, so the core outlet velocity is computed from
the mass flow rate obtained from Pronghorn.

!listing pbfhr/plant/ss2_primary.i block=Postprocessors/Core_outlet_rho Postprocessors/Core_outlet_v

These `Receivers` are then fed into dedicated coupling components, placed at the inlet and outlet of the core.

!listing pbfhr/plant/ss2_primary.i block=Components/core_inlet Components/core_outlet

These components are connected to the reset of the primary using pipes, which were chosen arbitrarily for this model.

!listing pbfhr/plant/ss2_primary.i block=Components/fueling Components/defueling

The core bypass flow is modeled by SAM, with both its inlet and outlet in the primary outside of the core model.

## How to run the inputs

The simulation could be run directly in one step as a coupled eigenvalue (neutronics) - relaxation to steady-state
transient (fluids) calculation. However this is not efficient as it would require the coupled multiphysics problem
to both perform a long transient to heat up the components of the core and to converge the SAM-Pronghorn coupling
on every neutronics - thermal fluids coupling iteration.

Instead we suggest to first converge the SAM-Pronghorn primary loop model separately, then converge the full
Griffin-Pronghorn-SAM restarting the thermal fluids calculation. We may also initialize the SAM primary loop simulation before
coupling it to Pronghorn. To do this, we run:

```
mpirun -n 8 ~/projects/blue_crab/blue_crab-opt -i ss2_primary.i
mpirun -n 8 ~/projects/blue_crab/blue_crab-opt -i ss1_combined_initial.i
mpirun -n 8 ~/projects/blue_crab/blue_crab-opt -i ss0_neutrons.i
```

To remove either of the two first steps from the workflow, the `restart_file_base` `[Problem]` parameter in the SAM input and the
`restart_from_file_var` `[Variables]` parameters in the Pronghorn should be commented out.

## Relaxation to steady state transient

We present in this section sample results for the coupling of the coupled SAM-Pronghorn plant simulation
in a relaxation to steady state transient. Both simulations start reasonably initialized, and come to an
equilibrium as the mass flow rates and the pressure drops in the core and in the various 1D components adjust
for the head output by the pumps in the SAM model.

The core distributions are overlaid on the 1D results in Paraview. The 1D component widths are artificially
inflated in Paraview, for legibility. Both the pressure and salt temperature show continuity at the interface
between SAM and Pronghorn, ensured by the boundary conditions.

!media media/pbfhr/plant/salt_temp.png
       caption=Salt temperature through the Mk1-FHR plant model
       style=width:100%

!media media/pbfhr/plant/pressure.png
       caption=Pressure through the Mk1-FHR plant model
       style=width:100%

## Acknowledgements

The model was created with support from Daniel Nunez at ANL and Cole Mueller at INL.

!bibtex bibliography
