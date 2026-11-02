################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State and Transient               ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
## Common base for the steady state and transient inputs                      ##
################################################################################

!include ../common/MP_Griffin_base.i

[Mesh]
  parallel_type = DISTRIBUTED
[]

[Executioner]
  richardson_rel_tol = 1e-9

  diffusion_prec_type = lu
[]

[AuxVariables]
  [Tf]
    initial_condition = 725.0
  []
  [nH]
    initial_condition = 1.94
  []
[]

[GlobalParams]
  library_file = '../../ISOXML/GCMR_XS_2grid_detailed.xml'
  library_name = GCMR_XS_2grid_detailed
  # power normalization
  plus = true
  grid_names = 'Tfuel Hdens'
  grid_variables = 'Tf nH'
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10  100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
    # TODO: Add changes in densities
  []
[]

[UserObjects]
  [axial_power_inner]
    type = LayeredIntegral
    variable = power_density
    direction = z
    num_layers = 24
    block = '400 401 4000 4001 40000 40001 1000 1003'
  []
[]

[AuxKernels]
  [axial_power_inner]
    type = SpatialUserObjectAux
    variable = axial_power_inner
    execute_on = timestep_end
    user_object = axial_power_inner
  []
[]

[AuxVariables]
  [axial_power_inner]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[VectorPostprocessors]
  [axial_power_inner_elm]
    type = ElementValueSampler
    variable = axial_power_inner
    sort_by = z
    execute_on = timestep_end
  []
[]

[Outputs]
  exodus = false
[]

[Transfers]
  [from_sub_stoich]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = nH
    source_variable = stoich_griffin
    to_blocks = ${non_he_channel_blocks}
  []
  [from_sub_stoich_he]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bison
    variable = nH
    source_variable = stoich_griffin
    to_blocks = ${he_channel_blocks}
  []
[]
