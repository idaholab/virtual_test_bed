# DOME Thermal Model

## Overview

The DOME thermal model solves for the temperature distribution in the DOME shield with a reactor that operates in the central cavity of the shield. The model is a heat conduction model with surface-to-surface thermal radiation between the outer surface of the reactor and the inner surface of the shield. It runs as a standalone MOOSE thermal calculation on the shield mesh described on the [mesh page](microreactors/dome/mesh.md) and can be run either to steady state or as a transient to steady state. The model is reactor independent: the reactor is represented by a mesh that is loaded into the cavity, and its heat source is specified by the user.

## Model Description

### Governing Equations

Heat conduction is solved in the following regions of the model: the shield, the core, the water tank, and the air regions. At steady state, the temperature $T$ satisfies

\begin{equation}
\label{eq:dome_heat_conduction}
-\nabla \cdot \left( k \nabla T \right) = q''' ,
\end{equation}

where $k$ is the thermal conductivity and $q'''$ is a volumetric heat source. For the transient case, the time derivative term $\rho c_p \, \partial T / \partial t$ is added to the left-hand side of [eq:dome_heat_conduction], where $\rho$ is the density and $c_p$ is the specific heat capacity.

### Regions and Materials

The shield mesh is divided into named blocks. The model groups them by material as follows:

- Normal-weight concrete: the ground, Door 2, Floor 3, and Ceiling 1.
- Heavy-weight concrete: Door 1, Floor 1, Floor 2, Walls 1 through 3, and Ceilings 2 through 5.
- Aluminum: the water tank walls.
- Water: the water tank.
- Graphite: the heated core region and the core insulation.
- Air: the air gaps between the water tanks and the shield, the air gaps at the doors, and the cavity.

### Material Properties

The thermal properties of all of the materials listed above are defined in a separate input file that is included by the model, shown in [dome_thermal_properties]. For each material, the file defines the density $\rho$, the specific heat capacity $c_p$, and the thermal conductivity $k$ used in the heat conduction equation.

!listing microreactors/dome/thermal/thermal_properties.i
         id=dome_thermal_properties
         caption=Thermal properties input file.

### Heat Source

The reactor power is $P = 100$ kW, which is the heat removal design limit of the shield. It is applied as a uniform volumetric heat source in the heated core volume,

\begin{equation}
\label{eq:dome_core_source}
q'''_{core} = \frac{P}{V_{core}} ,
\end{equation}

where $V_{core}$ is the volume of the heated core blocks.

### Water Tank

The water tank has an inlet and an outlet that are not modeled explicitly. Instead, the tank is treated as a solid region with the thermal properties of water, and the heat removed by the flow is approximated with a uniform volumetric heat source,

\begin{equation}
\label{eq:dome_water_source}
q'''_{water} = \frac{\dot{m} c_p \left( T_{in} - T \right)}{V_{water}} ,
\end{equation}

where $\dot{m}$ is the mass flow rate, $T_{in}$ is the water inlet temperature, $T$ is the local water temperature, and $V_{water}$ is the water volume. This source is negative where the water is warmer than the inlet temperature and removes heat from the tank. It implicitly assumes that the water is well mixed. The mass flow rate is 1 kg/s and the inlet temperature is 280 K.

### Reactor Core

The reactor is represented by a simplified horizontal cylindrical core that is loaded into the shield cavity as part of the mesh (`shield_with_core.e`), with the cavity meshed around it. The core is not a model of a specific reactor design. Its purpose is to apply a heat load to the shield and to provide a radiating surface inside the cavity, so the internal reactor components (fuel, moderator, and cooling system) are not resolved. 

The core consists of two regions, both modeled as graphite:

- The heated region (`core_heated`), in which the full reactor power of 100 kW is deposited as a uniform volumetric heat source.
- The core insulation (`core_insulation`), which surrounds the heated region.

The outer surface of the core (`core_outer`) exchanges heat with the inner surface of the shield by thermal radiation, with an emissivity of 0.52. Because the core is meshed separately from the shield, a different core mesh can be substituted by changing the mesh file and the core block lists in the parameters file.

### Thermal Radiation

Radiation between the outer surface of the reactor core and the inner surface of the shield cavity is modeled with the net radiation method using the GrayDiffuseRadiation action. The surfaces are divided into patches (1000 patches on each surface), and the view factors between patches are computed with MOOSE's ray tracing module. The surfaces are treated as gray and diffuse, with emissivities of 0.52 for the reactor core and 0.76 for the inner shield surface.

### Boundary Conditions

Heat is lost from the exterior of the model by convection, using the ConvectiveFluxFunction boundary condition:

