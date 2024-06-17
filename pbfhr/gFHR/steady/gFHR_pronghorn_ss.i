# ------------------------------------------------------------------------------
# Description:
# gFHR input
# gFHR salt simulation
# Porous Flow Weakly Compressible Media Finite Volume
# sprvel: superficial formulation of the velocities
# ==============================================================================
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Geometric data (m)
inner_radius = 0.0
outer_radius = 1.2
bed_height = 3.0947

# Experiment data.
pebble_emissivity = 0.8

# Radial BC for conduction
#rpv_outer_temperature = 700.0

# characteristic lengths
pebble_diameter = 0.04
D_H_downcomer = 0.1
D_H_flow2 = 0.9
D_H_flow5 = 0.3
D_H_diode = 0.1
D_H_outlet = 0.8

# porosities
porosity_bed = 0.401150593
porosity_free_flow = 0.9999999
porosity_cone = 0.75
porosity_solid = 0

# Numerical scheme parameters
advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

# To reach steady state faster if needed
cp_multiplier = 1

core_power_density = 1.999987E+07
blocks_fluid = 'flow1 flow2 flow3 flow4 flow5 dio1 dio2 dio3 flowp inlet outlet '

blocks_free_flow = 'flow1 flow2 flow5 dio1 dio2 dio3 inlet outlet '
blocks_bed = 'flow3 flow4 flowp'
blocks_non_bed = 'flow1 flow2 flow5 dio1 dio2 dio3 reflector
                  barrel vessel1 vessel2 inlet outlet '
blocks_solid_only = '${blocks_bed} reflector barrel vessel1 vessel2'

# volumetric heat transfer coefficients computed
# from areal heat transfer coefficients
C_DB = 0.023
#ApV_flow_1 = 40
#ApV_diode = 40
ApV_flow_1 = 1
ApV_diode = 1

# Forchheimer coefficient in an open plenum
Forch_open = 1.25
# end parameters

[GlobalParams]
  pebble_diameter = ${pebble_diameter}
  fp = fluid_properties
  pressure = pressure

  # FV parameters
  two_term_boundary_expansion = true
  advected_interp_method = ${advected_interp_method}
  velocity_interp_method = ${velocity_interp_method}
  rho = 'rho'
  force_define_density = true
  acceleration = '0.0 -9.81 0.0'
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'
[]

[Debug]
  show_var_residual_norms = true
[]

