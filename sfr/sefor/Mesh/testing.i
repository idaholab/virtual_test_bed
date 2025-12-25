[Problem]
  solve = false
[]

[Executioner]
  type = Steady
[]

[AuxVariables]
  [volume]
    family = MONOMIAL
    order = CONSTANT
    [AuxKernel]
      type = VolumeAux
      execute_on = initial
    []
  []
[]

[MeshDivisions]
  [block_div]
    type = SubdomainsDivision
  []
[]

[VectorPostprocessors]
  [integral]
    type = MeshDivisionFunctorReductionVectorPostprocessor
    functors = 'volume'
    mesh_division = block_div
    reduction = 'integral'
    execute_on = 'TIMESTEP_END'
  []
[]

[Outputs]
  csv = true
  # to have a mesh to load in other tests
  [exo]
    type = Exodus
    execute_on = INITIAL
  []
[]
