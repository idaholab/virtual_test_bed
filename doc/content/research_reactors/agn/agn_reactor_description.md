# Aerojet General Nucleonics 201 (AGN-201) Research Reactor Model Description

The Aerojet General Nucleonics 201 (AGN-201) Research Reactor Model is a digital twin of the physical reactor built at Idaho State University. The AGN-201 design is a low power, very safe, solid-core reactor that has been used by Idaho State University, the University of New Mexico, and Texas A&M University to teach students. The reactor was developed in the 1950's by AGN to satisfy university's nuclear engineering departments' needs for a safe, flexible, and relatively low cost reactor with a long design life . The solid-core design requires no active cooling system and uses a simple shielding arrangement. This design results in a very low operating power which results in limited burnup, providing an operating lifetime exceeding many decades [!cite](ISU_AGN).

Due to the growing popularity of nuclear power, the use of digital twins as an approach to increase effectiveness and efficiency of safeguards by monitoring reactors has become more and more utilized throughout the field. By using geometric and material data from the physical asset, a surrogate model of the AGN-201 was created that "preserves basic physical qualities while significantly cutting down on computation costs" [!cite](AGN).

## Reactor Core Design

!table id=table-floating caption=AGN-201 surrogate model design specifications, from [!cite](AGN).
| Core Layout & Specifications                  | Quantity                             |
|:----------------------------------------------|:-------------------------------------|
| Thermal Power                                 | <5 W                                 |
| Operating Temperature Range                   | 15$^{\circ}$C - 30$^{\circ}$C        |
| Control Rods: Safety, Coarse, and Fine        | 2 Safety, 1 Coarse, 1 Fine           |
| Fuel Plates                                   | 9                                    |
| Reactivity-Adding Disk (RAD)                  | 1                                    |
| Central Irradiation Facility (CIF)            | 1 through center of core             |

| Dimensions/Geometry                               | Value/Type             | Unit        |
|:--------------------------------------------------|:-----------------------|:------------|
| Core Configuration                                | Annular                |             |
| Reactor Core Height                               | 24.7                   | cm          |
| Reactor Core Diameter                             | 25.6                   | cm          |
| Reactor Vessel Height                             | 279                    | cm          |
| Reactor Vessel Diameter                           | 206.6                  | cm          |
| Lead Shield Width                                 | 10                     | cm          |
| Outer Graphite Width                              | 20                     | cm          |
| Water Shielding Width                             | 55                     | cm          |
| Reactor Tank Width                                | 0.8                    | cm          |
| Core Tank Width                                   | 0.165                  | cm          |
| Inner Graphite Width                              | 3.3                    | cm          |
| Air Gap Width                                     | 0.435                  | cm          |

| Materials                           | Type                                               |
|:------------------------------------|:---------------------------------------------------|
| Fuel Type                           | Polyethylene-Uranium Dioxide                       |
| Fuel Enrichment                     | ~19.5%                                             |
| Reflectors                          | High Density Graphite encased in Lead Gamma Shield |
| Core Tank                           | A1-6061                                            |
| Light Water Neutron Shield Tank     | Steel                                              |
| Beamport Plug                       | Graphite flanked by Lead, Wood, and Aluminum       |

| Steady State Operation Specifics              | Value                                |
|:----------------------------------------------|:-------------------------------------|
| Safety Control Rods (Fueled)                  | 100% Inserted                        |
| Coarse Control Rod                            | ~94% Inserted                        |
| Fine Control Rod                              | ~85% Inserted                        |
| Reactor Temperature - Spatially Isothermal    | 23.5$^{\circ}$C                      |

