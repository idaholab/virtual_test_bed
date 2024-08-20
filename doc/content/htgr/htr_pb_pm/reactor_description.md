# Gas-Cooled High-Temperature Pebble-Bed Reactor Description

The Pebble Bed Modular Reactor (PBMR) is a design for an advanced nuclear reactor that employs the High Temperature Gas-cooled Reactor (HTGR) concept. It uses spherical fuel elements, known as "pebbles," each  consisting of fuel particles surrounded by a protective graphite shell. These pebbles are compiled in a reactor core and helium gas is used as the coolant. Here are some key aspects of the PBMR concept:

1. Modular Design: The PBMR is designed to be built in modular, standardized units that can be manufactured in a factory setting and then transported to the power plant site. This modularity allows for scalability and can lead to reductions in construction time and potentially lower capital costs.

2. High Efficiency: The PBMR operates at high temperatures, which increases the efficiency of the conversion of nuclear heat to electricity. PBMRs can achieve thermal efficiencies of around 40% or more.

3. Flexibility: Due to its high outlet temperatures, the PBMR can be used not only to generate electricity but also to provide process heat for industrial applications such as hydrogen production, petrochemical processes, or desalination.

4. Safety Features: The PBMR design includes passive safety features that leverage the physics of the reactor to safely shut down without human intervention or mechanical systems in case of an emergency. The fuel design also mitigates the release of fission products.

5. Fuel Efficiency: The PBMR's fuel pebbles allow for high burn-up rates, which means the reactor can extract more energy from the fuel before it needs to be replaced. This efficient use of fuel reduces waste and the frequency of refueling operations.

The PBMR concept represents a significant advancement in nuclear reactor technology, with the potential to offer a more efficient, flexible, and safe option for energy generation. This technology could play a crucial role in meeting global energy demands while reducing the carbon footprint associated with energy production. [!cite](pbmr_neutronics).

## Historical Context of PBMR

In the 1990s, the electric utility company of South Africa, Eskom, developed the PBMR concept as a possible option for increased power generation through the installation of a nuclear power plant (NPP).
This PBMR power plant incorporates a closed cycle primary coolant system using helium to transport heat energy directly from the modular pebble bed reactor. [!cite](pbmr_neutronics).

In 2012, China started construction of its own high-temperature gas-cooled reactor pebble-bed module (HTR-PM) demonstration power plant, located in Rongcheng, Shandong Province. The aim of the plant is to extend nuclear energy application beyond the grid, including high-temperature heat utilization, co-generation, and hydrogen production. Another goal was to prove that "innovation can provide another solution for inherently safe nuclear energy technology." During research and development, international experiences with HTGR were carefully studied, and much of the research was conducted alongside German scientists in the field of pebble-bed HTGR. [!cite](htr-pm_Zhang).

## Model Description

The Pebble Bed High Temperature Reactor, HTR-PB, is 250 MWth, helium-cooled reactor including a cylindrical pebble-bed surrounded by radial, lower, and upper reflectors made of graphite. The radial reflectors include designated areas for the control rod channels, fluid riser channels, and Kleine Absorber Kugel System (KLAK) channels (shutdown system).

Below are the design specifications for the Gas-Cooled High-Temperature Pebble-Bed (HTR-PB) Model, from [!cite](htr-pm_Zhang), [!cite](pbmr_neutronics), and [!cite](htr_pb_pm).

!table id=table-floating caption=Design specifications for the HTR-PB Model.
| Primary Operating Conditions                  | Value                                 |
|:----------------------------------------------|:--------------------------------------|
| Electric Power                                | 210 MW                                |
| Thermal Power                                 | 250 MW                                |
| Reflector Material                            | Graphite                              |
| Primary Coolant                               | Helium                                |
| Primary Helium Pressure                       | 7 MPa                                 |
| Inlet Temperature                             | 523.15K                               |
| Outlet Temperature                            | 1023.15K                              |
| Main Steam Pressure                           | 13.25 MPa                             |
| Main Steam Temperature                        | 567$^{\circ}$C                        |
| Feedwater Temperature                         | 205$^{\circ}$C                        |

| Geometry                                      | Value                                 |
|:----------------------------------------------|:--------------------------------------|
| Number of Modules                             | 2                                     |
| Active Core Diameter                          | 3 m                                   |
| Active Core Height                            | 11 m                                  |
| Reflector Diameter                            | 5 m                                   |
| Control Rod Channels                          | 24                                    |
| Reactivity Shutdown Channels                  | 4                                     |
| Vessel Diameter                               | 6 m                                   |
| Fuel Element Diameter                         | 60 mm                                 |

| Fuel Cycle                                    | Value                                  |
|:----------------------------------------------|:---------------------------------------|
| Fuel Type                                     | TRISO Ceramic Coated U-235 in Graphite |
| Heavy Metal Loading per Fuel Element          | 7 g                                    |
| Number of Fuel Elements in 1 Core             | 419,384                                |
| Fuel Pebble Types                             | 1 Pebble Type                          |
| Average Number of Passes                      | 15                                     |
| Average Pebble Residence Time                 | 70.5 Days                              |
| Fuel Enrichment                               | 8.6%                                   |
