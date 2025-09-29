[Postprocessors]
  [temp-1]
    type = SubChannelPointValue
    variable = T
    index = 527
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-2]
    type = SubChannelPointValue
    variable = T
    index = 240
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-3]
    type = SubChannelPointValue
    variable = T
    index = 112
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-4]
    type = SubChannelPointValue
    variable = T
    index = 4
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-5]
    type = SubChannelPointValue
    variable = T
    index = 1
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-6]
    type = SubChannelPointValue
    variable = T
    index = 75
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-7]
    type = SubChannelPointValue
    variable = T
    index = 258
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  [temp-8]
    type = SubChannelPointValue
    variable = T
    index = 497
    execute_on = 'TIMESTEP_END'
    height = 4.8
  []
  ####### Assembly pressure drop
  [DP_SubchannelDelta]
    type = SubChannelDelta
    variable = P
    execute_on = 'TIMESTEP_END'
  []
  ##### Average temperature on plane
  [Mean_Temp]
    type = SCMPlanarMean
    variable = T
    height = 4.8
    execute_on = 'TIMESTEP_END'
  []
  #### Duct contribution to total power that goes into/out of the fluid
  [Total_Net_Power_Through_Duct]
    type = SCMDuctHeatRatePostprocessor
    execute_on ='transfer'
  []
  #### Total net power that goes into/out of the fluid
  [Total_coolant_power]
    type = SCMTHPowerPostprocessor
  []
[]
