# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Mesh, variables, kernels, materials, executioner and outputs of the welding stage.
# Units: mm, s, K; mechanics in N and MPa (N/mm^2); heat transfer in J, W and kg (density in kg/mm^3).

# Kernel and material coverage checks are restricted to the active blocks by GlobalParams/block.
[Problem]
  extra_tag_vectors = 'reaction'
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  # Default computational domain: base metal plus deposited weld metal. Also sets the kernel and
  # material coverage checks to ONLY_LIST on these blocks.
  block = ${base_blocks}
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = ${mesh_file}
  []
  uniform_refine = 0

  use_displaced_mesh = false

[]

[Variables]
  [disp_x]
    block = ${base_blocks}
  []
  [disp_y]
    block = ${base_blocks}
  []
  [disp_z]
    block = ${base_blocks}
  []
  [T]
    initial_condition = ${T0}
    block = ${base_blocks}
  []
[]

[AuxVariables]
  [rx]
    block = ${base_blocks}
  []
  [ry]
    block = ${base_blocks}
  []
  [rz]
    block = ${base_blocks}
  []
  [time]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tc]
    order = FIRST
    family = LAGRANGE
    block = ${base_blocks}
  []
  [Tk]
    order = FIRST
    family = LAGRANGE
    block = ${base_blocks}
  []
  # phi, weld and tbegin also exist on the weld-pass blocks that are not yet deposited: block = ''
  # overrides GlobalParams/block (variables do not accept ANY_BLOCK_ID, and a list of the weld-pass
  # blocks fails in the Exodus output once a completed pass block is empty)
  [phi]
    order = CONSTANT
    family = MONOMIAL
    block = ''
  []
  [weld]
    order = CONSTANT
    family = MONOMIAL
    block = ''
  []
  [a]
    order = CONSTANT
    family = MONOMIAL
  []
  [tbegin]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1e12
    block = ''
  []
  [effective_plastic_strain]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [Tc]
    type = ParsedAux
    variable = Tc
    expression = 'if(T<${T0},${T0}-273.15,T-273.15)'
    coupled_variables = T
    block = ${base_blocks}
  []
  [Tk]
    type = ParsedAux
    variable = Tk
    expression = 'if(T<${T0},${T0},if(T>${Tm},${Tm},T))'
    coupled_variables = T
    block = ${base_blocks}
  []
  [time]
    type = FunctionAux
    function = time
    variable = time
  []
  # equivalent plastic strain of isoplasticity (generate_output = effective_plastic_strain would add a
  # second material declaring a property of the same name)
  [effective_plastic_strain]
    type = ADMaterialRealAux
    variable = effective_plastic_strain
    property = effective_plastic_strain
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
        block = ${base_blocks}
        add_variables = false
        use_automatic_differentiation = true
        eigenstrain_names = 'thermal'
        temperature = T
        volumetric_locking_correction = true
        strain = ${strain}
        incremental = true
        # displacement residual of the stress divergence kernels, i.e. the nodal reaction forces at
        # the Dirichlet nodes; extracted into rx, ry, rz by TagVectorAux in weld_objects.i
        extra_vector_tags = 'reaction'
        generate_output = "stress_xx stress_yy stress_zz
                           stress_xy stress_xz stress_yz
                           vonmises_stress
                           mechanical_strain_xx mechanical_strain_yy mechanical_strain_zz
                           mechanical_strain_xy mechanical_strain_xz mechanical_strain_yz
                           max_principal_stress mid_principal_stress min_principal_stress
                           plastic_strain_xx plastic_strain_yy plastic_strain_zz
                           plastic_strain_xy plastic_strain_xz plastic_strain_yz"
  []
[]

[Kernels]
  [htime]
    type = ADHeatConductionTimeDerivative
    variable = T
    density_name = density
    specific_heat = specific_heat
    block = ${base_blocks}
  []
  [hcond]
    type = ADHeatConduction
    variable = T
    thermal_conductivity = thermal_conductivity
    block = ${base_blocks}
  []
[]

[Functions]
  [CTE_base]
    type = PiecewiseLinear
    x = '-1000 298.15 323.15 373.15 423.15 473.15 523.15 573.15 623.15 673.15 723.15 773.15 823.15 873.15 923.15 973.15 1023.15 1523.15 1673.15 10000'
    # x: temperature [K], y: instantaneous coefficient of thermal expansion [1/K]
    y = '14.3033525e-6 14.3033525e-6 14.6621025e-6 15.3796025e-6 16.0971025e-6 16.8146025e-6 17.5321025e-6 18.2496025e-6 18.9671025e-6 19.6846025e-6 20.4021025e-6 21.1196025e-6 21.8371025e-6 22.5546025e-6 23.2721025e-6 23.9896025e-6 24.7071025e-6 31.8821025e-6 0 0'
  []
  [time]
    type = ParsedFunction
    expression = t
  []
  [isohard]
    # R5 room-temperature data of the weld (Barua and Messner 2024, Sec. 6.4), used at all temperatures
    # x: equivalent plastic strain [-], y: flow stress [MPa]
    type = PiecewiseLinear
    x = '0 0.002 0.01 10000'
    y = '235 240 480 480'
  []
