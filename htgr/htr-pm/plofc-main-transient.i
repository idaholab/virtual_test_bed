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
#   graphically from publicly available figures and information. Some main updates
#   the primary loop model includes the addition of the co-axial inlet/outlet channel,
#   the re-arrangement of components to more accurately reflect the actual system,
#   and the use of best-estimate geometric info/dimensions for the components.
#
# - The RCCS is a water-cooled system. The dimensions of the riser channels
#   are based on the "Scaling Analysis of Reactor Cavity Cooling System in HTR" by
#   Roberto et al. (2020). No cooling tower is included in the RCCS model. Instead,
#   a heat exchanger is included in the model to remove heat from the RCCS.
#
#
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

!include htr-pm-common.i

# Geometry ---------------------------------------------------------------------
pebble_diam = 0.06 # Diameter of the pebbles (m).
pbed_d      = 3.0  # Pebble bed diameter (m)
# v_mag = 1.0

# # Properties -------------------------------------------------------------------
# T_inlet           = 523.15 # Helium inlet temperature (K).
# p_outlet          = 7.0e+6 # Reactor outlet pressure (Pa)
# rho_in            = 6.3306  # Helium density at 7 MPa and 523.15 K (from NIST)

[Problem]
  # restart_file_base = 'ss-main_checkpoint_cp/0202'
  restart_file_base = 'ss-main_checkpoint_cp/LATEST'
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
    #initial_condition = 1.0E-08
    block = ${fluid_blocks}
  []
  [vel_y]
    scaling = 1e-3
    #initial_condition = 1.0E-08
    block = ${fluid_blocks}
  []
  # Pressure
  [p]
    scaling = 1
    #initial_condition = ${p_outlet}
    block = ${fluid_blocks}
  []
  # Fluid Temperature
  [T]
    scaling = 1.0e-6
    #initial_condition = ${T_inlet}
    block = ${fluid_blocks}
  []
  # Solid temperature
  [Ts]
    scaling = 1.0e-6
    #initial_condition = ${T_inlet}
    block = '${pebble_blocks} ${porous_blocks} ${solid_blocks} ${cavity_blocks}'
  []
[]

[AuxVariables]
  [density]
    block = ${fluid_blocks}
    #initial_condition = ${rho_in}
  []
  [porosity_aux]
    order = CONSTANT
    family = MONOMIAL
  []
  [power_density]
    order = CONSTANT
    family = MONOMIAL
    #initial_condition = 3.215251376e6
    block = '${active_core_blocks}'
  []
  [v_mag]
    #initial_condition = ${v_mag}
    block = ${fluid_blocks}
  []

  # Aux variables for heat transfer between bypass and riser
  [T_fluid_external_bypass]
    family = LAGRANGE
    order = FIRST
    #initial_condition = ${T_inlet}
  []
  [htc_external_bypass]
    family = LAGRANGE
    order = FIRST
    #initial_condition = 3.0e3
  []
  [T_fluid_external_riser]
    family = LAGRANGE
    order = FIRST
    #initial_condition = ${T_inlet}
  []
  [htc_external_riser]
    family = LAGRANGE
    order = FIRST
    #initial_condition = 3.0e3
  []

  # Aux variables for RCCS MultiApp transfer
  [TRad]
    #initial_condition =  ${T_inlet}
    block = 'rpv'
  []

[]

# For coupling the solid surfaces across 1-D components
# such as the bypass, riser, and hot plenum
[Constraints]
  [gap_conductance_pbed_bottom]
    type = GapHeatTransferConstraint
    variable = Ts
    h_gap = 1e5 #Arbitrarily large to mimic actual conduction in htr-pm
    primary = 'core_outlet'
    secondary = 'hot_plenum_wall_bottom'
    primary_variable = Ts
    RZ_multiplier_1 = 1.0
    RZ_multiplier_2 = 1.0
  []
[]

# Set up the MultiApp system
# Here we use 'TransientMultiApp' because we run the
# model in transient until it reaches steady-state
[MultiApps]
  [primary_loop]
    type = TransientMultiApp
    input_files = 'plofc-primary-loop-transient.i'
    catch_up = true
    execute_on = 'TIMESTEP_END'
  []

  [rccs]
    type = TransientMultiApp
    execute_on = timestep_end
    app_type = SamApp
    input_files = 'plofc-rccs-water-transient.i'
    catch_up = true
  []
[]

[Executioner]
  type = Transient
  dtmin = 1e-6
  dtmax = 3600

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
  l_tol      = 1e-4
  l_max_its  = 100

  start_time = 0
  end_time = 500000

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
