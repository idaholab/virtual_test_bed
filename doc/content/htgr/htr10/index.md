# Griffin HTR-10 Model and Results

*Contact: Javier Ortensi, Javier.Ortensi@inl.gov*

*Model link: [HTR-10 Griffin Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr10)*

!tag name=HTR-10 Griffin Neutronics Model
     description=HTR-10 core neutronics eigenvalue simulation
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htr10/htr-10-with-vessel.png
     pairs=reactor_type:HTGR
           reactor:HTR-10
           geometry:core
           simulation_type:neutronics
           transient:steady_state
           v&v:verification
           codes_used:Griffin
           computing_needs:Workstation
           fiscal_year:2021
           sponsor:NRC
           institution:INL

[Griffin HTR-10 Model](htr10/griffin_htr10_model.md)

[Griffin HTR-10 Results](htr10/griffin_htr10_results.md)

