# OpenMC 0.13.3 STARTR Model

The OpenMC model for STARTR was made using OpenMC version 0.13.3. 
The code is also heavily commented, and explains each section as a walkthrough within the monolithic python file. The sole helper file, na\_density.py calculates the density of sodium under [!citep](NaK1972). Currently, the code is only configured for k-eigenvalue calculations, with no tallies included.

## Adding Tallies

The OpenMC code uses python-generated `.xml` files as inputs for the significantly faster executable written in C++. Thus, to add tallies of your own, you need to generate a tally which records the data you're interested in. Exporting the `tallies.xml` to the same directory as the main python file will cause the tallies to automatically be applied to the next simulation you run. Below is an example of a short python script that will generate a flux tally over a 2-D mesh of the vessel core. More details on tally options and filters can be found in the [OpenMC documentation](https://docs.openmc.org/en/latest/usersguide/tallies.html).

!listing /microreactors/STARTR/snippets/openmc-tallies.py
         id=omc_reg2
         caption=Script for OpenMC tallies.

## Customizing Runtime Settings

The runtime settings are slightly more cumbersome to edit, as they are currently baked into the bottom of the monolithic python file that also runs the openmc executable. The code snippet of this section is provided. If you wish to change the runtime settings, remove the lines in the monolithic file that define the settings, and create a new python script similar to the tallies script that can generate a settings.xml file for OpenMC to read.

## Running the Model

Running the OpenMC executable is defined at the bottom of the monolithic python script, there are two options for you to choose from.

!listing id=openmc_exec_cmd caption=OpenMC serial execution command
openmc.run()

will run the code with one process (and one thread,) which can be unnecessarily slow if one has access to more cores.

!listing id=openmc_exec_cmd_parallel caption=OpenMC parallel execution command
openmc.run(mpi_args=['mpiexec', '-n', '48'])

will run the code in parallel with 48 cores. Customize this to the number of cores you wish to use for OpenMC.
