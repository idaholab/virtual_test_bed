# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Steady-state HTR-PM SAM porous media model
# Author(s): Zhiee Jhia Ooi, Gang Yang, Travis Mui, Ling Zou, Rui Hu or ANL
# ==============================================================================
# - This is a SAM reference plant model for the HTR-PM reactor.
#
# - The model consists of a porous-media core model, a 0-D/1-D primary loop model,
#   and a RCCS model.
#
# - The primary loop model is based on the design of the actual primary loop of the
#   HTR-PM reactor. Dimensions and geometries of the primary loop were estimated
#   graphically from publicly available figures and information.
#
# - The RCCS is a water-cooled system. The dimensions of the riser channels are
#   are based on the "Scaling Analysis of Reactor Cavity Cooling System in HTR" by
#   Roberto et al. (2020). No cooling tower is included in the RCCS model. Instead,
#   a heat exchanger is included in the model to remove heat from the RCCS.
#
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Problem Parameters -----------------------------------------------------------
active_core_blocks  = 'pebble_bed'
pebble_blocks       = 'pebble_bed'
porous_blocks       = 'top_reflector bottom_reflector'
cavity_blocks       = 'top_cavity'
fluid_blocks        = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
solid_blocks        = 'side_reflector carbon_brick core_barrel rpv refl_barrel_gap barrel_rpv_gap bypass_riser_reflector bypass_pebble_reflector riser bypass'

# Vertical surfaces on the inner and outer boundaries of the pebble bed
slip_wall_vertical  = 'pbed_inner btm_ref_vert_inner top_cavity_vertical_inner'
slip_wall_vertical_outer = 'pbed_outer btm_ref_vert_outer top_reflector_wall_vertical top_cavity_vertical_outer'


# Geometry ---------------------------------------------------------------------
pebble_diam = 0.06 # Diameter of the pebbles (m).
pbed_d      = 3.0  # Pebble bed diameter (m)
v_mag = 1.0

# Properties -------------------------------------------------------------------
T_inlet           = 523.15 # Helium inlet temperature (K).
p_outlet          = 7.0e+6 # Reactor outlet pressure (Pa)
rho_in            = 6.3306  # Helium density at 7 MPa and 523.15 K (from NIST)

# Start model ------------------------------------------------------------------
[GlobalParams]
  gravity = '0 -9.807 0' # SAM default is 9.8 for Z-direction
  eos = helium
  u = vel_x
  v = vel_y
  pressure = p
  temperature = T
  rho = density

  # Reduces transfers efficiency for now, can be removed once transferred fields are checked
  bbox_factor = 10
[]

[Mesh]
    file = htr-pm-mesh-bypass-riser.e
    coord_type = RZ
    rz_coord_axis = Y
[]

[Problem]
  type = FEProblem
[]