[Mesh]
  block_id = '  1     2     3     4     5    6    7    8    9     10           12     13      14      20      21  ' #30 is a buffer layer to protect the porosity smoothing and ensure conservation
  block_name = 'flow1 flow2 flow3 flow4 flow5 dio1 dio2 dio3 flowp reflector   barrel vessel1 vessel2 inlet outlet'
  coord_type = RZ
  rz_coord_axis = Y

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    # keep mesh in the pebble bed roughly 3xpebble diameter ~12 cm for gFHR
    dx = '0.8 0.1 0.3 0.2 0.2 0.2 0.02 0.05 0.04'
    ix = '  6   1   3   2   2   2    1    2    2'

    dy = '0.04 0.05  0.3 0.3  0.154735 2.78523 0.154735  0.6  0.5  0.05 0.1 0.2 0.4'
    iy = '   2    2    2   2         1      18        1    4    4     2   1   2   2'

    # lower X is at the beginning of this array
    # higher X is at the bottom, Y is as-expected
    subdomain_id = '
   14 13 13 13 13 13 13 13 13
    2  1  1  1  1  1  1  1 13
    2  2 10 10 10 10 12  1 13
    2  2  9 10 10 10 12  1 13
    3  3  3 10 10 10 12  1 13
    3  3  3 10 10 10 12  1 13
    3  3  3 10 10 10 12  1 13
    4  9  5 10 10 10 12  1 13
    4 10  5 10 10 10 12  1 13
    4 10  5  6  7  8  8  1 13
    4 10 10 10 10 10 12  1 13
    4 10 10 10 10 10 12  1 20
   21 10 10 10 10 10 12 12 13'
  []

  [CL_SS]
    type = SideSetsAroundSubdomainGenerator
    input = cartesian_mesh
    fixed_normal = true
    normal = '-1 0 0'
    block = '2 3 4 14 21'
    new_boundary = 'centerline'
  []
  [Inlet]
    type = SideSetsAroundSubdomainGenerator
    input = CL_SS
    fixed_normal = true
    normal = '1 0 0'
    block = '20'
    new_boundary = 'inlet'
  []
  [Outlet]
    type = SideSetsAroundSubdomainGenerator
    input = Inlet
    fixed_normal = true
    normal = '0 1 0'
    block = '21'
    new_boundary = 'outlet'
  []
  [vertical_walls_01]
    type = SideSetsBetweenSubdomainsGenerator
    input = Outlet
    primary_block = '1 20'
    paired_block = 13
    new_boundary = wall1
  []
  [vertical_walls_02]
    type = SideSetsBetweenSubdomainsGenerator
    input = vertical_walls_01
    primary_block = 2
    paired_block = 14
    new_boundary = wall1
  []
  [vertical_walls_03]
    type = SideSetsBetweenSubdomainsGenerator
    input = vertical_walls_02
    primary_block = '1 8'
    paired_block = 12
    new_boundary = wall1
  []
  [vertical_walls_04]
    type = SideSetsBetweenSubdomainsGenerator
    input = vertical_walls_03
    primary_block = '1 2 3 4 5 6 7 8 9 21'
    paired_block = 10
    new_boundary = wall1
  []
  [walls_free_flow_convection]
    type = ParsedGenerateSideset
    input = 'vertical_walls_04'
    included_subdomains = '1 2 5 6 7 8 20 21'
    new_sideset_name = 'walls_free_flow_convection'
    included_boundaries = 'wall1'
    combinatorial_geometry = 'x < 1e10'
  []
  [RCSS_Boundary]
    type = SideSetsAroundSubdomainGenerator
    input = walls_free_flow_convection
    fixed_normal = true
    block = '13 14'
    normal = '1 0 0'
    new_boundary = RCSS
    include_only_external_sides = true
  []
  [Mass_Flow_Sensor_1]
    type = SideSetsBetweenSubdomainsGenerator
    input = RCSS_Boundary
    primary_block = '6'
    paired_block = 7
    new_boundary = MF_1
  []
  [Mass_Flow_Sensor_2]
    type = SideSetsBetweenSubdomainsGenerator
    input = Mass_Flow_Sensor_1
    primary_block = '7'
    paired_block = 8
    new_boundary = MF_2
  []
  [Mass_Flow_Sensor_3]
    type = SideSetsBetweenSubdomainsGenerator
    input = Mass_Flow_Sensor_2
    primary_block = '1'
    paired_block = 2
    new_boundary = MF_3
  []
  uniform_refine = 0
[]

# ==============================================================================
# VARIABLES, AUXILIARY VARIABLES, INITIAL CONDITIONS DEFINITION AND FUNCTIONS
# ==============================================================================
[Variables]
  [pressure]
    type = INSFVPressureVariable
    block = ${blocks_fluid}
    initial_condition = 1e5
  []
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
    initial_condition = 1e-10
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = ${blocks_fluid}
    initial_condition = 1e-10
  []
  [T_solid]
    type = INSFVEnergyVariable
    initial_condition = 823.14
    block = ${blocks_solid_only}
  []
  [T_fluid]
    type = INSFVEnergyVariable
    block = ${blocks_fluid}
    initial_condition = 823.14
  []
[]

