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
lower_plenum_porosity = 1.0 # lower pelnum porosity
upper_plenum_porosity = 1.0 # upper pelnum porosity
riser_porosity = 1.0 # riser porosity
pump_porosity = 1.0 # pump porosity
elbow_porosity = 1.0 # elbow porosity

mfr = 0.07571 #m3/s # 191.1900 # Salt mass flow rate (kg/s).
p_outlet = 1.01325e+05 # Reactor outlet pressure (Pa)
T_inlet = 908.15 # Salt inlet temperature (K).

pump_force = 1.8e6

# Hydraulic diameter -----------------------------------------------------------
D_H_fuel_channel = 0.0191334114 # Hydraulic diameter of bypass
D_H_downcomer = 0.045589414 # Hydraulic diameter of riser
D_H_pipe = '${fparse 5*0.0254}' # Riser Hydraulic Diameter
D_H_plena = '${fparse 2*core_radius}' # Hydraulic diameter of riser

fluid_blocks = 'core lower_plenum upper_plenum down_comer riser pump elbow' # fluid blocks define fluid vars and solve for them

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

[GlobalParams]
  fp = fluid_properties_obj
  porosity = 'porosity'
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'

  u = vel_x
  v = vel_y

  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
  mixing_length = 'mixing_length'
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    file = '../steady_state/msre_neutronics_ss_s2_out_flow_dnp0.e'
    use_for_exodus_restart = true
  []
[]

[Problem]
  kernel_coverage_check = false
[]

[Modules]
  [NavierStokesFV]
    # Basic settings
    block = ${fluid_blocks}
    compressibility = 'weakly-compressible'
    porous_medium_treatment = true
    add_energy_equation = true

    #Scaling
    #energy_scaling = 1e-6
    momentum_scaling = 1e-3
    mass_scaling = 10
    gravity = '0.0 -9.81 0.0'

    # Numerical schemes
    pressure_face_interpolation = average
    momentum_advection_interpolation = upwind
    mass_advection_interpolation = upwind
    energy_advection_interpolation = upwind
    velocity_interpolation = rc
    velocity_variable = 'vel_x vel_y'
    pressure_variable = 'pressure'
    fluid_temperature_variable = 'T_fluid'

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

    # boundary conditions
    wall_boundaries = 'left      top      bottom   right    loop_boundary '
    momentum_wall_types = 'symmetry  slip     noslip   noslip   noslip'
    energy_wall_types = 'heatflux  heatflux heatflux heatflux heatflux'
    energy_wall_function = '0        0        0        0        0'

    pin_pressure = true
    pinned_pressure_value = ${p_outlet}
    pinned_pressure_type = average-uo

    # passive scalar -- solved in the multiapp because is much faster
    add_scalar_equation = false # solving separetely
  []
[]

[FluidProperties]
  [fluid_properties_obj]
    type = FlibeFluidProperties
  []
[]

