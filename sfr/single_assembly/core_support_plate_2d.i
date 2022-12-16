#
#---------------------------------------------------------------------------
#
#   2D core support plate thermal expansion input
#   Tensor Mechanics input model
#   given an inlet temperature (nominal = 350 degrees C = 623.15 K), computes the displacements along x and y
#   transfer them to griffin for cross section adjustment (radial expansion feedback)
#---------------------------------------------------------------------------
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

Tinlet = 1083.8 # inlet temperature matching 1% dl/l expansion

Tref   = 293.15 # reference temperature for the linear thermal expansion for SS316

Tsf    = 623.15 # stress-free temperature for the ComputeMeanThermalExpansionFunctionEigenstrain


[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = cyl_plate_2d.e
  []
  [add_nodeset] #  pick node at (0,0,0) and rename it "center"
    type = BoundingBoxNodeSetGenerator
    input = fmg
    new_boundary = center
    top_right = '1e-3 1e-3 0'
    bottom_left = '-1e-3 -1e-3 0'
  []
  parallel_type = REPLICATED
[]

[GlobalParams]
  displacements = 'disp_x disp_y'
  temperature = temp
[]

[AuxVariables]
  [temp] # core support plate temperature is set to inlet temperature
    initial_condition = ${Tinlet}
  []
[]

[Modules/TensorMechanics/Master]
  [plate]
    add_variables = true
    strain = SMALL
    eigenstrain_names = strain_clad
    generate_output = 'stress_xx strain_xx stress_yy strain_yy'
  []
[]

[BCs]
  [x_0]   # center of support plate bottom surface
    type = DirichletBC
    variable = disp_x
    boundary = center # node at (0,0)
    value = 0
  []
  [y_0]   # center of support plate bottom surface
    type = DirichletBC
    variable = disp_y
    boundary = center # node at (0,0)
    value = 0
  []
[]


[Functions]
  [ss316_alphaMean]
    type = ParsedFunction
    value = 'a+b*t+c*t*t'
    vars  =  'a       b          c'
    vals  =  '1.789e-5 2.398e-9 3.269e-13'
  []

[]

[Materials]
  [elasticity_tensor_clad]    # reference needed for SS-316 properties
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.5E+11
    poissons_ratio = 0 # set to 0 for 2D
  []
  [stress_clad]
    type = ComputeLinearElasticStress
  []

  #strain = 5.9037e-3 m/m @ 350 degrees C
  [thermal_expansion_strain_clad]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    stress_free_temperature = ${Tsf}
    thermal_expansion_function_reference_temperature = ${Tref}
    thermal_expansion_function = ss316_alphaMean
    eigenstrain_name = strain_clad
  []

[]

[Preconditioning]
   active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-ksp_gmres_restart -pc_type'
    petsc_options_value = '100 lu'
  []
[]

[Executioner]

  type = Steady
  # use default convergence criterion
[]

[Postprocessors]
  [disp_x_max]
    type = NodalExtremeValue
    variable = disp_x
    value_type = max
  []
  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
  []
  [disp_y_max]
    type = NodalExtremeValue
    variable = disp_y
    value_type = max
  []
  [strain_yy]
    type = ElementAverageValue
    variable = strain_yy
  []
[]

[Outputs]
  # exodus = true
  # csv = true
  # perf_graph = true
[]
