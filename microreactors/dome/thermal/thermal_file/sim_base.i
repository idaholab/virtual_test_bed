# Solves heat conduction in the DOME shield.
#
# - A uniform heat source is applied within the full core volume.
# - The water tank has an inlet and outlet which are not modeled explicitly.
#   Instead, a uniform heat source is used:
#     Q''' = m_dot*cp*(T_in - T_out)/V_water
#
# Conventions:
#   nwc: normal-weight concrete
#   hwc: heavy-weight concrete

T_external_air = 293
T_ground = 293
core_power = 1e5

htc_external_air = 10.0
htc_ground = 100.0

mass_flow_rate = 1.0
T_water_in = 280

emissivity_core = 0.52
emissivity_tankwall = 0.76

n_patches_core_outer = 1000
n_patches_inner_surface = 1000

hwc_blocks = 'door_1 floor_1 floor_2 wall_1 wall_2 wall_3 ceiling_2 ceiling_3 ceiling_4 ceiling_5'
concrete_blocks = '${nwc_blocks} ${hwc_blocks}'
water_blocks = 'water_tank'
nonwater_blocks = '${graphite_blocks} ${concrete_blocks} ${al_blocks} ${air_blocks}'
heat_conduction_blocks = '${water_blocks} ${nonwater_blocks}'

external_air_boundary = 'system_xmin system_xmax system_ymin system_ymax system_zmax'
ground_boundary = 'system_zmin'

!include ../thermal_properties.i

[Mesh]
  [file_mesh_mg]
    type = FileMeshGenerator
    file = ${mesh_file}
  []
  # It is necessary to make the water block ID to be lower than the other block IDs because
  # when block-restricted ICs overlap at the interface nodes (and thus make the IC for
  # a node ambiguous), the lower block ID wins.
  [renumber_water_block_mg]
    type = RenameBlockGenerator
    input = file_mesh_mg
    old_block = 'water_tank'
    new_block = '100'
  []
[]

[Functions]
  [core_heat_source_fn]
    type = ParsedFunction
    expression = '${core_power} / V'
    symbol_names = 'V'
    symbol_values = 'V_core_heated'
  []
[]

[Variables]
  [T]
  []
[]

[ICs]
  [ic_water]
    type = ConstantIC
    variable = T
    block = ${water_blocks}
    value = ${T_water_in}
  []
  [ic_nonwater]
    type = ConstantIC
    variable = T
    block = ${nonwater_blocks}
    value = ${T_external_air}
  []
[]

[FunctorMaterials]
  [water_heat_source_fmat]
    type = ADParsedFunctorMaterial
    property_name = water_heat_source
    expression = 'm_dot * cp * (T_in - T) / V'
    functor_symbols = 'm_dot cp T_in T V'
    functor_names = '${mass_flow_rate} ${water_cp} ${T_water_in} T V_water'
  []
[]

[Kernels]
  [diff]
    type = ADHeatConduction
    block = ${heat_conduction_blocks} # exclude air blocks; gap/radiation heat transfer used there
    variable = T
    thermal_conductivity = thermal_conductivity
  []
  [core_heat_source]
    type = HeatSource
    block = ${core_heated_blocks}
    variable = T
    function = core_heat_source_fn
  []
  [water_heat_source]
    type = FunctorKernel
    block = ${water_blocks}
    variable = T
    functor = water_heat_source
    functor_on_rhs = true
  []
[]

[BCs]
  [external_air_bc]
    type = ConvectiveFluxFunction
    boundary = ${external_air_boundary}
    variable = T
    coefficient = ${htc_external_air}
    T_infinity = ${T_external_air}
  []
  [ground_bc]
    type = ConvectiveFluxFunction
    boundary = ${ground_boundary}
    variable = T
    coefficient = ${htc_ground}
    T_infinity = ${T_ground}
  []
[]

