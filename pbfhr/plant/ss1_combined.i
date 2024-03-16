# ==============================================================================
# Model description
# Application : Pronghorn
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 10, 2020
# Author(s): Dr. Guillaume Giudicelli, Dr. Paolo Balestra, Dr. April Novak
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ------------------------------------------------------------------------------
#
# NOTE: This model is deprecated and is scheduled for removal from the VTB
#
# ==============================================================================
# - Coupled fluid-solid thermal hydraulics model of the Mk1-FHR
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Multiscale Core Thermal Hydraulics Analysis of the Pebble Bed Fluoride
#     Salt Cooled High Temperature Reactor (PB-FHR), A. Novak et al.
# [2] Technical Description of the “Mark 1” Pebble-Bed Fluoride-Salt-Cooled
#     High-Temperature Reactor (PB-FHR) Power Plant, UC Berkeley report 14-002
# [3] Molten salts database for energy applications, Serrano-Lopez et al.
#     https://arxiv.org/pdf/1307.7343.pdf
# [4] Heat Transfer Salts for Nuclear Reactor Systems - chemistry control,
#     corrosion mitigation and modeling, CFP-10-100, Anderson et al.
#     https://neup.inl.gov/SiteAssets/Final%20%20Reports/FY%202010/
#     10-905%20NEUP%20Final%20Report.pdf
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------

blocks_pebbles = '3 4'
blocks_fluid = '3 4 5 6'
blocks_solid = '1 2 6 7 8 9 10'

# Material compositions
UO2_phase_fraction = 1.20427291e-01
buffer_phase_fraction = 2.86014816e-01
ipyc_phase_fraction = 1.59496539e-01
sic_phase_fraction = 1.96561801e-01
opyc_phase_fraction = 2.37499553e-01
TRISO_phase_fraction = 3.09266232e-01
core_phase_fraction = 5.12000000e-01
fuel_matrix_phase_fraction = 3.01037037e-01
shell_phase_fraction = 1.86962963e-01

# FLiBe properties #TODO: Rely only on PronghornFluidProps
fluid_mu = 7.5e-3 # Pa.s at 900K [3]
# k_fluid =  1.1     # suggested constant [3]
# cp_fluid = 2385    # suggested constant [3]
rho_fluid = 1970.0 # kg/m3 at 900K [3]
alpha_b = 2e-4 # /K from [4]

# Graphite properties
heat_capacity_multiplier = 1e0 # >1 gets faster to steady state
solid_rho = 1780.0
# solid_k = 26.0
solid_cp = '${fparse 1697.0*heat_capacity_multiplier}'

# Core geometry
pebble_diameter = 0.03
bed_porosity = 0.4
IR_porosity = 0
OR_porosity = 0.1123
plenum_porosity = 0.5
model_inlet_rin = 0.45
model_inlet_rout = 0.8574
# model_vol        = 10.4
model_inlet_area = '${fparse 3.14159265 * (model_inlet_rout * model_inlet_rout - model_inlet_rin * model_inlet_rin)}'

# The convention for friction factors changed
darcy_conversion_plenum = '${fparse rho_fluid / plenum_porosity / fluid_mu}'
# The porosity simplfies out from the previous definition of the coefficients
darcy_conversion_or = '${fparse rho_fluid / fluid_mu}'
forchheimer_partial_conversion = 2 # divide further by speed

# Outer reflector drag parameters
# TODO: tune using CFD
# TODO: verify current values (imported from [1])
Ah = '${fparse 1337.76 * darcy_conversion_or}'
Bh = '${fparse 2.58 * forchheimer_partial_conversion}'
Av = '${fparse 599.30 * darcy_conversion_or}'
Bv = '${fparse 0.95 * forchheimer_partial_conversion}'
Dh = 0.02582
Dv = 0.02006

# Plenum drag parameters. The core hot legs cannot be represented in 2D RZ
# accurately, so this should be tuned to obtain the desired mass flow rates
plenum_friction = '${fparse 0.5 * darcy_conversion_plenum}'

