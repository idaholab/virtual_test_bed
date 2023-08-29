## Step 6

We build upon for the previous step, by adding the upper/bottom plenum and the riser.  The inlet boundary has moved from the top of the cavity to the bottom of the riser and the outlet changed from the bottom of the bottom reflector to the right side of the bottom plenum.

In contrast to Step 5, the coolant now turns three times on its way from the inlet to the outlet boundary. The fluid flow path starts from the inlet, goes up into the riser, then across the upper plenum and cavity. Next, the flow goes down through the pebble-bed followed by the bottom reflector and bottom plenum. Finally, the flow will go through the outlet.

The porosities of the upper plenum, bottom plenum and riser are $0.2$, $0.2$ and $0.68$, respectively.

## Updating and Adding Parameters

We adjust `top_core` to account for the addition of the bottom plenum, add the hydraulic diameter of the riser, `riser_Dh`, add a Darcy coefficient for the
plenums, `c_drag`, and reduce the `thermal_mass_scaling` to $0.1$ to accelerate convergence to steady-state. The new set of parameters
is given by:

!listing htgr/generic-pbr-tutorial/step6.i start=outlet_pressure end=Mesh

The Darcy coefficient in the plenums is usually determined from an experiment or CFD simulations of the plenum regions. These are not available and therefore we
set the Darcy coefficient to a number that is large enough to ensure smooth convergence but small enough to not change the solution much.

## Geometry

The geometry is changed in `[Mesh/cartesian_mesh]`. Note, the addition
of the plenum and riser blocks.

!listing htgr/generic-pbr-tutorial/step6.i block=cartesian_mesh

The geometry is depicted in [step6mesh].

!media generic-pbr-tutorial/MeshP6.png
        style=width:100%
        id=step6mesh
        caption= Mesh for Step 6.

The change in geometry requires updating the `T_solid` variable definition
and the block parameter in the `NavierStokesFV` action.

## Materials

We added `ADGenericFunctorMaterial` in the `riser`, `upper_plenum`, and `bottom_plenum` blocks defining `rho_s`, `cp_s`, and `kappa_s`:

!listing htgr/generic-pbr-tutorial/step6.i start=graphite_rho_and_cp_riser end=drag_pebble_bed

The difference to the already existing definition of `kappa_s` is the different
value of $1-\epsilon$.

The drag coefficients in the `cavity`, `upper_plenum` and `bottom_plenum` is set using the `c_drag` parameter that is used in `ADGenericVectorFunctorMaterial` objects:

!listing htgr/generic-pbr-tutorial/step6.i start=drag_cavity end=drag_bottom_reflector

The drag coefficient in the `bottom_reflector` and `riser` is modeled as pressure
drop in pipes:

!listing htgr/generic-pbr-tutorial/step6.i block=drag_bottom_reflector_riser

The `porosity_material` is updated to include the porosity in the `riser`, `upper_plenum`, and `bottom_plenum`:

!listing htgr/generic-pbr-tutorial/step6.i block=porosity_material

The characteristic length in the riser is set here:

!listing htgr/generic-pbr-tutorial/step6.i block=characteristic_length

## Executable

!listing
./pronghorn-opt -i step6.i

## Results

In [step6T_fluid], the fluid temperature and flow field are shown. The main difference of Step 6 to the previous steps is that
the flow turns multiple times before reaching the outlet.
In [step6T_solid], the solid temperature along with the outline of the fluid domain are shown.

!media generic-pbr-tutorial/T_fluidP6.png
        style=width:100%
        id=step6T_fluid
        caption= Fluid temperature and flow field for Step 6.

!media generic-pbr-tutorial/T_solidP6.png
        style=width:100%
        id=step6T_solid
        caption= Solid temperature for Step 6.
