# Molten Salt Fast Reactor Coupled Model

!tag name=MSFR Steady-State Griffin-Pronghorn-SAM Coupling
     description=Multiphysics model of the Euratom EVOL MSFR using Griffin, Pronghorn and SAM for core neutronics, fluid dynamics and the balance of plant thermal hydraulics respectively
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/msfr/plant/MSFR_coupling_domain_overlap.png
     pairs=reactor_type:MSR
           reactor:MSFR
           geometry:primary_loop
           simulation_type:multiphysics
           v&v:demonstration
           codes_used:BlueCrab;Griffin;Pronghorn;SAM
           input_features:multiapps
           transient:steady_state
           computing_needs:HPC
           fiscal_year:2023
           institution:INL
           sponsor:NEAMS;NRIC

[Description of the reactor](msfr/reactor_description.md)

[Griffin-Pronghorn model](msfr/griffin_pgh_model.md)

[Steady State Coupling](msfr/plant/steady_state_coupling.md)

[Griffin-Pronghorn-SAM steady-state results](msfr/plant/griffin_pgh_SAM_steady_results.md)



!alert note
To request access to Griffin, please submit a request on the
[INL modeling and software website](https://modsimcode.inl.gov/SitePages/Home.aspx).