# Operating parameters
# mfr = 976.0            # kg/s, from [2]
# total_power = 236.0e6  # W, from [2]
inlet_T_fluid = 873.15 # K, from [2]
# inlet_vel_y_ini = ${fparse mfr / model_inlet_area / rho_fluid} # superficial
# power_density = ${fparse total_power / model_vol / 258 * 236}  # adjusted using power pp
# outlet_pressure_val = 2e5

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = RZ
  # Mesh should be fairly orthogonal for finite volume fluid flow
  # If you are running this input file for the first time, run core_with_reflectors.py
  # in pbfhr/meshes using Cubit to generate the mesh
  # Modify the parameters (mesh size, refinement areas) for each application
  # neutronics, thermal hydraulics and fuel performance
  uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    file = '../meshes/core_pronghorn.e'
  []
  [barrel]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 6
    paired_block = 7
    input = fmg
    new_boundary = 'barrel_wall'
  []
  [OR_inlet]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y) < 1e-10'
    new_sideset_name = 'OR_horizontal_bottom'
    included_subdomains = '6'
    input = barrel
  []
  [OR_outlet]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y - 5.3125) < 1e-10'
    new_sideset_name = 'OR_horizontal_top'
    included_subdomains = '6'
    input = OR_inlet
  []
  [add_bed_right]
    type = SideSetsBetweenSubdomainsGenerator
    input = OR_outlet
    new_boundary = 'bed_right'
    primary_block = '6'
    paired_block = '4 5'
  []
  [remove_bad_sideset]
    type = BoundaryDeletionGenerator
    input = add_bed_right
    boundary_names = bed_left
  []
  [add_sideset_again]
    type = SideSetsBetweenSubdomainsGenerator
    input = remove_bad_sideset
    new_boundary = 'bed_left'
    primary_block = '3'
    paired_block = '1 2'
  []
[]

[Problem]
  # We use a restart file to heat up the reflector beforehand, to get SAM and Pgh in agreement
  restart_file_base = ss1_combined_initial_checkpoint_cp/LATEST
  force_restart = true
[]

[GlobalParams]
  rho = 'rho'
  porosity = porosity_viz
  characteristic_length = 0.03
  pebble_diameter = ${pebble_diameter}
  speed = 'speed'

  fp = fp
  T_solid = T_solid
  T_fluid = T_fluid
  pressure = pressure

  vel_x = 'superficial_vel_x'
  vel_y = 'superficial_vel_y'

  fv = true
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================

[Problem]
  kernel_coverage_check = false
[]

[Modules]
  [NavierStokesFV]
    # General parameters
    compressibility = 'incompressible'
    porous_medium_treatment = true
    add_energy_equation = true
    boussinesq_approximation = true
    block = ${blocks_fluid}

    # Variables
    velocity_variable = 'superficial_vel_x superficial_vel_y'
    pressure_variable = 'pressure'
    fluid_temperature_variable = 'T_fluid'

    # Material properties
    density = ${rho_fluid}
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'kappa'
    specific_heat = 'cp'
    thermal_expansion = 'alpha_b'
    porosity = 'porosity'

    # Boussinesq parameters
    gravity = '0 -9.81 0'
    ref_temperature = ${inlet_T_fluid}

    # Wall boundary conditions
    wall_boundaries = 'bed_left barrel_wall'
    momentum_wall_types = 'slip slip'
    energy_wall_types = 'heatflux heatflux'
    energy_wall_function = '0 0'

    # Inlet boundary conditions
    inlet_boundaries = 'bed_horizontal_bottom OR_horizontal_bottom'
    momentum_inlet_types = 'fixed-velocity fixed-velocity'
    momentum_inlet_function = '0 inlet_vel_y_fun; 0 0'
    energy_inlet_types = 'fixed-temperature heatflux'
    energy_inlet_function = 'T_inlet_fun 0'
    # so the flux BCs have to be used consistently across all equations

    # Outlet boundary conditions
    outlet_boundaries = 'bed_horizontal_top plenum_top OR_horizontal_top'
    momentum_outlet_types = 'fixed-pressure fixed-pressure fixed-pressure'
    pressure_function = 'pressure_out_fun pressure_out_fun pressure_out_fun'

    # Porous flow parameters
    ambient_convection_blocks = ${blocks_pebbles}
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'

    # Friction in porous media
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'

    # Numerical scheme
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    energy_advection_interpolation = 'upwind'
  []
[]

