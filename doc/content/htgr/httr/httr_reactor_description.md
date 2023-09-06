# High Temperature Engineering Test Reactor (HTTR) Description

The High Temperature Engineering Test Reactor (HTTR) is a graphite moderated and helium cooled prismatic reactor developed and operated by the Japan Atomic Energy Agency (JAEA). It was designed to test the safety of high temperature gas cooled reactors (HTGRs). The HTTR is the first and only HTGR in Japan; it first reached criticality in 1998 and was used to conduct safety analyses and performance tests until 2011, when it was shut down following the Fukushima accident.

!media media/htgr/httr/httrJAEA.png
    style=width:45%
    caption=Figure 1: Drawing plan of the HTTR in built in Ibaraki, Japan, [!cite](JAEA_httr).

In 2021, following a safety review by the Nuclear Regulation Authority, the HTTR was restarted. As a part of a cooperative effort between Japan and the United States (U.S.) under the Civil Nuclear Energy Research and Development Working Group (CNWG), the Advanced Reactor Technologies (ART) program at Idaho National Laboratory (INL) and JAEA involves a multi-national research project sponsored by the Nuclear Energy Agency of the Organization of Economic Cooperation and Development [!cite](osti_1893099,LABOURE2023109838).

The general radial layout of the HTTR core, shown in Figure 1, follows a hexagonal lattice containing 30 fuel columns, 16 control rods, 12 replaceable reflectors, and 3 instrumentation columns surrounded by a permanent reflector.

!media media/htgr/httr/CoreLayout.png
    style=width:45%
    caption=Figure 1: HTTR core layout with fuel (columns 1-4), control rods (C, R1, R2, R3), replaceable reflectors (RR), and instrumentation (I), from [!cite](osti_1484524).

 Each fuel column is composed of nine blocks: five fuel pins fitted between two top and two bottom axial reflectors, represented in Figure 2. Each block measures 58 cm in height. The burnable poison and fuel enrichment inside the fuel pins vary both radially and axially. Cold helium flows upwards between the permanent reflectors and the reactor pressure vessel (RPV), then flows downward through the cooling channels inside the core.

!media media/htgr/httr/FuelColumns.png
    style=width:45%
    caption=Figure 2: Description of the four different HTTR fuel columns (UO${_2}$ wt% fuel enrichment/burnable poison wt% enrichment), from [!cite](osti_1484524).

The model described here assumes the reactor to be operating at 9MW. HTTR typically operates at 9 or 30 MW.

The general HTTR design specifications are summarized below in Table I, from [!cite](osti_1484524).

| Design Specifications                             | Value               | Unit        |
|:-------------------------------------------------:|:-------------------:|:-----------:|
| Thermal Power                                     | 9                   | MW          |
| Outlet Coolant Temperature                        | 320                 | $^{\circ}$C |
| Inlet Coolant Temperature                         | 180                 | $^{\circ}$C |
| Core Structure                                    | Graphite            |             |
| Equivalent Core Diameter                          | 2.3                 | m           |
| Effective Core Height                             | 2.9                 | m           |
| Average Power Density                             | 2.5                 | W/cm$^{3}$  |
| Fuel/Enrichment                                   | UO${_2}$/3-10 wt%   |             |
| Fuel Type                                         | Pin in Block        |             |
| Burnup Period                                     | 660                 | EFPD        |
| Coolant Material/Flow                             | Helium Gas/Downward |             |
| Reflector Thickness: Top/Slide/Bottom             | 1.16/0.99/1.16      | m           |
| Number of Fuel Assemblies                         | 150                 |             |
| Number of Fuel Columns                            | 30                  |             |
| Number of Control Rod Pairs: In Core/In Reflector | 7/9                 |             |

The general HTTR fuel specifications are summarized below in Table II, from [!cite](osti_1484524).

| Fuel Kernel                                                        |
|:-------------------------------------|:----------------------------|
| Material                             | UO${_2}$                    |
| Diameter                             | 600 ${\mu}$m                |
| Density                              | 10.41 g/cm$^{3}$            |

| Coated Fuel Particle                                               |
|:-------------------------------------|:----------------------------|
| Type/Material                        | TRISO                       |
| Diameter                             | 920 ${\mu}$m                |
| Impurity                             | <3 (Boron Equivalent) ppm   |

| Fuel Compact                                                       |
|:-------------------------------------|:----------------------------|
| Type                                 | Hollow Cylinder             |
| Material                             | Coated Fuel Particles, Binder, and Graphite  |
| Outer/Inner Diameter                 | 2.6/1.0 cm                  |
| Length                               | 3.9 cm                      |
| Packing Fraction of CFPs             | 30 vol%                     |
| Density of Graphite Matrix           | 1.7g/cm$^{3}$               |
| Impurity in Graphite Matrix          | <1.2 (Boron Equivalent) ppm |

| Fuel Rod                                                           |
|:-------------------------------------|:----------------------------|
| Outer Diameter                       | 3.4 cm                      |
| Sleeve Thickness                     | 3.75 mm                     |
| Length                               | 54.6 cm                     |
| Number of Fuel Compacts              | 14                          |
| Number of Rods in a Block            | 31/33                       |

| Graphite Sleeve                                                    |
|:-------------------------------------|:----------------------------|
| Type                                 | Cylinder                    |
| Material                             | IG 110 Graphite             |
| Length                               | 58 cm                       |
| Gap Width between Compact and Sleeve | 0.25 mm                     |

| Graphite Block                                                     |
|:-------------------------------------|:----------------------------|
| Type/Configuration                   | Pin in Block/Hexagonal      |
| Material                             | IG 110 Graphite             |
| Width across Flats                   | 36 cm                       |
| Height                               | 58 cm                       |
| Fuel Hole Diameter                   | 4.1 cm                      |
| Density                              | 1.75 g/cm$^{3}$             |
| Impurity                             | <1 (Boron Equivalent) ppm   |
