# MSFR Griffin-Pronghorn model

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

The MultiApp system is used to separate the neutronics and the fluid dynamics
problems. The fluid system is solved by the subapp and it uses the `run_ns.i`
input files. (Here "ns" is an abbreviation for Navier-Stokes.)

The fluid system includes conservation equations for fluid mass, momentum, and
energy as well as the conservation of delayed neutron precursors.

## Conservation of fluid mass

The conservation of mass is,

\begin{equation}
  \nabla \cdot \rho \vec{u} = 0,
\end{equation}

where $\rho$ is the fluid density and $\vec{u}$ is the velocity vector.

Here the system will be simplified by modeling the flow as incompressible.  (The
effect of Buoyancy will be re-introduced later with the Boussinesq
approximation.)  The simplified conservation of mass is then given by,

\begin{equation}
  \nabla \cdot \vec{u} = 0.
\end{equation}

This conservation equation is automatically added by the `NavierStokesFV` action
when selecting the incompressible model.

```
[Modules]
  [NavierStokesFV]
    # General parameters
    compressibility = 'incompressible'
    ...
```

Legacy syntax for the mass equation is included [here](griffin_pgh_model_legacy.md).

## Conservation of fluid momentum

This system also includes the conservation of momentum in the $x$-direction. A
fairly general form of the steady-state condition is,

\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \mu \nabla^2 u + f_{\text{fric},x} +
  \rho \vec{g} \cdot \hat{x},
\end{equation}

where $u$ is the $x$ component of the velocity, $P$ is the pressure,
$f_{\text{fric},x}$ is the $x$ component of the viscous friction force, and
$\vec{g}$ is the gravity vector.

In this model, gravity will point in the negative $y$-direction so the quantity
$\vec{g} \cdot \hat{x}$ is zero,

\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \mu \nabla^2 u + f_{\text{fric},x}.
\end{equation}

Practical simulations require modifications to the momentum equations in order
to model the effects of turbulence without explicitly resolving the turbulent
structures. Here, we will apply the Reynolds-averaging procedure and the
Boussinesq hypothesis so that the effect of turbulent momentum transfer is
modeled with a term analogous to viscous shear,

\begin{equation}
  \nabla \cdot \rho \vec{u} u = -\frac{\partial}{\partial x} P
  + \left( \mu + \mu_t \right) \nabla^2 u + f_{\text{fric},x},
\end{equation}

where $\mu_t$ is the turbulent viscosity.

Here, a zero-equation model based on the mixing length model is used. In this
model the turbulent viscosity is defined as:
\begin{equation}
  \mu_t = \rho \cdot {l_m}^2 \cdot |2\overline{\overline S} : \overline{\overline S}|
\end{equation}
and
\begin{equation}
  \overline{\overline S} = 0.5 \cdot \left( \nabla u + \nabla u^t \right).
\end{equation}

The standard Prandtl's mixing length model dictates that $l_m$ has a linear
dependence on the distance to the nearest wall. However, for this simulation we
implement a capped mixing length model [!citep](escudier1966) that defines the mixing
length as

\begin{equation}
  l_m = \kappa y_d, \quad \text{if} \: \kappa y_d < \kappa_0 \delta, \\
  l_m = \kappa_0 \delta, \quad \text{if} \: \kappa y_d \geq \kappa_0 \delta,
\end{equation}

where $\kappa =0.41$ is the Von Karman constant, $\kappa_0 = 0.09$ as in
Escudier's model and $\delta$ has length units and represents the thickness of
the velocity boundary layer.

The viscous friction is treated with two different models for different regions
of the reactor. The bulk of the friction is expected to occur in the heat
exchanger region where there is a large surface area in contact with the salt to
facilitate heat transfer. Rather than explicitly modeling the heat exchanger
geometry, a simple, tunable model will be used,
\begin{equation}
  f_{\text{fric},x} = -C_q u | u |,