[GrayDiffuseRadiation]
  [rad]
    boundary = 'inner_surface core_outer'
    emissivity = '${emissivity_tankwall} ${emissivity_core}'
    n_patches = '${n_patches_inner_surface} ${n_patches_core_outer}'
    temperature = T
    view_factor_calculator = ray_tracing
    # There appear to be issues in view factor calculations; for the Cartesian mesh,
    # we get the following after normalization:
    #
    #        i=108    i=109
    # j=108: 0.706589 1.00008
    # j=109: 0.293411 -7.50321e-05
    #
    # Before normalization:
    #
    #        i=108    i=109
    # j=108: 0.706333 1
    # j=109: 0.293667 0
    #
    # Therefore for now, we disable normalization to keep 0 <= Fij <= 1.
    normalize_view_factor = false

    # For the mesh containing tetrahedra, we get a warning due to having non-planar surfaces in the mesh.
    # This appears to be because QUAD4 elements can have non-affine mapping. This
    # occurs inside of the core mesh due to circular mesh; it's not known why
    # this should be relevant since these these elements are not on the radiation
    # surfaces. This likely means the check needs to be more specific/relaxed.

    # cannot use GRID with tetrahedral elements
    ray_tracing_face_type = GAUSS
  []
[]


[VectorPostprocessors]
  [view_factor_vpp]
    type = ViewFactorVectorPostprocessor
    surface_radiation_object_name = view_factor_surface_radiation_rad
    # This causes segfault; should raise issue and fix
    # execute_on = 'INITIAL'
  []
[]

[Postprocessors]
  # Core heat generation rate
  [Q_core]
    type = FunctionElementIntegral
    block = ${core_heated_blocks}
    function = core_heat_source_fn
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Heat source rate to water, typically negative
  [Q_water]
    type = ADElementIntegralFunctorPostprocessor
    block = ${water_blocks}
    functor = water_heat_source
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Heat lost to ambient air from external shield surfaces
  [Q_air]
    type = ADConvectiveHeatTransferSideIntegral
    boundary = ${external_air_boundary}
    T_solid = T
    T_fluid = ${T_external_air}
    htc = ${htc_external_air}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Heat lost to ground from bottom external shield surface
  [Q_ground]
    type = ADConvectiveHeatTransferSideIntegral
    boundary = ${ground_boundary}
    T_solid = T
    T_fluid = ${T_ground}
    htc = ${htc_ground}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Total heat loss rate
  [Q_loss_total]
    type = ParsedPostprocessor
    pp_names = 'Q_air Q_ground Q_water'
    expression = 'Q_air + Q_ground - Q_water'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  # heated core volume
  [V_core_heated]
    type = VolumePostprocessor
    block = ${core_heated_blocks}
    execute_on = 'INITIAL'
    execution_order_group = -1 # To execute before 'Q_core'
  []
  # water volume
  [V_water]
    type = VolumePostprocessor
    block = ${water_blocks}
    execute_on = 'INITIAL'
    execution_order_group = -1 # To execute before 'Q_water'
  []

  # Max concrete temperature
  [Tmax_concrete]
    type = NodalExtremeValue
    block = ${concrete_blocks}
    variable = T
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Average concrete temperature
  [Tavg_concrete]
    type = ElementAverageValue
    variable = T
    block = ${concrete_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # average water temperature; water outlet temperature
  [T_water_out]
    type = AverageNodalVariableValue
    block = ${water_blocks}
    variable = T
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Average temperature along the shield external boundary in contact with DOME air
  [Tavg_shield_outer_air]
    type = SideAverageValue
    variable = T
    boundary = ${external_air_boundary}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # Average temperature along the shield ground boundary
  [Tavg_shield_outer_ground]
    type = SideAverageValue
    variable = T
    boundary = ${ground_boundary}
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Outputs]
  exodus = true
  checkpoint = true
  [csv]
    type = CSV
    execute_vector_postprocessors_on = 'NONE'
  []
  xml = true
[]
