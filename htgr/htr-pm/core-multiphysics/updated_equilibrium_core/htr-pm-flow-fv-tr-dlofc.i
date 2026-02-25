# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# DLOFC HTR-PM model Created & modifed by Sebastian Schunert, Mustafa Jaradat, April 11, 2023
# ==============================================================================
# - htr-pm-FV: reference plant design based on 250MW HTR-PM plant.
# - FV using the new FV action
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------

# Geometry ---------------------------------------------------------------------
pebble_diameter               = 0.06   # Diameter of the pebbles (m).
pbed_top                      = 14.228 # TAF (m).
pbed_bottom                   = 3.228  # Bottom of bed (m).
pbed_r                        = 1.500  # Pebble Bed radius (m).

# Properties -------------------------------------------------------------------
global_emissivity                = 0.80     # All the materials has the same emissivity (//).
pebble_bed_porosity              = 0.39      # Pebble bed porosity (//).
fluid_channels_porosity          = 0.20      # 20% is assumed in regions where the He flows in graphite areas (//).
bypass_channel_porosity          = 0.32      # Porosity in the bypass channel (see engineering calc in spreadsheet)
riser_porosity                   = 0.32      # Porosity in the riser channel (see engineering calc in spreadsheet)
top_reflector_porosity           = 0.3       # Porosity of the top reflector
bottom_reflector_porosity        = 0.3       # Porosity of the bottom reflector
mfr                              = 96.0      # Total reactor He mass flow rate (kg/s).
T_inlet                          = 523.15    # Helium inlet temperature (K).
p_outlet                         = 7.0e+6    # Reactor outlet pressure (Pa)

# Hydraulic diameter -----------------------------------------------------------
D_H_bypass = 0.15                            # Hydraulic diameter of bypass
D_H_riser  = 0.1875                          # Hydraulic diameter of riser
D_H_top_reflector = 0.2                      # Hydraulic diameter of the top reflector
D_H_bottom_reflector = 0.2                   # Hydraulic diameter of the top reflector
D_H_top_cavity = 0.67                        # Hydraulic diameter of the top cavity

# Heat transfer area per volume ------------------------------------------------
C_DB = 0.023                                 # original Dittus Boelter constant for areal htc; modified by ApV
ApV_bypass = 8.521                           # heat transfer area per volume bypass
ApV_riser  = 6.927                           # heat transfer area per volume riser
ApV_top_reflector = 5.737                    # heat transfer area per volume top reflector
ApV_bottom_reflector = 5.737                 # heat transfer area per volume bottom reflector

## block definitions
# fluid blocks define fluid vars and solve for them
fluid_blocks = '1 2 3 4 5 6 61 71'
# solid blocks define T_solid and solve for it
solid_blocks = '1 2 3 5 6 7 8 10 12 61 71 9 11'

# friction scaling
scaling = 0.1  #0.05

# volumetric heat transfer coefficient between solid
# fluid and solid in the fluid/solid regions except the
# bed; currently applied in top_reflector bottom_reflector hot_plenum cold_plenum
# TODO: use correlations here
alpha_fluid_solid = 5e3

# nominal power density
# nominal_pd = 3.215e6

[GlobalParams]
  acceleration = '0.0 -9.81 0.0' # Gravity acceleration (m/s2).
  fp = fluid_properties_obj
  porosity = 'porosity'
  pebble_diameter = ${pebble_diameter}
  T_solid = T_solid
  rhie_chow_user_object = pins_rhie_chow_interpolator
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [file]
    type = FileMeshGenerator
    file = 'htr_pm_griffin_ss_out_flow0.e'
    use_for_exodus_restart = true
  []
[]

[Problem]
  coord_type = RZ
  kernel_coverage_check = false
[]

