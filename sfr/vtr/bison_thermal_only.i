################################################################################
## VTR fuel rod, derived from BISON assessment case IFR1.i                    ##
## Bison Sub-Application                                                      ##
## Thermal conduction in fuel, closed gap and clad                            ##
## Convection on clad outer surface with SAM coupling                         ##
################################################################################
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

#  Units are in standard SI: J, K, kg, m, Pa, s.
#  This input file does not include friction.

# radial/axial  dimensions at hot irradiated condition to be consistent with griffin/SAM model
gap                  = 0. #0.5e-3
rod_outside_diameter = 6.282e-3  # 6.25e-3
clad_thickness       = 0.503e-3  # 0.5e-3
slug_diameter        = 5.277e-3  # 4.547e-3
fuel_height          = 842.4e-3  # 800.0e-3
plenum_height        = 782.2e-3  # 778.0e-3

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
   #  Parameters that are used in multiple blocks can be included here so that
   #  they only need to be specified one time.
   order = FIRST
   family = LAGRANGE
   temperature = Temperature
   #the following are needed in multiple UPuZr Materials
   X_Zr = 0.225 #  U-20Pu-10Zr
   X_Pu = 0.171
   density = 11120.0 # kg/m3 at hot operating condition (UPuZr fuel)
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = RZ
  # based on x447.i from examples
  # rod specific parameters - dimensions are for fresh fuel at room temperature
  [smeared_pellet_mesh]
    type = SmearedPelletMeshGenerator
    clad_thickness = ${clad_thickness}
    pellet_outer_radius = ${fparse slug_diameter/2}
    pellet_height = ${fuel_height}
    clad_top_gap_height = ${plenum_height} # fixme assumes no Na bond sodium
    clad_gap_width = ${gap} # no gap for hot condition after irradiation (2 % fima)
    top_bot_clad_height = ${clad_thickness}
    clad_bot_gap_height = 0.

    # meshing parameters
    clad_mesh_density = customize
    pellet_mesh_density = customize
    nx_p = 6  # number of fuel elements in radial direction
    ny_p = 300 # number of fuel elements in axial direction
    nx_c = 3 # number of clad elements in radial direction
    ny_c = 300 # number of clad elements in axial direction
    ny_cu = 1 #?? number of cladding elements in upper plug in axial direction (default=1)
    ny_cl = 1 #?? number of cladding elements in lower plug in axial direction (default=1)
    pellet_quantity = 1
    elem_type = QUAD4
  []
  [add_side_clad]
    type = SubdomainBoundingBoxGenerator
    location = INSIDE
    restricted_subdomains = clad
    block_id = '4'
    block_name = 'side_clad'
    input = smeared_pellet_mesh
    bottom_left = '${fparse rod_outside_diameter/2 - clad_thickness/3}  0. 0.'
    top_right = '${fparse rod_outside_diameter/2} ${fparse fuel_height + plenum_height} 0.'
  []
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [Temperature]
    initial_condition = 900
  []
[]

[Kernels]
  active = 'heat_conduction heat_source_from_power'
  [heat_time]
    type = HeatConductionTimeDerivative
    variable = Temperature
  []
  [heat_conduction]
    type = HeatConduction
    variable = Temperature
  []
  [heat_source_from_power]
    type = CoupledForce
    variable = Temperature
    block = pellet
    v = power_density_scaled
  []
  [heat_source_from_fission]
    type = FissionRateHeatSource
    variable = Temperature
    fission_rate = fission_rate
    block = pellet
  []
[]

# ==============================================================================
# MODULES
# ==============================================================================
[ThermalContact]
   #Action to control heat transfer in regions without meshes. Specifically
   #the gap and the coolant.
   [thermal_contact]
      type = GapHeatTransfer
      variable = Temperature
      primary = clad_inside_right
      secondary = pellet_outer_radial_surface
      quadrature = true
      gap_conductivity = 61.0 # [Fink and Leibowitz, 1995.] pg. 181 (840 K)
      min_gap = 0.38e-03  # [Greenquist et al., 2020] pg. 4
   []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [power_density]
    block = pellet
    initial_condition = 4.2730e+08 #homogeneous power density - from python script get_vol.py
  []
  [power_density_scaled]
    block = pellet
  []
  [tfuel]
    block = pellet
  []
  [twall]
    block = 4 # side_clad
  []
  [tcool]
    initial_condition = 750
  []
  [htc]
    initial_condition = 1e5
  []
  [disp_x]
    initial_condition = 0
  []
  [disp_y]
    initial_condition = 0
  []
[]