\end{equation}
where $C_q$ is a tunable volumetric friction coefficient, which is selected to match the
desired pressure drop, in conjunction with the pump head value.

A typical viscous friction model could be used for the regions outside of the
heat exchanger. However, the viscous effects will be negligible due to the
large, uniform eddy viscosity model used here. Consequently, the viscous force
will be neglected outside of the heat exchanger,
\begin{equation}
  f_{\text{fric},x} = 0.
\end{equation}

By convention, we must collect all of the terms on one side of the equation.
This gives the form that is implemented for the MSFR model,

\begin{equation}
  \nabla \cdot \rho \vec{u} u + \frac{\partial}{\partial x} P
  - \left( \mu + \mu_t \right) \nabla^2 u - f_{\text{fric},x} = 0.
  \label{eq:x_mom}
\end{equation}

The first few terms in [eq:x_mom], including the advection of momentum, the pressure gradient
and the laminar diffusion are automatically handled by the `NavierStokesFV` action.

The mixing length turbulence model is added by specifying additional parameters to
the action. This basic model is currently the most limiting issue in terms of
accuracy.

```
[Modules]
  [NavierStokesFV]
    ...
    # Turbulence parameters
    turbulence_handling = 'mixing-length'
    turbulent_prandtl = ${Pr_t}
    von_karman_const = ${von_karman_const}
    mixing_length_delta = 0.1
    mixing_length_walls = 'shield_wall reflector_wall'
    mixing_length_aux_execute_on = 'initial'
    ...
```

The friction in the heat exchanger is specified by passing the following parameters to the
`NavierStokesFV` action. A quadratic friction model with a coefficient tuned to obtain the desired
mass flow rate is selected.

```
[Modules]
  [NavierStokesFV]
    ...
    # Heat exchanger
    friction_blocks = 'hx'
    friction_types = 'FORCHHEIMER'
    friction_coeffs = ${friction}
    ...
```

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
  - f_{\text{pump}} - \rho \alpha \vec{g} \left( T - T_0 \right) = 0,
\end{equation}

where $f_{\text{pump}}$ is the pump head driving the flow, $\alpha$ is the
expansion coefficient, $T$ is the fluid temperature, and $T_0$ is a reference
temperature value. The pump head is tuned such that the imposed mass flow rate
is ~18500 kg/s.

For each kernel describing the $x$-momentum equation, there is a corresponding
kernel for the $y$-momentum equation. They are similarly added by the `NavierStokesFV`.
An additional kernel is added to add a volumetric pump component to the system:

!listing msr/msfr/steady/run_ns.i block=FVKernels/pump

The Boussinesq buoyancy approximation is added to the model using this parameter:

```
[Modules]
  [NavierStokesFV]
    ...
    boussinesq_approximation = true
    ...
```

Boundary conditions include standard velocity wall functions at the walls to
account for the non-linearity of the velocity in the boundary layer given the
coarse mesh and symmetry at the center axis of the MSFR. They are added by the
action based on user-input parameters:

```
[Modules]
  [NavierStokesFV]
    ...
    # Boundary conditions
    wall_boundaries = 'shield_wall reflector_wall fluid_symmetry'
    momentum_wall_types = 'wallfunction wallfunction symmetry'
    ...
```

Auxkernels are used to compute the wall shear stress obtained by the standard
wall function model, the dimensionless wall distance $y^+$ and the value for the
eddy viscosity. These are used for analysis purposes.

!listing msr/msfr/steady/legacy/run_ns.i block=AuxKernels

Legacy syntax for the momentum equation is included [here](griffin_pgh_model_legacy.md).

## Conservation of fluid energy

The steady-state conservation of energy can be expressed as,
\begin{equation}
  \nabla \cdot \rho h \vec{u} - \nabla \cdot \lambda \nabla T = Q_q,
\end{equation}
where $h$ is the fluid specific enthalpy, $\lambda$ is the thermal conductivity,
and $Q_q$ is the volumetric heat generation rate.

