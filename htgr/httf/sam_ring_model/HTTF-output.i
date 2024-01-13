# ==============================================================================
# High Temperature Transient Facility
# HTTF benchmark PCC Exercise 1A
# SAM input file
# -- Postprocessors and Outputs sub-input
# ------------------------------------------------------------------------------
# ANL, 09/2023
# Author(s): Dr. Thanh Hua
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[Postprocessors]
  [R2C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL2(in)
  []
  [R2C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU2(out)
  []
  [R2C_F]
    type = ComponentBoundaryFlow
    input = RU2(out)
  []
  [R2C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU2(out)
  []
  [R4C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL4(in)
  []
  [R4C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU4(out)
  []
  [R4C_F]
    type = ComponentBoundaryFlow
    input = RU4(out)
  []
  [R4C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU4(out)
  []
  [R8C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL8(in)
  []
  [R8C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU8(out)
  []
  [R8C_F]
    type = ComponentBoundaryFlow
    input = RU8(out)
  []
  [R8C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU8(out)
  []
  [R12C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL12(in)
  []
  [R12C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU12(out)
  []
  [R12C_F]
    type = ComponentBoundaryFlow
    input = RU12(out)
  []
  [R12C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU12(out)
  []
  [R16C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL16(in)
  []
  [R16C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU16(out)
  []
  [R16_F]
    type = ComponentBoundaryFlow
    input = RU16(out)
  []
  [R16C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU16(out)
  []
  [R20C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL20(in)
  []
  [R20C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU20(out)
  []
  [R20C_F]
    type = ComponentBoundaryFlow
    input = RU20(out)
  []
  [R20C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU20(out)
  []
  [R24C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL24(in)
  []
  [R24C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU24(out)
  []
  [R24C_F]
    type = ComponentBoundaryFlow
    input = RU24(out)
  []
  [R24C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU24(out)
  []
  [R28C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL28(in)
  []
  [R28C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU28(out)
  []
  [R28C_F]
    type = ComponentBoundaryFlow
    input = RU28(in)
  []
  [R28C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU28(out)
  []
  [R32C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL32(in)
  []
  [R32C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU32(out)
  []
  [R32C_F]
    type = ComponentBoundaryFlow
    input = RU32(out)
  []
  [R32C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU32(out)
  []
  [R36C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL36(in)
  []
  [R36C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU36(out)
  []
  [R36C_F]
    type = ComponentBoundaryFlow
    input = RU36(out)
  []
  [R36C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU36(out)
  []
  [R40C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL40(in)
  []
  [R40C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU40(out)
  []
  [R40C_F]
    type = ComponentBoundaryFlow
    input = RU40(out)
  []
  [R40C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU40(out)
  []
  [R44C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL44(in)
  []
  [R44C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU44(out)
  []
  [R44C_F]
    type = ComponentBoundaryFlow
    input = RU44(out)
  []
  [R44C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU44(out)
  []
  [R46C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL46(in)
  []
  [R46C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU46(out)
  []
  [R46C_F]
    type = ComponentBoundaryFlow
    input = RU46(out)
  []
  [R46C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU46(out)
  []
  [R52C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL52(in)
  []
  [R52C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RU52(out)
  []
  [R52C_F]
    type = ComponentBoundaryFlow
    input = RU52(out)
  []
  [R52C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RU52(out)
  []
  [R54C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RT54(out)
  []
  [R54C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RL54(in)
  []
  [R54C_F]
    type = ComponentBoundaryFlow
    input = R54(in)
  []
  [R54C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R54(out)
  []
  [R54_E]
    type = ComponentBoundaryEnergyBalance
    eos = air_eos
    input = 'RL54(in) RT54(out)'
  []
  [R56C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RT56(out)
  []
  [R56C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = RB56(in)
  []
  [R56C_F]
    type = ComponentBoundaryFlow
    input = RB56(in)
  []
  [R56C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = RT56(out)
  []
  [R56_E]
    type = ComponentBoundaryEnergyBalance
    eos = water_eos
    input = 'RB56(in) RT56(out)'
  []

  [inpipe_V]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = inpipe(in)
  []
  [inpipe_F]
    type = ComponentBoundaryFlow
    input = inpipe(out)
  []
  [inpipe_Tin]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = inpipe(in)
  []
  [outpipe_F]
    type = ComponentBoundaryFlow
    input = outpipe(out)
  []
  [outpipe_Tout]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = outpipe(out)
  []
  [outpipe_E]
    type = ComponentBoundaryEnergyBalance
    input = 'inpipe(in) outpipe(out)'
    eos = eos
  []

  [max_R1]
    type = NodalExtremeValue
    block = 'R1:hs0'
    variable = T_solid
  []

  [max_R3]
    type = NodalExtremeValue
    block = 'R3:hs0'
    variable = T_solid
  []

  [max_R5]
    type = NodalExtremeValue
    block = 'R5:hs0'
    variable = T_solid
  []

  [max_R7]
    type = NodalExtremeValue
    block = 'R7:hs0'
    variable = T_solid
  []

  [max_R9]
    type = NodalExtremeValue
    block = 'R9:hs0'
    variable = T_solid
  []

  [max_R11]
    type = NodalExtremeValue
    block = 'R11:hs0'
    variable = T_solid
  []

  [max_R13]
    type = NodalExtremeValue
    block = 'R13:hs0'
    variable = T_solid
  []

  [max_R15]
    type = NodalExtremeValue
    block = 'R15:hs0'
    variable = T_solid
  []

  [max_R17]
    type = NodalExtremeValue
    block = 'R17:hs0'
    variable = T_solid
  []

  [max_R19]
    type = NodalExtremeValue
    block = 'R19:hs0'
    variable = T_solid
  []

  [max_R21]
    type = NodalExtremeValue
    block = 'R21:hs0'
    variable = T_solid
  []

  [max_R23]
    type = NodalExtremeValue
    block = 'R23:hs0'
    variable = T_solid
  []

  [max_R25]
    type = NodalExtremeValue
    block = 'R25:hs0'
    variable = T_solid
  []

  [max_R27]
    type = NodalExtremeValue
    block = 'R27:hs0'
    variable = T_solid
  []

  [max_R29]
    type = NodalExtremeValue
    block = 'R29:hs0'
    variable = T_solid
  []

  [max_R31]
    type = NodalExtremeValue
    block = 'R31:hs0'
    variable = T_solid
  []

  [max_R33]
    type = NodalExtremeValue
    block = 'R33:hs0'
    variable = T_solid
  []

  [max_R35]
    type = NodalExtremeValue
    block = 'R35:hs0'
    variable = T_solid
  []

  [max_R37]
    type = NodalExtremeValue
    block = 'R37:hs0'
    variable = T_solid
  []

  [max_R39]
    type = NodalExtremeValue
    block = 'R39:hs0'
    variable = T_solid
  []

  [max_R41]
    type = NodalExtremeValue
    block = 'R41:hs0'
    variable = T_solid
  []

  [max_R43]
    type = NodalExtremeValue
    block = 'R43:hs0'
    variable = T_solid
  []

  [max_R45]
    type = NodalExtremeValue
    block = 'R45:hs0'
    variable = T_solid
  []

  [max_R47]
    type = NodalExtremeValue
    block = 'R47:hs0'
    variable = T_solid
  []

  [max_R49]
    type = NodalExtremeValue
    block = 'R49:hs0'
    variable = T_solid
  []

  [ave_R1]
    type = ElementAverageValue
    block = 'R1:hs0'
    variable = T_solid
  []

  [ave_R3]
    type = ElementAverageValue
    block = 'R3:hs0'
    variable = T_solid
  []

  [ave_R5]
    type = ElementAverageValue
    block = 'R5:hs0'
    variable = T_solid
  []

  [ave_R7]
    type = ElementAverageValue
    block = 'R7:hs0'
    variable = T_solid
  []

  [ave_R9]
    type = ElementAverageValue
    block = 'R9:hs0'
    variable = T_solid
  []

  [ave_R11]
    type = ElementAverageValue
    block = 'R11:hs0'
    variable = T_solid
  []

  [ave_R13]
    type = ElementAverageValue
    block = 'R13:hs0'
    variable = T_solid
  []

  [ave_R15]
    type = ElementAverageValue
    block = 'R15:hs0'
    variable = T_solid
  []

  [ave_R17]
    type = ElementAverageValue
    block = 'R17:hs0'
    variable = T_solid
  []

  [ave_R19]
    type = ElementAverageValue
    block = 'R19:hs0'
    variable = T_solid
  []

  [ave_R21]
    type = ElementAverageValue
    block = 'R21:hs0'
    variable = T_solid
  []

  [ave_R23]
    type = ElementAverageValue
    block = 'R23:hs0'
    variable = T_solid
  []

  [ave_R25]
    type = ElementAverageValue
    block = 'R25:hs0'
    variable = T_solid
  []

  [ave_R27]
    type = ElementAverageValue
    block = 'R27:hs0'
    variable = T_solid
  []

  [ave_R29]
    type = ElementAverageValue
    block = 'R29:hs0'
    variable = T_solid
  []

  [ave_R31]
    type = ElementAverageValue
    block = 'R31:hs0'
    variable = T_solid
  []

  [ave_R33]
    type = ElementAverageValue
    block = 'R33:hs0'
    variable = T_solid
  []

  [ave_R35]
    type = ElementAverageValue
    block = 'R35:hs0'
    variable = T_solid
  []

  [ave_R37]
    type = ElementAverageValue
    block = 'R37:hs0'
    variable = T_solid
  []

  [ave_R39]
    type = ElementAverageValue
    block = 'R39:hs0'
    variable = T_solid
  []

  [ave_R41]
    type = ElementAverageValue
    block = 'R41:hs0'
    variable = T_solid
  []

  [ave_R43]
    type = ElementAverageValue
    block = 'R43:hs0'
    variable = T_solid
  []

  [ave_R45]
    type = ElementAverageValue
    block = 'R45:hs0'
    variable = T_solid
  []

  [ave_R47]
    type = ElementAverageValue
    block = 'R47:hs0'
    variable = T_solid
  []

  [ave_R49]
    type = ElementAverageValue
    block = 'R49:hs0'
    variable = T_solid
  []

  [Heater_R6]
    type = NodalExtremeValue
    block = 'R6:hs0'
    variable = T_solid
  []

  [Heater_R10]
    type = NodalExtremeValue
    block = 'R10:hs0'
    variable = T_solid
  []

  [Heater_R14]
    type = NodalExtremeValue
    block = 'R14:hs0'
    variable = T_solid
  []

  [Heater_R18]
    type = NodalExtremeValue
    block = 'R18:hs0'
    variable = T_solid
  []

  [Heater_R22]
    type = NodalExtremeValue
    block = 'R22:hs0'
    variable = T_solid
  []

  [Heater_R26]
    type = NodalExtremeValue
    block = 'R26:hs0'
    variable = T_solid
  []

  [Heater_R30]
    type = NodalExtremeValue
    block = 'R30:hs0'
    variable = T_solid
  []

  [Heater_R34]
    type = NodalExtremeValue
    block = 'R34:hs0'
    variable = T_solid
  []

  [Heater_R38]
    type = NodalExtremeValue
    block = 'R38:hs0'
    variable = T_solid
  []

  [Heater_R42]
    type = NodalExtremeValue
    block = 'R42:hs0'
    variable = T_solid
  []

  [HeaterAve_R6]
    type = ElementAverageValue
    block = 'R6:hs0'
    variable = T_solid
  []

  [HeaterAve_R10]
    type = ElementAverageValue
    block = 'R10:hs0'
    variable = T_solid
  []

  [HeaterAve_R14]
    type = ElementAverageValue
    block = 'R14:hs0'
    variable = T_solid
  []

  [HeaterAve_R18]
    type = ElementAverageValue
    block = 'R18:hs0'
    variable = T_solid
  []

  [HeaterAve_R22]
    type = ElementAverageValue
    block = 'R22:hs0'
    variable = T_solid
  []

  [HeaterAve_R26]
    type = ElementAverageValue
    block = 'R26:hs0'
    variable = T_solid
  []

  [HeaterAve_R30]
    type = ElementAverageValue
    block = 'R30:hs0'
    variable = T_solid
  []

  [HeaterAve_R34]
    type = ElementAverageValue
    block = 'R34:hs0'
    variable = T_solid
  []

  [HeaterAve_R38]
    type = ElementAverageValue
    block = 'R38:hs0'
    variable = T_solid
  []

  [HeaterAve_R42]
    type = ElementAverageValue
    block = 'R42:hs0'
    variable = T_solid
  []
  [PipeHeatRemovalRate_R2]
    type = ComponentBoundaryEnergyBalance
    input = 'RL2(in) RU2(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R4]
    type = ComponentBoundaryEnergyBalance
    input = 'RL4(in) RU4(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R8]
    type = ComponentBoundaryEnergyBalance
    input = 'RL8(in) RU8(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R12]
    type = ComponentBoundaryEnergyBalance
    input = 'RL12(in) RU12(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R16]
    type = ComponentBoundaryEnergyBalance
    input = 'RL16(in) RU16(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R20]
    type = ComponentBoundaryEnergyBalance
    input = 'RL20(in) RU20(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R24]
    type = ComponentBoundaryEnergyBalance
    input = 'RL24(in) RU24(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R28]
    type = ComponentBoundaryEnergyBalance
    input = 'RL28(in) RU28(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R32]
    type = ComponentBoundaryEnergyBalance
    input = 'RL32(in) RU32(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R36]
    type = ComponentBoundaryEnergyBalance
    input = 'RL36(in) RU36(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R40]
    type = ComponentBoundaryEnergyBalance
    input = 'RL40(in) RU40(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R44]
    type = ComponentBoundaryEnergyBalance
    input = 'RL44(in) RU44(out)'
    eos = eos
  []

  [PipeHeatRemovalRate_R46]
    type = ComponentBoundaryEnergyBalance
    input = 'RL46(in) RU46(out)'
    eos = eos
  []
[]

[VectorPostprocessors]
  [R1_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R1:hs0'
    sort_by = z
    outputs = 'R1_temp'
  []
  [R2_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R2'
    sort_by = z
    outputs = 'R2_temp'
  []
  [R3_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R3:hs0'
    sort_by = z
    outputs = 'R3_temp'
  []
  [R4_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R4'
    sort_by = z
    outputs = 'R4_temp'
  []
  [R5_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R5:hs0'
    sort_by = z
    outputs = 'R5_temp'
  []
  [R6_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R6:hs0'
    sort_by = z
    outputs = 'R6_temp'
  []
  [R7_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R7:hs0'
    sort_by = z
    outputs = 'R7_temp'
  []
  [R8_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R8'
    sort_by = z
    outputs = 'R8_temp'
  []
  [R9_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R9:hs0'
    sort_by = z
    outputs = 'R9_temp'
  []
  [R10_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R10:hs0'
    sort_by = z
    outputs = 'R10_temp'
  []
  [R11_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R11:hs0'
    sort_by = z
    outputs = 'R11_temp'
  []
  [R12_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R12'
    sort_by = z
    outputs = 'R12_temp'
  []
  [R13_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R13:hs0'
    sort_by = z
    outputs = 'R13_temp'
  []
  [R14_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R14:hs0'
    sort_by = z
    outputs = 'R14_temp'
  []
  [R15_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R15:hs0'
    sort_by = z
    outputs = 'R15_temp'
  []
  [R16_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R16'
    sort_by = z
    outputs = 'R16_temp'
  []
  [R17_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R17:hs0'
    sort_by = z
    outputs = 'R17_temp'
  []
  [R18_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R18:hs0'
    sort_by = z
    outputs = 'R18_temp'
  []
  [R19_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R19:hs0'
    sort_by = z
    outputs = 'R19_temp'
  []
  [R20_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R20'
    sort_by = z
    outputs = 'R20_temp'
  []
  [R21_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R21:hs0'
    sort_by = z
    outputs = 'R21_temp'
  []
  [R22_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R22:hs0'
    sort_by = z
    outputs = 'R22_temp'
  []
  [R23_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R23:hs0'
    sort_by = z
    outputs = 'R23_temp'
  []
  [RL23_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RL23:hs0'
    sort_by = z
    outputs = 'RL23_temp'
  []
  [RU23_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RU23:hs0'
    sort_by = z
    outputs = 'RU23_temp'
  []
  [R24_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R24'
    sort_by = z
    outputs = 'R24_temp'
  []
  [R25_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R25:hs0'
    sort_by = z
    outputs = 'R25_temp'
  []
  [R26_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R26:hs0'
    sort_by = z
    outputs = 'R26_temp'
  []
  [R27_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R27:hs0'
    sort_by = z
    outputs = 'R27_temp'
  []
  [R28_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R28'
    sort_by = z
    outputs = 'R28_temp'
  []
  [R29_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R29:hs0'
    sort_by = z
    outputs = 'R29_temp'
  []
  [R30_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R30:hs0'
    sort_by = z
    outputs = 'R30_temp'
  []
  [R31_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R31:hs0'
    sort_by = z
    outputs = 'R31_temp'
  []
  [R32_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R32'
    sort_by = z
    outputs = 'R32_temp'
  []
  [R33_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R33:hs0'
    sort_by = z
    outputs = 'R33_temp'
  []
  [R34_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R34:hs0'
    sort_by = z
    outputs = 'R34_temp'
  []
  [R35_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R35:hs0'
    sort_by = z
    outputs = 'R35_temp'
  []
  [R36_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R36'
    sort_by = z
    outputs = 'R36_temp'
  []
  [R37_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R37:hs0'
    sort_by = z
    outputs = 'R37_temp'
  []
  [R38_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R38:hs0'
    sort_by = z
    outputs = 'R38_temp'
  []
  [R39_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R39:hs0'
    sort_by = z
    outputs = 'R39_temp'
  []
  [R40_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R40'
    sort_by = z
    outputs = 'R40_temp'
  []
  [R41_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R41:hs0'
    sort_by = z
    outputs = 'R41_temp'
  []
  [R42_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R42:hs0'
    sort_by = z
    outputs = 'R42_temp'
  []
  [R43_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R43:hs0'
    sort_by = z
    outputs = 'R43_temp'
  []
  [R44_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R44'
    sort_by = z
    outputs = 'R44_temp'
  []
  [R45_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R45:hs0'
    sort_by = z
    outputs = 'R45_temp'
  []
  [R46_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R46'
    sort_by = z
    outputs = 'R46_temp'
  []
  [R47_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R47:hs0'
    sort_by = z
    outputs = 'R47_temp'
  []
  [R49_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R49:hs0'
    sort_by = z
    outputs = 'R49_temp'
  []
  [R51_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R51:hs0'
    sort_by = z
    outputs = 'R51_temp'
  []
  [R53_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R53:hs0'
    sort_by = z
    outputs = 'R53_temp'
  []
  [RL53_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RL53:hs0'
    sort_by = z
    outputs = 'RL53_temp'
  []
  [RU53_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RU53:hs0'
    sort_by = z
    outputs = 'RU53_temp'
  []
  [RB53_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RB53:hs0'
    sort_by = z
    outputs = 'RB53_temp'
  []
  [RT53_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RT53:hs0'
    sort_by = z
    outputs = 'RT53_temp'
  []
  [R54_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R54'
    sort_by = z
    outputs = 'R54_temp'
  []
  [R55_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'R55:hs0'
    sort_by = z
    outputs = 'R55_temp'
  []
  [RL55_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RL55:hs0'
    sort_by = z
    outputs = 'RL55_temp'
  []
  [RU55_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RU55:hs0'
    sort_by = z
    outputs = 'RU55_temp'
  []
  [RB55_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RB55:hs0'
    sort_by = z
    outputs = 'RB55_temp'
  []
  [RT55_temp]
    type = NodalValueSampler
    variable = T_solid
    block = 'RT55:hs0'
    sort_by = z
    outputs = 'RT55_temp'
  []
  [R56_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'R56'
    sort_by = z
    outputs = 'R56_temp'
  []
  [RL56_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'RL56'
    sort_by = z
    outputs = 'RL56_temp'
  []
  [RU56_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'RU56'
    sort_by = z
    outputs = 'RU56_temp'
  []
  [RB56_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'RB56'
    sort_by = z
    outputs = 'RB56_temp'
  []
  [RT56_temp]
    type = NodalValueSampler
    variable = temperature
    block = 'RT56'
    sort_by = z
    outputs = 'RT56_temp'
  []
[]

[Outputs]
  [R1_temp]
    type = CSV
    file_base = ceramic/R1_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R3_temp]
    type = CSV
    file_base = ceramic/R3_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R5_temp]
    type = CSV
    file_base = ceramic/R5_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R7_temp]
    type = CSV
    file_base = ceramic/R7_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R9_temp]
    type = CSV
    file_base = ceramic/R9_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R11_temp]
    type = CSV
    file_base = ceramic/R11_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R13_temp]
    type = CSV
    file_base = ceramic/R13_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R15_temp]
    type = CSV
    file_base = ceramic/R15_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R17_temp]
    type = CSV
    file_base = ceramic/R17_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R19_temp]
    type = CSV
    file_base = ceramic/R19_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R21_temp]
    type = CSV
    file_base = ceramic/R21_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R23_temp]
    type = CSV
    file_base = ceramic/R23_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RL23_temp]
    type = CSV
    file_base = ceramic/RL23_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RU23_temp]
    type = CSV
    file_base = ceramic/RU23_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R25_temp]
    type = CSV
    file_base = ceramic/R25_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R27_temp]
    type = CSV
    file_base = ceramic/R27_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R29_temp]
    type = CSV
    file_base = ceramic/R29_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R31_temp]
    type = CSV
    file_base = ceramic/R31_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R33_temp]
    type = CSV
    file_base = ceramic/R33_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R35_temp]
    type = CSV
    file_base = ceramic/R35_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R37_temp]
    type = CSV
    file_base = ceramic/R37_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R39_temp]
    type = CSV
    file_base = ceramic/R39_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R41_temp]
    type = CSV
    file_base = ceramic/R41_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R43_temp]
    type = CSV
    file_base = ceramic/R43_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R45_temp]
    type = CSV
    file_base = ceramic/R45_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R47_temp]
    type = CSV
    file_base = ceramic/R47_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R49_temp]
    type = CSV
    file_base = ceramic/R49_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R51_temp]
    type = CSV
    file_base = ceramic/R51_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R53_temp]
    type = CSV
    file_base = ceramic/R53_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RL53_temp]
    type = CSV
    file_base = ceramic/RL53_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RU53_temp]
    type = CSV
    file_base = ceramic/RU53_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RB53_temp]
    type = CSV
    file_base = ceramic/RB53_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RT53_temp]
    type = CSV
    file_base = ceramic/RT53_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R55_temp]
    type = CSV
    file_base = ceramic/R55_temp
    #    execute_on = 'timestep_end'
    sync_times = '0.0'
    sync_only = true
  []
  [RL55_temp]
    type = CSV
    file_base = ceramic/RL55_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RU55_temp]
    type = CSV
    file_base = ceramic/RU55_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RB55_temp]
    type = CSV
    file_base = ceramic/RB55_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RT55_temp]
    type = CSV
    file_base = ceramic/RT55_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R2_temp]
    type = CSV
    file_base = cool/R2_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R4_temp]
    type = CSV
    file_base = cool/R4_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R8_temp]
    type = CSV
    file_base = cool/R8_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R12_temp]
    type = CSV
    file_base = cool/R12_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R16_temp]
    type = CSV
    file_base = cool/R16_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R20_temp]
    type = CSV
    file_base = cool/R20_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R24_temp]
    type = CSV
    file_base = cool/R24_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R28_temp]
    type = CSV
    file_base = cool/R28_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R32_temp]
    type = CSV
    file_base = cool/R32_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R36_temp]
    type = CSV
    file_base = cool/R36_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R40_temp]
    type = CSV
    file_base = cool/R40_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R44_temp]
    type = CSV
    file_base = cool/R44_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R46_temp]
    type = CSV
    file_base = cool/R46_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R54_temp]
    type = CSV
    file_base = cool/R54_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R56_temp]
    type = CSV
    file_base = cool/R56_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RL56_temp]
    type = CSV
    file_base = cool/RL56_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RU56_temp]
    type = CSV
    file_base = cool/RU56_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RB56_temp]
    type = CSV
    file_base = cool/RB56_temp
    sync_times = '0.0'
    sync_only = true
  []
  [RT56_temp]
    type = CSV
    file_base = cool/RT56_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R6_temp]
    type = CSV
    file_base = rods/R6_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R10_temp]
    type = CSV
    file_base = rods/R10_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R14_temp]
    type = CSV
    file_base = rods/R14_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R18_temp]
    type = CSV
    file_base = rods/R18_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R22_temp]
    type = CSV
    file_base = rods/R22_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R26_temp]
    type = CSV
    file_base = rods/R26_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R30_temp]
    type = CSV
    file_base = rods/R30_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R34_temp]
    type = CSV
    file_base = rods/R34_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R38_temp]
    type = CSV
    file_base = rods/R38_temp
    sync_times = '0.0'
    sync_only = true
  []
  [R42_temp]
    type = CSV
    file_base = rods/R42_temp
    sync_times = '0.0'
    sync_only = true
  []

[]