[AuxVariables]
  [Volume_of_Cell]
    order = CONSTANT
    family = MONOMIAL
    block = ${blocks_fluid}
    initial_condition = 0.00012499797344389663
  []
  [CFL_Now]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [Dt]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [porosity_1]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [real_vel_x]
    type = MooseVariableFVReal
    initial_condition = 0
    block = ${blocks_fluid}
  []
  [real_vel_y]
    type = MooseVariableFVReal
    initial_condition = 0.0
    block = ${blocks_fluid}
  []
  [power_density]
    type = MooseVariableFVReal
    initial_condition = '${fparse core_power_density}'
    block = 'flow3'
  []
  [T_fluid_WD]
    type = MooseVariableFVReal
  []
  [Wall_Distance]
    type = MooseVariableFVReal
  []
  [htc_material]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [Adjusted_HTC_Material]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [kappa_fluid]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [Darcy_Value]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
  [Forchheimer_Value]
    type = MooseVariableFVReal
    block = ${blocks_fluid}
  []
[]

[Functions]
  [dt_function]
    type = ParsedFunction
    symbol_values = 'dt'
    symbol_names = 'dt'
    expression = 'dt'
  []
  [porosity_core]
    type = ParsedFunction
    expression = 0.4011505932
  []
  [porosity_cones]
    type = ParsedFunction
    expression = 0.75
  []
  [porosity_plena]
    type = ParsedFunction
    expression = 0.9999
  []
  [porosity_pipe]
    type = ParsedFunction
    expression = 0.9999
  []
  [porosity_diode]
    type = ParsedFunction
    expression = 0.9999
  []
  [Outlet_Average_Pressure_Function]
    type = ParsedFunction
    symbol_names = 'OAP'
    expression = OAP
    symbol_values = 'Outlet_Pressure_BC'
  []
  [mu_rampdown]
    type = ParsedFunction
    expression = 1
  []
[]

# ==============================================================================
# KERNEL AND AUXILIARY KERNELS
# ==============================================================================

[Modules]
  [NavierStokesFV]
    # General parameters
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    add_energy_equation = false
    block = ${blocks_fluid}
    gravity = '0 -9.81 0'

    # Variables
    velocity_variable = 'superficial_vel_x superficial_vel_y'
    pressure_variable = 'pressure'
    fluid_temperature_variable = 'T_fluid'

    # Wall boundary conditions
    wall_boundaries = 'wall1'
    momentum_wall_types = 'slip'

    # Inlet boundary conditions
    inlet_boundaries = 'inlet'
    momentum_inlet_types = 'fixed-velocity'
    momentum_inlet_function = '-0.242984118 0'

    # Outlet boundary conditions
    outlet_boundaries = 'outlet'
    momentum_outlet_types = 'fixed-pressure'
    pressure_function = 'Outlet_Average_Pressure_Function'

    # Porous flow parameters
    ambient_convection_blocks = ${blocks_fluid}
    ambient_convection_alpha = 'alpha'
    ambient_temperature = 'T_solid'

    # Friction in porous media
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'combined_linear combined_quadratic'
    use_friction_correction = True
    consistent_scaling = 200
    # porosity_smoothing_layers = 8

    # Numerical scheme
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
  []
[]

[FVKernels]
  # Equation 3 (fluid energy conservation).
  [fluid_energy_time]
    type = PINSFVEnergyTimeDerivative
    is_solid = false
    variable = T_fluid
    cp = cp
    rho = rho
    drho_dt = drho_dt
    #dcp_dt = dcp_dt
    porosity = 'porosity_energy'
    block = ${blocks_fluid}
  []
  [fluid_energy_space]
    type = PINSFVEnergyAdvection
    variable = T_fluid
    block = ${blocks_fluid}
  []
  [fluid_energy_diffusive]
    type = PINSFVEnergyAnisotropicDiffusion
    variable = T_fluid
    effective_diffusivity = false
    kappa = 'kappa'
    porosity = 'porosity_energy'
    block = ${blocks_fluid}
  []
  [fluid_energy_solid_fluid_source]
    type = PINSFVEnergyAmbientConvection
    variable = T_fluid
    is_solid = false
    h_solid_fluid = 'alpha'
    T_fluid = T_fluid
    T_solid = T_solid
    block = ${blocks_bed}
  []

  # Equation 4 (solid energy conservation).
  [solid_energy_time]
    type = PINSFVEnergyTimeDerivative
    variable = T_solid
    rho = 'rho_s'
    cp = 'cp_s'
    #dcp_dt = 0
    is_solid = true
    porosity = porosity_energy
  []
  [temp_fluid_to_solid]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = 'T_fluid'
    T_solid = 'T_solid'
    is_solid = true
    h_solid_fluid = 'alpha'
    block = ${blocks_bed}
  []
  [solid_energy_production]
    type = FVCoupledForce
    variable = T_solid
    v = power_density
    block = 'flow3' # only in the pebble bed core
  []
  [solid_energy_diffusion_core]
    type = PINSFVEnergyDiffusion
    variable = T_solid
    k = 'eff_solid_conductivity'
    effective_diffusivity = true
    # porosity won't be used because effective_diffusivity = true
    # so set it to 1
    porosity = 1
  []
