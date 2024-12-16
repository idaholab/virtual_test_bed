################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Multiphysics Steady State                                           ##
## BISON thermomechanics (Child App)                                          ##
## Meta Input File with Parameters                                            ##
################################################################################

# References
# poston: "Krusty Reactor Design"
# iaea: "Material Properties of Unirradiated Uranium\u2013 Molybdenum (U\u2013Mo) Fuel for Research Reactors"
# iaea2: "Thermophysical Properties of Materials For Nuclear Engineering: A Tutorial and Collection of Data"
# rest: "U-Mo Fuels Handbook"

# blocks_all = '1 2 3 4 5 6 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 64 71 72 73 1212 2081 2082 2091 2092 2101 2102 2111 2112 2121 2122 2131 2132 2141 2142 3081 3082 3091 3092 3101 3102 3111 3112 3121 3122 3131 3132 3141 3142 4081 4082 4091 4092 4101 4102 4111 4112 4121 4122 4131 4132 4141 4142'
no_void = '2 3 4 5 6 8 9 11 12 13 14 15 16 17 18 19 20 21 22 23 24 71 72 73 1212 2081 2082 2091 2092 2101 2102 2111 2112 2121 2122 2131 2132 2141 2142 3081 3082 3091 3092 3101 3102 3111 3112 3121 3122 3131 3132 3141 3142 4081 4082 4091 4092 4101 4102 4111 4112 4121 4122 4131 4132 4141 4142'
fuel_all = '2081 2082 2091 2092 2101 2102 2111 2112 2121 2122 2131 2132 2141 2142 3081 3082 3091 3092 3101 3102 3111 3112 3121 3122 3131 3132 3141 3142 4081 4082 4091 4092 4101 4102 4111 4112 4121 4122 4131 4132 4141 4142'
## fuel_names = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08 fuel_09 fuel_10
##               fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16 fuel_17 fuel_18 fuel_19 fuel_20
##               fuel_21 fuel_22 fuel_23 fuel_24 fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30
##               fuel_31 fuel_32 fuel_33 fuel_34 fuel_35 fuel_36 fuel_37 fuel_38 fuel_39 fuel_40
##               fuel_41 fuel_42'

Be_all = '14'
## Be_names = 'Be_01'
Al_all = '11 13 16' # currenly using Al 6061 properites
## Al_names = 'Al_01 Al_02 Al_03'
hp_all = '10'
## hp_names = 'hp_01'
beo_all = '12 1212 17 9'
## beo_names = 'beo_01 beo_02 beo_03 beo_04'
# ss_all includes the ss304 ss316 and cast iron
ss_all = '2 3 4 6 71 72 73 8 15 18 19 20 22 23 24' # remove 14; it is Be
## ss_names = 'ss_01 ss_02 ss_03 ss_04 ss_05 ss_06 ss_07 ss_08 ss_09 ss_10 ss_11 ss_12 ss_13 ss_14 ss_15'
b4c_all = '5 21'
## b4c_names = 'b4c_01 b4c_02'
air_all = '1'
## air_names = 'air_01'
hp_fuel_gap_all = '64'
hp_fuel_gap_names = 'hp_fuel_gap'
hp_mli_all = '999 998'
hp_mli_names = 'hp_mli hp_mli_2'

nonfuel_all = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} ${hp_mli_all}'
nonfuel_mech = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all}'
non_ss_998_all = '${fuel_all} ${Be_all} ${Al_all} ${hp_all} ${beo_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} 999'

umo_dens = 17340 # from poston
umo_ym = 54.3e9 # from iaea
umo_pr = 0.35 # INL/CON-11-22390

beo_dens = 2870.0 # from iaea2
ss_dens = 7950
al_dens = 2700

air_cond = 0.001 # ~1 Pa vacuum https://doi.org/10.1016/j.egypro.2016.06.196
air_sph = 1000.6 # engineering toolbox 0 C, J/kg/K
air_dens = 1.276e-5 # kg/m3 engineering toolbox scaled to 1e-5 atm (1Pa)

hp_fuel_couple_cond = 12 # number used by LANL
hp_fuel_couple_sph = 1000.6 # same as air
hp_fuel_couple_dens = 1.276 # same as air

hp_mli_cond = 0.001
hp_mli_sph = 1000.6 # same as air
hp_mli_dens = 1.276 # same as air

b4c_dens = 2510
b4c_ym = 4.48e11
b4c_pr = 0.21
b4c_exp = 4.5e-6
b4c_cond = 92
b4c_sph = 960.0

Be_dens = 1824
Be_ym = 2.53e11
Be_pr = 0.07
Be_exp = 17.3e-6
Be_cond = 91
Be_sph = 3103.0
