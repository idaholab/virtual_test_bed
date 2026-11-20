# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Cooldown stage objects: clamp release, welding-end displacement BCs, thermal BCs.

[Functions]
  [release]
    type = PiecewiseLinear
    x = '${total_weld_time} ${fparse total_weld_time+load_release_time}'
    y = '1 0'
  []
  # Welding -> cooldown displacement transfer (MOOSE-native, no hard-coded values).
  # Each function is the welding history of one bottom-node displacement, read from the welding CSV.
  # PiecewiseLinear does not extrapolate by default, so for every cooldown time t >= t_restart
  # (= last welding output time = time of the final welding checkpoint) it returns the
  # displacement at the end of welding.
  [xzfix_bot_disp_x_weld_end]
    type = PiecewiseLinear
    data_file = ${weld_csv}
    format = columns
    x_title = time
    y_title = xzfix_bot_disp_x
  []
  [xzfix_bot_disp_z_weld_end]
    type = PiecewiseLinear
    data_file = ${weld_csv}
    format = columns
    x_title = time
    y_title = xzfix_bot_disp_z
  []
  [zfix_bot_disp_z_weld_end]
    type = PiecewiseLinear
    data_file = ${weld_csv}
    format = columns
    x_title = time
    y_title = zfix_bot_disp_z
  []
[]

# [BlackBear port] The original used FunctionCoupledNodalForce, a custom NodalKernel that only
# existed (untracked) in the MALAMUTE MOOSE tree:  residual = -coef * v * release(t), Jacobian = 0.
# BlackBear has no such object, so the same residual is built from standard MOOSE objects:
#   r*_released = r* * release(t)   (ParsedAux, evaluated at the new time at TIMESTEP_BEGIN)
#   CoupledForceNodalKernel:  residual = -coef * r*_released, Jacobian = 0 (v is an aux variable)
# r* (rx, ry, rz) are the weld-end nodal reactions restored from the checkpoint; they are not
# updated during cooldown (disp_save_in = ''), exactly as before.
# The r*_released aux variables are new relative to the checkpoint; MOOSE restart supports this.
[AuxVariables]
  [rx_released]
    block = ${base_blocks}
  []
  [ry_released]
    block = ${base_blocks}
  []
  [rz_released]
    block = ${base_blocks}
  []
[]

[AuxKernels]
  [rx_released]
    type = ParsedAux
    variable = rx_released
    coupled_variables = 'rx'
    functor_names = 'release'
    expression = 'rx * release'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [ry_released]
    type = ParsedAux
    variable = ry_released
    coupled_variables = 'ry'
    functor_names = 'release'
    expression = 'ry * release'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [rz_released]
    type = ParsedAux
    variable = rz_released
    coupled_variables = 'rz'
    functor_names = 'release'
    expression = 'rz * release'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

[NodalKernels]
  [xfix_top_clamp]
    type = CoupledForceNodalKernel
    variable = disp_x
    coef = 1
    v = 'rx_released'
    boundary = 'xyzfix_top_clamp'
  []
  [yfix_top_clamp]
    type = CoupledForceNodalKernel
    variable = disp_y
    coef = 1
    v = 'ry_released'
    boundary = 'xyzfix_top_clamp'
  []
  [zfix_top_clamp]
    type = CoupledForceNodalKernel
    variable = disp_z
    coef = 1
    v = 'rz_released'
    boundary = 'xyzfix_top_clamp'
  []
  [xfix_bot_clamp]
    type = CoupledForceNodalKernel
    variable = disp_x
    coef = 1
    v = 'rx_released'
    boundary = 'xzfix_bot_clamp'
  []
  [zfix_bot_clamp]
    type = CoupledForceNodalKernel
    variable = disp_z
    coef = 1
    v = 'rz_released'
    boundary = 'xzfix_bot_clamp'
  []
[]

[BCs]
  # Bottom-node displacements held at their welding-end values (functions above). AD variant of
  # FunctionDirichletBC, consistent with the AD formulation of the model.
  [xzfix_bot_disp_x]
    type = ADFunctionDirichletBC
    variable = disp_x
    function = xzfix_bot_disp_x_weld_end
    boundary = 'xzfix_bot'
  []
  [xzfix_bot_disp_z]
    type = ADFunctionDirichletBC
    variable = disp_z
    function = xzfix_bot_disp_z_weld_end
    boundary = 'xzfix_bot'
  []
  [yfix_bot]
    type = ADDirichletBC
    variable = disp_y
    value = 0
    boundary = 'yfix_bot'
  []
  [zfix_bot_disp_z]
    type = ADFunctionDirichletBC
    variable = disp_z
    function = zfix_bot_disp_z_weld_end
    boundary = 'zfix_bot'
  []
  [rad]
    type = ADMatNeumannBC
    variable = T
    value = -1
    boundary_material = rad
    boundary = 'od_base id_base'
  []
  [conv]
    type = ADConvectiveHeatFluxBC
    variable = T
    boundary = 'od_base id_base'
    T_infinity = ${T0}
    heat_transfer_coefficient = ${heat_transfer_coefficient}
  []
[]
