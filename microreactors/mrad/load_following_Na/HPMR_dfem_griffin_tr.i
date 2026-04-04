################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor with Na Working Fluid load following (Na-HPMR) LF   ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
################################################################################

# The majority of the input file is the same as the K-HPMR model
!include HPMR_dfem_griffin_tr_base.i

[Mesh]
  # [fmg]
  #   file := 'griffin-mesh.cpr'
  #   skip_partitioning = true
  # []
  [fmg_id]
    subdomains := '200 203 100 103 301 303 10 503 201 101 400 401 250 600 601'
    extra_element_ids := '815 815 802 802 801 801 803 811 814 806 805 805 804 804 804;
                          815 815 802 802 801 801 803 811 814 806 805 805 804 804 804'
  []
  parallel_type = distributed
[]

[AuxVariables]
  [nH]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.94
  []
[]

[Materials]
  [mod]
    block := '200 203 100 103 301 303 10 503 201 400 401 250 600 601'
  []
  [mod_ss]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '101'
    densities = 0.342995 # ss+gap smeared
  []
[]

[GlobalParams]
  library_file := '../isoxml/Na-HPMR_Serpent_ENDFB80_g11_u804.xml'
  library_name := 'Na-HPMR_Serpent_ENDFB80_g11'
  grid_names := 'Tfuel Tmod ch'
  grid_variables := 'Tf Tm nH'
[]
