# MSFR Griffin-Pronghorn model

## Conservation of fluid mass and momentum

The MultiApp system is used to separate the neutronics and the fluid dynamics
problems. The fluid system is solved by the subapp and it uses the `run_ns.i`
input files. (Here "ns" is an abbreviation for Navier-Stokes.)

The fluid system includes conservation equations for fluid mass, momentum, and
energy as well as the conservation of delayed neutron precursors.

The conservation of mass is,
\begin{equation}
  \nabla \cdot \rho \vec{u} = 0
\end{equation}
where $\rho$ is the fluid density and $\vec{u}$ is the velocity vector.

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
  + f_{\text{fric},x} + \rho \vec{g} \cdot \hat{x}
\end{equation}
where $u$ is the $x$ component of the velocity, $P$ is the pressure,
$f_{\text{fric},x}$ is the $x$ component of the viscous friction force, and
$\vec{g}$ is the gravity vector.

In this model, gravity will point in the negative $y$-direction so the quantity
$\vec{g} \cdot \hat{x}$ is zero,
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + f_{\text{fric},x}
\end{equation}

Practical simulations require modifications to the momentum equations in order
to model the effects of turbulence without explicitly resolving the turbulent
structures. Here, we will apply the Reynolds-averaging procedure and the
Boussinesq hypothesis so that the effect of turbulent momentum transfer is
modeled with a term analogous to viscous shear,
\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \nu_t \nabla^2 u + f_{\text{fric},x}
\end{equation}
where $\nu_t$ is the eddy viscosity.

Here, an extremely simple turbulence model will be used for the purposes of this
demonstration. A large, uniform, fixed value of the eddy viscosity will be
assumed everywhere.

The viscous friction is treated with two different models for different regions
of the reactor. The bulk of the friction is expected to occur in the heat
exchanger region where there is a large surface area in contact with the salt to
facilitate heat transfer. Rather than explicitly modeling the heat exchanger
geometry, a simple, tunable model will be used,
\begin{equation}
  f_{\text{fric},x} = -C_q u | u |
\end{equation}
where $C_q$ is a tunable coefficient.

A typical viscous friction model could be used for the regions outside of the
heat exchanger. However, the viscous effects will be negligible due to the
large, uniform eddy viscosity model used here. Consequently, the viscous force
will be neglected outside of the heat exchanger,
\begin{equation}
  f_{\text{fric},x} = 0
\end{equation}

By convention, we must collect all of the terms on one side of the equation.
This gives the form that is implemented for the MSFR model,
\begin{equation}
  \nabla \cdot \rho \vec{u} u + \frac{\partial}{\partial x} P
  - \nu_t \nabla^2 u - f_{\text{fric},x} = 0
  \label{eq:x_mom}
\end{equation}

The first term in [eq:x_mom]---the advection of momentum---is handled with the
kernel,

!listing /msfr/steady/run_ns.i block=FVKernels/u_advection

The second term---the pressure gradient---is handled with,

!listing /msfr/steady/run_ns.i block=FVKernels/u_pressure

The third term---the Reynolds stress---with,

!listing /msfr/steady/run_ns.i block=FVKernels/u_turb_viscosity

Recall that the fourth term, the viscous force, is treated with a unique model
for the heat exchanger region. Consequently, the `block` parameter is used to
restrict the relevant kernel to the heat exchanger,

!listing /msfr/steady/run_ns.i block=FVKernels/friction_hx_x

This model does not include a friction force for the other blocks so no kernel
needs to be specified for those blocks.

The conservation of momentum in the $y$-direction is analogous, but it also
includes the Boussinesq approximation in order to capture the effect of
buoyancy. Note that this extra term is needed because of the approximation that
the fluid density is uniform and constant,
\begin{equation}
  \nabla \cdot \rho \vec{u} v + \frac{\partial}{\partial y} P
  - \nu_t \nabla^2 v - f_{\text{fric}, y}
  - \rho \alpha \vec{g} \left( T - T_0 \right) = 0
\end{equation}
where $\alpha$ is the expansion coefficient, $T$ is the fluid temperature, and
$T_0$ is a reference temperature value.

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
and $Q_q$ is the volumetric heat generation rate.

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

The heat generation due to nuclear reactions is computed by the neutronics
solver, and this distribution will be used directly in the $Q_q$ term. The
effect of the heat exchanger will also be included in the $Q_q$ term as a
volumetric heat loss per the model,
\begin{equation}
  Q_q = -\alpha (T - T_\text{ambient})
\end{equation}
where $\alpha$ is a coefficient (equal to the surface area density times the
heat transfer coefficient) and $T_\text{ambient}$ is the
temperature of the coolant on the secondary side of the heat exchanger.

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

The third term---heat source and loss---is covered by two kernels. First, the
nuclear heating computed by the neutronics solver is included with,

!listing /msfr/steady/run_ns.i block=FVKernels/heat_src

And second, the heat loss through the heat exchanger is implemented with the
kernel,

!listing /msfr/steady/run_ns.i block=FVKernels/heat_sink

## Neutronics

With Griffin, the process of converting the basic conservation equations into
MOOSE variables and kernels is automated with the `TransportSystems` block:

!listing /msfr/steady/run_neutronics.i block=TransportSystems

Here we are specifying an eigenvalue neutronics problem using 6 energy groups
(`G = 6`) solved via the diffusion approximation with a continuous finite
element discretization scheme (`scheme = CFEM-Diffusion`).

Note the `external_dnp_variable = 'dnp'` parameter. This is a special option
needed for liquid-fueled MSRs which signals that the conservation equations for
the delayed neutron precursors will be handled "externally" from the default
Griffin implementation which assumes that the precursors do not move. This
parameter is referencing the `dnp` `AuxVariable` which is defined as,

!listing /msfr/steady/run_neutronics.i block=AuxVariables/dnp

Note that this is an array auxiliary variable with 6 components, corresponding
to the 6 delayed neutron precursor groups used here.

Support within the Framework for array variables is somewhat limited. For
example, not all of the multiapp transfers work with array variables, and the
Navier-Stokes module does not include the kernels that are needed to advect an
array variable. For this reason, there is also a separate AuxVariable for each
of the delayed neutron precursors. For example,

!listing /msfr/steady/run_neutronics.i block=AuxVariables/c1

The `run_ns.i` subapp is responsible for computing the precursor distributions,
and the distributions are transferred from the subapp to the main app by blocks
like this one,

!listing /msfr/steady/run_neutronics.i block=Transfers/c1

The values are then copied from the `c1`, `c2`, etc. variables into the `dnp`
variable by this aux kernel:

!listing /msfr/steady/run_neutronics.i block=AuxKernels/build_dnp

Also note that solving the neutronics problem requires a set of multigroup
cross sections. Generating cross sections is a topic that is left outside the
scope of this example. A set has been generated for the MSFR problem and stored
in the repository using Griffin's XML format. These cross sections are included
by the blocks,

!listing /msfr/steady/run_neutronics.i block=Materials
