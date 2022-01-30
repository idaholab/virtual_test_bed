# ==============================================================================
# Model description
# Application : Pronghorn
# ------------------------------------------------------------------------------
# Idaho Falls, INL, August 10, 2020
# Author(s): Dr. Guillaume Giudicelli, Dr. Paolo Balestra, Dr. April Novak
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
UO2_phase_fraction           = 1.20427291e-01
buffer_phase_fraction        = 2.86014816e-01
ipyc_phase_fraction          = 1.59496539e-01
sic_phase_fraction           = 1.96561801e-01
opyc_phase_fraction          = 2.37499553e-01
TRISO_phase_fraction         = 3.09266232e-01
core_phase_fraction          = 5.12000000e-01
fuel_matrix_phase_fraction   = 3.01037037e-01
shell_phase_fraction         = 1.86962963e-01

# FLiBe properties #TODO: Rely only on PronghornFluidProps
# fluid_mu = 7.5e-3  # Pa.s at 900K [3]
# k_fluid =  1.1     # suggested constant [3]
# cp_fluid = 2385    # suggested constant [3]
rho_fluid = 1970.0   # kg/m3 at 900K [3]
alpha_b = 2e-4       # /K from [4]

# Graphite properties
heat_capacity_multiplier = 1e0  # >1 gets faster to steady state
solid_rho = 1780.0
# solid_k = 26.0
solid_cp = ${fparse 1697.0*heat_capacity_multiplier}

# Outer reflector drag parameters
# TODO: tune using CFD
# TODO: verify current values (imported from [1])
Ah = 1337.76
Bh = 2.58
Av = 599.30
Bv = 0.95
Dh = 0.02582
Dv = 0.02006

# Plenum drag parameters. The core hot legs cannot be represented in 2D RZ
# accurately, so this should be tuned to obtain the desired mass flow rates
plenum_friction = 0.5

# Computation parameters
velocity_interp_method = 'rc'
advected_interp_method = 'upwind'

# Core geometry
pebble_diameter  = 0.03
bed_porosity     = 0.4
IR_porosity      = 0
OR_porosity      = 0.1123
plenum_porosity  = 0.5
model_inlet_rin  = 0.45
model_inlet_rout = 0.8574
model_vol        = 10.4
model_inlet_area = ${fparse 3.14159265 * (model_inlet_rout * model_inlet_rout -
                                          model_inlet_rin * model_inlet_rin)}

# Operating parameters
mfr = 976.0            # kg/s, from [2]
total_power = 236.0e6  # W, from [2]
inlet_T_fluid = 873.15 # K, from [2]
inlet_vel_y = ${fparse mfr / model_inlet_area / rho_fluid} # superficial
power_density = ${fparse total_power / model_vol / 258 * 236}  # adjusted using power pp

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
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
    included_subdomain_ids = '6'
    input = barrel
  []
  [OR_outlet]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y - 5.3125) < 1e-10'
    new_sideset_name = 'OR_horizontal_top'
    included_subdomain_ids = '6'
    input = OR_inlet
  []
[]

[Problem]
  coord_type = RZ
[]

[GlobalParams]
  rho = ${rho_fluid}
  porosity = porosity
  pebble_diameter = ${pebble_diameter}
  fp = fp
  T_solid = temp_solid
  T_fluid = temp_fluid

  vel = 'superficial_velocity'
  pressure = pressure
  u = vel_x
  v = vel_y
  mu = 'mu'

  velocity_interp_method = ${velocity_interp_method}
  advected_interp_method = ${advected_interp_method}
  fv = true

  vel_x = 'vel_x'
  vel_y = 'vel_y'
  superficial_vel_x = 'vel_x'
  superficial_vel_y = 'vel_y'

  rhie_chow_user_object = rc
  two_term_boundary_expansion = true
[]

[UserObjects]
  [rc]
    type = PINSFVRhieChowInterpolator
    #standard_body_forces = true
  []
[]