[]

[Materials]
  [CTE]
    type = ADComputeInstantaneousThermalExpansionFunctionEigenstrain
    eigenstrain_name = thermal
    stress_free_temperature = ${T0}
    thermal_expansion_function = CTE_base
    temperature = T
    block = ${base_blocks}
    outputs = exodus
  []
  [elasticity_tensor]
    type = ADComputeVariableIsotropicElasticityTensor
    youngs_modulus = youngs_modulus
    poissons_ratio = 0.31 # [-]
    block = ${base_blocks}
  []
  [radial_return_stress_load]
    type = ADComputeMultipleInelasticStress
    inelastic_models = 'isoplasticity'
    max_iterations = 1000
    relative_tolerance = 1e-08
    absolute_tolerance = 1e-11
    perform_finite_strain_rotations = false
    block = ${base_blocks}
  []
  [isoplasticity]
    type = ADIsotropicPlasticityStressUpdate
    yield_stress = 235 # MPa
    hardening_function = isohard
    block = ${base_blocks}
    max_inelastic_increment = 0.0001
    relative_tolerance = 1e-08
    absolute_tolerance = 1e-11
  []
  [youngs_modulus]
    type = ADPiecewiseLinearInterpolationMaterial
    x = '-1000 273.15 288.741836735 304.333673469 319.925510204 335.517346939 351.109183673 366.701020408 382.292857143 397.884693878 413.476530612 429.068367347 444.660204082 460.252040816 475.843877551 491.435714286 507.02755102 522.619387755 538.21122449 553.803061224 569.394897959 584.986734694 600.578571429 616.170408163 631.762244898 647.354081633 662.945918367 678.537755102 694.129591837 709.721428571 725.313265306 740.905102041 756.496938776 772.08877551 787.680612245 803.27244898 818.864285714 834.456122449 850.047959184 865.639795918 881.231632653 896.823469388 912.415306122 928.007142857 943.598979592 959.190816327 974.782653061 990.374489796 1005.96632653 1021.55816327 1037.15 1648.15 3000'
    # x: temperature [K], y: Young's modulus [MPa]
    y = '196500.0 196500.0 195564.489796 194505.306122 193257.959184 192010.612245 190763.265306 189515.918367 188451.428571 187515.918367 186580.408163 185644.897959 184709.387755 183773.877551 182784.489796 181537.142857 180289.795918 179042.44898 178096.326531 177160.816327 176225.306122 175053.061224 173805.714286 172558.367347 171483.265306 170547.755102 169612.244898 168568.979592 167321.632653 166074.285714 164783.673469 163224.489796 161665.306122 160106.122449 158837.55102 157590.204082 156342.857143 154869.387755 153310.204082 151751.020408 150191.836735 148632.653061 147073.469388 145417.142857 143546.122449 141675.102041 139804.081633 137933.061224 136062.040816 134191.020408 132320.0 132320.0 132320.0'
    property = youngs_modulus
    variable = T
    block = ${base_blocks}
  []
  [rad]
    type = ADParsedMaterial
    property_name = rad
    coupled_variables = 'T'
    expression = 'epsilon*sigma*(T^4-Tinf^4)'
    constant_names = 'epsilon sigma Tinf'
    # radiative heat flux [W/mm^2]; emissivity [-], Stefan-Boltzmann constant [W/(mm^2 K^4)], K
    constant_expressions = '0.25 5.67037e-14 ${T0}'
    block = ${base_blocks}
  []
  [density]
    type = ADPiecewiseLinearInterpolationMaterial
    property = 'density'
    variable = T
    x = '-1000 3000'
    y = '8030e-9 8030e-9' # kg/mm^3 (= 8030 kg/m^3)
    block = ${base_blocks}
  []
  [specific_heat]
    type = ADPiecewiseLinearInterpolationMaterial
    property = 'specific_heat'
    variable = T
    x = '-1000 3000'
    y = '550 550' # J/(kg K)
    block = ${base_blocks}
  []
  [thermalconductivity]
    type = ADPiecewiseLinearInterpolationMaterial
    property = 'thermal_conductivity'
    variable = T
    x = '-1000 298.15 373.15 473.15 573.15 673.15 773.15 873.15 973.15 1023.15 2500 3000'
    y = '14.1e-3 14.1e-3 15.4e-3 16.8e-3 18.3e-3 19.7e-3 21.2e-3 22.4e-3 23.9e-3 24.6e-3 24.6e-3 24.6e-3' # W/(mm K)
    block = ${base_blocks}
  []
[]

