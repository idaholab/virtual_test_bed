# First time using the Virtual Test Bed

In this short tutorial, we will feature how the Virtual Test Bed should be used for the Molten Salt Reactor
multiphysics core simulation using Griffin and Pronghorn, starting from the very beginning: a fresh install.

## Step 1: Clone the repository

### Using git to download the repository

Cloning the repository using `git` will make a local copy of the repository on your machine. It will download
most files and place them in the same file/folder structure as can be found on the online interface. Only the
larger files will initially be left out as they are tracked by `git-lfs`. If both applications are installed,
then a `git clone` will download both the regular and large files.

!alert note
To install `git`, see instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for example

### git Large File System : meshes and sample outputs

For several models, the mesh files are too large to be hosted on github directly. We leverage `git-lfs` to
store them. This application is not natively installed on most machines, so you will have to install it yourself.
If you are not interested by these models, feel free to skip this step.

!alert note
To install `git-lfs`, see instructions [here](https://git-lfs.github.com/) for example

### Cloning the repository

To clone the repository, navigate to the `projects` directory first, then use `git clone`. The `git` part should be
done very fast. Downloading the large files may take several minutes.

```
    cd ~/projects  # this directory is often created when installing NEAMS tools
    git clone git@github.com:idaholab/virtual_test_bed.git
```

!alert note
It is also possible to download a zip file of the repository. However this is not recommended as using
git provides highly desirable change-tracking and an easy way to maintain your local repository updated
with the latest changes of the Virtual Test Bed. Using zip files will also not download the large files.

## Step 2: Navigate to the model of interest

The local directory structure mirrors the one on the [online repository](https://github.com/idaholab/virtual_test_bed).
The input files are sorted by reactor types. If we are interested in the Molten Salt Fast Reactor inputs, we go to their
folder with

```
  cd ~/projects/virtual_test_bed/msr/msfr
```

Simultaneously, we navigate on the documentation website to the [page for the MSFR](https://mooseframework.inl.gov/virtual_test_bed/msfr/index.html)
to have information about the model and the input file.

!alert note
If interested in a particular simulation type rather than a particular reactor, please see this
[index of simulations](resources/simulation_type.md).

## Step 3: Use the relevant application to run the input file

- installing the application

- running

- peacock

## Step 4: Adapt the model for your reactor or your simulation

### Changing the mesh file

If you are modeling a similar reactor type and are trying to model the same physics in the same
conditions, then only very limited changes to the input file may be required. The mesh file may be
changed in the `[Mesh]` block, usually in a `FileMeshGenerator`. For example, for the MSFR inputs, the file
parameter in this block may be changed.

!listing msr/msfr/steady/run_neutronics.i block=Mesh

Once the mesh is changed, the users should adapt all `blocks` and `boundaries` fields in the input files.
The names of those spatial regions are most likely different between the original mesh file and the one you
provided. In most input files, `Variables`, `AuxVariables` and `Materials` are only defined on some blocks,
and `BCs` (boundary conditions) are only defined on certain boundaries.

### Changing the simulation

Modifying the simulation may require more effort and is highly dependent on the application you are using.
We will refer you to the documentation for this application for more information. Please feel free to reach
out on the [Discussions forum](https://github.com/idaholab/virtual_test_bed/discussions) for help.

### Postprocessing resources


# Updating the Virtual Test Bed
