# MSFR Griffin-Pronghorn model

## Conservation of fluid mass and momentum

The MultiApp system is used to separate the neutronics and the fluid dynamics
problems. The fluid system is solved by the subapp and it uses the `run_ns.i`
input files. (The phrase "ns" is an abbreviation for Navier-Stokes.)

The fluid system includes conservation equations for fluid mass, momentum, and
energy as well as the conservation of delayed neutron precursors.

The conservation of mass is,
\begin{equation}
  \nabla \cdot \rho \vec{u} = 0
\end{equation}

Here the system will be simplified by modeling the flow as incompressible.  (The
effect of Buoyancy will be re-introduced later with the Boussinesq
approximation.)  The simplified conservation of mass is then given by,
\begin{equation}
  \nabla \cdot \vec{u} = 0
\end{equation}

This conservation is expressed by the `FVKernels/mass` kernel:

!listing /msfr/steady/run_ns.i block=FVKernels/mass

(Note that this kernel uses `variable = pressure` even though pressure does not
appear in the mass conservation equation. This is an artifact of the way systems
of equations are described in MOOSE. Since the number of equations must
correspond to the number of non-linear variables, we are essentially using the
variables to "name" each equation. The momentum equations will be named by the
corresponding velocity variable. That just leaves the pressure variable for
naming the mass equation, even though pressure does not appear in the mass
equation.)

This system also includes the conservation of momentum in the $x$-direction. A
fairly general form of the steady-state condition is,
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \nabla \cdot \underline{\tau} \cdot \hat{x}
  + \rho \vec{g} \cdot \hat{x}
\end{equation}

In this model, gravity will point in the negative $y$-direction so the quantity
$\vec{g} \cdot \hat{x}$ is zero,
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \nabla \cdot \underline{\tau} \cdot \hat{x}
\end{equation}

Practical simulations require modifications to the momentum equations in order
to model the effects of turbulence without explicitly resolving the turbulent
structures. Here, we will apply the Reynolds-averaging procedure and the
Boussinesq hypothesis so that the effect of turbulent momentum transfer is
modeled with a term analogous to viscous shear,
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \nabla \cdot \underline{\tau} \cdot \hat{x}
  + \nu_t \nabla^2 u
\end{equation}

Here, an extremely simple turbulence model will be used for the purposes of this
demonstration. A large, uniform, fixed value of the eddy viscosity will be
assumed everywhere. In practice, this eddy viscosity will be far greater than
the molecular viscosity so we can neglect the molecular viscous forces.
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \nu_t \nabla^2 u
\end{equation}

Finally, we must collect all of the terms on one side of the equation. This
gives the form that is implemented for the MSFR model,
\begin{equation}
  \nabla \cdot \rho \vec{u} u + \frac{\partial}{\partial x} P
  - \nu_t \nabla^2 u = 0
  \label{eq:x_mom}
\end{equation}

The first term in [eq:x_mom]---the advection of momentum---is handled with the
kernel,

!listing /msfr/steady/run_ns.i block=FVKernels/u_advection

The second term---the pressure gradient---is handled with,

!listing /msfr/steady/run_ns.i block=FVKernels/u_pressure

And the third term---the Reynolds stress---with,

!listing /msfr/steady/run_ns.i block=FVKernels/u_turb_viscosity

If there are three conservation
equations---mass, $x$-momentum, $y$-momentum---then there must be three
non-linear variables.

The conservation of momentum in the $y$-direction is analogous, but it also
includes the Boussinesq approximation in order to capture the effect of
buoyancy. Note that this extra term is needed because of the approximation that
the fluid density is uniform and constant,
\begin{equation}
  \nabla \cdot \rho \vec{u} v + \frac{\partial}{\partial y} P
  - \nu_t \nabla^2 v - \rho \alpha \vec{g} \left( T - T_0 \right) = 0
\end{equation}

For each kernel describing the $x$-momentum equation, there is a corresponding
kernel for the $y$-momentum equation. The additional Boussinesq kernel for this
equation is,

!listing /msfr/steady/run_ns.i block=FVKernels/v_buoyancy

## Conservation of fluid energy

The steady-state conservation of energy can be expressed as,
\begin{equation}
  \nabla \cdot \rho h \vec{u} - \nabla \cdot \lambda \nabla T = Q_q
\end{equation}
where $h$ is the fluid specific enthalpy, $\lambda$ is the thermal conductivity,
$T$ is the temperature, and $Q_q$ is the volumetric heat generation rate.

Here it is expected that the energy released from nuclear reactions will be very
large compared to pressure work terms. Consequently, we will use the simplified form,
\begin{equation}
  \nabla \cdot \rho c_p T \vec{u} - \nabla \cdot \lambda \nabla T = Q_q
\end{equation}

As with the momentum equations, a practical solver requires a model for the
turbulent transport of energy,
\begin{equation}
  \nabla \cdot \rho c_p T \vec{u} - \nabla \cdot \lambda \nabla T
  - \nabla \cdot \rho c_p \epsilon_q \nabla T = Q_q
\end{equation}
where $\epsilon_q$ is the eddy diffusivity for heat. It is related to the eddy
diffusivity for momentum (i.e. the kinematic eddy viscosity) as
$\text{Pr}_t = \nu_t / \epsilon_q$ where $\text{Pr}_t$ is the turbulent
Prandtl number.

As with the molecular viscosity in the momentum equations, the simple
turbulence model used here will overwhelm the thermal conductivity. Neglecting
that term and moving the heat generation to the left-hand-side of the equation
gives,
\begin{equation}
  \nabla \cdot \rho c_p T \vec{u} - \nabla \cdot \rho c_p \epsilon_q \nabla T
  - Q_q = 0
\end{equation}

Note that all material properties, including $\rho$ and $c_p$, are assumed
constant. It will therefore be convenient to move the $\rho c_p$ factors outside
of the divergence operators and divide the entire equation by that factor,
\begin{equation}
  \nabla \cdot T \vec{u} - \nabla \cdot \epsilon_q \nabla T
  - \frac{1}{\rho c_p} Q_q = 0
  \label{eq:energy}
\end{equation}

[eq:energy] is the final equation that is implemented in this model. The first
term---energy advection---is captured by the kernel,

!listing /msfr/steady/run_ns.i block=FVKernels/heat_advection

The second term---the turbulent diffusion of heat---corresponds to the kernel,

!listing /msfr/steady/run_ns.i block=FVKernels/heat_turb_diffusion
