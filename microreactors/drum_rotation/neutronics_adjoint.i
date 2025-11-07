# Hexagon math
r = ${fparse 16.1765 / 100} # Apothem (set by generator)
d = ${fparse 4 / sqrt(3) * r} # Long diagonal
x_center = ${fparse 9 / 4 * d}
y_center = ${fparse r}

[Mesh]
  [main]
    type = FileMeshGenerator
    file = empire_2d_CD_fine_in.e
    exodus_extra_element_integers = 'material_id coarse_element_id'
  []
  second_order = true
[]

[TransportSystems]
  equation_type = eigenvalue
  particle = neutron
  G = 11

  ReflectingBoundary = 'bottom topleft'
  VacuumBoundary = 'right'

  for_adjoint = true
  [sn]
    scheme = DFEM-SN
    n_delay_groups = 6
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 6
    NA = 1
  []
[]

[GlobalParams]
  library_file = empire_core_modified_11G_CD.xml
  library_name = empire_core_modified_11G_CD
  densities = 1.0
  isotopes = 'pseudo'
  dbgmat = false
  grid_names = 'Tfuel Tmod CD'
  grid_variables = 'Tfuel Tmod CD'
  is_meter = true
[]

[AuxVariables]
  [Tfuel] # fuel temperature
  []
  [Tmod] # moderator + monolith + HP + reflector temperature
  []
  [CD] # drum angle (0 = fully in, 180 = fully out)
  []
[]

[Functions]
  [offset]
    type = ConstantFunction
    value = 225
  []
  [drum_position]
    type = ConstantFunction
    value = 90
  []
  [drum_fun]
    type = ParsedFunction
    expression = 'drum_position + offset'
    symbol_names = 'drum_position offset'
    symbol_values = 'drum_position offset'
  []
[]

[AuxKernels]
  [CD_aux]
    type = FunctionAux
    variable = CD
    function = drum_position
    execute_on = 'initial timestep_end'
  []
[]

[Materials]
  [fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '1 2'
    plus = true
  []
  [non_fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '3 4 5 6 7 8 10 11 14 15 20 21 22'
  []
  [drum]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '13'
    front_position_function = drum_fun
    rotation_center = '${x_center} ${y_center} 0'
    rod_segment_length = '270 90'
    segment_material_ids = '1005 1006'
    isotopes = 'pseudo; pseudo'
    densities = '1.0 1.0'
  []
[]

[Decusping]
  level = 1
  switch_h_to_p_refinement = true
[]

[Executioner]
  type = SweepUpdate

  richardson_rel_tol = 1e-6
  richardson_abs_tol = 1e-4
  richardson_max_its = 100
  richardson_value = eigenvalue
  inner_solve_type = GMRes
  max_inner_its = 2

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1
  diffusion_n_free_power_its = 0
  diffusion_newton_rel_tol = 1e-3
[]

[Postprocessors]
  [dp]
    type = FunctionValuePostprocessor
    function = drum_position
    execute_on = 'initial timestep_end'
  []
[]

[UserObjects]
  [neutronics_adjoint]
    type = TransportSolutionVectorFile
    transport_system = sn
    folder = 'binary_90'
    execute_on = final
  []
  [neutronics_thermal_initial]
    type = SolutionVectorFile
    folder = 'binary_90'
    var = 'Tfuel Tmod'
    writing = false
    execute_on = initial
  []
[]

[Outputs]
  perf_graph = true
  [console]
    type = Console
    outlier_variable_norms = false
  []
[]
