# Running the Input File

SAM can be run in Linux, Unix, and MacOS.  Due to its
dependence on MOOSE, SAM is not compatible with Windows.  
SAM can be run from the shell prompt as shown below

```language=bash

/projects/SAM/sam-opt -i mhtgr.i

```

# Results

There are three types of output files:

1. +MHTGR_csv.csv+: this is a `csv` file that writes the user-specified scalar
    and vector variables to a comma-separated-values file. The data can be imported
    to Excel for further processing or in Python using the `csv` module, Pandas,
    or other methods.

2. +MHTGR_checkpoint_cp+: this is a sub-folder that save snapshots of the simulation
    data including all meshes, solutions. Users can restart the run from where it ended
    using the file in the checkpoint folder.

3. +MHTGR_out.displaced.e+: this is a `ExodusII` file that has all mesh and
    solution data. Users can use Paraview to open this .e file to visualize, plot,
    and analyze the data.

Figure 1 shows the Paraview output for the primary loop.
[mhtgr_temp] shows the coolant temperature profile during normal operation

!media /mhtgr/mhtgr_sam_model.png
       style=width:60%
       id=mhtgr_model
       caption=SAM model for the MHTGR primary loop

!media /mhtgr/mhtgr_temperature.png
       style=width:80%
       id=mhtgr_temp
       caption=Temperature profiles of helium coolant (left) and heat
       structure (right) during normal operation
