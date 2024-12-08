# Pebble Bed Modular Reactor (PBMR)

!tag name=Pebble Bed Modular Reactor Core Multiphysics
     description=Multiphysics model with coarse mesh thermal hydraulics and multigroup neutron diffusion of the PBMR400 reference plant core
     image=https://mooseframework.inl.gov/virtual_test_bed/media/pbmr/PBMR400Mesh.png
     pairs=reactor_type:HTGR
                       reactor:PBMR-400
                       geometry:core
                       simulation_type:multiphysics
                       V_and_V:verification
                       input_features:multiapps;mixed_restart
                       transient:steady_state;PLOFC
                       codes_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       fiscal_year:2021
                       sponsor:NEAMS
                       institution:INL

[Model Description](pbmr/model_description.md)

[Model Results](pbmr/model_results.md)
