# Generic fluoride-cooled high-temperature reactor (gFHR)

!tag name=gFHR Griffin-Pronghorn Steady State Model pairs=reactor_type:PB-FHR
                       reactor:gFHR
                       geometry:core
                       simulation_type:multiphysics
                       transient:steady_state
                       input_features:multiapps;physics_syntax
                       codes_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       sponsor:NRC
                       fiscal_year:2024

[Description of the reactor](pbfhr/g_fhr/reactor_description.md)

[Griffin steady state neutronics model](pbfhr/g_fhr/griffin.md)

[Pronghorn steady state thermal hydraulics model](pbfhr/g_fhr/pronghorn.md)

[Pebble - Triso steady state heat conduction model](pbfhr/g_fhr/pebble_triso.md)

[Griffin-Pronghorn Results](pbfhr/g_fhr/griffin_pgh_results.md)