[Variables]
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
  []
  [pressure]
    type = INSFVPressureVariable
    block = ${blocks_fluid}
  []
  [T_fluid]
    type = INSFVEnergyVariable
    block = ${blocks_fluid}
  []
  [T_solid]
    type = INSFVEnergyVariable
  []
[]

[FVKernels]
  # Solid Energy equation.
  [temp_solid_time_core]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    cp = 'cp_s'
    rho = ${solid_rho}
    is_solid = true
    block = ${blocks_fluid}
  []
  [temp_solid_time]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    cp = 'cp_s'
    rho = 'rho_s'
    porosity = 0
    is_solid = true
    block = ${blocks_solid}
  []
  [temp_solid_conduction_core]
    type = FVDiffusion
    variable = T_solid
    coeff = 'kappa_s'
    block = ${blocks_fluid}
    # For backwards compatibility of testing. Please use harmonic (default)
    coeff_interp_method = 'average'
  []
  [temp_solid_conduction]
    type = FVDiffusion
    variable = T_solid
    coeff = 'k_s'
    block = ${blocks_solid}
    # For backwards compatibility of testing. Please use harmonic (default)
    coeff_interp_method = 'average'
  []
  [temp_solid_source]
    type = FVCoupledForce
    variable = T_solid
    v = power_distribution
    block = '3'
  []
  [temp_fluid_to_solid]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    is_solid = true
    h_solid_fluid = 'alpha'
    block = ${blocks_fluid}
  []
[]

[FVInterfaceKernels]
  [diffusion_interface]
    type = FVDiffusionInterface
    boundary = 'bed_left'
    subdomain1 = '3 4 5'
    subdomain2 = '1 2 6'
    coeff1 = 'kappa_s'
    coeff2 = 'k_s'
    variable1 = 'T_solid'
    variable2 = 'T_solid'
    # For backwards compatibility of testing. Please use harmonic (default)
    coeff_interp_method = 'average'
  []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [power_distribution]
    type = MooseVariableFVReal
    block = '3'
  []
  [porosity_viz]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
[]

[AuxKernels]
  [eps]
    type = FunctorAux
    variable = porosity_viz
    functor = porosity
    block = ${blocks_fluid}
    execute_on = 'INITIAL'
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
  # No need for initial conditions for a restart simulation
[]

[Functions]
  # Convert postprocessor inputs to functions
  [inlet_vel_y_fun]
    type = ParsedFunction
    expression = 'inlet_vel_y_pp'
    symbol_names = 'inlet_vel_y_pp'
    symbol_values = 'inlet_vel_y_pp'
  []
  [pressure_out_fun]
    type = ParsedFunction
    expression = 'outlet_pressure'
    symbol_names = 'outlet_pressure'
    symbol_values = 'outlet_pressure'
  []
  [T_inlet_fun]
    type = ParsedFunction
    expression = 'inlet_temp_fluid'
    symbol_names = 'inlet_temp_fluid'
    symbol_values = 'inlet_temp_fluid'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[FVBCs]
  [outer]
    type = FVDirichletBC
    variable = T_solid
    boundary = 'brick_surface'
    value = '${fparse 35 + 273.15}'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fp]
    type = FlibeFluidProperties
  []
[]

