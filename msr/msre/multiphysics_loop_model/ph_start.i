# ================================================================================================================# Model description
# Molten Salt Reactor Experiment (MSRE) Model - Steady-State Model
# Primary Loop Thermal Hydraulics Model
# Integrates:
# - Porous media model for reactor primary loop
# - Weakly compressible, turbulent flow formulation
# MSRE: reference plant design based on 10.0 MW of MSRE Experiment.
# ================================================================================================================
# Author(s): Dr. Mauricio Tano & Dr. Mustafa K. Jaradat
# ================================================================================================================
# MODEL PARAMETERS
# ================================================================================================================
# Geometry
# ----------------------------------------------------------------------------------------------------------------
core_radius = 0.691433
graph_heat_frac       = 0.05467
# ----------------------------------------------------------------------------------------------------------------
# Material Thermal Properties
# ----------------------------------------------------------------------------------------------------------------
cp_graph              = 1757.3              # (J/(kg.K)) specific heat of graphite
rho_graph             = 1860.0              # (kg/(m3)) density of graphite
k_graph               = 40.1                # (W/(m.k)) density of graphite
# ----------------------------------------------------------------------------------------------------------------
cp_steel              = 500.0               # (J/(kg.K)) specific heat of steel
rho_steel             = 8000.0              # (kg/(m3)) density of steel
k_steel               = 15.0                # (W/(m.k)) density of steel
# ----------------------------------------------------------------------------------------------------------------
# Porosity
# ----------------------------------------------------------------------------------------------------------------
core_porosity         = 0.222         # core porosity salt VF=0.222831853, Graphite VF=0.777168147
down_comer_porosity   = 1.0                 # downcomer porosity
lower_plenum_porosity = 1.0                 # lower pelnum porosity
upper_plenum_porosity = 1.0                 # upper pelnum porosity
riser_porosity        = 1.0                 # riser porosity
#pump_porosity         = 1.0                 # pump porosity
#elbow_porosity        = 1.0                 # elbow porosity
bypass_porosity       = 1.0
# ----------------------------------------------------------------------------------------------------------------
# Thermal-Hydraulic diameters
# ---------------------------------------------------------------------------------------------------------------
D_H_fuel_channel      = 0.0191334114              # Hydraulic diameter of bypass
D_H_downcomer         = 0.045589414               # Hydraulic diameter of riser
D_H_pipe              = '${fparse 5*0.0254}'      # Riser Hydraulic Diameter
D_H_plena             = '${fparse 2*core_radius}' # Hydraulic diameter of riser
# ----------------------------------------------------------------------------------------------------------------
# Operational Parameters
# ----------------------------------------------------------------------------------------------------------------
#T_inlet_hx            = 904.55              # Salt inlet temperature (K)
bulk_htc              = 20000.0             # (W/(m3.K)) core bulk volumetric heat exchange coefficient (already callibrated)
#p_outlet              = 1.50653E+05         # 1.01325e+05 # Reactor outlet pressure (Pa)
#T_Salt_initial        = 922.              # inital salt temperature (will change in steady-state)
#pump_force            = 1.1E+08             # pump force functor (set to get a loop circulation time of ~25 seconds)
#vol_hx                = 1.0E+10             # (W/(m3.K)) volumetric heat exchange coefficient for heat exchanger
                                            # Note: vol_hx need to be tuned to match intermediate HX performance for transients
# ----------------------------------------------------------------------------------------------------------------
# Delayed Neutron Data
# ----------------------------------------------------------------------------------------------------------------
# ----------------------------------------------------------------------------------------------------------------
# Effective Delayed Neutron Data
# ----------------------------------------------------------------------------------------------------------------
lambda_1              = 0.013336
lambda_2              = 0.0327389985
lambda_3              = 0.120779999
lambda_4              = 0.302780002
lambda_5              = 0.849489987
lambda_6              = 2.85299993
beta_1                = 0.00022841247418
beta_2                = 0.00118081389477
beta_3                = 0.00112776325192
beta_4                = 0.00252807960458
beta_5                = 0.00103842275185
beta_6                = 0.000434699197035
# ----------------------------------------------------------------------------------------------------------------
fluid_blocks          = 'core core1 core2 lower_plenum upper_plenum down_comer riser'
solid_blocks          = 'core core1 core_barrel'
non_solid_blocks      = 'core2 lower_plenum upper_plenum down_comer riser'
# ================================================================================================================
# GLOBAL PARAMETERS
# ================================================================================================================
[GlobalParams]
  fp                     = salt
  porosity               = 'porosity'
  rhie_chow_user_object  = 'pins_rhie_chow_interpolator'
  advected_interp_method = 'upwind'
  velocity_interp_method = 'rc'
[]
# ================================================================================================================
# GEOMETRY AND MESH
# ================================================================================================================
[Mesh]
 [Mesh_gen]
  type                             = FileMeshGenerator
  use_for_exodus_restart           = true
  file = 'ph_initial.e'
 []
#  [ph_out-sam-in]
#   type = RenameBoundaryGenerator
#   new_boundary = ph_out_sam_in
#   old_boundary = 'riser_inlet'
#   input = Mesh_gen
#  []
#  [ph_outlet]
#    type = SideSetsBetweenSubdomainsGenerator
#    primary_block = 'riser'
#    paired_block = 'pump'
#    new_boundary = ph_outlet
#    input = ph_out-sam-in
#  []
#  [ph_inlet]
#   type = RenameBoundaryGenerator
#   input = ph_outlet
#   old_boundary = 'downcomer_inlet'
#   new_boundary = 'ph_inlet'
#  []
#  [reference_plane]
#    type = SideSetsBetweenSubdomainsGenerator
#    primary_block = 'lower_plenum lower_plenum lower_plenum'
#    paired_block = 'core core1 core2'
#    new_boundary = reference_plane
#    input = ph_inlet
#  []
#  [delete_blocks]
#   type = BlockDeletionGenerator
#   input = reference_plane
#   block = 'pump elbow'
#  []
  coord_type             = 'RZ'
