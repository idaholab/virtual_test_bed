# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Steady state HTR-PM model
# Created & modifed by Sebastian Schunert, Mustafa Jaradat, April 11, 2023
# Updated by Guillaume Giudicelli, June 15th 2026
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

# Hydraulic diameter -----------------------------------------------------------
D_H_bypass = 0.15                            # Hydraulic diameter of bypass
D_H_riser  = 0.1875                          # Hydraulic diameter of riser
D_H_top_reflector = 0.2                      # Hydraulic diameter of the top reflector
D_H_bottom_reflector = 0.2                   # Hydraulic diameter of the top reflector
D_H_top_cavity = 0.67                        # Hydraulic diameter of the top cavity

# Properties -------------------------------------------------------------------
global_emissivity                = 0.80      # All the materials have the same emissivity (//).
pebble_bed_porosity              = 0.39      # Pebble bed porosity (//).
fluid_channels_porosity          = 0.20      # 20% is assumed in regions where the He flows in graphite areas (//).
bypass_channel_porosity          = 0.32      # Porosity in the bypass channel (see engineering calc in spreadsheet)
riser_porosity                   = 0.32      # Porosity in the riser channel (see engineering calc in spreadsheet)
top_reflector_porosity           = 0.3       # Porosity of the top reflector
bottom_reflector_porosity        = 0.3       # Porosity of the bottom reflector

# Operating conditions ---------------------------------------------------------
mfr                              = 96.0      # Total reactor He mass flow rate (kg/s).
T_inlet                          = 523.15    # Helium inlet temperature (K).
p_outlet                         = 7.0e+6    # Reactor outlet pressure (Pa)
T_exterior                       = 300.0     # External temperature (K)
reference_power                  = 250e6     # Reference power (W)

# Heat transfer area per volume ------------------------------------------------
C_DB = 0.023                                 # original Dittus Boelter constant for areal htc; modified by ApV
ApV_bypass = 8.521                           # heat transfer area per volume bypass
ApV_riser  = 6.927                           # heat transfer area per volume riser
ApV_top_reflector = 5.737                    # heat transfer area per volume top reflector
ApV_bottom_reflector = 5.737                 # heat transfer area per volume bottom reflector

# volumetric heat transfer coefficient between solid
# fluid and solid in the fluid/solid regions except the
# bed; currently applied in top_reflector bottom_reflector hot_plenum cold_plenum
# TODO: use correlations here
alpha_fluid_solid = 5e3

## block definitions
# fluid blocks define fluid vars and solve for them
fluid_blocks = '1 2 3 4 5 6 61 71'
# solid blocks define T_solid and solve for it
solid_blocks = '1 2 3 5 6 7 8 10 12 61 71 9 11'

# friction scaling
scaling = 1  #0.05

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

  coord_type = RZ
[]

# ==============================================================================
# Physics Equations
# ==============================================================================

[Physics]
  [NavierStokes]
    [Flow/all]
      # basic settings
      block = ${fluid_blocks}
      compressibility = 'weakly-compressible'
      gravity = '0.0 -9.81 0.0'

      # Porous treatement
      porous_medium_treatment = true
      friction_types = 'darcy forchheimer'
      friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
      consistent_scaling = ${scaling}
      porosity_smoothing_layers = 0
      use_friction_correction = true

      # fluid properties
      density = 'rho'
      dynamic_viscosity = 'mu'

      # initial conditions
      initial_velocity = '1e-6 1e-6 0'
      initial_pressure = '${p_outlet}'

      # boundary conditions
      inlet_boundaries = 'reactor_inlet'
      momentum_inlet_types = 'flux-mass'
      flux_inlet_pps = 'set_inlet_mfr'
      flux_inlet_directions = '0 1 0'

      outlet_boundaries = 'reactor_outlet'
      momentum_outlet_types = 'fixed-pressure'
      pressure_functors = '${p_outlet}'

      wall_boundaries =      'pbed_inner pbed_outer hot_plenum_walls cold_plenum_walls riser_walls bypass_wall'
      momentum_wall_types =  'symmetry   slip       slip             slip              slip        slip'

      # numerical scheme
      pressure_face_interpolation = average
      momentum_advection_interpolation = upwind
      mass_advection_interpolation = upwind
      # prevents solution jump on future restarts
      time_derivative_contributes_to_RC_coefficients = false
    []
    [FluidHeatTransfer/all]
      block = ${fluid_blocks}

      # numerical scheme
      energy_advection_interpolation = upwind
      system_names = 'nl0'

      # convective heat transfer
      ambient_convection_blocks = '1 2 3 5 6 61 71'
      ambient_convection_alpha = 'alpha'
      ambient_temperature = 'T_solid'

      # fluid properties
      thermal_conductivity = 'kappa'
      specific_heat = 'cp'

      # initial conditions
      initial_temperature = '${T_inlet}'

      # boundary conditions
      # see Flow physics for list of boundaries
      energy_inlet_types = 'flux-mass'
      energy_inlet_functors = '${T_inlet}'

      energy_wall_types =    'heatflux   heatflux   heatflux         heatflux          heatflux    heatflux'
      energy_wall_functors = '0          0          0                0                 0           0'
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
    Tinfinity = ${T_exterior}
    boundary_radius = 3.0
    boundary_emissivity = ${global_emissivity}
    cylinder_radius = 4.0
    cylinder_emissivity = ${global_emissivity}
  []
  [convection]
    type = FVThermalResistanceBC
    variable = T_solid
    htc = natural_htc
    T_ambient = ${T_exterior}
    emissivity = 0
    thermal_conductivities = '0.025'
    conduction_thicknesses = '1'
    boundary = right
  []
[]

# ==============================================================================
# Operating conditions and ramps to steady state
# ==============================================================================

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    initial_condition = ${fparse reference_power / 77.754418176347}
    # volume from postprocessing
    block = 'pebble_bed'
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

[Postprocessors]
  [set_inlet_mfr]
    type = FunctionValuePostprocessor
    function = 'mfr_fn'
    execute_on = TIMESTEP_BEGIN
  []
[]

# ==============================================================================
# Materials and closure models
# ==============================================================================

!include htr-pm-flow-fv_materials.i

# ==============================================================================
# Solver parameters
# ==============================================================================

[Executioner]
  type = Transient

  # solver parameters
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart -pc_factor_shift_type -mat_mumps_icntl_20'
  petsc_options_value = 'lu       mumps                         100                 NONZERO              0'
  automatic_scaling = true
  nl_abs_tol = 1e-5
  line_search = l2
  nl_max_its = 50

  # time stepping
  end_time = 1e6
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.5
    optimal_iterations = 9
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []
[]

# ==============================================================================
# Outputs and postprocessing
# ==============================================================================

[Outputs]
  csv = true
  exodus = true
  [console]
    type = Console
    hide = 'area_pp_reactor_inlet set_inlet_mfr'
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

!include htr-pm-flow-fv_postprocessing.i
