# Heat-Pipe Micro Reactor (MR) Description

The VTB MRAD model is based off of the Micro-Reactor design under analysis by the NEAMS Micro-Reactor Application Drivers area [!citep](Stauff2021). As a modeling exercise, a micro-reactor concept was designed at ANL to gather some of the most pressing modeling challenges faced by the micro-reactor industry: a) the use of heat pipe technologies to remove the nuclear heat; b) the use of TRi-structural ISOtropic (TRISO) fuel to enable operations at very high temperatures; c) the use of rotating control rod drums in the radial reflectors. More details about the design and modeling of this reactor can be found in [!citep](stauff2022multiphysics).

## Core Description

This core has a rated power of 2 MW thermal and its layout is shown in the Figure below. A traditional TRISO fuel with 19.95 at% Low-Enriched Uranium (LEU) in UCO form was adopted in a hexagonal graphite matrix with a 40% packing fraction. The core length is set to 160 cm with 20 cm upper and lower axial reflectors made of beryllium metal. 30 fuel assemblies are surrounded by one ring of beryllium reflector and 12 control drums. Only one sixth of the core geometry was modeled to reduce the size of the modeling problem.

!media media/mrad/legacy/mrad_geometry/mrad_diagram.png
       style=width:50%

To achieve an optimum level of moderation, yttrium-hydride (YH2) pins are employed in addition to the graphite structure component, as YH2 provides more efficient neutron slowing-down capability, enabling the design of a more compact core. The yttrium-hydride is clad in a stainless steel envelope, with a helium gap between the YH2 and envelope and then another helium gap between the envelope and the graphite monolith.

This concept employs heat pipes with a stainless-steel envelope and potassium working fluid. The heat pipe is separated from the graphite monolith by a helium gap. The heat pipe is divided into three radial regions: the working fluid vapor, the working fluid liquid plus wick, and the envelope.

The control system of the core includes 12 control drums located in the radial reflector that are capable of bringing the core to cold shutdown throughout the operation of the reactor. For redundancy purposes, a shutdown rod is located in the central core location.
