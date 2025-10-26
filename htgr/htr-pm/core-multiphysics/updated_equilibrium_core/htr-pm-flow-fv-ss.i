# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Steady state HTR-PM model Created & modifed by Sebastian Schunert, Mustafa Jaradat, April 11, 2023
# ==============================================================================
# - htr-pm-FV: reference plant design based on 250MW HTR-PM plant.
# - FV using the new FV action
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------

# Geometry ---------------------------------------------------------------------
pebble_diameter               = 0.06   # Diameter of the pebbles (m).
geometric_tolerance           = 1e-3   # Geometric tolerance to generate the side-sets (m).
pbed_top                      = 14.228 # TAF (m).
pbed_bottom                   = 3.228  # Bottom of bed (m).
pbed_r                        = 1.500  # Pebble Bed radius (m).

# Properties -------------------------------------------------------------------
global_emissivity                = 0.80      # All the materials has the same emissivity (//).
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
  type = MeshGeneratorMesh
  block_id = '1 2 3 4 5 6 7 8 10 12 61 71 9 11'
  block_name = 'pebble_bed
                top_reflector
                bottom_reflector
                top_cavity
                hot_plenum
                cold_plenum
                side_reflector
                carbon_brick
                core_barrel
                rpv
                riser
                bypass
                refl_barrel_gap
                barrel_rpv_gap'
  uniform_refine = 1

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = ' 0.250 0.250 0.250 0.250 0.250 0.250
           0.010 0.050
           0.130
           0.080 0.080 0.080 0.200 0.120 0.010 0.240
           0.150 0.040 0.160 0.150 '
    ix = ' 1 1 1 1 1 1
           1 1
           1
           1 1 1 2 1 1 1
           1 1 1 1 '

    dy = ' 0.400 0.400 0.100 0.100
           0.800 0.300 0.200 0.300 0.216 0.412
           0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
           0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550 0.550
           0.760 0.712 0.300
           0.400 0.400 '
    iy = ' 1 1 1 1
           2 1 1 1 1 1
           1 1 1 1 1 1 1 1 1 1
           1 1 1 1 1 1 1 1 1 1
           2 2 1
           1 1 '

    subdomain_id = ' 8  8 8 8 8 8  8 8 8  8 8 8 8  8 8 8  9  10  11  12
                     8  8 8 8 8 8  8 8 8  8 8 8 8  8 8 8  9  10  11  12
                     7  7 7 7 7 7  7 7 7  7 7 7 7  7 8 8  9  10  11  12
                     7  7 7 7 7 7  7 7 7  7 7 7 7  7 8 8  9  10  11  12
                     5  5 5 5 5 5  5 5 5  7 7 7 61 7 8 8  9  10  11  12
                     3  3 3 3 3 3  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     3  3 3 3 3 3  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     3  3 3 3 3 3  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     3  3 3 3 3 3  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     3  3 3 3 3 3  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     1  1 1 1 1 1  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     4  4 4 4 4 4  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     4  2 2 2 2 2  7 7 71 7 7 7 61 7 8 8  9  10  11  12
                     6  6 6 6 6 6  6 6 6  6 6 6 6  7 8 8  9  10  11  12
                     7  7 7 7 7 7  7 7 7  7 7 7 7  7 8 8  9  10  11  12
                     8  8 8 8 8 8  8 8 8  8 8 8 8  8 8 8  9  10  11  12 '
  []

  # Side sets for gap conductance model.
  [reflector_barrel_gap_inner]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 8
    paired_block = 9
    input = cartesian_mesh
    new_boundary = reflector_barrel_gap_inner
  []
  [reflector_barrel_gap_outer]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 10
    paired_block = 9
    input = reflector_barrel_gap_inner
    new_boundary = reflector_barrel_gap_outer
  []
  [barrel_rpv_gap_inner]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 10
    paired_block = 11
    input = reflector_barrel_gap_outer
    new_boundary = barrel_rpv_gap_inner
  []
  [barrel_rpv_gap_outer]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 12
    paired_block = 11
    input = barrel_rpv_gap_inner
    new_boundary = barrel_rpv_gap_outer
  []

  # Side sets for inflow and outflow conditions.
  [reactor_inlet]
    type = ParsedGenerateSideset
    included_subdomains = '61'
    combinatorial_geometry = 'abs(y-1) < 1e-3'
    fixed_normal = true
    normal = '0 -1 0'
    input = barrel_rpv_gap_outer
    new_sideset_name = reactor_inlet
  []
  [reactor_outlet]
    type = SideSetsAroundSubdomainGenerator
    block = '5'
    fixed_normal = true
    normal = '1 0 0'
    input = reactor_inlet
    new_boundary = reactor_outlet
  []
  [riser_walls]
    type = ParsedGenerateSideset
    included_subdomains = '61'
    included_neighbors = '7'
    combinatorial_geometry = 'y > 1 + 1e-3'
    input = reactor_outlet
    new_sideset_name = riser_walls
  []

  # Side sets for wall boundaries.
  [cold_plenum_walls]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '7'
    input = riser_walls
    new_boundary = cold_plenum_walls
  []
  [hot_plenum_walls]
    type = ParsedGenerateSideset
    included_subdomains = 5
    included_neighbors = 7
    combinatorial_geometry = 'x < 1.69'
    input = cold_plenum_walls
    new_sideset_name = hot_plenum_walls
  []
  [bypass_walls]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '71'
    paired_block = '7'
    input = hot_plenum_walls
    new_boundary = 'bypass_wall'
  []
  [pbed_inner]
    type = ParsedGenerateSideset
    included_subdomains = '1 2 3 4 5 6'
    combinatorial_geometry = '( abs(x - 0.000) < ${geometric_tolerance} &
                              y > ${fparse 1.000 - geometric_tolerance} &
                              y < ${fparse 16.00 + geometric_tolerance} )'
    input = bypass_walls
    new_sideset_name = pbed_inner
  []
  [pbed_outer]
    type = ParsedGenerateSideset
    included_subdomains = '1 2 3 4'
    combinatorial_geometry = '( abs(x - ${pbed_r}) < ${geometric_tolerance} &
                              y > ${fparse 1.800 - geometric_tolerance} &
                              y < ${fparse 15.70 + geometric_tolerance} ) '
    input = pbed_inner
    new_sideset_name = pbed_outer
  []
  [bypass_hot_plenum_interface]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '71'
    paired_block = '5'
    new_boundary = 'bypass_hot_plenum_interface'
    input = pbed_outer
  []
