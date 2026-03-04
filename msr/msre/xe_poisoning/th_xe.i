# ==============================================================================
# Model description
# Molten Salt Reactor Experiment (MSRE) Model - Steady-State Model
# Primary Loop Thermal Hydraulics Model
# Integrates:
# - Porous media model for reactor primary loop
# - Weakly compressible, turbulent flow formulation
# MSRE: reference plant design based on 5MW of MSRE Experiment.
# ==============================================================================
# Author(s): Dr. Mauricio Tano, Dr. Samuel Walker
# ==============================================================================
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------
# Geometry ---------------------------------------------------------------------
core_radius = 0.69793684

# Properties -------------------------------------------------------------------
core_porosity = 0.222831853 # core porosity salt VF=0.222831853, Graphite VF=0.777168147
down_comer_porosity = 1.0 # downcomer porosity
lower_plenum_porosity = 0.5 # lower pelnum porosity
upper_plenum_porosity = 1.0 # upper pelnum porosity
riser_porosity = 1.0 # riser porosity
pump_porosity = 1.0 # pump porosity
elbow_porosity = 1.0 # elbow porosity
bypass_line_porosity = 1.0 # bypass_line porosity
strip_porosity = 1.0 # strip porosity
return_line_porosity = 1.0 # return_line porosity

cp_steel = 500.0 # (J/(kg.K)) specific heat of steel
rho_steel = 8000.0 # (kg/(m3)) density of steel
k_steel = 15.0 # # (W/(m.k)) density of steel

# Operational Parameters --------------------------------------------------------
#p_outlet = 1.01325e+05 # Reactor outlet pressure (Pa)
p_outlet = 1.50653e+05 # Reactor outlet pressure (Pa)
T_inlet = 908.15 # Salt inlet temperature (K).
T_Salt_initial = 923.0 # inital salt temperature (will change in steady-state)

pump_force = -1.3e6 # pump force functor (set to get a loop circulation time of ~25 seconds)
vol_hx = 1e10 # (W/(m3.K)) volumetric heat exchange coefficient for heat exchanger
# Note: vol_hx need to be tuned to match intermediate HX performance for transients
bulk_hx = 100.0 # (W/(m3.K)) core bulk volumetric heat exchange coefficient (already callibrated)

# Thermal-Hydraulic diameters ----------------------------------------------------
D_H_fuel_channel = 0.0191334114 # Hydraulic diameter of bypass
D_H_downcomer = 0.045589414 # Hydraulic diameter of riser
D_H_pipe = '${fparse 5*0.0254}' # Riser Hydraulic Diameter
D_H_plena = '${fparse 2*core_radius}' # Hydraulic diameter of riser

# Delayed neutron precursors constants ------------------------------------------
lambda1 = 0.0133104
lambda2 = 0.0305427
lambda3 = 0.115179
lambda4 = 0.301152
lambda5 = 0.879376
lambda6 = 2.91303
beta1 = 8.42817e-05
beta2 = 0.000684616
beta3 = 0.000479796
beta4 = 0.00103883
beta5 = 0.000549185
beta6 = 0.000184087

Sc_t = 1 # turbulent Schmidt number

yield_I135    = ${fparse 0.0263071*1.37e-15}
lambda_I135   = ${fparse log(2)/(3600*6.58)}
lambda_I135_g = ${fparse log(2)/(3600*6.58)}

yield_XE135   = ${fparse 0.00325859*1.37e-15}
lambda_XE135  = ${fparse log(2)/(3600*9.14)}

# Utils -------------------------------------------------------------------------
# fluid blocks define fluid vars and solve for them
fluid_blocks = 'core lower_plenum upper_plenum down_comer riser pump elbow bypass_line strip return_line'
solid_blocks = 'core core_barrel'

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  fp = fluid_properties_obj
  porosity = 'porosity'
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'

  u = superficial_vel_x
  v = superficial_vel_y

  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  mixing_length = 'mixing_length'
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = 'RZ'
  [restart]
    type = FileMeshGenerator
    use_for_exodus_restart = true
    file = './neu_pump_out_flow_dnp0_restart.e'
  []
[]

[Problem]
  kernel_coverage_check = false
  allow_initial_conditions_with_restart = true