[]

[Problem]
  kernel_coverage_check = false
  allow_initial_conditions_with_restart=true
[]

# ================================================================================================================
# FV VARIABLES
# ================================================================================================================
[Variables]
  [superficial_vel_x]
    type              = PINSFVSuperficialVelocityVariable
    block             = ${fluid_blocks}
    initial_from_file_var =superficial_vel_x
    #initial_condition = 0
    scaling = 1e-3
    #two_term_boundary_expansion = false
  []
  [superficial_vel_y]
    type              = PINSFVSuperficialVelocityVariable
    block             = ${fluid_blocks}
    initial_from_file_var =superficial_vel_y
    #initial_condition = 0
    scaling = 1e-3
    #two_term_boundary_expansion = false
  []
  [pressure]
    type              = INSFVPressureVariable
    block             = ${fluid_blocks}
    initial_from_file_var =pressure
    #two_term_boundary_expansion = false
  []
  [T_fluid]
    type              = INSFVEnergyVariable
    initial_from_file_var = T_fluid
    block             = ${fluid_blocks}
    #initial_condition = 908.15
    #two_term_boundary_expansion = false
  []
  [T_solid]
    type              = INSFVEnergyVariable
    initial_from_file_var = T_solid
    block             = ${solid_blocks}
    #initial_condition = 908.15
    #two_term_boundary_expansion = false
  []
  [c1]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_condition = 0
    #initial_from_file_var =c1
  []
  [c2]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_from_file_var =c2
  []
  [c3]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_from_file_var =c3
  []
  [c4]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_from_file_var =c4
  []
  [c5]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_from_file_var =c5
  []
  [c6]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
    #initial_from_file_var =c6
  []
[]

# ================================================================================================================
# THERMAL-HYDRAULICS PROBLEM SETUP
# ================================================================================================================
[FluidProperties]
  [salt]
    type = SalineMoltenSaltFluidProperties
    comp_name = "LiF BeF2 ZrF4 UF4" # This should be the MSRE fuel salt, but I did not find an exact completed reference in MSTDB-TP, using FLiBe for now
    comp_val = "0.6479 0.2996 0.0499 0.0026"
    prop_def_file = "Molten_Salt_Thermophysical_Properties_.csv"
  []
  # [salt]
  #   type = SalineMoltenSaltFluidProperties
  #   comp_name = "LiF BeF2" # This should be the MSRE fuel salt, but I did not find an exact completed reference in MSTDB-TP, using FLiBe for now
  #   comp_val = "0.66 0.34"
  #   prop_def_file = "Molten_Salt_Thermophysical_Properties.csv"
  # []
  # [salt]
  #   type                             = SimpleFluidProperties
  #   density0                         = 2000.0   # kg/m^3
  #   thermal_expansion                = 0.000 # K^{-1}
  #   cp                               = 2000.      # J/kg·K
  #   viscosity                        = 0.009    # Pa-s11
  #   thermal_conductivity             = 1.         # W/m·K
  # []
  # [salt]
  #   type = TemperaturePressureFunctionFluidProperties
  #   cp = 2000
  #   k = 1
  #   rho = 2000
  #   mu = 0.009
  #   T_ref = 908.15
  # []
[]

[OverlappingDomainCoupling]
  subapp_filename = 'msre_sam_do.i'
  hydrodynamic_iteration_type = 'update'
  component_names = 'downcomer core_plenums'
  overlapped_branch_name = 'j_ip_c'
  initial_boundary_massflowrate = '0 0'
  hydrodynamic_startup_time = -1999.
  component_orientation = 'in out'
  boundaries = 'ph_inlet ph_outlet'
  component_area = '0.1155292077 0.5541878 '
  component_hydraulic_diameter = '0.0508 1.4097'
  component_length = '2.00654 2.43854'
  boundary_massflowrate_names = 'mfr_in mfr_out'
  boundary_pressure_names = 'p_in p_out'
  reference_pressure = reference_pressure_pp

  eos = 'fuel_salt_eos' #'fuel_salt_eos
  enthalpy_functor = 'h'
  #reference_enthalpy = 'reference_enthalpy_pp'
  boundary_temperature_names = 'temp_in temp_out'
  initial_boundary_temperatures = '908.15 908.15'
  thermal_startup_time = -1999.
  thermal_iteration_type = 'update'
  show_pps = true

  passive_scalar_iteration_type = update
  passive_scalar_startup_time = -1999.
  MD_passive_scalar_variable_names = 'c1 c2 c3 c4 c5 c6'
  SC_passive_scalar_variable_names = 'c1 c2 c3 c4 c5 c6'
  passive_scalar_decay_constant = '${lambda_1} ${lambda_2} ${lambda_3} ${lambda_4} ${lambda_5} ${lambda_6}'
  initial_boundary_passive_scalar_value = '0. 0.; 0. 0.; 0. 0.; 0. 0.; 0. 0.; 0. 0.'
  boundary_passive_scalar_names = 'c1_in c1_out; c2_in c2_out; c3_in c3_out; c4_in c4_out; c5_in c5_out; c6_in c6_out'
  reference_passive_scalars = 'ref_ps_pp1 ref_ps_pp2 ref_ps_pp3 ref_ps_pp4 ref_ps_pp5 ref_ps_pp6'
