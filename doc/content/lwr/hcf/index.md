# Metallic HCF BISON Model

!tag name=Metallic HCF BISON Model
      description=3D cycle fuel perfornamce study for U-50 wt.% Zr helical cruciform fuel
      image=https://mooseframework.inl.gov/virtual_test_bed/media/lwr/hcf/HCF-geometry-intro.png
      pairs=reactor_type:LWR
            reactor:NuScale_Power_Module
            geometry:fuel_pin
            simulation_type:fuel_performance
            transient:depletion
            codes_used:BISON
            open_source:partially
            computing_needs:Workstation;HPC
            fiscal_year:2025
            institution:MIT
            sponsor:NEUP
            V&V:demonstration


[3D metallic HCF cycle fuel performance](hcf_bison_model.md)
