# SNAP 8 Experimental Reactor (S8ER) Description

*Contact: Isaac Naupa, iaguirre6@gatech.edu*
*Contact: Stefano Terlizzi, Stefano.Terlizzi@inl.gov*

!alert note
For citing purposes, please cite [!citep](s8er_garcia2022) and [!citep](s8er_naupa2022).

## Introduction

The S8ER was part of a fleet of reactors built during the Systems for Nuclear Auxilliary Power (SNAP) program. These reactors were space-based aiming to be used as auxiliary power for components such as satellites. 

These systems were the first to explore novel microreactor technology and share many similar characteristics to modern designs that include comparable power output, compact core design, representative reactor-physics phenomena, alkali metal working fluids and high temperature solid moderators prone to hydrogen migration.

!media s8er/reactor_assembly_view.png
  caption= Reactor Assembly View, from [!citep](SNAP8Summary)
  style=width:60%;margin-left:auto;margin-right:auto

This work is part of an ongoing joint effort between Georgia Tech, University of Wisconsin-Madison, BWXT, and INL that leverages extensive experimental data from the Systems for Nuclear Auxiliary Power (SNAP) Program to validate the performance of several NEAMS tools in modeling effects that are unique to microreactor technology.

## System Characterstics

The S8ER was designed to operate for a total of 10,000 hrs and operate at a power level of 600 kWth. In the interest of reducing size, weight, and performance,  the system uses HEU in the form of Uranium-ZirconiumHydride (UZrH), with eutetic Sodium-Potassium Alloy (NaK) coolant in a tight hexagonal lattice arrangement.

!table id=table-floating1 caption=S8ER System Characteristics
| Parameter      | Value  |
| ----------- | ----------- |
| Power (kWth)      |   600     |
| Fuel              |   UZrH     |
| Coolant           |   NaK      |
| Inlet Temp ($\degree$F)    |    1100    |
| Outlet Temp ($\degree$F)   | 1300     |
| Heavy Metal Loading (kg of U 93.15 Wt%  |   6.56    |
| Outlet Temp ($\degree$F)   | 1300     |

## Core Description

As described earlier, the S8ER is a compact nuclear reactor using homogenous combined HEU fuel with Zirconium-Hydride as the fuel-moderator mix. The system uses a mix of burnable poisons aswell as stationary and moveable reflectors for reactivity control. 

!media s8er/core_reflector_view.png
  caption= S8ER Core and Reflector Assembly View, from [!citep](SNAP8Summary)
  style=width:60%;margin-left:auto;margin-right:auto

!table id=table-floating2 caption=S8ER Core Characteristics
| Parameter      | Value  |
| ----------- | ----------- |
| Upper grid plate material | SS 316 |
| Upper grid plate material | Hastelloy-C |
| Internal Reflector Material | BeO  |
| External Reflector Material | Be  |
| External Reflector Nominal Thickness | 0.0762 m  |
| Core Vessel Outer Diameter | 0.237236 m |
| Core Vessel Height  | 0.237236 m |
| Hex Lattice Pitch  | 0.014478 m |

## Fuel Element

The core contains 211 elements arranged in a hexagonal lattice. Each rod contains the homogenous UZrH mix as the fuel base, a hydrogen diffusion barrier consisting of the ceramic AI-8763D infused with burnable poison Sm2O3, an internal atmosphere consisting of Helium as a gap, and a layer of Hastelloy N cladding. The fuel pins contain upper and lower end caps for containment as well as indexing.   

!media s8er/fuelpin_view.png
  caption= S8ER Fuelpin Diagram, from [!citep](SNAP8Summary)
  style=width:60%;margin-left:auto;margin-right:auto

!table id=table-floating3 caption=S8ER Fuel pin Characteristics
| Parameter      | Value  |
| ----------- | ----------- |
| Fuel  | Zr-10 Wt% U-Hydrided to 6E+22 #/cm^3 of H |
| Fissile Enrichment  |  U-235 93.15 Wt% |
| Ceramic Material           |   AI-8763D  |
| Burnable Poison           |   Sm2O3 (3.34 mg/in of clad) | 
| Internal Atmosphere           |   He 0.1 atm  |
| Cladding           |   Hastelloy-N  |
| Fuel Rod Length           |   0.3556 m  |
| Fuel Rod Outer Diameter           |   00.0135128 m  |

!alert note
More information about the SNAP Reactors may be found [here](https://github.com/CORE-GATECH-GROUP/SNAP-REACTORS).

!bibtex bibliography