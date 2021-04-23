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

!alert note
nekRS uses the [!ac](OCCA) [!ac](API), which allows nekRS to run on both [!ac](CPU) and [!ac](GPU)
systems. However, because nekRS is a turbulence-resolved [!ac](CFD) code that is typically
used by resolving boundary layers, this analysis requires [!ac](HPC) resources
to run the inputs. If you do not have access to [!ac](HPC) resources, you will still
find the analysis procedure useful in understanding the MOOSE-wrapped app concept
and opportunities for high-resolution thermal-hydraulics within the MOOSE framework.

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
  [MooseMesh](https://mooseframework.inl.gov/source/mesh/MooseMesh.html)
   is created by copying the nekRS surface mesh into a format that
  all native MOOSE applications use.
- Add [MooseVariables](https://mooseframework.inl.gov/source/variables/MooseVariable.html)
  to represent the nekRS solution. In other words,
  if nekRS stores the temperature internally as an `std::vector<double>`, with each
  entry corresponding to a nekRS node, then a [MooseVariable](https://mooseframework.inl.gov/source/variables/MooseVariable.html)
   is created that represents
  the same data, but that can be accessed in relation to the [MooseMesh](https://mooseframework.inl.gov/source/mesh/MooseMesh.html)
   mirror described above.
- Writing multiphysics feedback fields in/out of nekRS's internal solution and boundary
  condition arrays. So, if nekRS represents a heat flux boundary condition internally
  as an `std::vector<double>`, this involves reading from a [MooseVariable](https://mooseframework.inl.gov/source/variables/MooseVariable.html) representing
  heat flux (which can be transferred with any of MOOSE's transfers to the nekRS
  wrapping) and writing into nekRS's internal arrays.

Accomplishing the above three tasks requires an intimate knowledge of how nekRS
stores its solution fields and mesh. But once the wrapping is constructed, nekRS can
then communicate with any other MOOSE application via the [MultiApp]((https://mooseframework.inl.gov/syntax/MultiApps/index.html)
and [Transfer](https://mooseframework.inl.gov/syntax/Transfers/index.html) systems
in MOOSE, enabling complex multiscale thermal-hydraulic analysis and multiphysics feedback.
The same wrapping can be used for conjugate heat transfer analysis with *any* MOOSE
application that can compute a heat flux; that is, because a MOOSE-wrapped version of nekRS
interacts with the MOOSE framework in a similar manner as natively-developed
MOOSE applications, the agnostic formulations of the [MultiApps](https://mooseframework.inl.gov/syntax/MultiApps/index.html) and
[Transfers](https://mooseframework.inl.gov/syntax/Transfers/index.html) can be
used to equally extract heat flux from Pronghorn, BISON, the MOOSE heat conduction
module, and so on.

Cardinal includes capabilities for:

- Conjugate heat transfer boundary coupling to MOOSE
- Volumetric temperature, density, and heat source coupling to MOOSE and OpenMC

The remainder of this example will only describe the conjugate heat transfer aspects
of Cardinal via an application to the [!ac](PB-FHR) outer reflector with heat flux
coupling to the MOOSE heat conduction module.

## Geometry and Computational Model
  id=model

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
flow path is shown as yellow dashed lines in [top_down]; in these gaps, coolant
flows both from the pebble bed and outward in the radial direction, as well as vertically
from lower reflector rings.
Each ring of blocks is separated from the rings above and below it by very thin horizontal
gaps that form as the graphite thermally expands (not shown in [top_down]; these flow paths also
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
\label{eq:mass}
\nabla\cdot\mathbf u=0
\end{equation}

\begin{equation}
\label{eq:momentum}
\rho_f\left(\frac{\partial\mathbf u}{\partial t}+\mathbf u\cdot\nabla\mathbf u\right)=-\nabla P=\nabla\cdot\tau+\rho\ \mathbf f
\end{equation}

\begin{equation}
\label{eq:energy}
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

nekRS can be solved in either dimensional or non-dimensional form; in the present case,
nekRS is solved in non-dimensional form. That is, characteristic scales for velocity,
temperature, length, and time are defined and substituted into the governing equations
so that all solution fields (velocity, pressure, temperature) are of order unity.
A full derivation of the non-dimensional governing equations in nekRS is available
[here](https://nekrsdoc.readthedocs.io/en/latest/theory.html#non-dimensional-formulation).
But to summarize, non-dimensional formulations for velocity, pressure, temperature, length,
and time are defined as

\begin{equation}
u_i^\dagger=\frac{u_i}{U_{ref}}
\end{equation}

\begin{equation}
P^\dagger=\frac{P}{\rho_0U_{ref}^2}
\end{equation}

\begin{equation}
T^\dagger=\frac{T-T_{ref}}{\Delta T}
\end{equation}

\begin{equation}
x_i^\dagger=\frac{x_i}{L_{ref}}
\end{equation}

\begin{equation}
t^\dagger=\frac{t}{L_{ref}/U_{ref}}
\end{equation}

where a $\dagger$ superscript indicates a non-dimensional quantity. Inserting these definitions into 
[eq:mass], [eq:momentum], and [eq:energy] gives

\begin{equation}
\frac{\partial u_i^\dagger}{\partial x_i^\dagger}=0
\end{equation}

\begin{equation}
\rho^\dagger\left(\frac{\partial u_i^\dagger}{\partial t^\dagger}+u_j^\dagger\frac{\partial u_i^\dagger}{\partial x_j^\dagger}\right)=-\frac{\partial P^\dagger}{\partial x_i^\dagger}+\frac{1}{Re}\frac{\partial \tau_{ij}^\dagger}{\partial x_j^\dagger}+\rho^\dagger f_i^\dagger
\end{equation}

\begin{equation}
\rho^\dagger C_p^\dagger\left(\frac{\partial T^\dagger}{\partial t^\dagger}+u_i^\dagger\frac{\partial T^\dagger}{\partial x_i^\dagger}\right)=\frac{1}{Pe}\frac{\partial}{\partial x_i^\dagger}\left(k^\dagger\frac{\partial T^\dagger}{\partial x_i^\dagger}\right)+\dot{q}^\dagger
\end{equation}

where $\dagger$ superscripts indicates a non-dimensional quantity, complete definitions
of which are available [here](https://nekrsdoc.readthedocs.io/en/latest/theory.html#non-dimensional-formulation).
New terms in these non-dimensional equations are $Re$ and $Pe$, the Reynolds and Peclet numbers,
respectively:

\begin{equation}
Re\equiv\frac{\rho_0 UL}{\mu_0}
\end{equation}

\begin{equation}
Pe\equiv\frac{LU}{\alpha}
\end{equation}


So, nekRS solves for $\mathbf u^\dagger$, $P^\dagger$, and $T^\dagger$; Cardinal will handle
conversions from a non-dimensional solution to a dimensional MOOSE heat conduction application,
but awareness of this non-dimensional formulation will be important for describing the
nekRS input files.

In this model, the reference length scale is selected as the block gap width, or $L_{ref}=0.006$. Therefore,
to obtain a mesh with a gap width of unity (in non-dimensional units), the entire nekRS mesh must
be multiplied by $1/0.006$. The characteristic velocity is selected to obtain a Reynolds number of 100,
which corresponds to $U_{ref}=0.0575$ based on the values for density and viscosity for FLiBe
evaluated at 650&deg;C. Finally, $T_{ref}$ is taken equal to the inlet temperature of 923.15 K; the
$\Delta T$ parameter is arbitrary, and does not necessarily need to equal any expected temperature rise
in the fluid. So for this example, $\Delta T$ is simply taken equal to 10 K.

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
radiation heat transfer across a transpent fluid.
For a paired set of boundaries, each quadrature point on boundary A is
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
the nekRS computational model to the depiction in [#model] is imperfect.

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

## Meshing

This section describes how the meshes are generated for MOOSE and nekRS.
For both applications, the Cubit meshing software [!cite](cubit) is used to
programmatically create meshes with user-defined geometry and customizable
boundary layers. Journal files, or Python-scripted Cubit inputs, are used
to create meshes in Exodus II format. The MOOSE framework accepts meshes in
a wide range of formats that can be generated with many commercial and free
meshing tools; Cubit is used for this example because the content creator
is most familiar with this software, though similar meshes can be generated
with your preferred meshing tool.

#### Solid MOOSE Heat Conduction Mesh
  id=solid_mesh

The `solid.jou` file is a Cubit script that is used to generate the solid mesh,
shown below:

!listing /pbfhr/reflector/meshes/solid.jou

At the top of this file, is a `#!python` shebang that allows Python to be used
to programmatically create the mesh. Any valid Python code (including imported
modules) can be used; the actual commands passed to the Cubit
meshing tool are written as `cubit.cmd(<string command>)`, where
`<string command>` is a string containing the Cubit command that, in interactive mode,
would be manually typed into the Cubit command line. For complex meshes, scripting
the mesh process is essential for reproducibility and easing the burden of making
modifications to the geometry or mesh.

The complete solid mesh is shown below; the boundary names are illustrated towards
the right by showing only the highlighted surface to which each boundary corresponds.
Names are shown in Courier font. A unique block ID is used for the set of elements
corresponding to the inner ring, outer ring, and barrel. Material properties in MOOSE
are typically restricted by block, and setting three separate IDs allows us to set
different properties in each of these blocks.

!media solid_mesh.png
  id=solid_mesh
  caption=Solid mesh for the reflector blocks and barrel and a subset of the boundary names

Unique boundary names are set for each boundary to which we will apply a unique
boundary condition; we define the boundaries on the top and bottom of the block,
the symmetry boundaries that reflect the fact that we've reduced the full [!ac](PB-FHR)
reflector to a half-block domain, and boundaries at the interface between the
reflector and the bed and on the barrel surface.

To facilitate radiation heat transfer between the thin block gaps,
additional boundaries must be defined on the faces on either side of the gaps.
Two boundaries are defined per gap - one on either side of the gap. These are
shown below, where the naming convention `three_to_two` indicates a boundary
on block 3, across a gap from block 2.

!media solid_mesh_radiation.png
  id=solid_radiation
  caption=Sidesets defined for enforcing radiation heat transfer boundary conditions
  style=width:50%;margin-left:auto;margin-right:auto

One convenient aspect of MOOSE is that the same elements
can be assigned to more than one boundary ID. To help in applying heat flux and
temperature boundary conditions between nekRS and MOOSE, we define another boundary
that contains all of the fluid-solid interfaces through which we will exchange
heat flux and temperature, as `fluid_solid_interface`. Some of the elements on
the `fluid_solid_interface` boundary are also present on the boundaries between
blocks used for the radiation boundary conditions shown in [solid_radiation].

Now that the overall structure of the mesh has been introduced, a brief
description of the process of how the mesh was actually constructed is provided.
First, the block geometry is formed by creating cylinders and bricks and subtracting
them from one another to get angular sectors of cylindrical annuli. Then, the
Cubit `boundary_layer` feature is used to programmatically refine the mesh
near surfaces; we perform this refinement because, on some of these surfaces (those
exchanging heat with the fluid and radiation across gaps), we expect to have higher
thermal gradients that we would like to resolve with a finer mesh. For each boundary
layer, we specify a starting element width perpendicular to the surface, a growth
factor, and a number of boundary layers we would like to mesh. Finally, the mesh
is saved in Exodus II format to disk.

For the steady conduction analysis in [#part1], a slightly coarser mesh is used
to accelerate the calculation; this coarser mesh is obtained by setting the value
of the `initial_steady` Python variable in the journal file. Therefore, the meshes
for the solid phase are:

- `solid_coarse.e` is a fairly coarse mesh for the solid phase that will be used
  in [#part1]; this is generated by setting `initial_steady = True`
- `solid.e` is a finer mesh for the solid phase that will be used in [#part2];
  this is generated by setting `initial_steady = False`

#### Fluid nekRS Mesh
  id=fluid_mesh

The `fluid.jou` is a Cubit script that is used to generate the fluid mesh, shown below.

!listing /pbfhr/reflector/meshes/fluid.jou

Because nekRS uses a custom binary mesh format with a `.re2` extension, the mesh generation
process for nekRS is slightly more involved than the setup for MOOSE, though we still
begin by generating a mesh with Cubit.
nekRS also imposes several additional restrictions that are important to acknowledge
that do not exist for meshes used directly in native MOOSE applications.

The complete fluid mesh is shown below; the boundary names are illustrated towards
the right by showing only the highlighted surface to which each boundary corresponds.
Names are shown in Courier font. While the names of the surfaces are shown in Courier
font, nekRS does not directly use these names - rather, nekRS assigns boundary
conditions based on the numeric value of the boundary name; these are shown as "ID"
in the figure. An important restriction in nekRS is that the boundary IDs be ordered
sequentially beginning from 1.

!media fluid_mesh.png
  id=fluid_mesh
  caption=Fluid mesh for the FLiBe flowing around the reflector blocks, along with boundary names and IDs. It is difficult to see, but the `porous_inner_surface` boundary corresponds to the thin surface at the interface between the reflector region and the pebble bed.

Creating the fluid mesh is significantly more involved than creating the solid mesh.
First, a series of boolean operations is performed to obtain an un-meshed volume
that the fluid will flow through. Rather than create a single volume, the fluid region
is created as 7 separate volumes; this allows full customzation of the meshing near the
corners where we would like the boundary layer scheme to extend from the interior corners
(with angles greater than 180 degrees) across the fluid gaps. Like the solid mesh,
boundary layers are applied on all surfaces (even if the particular boundary condition
on a surface is not necessarily "no-slip"). Finally, the boundary IDs are created; while
names are assigned in the Cubit script, these names are not accessible to nekRS, and the
numeric boundary IDs are instead used for designating boundaries.

nekRS relies on a conversion utility that converts from
an Exodus II format to nekRS's `.re2` nekRS format. This utility, or the `exo2nek` program,
requires the Exodus mesh elements to be type `HEX20` (a twenty-node hexahedral element),
so we set this element type from Cubit. Finally, we export the mesh to Exodus II format.

To use this mesh in nekRS, it must be converted to the `.re2` format. Instructinos
for building the `exo2nek` program are available [here](https://nekrsdoc.readthedocs.io/en/latest/detailed_usage.html).
After this script has been compiled, you simply need to run

```
$ exo2nek
```

and then follow the prompts for the information that must be added about the mesh
to perform the conversion. Above, `$` indicates the terminal prompt.
For this example, there is no solid mesh, there are no periodic surface pairs,
and we want a scaling factor of $1/0.006$ (for the non-dimensional formulation)
and no translation (our mesh is located in space such that the faces match spatially
with the MOOSE solid mesh). The last part of the `exo2nek` program will request
a name for the fluid `.re2` mesh; providing `fluid` then will create the nekRS
mesh, named `fluid.re2`.

## Part 1: Initial Conduction Coupling
  id=part1

In this section, nekRS and MOOSE are coupled for conduction heat transfer in the solid reflector
blocks and barrel, and through a stagnant fluid. The purpose of this stage of
the analysis is to obtain a restart file for use as an initial condition in [#part2] to accelerate the nekRS
calculation for conjugate heat transfer. Because this initial condition is only used for
accelerating a later calculation, applying the radiation quadrature-based boundary conditions
is deferred to [#part2].

All input files for this stage of the analysis are present in the
`pbfhr/reflector/conduction` directory. The following sub-sections describe all of these files.

### Solid Input Files

The solid phase is solved with the MOOSE heat conduction module, and the mesh is generated
with Cubit, as described in [#solid_mesh]. The solid physics solved with the MOOSE
heat conduction module are specified in the `solid.i` file; this file will now be described
from beginning to end.

At the top of the file, the core heat flux is defined as a variable local to the file;
this value comes from a Pronghorn postprocessor, which we re-define locally in this file.

!listing /pbfhr/reflector/conduction/solid.i
  end=Mesh

The value of this variable can then be used anywhere else in the input file
with syntax like `${core_heat_flux}`, similar to bash syntax. Next, the solid mesh is
specified by pointing to the Exodus mesh generated in [#solid_mesh].

!listing /pbfhr/reflector/conduction/solid.i
  start=Mesh
  end=Variables

The heat conduction module will solve for temperature, which is defined as a nonlinear
variable.

!listing /pbfhr/reflector/conduction/solid.i
  start=Variables
  end=AuxVariables

The [Transfer](https://mooseframework.inl.gov/syntax/Transfers/index.html)
 system in MOOSE is used to communicate auxiliary variables across applications;
a boundary heat flux will be computed by MOOSE and applied as a boundary condition in nekRS.
In the opposite direction, nekRS will compute a surface temperature that will be applied as
a boundary condition in MOOSE. Therefore, both the flux, `flux`, and surface temperature,
`nek_temp`, are declared as auxiliary variables. Within `solid.i`, `flux` will be *computed*,
while `nek_temp` will simply *receive* a solution from the nekRS sub-applciation. The flux
is computed as a constant monomial field (a single value per element) due to the manner in
which material properties are accessible in auxiliary kernels in MOOSE.

!listing /pbfhr/reflector/conduction/solid.i
  start=AuxVariables
  end=Functions

In this example, the overall calculation workflow is as follows:

- Run MOOSE heat conduction with a given surface temperature distribution from nekRS.
- Send heat flux to nekRS as a boundary condition.
- Run nekRS with a given surface heat flux distribution from MOOSE.
- Send surface temperature to MOOSE as a boundary condition.

The above sequence is repeated until convergence of the overall domain. For the very first
time step, an initial condition should be set for `nek_temp`; this is done using a function
with an arbitrary, but not wholly unrealistic, distribution for the fluid temperature. That
function is then used as an initial condition with a `FunctionIC` object.

!listing /pbfhr/reflector/conduction/solid.i
  start=Functions
  end=Kernels

Next, the governing equation solved by MOOSE is specified with the `Kernels` block as the
`HeatConduction` kernel, or $-\nabla\cdot(k\nabla T)=0$. An auxiliary kernel is also specified
for the `flux` variable that specifies that the flux on the `fluid_solid_interface` boundary
should be computed as `-k\nabla T\cdot\hat{n}`.

!listing /pbfhr/reflector/conduction/solid.i
  start=Kernels
  end=BCs

Next, the boundary conditions on the solid are applied. On the fluid-solid interface,
a `MatchedValueBC` applies the value of the `nek_temp` receiver auxiliary variable
to `T` in a strong Dirichlet sense. Insulated boundary conditions are applied on the `symmetry`,
`top`, and `bottom` boundaries. On the boundary at the bed-reflector interface, the
core heat flux is specified as a `NeumannBC`. Finally, on the surface of the barrel,
a heat flux of `h(T-T_\infty)` is specified, where both $h$ and $T_\infty$ are specified
as material properties.

!listing /pbfhr/reflector/conduction/solid.i
  start=BCs
  end=Materials

The `HeatConduction` kernel requires a material property for the thermal conductivity;
material properties are also required for the heat transfer coefficient and far-field
temperature for the `ConvectiveHeatFluxBC`. These material properties are specified
in the `Materials` block.

!listing /pbfhr/reflector/conduction/solid.i
  start=Materials
  end=MultiApps

Next, the [MultiApps](https://mooseframework.inl.gov/syntax/MultiApps/index.html)
 and [Transfers](https://mooseframework.inl.gov/syntax/Transfers/index.html)
blocks describe the interaction between Cardinal
and MOOSE. The MOOSE heat conduction module is here run as the master application, with
the nekRS wrapping run as the sub-application. We specify that MOOSE will run first on each
time step. Allowing sub-cycling means that, if the MOOSE time step is 0.05 seconds, but
the nekRS time step is 0.02 seconds, that for every MOOSE time step, nekRS will perform
three time steps, of length 0.02, 0.02, and 0.01 seconds to "catch up" to the MOOSE master
application. Three transfers are required to couple Cardinal and MOOSE; the first is a transfer
of surface temperature from nekRS to MOOSE. The second is a transfer of heat flux from
MOOSE to Cardinal. And the third is a transfer of the total integrated heat flux from MOOSE
to Cardinal (computed as a postprocessor), which is then used internally by nekRS to re-normalize the heat flux (after
interpolation onto its [!ac](GLL) points).

!listing /pbfhr/reflector/conduction/solid.i
  start=MultiApps
  end=Postprocessors

!alert note
For transfers between two native MOOSE applications, you can ensure
conservation of a transferred field using the `from_postprocessors_to_be_preserved` and
`to_postprocessors_to_be_preserved` options available to any class inheriting from
[MultiAppConservativeTransfer](https://mooseframework.inl.gov/moose/source/transfers/MultiAppConservativeTransfer.html).
However, proper conservation of a field within nekRS (which uses a completely different
spatial discretization from MOOSE) requires performing such conservations in nekRS itself.
Hence, an integral postprocessor must explicitly be passed in this case.

The `Postprocessors` block is used to compute the integral heat flux as a
[SideIntegralVariablePostprocessor](https://mooseframework.inl.gov/source/postprocessors/SideIntegralVariablePostprocessor.html).
For diagnostic purposes, two other postprocessors are applied to compute the
heat flux on the barrel surface and the interface with the pebble bed with
the [SideFluxIntegral](https://mooseframework.inl.gov/source/postprocessors/SideFluxIntegral.html).

### Fluid Input Files

## Part 2: Conjugate Heat Transfer Coupling
  id=part2

### Input Files

## Acknowledgements

The Cardinal project is funded by the [!ac](NEAMS) program, while nekRS is
primarily funded through the [!ac](ECP), with additional contributions from
[!ac](NEAMS).


!bibtex bibliography
