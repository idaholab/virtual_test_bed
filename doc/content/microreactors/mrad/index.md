# Heat-Pipe Micro Reactor (MR)

!tag name=MRAD Micro-Reactor Multiphysics model
     description=A core multiphysics model with steady state, three accidental transients, and uncertainty quantification of TRISO failures in transients.
     image=https://mooseframework.inl.gov/virtual_test_bed/media/mrad/hpmr_mesh_proc.png
     pairs=reactor_type:microreactor
           reactor:HPMR
           geometry:core
           simulation_type:multiphysics
           v&v:demonstration
           input_features:multiapps;reactor_meshing;mixed_restart
           transient:steady_state;overpower;load_follow;ULOC
           codes_used:BlueCrab;Griffin;BISON;Sockeye
           computing_needs:HPC
           fiscal_year:2023
           sponsor:NEAMS
           institution:ANL

[Description of the reactor](mrad/reactor_description.md)

## Multiphysics Neutronics-Thermal-Heat Pipe Model

[Multiphysics model](mrad/mrad_model.md)

[Multiphysics results](mrad/mrad_results.md)

## Legacy Thermal-Heat Pipe Model

[Legacy Multiphysics model](mrad/legacy_mrad_model.md)

[Legacy Multiphysics results](mrad/legacy_mrad_results.md)

## HP-MR Based TRISO Failure Model

[Index page](mrad/hpmr_triso_failure/index_triso.md)

[Problem Description](mrad/hpmr_triso_failure/problem_description.md)

[Model Description](mrad/hpmr_triso_failure/problem_models.md)

[Results](mrad/hpmr_triso_failure/problem_results.md)
