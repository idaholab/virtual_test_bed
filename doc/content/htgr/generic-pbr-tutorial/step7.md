## Step 7

In Step 7, we add the bypass flow through the control rod. The flow splits at the upper
plenum into the portion that flows through the bed and a small bypass flow portion (a few percent)
that flows through the control rod. This increases pebble bed temperatures slightly, but ensures that
the control rod is cooled during reactor operations.

## Modifying the Geometry

A portion of the side reflector between the riser and pebble bed is replaced by the `control_rods` block (block 8). The modification that needs to be made in the `cartesian_mesh` object is simple. Some of the numbers that represents the side reflector are replaced by block number 8. We assume that the control rods are not inserted
in this model so the porous medium contains only flow volume and graphite. The geometry is depicted in [step7mesh].

Note, the `control_rods` block defines both flow variables and
`T_solid` and the corresponding block definitions must be updated.

!media generic-pbr-tutorial/MeshP7.png
        style=width:100%
        id=step7mesh
        caption=Geometry for Step 7 with the fluid domain framed in red.

## Updated Parameters

The `thermal_mass_scaling` is reduced to obtain faster convergence
to steady-state during the pseudo-transient. The hydraulic diameter of
the control rods is set to `control_rod_Dh = 0.1`.

!listing htgr/generic-pbr-tutorial/step7.i start=outlet_pressure end=Mesh

## Materials

The control rod block has a porosity of $0.32$ which is added here:

!listing htgr/generic-pbr-tutorial/step7.i block=porosity_material

and the hydraulic diameter is added here:

!listing htgr/generic-pbr-tutorial/step7.i block=characteristic_length

The solid properties (`rho_s`, `cp_s`, `kappa_s`) are set just like for the 
other non-pebble-bed regions using a `ADGenericFunctorMaterial`:

!listing htgr/generic-pbr-tutorial/step7.i block=graphite_rho_and_cp_riser_control_rods

The drag coefficient in the `control_rods` is used to adjust the bypass flow to 
between $2$ and $3$% of the nominal mass flow rate. The Darcy coefficient is set to
$0$ and the Forchheimer coefficient is set by a `LinearFrictionFactorFunctorMaterial` object.

!listing htgr/generic-pbr-tutorial/step7.i start=Darcy_control_rods end=porosity_material

In `Forchheimer_control_rods`, `g=1000` is the Forchheimer coefficient and `B` can be used 
to make the Forchheimer coefficient anisotropic. In this case, we just make it isotropic.
`f` must be provided but it corresponds to a linear contribution of the pressure drop
which we choose to not use in this example. 

## Postprocessors

The mass flow rate through the bypass flow channel is measured using this postprocessor:

!listing htgr/generic-pbr-tutorial/step7.i block=cr_mfr

Note, the postprocessor is not outputted anywhere because of the `outputs = none` line.
The fraction of mass flow going through the control rod channel is computed by
`cr_mfr_fraction`:

!listing htgr/generic-pbr-tutorial/step7.i block=cr_mfr_fraction

## Executioner

MOOSE allows the user to run a pseudo-transient until it achieves steady-state.
This is accomplished by adding:

!listing htgr/generic-pbr-tutorial/step7.i start=steady_state_detection end=[]

to the `Executioner` block. This switches on steady-state detection starting
at `t=1000s` and stops the simulation once the steady-state relative differential norm 
has dropped below $10^{-10}$.

## Executable

!listing
./pronghorn-opt -i step7.i

## Results