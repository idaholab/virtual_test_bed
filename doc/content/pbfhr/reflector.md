# Bypass Flow Reflector Modeling

The pebble bed region in the [!ac](PB-FHR) is enclosed by an outer graphite reflector
that constrains the pebble geometry while also
serving as a reflector for neutrons and a shield for
the reactor barrel and core externals. In order to keep the graphite reflector within
allowable design temperatures, the reflector contains several bypass flow
paths so that a small percentage of the coolant flow, usually on the
order of 5 to 10% of the total flow, can remove heat from the reflector
and maintain the graphite within allowable temperature ranges. This
bypass flow, so-named because coolant is diverted from the pebble region,
is important to quantify during the reactor design process so that accurate
estimates of core cooling and reflector temperatures can be obtained.

This page shows an example of using [nekRS](https://nekrsdoc.readthedocs.io/en/latest/index.html),
a [!ac](GPU) based [!ac](CFD) code developed by Argonne National Laboratory,
coupled to MOOSE to explore the
conjugate heat transfer in a small region of the [!ac](PB-FHR) reflector. With input
from a full-core coupled Pronghorn-Griffin model, this example can be used to
evaluate hot spots in the reflector and ensure that reflector temperatures
remain within allowable limits. The meshes for this example are created with
programmable scripts; by running these inputs for a range of bypass gap widths
and Reynolds numbers, this model can be used to provide friction factor and
Nusselt number correlations as inputs to a full-core Pronghorn model.

The objectives of the present analysis are to:

- Show an example of how non-MOOSE codes can be coupled to MOOSE, and some
  capabilities in this space for thermal-hydraulics analysis. You should
  come away with an understanding of what a "MOOSE-wrapped app" looks like
  and the extent to which MOOSE-wrapped applications behave like other natively-developed
  MOOSE applications.
- Predict the pressure, velocity, and temperature distribution in the
  [!ac](PB-FHR) outer reflector.
- Describe how high-resolution tools such as nekRS can be used to generate
  closure terms (such as friction factor models) for the coarse-mesh tools
  in the MOOSE framework, such as Pronghorn.

## Cardinal and MOOSE-Wrapped Apps

The analysis shown here is performed with Cardinal, a MOOSE application
that "wraps" [nekRS](https://nekrsdoc.readthedocs.io/en/latest/index.html),
a [!ac](CFD) code, and [OpenMC](https://docs.openmc.org/en/latest/), a Monte Carlo particle transport
code.

"Wrapping" means that, for all intents and purposes, a nekRS simulation can
be run within the MOOSE framework and interacted with as if the physics
and numerical solution procedure performed by nekRS were a MOOSE application.
Cardinal contains source code that facilitates data transfers in and out of nekRS
within the MOOSE framework. At a high level, Cardinal's wrapping of nekRS consists of:

- Constructing a "mirror" of the nekRS mesh through which data transfers occur
  with MOOSE. For conjugate heat transfer applications such as shown here, a
  `MooseMesh` is created by copying the nekRS surface mesh into a format that
  all native MOOSE applications use.
- Adding `MooseVariable`s to represent the nekRS solution. In other words,
  if nekRS stores the temperature internally as an `std::vector<double>`, with each
  entry corresponding to a nekRS node, then a `MooseVariable` is created that represents
  the same data, but that can be accessed in relation to the `MooseMesh` mirror
  described above.
- Writing multiphysics feedback fields in/out of nekRS's internal solution and boundary
  condition arrays. So, if nekRS represents a heat flux boundary condition internally
  as an `std::vector<double>`, this involves reading from a `MooseVariable` representing
  heat flux (which can be transferred with any of MOOSE's transfers to the nekRS
  wrapping) and writing into nekRS's internal arrays.

Accomplishing the above three tasks requires an intimate knowledge of how nekRS
stores its solution fields and mesh. But once the wrapping is constructed, nekRS can
then communicate with any other MOOSE application via the `MultiApp` and `Transfer` systems
in MOOSE, enabling complex multiscale thermal-hydraulic analysis and multiphysics feedback.
The same wrapping can be used for conjugate heat transfer analysis with *any* MOOSE
application that can compute a heat flux; that is, because a MOOSE-wrapped version of nekRS
interacts with the MOOSE framework in a similar manner as natively-developed
MOOSE applications, the agnostic formulations of the `MultiApp` `Transfer`s can be
used to equally extract heat flux from Pronghorn, BISON, the MOOSE heat conduction
module, and so on.

Cardinal includes capabilities for:

- Conjugate heat transfer boundary coupling to MOOSE
- Volumetric temperature, density, and heat source coupling to MOOSE and OpenMC

The remainder of this example will only describe the conjugate heat transfer aspects
of Cardinal via an application to the [!ac](PB-FHR) outer reflector with heat flux
coupling to the MOOSE heat conduction module.

## Geometry and Computational Model

This section describes the [!ac](PB-FHR) reflector geometry and the simplifications
made in constructing a computational model of this system.

!alert note
This computational model is a simplified version of the actual reflector
geometry and reactor state. Due to limitations in nekRS's boundary conditions,
some geometry approximations will be made. This model is also run independently
of Pronghorn and Griffin, so several assumptions are made regarding fluid boundary
conditions at the inlet to the reflector and along the reflector-pebble bed interface,
even though in reality the flow and heat transfer in the reflector is tightly
coupled to the flow and heat transfer in the bed and the neutron transport
over the entire reactor.
It is important to be aware of these simplifications when assessing the physical predictions
of this model. Nevertheless, these simplifications do not detract from the
ability to use this model to learn about high-resolution conjugate heat transfer
capabilities in the MOOSE framework as long as the simplifications are acknowledged.
The details of this model can be refined for follow-on studies as needed.

A top-down view of the [!ac](PB-FHR) reactor vessel is shown below. This geometry is
based on the specifications given in [!cite](shaver). The center region
is the pebble bed core, which has an outer radius of 2.6 m. Surrounding the
pebble region are two rings of graphite reflector blocks, staggered with
respect to one another in a brick-like fashion. Each ring contains 24 blocks.
The inner ring blocks have a width (i.e. radial thickness) of 0.3 m, while
the outer ring blocks have a width of 0.4 m.
The gaps between the blocks are 0.002 m wide. In black is shown the core barrel,
which is 0.022 m thick. The gap between the outer ring of blocks and the barrel
is ten times larger than the gap between the inner and outer ring of blocks,
or 0.02 m.

!media top_down.png
  id=top_down
  caption=Top-down schematic of the [!ac](PB-FHR) reactor core (only roughly to scale).
  style=width:60%;margin-left:auto;margin-right:auto

To ease the difficulty of meshing very narrow slots, as well as
to make visualization and model depiction easier, the width of
the gap between blocks is increased in this example to 0.006 m. Of course, over
the lifetime of the reactor, the gap width changes due to graphite material response
to fluence such that the gap width is not a fixed value. Therefore, we take this
liberty here to improve visualization of the thin gaps, but allow setting the gap
width as an input to the meshing scripts. Gap widths of 0.006 m are not
completely without physical basis; for instance, for the [!ac](THTR),
a maximum 1% shrinkage of the graphite reflector blocks was assumed
[!cite](oehme). Translating this percentage to the [!ac](PB-FHR) geometry corresponds to
gaps of approximately 0.005 m thickness [!cite](novak2021).

To form the entire axial height of the reflector, rings of blocks are stacked
vertically; each block is 0.52 m tall. The entire core height is 5.3175 m, or
about 10 vertical rings of blocks (additional structures at the core inlet and
outlet compose any remaining height not evenly divisible by 0.52 m).

In both the pebble bed region and through the small gaps between the reflector
blocks and between the reflector blocks and the barrel, FLiBe coolant flows. This bypass
flow path is shown as yellow dashed lines in [top-down]; in these gaps, coolant
flows both from the pebble bed and outward in the radial direction, as well as vertically
from lower reflector rings.
Each ring of blocks is separated from the rings above and below it by very thin horizontal
gaps that form as the graphite thermally expands (not shown in [top-down]; these flow paths also
contribute to bypass flows, allowing a second radial flow path from the pebble
bed towards the barrel. For simplicity, this second radial flow path is neglected here.

The total power of the [!ac](PB-FHR) is 236 MW; any power deposition in the reflector is neglected.
The FLiBe inlet temperature to the
core is 600&deg;C, while the nominal outlet temperature is 700&deg;C.

To reduce computational cost, the coupled nekRS-MOOSE simulation is conducted
for a single ring of reflector blocks (i.e. a height of 0.52 m), with azimuthal symmetry assumed to further
reduce the domain to half of an inner ring block, half of an outer ring block,
and the vertical and radial bypass flow paths between the blocks and the barrel. This
computational domain is shown outlined with a red dotted line in the figure above.
As already mentioned, the second radial flow path (along fluid "sheets" between vertically
stacked rings of blocks) is not considered. This geometry, as well
as the boundary conditions imposed, will be
described in much greater detail later when the meshes for the fluid and solid
phases are discussed.

## Governing Equations

This section describes the physics solved in this coupled conjugate heat
transfer problem. Because there are no transient source terms or transient
boundary conditions, the MOOSE heat conduction module will
solve the steady state energy conservation equation for a solid,

\begin{equation}
-\nabla\cdot(k_s\nabla T_s)=\dot{q}
\end{equation}

where $k_s$ is the solid thermal conductivity, $T_s$ is the solid temperature,
and $\dot{q}$ is the solid volumetric heat source. Solving the steady energy conservation
in lieu of the transient equation will accelerate the approach to the coupled psuedo-steady state.

nekRS solves the incompressible Navier-Stokes equations,

\begin{equation}
\nabla\cdot\mathbf u=0
\end{equation}

\begin{equation}
\rho_f\left(\frac{\partial\mathbf u}{\partial t}+\mathbf u\cdot\nabla\mathbf u\right)=-\nabla P=\nabla\cdot\tau+\rho\ \mathbf f
\end{equation}

\begin{equation}
\rho_f C_{p,f}\left(\frac{\partial T_f}{\partial t}+\mathbf u\cdot\nabla T_f\right)=\nabla\cdot\left(k_f\nabla T_f\right)+\dot{q}_f
\end{equation}

where $\mathbf u$ is the fluid velocity, $\rho_f$ is the fluid density, $P$ is the pressure, $\tau$
is the viscous stress tensor, $\mathbf f$ is a source vector, $\dot{q}_f$
is a volumetric heat source, $C_{p,f}$ is the fluid heat capacity,
$T_f$ is the fluid temperature, and $k_f$ is the fluid thermal conductivity. In this example, $\mathbf f$
is set equal to $-g\hat{z}$ and
$\dot{q}_f$ is set to zero because there is no volumetric heat source in the fluid.

Because the expected temperature range is small (on the order of the nominal
100&deg;C temperature rise divided by 10 (because the reflector is approximately 10 rings of
blocks high), all material properties are taken as constant (though this is not a limitation of nekRS).
In addition, the expected flowrate through the reflector block is sufficiently low to be laminar,
so the $k$-$\tau$ turbulence model in nekRS is not needed.

### Boundary Conditions

This section describes the boundary conditions imposed on the fluid and solid phases.
When the meshes are described later, descriptive words such as "inlet" and "outlet"
will be directly tied to sidesets in the mesh to enhance the verbal description here.

There are two important caveats to recognize in these boundary conditions.
As described earlier, this simulation is performed as a standalone case, independent
of Pronghorn and Griffin, despite the fact that the reflector flow and heat transfer
is tightly coupled to the core thermal-hydraulics. Two simplifications are made:

- The heat flux at the pebble bed-reflector interface is given as the
  average heat flux over the outer boundary of the [!ac](PB-FHR) model described in TODO. This
  heat flux is evaluated with a `Postprocessor` (TODO) in the Pronghorn model, so its
  use here as a boundary condition indicates that the reflector block we are considering
  represents some average conditions in the [!ac](PB-FHR).
- The coupled Pronghorn-Griffin [!ac](PB-FHR) model described TODO does not model flow through
  the outer reflector - the reflector is treated as a solid conducting block. Therefore,
  this particular full-core [!ac](PB-FHR) model cannot directly provide temperature and velocity boundary
  conditions to the present reflector model. Instead, the inlet boundary conditions
  are also taken as representing some average conditions in the [!ac](PB-FHR) at an
  a priori specified bypass fraction and inlet temperature.

#### Solid Boundary Conditions

For the solid
domain, a heat flux is imposed on the block surface facing the pebble bed, where the value of
the heat flux comes from a Pronghorn postprocessor. TODO On the surface of the barrel, a heat
convection boundary condition is imposed,

\begin{equation}
q^{''}=h\left(T_s-T_\infty\right)
\end{equation}

where $q^{''}$ is the heat flux, $h$ is the convective heat transfer coefficient, and $T_\infty$
is the far-field ambient temperature.

Between the reflector blocks, the MOOSE heat conduction module is used to apply quadrature-based
radiation heat transfer. For a paired set of boundaries, each quadrature point on boundary A is
paired with the nearest quadrature point on boundary B. Then, a radiation heat flux is imposed
between pairs of quadrature points as

\begin{equation}
q^{''}=\sigma\frac{\left(T^4-T_{gap}^4\right)}{\frac{1}{\varepsilon_A}+\frac{1}{\varepsilon_B}-1}
\end{equation}

where $q^{''}$ is the heat flux, $\sigma$ is the Stefan-Boltzmann constant, $T$ is the temperature
at a quadrature point, $T_{gap}$ is the temperature of the nearest quadrature point across the
gap, and $\varepsilon_A$ and $\varepsilon_B$ are the emissivities of boundary A and B, respectively.

At fluid-solid interfaces, the solid temperature is imposed as a Dirichlet condition,
where nekRS computes the surface temperature.
Finally, the top and bottom of the block, as well as all symmetry boundaries, are treated
as insulated.

#### Fluid Boundary Conditions

At the inlet, the fluid temperature is taken as 650&deg;C, or the nominal
media fluid temperature. The inlet velocity is selected such that the Reynolds number is 100.
At the outlet, a zero pressure is imposed. On the $\theta=0^\circ$ boundary (i.e. the $y=0$ boundary), symmetry is imposed
such that all derivatives in the $y$ direction are zero. All other boundaries are treated as no-slip.

!alert note
The $\theta=7.5^\circ$ boundary (i.e. $360^\circ$ divided by 24 blocks, divided
in half because we are modeling only half a block) should also be imposed as a symmetry
boundary in the nekRS model. However, nekRS is currently limited to symmetry
boundaries only for boundaries aligned with the $x$, $y$, and $z$ coordinate
axes. Here, a no-slip boundary condition is used instead, so the correspondence of
the nekRS computational model to the depiction in [top-down] is imperfect.

At fluid-solid interfaces, the heat flux is imposed as a Neumann condition, where MOOSE
computes the surface heat flux.

### Initial Conditions

Because the nekRS mesh contains very small elements in the fluid phase, fairly small time
steps are required to meet [!ac](CFL) conditions related to stability. Therefore,
the approach to the coupled, pseudo-steady conjugate heat transfer solution can be
accelerated by obtaining initial conditions from a pure conduction simulation. Then, the
initial conditions for the conjugate heat transfer simulation use the temperature obtained
from the conduction simulation, with a uniform axial velocity and zero pressure.
The process to run Cardinal in conduction mode is described in [#part1].

## Computing Requirements

While nekRS is developed targeting [!ac](GPU) computing resources, the use
of the [!ac](OCCA) [!ac](API) allows nekRS to run on both [!ac](CPU) and [!ac](GPU)
systems. However, because nekRS is a turbulence-resolved [!ac](CFD) code that is typically
used by resolving boundary layers, this analysis requires [!ac](HPC) resources
to run the inputs. If you do not have access to [!ac](HPC) resources, you will still
find the analysis procedure useful in understanding the MOOSE-wrapped app concept
and opportunities for high-resolution thermal-hydraulics within the MOOSE framework.

## Part 1: Initial Steady State Conduction Coupling
  id=part1

## Part 2: Conjugate Heat Transfer Coupling
  id=part2

## Acknowledgements

The Cardinal project is funded by the [!ac](NEAMS) program, while nekRS is
primarily funded through the [!ac](ECP), with additional contributions from
[!ac](NEAMS).


!bibtex bibliography
