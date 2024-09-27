## HP-MR Based TRISO Failure Model

!tag name=MRAD Micro-Reactor Multiphysics model
     description=A core multiphysics model with steady state and TRISO failures.
     image=https://mooseframework.inl.gov/virtual_test_bed/media/mrad/hpmr_mesh_proc.png
     pairs=reactor_type:microreactor
                       reactor:HPMR
                       geometry:core;TRISO
                       simulation_type:multiphysics
                       input_features:multiapps;reactor_meshing
                       transient:steady_state
                       codes_used:BlueCrab;Griffin;BISON;Sockeye
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:ANL

[Problem Description](mrad/hpmr_triso_failure/problem_description.md)

[Model Description](mrad/hpmr_triso_failure/problem_models.md)

[Results](mrad/hpmr_triso_failure/problem_results.md)
