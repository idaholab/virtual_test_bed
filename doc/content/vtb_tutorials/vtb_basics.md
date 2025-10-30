# VTB Basics Tutorial

In this short tutorial, we will feature how the VTB should be used for a Molten Salt Reactor (MSR)
multiphysics core simulation using Griffin and Pronghorn.

First, if you have not already done so, follow the instructions on [vtb_pages/getting_started.md] (or [vtb_tutorials/neams-workbench.md] if you would like to use NEAMS Workbench on INL HPC) to install the VTB.

Browsing the various model indices for our desired reactor type and simulation, we find the steady-state Molten Salt Fast Reactor (MSFR) model [msr/msfr/griffin_pgh_model.md]. Following "Model link", we navigate to `msr/msfr/steady`:

```
cd ~/projects/virtual_test_bed/msr/msfr/steady
```

Now we run this model using the relevant applications. If you have not done so already, please see [vtb_pages/running_models.md] for the basics of running a MOOSE-based application (such as Griffin and Pronghorn). In this example, we use a Multiphysics application called BlueCRAB, which contains both Griffin and Pronghorn. If we want to run the coupled multiphysics model, we execute

```
~/projects/blue_crab/blue_crab-opt -i run_neutronics.i
```

but if we want to only run the fluid simulation, we execute

```
~/projects/blue_crab/blue_crab-opt -i run_ns.i
```

## Making Modifications to Models

Now we begin to adapt the models for our own purposes.

### Changing the Mesh

If you are modeling a similar reactor type and are trying to model the same physics in the same
conditions, then only very limited changes to the input file may be required. The mesh file may be
changed in the `[Mesh]` block, usually in a `FileMeshGenerator`. For example, for the MSFR inputs, the file
parameter in this block may be changed.

!listing msr/msfr/steady/run_neutronics.i block=Mesh

Once the mesh is changed, the users should adapt all `blocks` and `boundaries` fields in the input files.
The names of those spatial regions are most likely different between the original mesh file and the one you
provided. In most input files, `Variables`, `AuxVariables` and `Materials` are only defined on some blocks,
and `BCs` (boundary conditions) are only defined on certain boundaries.

### Changing the Simulation

Modifying the simulation may require more effort and is highly dependent on the application you are using.
We will refer you to the documentation for the application of interest (i.e. Pronghorn, Griffin, etc.) for more information. Please feel free to reach
out on the [Discussions forum](https://github.com/idaholab/virtual_test_bed/discussions) for help.

### Postprocessing

Once you have run your simulation the results may be output in numerous ways. More details are provided in
the [MOOSE Outputs documentation](https://mooseframework.inl.gov/syntax/Outputs/index.html). For `Exodus` output,
there are two main options to visualize your results:

- +Paraview+: Paraview is a free visualization software provided by Kitware. It has a flexible GUI which will
  allow you to visualize your results through time and space and output results to videos or image files.
- +Chigger and python VTK libraries+: Chigger is an in-house python library used to make highly customizable visualization scripts. It lets you adjust
  visualization parameters such as the angle, the pixel count, the positions of the objects and easily generate outputs
  consistently for different variables in a simulation or between different simulations. See [this page](https://mooseframework.inl.gov/python/chigger/)
  for more information.

## Updating the VTB

If you would like to get the most up-to-date version of the VTB, see [vtb_pages/updating.md].

## Citing the VTB

If you publish work based on models derived from the VTB, please [cite the VTB](vtb_pages/citing.md).
