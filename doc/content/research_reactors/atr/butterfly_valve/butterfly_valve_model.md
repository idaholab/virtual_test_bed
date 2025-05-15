# ATR Butterfly-Valve Model using MOOSE Navier-Stokes module

*Contact: Daniel Yankura, daniel.yankura@inl.gov

*Model link: [ATR Butterfly-Valve Model](https://github.com/idaholab/virtual_test_bed/tree/devel/research_reactors/atr/butterfly_valve)*

!tag name=ATR Butterfly-Valve Model
     description=3D Steady state CFD model of a butterfly-vale used at ATR, using the Navier-Stokes module
     pairs=reactor_type:LWR
                       geometry:valve
                       simulation_type:fluid_flow
                       codes_used:MOOSE_NavierStokes
                       open_source:full
                       computing_needs:HPC
                       fiscal_year:2024
                       institution:INL 

The advanced test reactor (ATR) at INL employs a buttefly-valve to control pressure drop across the reactor core. 
This simulation utilized the Navier-Stokes module in MOOSE for all simulations. 
Running this model will likely require HPC resources. The simulations setup will be described below.

# Physics Models and Boundary Conditions Used

All simulations used the finite volume incompressible Navier-Stokes formulas. The pipe inlet was set as a
constant inlet velocity that corresponded to the mass-flow rate from experimental data. The outlet pressure 
was arbitrarily set to 0. All walls (including those belonging to the valve) were set as no-slip boundaries.

# Simulation Setup

The valve was simulated for 5 different angles (between 0 and 42.7 degrees) where fully open is 90 degrees.
Due to the highly turbulent nature of the simulations, the mixing-length turbulence model with an lu
preconditioner was used. For each valve configuration and flow-rate, three meshes of different refinement levels
were used. A closeup of the coarse 0 degree mesh is show below.

Due to convergence constraints a direct solve method was used, greatly increasing the computational resources needed.
Access to HPC resources will likely be necessary to run these simulations. It is also necessary to increase MOOSE's
default AD container size. 

!media atr/0deg_coarse_zoom_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve
       caption=A coarse mesh for a butterfly-valve in use at ATR. In this particular mesh the valve is fully closed.

# Butterfly-Valve Input

## Parameters

```language=bash
  
 mu = 0.001 # viscosity [Pa*s]
 rho = 986.737 # density [kg/m^3]
 von_karman_const = 0.41
```

# Mesh

 
Because of the complex geometries involved, Cubit was used to generate meshes for all angles tested.

### `Variables`

test

!listing /research_reactors/atr/butterfly_valve/input_file/mixing_length_0deg_20k_gpm.i block=Variables language=cpp

### `AuxVariables`

!listing /research_reactors/atr/butterfly_valve/input_file/mixing_length_0deg_20k_gpm.i block=AuxVariables language=cpp

### `Aux Kernels`

!listing /research_reactors/atr/butterfly_valve/input_file/mixing_length_0deg_20k_gpm.i block=AuxKernels language=cpp

# Executioner

!listing /research_reactors/atr/butterfly_valve/input_file/mixing_length_0deg_20k_gpm.i block=Executioner language=cpp

# Results

Shown below is a velocity streamline plot for a select inlet velocity for a select inlet velocity. Aside from general
trends such as high velocities at the top an bottom of the valve, important details such as vorticies forming downstream of the valve
are able to be simulated despite the relative coarseness of the meshes.

!media atr/bf_valve_vel_and_pressure.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve_vel_and_pressure
       caption=Velocity and pressure profiles for each valve configuration.

!media atr/bf_valve_velocity_streamline.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=0deg_bf_valve
       caption=Velocity streamlines from each of the fine meshes. The inlet velocity is listed for each.