[]

[FVInterfaceKernels]
  [free-flow-to-solid]
    type = FVConvectionCorrelationInterface
    variable1 = T_fluid
    variable2 = T_solid
    boundary = 'walls_free_flow_convection'
    h = 'wall_htc'
    T_solid = T_solid
    T_fluid = T_fluid
    subdomain1 = ${blocks_free_flow}
    subdomain2 = 'vessel1 vessel2 barrel reflector'
    wall_cell_is_bulk = true
  []
  [free-flow-to-solid_other]
    type = FVConvectionCorrelationInterface
    variable1 = T_solid
    variable2 = T_fluid
    boundary = 'walls_free_flow_convection'
    h = 'wall_htc'
    T_solid = T_solid
    T_fluid = T_fluid
    subdomain2 = ${blocks_free_flow}
    subdomain1 = 'vessel1 vessel2 barrel reflector'
    wall_cell_is_bulk = true
  []
[]

[AuxKernels]
  [volume_Calc]
    type = VolumeAux
    variable = Volume_of_Cell
    block = ${blocks_fluid}
  []
  [dt_kernel]
    type = FunctionAux
    variable = Dt
    function = dt_function
  []
  [CFL_Calc]
    type = ParsedAux
    variable = CFL_Now
    coupled_variables = 'superficial_vel_x superficial_vel_y Volume_of_Cell Dt'
    expression = '(abs(superficial_vel_x) + abs(superficial_vel_y))*Dt/(Volume_of_Cell)^(0.5)'
    block = ${blocks_fluid}
  []
  [real_vel_x_calc]
    type = ParsedAux
    variable = real_vel_x
    coupled_variables = 'superficial_vel_x porosity_1'
    expression = 'superficial_vel_x / porosity_1'
    block = ${blocks_fluid}
  []
  [real_vel_y_calc]
    type = ParsedAux
    variable = real_vel_y
    coupled_variables = 'superficial_vel_y porosity_1'
    expression = 'superficial_vel_y / porosity_1'
    block = ${blocks_fluid}
  []
  [Whole_Domain_Fluid_Temp]
    type = ParsedAux
    variable = T_fluid_WD
    coupled_variables = 'T_fluid'
    expression = 'T_fluid'
    block = ${blocks_fluid}
  []
  [Whole_Domain_Fluid_Temp_2]
    type = ConstantAux
    variable = T_fluid_WD
    value = 0
    block = 'reflector barrel vessel1 vessel2'
  []
  [porosity_out]
    type = FunctorAux
    functor = 'porosity'
    variable = 'porosity_1'
    block = ${blocks_fluid}
    execute_on = 'initial'
  []
  [kappa_out]
    type = ADFunctorVectorElementalAux
    functor = 'kappa'
    variable = 'kappa_fluid'
    component = '0'
    execute_on = 'timestep_end final'
    block = ${blocks_fluid}
  []
  [Wall_Distance_Aux_Kernel]
    type = WallDistanceMixingLengthAux
    variable = Wall_Distance
    von_karman_const = 1
    von_karman_const_0 = 1
    walls = 'wall1'
  []
  [Adjust_HTC]
    type = ParsedAux
    variable = Adjusted_HTC_Material
    coupled_variables = 'htc_material Wall_Distance'
    expression = 'htc_material*Wall_Distance'
    block = ${blocks_fluid}
  []
  [d_var_aux]
    type = ADFunctorVectorElementalAux
    variable = Darcy_Value
    functor = combined_linear
    block = ${blocks_fluid}
    component = '0'
  []
  [f_var_aux]
    type = ADFunctorVectorElementalAux
    variable = Forchheimer_Value
    functor = combined_quadratic
    block = ${blocks_fluid}
    component = '0'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fluid_properties]
    type = FlibeFluidProperties
  []
