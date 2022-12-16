################################################################################
## SFR assembly model                                                         ##
## Griffin main application                                                   ##
## Steady state neutronics model                                              ##
## 6-group continuous neutron diffusion without equivalence                   ##
################################################################################
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  [fmg]
   type = FileMeshGenerator
   file = vtb_single_asm.e
   exodus_extra_element_integers = 'material_id equivalence_id'
  []
  parallel_type = replicated
  displacements = 'disp_x disp_y disp_z'
[]

[GlobalParams]
  is_meter = true
  grid_names = 'tfuel tcool'
  grid_variables = 'tfuel tcool'
  library_file = 'sfr_xs.xml'
  library_name = 'sfr_xs'
  isotopes = 'pseudo'
  densities = '1.0'
[]


[AuxVariables]
  [tfuel]
    initial_condition = 900.
  []
 [tcool]
   initial_condition = 700.
 []
 [disp_x] # from grid plate expansion
   initial_condition = 0
 []
 [disp_y]  # from axial fuel expansion
   initial_condition = 0
 []
 [disp_z] # from grid plate expansion
   initial_condition = 0
 []
[]


[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  ReflectingBoundary = '1 2 3'
  [CFEM-Diffusion]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    family = LAGRANGE
    order = FIRST
    use_displaced_mesh = true
  []
[]


[Materials]
  [nonfuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 2
    plus = 0
    displacements = 'disp_x disp_y disp_z'
  []
  [fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 1
    plus = 1
    displacements = 'disp_x disp_y disp_z'
  []
[]

[PowerDensity]
  power = 4545454.5 # in W
  power_density_variable = power_density # name of AuxVariable to be created
[]


[Executioner]
  automatic_scaling = True
  type = Eigenvalue
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 100'
  free_power_iterations = 2
  nl_abs_tol = 1e-8


  # Multiphysics coupling iteration parameters
  fixed_point_rel_tol = 1e-08
  fixed_point_abs_tol = 1e-10
  fixed_point_max_its = 10
  accept_on_max_fixed_point_iteration = true
[]

#  STM global variables passed from stochastic tools to sub-apps (BISON/SAM)
  k_scalar = 1.0


[MultiApps]

  [bison]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions = '0 0.976 0'
    input_files = bison_thermal_only.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #STM
    cli_args = 'Materials/fuel_thermal/k_scalar=${k_scalar}'
  []

  [core_support_plate]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions = '0 0 0'
    input_files = core_support_plate_2d.i
    execute_on = INITIAL # no need for other calls - since tinlet is fixed
    output_in_position = true
  []
[]

[Transfers]

  # main app -> sub-app

  #-----------------------
  # power_density to BISON
  #-----------------------
  # (1) ProjectionTransfer
  [pdens_to_bison]
    type = MultiAppProjectionTransfer
    variable = power_density
    source_variable = power_density
    to_multi_app = bison
  []

  # sub-app -> main app

  #------------------
  # tfuel from BISON
  #------------------
  #(1) InterpolationTransfer
  [tfuel_from_subapp]
    type = MultiAppGeometricInterpolationTransfer
    source_variable = tfuel
    variable = tfuel
    from_multi_app = bison
  []
  #------------------
  # tcool from SAM
  #------------------
  #(1) InterpolationTransfer
  [tcool_from_subapp]
    type = MultiAppGeometricInterpolationTransfer
    source_variable = tcool
    variable = tcool
    from_multi_app = bison
  []
  #------------------
  # axial expansion = vertical displacements disp_y
  #------------------
  [disp_y_from_bison]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison
    source_variable = disp_y
    variable = disp_y
  []
  #------------------
  # Radial expansion = horizontal displacements disp_x, disp_z from core_support_plate
  #------------------
  [disp_x_from_core_support_plate]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = core_support_plate
    source_variable = disp_x
    variable = disp_x
  []
  [disp_z_from_core_support_plate]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = core_support_plate
    source_variable = disp_y
    variable = disp_z
  []
[]



[Postprocessors]
  [avg_tfuel]
    type = ElementAverageValue
    variable = tfuel
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tfuel]
    type = ElementExtremeValue
    variable = tfuel
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tfuel]
    type = ElementExtremeValue
    variable = tfuel
    value_type = min
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_tcool]
    type = ElementAverageValue
    variable = tcool
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tcool]
    type = ElementExtremeValue
    variable = tcool
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tcool]
    type = ElementExtremeValue
    variable = tcool
    value_type = min
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [ptot]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = ' INITIAL TIMESTEP_END'
  []
  [disp_x_max]
    type = ElementExtremeValue
    variable = disp_x
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [disp_y_max]
    type = ElementExtremeValue
    variable = disp_y
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [disp_z_max]
    type = ElementExtremeValue
    variable = disp_z
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
[]


[Outputs]
   exodus = true
   csv = true
[]
