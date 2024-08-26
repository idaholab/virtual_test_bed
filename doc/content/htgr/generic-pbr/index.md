# SAM Generic PBR Model and Results

!tag name=SAM Generic PBR Model
     description=Load follow simulation of a generic PBR core using SAM to solve thermal hydraulics and thermal conduction
     image=https://mooseframework.inl.gov/virtual_test_bed/media/generic-pbr/core-geometry.png
     pairs=reactor_type:HTGR
                       reactor:generic_PBR
                       geometry:core
                       simulation_type:multiphysics
                       transient:load_follow
                       input_features:checkpoint_restart
                       codes_used:SAM
                       computing_needs:Workstation
                       fiscal_year:2021
                       sponsor:NEAMS
                       institution:ANL

[SAM generic PBR model](generic-pbr/generic-pbr_model.md)

[SAM generic PBR results](generic-pbr/generic-pbr_results.md)