[]

[FunctorMaterials]
  # Generating materials for non linear variables and the fluid.
  [Action_Creates]
    type = INSFVEnthalpyFunctorMaterial
    temperature = T_fluid
    output_properties = 'cp'
    outputs = 'exo'
  []

  [GFFP]
    type = GeneralFunctorFluidProps
    T_fluid = 'T_fluid'
    characteristic_length = characteristic_length
    fp = fluid_properties
    porosity = 'porosity'
    pressure = 'pressure'
    speed = speed
    mu_rampdown = 'mu_rampdown'
    block = ${blocks_fluid}
    output_properties = 'rho'
    outputs = 'exo'
  []

  ## Characteristic length: fix the 1's wherever we need Reynolds number!!
  [characteristic_length]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = characteristic_length
    block = ${blocks_fluid}
    subdomain_to_prop_value = '1  ${D_H_downcomer}
                               2  ${D_H_flow2}
                               3  ${pebble_diameter}
                               4  ${pebble_diameter}
                               5  ${D_H_flow5}
                               6  ${D_H_diode}
                               7  ${D_H_diode}
                               8  ${D_H_diode}
                               9  ${pebble_diameter}
                               20 ${D_H_downcomer}
                               21 ${D_H_outlet}'
  []

  ## Porosity
  [porosity_energy]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = porosity_energy
    subdomain_to_prop_value = '1 ${porosity_free_flow}
                               2 ${porosity_free_flow}
                               3 ${porosity_bed}
                               4 ${porosity_cone}
                               5 ${porosity_free_flow}
                               6 ${porosity_free_flow}
                               7 ${porosity_free_flow}
                               8 ${porosity_free_flow}
                               9 ${porosity_cone}
                               20 ${porosity_free_flow}
                               21 ${porosity_free_flow}
                               10 ${porosity_solid}
                               12 ${porosity_solid}
                               13 ${porosity_solid}
                               14 ${porosity_solid}'
  []

  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = '1 ${porosity_free_flow}
                               2 ${porosity_free_flow}
                               3 ${porosity_bed}
                               4 ${porosity_cone}
                               5 ${porosity_free_flow}
                               6 ${porosity_free_flow}
                               7 ${porosity_free_flow}
                               8 ${porosity_free_flow}
                               9 ${porosity_cone}
                               20 ${porosity_free_flow}
                               21 ${porosity_free_flow}
                               10 ${porosity_solid}
                               12 ${porosity_solid}
                               13 ${porosity_solid}
                               14 ${porosity_solid}'
    output_properties = 'porosity'
    outputs = 'exo'
  []

  [diode]
    type = NSFVFrictionFlowDiodeFunctorMaterial
    direction = '-1 0 0'
    additional_linear_resistance = '1000 0 0'
    additional_quadratic_resistance = '100 0 0'
    base_linear_friction_coefs = 'Darcy_coefficient'
    base_quadratic_friction_coefs = 'Forchheimer_coefficient'
    sum_linear_friction_name = 'diode_linear'
    sum_quadratic_friction_name = 'diode_quad'
    block = '6 7 8'
    turn_on_diode = true
  []

  [combine_linear_friction]
    type = ADPiecewiseByBlockVectorFunctorMaterial
    prop_name = 'combined_linear'
    subdomain_to_prop_value = '1 Darcy_coefficient
                               2 Darcy_coefficient
                               3 Darcy_coefficient
                               4 Darcy_coefficient
                               5 Darcy_coefficient
                               6 diode_linear
                               7 diode_linear
                               8 diode_linear
                               9 Darcy_coefficient
                               20 Darcy_coefficient
                               21 Darcy_coefficient'
  []

  [combine_quadratic_friction]
    type = ADPiecewiseByBlockVectorFunctorMaterial
    prop_name = 'combined_quadratic'
    subdomain_to_prop_value = '1 Forchheimer_coefficient
                               2 Forchheimer_coefficient
                               3 Forchheimer_coefficient
                               4 Forchheimer_coefficient
                               5 Forchheimer_coefficient
                               6 diode_linear
                               7 diode_linear
                               8 diode_linear
                               9 Forchheimer_coefficient
                               20 Forchheimer_coefficient
                               21 Forchheimer_coefficient'
  []

  ## Thermal conductivity of the fluid
  [pebble_bed_fluid_effective_conductivity]
    type = FunctorLinearPecletKappaFluid
    block = ${blocks_bed}
    porosity = porosity_energy
  []

  [non_pebble_bed_kappa]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = ${blocks_non_bed}
  []

  ## Drag coefficients
  [pebble_bed_drag_coefficient]
    type = FunctorKTADragCoefficients
    T_solid = T_solid
    T_fluid = T_fluid
    porosity = porosity
    block = ${blocks_bed}
  []

  [churchill_drag_coefficient]
    type = FunctorChurchillDragCoefficients
    block = 'flow1 inlet dio1 dio2 dio3'
  []

  [drag_open_flow_regions]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = ${Forch_open}
    block = 'flow2 flow5 outlet'
  []

  ## Heat transfer coefficients
  [pebble_bed_alpha]
    type = FunctorPetrovicPebbleBedHTC
    block = ${blocks_bed}
    porosity = porosity_energy
  []

  [equivalent_alpha_flow1]
    type = FunctorDittusBoelterWallHTC
    C = '${fparse C_DB * ApV_flow_1}'
    # block = 'flow1'
    block = 'flow1 flow2 flow3 flow4 flow5 inlet outlet'
  []

  [equivalent_alpha_diodes]
    type = FunctorDittusBoelterWallHTC
    C = '${fparse C_DB * ApV_diode}'
    block = 'dio1 dio2 dio3'
  []

