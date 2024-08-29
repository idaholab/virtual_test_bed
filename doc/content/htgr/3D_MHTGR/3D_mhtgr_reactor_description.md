# Modular High-Temperature Gas-Cooled Reactor (3D-MHTGR) Reactor Description

The Modular High Temperature Gas-Cooled Reactor (MHTGR) is a Generation-IV reactor design. It was designed to allow coupling to industrial applications, such as "co-generation of electricity and steam supply or high temperature gas supply to petrochemical and refining plants, electricity and steam supply for oil recovery from oil sands, and high temperature steam or gas and electricity for hydrogen production" [!cite](osti_1149009). The modularity of the design, along with a relatively modest 350MW power rating, would allow for a reduction of construction costs. MHTGR technology presents an opportunity for process heat generation, thereby reducing greenhouse gas emissions.

## Historical and International Context of MHTGR Development

Since the 1980s, HTGR designs using both pebble bed and prismatic reactor fuel designs have been developed by the United States, South Africa, China, Japan, France, and Germany [!cite](osti_1149009).

Germany built and operated the AVR 15MWe, one of the first HTGR plants, in the mid-1960s. It operated for over 20 years as a valuable test bed for fuel and safety experiments relevant to the MHTGR concept. In 1987, the 300MWe THTR-300 (thorium cycle high-temperature nuclear reactor) prototype HTR plant was commissioned and started operating at full power. The plant was shut down in 1989 due to economics and lack of government financial support [!cite](status_of_HTGR_dev_design).

The Japan Atomic Energy Agency constructed the prismatic-based High Temperature Engineering Test Reactor (HTTR), which achieved first criticality in 1998 and operation of the high temperature test operation mode in 2004 [!cite](osti_1149009).

The Chinese Institute of Nuclear and New Energy Technology (INET) constructed the 10MW(t) High Temperature Reactor (HTR)-10 in Beijing in 1992. The HTR-10 achieved first criticality in 2000 and successfully connected to the electric grid in 2003. INET completed four safety experiments to confirm safety features of HTRs from 2003 to 2006 [!cite](osti_1149009).

In 2006, the Department of Energy (DOE) initiated the Next Generation Nuclear Plant (NGNP) project at the Idaho National Laboratory. An objective of the NGNP project was to demonstrate HTGR technology's ability to produce high temperature heat and electricity. In 2007, South African group Pebble Bed Modular Reactor (PBMR) Pty Ltd. and French group AREVA NP, Inc. developed preconceptual designs for pebble bed and prismatic based nuclear power plants [!cite](osti_1149009).

The 3D Modular High-Temperature Gas-Cooled Reactor Model is based on the MHTGR 350MW, annular prismatic block core design developed by General Atomics (GA) and the Department of Energy in the 1980s [!cite](NEYLAN198899). This design was chosen to maximize power rating while still permitting passive core heat removal and maintaining silicon carbide temperature below 600$^{\circ}$C during a cooldown event [!cite](osti_1832146).

## Reactor Core Design

The axial and radial core layouts of this simplified model are presented below in Figures 1 and 2.

The axial core layout, show below in Figure 1, includes the Reactor Pressure Vessel (RPV), the Upper Plenum Thermal Protection Structure (UPTPS), coolant channels on the exterior of the core, fuel columns containing 10 fuel blocks surrounded by 2 upper reflector blocks and 2 bottom reflector blocks, replaceable reflector columns composed of 13 blocks, a bottom layer of flow distribution and central reflector support blocks, and a top layer of Alloy 800H blocks covering the core.

!media media/htgr/mhtgr/3D_mhtgr_axial_core_layout.png
    style=width:45%
    caption=Figure 1: Axial core layout, from [!cite](osti_1129932).

The general radial layout of the MHTGR core, shown in Figure 2, follows a hexagonal lattice containing 54 fuel columns without a reserve shut-down control (RSC) channel, 12 fuel columns with a RSC channel, 12 coolant channels, 24 replaceable reflector columns with control rod channels, and 54 replaceable reflector columns, all surrounded by 24 permanent reflector columns composed of 2020 Graphite and the RPV.

