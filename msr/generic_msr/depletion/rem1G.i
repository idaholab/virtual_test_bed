# Generic Molten Salt Reactor Depletion
# Griffin input : only with experimental branch (12/16/22)
# Depletion with isotopic removal
# POC: Samuel Walker (samuel.walker at inl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  [gmg]
    type = GeneratedIDMeshGenerator
    dim = 2
    depletion_ids = 0
    material_ids = 1
  []
[]

[Problem]
  type = FEProblem
  solve = false
  kernel_coverage_check = false
[]

[AuxVariables]
  [Burnup]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.0
  []
  [flux]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 8.3989E15
  []
[]

[AuxKernels]
  [constant]
    variable = flux
    type = ConstantAux
    value = 8.3989E15
  []

  [SetBurnup]
     type = FunctionAux
     function = SetBurnup
     variable = Burnup
     execute_on = timestep_begin
  []
[]

[Functions]
  [SetBurnup]
     type = PiecewiseLinear
     x = '0 1800 3600 608400 1213200 1818000 2422800 3027600 3632400 4237200 4842000 5446800 6051600'
     y = '0 0 0 0 0 0 0 0 0 0 0 0 0'
  []
[]

[Materials]
  [Mat_1]
    type = CoupledFeedbackNeutronicsMaterial
    block = 0
    library_file = '../data/Macro_XS_Artifact.xml'
    library_name = 'Macro_XS_Artifact'
    material_id = 1

    # multiphysics variables
    grid_names = 'Burnup'
    grid_variables = 'Burnup'
    scalar_fluxes = 'flux'

    # initial isotopes
    isotopes = 'pseudo'
    densities = '1.0'
  []
[]

[Executioner]
  type = Transient   # Here we use the Transient Executioner
  [TimeStepper]
   type = TimeSequenceStepper
   time_sequence  = '1800 3600 608400 1213200 1818000 2422800 3027600 3632400 4237200 4842000 5446800 6051600'
  []
  start_time = 0.0
  end_time = 6051600
[]

[Outputs]
  csv = false
[]

[VectorPostprocessors]
  [bateman]
    type = BatemanVPP

    # multiphysics variables
    grid_names = 'Burnup'
    grid_variables = 'Burnup'
    scalar_fluxes = 'flux'
    use_power = false

    # loading databases
    isoxml_mglib_file = '../data/MSR_XS.xml'
    isoxml_mglib_name = 'MSR_XS'
    library_id = 1
    isoxml_dtlib_file = '../data/MSR_DT.xml'
    isoxml_dtlib_name = 'MSR_DT'

    # setting initial conditions
    isotope_atomic_densities = 'CL35 1.55753e-02 CL37 4.98332e-03 NA23 8.23094e-3 U232 7.49749e-10 U234 4.05961e-05 U235 8.12118e-04 U236 1.11782e-05 U238 3.20723e-03'
    isotope_fixed_removal_rates = 'I127 3.85E-5 I129 3.85E-5'

    # Bateman solve settings
    bateman_solver = 'CRAMIPF'
    bateman_solver_tolerance = 1e-100
    cram_ipf_order = 48
    use_sparse_gaussian_elimination = false
    track_secondary_particle_production = true
    debug = true
    execute_on = 'initial timestep_begin'
  []
[]
