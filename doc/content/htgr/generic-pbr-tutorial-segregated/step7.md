## Step 7

In Step 7, we add bypass flow through the control rod. The flow splits at the upper
plenum into the portion that flows through the bed and a small bypass flow portion that
flows through the control rod. This increases pebble-bed temperatures slightly, but ensures that
the control rod is cooled during reactor operations.

## Modifying the Geometry

A portion of the side reflector between the riser and pebble bed is replaced by the `control_rods` block (block 8). The modification that needs to be made in the `cartesian_mesh` object is simple: some of the numbers that represent the side reflector are replaced by block number 8. We assume that the control rods are not inserted
in this model, so the porous medium contains only flow volume and graphite. The geometry is depicted in [step7mesh].

Note, the `control_rods` block defines both flow variables and
`T_solid` and the corresponding block definitions must be updated.

!media generic-pbr-tutorial/MeshP7.png
        style=width:100%
        id=step7mesh
        caption=Geometry for Step 7 with the fluid domain framed in red.

## Updated Parameters

The hydraulic diameter of
the control rods is set to `control_rod_Dh = 0.1` because we assume that the control rod is an empty channel with
a diameter of $0.1$ m.

!listing htgr/generic-pbr-tutorial-segregated/step7.i start=p_out end=Mesh

## Materials

The control rod block has a porosity of $0.32$. The porosity is computed as the ratio of
control rod channel area (number of control rods times the area of a circle of diameter $0.1$ m) and the
area of the porous flow region perpendicular to the vertical axis that represents the control rod in this model. The porosity is added here:

!listing htgr/generic-pbr-tutorial-segregated/step7.i block=porosity

and the hydraulic diameter is added here:

!listing htgr/generic-pbr-tutorial-segregated/step7.i block=characteristic_length_mat

The solid properties (`rho_s`, `cp_s`, `k_s`) are set just like for the
other non-pebble-bed regions using a `GenericFunctorMaterial`:

!listing htgr/generic-pbr-tutorial-segregated/step7.i block=graphite_rho_and_cp_riser_control_rods

The drag coefficient in the `control_rods` is used to adjust the bypass flow to
between $2$ and $3$% of the nominal mass flow rate. The Darcy coefficient is set to
$0$ and the Forchheimer coefficient is set by a `LinearFrictionFactorFunctorMaterial` object. The local speed used by this model is provided by the `speed_material` functor.

!listing htgr/generic-pbr-tutorial-segregated/step7.i start=Darcy_control_rods end=[porosity]

In `Forchheimer_control_rods`, `g` receives the `new_g` functor and `B` can be used
to make the Forchheimer coefficient anisotropic, which is not the case here.

## Postprocessors

The mass flow rate through the bypass flow channel is measured using this postprocessor:

!listing htgr/generic-pbr-tutorial-segregated/step7.i block=cr_mfr

The postprocessor uses the Rhie-Chow face flux and is not outputted anywhere because of the `outputs = none` line.
The fraction of mass flow going through the control rod channel is computed by
`cr_mfr_fraction`:

!listing htgr/generic-pbr-tutorial-segregated/step7.i block=cr_mfr_fraction

## Executioner

The input remains a steady-state SIMPLE solve:

!listing htgr/generic-pbr-tutorial-segregated/step7.i start=Executioner end=Variables

## Execution

!listing
./pronghorn-opt -i step7.i
