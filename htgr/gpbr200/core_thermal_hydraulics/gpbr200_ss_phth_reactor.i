# ==============================================================================
# Model description:
# gPBR200 thermal hydraulic model
# ------------------------------------------------------------------------------
# Idaho Falls, INL, Mar. 2023
# Author(s)(name alph): David Reger, Dr. Javier Ortensi, Dr. Paolo Balestra,
#   Dr. Ryan Stewart, Dr. Sebastian Schunert., Dr. Zachary M. Prince
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Blocks -----------------------------------------------------------------------
risers_blocks = '1 2 3 22'
fluid_only_blocks = '4'
heated_blocks = '5 6 7 8 9'
outchans_blocks = '10'
outplen_blocks = '11'
hotleg_blocks = '12'
ref_blocks = '13 14 15 16 17'
ref2barrel_gap = '18'
barrel_blocks = '19'
barrel2rpv_gap = '20'
rpv_blocks = '21'
outlet_blocks = '${outplen_blocks} ${hotleg_blocks} ${outchans_blocks}'
porous_blocks = '${risers_blocks} ${heated_blocks} ${outlet_blocks}'
fluid_blocks = '${fluid_only_blocks} ${porous_blocks}'
solid_only_blocks = '${ref_blocks} ${barrel_blocks} ${rpv_blocks}'
pbed_blocks = '${heated_blocks}'
no_pbed_porous_blocks = '${risers_blocks} ${outlet_blocks}'

# Geometry ---------------------------------------------------------------------
pbed_r = 1.200 # Pebble Bed radius (m).
pbed_top = 11.3354 # Absolute height of the core top in the model (m).
rpv_r = 2.307 # rpv radius (m)
cavity_thickness = 1.340 # Cavity thickness from pbmr400 (m)
pebble_diameter = 0.06 # Diameter of the pebbles (m).

# Properties -------------------------------------------------------------------
global_emissivity = 0.80 # All the materials have the same emissivity (//).
reactor_total_mfr = 64.3 # Total reactor He mass flow rate (kg/s).
reactor_inlet_T_fluid = 533.25 # He temperature  at the inlet of the lower inlet plenum (K).
reactor_inlet_rho = 5.364 # He density at the inlet of the lower inlet plenum (kg/m3).
reactor_outlet_pressure = 5.84e+6 # Pressure at the at the outlet of the outlet plenum (Pa).
top_bottom_cav_temperature = '${fparse 273.15 + 200.0}' # Top and Bottom cavities temperatures (K).
rccs_temperature = '${fparse 273.15 + 70.0}' # RCCS temperatures (K).
htc_cavities = 10.0 # Heat Exchange coefficient for natural circulation (W/m2K)
heat_capacity_multiplier = 1e-5
db_cnst = 0.023 # Dittus Boelter constant for area htc
pbed_porosity = 0.39 # Pebble bed porosity (//).

# Power ------------------------------------------------------------------------
total_power = 200.0e+6 # Total reactor Power (W)

# BCs --------------------------------------------------------------------------
inlet_free_area = '${fparse 2 * pi * 2.066 * 0.39}'
inlet_vel = '${fparse reactor_total_mfr/inlet_free_area/reactor_inlet_rho}'

# Initial values ---------------------------------------------------------------
pbed_free_flow_area = '${fparse pi * pbed_r * pbed_r}' # Core inlet free flow area (m2)
pbed_superficial_vel = '${fparse -reactor_total_mfr/pbed_free_flow_area/reactor_inlet_rho}' # m/s
initial_temp = 900.0 # K

[GlobalParams]
  pebble_diameter = ${pebble_diameter}
  acceleration = ' 0.00 -9.81 0.00 ' # Gravity acceleration (m/s2).
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [pebble_bed]
    type = FileMeshGenerator
    file = ../data/streamline_mesh_in.e
  []
  coord_type = RZ
  rz_coord_axis = Y
[]

[Problem]
  kernel_coverage_check = false
  material_coverage_check = false
[]

