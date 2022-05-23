## Legacy explicit syntax for mass equation id=legacy_pgh_mass

This conservation is expressed by the `FVKernels/mass` kernel:

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/mass

(Note that this kernel uses `variable = pressure` even though pressure does not
appear in the mass conservation equation. This is an artifact of the way systems
of equations are described in MOOSE. Since the number of equations must
correspond to the number of non-linear variables, we are essentially using the
variables to "name" each equation. The momentum equations will be named by the
corresponding velocity variable. That just leaves the pressure variable for
naming the mass equation, even though pressure does not appear in the mass
equation.)

## Legacy explicit syntax for momentum equation id=legacy_pgh_momentum

The first term in [eq:x_mom]---the advection of momentum---is handled with the
kernel,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/u_advection

The second term---the pressure gradient---is handled with,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/u_pressure

The third and fourth term---the Reynolds Stress and the Viscous Tensor---with,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/u_turbulent_diffusion_rans FVKernels/u_molecular_diffusion

The definition of the mixing length is handled with,

!listing msr/msfr/steady/legacy/run_ns.i block=AuxKernels/mixing_len

Recall that the fifth term, the viscous force, is treated with a unique model
for the heat exchanger region. Consequently, the `block` parameter is used to
restrict the relevant kernel to the heat exchanger,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/friction_hx_x

This model does not include a friction force for the other blocks so no kernel
needs to be specified for those blocks.

The conservation of momentum in the $y$-direction is analogous, but it also
includes the Boussinesq approximation in order to capture the effect of
buoyancy and a body force in the pump region. Note that the Boussinesq term  is
needed because of the approximation that the fluid density is uniform and
constant,

\begin{equation}
  \nabla \cdot \rho \vec{u} v + \frac{\partial}{\partial y} P
  - \left( \mu + \mu_t \right) \nabla^2 v - f_{\text{fric}, y}
  - f_{\text{pump}} - \rho \alpha \vec{g} \left( T - T_0 \right) = 0
\end{equation}

where $f_{\text{pump}}$ is the pump head driving the flow, $\alpha$ is the
expansion coefficient, $T$ is the fluid temperature, and $T_0$ is a reference
temperature value. The pump head is tuned such that the imposed mass flow rate
is ~18500 kg/s.

For each kernel describing the $x$-momentum equation, there is a corresponding
kernel for the $y$-momentum equation. The additional Boussinesq kernel and the
pump kernel for this equation are,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/v_buoyancy

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/pump


Boundary conditions include standard velocity wall functions at the walls to
account for the non-linearity of the velocity in the boundary layer given the
coarse mesh and symmetry at the center axis of the MSFR,

!listing msr/msfr/steady/legacy/run_ns.i block=FVBCs

Auxkernels are used to compute the wall shear stress obtained by the standard
wall function model, the dimensionless wall distance $y^+$ and the value for the
eddy viscosity.

!listing msr/msfr/steady/legacy/run_ns.i block=AuxKernels

The mixing length value is obtained from the restart file, as it is constant
throughout the simulation.

For relaxation purposes, time derivatives are added to the momentum equations
until a steady state is attained.

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/u_time

## Legacy explicit syntax for the energy equation id=legacy_pgh_energy

[eq:energy] is the final equation that is implemented in this model. The first
term---energy advection---is captured by the kernel,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/heat_advection

The second term---the turbulent diffusion of heat---corresponds to the kernel,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/heat_turb_diffusion

The third term---heat source and loss---is covered by two kernels. First, the
nuclear heating computed by the neutronics solver is included with,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/heat_src

And second, the heat loss through the heat exchanger is implemented with the
kernel,

!listing msr/msfr/steady/legacy/run_ns.i block=FVKernels/heat_sink

## Legacy explicit syntax for adding time derivatives to all equations

The following kernels were used to add the time derivatives to their
respective equations. This is no longer necessary with the `NavierStokesFV` syntax.

!listing msr/msfr/transient/legacy/run_ns.i block=FVKernels/u_time

!listing msr/msfr/transient/legacy/run_ns.i block=FVKernels/v_time

!listing msr/msfr/transient/legacy/run_ns.i block=FVKernels/heat_time

!listing msr/msfr/transient/legacy/run_ns.i block=FVKernels/c1_time
