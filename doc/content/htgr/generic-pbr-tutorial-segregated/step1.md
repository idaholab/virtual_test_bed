## Step 1

The first step creates an axially symmetric flow channel
with a uniform porosity of $\epsilon = 0.39$. This region will become
the pebble bed in future steps. In this initial step, the flow
channel has no pressure drop or heat source. The inflow boundary
is situated at the top, the outflow boundary is situated at the bottom,
and the left and right boundaries are slip walls.

We expect that velocity in the y-direction and pressure are uniform in the flow channel
and velocity in the x-direction is 0. The heat equation is not solved at all,
and the fluid temperature will not be added as a variable.

This tutorial uses the finite volume method to discretize the thermal-hydraulics equations.
We solve a steady-state directly using the SIMPLE solver.

### Geometry

We define the bed height, bed radius, porosity, and operating conditions at the top of the input file.

!listing htgr/generic-pbr-tutorial-segregated/step1.i start=bed_height end=flow_vel

Then we use the `GeneratedMeshGenerator` to create a Cartesian mesh
of the desired height and width. Notice how we use the ${x} syntax, where x
stands for any defined parameter, usually defined at the top of the input file.

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=Mesh

The parameters of `GeneratedMeshGenerator` are explained [here](https://mooseframework.inl.gov/source/meshgenerators/GeneratedMeshGenerator.html).
In two-dimensional geometry, the boundaries are named bottom (id=0), right (id=1), top (id=2), and left (id=3).
The line `coord_type = RZ` sets the coordinate system to be axisymmetric (aka RZ). The symmetry axis
defaults to the y-axis, which is what we want, so we do not need to set it explicitly.

To visualize the geometry, you can run:

!listing
./pronghorn-opt -i step1.i --mesh-only

This command produces the file `step1_in.e` that can be visualized using paraview.
It is shown in [step1geom].

!media generic-pbr-tutorial/step1_geometry.png
        style=width:10%
        id=step1geom
        caption=Geometry for Step 1.

### Setting the Fluid Properties

Fluid properties are set by first defining a `HeliumFluidProperties` fluid properties object
and second by creating a material that inserts the fluid properties into functors (if you do not know what a functor is then click [here](https://mooseframework.inl.gov/moose/syntax/FunctorMaterials/)).

The first task is performed by the following input syntax:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=FluidProperties

The second task is performed by the `GeneralFunctorFluidProps` object:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=FunctorMaterials

This object takes pressure and temperature provided to the parameters
`pressure` and `T_fluid`, respectively, and computes fluid properties, such as
density and viscosity. Density and viscosity are named `rho` and `mu`.
Note that `T_fluid` is set to a constant value in this input file because
we do not solve the heat equation and therefore have no fluid temperature defined
as a variable.

This object also requires functors for the `porosity`, `speed`, and `characteristic_length`
parameters. Porosity is defined as an auxiliary variable here:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=AuxVariables

and set equal to the `bed_porosity` parameter of 0.39.
The `speed` and `characteristic_length` functors are only needed by `GeneralFunctorFluidProps`
for derived quantities such as Reynolds numbers, which are not used in Step 1; therefore, both are set to simple constant values.

The density computed by `GeneralFunctorFluidProps` is copied into `rho_aux`:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=AuxKernels

The SIMPLE mass-flux object then uses `rho_aux` as its density functor.

### Setting up the Thermal-Hydraulics Problem

The thermal-hydraulics problem is set up using explicit linear finite volume
variables, kernels, boundary conditions, and a Rhie-Chow mass-flux user object.
The segregated linear systems are named in the `Problem` block:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=Problem

The Rhie-Chow mass-flux object provides the face mass fluxes used to couple the
segregated momentum and pressure equations:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=UserObjects

It uses the superficial velocity variables, pressure, density, porosity, and the pressure
diffusion kernel. The flux-velocity reconstruction options help reconstruct a consistent
cell velocity field from the corrected face fluxes, while enforcing zero normal flux on
the left and right symmetry boundaries.

The flow variables are defined explicitly:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=Variables

These initial conditions should be interpreted as initial guesses for the SIMPLE iteration.
The vertical velocity is initialized to the inlet velocity, and the pressure is initialized
to $5.4$ MPa.

The momentum and pressure equations are assembled using linear finite volume kernels:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=LinearFVKernels

The two `PorousLinearWCNSFVMomentumFlux` kernels add the momentum advection and stress
contributions for the x- and y-momentum equations. The pressure-gradient terms are added
with `LinearFVMomentumPressureUO`. The pressure equation is assembled using the inverse
momentum operator stored in `Ainv` and the predicted flux stored in `HbyA`.

The boundary conditions are set by these lines:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=LinearFVBCs

The top boundary is the inlet boundary, where we specify the inlet velocity. The inlet velocity
is $(0, -v_{in})$ where we note that the velocity is downward, leading to the negative sign.
The bottom boundary uses outflow conditions for velocity and a constant pressure condition for pressure.
The left and right boundaries are set to symmetry conditions for velocity and pressure, which
represent slip walls in this axisymmetric channel.

The relevant values used for substituting the ${variable_name} expressions are computed
at the beginning of the input file:

!listing htgr/generic-pbr-tutorial-segregated/step1.i start=outlet_pressure end=[Mesh]

### Checking Mass Conservation

We use postprocessors to compute the inlet and outlet mass flow rates.

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=Postprocessors

The `desired_mfr` postprocessor simply takes the `mass_flow_rate` parameter computed
at the top of the input file and prints it to screen. This is the mass flow rate we
want to achieve.

The `inlet_mfr` and `outlet_mfr` are `RhieChowMassFlowRate` postprocessors. They
integrate the Rhie-Chow face mass flux over the selected boundary. Because the inlet
flow is directed into the domain while the boundary normal points outward, the inlet
mass flow rate has a negative sign. We expect the inlet and outlet mass flow rate
magnitudes to match the desired mass flow rate.

### Executioner

The executioner object is explained in detail [here](https://mooseframework.inl.gov/syntax/Executioner/). For Step 1 we use these specifications:

!listing htgr/generic-pbr-tutorial-segregated/step1.i block=Executioner

We solve the steady problem using the `SIMPLE` executioner. The `momentum_systems`
parameter lists the segregated velocity systems and `pressure_system` identifies the
pressure system. The `rhie_chow_user_object` parameter connects the executioner to the
mass-flux object used by the momentum and pressure equations. The momentum and pressure
equations are under-relaxed, and the linear systems are solved with hypre BoomerAMG.
The input runs a fixed 250 SIMPLE iterations instead of requiring the individual residuals to reach $10^{-8}$, because this case has constant pressure and velocity fields and those residuals are not expected to decay to that tolerance.

### Results

Execute `step1.i` by:

!listing
./pronghorn-opt -i step1.i

Execution should take less than 2 seconds. An exodus file `step1_out.e` and a CSV file
`step1_out.csv` are created. The exodus file contains the pressure and superficial
velocity solutions. These are constant at $p=5.5$ MPa and
$\vec{v}=(0,-1.54191)$ m/s. Since they are not very relevant, they are not plotted here.
The final postprocessor values are:

!listing
desired_mfr = 60
inlet_mfr = -59.99997
outlet_mfr = 59.99997

We conserve mass, since the `inlet_mfr` and `outlet_mfr` magnitudes are identical.
The mass flow rate is also very close to what we expect ($60$ kg/s). The small
difference originates from truncating the decimals of the assumed density when
computing the inlet velocity.
