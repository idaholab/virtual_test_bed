[Mesh]
  [file]
    type = FileMeshGenerator
    file = sphere.e
  []
  [cmbn]
    type = CombinerGenerator
    inputs = file
    positions_file = 'positions.txt'
  []
  [scale]
    type = TransformGenerator
    input = cmbn
    transform = SCALE
    vector_value = '0.99 0.99 0.99'
  []
[]

[Kernels]
  [hc]
    type = HeatConduction
    variable = temp
  []
  [heat]
    type = BodyForce
    value = 0.01
    variable = temp
  []
[]

[BCs]
  [match_nek]
    type = MatchedValueBC
    variable = temp
    boundary = '1'
    v = 'nek_temp'
  []
[]

[Materials]
  [hc]
    type = GenericConstantMaterial
    prop_values = '0.005' # Should be 45 times higher than the fluid conductivity (Steel/P-cymene ratio)
    prop_names = 'thermal_conductivity'
  []
[]

[Executioner]
  type = Transient
#  petsc_options_iname = '-pc_type -pc_hypre_type'
  num_steps = 16000
#  petsc_options_value = 'hypre boomeramg'
  dt = 2e-4
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-10
[]

[Variables]
  [temp]
    initial_condition = 4.3
  []
[]

[Outputs]
  exodus = true
  interval = 500
  [csv]
    type = CSV
    interval = 1
  []
[]

[MultiApps]
  [nek]
    type = TransientMultiApp
    app_type = CardinalApp
    input_files = 'nek.i'
  []
[]

[Transfers]
  [nek_temp]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = temp
    from_multi_app = nek
    variable = nek_temp
  []
  [avg_flux]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = avg_flux
    to_multi_app = nek
    variable = avg_flux
  []
  [flux_integral_to_nek]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = flux_integral
    from_postprocessor = flux_integral
    to_multi_app = nek
  []
[]

[AuxVariables]
  [nek_temp]
  []
  [avg_flux]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [avg_flux]
    type = DiffusionFluxAux
    diffusion_variable = temp
    component = normal
    diffusivity = thermal_conductivity
    variable = avg_flux
    boundary = '1'
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideDiffusiveFluxIntegral
    diffusivity = thermal_conductivity
    variable = 'temp'
    boundary = '1'
  []
  [average_flux]
    type = SideDiffusiveFluxAverage
    diffusivity = thermal_conductivity
    variable = 'temp'
    boundary = '1'
  []
  [max_pebble_T]
    type = NodalExtremeValue
    variable = temp
    value_type = max
  []
  [min_pebble_T]
    type = NodalExtremeValue
    variable = temp
    value_type = min
  []
  [average_pebble_T]
    type = SideAverageValue
    variable = 'temp'
    boundary = '1'
  []
[]
