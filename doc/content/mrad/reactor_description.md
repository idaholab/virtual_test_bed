# Heat-Pipe Micro Reactor (MR) Description

The VTB MRAD model is based off of the Micro-Reactor design under analysis by the NEAMS Micro-Reactor Application Drivers area [!citep](Stauff2021). As a modeling exercise, a micro-reactor concept was designed at ANL to gather some of the most pressing modeling challenges faced by the micro-reactor industry: a) the use of heat pipe technologies to remove the nuclear heat; b) the use of TRi-structural ISOtropic (TRISO) fuel to enable operations at very high temperatures; c) the use of rotating control rod drums in the radial reflectors. 

## Core Description

This core has a rated power of 2 MW thermal and its layout is shown in the Figure below. A traditional TRISO fuel with 19.95 at% Low-Enriched Uranium (LEU) in UCO form was adopted in a hexagonal graphite matrix with a 40% packing fraction. The core length is set to 160 cm with 20 cm upper and lower axial reflectors made of beryllium metal. 30 fuel assemblies are surrounded by one ring of beryllium reflector and 12 control drums. Only one sixth of the core geometry was modeled to reduce the size of the modeling problem. 

!media media/mrad/mrad_geometry/mrad_diagram.png
       style=width:50%

To achieve an optimum level of moderation, yttrium-hydride (YH2) pins are employed in addition to graphite structure component as YH2 provides more efficient neutron slowing-down capability enabling the design of more compact core. The yttrium-hydride is surrounded in two layers of helium gaps separating the moderator, the stainless steel envelope and the graphite monolith. 

This concept employs heat pipes with a stainless-steel envelope and potassium heat-transfer fluid. The heat pipe is separated from the graphite monolith by another layer of helium gap. The heat pipe region has been divided into three zones representing the fluid at the phase of vapor, liquid and wick respectively. 

The control system of the core includes 12 control drums located in the radial reflector that are capable of bringing the core to cold shutdown throughout the operation of the reactor. For redundancy purposes, a shutdown rod is located in the central core location.
