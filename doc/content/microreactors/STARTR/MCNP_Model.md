# MCNP 6.2 STARTR Model

The MCNP model for STARTR was made using MCNP version 6.2. The input is commented and describes the geometry, materials, and movement of the control drums for the model. The input is configured for k-eigenvalue calculations. 


!media MCNP_STARTR_xy_radial.png id=mcnpxy caption=STARTR MCNP radial reactor geometry with control drums at cold critical position style=width:80%;margin-left:auto;margin-right:auto

!media MCNP_STARTR_yz_axial.png id=root caption=STARTR MCNP axial reactor geometry style=width:80%;margin-left:auto;margin-right:auto

## Adding Tallies

There are no tallies used in this base model. Tallies may be added by the user to investigate specific parameters of interest in the model (e.g. flux, flux spectrum, fission densities, reaction rates, etc.) See the MCNP 6.2 User's Manual [!citep](MCNP62UserManual) for more information. 


## Customizing Runtime Settings

The runtime settings are defined in the execution of MCNP in serial or in parallel mode. The installation of MCNP must support parallel calculations to run in parallel mode. 

## Running the Model
Running the OpenMC executable is defined at the bottom of the monolithic python script, there are two options for you to choose from.

```
mcnp6 i=STARTR_MCNP.input.txt
```
will run in serial mode, which can be unecessarily slow if one has access to more cores.

If the MCNP install has MPI enabled, then use something like:

```
mpirun mcnp6 i=STARTR_MCNP.input.txt n=48
```
will run the code in parallel with 48 cores. Customize this to the number of cores you wish to use for MCNP.