[]

[Problem]
  coord_type = RZ
  kernel_coverage_check = false
[]

[Modules]
  [NavierStokesFV]
    # basic settings
    block = ${fluid_blocks}
    compressibility = 'weakly-compressible'
    add_energy_equation = true
    gravity = '0.0 -9.81 0.0'

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

    # initial conditions
    initial_velocity = '1e-6 1e-6 0'
    initial_pressure = '${p_outlet}'
    initial_temperature = '${T_inlet}'

    # boundary conditions
    inlet_boundaries = 'reactor_inlet'
    momentum_inlet_types = 'flux-mass'
    flux_inlet_pps = 'set_inlet_mfr'
    flux_inlet_directions = '0 1 0'
    energy_inlet_types = 'flux-mass'
    energy_inlet_function = '${T_inlet}'

    outlet_boundaries = 'reactor_outlet'
    momentum_outlet_types = 'fixed-pressure'
    pressure_function = '${p_outlet}'

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
    initial_condition = ${T_inlet}
    block = '${solid_blocks}'
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
#    type = FVAnisotropicDiffusion
    type = PINSFVEnergyAnisotropicDiffusion
    variable = T_solid
    kappa = 'effective_thermal_conductivity'
    effective_diffusivity = true
    # porosity won't be used because effective_diffusivity = true
    # so set it to 1
    porosity = 1
#    coeff = 'eff_solid_conductivity'
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
    Tinfinity = 300
    boundary_radius = 3.0
    boundary_emissivity = ${global_emissivity}
    cylinder_radius = 4.0
    cylinder_emissivity = ${global_emissivity}
  []
  [convection]
    type = FVThermalResistanceBC
    variable = T_solid
    htc = natural_htc
    T_ambient = 300
    emissivity = 0
    thermal_conductivities = '0.025'
    conduction_thicknesses = '1'
    boundary = right
  []
[]

[Functions]
  [mu_ramp_fn]
    type = PiecewiseLinear
    x = '0  1   10'
    y = '10 1.5 1'
  []
  [mfr_fn]
    type = PiecewiseLinear
    x = '0 1'
    y = '0 ${mfr}'
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
    initial_condition = 3.215251376e+6
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
    execute_on = TIMESTEP_BEGIN
  []

  [outlet_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = reactor_outlet
  []

  [bypass_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = bypass_hot_plenum_interface
  []

  inactive = 'pressure_inlet pressure_outlet core_delta_p T_fluid_inlet T_fluid_outlet core_delta_T'
  [pressure_inlet]
    type = SideAverageValue
    boundary = 'reactor_inlet'
    variable = pressure
    execute_on = 'TIMESTEP_END'
  []
  [pressure_outlet]
    type = SideAverageValue
    boundary = 'reactor_outlet'
    variable = pressure
    execute_on = 'TIMESTEP_END'
  []
  [core_delta_p]
    type = ParsedPostprocessor
    function = 'pressure_inlet - pressure_outlet'
    pp_names = 'pressure_inlet pressure_outlet'
    execute_on = 'TIMESTEP_END'
  []
  
  [T_fluid_inlet]
    type = SideAverageValue
    boundary = 'reactor_inlet'
    variable = T_fluid
    execute_on = 'TIMESTEP_END'
  []
  [T_fluid_outlet]
    type = SideAverageValue
    boundary = 'reactor_outlet'
    variable = T_fluid
    execute_on = 'TIMESTEP_END'
  []
  [core_delta_T]
    type = ParsedPostprocessor
    function = 'T_fluid_outlet - T_fluid_inlet'
    pp_names = 'T_fluid_outlet T_fluid_inlet'
    execute_on = 'TIMESTEP_END'
  []
  
  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'pebble_bed'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [core_volume]
    type = VolumePostprocessor
    block = 'pebble_bed'
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
    emissivity = ${global_emissivity}
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
	  multipliers  = ' 1.0e+05  1.0  1.0e+05 '
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
    dt = 1.0
    optimal_iterations = 9
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []
  end_time = 1e4
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