[FunctorMaterials]
  # solid material properties
  [solid_fuel_pebbles]
    type = PronghornSolidFunctorMaterialPT
    solid = pebble
    block = '3'
  []
  [solid_blanket_pebbles]
    type = PronghornSolidFunctorMaterialPT
    solid = graphite
    block = '4'
  []
  [plenum_and_OR]
    type = PronghornSolidFunctorMaterialPT
    solid = graphite
    block = '5 6 8'
  []
  [IR]
    type = PronghornSolidFunctorMaterialPT
    solid = inner_reflector
    block = '1 2'
  []
  [barrel_and_vessel]
    type = PronghornSolidFunctorMaterialPT
    solid = stainless_steel
    block = '7 9'
  []
  [firebrick_properties]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s         cp_s        k_s'
    prop_values = '${solid_rho} ${solid_cp} 0.26'
    block = '10'
  []

  # FLUID
  [alpha_boussinesq]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha_b rho'
    prop_values = '${alpha_b} ${rho_fluid}'
    block = ${blocks_fluid}
    define_dot_functors = false
  []
  [fluidprops]
    type = GeneralFunctorFluidProps
    block = ${blocks_fluid}
    mu_rampdown = 1
  []

  # closures in the pebble bed
  [alpha]
    type = FunctorWakaoPebbleBedHTC
    block = ${blocks_pebbles}
  []
  [drag]
    type = FunctorKTADragCoefficients
    block = ${blocks_pebbles}
  []
  [kappa]
    type = FunctorLinearPecletKappaFluid
    block = ${blocks_pebbles}
  []
  [kappa_s]
    type = FunctorPebbleBedKappaSolid
    emissivity = 0.8
    Youngs_modulus = 9e9
    Poisson_ratio = 0.136
    wall_distance = wall_dist
    block = ${blocks_pebbles}
    T_solid = T_solid
    acceleration = '0 -9.81 0'
  []

  # closures in the outer reflector and the plenum
  [Fh]
    type = ADParsedFunctorMaterial
    property_name = Fh
    expression = 'Bh / Dh / speed'
    functor_symbols = 'Bh Dh speed'
    functor_names = '${Bh} ${Dh} speed'
  []
  [Fv]
    type = ADParsedFunctorMaterial
    property_name = Fv
    expression = 'Bv / Dv / speed'
    functor_symbols = 'Bv Dv speed'
    functor_names = '${Bv} ${Dv} speed'
  []
  [drag_OR]
    type = FunctorAnisotropicFunctorDragCoefficients
    Darcy_coefficient = '${fparse Ah / Dh / Dh} ${fparse Av / Dv / Dv} ${fparse Av / Dv / Dv}'
    Forchheimer_coefficient = 'Fh Fv Fv'
    block = '6'
  []
  [drag_plenum]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'Darcy_coefficient Forchheimer_coefficient'
    prop_values = '${plenum_friction} ${plenum_friction} ${plenum_friction}
                   0 0 0'
    block = '5'
  []
  [alpha_OR_plenum]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '0.0'
    block = '5 6'
  []
  [kappa_OR_plenum]
    type = FunctorKappaFluid
    block = '5 6'
  []
  [kappa_s_OR_plenum]
    type = FunctorVolumeAverageKappaSolid
    block = '5 6'
  []

  # porosity
  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'porosity'
    subdomain_to_prop_value = '3 ${bed_porosity}
                               4 ${bed_porosity}
                               5 ${plenum_porosity}
                               6 ${OR_porosity}
                               7 ${OR_porosity}' # !!!
  []
[]

