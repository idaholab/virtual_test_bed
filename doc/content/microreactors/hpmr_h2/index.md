# Heat Pipe Microreactor with Hydrogen Redistribution (HPMR-H$_2$)

!tag name=HPMR Steady State Model with moderator hydrogen redistribution
     description=Heat Pipe Microreactor core multiphysics model with neutronics, thermal physics and hydrogen redistribution
     image=https://mooseframework.inl.gov/virtual_test_bed/media/hpmr_h2/hpmr_h2_geometry.jpeg
     pairs=reactor_type:microreactor
           reactor:HPMR_H2
           geometry:core
           simulation_type:multiphysics
           v&v:demonstration
           input_features:multiapps;reactor_meshing
           codes_used:DireWolf;Griffin;BISON;Sockeye
           computing_needs:HPC
           fiscal_year:2024
           institution:INL
           sponsor:INL-LDRD

[Reactor Description](hpmr_h2/hpmr_h2_description.md)

[Multiphysics Griffin-Bison-Sockeye Model](hpmr_h2/hpmr_h2_model.md)

[Multiphysics Griffin-Bison-Sockeye Results](hpmr_h2/hpmr_h2_results.md)
