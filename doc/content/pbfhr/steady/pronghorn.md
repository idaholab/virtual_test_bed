# Pronghorn thermal hydraulics steady state simulation

Pronghorn is the thermal hydraulics solver we use to simulate fluid flow and conjugate heat transfer in the FHR
core. In the same input file, we model the heat transfer in the solid phase in the core and heat conduction
in the solid components around the core, for a total of five equations: conservation of mass, x- and y-momentum (in RZ),
fluid and solid energy.

We could have used another [MultiApp](https://mooseframework.inl.gov/syntax/MultiApps/index.html) setup to compute the solid temperature, with the
justification that it evolves on a longer timescale so it takes longer to reach steady state. However, the cost of
the more expensive full-core solves and of the additional fluid flow solves, while the solid temperature is converging,
is sufficiently offset by not needing to iterate the coupling between two applications. The workflow is also generally
simplified.

We are using newly implemented finite volume capabilities in MOOSE to model all these physics. We use an
incompressible approximation for the fluid flow, with a Boussinesq approximation to model buoyancy. There are
various closures used in the pebble bed for the heat transfer coefficients, the drag models, which are
detailed in the [Pronghorn manual](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_24425.pdf).

We first define in the input file header physical quantities such as the pebble geometry, the material compositions as well as some constant material properties.

!listing /pbfhr/steady/ss1_combined.i start=blocks_fluid =  end=power_density =

We also define a few global parameters that will be added to every block that may use them. This is
done to reduce the length of the input file and improve its readability. Once the [Actions](https://mooseframework.inl.gov/source/actions/Action.html) syntax is implemented, this will be automatically streamlined for the user.

!listing /pbfhr/steady/ss1_combined.i block=GlobalParams

## Mesh and geometry

The mesh input is standardized across MOOSE applications. The [Mesh](https://mooseframework.inl.gov/application_usage/mesh_block_type.html) block is similar to the
one we saw for Griffin. We load a different mesh file for this application. The mesh for a CFD simulation should be
as aligned as possible to the flow lines to avoid false diffusion. The CFD
mesh should also be as orthogonal as possible as there is no skewness correction implemented.

!listing /pbfhr/steady/ss1_combined.i block=Mesh

The geometry is also specified in the `WallDistance` model, which is used to account for the presence
of the wall in material closures. For the Mk1-FHR we use a `WallDistanceAngledCylindricalBed` which
is specific to the shape of this core. This is defined in the [UserObjects](https://mooseframework.inl.gov/syntax/UserObjects/) block.

!listing /pbfhr/steady/ss1_combined.i block=UserObjects/wall_dist

## Variables

We define the fluid variables, the two velocity components, pressure and temperature over
the active region and the pebble reflector, the two fluid flow regions. The model may evolve in the future to model flow in the inner and outer reflectors. We use INSFV-
and PINSFV-specific (stands Porous flow Incompressible Navier Stokes Finite Volume) variables
for the fluid, such as [INSFVPressureVariable](https://mooseframework.inl.gov/source/variables/INSFVPressureVariable.html). These variables
types are `CONSTANT` `MONOMIAL`, which means that they are constant over elements. This is the regular discretization for finite volume variables. The solid temperature
is defined in the entire domain, as the solid phase temperature in the pebble bed, and as the regular solid temperature in the rest of the core.

!listing /pbfhr/steady/ss1_combined.i block=Variables

The fluid system includes conservation equations for fluid mass, momentum, and
energy. The conservation of energy for the solid / solid phase is solved simultaneously.

## Conservation of fluid mass

The conservation of mass is,
\begin{equation}
  \nabla \cdot \rho \epsilon \vec{u} = 0
\end{equation}

with $\rho$ the density of the fluid, $\epsilon$ the porosity of the homogenized medium
and $u$ the interstitial velocity. We reformulate this equation in terms of the
superficial or Darcy velocity $\vec{u}_D = \epsilon \vec{u}$.

\begin{equation}
  \nabla \cdot \rho \vec{u}_D = 0
\end{equation}

Here the system will be simplified by modeling the flow as incompressible. (The
effect of buoyancy will be re-introduced later with the Boussinesq
approximation.)  The simplified conservation of mass is then given by,
\begin{equation}
  \nabla \cdot \vec{u}_D = 0
\end{equation}

This conservation is expressed by the `FVKernels/mass` kernel:

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/mass

(Note that this kernel uses `variable = pressure` even though pressure does not
appear in the mass conservation equation. This is an artifact of the way systems
of equations are described in MOOSE. Since the number of equations must
correspond to the number of non-linear variables, we are essentially using the
variables to "name" each equation. The momentum equations will be named by the
corresponding velocity variable. That just leaves the pressure variable for
naming the mass equation, even though pressure does not appear in the mass
equation.)

## Conservation of fluid momentum

This system also includes the conservation of momentum in the $x$-direction.
We use a transient simulation to reach steady state, and the porous media Navier Stokes
equation can be written as:
\begin{equation}
  \rho \epsilon \dfrac{\partial u}{\partial t} + \nabla \cdot \rho \epsilon \vec{u} u =
  - \epsilon \frac{\partial}{\partial x} P
  + \nabla \cdot \underline{\tau} \cdot \hat{x}
  + \epsilon \rho \vec{g} \cdot \hat{x}
  - W_x \rho u
\end{equation}

In this model, gravity will point in the negative $y$-direction so the quantity
$\vec{g} \cdot \hat{x}$ is zero for $u$, the x-direction velocity,
\begin{equation}
  \rho \epsilon \dfrac{\partial u}{\partial t} + \nabla \cdot \rho \epsilon \vec{u} u =
  - \epsilon \frac{\partial}{\partial x} P
  + \nabla \cdot \underline{\tau} \cdot \hat{x} - W_x \rho u
\end{equation}

The effective viscosity is the Brinkman viscosity. There is insufficient agreement in the literature about whether
this term should be considered and its magnitude. The study on which this model is based neglected it [!citep](novak2021).
We simply used the regular fluid viscosity as a placeholder for future refinements.

The drag term $-W_x \rho u$ represents the interphase drag. It accounts for both viscous and inertial effects.
It can be anisotropic in solid components such as the reflector and isotropic in the pebble bed. It's a superposition
of a linear and quadratic in velocity terms, which are dominant in low/high velocity regions respectively.
A common correlation for the pebble bed is to use an Ergun drag coefficient, detailed in the [Pronghorn manual](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_24425.pdf).
To model the outer reflector using a porous medium, we would need to tune the anisotropic drag coefficient using
CFD simulations.

Finally, we must collect all of the terms on one side of the equation and express the
equation in terms of the superficial velocity. This
gives the form that is implemented for the FHR model,
\begin{equation}
  \rho \dfrac{\partial u_D}{\partial t} + \nabla \cdot \rho \vec{u}_D \dfrac{u_D}{\epsilon} +
   \epsilon \frac{\partial}{\partial x} P
  - \nu \nabla^2 \dfrac{u_D}{\epsilon} + W_x \dfrac{\rho u_D}{\epsilon} = 0
  \label{eq:x_mom}
\end{equation}

The first term in [eq:x_mom]---the momentum time derivative---is input with the time derivative kernel:

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/vel_x_time

The second term---the advection of momentum---is handled by a [PINSFVMomentumAdvection](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumAdvection.html) kernel

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/vel_x_advection

The third term---the pressure gradient---is handled by a [PINSFVMomentumPressure](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumPressure.html) kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/u_pressure

The third term---the effective diffusion---with a [PINSFVMomentumDiffusion](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumDiffusion.html) kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/vel_x_viscosity

And the fourth term--the friction term---with a [PINSFVMomentumFriction](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumFriction.html) kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/u_friction

The conservation of momentum in the $y$-direction is analogous, but it also
includes the Boussinesq approximation in order to capture the effect of
buoyancy. Note that this extra term is needed because of the approximation that
the fluid density is uniform and constant,
\begin{equation}
  \rho \dfrac{\partial v_D}{\partial t} + \nabla \cdot \rho \vec{u}_D \dfrac{v_D}{\epsilon} + \epsilon \frac{\partial}{\partial y} P
  - \nu \nabla^2 \dfrac{v_D}{\epsilon} - \epsilon \rho \alpha_b \vec{g} \left( T - T_0 \right) -\epsilon \rho g + W_y \dfrac{\rho v_D}{\epsilon} = 0
\end{equation}

For each kernel describing the $x$-momentum equation, there is a corresponding
kernel for the $y$-momentum equation. The additional Boussinesq and gravity kernels for this
equation are,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/buoyancy_boussinesq FVKernels/gravity

## Conservation of fluid energy

The conservation of the fluid energy can be expressed as,
\begin{equation}
  \rho \dfrac{\partial \epsilon h}{\partial t} + \nabla \cdot \rho \epsilon h \vec{u} - \nabla \cdot \kappa_f \nabla T_f = h_{fs} (T_s - T_f)
  \label{eq:energy}
\end{equation}
where $h$ is the fluid specific enthalpy, $\kappa_f$ is the fluid effective thermal conductivity,
$T_f$ is the fluid temperature, $T_s$ the solid temperature, and $h_{fs}$ is the heat
transfer coefficient between the two phases. The heat generation term is featured in the
solid phase energy equation, and heat is transfered by convection between the two phases.

We neglect the work terms of gravity, friction and the buoyancy force compared to the heat generation.
It is also expected that the energy released from nuclear reactions will be very
large compared to pressure work terms. Consequently, we will use the simplified form,
\begin{equation}
  \nabla \cdot \rho h \vec{u} \approx \nabla \cdot \rho c_p T \vec{u}
\end{equation}

The effective thermal diffusivity represents both the molecular diffusion and thermal dispersion in
the fluid. We use a closure with a linear Peclet number dependence valid at low Reynolds number (<800).
\begin{equation}
  \kappa_f = \epsilon k_f + C_0 k_f Pe
\end{equation}

The interphase heat transfer coefficient represents convective heat transfer between the solid and fluid phase.
We use the Wakao correlation [!citep](wakao1979), detailed in the [Pronghorn manual](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_24425.pdf) and commonly used in pebble-bed
reactor analysis.

The first term of [eq:energy]---the energy time derivative---is captured by the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_fluid_time

The second term of [eq:energy]---energy advection---is expressed by,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_fluid_advection

The third term---the effective diffusion of heat---corresponds to the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_fluid_conduction

The final term---the fluid-solid heat convection---is added by the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_solid_to_fluid


## Conservation of solid energy

The conservation of energy in the solid phase may be written in terms of the temperature as:
\begin{equation}
  \rho (1-\epsilon) c_{ps} \dfrac{\partial T_s}{\partial t} - \nabla \cdot \kappa_s \nabla T_s = h_{fs} (T_f - T_s) + \dot{Q}
  \label{eq:solid_energy}
\end{equation}

with $\kappa_s$ the effective solid thermal conductivity in the pebble bed, and the solid thermal conductivity
in the other solid parts and $\dot{Q}$ the heat source.

Effective solid diffusion accounts for

- conduction inside pebbles and radiation between pebbles across a transparent fluid
- conduction inside pebbles and conduction in the fluid between pebbles
- conduction inside pebbles and conduction between pebbles at contact areas


Each effect is represented by a separate correlation, lumped together in the effective thermal diffusivity.


The first term of [eq:solid_energy]---the energy time derivative---is captured by the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_solid_time

The second term---the effective diffusion and diffusion of heat---corresponds to the kernels,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_solid_core_conduction block=FVKernels/temp_solid_conduction

The third term---the fluid-solid heat convection---is added by the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_fluid_to_solid

The final term---the heat source---is added by the kernel,

!listing /pbfhr/steady/ss1_combined.i block=FVKernels/temp_solid_source


## Auxiliary system and initialization

We define two auxiliary variables in this simulation: porosity and the power distribution. While porosity is
intrinsically more of a material property for the homogenized medium, we may need to compute its gradient on cell faces in the future versions
of the models, something which is currently not possible with material properties. Power distribution is an
auxiliary field that is passed on from the neutronics simulation, and used to compute the energy conservation
in the solid phase.

!listing /pbfhr/steady/ss1_combined.i block=AuxVariables

There are numerous options to initialize a [Variable](https://mooseframework.inl.gov/syntax/Variables/) or an [AuxVariable](https://mooseframework.inl.gov/syntax/AuxVariables/) in MOOSE. The `initial_condition` can
be set directly in the relevant [Variables](https://mooseframework.inl.gov/syntax/Variables/) block. It can also be set using an initial condition, [ICs](https://mooseframework.inl.gov/syntax/ICs/index.html), block.
The velocity variables have to be initialized to a non-zero value, to avoid numerical
issues with advection at 0 velocity. We initialize in this block the power distribution, which will be overriden
by the power distribution provided by Griffin, and the solid temperature. The solid temperature can take a long
time to relax to its steady state value, so a closer reasonable flat guess can save computation time.

!listing /pbfhr/steady/ss1_combined.i block=ICs

Another important part of the simulation initialization is the viscosity ramp-down. It is very difficult to
initialize a high-Reynolds number fluid simulation from an initial guess and let it relax to the steady state
simulation. To avoid those numerical difficulties, we initialize the simulation with a very high viscosity, making
the flow very slow and easy to solve for. We then ramp-down viscosity to its value from [!citep](serrano2013) over a few
seconds. This is not particularly expensive considering the length of the relaxation pseudo-transient. The
ramp down is performed using a piecewise linear function and a functionalized material property.

!listing /pbfhr/steady/ss1_combined.i block=Functions/mu_func

## Boundary conditions

Pronghorn finite-volume currently does not have an [Actions](https://mooseframework.inl.gov/source/actions/Action.html) system so the boundary conditions have to be explicitly
defined for each equation, rather than simply indicate which boundary is a wall, inflow or outflow boundary.

We first define the inlet of the core. We specify the velocity of the fluid at the inlet and its temperature. In
this simplified model of the Mk1-FHR, there is no flow coming from the inner reflector. The velocity and
temperature are currently set to a constant value, but will be coupled in the future to a SAM simulation of the
primary loop.

!listing /pbfhr/steady/ss1_combined.i block=FVBCs/inlet_vel_y FVBCs/inlet_temp_fluid

Since the model does not include flow in the inner and outer reflector, we define wall boundary conditions on these
surfaces. We chose free-slip boundary conditions as the friction on the fluid is heavily dominated by the friction
with the pebbles, so wall friction may be neglected.

!listing /pbfhr/steady/ss1_combined.i block=FVBCs/free-slip-wall-x FVBCs/free-slip-wall-x

The outflow boundary condition is a pressure boundary condition. Since this model does not include flow in the
outer reflector, all the flow goes through the defueling chute. The velocity is very high in this region, causing a
large pressure drop. This is a known result of the simplified model. This boundary condition is a fully developed
flow boundary condition. It may only be used sufficiently far from modifications of the flow path.

!listing /pbfhr/steady/ss1_combined.i block=FVBCs/outlet_p

Finally, we define the boundary conditions for the solid temperature. They are implicitly defined to be zero flux
boundary conditions on the center, top and bottom surfaces. For the center, this represents the axi-symmetry of
the model. For the top and bottom surfaces, this is equivalent to perfect insulation. Future evolutions of the model
will distinguish between the pebble bed solid phase and top and bottom surfaces of the core regions. Finally, on the outer
cylindrical boundary of the model, we define a fixed temperature boundary condition, as an approximation of the outer environment.

!listing /pbfhr/steady/ss1_combined.i block=FVBCs/outer

## Material properties

There are four main types of [materials](https://mooseframework.inl.gov/moose/syntax/Materials/) that may be found in Pronghorn input files:

- solid material properties

- closure relations ($\kappa_f$, $\kappa_f$, $\alpha$)

- variable materials (`VarMats`)

- fluid properties


### Solid material properties

The properties of the firebrick around the core are specified directly, using an [ADGenericConstantMaterial](https://mooseframework.inl.gov/source/materials/GenericConstantMaterial.html), neglecting their temperature dependence.

!listing /pbfhr/steady/ss1_combined.i block=Materials/firebrick_properties

The properties of the other solid phases are obtained through volumetric mixing. The base material
properties of each type of graphite, UO2 and other materials are defined first:

!listing /pbfhr/steady/ss1_combined.i block=UserObjects/graphite UserObjects/pebble_graphite UserObjects/pebble_core UserObjects/UO2 UserObjects/pyc UserObjects/buffer UserObjects/SiC UserObjects/solid_flibe

Then these properties are mixed using `CompositeSolidProperties`. We specify the volumetric fraction of
each material and how the properties should be combined. The default option is simply volume
averaging. The Chiew correlation is used for mixing thermal conductivities in the fuel matrix in the
pebble. Note that this step is obtaining macroscopic phase solid properties, the temperature inside the pellet
is resolved later on using a MultiApp. The effective thermal conductivity is determined by a closure
relation, further detailed below.

!listing /pbfhr/steady/ss1_combined.i block=UserObjects/TRISO UserObjects/fuel_matrix UserObjects/pebble UserObjects/inner_reflector

Finally, these materials, defined as user objects, are placed in each subdomain of the mesh in the [Materials](https://mooseframework.inl.gov/moose/syntax/Materials/) block.

!listing /pbfhr/steady/ss1_combined.i block=Materials/solid_fuel_pebbles Materials/solid_blanket_pebbles Materials/plenum_and_OR Materials/IR Materials/barrel_and_vessel

### Closure relations

The closure relations used for friction and effective thermal diffusivities are documented in the [Pronghorn manual](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_24425.pdf).

!listing /pbfhr/steady/ss1_combined.i block=Materials/alpha Materials/drag Materials/kappa Materials/kappa_s

### Variable materials

Variable materials or `VarMats` are simply constructs that hold a copy of the variables as
material properties. This makes it easier to formulate kernels in terms of quantities based on the
primary variables. For example, the fluid energy equation is specified in terms of $\rho c_{pf} T_f$
instead of $T_f$. Similarly the momentum advection kernels are specified in terms of $\rho u$,
the momentum, instead of $u$, the velocity variable.

!listing /pbfhr/steady/ss1_combined.i block=Materials/ins_fv

### Fluid properties

The fluid properties are similar to variable materials but are specific to Pronghorn. They
act as an aggregator of both materials properties and variables and allow the computation of
closure inputs such as the Reynolds and Prandtl number.

!listing /pbfhr/steady/ss1_combined.i block=FluidProperties

!listing /pbfhr/steady/ss1_combined.i block=Materials/fluidprops

## Solving the equations

The [Executioner](https://mooseframework.inl.gov/syntax/Executioner/index.html) block defines how the non-linear system will be solved. Since this is a transient problem,
we are using a [Transient](https://mooseframework.inl.gov/moose/source/executioners/Transient.html) executioner. Pronghorn makes use of automatic differentiation, more information
[here](https://mooseframework.inl.gov/magpie/automatic_differentiation/index.html), to compute an exact Jacobian,
so we make use of the Newton method to solve the non-linear system.  The `petsc_options_iname/ivalue` specify a reasonably scaling
pre-conditioner. The factor shift avoids numerical issues when there are zeros in the diagonal of the Jacobian,
for example when using Lagrange multipliers to enforce constraints, which some iterations of this model used.
MOOSE defaults to GMRES for the linear solver, and we increase the size of the base used as using too small a Krylov
vector base is a common issue.

We then specify the solver tolerances. These may be loosened to obtain a faster solve. They should initially be set
fairly small to obtain a tight convergence, then relaxed to improve performance.

Finally we set the time parameters for the simulation. We choose a very large runtime since the bricks around the core
are very slow to heat up. We use an adaptive time-stepper to increase the time step over the course of the simulation.
Because we are using an implicit scheme, we can take very large time steps and still have a stable simulation.
An alternative strategy is to artificially decrease the specific heat capacity of the solid materials for the steady state solve.

!listing /pbfhr/steady/ss1_combined.i block=Executioner

## MultiApp Coupling

We couple the thermal-hydraulics simulation with simulation of the pebbles spread throughout the core. The solid
phase temperature is then the boundary condition to a heat conduction problem that allows us to examine the
temperature profile in fueled and reflector pebbles. The sub-application is defined using the [MultiApps](https://mooseframework.inl.gov/syntax/MultiApps/index.html) block.

!listing /pbfhr/steady/ss1_combined.i block=MultiApps

Pronghorn is running as a sub-application of Griffin. As such it does not need to handle transfers with Griffin, as
they are defined in Griffin's input file. We transfer the power distribution, previously received from Griffin,
and the solid phase temperature in the pebble bed.

!listing /pbfhr/steady/ss1_combined.i block=Transfers

## Outputs

We first define a few postprocessors to:

- help quantify the convergence of our mesh.

!listing /pbfhr/steady/ss1_combined.i block=Postprocessors/max_Tf Postprocessors/max_vy Postprocessors/pressure_in

- pass inlet and outlet conditions to a future SAM model of the primary loop

!listing /pbfhr/steady/ss1_combined.i block=Postprocessors/pressure_in Postprocessors/T_flow_out

- examine conservation of mass

!listing /pbfhr/steady/ss1_combined.i block=Postprocessors/mass_flow_out

- examine conservation of energy

!listing /pbfhr/steady/ss1_combined.i block=Postprocessors/outer_heat_loss Postprocessors/flow_in_m Postprocessors/flow_out Postprocessors/core_balance


We then define an [Exodus](https://mooseframework.inl.gov/source/outputs/Exodus.html) output. This will have the multi-dimensional distributions of the quantities Pronghorn
solved for: the fluid velocities, the pressure and the temperature fields. We also include the material properties
to help us understand the behavior of the core.

!listing /pbfhr/steady/ss1_combined.i block=Outputs
