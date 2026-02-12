# CNRS Multiphysics Modeling

!tag name=CNRS Griffin-Pronghorn Model
     description=CNRS MSR multiphysics benchmark
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/cnrs/step14-results.png
     pairs=reactor_type:MSR
                       reactor:CNRS
                       geometry:core
                       simulation_type:multiphysics
                       transient:steady_state
                       input_features:multiapps
                       codes_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       fiscal_year:2024
                       institution:INL
                       sponsor:NEAMS;NRIC

[Benchmark Description](cnrs/model_description.md)

[Phase 0 model and results](cnrs/phase-0-model.md)

[Phase 1 model and results](cnrs/phase-1-model.md)

[Phase 2 model and results](cnrs/phase-2-model.md)