[]
# ==============================================================================
# FV VARIABLES
# ==============================================================================
[Variables]
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    initial_condition = 1e-8
    block = ${fluid_blocks}
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    initial_condition = 1e-8
    block = ${fluid_blocks}
  []
  [pressure]
    type = INSFVPressureVariable
    initial_condition = ${p_outlet}
    block = ${fluid_blocks}
  []
  [T_fluid]
    type = INSFVEnergyVariable
    initial_condition = ${T_Salt_initial}
    block = ${fluid_blocks}
  []
  [T_solid]
    type = INSFVEnergyVariable
    initial_condition = ${T_Salt_initial}
    block = ${solid_blocks}
  []
  [c1]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [c2]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [c3]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [c4]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [c5]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [c6]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  # Species
  [I135]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [Xe135]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
[]

# ==============================================================================
# THERMAL-HYDRAULICS PROBLEM SETUP
# ==============================================================================
[FluidProperties]
  [fluid_properties_obj]
    type = FlibeFluidProperties
  []
[]

[Modules]
  [NavierStokesFV]
    # Basic settings - weakly-compressible, turbulent flow with buoyancy
    block = ${fluid_blocks}
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    add_energy_equation = true
    gravity = '0.0 -9.81 0.0'

    # Variable naming
    velocity_variable = 'superficial_vel_x superficial_vel_y'
    pressure_variable = 'pressure'
    fluid_temperature_variable = 'T_fluid'

    # Numerical schemes
    pressure_face_interpolation = average
    momentum_advection_interpolation = upwind
    mass_advection_interpolation = upwind
    energy_advection_interpolation = upwind
    velocity_interpolation = rc

    # Porous & Friction treatement
    use_friction_correction = true
    friction_types = 'darcy forchheimer'
    friction_coeffs = 'Darcy_coefficient Forchheimer_coefficient'
    consistent_scaling = 100.0
    porosity_smoothing_layers = 2
    turbulence_handling = 'mixing-length'

    # fluid properties
    density = 'rho'
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'kappa'
    specific_heat = 'cp'

    # Energy source-sink
    external_heat_source = 'power_density'
    #energy_scaling = 2.0

    # Boundary Conditions
    wall_boundaries = 'left      top      bottom   right    loop_boundary bypass_line_boundary extraction return_line_boundary'
    momentum_wall_types = 'symmetry  slip     noslip   noslip   noslip    noslip   noslip noslip'
    energy_wall_types = 'heatflux  heatflux heatflux heatflux heatflux    heatflux heatflux heatflux'
    energy_wall_function = '0        0        0        0        0         0      0    0'

    # Constrain Pressure
    pin_pressure = true
    pinned_pressure_value = ${p_outlet}
    pinned_pressure_point = '0.0 2.13859 0.0'
    pinned_pressure_type = point-value-uo

    # Passive Scalar -- solved separetely to integrate porosity jumps
    add_scalar_equation = false

    #Scaling -- used mainly for nonlinear solves
    momentum_scaling = 1e-3
    mass_scaling = 10
  []
[]

[FVBCs]
  [sym_I135]
    type = INSFVSymmetryScalarBC
    boundary = 'left top'
    variable = I135
  []
  [sym_Xe135]
    type = INSFVSymmetryScalarBC
    boundary = 'left top'
    variable = Xe135
  []
[]