[Postprocessors]
  [maxTnode] #max value of temp
    type = NodalExtremeValue
    variable = T
    value_type = max
    block = ${base_blocks}
  []
  [Tc_max]
    type = NodalExtremeValue
    variable = Tc
    block = ${base_blocks}
    outputs = 'csv'
  []
  [Tc_min]
    type = NodalExtremeValue
    variable = Tc
    block = ${base_blocks}
    value_type = min
    outputs = 'csv'
  []

  [Svm_max]
    type = ElementExtremeValue
    variable = vonmises_stress
    block = ${base_blocks}
  []

  [Tc_id]
    type = PointValue
    point = ${id_point}
    variable = Tc
    outputs = 'csv'
  []
  [Sxx_id]
    type = PointValue
    point = ${id_point}
    variable = stress_xx
    outputs = 'csv'
  []
  [Syy_id]
    type = PointValue
    point = ${id_point}
    variable = stress_yy
    outputs = 'csv'
  []
  [Szz_id]
    type = PointValue
    point = ${id_point}
    variable = stress_zz
    outputs = 'csv'
  []
  [Sxy_id]
    type = PointValue
    point = ${id_point}
    variable = stress_xy
    outputs = 'csv'
  []
  [Sxz_id]
    type = PointValue
    point = ${id_point}
    variable = stress_xz
    outputs = 'csv'
  []
  [Syz_id]
    type = PointValue
    point = ${id_point}
    variable = stress_yz
    outputs = 'csv'
  []
  [Svm_id]
    type = PointValue
    point = ${id_point}
    variable = vonmises_stress
    outputs = 'csv'
  []
  [Exx_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_xx
    outputs = 'csv'
  []
  [Eyy_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_yy
    outputs = 'csv'
  []
  [Ezz_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_zz
    outputs = 'csv'
  []
  [Exy_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_xy
    outputs = 'csv'
  []
  [Exz_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_xz
    outputs = 'csv'
  []
  [Eyz_id]
    type = PointValue
    point = ${id_point}
    variable = mechanical_strain_yz
    outputs = 'csv'
  []

  [Tc_mid]
    type = PointValue
    point = ${mid_point}
    variable = Tc
    outputs = 'csv'
  []

  [Tc_od]
    type = PointValue
    point = ${od_point}
    variable = Tc
    outputs = 'csv'
  []
  [Sxx_od]
    type = PointValue
    point = ${od_point}
    variable = stress_xx
    outputs = 'csv'
  []
  [Syy_od]
    type = PointValue
    point = ${od_point}
    variable = stress_yy
    outputs = 'csv'
  []
  [Szz_od]
    type = PointValue
    point = ${od_point}
    variable = stress_zz
    outputs = 'csv'
  []
  [Sxy_od]
    type = PointValue
    point = ${od_point}
    variable = stress_xy
    outputs = 'csv'
  []
  [Sxz_od]
    type = PointValue
    point = ${od_point}
    variable = stress_xz
    outputs = 'csv'
  []
  [Syz_od]
    type = PointValue
    point = ${od_point}
    variable = stress_yz
    outputs = 'csv'
  []
  [Svm_od]
    type = PointValue
    point = ${od_point}
    variable = vonmises_stress
    outputs = 'csv'
  []
  [Exx_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_xx
    outputs = 'csv'
  []
  [Eyy_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_yy
    outputs = 'csv'
  []
  [Ezz_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_zz
    outputs = 'csv'
  []
  [Exy_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_xy
    outputs = 'csv'
  []
  [Exz_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_xz
    outputs = 'csv'
  []
  [Eyz_od]
    type = PointValue
    point = ${od_point}
    variable = mechanical_strain_yz
    outputs = 'csv'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  line_search = none

  petsc_options = '-ksp_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_type'
  petsc_options_value = 'lu superlu_dist gmres'
  l_max_its = 100

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-6
  nl_max_its = 100

  automatic_scaling = true
  compute_scaling_once = true

  verbose = true
  reuse_preconditioner = true
  reuse_preconditioner_max_linear_its = 20

  end_time = ${end_time}
  dtmin = ${dtmin}
  dtmax = ${dtmax}
  [TimeStepper]
    type = IterationAdaptiveDT #change time step based on iterations
    dt = ${dt} #initial time step
    growth_factor = 3
    cutback_factor = 0.25
    cutback_factor_at_failure = 0.25
    optimal_iterations = 15 # nonlinear iterations
    linear_iteration_ratio = 100000
    iteration_window = 2
  []
[]

[Times]
  # every output_interval (25 s) from t = 0 to the end of welding
  [output_times]
    type = TimeIntervalTimes
    time_interval = ${output_interval}
    start_time = 0
    end_time = ${total_weld_time}
    outputs = 'none'
  []
[]

# The time stepper hits the sync times of all outputs: output_times (Exodus and Checkpoint) and
# pass_sync_times (CSV). Exodus and CSV still write every time step (sync_only = false).
[Outputs]
  print_linear_residuals = false
  [exodus]
    type = Exodus
    file_base = ${exo_file_base}
    sync_times_object = output_times
  []
  [csv]
    type = CSV
    file_base = ${csv_file_base}
    sync_times = ${pass_sync_times}
  []
  [cp]
    type = Checkpoint
    file_base = ${cp_file_base}
    sync_times_object = output_times
    time_step_interval = 25
    num_files = 48
  []
[]
