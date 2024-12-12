################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin input file for decoupled calculations                              ##
## Steady state neutronics model                                              ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

!include run_neutronics_base.i

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 873.15 # in degree K
    block = 'fuel pump hx'
  []
  # TODO: remove once we have block restricted transfers
  [tfuel_constant]
    initial_condition = 873.15 # in degree K
    block = 'reflector shield'
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    block = 'fuel pump hx'
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
  [dnp_ak]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'timestep_begin final'
  []
[]
