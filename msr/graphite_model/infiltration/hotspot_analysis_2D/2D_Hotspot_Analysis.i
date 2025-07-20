
# center of the hotspot
x0 = 0.009
y0 = 0.009
R = 1e-4 #Hotspot radius

max_PD = 1e7 # Maximum power density
porosity = 0.2
avg_PD = '${fparse max_PD*porosity}' #distributed power density


[GlobalParams]
  displacements = 'disp_x disp_y'
[]

[Mesh]
  file = msre2D_Fine.e
[]

[Variables]
  [T]
    initial_condition = 300.0
  []
[]

[AuxVariables]
  [smooth_read]
      order = FIRST
      family = LAGRANGE        
  []
  [hotspot_var]
    order = CONSTANT
    family = MONOMIAL       
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = T
  []
  [heat_source]
    type = HeatSource
    variable = T
    function = mod_heatsource_soln_func
  []
  [heat_source_hotspot]
    type = HeatSource
    variable = T
    function = heatsource_hotspot_fn
  []
[]

[AuxKernels]
  [smooth_read_fn]
    type = FunctionAux
    variable = smooth_read
    function = mod_heatsource_soln_func
  []
  [hotspot]
    type = FunctionAux
    variable = hotspot_var
    function = heatsource_hotspot_fn
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = FINITE
    automatic_eigenstrain_names = true
    generate_output = 'stress_xx stress_yy max_principal_stress vonmises_stress'
  []
[]

[Functions]
  [heatsource_soln_func]
    type = SolutionFunction
    solution = heatsource_soln
    from_variable = smooth
    scale_factor = ${avg_PD}
  []
  [mod_heatsource_soln_func]
    type = ParsedFunction
    symbol_names = smooth_mod
    symbol_values = heatsource_soln_func
    expression = 'max(smooth_mod,0)'
  []
  [heatsource_hotspot_fn]
    type = ParsedFunction
    expression = 'r := (sqrt((x-${x0})^2 + (y-${y0})^2) );
                  if(r<=${R},${max_PD}-${avg_PD},0)'     
  []
[]

[UserObjects]
  [heatsource_soln]
    type = SolutionUserObject
    mesh = 'Ref_solution_file.e'
    system_variables = 'smooth'
    timestep = LATEST
  []
[]

[Materials]
  [thermal]
    type = HeatConductionMaterial
    thermal_conductivity = 63
    specific_heat = 1400
  []
  [density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = 1760.0
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 9.8e9
    poissons_ratio = 0.14
  []
  [expansion1]
    type = ComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = 4.5e-6
    stress_free_temperature = 300
    eigenstrain_name = thermal_expansion
  []
  [stress]
    type = ComputeFiniteStrainElasticStress
  []
[]

[BCs]
  [xsymm_left]
    type = DirichletBC
    variable = disp_x
    value = 0
    boundary = 'left'
  []
  [ysymm_bottom]
    type = DirichletBC
    variable = disp_y
    value = 0
    boundary = 'bottom'
  []

  [contacting_salt]
    type = ConvectiveHeatFluxBC
    variable = T
    boundary = 'right_channelboundary'
    T_infinity = 923
    heat_transfer_coefficient = 4500
  []  

[]

[VectorPostprocessors]
  [point1]
    type = LineValueSampler
    use_displaced_mesh = false
    start_point = '0 0.009 0.0'
    end_point = '0.0196 0.009 0.0'
    sort_by = z
    num_points = 750
    outputs = csv
    variable = 'T'
    execute_on = TIMESTEP_END
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  line_search = 'none'
  nl_abs_tol = 1.0e-10
  nl_rel_tol = 1.0e-08

[]

[Outputs]
  exodus = true
  csv = true
[]
