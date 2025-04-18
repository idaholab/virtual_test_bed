################################################################################
## VTR fuel rod, derived from BISON assessment case IFR1.i                    ##
## Bison lower level Sub-Application                                          ##
## Fuel and clad mechanical deformation                                       ##
################################################################################
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

#  Notes
#  Units are in standard SI: J, K, kg, m, Pa, s.
#  This input file does not include friction.

# radial/axial  dimensions at cold condition, will be thermally expanded based on fuel temperature from bison_thermal_only.i
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
  # Parameters that are used in multiple blocks can be included here so that
  # they only need to be specified one time.
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x disp_y'
  temperature = Temperature
  #the following are needed in multiple UPuZr Materials
  X_Zr = 0.225 #  U-20Pu-10Zr
  X_Pu = 0.171
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = RZ
  # based on x447.i from examples
  # rod specific parameters - dimensions are for fresh fuel at room temperature
  [smeared_pellet_mesh]
    type = FuelPinMeshGenerator
    clad_thickness = ${clad_thickness}
    pellet_outer_radius = ${fparse slug_diameter/2}
    pellet_height = ${fuel_height}
    clad_gap_width = ${gap}
    bottom_clad_height = ${clad_thickness}
    top_clad_height = ${clad_thickness}
    clad_bot_gap_height =${clad_thickness}
    clad_top_gap_height = ${plenum_height} # fixme assumes no Na bond sodium
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
  # mesh options
  patch_size = 50
  patch_update_strategy = iteration
  partitioner = centroid
  centroid_partitioner_direction = y
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
  # Only Temperature is specified here. disp_x and disp_y are generated by the
  # [Physics/SolidMechanics] block.
  [Temperature]
    initial_condition = 900
  []
[]

[AuxKernels]
[]

# ==============================================================================
# MODULES
# ==============================================================================
[Physics]
   # Modules are prepackaged actions to create objects in other blocks.
   [SolidMechanics]
      [QuasiStatic]
         add_variables = true
         strain = SMALL # changed from finite for enabling steady solve
         generate_output = 'stress_xx stress_yy  strain_xx strain_yy' #  'hoop_stress vonmises_stress hydrostatic_stress volumetric_strain'
         [fuel_mechanics]
            block = pellet
            eigenstrain_names = fuel_thermal_strain # 'fuel_thermal_strain fuel_gaseous_strain fuel_solid_strain'
         []
         [cladding_mechanics]
            block = 'clad 4'
            eigenstrain_names = clad_thermal_strain #'clad_thermal_strain clad_swelling_strain'
            #additional_generate_output = 'hoop_creep_strain hoop_elastic_strain hoop_strain'
         []
      []
   []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
   # Any parameter that is a pre-specified function of space and time goes here.
   [power_history]
     type = ConstantFunction
     value = 24.868e3
   []
   [axial_peaking_factors]
     type = ConstantFunction
     value = 1.
   []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
#---------------
# mechanics only
#---------------
#fuel+clad
active = 'fuel_elasticity_tensor fuel_elastic_stress fuel_thermal_expansion
          clad_elasticity_tensor clad_elastic_stress clad_thermal_expansion
          fission_rate fuel_gaseous_swelling'
  [fission_rate] # only needed with heat_source_standalone kernel
    type = UPuZrFissionRate
    rod_linear_power = power_history
    axial_power_profile = axial_peaking_factors
    #X_Pu_function = 0.0
    # coeffs = '0.8952 -1.2801 '
    pellet_radius = ${fparse slug_diameter/2}
    block = pellet
  []
  #fuel
  #mechanics materials
  [fuel_elasticity_tensor]
    type = UPuZrElasticityTensor
    block = pellet
    porosity = porosity
    output_properties = 'youngs_modulus poissons_ratio'
    outputs = all
  []
  [fuel_elastic_stress]
    type = ComputeLinearElasticStress
    block = pellet
  []
  [fuel_thermal_expansion]
    type = UPuZrThermalExpansionEigenstrain
    block = pellet
    eigenstrain_name = fuel_thermal_strain
    stress_free_temperature = 900 # geometry already expanded at hot condition
  []
  [fuel_gaseous_swelling] # needed to get porosity material property set
    type = UPuZrGaseousEigenstrain
    block = pellet
    eigenstrain_name = fuel_gaseous_strain
    anisotropic_factor = 0.5 # [Greenquist et al., pg. 8]
    bubble_number_density = 2.09e18 # [Casagranda, 2020]
    interconnection_initiating_porosity = 0.125 # [Casagranda, 2020]
    interconnection_terminating_porosity = 0.2185 # [Casagranda, 2020]
    fission_rate = fission_rate
    output_properties = porosity
    outputs = all
  []
  #cladding
  #mechanics materials
  # [clad_elasticity_tensor]
  #   type = ComputeIsotropicElasticityTensor
  #   youngs_modulus = 1.645e11 # [Hofman et al., 1989] pg. E.1.1.6 (733 K)
  #   poissons_ratio = 0.35 # [Hofman et al., 1989] pg. E.1.1.6 (733 K)
  #   block = 'clad 4'
  # []
  [clad_elasticity_tensor]
    type = HT9ElasticityTensor
    block = 'clad 4'
  []
  [clad_elastic_stress]
    type = ComputeLinearElasticStress
    block = 'clad 4'
  []
  [clad_thermal_expansion]
    type = HT9ThermalExpansionEigenstrain
    block = 'clad 4'
    eigenstrain_name = clad_thermal_strain
    stress_free_temperature = 295 # [Greenquist et al., 2020] pg. 7
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  [no_x_all]
    type = DirichletBC
    variable = disp_x
    boundary = centerline
    value = 0.0
  []
  [no_y_all]
    type = DirichletBC
    variable = disp_y
    boundary = 'clad_outside_bottom bottom_of_bottom_pellet'
    value = 0.0
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
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [disp_x_max]
    type = NodalExtremeValue
    variable = disp_x
    value_type = max
    use_displaced_mesh = true
  []
  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
    use_displaced_mesh = true
  []
  [disp_y_max]
    type = NodalExtremeValue
    variable = disp_y
    value_type = max
    use_displaced_mesh = true
  []
  [strain_yy]
    type = ElementAverageValue
    variable = strain_yy
    use_displaced_mesh = true
  []
[]

[Outputs]
  # csv = true
  # exodus = true
  print_nonlinear_converged_reason = false
  print_linear_converged_reason = false
[]
