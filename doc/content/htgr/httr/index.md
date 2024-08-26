# High Temperature Engineering Test Reactor (HTTR) Multiphysics Model

!tag name=High Temperature Engineering Test Reactor Steady State Model
     description=This model of the HTTR core solves neutronics, heat conduction and thermal-hydraulics to perform a null-transient simulation, preliminary to transient analysis
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htgr/httr/CoreLayout.png
     pairs=reactor_type:HTGR
                       reactor:HTTR
                       geometry:core
                       simulation_type:multiphysics
                       input_features:multiapps
                       transient:steady_state;null
                       codes_used:Sabertooth;Griffin;MOOSE_HeatTransfer;RELAP-7
                       computing_needs:Workstation
                       fiscal_year:2023

[HTTR Reactor Description](httr/httr_reactor_description.md)

[HTTR Steady-State Model Description](httr/httr_steady_state_model_description.md)

[HTTR Null-Transient Model Description](httr/httr_null_transient_model_description.md)

[HTTR Model Results](httr/httr_model_results.md) 