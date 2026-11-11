
# ==============================================================================
# Model description:
# A standalone thermal hydraulics model of HTTR
# This model is being developed in stages
# Current stage consists of the following
# simplifying assumptions:
# -No azimuthal dependence. Rings with control
#   rod blocks have the area-averaged porosity
#   of the fuelled blocks and control rods
# -No crossflow
# -No bypass gaps
# -Permanent reflector has no flow, but side reflector has some flow
# -Spacer fins neglected
# Power is a Gaussian fit axially and uniform radially
# Gaussian fit derived from the 3D HTTR Griffin model in the VTB repo
# ------------------------------------------------------------------------------
# Idaho Falls, INL, March 1, 2024 10:15 AM
# Author(s)(name alph): Dr. Robert F. Kile
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Blocks -----------------------------------------------------------------------

porous_blocks = '0 1 3 8 10 11 12 13 14 21 22 23 24 31 32 33 34 61 62 71 72 4 41 43 88 99 222'
solid_only_blocks = '9 101 111'

solid_blocks = '${porous_blocks} ${solid_only_blocks}'
fluid_only_blocks = '5'
fluid_blocks = '${porous_blocks} ${fluid_only_blocks}'
fuel_blocks = '11 21 31'
reflect_blocks = ' 12 13 14 22 23 24 32 33 34 '

seal_and_key_blocks = '61 62 71 72'
PGX_blocks = '61 62 71 72 9'
IG_110_blocks = '0 1 3 11 12 13 14 21 22 23 24 31 32 33 34 4 41 43 8 10'
IG_110_etc_blocks = '11 12 13 14 21 22 23 24 31 32 33 34'
IG_110_k_blocks = '0 1 3 4 41 43 10'

gap_blocks = '99 88 222'

# Global parameters ------------------------------------------------------------
cool_hole_rad = ${fparse 41/2000} #m
fuel_compact_rad = ${fparse 34/2000} #m
block_height = 0.580  #m


mdot =  11.5582 #kg/s

sysPress = 4e6 #Pa
TIn = 668.15  #K
inDens = 2.8606 #Helium density at 3.93 MPa and 665 K, taken from NIST Webbook
centRefRad = 0.189013524 #m
ring1Rad = 0.50008278 #m
ring2Rad = 0.823890852 #m
ring3Rad = 1.149724384 #m

PSRRad = 2.15211
sideShieldInRad = 2.1750
sideShieldOutRad = 2.271
PSR2ShieldGap = ${fparse sideShieldInRad - PSRRad}
vesselInnerRadius = 2.750
vesselOuterRadius = 2.872
shield2VessGap = ${fparse vesselInnerRadius - sideShieldOutRad}
inFlowArea = ${fparse pi * (vesselInnerRadius*vesselInnerRadius - PSRRad*PSRRad)}
cavityDiam = 7.41 #m
cavityRad = ${fparse cavityDiam/2}



# Calcluating a few values -----------------------------------------------------

ring1Vol = ${fparse pi * (ring1Rad * ring1Rad - centRefRad * centRefRad) * block_height}
ring2Vol = ${fparse pi * (ring2Rad * ring2Rad - ring1Rad * ring1Rad)  * block_height}
ring3Vol = ${fparse pi * (ring3Rad * ring3Rad - ring2Rad * ring2Rad) * block_height}

# Defining other axial mesh stuff here -----------------------------------------



[Mesh]
  [restart]
    type = FileMeshGenerator
    file = './LOFC2_Steady.e'

  []
  coord_type = 'RZ'
[]

 [Problem]
  restart_file_base = './A01b_Griffin_restarts_cp/LATEST'
 []

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [T_solid]
    type = INSFVEnergyVariable
    block = '${solid_blocks}'
  []
  [T_fluid]
    type = INSFVEnergyVariable

    block = '${fluid_blocks}'
  []
[]

[FVKernels]
  [energy_storage]
    type = PINSFVEnergyTimeDerivative
    is_solid = true
    variable = T_solid
    rho = rho_s
    cp = cp_s
    porosity = porosity
    block = '${solid_blocks}'
  []
  [solidConduct]
    type = FVAnisotropicDiffusion
    coeff = 'ks'
    variable = 'T_solid'
    block = '${solid_blocks}'
  []
  [heat_source]
    type = FVCoupledForce
    variable = T_solid
    v = pow_dens
    block = '11 21 31'
  []
  [convection]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = 'wall_htc'
    block = '${porous_blocks}'
  []
[]

