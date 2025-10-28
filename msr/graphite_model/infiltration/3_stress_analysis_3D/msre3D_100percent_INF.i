# ==============================================================================
# Input file to predict stresses due to a specified infiltration amount
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

### INPUTS ###

E = 9.8e9
K = 63
nu = 0.14
htc = 4500
CTE = 4.5e-6

volume_fraction = 0.33
threshold = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]

  file = 'msre3D_0PF_Fine.e'
[]

[Variables]
  [T]
    initial_condition = 300.0
  []
[]

[AuxVariables]
  [T_inf]
  []
  [smooth_read]
    order = FIRST
    family = LAGRANGE
  []
[]

[Functions]
  [volumetric_heat] #Axial distribution of the power density
    type = PiecewiseLinear
    data_file = interpolated_T_PD_values.csv
    x_index_in_file = 0
    y_index_in_file = 2
    format = columns
    xy_in_file_only = false
    axis = z
  []
  [T_infinity_fn] #Temperature distribution at the graphite-coolant interface
    type = PiecewiseLinear
    data_file = interpolated_T_PD_values.csv
    x_index_in_file = 0
    y_index_in_file = 5
    format = columns
    xy_in_file_only = false
    axis = z
  []
  [heatsource_soln_func] #Infiltration profile corresponding to user-defined amount
    type = SolutionFunction
    solution = heatsource_soln
    from_variable = diffuse
  []
  [bin_heatsource_soln_func] #Binarize heatsource_soln_func
    type = ParsedFunction
    symbol_names = smooth_mod
    symbol_values = heatsource_soln_func
    expression = 'if(smooth_mod>=${threshold},1,0)'
  []
  [mod_heatsource_soln_func] #Obtain 3D distribution of the power density
    type = ParsedFunction
    symbol_names = 'bin_heatsource_soln_func volumetric_heat'
    symbol_values = 'bin_heatsource_soln_func volumetric_heat'
    expression = bin_heatsource_soln_func*volumetric_heat
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
  [T_inf]
    type = FunctionAux
    variable = T_inf
    function = T_infinity_fn
    execute_on = initial
  []
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
        add_variables = true
        strain = small
        automatic_eigenstrain_names = true
        generate_output = 'stress_xx stress_yy max_principal_stress vonmises_stress'
        material_output_order = FIRST
        material_output_family = LAGRANGE
      []
    []
  []
[]

[UserObjects]
  [heatsource_soln]
    type = SolutionUserObject
    mesh = 'CombinedExodus_AllResults_out.e'
    time_transformation = ${volume_fraction}
    system_variables = 'diffuse'
  []
[]

[Materials]
  [thermal]
    type = HeatConductionMaterial
    thermal_conductivity = ${K}
    specific_heat = 1400
  []
  [density]
    type = GenericConstantMaterial
    prop_names = 'density'
    prop_values = 1760.0
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
    stress_free_temperature = 300
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
    boundary = 'XMINUS'
  []
  [ysymm_bottom]
    type = DirichletBC
    variable = disp_y
    value = 0
    boundary = 'YMINUS'
  []

  [zsymm_bottom]
    type = DirichletBC
    preset = true
    variable = disp_z
    value = 0
    boundary = 'ZMINUS'
  []

  [convective_heat_transfer]
    type = CoupledConvectiveHeatFluxBC
    variable = T
    boundary = 'coolantchannelboundary'
    T_infinity = T_inf
    htc = ${htc}
  []
[]

[Postprocessors]
  [maxstress]
    type = ElementExtremeValue
    variable = max_principal_stress
    value_type = max
  []
[]
[VectorPostprocessors]
  [line]
    type = LineValueSampler
    start_point = '0 0 1.6637'
    end_point = '0.0148 0.0139 0'
    num_points = 100
    sort_by = 'z'
    variable = 'disp_x disp_y disp_z T'
    execute_on = timestep_end
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
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre    boomeramg      0.6'
  line_search = 'none'
  nl_abs_tol = 1.0e-10
  nl_rel_tol = 1.0e-08
[]

[Outputs]
  wall_time_checkpoint = false
  csv = true
[]
