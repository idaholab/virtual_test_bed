# GPBR200 Multiphysics Coupling

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Coupled Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/gpbr200/coupling)*

Here the input for the fully coupled GPBR200 model is presented. This combines
the physics presented in the [neutronics model](gpbr200/core_neutronics.md),
[thermal hydraulics model](gpbr200/core_thermal_hydraulics.md), and
[pebble thermomechanics model](gpbr200/pebble_thermomechanics.md).

## MultiApp Structure

[!ref](fig:gpbr200_multiapp_diagram) shows the `MultiApp` structure employed for
the multiphysics, along with the transfers of coupled fields. The
neutronics-depletion input serves as the main application, transferring power
density to the thermal hydraulics and pebble heat conduction applications. The
solid temperature is received from the TH application to evaluate cross sections
in the reflector regions and transferred to the pebble applications for the
pebble surface boundary condition. Finally, the fuel and moderator temperatures
are received from the pebble applications for cross-section evaluation in the
pebble bed.

!media gpbr200/gpbr200_multiapp_diagram.jpg
    caption=`MultiApp` structure of GPBR200 equilibrium core from [!cite](prince2024Sensitivity).
    id=fig:gpbr200_multiapp_diagram

The order of operations for a given fixed-point iteration is:

1. Pebble heat conduction solves
2. Streamline depletion solve
3. Neutronics eigenvalue solve
4. Thermal hydraulics solve

## Input Modifications

This section focuses on the key differences in the coupled inputs from the
stand-alone physics inputs previously presented.

### Pebble Heat Conduction Input

There are no meaningful modifications to the pebble heat conduction input, the
only adjustment is in the `Outputs` to reduce the amount of screen output.

!listing gpbr200/coupling/gpbr200_ss_bsht_pebble_triso.i
    diff=gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Outputs


### Thermal Hydraulics Input

The only modification to the thermal hydraulics input is the removal of the
power density auxiliary kernel and the supporting volume postprocessor.

!listing gpbr200/coupling/gpbr200_ss_phth_reactor.i
    diff=gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=AuxKernels Postprocessors Outputs

### Neutronics-Depletion Input

The majority of the input modifications are in the neutronics input, which
serves as the main application; defining the `MultiApps` and `Transfers`.

First, the thermal hydraulics application is defined, with transfers for the
power density to the sub-application and solid temperature from the application.
In order to speed up steady-state convergence of the pseudo-transient
simulation, `keep_solution_during_restore = true` is specified.

!listing gpbr200/coupling/gpbr200_ss_gfnk_reactor.i
    block=MultiApps/pronghorn_th
          Transfers/to_pronghorn_total_power_density
          Transfers/from_pronghorn_Tsolid

Next, the pebble heat conduction `MultiApp` is defined. A `Positions` object is
defined to specify the location of the applications. For this model an
application is defined for each cell in the pebble bed region. This position
object is repeated for each pebble burnup group, since each group has a unique
power density. The result is a total of $300 \text{ cells} \times 13 \text{
burnup groups} = 3,900$ applications. For consistency in the TRISO geometry and
pebble composition, the kernel radius and filling factor are transferred at
application creation via `cli_args`. The solid temperature is transferred to the
postprocessor of the sub-applications, based on their position. The power
density is similarly transferred, except the `partial_power_density` is an array
variable where each component corresponds to a burnup group. Finally, the the
fuel and moderator temperature are transferred from the sub-applications, again
based on their position and burnup group index.

!listing gpbr200/coupling/gpbr200_ss_gfnk_reactor.i
    block=Positions
          MultiApps/pebble_conduction
          Transfers/to_pebble_conduction_Tsolid
          Transfers/to_pebble_conduction_power_density
          Transfers/from_pebble_conduction_Tfuel
          Transfers/from_pebble_conduction_Tmod

For easier visualization, several auxiliary variables are defined representing
the max power density, fuel temperature, and moderator temperature across burnup
groups.

!listing gpbr200/coupling/gpbr200_ss_gfnk_reactor.i
    block=AuxVariables/Tfuel_max AuxVariables/Tmod_max AuxVariables/ppd_max AuxKernels


## Results

The input must be run with an executable including Griffin, Pronghorn, and
Bison, i.e. `blue-crab-opt`:

```
mpiexec -n 16 blue_crab-opt -i gpbr200_ss_gfnk_reactor.i
```

The resulting eigenvalue is approximately 1.00125.
[!ref](fig:gpbr200_ss_gfnk_reactor) shows the resulting power density, fast
scalar flux, and thermal flux. [!ref](fig:gpbr200_ss_phth_reactor) shows the
resulting fluid velocity, pressure, temperature, and solid temperature.
[!ref](fig:gpbr200_ss_bsht_pebble_triso) shows the resulting max power density,
fuel temperature, and moderator temperature across burnup groups.

!media gpbr200/gpbr200_ss_gfnk_reactor.png
    caption=GPBR200 neutronics selected field variables
    id=fig:gpbr200_ss_gfnk_reactor

!media gpbr200/gpbr200_ss_phth_reactor.png
    caption=GPBR200 fluids selected field variables
    id=fig:gpbr200_ss_phth_reactor

!media gpbr200/gpbr200_ss_bsht_pebble_triso.png
    caption=GPBR200 pebble heat conduction selected field variables
    id=fig:gpbr200_ss_bsht_pebble_triso

The use of 16 processors in the command listing is somewhat arbitrary,
[!ref](tab:gpbr200_ss_gfnk_rt) shows the expected scaling performance.

!table caption=Run times for GPBR200 multiphysics simulation with varying number of processors id=tab:gpbr200_ss_gfnk_rt
| Processors | Run-time (min) |
| ---------- | -------------- |
|          4 | 40             |
|          8 | 26             |
|         16 | 7              |
|         32 | 4              |
