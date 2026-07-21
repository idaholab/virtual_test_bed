## Step 4

In this step, a heat source representing fission is added in the pebble-bed
region. Neutrons cause fission in the fuel kernels dispersed in the pebbles.
The pebbles conduct the heat to the outside of the pebble where it is
transferred to the helium coolant via convection.

Note that in this step, many parameters, such as mass flow rate and inlet
temperature, and material property values, such as heat transfer coefficients,
are not set to realistic values. The obtained results are therefore quite
different from prototypical gas-cooled reactors.

## Added Inputs

The thermal model adds two linear finite-volume variables. The fluid energy
equation is written in terms of fluid enthalpy `h_fluid`, which is solved on
`energy_system`:

!listing htgr/generic-pbr-tutorial-segregated/step4.i block=h_fluid

The solid temperature `T_solid` is solved on `solid_energy_system` and is
restricted to the pebble-bed block:

!listing htgr/generic-pbr-tutorial-segregated/step4.i block=T_solid

The fluid enthalpy equation contains advection, diffusion, and heat exchange
with the solid. The solid temperature equation contains conduction, the fission
heat source, and the corresponding heat exchange with the fluid:

!listing htgr/generic-pbr-tutorial-segregated/step4.i start=fluid_energy_advection end=convection_pebble_bed_fluid

The fluid enthalpy boundary condition at the top fixes `h_fluid` to
`${h_inlet}`. The side boundaries are adiabatic and the bottom uses an outflow
condition. The solid temperature has zero heat flux on the side boundaries:

!listing htgr/generic-pbr-tutorial-segregated/step4.i start=top_h_fluid end=side_T_solid

The shape of the heat source is represented as a `ParsedFunction` in the input
file:

!listing htgr/generic-pbr-tutorial-segregated/step4.i block=heat_source_fn

The `expression` declares the heat source as a function of the y-coordinate,
which is aligned with the up/down direction in this model. The radial dependence
of the heat source is omitted. The prefactor `power_fn_scaling` = $0.8869$
rescales the function to yield a power of 200 MW.

`heat_source_fn` is used first as the source term in the solid temperature
equation and second by a postprocessor that integrates the source over the
pebble-bed block:

!listing htgr/generic-pbr-tutorial-segregated/step4.i block=heat_source_integral

The postprocessor named `heat_source_integral` should return $2 \times 10^8$.

Properties used by the equations are provided as functors. The helium properties
come from `GeneralFunctorFluidProps`, while `LinearFVEnthalpyFunctorMaterial`
recovers the fluid temperature from pressure and enthalpy. The KTA drag and
linear Peclet fluid conductivity correlations are kept as functor materials:

!listing htgr/generic-pbr-tutorial-segregated/step4.i start=fluid_props end=kappa_h_material

Because the SIMPLE fluid energy variable is enthalpy rather than temperature,
the diffusion tensor for the enthalpy equation is `kappa_h = kappa / cp`. The
input obtains `cp` and the components of `kappa` from the helium property
functors and forms the three components of `kappa_h` with auxiliary variables:

!listing htgr/generic-pbr-tutorial-segregated/step4.i start=fluid_temperature end=assign_kappa_over_cp_z

The solid conductivity and volumetric heat transfer coefficient are supplied as
simple functor materials:

!listing htgr/generic-pbr-tutorial-segregated/step4.i start=solid_k end=alpha_mat

## Execution

!listing
./pronghorn-opt -i step4.i

## Results

From the screen output we find that at steady state, the `enthalpy_balance`
matches the `heat_source_integral`, indicating that Pronghorn conserves energy.

The geometry/mesh, fluid temperature, solid temperature, and vertical superficial
velocity are shown in [step4mesh] through [step4Velocity]. A few remarks
are in order:

- Fluid temperature increases monotonically from top to bottom. The temperature
  increases by about $600$ K, which is $100$ K more than a typical pebble-bed
  high-temperature gas-cooled reactor.
- The difference between solid and fluid temperature is much larger than in
  reality because the heat transfer coefficient is much smaller than in reality.
- The solid temperature peaks roughly at core mid-height because of the peak in
  power density and the large difference between fluid and solid temperature.
- Velocity increases in magnitude towards the outlet because the fluid density decreases.

!media generic-pbr-tutorial/MeshP4.png
        style=width:10%
        id=step4mesh
        caption= Block and mesh definition for Step 4.

!media generic-pbr-tutorial-segregated/T_fluidP4.png
        style=width:20%
        id=step4T_fluid
        caption= Temperature of the fluid for Step 4.

!media generic-pbr-tutorial-segregated/T_solidP4.png
        style=width:20%
        id=step4T_solid
        caption= Temperature of the solid for Step 4. Note that the solid temperature is not defined in the cavity.

!media generic-pbr-tutorial-segregated/VelocityP4.png
        style=width:20%
        id=step4Velocity
        caption= Vertical velocity of the system for Step 4.