[AuxKernels]
  active = 'GetPowerDensity_from_griffin SetTwall SetTfuel' # replace _from_griffin by _from_func for standalone runs
  [GetPowerDensity_from_griffin]
    type = NormalizationAux
    variable = power_density_scaled
    source_variable = power_density
    normal_factor   =   2.66105 # Vhom/Vhet, from python script get_vol.py
    block = pellet
  []
  [GetPowerDensity_from_func]
    type = FunctionAux
    variable = power_density_scaled
    function = power_density_shaped
    block = pellet
  []
  [SetTwall]
    type = CoupledAux
    block = 4
    variable = twall
    coupled = Temperature
  []
  [SetTfuel]
    type = CoupledAux
    block = pellet
    variable = tfuel
    coupled = Temperature
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
  [lhgr] # W/m
    type = ConstantFunction
    value = 24.868e3
  []
  # power density in W/m3 - normally from griffin
  [power_density_hom]
    type = ConstantFunction
    value = 4.2725e8 # W/m3
  []
  [power_density_het]
     type = ConstantFunction
     value = 11.369e8 # W/m3
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
#---------------
# thermal only
#---------------
  active = 'fuel_thermal fuel_density clad_thermal clad_density'
  #fuel
  #thermal materials
  [fuel_thermal]
    type = UPuZrThermal
    block = pellet
    spheat_model = savage
    thcond_model = lanl
    porosity = 0
    k_scalar = 1.0
    outputs  = all
  []
  [fuel_density]
    type = Density
    block = pellet
  []
  #cladding
  #thermal materials
  [clad_thermal]
    type = HT9Thermal
    block = 'clad 4'
  []
  [clad_density]
    type = Density
    block = 'clad 4'
    density = 7800
  []
[]

[UserObjects]
  [disp_y_UO]
    type = LayeredAverage
    variable = disp_y
    direction = y
    num_layers = 20
    block = pellet
    execute_on = TIMESTEP_END
    use_displaced_mesh = true
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  #for coupling with SAM (provides both htc and tcool)
  [convection_outer_clad]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'clad_outside_bottom clad_outside_right clad_outside_top'
    variable = Temperature
    T_infinity = tcool
    htc = htc
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
   # Used to improve the solver performance
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  automatic_scaling = true
  solve_type = 'PJFNK'

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================
[MultiApps]
  [sam]
    type = FullSolveMultiApp
    app_type = SamApp
    positions = '0 0 0'
    input_files = sam_channel.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
  []
  [bison_mechanics]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions = '0 0 0'
    input_files = bison_mecha_only.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
  []
[]

[Transfers]
  [twall_to_sam]
    type = MultiAppCoordSwitchNearestNodeTransfer
    source_variable = twall
    variable = T_wall_external # SAM variable
    to_multi_app = sam
    displaced_target_mesh = true
    fixed_meshes = true
  []
  [tcool_from_sam]
    type = MultiAppCoordSwitchNearestNodeTransfer
    source_variable = temperature
    variable = tcool
    from_multi_app = sam
    displaced_source_mesh = true
    fixed_meshes = true
  []
  [htc_from_sam]
    type = MultiAppCoordSwitchNearestNodeTransfer
    source_variable = htc_external
    variable = htc
    from_multi_app = sam
    displaced_source_mesh = true
    fixed_meshes = true
  []
  [temperature_to_mechanics]
    type = MultiAppCopyTransfer
    to_multi_app = bison_mechanics
    source_variable = Temperature
    variable = Temperature
  []
  [disp_x_from_mechanics]
    type = MultiAppCopyTransfer
    from_multi_app = bison_mechanics
    source_variable = disp_x
    variable = disp_x
  []
  [disp_y_from_mechanics]
    type = MultiAppCopyTransfer
    from_multi_app = bison_mechanics
    source_variable = disp_y
    variable = disp_y
  []
  [sam_reporter]
    type = MultiAppReporterTransfer
    to_reporters =   'max_tcool_r/value'
    from_reporters = 'max_tcool/value'
    from_multi_app = sam
    subapp_index = 0
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [ptot_bison]
    type = ElementIntegralVariablePostprocessor
    block = pellet
    variable = power_density
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [ptot_scaled_bison]
    type = ElementIntegralVariablePostprocessor
    block = pellet
    variable = power_density_scaled
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_tfuel]
    type = ElementAverageValue
    variable = Temperature
    block = pellet
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tfuel]
    type = ElementExtremeValue
    variable = Temperature
    value_type = max
    block = pellet
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tfuel]
    type = ElementExtremeValue
    variable = Temperature
    value_type = min
    block = pellet
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_twall]
    type = ElementAverageValue
    variable = twall
    block = 4
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_twall]
    type = ElementExtremeValue
    variable = Temperature
    value_type = min
    block    = 4
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_twall]
    type = ElementExtremeValue
    variable = Temperature
    value_type = max
    block    = 4
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tclad]
    type = ElementExtremeValue
    variable = Temperature
    value_type = max
    block    = 'clad 4'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tclad]
    type = ElementExtremeValue
    variable = Temperature
    value_type = min
    block    = 'clad 4'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_tclad]
    type = ElementAverageValue
    variable = Temperature
    block    = 'clad 4'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_htc]
    type = ElementAverageValue
    variable = htc
    block = 4
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_tcool]
    type = ElementAverageValue
    variable = tcool
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tcool]
    type = ElementExtremeValue
    value_type = max
    variable = tcool
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tcool]
    type = ElementExtremeValue
    value_type = min
    variable = tcool
    execute_on = 'INITIAL TIMESTEP_END'
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
  [max_thcond]
    type = ElementExtremeValue
    variable = thermal_conductivity
  []
  [max_tcool_r]
    type = Receiver
  []
[]

[Outputs]
  # csv = true
  # exodus = true
  print_nonlinear_converged_reason = false
  print_linear_converged_reason = false
[]