[Functions]
  # Axial distribution of power
  [Q_axial]
    type = PiecewiseLinear
    axis = y
    x = '3.228  3.768 4.198 4.698 5.198 5.698 6.198 6.698 7.198 7.698 8.198 8.698 9.198 10.3  11.5  12  12.8  13.4  13.8  14.228'
    y = '0.5  0.56660312  0.70174359  0.84062718  0.97604136  0.95988015   1.05950249 1.0727253 1.1394942 1.19985528  1.24058574  1.24499334 1.26168557  1.26315477 1.20720129  1.14977861 1.0 0.8 0.56820578  0.5'
  []
  # Radial distribution of power
  [Q_radial]
    type = PiecewiseLinear
    axis = x
    x = '0            0.35        0.36         0.56        0.57         0.77        0.78         0.98        0.99       1.2'
    y = '0.218854258  0.218854258 0.205293334  0.205293334 0.191519566  0.191519566 0.185868174  0.185868174 0.198464668  0.198464668'
  []
  # Changes of power level with respect to time
  [Q_time]
    type = PiecewiseLinear
    x = '-1.00E+06  0 1.00E-06  0.5 1 2.5 5 10  20  50  100 200 500 1000  2000  4000  6000  10000 20000 40000 60000 100000  150000  200000  250000  300000  365000 430000 495000 560000 625000 690000 755000'
    y = '1        1 0.06426 0.06193 0.06008 0.05603 0.0518  0.04704 0.04216 0.03592 0.03137 0.02739 0.02287 0.01945 0.01599 0.01281 0.01127 0.00966 0.00795 0.00655 0.00582 0.00499 0.00438 0.00399 0.00369 0.00347 0.00323 2.99e-3 2.75e-3 2.51e-3 2.27e-3 2.03e-3 1.79e-3'
  []
  # Combine time, axial distribution, and radial distribution
  [Q_fn]
    type = CompositeFunction
    functions = 'Q_axial Q_time Q_radial'
    scale_factor = 15.87877834e6 # To give a total of 250 MWth
  []
  [rhoHe]  #Helium  density; x- Temperature [K], y- density [kg/m3] @ P=7 MPa, NIST database
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '6.6176 6.3682  6.137 5.9219  5.7214  5.534 5.3585  5.1937  5.0388  4.8929  4.7551  4.6249  4.5016  4.3848  4.2738  4.1683  4.0679  3.9722  3.8809  3.7937  3.7103  3.6305  3.5541  3.4808  3.4105  3.343 3.278 3.2156  3.1555  3.0976  3.0417  2.9879  2.9359  2.8857  2.8372  2.7903  2.7449  2.701 2.6584  2.6172  2.5772  2.5384  2.5008  2.4643  2.4288  2.3943  2.3608  2.3283  2.2966  2.2657  2.2357'
  []
  [muHe]  #Helium viscosity; x- Temperature [K], y-viscosity [Pa.s]
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '2.85E-05 2.93E-05  3.01E-05  3.08E-05  3.16E-05  3.23E-05  3.31E-05  3.38E-05  3.45E-05  3.53E-05  3.60E-05  3.67E-05  3.74E-05  3.81E-05  3.88E-05  3.95E-05  4.02E-05  4.09E-05  4.16E-05  4.23E-05  4.29E-05  4.36E-05  4.43E-05  4.49E-05  4.56E-05  4.62E-05  4.69E-05  4.75E-05  4.82E-05  4.88E-05  4.94E-05  5.01E-05  5.07E-05  5.13E-05  5.20E-05  5.26E-05  5.32E-05  5.38E-05  5.44E-05  5.50E-05  5.57E-05  5.63E-05  5.69E-05  5.75E-05  5.81E-05  5.87E-05  5.92E-05  5.98E-05  6.04E-05  6.10E-05  6.16E-05'
  []
  [kHe]  #Helium therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '0.22621  0.23233 0.23838 0.24437 0.2503  0.25616 0.26197 0.26773 0.27344 0.27909 0.2847  0.29026 0.29578 0.30126 0.30669 0.31208 0.31743 0.32275 0.32802 0.33327 0.33847 0.34365 0.34879 0.3539  0.35897 0.36402 0.36904 0.37403 0.37899 0.38392 0.38883 0.39371 0.39856 0.40339 0.4082  0.41298 0.41774 0.42248 0.42719 0.43188 0.43655 0.4412  0.44583 0.45043 0.45502 0.45959 0.46414 0.46867 0.47318 0.47767 0.48215'
  []

 #######
  [T_reactor_in]
    type = ParsedFunction
    value = 'T_in'
    vars = 'T_in'
    vals = '2Dreceiver_temperature_in'
  []
  [T_core_out]
    type = ParsedFunction
    value = 'T_out'
    vars = 'T_out'
    vals = '2Dreceiver_temperature_out'
  []
[]

[EOS]
  [helium]
    type    =    PTFunctionsEOS
    rho     =    rhoHe
    cp      =    5240
    mu      =    muHe
    k       =    kHe
    T_min   = 500
    T_max   = 1500
  []
[]

[MaterialProperties]
  [rpv-ss-mat]
    type = HeatConductionMaterialProps
    k = 38.0
    Cp = 540.0
    rho = 7800.0
  []
  [cb-ss-mat]
    type = HeatConductionMaterialProps
    k = 17.0
    Cp = 540.0
    rho = 7800.0
  []
  [graphite]
    type = HeatConductionMaterialProps
    k = 26.0
    rho = 1780
    Cp = 1697
  []
  [he]
    type = HeatConductionMaterialProps
    k = 4
    rho = 6.0
    Cp = 5000
  []
  [graphite_porous]
    type = HeatConductionMaterialProps
    k = 17.68
    rho = 1153.96
    Cp = 1210.4
  []
