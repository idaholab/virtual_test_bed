################################################################################
## NEAMS Fast Reactor Application Driver                                      ##
## SEFOR 3D Model of SEFOR Core I-E at 450 K                                  ##
## Input File for Griffin Steady State                                        ##
## Please contact the authors for issues:                                     ##
## - Dr. Donny Hartanto (hartantod.at.ornl.gov)                               ##
################################################################################
[Mesh]
  parallel_type = distributed
  [loader]
    type = FileMeshGenerator
    file ='Core-I-E_3D_450K_mesh_split_with_cmfd.cpa.gz'
  []
[]

[GlobalParams]
  library_file   = '../xml/Core-I-E_450K_ENDF71.33gV2.xml'
  library_name   = ISOTXS-neutron
  plus           = true
  dbgmat         = false
  grid_names     = 'Tfuel'
  grid_variables = 'Tfuel'
  is_meter       = 'false'
[]

[AuxVariables]
  [Tfuel]
    initial_condition = 450
    order = CONSTANT
    family = MONOMIAL
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 33
  VacuumBoundary = '10000 20000 30000'

  [sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 3
    NAzmthl = 6
    NA = 3
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    hide_angular_flux = true
    collapse_scattering = true
    assemble_fission_jacobian = false
    flux_moment_primal_variable = true
  []
[]

[Materials]
  [std_assm_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239K pseudo_PU240K pseudo_U235_K pseudo_U238_K pseudo_O16__K '
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '110 111'
    material_id = 1
  []
  [std_assm_void]
    type = VoidNeutronicsMaterial
    block = '112 116'
  []
  [std_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_K pseudo_CR52_K pseudo_CR53_K pseudo_CR54_K pseudo_FE54_K 
                pseudo_FE56_K pseudo_FE57_K pseudo_FE58_K pseudo_MO100K pseudo_MO92_K 
                pseudo_MO94_K pseudo_MO95_K pseudo_MO96_K pseudo_MO97_K pseudo_MO98_K 
                pseudo_NI58_K pseudo_NI60_K pseudo_NI61_K pseudo_NI62_K pseudo_NI64_K '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '113 117'
    material_id = 1
  []
  [std_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__K pseudo_O16__K '
    densities = '6.84143E-02  6.84143E-02'
    block = '114 115'
    material_id = 1
  []
  [std_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_K pseudo_CR52_K pseudo_CR53_K pseudo_CR54_K pseudo_FE54_K 
                pseudo_FE56_K pseudo_FE57_K pseudo_FE58_K pseudo_NI58_K pseudo_NI60_K 
                pseudo_NI61_K pseudo_NI62_K pseudo_NI64_K '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '119 120 122'
    material_id = 1
  []
  [std_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_K '
    densities = '2.39160E-02'
    block = '118 121 123'
    material_id = 1
  []

  [std_assm_insul_uo2]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_U235_J pseudo_U238_J pseudo_O16__J '
    densities = '4.92079E-05  2.23181E-02   4.47347E-02'
    block = '130 131'
    material_id = 1
  []
  [std_assm_insul_void]
    type = VoidNeutronicsMaterial
    block = '132 136'
  []
  [std_assm_insul_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_J pseudo_CR52_J pseudo_CR53_J pseudo_CR54_J pseudo_FE54_J 
                pseudo_FE56_J pseudo_FE57_J pseudo_FE58_J pseudo_MO100J pseudo_MO92_J 
                pseudo_MO94_J pseudo_MO95_J pseudo_MO96_J pseudo_MO97_J pseudo_MO98_J 
                pseudo_NI58_J pseudo_NI60_J pseudo_NI61_J pseudo_NI62_J pseudo_NI64_J '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '133 137'
    material_id = 1
  []
  [std_assm_insul_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__J pseudo_O16__J '
    densities = '6.84143E-02  6.84143E-02'
    block = '134 135'
    material_id = 1
  []
  [std_assm_insul_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_J pseudo_CR52_J pseudo_CR53_J pseudo_CR54_J pseudo_FE54_J 
                pseudo_FE56_J pseudo_FE57_J pseudo_FE58_J pseudo_NI58_J pseudo_NI60_J 
                pseudo_NI61_J pseudo_NI62_J pseudo_NI64_J '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '139 140 142'
    material_id = 1
  []
  [std_assm_insul_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_J '
    densities = '2.39160E-02'
    block = '138 141 143'
    material_id = 1
  []

  [std_assm_spring_void]
    type = VoidNeutronicsMaterial
    block = '150 151 152 156'
  []
  [std_assm_spring_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_L pseudo_CR52_L pseudo_CR53_L pseudo_CR54_L pseudo_FE54_L 
                pseudo_FE56_L pseudo_FE57_L pseudo_FE58_L pseudo_MO100L pseudo_MO92_L 
                pseudo_MO94_L pseudo_MO95_L pseudo_MO96_L pseudo_MO97_L pseudo_MO98_L 
                pseudo_NI58_L pseudo_NI60_L pseudo_NI61_L pseudo_NI62_L pseudo_NI64_L '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '153 157'
    material_id = 1
  []
  [std_assm_spring_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__L pseudo_O16__L '
    densities = '6.84143E-02  6.84143E-02'
    block = '154 155'
    material_id = 1
  []
  [std_assm_spring_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_L pseudo_CR52_L pseudo_CR53_L pseudo_CR54_L pseudo_FE54_L 
                pseudo_FE56_L pseudo_FE57_L pseudo_FE58_L pseudo_NI58_L pseudo_NI60_L 
                pseudo_NI61_L pseudo_NI62_L pseudo_NI64_L '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '159 160 162'
    material_id = 1
  []
  [std_assm_spring_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_L '
    densities = '2.39160E-02'
    block = '158 161 163'
    material_id = 1
  []

  [std_assm_axial_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NI58_I pseudo_NI60_I pseudo_NI61_I pseudo_NI62_I pseudo_NI64_I '
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '170 171 174 175'
    material_id = 1
  []
  [std_assm_axial_void]
    type = VoidNeutronicsMaterial
    block = '172 176'
  []
  [std_assm_axial_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_I pseudo_CR52_I pseudo_CR53_I pseudo_CR54_I pseudo_FE54_I 
                pseudo_FE56_I pseudo_FE57_I pseudo_FE58_I pseudo_MO100I pseudo_MO92_I 
                pseudo_MO94_I pseudo_MO95_I pseudo_MO96_I pseudo_MO97_I pseudo_MO98_I 
                pseudo_NI58_I pseudo_NI60_I pseudo_NI61_I pseudo_NI62_I pseudo_NI64_I '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '173 177'
    material_id = 1
  []
  [std_assm_axial_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_I pseudo_CR52_I pseudo_CR53_I pseudo_CR54_I pseudo_FE54_I 
                pseudo_FE56_I pseudo_FE57_I pseudo_FE58_I pseudo_NI58_I pseudo_NI60_I 
                pseudo_NI61_I pseudo_NI62_I pseudo_NI64_I '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '179 180 182'
    material_id = 1
  []
  [std_assm_axial_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_I '
    densities = '2.39160E-02'
    block = '178 181 183'
    material_id = 1
  []

  [gp2_assm_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239Q pseudo_PU240Q pseudo_U235_Q pseudo_U238_Q pseudo_O16__Q '
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '210 211'
    material_id = 1
  []
  [gp2_assm_gp_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239Q pseudo_PU240Q pseudo_U235_Q pseudo_U238_Q pseudo_O16__Q '
    densities = '5.45489E-03  4.89849E-04   3.50453E-05   1.58946E-02   4.36894E-02'
    block = '212 213'
    material_id = 1
  []
  [gp2_assm_void]
    type = VoidNeutronicsMaterial
    block = '214 218'
  []
  [gp2_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_Q pseudo_CR52_Q pseudo_CR53_Q pseudo_CR54_Q pseudo_FE54_Q 
                pseudo_FE56_Q pseudo_FE57_Q pseudo_FE58_Q pseudo_MO100Q pseudo_MO92_Q 
                pseudo_MO94_Q pseudo_MO95_Q pseudo_MO96_Q pseudo_MO97_Q pseudo_MO98_Q 
                pseudo_NI58_Q pseudo_NI60_Q pseudo_NI61_Q pseudo_NI62_Q pseudo_NI64_Q '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '215 219'
    material_id = 1
  []
  [gp2_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__Q pseudo_O16__Q '
    densities = '6.84143E-02  6.84143E-02'
    block = '216 217'
    material_id = 1
  []
  [gp2_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_Q pseudo_CR52_Q pseudo_CR53_Q pseudo_CR54_Q pseudo_FE54_Q 
                pseudo_FE56_Q pseudo_FE57_Q pseudo_FE58_Q pseudo_NI58_Q pseudo_NI60_Q 
                pseudo_NI61_Q pseudo_NI62_Q pseudo_NI64_Q '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '221 222 224'
    material_id = 1
  []
  [gp2_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_Q '
    densities = '2.39160E-02'
    block = '220 223 225'
    material_id = 1
  []

  [abs1_assm_pu_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239O pseudo_PU240O pseudo_U235_O pseudo_U238_O pseudo_O16__O '
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '310 311'
    material_id = 1
  []
  [abs1_assm_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_B10__O pseudo_B11__O pseudo_C12__O '
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '316'
    material_id = 1
  []
  [abs1_assm_void]
    type = VoidNeutronicsMaterial
    block = '312 320'
  []
  [abs1_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_O pseudo_CR52_O pseudo_CR53_O pseudo_CR54_O pseudo_FE54_O 
                pseudo_FE56_O pseudo_FE57_O pseudo_FE58_O pseudo_MO100O pseudo_MO92_O 
                pseudo_MO94_O pseudo_MO95_O pseudo_MO96_O pseudo_MO97_O pseudo_MO98_O 
                pseudo_NI58_O pseudo_NI60_O pseudo_NI61_O pseudo_NI62_O pseudo_NI64_O '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '313 317 321'
    material_id = 1
  []
  [abs1_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__O pseudo_O16__O '
    densities = '6.84143E-02  6.84143E-02'
    block = '318 319'
    material_id = 1
  []
  [abs1_assm_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_O pseudo_CR52_O pseudo_CR53_O pseudo_CR54_O pseudo_FE54_O 
                pseudo_FE56_O pseudo_FE57_O pseudo_FE58_O pseudo_NI58_O pseudo_NI60_O 
                pseudo_NI61_O pseudo_NI62_O pseudo_NI64_O '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '314 315'
    material_id = 1
  []
  [abs1_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_O pseudo_CR52_O pseudo_CR53_O pseudo_CR54_O pseudo_FE54_O 
                pseudo_FE56_O pseudo_FE57_O pseudo_FE58_O pseudo_NI58_O pseudo_NI60_O 
                pseudo_NI61_O pseudo_NI62_O pseudo_NI64_O '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '323 324 326'
    material_id = 1
  []
  [abs1_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_O '
    densities = '2.39160E-02'
    block = '322 325 327'
    material_id = 1
  []

  [abs1_assm_insul_uo2]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_U235_N pseudo_U238_N pseudo_O16__N '
    densities = '4.92079E-05  2.23181E-02   4.47347E-02'
    block = '330 331'
    material_id = 1
  []
  [abs1_assm_insul_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_B10__N pseudo_B11__N pseudo_C12__N '
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '336'
    material_id = 1
  []
  [abs1_assm_insul_void]
    type = VoidNeutronicsMaterial
    block = '332 340 395'
  []
  [abs1_assm_insul_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_N pseudo_CR52_N pseudo_CR53_N pseudo_CR54_N pseudo_FE54_N 
                pseudo_FE56_N pseudo_FE57_N pseudo_FE58_N pseudo_MO100N pseudo_MO92_N 
                pseudo_MO94_N pseudo_MO95_N pseudo_MO96_N pseudo_MO97_N pseudo_MO98_N 
                pseudo_NI58_N pseudo_NI60_N pseudo_NI61_N pseudo_NI62_N pseudo_NI64_N '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '333 337 341'
    material_id = 1
  []
  [abs1_assm_insul_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__N pseudo_O16__N '
    densities = '6.84143E-02  6.84143E-02'
    block = '338 339'
    material_id = 1
  []
  [abs1_assm_insul_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_N pseudo_CR52_N pseudo_CR53_N pseudo_CR54_N pseudo_FE54_N 
                pseudo_FE56_N pseudo_FE57_N pseudo_FE58_N pseudo_NI58_N pseudo_NI60_N 
                pseudo_NI61_N pseudo_NI62_N pseudo_NI64_N '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '334 335'
    material_id = 1
  []
  [abs1_assm_insul_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_N pseudo_CR52_N pseudo_CR53_N pseudo_CR54_N pseudo_FE54_N 
                pseudo_FE56_N pseudo_FE57_N pseudo_FE58_N pseudo_NI58_N pseudo_NI60_N 
                pseudo_NI61_N pseudo_NI62_N pseudo_NI64_N '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '343 344 346'
    material_id = 1
  []
  [abs1_assm_insul_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_N '
    densities = '2.39160E-02'
    block = '342 345 347'
    material_id = 1
  []

  [abs1_assm_spring_void]
    type = VoidNeutronicsMaterial
    block = '350 351 352 360'
  []
  [abs1_assm_spring_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_B10__P pseudo_B11__P pseudo_C12__P '
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '356'
    material_id = 1
  []
  [abs1_assm_spring_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_P pseudo_CR52_P pseudo_CR53_P pseudo_CR54_P pseudo_FE54_P 
                pseudo_FE56_P pseudo_FE57_P pseudo_FE58_P pseudo_MO100P pseudo_MO92_P 
                pseudo_MO94_P pseudo_MO95_P pseudo_MO96_P pseudo_MO97_P pseudo_MO98_P 
                pseudo_NI58_P pseudo_NI60_P pseudo_NI61_P pseudo_NI62_P pseudo_NI64_P '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '353 357 361'
    material_id = 1
  []
  [abs1_assm_spring_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__P pseudo_O16__P '
    densities = '6.84143E-02  6.84143E-02'
    block = '358 359'
    material_id = 1
  []
  [abs1_assm_spring_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_P pseudo_CR52_P pseudo_CR53_P pseudo_CR54_P pseudo_FE54_P 
                pseudo_FE56_P pseudo_FE57_P pseudo_FE58_P pseudo_NI58_P pseudo_NI60_P 
                pseudo_NI61_P pseudo_NI62_P pseudo_NI64_P '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '354 355'
    material_id = 1
  []
  [abs1_assm_spring_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_P pseudo_CR52_P pseudo_CR53_P pseudo_CR54_P pseudo_FE54_P 
                pseudo_FE56_P pseudo_FE57_P pseudo_FE58_P pseudo_NI58_P pseudo_NI60_P 
                pseudo_NI61_P pseudo_NI62_P pseudo_NI64_P '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '363 364 366'
    material_id = 1
  []
  [abs1_assm_spring_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_P '
    densities = '2.39160E-02'
    block = '362 365 367'
    material_id = 1
  []

  [abs1_assm_axial_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NI58_M pseudo_NI60_M pseudo_NI61_M pseudo_NI62_M pseudo_NI64_M '
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '370 371 374 375 376 378 379'
    material_id= 1
  []
  [abs1_assm_axial_void]
    type = VoidNeutronicsMaterial
    block = '372 380'
  []
  [abs1_assm_axial_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_M pseudo_CR52_M pseudo_CR53_M pseudo_CR54_M pseudo_FE54_M 
                pseudo_FE56_M pseudo_FE57_M pseudo_FE58_M pseudo_MO100M pseudo_MO92_M 
                pseudo_MO94_M pseudo_MO95_M pseudo_MO96_M pseudo_MO97_M pseudo_MO98_M 
                pseudo_NI58_M pseudo_NI60_M pseudo_NI61_M pseudo_NI62_M pseudo_NI64_M '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '373 377 381'
    material_id= 1
  []
  [abs1_assm_axial_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_M pseudo_CR52_M pseudo_CR53_M pseudo_CR54_M pseudo_FE54_M 
                pseudo_FE56_M pseudo_FE57_M pseudo_FE58_M pseudo_NI58_M pseudo_NI60_M 
                pseudo_NI61_M pseudo_NI62_M pseudo_NI64_M'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '383 384 386'
    material_id= 1
  []
  [abs1_assm_axial_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_M '
    densities = '2.39160E-02'
    block = '382 385 387'
    material_id= 1
  []

  [abs1gp1_assm_pu_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239R pseudo_PU240R pseudo_U235_R pseudo_U238_R pseudo_O16__R '
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '410 411'
    material_id = 1
  []
  [abs1gp1_assm_gp_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_PU239R pseudo_PU240R pseudo_U235_R pseudo_U238_R pseudo_O16__R '
    densities = '5.45489E-03  4.89849E-04   3.50453E-05   1.58946E-02   4.36894E-02'
    block = '412 413'
    material_id = 1
  []
  [abs1gp1_assm_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_B10__R pseudo_B11__R pseudo_C12__R '
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '418'
    material_id = 1
  []
  [abs1gp1_assm_void]
    type = VoidNeutronicsMaterial
    block = '414 422'
  []
  [abs1gp1_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_R pseudo_CR52_R pseudo_CR53_R pseudo_CR54_R pseudo_FE54_R 
                pseudo_FE56_R pseudo_FE57_R pseudo_FE58_R pseudo_MO100R pseudo_MO92_R 
                pseudo_MO94_R pseudo_MO95_R pseudo_MO96_R pseudo_MO97_R pseudo_MO98_R 
                pseudo_NI58_R pseudo_NI60_R pseudo_NI61_R pseudo_NI62_R pseudo_NI64_R '
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '415 419 423'
    material_id = 1
  []
  [abs1gp1_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_BE9__R pseudo_O16__R '
    densities = '6.84143E-02  6.84143E-02'
    block = '420 421'
    material_id = 1
  []
  [abs1gp1_assm_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_R pseudo_CR52_R pseudo_CR53_R pseudo_CR54_R pseudo_FE54_R 
                pseudo_FE56_R pseudo_FE57_R pseudo_FE58_R pseudo_NI58_R pseudo_NI60_R 
                pseudo_NI61_R pseudo_NI62_R pseudo_NI64_R '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '416 417' 
    material_id = 1
  []
  [abs1gp1_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_R pseudo_CR52_R pseudo_CR53_R pseudo_CR54_R pseudo_FE54_R 
                pseudo_FE56_R pseudo_FE57_R pseudo_FE58_R pseudo_NI58_R pseudo_NI60_R 
                pseudo_NI61_R pseudo_NI62_R pseudo_NI64_R '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '425 426 428'
    material_id = 1
  []
  [abs1gp1_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_R '
    densities = '2.39160E-02'
    block = '424 427 429'
    material_id = 1
  []

  [fred_assm_void]
    type = VoidNeutronicsMaterial
    block = '510 511 513'
  []
  [fred_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_B pseudo_CR52_B pseudo_CR53_B pseudo_CR54_B pseudo_FE54_B 
                pseudo_FE56_B pseudo_FE57_B pseudo_FE58_B pseudo_MO100B pseudo_MO92_B 
                pseudo_MO94_B pseudo_MO95_B pseudo_MO96_B pseudo_MO97_B pseudo_MO98_B 
                pseudo_NI58_B pseudo_NI60_B pseudo_NI61_B pseudo_NI62_B pseudo_NI64_B '
    densities = '6.91067E-04  1.33262E-02   1.51117E-03   3.76153E-04   3.41139E-03
                 5.35512E-02  1.23670E-03   1.64582E-04   1.22081E-04   1.88136E-04
                 1.17265E-04  2.01830E-04   2.11462E-04   1.21068E-04   3.05907E-04
                 7.61720E-03  2.93415E-03   1.27542E-04   4.06668E-04   1.03571E-04 '
    block = '512'
    material_id = 1
  []
  [fred_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_B pseudo_CR52_B pseudo_CR53_B pseudo_CR54_B pseudo_FE54_B 
                pseudo_FE56_B pseudo_FE57_B pseudo_FE58_B pseudo_NI58_B pseudo_NI60_B 
                pseudo_NI61_B pseudo_NI62_B pseudo_NI64_B '
    densities = '8.17596E-04  1.57670E-02   1.78782E-03   4.45018E-04   3.48180E-03
                 5.46564E-02  1.26222E-03   1.67978E-04   6.80898E-03   2.62284E-03
                 1.14008E-04  3.63522E-04   9.25775E-05 '
    block = '514'
    material_id = 1
  []
  [fred_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_B '
    densities = '2.39160E-02'
    block = '515'
    material_id = 1
  []
  
  [downcomer_iv]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_C pseudo_CR50_C pseudo_CR52_C pseudo_CR53_C pseudo_CR54_C 
                pseudo_FE54_C pseudo_FE56_C pseudo_FE57_C pseudo_FE58_C pseudo_NI58_C 
                pseudo_NI60_C pseudo_NI61_C pseudo_NI62_C pseudo_NI64_C '
    densities = '1.48350E-02  2.34745E-04   4.52673E-03   5.13299E-04   1.27773E-04
                 9.99616E-04  1.56923E-02   3.62408E-04   4.82292E-05   1.95489E-03
                 7.53037E-04  3.27337E-05   1.04375E-04   2.65802E-05'
    block = '601'
    material_id = 1
  []

  [downcomer_ov]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_MG24_D pseudo_MG25_D pseudo_MG26_D pseudo_AL27_D pseudo_CR50_D 
                pseudo_CR52_D pseudo_CR53_D pseudo_CR54_D pseudo_FE54_D pseudo_FE56_D 
                pseudo_FE57_D pseudo_FE58_D pseudo_NI58_D pseudo_NI60_D pseudo_NI61_D 
                pseudo_NI62_D pseudo_NI64_D '
    densities = '4.12309E-04  5.21977E-05   5.74694E-05   1.12844E-02   1.28512E-04
                 2.47827E-03  2.81011E-04   6.99491E-05   5.47272E-04   8.59100E-03
                 1.98405E-04  2.64034E-05   1.07022E-03   4.12259E-04   1.79202E-05
                 5.71389E-05  1.45518E-05'
    block = '602'
    material_id = 1
  []

  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_MG24_F pseudo_MG25_F pseudo_MG26_F pseudo_AL27_F pseudo_CR50_F 
                pseudo_CR52_F pseudo_CR53_F pseudo_CR54_F pseudo_FE54_F pseudo_FE56_F 
                pseudo_FE57_F pseudo_FE58_F pseudo_NI58_F pseudo_NI60_F pseudo_NI61_F 
                pseudo_NI62_F pseudo_NI64_F '
    densities = '7.44450E-05  9.42463E-06   1.03762E-05   2.03752E-03   2.77734E-05
                 5.35588E-04  6.07314E-05   1.51177E-05   1.18273E-04   1.85668E-03
                 4.28782E-05  5.70638E-06   4.99710E-02   1.92485E-02   8.36735E-04
                 2.66786E-03  6.79430E-04'
    block = '603'
    material_id = 1
  []

  [rad_shield]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_MG24_G pseudo_MG25_G pseudo_MG26_G pseudo_CR50_G pseudo_CR52_G 
                pseudo_CR53_G pseudo_CR54_G pseudo_FE54_G pseudo_FE56_G pseudo_FE57_G 
                pseudo_FE58_G pseudo_NI58_G pseudo_NI60_G pseudo_NI61_G pseudo_NI62_G 
                pseudo_NI64_G pseudo_B10__G pseudo_B11__G pseudo_C12__G '
    densities = '2.71254E-04  3.43404E-05   3.78086E-05   9.86654E-05   1.90267E-03
                 2.15751E-04  5.37036E-05   4.20168E-04   6.59577E-03   1.52329E-04
                 2.02719E-05  8.21692E-04   3.16512E-04   1.37589E-05   4.38683E-05
                 1.11725E-05  5.40601E-03   2.17599E-02   6.79150E-03 '
    block = '604'
    material_id = 1
  []

  [Na_grid_plate]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_A pseudo_CR50_A pseudo_CR52_A pseudo_CR53_A pseudo_CR54_A 
                pseudo_FE54_A pseudo_FE56_A pseudo_FE57_A pseudo_FE58_A pseudo_NI58_A 
                pseudo_NI60_A pseudo_NI61_A pseudo_NI62_A pseudo_NI64_A pseudo_B10__A 
                pseudo_B11__A pseudo_C12__A '
    densities = '1.68850E-02  1.99835E-04   3.85357E-03   4.36962E-04   1.08771E-04
                 8.50997E-04  1.33588E-02   3.08517E-04   4.10573E-05   1.66423E-03
                 6.41055E-04  2.78666E-05   8.88497E-05   2.26275E-05   6.60243E-04
                 2.65754E-03  8.29451E-04 '
    block = '1001 1002'
    material_id = 1
  []

  [Na_steel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_NA23_H pseudo_CR50_H pseudo_CR52_H pseudo_CR53_H pseudo_CR54_H 
                pseudo_FE54_H pseudo_FE56_H pseudo_FE57_H pseudo_FE58_H pseudo_NI58_H 
                pseudo_NI60_H pseudo_NI61_H pseudo_NI62_H pseudo_NI64_H pseudo_B10__H 
                pseudo_B11__H pseudo_C12__H '
    densities = '1.35120E-02  2.66172E-04   5.13286E-03   5.82020E-04   1.44878E-04
                 1.13346E-03  1.77932E-02   4.10931E-04   5.46867E-05   2.21669E-03
                 8.53861E-04  3.71173E-05   1.18350E-04   3.01385E-05   6.60243E-04
                 2.65754E-03  8.29451E-04 '
    block = '2001 2002'
    material_id = 1
  []  

  [Steel_void]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'pseudo_CR50_E pseudo_CR52_E pseudo_CR53_E pseudo_CR54_E pseudo_FE54_E 
                pseudo_FE56_E pseudo_FE57_E pseudo_FE58_E pseudo_NI58_E pseudo_NI60_E 
                pseudo_NI61_E pseudo_NI62_E pseudo_NI64_E '
    densities = '1.23500E-04  2.38160E-03   2.70060E-04   6.72230E-05   5.25940E-04
                 8.25610E-03  1.90670E-04   2.53750E-05   1.02850E-03   3.96190E-04
                 1.72220E-05  5.49120E-05   1.39840E-05'
    block = '605'
    material_id = 1
  []
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-6
  richardson_rel_tol = 1e-20
  richardson_value = eigenvalue
  richardson_max_its = 1000

  inner_solve_type = GMRes
  max_inner_its = 1000

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  diffusion_eigen_solver_type = newton
  diffusion_prec_type = lu

  abs_eig_tol = 1e-6
[]

[Postprocessors]

[]

[Outputs]
  csv = true
  perf_graph = true
  exodus = false
  checkpoint = false
  wall_time_checkpoint = false
  nemesis = false
[]
