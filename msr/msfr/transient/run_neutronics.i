################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application input file                                        ##
## Transient neutronics model                                                 ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

!include run_neutronics_base.i

[MSRNeutronicsFluidCoupling]
  fluid_blocks = 'fuel pump hx'
  solid_blocks = 'reflector shield'
  n_dnp = 6
  use_transient_multi_app = true
  initialize_variables_from_mesh_file = true
  fluid_app_name = ns
  fluid_input_file = run_ns.i
  fluid_temperature_name_neutronics_app = tfuel
  fluid_temperature_name_solid_suffix = _constant
  fluid_temperature_name_fluid_app = T_fluid
  dnp_name_prefix = c
  dnp_array_name = dnp
[]
