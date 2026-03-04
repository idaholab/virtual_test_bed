# Griffin steady state input

*Contact: Dr. Mustafa Jaradat, Mustafa.Jaradat\@inl.gov*

*Sponsor: Dr. Steve Bajorek (NRC)*

*Model summarized, documented, and uploaded by Dr. Mustafa Jaradat and Dr. Samuel Walker*

We will first cover the input for the main application, Griffin, which tackles the neutronics
problem. While the Griffin manual is ultimately the most complete reference on this input, we will
try to provide enough details here for a complete comprehension of this input.

### Problem Parameters

We first define in the header parameters that can be called throughout the input file:

- geometric parameters for the core height and the active core radius

- core porosity value

- burnup group information

- geometric parameters for pebbles

- parameters for the streamline calculations for pebble cycling

- the core power

- and initial values for the temperature, density, and reference density.

### Global Parameters

The next block is a [GlobalParams](https://mooseframework.inl.gov/syntax/GlobalParams/index.html) block. These parameters will be inserted in every block in the input,
and are used to reduce the size of the input file. Here we specify the group cross section library. We will give
additional details about the group cross sections in the [Materials](https://mooseframework.inl.gov/moose/syntax/Materials/) block.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=GlobalParams

### Transport Systems

The `[TransportSystems]` block is used to specify the solver parameters.

We chose a diffusion solver
as accuracy is generally satisfactory with graphite-moderated reactors, as we confirmed by benchmarking
with Serpent for a similar reactor [!citep](giudicelli2021). We select the `eigenvalue` equation type as the steady state coupling is an
eigenvalue calculation for neutron transport. The steady state is the eigenpair of the $k_{eff}$ and the
steady flux distribution. We also specify the boundary conditions in this block. This is a 2D RZ model,
so the center of the geometry is an axis of symmetry with a reflecting boundary condition on the `left` of the model. A vacuum boundary condition is placed on the other boundaries. This approximation is appropriate when the boundaries are sufficiently far from the active region.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=TransportSystems

### Mesh

The next part of the input specifies the geometry. Here we use the `CartesianMeshGenerator` to create our own mesh, specifying 5 blocks, including the `pebble_bed`, `reflector`, `ss` stainless steel vessel, `downcomer`, and  `cr` the control rod. Here we have a 2D, RZ model, and use the `subdomain_id` to draw our mesh with `dx` and `dy` setting the width of the corresponding `ix` and `iy` which determine the number of elements in the mesh matching what is drawn in `subdomain_id`.

The neutronics mesh is shown in [neutronics_mesh].

!media gFHR/gFHR_neutronics_mesh.png
  caption= Griffin equilibrium core mesh from [!citep](gFHR_report).
  id=neutronics_mesh
  style=width:100%;margin-left:auto;margin-right:auto

We then edit the mesh, through the `SubdomainExtraElementIDGenerator` to define material_ids and subsequently use `RenameBlockGenerator` to merge block 2 into block 1.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Mesh

### Auxiliary Variables

The Variables and Kernels need not be defined when using Griffin, as the `TransportSystems` block is an [Action](https://mooseframework.inl.gov/source/actions/Action.html) in
MOOSE vocabulary that takes care of defining those. However it is helpful to define [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/) which can be used to define fields/variables that are not solved for. They may be used for coupling, for
computing material properties, for outputting quantities of interests, and many other uses. In this input file, `Tsolid` and `Rho` are used to incorporate fields from the thermal hydraulics simulation for a multiphysics coupled solution. These fields are populated by
[Transfers](https://mooseframework.inl.gov/syntax/Transfers/) from the Pronghorn app, and will be discussed further in the input file. We also define other auxiliary variables to track items like `burnup`, `porosity`, and power densities or temperatures like `pden_avg` and `Tmod_max`.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=AuxVariables

### Auxiliary Kernels

Next, we define [AuxKernels](https://mooseframework.inl.gov/moose/syntax/AuxKernels/) which operate on [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/). They may scale, multiply, add and perform many other operations.
They may be block restricted, as some [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/) are not defined over the entire domain, or they may inherit the
same block restriction as the variable. Some examples here are Auxiliary Variables which find the max or average value `pden_max` and `Tfuel_avg` using the `ArrayVarExtremeValueAux` and `PebbleAveragedAux` respectively. We also set the porosity auxiliary variable through a `FunctionAux` which reads in a function called `porosity_f` which will be discussed next.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=AuxKernels

### Functions

Functions may be defined in MOOSE in a [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block.
Here a function to define the porosity is read in using the `PiecewiseMulticonstant` function to read a data file defined in the text file `gFHR_porosity.txt`. Additionally the control rod position is set in this input using
a `ConstantFunction`.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Functions

### Pebble Depletion

Now we introduce a new capability developed in Griffin for this specific model to do PBFHR depletion with streamlines for pebble shuffling and achieve an equilibrium core. This [PebbleBed](https://griffin-docs.hpc.inl.gov/latest/syntax/PebbleBed/index.html) action is quite extensive and the theory can be found [here](https://griffin-docs.hpc.inl.gov/latest/memoranda/pebble_depletion_theory.html).

Therefore, we will very briefly cover this block at a high level. First the Pebble Depletion action reads in variables and Auxiliary variables such as the `power`, `burnup`, `Tfuel`, `Tmod`, and `Rho`. The coolant and pebble compositions are read in from the `Compositions` block which will be covered shortly. Transmutation data in the ISOXML format is read in for this problem from the file `DRAGON5_DT.xml`. Specific Pebble and Tabulation options are also specified.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=PebbleBed

More specifically, the specific `DepletionScheme` that is used here is the [ConstantStreamLineEquilibrium](https://griffin-docs.hpc.inl.gov/latest/source/pebbledepletion/pebbledepletionschemes/ConstantStreamlineEquilibrium.html) option. Here the streamlines of the shuffling pebbles are used to correctly determine the equilibrium depletion.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=PebbleBed/DepletionScheme

Lastly, the pebble conduction problem is solved through a sub-app `gFHR_pebble_triso_ss.i` where the positions are loaded in from the text data file `pebble_heat_pos_16r_40z.txt`. Specific postprocessors from that sub-app are then read in and used in the `PebbleBed` action. See [this page](pebble_triso.md) for more information on the multiscale pebble - triso fuel performance model.

### Compositions

Next, specific `Compositions` are defined that will be read in by the `PebbleBed` actions. Here [IsotopeComposition](https://griffin-docs.hpc.inl.gov/latest/source/compositions/IsotopeComposition.html) is used to define the `coolant` and `pebble` isotopic compositions. These compositions are then loaded into the `PebbleBed` action previously described.

### Materials

The group cross sections are distributed through the geometry using the [Materials](https://mooseframework.inl.gov/moose/syntax/Materials/) block. Each block in this
section is a `Material` object defining the group cross section in a block.

Here there are two types of neutronics materials including the [CoupledFeedbackRoddedNeutronicsMaterial](https://griffin-docs.hpc.inl.gov/latest/source/materials/CoupledFeedbackRoddedNeutronicsMaterial.html) and the [CoupledFeedbackMatIDNeutronicsMaterial](https://griffin-docs.hpc.inl.gov/latest/source/materials/CoupledFeedbackMatIDNeutronicsMaterial.html). Here the `CR_dynamic` material is used to define the control rod, and the `downcomer` and `non-pebble-bed-regions` correspondingly identify the material and the auxiliary variables that are read in from the Pronghorn sub-app.

Specifically, the `CoupledFeedbackMatIDNeutronicsMaterial` is used to take into account the effect of the fuel and salt temperature on the group cross section. The cross section library name and the file containing it are specified using the [GlobalParams](https://mooseframework.inl.gov/syntax/GlobalParams/index.html) block. The temperature dependence is captured using a tabulation. The names used in the tabulation are matched to the variables in the simulation using `grid_names` and `grid_variables`. The correct entry in the library is selected using the `material_id`, except this was read in previously from material IDs in the mesh in `assign_material_id`.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Materials

### Executioner

The [Executioner](https://mooseframework.inl.gov/source/executioners/Executioner.html) block specifies how to solve the equation system. We choose an eigenvalue executioner,
`Eigenvalue`, as a criticality calculation is
an eigenvalue problem. The solve type uses the `PJFNKMO` or the Preconditioned Jacobian-Free Newton_krylov - Matrix Only methods of solving the eigenvalue problem.

The number of non-linear iterations and the non-linear relative and absolute convergence criteria may be
respectively reduced and loosened to reduce the computational cost of the solution at the expense of its
convergence. Additionally, for multiphysics coupled solutions, the fixed point iteration convergence criteria can also be specified.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Executioner

### MultiApps

The Pronghorn sub-application is created by the [MultiApps](https://mooseframework.inl.gov/syntax/MultiApps/index.html) block with the pronghorn input file being `gFHR_pronghorn_ss.i`. Since we are seeking a steady state solution, we
want the thermal hydraulics problem to be fully solved at every multiphysics iteration. This is accomplished by a
[FullSolveMultiApp](https://mooseframework.inl.gov/source/multiapps/FullSolveMultiApp.html). The `execute_on` field is set to `timestep_end` and `FINAL` to have the thermal hydraulics solve be
performed after the neutronics solve. This means that for the first multiphysics iteration, the temperature fields in the neutronics solve will be set to an initial guess, while the power distribution in the thermal hydraulics solve will be updated once already. `0 -0.09 0` is specified for the position since the two meshes are slightly different and not aligned.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=MultiApps

### Transfers

The coupling to the thermal hydraulics simulation is done by using a [MultiAppGeneralFieldNearestLocationTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppGeneralFieldNearestLocationTransfer.html) of the power density to the pronghorn sub-app. This transfer is conservative, in that the total power in both applications is preserved. This is important for the multiphysics coupling, as the power will not fluctuate in the thermal hydraulics simulation based
on the power density profile and the difference between the neutronics and thermal hydraulics meshes.

The conservation of the transfer is achieved through the specification of two postprocessors, one in the source and one in the receiving simulations, which are used to compute a scaling factor.

Additionally, the pronghorn sub-application sends steady state thermal hydraulics solutions of the temperature `Tsolid` and density `Rho` back to the neutronics solve to update the new flux, and eigenvalue until the multiphysics solution converges within tolerance set in the `Executioner`.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Transfers

### Postprocessors

The second to last block is the [Postprocessors](https://mooseframework.inl.gov/syntax/Postprocessors/index.html) block which specifies calculations that should be made regarding the solution so that data analysis and interpretation of results can be performed. Key items of interest here are the `ElementAverageValue` for variables of interest like the temperature in the core, or density of the coolant in the core. Similarly `ElementExtremeValue` finds the maximum value of certain variables on the mesh and reports them. These postprocessors will be displayed in the output to terminal, but will also be stored in the CSV if that option is selected in the `Outputs` block.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Postprocessors

### Outputs

Finally, the [Outputs](https://mooseframework.inl.gov/syntax/Outputs/index.html) block indicates which types of outputs the simulation should return. We specify here two major
types:

- exodus. [Exodus](https://mooseframework.inl.gov/source/outputs/Exodus.html) files contain the mesh, the (aux)variables and global quantities such as postprocessors. We can
  use Paraview to view the spatial dependence of each field. They may be used to restart simulations.

- comma-separated values, or [csv](https://mooseframework.inl.gov/source/outputs/CSV.html). This file reports the values of the postprocessors at each time step. They are
  useful for easily importing then plotting the simulation results using Python or Matlab.

!listing /pbfhr/gFHR/steady/gFHR_griffin_cr_ss.i block=Outputs