[Variables]
  [vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = ${fluid_blocks}
    initial_from_file_var = vel_x
  []
  [vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = ${fluid_blocks}
    initial_from_file_var = vel_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = ${fluid_blocks}
    initial_from_file_var = pressure
  []
  [T_fluid]
    type = INSFVEnergyVariable
    block = ${fluid_blocks}
    initial_from_file_var = T_fluid
  []
  [T_solid]
    type = INSFVEnergyVariable
    block = 'core core_barrel'
    initial_from_file_var = T_solid
  []
  [c1]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c1
  []
  [c2]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c2
  []
  [c3]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c3
  []
  [c4]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c4
  []
  [c5]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c5
  []
  [c6]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = c6
  []
[]

[FVKernels]

  [pump_x]
    type = INSFVBodyForce
    variable = vel_x
    functor = '${pump_force}'
    block = 'pump'
    momentum_component = 'x'
  []
  [pump_y]
    type = INSFVBodyForce
    variable = vel_y
    functor = '${pump_force}'
    block = 'pump'
    momentum_component = 'y'
  []
  [convection_fluid_hx]
    type = NSFVEnergyAmbientConvection
    variable = T_fluid
    T_ambient = ${T_inlet}
    alpha = 1e10
    block = 'pump'
  []

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
  [c1_advection] # This should be porous: I need to add the kernel to MOOSE later
    type = PINSFVMassAdvection
    variable = c1
    rho = 'c1_porous'
    block = ${fluid_blocks}
  []
  [c2_advection] # This should be porous: I need to add the kernel to MOOSE later
    type = PINSFVMassAdvection
    variable = c2
    rho = 'c2_porous'
    block = ${fluid_blocks}
  []
  [c3_advection] # This should be porous: I need to add the kernel to MOOSE later
    type = PINSFVMassAdvection
    variable = c3
    rho = 'c3_porous'
    block = ${fluid_blocks}
  []
  [c4_advection] # This should be porous: I need to add the kernel to MOOSE later
    type = PINSFVMassAdvection
    variable = c4
    rho = 'c4_porous'
    block = ${fluid_blocks}
  []
  [c5_advection] # This should be porous: I need to add the kernel to MOOSE later
    type = PINSFVMassAdvection
    variable = c5
    rho = 'c5_porous'
    block = ${fluid_blocks}
  []
  [c6_advection] # This should be porous: I need to add the kernel to MOOSE later
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

  [heat_time_solid]
    type = INSFVEnergyTimeDerivative
    variable = T_solid
    cp = 800.0
    rho = 15.0
  []
  [heat_diffusion_solid]
    type = FVDiffusion
    variable = T_solid
    coeff = 15.0
  []
  [convection_core]
    type = PINSFVEnergyAmbientConvection
    variable = T_solid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = true
    h_solid_fluid = 100.0
    block = 'core'
  []
  [convection_core_completmeent]
    type = PINSFVEnergyAmbientConvection
    variable = T_fluid
    T_fluid = T_fluid
    T_solid = T_solid
    is_solid = false
    h_solid_fluid = 100.0
    block = 'core'
  []
[]

[FVInterfaceKernels]
  [convection]
    type = FVConvectionCorrelationInterface
    variable1 = T_fluid
    variable2 = T_solid
    boundary = 'core_downcomer_boundary'
    h = 100.0
    T_solid = T_solid
    T_fluid = T_fluid
    subdomain1 = 'core down_comer lower_plenum'
    subdomain2 = 'core_barrel'
    wall_cell_is_bulk = true
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

  [cosine_guess]
    type = ParsedFunction
    expression = 'max(0, cos(x*pi/2/1.0))*max(0, cos((y-1.0)*pi/2/1.1))'
  []

[]

[AuxVariables]
  [porosity_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
    initial_from_file_var = porosity_var
  []
  [power_density]
    type = MooseVariableFVReal
    initial_from_file_var = power_density
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_from_file_var = fission_source
  []
  [rho_var]
    type = MooseVariableFVReal
    initial_from_file_var = rho_var
    block = ${fluid_blocks}
  []
[]

[AuxKernels]
  [porosity_var_aux]
    type = ADFunctorElementalAux
    variable = porosity_var
    functor = 'porosity'
    block = ${fluid_blocks}
  []
  [rho_var_aux]
    type = ADFunctorElementalAux
    variable = 'rho_var'
    functor = 'rho'
    block = ${fluid_blocks}
  []
[]

[Postprocessors]
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
    vel_x = vel_x
    vel_y = vel_y
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
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = 1.0
    boundary = 'pump_outlet'
  []

  [limit_dt]
    type = Receiver
    default = 0.25
  []
[]

[Materials]

  # hydraulic diameter and porosity - fixed number per block
  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'porosity'
    subdomain_to_prop_value = 'core             ${core_porosity}
                               lower_plenum     ${lower_plenum_porosity}
                               upper_plenum     ${upper_plenum_porosity}
                               down_comer       ${down_comer_porosity}
                               riser            ${riser_porosity}
                               pump             ${pump_porosity}
                               elbow            ${elbow_porosity}'
  []

  [hydraulic_diameter]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = 'characteristic_length'
    subdomain_to_prop_value = 'core             ${D_H_fuel_channel}
                               lower_plenum     ${D_H_plena}
                               upper_plenum     ${D_H_plena}
                               down_comer       ${D_H_downcomer}
                               riser            ${D_H_pipe}
                               pump             ${D_H_pipe}
                               elbow            ${D_H_pipe}'
    block = ${fluid_blocks}
  []

  ## Fluid properties and non-dimensional numbers
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    pressure = 'pressure'
    T_fluid = 900.0 #'T_fluid'
    speed = 'speed'
    # mu_rampdown = 'mu' #'mu_ramp_fn'  # To initialize with a high viscosity
    characteristic_length = characteristic_length
    block = ${fluid_blocks}
  []

  [effective_fluid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = ${fluid_blocks}
  []

  [isotropic_drag_core]
    type = FunctorChurchillDragCoefficients
    multipliers = '100000 500 100000'
    block = 'core'
  []

  [drag_plena]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    block = 'lower_plenum upper_plenum'
  []

  [drag_downcomer]
    type = FunctorChurchillDragCoefficients
    multipliers = '1 1 1'
    block = 'down_comer'
  []

  [drag_piping]
    type = FunctorChurchillDragCoefficients
    multipliers = '0 0 0'
    block = 'riser pump elbow'
  []

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
[]

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
  nl_max_its = 100

  start_time = 0.0
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.01
    optimal_iterations = 9
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.5
    timestep_limiting_postprocessor = limit_dt
  []
  end_time = 400.0
  auto_advance = true
  # steady_state_detection = true
[]

[Outputs]
  csv = true
  exodus = true
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
