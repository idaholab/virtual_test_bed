################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor with Na Working Fluid Steady State (Na-HPMR) SS     ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
################################################################################

# The majority of the input file is the same as the K-HPMR model
!include '../steady/HPMR_dfem_griffin_ss.i'

[AuxVariables]
  [Tf]
    initial_condition := 900
  []
  [Ts]
    initial_condition := 900
  []
  [nH]
    initial_condition = 1.94
    order = CONSTANT
    family = MONOMIAL
  []
[]

[GlobalParams]
  library_file := '../isoxml/HP-MR_XS_Na_HPMR.xml'
  library_name := 'HP-MR_XS'
  grid_names := 'Ts Tfuel H_content'
  grid_variables := 'Ts Tf nH'
[]