[Debug]
  # show_var_residual_norms = true
  # show_material_props = true
  # show_actions = true
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
    initial_condition = 1e-12
  []
  [vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
  []
  [pressure]
    type = INSFVPressureVariable
    block = ${blocks_fluid}
    initial_condition = 1e5
  []
  [temp_fluid]
    type = INSFVEnergyVariable
    block = ${blocks_fluid}
    initial_condition = 900
  []
  [temp_solid]
    type = MooseVariableFVReal
  []
[]

[FVKernels]
  # Mass Equation.
  [mass]
    type = PINSFVMassAdvection
    variable = pressure
    u = vel_x
    v = vel_y
    pressure = pressure
    mu = 'mu'
  []

  # Momentum x component equation.
  [vel_x_time]
    type = PINSFVMomentumTimeDerivative
    variable = vel_x
    momentum_component = x
  []
  [vel_x_advection]
    type = PINSFVMomentumAdvection
    variable = vel_x
    advected_quantity = 'superficial_rho_u'
    momentum_component = x
  []
  [vel_x_viscosity]
    type = PINSFVMomentumDiffusion
    variable = vel_x
    momentum_component = x
  []
  [u_pressure]
    type = PINSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
  []
  [u_friction]
    type = PINSFVMomentumFriction
    variable = vel_x
    Darcy_name = 'Darcy_coefficient'
    Forchheimer_name = 'Forchheimer_coefficient'
    momentum_component = 'x'
  []

  # Momentum y component equation.
  [vel_y_time]
    type = PINSFVMomentumTimeDerivative
    variable = vel_y
    momentum_component = y
  []
  [vel_y_advection]
    type = PINSFVMomentumAdvection
    variable = vel_y
    advected_quantity = 'superficial_rho_v'
    momentum_component = y
  []
  [vel_y_viscosity]
    type = PINSFVMomentumDiffusion
    variable = vel_y
    momentum_component = y
  []
  [v_pressure]
    type = PINSFVMomentumPressure
    variable = vel_y
    pressure = pressure
    momentum_component = 'y'
  []
  [v_friction]
    type = PINSFVMomentumFriction
    variable = vel_y
    Darcy_name = 'Darcy_coefficient'
    Forchheimer_name = 'Forchheimer_coefficient'
    momentum_component = 'y'
  []
  [gravity]
    type = PINSFVMomentumGravity
    variable = vel_y
    gravity = '0 -9.81 0'
    momentum_component = 'y'
  []
  [buoyancy_boussinesq]
    type = PINSFVMomentumBoussinesq
    variable = vel_y
    gravity = '0 -9.81 0'
    ref_temperature = ${inlet_T_fluid}
    T_fluid = 'temp_fluid'
    momentum_component = 'y'
    alpha_name = 'alpha_b'
  []

  # Fluid Energy equation.
  [temp_fluid_time]
    type = PINSFVEnergyTimeDerivative
    variable = temp_fluid
    cp = 'cp'
    is_solid = false
  []
  [temp_fluid_advection]
    type = PINSFVEnergyAdvection
    variable = temp_fluid
    vel = 'superficial_velocity'
    advected_quantity = 'rho_cp_temp'
  []
  [temp_fluid_conduction]
    type = PINSFVEnergyAnisotropicDiffusion
    variable = temp_fluid
    effective_diffusivity = false
    kappa = 'kappa'
  []
  [temp_solid_to_fluid]
    type = PINSFVEnergyAmbientConvection
    variable = temp_fluid
    T_fluid = temp_fluid
    T_solid = temp_solid
    is_solid = false
    h_solid_fluid = 'alpha'
  []

  # Solid Energy equation.
  [temp_solid_time_core]
    type = PINSFVEnergyTimeDerivative
    variable = temp_solid
    cp = 'cp_s'
    rho = ${solid_rho} # FIXME
    is_solid = true
    block = ${blocks_fluid}
  []
  [temp_solid_time]
    type = INSFVEnergyTimeDerivative
    variable = temp_solid
    cp_name = 'cp_s'
    block = ${blocks_solid}
  []
  [temp_solid_conduction_core]
    type = FVDiffusion
    variable = temp_solid
    coeff = 'kappa_s'
    block = ${blocks_fluid}
  []
  [temp_solid_conduction]
    type = FVDiffusion
    variable = temp_solid
    coeff = 'k_s'
    block = ${blocks_solid}
  []
  [temp_solid_source]
    type = FVCoupledForce
    variable = temp_solid
    v = power_distribution
    block = '3'
  []
  [temp_fluid_to_solid]
    type = PINSFVEnergyAmbientConvection
    variable = temp_solid
    T_fluid = 'temp_fluid'
    T_solid = 'temp_solid'
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
    variable1 = 'temp_solid'
    variable2 = 'temp_solid'
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
  [porosity]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
  [pow_init1]
    type = FunctionIC
    variable = power_distribution
    function = ${power_density}
    block = '3'
  []
  [core_T]
    type = FunctionIC
    variable = temp_solid
    function = 800
    block = '1 2 3 4 5 6 7 8'
  []
  [bricks]
    type = FunctionIC
    variable = temp_solid
    function = 350
    block = '9 10'
  []
  [bed_porosity]
    type = FunctionIC
    variable = porosity
    function = ${bed_porosity}
    block = ${blocks_pebbles}
  []
  [plenum_porosity]
    type = FunctionIC
    variable = porosity
    function = ${plenum_porosity}
    block = '5'
  []
  [OR_porosity]
    type = FunctionIC
    variable = porosity
    function = ${OR_porosity}
    block = '6'
  []
  [vel_core]
    type = FunctionIC
    variable = vel_y
    function = ${inlet_vel_y}
    block = ${blocks_fluid}
  []
[]

[Functions]
  [mu_func]
    type = PiecewiseLinear
    x = '1 3 5 10'
    y = '1e3 1e2 1e1 1'
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[FVBCs]
  [inlet_vel_x]
    type = INSFVInletVelocityBC
    variable = vel_x
    function = 1e-12
    boundary = 'bed_horizontal_bottom'
  []
  [inlet_vel_y]
    type = INSFVInletVelocityBC
    variable = vel_y
    function = ${inlet_vel_y}
    boundary = 'bed_horizontal_bottom'
  []
  [OR_inlet_vel_x]
    type = INSFVInletVelocityBC
    variable = vel_x
    function = 1e-12
    boundary = 'OR_horizontal_bottom'
  []
  [OR_inlet_vel_y]
    type = INSFVInletVelocityBC
    variable = vel_y
    function = 1e-12
    boundary = 'OR_horizontal_bottom'
  []

  #TODO: Switch to a flux BC (eps * phi * T)
  [inlet_temp_fluid]
    type = FVDirichletBC
    variable = temp_fluid
    value = ${fparse inlet_T_fluid}
    boundary = 'bed_horizontal_bottom'
  []

  [free-slip-wall-x]
    type = INSFVNaturalFreeSlipBC
    boundary = 'bed_left barrel_wall'
    variable = vel_x
    momentum_component = x
  []
  [free-slip-wall-y]
    type = INSFVNaturalFreeSlipBC
    boundary = 'bed_left barrel_wall'
    variable = vel_y
    momentum_component = y
  []

  [outer]
    type = FVDirichletBC
    variable = temp_solid
    boundary = 'brick_surface'
    value = ${fparse 35 + 273.15}
  []

  [outlet_p]
    type = INSFVOutletPressureBC
    variable = pressure
    function = 2e5   # not too far from atm for matprop evaluations
    boundary = 'bed_horizontal_top OR_horizontal_top plenum_top'
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

[Materials]
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
    prop_names = 'alpha_b'
    prop_values = '${alpha_b}'
    block = ${blocks_fluid}
  []
  [ins_fv]
    type = INSFVPrimitiveSuperficialVarMaterial
    T_fluid = 'temp_fluid'
    block = ${blocks_fluid}
    p_constant = 1e5
    T_constant = 900
  []
  [fluidprops]
    type = PronghornFluidFunctorProps
    block = ${blocks_fluid}
    mu_multiplier = mu_func
    T_fluid = 'temp_fluid'
    speed = 'speed'
    characteristic_length = ${pebble_diameter}
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
    T_solid = temp_solid
    acceleration = '0 -9.81 0'
  []

  # closures in the outer reflector and the plenum
  [drag_OR]
    type = FunctorAnisotropicFunctorDragCoefficients
    Darcy_coefficient = '${fparse OR_porosity * Ah / Dh / Dh}
    ${fparse OR_porosity * Av / Dv / Dv} ${fparse OR_porosity * Av / Dv / Dv}'
    Forchheimer_coefficient = '${fparse OR_porosity * Bh / Dh}
    ${fparse OR_porosity * Bv / Dv} ${fparse OR_porosity * Bv / Dv}'
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
    type = ADGenericConstantFunctorMaterial
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
[]

[UserObjects]
  [graphite]
    type = FunctionSolidProperties
    rho_s = 1780
    cp_s = ${fparse 1800.0 * heat_capacity_multiplier}
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
    fractions = '${UO2_phase_fraction} ${buffer_phase_fraction} ${ipyc_phase_fraction} '
                '${sic_phase_fraction} ${opyc_phase_fraction}'
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
  l_tol     = 1e-8
  nl_max_its = 25
  nl_rel_tol = 5e-7
  nl_abs_tol = 5e-7

  # Automatic scaling
  automatic_scaling = true

  # Problem time parameters
  dtmin = 0.1
  dtmax = 2e4
  end_time = 1e6

  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1
    cutback_factor     = 0.5
    growth_factor      = 2.0
  []

  # Steady state detection.
  steady_state_detection = true
  steady_state_tolerance = 1e-8
  steady_state_start_time = 200000
[]

# ==============================================================================
# MULTIAPPS FOR PEBBLE MODEL
# ==============================================================================
#[MultiApps]
#  [coarse_mesh]
#    type = TransientMultiApp
#    execute_on = 'TIMESTEP_END'
#    input_files = 'ss3_coarse_pebble_mesh.i'
#    cli_args = 'Outputs/console=false'
#  []
#[]

#[Transfers]
#  [fuel_matrix_heat_source]
#    type = MultiAppProjectionTransfer
#    direction = to_multiapp
#    multi_app = coarse_mesh
#    source_variable = power_distribution
#    variable = power_distribution
#  []
#  [pebble_surface_temp]
#    type = MultiAppProjectionTransfer
#    direction = to_multiapp
#    multi_app = coarse_mesh
#    source_variable = temp_solid
#    variable = temp_solid
#  []
#[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  # For future SAM coupling
  # [inlet_vel_y]
  #   type = Receiver
  #   default = ${inlet_vel_y}
  # []
  # [inlet_temp_fluid]
  #   type = Receiver
  #   default = ${inlet_T_fluid}
  # []
  # [outlet_pressure]
  #   type = Receiver
  #   default = ${outlet_pressure}
  # []
  [max_Tf]
    type = ElementExtremeValue
    variable = temp_fluid
    block = ${blocks_fluid}
  []
  [max_vy]
    type = ElementExtremeValue
    variable = vel_y
    block = ${blocks_fluid}
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_distribution
    block = '3'
    execute_on = 'INITIAL TIMESTEP_BEGIN TRANSFER TIMESTEP_END'
  []
  [mass_flow_out]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    advected_variable = ${rho_fluid}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_flow_out]
    type = SideAverageValue
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    variable = temp_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pressure_in]
    type = SideAverageValue
    boundary = 'bed_horizontal_bottom'
    variable = pressure
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pressure_out]
    type = SideAverageValue
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    variable = pressure
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pressure_drop]
    type = DifferencePostprocessor
    value1 = pressure_out
    value2 = pressure_in
  []

  # Energy balance
  # Energy balance will be shown once #18119 #18123 are merged in MOOSE
  # [outer_heat_loss]
  #   type = ADSideDiffusiveFluxIntegral
  #   boundary = 'brick_surface'
  #   variable = temp_solid
  #   diffusivity = 'k_s'
  #   execute_on = 'INITIAL TIMESTEP_END'
  # []
  [flow_in_m]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_bottom OR_horizontal_bottom'
    advected_mat_prop = 'rho_cp_temp'
  []
  # [diffusion_in]
  #   type = ADSideVectorDiffusivityFluxIntegral
  #   variable = temp_fluid
  #   boundary = 'bed_horizontal_bottom OR_horizontal_bottom'
  #   diffusivity = 'kappa'
  # []
  # diffusion at the top is 0 because of the fully developped flow assumption
  [flow_out]
    type = VolumetricFlowRate
    boundary = 'bed_horizontal_top plenum_top OR_horizontal_top'
    advected_mat_prop = 'rho_cp_temp'
  []
  # [core_balance]
  #   type = ParsedPostprocessor
  #   pp_names = 'power flow_in_m diffusion_in flow_out outer_heat_loss'
  #   function = 'power - flow_in_m + diffusion_in - flow_out + outer_heat_loss'
  # []

  # Bypass
  [mass_flow_OR]
    type = VolumetricFlowRate
    boundary = 'OR_horizontal_top'
    advected_variable = ${rho_fluid}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [mass_flow_plenum]
    type = VolumetricFlowRate
    boundary = 'plenum_top'
    advected_variable = ${rho_fluid}
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
[]

[Outputs]
  csv = true
  hide = 'pressure_in pressure_out mass_flow_OR mass_flow_plenum max_vy '
        # 'bypass_fraction plenum_fraction max_Tf h pressure_drop'
  [exodus]
    type = Exodus
    # renaming variables to use this option would be necessary for now, see #17905
    # output_material_properties = true
  []
  [checkpoint]
    type = Checkpoint
    num_files = 2
    execute_on = 'FINAL'
  []
[]