[Modules]
  [NavierStokesFV]
    # restart!
    #initialize_variables_from_mesh_file = true
    #energy_scaling = 5e-6

    # basic settings
    block = ${fluid_blocks}
    compressibility = 'weakly-compressible'
    add_energy_equation = true
    gravity = '0.0 -9.81 0.0'
	
	# Variables, defined below for the Exodus restart
    velocity_variable = 'superficial_vel_x superficial_vel_y'
    pressure_variable = 'pressure'
    fluid_temperature_variable = 'T_fluid'
	
    # Porous treatement
    porous_medium_treatment = true
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
    consistent_scaling = 50 #200 #1000
    porosity_smoothing_layers = 0

    pressure_face_interpolation = average
    momentum_advection_interpolation = upwind
    mass_advection_interpolation = upwind
    energy_advection_interpolation = upwind

    use_friction_correction = true

    # convective heat transfer
    ambient_convection_blocks = '1 2 3 5 6 61 71'
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'

    # fluid properties
    density = 'rho'
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'kappa'
    specific_heat = 'cp'

    # boundary conditions
    inlet_boundaries = 'reactor_inlet'
    momentum_inlet_types = 'flux-mass'
    flux_inlet_pps = 'set_inlet_mfr'
    flux_inlet_directions = '0 1 0'
    energy_inlet_types = 'flux-mass'
    energy_inlet_function = '${T_inlet}'

    outlet_boundaries = 'reactor_outlet'
    momentum_outlet_types = 'fixed-pressure'
    pressure_function = 'pressure_out_fn'

    wall_boundaries =      'pbed_inner pbed_outer hot_plenum_walls cold_plenum_walls riser_walls bypass_wall'
    momentum_wall_types =  'symmetry   slip       slip             slip              slip        slip'
    energy_wall_types =    'heatflux   heatflux   heatflux         heatflux          heatflux    heatflux'
    energy_wall_function = '0          0          0                0                 0           0'
  []

  [FluidProperties]
    [fluid_properties_obj]
      type = HeliumFluidProperties
    []
  []
[]

[Variables]
  [T_solid]
    type = INSFVEnergyVariable
    block = '${solid_blocks}'
	initial_from_file_var = T_solid
	initial_from_file_timestep = LATEST
  []
  [T_fluid]
    type = INSFVEnergyVariable
    block = '${fluid_blocks}'
    initial_from_file_var = T_fluid
    initial_from_file_timestep = LATEST
  []
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = '${fluid_blocks}'
    #initial_condition = 1e-10
    initial_from_file_var = superficial_vel_x
    initial_from_file_timestep = LATEST
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = '${fluid_blocks}'
    #initial_condition = 1e-10
    initial_from_file_var = superficial_vel_y
    initial_from_file_timestep = LATEST
  []
  [pressure]
    type = INSFVPressureVariable
    block = '${fluid_blocks}'
    #initial_condition = 1e-10
    initial_from_file_var = pressure
    initial_from_file_timestep = LATEST
  []
[]

[FVKernels]
  [energy_storage]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    rho = rho_s
    cp = cp_s
    is_solid = true
  []
  [solid_energy_diffusion_core]
    type = PINSFVEnergyAnisotropicDiffusion
    variable = T_solid
    kappa = 'effective_thermal_conductivity'
    effective_diffusivity = true
    # porosity won't be used because effective_diffusivity = true
    # so set it to 1
    porosity = 1
  []
  [convection_pebble_bed_fluid]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = alpha
    block = 'pebble_bed top_reflector
             bottom_reflector hot_plenum
             cold_plenum riser bypass'
  []
  [heat_source]
    type = FVCoupledForce
    variable = T_solid
    v = power_density
    block = 'pebble_bed'
  []
[]

[FVBCs]
  [radiation]
    type = FVInfiniteCylinderRadiativeBC
    variable = T_solid
    boundary = right
    temperature = T_solid
    Tinfinity = 300.0
    boundary_radius = 3.0
    boundary_emissivity = ${global_emissivity}
    cylinder_radius = 4.0
    cylinder_emissivity = ${global_emissivity}
  []
  [convection]
    type = FVThermalResistanceBC
    variable = T_solid
    htc = natural_htc
    T_ambient = 300.0
    emissivity = 0
    thermal_conductivities = '0.025'
    conduction_thicknesses = '1'
    boundary = right
  []
[]

[Functions]
  [mu_ramp_fn]
    type = PiecewiseLinear
    x = '0  1 1e+7'
    y = '1  1 1'
  []
  [mfr_fn]
    type = PiecewiseLinear
    x = '    0      13'
    y = ' ${mfr}    0.0'
  []
  [pressure_out_fn]
    type = PiecewiseLinear
    x = '  0           13'
    y = '${p_outlet}  101325.0'
  []
  [dt_max_fn]
    type = PiecewiseLinear
    x = '-10 0 16 30 1000 5000 20000 100000 200000 500000'
    y = '  1 1 1  1  50   100  200   400   400   500'
  []
[]

