# Griffin MHTGR Benchmark Model, Model Inputs, and Results

!tag name=MHTGR Griffin Benchmark
     description=Neutronics benchmark of the MHTGR using one-sixth assembly homogenization and 26-group diffusion
     image=https://mooseframework.inl.gov/virtual_test_bed/media/mhtgr/radial_core_layout.png
     pairs=reactor_type:HTGR
                       reactor:MHTGR
                       geometry:core
                       simulation_type:neutronics
                       transient:steady_state
                       V&V:benchmark
                       codes_used:Griffin
                       computing_needs:Workstation
                       fiscal_year:2023
                       institution:INL
                       sponsor:ART

[Griffin MHTGR benchmark model](mhtgr_griffin/mhtgr350_model.md)

[Griffin MHTGR benchmark model inputs](mhtgr_griffin/mhtgr350_model_inputs.md)

[Griffin MHTGR benchmark results](mhtgr_griffin/mhtgr350_results.md)