#  [convert_wall_htc_to_alpha]
#    type = ADGenericFunctorMaterial
#    prop_names = 'alpha'
#    prop_values = 'wall_htc'
#    block = 'dio1 dio2 dio3 flow1'
#  []

  # in some regions we do not care about volumetric
  # heat transfer, but we might have to do sanity checks here
  [alpha_null]
    type = ADGenericFunctorMaterial
    prop_names = 'alpha'
    prop_values = '0'
    block = 'flow2 flow5 outlet  inlet dio1 dio2 dio3 flow1'
  []

  ## Solid phase properties
  [pebble_bed_kappa_s]
    type = FunctorPebbleBedKappaSolid
    radiation = BreitbachBarthels
    solid_conduction = ChanTien
    fluid_conduction = ZBS
    emissivity = ${pebble_emissivity}
    Youngs_modulus = 9e9
    Poisson_ratio = 0.136
    wall_distance = bed_geometry
    T_solid = T_solid
    block = ${blocks_bed}
    porosity = porosity_energy
  []

  [pebble_bed_solid_properties]
    type = PronghornSolidFunctorMaterialPT
    solid = graphite
    T_solid = T_solid
    block = ${blocks_bed}
  []

  [steel]
    type = ADGenericFunctorMaterial
    block = 'barrel vessel1 vessel2'
    prop_names = 'rho_s cp_s k_s'
    prop_values = '8000.0 ${fparse 500.0 * cp_multiplier} 21.5'
  []

  [reflector_full_density_graphite]
    type = ADGenericFunctorMaterial
    block = 'reflector'
    prop_names = 'rho_s cp_s k_s'
    prop_values = '1740.0 ${fparse 1697.0 * cp_multiplier} 26.0'
  []

  # Modeling solid everywhere. Open flow regions are modeled
  # as very low density/conductivity regions. Heat transfer
  # through them will be facilitated by conjugate heat transfer
  # from the adjacent walls that is converted to a volumetric term
  [dummy_open_flow_region_solid_props]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s cp_s k_s'
    prop_values = '1 1 1e-4'
    block = '${blocks_free_flow}'
  []

  # write k_s into kappa_s so we can use the same
  # kernel everywhere

  [non_pebble_bed_eff_solid_conductivity]
    type = ADGenericFunctorMaterial
    prop_names = 'eff_solid_conductivity'
    prop_values = 'k_s'
    block = '${blocks_free_flow} reflector barrel vessel1 vessel2'
    output_properties = 'eff_solid_conductivity'
    outputs = 'exo'
  []

  [pebble_bed_eff_solid_conductivity]
    type = ADGenericFunctorMaterial
    prop_names = 'eff_solid_conductivity'
    prop_values = 'kappa_s'
    block = '${blocks_bed}'
    output_properties = 'eff_solid_conductivity'
    outputs = 'exo'
  []
