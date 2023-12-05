################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Thermochimica Main Application input file                                  ##
## Steady state spatially-resolved thermochemistry model                      ##
## Depletion history and it's effects on thermochemistry included             ##
## Model developed by Samuel Walker                                           ##
## Thermochimica wrapped into MOOOSE by Parikshit Bajpai and Daniel Schwen    ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

###########################################
# SETTING UP PROBLEM - MESH, GLOBAL PARAMS, CHEMICAL COMPOSITION
###########################################

[Mesh]
  coord_type = 'RZ'
  [restart]
    type = FileMeshGenerator
    use_for_exodus_restart = true
    file = '../steady/restart/run_ns_coupled_restart.e'
  []
  [extraction]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y>1.3'
    new_sideset_name = 'extraction'
    included_boundaries = 'reflector_wall'
    replace = true
    input = 'restart'
  []
[]

[GlobalParams]
  elements = 'F Li U Th Ni Nd Ce La Cs Xe I Kr Ne'
  output_phases = 'MSFL gas_ideal Ni_Solid_FCC(s) U_Solid-A(s)'
  #output_phases = 'ALL'
  output_species = 'MSFL:UF3 MSFL:U3+//I MSFL:U2F8 MSFL:U2//I MSFL:U[VII]//F MSFL:U[VII]//I MSFL:U[VI]//F MSFL:U[VI]//I  MSFL:NiF2 MSFL:Ni//I gas_ideal:CsI gas_ideal:CsF gas_ideal:I gas_ideal:I2 gas_ideal:I2Ni gas_ideal:ILi gas_ideal:Xe gas_ideal:Kr gas_ideal:Ne'
  #output_species = 'ALL'
  output_element_potentials = 'ALL'
  output_vapor_pressures = 'vp:gas_ideal:CsI vp:gas_ideal:CsF vp:gas_ideal:I vp:gas_ideal:I2 vp:gas_ideal:I2Ni vp:gas_ideal:ILi'
  #output_vapor_pressures = 'ALL'
[]

[ChemicalComposition]
  thermofile = MSTDTC_Noble_metal_gases.dat
  tunit = K
  punit = Pa
  munit = moles
  temperature = tfuel_nod
  pressure = pressure_nod
  reinitialization_type = nodal
[]

###########################################
# AUX VARIABLES, KERNELS, and ICs
###########################################

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    #initial_condition = 936.00
    initial_from_file_var = T_fluid
  []
  [tfuel_nod]
    order = FIRST
    family = Lagrange
  []
  [pressure]
    order = CONSTANT
    family = MONOMIAL
    #initial_condition = 1.3042
    initial_from_file_var = pressure
  []
  [pressure_nod]
    order = FIRST
    family = Lagrange
  []
[]

[AuxKernels]
  [ProjAuxT]
    type = ProjectionAux
    v = tfuel
    variable = tfuel_nod
    execute_on = INITIAL
  []
  [ProjAuxP]
    type = ProjectionAux
    v = pressure
    variable = pressure_nod
    execute_on = INITIAL
  []
[]

[ICs]
  [F]
    type = FunctionIC
    variable = F
    function = FSumSet
  []
  [Li]
    type = FunctionIC
    variable = Li
    function = LiSumSet
  []
  [U]
    type = FunctionIC
    variable = U
    function = USumSet
  []
  [Th]
    type = FunctionIC
    variable = Th
    function = ThSumSet
  []
  [Ni]
    type = ConstantIC
    variable = Ni
    #value = 7.1e-03
    value = 1
  []
  [Xe]
    type = FunctionIC
    variable = Xe
    function = XeSumSet
  []
  [Nd]
    type = FunctionIC
    variable = Nd
    function = NdSumSet
  []
  [Ce]
    type = FunctionIC
    variable = Ce
    function = CeSumSet
  []
  [La]
    type = FunctionIC
    variable = La
    function = LaSumSet
  []
  [Cs]
    type = FunctionIC
    variable = Cs
    function = CsSumSet
  []
  [I]
    type = FunctionIC
    variable = I
    function = ISumSet
  []
  [Kr]
    type = FunctionIC
    variable = Kr
    function = KrSumSet
  []
  [Ne]
    type = FunctionIC
    variable = Ne
    function = NeSumSet
  []
[]

###########################################
# PROBLEM, EXECUTIONER, and OUTPUTS
###########################################

[Problem]
  solve = false
  allow_initial_conditions_with_restart = true
[]

[Executioner]
  #type = Transient
  type = Steady
[]

[Outputs]
  csv = true
  exodus = true
