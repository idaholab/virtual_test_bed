#Thermal properties taken from contractor analysis
# normal-weight concrete
nwc_rho = 2403.00
nwc_cp = 880
nwc_k = 1.7

# heavy-weight concrete
hwc_rho = 3684.00
hwc_cp = 670
hwc_k = 2.77 

# water
water_rho = 998.0
water_cp = 4179
water_k = 6000.71 # Tuned to a high value to simulate flow with chilled water

# alumnium
al_rho = 2270
al_cp = 875
al_k = 175

# steel for reactor (cylinder) inside
#steel_rho = 7850 # from https://www.aqua-calc.com/page/density-table/substance/steel
#steel_cp = 434 # 304 Steel, from https://www.azom.com/properties.aspx?ArticleID=965
#steel_k = 60.5 # 304 Steel, from https://www.engineeringtoolbox.com/thermal-conductivity-metals-d_858.html

#Graphite properties (core is assumed to be graphite predominantly)
graphite_rho = 1850.00
graphite_cp = 1700.0
graphite_k = 100.0

# air
air_rho = 1.16
air_cp = 1007


# core insulation
#insulation_rho = 256
#insulation_cp = 1047
#insulation_k =  0.065

T_ref = 300 # reference temperature for density evaluation

[GlobalParams]
  temperature = T
  T_ref = ${T_ref}
[]

[Functions]
  # Copied from thermal_model/DOME_thermal.i
  [air_k_fn]
    type = PiecewiseLinear
    x = '300 350 400 450 500 550 600 650 700 800 900 1000 1100 1200 1300 1400 1500 1600 1700 1800 1900'
    y = '26.38 30 33.45 36.76 39.94 43.02 46.01 48.91 51.75 57.25 62.55 67.68 72.68 77.56 82.36 87.09 91.79 96.46 101.1 105.66 110.07  '
    scale_factor = 1e-3
  []
[]

[SolidProperties]
  [nwc_sp]
    type = ThermalFunctionSolidProperties
    rho = ${nwc_rho}
    cp = ${nwc_cp}
    k = ${nwc_k}
  []
  [hwc_sp]
    type = ThermalFunctionSolidProperties
    rho = ${hwc_rho}
    cp = ${hwc_cp}
    k = ${hwc_k}
  []
  [water_sp]
    type = ThermalFunctionSolidProperties
    rho = ${water_rho}
    cp = ${water_cp}
    k = ${water_k}
  []
  [al_sp]
    type = ThermalFunctionSolidProperties
    rho = ${al_rho}
    cp = ${al_cp}
    k = ${al_k}
  []
  [air_sp]
    type = ThermalFunctionSolidProperties
    rho = ${air_rho}
    cp = ${air_cp}
    k = air_k_fn
  []
  [graphite_sp]
    type = ThermalFunctionSolidProperties
    rho = ${graphite_rho}
    cp = ${graphite_cp}
    k = ${graphite_k}
  []
  #[insulation_sp]
  #  type = ThermalFunctionSolidProperties
  #  rho = ${insulation_rho}
  #  cp = ${insulation_cp}
  #  k = ${insulation_k}
  #[]
[]

[Materials]
  [nwc_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${nwc_blocks}
    sp = nwc_sp
  []
  [hwc_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${hwc_blocks}
    sp = hwc_sp
  []
  [water_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${water_blocks}
    sp = water_sp
  []
  [al_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${al_blocks}
    sp = al_sp
  []
  [air_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${air_blocks}
    sp = air_sp
  []
  [graphite_mat]
    type = ADConstantDensityThermalSolidPropertiesMaterial
    block = ${graphite_blocks}
    sp = graphite_sp
  []
  #[insulation_mat]
  #  type = ADConstantDensityThermalSolidPropertiesMaterial
  #  block = ${insulation_blocks}
  #  sp = insulation_sp
  #[]
[]