[]

[UserObjects]
  [graphite]
    type = FunctionSolidProperties
    # adjusted base core, matrix, and shell
    rho_s = 1631.59203
    # HEAT CAPACITY [J/kg/K] from DOE-HTGR-88111, REV 0.
    cp_s = '(0.54212 - 2.42667E-06 * t - 9.02725E+01 * pow(t, -1) - 4.34493E+04 * pow(t, -2) + 1.59309E+07 * pow(t, -3.) - 1.43688E+09 * pow(t, -4.)) * 4184.'
    k_s = 15.0 # from Kairos
  []
  [StainlessSteel]
    type = StainlessSteel
  []
  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = ${bed_height}
    inner_radius = ${inner_radius}
    outer_radius = ${outer_radius}
    axis = 1
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[FVBCs]
  # Radial conduction/radiation trough the stagnating Air BCs.
  [T_solid_conduction]
    type = FunctorThermalResistanceBC
    boundary = 'RCSS'
    geometry = 'cylindrical'
    variable = T_solid
    emissivity = 1e-10
    htc = 1e-10
    thermal_conductivities = 0.03 # Stagnant Air.
    inner_radius = 1.91
    conduction_thicknesses = 1.5
    T_ambient = 293.15
  []
  [T_solid_radiation]
    type = FVInfiniteCylinderRadiativeBC
    boundary = 'RCSS'
    variable = T_solid
    cylinder_emissivity = 0.8
    boundary_emissivity = 0.8
    boundary_radius = 1.91
    cylinder_radius = 3.41
    Tinfinity = 293.15
  []
  [Tinlet]
    type = FVPostprocessorDirichletBC
    boundary = 'inlet'
    variable = T_fluid
    postprocessor = 'Inlet_Temperature_BC'
  []
[]