[UserObjects]
  [graphite]
    type = FunctionSolidProperties
    rho_s = 1780
    cp_s = '${fparse 1800.0 * heat_capacity_multiplier}'
    k_s = 26.0
  []
  [pebble_graphite]
    type = FunctionSolidProperties
    rho_s = 1600.0
    cp_s = 1800.0
    k_s = 15.0
  []
  [pebble_core]
    type = FunctionSolidProperties
    rho_s = 1450.0
    cp_s = 1800.0
    k_s = 15.0
  []
  [UO2]
    type = FunctionSolidProperties
    rho_s = 11000.0
    cp_s = 400.0
    k_s = 3.5
  []
  [pyc]
    type = PyroliticGraphite # (constant)
  []
  [buffer]
    type = PorousGraphite # (constant)
  []
  [SiC]
    type = FunctionSolidProperties
    rho_s = 3180.0
    cp_s = 1300.0
    k_s = 13.9
  []
  [TRISO]
    type = CompositeSolidProperties
    materials = 'UO2 buffer pyc SiC pyc'
    fractions = '${UO2_phase_fraction} ${buffer_phase_fraction} ${ipyc_phase_fraction} ${sic_phase_fraction} ${opyc_phase_fraction}'
  []
  [fuel_matrix]
    type = CompositeSolidProperties
    materials = 'TRISO pebble_graphite'
    fractions = '${TRISO_phase_fraction} ${fparse 1.0 - TRISO_phase_fraction}'
    k_mixing = 'chiew'
  []
  [pebble]
    type = CompositeSolidProperties
    materials = 'pebble_core fuel_matrix pebble_graphite'
    fractions = '${core_phase_fraction} ${fuel_matrix_phase_fraction} ${shell_phase_fraction}'
  []
  [stainless_steel]
    type = StainlessSteel
  []
  [solid_flibe]
    type = FunctionSolidProperties
    rho_s = 1986.62668
    cp_s = 2416.0
    k_s = 1.0665
  []
  [inner_reflector]
    type = CompositeSolidProperties
    materials = 'solid_flibe graphite'
    fractions = '${IR_porosity} ${fparse 1.0 - IR_porosity}'
  []
  [wall_dist]
    type = WallDistanceAngledCylindricalBed
    outer_radius_x = '0.8574 0.8574 1.25 1.25 0.89 0.89'
    outer_radius_y = '0.0 0.709 1.389 3.889 4.5125 5.3125'
    inner_radius_x = '0.45 0.45 0.35 0.35 0.71 0.71'
    inner_radius_y = '0.0 0.859 1.0322 3.889 4.5125 5.3125'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  type = Transient

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'asm      lu           NONZERO                   200'
  line_search = 'none'

  # Iterations parameters
  l_max_its = 500
  l_tol = 1e-8
  nl_max_its = 25
  nl_rel_tol = 5e-7
  nl_abs_tol = 5e-7

  # Automatic scaling
  automatic_scaling = true

  # Problem time parameters
  dtmin = 0.1
  dtmax = 2e4

  # To run a 100s transient
  start_time = 0
  end_time = 100

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
    cutback_factor = 0.5
    growth_factor = 2.0
  []

  # Time integration scheme
  scheme = 'implicit-euler'

  # Fixed point iterations with SAM
  fixed_point_max_its = 10
  fixed_point_abs_tol = 1e-5
  accept_on_max_fixed_point_iteration = true

  # Steady state detection.
  steady_state_detection = true
  steady_state_tolerance = 1e-8
  steady_state_start_time = 200000
[]

# ==============================================================================
# MULTIAPPS FOR PEBBLE MODEL AND PRIMARY LOOP
# ==============================================================================
[MultiApps]
  [pebble_mesh]
    type = TransientMultiApp
    execute_on = 'FINAL'
    # This must be set so that the default SAM executioner parameters are used
    app_type = 'SamApp'
    input_files = 'ss3_coarse_pebble_mesh.i'
    cli_args = 'Outputs/console=false'
  []

  [primary]
    type = TransientMultiApp
    app_type = 'SamApp'
    input_files = ss2_primary.i
    max_procs_per_app = 1
    execute_on = 'timestep_end'

    # Parameters if Pronghorn takes larger steps than SAM
    # sub_cycling = true
    # print_sub_cycles = false

    # Parameters if Pronghorn and SAM steps match
    # catch_up = true
    # keep_solution_during_restore = true
  []
[]

