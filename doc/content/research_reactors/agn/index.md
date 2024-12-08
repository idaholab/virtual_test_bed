# Aerojet General Nucleonics 201 (AGN-201) Research Reactor Mesh

*Contact: Olin Calvin, olin.calvin.at.inl.gov

*Model link: [AGN-201 Mesh](https://github.com/idaholab/virtual_test_bed/tree/main/research_reactors/agn/)*

!tag name=AGN-201 Model
     description=3D mesh of the AGN-201 generated using the MOOSE Reactor module
     image=https://mooseframework.inl.gov/virtual_test_bed/media/research_reactors/agn_meshes/extrude.png
     pairs=reactor_type:research_reactor
           reactor:AGN-201
           geometry:core
           codes_used:MOOSE_Reactor
           computing_needs:Workstation
           input_features:reactor_meshing
           fiscal_year:2024
           sponsor:NNSA
           institution:INL
           simulation_type:mesh-only

[AGN-201 Model Reactor Description](agn_reactor_description.md)

[AGN-201 Model Mesh](agn_mesh.md)
