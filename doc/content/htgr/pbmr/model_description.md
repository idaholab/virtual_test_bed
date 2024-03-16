# Pebble Bed Modular Reactor (PBMR) Description

*Contact: Paolo Balestra (paolo.balestra.at.inl.gov)*

*Model link: [PBMR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pbmr400)*

!tag name=Pebble Bed Modular Reactor Core Multiphysics pairs=reactor_type:HTGR
                       reactor:PBMR-400
                       geometry:core
                       simulation_type:multiphysics
                       input_features:multiapps;mixed_restart
                       transient:steady_state;PLOFC
                       code_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       fiscal_year:2021

The VTB PBMR case is based on the PBMR400 coupled benchmark specifications described in [!citep](PBMR400). The benchmark design has been derived from the 400 MWth Pebble Bed Modular Reactor (PBMR) demonstration plant. The PBMR-400 is a modular thermal reactor with helium coolant and graphite moderator. It utilizes 9.6% enriched uranium dioxide fuel encapsulated with four shells of pyrolitic graphite and ceramic layers, known as TriStructural Isotropic (TRISO) particles. These particles are then embedded into larger graphite pebbles. There are roughly 15,000 of these TRISO particles in each of the 452,000 graphite pebbles in the system. These pebbles are contained in an annular region where they enter the core from the top and leave through the defueling chute at the bottom. Pebbles then are either recirculated or discarded based on their burnup; a pebble makes an average of six passes through the core. During normal operation, 192.7 kg/s of helium at an inlet temperature of 773K flows through the pebbles from the top to the bottom of the core, reaching roughly 1173K at the outlet.

The Thermal-Hydraulic (TH) and Neutron Kinetic (NK) axisymmetric 2D models have been defined to preserve the geometry of the most relevant core components and can be found below. Additionally, a spherical heat conduction model to reconstruct the temperature within the pebble and TRISO fuel has been developed. They can be found pictured in [Mesh].

!media pbmr/PBMR400Mesh.png
        style=width:100%
        id=Mesh
        caption=NK, TH, and TRISO models used to represent the PBMR400 (pictured on the left).

The neutron kinetics model includes the pebble bed, a small portion of the reflector above and below the active region, the top cavity, and the full radial reflector from the center to the core barrel, including the gas gap between the side reflector and barrel. All regions far from the core, where flux solutions may be problematic, have been excluded and replaced by void boundary conditions. In total, 193 material regions exist: 110 for the pebble bed (red), 80 for the reflector (yellow), 1 for the control rod (green), and 2 for the plenum areas (cyan). Since special treatment is required to correctly simulate the neutron streaming effect in the void regions, directional diffusion coefficients for the top cavity and the gas gap are provided in [!citep](PBMR400).

The TH model included more of the system components than the NK model. The helium flows through different porous components, including the inlet lower collector and the outlet collector (20% porosity), as well as the pebble bed (39% porosity). The flow path is indicated with the cyan arrows. The fluid domain is limited to only these three components. At the same time, the solid conduction equations are solved on the entire domain to take into account the heat conducted from the core to the outside boundary through the reflector, the barrel, and the reactor pressure vessel (RPV). Special radiation conduction components have been used to take into account the heat exchange between the two annular cavities around the core barrel. The top, bottom, center, and centerline of the axisymmetric model are considered adiabatic, where the normal heat flux is set to zero. On the right boundary, a thermal resistance model taking into account the radiation and the conduction through the stagnant air gap between the RPV and the Reactor Cavity Cooling System (RCCS) at 293.15K has been imposed. Finally, 192.7 kg/s of inlet mass flow rate, a helium inlet temperature of 773K, and an outlet pressure of 9 MPa boundary conditions are imposed for the fluid domain.

The Pebble/TRISO model is composed of two spherical heat conduction problems; one for the pebble and one for the TRISO fuel.  The pebble model has one 2.5 cm radius layer of an equivalent mixture to simulate the TRISO particle and graphite matrix plus a 0.5 cm shell of graphite. The TRISO particle is divided into five layers: the UO2 kernel, the graphite buffer, the inner pyrolitic graphite, the silicon carbide, and the outer pyrolitic graphite.

As shown in the figure above, the NK model uses the fuel temperature (Tfuel), the moderator temperature (Tmod), and the reflector temperature (Tref) to interpolate the cross-sections, calculate the flux, calculate the Xe concentration, and provide the power denisty (q''') to the TH model. The TH model calculated the pebble surface temperature (Tsurf) and passes it to the 110 Pebble/TRISO models (one for each core mesh) together with the power density to reconstruct the temperature within the pebbles and TRISO particles. Furthermore, the reflector temperature (Tref)is calculated and pass to the NK model. The modeled TRISO particle is a representative average particle, using the pebble core average temperature as the external temperature. Finally, the pebble core temperature is averaged and sent back to the NK model (Tmod) together with the average TRISO kernel temperature (Tfuel).

!alert note
The cross sections for this model are hosted on LFS. Please refer to [LFS instructions](resources/how_to_use_vtb.md#lfs)
to download them.
