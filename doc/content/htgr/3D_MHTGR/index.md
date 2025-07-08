# 3D mesh of the mHGTR

*Contact: Olin Calvin, olin.calvin.at.inl.gov*

*Model summarized and documented by Kylee Swanson*

*Model link: [3D Mesh of the modular HTGR](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr/3D_mesh/)*

!tag name=3D-MHTGR Mesh
     description=3D mesh of the mHTGR
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htgr/mhtgr/3D_mesh/ring_boundary.png
     pairs=reactor_type:HTGR
            reactor:MHTGR
            geometry:core
            codes_used:MOOSE_Reactor
            computing_needs:Workstation
            input_features:reactor_meshing
            fiscal_year:2024
            sponsor:NEAMS
            institution:INL
            simulation_type:mesh-only

[3D-MHGTR 350MW Model Reactor Description](3D_mhtgr_reactor_description.md)

[3D-MHGTR 350MW Model Mesh](3D_mhtgr_mesh.md)
