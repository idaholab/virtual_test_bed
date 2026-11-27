# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Welding stage objects: torch path, heat source, weld-pass activation, BCs, postprocessors.

[Postprocessors]
  [total_heat]
    type = ADElementIntegralMaterialProperty
    mat_prop = 'volumetric_heat'
  []
  [xzfix_bot_disp_x]
    type = PointValue
    variable = disp_x
    point = '-75 450 0'
  []
  [xzfix_bot_disp_z]
    type = PointValue
    variable = disp_z
    point = '-75 450 0'
  []
  [zfix_bot_disp_z]
    type = PointValue
    variable = disp_z
    point = '75 450 0'
  []
[]

# Torch path: piecewise-linear interpolation of the (t, x, y, z) vertices in path_txyz.csv
# (1930 vertices). The heat source is oriented along the current path segment.
[SpatioTemporalPaths]
  [path]
    type = SpatioTemporalPath
    file = 'path_txyz.csv'
  []
[]

[Materials]
  # R5 gives no welding procedure details, so the heat input was calibrated so that the peak
  # temperature of each pass is close to the melting point of 316H (Barua and Messner 2024, Sec. 6.3).
  # volumetric_heat [W/mm^3] = 2*efficiency*Pfraction*scale/(pi*a*b) * exp(-2*dt^2/a^2 - 2*dn^2/b^2)
  # with a, b, dt, dn in mm: scale (= base_power) is a heat input per unit length [W/mm], not the
  # torch power in W. total_heat is the volume integral of volumetric_heat over the active blocks:
  # the instantaneous applied heat rate [W], not the cumulative energy.
  [ellipsoidal_heat_source]
    type = ADMovingEllipsoidalHeatSource
    spatiotemporal_path = path
    power = Pfraction
    efficiency = 0.8
    scale = ${base_power}
    a = ${elip_a}
    b = ${elip_b}
  []
  [Pfraction]
    type = ADParsedMaterial
    property_name = 'Pfraction'
    expression = 'if(time-td<=0,0,if(time-td<=1200,f1,if(time-td<=2400,f2,if(time-td<=3600,f3,if(time-td<=4800,f4,if(time-td<=6000,f5,if(time-td<=7200,f6,if(time-td<=8400,f7,if(time-td<=9600,f8,0)))))))))'
    constant_names = 'td f1 f2 f3 f4 f5 f6 f7 f8'
    constant_expressions = '${delay_time} 1 0.8 0.66 0.71 0.64 0.71 0.58 0.67'
    coupled_variables = 'time'
  []
[]

# Patch recovery of T and displacements, used by the mesh modifier below to initialize the
# newly activated weld elements (reinitialization_strategy = POLYNOMIAL_NEIGHBOR).
[UserObjects]
  [extrapolation_patch_T]
    type = NodalPatchRecoveryVariable
    patch_polynomial_order = FIRST
    variable = 'T'
    block = ${base_blocks}
    execute_on = 'TIMESTEP_BEGIN'
  []
  [extrapolation_patch_disp_x]
    type = NodalPatchRecoveryVariable
    patch_polynomial_order = FIRST
    variable = 'disp_x'
    block = ${base_blocks}
    execute_on = 'TIMESTEP_BEGIN'
  []
  [extrapolation_patch_disp_y]
    type = NodalPatchRecoveryVariable
    patch_polynomial_order = FIRST
    variable = 'disp_y'
    block = ${base_blocks}
    execute_on = 'TIMESTEP_BEGIN'
  []
  [extrapolation_patch_disp_z]
    type = NodalPatchRecoveryVariable
    patch_polynomial_order = FIRST
    variable = 'disp_z'
    block = ${base_blocks}
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