Here it is expected that the energy released from nuclear reactions will be very
large compared to pressure work terms. Consequently, we will use the simplified form,
\begin{equation}
  \nabla \cdot \rho c_p T \vec{u} - \nabla \cdot \lambda \nabla T = Q_q.
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
  - Q_q = 0.
\end{equation}

The heat generation due to nuclear reactions is computed by the neutronics
solver, and this distribution will be used directly in the $Q_q$ term. The
effect of the heat exchanger will also be included in the $Q_q$ term as a
volumetric heat loss per the model,
\begin{equation}
  Q_q = -\alpha (T - T_\text{ambient}),
\end{equation}
where $\alpha$ is a coefficient (equal to the surface area density times the
heat transfer coefficient) and $T_\text{ambient}$ is the
temperature of the coolant on the secondary side of the heat exchanger.

Note that all material properties, including $\rho$ and $c_p$, are assumed
constant. It will therefore be convenient to move the $\rho c_p$ factors outside
of the divergence operators and divide the entire equation by that factor,
\begin{equation}
  \nabla \cdot T \vec{u} - \nabla \cdot \epsilon_q \nabla T
  - \frac{1}{\rho c_p} Q_q = 0.
  \label{eq:energy}
\end{equation}

[eq:energy] is the final equation that is implemented in this model. It is added to
the equation system using a parameter in the `NavierStokesFV` action:

```
[Modules]
  [NavierStokesFV]
    ...
    add_energy_equation = true
    ...
```

The first term---energy advection--- is automatically added by the action syntax. The
second term---turbulent diffusion of heat--- is added based on the momentum
turbulent term, with the Prandtl number also to be specified to adjust the
diffusion coefficient.

The third term---heat source and loss---is covered by two kernels. First, the
nuclear heating computed by the neutronics solver is included with,

```
[Modules]
  [NavierStokesFV]
    ...
    # Heat source
    external_heat_source = power_density
    ...
```

And second, the heat loss through the heat exchanger is implemented with the
kernel,

```
[Modules]
  [NavierStokesFV]
    ...
    # Heat exchanger
    ambient_convection_blocks = 'hx'
    ambient_convection_alpha = ${fparse 600 * 20e3} # HX specifications
    ambient_temperature = ${T_HX}
    ...
```

The boundary conditions are added similarly, by simply specifying 0 heat flux for
symmetry and adiabatic boundaries.

```
[Modules]
  [NavierStokesFV]
    ...
    energy_wall_types = 'heatflux heatflux heatflux'
    energy_wall_function = '0 0 0'
```

Legacy syntax for the energy equation is included [here](griffin_pgh_model_legacy.md).

## Conservation of delayed neutron precursors

The steady-state conservation of delayed neutron precursors (DNP) can be expressed as,
\begin{equation}
  \nabla \cdot (\vec{u}c_i) -  \nabla \cdot \epsilon_c \nabla c_i - \lambda_i c_i = \beta_i f,\quad i=1,\cdots,I,
  \label{eq:dnp}
\end{equation}
where $c_i$, $\lambda_i$ and $\beta_i$ are the concentration, the decay constant and
the production fraction per neutron generated from fission of the $i$-th group of
DNP respectively. $I$ is the total number of groups of DNP.
$f$ is the fission neutron production rate.
$\epsilon_c$ is the eddy diffusivity for DNP.
It is noted the DNP term in the neutron transport equation is scaled with $k$-effective
as the prompt fission term for steady-state eigenvalue calculations, where $k$-effective
(the eigenvalue) is part of the solution.

It is added to
the equation system using a parameter in the `NavierStokesFV` action:

```
[Modules]
  [NavierStokesFV]
    ...
    add_scalar_equation = true
    ...
```

The terms of [eq:energy] are added with