[Transfers]
  # Pebble simulations
  [fuel_matrix_heat_source]
    type = MultiAppProjectionTransfer
    to_multi_app = pebble_mesh
    source_variable = power_distribution
    variable = power_distribution
  []
  [pebble_surface_temp]
    type = MultiAppProjectionTransfer
    to_multi_app = pebble_mesh
    source_variable = T_solid
    variable = temp_solid
  []

  # Primary and secondary loops
  [send_flow_BCs]
    type = MultiAppPostprocessorVectorTransfer
    to_multi_app = primary
    from_postprocessors = 'pressure_in mass_flow_out T_flow_out T_flow_in'
    to_postprocessors = 'Core_inlet_pressure Core_outlet_mdot Core_outlet_T Core_inlet_T_reversal'
  []
  [receive_flow_BCs]
    type = MultiAppPostprocessorVectorTransfer
    from_multi_app = primary
    from_postprocessors = 'Core_outlet_p Core_inlet_mdot Core_inlet_T'
    to_postprocessors = 'outlet_pressure inlet_mdot inlet_temp_fluid'
    # Initial execution is important to avoid using a default BC
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  # Received from SAM for primary loop coupling
  [inlet_mdot]
    type = Receiver
    default = 9.784508e+02 #${mfr}
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [inlet_vel_y_pp]
    type = ParsedPostprocessor
    function = 'inlet_mdot / model_inlet_area / rho_fluid'
    pp_names = 'inlet_mdot'
    constant_names = 'model_inlet_area rho_fluid'
    constant_expressions = '${model_inlet_area} ${rho_fluid}'
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [inlet_temp_fluid]
    type = Receiver
    default = 8.741515e+02 #${inlet_T_fluid}
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [outlet_pressure]
    type = Receiver
    default = 1.865956e+05 #${outlet_pressure_val}
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []

  # Transfered to SAM for primary loop coupling
  [pressure_in]
    type = SideAverageValue
    boundary = 'bed_horizontal_bottom'
    variable = pressure
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [mass_flow_out]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    advected_quantity = ${rho_fluid}
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [T_flow_in]
    type = ParsedPostprocessor
    function = '-e_flow_in_m / inlet_mdot / cp_fluid'
    pp_names = 'e_flow_in_m inlet_mdot'
    constant_names = 'cp_fluid'
    constant_expressions = '2416'
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [T_flow_out]
    type = ParsedPostprocessor
    function = 'e_flow_out / mass_flow_out / cp_fluid'
    pp_names = 'e_flow_out mass_flow_out'
    constant_names = 'cp_fluid'
    constant_expressions = '2416'
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []

  # Solution Analysis
  [max_Tf]
    type = ElementExtremeValue
    variable = T_fluid
    block = ${blocks_fluid}
  []
  [max_vy]
    type = ElementExtremeValue
    variable = superficial_vel_y
    block = ${blocks_fluid}
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_distribution
    block = '3'
    execute_on = 'INITIAL TIMESTEP_BEGIN TRANSFER TIMESTEP_END'
  []
  [pressure_drop]
    type = DifferencePostprocessor
    value1 = outlet_pressure
    value2 = pressure_in
  []

  # Energy balance
  # Energy balance will be shown once #18119 #18123 are merged in MOOSE
  # [outer_heat_loss]
  #   type = ADSideDiffusiveFluxIntegral
  #   boundary = 'brick_surface'
  #   variable = T_solid
  #   diffusivity = 'k_s'
  #   execute_on = 'INITIAL TIMESTEP_END'
  # []
  [e_flow_in_m]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_bottom OR_horizontal_bottom'
    advected_quantity = 'rho_cp_temp'
  []
  # [diffusion_in]
  #   type = ADSideVectorDiffusivityFluxIntegral
  #   variable = T_fluid
  #   boundary = 'bed_horizontal_bottom OR_horizontal_bottom'
  #   diffusivity = 'kappa'
  # []
  # diffusion at the top is 0 because of the fully developped flow assumption
  [e_flow_out]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    advected_quantity = 'rho_cp_temp'
  []
  [core_balance]
    type = ParsedPostprocessor
    pp_names = 'power e_flow_in_m e_flow_out' #diffusion_in  outer_heat_loss'
    function = 'power - e_flow_in_m - e_flow_out' # + diffusion_in + outer_heat_loss'
  []

  # Bypass
  [mass_flow_OR]
    type = VolumetricFlowRate
    boundary = 'OR_horizontal_top'
    advected_quantity = 'rho'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [mass_flow_plenum]
    type = VolumetricFlowRate
    boundary = 'plenum_top'
    advected_quantity = 'rho'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [bypass_fraction]
    type = ParsedPostprocessor
    pp_names = 'mass_flow_OR mass_flow_out'
    function = 'mass_flow_OR / mass_flow_out'
  []
  [plenum_fraction]
    type = ParsedPostprocessor
    pp_names = 'mass_flow_plenum mass_flow_out'
    function = 'mass_flow_plenum / mass_flow_out'
  []

  # Miscellaneous
  [h]
    type = AverageElementSize
    outputs = 'console csv'
    execute_on = 'timestep_end'
  []
  [coupling_its_primary]
    type = NumFixedPointIterations
  []
  [num_fixed_point]
    type = Receiver
    default = 0
  []
[]

[Outputs]
  csv = true
  [console]
    type = Console
    show = 'T_flow_in inlet_temp_fluid T_flow_out pressure_in outlet_pressure inlet_mdot mass_flow_out'
  []
  [exodus]
    type = Exodus
  []
  [checkpoint]
    type = Checkpoint
    num_files = 2
  []
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