[]

[Modules]
  [NavierStokesFV]
    # Basic settings - weakly-compressible, turbulent flow with buoyancy
    block                            = ${fluid_blocks}
    compressibility                  = 'weakly-compressible'
    porous_medium_treatment          = true
    add_energy_equation              = true
    gravity                          = '0.0 -9.8 0.0'

    # Variable naming
    velocity_variable                = 'superficial_vel_x superficial_vel_y'
    pressure_variable                = 'pressure'
    fluid_temperature_variable       = 'T_fluid'

    # Numerical schemes
    # pressure_face_interpolation      = average
    momentum_advection_interpolation = upwind
    mass_advection_interpolation     = upwind
    energy_advection_interpolation  = upwind
    velocity_interpolation           = rc


    # Porous & Friction treatement
    use_friction_correction          = true
    friction_types                   = 'darcy forchheimer'
    friction_coeffs                  = 'Darcy_coefficient Forchheimer_coefficient'
    consistent_scaling               = 100.0
    porosity_smoothing_layers        = 2

    # Mixing Length model
    turbulence_handling              = 'mixing-length'
    von_karman_const                  = 2.
    von_karman_const_0                = 0.9
    mixing_length_walls               ='right loop_boundary'
    mixing_length_delta               = 0.15

    # fluid properties
    density                          = 'rho'
    dynamic_viscosity                = 'mu'
    thermal_conductivity             = 'kappa'
    specific_heat                    = 'cp'
    dont_create_materials = true

    # Energy source-sink
    external_heat_source             = 'power_density_fuel' #'prescribed_power_density_fuel'

    # # # Boundary Conditions
    inlet_boundaries = 'ph_inlet'
    momentum_inlet_types ='flux-mass' #'fixed-velocity'
    flux_inlet_pps = 'mfr_in' #'inlet_mdot' #'mfr_in' #'-20'
    energy_inlet_types = 'flux-mass' #'heatflux' #'flux-mass' #'fixed-temperature'# 'heatflux' # 'fixed-temperature'
    #energy_inlet_function =  'mdot_h_inlet_flux' #${fparse mdot/A * h_inlet}
    energy_inlet_functors = 'temp_in' #'inlet_T' #'temp_in'
    #flux_inlet_pps = 'h_inlet'

    #flux_inlet_pps = '908.15'
    #momentum_inlet_function = '0 -0.9'

    outlet_boundaries = 'ph_outlet'
    momentum_outlet_types = 'fixed-pressure'
    pressure_function = 'p_out' #'p_out' #'outlet_p'

    wall_boundaries                  = 'left    '#      bottom   right    loop_boundary'# core_barrel'
    momentum_wall_types              = 'symmetry'#      noslip   noslip   noslip'# noslip'
    energy_wall_types                = 'heatflux'#  heatflux heatflux heatflux'
    energy_wall_function             = '0    '#'     0        0        0'

    # Constrain Pressure
    #pin_pressure                     = true
    #pinned_pressure_value            = ${p_outlet}
    #pinned_pressure_point            = '0.0 2.13859 0.0'
    #pinned_pressure_type             = point-value-uo

    # Passive Scalar -- solved separetely to integrate porosity jumps
    add_scalar_equation              = false

    #Scaling -- used mainly for nonlinear solves
    # momentum_scaling                 = 1e-3
    # mass_scaling                     = 10
  []
[]