[Postprocessors]
  [dt]
    type = TimestepSize
  []
  [Max_CFL]
    type = ElementExtremeValue
    variable = CFL_Now
    block = ${blocks_fluid}
  []
  [New_Dt]
    type = ParsedPostprocessor
    pp_names = 'Max_CFL dt'
    #Relaxed and limited growth timestep so that we dont end up in a cyclical problem
    function = 'min((10000*t/Max_CFL * dt/2 + dt/2) , dt*2)'
    execute_on = 'timestep_end'
    use_t = true
  []
  [Num_Picards]
    type = Receiver
    default = 0
  []

  [Inlet_Temperature_BC]
    type = Receiver
    default = 823.15
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Outlet_Pressure_BC]
    type = Receiver
    default = 2e5
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Outlet_Velocity_y]
    type = SideAverageValue
    boundary = 'outlet'
    variable = superficial_vel_y
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []

  ### Griffin values
  [total_power]
    type = ElementIntegralVariablePostprocessor
    block = 'flow3'
    variable = power_density
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []

  ### Pronghorn Values ###
  [Outlet_Velocity_PH]
    type = ParsedPostprocessor
    function = 'mass_flow_out / area_SAM / density'
    pp_names = 'mass_flow_out'
    constant_names = 'area_SAM density'
    constant_expressions = '1.327511 2201'
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Outlet_Pressure_PH]
    type = SideAverageValue
    boundary = 'outlet'
    variable = pressure
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Outlet_Temperature_PH]
    type = SideAverageValue
    boundary = 'outlet'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [Heatflux_RCCS]
    type = SideIntegralVariablePostprocessor
    boundary = 'RCSS'
    variable = T_solid
  []
  [Tfluid_core]
    type = ElementAverageValue
    block = 'flow3'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfluid_bottom]
    type = ElementAverageValue
    block = 'flow2'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfluid_upper]
    type = ElementAverageValue
    block = 'flow4 flow5'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfluid_diode]
    type = ElementAverageValue
    block = 'dio1 dio2 dio3'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Tfluid_downcomer]
    type = ElementAverageValue
    block = 'flow1'
    variable = T_fluid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Reflector_Temp]
    type = ElementAverageValue
    block = 'reflector'
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Barrel_Temp]
    type = ElementAverageValue
    block = 'barrel'
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Vessel_Temp]
    type = ElementAverageValue
    block = 'vessel1 vessel2'
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  ### ###
  [inlet_mdot]
    type = Receiver
    default = 1173.0
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [inlet_area]
    type = AreaPostprocessor
    boundary = 'inlet'
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [mass_flow_out]
    type = VolumetricFlowRate
    boundary = 'outlet'
    advected_quantity = 'rho_out'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [mass_flow_in]
    type = VolumetricFlowRate
    boundary = 'inlet'
    advected_quantity = 'rho_out'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    execute_on = 'INITIAL TIMESTEP_END TRANSFER'
  []
  [mass_flow_1]
    type = VolumetricFlowRate
    boundary = 'MF_1'
    advected_quantity = 'rho_out'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    execute_on = 'TIMESTEP_END TRANSFER'
  []
  [mass_flow_2]
    type = VolumetricFlowRate
    boundary = 'MF_2'
    advected_quantity = 'rho_out'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    execute_on = 'TIMESTEP_END TRANSFER'
  []
  [mass_flow_3]
    type = VolumetricFlowRate
    boundary = 'MF_3'
    advected_quantity = 'rho_out'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    execute_on = 'TIMESTEP_END TRANSFER'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
  [SMP]
    type = SMP
    full = true
    petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type
                            -ksp_gmres_restart -pc_factor_shift_type'
    petsc_options_value = ' lu superlu_dist 50 NONZERO'
  []
[]

[Executioner]
  type = Transient # Pseudo transient to reach steady state.
  solve_type = 'NEWTON'
  petsc_options = '-snes_converged_reason'
  line_search = 'none'

  # Problem time parameters.
  end_time = 1e+6
  dtmin = 1e-6
  dtmax = 10000

  # Iterations parameters.
  l_max_its = 50
  l_tol = 1e-6

  nl_max_its = 25
  nl_rel_tol = 1e-10
  nl_abs_tol = 1e-11
  nl_forced_its = 1

  # Steady state detection.
  steady_state_detection = true
  steady_state_tolerance = 1e-12
  steady_state_start_time = 0

  auto_advance = true

  # Adaptive time step scheme.
  [TimeStepper]
    type = PostprocessorDT
    dt = 1e-1
    postprocessor = New_Dt
  []

  # Automatic scaling
  automatic_scaling = true
  off_diagonals_in_auto_scaling = true
  compute_scaling_once = true
[]

[Outputs]
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
  perf_graph = true
  csv = true
  execute_on = 'INITIAL FINAL'
  [console]
    type = Console
    outlier_variable_norms = false
    all_variable_norms = false
  []
  [exo]
    type = Exodus
    execute_on = 'FINAL'
  []
[]