# ==============================================================================
# PHYSICS
# ==============================================================================
[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        # Basic FVM settings
        block = '${fluid_blocks}'
        compressibility = 'weakly-compressible'
        gravity = '0.0 -9.81 0.0'

        # Porous treatment.
        porous_medium_treatment = true
        friction_types = 'darcy forchheimer'
        friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
        porosity_interface_pressure_treatment = 'bernoulli'

        # Fluid properties.
        density = 'rho'
        dynamic_viscosity = 'mu'

        # Initial conditions.
        initial_velocity = '0 pbed_superficial_vel_func 0'
        velocity_variable = 'superficial_vel_x superficial_vel_y'
        initial_pressure = '${reactor_outlet_pressure}'

        # Fluid boundary conditions.
        inlet_boundaries = 'inlet'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '-${inlet_vel} 0'

        outlet_boundaries = 'outlet'
        momentum_outlet_types = 'fixed-pressure'
        pressure_functors = '${reactor_outlet_pressure}'

        wall_boundaries = 'wall inner'
        momentum_wall_types = 'slip  symmetry'
      []
    []
    [FluidHeatTransfer]
      [energy]
        block = '${fluid_blocks}'

        # Fluid properties.
        thermal_conductivity = 'kappa'
        specific_heat = 'cp'

        # Initial conditions
        fluid_temperature_variable = 'T_fluid'
        initial_temperature = '${initial_temp}'

        # Fluid boundary conditions
        energy_inlet_types = 'fixed-temperature'
        energy_inlet_functors = '${reactor_inlet_T_fluid}'
        energy_wall_types = 'heatflux  heatflux'
        energy_wall_functors = '0         0'

        # Convective heat transfer.
        ambient_convection_blocks = '${porous_blocks}'
        ambient_convection_alpha = 'alpha'
        ambient_temperature = 'T_solid'

        # Interpolation schemes.
        energy_advection_interpolation = average
      []
    []
    [SolidHeatTransfer]
      [solid]
        block = '${porous_blocks} ${solid_only_blocks} ${ref2barrel_gap} ${barrel2rpv_gap}'

        # Initial conditions.
        solid_temperature_variable = 'T_solid'
        initial_temperature = ${initial_temp}

        # Solid properties
        thermal_conductivity_solid = 'effective_thermal_conductivity'
        cp_solid = 'cp_s_mod'
        rho_solid = 'rho_s'

        # Convective heat transfer.
        ambient_convection_blocks = '${porous_blocks}'
        ambient_convection_alpha = 'alpha'
        ambient_convection_temperature = 'T_fluid'

        # Heat source
        external_heat_source_blocks = '${heated_blocks}'
        external_heat_source = 'power_density'
      []
    []
  []
[]

[FVBCs]
  [rpv_radial_radiation]
    type = FVInfiniteCylinderRadiativeBC
    variable = T_solid
    cylinder_emissivity = '${global_emissivity}'
    boundary_emissivity = '${global_emissivity}'
    boundary_radius = '${rpv_r}'
    cylinder_radius = '${fparse rpv_r + cavity_thickness}'
    Tinfinity = '${rccs_temperature}'
    boundary = 'rpv2rcav'
  []
  [rpv_radial_convection]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T_solid
    T_solid = T_solid
    T_bulk = '${rccs_temperature}'
    boundary = 'rpv2rcav'
    heat_transfer_coefficient = '${htc_cavities}'
    is_solid = true
  []
  [rpv_bottom_top]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T_solid
    T_solid = T_solid
    T_bulk = '${top_bottom_cav_temperature}'
    boundary = 'rtop rbottom'
    heat_transfer_coefficient = '${htc_cavities}'
    is_solid = true
  []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [power_density]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    block = '${heated_blocks}'
  []

  [vel_x]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    block = '${fluid_blocks}'
  []
  [vel_y]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    block = '${fluid_blocks}'
  []
[]

[AuxKernels]
  [power_density]
    type = ParsedAux
    variable = power_density
    expression = '${total_power} / volume'
    functor_names = 'volume'
    execute_on = 'INITIAL'
  []
  [vel_x]
    type = InterstitialFunctorAux
    variable = vel_x
    superficial_variable = superficial_vel_x
    phase = fluid
    porosity = porosity
  []
  [vel_y]
    type = InterstitialFunctorAux
    variable = vel_y
    superficial_variable = superficial_vel_y
    phase = fluid
    porosity = porosity
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================

[Functions]
  [pbed_superficial_vel_func]
    type = ParsedFunction
    expression = 'if(x < pbed_r & y > 1.851 & y < pbed_top, vel, 0.0)'
    symbol_names = 'pbed_r pbed_top vel'
    symbol_values = '${pbed_r} ${pbed_top} ${pbed_superficial_vel}'
  []
  [he_conductivity_fn]
    type = PiecewiseLinear
    x = '300 350 400 450 500 550 600 650 700 750 800 850 900 950
         1000 1050 1100 1150 1200 1250 1300 1350 1400 1450 1500'
    y = '1.57e-01 1.75e-01 1.92e-01
         2.08e-01 2.24e-01 2.40e-01 2.55e-01 2.69e-01 2.84e-01 2.98e-01 3.12e-01
         3.25e-01 3.38e-01 3.51e-01 3.64e-01 3.77e-01 3.89e-01 4.02e-01
         4.14e-01 4.26e-01 4.38e-01 4.50e-01 4.61e-01 4.73e-01 4.84e-01'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
    allow_imperfect_jacobians = true
  []
[]

[FunctorMaterials]
  # Fluid properties and non-dimensional numbers.
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    pressure = 'pressure'
    T_fluid = 'T_fluid'
    speed = 'speed'
    porosity = porosity
    characteristic_length = characteristic_length
    block = ${fluid_blocks}
    fp = fluid_properties_obj
  []

  # Porosity.
  [risers_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '0.22' # 18 channels and inlet structures (//).
    block = '${risers_blocks}'
  []
  [pbed_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '${pbed_porosity}'
    block = ' ${heated_blocks}'
  []
  [cavity_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '0.99' # Ideally 1.0 (//).
    block = '${fluid_only_blocks}'
  []
  [outchans_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '0.63' # Triangular lattice of 0.5cm radius channels and 1.7cm pitch (//).
    block = '${outchans_blocks}'
  []
  [outplen_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '0.40' # Triangular lattice of 4.75cm radius colums and 16.5cm pitch (//).
    block = '${outplen_blocks}'
  []
  [hotleg_blocks_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '0.07' # Cylindrical channel (//).
    block = '${hotleg_blocks}'
  []
  [all_other_porosity]
    type = ADGenericFunctorMaterial
    prop_names = 'porosity'
    prop_values = '-1' # Dummy value.
    block = '${solid_only_blocks} ${ref2barrel_gap} ${barrel2rpv_gap}'
  []

  # Characteristic Length.
  [pbed_hydraulic_diameter]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = '${pebble_diameter}'
    block = '${pbed_blocks}'
  []
  [risers_hydraulic_diameter]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = '0.17' # Diameter of the risers channels (m).
    block = '${risers_blocks} ${fluid_only_blocks}'
  []
  [outlet_chans_hydraulic_diameter]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = '0.01' # Diameter of the outlet channels (m).
    block = '${outchans_blocks}'
  []
  [outlet_plen_hydraulic_diameter]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = '0.25' # Hydraulic diameter of outlet plenum (m).
    block = '${outplen_blocks}'
  []
  [hotleg_hydraulic_diameter]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = '0.967' # Diameter of the hot leg (m).
    block = '${hotleg_blocks}'
  []

  # Solid properties.
  [full_density_graphite]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s cp_s k_s'
    prop_values = '1780 1697 26'
    block = '${ref_blocks} ${risers_blocks} ${outlet_blocks} ${heated_blocks}'
  []
  [core_barrel_steel]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s cp_s k_s'
    prop_values = '7800.0 540.0 17.0'
    block = '${barrel_blocks}'
  []
  [rpv_steel]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s cp_s k_s'
    prop_values = '7800.0 525.0 38.0'
    block = '${rpv_blocks}'
  []
  [he_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s  cp_s'
    prop_values = '6      5000'
    block = '${ref2barrel_gap} ${barrel2rpv_gap}'
  []
  [mod_cp_s]
    type = ADParsedFunctorMaterial
    expression = 'cp_s * ${heat_capacity_multiplier}'
    property_name = 'cp_s_mod'
    functor_symbols = 'cp_s'
    functor_names = 'cp_s'
    block = '${porous_blocks} ${solid_only_blocks} ${ref2barrel_gap} ${barrel2rpv_gap}'
  []

  # Drag coefficients.
  [pbed_drag_coefficient]
    type = FunctorKTADragCoefficients
    T_fluid = T_fluid
    T_solid = T_solid
    porosity = porosity
    block = '${pbed_blocks}'
    fp = fluid_properties_obj
  []
  [risers_drag_coefficients]
    type = FunctorChurchillDragCoefficients
    block = '${risers_blocks} ${fluid_only_blocks}'
  []
  [outchans_drag_coefficients]
    type = FunctorChurchillDragCoefficients
    multipliers = '1.0e+05 1.0 1.0e+05'
    block = '${outchans_blocks}'
  []
  [outlet_drag_coefficients]
    type = FunctorChurchillDragCoefficients
    block = '${outplen_blocks}'
  []
  [hotleg_drag_coefficients]
    type = FunctorChurchillDragCoefficients
    multipliers = '1.0 1.0e+05 1.0e+05'
    block = '${hotleg_blocks}'
  []

  # Heat transfer coefficients.
  [pbed_alpha]
    type = FunctorKTAPebbleBedHTC
    T_solid = T_solid
    T_fluid = T_fluid
    mu = mu
    porosity = porosity
    pressure = pressure
    block = '${pbed_blocks}'
    fp = fluid_properties_obj
  []
  [risers_blocks_alpha]
    type = FunctorDittusBoelterWallHTC
    C = '${fparse db_cnst * 23.5}'

    block = '${risers_blocks}'
  []
  [outchans_blocks_alpha]
    type = FunctorDittusBoelterWallHTC
    C = '${fparse db_cnst * 400}'
    block = '${outchans_blocks}'
  []
  [outplen_blocks_alpha]
    type = FunctorDittusBoelterWallHTC
    C = '${fparse db_cnst * 63.5}'
    block = '${outplen_blocks}'
  []
  [rename_wall_htc_to_alpha]
    type = ADGenericFunctorMaterial
    prop_values = 'wall_htc'
    prop_names = 'alpha'
    block = '${risers_blocks} ${outchans_blocks} ${outplen_blocks}'
  []
  [hotleg_blocks_alpha]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '0.0'
    block = '${hotleg_blocks}'
  []

  # Effective solid thermal conductivity.
  [pebble_effective_thermal_conductivity]
    type = FunctorPebbleBedKappaSolid
    T_solid = T_solid
    porosity = porosity
    solid_conduction = ZBS
    emissivity = 0.8
    infinite_porosity = '${pbed_porosity}'
    Youngs_modulus = 9e+9
    Poisson_ratio = 0.1360
    lattice_parameters = interpolation
    coordination_number = You
    wall_distance = bed_geometry # Requested by solid_conduction = ZBS
    block = '${pbed_blocks}'
  []
  [porous_blocks_solid_effective_conductivity]
    type = FunctorVolumeAverageKappaSolid
    porosity = porosity
    block = '${no_pbed_porous_blocks}'
  []
  [effective_solid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'kappa_s kappa_s kappa_s'
    block = '${pbed_blocks} ${no_pbed_porous_blocks}'
  []
  [effective_solid_thermal_conductivity_solid_only]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'k_s k_s k_s'
    block = '${solid_only_blocks}'
  []
  [effective_thermal_conductivity_refl_ref2barrel_gap]
    type = FunctorGapHeatTransferEffectiveThermalConductivity
    gap_direction = x
    temperature = T_solid
    gap_conductivity_function = he_conductivity_fn
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    radius_primary = 2.066
    radius_secondary = 2.098
    prop_name = effective_thermal_conductivity
    block = '${ref2barrel_gap}'
  []
  [effective_thermal_conductivity_barrel_rpv_gap]
    type = FunctorGapHeatTransferEffectiveThermalConductivity
    gap_direction = x
    temperature = T_solid
    gap_conductivity_function = he_conductivity_fn
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    radius_primary = 2.143
    radius_secondary = 2.215
    prop_name = effective_thermal_conductivity
    block = '${barrel2rpv_gap}'
  []

  # Effective fluid thermal conductivity.
  [pebble_bed_effective_fluid_thermal_conductivity]
    type = FunctorLinearPecletKappaFluid
    porosity = porosity
    block = '${pbed_blocks}'
  []
  [everywhere_else_effective_fluid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = '${no_pbed_porous_blocks} ${fluid_only_blocks}'
  []
[]

[UserObjects]
  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = '${pbed_top}'
    inner_radius = 0.0
    outer_radius = '${pbed_r}'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = l2

  # Scaling.
  automatic_scaling = true
  off_diagonals_in_auto_scaling = false
  compute_scaling_once = false

  # Tolerances.
  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-6
  nl_max_its = 15

  # Time step control.
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 2.5e-3
    cutback_factor = 0.5
    growth_factor = 2.00
    optimal_iterations = 8
  []

  # Steady state detection.
  steady_state_detection = true
  steady_state_tolerance = 1e-13
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  # General checks.
  [pp00_inlet_mfr]
    type = VolumetricFlowRate
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = rho
    boundary = inlet
    rhie_chow_user_object = pins_rhie_chow_interpolator
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pp01_outlet_mfr]
    type = VolumetricFlowRate
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = rho
    boundary = outlet
    rhie_chow_user_object = pins_rhie_chow_interpolator
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pp02_inlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = 'inlet'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pp03_total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = '${heated_blocks}'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pp04_T_oulet]
    type = SideAverageValue # Fix it with weighted thing
    variable = T_fluid
    boundary = 'outlet'
  []
  [pp05_rpv_temp]
    type = ElementAverageValue
    variable = T_solid
    block = '${rpv_blocks}'
  []
  [pp06_rpv_temp_max]
    type = ElementExtremeValue
    variable = T_solid
    block = '${rpv_blocks}'
  []

  [volume]
    type = VolumePostprocessor
    block = '${heated_blocks}'
    force_preaux = true
    execute_on = 'INITIAL'
    outputs = none
  []
[]

[Outputs]
  exodus = true
  csv = true
  execute_on = 'FINAL'
[]