[]

###########################################
# POSTPROCESSING
###########################################

[Postprocessors]
  [total_ideal_gas]
    type = NodalSum
    variable = gas_ideal
    block = 'fuel pump hx'
  []
  [total_F]
    type = NodalSum
    variable = F
    block = 'fuel pump hx'
  []
  [total_Li]
    type = NodalSum
    variable = Li
    block = 'fuel pump hx'
  []
  [total_U]
    type = NodalSum
    variable = U
    block = 'fuel pump hx'
  []
  [total_Th]
    type = NodalSum
    variable = Th
    block = 'fuel pump hx'
  []
  [total_Nd]
    type = NodalSum
    variable = Nd
    block = 'fuel pump hx'
  []
  [total_Ce]
    type = NodalSum
    variable = Ce
    block = 'fuel pump hx'
  []
  [total_La]
    type = NodalSum
    variable = La
    block = 'fuel pump hx'
  []
  [total_Cs]
    type = NodalSum
    variable = Cs
    block = 'fuel pump hx'
  []
  [total_I]
    type = NodalSum
    variable = I
    block = 'fuel pump hx'
  []
  [total_Kr]
    type = NodalSum
    variable = Kr
    block = 'fuel pump hx'
  []
  [total_Ne]
    type = NodalSum
    variable = Ne
    block = 'fuel pump hx'
  []
  [total_I_gas]
    type = NodalSum
    variable = gas_ideal:I
    block = 'fuel pump hx'
  []
  [total_I2]
    type = NodalSum
    variable = gas_ideal:I2
    block = 'fuel pump hx'
  []
  [total_I2Ni]
    type = NodalSum
    variable = gas_ideal:I2Ni
    block = 'fuel pump hx'
  []
  [total_ILi]
    type = NodalSum
    variable = gas_ideal:ILi
    block = 'fuel pump hx'
  []
  [total_CsI]
    type = NodalSum
    variable = gas_ideal:CsI
    block = 'fuel pump hx'
  []
  [total_CsF]
    type = NodalSum
    variable = gas_ideal:CsF
    block = 'fuel pump hx'
  []
  [total_UF3]
    type = NodalSum
    variable = MSFL:UF3
    block = 'fuel pump hx'
  []
  [total_U3I]
    type = NodalSum
    variable = MSFL:U3+//I
    block = 'fuel pump hx'
  []
  [total_U2F8]
    type = NodalSum
    variable = MSFL:U2F8
    block = 'fuel pump hx'
  []
  [total_U2I]
    type = NodalSum
    variable = MSFL:U2//I
    block = 'fuel pump hx'
  []
  [total_UVIIF]
    type = NodalSum
    variable = 'MSFL:U[VII]//F'
    block = 'fuel pump hx'
  []
  [total_UVIII]
    type = NodalSum
    variable = 'MSFL:U[VII]//I'
    block = 'fuel pump hx'
  []
  [total_UVIF]
    type = NodalSum
    variable = 'MSFL:U[VI]//F'
    block = 'fuel pump hx'
  []
  [total_UVII]
    type = NodalSum
    variable = 'MSFL:U[VI]//I'
    block = 'fuel pump hx'
  []