[]


# ========================================================
# Specifications for 2D part of model
# ========================================================

# WARNING: variable names for 2D model need to be different from 1D variable names
#   The 1D variable names are : 'pressure', 'velocity', 'temperature', 'T_solid', and 'rho'
#   Here the 2D variable names are: 'p', 'vel_x', 'vel_y', 'vel_z', 'T' (fluid temperature),
#   'Ts' (solid temperature), and 'density'

[Variables]
  # Velocity
  [vel_x]
    scaling = 1e-3
    initial_condition = 1.0E-08
    block = ${fluid_blocks}
  []
  [vel_y]
    scaling = 1e-3
    initial_condition = 1.0E-08
    block = ${fluid_blocks}
  []
  # Pressure
  [p]
    scaling = 1
    initial_condition = ${p_outlet}
    block = ${fluid_blocks}
  []
  # Fluid Temperature
  [T]
    scaling = 1.0e-6
    initial_condition = ${T_inlet}
    block = ${fluid_blocks}
  []
  # Solid temperature
  [Ts]
    scaling = 1.0e-6
    initial_condition = ${T_inlet}
    block = '${pebble_blocks} ${porous_blocks} ${solid_blocks} ${cavity_blocks}'
  []
[]

[AuxVariables]
  [density]
    block = ${fluid_blocks}
    initial_condition = ${rho_in}
  []
  [porosity_aux]
    order = CONSTANT
    family = MONOMIAL
  []
  [power_density]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 3.215251376e6
    block = '${active_core_blocks}'
  []
  [v_mag]
    initial_condition = ${v_mag}
    block = ${fluid_blocks}
  []

  # Aux variables for heat transfer between bypass and riser
  [T_fluid_external_bypass]
    family = LAGRANGE
    order = FIRST
    initial_condition = ${T_inlet}
  []
  [htc_external_bypass]
    family = LAGRANGE
    order = FIRST
    initial_condition = 3.0e3
  []
  [T_fluid_external_riser]
    family = LAGRANGE
    order = FIRST
    initial_condition = ${T_inlet}
  []
  [htc_external_riser]
    family = LAGRANGE
    order = FIRST
    initial_condition = 3.0e3
  []

  # Aux variables for RCCS MultiApp transfer
  [TRad]
    initial_condition =  ${T_inlet}
    block = 'rpv'
  []

[]

[Materials]
  [pebble_bed]
    type = PorousFluidMaterial
    block = ${fluid_blocks}
    d_pebble = ${pebble_diam}
    d_bed = ${pbed_d}
    porosity = porosity_aux
    friction_model = KTA
    HTC_model = KTA
    Wall_HTC_model = Achenbach
    compute_turbulence_viscosity = true
    mixing_length = 0.2
  []
  [pebble_keff]
    type = PebbleBedEffectiveThermalConductivity
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    d_pebble = ${pebble_diam}
    porosity = porosity_aux
    k_effective_model = ZBS
    solid = graphite
    tsolid = Ts
  []
  [pebble_mat]
    type = SAMHeatConductionMaterial
    block = ${pebble_blocks}
    properties = graphite
    temperature = Ts
  []
  [graphite_mat]
    type = SAMHeatConductionMaterial
    block = 'side_reflector carbon_brick bypass_riser_reflector bypass_pebble_reflector'
    properties = graphite
    temperature = Ts
  []
  [graphite_porous_mat]
    type = SAMHeatConductionMaterial
    block = 'bypass riser'
    properties = graphite_porous
    temperature = Ts
  []
  [core_barrel_steel_mat]
    type = SAMHeatConductionMaterial
    block = 'core_barrel'
    properties = cb-ss-mat
    temperature = Ts
  []
  [rpv_steel_mat]
    type = SAMHeatConductionMaterial
    block = 'rpv'
    properties = rpv-ss-mat
    temperature = Ts
  []
  [He_gap_mat]
    type = SAMHeatConductionMaterial
    block = 'refl_barrel_gap barrel_rpv_gap'
    properties = he
    temperature = Ts
  []
