# SNAP 8 Experimental Reactor (S8ER)

!tag name=SNAP 8 Experimental Reactor Multiphysics model
     description=Core steady-state multipysics model of the SNAP8 experimental reactor
     image=https://mooseframework.inl.gov/virtual_test_bed/media/s8er/SNAP8ER_C3_2D_NODRUMS_WET_3_4.i_geom1.png
     pairs=reactor_type:microreactor
           reactor:SNAP-8
           geometry:core
           input_features:multiapps
           simulation_type:multiphysics
           transient:steady_state
           v&v:demonstration
           codes_used:Griffin;BISON;Serpent
           computing_needs:Workstation
           fiscal_year:2023
           sponsor:NRIC;NEUP
           institution:INL

[Reactor Description](s8er_reactor_description.md)

[Multiphysics Griffin-Bison Model](s8er_multiphysics_model.md)

[Multiphysics Griffin-Bison Results](s8er_multiphysics_results.md)
