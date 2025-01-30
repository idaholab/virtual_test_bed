################################################################################
## FHR bypass flow in outer reflector                                         ##
## Cardinal Main Application                                                  ##
## Heat conduction in solid phase                                             ##
## POC : anovak at anl.gov                                                    ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

# core average heat flux from the pebbles to the blocks
core_heat_flux = 5e3

[GlobalParams]
  # Reduces transfers efficiency for now, can be removed once transferred fields are checked
  bbox_factor = 10
[]

# Note: the mesh is stored using git large file system (LFS)
[Mesh]
  type = FileMesh
  file = ../meshes/solid.e
[]

[Variables]
  [T]
  []
[]

[AuxVariables]
  [flux]
    family = MONOMIAL
    order = CONSTANT
  []
  [nek_temp]
  []
[]

[Functions]
  [nek_temp_ic]
    type = ParsedFunction
    expression = 923.0-50.0*(r-3.348)
    symbol_names = 'r'
    symbol_values = 'r'
  []
  [r]
    type = ParsedFunction
    expression = sqrt(x*x+y*y)
  []
[]

[ICs]
  [nek_temp]
    type = FunctionIC
    variable = nek_temp
    function = nek_temp_ic
  []
[]

[Kernels]
  [conduction]
    type = HeatConduction
    variable = T
  []
[]

[AuxKernels]
  [flux]
    type = DiffusionFluxAux
    variable = flux
    diffusion_variable = T
    component = normal
    check_boundary_restricted = false
    diffusivity = thermal_conductivity
    boundary = 'fluid_solid_interface'
  []
[]

[BCs]
  [cht_interface]
    type = MatchedValueBC
    variable = T
    v = nek_temp
    boundary = 'fluid_solid_interface'
  []
  [insulated]
    type = NeumannBC
    variable = T
    boundary = 'symmetry top bottom'
    value = 0.0
  []
  [inner_surface]
    type = NeumannBC
    variable = T
    value = ${core_heat_flux}
    boundary = 'inner_surface'
  []
  [outer_surface]
    type = ConvectiveHeatFluxBC
    variable = T
    T_infinity = 'Tinf'
    heat_transfer_coefficient = 'htc'
    boundary = 'barrel_surface'
  []
[]

[Materials]
  [k_graphite]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '43.73' # evaluated at 650 C
    block = '2 3'
  []
  [k_steel]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity'
    prop_values = '23.82' # evaluated at 650 C
    block = '1'
  []
  [htc_and_Tinf]
    type = GenericConstantMaterial
    prop_names = 'htc Tinf'
    prop_values = '10.0 300.0'
  []
[]

[MultiApps]
  [nek]
    type = TransientMultiApp
    app_type = CardinalApp
    input_files = 'nek.i'
    sub_cycling = true
    execute_on = timestep_end
  []
[]

[Transfers]
  [temperature_from_nek]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    from_multi_app = nek
    variable = nek_temp
  []
  [flux_to_nek]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = flux
    to_multi_app = nek
    variable = avg_flux
    source_boundary = 'fluid_solid_interface'
  []
  [flux_integral_to_nek]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = flux_integral
    from_postprocessor = flux_integral
    to_multi_app = nek
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideIntegralVariablePostprocessor
    variable = flux
    boundary = 'fluid_solid_interface'
  []
[]

[Executioner]
  type = Transient
  dt = 0.005
  nl_abs_tol = 1e-6
  num_steps = 2000

  steady_state_detection = true
  steady_state_tolerance = 5e-4
[]

[Outputs]
  exodus = true
  print_linear_residuals = false
[]