[]

[Kernels]
  # mass eq
  [mass_time]
    type = PMFluidPressureTimeDerivative
    variable = p
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [mass_space]
    type = MDFluidMassKernel
    variable = p
    porosity = porosity_aux
    block = ${fluid_blocks}
  []

  # x-momentum
  [x_momentum_time]
    type = PMFluidVelocityTimeDerivative
    variable = vel_x
    block = ${fluid_blocks}
  []
  [x_momentum_space]
    type = MDFluidMomentumKernel
    variable = vel_x
    porosity = porosity_aux
    component = 0
    block = ${fluid_blocks}
  []

  # y-momentum
  [y_momentum_time]
    type = PMFluidVelocityTimeDerivative
    variable = vel_y
    block = ${fluid_blocks}
  []
  [y_momentum_space]
    type = MDFluidMomentumKernel
    variable = vel_y
    porosity = porosity_aux
    component = 1
    block = ${fluid_blocks}
  []

  # Fluid temperature
  [temperature_time]
    type = PMFluidTemperatureTimeDerivative
    variable = T
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [temperature_space]
    type = MDFluidEnergyKernel
    variable = T
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [temperature_heat_transfer]
    type = PorousMediumEnergyKernel
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    variable = T
    T_solid = Ts
  []

  # Pebble-bed solid temperature (pebble surface temperature)
  [solid_time]
    type = PMSolidTemperatureTimeDerivative
    # block = ${fluid_blocks
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    variable = Ts
    porosity = porosity_aux
    solid = graphite
  []
  [solid_conduction]
    type = PMSolidTemperatureKernel
    variable = Ts
    block    = '${porous_blocks} ${cavity_blocks}'
    T_fluid = T
  []
  [solid_conduction_core]
    type = PMSolidTemperatureKernel
    block = ${active_core_blocks}
    variable = Ts
    T_fluid = T
    power_density_var = power_density # set power density in pebble bed
  []
  # Other solid (non-porous) temperature
  [transient_term_reflector]
    type = HeatConductionTimeDerivative
    variable = Ts
    block = ${solid_blocks}
  []
  [diffusion_term_reflector]
    type = HeatConduction
    variable = Ts
    block = ${solid_blocks}
  []
[]

[AuxKernels]
  [rho_aux]
    type = DensityAux
    variable = density
    block = ${fluid_blocks}
  []
  [v_aux]
    type = VelocityMagnitudeAux
    variable = v_mag
  []
  [porosity_bed]
    type = ConstantAux
    variable = porosity_aux
    block = 'pebble_bed'
    value = 0.39
  []
  [porosity_reflector_top]
    type = ConstantAux
    variable = porosity_aux
    block = 'top_reflector'
    value = 0.3
  []
  [porosity_reflector_bottom]
    type = ConstantAux
    variable = porosity_aux
    block = 'bottom_reflector'
    value = 0.3
  []
  [porosity_top_cavity]
    type = ConstantAux
    variable = porosity_aux
    block = 'top_cavity'
    value = 0.99
  []
  [power_density]
    type = FunctionAux
    variable = power_density
    function = Q_fn
  []
[]

# For coupling the solid surfaces across 1-D components
# such as the bypass, riser, and hot plenum
[Constraints]
  # [gap_conductance_pbed_bottom]
  #   type = GapHeatTransferConstraint
  #   variable = Ts
  #   h_gap = 1e5 #Arbitrarily large to mimic actual conduction in htr-pm
  #   primary = 'core_outlet'
  #   secondary = 'hot_plenum_wall_bottom'
  #   primary_variable = Ts
  #   RZ_multiplier_1 = 1.0
  #   RZ_multiplier_2 = 1.0
  # []


  # [gap_conductance_riser]
  #   type = GapHeatTransferConstraint
  #   variable = Ts
  #   h_gap = 1e5 #Arbitrarily large to mimic actual conduction in htr-pm
  #   primary = 'riser_wall_vertical_inner'
  #   secondary = 'riser_wall_vertical_outer'
  #   primary_variable = Ts
  #   RZ_multiplier_1 = 1
  #   RZ_multiplier_2 = 1
  # []
