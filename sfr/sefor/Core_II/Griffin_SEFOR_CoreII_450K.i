# ========================================================
# SEFOR Core I-I Griffin Model at 450 K
# Developer: Ahmed Amin Abdelhameed (Argonne National Lab)
# ========================================================

# -------------------------------------------------------------
# Step 1: Generate the split mesh (uncomment if needed)
# -------------------------------------------------------------

# Example input block for mesh splitting:
# [Mesh]
#   parallel_type = REPLICATED
#   [fmg]
#     type = FileMeshGenerator
#     file = '../Mesh/SEFORII_3D_450_in.e'
#   []
# []

# Command used to generate a split mesh:
#   mpirun -np 1 griffin-opt -i griffin_input.i \
#       --split-mesh 6048 \
#       --split-file mesh_splitted


# -------------------------------------------------------------
# Step 2: Run Griffin using the split mesh
# -------------------------------------------------------------
[Mesh]
  parallel_type = DISTRIBUTED
  [fmg]
    type = FileMeshGenerator
    file = 'mesh_splitted.cpa.gz'
  []
[]


[GlobalParams]
  library_file   = '../Cross_Section/ISOTXS_450.xml'
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
    NAzmthl = 4
    NA = 3
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    hide_angular_flux = true
    collapse_scattering = true
    assemble_fission_jacobian = false
  []
[]

[Materials]

##############################################################################
############### Materials for Standard Fuel Assembly #########################
##############################################################################

