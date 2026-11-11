# MSRE Multiphysics Primary Loop Model

!tag name=MSRE Multiphysics Primary Loop Model
     description=Integrated multiphysics steady-state model of the MSRE using domain overlapping coupling between SAM (system TH), Pronghorn-Griffin (core neutronics/TH), and Saline (molten salt properties), validated against MSRE design data at 10 MW.
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/msre/multiphysics_loop_model/MSRE_SS_vel.png
     pairs=reactor_type:MSR
           reactor:MSRE
           geometry:primary_loop;core
           simulation_type:multiphysics
           transient:steady_state
           input_features:multiapps;domain_overlapping
           V_and_V:validation
           codes_used:BlueCrab;Griffin;Pronghorn;SAM;Saline
           computing_needs:HPC
           fiscal_year:2025
           institution:ANL;INL
           sponsor:NEAMS

[Model Description and Input Files](msre_do_model.md)

[Simulation Results](msre_do_results.md)
