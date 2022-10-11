# TREAT-like LEU Pulse Model: DRAFT

*Contact: Adam Zabriskie, Adam.Zabriskie@inl.gov*

## Model Description

This model represents a greatly simplified version of the Transient Reactor Test Facility (TREAT) that simulates the effect of a power pulse on a single 20 $\mu$m LEU fuel grain with an inserted reactivity of 4.56 % $\Delta$k/k.
The model's simplified geometry consists of a single, unit cell TREAT fuel element surrounded by a cube shell reflector, excluding air channels and cladding.
Reflective boundaries are applied on the left, right, front, and back boundaries (±x, ±y), while the top and bottom of the fueled portion of the fuel element are covered by a graphite reflector with vacuum boundary conditions.

The neutronics analysis is performed on a mesh characterized by centimeter-sized elements, while grain treatment is on the micrometer element scale where heat conduction problems are solved on microscopic domains encompassing a single fuel grain and the proportional amount of graphite.
This model makes use of the Griffin code for neutronics and radiation transport, as well as Serpent 2 for calculation of cross-sections.
[!citep](zabriskie2019), [!citep](doi:10.1080/00295639.2018.1528802). 
The dimensions of the fuel element are given in [dim].
[!citep](doi:10.1080/00295639.2018.1528802)

!table id=dim caption=Fuel element model dimensions.
|  Characteristic | Value (cm) |
| :- | :- |
| Fuel element cross-section length | 9.65 |
| Fuel element cross-section width | 9.65 |
| Fueled height | 120.97 |
| Top reflector height | 65.98 |
| Bottom reflector height | 65.98 |
| Macroscale mesh element length | 2.41 |
| Macroscale mesh element width | 2.41 |
| Macroscale mesh element height | 5.50 |

Four equidistant locations on the x-y plane 2.413 cm from the x-z and y-z edge of the simplified fuel element are spaced every 10.997 cm in the z-direction in the fuel starting 5.498 cm from the graphite reflector.
Thus, 44 locations within the fueled region of the fuel element are selected as sites for the microsimulations.
The power density, calculated from the sampled flux at each location, is transferred to a single microscale simulation.
A transition region next to the fuel grain in the moderator shell features mesh elements of a different size than found in the rest of the moderator shell.

The MOOSE MultiApp system handles the multiscale and information transfer needs of the proposed method.
To supply the macrosimulation with the informed feedback temperature, the average temperature value of the graphite, the fuel grain, or both are transferred to the macrodomain from each microsimulation.

## Input Files

There are four input files for this model. The first is the input file that sets the initial conditions from which the transient pulse starts.
The second input file calculates the point kinetics equation parameters that describe the pulse. 
The third input file describes microscale particles that affect heat transport from generation. 
The fourth is the main input file that runs the simulation. The first three files must be run before the main file to initialize the meshes and perform other necessary tasks.

## Transient Pulse Initial Conditions (init_refcube.i)

*Note: some code blocks appearing in this file also appear in other input blocks. For brevity, these common blocks are only shown in this first section, but they will be mentioned at the beginning of each section that they appear.*

### Mesh

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=mesh language=cpp

## PKE Parameters (adj_refcube.i)

## Microscale Particles (ht_20r_leu_fl.i)

## Main Input File (refcube.i)
