endtime = 1892160000
dt_max = 5e6

# Parameters for temperature distribution
Tmax_A1 = -36.406902443685375
Tmax_B1 = 899.4907346560636
Tmax_z01 = 0.5788213284387279
Tmin_A2 = -30.744024831884484
Tmin_B2 = 899.8512009151575
Tmin_z02 = 0.591661495195294
x0c = 1.2
thickness = 0.6

# Parameters for neutron flux distribution
B_flux = -11.7708550271939
x0v = 1.26
Fmax_a = 1.264e+15
Fmax_b = -1.260e+16
Fmax_c = 3.202e+16
Fmax_d = -1.887e+15



[GlobalParams]
    displacements = 'disp_x disp_y disp_z'
[]



[Mesh]
   type = FileMesh
   file = baseline.e
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = FINITE
    automatic_eigenstrain_names = true
    generate_output = 'stress_xx stress_xy stress_xz stress_yy stress_yx stress_yz stress_zz stress_zx stress_zy 
                      vonmises_stress max_principal_stress mid_principal_stress min_principal_stress 
                      strain_xx strain_yy strain_zz elastic_strain_xx elastic_strain_yy elastic_strain_zz'
  []
[]

# Functions for temperature and fluence (flux * t)
[Functions]
  # Parsed function for temperature
  [T_func]
    type = ParsedFunction
    value = 'r := (x^2 + y^2)^0.5;
             Tmax := ${Tmax_A1}*cos(z-${Tmax_z01}) + ${Tmax_B1};
             Tmin := ${Tmin_A2}*cos(z-${Tmin_z02}) + ${Tmin_B2};
             Tmax - (Tmax-Tmin)*(r-${x0c})/${thickness}'
  []

  # Fluence function (flux * time) 
  [fluence_func]
    type = ParsedFunction
    value = 'r := (x^2 + y^2)^0.5;
             Fmax := ${Fmax_a}*z^3 + ${Fmax_b}*z^2 + ${Fmax_c}*z + ${Fmax_d};
             Fmax*exp(${B_flux}*(r-${x0v}))*t'
  []
[]

# AuxVariables for temperature and fluence
[AuxVariables]
  [temperature]
  []
  [volume]
    order = CONSTANT
    family = MONOMIAL
  []
[]



# AuxKernels to assign the temperature and fluence functions
[AuxKernels]
  [T_aux]
    type = FunctionAux
    variable = temperature
    function = T_func
    execute_on = initial
  []
  [volume_aux]
    type = VolumeAux
    variable = volume
  []
[]

# Materials
[Materials]
  [neutron_fluence]
    type = GenericFunctionMaterial
    prop_names = fast_neutron_fluence
    prop_values = fluence_func
    outputs = exodus
  []         

  [thermal]
    type = HeatConductionMaterial
    thermal_conductivity = 63
    specific_heat = 1502
  []
  [density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = 1774.0
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 10.3e9
    poissons_ratio = 0.14
  []
  [thermal_expansion]
    type = StructuralGraphiteThermalExpansionEigenstrain
    eigenstrain_name = thermal_expansion
    graphite_grade = IG_110
    stress_free_temperature = 300.0
    fluence_conversion_factor = 1.0
    temperature = temperature
    outputs = exodus
  []
  [GraphiteGrade_creep]
    type = StructuralGraphiteCreepUpdate
    fluence_conversion_factor = 1.0
    graphite_grade = IG_110
    temperature = temperature
    creep_scale_factor = 1.0
    outputs = exodus
  []
  [graphite_irrad_strain]
    type = StructuralGraphiteIrradiationEigenstrain
    temperature = temperature
    graphite_grade = IG_110
    fluence_conversion_factor = 1.0
    eigenstrain_name = irrad_strain
    outputs = exodus
  []  

  [stress]
    type = ComputeMultipleInelasticStress
    inelastic_models = 'GraphiteGrade_creep'
  []
[]

# BCs
[BCs]
  [x_fixed]
    type = DirichletBC
    preset = true
    variable = disp_x
    value = 0
    boundary = 'fixed'
  []
  [y_fixed]
    type = DirichletBC
    preset = true
    variable = disp_y
    value = 0
    boundary = 'fixed y_z_roller y_roller'
  []  
  [z_fixed]
    type = DirichletBC
    preset = true
    variable = disp_z
    value = 0
    boundary = 'fixed y_z_roller'
  []  

[]

[VectorPostprocessors]
    [auxvars]
      type = ElementValueSampler
      sort_by = id
      variable = 'volume max_principal_stress mid_principal_stress min_principal_stress'
      execute_on = TIMESTEP_END
    []
 
[]

# Executioner
[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre    boomeramg      0.6'
  line_search = 'none'
  end_time = ${endtime}
  dtmax = ${dt_max}
  nl_abs_tol = 1.0e-08
  nl_rel_tol = 1.0e-04
  nl_max_its = 15
  l_max_its = 50
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 100
    growth_factor = 3.0
    cutback_factor = 0.5
  []
  [Predictor]
    type = SimplePredictor
    scale = 1.0
  []
[]

# Outputs
[Outputs]
  sync_times = '0 315360000 630720000 946080000 1261440000 1576800000 1892160000'

  [exodus]
    type = Exodus
    sync_only = true
  []

  [csv]
    type = CSV
    sync_only = true
  []
  wall_time_checkpoint = false
[]
