# Molten Salt Reactor Depletion

!tag name=MSR Depletion Model
     description=Spatial depletion of the molten fuel in a generic molten salt reactor with HALEU fuel
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htgr/pulse/refcube.png
     pairs=reactor_type:MSR
                       reactor:generic_MSR
                       geometry:mini-core
                       simulation_type:depletion
                       codes_used:Griffin
                       computing_needs:Workstation
                       fiscal_year:2023
                       sponsor:ART
                       institution:INL

[Model](depletion/model.md)

[Results](depletion/results.md)