[AuxVariables]
  [porosity_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [alpha_var]
    type = MooseVariableFVReal
    block = 'pebble_bed top_reflector
             bottom_reflector hot_plenum
             cold_plenum riser bypass'
  []
  [effective_thermal_conductivity_var0]
    type = MooseVariableFVReal
    block = ${solid_blocks}
  []
  [effective_thermal_conductivity_var1]
    type = MooseVariableFVReal
    block = ${solid_blocks}
  []
  [kappa_f_var0]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [kappa_f_var1]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [power_density]
    type = MooseVariableFVReal
    block = 'pebble_bed'
  []
[]

[AuxKernels]
  [porosity_var_aux]
    type = ADFunctorElementalAux
    variable = porosity_var
    functor = 'porosity'
    block = ${fluid_blocks}
  []

  [alpha_var_aux]
    type = ADFunctorElementalAux
    variable = alpha_var
    functor = 'alpha'
    block = 'pebble_bed top_reflector
             bottom_reflector hot_plenum
             cold_plenum riser bypass'
  []

  [effective_thermal_conductivity_var0_aux]
    type = ADFunctorVectorElementalAux
    variable = effective_thermal_conductivity_var0
    functor = 'effective_thermal_conductivity'
    block = ${solid_blocks}
    component = 0
  []

  [effective_thermal_conductivity_var1_aux]
    type = ADFunctorVectorElementalAux
    variable = effective_thermal_conductivity_var1
    functor = 'effective_thermal_conductivity'
    block = ${solid_blocks}
    component = 1
  []

  [kappa_f_var0_aux]
    type = ADFunctorVectorElementalAux
    variable = kappa_f_var0
    functor = 'kappa'
    block = ${fluid_blocks}
    component = 0
  []

  [kappa_f_var1_aux]
    type = ADFunctorVectorElementalAux
    variable = kappa_f_var1
    functor = 'kappa'
    block = ${fluid_blocks}
    component = 1
  []
[]

[Postprocessors]
  [set_inlet_mfr]
    type = FunctionValuePostprocessor
    function = 'mfr_fn'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []

  [outlet_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = reactor_outlet
    execute_on  = 'initial timestep_end'
  []

  [bypass_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = bypass_hot_plenum_interface
    #execute_on  = 'initial timestep_end'
  []

  inactive = 'pressure_inlet pressure_outlet core_delta_p'
  [pressure_inlet]
    type = SideAverageValue
    boundary = 'reactor_inlet'
    variable = pressure
    execute_on = 'initial TIMESTEP_END'
  []

  [pressure_outlet]
    type = SideAverageValue
    boundary = 'reactor_outlet'
    variable = pressure
    execute_on = 'initial TIMESTEP_END'
  []

  [core_delta_p]
    type = ParsedPostprocessor
    function = 'pressure_inlet - pressure_outlet'
    pp_names = 'pressure_inlet pressure_outlet'
    execute_on = 'initial TIMESTEP_END'
  []

  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'pebble_bed'
    execute_on  = 'initial timestep_end'
  []

  [core_volume]
    type = VolumePostprocessor
    block = 'pebble_bed'
    execute_on  = 'initial timestep_end'
  []

  [dt_max_pp]
    type = FunctionValuePostprocessor
    function = dt_max_fn
    execute_on = TIMESTEP_BEGIN
  []

  [bed_solid_average_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'pebble_bed'
    
  []
  
  [ref_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'side_reflector'
  []
  [ref_average_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'side_reflector'
  []
  [barrel_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'core_barrel'
  []
  [barrel_average_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'core_barrel'
  []
  [rpv_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'rpv'
  []
  [rpv_average_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'rpv'
  []
  [rpv_flux2]
    type = ADSideIntegralFunctorPostprocessor
    boundary = 'right'
    functor = 'k_s'
    execute_on  = 'initial timestep_end'
  []
  
  [rpv_flux]
    type = ADSideDiffusiveFluxIntegral
    variable = T_solid
    functor_diffusivity = 'k_s'
    boundary = 'right'
    execute_on  = 'initial timestep_end'
  []
  
  [right_Temp]
    type = SideAverageValue
    boundary = 'right'
    variable = T_solid
    execute_on  = 'initial timestep_end'
  []
  [rpv_radiation_out] # should be equal to 0 upon convergence
    type = ParsedPostprocessor
    function = '0.8*5.6703e-8*316.6725395*(right_Temp^4 - 300.0^4)/1000.0'
    pp_names = 'right_Temp'
    execute_on  = 'initial timestep_end'
  []
  [rpv_convective_out]
    type = ParsedPostprocessor
    function = '1.0*316.6725395*(right_Temp - 300.0)/1000.0'
    pp_names = 'right_Temp'
    execute_on  = 'initial timestep_end'
  []
  #[rpv_convective_out]    
  #  type = ConvectiveHeatTransferSideIntegral
  #  T_solid = T_solid
  #  boundary = 'right' # outer RVP
  #  T_fluid = 300.0
  #  htc = 5.0
  #  execute_on = 'TIMESTEP_END'
  #[]
  [rpv_tot_out] # should be equal to 0 upon convergence
    type = ParsedPostprocessor
    function = 'rpv_convective_out + rpv_radiation_out '
    pp_names = 'rpv_convective_out rpv_radiation_out'
    execute_on  = 'initial timestep_end'
  []
  
  #[Tf_inlet]
  #  type = SideAverageValue
  #  boundary = 'reactor_inlet'
  #  variable = T_fluid
  #  execute_on = 'TIMESTEP_END'
  #[]
  #
  #[Tf_outlet]
  #  type = SideAverageValue
  #  boundary = 'reactor_outlet'
  #  variable = T_fluid
  #  execute_on = 'TIMESTEP_END'
  #[]
  
  #[Tf_inlet_vol]
  #  type = VolumetricFlowRate
  #  vel_x = superficial_vel_x
  #  vel_y = superficial_vel_y
  #  advected_quantity = T_fluid
  #  boundary = reactor_inlet
  #[]
  [Tf_outlet_vol]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = T_fluid
    boundary = reactor_outlet
    execute_on  = 'initial timestep_end'
  []
  [outlet_vfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 1.0
    boundary = reactor_outlet
    execute_on  = 'initial timestep_end'
  []
  [He_Heat_Ext] # should be equal to 0 upon convergence
    type = ParsedPostprocessor
    function = '96.0 * 5195.0 * (Tf_outlet_vol/outlet_vfr - 523.15) '
    pp_names = 'Tf_outlet_vol outlet_vfr'
    execute_on  = 'initial timestep_end'
  []
[]

[UserObjects]
  [wall_distance_uo]
    type = WallDistanceCylindricalBed
    outer_radius = ${pbed_r}
    axis = 1
    bottom = ${pbed_bottom}
    top = ${pbed_top}
  []
[]

[Materials]
  ## Solid thermal properties
  [graphite_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s'
    prop_values = '1780.0 1697'
    block = 'pebble_bed side_reflector carbon_brick
             bottom_reflector hot_plenum cold_plenum bypass riser
             top_reflector'
  []

  [He_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s'
    prop_values = '6      5000'
    block = 'refl_barrel_gap barrel_rpv_gap'
  []
  ## natural htc for BC
  [natural_htc_mat]
    type = ADGenericConstantMaterial
    prop_names = 'natural_htc'
    prop_values = '5'
  []
  [pebble_bed_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '26.0'
    block = 'pebble_bed'
  []

  [reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '26.0'
    block = 'side_reflector carbon_brick'
  []

  [core_barrel_steel]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s   cp_s k_s'
    prop_values = '7800.0 540  17.0'
    block = 'core_barrel'
  []

  [rpv_steel]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s  k_s'
    prop_values = '7800.0 525.0 38.0'
    block = 'rpv'
  []

  [channels_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '20.8'
    block = 'hot_plenum cold_plenum'
  []

  [bypass_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - bypass_channel_porosity)}'
    block = 'bypass'
  []

  [riser_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - riser_porosity)}'
    block = 'riser'
  []

  [top_reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - top_reflector_porosity)}'
    block = 'top_reflector'
  []

  [bottom_reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - bottom_reflector_porosity)}'
    block = 'bottom_reflector'
  []

  # Effective solid thermal conductivity in the bed
  [pebble_effective_thermal_conductivity]
    type = FunctorPebbleBedKappaSolid
    radiation = BreitbachBarthels
    emissivity = 0.8
    Youngs_modulus = 11.5e9
    Poisson_ratio = 0.31
    wall_distance = wall_distance_uo
    block = 'pebble_bed'
  []

  # we use effective_thermal_conductivity everywhere as thermal conductivity
  # in most regions effective_thermal_conductivity = k_s
  [effective_solid_thermal_conductivity_pb]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'kappa_s kappa_s kappa_s'
    block = 'pebble_bed'
  []

  [effective_solid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'k_s k_s k_s'
    block = 'top_reflector
             bottom_reflector
             hot_plenum
             cold_plenum
             side_reflector
             carbon_brick
             core_barrel
             rpv
             riser
             bypass'
  []
  
  [non_pebble_bed_eff_solid_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = '4 0 0'
    block = 'refl_barrel_gap barrel_rpv_gap'
  []
  ## hydraulic diameter and porosity - fixed number per block
  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'porosity'
    subdomain_to_prop_value = 'pebble_bed       ${pebble_bed_porosity}
                               top_reflector    ${top_reflector_porosity}
                               bottom_reflector ${bottom_reflector_porosity}
                               top_cavity       1
                               hot_plenum       ${fluid_channels_porosity}
                               cold_plenum      ${fluid_channels_porosity}
                               side_reflector   0
                               carbon_brick     0
                               core_barrel      0
                               rpv              0
                               riser            ${riser_porosity}
                               bypass           ${bypass_channel_porosity}
                               refl_barrel_gap  0
                               barrel_rpv_gap   0
                              '
  []

  [hydraulic_diameter]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = 'characteristic_length'
    subdomain_to_prop_value = 'pebble_bed       ${pebble_diameter}
                               top_reflector    ${D_H_top_reflector}
                               bottom_reflector ${D_H_bottom_reflector}
                               top_cavity       ${D_H_top_cavity}
                               hot_plenum       1
                               cold_plenum      1
                               riser            ${D_H_riser}
                               bypass           ${D_H_bypass}
                              '
    block = ${fluid_blocks}
  []

  ## Fluid properties and non-dimensional numbers
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    pressure = 'pressure'
    T_fluid = 'T_fluid'
    speed = 'speed'
    # To initialize with a high viscosity
    mu_rampdown = 'mu_ramp_fn'
    # For porous flow
    characteristic_length = characteristic_length
    block = ${fluid_blocks}
  []

  ## Volumetric heat transfer coefficient correlations
  [pebble_volumetric_heat_transfer]
    type = FunctorWakaoPebbleBedHTC
    block = 'pebble_bed'
  []

  [bypass_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_bypass}
    block = 'bypass'
  []

  [riser_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_riser}
    block = 'riser'
  []

  [top_reflector_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_top_reflector}
    block = 'top_reflector'
  []

  [bottom_reflector_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_bottom_reflector}
    block = 'bottom_reflector'
  []

  [rename_wall_htc_to_alpha]
    type = ADGenericFunctorMaterial
    prop_names =  'alpha'
    prop_values = 'wall_htc'
    block = 'bypass riser top_reflector bottom_reflector'
  []

  [other_fluid_solid_volumetric_heat_transfer]
    type = ADGenericFunctorMaterial
    prop_names =  'alpha'
    prop_values = '${alpha_fluid_solid}'
    block = 'hot_plenum cold_plenum'
  []

  ## Effective fluid thermal conductivities
  [pebble_bed_effective_fluid_thermal_conductivity]
    type = FunctorLinearPecletKappaFluid
    block = 'pebble_bed'
  []
  #inactive = 'effective_thermal_conductivity_top_cavity'
  [non_pebble_bed_eff_solid_conductivity_2]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = '0 15 0'
    block = 'top_cavity'
  []
  [effective_fluid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = 'top_reflector bottom_reflector
             hot_plenum cold_plenum riser bypass'
  []

  ## Drag correlations
  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    block = 'pebble_bed'
  []

  [isotropic_drag_hot_plenum]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = ${fparse 1.25*scaling}
    block = 'hot_plenum'
  []
  [isotropic_drag_cold_plenum_cavity]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = ${fparse 1.25*scaling}
    block = 'cold_plenum top_cavity'
  []

  [drag_Churchill]
    type = FunctorChurchillDragCoefficients
    block = 'riser top_reflector bottom_reflector'
    multipliers = ' 1.0e+05  1.0  1.0e+05 '
  []

  [drag_bypass]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = 2000
    block = 'bypass'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart -sub_pc_factor_shift_type'
  petsc_options_value = 'lu       mumps                         100                 NONZERO'
  automatic_scaling = true
  nl_abs_tol = 1e-5
  line_search = l2
  nl_max_its = 50
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    timestep_limiting_postprocessor = dt_max_pp
    optimal_iterations = 10
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []
  start_time = 0
  end_time = 5.0e+05
[]

[Outputs]
  csv = true
  exodus = true
  #[console]
  #  type = Console
  #  hide = 'area_pp_reactor_inlet set_inlet_mfr'
  #[]
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
