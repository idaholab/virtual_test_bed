# Hexagon math
r = ${fparse 16.1765 / 100} # Apothem (set by generator)
d = ${fparse 4 / sqrt(3) * r} # Long diagonal
x_center = ${fparse 9 / 4 * d}
y_center = ${fparse r}

[Mesh]
  [main]
    type = FileMeshGenerator
    file = empire_2d_CD_fine_in.e
  []
  [coarse_mesh]
    type = FileMeshGenerator
    file = empire_2d_CD_coarse_in.e
  []
  [assign_coarse]
    type = CoarseMeshExtraElementIDGenerator
    input = main
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
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
    # set here to 1 to minimize needed resources, also tested in hpc_tests with 3
    NPolar = 1
    # set here to 3 to minimize needed resources, also tested in hpc_tests with 9
    NAzmthl = 3
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
    type = CoupledFeedbackNeutronicsMaterial
    block = '1 2' # fuel pin with 1 cm outer radius, no gap
    material_id = 1001
    plus = true
  []
  [moderator]
    type = CoupledFeedbackNeutronicsMaterial
    block = '3 4 5' # moderator pin with 0.975 cm outer radius
    material_id = 1002
  []
  [monolith]
    type = CoupledFeedbackNeutronicsMaterial
    block = '8'
    material_id = 1003
  []
  [hpipe]
    type = CoupledFeedbackNeutronicsMaterial
    block = '6 7' # gap homogenized with HP
    material_id = 1004
  []
  [be]
    type = CoupledFeedbackNeutronicsMaterial
    block = '10 11 14 15'
    material_id = 1005
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
  [air]
    type = CoupledFeedbackNeutronicsMaterial
    block = '20 21 22'
    material_id = 1007
  []
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
[]

[Postprocessors]
  [dp]
    type = FunctionValuePostprocessor
    function = drum_position
    execute_on = 'initial timestep_end'
  []

  [fuel_temp_avg]
    type = Receiver
  []
  [fuel_temp_max]
    type = Receiver
  []
  [mod_temp_avg]
    type = Receiver
  []
  [mod_temp_max]
    type = Receiver
  []
  [monolith_temp_avg]
    type = Receiver
  []
  [monolith_temp_max]
    type = Receiver
  []
  [refl_temp_avg]
    type = Receiver
  []
  [refl_temp_max]
    type = Receiver
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
  [console]
    type = Console
    outlier_variable_norms = false
  []
[]