###########################################
# POSTPROCESSING DEPLETION STEPS
###########################################
  #Initializing From Depletion
  #U
  [U230]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U230
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U231]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U230
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U232]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U232
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U233]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U233
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U234]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U234
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U235]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U235
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U235M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U235M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [U236]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = U236
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Th
  [Th226]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH226
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th227]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH227
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th228]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH228
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th229]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH229
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th230]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH230
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th231]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH231
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th232]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH232
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th233]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH233
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Th234]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = TH234
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Nd
  #Nd
  [Nd140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd146]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND146
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd147]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND147
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd148]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND148
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd149]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND149
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd150]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND150
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd151]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND151
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd152]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND152
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd153]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND153
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd154]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND154
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd155]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND155
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd156]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND156
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd157]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND157
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd158]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND158
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd159]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND159
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd160]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND160
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Nd161]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = ND161
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Ce
  [Ce137]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE137
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce138]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE138
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce139]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE139
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce139M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE139M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce146]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE146
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce147]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE147
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce148]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE148
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce149]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE149
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce150]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE150
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce151]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE151
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce152]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE152
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce153]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE153
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce154]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE154
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce155]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE155
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce156]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE156
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Ce157]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CE157
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #La
  [La133]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA133
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La135]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA135
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La137]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA137
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La138]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA138
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La139]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA139
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La146]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA146
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La146M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA146M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La147]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA147
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La148]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA148
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La149]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA149
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La150]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA150
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La151]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA151
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La152]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA152
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La153]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA153
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La154]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA154
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [La155]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LA155
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Cs
  [Cs129]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS129
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs131]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS131
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs132]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS132
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs133]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS133
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs134]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS134
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs134M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS134M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs135]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS135
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs135M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS135M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs136]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS136
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs136M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS136M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs137]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS137
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs138]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS138
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs138M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS138M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs139]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS139
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs146]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS146
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs147]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS147
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs148]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS148
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs149]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS149
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs150]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS150
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Cs151]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = CS151
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #I
  [I121]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I121
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I123]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I123
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I125]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I125
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I126]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I126
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I127]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I127
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I128]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I128
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I129]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I129
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I130]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I130
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I130M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I130M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I131]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I131
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I132]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I132
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I132M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I132M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I133]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I133
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I133M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I133M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I134]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I134
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I134M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I134M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I135]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I135
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I136]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I136
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I137]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I137
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I138]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I138
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I139]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I139
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [I145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = I145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Rb
  [Rb81]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB81
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb83]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB83
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb84]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB84
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb85]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB85
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb86]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB86
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb86M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB86M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb87]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB87
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb88]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB88
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb89]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB89
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb90]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB90
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb91]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB91
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb92]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB92
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb93]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB93
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb94]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB94
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb95]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB95
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb96]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB96
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb97]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB97
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb98]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB98
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb99]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB99
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb100]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB100
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb101]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB101
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Rb102]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = RB102
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Kr
  [Kr78]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR78
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr79]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR79
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr79M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR79M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr80]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR80
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr81]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR81
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr81M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR81M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr82]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR82
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr83]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR83
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr83M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR83M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr84]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR84
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr85]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR85
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr85M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR85M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr86]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR86
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr87]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR87
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr88]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR88
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr89]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR89
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr90]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR90
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr91]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR91
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr92]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR92
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr93]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR93
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr94]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR94
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr95]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR95
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr96]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR96
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr97]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR97
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr98]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR98
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr99]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR99
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Kr100]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = KR100
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Ne
  [Ne20]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = NE20
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #F
  [F19]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = F19
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Li
  [Li6]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LI6
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Li7]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LI7
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Li8]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = LI8
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  #Xe
  [Xe126]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE126
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe128]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE128
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe129]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE129
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe129M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE129M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe130]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE130
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe131]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE131
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe131M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE131M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe132]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE132
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe133]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE133
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe133M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE133M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe134]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE134
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe134M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE134M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe135]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE135
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe135M]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE135M
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe136]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE136
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe137]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE137
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe138]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE138
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe139]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE139
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe140]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE140
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe141]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE141
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe142]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE142
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe143]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE143
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe144]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE144
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe145]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE145
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe146]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE146
    index = 0
    force_preic = True
    execute_on = INITIAL
  []
  [Xe147]
    type = VectorPostprocessorComponent
    vectorpostprocessor = reader
    vector_name = XE147
    index = 0
    force_preic = True
    execute_on = INITIAL
  []

  [TotVolume]
    type = VolumePostprocessor
    block = 'fuel pump hx'
    force_preic = True
    execute_on = INITIAL
  []
  [NumNodes]
    type = NumNodes
    force_preic = True
    execute_on = INITIAL
  []
[]

