# Gas-cooled Microreactor Assembly Model Description

The Gas-Cooled Microreactor (GC-MR) core model with bypass flow is a thermal hydraulics model  that can be used to evaluate the impact of the inter assembly bypass flow on the fuel temperatures. For simplicity, no neutronics is included in this model and the power density is prescribed. The design is from [!citep](Duchnowski2022). The core layout is modified to include assemblies in the corners for compatibility with the available meshes in Pronghorn-SC as shown in [core_layout].

!media media/gcmr/bypass_flow/core_cross_section.png
      style=display: block;margin-left:auto;margin-right:auto;width:50%;
      id=core_layout
      caption= GCMR core layout

Mesh details showing the inter assembly bypass is shown in [core_layout_detailed].

!media media/gcmr/bypass_flow/mesh_details.png
      style=display: block;margin-left:auto;margin-right:auto;width:70%;
      id=core_layout_detailed
      caption= GCMR core layout mesh


The major technical parameters for the GC-MR core model are:

| Parameter (unit)                   | Value     |
| ---------------------------------- | --------- |
| Reactor Power (MWt)                | 15        |
| Fuel                               | TRISO     |
| Coolant                            | He        |
| Moderator                          | Graphite  |
| Reflector                          | Graphite  |
| Inlet/ avg. outlet temperature (K) | 889/ 1200 |
| Pressure (MPa)                     | 7.9       |
| Inlet velocity (m/s)               | 15        |
| Assembly lattice pitch (cm)        | 2.20      |
| Total height (cm)                  | 200       |
| TRISO fuel compact radius (cm)     | 0.794     |
| Coolant hole radius (cm)           | 0.635     |
| Inter assembly gap (cm)            | 0.1       |
