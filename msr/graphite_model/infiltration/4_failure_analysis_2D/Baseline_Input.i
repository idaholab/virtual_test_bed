# ==============================================================================
# Baseline input file used by pss.i
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

### INPUTS ###

INF = 1.0
E = 9.3e9    #Pa
K = 37       #W/mK
PD = 42e6    #W/m^3
nu = 0.16
Tinf = 972   #K
htc = 5267   #W/m^2K
CTE = 4.5e-6 #1/K

threshold = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
  scalar_out_of_plane_strain = scalar_strain_yy
[]

[Mesh]
  file = msre2D_1X.e
[]

[Variables]
  [T]
    initial_condition = 300.0 #K
  []
  [scalar_strain_yy]
    order = FIRST
    family = SCALAR
  []
[]

[AuxVariables]
  [smooth_read]
    order = FIRST
    family = LAGRANGE
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
[]

[AuxKernels]
  [smooth_read_fn]
    type = FunctionAux
    variable = smooth_read
    function = mod_heatsource_soln_func
    execute_on = TIMESTEP_BEGIN
  []
[]

[Physics]

  [SolidMechanics]

    [QuasiStatic]
      [all]
        planar_formulation = GENERALIZED_PLANE_STRAIN
        scalar_out_of_plane_strain = scalar_strain_yy
        add_variables = true
        strain = small
        automatic_eigenstrain_names = true
        generate_output = 'stress_xx stress_yy max_principal_stress vonmises_stress'
      []
    []
  []
[]

[Functions]
  [heatsource_soln_func]
    type = SolutionFunction
    solution = heatsource_soln
    from_variable = diffuse
  []
  [mod_heatsource_soln_func]
    type = ParsedFunction
    symbol_names = smooth_mod
    symbol_values = heatsource_soln_func
    expression = 'if(smooth_mod>=${threshold},${PD},0)'
  []
[]

[UserObjects]
  [heatsource_soln]
    type = SolutionUserObject
    mesh = 'CombinedExodus_AllResults_out.e'
    time_transformation = ${INF}
    system_variables = 'diffuse'
  []
[]

[Materials]
  [thermal]
    type = HeatConductionMaterial
    thermal_conductivity = ${K}
    specific_heat = 1400 #J/KgK
  []
  [density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = 1760.0 #Kg/m^3
  []
  [elasticity]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = ${E}
    poissons_ratio = ${nu}
  []
  [expansion1]
    type = ComputeThermalExpansionEigenstrain
    temperature = T
    thermal_expansion_coeff = ${CTE}
    stress_free_temperature = 300 #K
    eigenstrain_name = thermal_expansion
  []
  [stress]
    type = ComputeLinearElasticStress
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
    T_infinity = ${Tinf}
    heat_transfer_coefficient = ${htc}
  []
[]

[Postprocessors]
  [maxstress]
    type = ElementExtremeValue
    variable = max_principal_stress
    value_type = max
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
[]