[FVKernels]
  # Extra kernels for the thermal-hydraulics solve in the fluid
  [pump_x]
    type = INSFVPump
    momentum_component = x
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    variable = superficial_vel_x
    block = 'pump'
    pump_volume_force = ${pump_force}
  []
  [pump_y]
    type = INSFVPump
    momentum_component = y
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    variable = superficial_vel_y
    block = 'pump'
    pump_volume_force = ${pump_force}
  []
  [convection_fluid_hx]
    type = NSFVEnergyAmbientConvection
    variable = T_fluid
    T_ambient = ${T_inlet}
    alpha = ${vol_hx}
    block = 'pump'
  []

  # Kernels for solve in the solid blocks
  [heat_time_solid]
    type = INSFVEnergyTimeDerivative
    variable = T_solid
    dh_dt = dh_dt
    rho = ${rho_steel}
  []
  [heat_diffusion_solid]
    type = FVDiffusion
    variable = T_solid
    coeff = ${k_steel}
  []
  [convection_core]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = ${bulk_hx}
    block = 'core'
  []
  [convection_core_completmeent]
    type = PINSFVEnergyAmbientConvection
    variable = T_fluid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    h_solid_fluid = ${bulk_hx}
    block = 'core'
  []

  # Kernels for solve of delayed neutron precursor transport
  [c1_time]
    type = FVFunctorTimeKernel
    variable = 'c1'
  []
  [c2_time]
    type = FVFunctorTimeKernel
    variable = 'c2'
  []
  [c3_time]
    type = FVFunctorTimeKernel
    variable = 'c3'
  []
  [c4_time]
    type = FVFunctorTimeKernel
    variable = 'c4'
  []
  [c5_time]
    type = FVFunctorTimeKernel
    variable = 'c5'
  []
  [c6_time]
    type = FVFunctorTimeKernel
    variable = 'c6'
  []
  [c1_advection]
    type = PINSFVMassAdvection
    variable = c1
    rho = 'c1_porous'
    block = ${fluid_blocks}
  []
  [c2_advection]
    type = PINSFVMassAdvection
    variable = c2
    rho = 'c2_porous'
    block = ${fluid_blocks}
  []
  [c3_advection]
    type = PINSFVMassAdvection
    variable = c3
    rho = 'c3_porous'
    block = ${fluid_blocks}
  []
  [c4_advection]
    type = PINSFVMassAdvection
    variable = c4
    rho = 'c4_porous'
    block = ${fluid_blocks}
  []
  [c5_advection]
    type = PINSFVMassAdvection
    variable = c5
    rho = 'c5_porous'
    block = ${fluid_blocks}
  []
  [c6_advection]
    type = PINSFVMassAdvection
    variable = c6
    rho = 'c6_porous'
    block = ${fluid_blocks}
  []
  [c1_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c1
    block = ${fluid_blocks}
  []
  [c2_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c2
    block = ${fluid_blocks}
  []
  [c3_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c3
    block = ${fluid_blocks}
  []
  [c4_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c4
    block = ${fluid_blocks}
  []
  [c5_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c5
    block = ${fluid_blocks}
  []
  [c6_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c6
    block = ${fluid_blocks}
  []
  [c1_src]
    type = FVCoupledForce
    variable = c1
    v = fission_source
    coef = ${beta1}
    block = ${fluid_blocks}
  []
  [c2_src]
    type = FVCoupledForce
    variable = c2
    v = fission_source
    coef = ${beta2}
    block = ${fluid_blocks}
  []
  [c3_src]
    type = FVCoupledForce
    variable = c3
    v = fission_source
    coef = ${beta3}
    block = ${fluid_blocks}
  []
  [c4_src]
    type = FVCoupledForce
    variable = c4
    v = fission_source
    coef = ${beta4}
    block = ${fluid_blocks}
  []
  [c5_src]
    type = FVCoupledForce
    variable = c5
    v = fission_source
    coef = ${beta5}
    block = ${fluid_blocks}
  []
  [c6_src]
    type = FVCoupledForce
    variable = c6
    v = fission_source
    coef = ${beta6}
    block = ${fluid_blocks}
  []
  [c1_decay]
    type = FVReaction
    variable = c1
    rate = ${lambda1}
    block = ${fluid_blocks}
  []
  [c2_decay]
    type = FVReaction
    variable = c2
    rate = ${lambda2}
    block = ${fluid_blocks}
  []
  [c3_decay]
    type = FVReaction
    variable = c3
    rate = ${lambda3}
    block = ${fluid_blocks}
  []
  [c4_decay]
    type = FVReaction
    variable = c4
    rate = ${lambda4}
    block = ${fluid_blocks}
  []
  [c5_decay]
    type = FVReaction
    variable = c5
    rate = ${lambda5}
    block = ${fluid_blocks}
  []
  [c6_decay]
    type = FVReaction
    variable = c6
    rate = ${lambda6}
    block = ${fluid_blocks}
  []
# Kernels for solve of I and Xe transport 
  [I135_time]
    type = FVFunctorTimeKernel
    variable = 'I135'
  []
  [Xe135_time]
    type = FVFunctorTimeKernel
    variable = 'Xe135'
  []
  [I135_advection]
    type = PINSFVMassAdvection
    variable = I135
    rho = 'I135_porous'
    block = ${fluid_blocks}
  []
  [Xe135_advection]
    type = PINSFVMassAdvection
    variable = Xe135
    rho = 'Xe135_porous'
    block = ${fluid_blocks}
  []
  [I135_diffusion]
    type = FVDiffusion
    coeff = mu_var
    variable = I135
    block = ${fluid_blocks}
  []
  [Xe135_diffusion]
    type = FVDiffusion
    coeff = mu_var
    variable = Xe135
    block = ${fluid_blocks}
  []
  [I135_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = I135
    block = ${fluid_blocks}
  []
  [Xe135_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = Xe135
    block = ${fluid_blocks}
  []
  [I135_src]
    type = FVCoupledForce
    variable = I135
    v = fission_source
    coef = ${yield_I135}
    block = ${fluid_blocks}
  []
  [Xe135_src]
    type = FVCoupledForce
    variable = Xe135
    v = fission_source
    coef = ${yield_XE135}
    block = ${fluid_blocks}
  []
  # Stripping
  [Xe135_strip]
    type = NSFVEnergyAmbientConvection
    variable = Xe135
    alpha = mass_trans_var
    block = strip
    T_ambient = 0
  []

  [I135_decay]
    type = FVReaction
    variable = I135
    rate = ${lambda_I135}
    block = ${fluid_blocks}
  []
  [Xe135_decay]
    type = FVReaction
    variable = Xe135
    rate = ${lambda_XE135}
    block = ${fluid_blocks}
  []
  [Xe135_grow]
    type = FVCoupledForce
    variable = Xe135
    v = I135
    coef = ${lambda_I135_g}
    block = ${fluid_blocks}
  []
[]

[FVInterfaceKernels]
  # Conjugated heat transfer with core barrel
  [convection]
    type = FVConvectionCorrelationInterface
    variable1 = T_fluid
    variable2 = T_solid
    boundary = 'core_downcomer_boundary'
    h = ${bulk_hx}
    T_solid = T_solid
    T_fluid = T_fluid
    subdomain1 = 'core down_comer lower_plenum upper_plenum'
    subdomain2 = 'core_barrel'
    wall_cell_is_bulk = true
  []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[Functions]
  [cosine_guess]
    type = ParsedFunction
    expression = 'max(0, cos(x*pi/2/1.0))*max(0, cos((y-1.0)*pi/2/1.1))'
  []
[]

[AuxVariables]
  [porosity_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [power_density]
    type = MooseVariableFVReal
    [FVInitialCondition]
      type = FVFunctionIC
      function = 'cosine_guess'
      scaling_factor = '${fparse 2.9183E+6}'
    []
  []
  [fission_source]
    type = MooseVariableFVReal
    [FVInitialCondition]
      type = FVFunctionIC
      function = 'cosine_guess'
      scaling_factor = '${fparse 1.0E-8}'
    []
  []
  [rho_var]
    type = MooseVariableFVReal
    initial_condition = 1.0
    block = ${fluid_blocks}
  []
  [a_u_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [a_v_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [mass_trans_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [mu_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
  [speed_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
[]

[AuxKernels]
  [porosity_var_aux]
    type = FunctorAux
    variable = porosity_var
    functor = 'porosity'
    block = ${fluid_blocks}
  []
  [rho_var_aux]
    type = FunctorAux
    variable = 'rho_var'
    functor = 'rho'
    block = ${fluid_blocks}
  []
  [comp_a_u]
    type = FunctorAux
    functor = 'ax'
    variable = 'a_u_var'
    block = ${fluid_blocks}
    execute_on = 'timestep_end'
  []
  [comp_a_v]
    type = FunctorAux
    functor = 'ay'
    variable = 'a_v_var'
    block = ${fluid_blocks}
    execute_on = 'timestep_end'
  []
  [comp_mass_trans]
    type = FunctorAux
    functor = 'mass_trans_mat'
    variable = 'mass_trans_var'
    block = ${fluid_blocks}
    execute_on = 'timestep_end'
  []
  [mu_var_aux]
    type = FunctorAux
    functor = 'mu'
    variable = mu_var
    block = ${fluid_blocks}
    execute_on = 'timestep_end'
  []
  [speed_var_aux]
    type = FunctorAux
    functor = 'speed'
    variable = speed_var
    block = ${fluid_blocks}
    execute_on = 'timestep_end'
  []
[]

# ==============================================================================
# MATERIALS
# ==============================================================================
[Materials]

  # Setting up material porosities at fluid blocks
  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'porosity'
    subdomain_to_prop_value = 'core             ${core_porosity}
                               lower_plenum     ${lower_plenum_porosity}
                               upper_plenum     ${upper_plenum_porosity}
                               down_comer       ${down_comer_porosity}
                               riser            ${riser_porosity}
                               pump             ${pump_porosity}
                               elbow            ${elbow_porosity}
                               bypass_line      ${bypass_line_porosity}
                               strip            ${strip_porosity}
                               return_line      ${return_line_porosity}'
  []

  # Setting up hydraulic diameters at fluid blocks
  [hydraulic_diameter]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = 'characteristic_length'
    subdomain_to_prop_value = 'core             ${D_H_fuel_channel}
                               lower_plenum     ${D_H_plena}
                               upper_plenum     ${D_H_plena}
                               down_comer       ${D_H_downcomer}
                               riser            ${D_H_pipe}
                               pump             ${D_H_pipe}
                               elbow            ${D_H_pipe}
                               bypass_line      ${D_H_pipe}
                               strip            ${D_H_pipe}
                               return_line      ${D_H_pipe}'
    block = ${fluid_blocks}
  []

  # Setting up fluid properties at blocks material blocks
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    pressure = 'pressure'
    T_fluid = 'T_fluid'
    speed = 'speed'
    characteristic_length = characteristic_length
    block = ${fluid_blocks}
  []

  # Setting up heat conduction materials at blocks
  [dh_dt_mat]
    type = INSFVEnthalpyFunctorMaterial
    rho = ${rho_steel}
    temperature = T_solid
    cp = ${cp_steel}
    block = 'core_barrel'
  []

  [effective_fluid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = ${fluid_blocks}
  []

  ## Drag correlations per block
  [isotropic_drag_core]
    type = FunctorChurchillDragCoefficients
    multipliers = '100000 100 100000'
    block = 'core'
  []
  [drag_lower_plenum]
    type = FunctorChurchillDragCoefficients
    multipliers = '10 1 10'
    block = 'upper_plenum'
  []
  [drag_upper_plenum]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    block = 'lower_plenum'
  []
  [drag_downcomer]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    block = 'down_comer'
  []
  [drag_piping]
    type = FunctorChurchillDragCoefficients
    multipliers = '0 0 0'
    block = 'riser pump elbow bypass_line strip return_line'
  []

  ## Materials for computing corrected DNP advection
  [c1_mat]
    type = ADParsedFunctorMaterial
    expression = 'c1 / porosity'
    functor_names = 'c1 porosity'
    functor_symbols = 'c1 porosity'
    property_name = 'c1_porous'
  []
  [c2_mat]
    type = ADParsedFunctorMaterial
    expression = 'c2 / porosity'
    functor_names = 'c2 porosity'
    functor_symbols = 'c2 porosity'
    property_name = 'c2_porous'
  []
  [c3_mat]
    type = ADParsedFunctorMaterial
    expression = 'c3 / porosity'
    functor_names = 'c3 porosity'
    functor_symbols = 'c3 porosity'
    property_name = 'c3_porous'
  []
  [c4_mat]
    type = ADParsedFunctorMaterial
    expression = 'c4 / porosity'
    functor_names = 'c4 porosity'
    functor_symbols = 'c4 porosity'
    property_name = 'c4_porous'
  []
  [c5_mat]
    type = ADParsedFunctorMaterial
    expression = 'c5 / porosity'
    functor_names = 'c5 porosity'
    functor_symbols = 'c5 porosity'
    property_name = 'c5_porous'
  []
  [c6_mat]
    type = ADParsedFunctorMaterial
    expression = 'c6 / porosity'
    functor_names = 'c6 porosity'
    functor_symbols = 'c6 porosity'
    property_name = 'c6_porous'
  []

  [I135_mat]
    type = ADParsedFunctorMaterial
    expression = 'I135 / porosity_var'
    functor_names = 'I135 porosity_var'
    functor_symbols = 'I135 porosity_var'
    property_name = 'I135_porous'
  []
  [Xe135_mat]
    type = ADParsedFunctorMaterial
    expression = 'Xe135 / porosity_var'
    functor_names = 'Xe135 porosity_var'
    functor_symbols = 'Xe135 porosity_var'
    property_name = 'Xe135_porous'
  []
  [coupled_Xe135_mass_trans]
    type = ADParsedFunctorMaterial
    property_name = coupled_Xe135_mass_trans
    functor_names = 'Xe135 mass_trans_mat'
    expression = 'Xe135*mass_trans_mat'
  []
  [mass_trans_mat]
    type = ADParsedFunctorMaterial
    property_name = mass_trans_mat
    functor_names = 'rho mu speed'
    expression = '0.023*1e-6/0.01*((rho*0.01*speed)/mu)^(0.8)*(mu/(rho*1e-6))^(0.4)'
  []
[]

# ==============================================================================
# POSTPROCESSORS
# ==============================================================================
[Postprocessors]
  [Xe_avg]
    type = ElementAverageValue
    variable = Xe135
    block = 'core'
  []

  [outlet_p]
    type = SideAverageValue
    variable = pressure
    boundary = 'pump_outlet'
  []
  [outlet_T]
    type = SideAverageValue
    variable = 'T_fluid'
    boundary = 'pump_outlet'
  []
  [inlet_p]
    type = SideAverageValue
    variable = 'pressure'
    boundary = 'downcomer_inlet'
  []
  [inlet_T]
    type = SideAverageValue
    variable = 'T_fluid'
    boundary = 'downcomer_inlet'
  []
  [vfr_downcomer]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 1.0
    boundary = 'downcomer_inlet'
  []
  [area_pp_downcomer_inlet]
    type = AreaPostprocessor
    boundary = 'downcomer_inlet'
    execute_on = 'INITIAL'
  []
  [vfr_pump]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 1.0
    boundary = 'pump_outlet'
  []
  [vfr_return_line]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 1.0
    boundary = 'return_line_sideset'
  []
  [return_line_fraction]
    type = ParsedPostprocessor
    function = '- vfr_return_line / vfr_pump'
    pp_names = 'vfr_return_line vfr_pump'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Debug]
  show_var_residual_norms = true
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  petsc_options_iname = '-pc_type -sub_pc_factor_shift_type'
  petsc_options_value = ' lu       NONZERO'
  automatic_scaling = true
  nl_abs_tol = 1e-6
  #line_search = l2
  nl_max_its = 100
  dtmin = 0.01
  dtmax = 1e4

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    optimal_iterations = 20
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
  []

  end_time = 4e5
  #steady_state_detection = true

[]

[Outputs]
  csv = true
  exodus = true
  [restart]
    type = Exodus
    overwrite = true
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

# ==============================================================================
# MULTIAPPS AND TRANSFERS
# ==============================================================================
[MultiApps]
  [griffin]
    type                  = FullSolveMultiApp
    app_type              = GriffinApp
    input_files           = 'neu_xe.i'
    execute_on            = 'timestep_end'

    no_backup_and_restore = true
    enable                = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = griffin
    source_variable = power_density
    variable = power_density
    execute_on = 'timestep_end'
  []
  [fission_source]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = griffin
    source_variable = fission_source
    variable = fission_source
    execute_on = 'timestep_end'
  []
  [c1]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c1'
    variable = 'c1'
    execute_on = 'timestep_end'
  []
  [c2]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c2'
    variable = 'c2'
    execute_on = 'timestep_end'
  []
  [c3]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c3'
    variable = 'c3'
    execute_on = 'timestep_end'
  []
  [c4]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c4'
    variable = 'c4'
    execute_on = 'timestep_end'
  []
  [c5]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c5'
    variable = 'c5'
    execute_on = 'timestep_end'
  []
  [c6]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'c6'
    variable = 'c6'
    execute_on = 'timestep_end'
  []
  [update_ad_Xe135]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'Xe135'
    variable = 'ad_Xe135'
    execute_on = 'timestep_end'
  []
  [T_salt]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'T_fluid'
    variable = 'T_salt'
    execute_on = 'timestep_end'
  []
  [T_graph]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'T_solid'
    variable = 'T_solid'
    execute_on = 'timestep_end'
  []
  [vel_x]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'superficial_vel_x'
    variable = 'vel_x'
    execute_on = 'timestep_end'
  []
  [vel_y]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = griffin
    source_variable = 'superficial_vel_y'
    variable = 'vel_y'
    execute_on = 'timestep_end'
  []
[]


