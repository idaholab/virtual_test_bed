# GCMR Balance of Plant

## 1D thermal hydraulic simulation

!tag name=Gas-Cooled Microreactor Balance of Plant
     description=Startup and load follow transient simulation of the GCMR balance of plant coupled with core multiphysics
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gcmr/balance_of_plant/system_diagram.png 
     pairs=reactor_type:microreactor
                       reactor:GCMR
                       geometry:plant
                       simulation_type:multiphysics
                       codes_used:BlueCrab;Griffin;MOOSE_ThermalHydraulics
                       input_features:control_logic
                       transient:startup;load_follow
                       open_source:partially
                       computing_needs:Workstation
                       fiscal_year:2023
                       institution:INL
                       sponsor:NRIC
                       
*Contact: Lise Charlot (lise.charlot.at.inl.gov)*

[System Description](gcmr/BOP_system_description.md)

[Model Description](gcmr/BOP_model_description.md)

[Results](gcmr/BOP_results.md)