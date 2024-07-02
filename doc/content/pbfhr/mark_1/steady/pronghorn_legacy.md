## Kernel syntax (legacy) for the conservation of fluid mass

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

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/mass

(Note that this kernel uses `variable = pressure` even though pressure does not
appear in the mass conservation equation. This is an artifact of the way systems
of equations are described in MOOSE. Since the number of equations must
correspond to the number of non-linear variables, we are essentially using the
variables to "name" each equation. The momentum equations will be named by the
corresponding velocity variable. That just leaves the pressure variable for
naming the mass equation, even though pressure does not appear in the mass
equation.)

## Kernel syntax (legacy) for the conservation of fluid momentum

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

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/vel_x_time

The second term---the advection of momentum---is handled by a [PINSFVMomentumAdvection](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumAdvection.html) kernel

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/vel_x_advection

The third term---the pressure gradient---is handled by a [PINSFVMomentumPressure](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumPressure.html) kernel,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/u_pressure

The third term---the effective diffusion---with a [PINSFVMomentumDiffusion](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumDiffusion.html) kernel,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/vel_x_viscosity

And the fourth term--the friction term---with a [PNSFVMomentumFriction](https://mooseframework.inl.gov/source/fvkernels/PINSFVMomentumFriction.html) kernel,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/u_friction

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

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/buoyancy_boussinesq FVKernels/gravity

## Kernel syntax (legacy) for the conservation of fluid energy

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

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/temp_fluid_time

The second term of [eq:energy]---energy advection---is expressed by,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/temp_fluid_advection

The third term---the effective diffusion of heat---corresponds to the kernel,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/temp_fluid_conduction

The final term---the fluid-solid heat convection---is added by the kernel,

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVKernels/temp_solid_to_fluid

## Legacy explicit boundary conditions syntax

We first define the inlet of the core. We specify the velocity of the fluid at the inlet and its temperature. In
this simplified model of the Mk1-FHR, there is no flow coming from the inner reflector. The velocity and
temperature are currently set to a constant value, but will be coupled in the future to a SAM simulation of the
primary loop.

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVBCs/inlet_vel_y FVBCs/inlet_temp_fluid

Since the model does not include flow in the inner and outer reflector, we define wall boundary conditions on these
surfaces. We chose free-slip boundary conditions as the friction on the fluid is heavily dominated by the friction
with the pebbles, so wall friction may be neglected.

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVBCs/free-slip-wall-x FVBCs/free-slip-wall-x

The outflow boundary condition is a pressure boundary condition. Since this model does not include flow in the
outer reflector, all the flow goes through the defueling chute. The velocity is very high in this region, causing a
large pressure drop. This is a known result of the simplified model. This boundary condition is a fully developed
flow boundary condition. It may only be used sufficiently far from modifications of the flow path.

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=FVBCs/outlet_p

## Material properties

### Variable materials

Variable materials or `VarMats` are simply constructs that hold a copy of the variables as
material properties. This makes it easier to formulate kernels in terms of quantities based on the
primary variables. For example, the fluid energy equation is specified in terms of $\rho c_{pf} T_f$
instead of $T_f$. Similarly the momentum advection kernels are specified in terms of $\rho u$,
the momentum, instead of $u$, the velocity variable.

!listing /pbfhr/mark1/steady/legacy/ss1_combined.i block=Materials/ins_fv
