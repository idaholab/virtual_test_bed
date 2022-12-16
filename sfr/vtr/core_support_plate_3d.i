################################################################################
##  3D core support plate thermal expansion input                             ##
##  Tensor Mechanics input model                                              ##
################################################################################
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

#  given an inlet temperature (nominal = 350 degrees C = 623.15 K),
#  computes the displacements along x and y
#  transfer them to griffin for cross section adjustment (radial expansion feedback)

Tinlet = 623.15 # inlet temperature (nominal temperature for the )

Tref   = 293.15 # reference temperature for the linear thermal expansion for SS316
#Tref = ${Tinlet}
#Tsf    = 623.15 # stress-free temperature for the ComputeMeanThermalExpansionFunctionEigenstrain

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  temperature = temp
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = mesh/cyl_plate_3d.e # Y - vertical axis
  []
  [add_nodeset] #  pick node at (0,0,0) and rename it "center"
    type = BoundingBoxNodeSetGenerator
    input = fmg
    new_boundary = center
    top_right = '1e-3 0 1e-3'
    bottom_left = '-1e-3  0 -1e-3'
  []
  parallel_type = REPLICATED
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
[]

[Kernels]
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [temp]    #core support plate temperature is set to inlet temperature
    initial_condition = ${Tinlet}
  []
[]

[AuxKernels]
[]

# ==============================================================================
# MODULES
# ==============================================================================
[Modules/TensorMechanics/Master]
  [plate]
    add_variables = true
    strain = SMALL
    eigenstrain_names = thermal_expansion
    generate_output = 'stress_xx strain_xx stress_yy strain_yy stress_zz strain_zz'
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
  # from TEV 3749
  [ss316_alphaMean_vtr]
    type = ParsedFunction
    value = 'a+b*t+c*t*t'
    vars  =  'a       b          c'
    vals  =  '1.789e-5 2.398e-9 3.269e-13'
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [elasticity_tensor_ss316]
    type = SS316ElasticityTensor
  []
  [stress]
    type = ComputeLinearElasticStress
  []
  [thermal_expansion_ss316]
    type = SS316ThermalExpansionEigenstrain
    stress_free_temperature = ${Tref}
    eigenstrain_name = thermal_expansion
  []
[]

[UserObjects]
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [x_0]   # center of support plate bottom surface
    type = DirichletBC
    variable = disp_x
    boundary = center # node at (0,0,0)
    value = 0
  []
  [z_0]   # center of support plate bottom surface
    type = DirichletBC
    variable = disp_z
    boundary = center # node at (0,0,0)
    value = 0
  []
  [bottom_disp_y]   # at bottom of support plate
    type = DirichletBC
    variable = disp_y
    boundary = plateBottom
    value = 0
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
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
  automatic_scaling = true
  nl_forced_its = 3
  #use default convergence criterion
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
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
  [disp_z_max]
    type = NodalExtremeValue
    variable = disp_z
    value_type = max
  []
  [strain_zz]
    type = ElementAverageValue
    variable = strain_zz
  []
[]

[Debug]
[]

[Outputs]
  print_nonlinear_converged_reason = false
  print_linear_converged_reason = false
  # exodus = true
  # csv = true
  # perf_graph = true
[]
