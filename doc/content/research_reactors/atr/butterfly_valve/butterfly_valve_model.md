# ATR Butterfly-Valve Model using MOOSE Navier-Stokes module

*Contact: Daniel Yankura, daniel.yankura@inl.gov

*Model link: [ATR Butterfly-Valve Model](https://github.com/idaholab/virtual_test_bed/tree/main/research_reactors/atr/butterfly_valve)*

!tag name=ATR Butterfly-Valve Model
     description=3D Steady state CFD model of a butterfly-vale used at ATR, using the Navier-Stokes module
     pairs=reactor_type:LWR
                       geometry:valve
                       simulation_type:CFD
                       codes_used:MOOSE_NavierStokes
                       open_source:full
                       computing_needs:HPC
                       fiscal_year:2024
                       institution:INL 

The advanced test reactor (ATR) at INL employs a buttefly-valve to control pressure drop across the reactor core. 
This simulation utilized the Navier-Stokes module in MOOSE for all simulations. 
Running this model will likely require HPC resources. The simulations setup will be described below.

# Physics Models and Boundary Conditions Used

All simulations used the finite volume discretization of the incompressible Navier-Stokes equations. The pipe inlet was set as a
constant inlet velocity that corresponded to the mass-flow rate from experimental data. The outlet pressure 
was arbitrarily set to 0. All walls (including those belonging to the valve) were set as no-slip boundariesi.

The following sections go into greater detail on how the simulations were carried out, including meshing, simulation parameters,
and computational resources used. Detailed documentation on the MOOSE Navier-Stokes module, the mixing-length turbulence method, as
well as the other parameters used, see the [Navier-Stokes module page](https://mooseframework.inl.gov/modules/navier_stokes/index.html)

# Simulation Setup

The valve was simulated for 5 different angles (between 0 and 42.7 degrees) where fully open is 90 degrees.
Due to the highly turbulent nature of the simulations, the mixing-length turbulence model was used. For each valve configuration and 
flow-rate, three meshes of different refinement levels were used. A closeup of the coarse 0 degree mesh is show below.

Due to convergence constraints a direct solve method was used, greatly increasing the computational resources needed.
Access to HPC resources will likely be necessary to run these simulations. It is also necessary to increase MOOSE's
default AD container size. More information on MOOSE's automatic differentiation system, and information on increases AD container size
when building can be found [here](https://mooseframework.inl.gov/automatic_differentiation/index.html).

!media atr/0deg_coarse_zoom_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve
       caption=A coarse mesh for a butterfly-valve in use at ATR. In this particular mesh the valve is fully closed.

# Butterfly-Valve Input

## Parameters

The viscosity and density match experimental values for water at the pressure levels measured in earlier experiments.
The simulation begins with the viscosity at a higher number, but it gets ramped-down to this value with each successful timestep.
The von-karman constant is a dimensionless constant used in turbulence modeling.


```language=bash
  
 mu = 0.001 # viscosity [Pa*s]
 rho = 986.737 # density [kg/m^3]
 von_karman_const = 0.41
```

# Mesh

 
Because of the complex geometries involved, Cubit was used to generate meshes for all angles tested. All meshes used are included with the input file provided.
For each angle simulated three meshes (coarse, medium, and fine) were created. Each course mesh had between 50-100 thousand cells, medium meshes between 100-200
thousand cells, and fine meshes over 200 thousand cells. With three levels of refinement the self convergence rate could be calculated using the method described in [!cite](Roache1998).

### `Variables`

All simulations were done in three dimensions. Because of the turbulent nature of the simulations, a relatively slow initial velocity
in the x-direction was chosen. This prevented the simulations from diverging early on.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Variables language=cpp

### `AuxVariables`

To implement the mixing-length turbulence model, a `mixing_length` auxillary variable needs to be included. 

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=AuxVariables language=cpp

### `AuxKernels`

This kernel controls the behavior of the mixing-length model. `walls 2 and 4` correspond to the wall of the pipe and the valve as well.
the delta parameter controls turbulent behavior near these walls.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=AuxKernels language=cpp


### Boundary Conditions

The `inlet-u` parameter controls the inlet velocity. Its function value can be changed to match the experimental inlet velocities. To reduce computational resources
The entire assembly was split in half in the direction of flow. Since the pipe and valve is symmetric along this axis, a symmetry boundary condition was applied along this surface to approximate
simulating the entire assembly.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=FVBCs language=cpp

### Executioner

While these are steady-state simulations a transient solver must be used in order for the viscosity rampdown to work. This operates by having the viscosity ramp down over time 
while every other paramter remains unchanged. With each successful timestep, the viscosity approaches the desired value. The simulation terminates once it ramps down all the way
to the desired level.

!listing /research_reactors/atr/butterfly_valve/input_file/bf_valve_mixing_length_test.i block=Executioner language=cpp

### Results

Shown below is a velocity streamline plot for a select inlet velocity for a select inlet velocity. Aside from general
trends such as high velocities at the top an bottom of the valve, important details such as vortices forming downstream of the valve
are able to be simulated despite the relative coarseness of the meshes.

!media atr/bf_valve_vel_and_pressure.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve_vel_and_pressure
       caption=Velocity and pressure profiles for each valve configuration.

!media atr/bf_valve_velocity_streamline.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve
       caption=Velocity streamlines from each of the fine meshes. The inlet velocity is listed for each.

