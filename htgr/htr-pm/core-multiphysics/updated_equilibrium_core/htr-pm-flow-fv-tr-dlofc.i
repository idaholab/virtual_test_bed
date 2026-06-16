# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# DLOFC HTR-PM model
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
global_emissivity                = 0.80      # All the materials has the same emissivity (//).
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
  [file]
    type = FileMeshGenerator
    # for single-physics simulation restart (as the parent app)
    # file = 'htr-pm-flow-fv-ss_out.e'
    # for multiphysics simulation restart (as a multiapp)
    file = 'htr_pm_griffin_ss_out_flow0.e'
    use_for_exodus_restart = true
  []
  coord_type = RZ
[]

# ==============================================================================
# Physics Equations
# ==============================================================================

[Physics]
  [NavierStokes]
    [Flow/all]
      # restart
      initialize_variables_from_mesh_file = true

      # basic settings
      block = ${fluid_blocks}
      compressibility = 'weakly-compressible'
      gravity = '0.0 -9.81 0.0'

      # Variables, defined below for the Exodus restart
      velocity_variable = 'superficial_vel_x superficial_vel_y'
      pressure_variable = 'pressure'

      # Porous treatement
      porous_medium_treatment = true
      friction_types = 'darcy forchheimer'
      friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
      use_friction_correction = true
      consistent_scaling = ${scaling}
      porosity_smoothing_layers = 0

      # fluid properties
      density = 'rho'
      dynamic_viscosity = 'mu'

      # boundary conditions
      inlet_boundaries = 'reactor_inlet'
      momentum_inlet_types = 'flux-mass'
      flux_inlet_pps = 'set_inlet_mfr'
      flux_inlet_directions = '0 1 0'

      outlet_boundaries = 'reactor_outlet'
      momentum_outlet_types = 'fixed-pressure'
      pressure_functors = 'pressure_out_fn'

      wall_boundaries =      'pbed_inner pbed_outer hot_plenum_walls cold_plenum_walls riser_walls bypass_wall'
      momentum_wall_types =  'symmetry   slip       slip             slip              slip        slip'

      # numerical parameters
      pressure_face_interpolation = average
      momentum_advection_interpolation = upwind
      mass_advection_interpolation = upwind
      # prevents solution jump on future restarts
      time_derivative_contributes_to_RC_coefficients = false
    []
    [FluidHeatTransfer/all]
      # restart
      initialize_variables_from_mesh_file = true

      fluid_temperature_variable = 'T_fluid'
      block = ${fluid_blocks}

      # material properties
      thermal_conductivity = 'kappa'
      specific_heat = 'cp'

      # convective heat transfer
      ambient_convection_blocks = '1 2 3 5 6 61 71'
      ambient_convection_alpha = 'alpha'
      ambient_temperature = 'T_solid'

      # boundary conditions
      # see Flow physics for list of boundaries
      energy_inlet_types = 'flux-mass'
      energy_inlet_functors = '${T_inlet}'

      energy_wall_types =    'heatflux   heatflux   heatflux         heatflux          heatflux    heatflux'
      energy_wall_functors = '0          0          0                0                 0           0'

      # numerical parameters
      energy_advection_interpolation = upwind
      energy_scaling = 5e-6
      coupled_flow_physics = 'all'
      system_names = 'nl0'
    []
  []
[]

[Variables]
  [T_solid]
    type = INSFVEnergyVariable
    block = '${solid_blocks}'
    # restart from exodus
    initial_from_file_var = T_solid
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
# DLOFC transient specifications
# ==============================================================================

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    block = 'pebble_bed'
    # restart from exodus
    initial_from_file_var = power_density
    initial_from_file_timestep = LATEST
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
    x = '    0    1       13'
    y = ' ${mfr}  ${mfr}  0.0'
  []
  [pressure_out_fn]
    type = PiecewiseLinear
    x = '  0          1           13'
    y = '${p_outlet}  ${p_outlet} 101325.0'
  []
  [dt_max_fn]
    type = PiecewiseLinear
    x = '-10 0 16 30 1000 5000 20000 100000 200000 500000'
    y = '  1 1 1  1  50   100  200   400   400   500'
  []
[]

[Postprocessors]
  [set_inlet_mfr]
    type = FunctionValuePostprocessor
    function = 'mfr_fn'
    execute_on = TIMESTEP_BEGIN
  []
  [dt_max_pp]
    type = FunctionValuePostprocessor
    function = dt_max_fn
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
  start_time = 0
  end_time = 5.0e+05
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    timestep_limiting_postprocessor = dt_max_pp
    optimal_iterations = 10
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
    # hide some trivial postprocessors, and the balance which we don't run long
    # enough to establish
    hide = 'area_pp_reactor_inlet set_inlet_mfr total_balance_percent advection_energy_balance'
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

!include htr-pm-flow-fv_postprocessing.i
