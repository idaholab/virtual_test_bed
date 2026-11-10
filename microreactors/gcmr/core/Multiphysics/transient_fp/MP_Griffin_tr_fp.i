################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Control Rod Insertion                    ##
## Griffin Main Application input file with fission product tracking          ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_Griffin_base.i

[Mesh]
  parallel_type = DISTRIBUTED
[]

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 1e-6
  richardson_rel_tol = 1e-7
  richardson_max_its = 1000
  max_inner_its = 100

  end_time = 172800
  dtmax = 10
  dtmin = 1e-3

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
  []
[]

[TransportSystems]
  equation_type = transient
[]

[GlobalParams]
  library_file = '../../ISOXML/GCMR_XS_Xe_TR.xml'
  library_name = 'GCMR_XS_Xe_TR'
  grid_names = 'Tfuel'
  grid_variables = 'Tf'
[]

[PowerDensity]
  poison_tracking_chains = 'XE135 SM149'
[]

[Materials]
  [mod_fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '400 401 4000 4001 40000 40001'
    plus = true
  []
  [mod_nonfuel_nocr]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10 100 101 102 103 200 201 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 250'
    plus = false
  []
  [mod_cr]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '1777 1773 300 301'
    rod_segment_length = '2.2'
    rod_withdrawn_direction = z
    isotopes = 'pseudo; pseudo; pseudo'
    densities = '1.0 1.0 1.0'
    segment_material_ids = '807 809 805'
    front_position_function = control_rod_position
    diffusion_coefficient_scheme = user_supplied
  []
[]

[Functions]
  [control_rod_position]
    type = ParsedFunction
    # control rod is fully inserted at the beginning of the transient
    expression = '0.2'
  []
[]

[UserObjects]
  [ss]
    writing = false
    execute_on = initial
    folder = '../steady_state_fp'
  []
  [restart_poison_densities]
    type = SolutionVectorFile
    var = 'poison_tracking'
    writing = false
    execute_on = initial
    folder = '../steady_state_fp'
  []
[]

[Outputs]
  checkpoint = true
  [exodus]
    type = Exodus
    show = 'poison_tracking power_density Tf'
    enable = false
  []
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    input_files = MP_BISON_tr_fp.i
    execute_on = 'initial timestep_end'
    sub_cycling = false
  []
[]

[Transfers]
  [to_sub_power_density]
    execute_on = 'timestep_end'
  []
[]

[Postprocessors]
  [NI]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 0
  []
  [NXe]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 1
  []
  [NPm]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 2
  []
  [NSm]
    type = ElementIntegralArrayVariablePostprocessor
    variable = poison_tracking
    component = 3
  []
[]
