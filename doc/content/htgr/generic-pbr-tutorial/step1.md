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
We solve a pseudo-transient problem (i.e., we let a transient run long enough to achieve a steady-state solution). This approach is usually more stable than solving a steady-state problem directly.

### Geometry

We define the bed height and bed radius at the top of the input file.

!listing htgr/generic-pbr-tutorial/step1.i start=subdomains end=bed_porosity

Then we use the `GeneratedMeshGenerator` to create a Cartesian mesh
of the desired height and width. Note, how we use the ${x} syntax, where x
stands for any defined parameter. We

!listing htgr/generic-pbr-tutorial/step1.i block=Mesh

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
and second by creating a material that inserts the fluid properties into functors (if you do not know what a functor is then click [here](https://mooseframework.inl.gov/moose/syntax/Materials/)).

The first task is performed by the following input syntax:

!listing htgr/generic-pbr-tutorial/step1.i block=FluidProperties

The second task is performed by the `GeneralFunctorFluidProps` object:

!listing htgr/generic-pbr-tutorial/step1.i block=Materials

This object takes pressure and temperature provided as variables to parameters
`pressure` and `T_fluid`, respectively, and computes fluid properties, such as
density and viscosity. Density and viscosity are named `rho` and `mu`.
Note that `T_fluid` is set to a constant value in this input file because
we do not solve the heat equation and therefore have no fluid temperature defined
as a variable.

This object also requires providing functors to the `porosity`, `speed`, and `characteristic_length`
parameters.

Porosity is defined as an auxiliary variable here:

!listing htgr/generic-pbr-tutorial/step1.i block=AuxVariables

and set equal to the `bed_porosity` parameter of 0.39.
`speed` is a functor that is computed automatically by the Navier-Stokes FV action,
and `characteristic_length` is only used for computing Reynolds numbers, which are not
required in Step 1; therefore, we set `characteristic_length = 1` for now.

### Setting up the Thermal-Hydraulics Problem

The thermal-hydraulics problem is set up using the finite volume Navier-Stokes action.
This action is discussed in detail [here](https://mooseframework.inl.gov/source/actions/NSFVAction.html).
The corresponding block in the input file is:

!listing htgr/generic-pbr-tutorial/step1.i block=Modules

Understanding the finite volume Navier-Stokes action is important.
Therefore, each line will be explained.

!listing htgr/generic-pbr-tutorial/step1.i start=compressibility end=porous_medium_treatment

This line indicates that weakly compressible fluid equations are solved. These equations allow the density of the fluid to vary, and the discretization methods assume Mach numbers of less than 0.2.
For compressible flows in reactors, the weakly compressible formulation is the most commonly used equation set.

!listing htgr/generic-pbr-tutorial/step1.i start=porous_medium_treatment end=density

This line activates the porous flow treatment. Porous flow indicates that fluid
and solid share a volume and exchange mass, momentum, and energy in this volume.
This exchange is usually described by correlations. In this input file, no mass, momentum, or energy exchange occurs. The porosity defines how
much of each porous flow element is fluid. The porosity in this input file is defined
as a variable and provided in the line:

!listing htgr/generic-pbr-tutorial/step1.i block=NavierStokesFV start=porosity end=initial_velocity

The names of the density and dynamic viscosity functors need to be provided to the
action:

!listing htgr/generic-pbr-tutorial/step1.i block=NavierStokesFV start=density end=porosity

Note that these functors are defined by the `GeneralFunctorFluidProps` object discussed above.

Initial conditions for the velocity and pressure are defined by the lines:

!listing htgr/generic-pbr-tutorial/step1.i block=NavierStokesFV start=initial_velocity end=inlet_boundaries

Note that, since we solve a pseudo-transient, the initial conditions should be interpreted
as initial guesses of the solution.
We set the initial guess of the velocity to 0 and the initial guess of pressure to $5.4$ MPa.
The initial condition for pressure is mismatched with the outlet pressure to make the problem
slightly harder to solve.

The boundary conditions are set by these lines:

!listing htgr/generic-pbr-tutorial/step1.i block=NavierStokesFV start=inlet_boundaries end=[]

The top boundary is the inlet boundary, where we specify the inlet velocity. The inlet velocity
is $(0, -v_{in})$ where we note that the velocity is downward, leading to the negative sign.
The left and right boundaries are set to slip walls. The bottom boundary is set to a constant pressure outlet.

The relevant values used for substituting the ${variable_name} expressions are computed
at the beginning of the input file:

!listing htgr/generic-pbr-tutorial/step1.i start=outlet_pressure end=[Mesh]

### Checking Mass Conservation

We use postprocessors to compute the inlet and outlet mass flow rates.

!listing htgr/generic-pbr-tutorial/step1.i block=Postprocessors

The `desired_mfr` postprocessor simply takes the `mass_flow_rate` parameter computed
at the top of the input file and prints it to screen. This is the mass flow rate we
want to achieve.

The `inlet_mfr` and `outlet_mfr` are `VolumetricFlowRate` postprocessors. The
`VolumetricFlowRate` allows the computation of velocity weighted
integrals over surfaces. If the `advected_quantity` is denoted by $a$, velocity by
$\vec{v}$, and the normal on the surface by $\vec{n}$, then `VolumetricFlowRate` returns:

!equation
\text{VolumetricFlowRate} = \int\limits_{A} a \vec{v}^T  \vec{n} dA

For $a$ set to density, this is the mass flow rate. We expect all three
postprocessors to be identical.

### Executioner

The executioner is explained in detail [here](https://mooseframework.inl.gov/syntax/Executioner/). For Step 1 we use these specifications:

!listing htgr/generic-pbr-tutorial/step1.i block=Executioner

We run a transient to the `end_time` of 100 seconds. The time steps are selected adaptively based on the number of nonlinear iterations used by the previous timestep. Details on `IterationAdaptiveDT` can be found [here](https://mooseframework.inl.gov/source/timesteppers/IterationAdaptiveDT.html). A maximum timestep of $5$ seconds is used. We use Newton's method to solve the problem and solve the linear problem using lower-upper (LU) decomposition. Relative and absolute convergence tolerances are set to $10^{-6}$.

### Results

Execute `step1.i` by:

!listing
./pronghorn-opt -i step1.i

Execution should take about 10 seconds. An exodus file `step1_out.e` is created.
This file contains the pressure and superficial velocity solutions. These are
constant at $p=5.5$ MPa and $\vec{v}=(0,-1.54191)$ m/s. Since they are not very relevant, they are not plotted here. The three postprocessors at $100$ seconds are:

!listing
desired_mfr = 6.000000e+01
inlet_mfr = -5.999997e+01
outlet_mfr = 5.999997e+01

We conserve mass, since `inlet_mfr` and `outlet_mfr` are identical. The mass flow rate is also very close to what we expect ($60$ kg/s). The small difference orgininates from truncating the decimals of the assumed density when computing the inlet velocity.
