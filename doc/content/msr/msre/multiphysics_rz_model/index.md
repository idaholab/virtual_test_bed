# Multiphysics RZ Model of MSRE

!tag name=MSRE Griffin-Pronghorn Steady State Model
     description=Multiphysics steady-state model of the MSRE core using 2D RZ geometry with Griffin for neutronics and Pronghorn for fluid dynamics.
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/msre/MSRE_pgh_fields.png
     pairs=reactor_type:MSR
           reactor:MSRE
           geometry:core
           simulation_type:multiphysics
           transient:steady_state
           input_features:multiapps
           v&v:demonstration
           codes_used:BlueCrab;Griffin;Pronghorn
           computing_needs:Workstation
           fiscal_year:2023
           institution:INL
           sponsor:NEAMS;NRIC

[Multiphysics RZ Steady State Model](msre_multiphysics_core_model.md)

[Multiphysics RZ Model Results](msre_multiphysics_results.md)











