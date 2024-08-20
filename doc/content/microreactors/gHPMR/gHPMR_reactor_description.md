# Generic Heat Pipe Microreactor (gHPMR) Model Reactor Description

The generic Heat Pipe Microreactor (gHPMR) Model is based on &trade; Westinghouse Electric Company's eVinci microreactor design. The &trade; eVinci design has potential for autonomous operation, is intended for factory fabrication, and has a lifetime of 10 years, after which the entire reactor would be returned to the factory for either refueling or storage [!cite](eVinci).

Fuel, moderator, and heat pipes are arranged in a hexagonal lattice. The hexagonal core sits in steel monolith (graphite in [!cite](gHPMR_main)). The monolithic microreactor concept utilizes a monolithic metal structure to support the fuel assemblies and evaporator sections of the heat pipes. Control drums are embedded inside the radial reflector sections. A central rod is used to start up and shut down the reactor. Sodium is utilized as the heat pipe working fluid. Heat pipes protrude from both ends of the core, allowing for two primary heat exchangers (only one in [!cite](gHPMR_main)), one at each end of the monolith.

Below are the design specifications for the gHPMR model.

!table id=table-floating caption=Design specifications for the gHPMR model, from [!cite](gHPMR_main).
| General Design Specifications                 | Value                                |
|:----------------------------------------------|:-------------------------------------|
| Thermal Power                                 | 15 MW(th)                            |
| Core Height                                   | 1.8 m                                |
| Core Height (Active)                          | 1.6 m                                |
| Reflector Height                              | 0.2 m                                |
| Core Radius                                   | 1.4 m                                |
| Canister Radius                               | 1.468 m                              |
| Fuel Enrichment                               | 10 w / o                             |
| Number of Heat Pipes                          | 876                                  |
| Number of Fuel Assemblies Types               | 2                                    |
| Number of Standard Fuel Assemblies            | 114                                  |
| Number of Control Rod Fuel Assemblies         | 13                                   |
| Fuel Assembly Pitch                           | 17.368 cm                            |
| Pin Pitch                                     | 2.782 cm                             |
| Fuel Compact Hole Radius                      | 0.95 cm                              |
| Heat Pipe Hold Radius                         | 1.07 cm                              |
| Number of Control Drums                       | 12                                   |
| Control Drum Diameter                         | 28.1979 cm                           |
| Control Drum B${_4}$C Layer Thickness         | 2.7984 cm                            |
| Control Drum B${_4}$C Angular Extension       | 120$^{\circ}$                        |

| Heat Pipe Specifications                      | Value                                |
|:----------------------------------------------|:-------------------------------------|
| Working Fluid                                 | Sodium                               |
| Wick Material                                 | SS 316                               |
| Cladding Material                             | SS 316                               |
| Evaporator Length                             | 1.8 m                                |
| Adiabatic Length                              | 0.4 m                                |
| Condenser Length                              | 1.8 m                                |
| Outer Cladding Radius                         | 0.0105 m                             |
| Inner Cladding Radius                         | 0.0097 m                             |
| Outer Wick Radius                             | 0.0090 m                             |
| Inner Wick Radius                             | 0.0080 m                             |
| Wick Porosity                                 | 0.7                                  |
| Wick Permeability                             | 2E-9 m$^{2}$                         |
| Pore Radius                                   | 1E-9 m                               |
| Wick Fill                                     | 100% overfill by volume at 500 K     |

| Compact and TRISO Specifications              | Value                                |
|:----------------------------------------------|:-------------------------------------|
| Compact Fueled Zone Radius                    | 0.875 cm                             |
| Compact Non-Fueled Zone Radius                | 0.9 cm                               |
| Compact Packing Fraction                      | 40%                                  |
| UCO Kernel Radius                             | 0.02125 cm                           |
| Buffer Radius                                 | 0.03125 cm                           |
| Inner PyC Radius                              | 0.03525 cm                           |
| SiC Radius                                    | 0.03875 cm                           |
| Outer PyC Radius                              | 0.04275 cm                           |

| Operating Conditions                | Value                               |
|:-----------------------------------------------|:------------------------------------|
| Average Temperature                            | 1073.15 K                           |
| Condenser Convection Temperature               | 523.15 K                            |
| Condenser Convection heat transfer coefficient | 312.4 W/(m$^{2}$ - K)               |
