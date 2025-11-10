# ==============================================================================
# Role of a local hotspot on the stress distribution of a 2D graphite section
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

### INPUTS ###

INF = 1.0
E = 9.8e9     #Pa
K = 63        #W/mK
max_PD = 1e7  #W/m^3
nu = 0.14
Tinf = 923    #K
htc = 4500    #W/m^2K
CTE = 4.5e-6  #1/K
porosity = 0.2

# Hot spot inputs
x0 = 0.0072 #m
y0 = 0.0072 #m
R = 1e-3    #m

interface_width = '${fparse R/10}'
PD = '${fparse max_PD*porosity}'

threshold = 0.8

[GlobalParams]
  displacements = 'disp_x disp_y'
  scalar_out_of_plane_strain = scalar_strain_yy
[]

[Mesh]
  file = '../1_create_infiltration_profile/2D/msre2D_1X.e'
[]

[ICs]
  [eta_ic]
    type = SpecifiedSmoothCircleIC
    variable = eta
    x_positions = ${x0}
    y_positions = ${y0}
    z_positions = 0
    radii = ${R}
    invalue = 1
    outvalue = 0
    int_width = ${interface_width}
  []
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
  [hotspot_var]
    order = CONSTANT
    family = MONOMIAL
  []
  [eta]
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
    execute_on = TIMESTEP_BEGIN
  []
  [hotspot]
    type = FunctionAux
    variable = hotspot_var
    function = heatsource_hotspot_fn
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
  [heatsource_hotspot_fn]
    type = ParsedFunction
    expression = 'r := (sqrt((x-${x0})^2 + (y-${y0})^2) );
                  if(r<=${R},${max_PD}-${PD},0)'
  []
[]

[UserObjects]
  [heatsource_soln]
    type = SolutionUserObject
    # mesh = 'Ref_solution_file.e'
    # use a gold file for convenience
    mesh = '../2_create_reference_solution_file/gold/CombinedExodus_AllResults_out.e'
    time_transformation = ${INF}
    system_variables = 'diffuse'
  []
[]

[Materials]
  [h_void]
    type = SwitchingFunctionMaterial
    eta = eta
    h_order = HIGH
    function_name = h_void
    output_properties = 'h_void'
    outputs = exodus
  []

  [h_mat]
    type = DerivativeParsedMaterial
    expression = '1-h_void'
    coupled_variables = 'eta'
    property_name = h_mat
    material_property_names = 'h_void'
    outputs = exodus
  []
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

  [elastic_tensor_matrix]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = ${E}
    poissons_ratio = ${nu}
    base_name = Cijkl_matrix
  []

  [elastic_tensor_void]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e-3 #Pa
    poissons_ratio = 1e-3
    base_name = Cijkl_void
  []

  [elasticity_tensor]
    type = CompositeElasticityTensor
    tensors = 'Cijkl_matrix Cijkl_void'
    weights = 'h_mat            h_void'
    coupled_variables = 'eta'
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
