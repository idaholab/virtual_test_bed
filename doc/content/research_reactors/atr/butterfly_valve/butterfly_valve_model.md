# ATR Butterfly-Valve Model using coarse mesh thermal hydraulics

*Contact: Daniel Yankura, daniel.yankura@inl.gov

*Model link: [ATR Butterfly-Valve Model](https://github.com/idaholab/virtual_test_bed/tree/main/research_reactors/atr/butterfly_valve)*

!tag name=ATR Butterfly-Valve Model
     description=3D Steady state coarse mesh CFD model of a butterfly-vale used at ATR, using the Navier-Stokes module
     image=https://mooseframework.inl.gov/virtual_test_bed/media/atr/42deg_coarse_zoom_mesh.png
     pairs=reactor_type:LWR
           geometry:valve
           simulation_type:CFD
           codes_used:MOOSE_NavierStokes
           open_source:fully
           computing_needs:HPC
           fiscal_year:2024;2025
           institution:INL

The advanced test reactor (ATR) at INL employs a butterfly-valve to control pressure drop across the reactor core.
The simulations of this valve utilized the Navier-Stokes module in MOOSE for all simulations.
Running this model will require HPC resources, and the simulation's setup will be described below. Simulations of this valve
have been performed before using STAR-CCM+ [!cite](ECAR6453). The motivation for performing additional simulations in MOOSE, is its open-source nature
as well as its ability to easily couple with other modules to create complex multiphysics simulations.

# Physics Models

All simulations used the finite volume discretization of the incompressible Navier-Stokes equations.
The following sections go into greater detail on how the simulations were carried out including meshing, simulation parameters,
and computational resources used. Detailed documentation on the MOOSE Navier-Stokes module, the mixing-length turbulence method, as
well as the other parameters used, see the [Navier-Stokes module page](https://mooseframework.inl.gov/modules/navier_stokes/index.html)

# Simulation Setup

The valve was simulated for 5 different angles (between 0$^\circ$ and 42.7$^\circ$) where fully open is 90$^\circ$.
Due to the highly turbulent nature of the simulations, the mixing-length turbulence model was used. For each valve configuration and
flow-rate, three meshes of different refinement levels were used. A closeup of the coarse 0$^\circ$ mesh is show below.

Due to convergence constraints a direct solve method was used, greatly increasing the computational resources needed.
Access to HPC resources will likely be necessary to run these simulations. It is also necessary to increase MOOSE's
default AD container size. More information on MOOSE's automatic differentiation system, and information on increases AD container size
when building can be found [here](https://mooseframework.inl.gov/automatic_differentiation/index.html).

!alert note
A solver based on the SIMPLE method has been added to the Navier Stokes module after this study was conducted, and should be preferred for future 3D studies.

!alert note
Input and mesh files are hosted on LFS. Please refer to [LFS instructions](vtb_pages/getting_started.md#lfs)
to download them.

!media atr/0deg_coarse_zoom_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve
       caption=A coarse mesh for a butterfly-valve in use at ATR. In this particular mesh the valve is fully closed.


!media atr/42deg_coarse_zoom_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=42deg_bf_valve
       caption=A coarse mesh for a butterfly-valve in use at ATR. In this particular mesh the valve is opened to $42.7^\circ$.

# Butterfly-Valve Input

## Parameters

The viscosity and density were set to match experimental values for water at the pressure levels measured in earlier experiments.
The simulations each begin with the viscosity set at a relatively higher value, but it is ramped-down with each successful timestep.
The von-karman constant is a dimensionless constant used in turbulence modeling.


```language=bash

 mu = 0.001 # viscosity [Pa*s]
 rho = 986.737 # density [kg/m^3]
 von_karman_const = 0.41
```

## Mesh


Because of the complex geometries involved, Cubit was used to generate meshes for all angles tested. All meshes used are included with the input file provided.
For each angle simulated three meshes (coarse, medium, and fine) were created. Each course mesh had between 50-100 thousand cells, medium meshes between 100-200
thousand cells, and fine meshes over 200 thousand cells. Three levels of refinement were used so that the self convergence rate could be calculated using
the method described in [!cite](Roache1998).

### `Boundary Conditions`

The `inlet-u` parameter controls the inlet velocity. Its function value can be changed to match the experimental inlet velocities. To reduce computational resources
The entire assembly was split in half in the direction of flow. Since the pipe and valve is symmetric along this axis, a symmetry boundary condition was applied along this surface to approximate
simulating the entire assembly. Additionally, the outlet was set as a constant pressure outlet of $0 Pa$, and all walls were set as no-slip boundary conditions.
The boundary conditions are created by the `Physics/NavierStokes/Flow/flow` syntax.

### `Variables`

All simulations were done in three dimensions. Because of the turbulent nature of the simulations, a relatively slow initial velocity
in the x-direction was chosen. This prevented the simulations from diverging early on.
The variables are created by the `Physics/NavierStokes/Flow/flow` syntax.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Physics/NavierStokes/Flow language=cpp

### `AuxVariables`

To implement the mixing-length turbulence model, a `mixing_length` auxillary variable needs to be included.

The mixing length variable is created by the `Physics/NavierStokes/Turbulence/mixing_length` syntax.

### `AuxKernels`

This kernel controls the behavior of the mixing-length model. Walls 2 and 4 correspond to the wall of the pipe and the valve, while
the delta parameter controls turbulent behavior near these walls.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Physics/NavierStokes/Turbulence language=cpp


### `Executioner`

While these are steady-state simulations, a transient solver must be used in order for the viscosity rampdown to function as intended. This operates by having the viscosity ramp down over time
while every other parameter remains unchanged. With each successful timestep, the viscosity approaches the desired value. The simulation terminates once it ramps down all the way
to the desired level.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Executioner language=cpp

### `Viscosity Rampdown`

The viscosity rampdown is controlled but two input blocks, the `Functions` and `Materials`. The functions block determines how quickly the rampdown occurs while the materials block is what defines the
value of `mu` as show in the listing below. For these simulations, `mu` was first ramped down to a value of `1e-3 PaS`. Once it converged to that point, it was restarted and a new rampdown
function was used to quickly bring the viscosity down to `5.4e-4 PaS`.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Functions language=cpp

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Materials language=cpp

# Results

Shown below are velocity and pressure profiles for each angle and for select inlet velocities. These profiles were all taken from the finer mesh simulations. They display expected features
such as pressure and velocity peaks in the correct regions.

!media atr/bf_valve_vel_and_pressure.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve_vel_and_pressure
       caption=Velocity and pressure profiles for each valve configuration.

Simulations were also performed on the fine mesh using STAR-CCM+ as a point of comparison. The pressure drop, resistance coefficient, and flow coefficient for all configurations (and for STAR-CCM+ simulations) is shown in the figure below. The experimental data was taken from an internal study by [!cite](ECAR52). Also included is a table with the pressure drop error and convergence information for the different levels of mesh refinement.
For most of the angles tested, simulations approached experimental value as finer meshes were used, with the only exception being the 22.5$^\circ$ configuration. However for that particular configuration simulation error relative to
experimental values was already significantly smaller than other configurations.

!media atr/multiplot.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=multiplot
       caption=Simulation results for each configuration. The pressure drop, resistance coefficient, and flow coefficient for each mesh and corresponding inlet velocity was compared to experimental data as well as results from STAR-CCM+       using the fine meshes.

| Angle | Flow-rate (m^3/s) | # Cells | % Error to experimental pressure-drop across valve |
| :-: | :-: | :-:   | :-:   |
| 0$^\circ$ | 1.26 | 88950   | 23.0    |
|           |      | 148770   | 10.4   |
|           |      | 286216   | 6.33   |
| 0$^\circ$ | 1.89 | 88950    | 39.9   |
|           |      | 148770   | 24.7   |
|           |      | 286216   | 13.5   |
| 19.7$^\circ$ | 2.57 | 97585    | 0.77 |
|           |         | 164566   | 0.55 |
|           |         | 250125   | 0.50 |
| 19.7$^\circ$ | 2.58 | 97585    | 1.28 |
|           |         | 164566   | 1.08 |
|           |         | 250125   | 0.88 |
| 22.5$^\circ$ | 2.64 | 88561    | 9.31 |
|           |         | 142611   | 10.0 |
|           |         | 276116   | 6.91 |
| 22.5$^\circ$ | 2.66 | 88561    | 0.73 |
|           |         | 142611   | 0.95 |
|           |         | 276116   | 2.03 |
| 36.6$^\circ$ | 2.97 | 99184    | 13.7 |
|           |         | 174730   | 7.52 |
|           |         | 254610   | 5.07 |
| 42.7$^\circ$ | 2.58 | 92668    | 27.3 |
|           |         | 173348   | 19.1 |
|           |         | 272450   | 15.9 |
