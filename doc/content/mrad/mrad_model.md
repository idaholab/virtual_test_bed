# Multiphysics model

*Contact: Nicholas Stauff, nstauff.at.anl.gov*

## Mesh File

!alert note
The mesh for this model is hosted on LFS. Please refer to [LFS instructions](resources/how_to_use_vtb.md#lfs)
to download it.

Mesh generation was performed with [Cubit](https://cubit.sandia.gov/) toolkit and the mesh file is used in BISON, and in the MultiApp (coupling BISON and Sockeye). A simplified 1/6 core was generated for preliminary assessment (Figure below). This mesh does not contain the helium gaps and stainless steel envelops for moderators and heat pipes, both of which will be included in the later version of full core model. The mesh density in radial direction is high as multiple small features (fuel rods, moderators, heat pipes and control drums) are involved.

!media media/mrad/mrad_geometry/mrad_mesh.png
       style=width:50%

## BISON Model

The present BISON simulation utilized the heat conduction module in MOOSE, supported with materials models in BISON including the thermal properties of TRISO fuel, thermal and mechanical properties of SS316 (cladding material for YH2). Convective boundary conditions were defined at the top and bottom of the model with an external temperature of 800K and h=100 W/m^2^-K.

!listing /mrad/steady/MP_FC_ss_bison.i max-height = 10000

## Sockeye Model

Sockeye is used for steady-state heat pipe thermal performance using the effective thermal conductivity model, i.e., a 2D axisymmetric conduction model with a very high thermal conductivity of 2×10^5^ W/m-K is applied to the vapor core. A heat flux boundary condition is applied to the exterior of the casing in the evaporator section, which is provided by the bulk conduction model. A convective boundary condition is applied to the exterior of the envelope in the condenser section, with an external temperature of 800 K and h=10^6^ W/m^2^-K.

!listing /mrad/steady/MP_FC_ss_sockeye.i max-height = 10000

## MultiApp

Multiphysics simulations performed leverage the MOOSE MultiApps system to couple thermo-mechanics and heat pipe heat energy transfer systems, which are simulated by BISON, and Sockeye, respectively. Each code has its own mesh and corresponding space and time scales. The MOOSE MultiApp system is leveraged to tightly couple the different codes via Picard iterations as illustrated below. In the absence of a neutronic model, constant power density is transferred to the BISON sub-application into the thermal simulation. Before solving for the temperature, BISON passes the surface temperature at the heat pipes to the Sockeye sub-apps, which compute the temperature distribution in every single heat pipe. Based on the calculated temperature gradient in each heat pipe, the consequent heat flux is passed back to BISON and converted into a heat sink for the thermal calculation.

!media media/mrad/mrad_geometry/mrad_coupling.png
       style=width:50%

The list and location of each heat-pipe in the 1/6 code is provided in:

!listing /mrad/steady/hp_centers.txt max-height = 10000
