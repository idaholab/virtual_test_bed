# MCNP 6.2 STARTR Model

The MCNP model for STARTR was made using version . The input is commented and describes the geometry, materials, and movement of the control drums for the model. The input is configured for k-eigenvalue calculations. 

!media media/STARTR/MCNP_STARTR_xy_radial.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=startr_mcnp_radial
      caption= STARTR MCNP radial reactor geometry with control drums at cold critical position

## Adding Tallies

There are no tallies used in this base model. Tallies may be added by the user to investigate specific parameters of interest in the model (e.g. flux, flux spectrum, fission densities, reaction rates, etc.) See the MCNP 6.2 User's Manual [!citep](MCNP62UserManual) for more information. 

## Customizing Runtime Settings

The runtime settings are defined in the execution of MCNP in serial or in parallel mode. The installation of MCNP must support parallel calculations to run in parallel mode. 

## Running the Model

Running MCNP is executed from the shell. The execution commands for serial or parallel are below.  

!listing id=mcnp6_exec_cmd caption=MCNP serial execution command
mcnp6 i=STARTR_MCNP.input.txt

!listing id=mcnp6_exec_cmd_parallel caption=MCNP parallel execution command
mpirun mcnp6 i=STARTR_MCNP.input.txt n=48

will run the code in parallel with 48 cores. Customize this to the number of cores you wish to use for MCNP.
