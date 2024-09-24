# LOTUS Molten Chloride Reactor (LMCR)

!tag name=Lotus Griffin-Pronghorn Steady State Model
     description=Multiphysics, neutronics and computational fluid dynamics, model of the primary molten fuel loop of a generic molten chloride reactor in the LOTUS test bed
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/lotus/MCR_geometry.jpg
     pairs=reactor_type:MSR
                       reactor:generic_msr
                       geometry:core
                       simulation_type:multiphysics
                       input_features:multiapps
                       transient:steady_state
                       codes_used:BlueCrab;Griffin;Pronghorn;MOOSE_NavierStokes
                       open_source:partial
                       computing_needs:HPC
                       fiscal_year:2024
                       institution:INL
                       sponsor:NEAMS

[Description of the reactor](lotus_description.md)

[Griffin-Pronghorn Model](lotus_multiphysics_model.md)

[Steady State Results](lotus_results.md)

