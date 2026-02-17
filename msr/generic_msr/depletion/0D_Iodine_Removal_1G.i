# Generic Molten Salt Reactor Depletion
# Griffin input
# Depletion with isotopic removal
# POC: Olin Calvin (olin.calvin at inl.gov)
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

[Compositions]
  [fuel_salt]
    type = IsotopeComposition
    isotope_densities = 'CL35 1.55753e-02
                         CL37 4.98332e-03
                         NA23 8.23094e-03
                         U232 7.49749e-10
                         U234 4.05961e-05
                         U235 8.12118e-04
                         U236 1.11782e-05
                         U238 3.20723e-03'
    density_type = atomic
    composition_ids = '1'
  []
[]

[Materials]
  [Mat_1]
    type = MSRDepletionNeutronicsMaterial
    block = 0
    library_file = '../data/MSR_XS.xml'
    library_name = 'MSR_XS'

    # multiphysics variables
    grid_names = 'Burnup'
    grid_variables = 'Burnup'
    scalar_fluxes = 'flux'

    # decay & transmutation data
    dataset = 'ISOXML'
    isoxml_data_file = '../data/MSR_DT.xml'
    isoxml_lib_name = 'MSR_DT'

    # Bateman solve settings
    bateman_solver = 'CRAMIPF'
    bateman_solver_tolerance = 1e-100
    cram_ipf_order = 48
    cram_matrix_inversion_scheme = sparse_gaussian_elimination

    track_secondary_particle_production = true
    print_number_densities = 'ALL'

    number_of_external_regions = 1
    multi_region_isotope_list = 'I127 I129'
    multi_region_isotope_densities = '0 0'
    multi_region_volumes = 1.0
    multi_region_names = 'Out_Of_Core'
    multi_region_transfer_paths = '0 1'
    multi_region_transfer_isotopes = 'I127 I129'
    multi_region_transfer_isotope_rates = '3.85E-5 3.85E-5'
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