[Functions]
  [USumSet]
    type = ParsedFunction
    expression = '(U230 + U231 + U232 + U233 + U234 + U235 + U235M + U236)*TotVolume/NumNodes*1.6605e6'
    #expression = '(U232 + U233 + U234 + U235 + U236 + U237 + U238)*TotVolume*1.6605e6'
    symbol_names = 'U230 U231 U232 U233 U234 U235 U235M U236 TotVolume NumNodes'
    symbol_values = 'U230 U231 U232 U233 U234 U235 U235M U236 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [ThSumSet]
    type = ParsedFunction
    expression = '(Th226 + Th227 + Th228 + Th229 + Th230 + Th231 + Th232 + Th233 + Th234)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Th226 Th227 Th228 Th229 Th230 Th231 Th232 Th233 Th234 TotVolume NumNodes'
    symbol_values = 'Th226 Th227 Th228 Th229 Th230 Th231 Th232 Th233 Th234 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [NdSumSet]
    type = ParsedFunction
    expression = '(Nd140 + Nd141 + Nd142 + Nd143 + Nd144 + Nd145 + Nd146 + Nd147 + Nd148 + Nd149 + Nd150 + Nd151 + Nd152 + Nd153 + Nd154 + Nd155 + Nd156 + Nd157 + Nd158 + Nd159 + Nd160 + Nd161)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Nd140 Nd141 Nd142 Nd143 Nd144 Nd145 Nd146 Nd147 Nd148 Nd149 Nd150 Nd151 Nd152 Nd153 Nd154 Nd155 Nd156 Nd157 Nd158 Nd159 Nd160 Nd161 TotVolume NumNodes'
    symbol_values = 'Nd140 Nd141 Nd142 Nd143 Nd144 Nd145 Nd146 Nd147 Nd148 Nd149 Nd150 Nd151 Nd152 Nd153 Nd154 Nd155 Nd156 Nd157 Nd158 Nd159 Nd160 Nd161 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [CeSumSet]
    type = ParsedFunction
    expression = '(Ce137 + Ce138 + Ce139 + Ce139M + Ce140 + Ce141 + Ce142 + Ce143 + Ce144 + Ce145 + Ce146 + Ce147 + Ce148 + Ce149 + Ce150 + Ce151 + Ce152 + Ce153 + Ce154 + Ce155 + Ce156 + Ce157)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Ce137 Ce138 Ce139 Ce139M Ce140 Ce141 Ce142 Ce143 Ce144 Ce145 Ce146 Ce147 Ce148 Ce149 Ce150 Ce151 Ce152 Ce153 Ce154 Ce155 Ce156 Ce157 TotVolume NumNodes'
    symbol_values = 'Ce137 Ce138 Ce139 Ce139M Ce140 Ce141 Ce142 Ce143 Ce144 Ce145 Ce146 Ce147 Ce148 Ce149 Ce150 Ce151 Ce152 Ce153 Ce154 Ce155 Ce156 Ce157 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [LaSumSet]
    type = ParsedFunction
    expression = '(La133 + La135 + La137 + La138 + La139 + La140 + La141 + La142 + La143 + La144 + La145 + La146 + La146M + La147 + La148 + La149 + La150 + La151 + La152 + La153 + La154 + La155)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'La133 La135 La137 La138 La139 La140 La141 La142 La143 La144 La145 La146 La146M La147 La148 La149 La150 La151 La152 La153 La154 La155 TotVolume NumNodes'
    symbol_values = 'La133 La135 La137 La138 La139 La140 La141 La142 La143 La144 La145 La146 La146M La147 La148 La149 La150 La151 La152 La153 La154 La155 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [CsSumSet]
    type = ParsedFunction
    expression = '(Cs129 + Cs131 + Cs132 + Cs133 + Cs134 + Cs134M + Cs135 + Cs135M + Cs136 + Cs136M + Cs137 + Cs138 + Cs139 + Cs140 + Cs141 + Cs142 + Cs143 + Cs144 + Cs145 + Cs146 + Cs147 + Cs148 + Cs149 + Cs150 + Cs151)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Cs129 Cs131 Cs132 Cs133 Cs134 Cs134M Cs135 Cs135M Cs136 Cs136M Cs137 Cs138 Cs139 Cs140 Cs141 Cs142 Cs143 Cs144 Cs145 Cs146 Cs147 Cs148 Cs149 Cs150 Cs151 TotVolume NumNodes'
    symbol_values = 'Cs129 Cs131 Cs132 Cs133 Cs134 Cs134M Cs135 Cs135M Cs136 Cs136M Cs137 Cs138 Cs139 Cs140 Cs141 Cs142 Cs143 Cs144 Cs145 Cs146 Cs147 Cs148 Cs149 Cs150 Cs151 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [ISumSet]
    type = ParsedFunction
    expression = '(I121 + I123 + I125 + I126 + I127 + I128 + I129 + I130 + I130M + I131 + I132 + I132M + I133 + I133M + I134 + I134M + I135 + I136 + I137 + I138 + I139 + I140 + I141 + I142 + I143 + I144 + I145)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'I121 I123 I125 I126 I127 I128 I129 I130 I130M I131 I132 I132M I133 I133M I134 I134M I135 I136 I137 I138 I139 I140 I141 I142 I143 I144 I145 TotVolume NumNodes'
    symbol_values = 'I121 I123 I125 I126 I127 I128 I129 I130 I130M I131 I132 I132M I133 I133M I134 I134M I135 I136 I137 I138 I139 I140 I141 I142 I143 I144 I145 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [RbSumSet]
    type = ParsedFunction
    expression = '(Rb81 + Rb83 + Rb84 + Rb85 + Rb86 + Rb86M + Rb87 + Rb88 + Rb89 + Rb90 + Rb91 + Rb92 + Rb93 + Rb94 + Rb95 + Rb96 + Rb97 + Rb98 + Rb99 + Rb100 + Rb101 + Rb102)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Rb81 Rb83 Rb84 Rb85 Rb86 Rb86M Rb87 Rb88 Rb89 Rb90 Rb91 Rb92 Rb93 Rb94 Rb95 Rb96 Rb97 Rb98 Rb99 Rb100 Rb101 Rb102 TotVolume NumNodes'
    symbol_values = 'Rb81 Rb83 Rb84 Rb85 Rb86 Rb86M Rb87 Rb88 Rb89 Rb90 Rb91 Rb92 Rb93 Rb94 Rb95 Rb96 Rb97 Rb98 Rb99 Rb100 Rb101 Rb102 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [KrSumSet]
    type = ParsedFunction
    expression = '(Kr78 + Kr79 + Kr79M + Kr80 + Kr81 + Kr81M + Kr82 + Kr83 + Kr83M + Kr84 + Kr85 + Kr85M + Kr86 + Kr87 + Kr88 + Kr89 + Kr90 + Kr91 + Kr92 + Kr93 + Kr94 + Kr95 + Kr96 + Kr97 + Kr98 + Kr99 + Kr100)*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Kr78 Kr79 Kr79M Kr80 Kr81 Kr81M Kr82 Kr83 Kr83M Kr84 Kr85 Kr85M Kr86 Kr87 Kr88 Kr89 Kr90 Kr91 Kr92 Kr93 Kr94 Kr95 Kr96 Kr97 Kr98 Kr99 Kr100 TotVolume NumNodes'
    symbol_values = 'Kr78 Kr79 Kr79M Kr80 Kr81 Kr81M Kr82 Kr83 Kr83M Kr84 Kr85 Kr85M Kr86 Kr87 Kr88 Kr89 Kr90 Kr91 Kr92 Kr93 Kr94 Kr95 Kr96 Kr97 Kr98 Kr99 Kr100 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [NeSumSet]
    type = ParsedFunction
    expression = 'Ne20*TotVolume/NumNodes*1.6605e6'
    symbol_names = 'Ne20 TotVolume NumNodes'
    symbol_values = 'Ne20 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [FSumSet]
    type = ParsedFunction
    expression = 'F19*TotVolume/NumNodes*1.6605e6'
    #expression = 'F19*TotVolume/NumNodes*1.6605e6*1.0001'
    symbol_names = 'F19 TotVolume NumNodes'
    symbol_values = 'F19 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [LiSumSet]
    type = ParsedFunction
    #expression = '(Li6 + Li7 + Li8)*TotVolume/NumNodes*1.6605e6'
    expression = '(Li6 + Li7 + Li8)*TotVolume/NumNodes*1.6605e6*1.0008'
    symbol_names = 'Li6 Li7 Li8 TotVolume NumNodes'
    symbol_values = 'Li6 Li7 Li8 TotVolume NumNodes'
    execute_on = INITIAL
  []
  [XeSumSet]
    type = ParsedFunction
    expression = '(Xe126 + Xe128 + Xe129 + Xe129M + Xe130 + Xe131 + Xe131M + Xe132 + Xe133 + Xe133M + Xe134 + Xe134M +  Xe135 + Xe135M + Xe136 + Xe137 + Xe138 + Xe139 + Xe140 + Xe141 + Xe142 + Xe143 + Xe144 + Xe145 + Xe146 + Xe147)*TotVolume/NumNodes*1.6605e6*10'
    symbol_names = 'Xe126 Xe128 Xe129 Xe129M Xe130 Xe131 Xe131M Xe132 Xe133 Xe133M Xe134 Xe134M Xe135 Xe135M Xe136 Xe137 Xe138 Xe139 Xe140 Xe141 Xe142 Xe143 Xe144 Xe145 Xe146 Xe147 TotVolume NumNodes'
    symbol_values = 'Xe126 Xe128 Xe129 Xe129M Xe130 Xe131 Xe131M Xe132 Xe133 Xe133M Xe134 Xe134M Xe135 Xe135M Xe136 Xe137 Xe138 Xe139 Xe140 Xe141 Xe142 Xe143 Xe144 Xe145 Xe146 Xe147 TotVolume NumNodes'
    execute_on = INITIAL
  []

[]

[VectorPostprocessors]
  [reader]
    type = CSVReader
    csv_file = run_dep_out_in-core_number_densities.csv
    force_preic = True
  []
[]