[]

[BCs]
  # Inlet BCs
  [BC_inlet_mass]
    type = MDFluidMassBC
    boundary = 'core_inlet'
    variable = p
    pressure = p
    u = vel_x
    v = vel_y
    temperature = T
    eos = helium
  []
  [BC_inlet_x_mom]
    type = DirichletBC
    boundary = 'core_inlet'
    variable = vel_x
    value = 0
  []
  [BC_inlet_y_mom]
    type = PostprocessorDirichletBC
    boundary = 'core_inlet'
    variable = vel_y
    postprocessor = 2Dreceiver_velocity_in
  []
  [BC_inlet_T]
    type = INSFEFluidEnergyDirichletBC
    variable = T
    boundary = 'core_inlet'
    out_norm = '0 1 0'
    T_fn = T_reactor_in
  []

  # Outlet BCs
  [BC_outlet_mass]
    type = DirichletBC
    boundary = 'core_outlet'
    variable = p
    value = 0
  []
  [BC_outlet_T]
    type = INSFEFluidEnergyDirichletBC
    variable = T
    boundary = 'core_outlet'
    out_norm = '0 -1 0'
    T_fn = T_core_out
  []

  # Wall BCs
  [BC_fluidWall_x_mom]
    type = DirichletBC
    boundary = '${slip_wall_vertical} ${slip_wall_vertical_outer}'
    variable = vel_x
    value = 0
  []

  # Heat transfer bypass and risers
  [HeatTransfer_bypass_inner_wall]
    type = CoupledConvectiveHeatFluxBC
    variable = Ts
    boundary = 'bypass_wall_vertical_inner'
    T_infinity = T_fluid_external_bypass
    htc = htc_external_bypass
  []
  [HeatTransfer_riser_inner_wall]
    type = CoupledConvectiveHeatFluxBC
    variable = Ts
    boundary = 'riser_wall_vertical_inner'
    T_infinity = T_fluid_external_riser
    htc = htc_external_riser
  []

  ##### RCCS : Radiative BC for RPV
 [RPV_out]
   type = CoupledRadiationHeatTransferBC
   variable = Ts
   T_external = TRad
   boundary = 'rpv_outer'
   emissivity = 0.8
   emissivity_external = 0.8
 []
[]

[Postprocessors]
  [2Dsource_pressure_in]
    type = SideAverageValue
    variable = p
    boundary = 'core_inlet'
  []

  [2Dsource_pressure_out]
    type = SideAverageValue
    variable = p
    boundary = 'core_outlet'
  []

  [2Dsource_temperature_in]
    type = SideAverageValue
    variable = T
    boundary = 'core_inlet'
  []

  [2Dsource_temperature_out]
    type = SideAverageValue
    variable = T
    boundary = 'core_outlet'
  []

  [2Dsource_velocity_in]
    type = SideAverageValue
    variable = vel_y
    boundary = 'core_inlet'
  []

  [2Dsource_velocity_out]
    type = SideAverageValue
    variable = vel_y #vel_y
    boundary = 'core_outlet'
  []

  [2Dreceiver_temperature_in]
    type = Receiver
    default = 523.15
  []

  [2Dreceiver_temperature_out]
    type = Receiver
  []

  [2Dreceiver_velocity_in]
    type = Receiver
  []
  [mflow_core_in]
    type = MDSideMassFluxIntegral
    boundary = 'core_inlet'
  []
  [mflow_core_out]
    type = MDSideMassFluxIntegral
    boundary = 'core_outlet'
  []

  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = ${active_core_blocks}
  []
  [pebble_bed_volume]
    type = VolumePostprocessor
    block = ${pebble_blocks}
    execute_on = 'initial'
  []


  # multi D temperature
  [Tsolid_pebble_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tfluid_pebble_avg]
    type       = ElementAverageValue
    block      = 'pebble_bed'
    variable   = T
    execute_on = 'initial timestep_end'
  []
  [Tsolid_pebble_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    value_type = max
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tfluid_pebble_max]
    type       = ElementExtremeValue
    block      = 'pebble_bed'
    value_type = max
    variable   = T
    execute_on = 'initial timestep_end'
  []
  [Tsolid_reflector_avg]
    type       = ElementAverageValue
    block      = 'side_reflector bypass_riser_reflector bypass_pebble_reflector'
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_reflector_max]
    type       = ElementExtremeValue
    block      = 'side_reflector bypass_riser_reflector bypass_pebble_reflector'
    value_type = max
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_brick_avg]
    type       = ElementAverageValue
    block      = 'carbon_brick'
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_brick_max]
    type       = ElementExtremeValue
    block      = 'carbon_brick'
    value_type = max
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_core_barrel_avg]
    type       = ElementAverageValue
    block      = 'core_barrel'
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_core_barrel_max]
    type       = ElementExtremeValue
    block      = 'core_barrel'
    value_type = max
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_rpv_avg]
    type       = ElementAverageValue
    block      = 'rpv'
    variable   = Ts
    execute_on = 'initial timestep_end'
  []
  [Tsolid_rpv_max]
    type       = ElementExtremeValue
    block      = 'rpv'
    value_type = max
    variable   = Ts
    execute_on = 'initial timestep_end'
  []

  [core_pressure_in]
    type = SideAverageValue
    variable = p
    boundary = 'core_inlet'
  []
  [core_pressure_out]
    type = SideAverageValue
    variable = p
    boundary = 'core_outlet'
  []
  [dpdz_core]
    type = ParsedPostprocessor
    function = 'core_pressure_out / 13.9 - core_pressure_in / 13.9'
    pp_names = 'core_pressure_out core_pressure_in'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

