# Depressurized Loss of Forced Cooling Transient (DLOFC)

The DLOFC transient simulation was initiated by [!citep](reitsma2013pbmr):
1. Reducing the mass flow rate of the coolant linearly from its nominal value to zero over thirteen seconds. 
2. The system pressure was reduced linearly from 7.0 MPa to atmospheric pressure (0.101 MPa).
3.  the control rods were fully inserted (SCRAM) to shutdown the reactor after completing the flow rate and pressure ramps. 
4. Beyond that, there were no changes to the system's  main parameters, and the simulation was performed for up to 140 hours. 

During the DLOFC transient simulation, coupled neutronics and thermal-hydraulics calculations were performed and the following progression of the reactor parameters was observed during the transient:
1. The reactor power starts decreasing at the beginning of the transient due to the negative thermal feedback.
2. The prompt power goes to zero while the remaining reactor power is just the decay heat component of the fuel. 
3. The maximum fluid and solid temperatures start moving axially and toward the top of the core.
4. Temperature distributions change mainly in the radial direction, and there is a significant change in the solid temperature of the reflector and RPV regions.
5. The maximum fuel temperature reaches 1503.26 °C (1776.41 K) during DLOFC transient compared to the reference results which is around 1500 °C [!citep](zheng2018study) and [!citep](strydom2008tinte).

The set of input files to run the DLOFC can be thought of as the left hand side of the app setup show in [apps_setup_3].

!media media/htrpm_coremultiphysics/apps_setup_3.png
  style=width:50%
  id=apps_setup_3

Thus, two inputs are required for this problem.
These are the ```htr_pm_neutronics_tr_dlofc.i``` and ```htr-pm-flow-fv-tr-dlofc.i```
The first input sets the neutronics calculations and calls the second input which performs the Pronghorn calculations.
The neutronics input is mostly similar to the input in the neutronics section model.
The major difference is in the ```MultiApps``` block in which the pebble/Triso conduction solution is eliminated compared to the steady state input ```htr_pm_neutronics_ss.i```.

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr_pm_neutronics_tr_dlofc.i block=MultiApps

For the reader's information, ```Mesh``` is imported from a previous run instead of redefining it.

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-tr-dlofc.i block=Mesh

The ```Modules``` block, variables are imported from the Exodus file. Notice ```velocity_variable```, ```pressure_variable```, and ```fluid_temperature_variable``` definition in ```Modules```.

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-tr-dlofc.i block=Modules

Additional initial initial conditions are imported from previous run as in the ```Variables``` block.

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-tr-dlofc.i block=Variables

The most important difference between the steady state and the transient case calculation is the fact that the transient case (i.e. DLOFC) changes the boundary conditions to mimic the of DLOFC, while the steady state case is ran in "transient" mode till the calculation is converged to the steady state solution.
The pressure, temperature, mass flow variations are defined in the ```Functions``` block as follows

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-tr-dlofc.i block=Functions

# Results

The fluid temperature distribution at different time steps of the transient are
in [fluid-temperature-dist].
The pebble surface temperature distribution as a function of time is shown in
[solid-temperature-dist].

!media media/htrpm_coremultiphysics/fluid-temperature-dist.png
  style=width:50%
  id=fluid-temperature-dist
  caption=Fluid temperature distribution as a function of time in DLOFC accident condition

!media media/htrpm_coremultiphysics/solid-temperature-dist.png
  style=width:50%
  id=solid-temperature-dist
  caption=Pebble surface temperature distribution as a function of time in DLOFC accident condition