[FVBCs]
  [vesselRadiate]
    type = FVInfiniteCylinderRadiativeBC
    boundary = right
    boundary_radius = ${vesselOuterRadius}
    cylinder_radius = ${cavityRad}
    variable = T_solid
    Tinfinity = VCS_fun
    boundary_emissivity = 0.8
    cylinder_emissivity = 0.48
  []
  [Corebot_rad]
    type = FVFunctorRadiativeBC
    boundary = core_bottom
    variable = T_solid
    Tinfinity = 569.0
    emissivity = 0.8
  []
  [vessel_convect]
    type = FVFunctorConvectiveHeatFluxBC
    boundary = right
    variable = T_solid
    T_solid = T_solid
    T_bulk = VCS_fun
    heat_transfer_coefficient = 5
    is_solid = true
  []
  [vessel_conduct]
    type = FunctorThermalResistanceBC
    boundary = 'right'
    variable = T_solid
    emissivity = 1e-10
    htc = 1e-10
    thermal_conductivities = 0.2 # Stagnant Helium.
    inner_radius = ${vesselOuterRadius}
    conduction_thicknesses = ${fparse cavityRad - vesselOuterRadius}
    T_ambient = 569.0
  []
[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
      compressibility = 'weakly-compressible'
      porous_medium_treatment = true
      density = rho
      dynamic_viscosity = mu
        block = '${fluid_blocks}'
        gravity = '0 -9.81 0'
        porosity = porosity
        porosity_interface_pressure_treatment =BERNOULLI
        consistent_scaling = 500
        pressure_drop_sidesets ='CR_up CR_low CR_low2Bot CR_bot2seal ring1_upRefIn ring1_fuelIn ring1_fuelOut ring1_low2Bot ring1_lowRefOut ring2_upRefIn ring2_fuelIn
         ring2_fuelOut ring2_low2Bot ring2_lowRefOut ring3_plen2Shield ring3_upRefIn ring3_fuelIn ring3_fuelOut ring3_low2Bot ring3_lowRefOut ring4_up
          ring4_low ring4_low2Bot ring4_bot key1_to_LP key2_to_LP'
        pressure_drop_form_factors = '0.997 0.052035191 0.494842129 0.99521 0.4989 2.85852e-5 5.71753e-5 4.96885e-6 0.283389 0.4989 0.012821034 5.71753e-5 4.96885e-6 0.2845 0.4934 0.303626808 0.012821041 0.086956529 0.250399771 0.196172944  0.4971 0.052035196 0.494842133 0.957305252 0.4122 0.4122 '

        # Boundary conditions
        inlet_boundaries = inletBound
        momentum_inlet_types = fixed-velocity
        momentum_inlet_functors = '0 vel_in_fun'
        wall_boundaries = 'fluid_sym psr_top psr_left psr_right LP_floor sideShield vessel upplen_top out_chute_right plen_Lower_Side'
        momentum_wall_types = 'SYMMETRY slip slip slip slip slip slip slip slip slip'

        # Outlet BCs
        outlet_boundaries = reactor_outlet
        momentum_outlet_types = fixed-pressure
        pressure_functors = '${sysPress}'

        # Friction control parameters
        friction_types = 'darcy forchheimer'
        friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
        use_friction_correction = true

        # Numerical Schemes
        pressure_face_interpolation      = average
        momentum_advection_interpolation = upwind
        mass_advection_interpolation     = upwind
        hydraulic_separator_sidesets = 'ring0_to_1_boundary ring1_to_2_boundary ring2_to_3_boundary ring3_to_4_boundary sealandKey_boundary'
      []
    []
    [FluidHeatTransfer]
      [heat]
        coupled_flow_physics = 'flow'
        thermal_conductivity = 'kappa'
        specific_heat = 'cp'
        fluid_temperature_variable ='T_fluid'
        energy_inlet_types = fixed-temperature
        energy_inlet_functors = 'TIn_fun'
        energy_wall_types = 'heatflux heatflux heatflux heatflux heatflux heatflux heatflux heatflux heatflux heatflux'
        energy_wall_functors = '0 0 0 0 0 0 0 0 0 0'
        ambient_convection_blocks = '${porous_blocks}'
        ambient_convection_alpha = 'wall_htc'
        ambient_temperature = 'T_solid'
        energy_advection_interpolation = 'upwind'
    []
[]
[]
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [porosityVar]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [cpVar]
    family = MONOMIAL
    order = CONSTANT
    fv = true
    block = '${fluid_blocks}'
  []
  [cp_s_Var]
    family = MONOMIAL
    order = CONSTANT
    block = ${solid_blocks}
  []
  # Velocity calculation.
  [vel_x]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [vel_y]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [vel_z]
    family = MONOMIAL
    order = CONSTANT
    fv = true
  []
  [powerVisVar]
    family = MONOMIAL
    order = CONSTANT
  []
  [pow_dens]
    family = MONOMIAL
    order = CONSTANT
  []
  [wall_htc_var]
    type = MooseVariableFVReal
  []
  [ReynoldsVar]
    family = MONOMIAL
    order = CONSTANT
  []
  [Density]
    family = MONOMIAL
    order = CONSTANT
  []
  [rho_s_Var]
    family = MONOMIAL
    order = CONSTANT
    block = '${solid_blocks}'
  []
  [power_ring1]
    family = MONOMIAL
    order = CONSTANT
  []
  [power_ring2]
    family = MONOMIAL
    order = CONSTANT
  []
  [power_ring3]
    family = MONOMIAL
    order = CONSTANT
  []
  [k_s_vis]
    family = MONOMIAL
    order = CONSTANT
    block = ${solid_blocks}
  []
  [T_fuelCompact_avg]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [num_pins_in_ring]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [htc_surface]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [viscosity]
    family = MONOMIAL
    order = CONSTANT
    block = '${fluid_blocks}'
  []
  [speedVar]
    family = MONOMIAL
    order = CONSTANT
    block = '${fluid_blocks}'
  []
  [conductivity]
    family = MONOMIAL
    order = CONSTANT
    block = '${fluid_blocks}'
  []
  [Lc]
    family = MONOMIAL
    order = CONSTANT
    block = '${fluid_blocks}'
  []
  [power_per_pin]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [T_mod]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [T_sleeve]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [copy_Tfluid]
    family = MONOMIAL
    order = CONSTANT
    block = '11 21 31'
  []
  [pressure_diff]
    family = MONOMIAL
    order = CONSTANT
    block = ${fluid_blocks}
  []
[]
[AuxKernels]
  # Velocity calculation.
  [vel_x]
    type = ParsedAux
    variable = vel_x
    expression = 'superficial_vel_x/porosityVar'
    coupled_variables = 'superficial_vel_x porosityVar'
    block = '${fluid_blocks}'
  []
  [vel_y]
    type = ParsedAux
    variable = vel_y
    expression = 'superficial_vel_y/porosityVar'
    coupled_variables = 'superficial_vel_y porosityVar'
    block = '${fluid_blocks}'
  []
  [vel_z]
    type = ParsedAux
    variable = vel_z
    expression = 0.0
    block = '${fluid_blocks}'
  []
  [porosity_out]
    type = FunctorAux
    functor = 'porosity'
    variable = 'porosityVar'
  []
  [cp_out]
    type = FunctorAux
    functor = 'cp'
    variable = 'cpVar'
    block = '${fluid_blocks}'
  []
  [cp_s_out]
    type = FunctorAux
    functor = 'cp_s'
    variable = 'cp_s_Var'
    block = '${solid_blocks}'
  []
  [rho_s_out]
    type = FunctorAux
    functor = 'rho_s'
    variable = 'rho_s_Var'
    block = '${solid_blocks}'
  []
  [pow_dens_1]
    type = ParsedAux
    variable = pow_dens
    expression = 'power_ring1 / r1Vol'
    coupled_variables = 'power_ring1'
    constant_names = 'r1Vol'
    constant_expressions = '${ring1Vol}'
    block = '11'
  []
  [pow_dens_2]
    type = ParsedAux
    variable = pow_dens
    expression = 'power_ring2 / r2Vol'
    coupled_variables = 'power_ring2'
    constant_names = 'r2Vol'
    constant_expressions = '${ring2Vol}'
    block = '21'
  []
  [pow_dens_3]
    type = ParsedAux
    variable = pow_dens
    expression = 'power_ring3 / r3Vol'
    coupled_variables = 'power_ring3'
    constant_names = 'r3Vol'
    constant_expressions = '${ring3Vol}'
    block = '31'
  []
  [wall_htc_aux]
    type = FunctorAux
    variable = wall_htc_var
    functor = wall_htc
    block = '${porous_blocks}'
  []
  [ReyNum_aux]
    type = FunctorAux
    functor = 'Re'
    variable = 'ReynoldsVar'
    block = '${fluid_blocks}'
  []
  [densAux]
    type = FunctorAux
    functor = 'rho'
    variable = 'Density'
    block = '${fluid_blocks}'
  []
  [powVis1]
    type = CopyValueAux
    source = power_ring1
    variable = powerVisVar
    block = '11 12 13 61'
  []
  [powVis2]
    type = CopyValueAux
    source = power_ring2
    variable = powerVisVar
    block = '21 22 23'
  []
    [powVis3]
    type = CopyValueAux
    source = power_ring3
    variable = powerVisVar
    block = '31 32 33'
  []
  [ks_out]
    type = FunctorMaterialRealVectorValueAux
    functor = 'ks'
    variable = 'k_s_vis'
    component = 0
    block = '${solid_blocks}'
  []
  [num_pins_33] #total number of pins per ring in ring 1 and 2 (each has 6 blocks of 33 pins) for calculating pin power density
    type = ParsedAux
    variable = num_pins_in_ring
    block = '11 21'
    expression = '6*33'
  []
  [num_pins_31] #total number of pins per ring in ring 3 (has 18 blocks of 31 pins) for calculating pin power density
    type = ParsedAux
    variable = num_pins_in_ring
    block = '31'
    expression = '18*31'
  []
  [htc_non_volumetric_33_pin_blocks]
    type = ParsedAux
    variable = htc_surface
    block = '11'
    functor_names = 'wall_htc'
    functor_symbols = 'wall_htc'
    expression = 'wall_htc/69.27'
  []
  [htc_non_volumetric_fuel2]
    type = ParsedAux
    variable = htc_surface
    block = '21'
    functor_names = 'wall_htc'
    functor_symbols = 'wall_htc'
    expression = 'wall_htc/34.64'
  []
  [htc_non_volumetric_31_pin_blocks]
    type = ParsedAux
    variable = htc_surface
    block = '31'
    functor_names = 'wall_htc'
    functor_symbols = 'wall_htc'
    expression = 'wall_htc/65.07'
  []
  [viscosity]
    type = FunctorAux
    functor = 'mu'
    variable = 'viscosity'
    block = '${fluid_blocks}'
  []
  [speed]
    type = FunctorAux
    functor = 'speed'
    variable = 'speedVar'
    block = '${fluid_blocks}'
  []
  [conductivity]
    type = FunctorAux
    functor = 'k'
    variable = 'conductivity'
    block = '${fluid_blocks}'
  []
  [power_per_pin]
    type = ParsedAux
    variable = 'power_per_pin'
    coupled_variables = 'powerVisVar num_pins_in_ring'
    expression = 'powerVisVar/num_pins_in_ring'
    block = '11 21 31'
  []
  [copy_Tfluid]
    type = ParsedAux
    variable = 'copy_Tfluid'
    coupled_variables = 'T_fluid'
    expression = 'T_fluid'
    block = '11 21 31'
  []
  [T_mod]
    type = ParsedAux
    variable = T_mod
    coupled_variables = 'T_sleeve T_solid'
    expression = '0.15*T_sleeve+0.85*T_solid'
  []
  [Lc]
    type = FunctorAux
    functor = 'characteristic_length'
    variable = 'Lc'
    block = '${fluid_blocks}'
  []
  [pressure_diff]
    type = ParsedAux
    variable = 'pressure_diff'
    coupled_variables = 'pressure'
    expression = 'pressure-${sysPress}'
    block = ${fluid_blocks}
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[Functions]
  [mfr_fun]
    type = PiecewiseLinear
    x = '-1000 0 60'
    y = '${mdot} ${mdot} 0.0'
  []
  [vel_in_fun]
    type = ParsedFunction
    expression = 'mfr_fun/${inFlowArea}/${inDens}'
    symbol_names = 'mfr_fun'
    symbol_values = 'mfr_fun'
  []
  [TIn_fun]
    type = PiecewiseLinear
    x = '0.0 60000'
    y =  '${TIn} ${TIn}'
  []
  [VCS_fun]
    type = PiecewiseLinear
    x = '0.0 60000'
    y =  '560.0 560.0'
  []
  [out_pres_fn]
    type = PiecewiseLinear
    x = '0.0 60000'
    y =  '4e6 4e6'
  []
    [timestep]
     type = PiecewiseConstant
    x = ' -100       0.0  1000 10000 32400 39600'
     y = '5.0        5.0   10.0   50.0   50.   10.0'
    #  y = '0.01 0.01 0.01'
     direction = left
  []
[]
# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[FunctorMaterials]
  [porosity_material]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = porosity
    subdomain_to_prop_value = 'inRef0         0.1389
                               inRef1         0.3176
                               inRef2         0.1224
                               ring1UpShield  0.1221
                               ring1Up        0.1221
                               ring1          0.1212
                               ring1Low       0.1224
                               ring2UpShield  0.0611
                               ring2Up        0.0611
                               ring2          0.0606
                               ring2Low       0.1224
                               ring3UpShield  0.1147
                               ring3Up        0.1147
                               ring3          0.1139
                               ring3Low       0.1224
                               sideRef    0.0898
                               sideRef_low 0.205
                               sideRef_bot 0.045
                               seal1      0.1755
                               seal2      0.1755
                               key1       0.1231
                               key2       0.1231
                               lowPlen    0.962
                               upPlen     1.0
                               psr        0.0
                              gap2Shield  0.9
                              sideShield  0.0
                          shield2VessGap  0.9
                                  vessel  0.0
                               inletArea  1.0
                               lp_out     0.3862'
  []
  [htc_ring0_upper]
    type = FunctorDittusBoelterWallHTC
    block = '0'
    C = '${fparse 0.023*16.65}'
  []
  [htc_ring0_lower]
    type = FunctorDittusBoelterWallHTC
    block = '1'
    C = '${fparse 0.023*10.32}'
  []
  [htc_bot_ref]
    type = FunctorDittusBoelterWallHTC
    block = '3 13 23 33'
    C = '${fparse 0.023*9.069}'
  []
  [htc_ring1_upper]
    type = FunctorDittusBoelterWallHTC
    block = '12 14'
    C = '${fparse 0.023*21.24}'
  []
  [htc_ring1_fuel]
    type = FunctorDittusBoelterWallHTC
    block = '11'
    C = '${fparse 0.023*69.27}'
  []
  [htc_ring2_upper]
    type = FunctorDittusBoelterWallHTC
    block = '22 24'
    C = '${fparse 0.023*18.95}'
  []
  [htc_ring2_fuel]
    type = FunctorDittusBoelterWallHTC
    block = '21'
    C = '${fparse 0.023*34.64}'
  []
  [htc_ring3_upper]
    type = FunctorDittusBoelterWallHTC
    block = '32 34'
    C = '${fparse 0.023*19.95}'
  []
  [htc_ring3_fuel]
    type = FunctorDittusBoelterWallHTC
    block = '31'
    C = '${fparse 0.023*65.07}'
  []
  [htc_ring4_upper]
    type = FunctorDittusBoelterWallHTC
    block = '4'
    C = '${fparse 0.023*8.32}'
  []
  [htc_ring4_lower]
    type = FunctorDittusBoelterWallHTC
    block = '41'
    C = '${fparse 0.023*5.164}'
  []
  [htc_ring4_bot]
    type = FunctorDittusBoelterWallHTC
    block = '43'
    C = '${fparse 0.023*4.53}'
  []
  [htc_seal]
    type = FunctorDittusBoelterWallHTC
    block = '61 62'
    C = '${fparse 0.023*19.32}'
  []
  [htc_key]
    type = FunctorDittusBoelterWallHTC
    block = '71 72'
    C = '${fparse 0.023*19.32}'
  []
  [htc_lower_plenum]
    type = FunctorDittusBoelterWallHTC
    block = '8'
    C = '${fparse 0.023*0.0}'
  []
  [htc_outlet_chute]
    type = FunctorDittusBoelterWallHTC
    block = '10'
    C = '${fparse 0.023*0.0}' #outlet chute is insulated from fluid
  []

  [kappa_f_core]
    type = FunctorLinearPecletKappaFluid
    porosity = porosity
    block = '${porous_blocks}'
  []
  [kappa_f_plena]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = '${fluid_only_blocks}'
  []
  [charact_len_core]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values =  ${fparse 2 * (cool_hole_rad - fuel_compact_rad)}
    block = '11 31'
  []
  [charact_len_r3Up]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.033
    block = '14 24 34'
  []
  [charact_len_mixedRing]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values =  ${fparse 2 * (cool_hole_rad - fuel_compact_rad)}
    block = '21'
  []
  [charact_len_Ref]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.023
    block = '12 22 32'
  []
  [charact_len_botBlock]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.054
    block = '3 13 23 33'
  []
  [charact_len_ring4_bot]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.054
    block = '43'
  []
  [charact_len_key]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values =  0.35
    block = '71 72'
  []
  [charact_len_Seal]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.158
    block = '61 62'
  []
  [charact_len_inRef]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.123
    block = '0'
  []
  [charact_len_inRef1]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.123
    block = '1'
  []
  [charact_len_outRef]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.054
    block = '4 41'
  []
  [charact_len_lowPlen]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.15
    block = '8 10 222'
  []
  [drag_core]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    critical_Reynolds = 0.001
    block = '${fuel_blocks} ${reflect_blocks}'
  []
  [drag_ring1_4]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 800 1'
    critical_Reynolds = 0.001
    block = '0 1 3 4 41 43'
  []
  [drag_sealKey]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    critical_Reynolds = 0.001
    block = '${seal_and_key_blocks}'
  []
  [drag_lowPlen]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    critical_Reynolds = 0.001
    block = 'lowPlen lp_out'
  []
  [drag_cavity]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    critical_Reynolds = 0.001
    block = '${fluid_only_blocks} ${gap_blocks}'
  []
  [heProps]
    type = GeneralFunctorFluidProps
    fp = fluid_properties_obj
    porosity = porosity
    pressure = pressure
    T_fluid = ${TIn}
    speed = speed
    characteristic_length = 'characteristic_length'
    block = '${fluid_blocks}'
  []
  [charact_len_gap2Shield]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    block = 'gap2Shield'
    prop_values = '${fparse 2 * (sideShieldInRad - PSRRad)}'
  []
  [charact_len_Shield2Ves]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 0.158
    block = 'shield2VessGap'
  []
  [charact_len_UpPlen]
    type = GenericFunctorMaterial
    prop_names = 'characteristic_length'
    prop_values = 5.5
    block = '5'
  []
  [htc_PSR]
    type = FunctorDittusBoelterWallHTC
    block = 'gap2Shield'
    C = ${fparse 0.023*87.37}
  []
  [htc_PSR_AD]
    type = ADDittusBoelterFunctorMaterial
    block = 'gap2Shield'
    D_h = characteristic_length
    Hw = 'PSR_htc'
    Re = Re
    Pr = Pr
    T_fluid = T_fluid
    T_wall = T_solid
    k = k
  []
  [htc_shieldOut]#2 is calculated as SA/unit vol. For an annulus, this is (2*pi*r_o + 2*pi*r_i)/(pi*(r_o^2-r_i^2))
    type = FunctorDittusBoelterWallHTC
    block = 'shield2VessGap 222'
    C = ${fparse 0.023*4.175}
  []

  [IG110_etc]
    type = ADParsedFunctorMaterial
    expression = 0.0088*T+5.1894
    property_name = IG110_etc
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [IG110_etc_axial]
    type = ADParsedFunctorMaterial
    expression = 'if(T<470, 21.75, if(T>1134, 41.2, 0.000036*T*T - 0.028186*T + 26.8237))'
    property_name = IG110_etc_axial
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [IG110_ks]
    type = ADParsedFunctorMaterial
    expression = '0.00001712*T*T - 0.04994*T + 63.42'
    property_name = IG110_ks
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [IG110_cp]
    type = ADParsedFunctorMaterial
    expression = 'if(T<373.15, 919.431, if(T>1973.15, 2018.363, 0.00000049*T*T*T - 0.00229440*T*T + 3.72451512*T - 148.12670288))'
    property_name = cp_s
    functor_names = 'T_solid'
    functor_symbols = 'T'
    block = '${IG_110_blocks}'
  []
  [IG110_rho]
    type = ADParsedFunctorMaterial
    expression = '1770'
    property_name = rho_s
    block = '${IG_110_blocks}'
  []
  [PGX_ks]
    type = ADParsedFunctorMaterial
    expression = 'if(T<373.15, 117.08, if(T>1873.15, 46.54, 0.000032*T*T - 0.117148*T + 155.356064))'
    property_name = PGX_ks
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [PGX_cp]
    type = ADParsedFunctorMaterial
    expression = 'if(T<373.15, 919.44, if(T>1873.15, 2005.41, 0.00000055*T*T*T - 0.00248282*T*T + 3.89862632*T - 194.78383145))'
    property_name = cp_s
    functor_names = 'T_solid'
    functor_symbols = 'T'
    block = '${PGX_blocks}'
  []
  [PGX_rho]
    type = ADParsedFunctorMaterial
    expression = '1780'
    property_name = rho_s
    block = '${PGX_blocks}'
  []
  [SS_ks]
    type = ADParsedFunctorMaterial
    expression = 'if(T<300, 11.83, if(T>1000, 20.53, 0.012432*T + 8.097857))'
    property_name = SS_ks
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [SS304_cp]
    type = ADParsedFunctorMaterial
    expression = 'if(T<298.15, 480, if(T>1273.15, 642, 0.161084*T + 444.819083))'
    property_name = SS304_cp
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [SS316_cp]
    type = ADParsedFunctorMaterial
    expression = 'if(T<298.15, 470, if(T>1273.15, 660, 0.186413*T + 425.451045))'
    property_name = cp_s
    functor_names = 'T_solid'
    functor_symbols = 'T'
    block = 'sideShield 88 99 222'
  []
  [SS_rho]
    type = ADParsedFunctorMaterial
    expression = '7780'
    property_name = rho_s
    block = 'sideShield 88 99 222'
  []
  [SS_vessel_ks] #stainless steel for vessel and core support structures
    type = ADParsedFunctorMaterial
    expression = '37'
    property_name = SS_vessel_ks
    functor_names = 'T_solid'
    functor_symbols = 'T'
  []
  [vessel_cp]
    type = ADParsedFunctorMaterial
    expression = '650'
    property_name = cp_s
    functor_names = 'T_solid'
    functor_symbols = 'T'
    block = 'vessel'
  []
  [vessel_rho]
    type = ADParsedFunctorMaterial
    expression = '7800'
    property_name = rho_s
    block = 'vessel'
  []
  [etc_IG110]
    type = ADGenericVectorFunctorMaterial
    block = '${IG_110_etc_blocks}'
    prop_names = 'ks'
    prop_values = 'IG110_etc  IG110_etc_axial  IG110_etc '
  []
  [k_IG110]
    type = ADGenericVectorFunctorMaterial
    block = '${IG_110_k_blocks}'
    prop_names = 'ks'
    prop_values = 'IG110_etc IG110_etc_axial IG110_etc'
  []
  [k_IG110_lower_plenum] #Lower plenum solid is only disconnected axial support posts, can't conduct radially
    type = ADGenericVectorFunctorMaterial
    block = '8'
    prop_names = 'ks'
    prop_values = '0 IG110_ks 0'
  []
  [etc_PGX]
    type = ADGenericVectorFunctorMaterial
    block ='9'
    prop_names = 'ks'
    prop_values = 'PGX_ks PGX_ks PGX_ks'
  []
  [etc_seal_and_key]
    type = ADGenericVectorFunctorMaterial
    block ='${seal_and_key_blocks}'
    prop_names = 'ks'
    prop_values = 'IG110_etc PGX_ks IG110_etc'
  []
  [etc_shield]
    type = ADGenericVectorFunctorMaterial
    block = 'sideShield'
    prop_names = 'ks'
    prop_values = 'SS_ks SS_ks SS_ks'
  []
  [etc_structures]
    type = ADGenericVectorFunctorMaterial
    block = 'vessel'
    prop_names = 'ks'
    prop_values = 'SS_vessel_ks SS_vessel_ks SS_vessel_ks'
  []
  [gap1Material]
    type = FunctorGapHeatTransferEffectiveThermalConductivity
    emissivity_primary = 0.8
    emissivity_secondary = 0.8
    gap_conductivity_function = 0.27
    temperature = T_solid
    block = '88'
    gap_width = ${PSR2ShieldGap}
    prop_name = 'ks'
  []
  [gap2Material]
    type = FunctorGapHeatTransferEffectiveThermalConductivity
    emissivity_primary = 0.8
    emissivity_secondary = 0.8
    gap_conductivity_function = 35
    temperature = T_solid
    gap_width = ${shield2VessGap}
    prop_name = 'ks'
    block = '99 222'
  []
[]
# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package
                        -ksp_gmres_restart -sub_pc_factor_shift_type'
  petsc_options_value = 'lu mumps 100 NONZERO'
  line_search = l2

  # Scaling.
  automatic_scaling = true
  off_diagonals_in_auto_scaling = true
  compute_scaling_once = false

  # Tolerances
  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-8
  nl_max_its = 25
  # Time step control.
  [TimeSteppers]
    [ts1]
      type = FunctionDT
      function = timestep
    []
  []
  error_on_dtmin = false
  start_time = -100.0
  end_time = 64800
[]
# ==============================================================================
# Multi-app for fuel compacts
# ==============================================================================
[MultiApps]
  [compactApp]
    type = CentroidMultiApp
    input_files = 'D02_Bison.i'
    output_in_position = true
    block = '11 21 31'
    app_type = BluecrabApp
  []
[]
[Transfers]
  [helium_temperature_transfer]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    source_variable = copy_Tfluid
    postprocessor = avg_Tfluid
    to_multi_app = compactApp
  []
  [wall_temperature_transfer]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    source_variable = T_solid
    postprocessor = avg_Tmod
    to_multi_app = compactApp
  []
  [htc_transfer]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    source_variable = htc_surface
    postprocessor = avg_htc
    to_multi_app = compactApp
  []
  [pow_dens_transfer]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    source_variable = power_per_pin
    postprocessor = avg_pin_power
    to_multi_app = compactApp
  []
  [Tfuel_from_compact]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = compactApp
    postprocessor = avg_Tfuel
    variable = T_fuelCompact_avg
  []
  [Tsleeve_from_compact]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = compactApp
    postprocessor = avg_Tsleeve
    variable = T_sleeve
  []
[]
# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [inlet_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'inletBound'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [outlet_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    vel_z = 'vel_z'
    boundary = 'reactor_outlet'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [ring0_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'CR_low2Bot'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [ring1_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'ring1_low2Bot'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [ring2_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'ring2_low2Bot'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [ring3_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'ring3_low2Bot'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [ring4_mfr]
    type = VolumetricFlowRate
    advected_quantity = rho
    vel_x = 'vel_x'
    vel_y = 'vel_y'
    boundary = 'ring4_low2Bot'
    rhie_chow_user_object = pins_rhie_chow_interpolator
  []
  [inlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = inletBound
    outputs = none
  []
  [inlet_temp]
    type = MassFluxWeightedFlowRate
    boundary = 'inletBound'
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = 'T_fluid'
    density = 'rho'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    execute_on = 'timestep_end'
  []
  [inner_key_fluid_temp]
    type = MassFluxWeightedFlowRate
    boundary = 'key1_to_LP'
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = 'T_fluid'
    density = 'rho'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    execute_on = 'timestep_end'
  []
  [outer_key_fluid_temp]
    type = MassFluxWeightedFlowRate
    boundary = 'key2_to_LP'
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = 'T_fluid'
    density = 'rho'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    execute_on = 'timestep_end'
  []
  [outlet_temp]
    type = MassFluxWeightedFlowRate
    boundary = 'reactor_outlet'
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = 'T_fluid'
    density = 'rho'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    execute_on = 'timestep_end'
  []
  [upPlen_press]
    type = ElementAverageValue
    block = 5
    variable = pressure
  []
  [lowPlen_press]
    type = ElementAverageValue
    block = '8 10'
    variable = pressure
  []
  [core_dP]
    type = ParsedPostprocessor
    pp_names = 'upPlen_press lowPlen_press'
    expression = 'upPlen_press - lowPlen_press'
  []
  [outlet_pressure]
    type = SideAverageValue
    variable = pressure
    boundary = reactor_outlet
    outputs = none
  []
  [pressure_drop]
    type = ParsedPostprocessor
    pp_names = 'inlet_pressure outlet_pressure'
    expression = 'inlet_pressure - outlet_pressure'
  []
  [T_solid_max]
    type = ADElementExtremeFunctorValue
    functor = T_solid
    block = '${solid_blocks}'
  []
  [T_solid_avg]
    type = ElementAverageValue
    variable = T_solid
    block = '${solid_blocks}'
  []
  [vessel_t_avg]
    type = ElementAverageValue
    variable = T_solid
    block = 'vessel'
  []
  [T_fuelBlock_avg]
    type = ElementAverageValue
    variable = T_solid
    block = '11 21 31'
  []
[totalPower]
  type = ElementIntegralFunctorPostprocessor
  functor = pow_dens
[]
[powerIntegral_ring1]
  type = ElementIntegralFunctorPostprocessor
  functor = power_ring1
[]
[powerIntegral_ring2]
  type = ElementIntegralFunctorPostprocessor
  functor = power_ring2
[]
[powerIntegral_ring3]
  type = ElementIntegralFunctorPostprocessor
  functor = power_ring3
[]
  [T_fuelCompact_avg]
    type = ElementAverageValue
    variable = T_fuelCompact_avg
    execute_on = 'initial timestep_end'
    block = '${fuel_blocks}'
  []
  [T_mod_avg]
    type = ElementAverageValue
    variable = T_mod
    execute_on = 'initial timestep_end'
    block = '${fuel_blocks}'
  []
  [TC_81]
    type = PointValue
    point = '1.477 8.27 0'
    variable = T_solid
    execute_on = 'initial timestep_end'
  []
  [TC_84]
    type = PointValue
    point = '1.8 3.2 0'
    variable = T_solid
    execute_on = 'initial timestep_end'
  []
  [TC_78]
    type  = PointValue
    point = '1.477 9.72 0'
    variable = T_solid
    execute_on = 'initial timestep_end'
  []
  [TC_87]
    type = PointValue
    point = '1.477 4.5 0'
    variable = T_solid
    execute_on = 'initial timestep_end'
  []
  [TC_97]
    type = PointValue
    point = '2.87 6.82 0'
    variable = T_solid
    execute_on = 'initial timestep_end'
  []
  [rccs_power]
    type = ADSideDiffusiveFluxIntegral
    variable = T_solid
    boundary = right
    functor_diffusivity = SS_vessel_ks
  []
  [pressure_ring1_fuelin]
    type = SideAverageValue
    variable = pressure
    boundary = ring1_fuelIn
  []
  [pressure_ring1_fuelout]
    type = SideAverageValue
    variable = pressure
    boundary = ring1_fuelOut
  []
  [dP_ring1]
    type = ParsedPostprocessor
    pp_names = 'pressure_ring1_fuelin pressure_ring1_fuelout'
    expression = 'pressure_ring1_fuelin - pressure_ring1_fuelout'
  []
[]
[Outputs]
  file_base = LOFC2
  print_linear_residuals = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  [exodus]
    type = Exodus
    execute_on = 'initial timestep_end'
    time_step_interval = 100
  []
  [csv]
    type = CSV
    time_step_interval = 5
  []
[]
