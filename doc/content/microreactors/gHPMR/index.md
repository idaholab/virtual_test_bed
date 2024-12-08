# 2D gHPMR Reactor Mesh

*Contact: Olin Calvin, olin.calvin.at.inl.gov

*Model link: [Generic Heat Pipe Micro-Reactor 2D Mesh](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gHPMR)*

!tag name=gHPMR Model
     description=2D mesh of a generic heat pipe microreactor
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gHPMR/final_core.png
     pairs=reactor_type:microreactor
            reactor:gHPMR
            geometry:core
            codes_used:MOOSE_Reactor
            computing_needs:Workstation
            input_features:reactor_meshing
            fiscal_year:2024
            sponsor:NEAMS
            institution:INL;ANL
            simulation_type:mesh-only

[2D gHPMR Model Reactor Description](gHPMR_reactor_description.md)

[2D gHPMR Model Mesh](gHPMR_mesh.md)
