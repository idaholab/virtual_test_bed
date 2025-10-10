# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 21, 2021 12:05 PM
# Author(s): Dr. Paolo Balestra & Dr. Ryan Stewart
# ==============================================================================
# - xe100: reference plant design based on 200MW XE100 Open Source Plant.
# - pke_temp_ramp: Recreate the temperature transient based on the PKE parameters
#                  using initial conditions and reactivity coefficients
# ==============================================================================
# - The Model has been built based on [1].
# ------------------------------------------------------------------------------
# [1] Reference
# ==============================================================================

# ==============================================================================
# Point Kinetics Equations
# ==============================================================================

[PKE]
  n_delayed_groups = 6
  DNP_variable = precursor
  DN_fraction_aux = betas
  DNP_decay_constant_aux = lambdas
  mean_generation_time_aux = Lambda
  reactivity_aux = rho
  verbose = 1
  amplitude_variable = n
  pke_parameter_csv = 'iqs_pke_params.csv'
[]

# ==============================================================================
# INITIAL CONDITIONS
# ==============================================================================

[ICs]
  [ic_n]
    type = ScalarComponentIC
    variable = n
    values = 1
  []
[]

# ==============================================================================
# FUNCTIONS
# ==============================================================================

[Functions]
  [rho_time]
    type = SlopeFunction
    timep = '0  1  4                 10'
    value = '0  0  4.43177878883e-5  4.43177878883e-5'
  []
[]

# ==============================================================================
# AUXKERNELS
# ==============================================================================

[AuxScalarKernels]
  [temp_ramp]
    type = FunctionScalarAux
    variable = rho
    function = rho_time
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================

[Executioner]
  type = Transient

  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 50'

  # Problem time parameters.
  start_time = 0.0
  dt = 0.5
  end_time = 10.0
  reset_dt = true

  # Linear/nonlinear iterations.
  l_max_its = 50
  l_tol = 1e-3

  nl_max_its = 50
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8
[]

# ==============================================================================
# OUTPUTS
# ==============================================================================

[Outputs]
  file_base = pke_fuel_auto
  print_linear_residuals = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  csv = true
[]

