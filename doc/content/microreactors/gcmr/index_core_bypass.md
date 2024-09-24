
# Gas-Cooled Microreactor core with Inter-Assembly Bypass Flow

*Contacts: Lise Charlot (lise.charlot@inl.gov)*

!tag name=GCMR Core Thermal Model
     description=Coupled model with homogenized heat conduction in the core, bypass flow using a subchannel discretization and 1D thermal-hydraulics for the coolant channels
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gcmr/bypass_flow/assembly_mesh.png
     pairs=reactor_type:microreactor
                       reactor:GCMR
                       geometry:core
                       simulation_type:thermal_hydraulics
                       input_features:multiapps
                       codes_used:Pronghorn_subchannel;MOOSE_HeatTransfer;MOOSE_ThermalHydraulics
                       computing_needs:Workstation
                       open_source:partial
                       fiscal_year:2023
                       sponsor:NRIC
                       institution:INL
                       
[Description](gcmr/bypass_flow/Core_with_bypass_description.md)

[Multiphysics Models](gcmr/bypass_flow/Core_with_bypass_model.md)

[Steady-State Results](gcmr/bypass_flow/Core_with_bypass_results.md)
