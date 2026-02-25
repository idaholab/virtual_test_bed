# HTR-PM Multiphysics Model

!tag name=HTR-PM Core multiphysics
     description=Steady state and transient core model
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htrpm_coremultiphysics/solid-temperature-dist.png
     pairs=reactor_type:HTGR
           reactor:HTR_PM
           geometry:core
           simulation_type:thermal_hydraulics;neutronics
           transient:steady_state;DLOFC
           codes_used:Pronghorn;Griffin
           input_features:multiapps
           V_and_V:verification
           computing_needs:Workstation
           fiscal_year:2025
           sponsor:NRC
           institution:INL

[Model Description](htr-pm/core-multiphysics/model-description.md)

[Neutronics Model](htr-pm/core-multiphysics/neutronics-model.md)

[Thermal Fluid Model](htr-pm/core-multiphysics/thermal-fluid-model.md)

[Depressurized Loss of Forced Cooling Transient](htr-pm/core-multiphysics/transient.md)