######################################
##### MATERIAL 11 : FA_6_Fuel_St  ####
######################################
  [std_assm_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '111'
    material_id = 11
  []
  [std_assm_void]
    type = VoidNeutronicsMaterial
    block = '112 115'
  []
  [std_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '113'
    material_id = 11
  []
  [std_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '114'
    material_id = 11
  []
  [std_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '116 118  119 121'
    material_id = 11
  []
  [std_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '117 120 122'
    material_id = 11
  []
########################################
##### MATERIAL 10 : FA_6_Fuel_insul ####
########################################
  [std_assm_insul_uo2]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' U235   U238   O16'
    densities = '4.92079E-05  2.23181E-02   4.47347E-02'
    block = '143'
    material_id = 10
  []
  [std_assm_insul_void]
    type = VoidNeutronicsMaterial
    block = '144 147'
  []
  [std_assm_insul_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54    FE54
                 FE56   FE57   FE58   MO100   MO92
                 MO94   MO95   MO96   MO97    MO98
                 NI58   NI60   NI61   NI62    NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '145'
    material_id = 10
  []
  [std_assm_insul_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
     block = '146'
    material_id = 10
  []
  [std_assm_insul_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '148 150  151 153'
    material_id = 10
  []
  [std_assm_insul_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23'
    densities = '2.39160E-02'
    block = '149 152 154'
    material_id = 10
  []
########################################
##### MATERIAL 12: FA_6_Spring_Void ####
########################################
  [std_assm_spring_void]
    type = VoidNeutronicsMaterial
    block = '156 157 160'
  []
  [std_assm_spring_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   MO100  MO92
                 MO94   MO95   MO96   MO97   MO98
                 NI58   NI60   NI61   NI62   NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '158'
    material_id = 12
  []
  [std_assm_spring_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '159'
    material_id = 12
  []
  [std_assm_spring_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '161 163 164 166'
    material_id = 12
  []
  [std_assm_spring_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '162 165 167'
    material_id = 12
  []
#######################################
##### MATERIAL 9: FA_6_Ni_Axial #######
#######################################
  [std_assm_axial_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58   NI60   NI61   NI62   NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '131 134 139'
    material_id = 9
  []
  [std_assm_axial_void]
    type = VoidNeutronicsMaterial
    block = '132 135 155'
  []
  [std_assm_axial_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   MO100  MO92
                 MO94   MO95   MO96   MO97   MO98
                 NI58   NI60   NI61   NI62   NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '133'
    material_id = 9
  []
  [std_assm_axial_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64  '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '136 138 141'
    material_id = 9
  []
  [std_assm_axial_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23'
    densities = '2.39160E-02'
    block = '137 140 142'
    material_id = 9
  []

#####################################################################################
############### Materials for  Fuel Assembly  with 1 GP rod #########################
#####################################################################################

#########################################
##### MATERIAL 17: GA_6_1_Fuel_St #######
#########################################

  [gp1_assm_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' PU239  PU240  U235  U238  O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '231'
    material_id = 17
  []
  [gp1_assm_gp_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' PU239  PU240  U235  U238  O16'
    densities = '5.45489E-03  4.89849E-04   3.50453E-05   1.58946E-02   4.36894E-02'
    block = '232'
    material_id = 17
  []
  [gp1_assm_void]
    type = VoidNeutronicsMaterial
    block = '233 236'
  []
  [gp1_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '234'
    material_id = 17
  []
  [gp1_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '235'
    material_id = 17
  []
  [gp1_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '237 239 240 242'
    material_id = 17
  []
  [gp1_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '238 241 243'
    material_id = 17
  []
######################################################################################
############### Materials for  Fuel Assembly  with 1 BA rod #########################
######################################################################################

##########################################
##### MATERIAL 15: AFA_6_1_Fuel_St #######
##########################################
  [abs1_assm_pu_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' PU239  PU240  U235  U238  O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '361'
    material_id = 15
  []
  [abs1_assm_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' B10  B11  C12 '
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '365'
    material_id = 15
  []
  [abs1_assm_void]
    type = VoidNeutronicsMaterial
    block = '362 368'
  []
  [abs1_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '363'
    material_id = 15
  []
  [abs1_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '367'
    material_id = 15
  []
  [abs1_assm_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '364'
    material_id = 15
  []
  [abs1_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '366 369 371 372 374'
    material_id = 15
  []
  [abs1_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23 '
    densities = '2.39160E-02'
    block = '370 373 375'
    material_id = 15
  []
#############################################
##### MATERIAL 14: AFA_6_1_Fuel_insul #######
#############################################
  [abs1_assm_insul_uo2]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'U235  U238  O16'
    densities = '4.92079E-05  2.23181E-02   4.47347E-02'
    block = '346'
    material_id = 14
  []
  [abs1_assm_insul_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'B10  B11  C12'
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '350'
    material_id = 14
  []
  [abs1_assm_insul_void]
    type = VoidNeutronicsMaterial
    block = '347 353'
  []
  [abs1_assm_insul_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '348'
    material_id = 14
  []
  [abs1_assm_insul_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '352'
    material_id = 14
  []
  [abs1_assm_insul_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '349'
    material_id = 14
  []
  [abs1_assm_insul_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '351 354 356 357 359'
    material_id = 14
  []
  [abs1_assm_insul_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '355 358 360'
    material_id = 14
  []

##############################################
##### MATERIAL 16: AFA_6_1_Spring_Void #######
##############################################
  [abs1_assm_spring_void]
    type = VoidNeutronicsMaterial
    block = '376 377 383'
  []
  [abs1_assm_spring_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'B10  B11  C12'
    densities = '1.32047E-02  5.31509E-02  1.65886E-02'
    block = '380'
    material_id = 16
  []
  [abs1_assm_spring_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '378'
    material_id = 16
  []
  [abs1_assm_spring_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9  O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '382'
    material_id = 16
  []
  [abs1_assm_spring_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64'
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '379'
    material_id = 16
  []
  [abs1_assm_spring_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '381 384 386 387 389'
    material_id = 16
  []
  [abs1_assm_spring_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23'
    densities = '2.39160E-02'
    block = '385 388 390'
    material_id = 16
  []
##############################################
##### MATERIAL 13: AFA_6_1_Ni_Axial ##########
##############################################
  [abs1_assm_axial_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '331 335 334 337'
    material_id= 13
  []
  [abs1_assm_axial_void]
    type = VoidNeutronicsMaterial
    block = '332 338'
  []
  [abs1_assm_axial_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '333'
    material_id= 13
  []
  [abs1_assm_axial_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '336 339 341 342 344'
    material_id= 13
  []
  [abs1_assm_axial_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '340 343 345'
    material_id= 13
  []


######################################################################################
############### Materials for  Fuel Assembly  with 1 BA rod  & 1GP rod ###############
######################################################################################

##################################################
##### MATERIAL 18: GA_AFA_6_1_1_Fuel_St ##########
##################################################
  [abs1gp1_assm_pu_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' PU239  PU240  U235  U238  O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '431'
    material_id = 18
  []
  [abs1gp1_assm_gp_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239  PU240  U235  U238  O16'
    densities = '5.45489E-03  4.89849E-04   3.50453E-05   1.58946E-02   4.36894E-02'
    block = '432'
    material_id = 18
  []
  [abs1gp1_assm_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'B10  B11  C12'
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '436'
    material_id = 18
  []
  [abs1gp1_assm_void]
    type = VoidNeutronicsMaterial
    block = '433 439'
  []
  [abs1gp1_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '434'
    material_id = 18
  []
  [abs1gp1_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9   O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '438'
    material_id = 18
  []
  [abs1gp1_assm_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '435'
    material_id = 18
  []
  [abs1gp1_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '437 440 442 443 445'
    material_id = 18
  []
  [abs1gp1_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '441 444 446'
    material_id = 18
  []
#####################################################################
###################### Materials for  FRED  Assembly  ###############
#####################################################################

########################################
##### MATERIAL 2: FRED #################
########################################
  [fred_assm_void]
    type = VoidNeutronicsMaterial
    block = '531 533'
  []
  [fred_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64'
    densities = '8.17596E-04  1.57670E-02   1.78782E-03   4.45018E-04   3.48180E-03
                 5.46564E-02  1.26222E-03   1.67978E-04   6.80898E-03   2.62284E-03
                 1.14008E-04  3.63522E-04   9.25775E-05'
    block = '532 534'
    material_id = 2
  []
  [fred_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23'
    densities = '2.39160E-02'
    block = '535'
    material_id = 2
  []
######################################################################################
############### Materials for  Fuel Assembly  with 1 BA rod  & 2GP rod ###############
######################################################################################

##################################################
##### MATERIAL 19: GA_AFA_6_1_2_Fuel_St ##########
##################################################
  [abs1gp2_assm_pu_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' PU239  PU240  U235  U238  O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '831'
    material_id = 19
  []
  [abs1gp2_assm_gp_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239  PU240  U235  U238  O16'
    densities = '5.45489E-03  4.89849E-04   3.50453E-05   1.58946E-02   4.36894E-02'
    block = '832'
    material_id = 19
  []
  [abs1gp2_assm_b4c]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'B10  B11  C12'
    densities = '1.32047E-02  5.31509E-02   1.65886E-02'
    block = '836'
    material_id = 19
  []
  [abs1gp2_assm_void]
    type = VoidNeutronicsMaterial
    block = '833 839'
  []
  [abs1gp2_assm_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  MO100  MO92
                 MO94  MO95  MO96  MO97  MO98
                 NI58  NI60  NI61  NI62  NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '834'
    material_id = 19
  []
  [abs1gp2_assm_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9   O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '838'
    material_id = 19
  []
  [abs1gp2_assm_ss304_cent]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17447E-04  1.57642E-02   1.78749E-03   4.44937E-04   3.48116E-03
                 5.46464E-02  1.26199E-03   1.67947E-04   6.80774E-03   2.62236E-03
                 1.13987E-04  3.63455E-04   9.25606E-05 '
    block = '835'
    material_id = 19
  []
  [abs1gp2_assm_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '837 840 842 843 845'
    material_id = 19
  []
  [abs1gp2_assm_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '841 844 846'
    material_id = 19
  []
######################################################################################
############### Materials for  Downcomer inner vessel ###############
######################################################################################

##################################################
##### MATERIAL 3: DC_IV  #########################
##################################################
  [downcomer_iv]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23  CR50  CR52  CR53  CR54
                 FE54  FE56  FE57  FE58  NI58
                 NI60  NI61  NI62  NI64 '
    densities = '1.48350E-02  2.34745E-04   4.52673E-03   5.13299E-04   1.27773E-04
                 9.99616E-04  1.56923E-02   3.62408E-04   4.82292E-05   1.95489E-03
                 7.53037E-04  3.27337E-05   1.04375E-04   2.65802E-05'
    block = '601'
    material_id = 3
  []
######################################################################################
############### Materials for  Downcomer outer vessel ################################
######################################################################################

##################################################
##### MATERIAL 4: DC_OV  #########################
##################################################
  [downcomer_ov]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' MG24  MG25  MG26  AL27  CR50
                 CR52  CR53  CR54  FE54  FE56
                 FE57  FE58  NI58  NI60  NI61
                 NI62  NI64'
    densities = '4.12309E-04  5.21977E-05   5.74694E-05   1.12844E-02   1.28512E-04
                 2.47827E-03  2.81011E-04   6.99491E-05   5.47272E-04   8.59100E-03
                 1.98405E-04  2.64034E-05   1.07022E-03   4.12259E-04   1.79202E-05
                 5.71389E-05  1.45518E-05'
    block = '602'
    material_id = 4
  []
######################################################################################
############### Materials for  Reflector   ###########################################
######################################################################################

##################################################
##### MATERIAL 6: Reflector_Refl  ################
##################################################
  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' MG24  MG25  MG26  AL27  CR50
                 CR52  CR53  CR54  FE54  FE56
                 FE57  FE58  NI58  NI60  NI61
                 NI62  NI64'
    densities = '7.44450E-05  9.42463E-06   1.03762E-05   2.03752E-03   2.77734E-05
                 5.35588E-04  6.07314E-05   1.51177E-05   1.18273E-04   1.85668E-03
                 4.28782E-05  5.70638E-06   4.99710E-02   1.92485E-02   8.36735E-04
                 2.66786E-03  6.79430E-04'
    block = '603'
    material_id = 6
  []
######################################################################################
############### Materials for  Radial Shield   ########################################
######################################################################################

##################################################
##### MATERIAL 7: Rad_Shld  ######################
##################################################
  [rad_shield]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' MG24  MG25  MG26  CR50  CR52
                 CR53  CR54  FE54  FE56  FE57
                 FE58  NI58  NI60  NI61  NI62
                 NI64  B10  B11  C12'
    densities = '2.71254E-04  3.43404E-05   3.78086E-05   9.86654E-05   1.90267E-03
                 2.15751E-04  5.37036E-05   4.20168E-04   6.59577E-03   1.52329E-04
                 2.02719E-05  8.21692E-04   3.16512E-04   1.37589E-05   4.38683E-05
                 1.11725E-05  5.40601E-03   2.17599E-02   6.79150E-03'
    block = '604'
    material_id = 7
  []
######################################################################################
############### Materials for  Na-grid plate   #######################################
######################################################################################

##################################################
##### MATERIAL 1: Na_GP_b  ######################
##################################################
  [Na_grid_plate]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23  CR50  CR52  CR53  CR54
                 FE54  FE56  FE57  FE58  NI58
                 NI60  NI61  NI62  NI64  B10
                 B11  C12'
    densities = '1.68850e-02  1.99836e-04  3.85357e-03  4.36962e-04  1.08771e-04
                 8.48348e-04  1.33173e-02  3.07556e-04  4.09295e-05  1.65905e-03
                 6.39060e-04  2.77798e-05  8.85732e-05  2.25570e-05  6.58188e-04
                 2.64927e-03  8.26870e-04'
    block = '1001 1002'
    material_id = 1
  []


#################################################################################
############### Materials for  Na-steel   #######################################
#################################################################################

##################################################
##### MATERIAL 8: Na_steel_t  ####################
##################################################
  [Na_steel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' NA23  CR50  CR52  CR53  CR54
                 FE54  FE56  FE57  FE58  NI58
                 NI60  NI61  NI62  NI64  B10
                 B11  C12'
    densities = '1.35120E-02  2.66172E-04   5.13286E-03   5.82020E-04   1.44878E-04
                 1.13346E-03  1.77932E-02   4.10931E-04   5.46867E-05   2.21669E-03
                 8.53861E-04  3.71173E-05   1.18350E-04   3.01385E-05   6.60243E-04
                 2.65754E-03  8.29451E-04 '
    block = '2001 2002'
    material_id = 8
  []
#################################################################################
############### Materials for  Steel void  ######################################
#################################################################################

##################################################
##### MATERIAL 5: Reflector_Steel_Void  ##########
##################################################
  [Steel_void]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = ' CR50  CR52  CR53  CR54  FE54
                 FE56  FE57  FE58  NI58  NI60
                 NI61  NI62  NI64 '
    densities = '1.23500E-04  2.38160E-03   2.70060E-04   6.72230E-05   5.25940E-04
                 8.25610E-03  1.90670E-04   2.53750E-05   1.02850E-03   3.96190E-04
                 1.72220E-05  5.49120E-05   1.39840E-05'
    block = '605'
    material_id = 5
  []

##########################################################################################
############################# IFA Blocks #################################################
##########################################################################################

###########################################################
##### MATERIAL 24: IFA_6_2_1 ##############################
###########################################################
  [IFA_1_std_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '931'
    material_id = 24
  []
  [IFA_1_ifa_insu]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '935'
    material_id = 24
  []

  [IFA_1_void]
    type = VoidNeutronicsMaterial
    block = '932 934 936 939'
  []
  [IFA_1_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '933 937'
    material_id = 24
  []
  [IFA_1_beo_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '938'
    material_id = 24
  []

   [IFA_1_wire_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '943'
    material_id = 24
  []

  [IFA_1_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '940 942 945'
    material_id = 24
  []
  [IFA_1_insu_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '941 944 946'
    material_id = 24
  []

######################################################################################
##### MATERIAL 25: IFA_6_2_2 #########################################################
######################################################################################

  [IFA_2_std_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '947'
    material_id = 25
  []

  [IFA_2_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '951'
    material_id = 25
  []

  [IFA_2_void]
    type = VoidNeutronicsMaterial
    block = '948 950 952 955'
  []
  [IFA_2_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '949 953'
    material_id = 25
  []
  [IFA_2_beo_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '954'
    material_id = 25
  []

  [IFA_2_wire_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '959'
    material_id = 25
  []

  [IFA_2_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '956 958  961'
    material_id = 25
  []
  [IFA_2_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '957 960 962'
    material_id = 25
  []

######################################################################################
##### MATERIAL 26: IFA_6_2_3 #########################################################
######################################################################################
  [IFA_3_stand_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '963'
    material_id = 26
  []

  [IFA_3_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '967'
    material_id = 26
  []

  [IFA_3_void]
    type = VoidNeutronicsMaterial
    block = '964 966 968 971'
  []
  [IFA_3_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '965 969'
    material_id = 26
  []
  [IFA_3_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '970'
    material_id = 26
  []
  [IFA_3_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '972 974 975 977'
    material_id = 26
  []
  [IFA_3_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '973 976 978'
    material_id = 26
  []

######################################################################################
##### MATERIAL 27: IFA_6_2_5 #########################################################
######################################################################################

  [IFA_5_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '980'
    material_id = 27
  []

  [IFA_5_ifa_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '984'
    material_id = 27
  []

  [IFA_5_void]
    type = VoidNeutronicsMaterial
    block = '981 983 985 988'
  []
  [IFA_5_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '982 986'
    material_id = 27
  []
  [IFA_5_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '987'
    material_id = 27
  []
  [IFA_5_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '989 991 992 994'
    material_id = 27
  []
  [IFA_5_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '990 993 995'
    material_id = 27
  []

######################################################################################
##### MATERIAL 28: IFA_6_2_6 #########################################################
######################################################################################
 #ifa rod: spring (void) & stand: fuel
  [IFA_6_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1031'
    material_id = 28
  []
  [IFA_6_void]
    type = VoidNeutronicsMaterial
    block = '1035 1032 1034 1036 1039'
  []
  [IFA_6_Spring_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1033 1037'
    material_id = 28
  []
  [IFA_6_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1038'
    material_id = 28
  []
  [IFA_6_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1040 1042 1043 1045'
    material_id = 28
  []
  [IFA_6_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1041 1044 1046'
    material_id = 28
  []

######################################################################################
##### MATERIAL 29: IFA_6_2_7 #########################################################
######################################################################################

  [IFA_7_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1047'
    material_id = 29
  []

  [IFA_7_ifa_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1051'
    material_id = 29
  []

  [IFA_7_insu_void]
    type = VoidNeutronicsMaterial
    block = '1048 1050 1052 1055'
  []
  [IFA_7_insu_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1049 1053'
    material_id = 29
  []
  [IFA_7_insu_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1054'
    material_id = 29
  []
  [IFA_7_insu_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1056 1058 1059 1061'
    material_id = 29
  []
  [IFA_7_insu_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1057 1060 1062'
    material_id = 29
  []

######################################################################################
##### MATERIAL 30: IFA_6_2_9 #########################################################
######################################################################################
 # both ifa and standard rods are fuel in this region ## 979 used to aviod quad tri writing error
   [IFA_9_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1063 1067 979'
    material_id = 30
  []

  [IFA_9_void]
    type = VoidNeutronicsMaterial
    block = '1064 1066 1068 1071 9799'
  []
  [IFA_9_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1065 1069'
    material_id = 30
  []
  [IFA_9_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1070'
    material_id = 30
  []
  [IFA_9_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1072 1074 1075 1077'
    material_id = 30
  []
  [IFA_9_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1073 1076 1078'
    material_id = 30
  []

######################################################################################
##### MATERIAL 31: IFA_6_2_10 #########################################################
######################################################################################

  [IFA_10_stand_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1079'
    material_id = 31
  []

  [IFA_10_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1083'
    material_id = 31
  []

  [IFA_10_void]
    type = VoidNeutronicsMaterial
    block = '1080 1082 1084 1087'
  []
  [IFA_10_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1081 1085'
    material_id = 31
  []
  [IFA_10_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1086'
    material_id = 31
  []
  [IFA_10_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1088 1090 1091 1093'
    material_id = 31
  []
  [IFA_10_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1089 1092 1094'
    material_id = 31
  []

######################################################################################
##### MATERIAL 32: IFA_6_2_11 ########################################################
######################################################################################
 # ifa: void , standard: fuel
   [IFA_11_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1095'
    material_id = 32
  []
  [IFA_11_void]
    type = VoidNeutronicsMaterial
    block = '1099 1096 1098 1100 1103'

  []
  [IFA_11_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1097 1101'
    material_id = 32
  []
  [IFA_11_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1102'
    material_id = 32
  []
  [IFA_11_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1104 1106 1107 1109'
    material_id = 32
  []
  [IFA_11_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1105 1108 1110'
    material_id = 32
  []

######################################################################################
##### MATERIAL 33: IFA_6_2_12 ########################################################
######################################################################################

   [IFA_12_stand_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1111'
    material_id = 33
  []

   [IFA_12_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1115'
    material_id = 33
  []

  [IFA_12_void]
    type = VoidNeutronicsMaterial
    block = '1112 1114 1116 1119'
  []
  [IFA_12_fuelTC_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1113 1117'
    material_id = 33
  []
  [IFA_12_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1118'
    material_id = 33
  []
  [IFA_12_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1120 1122 1123 1125'
    material_id = 33
  []
  [IFA_12_insu_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1121 1124 1126'
    material_id = 33
  []

######################################################################################
##### MATERIAL 34: IFA_6_2_13 ########################################################
######################################################################################
  # both standard and ifa rods are fuel
  [IFA_13_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1127 1131'
    material_id = 34
  []
  [IFA_13_void]
    type = VoidNeutronicsMaterial
    block = '1128 1130 1132 1135'
  []
  [IFA_13_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1129 1133'
    material_id = 34
  []
  [IFA_13_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1134'
    material_id = 34
  []
  [IFA_13_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1136 1138 1139 1141'
    material_id = 34
  []
  [IFA_13_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1137 1140 1142'
    material_id = 34
  []

######################################################################################
##### MATERIAL 35: IFA_6_2_14 # MAt 37: IFA_6_2_16 is used instead ###################
######################################################################################
  [IFA_14_std_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1143'
    material_id = 37
  []

  [IFA_14_ifa_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1147'
    material_id = 37
  []

  [IFA_14_void]
    type = VoidNeutronicsMaterial
    block = '1144 1146 1148 1151'
  []
  [IFA_14_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1145 1149'
    material_id = 37
  []
  [IFA_14_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1150'
    material_id = 37
  []
  [IFA_14_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1152 1154 1155 1157'
    material_id = 37
  []
  [IFA_14_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1153 1156 1158'
    material_id = 37
  []

######################################################################################
##### MATERIAL 36: IFA_6_2_15 ########################################################
######################################################################################
 # ifa: void , stand: fuel
  [IFA_15_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1159 '
    material_id = 36
  []
  [IFA_15_void]
    type = VoidNeutronicsMaterial
    block = '1163 1160 1162 1164 1167'
  []
  [IFA_15_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1161 1165'
    material_id = 36
  []
  [IFA_15_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1166'
    material_id = 36
  []
  [IFA_15_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1168 1170 1171 1173'
    material_id = 36
  []
  [IFA_15_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1169 1172 1174'
    material_id = 36
  []

######################################################################################
##### MATERIAL 37: IFA_6_2_16 ########################################################
######################################################################################
  [IFA_16_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1175'
    material_id = 37
  []

  [IFA_16_ifa_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1179'
    material_id = 37
  []

  [IFA_16_void]
    type = VoidNeutronicsMaterial
    block = '1176 1178 1180 1183'
  []
  [IFA_16_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1177 1181'
    material_id = 37
  []
  [IFA_16_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1182'
    material_id = 37
  []
  [IFA_16_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1184 1186 1187 1189'
    material_id = 37
  []
  [IFA_16_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1185 1188 1190'
    material_id = 37
  []

######################################################################################
##### MATERIAL 38: IFA_6_2_18 ########################################################
######################################################################################
  [IFA_18_stand_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1191'
    material_id = 38
  []
  [IFA_18_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1195'
    material_id = 38
  []
  [IFA_18_FuelTC_void]
    type = VoidNeutronicsMaterial
    block = '1192 1194 1196 1199'
  []
  [IFA_18_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1193 1197'
    material_id = 38
  []
  [IFA_18_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1198'
    material_id = 38
  []
  [IFA_18_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1200 1202 1203 1205'
    material_id = 38
  []
  [IFA_18_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1201 1204 1206'
    material_id = 38
  []

######################################################################################
##### MATERIAL 39: IFA_6_2_19 ########################################################
######################################################################################

  [IFA_19_stand_insul]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1207'
    material_id = 39
  []
   [IFA_19_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = '1211'
    material_id = 39
  []

  [IFA_19_void]
    type = VoidNeutronicsMaterial
    block = '1208 1210 1212 1215'
  []
  [IFA_19_FuelTC_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1209 1213'
    material_id = 39
  []
  [IFA_19_beo]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'BE9 O16'
    densities = '6.84143E-02  6.84143E-02'
    block = '1214'
    material_id = 39
  []
  [IFA_19_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1216 1218 1219 1221'
    material_id = 39
  []
  [IFA_19_FuelTC_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1217 1220 1222'
    material_id = 39
  []

######################################################################################
##### MATERIAL 40: IFA_6_2_20 ########################################################
######################################################################################
  [IFA_20_stand_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1223'
    material_id = 40
  []

  [IFA_20_ifa_fuel]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'PU239         PU240         U235          U238          O16'
    densities = '4.08031E-03  3.66406E-04   3.83521E-05   1.73945E-02   4.37142E-02'
    block = ' 1227'
    material_id = 40
  []

  [IFA_20_void]
    type = VoidNeutronicsMaterial
    block = '1224 1226 1228 1231'
  []
  [IFA_20_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1225 1229'
    material_id = 40
  []
  [IFA_20_beo_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1230'
    material_id = 40
  []
  [IFA_20_wire_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1235'
    material_id = 40
  []
  [IFA_20_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1232 1234 1237'
    material_id = 40
  []
  [IFA_20_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1233 1236 1238'
    material_id = 40
  []

######################################################################################
##### MATERIAL 41: IFA_6_2_21 & MAT 24: IFA_6_2_1 is used instead ####################
######################################################################################

  [IFA_21_std_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1239'
    material_id = 24
  []
  [IFA_21_ifa_insu]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'U235          U238          O16'
    densities = '4.92079E-05   2.23181E-02   4.47347E-02'
    block = '1243'
    material_id = 24
  []

  [IFA_21_void]
    type = VoidNeutronicsMaterial
    block = '1240 1242 1244 1247'
  []
  [IFA_21_insuTC_ss316]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'CR50 CR52 CR53 CR54 FE54
                FE56 FE57 FE58 MO100 MO92
                MO94 MO95 MO96 MO97 MO98
                NI58 NI60 NI61 NI62 NI64'
    densities = '6.90859E-04  1.33222E-02   1.51071E-03   3.76040E-04   3.41037E-03
                 5.35351E-02  1.23633E-03   1.64532E-04   1.22044E-04   1.88080E-04
                 1.17230E-04  2.01769E-04   2.11398E-04   1.21032E-04   3.05815E-04
                 7.61491E-03  2.93327E-03   1.27504E-04   4.06546E-04   1.03540E-04'
    block = '1241 1245'
    material_id = 24
  []
  [IFA_21_beo_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1246'
    material_id = 24
  []
  [IFA_21_wire_ni]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NI58  NI60  NI61  NI62  NI64'
    densities = '5.93541E-02  2.28635E-02   9.93799E-04   3.16883E-03   8.07005E-04'
    block = '1251'
    material_id = 24
  []

  [IFA_21_ss304]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes =  'CR50   CR52   CR53   CR54   FE54
                 FE56   FE57   FE58   NI58   NI60
                 NI61   NI62   NI64'
    densities = '8.17351E-04  1.57623E-02   1.78728E-03   4.44885E-04   3.48075E-03
                 5.46400E-02  1.26184E-03   1.67927E-04   6.80694E-03   2.62205E-03
                 1.13973E-04  3.63413E-04   9.25497E-05'
    block = '1248 1250 1253'
    material_id = 24
  []
  [IFA_21_na]
    type = CoupledFeedbackNeutronicsMaterial
    isotopes = 'NA23'
    densities = '2.39160E-02'
    block = '1249 1252 1254'
    material_id = 24
  []

###########################################################################################
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-6
  richardson_rel_tol = 1e-20
  richardson_value = eigenvalue
  richardson_max_its = 1000

  inner_solve_type = GMRes
  max_inner_its = 1000

  cmfd_acceleration = false
  prolongation_type = multiplicative

  abs_eig_tol = 1e-6
[]

[Postprocessors]

[]

[Outputs]
  csv = true
  perf_graph = true
  exodus = false
  checkpoint = false
  nemesis = false
[]
