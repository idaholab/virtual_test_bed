## Cardinal and MOOSE-Wrapped Apps

The analysis shown here is performed with Cardinal, a MOOSE application
that "wraps" [nekRS](https://nekrsdoc.readthedocs.io/en/latest/index.html),
a [!ac](CFD) code, and [OpenMC](https://docs.openmc.org/en/latest/), a Monte Carlo particle transport
code. Cardinal is an open-source application, [available on GitHub](https://github.com/neams-th-coe/cardinal).
As this example focuses on heat transfer modeling, there will be no further
discussion of the OpenMC wrapping in Cardinal.
"Wrapping" means that, for all intents and purposes, nekRS simulations can
be run within the MOOSE framework and interacted with as if the physics
and numerical solution performed by nekRS were a native MOOSE application.
Cardinal contains source code that facilitates data transfers in and out of nekRS
and runs nekRS within a MOOSE-controlled simulation.
At a high level, Cardinal's wrapping of nekRS consists of:

- Constructing a "mirror" of the nekRS mesh through which data transfers occur
  with MOOSE. For conjugate heat transfer applications such as those shown here, a
  [MooseMesh](https://mooseframework.inl.gov/source/mesh/MooseMesh.html)
   is created by copying the nekRS surface mesh into a format that
  all native MOOSE applications can understand.
- Adding [MooseVariables](https://mooseframework.inl.gov/source/variables/MooseVariable.html)
  to represent the nekRS solution. In other words,
  if nekRS stores the temperature internally as an `std::vector<double>`, with each
  entry corresponding to a nekRS node, then a [MooseVariable](https://mooseframework.inl.gov/source/variables/MooseVariable.html)
   is created that represents
  the same data, but that can be accessed in relation to the [MooseMesh](https://mooseframework.inl.gov/source/mesh/MooseMesh.html)
   mirror.
- Writing multiphysics feedback fields in/out of nekRS's internal solution and boundary
  condition arrays. So, if nekRS represents a heat flux boundary condition internally
  as an `std::vector<double>`, this involves reading from a [MooseVariable](https://mooseframework.inl.gov/source/variables/MooseVariable.html) representing
  heat flux (which can be transferred with any of MOOSE's transfers to the nekRS
  wrapping) and writing into nekRS's internal vectors.

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

!alert tip title=Why Use Cardinal?
Cardinal allows nekRS and OpenMC to couple seamlessly with the MOOSE framework,
enabling in-memory coupling, distributed parallel meshes for very large-scale
applications, and straightforward multiphysics problem setup. Cardinal has
capabilities for conjugate heat transfer coupling of nekRS and MOOSE, concurrent
conjugate heat transfer and volumetric heat source coupling of nekRS and MOOSE,
and volumetric density, temperature, and heat source coupling of OpenMC to MOOSE.
Together, the OpenMC and nekRS wrappings augment MOOSE
by expanding the framework to include high-resolution spectral element [!ac](CFD) and Monte Carlo
particle transport. For conjugate heat transfer applications in particular,
the libMesh-based interpolations of fields between meshes enables fluid-solid
heat transfer simulations on meshes that are not necessarily continuous on phase
interfaces, allowing mesh resolution to be specified based on the underlying physics,
rather than rigid continuity restrictions in single-application heat transfer codes.

