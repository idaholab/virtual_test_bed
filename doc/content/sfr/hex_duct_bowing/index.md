# Hexagonal Duct IAEA Benchmarks

!tag name=Hexagonal Duct IAEA Benchmarks
    description=Thermomechanics simulation of a sodium fast reactor hexagonal assembly follow IAEA VP benchmarks
    image=https://mooseframework.inl.gov/virtual_test_bed/media/hex_duct_bowing/vp3a_mesh.png
    pairs=reactor_type:SFR
                       geometry:assembly_duct
                       simulation_type:component_analysis;thermo_mechanics
                       codes_used:MOOSE_Solid_Mechanics
                       transient:steady_state
                       computing_needs:Workstation
                       open_source:true
                       fiscal_year:2022
                       sponsor:NEAMS
                       institution:ANL

[Hexagonal Duct Bowing - Linear Thermal Gradient (IAEA VP1)](/hex_duct_linear.md)

[Symmetric Sector Bowing - Linear Thermal Gradient (IAEA VP3A)](/iaea_vp3a_symmetric_sector.md)