[FVKernels]
  [energy_storage]
    type                  = PINSFVEnergyTimeDerivative
    variable              = T_solid
    rho                   = rho_s
    cp                    = cp_s
    is_solid              = true
  []
  [solid_energy_diffusion_core]
    type                  = PINSFVEnergyAnisotropicDiffusion
    variable              = T_solid
    kappa                 = 'effective_thermal_conductivity'
    effective_diffusivity = true
    porosity              = 1
  []
  [heat_source]
    type                  = FVCoupledForce
    variable              = T_solid
    v                     = prescribed_power_density_graph #power_density_graph
    block                 = 'core core1'
  []
  # ----------------------------------------------------------------------------------------------------------------
  [convection_core]
    type                  = PINSFVEnergyAmbientConvection
    variable              = T_solid
    T_fluid               = T_fluid
    T_solid               = T_solid
    is_solid              = true
    h_solid_fluid         = ${bulk_htc}
    block                 = 'core core1'
  []
  [convection_core_completmeent]
    type                  = PINSFVEnergyAmbientConvection
    variable              = T_fluid
    T_fluid               = T_fluid
    T_solid               = T_solid
    is_solid              = false
    h_solid_fluid         = ${bulk_htc}
    block                 = 'core core1'
  []
  #   # ----------------------------------------------------------------------------------------------------------------
  #   # Kernels for solve of delayed neutron precursor transport
  #   # ----------------------------------------------------------------------------------------------------------------
  [c1_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c1'
  []
  [c2_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c2'
  []
  [c3_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c3'
  []
  [c4_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c4'
  []
  [c5_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c5'
  []
  [c6_time]
    type                 = FVFunctorTimeKernel
    variable             = 'c6'
  []
  [c1_advection]
    type                 = PINSFVMassAdvection
    variable             =  c1
    rho                  = 'c1_porous'
    block                = ${fluid_blocks}
  []
  [c2_advection]
    type                 = PINSFVMassAdvection
    variable             =  c2
    rho                  = 'c2_porous'
    block                = ${fluid_blocks}
  []
  [c3_advection]
    type                 = PINSFVMassAdvection
    variable             =  c3
    rho                  = 'c3_porous'
    block                = ${fluid_blocks}
  []
  [c4_advection]
    type                 = PINSFVMassAdvection
    variable             =  c4
    rho                  = 'c4_porous'
    block                = ${fluid_blocks}
  []
  [c5_advection]
    type                 = PINSFVMassAdvection
    variable             =  c5
    rho                  = 'c5_porous'
    block                = ${fluid_blocks}
  []
  [c6_advection]
    type                 = PINSFVMassAdvection
    variable             =  c6
    rho                  = 'c6_porous'
    block                = ${fluid_blocks}
  []
  #  [c1_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c1
  #    block                = ${fluid_blocks}
  #  []
  #  [c2_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c2
  #    block                = ${fluid_blocks}
  #  []
  #  [c3_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c3
  #    block                = ${fluid_blocks}
  #  []
  #  [c4_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c4
  #    block                = ${fluid_blocks}
  #  []
  #  [c5_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c5
  #    block                = ${fluid_blocks}
  #  []
  #  [c6_turb_diffusion]
  #    type                 = INSFVMixingLengthScalarDiffusion
  #    schmidt_number       = ${Sc_t}
  #    variable             = c6
  #    block                = ${fluid_blocks}
  #  []
  [c1_src]
    type                 = FVCoupledForce
    variable             = c1
    v                    = fission_source
    coef                 = ${beta_1}
    block                = ${fluid_blocks}
  []
  [c2_src]
    type                 = FVCoupledForce
    variable             = c2
    v                    = fission_source
    coef                 = ${beta_2}
    block                = ${fluid_blocks}
  []
  [c3_src]
    type                 = FVCoupledForce
    variable             = c3
    v                    = fission_source
    coef                 = ${beta_3}
    block                = ${fluid_blocks}
  []
  [c4_src]
    type                 = FVCoupledForce
    variable             = c4
    v                    = fission_source
    coef                 = ${beta_4}
    block                = ${fluid_blocks}
  []
  [c5_src]
    type                 = FVCoupledForce
    variable             = c5
    v                    = fission_source
    coef                 = ${beta_5}
    block                = ${fluid_blocks}
  []
  [c6_src]
    type                 = FVCoupledForce
    variable             = c6
    v                    = fission_source
    coef                 = ${beta_6}
    block                = ${fluid_blocks}
  []
  [c1_decay]
    type                 = FVReaction
    variable             = c1
    rate                 = ${lambda_1}
    block                = ${fluid_blocks}
  []
  [c2_decay]
    type                 = FVReaction
    variable             = c2
    rate                 = ${lambda_2}
    block                = ${fluid_blocks}
  []
  [c3_decay]
    type                 = FVReaction
    variable             = c3
    rate                 = ${lambda_3}
    block                = ${fluid_blocks}
  []
  [c4_decay]
    type                 = FVReaction
    variable             = c4
    rate                 = ${lambda_4}
    block                = ${fluid_blocks}
  []
  [c5_decay]
    type                 = FVReaction
    variable             = c5
    rate                 = ${lambda_5}
    block                = ${fluid_blocks}
  []
  [c6_decay]
    type                 = FVReaction
    variable             = c6
    rate                 = ${lambda_6}
    block                = ${fluid_blocks}
  []

[]

[FVBCs]
  [gf]
    type = FVFunctorNeumannBC
    variable = T_fluid
    functor = 0
    boundary = 'bottom   right    loop_boundary'# core_barrel'
  []
  [walls-u]
    type = INSFVNoSlipWallBC
    boundary = 'bottom   right    loop_boundary'# core_barrel'
    variable = 'superficial_vel_x'
    function = 0
  []
  [walls-v]
    type = INSFVNoSlipWallBC
    boundary = 'bottom   right    loop_boundary'# core_barrel'
    variable = 'superficial_vel_y'
    function = 0
  []
  [inlet_c1]
    type = FVFunctorDirichletBC
    variable = c1
    functor = c1_in
    boundary = ph_inlet
  []
  [inlet_c2]
    type = FVFunctorDirichletBC
    variable = c2
    functor = c2_in
    boundary = ph_inlet
  []
  [inlet_c3]
    type = FVFunctorDirichletBC
    variable = c3
    functor = c3_in
    boundary = ph_inlet
  []
  [inlet_c4]
    type = FVFunctorDirichletBC
    variable = c4
    functor = c4_in
    boundary = ph_inlet
  []
  [inlet_c5]
    type = FVFunctorDirichletBC
    variable = c5
    functor = c5_in
    boundary = ph_inlet
  []
  [inlet_c6]
    type = FVFunctorDirichletBC
    variable = c6
    functor = c6_in
    boundary = ph_inlet
  []
[]

[FVInterfaceKernels]
  # Conjugated heat transfer with core barrel
  [convection]
    type                = FVConvectionCorrelationInterface
    variable1           = T_fluid
    variable2           = T_solid
    boundary            = 'core_barrel'
    h                   = ${bulk_htc}
    T_solid             = T_solid
    T_fluid             = T_fluid
    subdomain1          = 'core2 down_comer lower_plenum upper_plenum'
    subdomain2          = 'core_barrel'
    wall_cell_is_bulk   = true
  []
[]

#================================================================================================================
#AUXVARIABLES & AUXKERNELS
#================================================================================================================
[AuxVariables]
  [power_density]
    type              = MooseVariableFVReal
    initial_from_file_var =power_density
  []
  [power_density_fuel]
    type              = MooseVariableFVReal
    initial_from_file_var =power_density_fuel
  []
  [prescribed_power_density_fuel]
    type              = MooseVariableFVReal
    initial_condition = 0. #1000000
  []
  [prescribed_power_density_graph]
    type              = MooseVariableFVReal
    initial_condition = ${fparse 0. * ${graph_heat_frac}} #${fparse 1000000* ${graph_heat_frac}}
  []
  [power_density_graph]
    type              = MooseVariableFVReal
    initial_from_file_var = power_density_graph
  []
  [fission_source]
    type              = MooseVariableFVReal
    initial_from_file_var =fission_source
  []
  [porosity_var]
    type              = MooseVariableFVReal
    block             = ${fluid_blocks}
  []
  [rho_var]
      type = MooseVariableFVReal
      [AuxKernel]
        type = FunctorAux
        functor = 'rho'
        execute_on = 'timestep_end'
      []
  []
  [cp_var]
    type = MooseVariableFVReal
    [AuxKernel]
      type = FunctorAux
      functor = 'cp'
      execute_on = 'timestep_end'
    []
  []
  [mu_var]
    type = MooseVariableFVReal
    [AuxKernel]
      type = FunctorAux
      functor = 'mu'
      execute_on = 'timestep_end'
    []
  []
  [k_var]
    type = MooseVariableFVReal
    [AuxKernel]
      type = FunctorAux
      functor = 'k'
      execute_on = 'timestep_end'
    []
  []
[]

[AuxKernels]
  [porosity_var_aux]
    type                = FunctorAux
    variable            = porosity_var
    functor             = 'porosity'
    block               = ${fluid_blocks}
  []
  [rho_var_aux]
    type                = FunctorAux
    variable            = 'rho_var'
    functor             = 'rho'
    block               = ${fluid_blocks}
  []
  [fuel_power_density_core]
    type                = ParsedAux
    variable            = power_density_fuel
    coupled_variables   = 'power_density'
    expression          = 'power_density * (1.0-${graph_heat_frac})'
    execute_on          = 'INITIAL timestep_end'
    block               = 'core core1 core2'
  []
  [fuel_power_density_others]
    type                = ParsedAux
    variable            = power_density_fuel
    coupled_variables   = 'power_density'
    expression          = 'power_density * 1.0'
    execute_on          = 'INITIAL timestep_end'
    block               = ${non_solid_blocks}
  []
  [graph_power_density]
    type                = ParsedAux
    variable            = power_density_graph
    coupled_variables   = 'power_density'
    expression          = 'power_density * ${graph_heat_frac}'
    execute_on          = 'INITIAL timestep_end'
    block               = 'core core1'
  []
[]
# ================================================================================================================
# MATERIALS
# ================================================================================================================
[FunctorMaterials]
  # [rho_c1_inlet]
  #   type = ADParsedFunctorMaterial
  #   expression              = 'c1_inlet * rho'
  #   functor_names           = 'c1_inlet rho'
  #   property_name           = 'rho_c1_inlet'
  #   execute_on             = 'initial timestep_end'
  # []
  # ----------------------------------------------------------------------------------------------------------------
  # Setting up material porosities at fluid blocks
  # ----------------------------------------------------------------------------------------------------------------
  [porosity]
    type                    = ADPiecewiseByBlockFunctorMaterial
    prop_name               = 'porosity'
    subdomain_to_prop_value = 'core             ${core_porosity}
                               core1            ${core_porosity}
                               core2            ${bypass_porosity}
                               lower_plenum     ${lower_plenum_porosity}
                               upper_plenum     ${upper_plenum_porosity}
                               down_comer       ${down_comer_porosity}
                               riser            ${riser_porosity}
                               core_barrel      0'
                               #pump             ${pump_porosity}
                               #elbow            ${elbow_porosity}

  []
  # ----------------------------------------------------------------------------------------------------------------
  # Setting up hydraulic diameters at fluid blocks
  # ----------------------------------------------------------------------------------------------------------------
  [hydraulic_diameter]
    type                    = PiecewiseByBlockFunctorMaterial
    prop_name               = 'characteristic_length'
    subdomain_to_prop_value = 'core             ${D_H_fuel_channel}
                               core1            ${D_H_fuel_channel}
                               core2            ${D_H_fuel_channel}
                               lower_plenum     ${D_H_plena}
                               upper_plenum     ${D_H_plena}
                               down_comer       ${D_H_downcomer}
                               riser            ${D_H_pipe}'
                               #pump             ${D_H_pipe}
                               #elbow            ${D_H_pipe}'
    block                   = ${fluid_blocks}
  []
  # ----------------------------------------------------------------------------------------------------------------
  # Setting up Fluid & Solid properties
  # ----------------------------------------------------------------------------------------------------------------
  # [fluid_props_to_mat_props]
  #   type                    = GeneralFunctorFluidProps
  #   pressure                = 'pressure'
  #   T_fluid                 = 'T_fluid'
  #   speed                   = 'speed'
  #   characteristic_length   = characteristic_length
  #   block                   = ${fluid_blocks}
  # []
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    fp = salt
    pressure = 101325
    T_fluid = 'T_fluid'
    speed = 1
    porosity = 1
    characteristic_length = 1
    neglect_derivatives_of_density_time_derivative = true
  []
  [enthalpy_material]
    type = INSFVEnthalpyMaterial
    temperature = 'T_fluid'
    rho = 'rho'
    assumed_constant_cp = false
    fp = salt
    pressure = 101325.
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityFunctorMaterial
    u = 'superficial_vel_x'                             #computes total viscosity = mu_t + mu
    v = 'superficial_vel_y'                             #property is called total_viscosity
    mixing_length = 'mixing_length'
    mu = 'mu'
    rho = 'rho'
  []
  [speed]
    type = PINSFVSpeedFunctorMaterial
    superficial_vel_x = superficial_vel_x
    superficial_vel_y = superficial_vel_y
    porosity = porosity
  []
  [core_moderator]
    type                    = ADGenericFunctorMaterial
    prop_names              = 'rho_s   cp_s   k_s'
    prop_values             = '${rho_graph} ${cp_graph} ${k_graph}'
    block                   = 'core core1'
  []
  [core_barrel_steel]
    type                    = ADGenericFunctorMaterial
    prop_names              = 'rho_s   cp_s   k_s'
    prop_values             = '${rho_steel} ${cp_steel} ${k_steel}'
    block                   = 'core_barrel'
  []
  [effective_fluid_thermal_conductivity]
    type                    = ADGenericVectorFunctorMaterial
    prop_names              = 'kappa'
    prop_values             = 'k k k'
    block                   = ${fluid_blocks}
  []
  [effective_solid_thermal_conductivity]
    type                    = ADGenericVectorFunctorMaterial
    prop_names              = 'effective_thermal_conductivity'
    prop_values             = 'k_s k_s k_s'
    block                   =  ${solid_blocks}
  []
  # Drag correlations per block
  [isotropic_drag_core]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '100000 200 100000'
    block                   = 'core'
  []
  [isotropic_drag_core1]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '100000 200 100000'
    block                   = 'core1'
  []
  [isotropic_drag_core2]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '100000 200 100000'
    block                   = 'core2'
  []
  [drag_lower_plenum]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '1 1 1'
    block                   = 'upper_plenum'
  []
  [drag_upper_plenum]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '1 1 1'
    block                   = 'lower_plenum'
  []
  [drag_downcomer]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '1 1 1'
    block                   = 'down_comer'
  []
  [drag_piping]
    type                    = FunctorChurchillDragCoefficients
    multipliers             = '0 0 0'
    block                   = 'riser'
  []
  # ----------------------------------------------------------------------------------------------------------------
  # Materials for computing corrected DNP advection
  # ----------------------------------------------------------------------------------------------------------------
  [c1_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c1 / porosity'
    functor_names           = 'c1 porosity'
    functor_symbols         = 'c1 porosity'
    property_name           = 'c1_porous'
  []
  [c2_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c2 / porosity'
    functor_names           = 'c2 porosity'
    functor_symbols         = 'c2 porosity'
    property_name           = 'c2_porous'
  []
  [c3_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c3 / porosity'
    functor_names           = 'c3 porosity'
    functor_symbols         = 'c3 porosity'
    property_name           = 'c3_porous'
  []
  [c4_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c4 / porosity'
    functor_names           = 'c4 porosity'
    functor_symbols         = 'c4 porosity'
    property_name           = 'c4_porous'
  []
  [c5_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c5 / porosity'
    functor_names           = 'c5 porosity'
    functor_symbols         = 'c5 porosity'
    property_name           = 'c5_porous'
  []
  [c6_mat]
    type                    = ADParsedFunctorMaterial
    expression              = 'c6 / porosity'
    functor_names           = 'c6 porosity'
    functor_symbols         = 'c6 porosity'
    property_name           = 'c6_porous'
  []
[]
# ================================================================================================================
# POSTPROCESSORS
# ================================================================================================================
[Postprocessors]
  [c1_inlet]
    type = Receiver
  []
  [num_failed_steps]
    # if above one, no good
    type = NumFailedTimeSteps
  []
  [area_pp_inlet]
    type = AreaPostprocessor
    boundary = 'ph_inlet'
    execute_on = 'INITIAL'
  []
  [inlet_mdot]
    type = Receiver
    default = 200
  []
  [inlet_T]
    type = Receiver
    default = 908.15
  []
  [outlet_p]
    type = Receiver
    default = 1.7e5
  []
  [reference_pressure_pp]
    type                   = SideAverageValue
    boundary               = 'reference_plane'
    variable               = pressure
    execute_on             = 'initial timestep_end'
  []
  [reference_enthalpy_pp]
    type = MassFluxWeightedFlowRate
    boundary = 'reference_plane'
    vel_x = 'superficial_vel_x'
    vel_y = 'superficial_vel_y'
    advected_quantity = 'h'
    density = 'rho'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    execute_on = 'timestep_end'
  []
  [ref_ps_pp1]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c1
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [ref_ps_pp2]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c2
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [ref_ps_pp3]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c3
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [ref_ps_pp4]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c4
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [ref_ps_pp5]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c5
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [ref_ps_pp6]
    type = MassFluxWeightedFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = c6
    density = '1'
    boundary = 'reference_plane'
    rhie_chow_user_object = 'pins_rhie_chow_interpolator'
    # execute_on = 'timestep_begin'
  []
  [pressure_outlet]
    type                    = SideAverageValue
    variable                = pressure
    boundary                = 'ph_out_sam_in'
  []
  [pressure_inlet]
    type                    = SideAverageValue
    variable                = 'pressure'
    boundary                = 'ph_inlet'
  []
  [pressure_core_delta]
    type                   = ParsedPostprocessor
    function               = 'pressure_inlet - pressure_outlet'
    pp_names               = 'pressure_inlet pressure_outlet'
    execute_on             = 'initial timestep_end'
  []
  [T_inlet]
    type                    = SideAverageValue
    variable                = 'T_fluid'
    boundary                = 'downcomer_outlet'
  []
  [T_outlet]
    type                    = SideAverageValue
    variable                = 'T_fluid'
    boundary                = 'ph_out_sam_in'
  []
  [T_core_inlet]
    type                    = SideAverageValue
    variable                = 'T_fluid'
    boundary                = 'core_in'
  []
  [T_core_outlet]
    type                    = SideAverageValue
    variable                = 'T_fluid'
    boundary                = 'core_out'
  []
  [v_core_inlet]
    type                    = SideAverageValue
    variable                = 'superficial_vel_y'
    boundary                = 'core_in'
  []
  [v_core_outlet]
    type                    = SideAverageValue
    variable                = 'superficial_vel_y'
    boundary                = 'core_out'
  []
  [T_core_delta]
    type                   = ParsedPostprocessor
    function               = 'T_core_outlet - T_core_inlet'
    pp_names               = 'T_core_outlet T_core_inlet'
    execute_on             = 'initial timestep_end'
  []
  [area_pp_downcomer_inlet]
    type                    = AreaPostprocessor
    boundary                = 'ph_inlet'
    execute_on              = 'INITIAL'
  []
  [vfr_downcomer]
    type                    = VolumetricFlowRate
    vel_x                   = superficial_vel_x
    vel_y                   = superficial_vel_y
    advected_quantity       = 1.0
    boundary                = 'ph_inlet'
  []
  [mfr_core_inlet]
    type                    = VolumetricFlowRate
    vel_x                   = superficial_vel_x
    vel_y                   = superficial_vel_y
    advected_quantity       = rho
    boundary                = 'downcomer_outlet'
  []
  [core_vol]
    type                    = VolumePostprocessor
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [loop_vol]
    type                    = VolumePostprocessor
    block                   = ${non_solid_blocks}
    execute_on              = 'initial timestep_end'
  []
  [Tmax_fuel]
    type                    = ElementExtremeValue
    value_type              = max
    variable                = T_fluid
    block                   = ${fluid_blocks}
    execute_on              = 'initial timestep_end'
  []
  [Tavg_fuel]
    type                    = ElementAverageValue
    variable                = T_fluid
    block                   = ${fluid_blocks}
    execute_on              = 'initial timestep_end'
  []
  [Tmax_core_fuel]
    type                    = ElementExtremeValue
    value_type              = max
    variable                = T_fluid
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [Tavg_core_fuel]
    type                    = ElementAverageValue
    variable                = T_fluid
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [Tmax_mod]
    type                    = ElementExtremeValue
    value_type              = max
    variable                = T_solid
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [Tavg_mod]
    type                    = ElementAverageValue
    variable                = T_solid
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [power_total]
    type                    = ElementIntegralVariablePostprocessor
    variable                = power_density
    execute_on              = 'initial timestep_end'
  []
  [power_avg]
    type                    = ElementAverageValue
    variable                = power_density
    execute_on              = 'initial timestep_end'
  []
  [power_fuel_total]
    type                    = ElementIntegralVariablePostprocessor
    variable                = power_density_fuel
    execute_on              = 'initial timestep_end'
  []
  [power_ghrap_total]
    type                    = ElementIntegralVariablePostprocessor
    variable                = power_density_graph
    execute_on              = 'initial timestep_end'
  []
  [power_total_2]
    type                   = ParsedPostprocessor
    function             = 'power_ghrap_total + power_fuel_total'
    pp_names               = 'power_ghrap_total power_fuel_total'
    execute_on             = 'initial timestep_end'
  []
  [fission_source_integral]
    type             = ElementIntegralVariablePostprocessor
    variable         = fission_source
   execute_on       = 'initial timestep_end transfer'
  []
  # [c1_total]
  #   type             = ElementIntegralVariablePostprocessor
  #   variable         = c1
  #   execute_on       = 'initial timestep_end'
  #  block             = ${fluid_blocks}
  # []
  [Keff]
    type             = Receiver
  []
  # [rho_squirrel]
  #   type             = Receiver
  # []
  [rho_griffin]
    type = ParsedPostprocessor
    function = "1/Keff- 1/1.061274"
    pp_names = "Keff"
  []
  # [rho_Delta]
  #   type = ParsedPostprocessor
  #   function = "1e5*(rho_squirrel- rho_griffin)"
  #   pp_names = "rho_squirrel rho_griffin"
  # []
  # #Calc circulation time
  [graphite_vol]
    type                    = VolumePostprocessor
    block                   = 'core core1'
    execute_on              = 'initial timestep_end'
  []
  [bypass_vol]
    type                    = VolumePostprocessor
    block                   = 'core2'
    execute_on              = 'initial timestep_end'
  []
  [lower_plenum_vol]
    type                    = VolumePostprocessor
    block                   = 'lower_plenum'
    execute_on              = 'initial timestep_end'
  []
  [upper_plenum_vol]
    type                    = VolumePostprocessor
    block                   = 'upper_plenum'
    execute_on              = 'initial timestep_end'
  []
  [Aux_vol]
    type                    = VolumePostprocessor
    block                   = 'down_comer riser'
    execute_on              = 'initial timestep_end'
  []
  [Salt_vol_core_and_plena]
    type = ParsedPostprocessor
    function = 'graphite_vol*${core_porosity} + bypass_vol + lower_plenum_vol + upper_plenum_vol'
    pp_names = 'graphite_vol bypass_vol lower_plenum_vol upper_plenum_vol '
  []
  [Salt_vol_total]
    type = ParsedPostprocessor
    function = 'Aux_vol + Salt_vol_core_and_plena'
    pp_names = 'Aux_vol Salt_vol_core_and_plena'
  []

  #Calc circulation core
  [vfr_core]
    type                    = VolumetricFlowRate
    vel_x                   = superficial_vel_x
    vel_y                   = superficial_vel_y
    advected_quantity       = 1.0
    boundary                = 'core_out'
  []

  #calc circulation upper plenum
  [vol_upper_plenum]
    type                    = VolumePostprocessor
    block                   = 'upper_plenum'
    execute_on              = 'initial timestep_end'
  []
  [circulation_time_upper_plenum]
    type = ParsedPostprocessor
    function = 'vol_upper_plenum/vfr_core'
    pp_names = 'vol_upper_plenum vfr_core'
  []

  #calc circulation lower plenum
  [vol_lower_plenum]
    type                    = VolumePostprocessor
    block                   = 'lower_plenum'
    execute_on              = 'initial timestep_end'
  []
  [circulation_time_lower_plenum]
    type = ParsedPostprocessor
    function = 'vol_lower_plenum/vfr_core'
    pp_names = 'vol_lower_plenum vfr_core'
  []
[]


# ================================================================================================================
# Pump transient pump
# ================================================================================================================
[Functions]
  [time_stepper]
    type         = PiecewiseConstant
    # x            = '-500 -20   0    3e-5    0.005 2    50.0    100.0'
    # y            = '  25 0.05  1e-5 0.001   0.05   0.05  10.0     10.0'
    # x            = '-20  2    10.0    20 200'
    # y            = '1    1  5     10.0'
    x = '-2000.0    -1950.0  -1900.0 -1500.0  -1000  -500     0.0 '
    y = '    0.5        2.0      5.0    10.0     50.  100.0   100.0'
  []
  [pump_mass_flow]
    type = PiecewiseLinear
    xy_data =
    "
    -500   0.000
    -1   0.000
    0 0.0
    0.01	0.3217422
    1.01	0.6955083
    1.22	0.753172
    1.51	0.8606388
    1.71	1.3394747
    2.01	4.1665807
    2.21	5.9437789
    2.52	15.2513386
    2.8	    26.4035804
    3.03	37.6882878
    3.3	    48.4756182
    3.53	56.672489
    3.71	65.3763398
    4.02	70.9800623
    4.3	    76.1784862
    4.52	80.7886618
    4.86	85.0555664
    5.05	87.468681
    5.35	89.776737
    5.57	91.9527784
    5.76	93.0330588
    6.02	94.0825221
    6.33	95.2130242
    6.56	95.7846775
    6.75	96.1913261
    7.02	97.3445998
    7.22	98.3093899
    7.53	99.4160455
    7.82	99.8716087
    10	100
        "
     []
  # [mdot_h_inlet_flux]
  #   type = ParsedFunction
  #   expression = 'mdot_h_inlet_flux_pp'
  #   symbol_names = 'mdot_h_inlet_flux_pp'
  #   symbol_values = 'mdot_h_inlet_flux_pp'
  # []
[]

# ================================================================================================================
# EXECUTION PARAMETERS
# ================================================================================================================
[Executioner]
  type                             = Transient
  solve_type                       = NEWTON
  petsc_options_iname              = '-pc_type -sub_pc_factor_shift_type'
  petsc_options_value              = ' lu       NONZERO'
  automatic_scaling                = true
  nl_abs_tol                       = 1e-6
  nl_max_its                       = 50
  [TimeStepper]
    type                           = FunctionDT
    function                       = time_stepper
    min_dt                         = 1e-3
  []
  auto_advance = true
  start_time                       = -2000
  end_time                         =  -1000
  steady_state_detection           = false # true
  steady_state_tolerance           = 1e-16
  fixed_point_min_its = 3
  fixed_point_max_its = 15
  custom_pp = overlapping_coupling_error
  disable_fixed_point_residual_norm_check = true
  accept_on_max_fixed_point_iteration     = true
  direct_pp_value = true
  custom_abs_tol = 1e-6
  custom_rel_tol = 1e-6
[]
# ================================================================================================================
# OUTPUTS & DEBUG
# ================================================================================================================
[Debug]
  show_var_residual_norms          = false
[]
[Outputs]
  csv                              = true
  exodus                           = true
  print_linear_converged_reason    = false
  print_linear_residuals           = false
  print_nonlinear_converged_reason = false
[]

# ================================================================================================================
# MULTIAPPS AND TRANSFERS
# ================================================================================================================
[MultiApps]
  [Griffin]
    type                         = FullSolveMultiApp
    input_files                  = 'griffin_EV.i'
    execute_on                   = 'timestep_end'
    max_procs_per_app            = 48
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [c1_inlet_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sc_transient_app
    reduction_type = average
    from_postprocessor = c1_inlet
    to_postprocessor = c1_inlet
  []
  [c1]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app           = Griffin
    source_variable        = 'c1'
    variable               = 'c1'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [c2]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app         = Griffin
    source_variable        = 'c2'
    variable               = 'c2'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [c3]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app         = Griffin
    source_variable        = 'c3'
    variable               = 'c3'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [c4]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app         = Griffin
    source_variable        = 'c4'
    variable               = 'c4'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [c5]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app         = Griffin
    source_variable        = 'c5'
    variable               = 'c5'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [c6]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app           = Griffin
    source_variable        = 'c6'
    variable               = 'c6'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []

   #Fix rate form no flow ss
  [Pull_fission_source]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app         = Griffin
    source_variable        = 'fission_source_normalized'
    variable               = 'fission_source'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [Pull_power_density]
    type                   = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app         = Griffin
    source_variable        = 'power_density'
    variable               = 'power_density'
    execute_on             = 'timestep_end'
    search_value_conflicts = false
  []
  [Pull_Keff]
    type                = MultiAppPostprocessorTransfer
    from_multi_app      = Griffin
    from_postprocessor  = eigenvalue
    to_postprocessor    = Keff
    reduction_type      = average
    execute_on          = 'timestep_end'
  []
[]