# Set up the MultiApp system
# Here we use 'TransientMultiApp' because we run the
# model in transient until it reaches steady-state
[MultiApps]
  [primary_loop]
    type = TransientMultiApp
    input_files = 'ss-primary-loop-full.i'
    catch_up = true
    execute_on = 'TIMESTEP_END'
  []

  [rccs]
    type = TransientMultiApp
    execute_on = timestep_end
    app_type = SamApp
    input_files = 'ss-rccs-water.i'
    catch_up = true
  []
[]

[Transfers]

  # From 2D to 1D
  # Inlet and outlet boundary conditions
  [2Dto1D_temperature_in_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = primary_loop
    from_postprocessor = 2Dsource_temperature_in
    to_postprocessor = 1Dreceiver_temperature_in
  []

  [2Dto1D_temperature_out_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = primary_loop
    from_postprocessor = 2Dsource_temperature_out
    to_postprocessor = 1Dreceiver_temperature_out
  []

  # Send riser and bypass wall temperature to
  # 1-D primary loop model
  [To_subApp_Twall_riser]
    type = MultiAppUserObjectTransfer
    direction = to_multiapp
    user_object = Twall_riser_inner
    variable = Twall_riser_inner_from_main
    multi_app = primary_loop
  []
  [To_subApp_Twall_bypass]
    type = MultiAppUserObjectTransfer
    direction = to_multiapp
    user_object = Twall_bypass_inner
    variable = Twall_bypass_inner_from_main
    multi_app = primary_loop
  []

  # Send pebble-bed pressure drop to the
  # surrogate channel in the 1-D primary loop model
  [2Dto1D_core_dp]
    type = MultiAppPostprocessorTransfer
    to_multi_app = primary_loop
    from_postprocessor = dpdz_core
    to_postprocessor = dpdz_core_receive
  []

  # from 1D to 2D
  # Inlet and outlet boundary conditions
  [1Dto2D_temperature_in_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = primary_loop
    reduction_type = average
    from_postprocessor = 1Dsource_temperature_in
    to_postprocessor = 2Dreceiver_temperature_in
  []

  [1Dto2D_temperature_out_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = primary_loop
    reduction_type = average
    from_postprocessor = 1Dsource_temperature_out
    to_postprocessor = 2Dreceiver_temperature_out
  []

  [1Dto2D_velocity_in_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = primary_loop
    reduction_type = average
    from_postprocessor = 1Dsource_velocity_in
    to_postprocessor = 2Dreceiver_velocity_in
  []

  # Obtain fluid temperature and HTC of the
  # riser and bypass from 1-D primary loop model
  # for the calculation of wall temperature in the
  # multi-D model
  [from_subApp_T_fluid]
    type = MultiAppGeneralFieldNearestNodeTransfer
    direction = from_multiapp
    multi_app = primary_loop
    source_variable = temperature
    variable = T_fluid_external_riser
    from_blocks = 'riser'
    to_blocks = 'bypass_riser_reflector'
    execute_on = 'TIMESTEP_END'
  []
  [from_subApp_htc]
    type = MultiAppGeneralFieldNearestNodeTransfer
    direction = from_multiapp
    multi_app = primary_loop
    source_variable = htc_external
    variable = htc_external_riser
    from_blocks = 'riser'
    to_blocks = 'bypass_riser_reflector'
    execute_on = 'TIMESTEP_END'
  []

  [from_subApp_T_fluid_bypass]
    type = MultiAppGeneralFieldNearestNodeTransfer
    direction = from_multiapp
    multi_app = primary_loop
    source_variable = temperature
    variable = T_fluid_external_bypass
    from_blocks = 'bypass'
    to_blocks = 'bypass_pebble_reflector'
    execute_on = 'TIMESTEP_END'
  []
  [from_subApp_htc_bypass]
    type = MultiAppGeneralFieldNearestNodeTransfer
    direction = from_multiapp
    multi_app = primary_loop
    source_variable = htc_external
    variable = htc_external_bypass
    from_blocks = 'bypass'
    to_blocks = 'bypass_pebble_reflector'
    execute_on = 'TIMESTEP_END'
  []

  # Send radiation heat flux to the
  # 1-D RCCS model
  [QRad_to_subRCCS]
    type = MultiAppUserObjectTransfer
    direction = to_multiapp
    user_object = QRad_UO
    variable = QRad
    multi_app = rccs
    execute_on = TIMESTEP_END
    displaced_target_mesh = true
  []

  # Obtain RCCS panel temperature from the
  # 1-D RCCS model
  [TRad_from_RCCS_sub]
   type = MultiAppUserObjectTransfer
    direction = from_multiapp
    user_object = TRad_UO
    variable = TRad
    multi_app = rccs
    displaced_source_mesh = true
    execute_on = TIMESTEP_END
  []
[]

# For calculating layer-averaged
# parameters used in MultiApp transfer
[UserObjects]
  [QRad_UO]
    type = LayeredSideFluxAverage
    variable = Ts
    direction = y
    num_layers = 45
    boundary = 'rpv_outer'
    diffusivity = thermal_conductivity
    execute_on = 'TIMESTEP_END'
  []

  [Twall_riser_inner]
    type = LayeredSideAverage
    direction = y
    num_layers = 36
    sample_type = direct
    variable = Ts
    boundary = 'riser_wall_vertical_inner'
  []

  [Twall_bypass_inner]
    type = LayeredSideAverage
    direction = y
    num_layers = 36
    sample_type = direct
    variable = Ts
    boundary = 'bypass_wall_vertical_inner'
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 100'
  []
[]

[Executioner]
  type = Transient
  dtmin = 1e-6
  dtmax = 500

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.25
    optimal_iterations = 10
    linear_iteration_ratio = 100
    dt = 0.1
    cutback_factor = 0.8
    cutback_factor_at_failure = 0.8
  []

  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-4
  nl_max_its = 15
  l_tol      = 1e-3
  l_max_its  = 100

  start_time = -200000
  end_time = 0

  fixed_point_rel_tol                 = 1e-3
  fixed_point_abs_tol                 = 1e-3
  fixed_point_max_its            = 10
  relaxation_factor              = 0.8
  relaxed_variables              = 'p T vel_x vel_y'
  accept_on_max_fixed_point_iteration = true

  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  [out]
    type = Exodus
    use_displaced = true
    sequence = false
  []
  [csv]
    type = CSV
  []
  # Commented out for git purpose
  [checkpoint]
    type = Checkpoint
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [console]
    type = Console
    fit_mode = AUTO
    execute_scalars_on = 'NONE'
  []
[]