| Boundary | Heat Transfer Coefficient (W/m$^2$-K) | Ambient Temperature (K) |
| - | - | - |
| Exterior shield surfaces in contact with DOME air (all sides and the top) | 10 | 293 |
| Bottom surface of the ground layer | 100 | 293 |

### Initial Conditions

The water tank is initialized to the water inlet temperature, 280 K, and all other regions are initialized to the ambient temperature, 293 K. The water block is given a lower block ID than the other blocks so that, at nodes shared between the water and its neighboring regions, the water initial condition takes precedence over the neighboring regions' initial condition.

## Input Files

The model is split into several files so that the same base model can be run to steady state or as a transient, and with different core meshes. The core-specific settings are in `params_cyl.i`, the physics is in `sim_base.i`, and the solver settings are in the `part_` files.

| File | Description |
| - | - |
| `thermal_properties.i` | Density, specific heat capacity, and thermal conductivity of each material. |
| `params_cyl.i` | Settings specific to the `cyl` core mesh: the mesh file and the lists of blocks for the normal-weight concrete, aluminum, air, graphite, and heated core regions. The heavy-weight concrete and water blocks are defined in `sim_base.i`. |
| `sim_base.i` | Base model: mesh, variables, kernels, boundary conditions, radiation, and postprocessors. |
| `part_ss.i` | Steady-state solver settings. |
| `part_tr.i` | Transient solver settings and the time derivative kernel. |
| `sim_cyl_ss.i` | Steady-state simulation (includes `params_cyl.i`, `sim_base.i`, and `part_ss.i`). |
| `sim_cyl_tr.i` | Transient simulation (includes `params_cyl.i`, `sim_base.i`, and `part_tr.i`). |

The parameters file selects the mesh and the block groupings.

!listing microreactors/dome/thermal/thermal_file/params_cyl.i
         id=dome_thermal_params
         caption=Mesh file and block groupings.

The base model contains the physics.

!listing microreactors/dome/thermal/thermal_file/sim_base.i
         id=dome_thermal_base
         caption=Base thermal model input file.

### Steady-State Simulation

!listing microreactors/dome/thermal/thermal_file/sim_cyl_ss.i
         id=dome_thermal_ss
         caption=Steady-state simulation input file.

The steady-state case uses a Newton solver with automatic scaling and the BoomerAMG preconditioner, and is defined in `part_ss.i`.

!listing microreactors/dome/thermal/thermal_file/part_ss.i
         id=dome_thermal_part_ss
         caption=Steady-state solver settings.

### Transient Simulation

!listing microreactors/dome/thermal/thermal_file/sim_cyl_tr.i
         id=dome_thermal_tr
         caption=Transient simulation input file.

The transient case advances the temperature in time with the second-order BDF scheme out to 5000 hours, with an adaptive time step that grows by a factor of 1.2 up to a maximum of 100 hours. The simulation stops early once steady state is detected.

!listing microreactors/dome/thermal/thermal_file/part_tr.i
         id=dome_thermal_part_tr
         caption=Transient solver settings.

## Outputs

The model writes the temperature field to an Exodus file, and writes the following postprocessors to a CSV file at each time step:

| Postprocessor | Description |
| - | - |
| `Q_core` | Heat generation rate in the core. |
| `Q_water` | Heat source rate in the water tank (negative when heat is removed). |
| `Q_air` | Heat lost by convection from the exterior shield surfaces to the DOME air. |
| `Q_ground` | Heat lost by convection through the bottom of the ground layer. |
| `Q_loss_total` | Total heat loss rate, `Q_air + Q_ground - Q_water`. |
| `Tmax_concrete` | Maximum temperature in the concrete. |
| `Tavg_concrete` | Average temperature in the concrete. |
| `T_water_out` | Average water temperature, used as the water outlet temperature. |
| `Tavg_shield_outer_air` | Average temperature of the exterior shield surfaces in contact with DOME air. |
| `Tavg_shield_outer_ground` | Average temperature of the bottom ground surface. |

## Results

[dome_thermal_temperature] shows the computed temperature distribution in the shield and the reactor core in two three-dimensional cutaways.

!media media/dome/dome_thermal_temperature_3d.png
       style=width:100%
       id=dome_thermal_temperature
       caption=Temperature (K) in the DOME shield and core, shown from two viewpoints in a three-dimensional cutaway.

The highest temperatures, up to roughly 590 K, occur in the heated region of the core, where the reactor power is deposited. Heat leaves the core through its insulation and is transferred across the cavity to the inner surface of the shield, with thermal radiation between the core and the shield as the dominant mechanism. The warmest parts of the shield are the floor and ceiling immediately below and above the cavity. 