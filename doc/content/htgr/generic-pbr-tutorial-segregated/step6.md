## Step 6

We build upon the previous step by adding the upper and bottom plenums and the riser. The inlet boundary has moved from the top of the cavity to the bottom of the riser and the outlet boundary has moved from the bottom of the bottom reflector to the right side of the bottom plenum.

In contrast to Step 5, the coolant now turns three times on its way from the inlet to the outlet boundary. The fluid flow path starts from the inlet, goes up into the riser, then across the upper plenum and cavity. Next, the flow goes down through the pebble-bed followed by the bottom reflector and bottom plenum. Finally, the flow will go through the outlet.

The porosities of the upper plenum, bottom plenum and riser are $0.2$, $0.2$ and $0.32$, respectively.

## Updating and Adding Parameters

We adjust `top_core` to account for the addition of the bottom plenum, add the hydraulic diameter of the riser, `riser_Dh`, and set the plenum drag scale, `c_drag_old`. The riser radii define the inlet flow area used to compute the inlet velocity from the mass flow rate. The new set of parameters is given by:

!listing htgr/generic-pbr-tutorial-segregated/step6.i start=outlet_pressure end=Mesh

The Darcy coefficient in the plenums is usually determined from an experiment or CFD simulations of the plenum regions. These are not available and therefore we
set the Darcy coefficient to a number that is large enough to ensure smooth convergence but small enough to not change the solution much.

## Geometry

The geometry is changed in `[Mesh/cartesian_mesh]`. Note the addition
of the plenum and riser blocks.

!listing htgr/generic-pbr-tutorial-segregated/step6.i block=cartesian_mesh

The geometry is depicted in [step6mesh].

!media generic-pbr-tutorial/MeshP6.png
        style=width:100%
        id=step6mesh
        caption= Mesh for Step 6.

The change in geometry requires updating the `T_solid` variable definition and the block restrictions used by the SIMPLE flow and energy objects.

## Materials

We added `GenericFunctorMaterial` in the `riser`, `upper_plenum`, and `bottom_plenum` blocks defining `rho_s`, `cp_s`, and `k_s`:

!listing htgr/generic-pbr-tutorial-segregated/step6.i start=graphite_rho_and_cp_riser end=kappa_s_pebble_bed

The difference from the already existing reflector definitions is the different
value of $1-\epsilon$ used in the conductivity multiplier.

The drag coefficients in the `cavity`, `upper_plenum` and `bottom_plenum` are set using the `c_drag` material derived from `c_drag_old`:

!listing htgr/generic-pbr-tutorial-segregated/step6.i start=drag_new_convention end=drag_bottom_reflector_riser

The drag coefficient in the `bottom_reflector` and `riser` is modeled as pressure
drop in pipes:

!listing htgr/generic-pbr-tutorial-segregated/step6.i block=drag_bottom_reflector_riser

The `porosity` material is updated to include the porosity in the `riser`, `upper_plenum`, and `bottom_plenum`:

!listing htgr/generic-pbr-tutorial-segregated/step6.i block=porosity

The characteristic length in the riser is set here:

!listing htgr/generic-pbr-tutorial-segregated/step6.i block=characteristic_length_mat

## Execution

To run step 6, you simply run:


!listing
./pronghorn-opt -i step6.i

## Results

In [step6T_fluid], the fluid temperature and flow field are shown. The main difference between Step 6 and the previous steps is that
the flow turns multiple times before reaching the outlet.
In [step6T_solid], the solid temperature and the outline of the fluid domain are shown.

!media generic-pbr-tutorial-segregated/T_fluidP6.png
        style=width:50%
        id=step6T_fluid
        caption= Fluid temperature and flow field for Step 6.

!media generic-pbr-tutorial-segregated/T_solidP6.png
        style=width:50%
        id=step6T_solid
        caption= Solid temperature for Step 6.
