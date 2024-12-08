# Fuel Performance: Pin DP11 of [!ac](IFR) X447/A Experiment

*Contact: Yinbin Miao (ymiao.at.anl.gov)*

*Primary Contributors: Yinbin Miao, Aaron Oaks, Shipeng Shu, Abdellatif Yacout*

*Model link: [X447_DP11](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/ebr2_x447_dp11)*

!tag name=Metallic Fuel Performance
  image=https://mooseframework.inl.gov/virtual_test_bed/media/ebr2_x447_dp11/fcci_dp11.png
  description=This BISON metallic fuel performance model is part of the SFR validation data from the FIPD database, and compares experimental measurements of the EBR2 X447-DP11 with simulation results.
  pairs=reactor_type:SFR
        geometry:fuel_pin
        simulation_type:thermo_mechanics
        transient:steady_state
        v&v:validation
        codes_used:BISON
        computing_needs:Workstation
        fiscal_year:2024
        sponsor:NEAMS
        institution:ANL

!alert note title=Acknowledgement
This VTB model was developed based on the baseline [!ac](SFR) metallic fuel modeling capabilities [!citep](Matthews2023Metal) and the BISON-[!ac](FIPD) integration framework [!citep](Miao2021X447,Miao2023X423).

This case is focused on the verification and validation (V&V) demonstration of the BISON's [!ac](SFR) metallic fuel performance models powered by integration with the [!ac](FIPD) database [!citep](Yacout2021FIPD), which maintains the steady-state fuel irradiation data collected during the [!ac](IFR) program. Pin DP11 irradiated in the experimental subassembly X447, which was designed to investigate the high-temperature effects on cladding degradation caused by [!ac](FCCI) and [!ac](CCCI), was selected to be the representative of the demonstration case.

[Experiment Introduction](/dp11_introduction.md)

[BISON-FIPD Integration](/dp11_data_integration.md)

[Fuel Performance Models](/dp11_models.md)

[Simulation Results and Discussions](/dp11_results.md)