```
[Modules]
  [NavierStokesFV]
    ...
    # Precursor advection, diffusion and source term
    passive_scalar_names = 'c1 c2 c3 c4 c5 c6'
    passive_scalar_schmidt_number = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
    passive_scalar_coupled_source = 'fission_source c1; fission_source c2; fission_source c3;
                                     fission_source c4; fission_source c5; fission_source c6;'
    passive_scalar_coupled_source_coeff = '${beta1} ${lambda1_m}; ${beta2} ${lambda2_m};
                                           ${beta3} ${lambda3_m}; ${beta4} ${lambda4_m};
                                           ${beta5} ${lambda5_m}; ${beta6} ${lambda6_m}'
```

What is the boundary condition for DNP?

## Neutronics

With Griffin, the process of converting the basic conservation equations into
MOOSE variables and kernels is automated with the `TransportSystems` block:

!listing msr/msfr/steady/run_neutronics.i block=TransportSystems

Details about neutron transport equations can be found in Griffin theory manual.

Here we are specifying an eigenvalue neutronics problem using 6 energy groups
(`G = 6`) solved via the diffusion approximation with a continuous finite
element discretization scheme (`scheme = CFEM-Diffusion`).

Note the `external_dnp_variable = 'dnp'` parameter. This is a special option
needed for liquid-fueled MSRs which signals that the conservation equations for
DNP will be handled "externally" from the default
Griffin implementation which assumes that the precursors do not have the turbulent treatment.
This parameter is referencing the `dnp` auxiliary variable which is defined as,

!listing msr/msfr/steady/run_neutronics.i block=AuxVariables/dnp

Note that this is an array auxiliary variable with 6 components, corresponding
to the 6 DNP groups used here.

Support within the Framework for array variables is somewhat limited. For
example, not all of the multiapp transfers work with array variables, and the
Navier-Stokes module does not include the kernels that are needed to advect an
array variable. For this reason, there is also a separate auxiliary variables for each
of DNP. For example,

!listing msr/msfr/steady/run_neutronics.i block=AuxVariables/c1

The `run_ns.i` subapp is responsible for computing the precursor distributions,
and the distributions are transferred from the subapp to the main app by blocks
like this one,

!listing msr/msfr/steady/run_neutronics.i block=Transfers/c1

The values are then copied from the `c1`, `c2`, etc. variables into the `dnp`
variable by this aux kernel:

!listing msr/msfr/steady/run_neutronics.i block=AuxKernels/build_dnp

Also note that solving the neutronics problem requires a set of multigroup
cross sections. Generating cross sections is a topic that is left outside the
scope of this example. A set has been generated for the MSFR problem and stored
in the repository using Griffin's ISOXML format. These cross sections are included
by the blocks,

!listing msr/msfr/steady/run_neutronics.i block=Materials

`CoupledFeedbackNeutronicsMaterial` is able to use the temperature transferred
from the fluid system for evaluating multigroup cross sections based on a table lookup
on element quadrature points to bring in the feedback effect.
It also has the capability of adjusting cross sections based on fluid density.
In this model, the fluid density change is negligible.

Neutronics solution is normalized to the rated power $3000$MW with the `PowerDensity`
input block

!listing msr/msfr/steady/run_neutronics.i block=PowerDensity

The power density is evaluated with the normalized neutronics solution.
It provides the source of the fluid energy equation.
Because the fluid energy equation is discretized with FV, we evaluate the power
density variable with constant monomial.

Griffin input is the main-application and includes a sub-application with the
fluid system input `run_ns.i`.

!listing msr/msfr/steady/run_neutronics.i block=MultiApps

Neutronics needs to to transfer fission source, power density to fluid system
and needs to transfer back from fluid system temperature and DNP concentrations.

!listing msr/msfr/steady/run_neutronics.i block=Transfers

The caculation is driven by `Eigenvalue`, an executioner available in the MOOSE framework.
The PJFNKMO option for the `solve_type` parameter is able to
drive the eigenvalue calculation with the contribution of DNP
to the neutron transport equation as an external source scaled with $k$-effective.

!listing msr/msfr/steady/run_neutronics.i block=Executioner