[MeshModifiers]
  [weld]
    type = CoupledVarThresholdElementSubdomainModifier
    coupled_var = 'weld'
    criterion_type = ABOVE
    threshold = 0.999999
    subdomain_id = ${subdomain_block_id}
    block = ${weld_blocks}
    execute_on = 'TIMESTEP_BEGIN'
    moving_boundaries = 'moving_moving'
    moving_boundary_subdomain_pairs = moving

    # initial values of the newly activated elements, fitted from the active neighbors
    old_subdomain_reinitialized = false
    reinitialize_subdomains = ${base_blocks}

    reinitialization_strategy = "POLYNOMIAL_NEIGHBOR"
    reinitialize_variables = 'disp_x disp_y disp_z T'

    polynomial_fitters = 'extrapolation_patch_disp_x extrapolation_patch_disp_y extrapolation_patch_disp_z extrapolation_patch_T'
  []
[]

[Kernels]
  [hsource]
    type = ADMatHeatSource
    material_property = 'volumetric_heat'
    variable = T
    block = ${base_blocks}
  []
[]

[BCs]
  [xfix_top_clamp]
    type = DirichletBC
    variable = disp_x
    value = 0
    boundary = 'xyzfix_top_clamp'
  []
  [yfix_top_clamp]
    type = DirichletBC
    variable = disp_y
    value = 0
    boundary = 'xyzfix_top_clamp'
  []
  [zfix_top_clamp]
    type = DirichletBC
    variable = disp_z
    value = 0
    boundary = 'xyzfix_top_clamp'
  []
  [xfix_bot_clamp]
    type = ADDirichletBC
    variable = disp_x
    value = 0
    boundary = 'xzfix_bot_clamp'
  []
  [zfix_bot_clamp]
    type = ADDirichletBC
    variable = disp_z
    value = 0
    boundary = 'xzfix_bot_clamp'
  []
  [yfix_bot]
    type = ADDirichletBC
    variable = disp_y
    value = 0
    boundary = 'yfix_bot'
  []
  [rad]
    type = ADMatNeumannBC
    variable = T
    value = -1
    boundary_material = rad
    boundary = 'od_base id_base moving'
  []
  [conv]
    type = ADConvectiveHeatFluxBC
    variable = T
    boundary = 'od_base id_base moving'
    T_infinity = ${T0}
    heat_transfer_coefficient = ${heat_transfer_coefficient}
  []
[]

[AuxKernels]
  # Nodal reaction forces (unscaled displacement residuals) at the end of each time step. They are
  # restored from the final welding checkpoint and released gradually in the cooldown stage.
  [rx]
    type = TagVectorAux
    variable = rx
    v = disp_x
    vector_tag = reaction
    remove_variable_scaling = true
  []
  [ry]
    type = TagVectorAux
    variable = ry
    v = disp_y
    vector_tag = reaction
    remove_variable_scaling = true
  []
  [rz]
    type = TagVectorAux
    variable = rz
    v = disp_z
    vector_tag = reaction
    remove_variable_scaling = true
  []
  [phi]
    type = ParsedAux
    variable = phi
    block = '${base_blocks} ${weld_blocks}'
    expression = 'atan(z/x)+${pi}'
    use_xyzt = true
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld1]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 1
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-1'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld2]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 2
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-2'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld3]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 3
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-3'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld4]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 4
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-4'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld5]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 5
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-5'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld6]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 6
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-6'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld7]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 7
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-7'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [weld8]
    type = ParsedAux
    variable = weld
    expression = "phic:=if(t<${pass_weld_time}*(n-1),0,if(t<${pass_weld_time}*n,(t-${pass_weld_time}*(n-1))/${pass_weld_time},1))*2*${pi};
                  if(phi<=phic,1,0)"
    constant_names = n
    constant_expressions = 8
    coupled_variables = 'phi'
    use_xyzt = true
    block = 'weldpass-8'
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [tbegin]
    type = ParsedAux
    variable = tbegin
    expression = 't'
    use_xyzt = true
    block = ${weld_blocks}
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
  [a]
    type = ParsedAux
    variable = a
    expression = "DT:=if(t>tbegin,t-tbegin,0);
                  if(DT<${elm_weld_time}/2,4/${elm_weld_time}*DT,if(DT<${elm_weld_time},4-4/${elm_weld_time}*DT,0))"
    coupled_variables = 'tbegin'
    use_xyzt = true
    block = ${base_blocks}
    execute_on = 'INITIAL LINEAR TIMESTEP_BEGIN'
  []
[]