!media media/htgr/mhtgr/3D_mhtgr_radial_core_layout.png
    style=width:45%
    caption=Figure 2: Radial core layout, from [!cite](osti_1129932).

The general 3D-MHGTR design specifications are summarized below in Table I, from [!cite](osti_1832146), [!cite](osti_1129932), and [!cite](mhtgr_benchmark).

!table id=table-floating caption=3D-MHTGR design specifications.
| Design Specifications                         | Value/Type             | Unit        |
|:----------------------------------------------|:-----------------------|:------------|
| Thermal Power                                 | 350                    | MW(t)       |
| Electric Capacity                             | 165                    | MW(e)       |
| Average Power Density                         | 5.93                   | MW/m$^{3}$  |
| Inlet Temperature                             | 259                    | $^{\circ}$C |
| Coolant Pressure                              | 6.39                   | MPa         |
| Mass Flow Rate                                | 157.1                  | kg/s        |
| Outlet Temperature                            | 687                    | $^{\circ}$C |


| Dimensions/Geometry                           | Value/Type             | Unit        |
|:----------------------------------------------|:-----------------------|:------------|
| Core Configuration                            | Annular                |             |
| Reactor Vessel Height                         | 22                     | m           |
| Reactor Vessel Outer Diameter                 | 6.8                    | m           |
| Burnable Poison Radius                        | 0.5715                 | cm          |
| Burnable Poison Gap Radius                    | 0.635                  | cm          |
| Fuel Radius                                   | 0.6225                 | cm          |
| Fuel Gap Radius                               | 0.635                  | cm          |
| Large Coolant Channel Radius                  | 0.794                  | cm          |
| Small Coolant Channel Radius                  | 0.635                  | cm          |
| RSC Channel Radius                            | 4.7625                 | cm          |
| Control Rod Channel Radius                    | 5.1                    | cm          |
| Lattice Radial Size                           | 3.5                    | m           |
| Core Active Fuel Height                       | 7.93                   | m           |
| Core Reflector Heights                        | 9.7/12.2               | m           |


| Materials                                     | Type                                 |
|:----------------------------------------------|:-------------------------------------|
| Core Structure                                | Alloy 800H                           |
| Fuel Type                                     | Prismatic Hex-Block                  |
| Fuel Enrichment                               | UCO of 15.5 wt% enriched U-235       |
| Burnable Poison                               | B${_4}$C                             |
| Primary Coolant                               | Helium                               |
| Bottom Reflector Block                        | H-451 Graphite                       |
| Bottom Transition Reflector Block             | H-451 Graphite                       |
| Replacable Central Reflector Support Block    | 2020 Graphite                        |
| Flow Distribution Block                       | 2020 Graphite                        |
| Ceramic Tile                                  | Ceraform 1000                        |
| Upper Plenum Thermal Protection Structure     | Alloy 800H                           |
| Metallic Plenum Element                       | Alloy 800H                           |
| Metallic Core Support Structure               | Alloy 800H                           |
| Core Restraint Element                        | Alloy 800H                           |
| Insulation                                    | Kaowool                              |
| Reactor Pressure Vessel                       | SA-533B Steel                        |


| Core Layout                                   | Quantity                             |
|:----------------------------------------------|:-------------------------------------|
| Fuel Columns with RSC Channel                 | 12                                   |
| Fuel Columns without RSC Channel              | 54                                   |
| Fuel Assemblies with RSC                      | 6                                    |
| Fuel Pins per Fuel Assembly with RSC          | 132                                  |
| Burnable Poison Pins per Fuel Assy. with RSC  | 6                                    |
| Fuel Assemblies without RSC                   | 1                                    |
| Fuel Pins per Fuel Assembly without RSC       | 143                                  |
| Burnable Poison Pins per Fuel Assy. w/o RSC   | 4                                    |
| Reflector Assemblies                          | 30                                   |
| Coolant Channels                              | 1                                    |
| Replaceable Reflector Columns with CR Channel | 24                                   |
| Replaceable Reflector Columns                 | 54                                   |
| Permanent Reflector Columns                   | 24                                   |
