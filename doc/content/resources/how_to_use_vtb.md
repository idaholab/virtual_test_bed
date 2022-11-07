# First time using the Virtual Test Bed

In this short tutorial, we will feature how the Virtual Test Bed should be used for the Molten Salt Reactor
multiphysics core simulation using Griffin and Pronghorn, starting from the very beginning: a fresh install.
Instructions for updating the Virtual Test Bed on your local machine are situated at the bottom of this page.

!alert note
A similar [tutorial is available](neams-workbench.md) for using the NEAMS workbench with the VTB on INL HPC.

## Step 1: Clone the repository

### Using git to download the repository style=font-size:125%


Cloning the repository using `git` will make a local copy of the repository on your machine. It will download
most files and place them in the same file/folder structure as can be found on the online interface. Only the
larger files will initially be left out as they are tracked by `git-lfs`. If both applications are installed,
then a `git clone` will download both the regular and large files.

!alert note
To install `git`, see instructions [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for example

### git Large File System : meshes and sample outputs style=font-size:125% id=lfs


For several models, the mesh files are too large to be hosted on github directly. We leverage `git-lfs` to
store them. This application is not natively installed on most machines, so you will have to install it yourself.
If you are not interested by these models, feel free to skip this step.

!alert note
To install `git-lfs`, see instructions [here](https://git-lfs.github.com/) for example

### Cloning the repository style=font-size:125%


To clone the repository, navigate to the `projects` directory first, then use `git clone`. The `git` part should be
done very fast. Downloading the large files will take longer depending on your internet connection.

```
    cd ~/projects  # this directory is often created when installing NEAMS tools
    git clone git@github.com:idaholab/virtual_test_bed.git
```

!alert note
It is also possible to download a zip file of the repository. However this is not recommended as using
git provides highly desirable change-tracking and an easy way to maintain your local repository updated
with the latest changes of the Virtual Test Bed. Using zip files will also not download the large files.

## Step 2: Navigate to the model of interest

The local directory structure mirrors the [online repository](https://github.com/idaholab/virtual_test_bed).
The input files are sorted by reactor class then model then by simulation type. If we are interested in the Molten Salt
Fast Reactor inputs, we go to the msr folder, then the msfr folder.

```
  cd ~/projects/virtual_test_bed/msr/msfr
```

Simultaneously, we navigate on the documentation website to the [page for the MSFR](https://mooseframework.inl.gov/virtual_test_bed/msfr/index.html)
to have information about the model and the different simulations available. We are interested in the steady state
core analysis, so we navigate to the `steady` folder next.

!alert note
If interested in a particular simulation type rather than a particular reactor, please see this
[index of simulations](resources/simulation_type.md), which sorts the inputs by simulation type rather
than by reactor.

## Step 3: Use the relevant application to run the input file

Once you have located the inputs, the first step is to select the right application to run it.
This information may be found in multiple locations, including the documentation and the header of the input
file.

### From the command line style=font-size:125%


To run an input file from the command line, it must be provided to the executable, for code `<code_name>`, like this:

```
  ~/projects/<code_name>/<code_name>-opt -i <input_file>
```

For the MSFR simulation, multiple applications, Griffin and Pronghorn, need to be used. They are
gathered in combined applications such as `blue_crab`.

```
  cd ~/projects/virtual_test_bed/msr/msfr/steady
  ~/projects/blue_crab/blue_crab-opt -i run_neutronics.i # for coupled multiphysics model
  ~/projects/blue_crab/blue_crab-opt -i run_ns.i         # to run only the fluid simulation
```

### Using the Peacock GUI style=font-size:125%


An alternative to running NEAMS tools from the command line is to use the Peacock GUI.
Peacock should be provided an executable and an input file. Its interface contains five tabs:

- Input file tab, an integrated text editor to modify the input file
- Execute tab, to set execution parameters and view the log during the simulation
- ExodusViewer, to view multidimensional results during the simulation, such as variable values
- PostprocessorViewer, to view the time evolution of Postprocessors during the simulation
- VectorPostprocessorViewer, to view the time evolution of vectors of Postprocessors during the simulation


More information may be about about Peacock on [this page](https://mooseframework.inl.gov/moose/application_usage/peacock.html).

## Step 4: Adapt the model for your reactor or your simulation

### Changing the mesh file style=font-size:125%


If you are modeling a similar reactor type and are trying to model the same physics in the same
conditions, then only very limited changes to the input file may be required. The mesh file may be
changed in the `[Mesh]` block, usually in a `FileMeshGenerator`. For example, for the MSFR inputs, the file
parameter in this block may be changed.

!listing msr/msfr/steady/run_neutronics.i block=Mesh

Once the mesh is changed, the users should adapt all `blocks` and `boundaries` fields in the input files.
The names of those spatial regions are most likely different between the original mesh file and the one you
provided. In most input files, `Variables`, `AuxVariables` and `Materials` are only defined on some blocks,
and `BCs` (boundary conditions) are only defined on certain boundaries.

### Changing the simulation style=font-size:125%


Modifying the simulation may require more effort and is highly dependent on the application you are using.
We will refer you to the documentation for the application of interest (i.e. Pronghorn, Griffin, etc.) for more information. Please feel free to reach
out on the [Discussions forum](https://github.com/idaholab/virtual_test_bed/discussions) for help.

### Postprocessing resources style=font-size:125%


Once you have ran your simulation the results may be output in numerous ways. More details are provided in
the [MOOSE Outputs documentation](https://mooseframework.inl.gov/syntax/Outputs/index.html). For `Exodus` output,
there are two main options to visualize your results:

- Paraview \\
  Paraview is a free visualization software provided by Kitware. It has a flexible GUI which will
  allow you to visualize your results through time and space and output results to videos or image files.

- chigger and python VTK libraries \\
  Chigger is an in-house python library used to make highly customizable visualization scripts. It lets you adjust
  visualization parameters such as the angle, the pixel count, the positions of the objects and easily generate outputs
  consistently for different variables in a simulation or between different simulations. See [this page](https://mooseframework.inl.gov/python/chigger/)
  for more information.

- Peacock \\
  Peacock is an in-house visualization application for MOOSE-based apps. It has many less options than Paraview,
  and is generally more recommended in the modeling phase than for postprocessing. Peacock leverages Chigger.


# Updating the Virtual Test Bed

The Virtual Test Bed is very regularly updated. This is because NEAMS tools are always evolving and inputs are rapidly deprecated if
they are not kept up to date with the latest syntax. To update your local copy of the repository, run the following commands

```
  git pull origin main
```

This will update the `main` branch. If you are working on modifying inputs in a local branch, you may
use this instead to rebase your branch. This will move your work on top of the latest state of the virtual test
bed. If your work and the VTB updated conflict, this will warn you and let you address the conflicts.

```
  git fetch origin
  git rebase origin/main
```
