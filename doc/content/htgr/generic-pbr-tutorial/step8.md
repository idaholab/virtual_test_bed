## Step 8

The final step is to add the outer structure of the reactor. The outer structure includes carbon bricks, helium gaps, the core barrel, and the reactor pressure vessel (RPV). There are 2 different helium gaps, one between the carbon bricks and the core barrel and the other between the core barrel and the RPV.

## Geometry

The geometry is changed by modifying the `cartesian_mesh` block. The geometry is depicted in [step8mesh].

!media generic-pbr-tutorial/MeshP8.png
        style=width:100%
        id=step8mesh
        caption=Geometry for Step 8.

Note that only solid conduction blocks are added in Step 8 so that the `NavierStokesFV` remains
unchanged.

## Adding Boundary Conditions for T_solid

At the radial outside boundary of the RPV, a Dirichlet boundary condition of $300$ K is applied:

!listing htgr/generic-pbr-tutorial/step8.i block=FVBCs

By adding the boundary condition on the outer surface of the RPV, some of the
heat deposited in the pebble-bed is conducted to the RPV.
In a more realistic model, a convective and radiative boundary condition should be
applied.

## Materials

The `carbon_bricks` block is modeled as the same graphite as the `side_reflector`:

!listing htgr/generic-pbr-tutorial/step8.i block=graphite_rho_and_cp_carbon_bricks

The barrel and RPV are different steels, differing in specific heat and thermal conductivity:

!listing htgr/generic-pbr-tutorial/step8.i start=barrel_rho_cp_kappa end=gap_rho_and_cp

Only the `carbon_bricks`, `core_barrel`, and `rpv` blocks are added to the  `effective_thermal_conductivity` object:

!listing htgr/generic-pbr-tutorial/step8.i block=effective_thermal_conductivity_material

The properties of the gaps is taken care of differently. The gaps are in principle not
a solid but a stagnant gas. However, we treat it like a solid with small density and
effective thermal conductivity that takes into account conduction and radiation. To this end
`cp_s` and `rho_s` are defined as usual:

!listing htgr/generic-pbr-tutorial/step8.i block=gap_rho_and_cp

The effective thermal conductivities are defined using `FunctorGapHeatTransferEffectiveThermalConductivity` objects:

!listing htgr/generic-pbr-tutorial/step8.i start=effective_thermal_conductivity_barrel_gap end=pebble_bed_alpha

In this object:

- `gap_direction` coordinate direction pointing through the gap (i.e., connecting the two faces delimiting the gap),
- `gap_conductivity_function` is the molecular thermal conductivity of the gas in the gap as a function of temperature,
- `radius_primary` signals that the geometry that is considered is cylindrical. It is the inner radius of the cylindrical gap. `radius_secondary` must be provided now,
- `radius_secondary` is the outer radius of the cylindrical gap.

## Executable

!listing
./pronghorn-opt -i step8.i

## Result

The solid temperature is shown in [step8_Tsolid].

!media generic-pbr-tutorial/T_solidP8.png
        style=width:100%
        id=step8_Tsolid
        caption=Solid temperature for Step 8.
