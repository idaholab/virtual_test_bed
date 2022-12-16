################################################################################
## HTGR LOOP (Prismatic MHTGR -GA)                                            ##
## SAM Single-Application                                                     ##
## 1D thermal hydraulics                                                      ##
## Primary + secondary loop                                                   ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

### For reactor trasients the following variables needs to change####
##1.  EHX coefficient
##2.  Pump Head =0, comment out desired mass flow rate
##3.  Power function (ppf_axial * power_history)
##4.  Restart from normal operating steady state results
##5.  Adjust Time steps for converging results
### END for reactor trasients #####
#The rings are named as follow
#R1- inner reflector
#R2,R3,R4: inner, miidle and outer fuel rings
#R5: permanent reflector
#R6: core barrel
#R7: RPV and RCCS
#RCCS: Reactor cavity cooling system
#-R: Right side, -L: Left Side, C: coolant channel, Gap: Gap betwen heat structures

#radius inner side surface of cylinder
rad_R-1  = 0
rad_Gap-1 = 1.48
rad_R2-1-L = 1.482
rad_R2C-1 = 1.498229683
rad_R2-1-R = 1.498250709
rad_R2-2-L = 1.514306234
rad_R2C-2  = 1.530193306
rad_R2-2-R = 1.530213893
rad_R2-3-L = 1.545937495
rad_R2C-3  = 1.561502777
rad_R2-3-R = 1.561522951
rad_R2-4-L = 1.576934402
rad_R2C-4  = 1.592196688
rad_R2-4-R = 1.592216473
rad_R2-5-L = 1.607333655
rad_R2C-5 = 1.622309977
rad_R2-5-R = 1.622329395
rad_R2-6-L = 1.637168546
rad_R2C-6 = 1.6518744
rad_R2-6-R = 1.65189347
rad_R2-7-L = 1.666469388
rad_R2C-7 = 1.680918916
rad_R2-7-R = 1.680937657
rad_R2-8-L = 1.69526387
rad_R2C-8 = 1.709470027
rad_R2-8-R = 1.709488455
rad_R2-9-L = 1.723577373
rad_R2C-9 = 1.737552055
rad_R2-9-R = 1.737570185
rad_R2-10-L = 1.751433221
rad_R2C-10  = 1.765187387
rad_R2-10-R = 1.765205233
rad_R2-11-L = 1.778852917
rad_R2C-11 = 1.792396687
rad_R2-11-R = 1.792414262
rad_Gap-2 = 1.805856326
rad_R3-1-L = 1.807856326
rad_R3C-1  = 1.823838346
rad_R3-1-R = 1.823855619
rad_R3-2-L = 1.839698654
rad_R3C-2 = 1.855406413
rad_R3-2-R = 1.855423391
rad_R3-3-L = 1.87099914
rad_R3C-3 = 1.886446289
rad_R3-3-R = 1.886462988
rad_R3-4-L = 1.901784537
rad_R3C-4 = 1.916983631
rad_R3-4-R = 1.917000064
rad_R3-5-L = 1.932079467
rad_R3C-5 = 1.947042086
rad_R3-5-R = 1.947058266
rad_R3-6-L = 1.961906652
rad_R3C-6  = 1.976643501
rad_R3-6-R = 1.976659438
rad_R3-7-L = 1.99128711
rad_R3C-7  = 2.00580811
rad_R3-7-R = 2.005823815
rad_R3-8-L = 2.020240331
rad_R3C-8  = 2.034554697
rad_R3-8-R = 2.034570181
rad_R3-9-L = 2.04878443
rad_R3C-9 = 2.062900739
rad_R3-9-R = 2.06291601
rad_R3-10-L = 2.076936273
rad_R3C-10 = 2.090862526
rad_R3-10-R = 2.090877592
rad_R3-11-L = 2.104711602
rad_R3C-11 = 2.118455273
rad_R3-11-R = 2.118470144
rad_Gap-3 = 2.13212513
rad_R4-1-L = 2.13412513
rad_R4C-1  = 2.147680584
rad_R4-1-R = 2.147695251
rad_R4-2-L = 2.161165591
rad_R4C-2 = 2.17455249
rad_R4-2-R = 2.174566977
rad_R4-3-L = 2.187871878
rad_R4C-3 = 2.201096357
rad_R4-3-R = 2.201110669
rad_R4-4-L = 2.214256082
rad_R4C-4 = 2.227323914
rad_R4-4-R = 2.227338057
rad_R4-5-L = 2.240329583
rad_R4C-5 = 2.253246205
rad_R4-5-R = 2.253260186
rad_R4-6-L = 2.266103105
rad_R4C-6 = 2.278873648
rad_R4-6-R = 2.278887472
rad_R4-7-L = 2.291586771
rad_R4C-7 = 2.304216081
rad_R4-7-R = 2.304229752
rad_R4-8-L = 2.316790144
rad_R4C-8 = 2.329282806
rad_R4-8-R = 2.32929633
rad_R4-9-L = 2.341722275
rad_R4C-9  = 2.354082631
rad_R4-9-R = 2.354096013
rad_R4-10-L = 2.366391738
rad_R4C-10  = 2.378623904
rad_R4-10-R = 2.378637148
rad_R4-11-L = 2.390806663
rad_R4C-11 = 2.402914547
rad_R4-11-R = 2.402927657
rad_Gap-4 = 2.414974771
rad_R5  = 2.416583017
rad_Gap-5 = 3.339415889
rad_R6   = 3.341415889
rad_R6C  = 3.392500574
rad_R7   = 3.487771894
rad_RCCS = 3.587771894

## Thickness
w_R-1  = 1.48
w_Gap-1  = 0.002
w_R2-1-L = 0.016229683
w_R2C-1  = 2.1026E-05
w_R2-1-R = 0.016055525
w_R2-2-L = 0.015887072
w_R2C-2  = 2.05868E-05
w_R2-2-R = 0.015723603
w_R2-3-L = 0.015565282
w_R2C-3  = 2.0174E-05
w_R2-3-R = 0.015411451
w_R2-4-L = 0.015262285
w_R2C-4  = 1.97851E-05
w_R2-4-R = 0.015117182
w_R2-5-L = 0.014976322
w_R2C-5  = 1.94178E-05
w_R2-5-R = 0.014839151
w_R2-6-L = 0.014705853
w_R2C-6  = 1.90703E-05
w_R2-6-R = 0.014575917
w_R2-7-L = 0.014449529
w_R2C-7  = 1.87408E-05
w_R2-7-R = 0.014326213
w_R2-8-L = 0.014206157
w_R2C-8  = 1.84278E-05
w_R2-8-R = 0.014088918
w_R2-9-L = 0.013974682
w_R2C-9  = 1.813E-05
w_R2-9-R = 0.013863037
w_R2-10-L = 0.013754166
w_R2C-10  = 1.78461E-05
w_R2-10-R = 0.013647683
w_R2-11-L = 0.01354377
w_R2C-11 = 1.75752E-05
w_R2-11-R = 0.013442064
w_Gap-2  = 0.002
w_R3-1-L = 0.015982021
w_R3C-1  = 1.72723E-05
w_R3-1-R = 0.015843035
w_R3-2-L = 0.015707759
w_R3C-2  = 1.69784E-05
w_R3-2-R = 0.015575748
w_R3-3-L = 0.015447149
w_R3C-3  = 1.6699E-05
w_R3-3-R = 0.015321549
w_R3-4-L = 0.015199095
w_R3C-4  = 1.6433E-05
w_R3-4-R = 0.015079403
w_R3-5-L = 0.014962619
w_R3C-5  = 1.61793E-05
w_R3-5-R = 0.014848386
w_R3-6-L = 0.014736849
w_R3C-6  = 1.5937E-05
w_R3-6-R = 0.014627672
w_R3-7-L = 0.014521
w_R3C-7  = 1.57053E-05
w_R3-7-R = 0.014416516
w_R3-8-L = 0.014314366
w_R3C-8  = 1.54834E-05
w_R3-8-R = 0.014214249
w_R3-9-L = 0.014116309
w_R3C-9  = 1.52707E-05
w_R3-9-R = 0.014020263
w_R3-10-L = 0.013926253
w_R3C-10 = 1.50664E-05
w_R3-10-R = 0.013834009
w_R3-11-L = 0.013743672
w_R3C-11 = 1.48702E-05
w_R3-11-R = 0.013654986
w_Gap-3  = 0.002
w_R4-1-L = 0.013555454
w_R4C-1  = 1.46678E-05
w_R4-1-R = 0.01347034
w_R4-2-L = 0.013386899
w_R4C-2  = 1.44866E-05
w_R4-2-R = 0.013304902
w_R4-3-L = 0.013224479
w_R4C-3  = 1.43119E-05
w_R4-3-R = 0.013145413
w_R4-4-L = 0.013067832
w_R4C-4  = 1.41434E-05
w_R4-4-R = 0.012991526
w_R4-5-L = 0.012916622
w_R4C-5  = 1.39807E-05
w_R4-5-R = 0.01284292
w_R4-6-L = 0.012770543
w_R4C-6  = 1.38234E-05
w_R4-6-R = 0.012699299
w_R4-7-L = 0.01262931
w_R4C-7  = 1.36714E-05
w_R4-7-R = 0.012560392
w_R4-8-L = 0.012492662
w_R4C-8  = 1.35243E-05
w_R4-8-R = 0.012425945
w_R4-9-L = 0.012360356
w_R4C-9  = 1.33818E-05
w_R4-9-R = 0.012295725
w_R4-10-L = 0.012232166
w_R4C-10  = 1.32437E-05
w_R4-10-R = 0.012169515
w_R4-11-L = 0.012107884
w_R4C-11 = 1.31099E-05
w_R4-11-R = 0.012047114
w_Gap-4  = 0.001608246
w_R5  = 0.922832872
w_Gap-5  = 0.002
w_R6   = 0.051084685
w_R6C  = 0.09527132
w_R7   = 0.1
w_RCCS   = 0.02

##Surface area density [1/m]
aw_R2-1-L = 170.9669542
aw_R2C-1 = 170.9693536
aw_R2-1-R = 172.801492
aw_R2-2-L = 174.6144078
aw_R2C-2  = 174.616757
aw_R2-2-R = 176.411019
aw_R2-3-L = 178.1872145
aw_R2C-3  = 178.1895166
aw_R2-3-R = 179.9481581
aw_R2-4-L = 181.6897778
aw_R2C-4  = 181.6920356
aw_R2-4-R = 183.4170973
aw_R2-5-L = 185.126085
aw_R2C-5 = 185.1283008
aw_R2-5-R = 186.8216356
aw_R2-6-L = 188.4997595
aw_R2C-6 = 188.5019356
aw_R2-6-R = 190.1652322
aw_R2-7-L = 191.8141061
aw_R2C-7 = 191.8162447
aw_R2-7-R = 193.4510468
aw_R2-8-L = 195.0721489
aw_R2C-8 = 195.0742518
aw_R2-8-R = 196.6819755
aw_R2-9-L = 198.2766634
aw_R2C-9 = 198.2787323
aw_R2-9-R = 199.8606801
aw_R2-10-L = 201.4302044
aw_R2C-10  = 201.4322408
aw_R2-10-R = 202.9896141
aw_R2-11-L = 204.5351295
aw_R2C-11 = 204.5371351
aw_R2-11-R = 206.0710446

aw_R3-1-L = 173.4358505
aw_R3C-1  = 173.4374929
aw_R3-1-R = 174.9440685
aw_R3-2-L = 176.4377801
aw_R3C-2 = 176.4393947
aw_R3-2-R = 177.9205529
aw_R3-3-L = 179.3894821
aw_R3C-3 = 179.3910701
aw_R3-3-R = 180.8480555
aw_R3-4-L = 182.2933963
aw_R3C-4 = 182.294959
aw_R3-4-R = 183.7289177
aw_R3-5-L = 185.1517712
aw_R3C-5 = 185.1533097
aw_R3-5-R = 186.5653002
aw_R3-6-L = 187.9666843
aw_R3C-6 = 187.9681998
aw_R3-6-R = 189.3592017
aw_R3-7-L = 190.7400598
aw_R3C-7 = 190.7415533
aw_R3-7-R = 192.1124757
aw_R3-8-L = 193.4736842
aw_R3C-8 = 193.4751565
aw_R3-8-R = 194.8268445
aw_R3-9-L = 196.169219
aw_R3C-9  = 196.1706712
aw_R3-9-R = 197.5039123
aw_R3-10-L = 198.8282136
aw_R3C-10  = 198.8296463
aw_R3-10-R = 200.1451759
aw_R3-11-L = 201.4521148
aw_R3C-11 = 201.4535289
aw_R3-11-R = 202.7520344

aw_R4-1-L = 204.2312627
aw_R4C-1  = 204.2326576
aw_R4-1-R = 205.5136043
aw_R4-2-L = 206.7866164
aw_R4C-2 = 206.787994
aw_R4-2-R = 208.0532086
aw_R4-3-L = 209.3107755
aw_R4C-3 = 209.3121365
aw_R4-3-R = 210.5621847
aw_R4-4-L = 211.8048554
aw_R4C-4 = 211.8062004
aw_R4-4-R = 213.0416149
aw_R4-5-L = 214.2699065
aw_R4C-5 = 214.2712359
aw_R4-5-R = 215.4925189
aw_R4-6-L = 216.7069192
aw_R4C-6 = 216.7082338
aw_R4-6-R = 217.9158593
aw_R4-7-L = 219.1168293
aw_R4C-7 = 219.1181294
aw_R4-7-R = 220.3125456
aw_R4-8-L = 221.5005213
aw_R4C-8 = 221.5018073
aw_R4-8-R = 222.6834385
aw_R4-9-L = 223.8588326
aw_R4C-9  = 223.8601052
aw_R4-9-R = 225.0293533
aw_R4-10-L = 226.1925573
aw_R4C-10  = 226.1938167
aw_R4-10-R = 227.351063
aw_R4-11-L = 228.5024486
aw_R4C-11 = 228.5036953
aw_R4-11-R = 229.649302

aw_R6  = 10.35099515
aw_R6C = 10.64168132
aw_R7  = 10.94679535

## Power (W)
power_total =600e6
power_fr_ring_one =0.013368984
power_fr_ring_two =0.016042781
power_fr_ring_three =0.016042781
power_density = 6656820.087
## Active core
    radial_nElem_1 = 2
    axial_nElem_1  = 10
    radial_nElem_R1and5  = 5  #inner and outer reflector radial points
    axial_length_1 = 7.93
##Upper Support core structure
    radial_nElem_2 = 2
    axial_nElem_2  = 3
    axial_length_2 = 1.617142857
##Lower Support core sturcture
    radial_nElem_3 = 2
    axial_nElem_3  = 3
    axial_length_3 = 4.04285714285714

## Uplenum and Lplenum height
    Uplenum_z = 10.2950
    Lplenum_z = -4.439257
####
   hGap_cond = 1e7 #gap heat conduction
   fric_coef = 0.016399
   wallHeatTrans_coef   =  4153.72
### RCCS
 h_air_natural_conv =  19.45   # for 1 m/s air flow (10.45-vel+10*sqrt(vel))
#### Heat Exchanger
  EHX_hCoef =  1.6129e5    # Heat echnager coefficent primary and secondary side
###
##flow area
area_ring_1 =  0.055061253
area_ring_2 = 0.066073504
area_ring_3 = 0.066073504
channel_dia  =  15.875e-3
aw_tot  = 2.05929086
Dh_tot  = 0.8096
tot_massFlowRate =  289.12  #(kg/s)
##
Ts_1= 623.15
v_1 = 2   #26.19
p_out = 70e5
T_out = 623.15  #1000
##
[GlobalParams]
    global_init_P = ${p_out}
    global_init_V = ${v_1}
    global_init_T = ${Ts_1}
    Tsolid_sf = 1e-3
#    gravity = '0 0 -9.8'

  [./PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
    pspg = false
    p_order = 1
    supg_max = true
  [../]
[]

[EOS]

  [./eos]
    type = PTFluidPropertiesEOS
#    type = HeEquationOfState
    p_0 = 70e5    # Pa
    fp = fluid_props1
  [../]

  [./eos_water]
    type = PTConstantEOS
    p_0 = 70e5    # Pa
    rho_0 = 905
    beta = 0
    cp = 4330
    h_0 = 705000
    T_0 = 439
    mu = 0.00016
    k = 0.68
  [../]

  [./eos_air]
    type = AirEquationOfState
  [../]

[]

[Functions]
  active = 'power_dist kf cpf kclad cpclad rhoclad kgraphite cpgraphite rhographite kHe cpHe rhoHe muHe HHe beta_fn time_stepper
            ppf_axial power_history pump_p_coastdown pump_s_coastdown flow_secondary flow_dhx vf_pipeU head_pumpU power_decay_fn'



[./time_stepper]
    type = PiecewiseLinear
#    x = ' 0    0.1   1     60    120  200   600   3000 6000  1e5  1e6 '
#    y =' 0.01 0.02 0.05  0.05  0.1  0.5   1     10    20    50  200'

    x = ' -500e3   -499999.9   -499999  -499998   -499940  -499600      -494000  0 '
    y =' 0.005       0.1        0.3      1           20        50        100     1000'
  [../]

  [./ppf_axial]
    type = PiecewiseLinear

    x = '0 0.793 1.586 2.379 3.172 3.965 4.758 5.551 6.344 7.137 7.93'
    y = '0.8 0.85 0.95 1.05 1.15 1.2 1.15 1.05 0.95 0.85 0.8'

    axis = x
  [../]

  [./power_history]
    type = PiecewiseLinear
 x ='0 1.5 3 4.5 6 7.5 9 10.5 12 13.5 15 16.5 18 19.5 21 22.5 24 25.5 27 28.5 30 31.5 33 34.5 36 37.5 39 40.5 42 43.5 45 46.5 48 49.5 51 52.5 54 55.5 57 58.5 60 61.5 63 64.5 66 67.5 69 70.5 72 73.5 75 76.5 78 79.5 81 82.5 84 85.5 87 88.5 90 1.00E+08'
 y ='1 0.983333333 0.966666667 0.95 0.933333333 0.916666667 0.9 0.883333333 0.866666667 0.85 0.833333333 0.816666667 0.8 0.783333333 0.766666667 0.75 0.733333333 0.716666667 0.7 0.683333333 0.666666667 0.65 0.633333333 0.616666667 0.6 0.583333333 0.566666667 0.55 0.533333333 0.516666667 0.5 0.483333333 0.466666667 0.45 0.433333333 0.416666667 0.4 0.383333333 0.366666667 0.35 0.333333333 0.316666667 0.3 0.283333333 0.266666667 0.25 0.233333333 0.216666667 0.2 0.183333333 0.166666667 0.15 0.133333333 0.116666667 0.1 0.083333333 0.066666667 0.05 0.033333333 0.016666667 0 0'

  [../]

  [./power_decay_fn]
    type = CompositeFunction
#    functions = 'power_history   ppf_axial'  # any number of functions [power fn(time) * axial profile)]
    functions = 'ppf_axial'  # any number of functions [power fn(time) * axial profile)]

  [../]


  [./pump_p_coastdown]
    type = PiecewiseLinear
 x ='-1.000E+06 0.00E+00 4.00E-01 8.00E-01 1.20E+00 1.60E+00 2.00E+00 2.40E+00 2.80E+00 3.20E+00 3.60E+00
 4.00E+00 4.40E+00 4.80E+00 5.20E+00 5.60E+00 6.00E+00 6.40E+00 6.80E+00 7.20E+00 7.60E+00
 8.000E+00 1.000E+01 2.000E+01 3.000E+01 4.000E+01 5.000E+01 6.000E+01 7.000E+01 8.000E+01 9.000E+01
 1.000E+02 1.100E+02 1.200E+02 1.300E+02 1.400E+02 1.500E+02 1.600E+02 1.700E+02 1.800E+02 1.900E+02
 2.000E+02 2.100E+02 2.200E+02 2.300E+02 2.400E+02 2.500E+02 2.600E+02 2.700E+02 2.800E+02 2.900E+02
 3.000E+02 3.100E+02 3.200E+02 3.300E+02 3.400E+02 3.500E+02 3.600E+02 3.700E+02 3.800E+02 3.900E+02
 4.000E+02 4.100E+02 4.200E+02 1.00E+05'

 y ='1.000E+00 1.000E+00 9.671E-01 9.355E-01 9.050E-01 8.757E-01 8.476E-01 8.205E-01 7.945E-01 7.695E-01 7.455E-01
 7.225E-01 7.004E-01 6.792E-01 6.590E-01 6.395E-01 6.209E-01 6.031E-01 5.860E-01 5.697E-01 5.540E-01
 5.396E-01 4.749E-01 2.753E-01 1.773E-01 1.219E-01 8.812E-02 6.655E-02 5.206E-02 4.181E-02 3.425E-02
 2.850E-02 2.401E-02 2.043E-02 1.754E-02 1.516E-02 1.317E-02 1.151E-02 1.009E-02 8.869E-03 7.816E-03
 6.898E-03 6.094E-03 5.382E-03 4.752E-03 4.192E-03 3.692E-03 3.253E-03 2.814E-03 2.480E-03 2.132E-03
 1.866E-03 1.621E-03 1.397E-03 1.190E-03 9.999E-04 8.248E-04 6.642E-04 5.175E-04 3.841E-04 2.637E-04
 1.558E-04 5.989E-05  0   0'

 scale_factor = 76460.561082082   #415100
  [../]

  [./pump_s_coastdown]
    type = PiecewiseLinear
 x ='-1.000E+06 0.00E+00 4.00E-01 8.00E-01 1.20E+00 1.60E+00 2.00E+00 2.40E+00 2.80E+00 3.20E+00 3.60E+00
 4.00E+00 4.40E+00 4.80E+00 5.20E+00 5.60E+00 6.00E+00 6.40E+00 6.80E+00 7.20E+00 7.60E+00
 8.000E+00 1.000E+01 2.000E+01 3.000E+01 4.000E+01 5.000E+01 6.000E+01 7.000E+01 8.000E+01 9.000E+01
 1.000E+02 1.100E+02 1.200E+02 1.300E+02 1.400E+02 1.500E+02 1.600E+02 1.700E+02 1.800E+02 1.900E+02
 2.000E+02 2.100E+02 2.200E+02 2.300E+02 2.400E+02 2.500E+02 2.600E+02 2.700E+02 2.800E+02 2.900E+02
 3.000E+02 3.100E+02 3.200E+02 3.300E+02 3.400E+02 3.500E+02 3.600E+02 3.700E+02 3.800E+02 3.900E+02
 4.000E+02 4.100E+02 4.200E+02 1.00E+05'

 y ='1.000E+00 1.000E+00 9.671E-01 9.355E-01 9.050E-01 8.757E-01 8.476E-01 8.205E-01 7.945E-01 7.695E-01 7.455E-01
 7.225E-01 7.004E-01 6.792E-01 6.590E-01 6.395E-01 6.209E-01 6.031E-01 5.860E-01 5.697E-01 5.540E-01
 5.396E-01 4.749E-01 2.753E-01 1.773E-01 1.219E-01 8.812E-02 6.655E-02 5.206E-02 4.181E-02 3.425E-02
 2.850E-02 2.401E-02 2.043E-02 1.754E-02 1.516E-02 1.317E-02 1.151E-02 1.009E-02 8.869E-03 7.816E-03
 6.898E-03 6.094E-03 5.382E-03 4.752E-03 4.192E-03 3.692E-03 3.253E-03 2.814E-03 2.480E-03 2.132E-03
 1.866E-03 1.621E-03 1.397E-03 1.190E-03 9.999E-04 8.248E-04 6.642E-04 5.175E-04 3.841E-04 2.637E-04
 1.558E-04 5.989E-05  0   0'

 scale_factor = 40300
  [../]

  [./flow_secondary]
    type = PiecewiseLinear
 x ='-1.000E+06 0         1      1e5'
 y = '-1259    -1259    0     0'
 scale_factor = 0.05  #0.002216 # 1/rhoA
  [../]

  [./flow_dhx]
    type = PiecewiseLinear
 x ='-1.000E+06  0    1     1e5'
 y = '0  0 -6.478   -6.478'
 scale_factor = 0.046 # 1/rhoA
  [../]

  [./power_dist]                                # Function name
    type = PiecewiseLinear                   # Function type
    axis = x                                 # X-co-ordinate is used for x

    x = '0 1e4'
    y = '1.0 1'

  [../]

  [./kf]        #fuel thermal conductivity (UO2); x- Temperature [K], y- Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
 x ='300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975 1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475 1500'
 y ='5.311159613 5.144723577 4.988633194 4.841971034 4.703926271 4.573779724 4.450891343 4.334689702 4.224663124 4.120352159 4.021343169 3.927262846 3.837773503 3.752569015 3.671371305 3.593927301 3.520006282 3.449397561 3.381908456 3.317362513 3.255597934 3.196466197 3.139830829 3.085566329 3.033557196 2.98369708 2.935888018 2.890039748 2.846069106 2.803899475 2.763460305 2.724686666 2.687518864 2.651902079 2.617786058 2.585124822 2.553876416 2.524002677 2.49546903 2.468244303 2.442300561 2.417612963 2.394159629 2.371921528 2.350882371 2.331028528 2.31234895 2.2948351 2.278480905'
  [../]

  [./cpf]        #fuel matrix specific heat (UO2); x- Temperature [K], y- sp. heat [J/kg-K]
    type = PiecewiseLinear
 x ='300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975 1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475 1500'
 y ='44.87198213 57.09373669 71.35471375 87.81224925 106.6236791 127.9463393 151.9375658 178.7546944 208.5550611 241.4960019 277.7348528 317.4289495 360.7356281 407.8122246 458.8160748 513.9045146 573.2348801 636.9645072 705.2507318 778.2508898 856.1223171 939.0223498 1027.108324 1120.537575 1219.467439 1324.055252 1434.458351 1550.83407 1673.339746 1802.132715 1937.370313 2079.209875 2227.808738 2383.324238 2545.91371 2715.73449 2892.943915 3077.69932 3270.158042 3470.477415 3678.814777 3895.327463 4120.172809 4353.508151 4595.490824 4846.278166 5106.027511 5374.896196 5653.041556'
  [../]


  [./kclad]        #clad therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
 x ='300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975 1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475 1500'
 y ='13.2092369 13.38551962 13.56795276 13.75674395 13.9521008 14.15423095 14.36334204 14.57964168 14.8033375 15.03463714 15.27374821 15.52087836 15.7762352 16.04002637 16.31245949 16.59374219 16.8840821 17.18368685 17.49276406 17.81152137 18.1401664 18.47890678 18.82795014 19.1875041 19.5577763 19.93897436 20.33130591 20.73497858 21.1502 21.57717779 22.01611959 22.46723301 22.9307257 23.40680527 23.89567936 24.3975556 24.9126416 25.441145 25.98327344 26.53923453 27.1092359 27.69348519 28.29219001 28.90555801 29.5337968 30.17711402 30.83571729 31.50981424 32.1996125'
  [../]

  [./cpclad]        #clad specific heat; x- Temperature [K], y- sp. heat [J/kg-K]
    type = PiecewiseLinear
 x ='300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975 1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475 1500'
 y ='286.38 288.94 291.5 294.06 296.62 299.18 301.74 304.3 306.86 309.42 311.98 314.54 317.1 319.66 322.22 324.78 327.34 329.9 332.46 335.02 337.58 340.14 342.7 345.26 347.82 350.38 352.94 355.5 358.06 360.62 363.18 365.74 336.785 335.2703125 333.95125 332.8278125 331.9 331.1678125 330.63125 330.2903125 330.145 330.1953125 330.44125 330.8828125 331.52 332.3528125 333.38125 334.6053125 336.025'
  [../]

  [./rhoclad]        #clad density; x- Temperature [K], y- density [kg/m3]
    type = PiecewiseLinear
 x ='300 325 350 375 400 425 450 475 500 525 550 575 600 625 650 675 700 725 750 775 800 825 850 875 900 925 950 975 1000 1025 1050 1075 1100 1125 1150 1175 1200 1225 1250 1275 1300 1325 1350 1375 1400 1425 1450 1475 1500'
 y ='6550.89 6547.1975 6543.505 6539.8125 6536.12 6532.4275 6528.735 6525.0425 6521.35 6517.6575 6513.965 6510.2725 6506.58 6502.8875 6499.195 6495.5025 6491.81 6488.1175 6484.425 6480.7325 6477.04 6473.3475 6469.655 6465.9625 6462.27 6458.5775 6454.885 6451.1925 6447.5 6443.8075 6440.115 6436.4225 6485.95 6481.3125 6476.675 6472.0375 6467.4 6462.7625 6458.125 6453.4875 6448.85 6444.2125 6439.575 6434.9375 6430.3 6425.6625 6421.025 6416.3875 6411.75'
  [../]



  [./kgraphite]        #G-348 graphite therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
 x ='295.75 374.15 472.45 574.75 674.75 774.75 874.75 974.85 1074.45 1173.95 1274.05'
 y ='133.02 128.54 117.62 106.03 96.7 88.61 82.22 76.52 71.78 67.88 64.26'
  [../]

  [./cpgraphite]        #G-348 graphite specific heat; x- Temperature [K], y- sp. heat [J/kg-K]
    type = PiecewiseLinear
 x ='295.75 374.15 472.45 574.75 674.75 774.75 874.75 974.85 1074.45 1173.95 1274.05'
 y ='726.19 933.15 1154.47 1341.07 1486.83 1603.53 1697.43 1773.6 1835.58 1886.68 1929.44'
  [../]

  [./rhographite]        #G-348 graphite density; x- Temperature [K], y- density [kg/m3]
    type = PiecewiseLinear
 x ='295.75 374.15 472.45 574.75 674.75 774.75 874.75 974.85 1074.45 1173.95 1274.05'
 y ='1888.5 1886.3 1883.5 1880.4 1877.2 1873.9 1870.5 1867 1863.4 1859.6 1855.7'
  [../]



  [./kHe]        #Helium therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
 x ='300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000 1020 1040 1060 1080 1100 1120 1140 1160 1180 1200 1220 1240 1260 1280 1300 1320 1340 1360 1380 1400 1420 1440 1460 1480 1500'
 y ='0.16053 0.16754 0.17444 0.18123 0.18792 0.19451 0.20102 0.20743 0.21377 0.22003 0.22622 0.23233 0.23838 0.24437 0.2503 0.25616 0.26198 0.26773 0.27344 0.27909 0.2847 0.29026 0.29578 0.30126 0.30669 0.31208 0.31743 0.32275 0.32802 0.33327 0.33847 0.34365 0.34879 0.3539 0.35897 0.36402 0.36904 0.37403 0.37899 0.38392 0.38883 0.39371 0.39856 0.40339 0.4082 0.41298 0.41774 0.42248 0.42719 0.43188 0.43655 0.4412 0.44583 0.45043 0.45502 0.45959 0.46414 0.46867 0.47318 0.47767 0.48215'
  [../]

  [./muHe]        #Helium viscosity; x- Temperature [K], y-viscosity [Pa.s]
    type = PiecewiseLinear
 x ='300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000 1020 1040 1060 1080 1100 1120 1140 1160 1180 1200 1220 1240 1260 1280 1300 1320 1340 1360 1380 1400 1420 1440 1460 1480 1500'
 y ='0.00002016 0.0002148 0.000021921 0.000022782 0.00002363 0.000024467 0.000025294 0.00002611 0.000026917 0.000027715 0.000028504 0.000029285 0.000030058 0.000030823 0.000031582 0.000032333 0.000033078 0.000033816 0.000034549 0.000035275 0.000035996 0.000036711 0.00003742 0.000038125 0.000038825 0.00003952 0.00004021 0.000040895 0.000041576 0.000042253 0.000042926 0.000043595 0.00004426 0.00004492 0.000045578 0.000046231 0.000046881 0.000047528 0.000048171 0.000048811 0.000049447 0.000050081 0.000050711 0.000051338 0.000051963 0.000052584 0.000053203 0.000053818 0.000054432 0.000055042 0.00005565 0.000056255 0.000056858 0.000057458 0.000058056 0.000058651 0.000059244 0.000059835 0.000060424 0.00006101 0.000061594'
  [../]


  [./cpHe]        #Helium specific heat; x- Temperature [K], y- sp. heat [J/kg-K]
    type = PiecewiseLinear
 x ='300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000 1020 1040 1060 1080 1100 1120 1140 1160 1180 1200 1220 1240 1260 1280 1300 1320 1340 1360 1380 1400 1420 1440 1460 1480 1500'
 y ='5188.5 5188 5187.6 5187.4 5187.2 5187.2 5187.1 5187.2 5187.2 5187.3 5187.4 5187.5 5187.6 5187.7 5187.8 5187.9 5188 5188.1 5188.2 5188.3 5188.4 5188.5 5188.7 5188.8 5188.8 5188.9 5189 5189.1 5189.2 5189.3 5189.4 5189.5 5189.5 5189.6 5189.7 5189.7 5189.8 5189.9 5189.9 5190 5190.1 5190.1 5190.2 5190.2 5190.3 5190.3 5190.4 5190.4 5190.5 5190.5 5190.6 5190.6 5190.7 5190.7 5190.7 5190.8 5190.8 5190.8 5190.9 5190.9 5190.9'
  [../]

  [./rhoHe]        #Helium  density; x- Temperature [K], y- density [kg/m3]
    type = PiecewiseLinear
 x ='300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000 1020 1040 1060 1080 1100 1120 1140 1160 1180 1200 1220 1240 1260 1280 1300 1320 1340 1360 1380 1400 1420 1440 1460 1480 1500'
 y ='10.883 10.225 9.6425 9.1224 8.6555 8.234 7.8516 7.5031 7.1842 6.8912 6.6212 6.3715 6.14 5.9246 5.7239 5.5363 5.3605 5.1956 5.0405 4.8944 4.7565 4.6262 4.5028 4.3858 4.2747 4.1691 4.0686 3.9729 3.8815 3.7942 3.7108 3.6309 3.5545 3.4811 3.4108 3.3432 3.2782 3.2157 3.1556 3.0976 3.0418 2.9879 2.9359 2.8857 2.8371 2.7902 2.7448 2.7009 2.6583 2.617 2.577 2.5383 2.5006 2.4641 2.4286 2.3941 2.3606 2.328 2.2963 2.2655 2.2354'
  [../]

  [./HHe]        #Helium  Enthalpy; x- Temperature [K], y- denthalpy [j/kg]
    type = PiecewiseLinear
 x ='300 320 340 360 380 400 420 440 460 480 500 520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000 1020 1040 1060 1080 1100 1120 1140 1160 1180 1200 1220 1240 1260 1280 1300 1320 1340 1360 1380 1400 1420 1440 1460 1480 1500'
 y ='1585700 1689500 1793300 1897000 2000800 2104500 2208200 2312000 2415700 2519500 2623200 2727000 2830700 2934500 3038200 3142000 3245700 3349500 3453300 3557000 3660800 3764600 3868300 3972100 4075900 4179700 4283400 4387200 4491000 4594800 4698600 4802400 4906200 5010000 5113700 5217500 5321300 5425100 5528900 5632700 5736500 5840300 5944100 6047900 6151700 6255600 6359400 6463200 6567000 6670800 6774600 6878400 6982200 7086000 7189800 7293700 7397500 7501300 7605100 7708900 7812700'
  [../]

  [./beta_fn]
    type = PiecewiseLinear
    x = '300  2000'
    y = '0          0'
  [../]

  [./vf_pipeU]
    type = PiecewiseLinear
 x ='-1.000E+03 -500 -250 -249.99 -249    0 0.5      1      1e5'
 y = '26.19 26.19 26.19 26.19 0 0 0 0 0'
 scale_factor = 1
  [../]

  [./head_pumpU]
    type = PiecewiseLinear
 x ='-1.000E+03 -500 -250 -249.99 -249    0 0.5      1      1e5'
 y = '0 0 0 0 42000 42000 42000 42000 42000'
 scale_factor = 10
  [../]
[]

  [MaterialProperties]

  [./fluid_props1]
    type = FunctionFluidProperties
    rho = rhoHe
    beta = beta_fn
    cp =  cpHe
    mu = muHe
    k =  kHe
    enthalpy = HHe
  [../]

  [./fuel-mat]                               # Material name
     type = SolidMaterialProps
    k = 74.77 #153 #74.77 #kf                                  # Thermal conductivity
    Cp = 534  #1099 #534 #cpf                                # Specific heat
    rho = 2399 #1.104e4                           # Density
  [../]
  [./gap-mat]
     type = SolidMaterialProps
    k = kclad                                  # Thermal conductivity
    Cp = cpclad                                # Specific heat
    rho = rhoclad                              # Density
  [../]
  [./clad-mat]
    type = SolidMaterialProps
    k = kclad                                   # Thermal conductivity
    Cp = cpclad                                 # Specific heat
    rho = rhoclad                               # Density
  [../]
  [./ss-mat]
    type = HeatConductionMaterialProps
    k = 26.3
    Cp = 638
    rho = 7.646e3
  [../]
  [./graphite-mat]                               # Material name
    type = SolidMaterialProps
    k = kgraphite                                   # Thermal conductivity
    Cp = cpgraphite                                 # Specific heat
    rho = rhographite                                 # Density
  [../]

  [./leadBUF-mat]                                # Material name
    type = SolidMaterialProps
    k = 33                                  # Thermal conductivity
    Cp = 129                                # Specific heat
    rho = 1.05e3                                # Density
  [../]
[]

####
[ComponentInputParameters]
  [./R2_LHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_one}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn   #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

  [./R2_RHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
    eos_left = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_one}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn  #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

###
  [./R3_LHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_two}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn   #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

  [./R3_RHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
    eos_left = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_two}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn  #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

##
  [./R4_LHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_three}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn   #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

  [./R4_RHS_param]
    type =HeatStructureParameters
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'fuel-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
    eos_left = eos
    hs_power= ${power_total}
    power_fraction = '${power_fr_ring_three}'              # Power fraction of different blocks. If not provided, calculated based on the volume of differnt blocks
   hs_power_shape_fn = power_decay_fn  #ppf_axial       # Axial power profile. If not provided, assuming uniform
  [../]

##
 [./R2_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_1}
    n_elems =    ${axial_nElem_1}
    A = ${area_ring_1}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

[./R3_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_1}
    n_elems =    ${axial_nElem_1}
    A = ${area_ring_2}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

 [./R4_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_1}
    n_elems =    ${axial_nElem_1}
    A = ${area_ring_3}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]
##################################
## Upper Structure
  [./R2UP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R2UP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
#    Hw_left = ${wallHeatTrans_coef}
    eos_left = eos
    hs_power= 0
  [../]

###
  [./R3UP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R3UP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
#    Hw_left = ${wallHeatTrans_coef}
    eos_left = eos
    hs_power= 0
  [../]

##
  [./R4UP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R4UP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    elem_number_radial =${radial_nElem_2}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
#    Hw_left = ${wallHeatTrans_coef}
    eos_left = eos
    hs_power= 0
  [../]

##
 [./R2UP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_2}
    n_elems =    ${axial_nElem_2}
    A = ${area_ring_1}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

[./R3UP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_2}
    n_elems =    ${axial_nElem_2}
    A = ${area_ring_2}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

 [./R4UP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_2}
    n_elems =    ${axial_nElem_2}
    A = ${area_ring_3}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]
##################################
## LOWER  CORE SUPPORT Structure
  [./R2LP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R2LP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
#    Hw_left = ${wallHeatTrans_coef}
    eos_left = eos
    hs_power= 0
  [../]

###
  [./R3LP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R3LP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
#    Hw_left = ${wallHeatTrans_coef}
    eos_left = eos
    hs_power= 0
  [../]

##
  [./R4LP_LHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    eos_right = eos
    hs_power= 0
  [../]

  [./R4LP_RHS_param]
    type =HeatStructureParameters
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    elem_number_radial =${radial_nElem_3}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Coupled Adiabatic'
    eos_left = eos
    hs_power= 0
  [../]

##
 [./R2LP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_3}
    n_elems =    ${axial_nElem_3}
    A = ${area_ring_1}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

[./R3LP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_3}
    n_elems =    ${axial_nElem_3}
    A = ${area_ring_2}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

 [./R4LP_channelParam]
    type = PBOneDFluidComponentParameters
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_3}
    n_elems =    ${axial_nElem_3}
    A = ${area_ring_3}
    Dh = ${channel_dia}
    HTC_geometry_type = Pipe # pipe model
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]

#####
 []



###
[Components]
  [./reactor]
    type = ReactorPower
    initial_power = 600e6
#    decay_heat = power_history
  [../]

######  Primary Loop  ######
  [./R1]
    type = PBCoupledHeatStructure
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    width_of_hs = ${w_R-1}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = 0
  [../]

  [./Gap1_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R1:outer_wall'
    surface2_name = 'R2_1-L:inner_wall'
    width = ${w_Gap-1}
    radius_1 = ${rad_Gap-1}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./R2_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-1
    HT_surface_area_density_right = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-L}
    radius_i = ${rad_R2-1-L}
  [../]

 [./R2C-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-1} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-1
    HT_surface_area_density_left = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-R}
    radius_i = ${rad_R2-1-R}
  [../]

  [./R2_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-2
    HT_surface_area_density_right = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-L}
    radius_i = ${rad_R2-2-L}
  [../]

 [./R2C-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-2} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-2
    HT_surface_area_density_left = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-R}
    radius_i = ${rad_R2-2-R}
  [../]


  [./R2_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-3
    HT_surface_area_density_right = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-L}
    radius_i = ${rad_R2-3-L}
  [../]

 [./R2C-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-3} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-3
    HT_surface_area_density_left = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-R}
    radius_i = ${rad_R2-3-R}
  [../]


  [./R2_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-4
    HT_surface_area_density_right = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-L}
    radius_i = ${rad_R2-4-L}
  [../]

 [./R2C-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-4} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-4
    HT_surface_area_density_left = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-R}
    radius_i = ${rad_R2-4-R}
  [../]


  [./R2_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-5
    HT_surface_area_density_right = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-L}
    radius_i = ${rad_R2-5-L}
  [../]

 [./R2C-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-5} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-5
    HT_surface_area_density_left = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-R}
    radius_i = ${rad_R2-5-R}
  [../]

  [./R2_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-6
    HT_surface_area_density_right = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-L}
    radius_i = ${rad_R2-6-L}
  [../]

 [./R2C-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-6} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-6
    HT_surface_area_density_left = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-R}
    radius_i = ${rad_R2-6-R}
  [../]

  [./R2_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-7
    HT_surface_area_density_right = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-L}
    radius_i = ${rad_R2-7-L}
  [../]

 [./R2C-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-7} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-7
    HT_surface_area_density_left = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-R}
    radius_i = ${rad_R2-7-R}
  [../]

  [./R2_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-8
    HT_surface_area_density_right = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-L}
    radius_i = ${rad_R2-8-L}
  [../]

 [./R2C-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-8} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-8
    HT_surface_area_density_left = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-R}
    radius_i = ${rad_R2-8-R}
  [../]

  [./R2_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-9
    HT_surface_area_density_right = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-L}
    radius_i = ${rad_R2-9-L}
  [../]

 [./R2C-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-9} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-9
    HT_surface_area_density_left = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-R}
    radius_i = ${rad_R2-9-R}
  [../]

  [./R2_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-10
    HT_surface_area_density_right = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-L}
    radius_i = ${rad_R2-10-L}
  [../]

 [./R2C-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-10} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-10
    HT_surface_area_density_left = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-R}
    radius_i = ${rad_R2-10-R}
  [../]

  [./R2_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R2_LHS_param
    name_comp_right= R2C-11
    HT_surface_area_density_right = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-L}
    radius_i = ${rad_R2-11-L}
  [../]

 [./R2C-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-11} 0'
    input_parameters = R2_channelParam
  [../]

  [./R2_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R2_RHS_param
    name_comp_left= R2C-11
    HT_surface_area_density_left = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-R}
    radius_i = ${rad_R2-11-R}
  [../]

  [./Gap_R2_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-R:outer_wall'
    surface2_name = 'R2_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]



  [./Gap_R2_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-R:outer_wall'
    surface2_name = 'R2_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]



  [./Gap_R2_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-R:outer_wall'
    surface2_name = 'R2_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-R:outer_wall'
    surface2_name = 'R2_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-R:outer_wall'
    surface2_name = 'R2_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-R:outer_wall'
    surface2_name = 'R2_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-R:outer_wall'
    surface2_name = 'R2_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-R:outer_wall'
    surface2_name = 'R2_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-R:outer_wall'
    surface2_name = 'R2_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-R:outer_wall'
    surface2_name = 'R2_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
  [./Gap_R2_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-R:outer_wall'
    surface2_name = 'R3_1-L:inner_wall'
    width = ${w_Gap-2}
    radius_1 = ${rad_Gap-2}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#### RING#3 STARTS####
  [./R3_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-1
    HT_surface_area_density_right = ${aw_R3-1-L}
    width_of_hs = ${w_R3-1-L}
    radius_i = ${rad_R3-1-L}
  [../]

 [./R3C-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-1} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-1
    HT_surface_area_density_left = ${aw_R3-1-R}
    width_of_hs = ${w_R3-1-R}
    radius_i = ${rad_R3-1-R}
  [../]

  [./R3_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-2
    HT_surface_area_density_right = ${aw_R3-2-L}
    width_of_hs = ${w_R3-2-L}
    radius_i = ${rad_R3-2-L}
  [../]

 [./R3C-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-2} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-2
    HT_surface_area_density_left = ${aw_R3-2-R}
    width_of_hs = ${w_R3-2-R}
    radius_i = ${rad_R3-2-R}
  [../]


  [./R3_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-3
    HT_surface_area_density_right = ${aw_R3-3-L}
    width_of_hs = ${w_R3-3-L}
    radius_i = ${rad_R3-3-L}
  [../]

 [./R3C-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-3} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-3
    HT_surface_area_density_left = ${aw_R3-3-R}
    width_of_hs = ${w_R3-3-R}
    radius_i = ${rad_R3-3-R}
  [../]


  [./R3_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-4
    HT_surface_area_density_right = ${aw_R3-4-L}
    width_of_hs = ${w_R3-4-L}
    radius_i = ${rad_R3-4-L}
  [../]

 [./R3C-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-4} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-4
    HT_surface_area_density_left = ${aw_R3-4-R}
    width_of_hs = ${w_R3-4-R}
    radius_i = ${rad_R3-4-R}
  [../]


  [./R3_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-5
    HT_surface_area_density_right = ${aw_R3-5-L}
    width_of_hs = ${w_R3-5-L}
    radius_i = ${rad_R3-5-L}
  [../]

 [./R3C-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-5} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-5
    HT_surface_area_density_left = ${aw_R3-5-R}
    width_of_hs = ${w_R3-5-R}
    radius_i = ${rad_R3-5-R}
  [../]

  [./R3_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-6
    HT_surface_area_density_right = ${aw_R3-6-L}
    width_of_hs = ${w_R3-6-L}
    radius_i = ${rad_R3-6-L}
  [../]

 [./R3C-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-6} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-6
    HT_surface_area_density_left = ${aw_R3-6-R}
    width_of_hs = ${w_R3-6-R}
    radius_i = ${rad_R3-6-R}
  [../]

  [./R3_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-7
    HT_surface_area_density_right = ${aw_R3-7-L}
    width_of_hs = ${w_R3-7-L}
    radius_i = ${rad_R3-7-L}
  [../]

 [./R3C-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-7} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-7
    HT_surface_area_density_left = ${aw_R3-7-R}
    width_of_hs = ${w_R3-7-R}
    radius_i = ${rad_R3-7-R}
  [../]

  [./R3_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-8
    HT_surface_area_density_right = ${aw_R3-8-L}
    width_of_hs = ${w_R3-8-L}
    radius_i = ${rad_R3-8-L}
  [../]

 [./R3C-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-8} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-8
    HT_surface_area_density_left = ${aw_R3-8-R}
    width_of_hs = ${w_R3-8-R}
    radius_i = ${rad_R3-8-R}
  [../]

  [./R3_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-9
    HT_surface_area_density_right = ${aw_R3-9-L}
    width_of_hs = ${w_R3-9-L}
    radius_i = ${rad_R3-9-L}
  [../]

 [./R3C-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-9} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-9
    HT_surface_area_density_left = ${aw_R3-9-R}
    width_of_hs = ${w_R3-9-R}
    radius_i = ${rad_R3-9-R}
  [../]

  [./R3_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-10
    HT_surface_area_density_right = ${aw_R3-10-L}
    width_of_hs = ${w_R3-10-L}
    radius_i = ${rad_R3-10-L}
  [../]

 [./R3C-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-10} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-10
    HT_surface_area_density_left = ${aw_R3-10-R}
    width_of_hs = ${w_R3-10-R}
    radius_i = ${rad_R3-10-R}
  [../]

  [./R3_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R3_LHS_param
    name_comp_right= R3C-11
    HT_surface_area_density_right = ${aw_R3-11-L}
    width_of_hs = ${w_R3-11-L}
    radius_i = ${rad_R3-11-L}
  [../]

 [./R3C-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-11} 0'
    input_parameters = R3_channelParam
  [../]

  [./R3_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R3_RHS_param
    name_comp_left= R3C-11
    HT_surface_area_density_left = ${aw_R3-11-R}
    width_of_hs = ${w_R3-11-R}
    radius_i = ${rad_R3-11-R}
  [../]

  [./Gap_R3_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-R:outer_wall'
    surface2_name = 'R3_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-R:outer_wall'
    surface2_name = 'R3_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-R:outer_wall'
    surface2_name = 'R3_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-R:outer_wall'
    surface2_name = 'R3_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-R:outer_wall'
    surface2_name = 'R3_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-R:outer_wall'
    surface2_name = 'R3_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-R:outer_wall'
    surface2_name = 'R3_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-R:outer_wall'
    surface2_name = 'R3_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-R:outer_wall'
    surface2_name = 'R3_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-R:outer_wall'
    surface2_name = 'R3_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-R:outer_wall'
    surface2_name = 'R4_1-L:inner_wall'
    width = ${w_Gap-3}
    radius_1 = ${rad_Gap-3}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#####R4-ring starting ###
  [./R4_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-1
    HT_surface_area_density_right = ${aw_R4-1-L}
    width_of_hs = ${w_R4-1-L}
    radius_i = ${rad_R4-1-L}
  [../]

 [./R4C-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-1} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-1
    HT_surface_area_density_left = ${aw_R4-1-R}
    width_of_hs = ${w_R4-1-R}
    radius_i = ${rad_R4-1-R}
  [../]

  [./R4_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-2
    HT_surface_area_density_right = ${aw_R4-2-L}
    width_of_hs = ${w_R4-2-L}
    radius_i = ${rad_R4-2-L}
  [../]

 [./R4C-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-2} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-2
    HT_surface_area_density_left = ${aw_R4-2-R}
    width_of_hs = ${w_R4-2-R}
    radius_i = ${rad_R4-2-R}
  [../]


  [./R4_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-3
    HT_surface_area_density_right = ${aw_R4-3-L}
    width_of_hs = ${w_R4-3-L}
    radius_i = ${rad_R4-3-L}
  [../]

 [./R4C-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-3} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-3
    HT_surface_area_density_left = ${aw_R4-3-R}
    width_of_hs = ${w_R4-3-R}
    radius_i = ${rad_R4-3-R}
  [../]


  [./R4_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-4
    HT_surface_area_density_right = ${aw_R4-4-L}
    width_of_hs = ${w_R4-4-L}
    radius_i = ${rad_R4-4-L}
  [../]

 [./R4C-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-4} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-4
    HT_surface_area_density_left = ${aw_R4-4-R}
    width_of_hs = ${w_R4-4-R}
    radius_i = ${rad_R4-4-R}
  [../]


  [./R4_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-5
    HT_surface_area_density_right = ${aw_R4-5-L}
    width_of_hs = ${w_R4-5-L}
    radius_i = ${rad_R4-5-L}
  [../]

 [./R4C-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-5} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-5
    HT_surface_area_density_left = ${aw_R4-5-R}
    width_of_hs = ${w_R4-5-R}
    radius_i = ${rad_R4-5-R}
  [../]

  [./R4_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-6
    HT_surface_area_density_right = ${aw_R4-6-L}
    width_of_hs = ${w_R4-6-L}
    radius_i = ${rad_R4-6-L}
  [../]

 [./R4C-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-6} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-6
    HT_surface_area_density_left = ${aw_R4-6-R}
    width_of_hs = ${w_R4-6-R}
    radius_i = ${rad_R4-6-R}
  [../]

  [./R4_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-7
    HT_surface_area_density_right = ${aw_R4-7-L}
    width_of_hs = ${w_R4-7-L}
    radius_i = ${rad_R4-7-L}
  [../]

 [./R4C-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-7} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-7
    HT_surface_area_density_left = ${aw_R4-7-R}
    width_of_hs = ${w_R4-7-R}
    radius_i = ${rad_R4-7-R}
  [../]

  [./R4_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-8
    HT_surface_area_density_right = ${aw_R4-8-L}
    width_of_hs = ${w_R4-8-L}
    radius_i = ${rad_R4-8-L}
  [../]

 [./R4C-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-8} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-8
    HT_surface_area_density_left = ${aw_R4-8-R}
    width_of_hs = ${w_R4-8-R}
    radius_i = ${rad_R4-8-R}
  [../]

  [./R4_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-9
    HT_surface_area_density_right = ${aw_R4-9-L}
    width_of_hs = ${w_R4-9-L}
    radius_i = ${rad_R4-9-L}
  [../]

 [./R4C-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-9} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-9
    HT_surface_area_density_left = ${aw_R4-9-R}
    width_of_hs = ${w_R4-9-R}
    radius_i = ${rad_R4-9-R}
  [../]

  [./R4_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-10
    HT_surface_area_density_right = ${aw_R4-10-L}
    width_of_hs = ${w_R4-10-L}
    radius_i = ${rad_R4-10-L}
  [../]

 [./R4C-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-10} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-10
    HT_surface_area_density_left = ${aw_R4-10-R}
    width_of_hs = ${w_R4-10-R}
    radius_i = ${rad_R4-10-R}
  [../]

  [./R4_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-11
    HT_surface_area_density_right = ${aw_R4-11-L}
    width_of_hs = ${w_R4-11-L}
    radius_i = ${rad_R4-11-L}
  [../]

 [./R4C-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-11} 0'
    input_parameters = R4_channelParam
  [../]

  [./R4_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-11
    HT_surface_area_density_left = ${aw_R4-11-R}
    width_of_hs = ${w_R4-11-R}
    radius_i = ${rad_R4-11-R}
  [../]

  [./Gap_R4_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-R:outer_wall'
    surface2_name = 'R4_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-R:outer_wall'
    surface2_name = 'R4_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-R:outer_wall'
    surface2_name = 'R4_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-R:outer_wall'
    surface2_name = 'R4_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-R:outer_wall'
    surface2_name = 'R4_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-R:outer_wall'
    surface2_name = 'R4_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-R:outer_wall'
    surface2_name = 'R4_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-R:outer_wall'
    surface2_name = 'R4_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-R:outer_wall'
    surface2_name = 'R4_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-R:outer_wall'
    surface2_name = 'R4_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-R:outer_wall'
    surface2_name = 'R5:inner_wall'
    width = ${w_Gap-4}
    radius_1 = ${rad_Gap-4}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

### Ring 5
  [./R5]
    type = PBCoupledHeatStructure
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    width_of_hs = ${w_R5}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = ${rad_R5}
  [../]
####Ring#6 starting ###
  [./Gap5_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R5:outer_wall'
    surface2_name = 'R6:inner_wall'
    width = ${w_Gap-5}
    radius_1 =${rad_Gap-5}
    length = ${axial_length_1}
    eos = eos
    h_gap =${hGap_cond}
  [../]


  [./R6]
    type = PBCoupledHeatStructure
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    width_of_hs = ${w_R6}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    name_comp_right= R6_C
    HT_surface_area_density_right = ${aw_R6}
    eos_right = eos
    radius_i = ${rad_R6}
  [../]

[./R6_C]
    type = PBOneDFluidComponent
    position = '0 ${rad_R6C} 0'
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_1}
    A = ${aw_tot}
    Dh = ${Dh_tot}
    HTC_geometry_type = Pipe # pipe model
    n_elems = ${axial_nElem_1}
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]


####Ring#7 starting ###
  [./R7]
    type = PBCoupledHeatStructure
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    width_of_hs = ${w_R7}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Coupled Adiabatic'
#    T_bc_right = 303
    name_comp_left= R6_C
    HT_surface_area_density_left = ${aw_R6}
    eos_left = eos
    radius_i = ${rad_R7}
  [../]

  [./GapR6C_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R6:outer_wall'
    surface2_name = 'R7:inner_wall'
    radius_1 =${rad_R6}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]

###RCCS Ring

  [./RCCS_AC]
    type = PBCoupledHeatStructure
    position = '0 0 0'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_1}
    width_of_hs = ${w_RCCS}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_1}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Adiabatic Convective'
    Hw_right = ${h_air_natural_conv}
    T_amb_right = 300
    eos_right = eos_air
    radius_i = ${rad_RCCS}
  [../]

## Only radiation for RCCS
  [./GapRCCS_AC_RHT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R7:outer_wall'
    surface2_name = 'RCCS_AC:inner_wall'
    radius_1 =${rad_RCCS}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]



####UPPER STRUCTURE COMPONENTS ###
  [./R1UP]
    type = PBCoupledHeatStructure
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    width_of_hs = ${w_R-1}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = 0
  [../]

  [./Gap1UP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R1UP:outer_wall'
    surface2_name = 'R2UP_1-L:inner_wall'
    width = ${w_Gap-1}
    radius_1 = ${rad_Gap-1}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./R2UP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-1
    HT_surface_area_density_right = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-L}
    radius_i = ${rad_R2-1-L}
  [../]

 [./R2CUP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-1} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-1
    HT_surface_area_density_left = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-R}
    radius_i = ${rad_R2-1-R}
  [../]

  [./R2UP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-2
    HT_surface_area_density_right = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-L}
    radius_i = ${rad_R2-2-L}
  [../]

 [./R2CUP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-2} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-2
    HT_surface_area_density_left = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-R}
    radius_i = ${rad_R2-2-R}
  [../]


  [./R2UP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-3
    HT_surface_area_density_right = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-L}
    radius_i = ${rad_R2-3-L}
  [../]

 [./R2CUP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-3} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-3
    HT_surface_area_density_left = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-R}
    radius_i = ${rad_R2-3-R}
  [../]


  [./R2UP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-4
    HT_surface_area_density_right = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-L}
    radius_i = ${rad_R2-4-L}
  [../]

 [./R2CUP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-4} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-4
    HT_surface_area_density_left = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-R}
    radius_i = ${rad_R2-4-R}
  [../]


  [./R2UP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-5
    HT_surface_area_density_right = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-L}
    radius_i = ${rad_R2-5-L}
  [../]

 [./R2CUP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-5} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-5
    HT_surface_area_density_left = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-R}
    radius_i = ${rad_R2-5-R}
  [../]

  [./R2UP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-6
    HT_surface_area_density_right = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-L}
    radius_i = ${rad_R2-6-L}
  [../]

 [./R2CUP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-6} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-6
    HT_surface_area_density_left = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-R}
    radius_i = ${rad_R2-6-R}
  [../]

  [./R2UP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-7
    HT_surface_area_density_right = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-L}
    radius_i = ${rad_R2-7-L}
  [../]

 [./R2CUP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-7} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-7
    HT_surface_area_density_left = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-R}
    radius_i = ${rad_R2-7-R}
  [../]

  [./R2UP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-8
    HT_surface_area_density_right = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-L}
    radius_i = ${rad_R2-8-L}
  [../]

 [./R2CUP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-8} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-8
    HT_surface_area_density_left = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-R}
    radius_i = ${rad_R2-8-R}
  [../]

  [./R2UP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-9
    HT_surface_area_density_right = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-L}
    radius_i = ${rad_R2-9-L}
  [../]

 [./R2CUP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-9} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-9
    HT_surface_area_density_left = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-R}
    radius_i = ${rad_R2-9-R}
  [../]

  [./R2UP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-10
    HT_surface_area_density_right = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-L}
    radius_i = ${rad_R2-10-L}
  [../]

 [./R2CUP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-10} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-10
    HT_surface_area_density_left = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-R}
    radius_i = ${rad_R2-10-R}
  [../]

  [./R2UP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_LHS_param
    name_comp_right= R2CUP-11
    HT_surface_area_density_right = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-L}
    radius_i = ${rad_R2-11-L}
  [../]

 [./R2CUP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-11} ${axial_length_1}'
    input_parameters = R2UP_channelParam
  [../]

  [./R2UP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R2UP_RHS_param
    name_comp_left= R2CUP-11
    HT_surface_area_density_left = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-R}
    radius_i = ${rad_R2-11-R}
  [../]

  [./Gap_R2UP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_1-R:outer_wall'
    surface2_name = 'R2UP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_2-R:outer_wall'
    surface2_name = 'R2UP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_3-R:outer_wall'
    surface2_name = 'R2UP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_4-R:outer_wall'
    surface2_name = 'R2UP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_5-R:outer_wall'
    surface2_name = 'R2UP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_6-R:outer_wall'
    surface2_name = 'R2UP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_7-R:outer_wall'
    surface2_name = 'R2UP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_8-R:outer_wall'
    surface2_name = 'R2UP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_9-R:outer_wall'
    surface2_name = 'R2UP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_10-R:outer_wall'
    surface2_name = 'R2UP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
  [./Gap_R2UP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_11-R:outer_wall'
    surface2_name = 'R3UP_1-L:inner_wall'
    width = ${w_Gap-2}
    radius_1 = ${rad_Gap-2}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#### RING#3 STARTS####
  [./R3UP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-1
    HT_surface_area_density_right = ${aw_R3-1-L}
    width_of_hs = ${w_R3-1-L}
    radius_i = ${rad_R3-1-L}
  [../]

 [./R3CUP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-1} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-1
    HT_surface_area_density_left = ${aw_R3-1-R}
    width_of_hs = ${w_R3-1-R}
    radius_i = ${rad_R3-1-R}
  [../]

  [./R3UP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-2
    HT_surface_area_density_right = ${aw_R3-2-L}
    width_of_hs = ${w_R3-2-L}
    radius_i = ${rad_R3-2-L}
  [../]

 [./R3CUP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-2} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-2
    HT_surface_area_density_left = ${aw_R3-2-R}
    width_of_hs = ${w_R3-2-R}
    radius_i = ${rad_R3-2-R}
  [../]


  [./R3UP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-3
    HT_surface_area_density_right = ${aw_R3-3-L}
    width_of_hs = ${w_R3-3-L}
    radius_i = ${rad_R3-3-L}
  [../]

 [./R3CUP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-3} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-3
    HT_surface_area_density_left = ${aw_R3-3-R}
    width_of_hs = ${w_R3-3-R}
    radius_i = ${rad_R3-3-R}
  [../]


  [./R3UP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-4
    HT_surface_area_density_right = ${aw_R3-4-L}
    width_of_hs = ${w_R3-4-L}
    radius_i = ${rad_R3-4-L}
  [../]

 [./R3CUP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-4} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-4
    HT_surface_area_density_left = ${aw_R3-4-R}
    width_of_hs = ${w_R3-4-R}
    radius_i = ${rad_R3-4-R}
  [../]


  [./R3UP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-5
    HT_surface_area_density_right = ${aw_R3-5-L}
    width_of_hs = ${w_R3-5-L}
    radius_i = ${rad_R3-5-L}
  [../]

 [./R3CUP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-5} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-5
    HT_surface_area_density_left = ${aw_R3-5-R}
    width_of_hs = ${w_R3-5-R}
    radius_i = ${rad_R3-5-R}
  [../]

  [./R3UP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-6
    HT_surface_area_density_right = ${aw_R3-6-L}
    width_of_hs = ${w_R3-6-L}
    radius_i = ${rad_R3-6-L}
  [../]

 [./R3CUP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-6} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-6
    HT_surface_area_density_left = ${aw_R3-6-R}
    width_of_hs = ${w_R3-6-R}
    radius_i = ${rad_R3-6-R}
  [../]

  [./R3UP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-7
    HT_surface_area_density_right = ${aw_R3-7-L}
    width_of_hs = ${w_R3-7-L}
    radius_i = ${rad_R3-7-L}
  [../]

 [./R3CUP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-7} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-7
    HT_surface_area_density_left = ${aw_R3-7-R}
    width_of_hs = ${w_R3-7-R}
    radius_i = ${rad_R3-7-R}
  [../]

  [./R3UP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-8
    HT_surface_area_density_right = ${aw_R3-8-L}
    width_of_hs = ${w_R3-8-L}
    radius_i = ${rad_R3-8-L}
  [../]

 [./R3CUP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-8} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-8
    HT_surface_area_density_left = ${aw_R3-8-R}
    width_of_hs = ${w_R3-8-R}
    radius_i = ${rad_R3-8-R}
  [../]

  [./R3UP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-9
    HT_surface_area_density_right = ${aw_R3-9-L}
    width_of_hs = ${w_R3-9-L}
    radius_i = ${rad_R3-9-L}
  [../]

 [./R3CUP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-9} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-9
    HT_surface_area_density_left = ${aw_R3-9-R}
    width_of_hs = ${w_R3-9-R}
    radius_i = ${rad_R3-9-R}
  [../]

  [./R3UP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-10
    HT_surface_area_density_right = ${aw_R3-10-L}
    width_of_hs = ${w_R3-10-L}
    radius_i = ${rad_R3-10-L}
  [../]

 [./R3CUP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-10} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-10
    HT_surface_area_density_left = ${aw_R3-10-R}
    width_of_hs = ${w_R3-10-R}
    radius_i = ${rad_R3-10-R}
  [../]

  [./R3UP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_LHS_param
    name_comp_right= R3CUP-11
    HT_surface_area_density_right = ${aw_R3-11-L}
    width_of_hs = ${w_R3-11-L}
    radius_i = ${rad_R3-11-L}
  [../]

 [./R3CUP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-11} ${axial_length_1}'
    input_parameters = R3UP_channelParam
  [../]

  [./R3UP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R3UP_RHS_param
    name_comp_left= R3CUP-11
    HT_surface_area_density_left = ${aw_R3-11-R}
    width_of_hs = ${w_R3-11-R}
    radius_i = ${rad_R3-11-R}
  [../]

  [./Gap_R3UP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_1-R:outer_wall'
    surface2_name = 'R3UP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_2-R:outer_wall'
    surface2_name = 'R3UP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_3-R:outer_wall'
    surface2_name = 'R3UP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_4-R:outer_wall'
    surface2_name = 'R3UP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_5-R:outer_wall'
    surface2_name = 'R3UP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_6-R:outer_wall'
    surface2_name = 'R3UP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_7-R:outer_wall'
    surface2_name = 'R3UP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_8-R:outer_wall'
    surface2_name = 'R3UP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_9-R:outer_wall'
    surface2_name = 'R3UP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_10-R:outer_wall'
    surface2_name = 'R3UP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_11-R:outer_wall'
    surface2_name = 'R4UP_1-L:inner_wall'
    width = ${w_Gap-3}
    radius_1 = ${rad_Gap-3}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#####R4-ring starting ###
  [./R4UP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-1
    HT_surface_area_density_right = ${aw_R4-1-L}
    width_of_hs = ${w_R4-1-L}
    radius_i = ${rad_R4-1-L}
  [../]

 [./R4CUP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-1} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-1
    HT_surface_area_density_left = ${aw_R4-1-R}
    width_of_hs = ${w_R4-1-R}
    radius_i = ${rad_R4-1-R}
  [../]

  [./R4UP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-2
    HT_surface_area_density_right = ${aw_R4-2-L}
    width_of_hs = ${w_R4-2-L}
    radius_i = ${rad_R4-2-L}
  [../]

 [./R4CUP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-2} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-2
    HT_surface_area_density_left = ${aw_R4-2-R}
    width_of_hs = ${w_R4-2-R}
    radius_i = ${rad_R4-2-R}
  [../]


  [./R4UP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-3
    HT_surface_area_density_right = ${aw_R4-3-L}
    width_of_hs = ${w_R4-3-L}
    radius_i = ${rad_R4-3-L}
  [../]

 [./R4CUP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-3} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-3
    HT_surface_area_density_left = ${aw_R4-3-R}
    width_of_hs = ${w_R4-3-R}
    radius_i = ${rad_R4-3-R}
  [../]


  [./R4UP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-4
    HT_surface_area_density_right = ${aw_R4-4-L}
    width_of_hs = ${w_R4-4-L}
    radius_i = ${rad_R4-4-L}
  [../]

 [./R4CUP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-4} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-4
    HT_surface_area_density_left = ${aw_R4-4-R}
    width_of_hs = ${w_R4-4-R}
    radius_i = ${rad_R4-4-R}
  [../]


  [./R4UP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-5
    HT_surface_area_density_right = ${aw_R4-5-L}
    width_of_hs = ${w_R4-5-L}
    radius_i = ${rad_R4-5-L}
  [../]

 [./R4CUP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-5} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-5
    HT_surface_area_density_left = ${aw_R4-5-R}
    width_of_hs = ${w_R4-5-R}
    radius_i = ${rad_R4-5-R}
  [../]

  [./R4UP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-6
    HT_surface_area_density_right = ${aw_R4-6-L}
    width_of_hs = ${w_R4-6-L}
    radius_i = ${rad_R4-6-L}
  [../]

 [./R4CUP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-6} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-6
    HT_surface_area_density_left = ${aw_R4-6-R}
    width_of_hs = ${w_R4-6-R}
    radius_i = ${rad_R4-6-R}
  [../]

  [./R4UP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-7
    HT_surface_area_density_right = ${aw_R4-7-L}
    width_of_hs = ${w_R4-7-L}
    radius_i = ${rad_R4-7-L}
  [../]

 [./R4CUP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-7} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-7
    HT_surface_area_density_left = ${aw_R4-7-R}
    width_of_hs = ${w_R4-7-R}
    radius_i = ${rad_R4-7-R}
  [../]

  [./R4UP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-8
    HT_surface_area_density_right = ${aw_R4-8-L}
    width_of_hs = ${w_R4-8-L}
    radius_i = ${rad_R4-8-L}
  [../]

 [./R4CUP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-8} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-8
    HT_surface_area_density_left = ${aw_R4-8-R}
    width_of_hs = ${w_R4-8-R}
    radius_i = ${rad_R4-8-R}
  [../]

  [./R4UP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-9
    HT_surface_area_density_right = ${aw_R4-9-L}
    width_of_hs = ${w_R4-9-L}
    radius_i = ${rad_R4-9-L}
  [../]

 [./R4CUP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-9} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-9
    HT_surface_area_density_left = ${aw_R4-9-R}
    width_of_hs = ${w_R4-9-R}
    radius_i = ${rad_R4-9-R}
  [../]

  [./R4UP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-10
    HT_surface_area_density_right = ${aw_R4-10-L}
    width_of_hs = ${w_R4-10-L}
    radius_i = ${rad_R4-10-L}
  [../]

 [./R4CUP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-10} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-10
    HT_surface_area_density_left = ${aw_R4-10-R}
    width_of_hs = ${w_R4-10-R}
    radius_i = ${rad_R4-10-R}
  [../]

  [./R4UP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_LHS_param
    name_comp_right= R4CUP-11
    HT_surface_area_density_right = ${aw_R4-11-L}
    width_of_hs = ${w_R4-11-L}
    radius_i = ${rad_R4-11-L}
  [../]

 [./R4CUP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-11} ${axial_length_1}'
    input_parameters = R4UP_channelParam
  [../]

  [./R4UP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R4UP_RHS_param
    name_comp_left= R4CUP-11
    HT_surface_area_density_left = ${aw_R4-11-R}
    width_of_hs = ${w_R4-11-R}
    radius_i = ${rad_R4-11-R}
  [../]

  [./Gap_R4UP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_1-R:outer_wall'
    surface2_name = 'R4UP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_2-R:outer_wall'
    surface2_name = 'R4UP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_3-R:outer_wall'
    surface2_name = 'R4UP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_4-R:outer_wall'
    surface2_name = 'R4UP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_5-R:outer_wall'
    surface2_name = 'R4UP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_6-R:outer_wall'
    surface2_name = 'R4UP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_7-R:outer_wall'
    surface2_name = 'R4UP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_8-R:outer_wall'
    surface2_name = 'R4UP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_9-R:outer_wall'
    surface2_name = 'R4UP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_10-R:outer_wall'
    surface2_name = 'R4UP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_11-R:outer_wall'
    surface2_name = 'R5UP:inner_wall'
    width = ${w_Gap-4}
    radius_1 = ${rad_Gap-4}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

### Ring 5
  [./R5UP]
    type = PBCoupledHeatStructure
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    width_of_hs = ${w_R5}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = ${rad_R5}
  [../]
####Ring#6 starting ###
  [./Gap5UP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R5UP:outer_wall'
    surface2_name = 'R6UP:inner_wall'
    width = ${w_Gap-5}
    radius_1 =${rad_Gap-5}
    length = ${axial_length_2}
    eos = eos
    h_gap =${hGap_cond}
  [../]


  [./R6UP]
    type = PBCoupledHeatStructure
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    width_of_hs = ${w_R6}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    name_comp_right= R6UP_C
    HT_surface_area_density_right = ${aw_R6}
    eos_right = eos
    radius_i = ${rad_R6}
  [../]

[./R6UP_C]
    type = PBOneDFluidComponent
    position = '0 ${rad_R6C} ${axial_length_1}'
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_2}
    A = ${aw_tot}
    Dh = ${Dh_tot}
    HTC_geometry_type = Pipe # pipe model
    n_elems = ${axial_nElem_2}
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]


####Ring#7 starting ###
  [./R7UP]
    type = PBCoupledHeatStructure
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_2}
    width_of_hs = ${w_R7}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Coupled Adiabatic'
#    T_bc_right = 303
    name_comp_left= R6UP_C
    HT_surface_area_density_left = ${aw_R6}
    eos_left = eos
    radius_i = ${rad_R7}
  [../]

  [./GapR6CUP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R6UP:outer_wall'
    surface2_name = 'R7UP:inner_wall'
    radius_1 =${rad_R6}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]

###RCCS Ring

  [./RCCS_UP]
    type = PBCoupledHeatStructure
    position = '0 0 ${axial_length_1}'
    orientation = '0 0 1'
    hs_type = cylinder
    length =  ${axial_length_2}
    width_of_hs = ${w_RCCS}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_2}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Adiabatic Convective'
    Hw_right = ${h_air_natural_conv}
    T_amb_right = 300
    eos_right =eos_air
    radius_i = ${rad_RCCS}
  [../]

## Only radiation for RCCS
  [./GapRCCS-UP_RHT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R7UP:outer_wall'
    surface2_name = 'RCCS_UP:inner_wall'
    radius_1 =${rad_RCCS}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]

  [./GapRCCS-UP_tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'RCCS_AC:top_wall'
    surface2_name = 'RCCS_UP:bottom_wall'
    h_gap = ${hGap_cond}
  [../]


#### GAP connection btw top active core and upper structure ###
  [./GapR1UPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R1:top_wall'
    surface2_name = 'R1UP:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-L:top_wall'
    surface2_name = 'R2UP_1-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-R:top_wall'
    surface2_name = 'R2UP_1-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R2UP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-L:top_wall'
    surface2_name = 'R2UP_2-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-R:top_wall'
    surface2_name = 'R2UP_2-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-L:top_wall'
    surface2_name = 'R2UP_3-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-R:top_wall'
    surface2_name = 'R2UP_3-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-L:top_wall'
    surface2_name = 'R2UP_4-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-R:top_wall'
    surface2_name = 'R2UP_4-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-L:top_wall'
    surface2_name = 'R2UP_5-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-R:top_wall'
    surface2_name = 'R2UP_5-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-L:top_wall'
    surface2_name = 'R2UP_6-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-R:top_wall'
    surface2_name = 'R2UP_6-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-L:top_wall'
    surface2_name = 'R2UP_7-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-R:top_wall'
    surface2_name = 'R2UP_7-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-L:top_wall'
    surface2_name = 'R2UP_8-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-R:top_wall'
    surface2_name = 'R2UP_8-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-L:top_wall'
    surface2_name = 'R2UP_9-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-R:top_wall'
    surface2_name = 'R2UP_9-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-L:top_wall'
    surface2_name = 'R2UP_10-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-R:top_wall'
    surface2_name = 'R2UP_10-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-L:top_wall'
    surface2_name = 'R2UP_11-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2UP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-R:top_wall'
    surface2_name = 'R2UP_11-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]
##############
  [./Gap_R3UP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-L:top_wall'
    surface2_name = 'R3UP_1-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-R:top_wall'
    surface2_name = 'R3UP_1-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R3UP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-L:top_wall'
    surface2_name = 'R3UP_2-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-R:top_wall'
    surface2_name = 'R3UP_2-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-L:top_wall'
    surface2_name = 'R3UP_3-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-R:top_wall'
    surface2_name = 'R3UP_3-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-L:top_wall'
    surface2_name = 'R3UP_4-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-R:top_wall'
    surface2_name = 'R3UP_4-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-L:top_wall'
    surface2_name = 'R3UP_5-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-R:top_wall'
    surface2_name = 'R3UP_5-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-L:top_wall'
    surface2_name = 'R3UP_6-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-R:top_wall'
    surface2_name = 'R3UP_6-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-L:top_wall'
    surface2_name = 'R3UP_7-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-R:top_wall'
    surface2_name = 'R3UP_7-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-L:top_wall'
    surface2_name = 'R3UP_8-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-R:top_wall'
    surface2_name = 'R3UP_8-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-L:top_wall'
    surface2_name = 'R3UP_9-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-R:top_wall'
    surface2_name = 'R3UP_9-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-L:top_wall'
    surface2_name = 'R3UP_10-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-R:top_wall'
    surface2_name = 'R3UP_10-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]


  [./Gap_R3UP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-L:top_wall'
    surface2_name = 'R3UP_11-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3UP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-R:top_wall'
    surface2_name = 'R3UP_11-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-L:top_wall'
    surface2_name = 'R4UP_1-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-R:top_wall'
    surface2_name = 'R4UP_1-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R4UP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-L:top_wall'
    surface2_name = 'R4UP_2-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-R:top_wall'
    surface2_name = 'R4UP_2-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-L:top_wall'
    surface2_name = 'R4UP_3-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-R:top_wall'
    surface2_name = 'R4UP_3-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-L:top_wall'
    surface2_name = 'R4UP_4-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-R:top_wall'
    surface2_name = 'R4UP_4-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-L:top_wall'
    surface2_name = 'R4UP_5-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-R:top_wall'
    surface2_name = 'R4UP_5-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-L:top_wall'
    surface2_name = 'R4UP_6-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-R:top_wall'
    surface2_name = 'R4UP_6-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-L:top_wall'
    surface2_name = 'R4UP_7-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-R:top_wall'
    surface2_name = 'R4UP_7-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-L:top_wall'
    surface2_name = 'R4UP_8-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-R:top_wall'
    surface2_name = 'R4UP_8-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-L:top_wall'
    surface2_name = 'R4UP_9-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-R:top_wall'
    surface2_name = 'R4UP_9-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-L:top_wall'
    surface2_name = 'R4UP_10-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-R:top_wall'
    surface2_name = 'R4UP_10-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-L:top_wall'
    surface2_name = 'R4UP_11-L:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4UP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-R:top_wall'
    surface2_name = 'R4UP_11-R:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap5UPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R5:top_wall'
    surface2_name = 'R5UP:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap6UPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R6:top_wall'
    surface2_name = 'R6UP:bottom_wall'
    h_gap = ${hGap_cond}
  [../]


  [./Gap7UPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R7:top_wall'
    surface2_name = 'R7UP:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

###
################################
  [./Branch_R2CUP-1]
    type = PBSingleJunction
    inputs = 'R2C-1(out)'
    outputs = 'R2CUP-1(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-2]
    type = PBSingleJunction
    inputs = 'R2C-2(out)'
    outputs = 'R2CUP-2(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-3]
    type = PBSingleJunction
    inputs = 'R2C-3(out)'
    outputs = 'R2CUP-3(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-4]
    type = PBSingleJunction
    inputs = 'R2C-4(out)'
    outputs = 'R2CUP-4(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-5]
    type = PBSingleJunction
    inputs = 'R2C-5(out)'
    outputs = 'R2CUP-5(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-6]
    type = PBSingleJunction
    inputs = 'R2C-6(out)'
    outputs = 'R2CUP-6(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-7]
    type = PBSingleJunction
    inputs = 'R2C-7(out)'
    outputs = 'R2CUP-7(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-8]
    type = PBSingleJunction
    inputs = 'R2C-8(out)'
    outputs = 'R2CUP-8(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-9]
    type = PBSingleJunction
    inputs = 'R2C-9(out)'
    outputs = 'R2CUP-9(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-10]
    type = PBSingleJunction
    inputs = 'R2C-10(out)'
    outputs = 'R2CUP-10(in)'
    eos = eos
  [../]
  [./Branch_R2CUP-11]
    type = PBSingleJunction
    inputs = 'R2C-11(out)'
    outputs = 'R2CUP-11(in)'
    eos = eos
  [../]
###
  [./Branch_R3CUP-1]
    type = PBSingleJunction
    inputs = 'R3C-1(out)'
    outputs = 'R3CUP-1(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-2]
    type = PBSingleJunction
    inputs = 'R3C-2(out)'
    outputs = 'R3CUP-2(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-3]
    type = PBSingleJunction
    inputs = 'R3C-3(out)'
    outputs = 'R3CUP-3(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-4]
    type = PBSingleJunction
    inputs = 'R3C-4(out)'
    outputs = 'R3CUP-4(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-5]
    type = PBSingleJunction
    inputs = 'R3C-5(out)'
    outputs = 'R3CUP-5(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-6]
    type = PBSingleJunction
    inputs = 'R3C-6(out)'
    outputs = 'R3CUP-6(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-7]
    type = PBSingleJunction
    inputs = 'R3C-7(out)'
    outputs = 'R3CUP-7(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-8]
    type = PBSingleJunction
    inputs = 'R3C-8(out)'
    outputs = 'R3CUP-8(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-9]
    type = PBSingleJunction
    inputs = 'R3C-9(out)'
    outputs = 'R3CUP-9(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-10]
    type = PBSingleJunction
    inputs = 'R3C-10(out)'
    outputs = 'R3CUP-10(in)'
    eos = eos
  [../]
  [./Branch_R3CUP-11]
    type = PBSingleJunction
    inputs = 'R3C-11(out)'
    outputs = 'R3CUP-11(in)'
    eos = eos
  [../]
#######
  [./Branch_R4CUP-1]
    type = PBSingleJunction
    inputs = 'R4C-1(out)'
    outputs = 'R4CUP-1(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-2]
    type = PBSingleJunction
    inputs = 'R4C-2(out)'
    outputs = 'R4CUP-2(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-3]
    type = PBSingleJunction
    inputs = 'R4C-3(out)'
    outputs = 'R4CUP-3(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-4]
    type = PBSingleJunction
    inputs = 'R4C-4(out)'
    outputs = 'R4CUP-4(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-5]
    type = PBSingleJunction
    inputs = 'R4C-5(out)'
    outputs = 'R4CUP-5(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-6]
    type = PBSingleJunction
    inputs = 'R4C-6(out)'
    outputs = 'R4CUP-6(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-7]
    type = PBSingleJunction
    inputs = 'R4C-7(out)'
    outputs = 'R4CUP-7(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-8]
    type = PBSingleJunction
    inputs = 'R4C-8(out)'
    outputs = 'R4CUP-8(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-9]
    type = PBSingleJunction
    inputs = 'R4C-9(out)'
    outputs = 'R4CUP-9(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-10]
    type = PBSingleJunction
    inputs = 'R4C-10(out)'
    outputs = 'R4CUP-10(in)'
    eos = eos
  [../]
  [./Branch_R4CUP-11]
    type = PBSingleJunction
    inputs = 'R4C-11(out)'
    outputs = 'R4CUP-11(in)'
    eos = eos
  [../]

  [./Branch_R6UP]
    type = PBSingleJunction
    inputs = 'R6_C(out)'
    outputs = 'R6UP_C(in)'
    eos = eos
  [../]

####LOWER SUPPORT STRUCTURE COMPONENTS###
  [./R1LP]
    type = PBCoupledHeatStructure
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    width_of_hs = ${w_R-1}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = 0
  [../]

  [./Gap1LP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R1LP:outer_wall'
    surface2_name = 'R2LP_1-L:inner_wall'
    width = ${w_Gap-1}
    radius_1 = ${rad_Gap-1}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./R2LP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-1
    HT_surface_area_density_right = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-L}
    radius_i = ${rad_R2-1-L}
  [../]

 [./R2CLP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-1} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-1
    HT_surface_area_density_left = ${aw_R2-1-L}
    width_of_hs = ${w_R2-1-R}
    radius_i = ${rad_R2-1-R}
  [../]

  [./R2LP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-2
    HT_surface_area_density_right = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-L}
    radius_i = ${rad_R2-2-L}
  [../]

 [./R2CLP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-2} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-2
    HT_surface_area_density_left = ${aw_R2-2-L}
    width_of_hs = ${w_R2-2-R}
    radius_i = ${rad_R2-2-R}
  [../]


  [./R2LP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-3
    HT_surface_area_density_right = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-L}
    radius_i = ${rad_R2-3-L}
  [../]

 [./R2CLP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-3} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-3
    HT_surface_area_density_left = ${aw_R2-3-L}
    width_of_hs = ${w_R2-3-R}
    radius_i = ${rad_R2-3-R}
  [../]


  [./R2LP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-4
    HT_surface_area_density_right = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-L}
    radius_i = ${rad_R2-4-L}
  [../]

 [./R2CLP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-4} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-4
    HT_surface_area_density_left = ${aw_R2-4-L}
    width_of_hs = ${w_R2-4-R}
    radius_i = ${rad_R2-4-R}
  [../]


  [./R2LP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-5
    HT_surface_area_density_right = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-L}
    radius_i = ${rad_R2-5-L}
  [../]

 [./R2CLP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-5} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-5
    HT_surface_area_density_left = ${aw_R2-5-L}
    width_of_hs = ${w_R2-5-R}
    radius_i = ${rad_R2-5-R}
  [../]

  [./R2LP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-6
    HT_surface_area_density_right = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-L}
    radius_i = ${rad_R2-6-L}
  [../]

 [./R2CLP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-6} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-6
    HT_surface_area_density_left = ${aw_R2-6-L}
    width_of_hs = ${w_R2-6-R}
    radius_i = ${rad_R2-6-R}
  [../]

  [./R2LP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-7
    HT_surface_area_density_right = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-L}
    radius_i = ${rad_R2-7-L}
  [../]

 [./R2CLP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-7} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-7
    HT_surface_area_density_left = ${aw_R2-7-L}
    width_of_hs = ${w_R2-7-R}
    radius_i = ${rad_R2-7-R}
  [../]

  [./R2LP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-8
    HT_surface_area_density_right = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-L}
    radius_i = ${rad_R2-8-L}
  [../]

 [./R2CLP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-8} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-8
    HT_surface_area_density_left = ${aw_R2-8-L}
    width_of_hs = ${w_R2-8-R}
    radius_i = ${rad_R2-8-R}
  [../]

  [./R2LP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-9
    HT_surface_area_density_right = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-L}
    radius_i = ${rad_R2-9-L}
  [../]

 [./R2CLP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-9} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-9
    HT_surface_area_density_left = ${aw_R2-9-L}
    width_of_hs = ${w_R2-9-R}
    radius_i = ${rad_R2-9-R}
  [../]

  [./R2LP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-10
    HT_surface_area_density_right = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-L}
    radius_i = ${rad_R2-10-L}
  [../]

 [./R2CLP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-10} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-10
    HT_surface_area_density_left = ${aw_R2-10-L}
    width_of_hs = ${w_R2-10-R}
    radius_i = ${rad_R2-10-R}
  [../]

  [./R2LP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_LHS_param
    name_comp_right= R2CLP-11
    HT_surface_area_density_right = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-L}
    radius_i = ${rad_R2-11-L}
  [../]

 [./R2CLP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R2C-11} -${axial_length_3}'
    input_parameters = R2LP_channelParam
  [../]

  [./R2LP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R2LP_RHS_param
    name_comp_left= R2CLP-11
    HT_surface_area_density_left = ${aw_R2-11-L}
    width_of_hs = ${w_R2-11-R}
    radius_i = ${rad_R2-11-R}
  [../]

  [./Gap_R2LP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_1-R:outer_wall'
    surface2_name = 'R2LP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_2-R:outer_wall'
    surface2_name = 'R2LP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_3-R:outer_wall'
    surface2_name = 'R2LP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_4-R:outer_wall'
    surface2_name = 'R2LP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_5-R:outer_wall'
    surface2_name = 'R2LP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_6-R:outer_wall'
    surface2_name = 'R2LP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_7-R:outer_wall'
    surface2_name = 'R2LP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_8-R:outer_wall'
    surface2_name = 'R2LP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_9-R:outer_wall'
    surface2_name = 'R2LP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_10-R:outer_wall'
    surface2_name = 'R2LP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
  [./Gap_R2LP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_11-R:outer_wall'
    surface2_name = 'R3LP_1-L:inner_wall'
    width = ${w_Gap-2}
    radius_1 = ${rad_Gap-2}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#### RING#3 STARTS####
  [./R3LP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-1
    HT_surface_area_density_right = ${aw_R3-1-L}
    width_of_hs = ${w_R3-1-L}
    radius_i = ${rad_R3-1-L}
  [../]

 [./R3CLP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-1} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-1
    HT_surface_area_density_left = ${aw_R3-1-R}
    width_of_hs = ${w_R3-1-R}
    radius_i = ${rad_R3-1-R}
  [../]

  [./R3LP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-2
    HT_surface_area_density_right = ${aw_R3-2-L}
    width_of_hs = ${w_R3-2-L}
    radius_i = ${rad_R3-2-L}
  [../]

 [./R3CLP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-2} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-2
    HT_surface_area_density_left = ${aw_R3-2-R}
    width_of_hs = ${w_R3-2-R}
    radius_i = ${rad_R3-2-R}
  [../]


  [./R3LP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-3
    HT_surface_area_density_right = ${aw_R3-3-L}
    width_of_hs = ${w_R3-3-L}
    radius_i = ${rad_R3-3-L}
  [../]

 [./R3CLP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-3} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-3
    HT_surface_area_density_left = ${aw_R3-3-R}
    width_of_hs = ${w_R3-3-R}
    radius_i = ${rad_R3-3-R}
  [../]


  [./R3LP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-4
    HT_surface_area_density_right = ${aw_R3-4-L}
    width_of_hs = ${w_R3-4-L}
    radius_i = ${rad_R3-4-L}
  [../]

 [./R3CLP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-4} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-4
    HT_surface_area_density_left = ${aw_R3-4-R}
    width_of_hs = ${w_R3-4-R}
    radius_i = ${rad_R3-4-R}
  [../]


  [./R3LP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-5
    HT_surface_area_density_right = ${aw_R3-5-L}
    width_of_hs = ${w_R3-5-L}
    radius_i = ${rad_R3-5-L}
  [../]

 [./R3CLP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-5} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-5
    HT_surface_area_density_left = ${aw_R3-5-R}
    width_of_hs = ${w_R3-5-R}
    radius_i = ${rad_R3-5-R}
  [../]

  [./R3LP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-6
    HT_surface_area_density_right = ${aw_R3-6-L}
    width_of_hs = ${w_R3-6-L}
    radius_i = ${rad_R3-6-L}
  [../]

 [./R3CLP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-6} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-6
    HT_surface_area_density_left = ${aw_R3-6-R}
    width_of_hs = ${w_R3-6-R}
    radius_i = ${rad_R3-6-R}
  [../]

  [./R3LP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-7
    HT_surface_area_density_right = ${aw_R3-7-L}
    width_of_hs = ${w_R3-7-L}
    radius_i = ${rad_R3-7-L}
  [../]

 [./R3CLP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-7} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-7
    HT_surface_area_density_left = ${aw_R3-7-R}
    width_of_hs = ${w_R3-7-R}
    radius_i = ${rad_R3-7-R}
  [../]

  [./R3LP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-8
    HT_surface_area_density_right = ${aw_R3-8-L}
    width_of_hs = ${w_R3-8-L}
    radius_i = ${rad_R3-8-L}
  [../]

 [./R3CLP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-8} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-8
    HT_surface_area_density_left = ${aw_R3-8-R}
    width_of_hs = ${w_R3-8-R}
    radius_i = ${rad_R3-8-R}
  [../]

  [./R3LP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-9
    HT_surface_area_density_right = ${aw_R3-9-L}
    width_of_hs = ${w_R3-9-L}
    radius_i = ${rad_R3-9-L}
  [../]

 [./R3CLP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-9} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-9
    HT_surface_area_density_left = ${aw_R3-9-R}
    width_of_hs = ${w_R3-9-R}
    radius_i = ${rad_R3-9-R}
  [../]

  [./R3LP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-10
    HT_surface_area_density_right = ${aw_R3-10-L}
    width_of_hs = ${w_R3-10-L}
    radius_i = ${rad_R3-10-L}
  [../]

 [./R3CLP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-10} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-10
    HT_surface_area_density_left = ${aw_R3-10-R}
    width_of_hs = ${w_R3-10-R}
    radius_i = ${rad_R3-10-R}
  [../]

  [./R3LP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_LHS_param
    name_comp_right= R3CLP-11
    HT_surface_area_density_right = ${aw_R3-11-L}
    width_of_hs = ${w_R3-11-L}
    radius_i = ${rad_R3-11-L}
  [../]

 [./R3CLP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R3C-11} -${axial_length_3}'
    input_parameters = R3LP_channelParam
  [../]

  [./R3LP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R3LP_RHS_param
    name_comp_left= R3CLP-11
    HT_surface_area_density_left = ${aw_R3-11-R}
    width_of_hs = ${w_R3-11-R}
    radius_i = ${rad_R3-11-R}
  [../]

  [./Gap_R3LP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_1-R:outer_wall'
    surface2_name = 'R3LP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_2-R:outer_wall'
    surface2_name = 'R3LP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_3-R:outer_wall'
    surface2_name = 'R3LP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_4-R:outer_wall'
    surface2_name = 'R3LP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_5-R:outer_wall'
    surface2_name = 'R3LP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_6-R:outer_wall'
    surface2_name = 'R3LP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_7-R:outer_wall'
    surface2_name = 'R3LP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_8-R:outer_wall'
    surface2_name = 'R3LP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_9-R:outer_wall'
    surface2_name = 'R3LP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_10-R:outer_wall'
    surface2_name = 'R3LP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_11-R:outer_wall'
    surface2_name = 'R4LP_1-L:inner_wall'
    width = ${w_Gap-3}
    radius_1 = ${rad_Gap-3}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

#####R4-ring starting ###
  [./R4LP_1-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-1
    HT_surface_area_density_right = ${aw_R4-1-L}
    width_of_hs = ${w_R4-1-L}
    radius_i = ${rad_R4-1-L}
  [../]

 [./R4CLP-1]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-1} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_1-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-1
    HT_surface_area_density_left = ${aw_R4-1-R}
    width_of_hs = ${w_R4-1-R}
    radius_i = ${rad_R4-1-R}
  [../]

  [./R4LP_2-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-2
    HT_surface_area_density_right = ${aw_R4-2-L}
    width_of_hs = ${w_R4-2-L}
    radius_i = ${rad_R4-2-L}
  [../]

 [./R4CLP-2]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-2} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_2-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-2
    HT_surface_area_density_left = ${aw_R4-2-R}
    width_of_hs = ${w_R4-2-R}
    radius_i = ${rad_R4-2-R}
  [../]


  [./R4LP_3-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-3
    HT_surface_area_density_right = ${aw_R4-3-L}
    width_of_hs = ${w_R4-3-L}
    radius_i = ${rad_R4-3-L}
  [../]

 [./R4CLP-3]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-3} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_3-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-3
    HT_surface_area_density_left = ${aw_R4-3-R}
    width_of_hs = ${w_R4-3-R}
    radius_i = ${rad_R4-3-R}
  [../]


  [./R4LP_4-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-4
    HT_surface_area_density_right = ${aw_R4-4-L}
    width_of_hs = ${w_R4-4-L}
    radius_i = ${rad_R4-4-L}
  [../]

 [./R4CLP-4]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-4} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_4-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-4
    HT_surface_area_density_left = ${aw_R4-4-R}
    width_of_hs = ${w_R4-4-R}
    radius_i = ${rad_R4-4-R}
  [../]


  [./R4LP_5-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-5
    HT_surface_area_density_right = ${aw_R4-5-L}
    width_of_hs = ${w_R4-5-L}
    radius_i = ${rad_R4-5-L}
  [../]

 [./R4CLP-5]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-5} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_5-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-5
    HT_surface_area_density_left = ${aw_R4-5-R}
    width_of_hs = ${w_R4-5-R}
    radius_i = ${rad_R4-5-R}
  [../]

  [./R4LP_6-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-6
    HT_surface_area_density_right = ${aw_R4-6-L}
    width_of_hs = ${w_R4-6-L}
    radius_i = ${rad_R4-6-L}
  [../]

 [./R4CLP-6]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-6} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_6-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-6
    HT_surface_area_density_left = ${aw_R4-6-R}
    width_of_hs = ${w_R4-6-R}
    radius_i = ${rad_R4-6-R}
  [../]

  [./R4LP_7-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-7
    HT_surface_area_density_right = ${aw_R4-7-L}
    width_of_hs = ${w_R4-7-L}
    radius_i = ${rad_R4-7-L}
  [../]

 [./R4CLP-7]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-7} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_7-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-7
    HT_surface_area_density_left = ${aw_R4-7-R}
    width_of_hs = ${w_R4-7-R}
    radius_i = ${rad_R4-7-R}
  [../]

  [./R4LP_8-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-8
    HT_surface_area_density_right = ${aw_R4-8-L}
    width_of_hs = ${w_R4-8-L}
    radius_i = ${rad_R4-8-L}
  [../]

 [./R4CLP-8]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-8} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_8-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-8
    HT_surface_area_density_left = ${aw_R4-8-R}
    width_of_hs = ${w_R4-8-R}
    radius_i = ${rad_R4-8-R}
  [../]

  [./R4LP_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-9
    HT_surface_area_density_right = ${aw_R4-9-L}
    width_of_hs = ${w_R4-9-L}
    radius_i = ${rad_R4-9-L}
  [../]

 [./R4CLP-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-9} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-9
    HT_surface_area_density_left = ${aw_R4-9-R}
    width_of_hs = ${w_R4-9-R}
    radius_i = ${rad_R4-9-R}
  [../]

  [./R4LP_10-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-10
    HT_surface_area_density_right = ${aw_R4-10-L}
    width_of_hs = ${w_R4-10-L}
    radius_i = ${rad_R4-10-L}
  [../]

 [./R4CLP-10]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-10} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_10-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-10
    HT_surface_area_density_left = ${aw_R4-10-R}
    width_of_hs = ${w_R4-10-R}
    radius_i = ${rad_R4-10-R}
  [../]

  [./R4LP_11-L]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_LHS_param
    name_comp_right= R4CLP-11
    HT_surface_area_density_right = ${aw_R4-11-L}
    width_of_hs = ${w_R4-11-L}
    radius_i = ${rad_R4-11-L}
  [../]

 [./R4CLP-11]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-11} -${axial_length_3}'
    input_parameters = R4LP_channelParam
  [../]

  [./R4LP_11-R]
    type = PBCoupledHeatStructure
    input_parameters = R4LP_RHS_param
    name_comp_left= R4CLP-11
    HT_surface_area_density_left = ${aw_R4-11-R}
    width_of_hs = ${w_R4-11-R}
    radius_i = ${rad_R4-11-R}
  [../]

  [./Gap_R4LP_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_1-R:outer_wall'
    surface2_name = 'R4LP_2-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_2-R:outer_wall'
    surface2_name = 'R4LP_3-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_3-R:outer_wall'
    surface2_name = 'R4LP_4-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_4-R:outer_wall'
    surface2_name = 'R4LP_5-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_5-R:outer_wall'
    surface2_name = 'R4LP_6-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_6-R:outer_wall'
    surface2_name = 'R4LP_7-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_7-R:outer_wall'
    surface2_name = 'R4LP_8-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_8-R:outer_wall'
    surface2_name = 'R4LP_9-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_9-R:outer_wall'
    surface2_name = 'R4LP_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_10-R:outer_wall'
    surface2_name = 'R4LP_11-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LP_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_11-R:outer_wall'
    surface2_name = 'R5LP:inner_wall'
    width = ${w_Gap-4}
    radius_1 = ${rad_Gap-4}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

### Ring 5
  [./R5LP]
    type = PBCoupledHeatStructure
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    width_of_hs = ${w_R5}
    elem_number_radial = ${radial_nElem_R1and5}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'graphite-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Adiabatic'
    radius_i = ${rad_R5}
  [../]
####Ring#6 starting ###
  [./Gap5LP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R5LP:outer_wall'
    surface2_name = 'R6LP:inner_wall'
    width = ${w_Gap-5}
    radius_1 =${rad_Gap-5}
    length = ${axial_length_3}
    eos = eos
    h_gap =${hGap_cond}
  [../]


  [./R6LP]
    type = PBCoupledHeatStructure
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    width_of_hs = ${w_R6}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
    HS_BC_type = 'Adiabatic Coupled'
    name_comp_right= R6LP_C
    HT_surface_area_density_right = ${aw_R6}
    eos_right = eos
    radius_i = ${rad_R6}
  [../]

[./R6LP_C]
    type = PBOneDFluidComponent
    position = '0 ${rad_R6C} -${axial_length_3}'
    orientation = '0 0 1'
    eos = eos
    length = ${axial_length_3}
    A = ${aw_tot}
    Dh = ${Dh_tot}
    HTC_geometry_type = Pipe # pipe model
    n_elems = ${axial_nElem_3}
#    f = ${fric_coef}                            # User specified friction coefficient (Blausis f=(100 Re)^-0.25
#    Hw = ${wallHeatTrans_coef}                  # User specified heat transfer coefficient (Dittus-Boelter)
  [../]


####Ring#7 starting ###
  [./R7LP]
    type = PBCoupledHeatStructure
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length = ${axial_length_3}
    width_of_hs = ${w_R7}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Coupled Adiabatic'
#    T_bc_right = 303
    name_comp_left= R6LP_C
    HT_surface_area_density_left = ${aw_R6}
    eos_left = eos
    radius_i = ${rad_R7}
  [../]

  [./GapR6CLP_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R6LP:outer_wall'
    surface2_name = 'R7LP:inner_wall'
    radius_1 =${rad_R6}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]


###RCCS Ring

  [./RCCS_LP]
    type = PBCoupledHeatStructure
    position = '0 0 -${axial_length_3}'
    orientation = '0 0 1'
    hs_type = cylinder
    length =  ${axial_length_3}
    width_of_hs = ${w_RCCS}
    elem_number_radial =${radial_nElem_1}
    elem_number_axial = ${axial_nElem_3}
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${Ts_1}
     HS_BC_type = 'Adiabatic Convective'
    Hw_right = ${h_air_natural_conv}
    T_amb_right = 300
    eos_right =eos_air
    radius_i = ${rad_RCCS}
  [../]

## Only radiation for RCCS
  [./GapRCCS_LP_RHT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = RadiationHeatTransfer
    surface1_name = 'R7LP:outer_wall'
    surface2_name = 'RCCS_LP:inner_wall'
    radius_1 =${rad_RCCS}
    epsilon_1 = 0.8
    epsilon_2 = 0.8
  [../]

  [./GapRCCS-LP_tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'RCCS_LP:top_wall'
    surface2_name = 'RCCS_AC:bottom_wall'
    h_gap = ${hGap_cond}
  [../]

###

  [./GapR1LPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R1:bottom_wall'
    surface2_name = 'R1LP:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-L:bottom_wall'
    surface2_name = 'R2LP_1-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-R:bottom_wall'
    surface2_name = 'R2LP_1-R:top_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R2LP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-L:bottom_wall'
    surface2_name = 'R2LP_2-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-R:bottom_wall'
    surface2_name = 'R2LP_2-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-L:bottom_wall'
    surface2_name = 'R2LP_3-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-R:bottom_wall'
    surface2_name = 'R2LP_3-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-L:bottom_wall'
    surface2_name = 'R2LP_4-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-R:bottom_wall'
    surface2_name = 'R2LP_4-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-L:bottom_wall'
    surface2_name = 'R2LP_5-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-R:bottom_wall'
    surface2_name = 'R2LP_5-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-L:bottom_wall'
    surface2_name = 'R2LP_6-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-R:bottom_wall'
    surface2_name = 'R2LP_6-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-L:bottom_wall'
    surface2_name = 'R2LP_7-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-R:bottom_wall'
    surface2_name = 'R2LP_7-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-L:bottom_wall'
    surface2_name = 'R2LP_8-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-R:bottom_wall'
    surface2_name = 'R2LP_8-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-L:bottom_wall'
    surface2_name = 'R2LP_9-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-R:bottom_wall'
    surface2_name = 'R2LP_9-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-L:bottom_wall'
    surface2_name = 'R2LP_10-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-R:bottom_wall'
    surface2_name = 'R2LP_10-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-L:bottom_wall'
    surface2_name = 'R2LP_11-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R2LP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-R:bottom_wall'
    surface2_name = 'R2LP_11-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-L:bottom_wall'
    surface2_name = 'R3LP_1-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-R:bottom_wall'
    surface2_name = 'R3LP_1-R:top_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R3LP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-L:bottom_wall'
    surface2_name = 'R3LP_2-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-R:bottom_wall'
    surface2_name = 'R3LP_2-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-L:bottom_wall'
    surface2_name = 'R3LP_3-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-R:bottom_wall'
    surface2_name = 'R3LP_3-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-L:bottom_wall'
    surface2_name = 'R3LP_4-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-R:bottom_wall'
    surface2_name = 'R3LP_4-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-L:bottom_wall'
    surface2_name = 'R3LP_5-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-R:bottom_wall'
    surface2_name = 'R3LP_5-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-L:bottom_wall'
    surface2_name = 'R3LP_6-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-R:bottom_wall'
    surface2_name = 'R3LP_6-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-L:bottom_wall'
    surface2_name = 'R3LP_7-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-R:bottom_wall'
    surface2_name = 'R3LP_7-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-L:bottom_wall'
    surface2_name = 'R3LP_8-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-R:bottom_wall'
    surface2_name = 'R3LP_8-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-L:bottom_wall'
    surface2_name = 'R3LP_9-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-R:bottom_wall'
    surface2_name = 'R3LP_9-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-L:bottom_wall'
    surface2_name = 'R3LP_10-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-R:bottom_wall'
    surface2_name = 'R3LP_10-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-L:bottom_wall'
    surface2_name = 'R3LP_11-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R3LP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-R:bottom_wall'
    surface2_name = 'R3LP_11-R:top_wall'
    h_gap = ${hGap_cond}
  [../]
##############
##############
  [./Gap_R4LP_1-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-L:bottom_wall'
    surface2_name = 'R4LP_1-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_1-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-R:bottom_wall'
    surface2_name = 'R4LP_1-R:top_wall'
    h_gap = ${hGap_cond}
  [../]
##
  [./Gap_R4LP_2-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-L:bottom_wall'
    surface2_name = 'R4LP_2-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_2-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-R:bottom_wall'
    surface2_name = 'R4LP_2-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_3-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-L:bottom_wall'
    surface2_name = 'R4LP_3-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_3-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-R:bottom_wall'
    surface2_name = 'R4LP_3-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_4-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-L:bottom_wall'
    surface2_name = 'R4LP_4-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_4-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-R:bottom_wall'
    surface2_name = 'R4LP_4-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_5-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-L:bottom_wall'
    surface2_name = 'R4LP_5-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_5-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-R:bottom_wall'
    surface2_name = 'R4LP_5-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_6-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-L:bottom_wall'
    surface2_name = 'R4LP_6-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_6-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-R:bottom_wall'
    surface2_name = 'R4LP_6-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_7-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-L:bottom_wall'
    surface2_name = 'R4LP_7-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_7-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-R:bottom_wall'
    surface2_name = 'R4LP_7-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_8-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-L:bottom_wall'
    surface2_name = 'R4LP_8-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_8-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-R:bottom_wall'
    surface2_name = 'R4LP_8-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_9-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-L:bottom_wall'
    surface2_name = 'R4LP_9-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_9-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-R:bottom_wall'
    surface2_name = 'R4LP_9-R:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_10-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-L:bottom_wall'
    surface2_name = 'R4LP_10-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_10-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-R:bottom_wall'
    surface2_name = 'R4LP_10-R:top_wall'
    h_gap = ${hGap_cond}
  [../]


  [./Gap_R4LP_11-L-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-L:bottom_wall'
    surface2_name = 'R4LP_11-L:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap_R4LP_11-R-tb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-R:bottom_wall'
    surface2_name = 'R4LP_11-R:top_wall'
    h_gap = ${hGap_cond}
  [../]
##############
  [./Gap5LPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R5:bottom_wall'
    surface2_name = 'R5LP:top_wall'
    h_gap = ${hGap_cond}
  [../]

  [./Gap6LPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R6:bottom_wall'
    surface2_name = 'R6LP:top_wall'
    h_gap = ${hGap_cond}
  [../]


  [./Gap7LPtb_HT]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R7:bottom_wall'
    surface2_name = 'R7LP:top_wall'
    h_gap = ${hGap_cond}
  [../]
################################
  [./Branch_R2CLP-1]
    type = PBSingleJunction
    inputs = 'R2C-1(in)'
    outputs = 'R2CLP-1(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-2]
    type = PBSingleJunction
    inputs = 'R2C-2(in)'
    outputs = 'R2CLP-2(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-3]
    type = PBSingleJunction
    inputs = 'R2C-3(in)'
    outputs = 'R2CLP-3(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-4]
    type = PBSingleJunction
    inputs = 'R2C-4(in)'
    outputs = 'R2CLP-4(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-5]
    type = PBSingleJunction
    inputs = 'R2C-5(in)'
    outputs = 'R2CLP-5(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-6]
    type = PBSingleJunction
    inputs = 'R2C-6(in)'
    outputs = 'R2CLP-6(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-7]
    type = PBSingleJunction
    inputs = 'R2C-7(in)'
    outputs = 'R2CLP-7(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-8]
    type = PBSingleJunction
    inputs = 'R2C-8(in)'
    outputs = 'R2CLP-8(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-9]
    type = PBSingleJunction
    inputs = 'R2C-9(in)'
    outputs = 'R2CLP-9(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-10]
    type = PBSingleJunction
    inputs = 'R2C-10(in)'
    outputs = 'R2CLP-10(out)'
    eos = eos
  [../]
  [./Branch_R2CLP-11]
    type = PBSingleJunction
    inputs = 'R2C-11(in)'
    outputs = 'R2CLP-11(out)'
    eos = eos
  [../]
###
  [./Branch_R3CLP-1]
    type = PBSingleJunction
    inputs = 'R3C-1(in)'
    outputs = 'R3CLP-1(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-2]
    type = PBSingleJunction
    inputs = 'R3C-2(in)'
    outputs = 'R3CLP-2(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-3]
    type = PBSingleJunction
    inputs = 'R3C-3(in)'
    outputs = 'R3CLP-3(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-4]
    type = PBSingleJunction
    inputs = 'R3C-4(in)'
    outputs = 'R3CLP-4(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-5]
    type = PBSingleJunction
    inputs = 'R3C-5(in)'
    outputs = 'R3CLP-5(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-6]
    type = PBSingleJunction
    inputs = 'R3C-6(in)'
    outputs = 'R3CLP-6(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-7]
    type = PBSingleJunction
    inputs = 'R3C-7(in)'
    outputs = 'R3CLP-7(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-8]
    type = PBSingleJunction
    inputs = 'R3C-8(in)'
    outputs = 'R3CLP-8(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-9]
    type = PBSingleJunction
    inputs = 'R3C-9(in)'
    outputs = 'R3CLP-9(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-10]
    type = PBSingleJunction
    inputs = 'R3C-10(in)'
    outputs = 'R3CLP-10(out)'
    eos = eos
  [../]
  [./Branch_R3CLP-11]
    type = PBSingleJunction
    inputs = 'R3C-11(in)'
    outputs = 'R3CLP-11(out)'
    eos = eos
  [../]
#######
  [./Branch_R4CLP-1]
    type = PBSingleJunction
    inputs = 'R4C-1(in)'
    outputs = 'R4CLP-1(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-2]
    type = PBSingleJunction
    inputs = 'R4C-2(in)'
    outputs = 'R4CLP-2(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-3]
    type = PBSingleJunction
    inputs = 'R4C-3(in)'
    outputs = 'R4CLP-3(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-4]
    type = PBSingleJunction
    inputs = 'R4C-4(in)'
    outputs = 'R4CLP-4(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-5]
    type = PBSingleJunction
    inputs = 'R4C-5(in)'
    outputs = 'R4CLP-5(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-6]
    type = PBSingleJunction
    inputs = 'R4C-6(in)'
    outputs = 'R4CLP-6(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-7]
    type = PBSingleJunction
    inputs = 'R4C-7(in)'
    outputs = 'R4CLP-7(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-8]
    type = PBSingleJunction
    inputs = 'R4C-8(in)'
    outputs = 'R4CLP-8(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-9]
    type = PBSingleJunction
    inputs = 'R4C-9(in)'
    outputs = 'R4CLP-9(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-10]
    type = PBSingleJunction
    inputs = 'R4C-10(in)'
    outputs = 'R4CLP-10(out)'
    eos = eos
  [../]
  [./Branch_R4CLP-11]
    type = PBSingleJunction
    inputs = 'R4C-11(in)'
    outputs = 'R4CLP-11(out)'
    eos = eos
  [../]

  [./Branch_R6LP]
    type = PBSingleJunction
    inputs = 'R6_C(in)'
    outputs = 'R6LP_C(out)'
    eos = eos
  [../]

#### Channel Gap heat trasfer

  [./Gap_R2C_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_1-L:outer_wall'
    surface2_name = 'R2_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_2-L:outer_wall'
    surface2_name = 'R2_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_3-L:outer_wall'
    surface2_name = 'R2_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R2C_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_4-L:outer_wall'
    surface2_name = 'R2_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_5-L:outer_wall'
    surface2_name = 'R2_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_6-L:outer_wall'
    surface2_name = 'R2_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_7-L:outer_wall'
    surface2_name = 'R2_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_8-L:outer_wall'
    surface2_name = 'R2_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_9-L:outer_wall'
    surface2_name = 'R2_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_10-L:outer_wall'
    surface2_name = 'R2_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2C_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2_11-L:outer_wall'
    surface2_name = 'R2_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-11-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

##ring 3
  [./Gap_R3C_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_1-L:outer_wall'
    surface2_name = 'R3_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_2-L:outer_wall'
    surface2_name = 'R3_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_3-L:outer_wall'
    surface2_name = 'R3_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R3C_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_4-L:outer_wall'
    surface2_name = 'R3_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_5-L:outer_wall'
    surface2_name = 'R3_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_6-L:outer_wall'
    surface2_name = 'R3_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_7-L:outer_wall'
    surface2_name = 'R3_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_8-L:outer_wall'
    surface2_name = 'R3_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_9-L:outer_wall'
    surface2_name = 'R3_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_10-L:outer_wall'
    surface2_name = 'R3_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3C_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3_11-L:outer_wall'
    surface2_name = 'R3_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-11-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
##3ring 4
  [./Gap_R4C_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_1-L:outer_wall'
    surface2_name = 'R4_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_2-L:outer_wall'
    surface2_name = 'R4_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_3-L:outer_wall'
    surface2_name = 'R4_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R4C_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_4-L:outer_wall'
    surface2_name = 'R4_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_5-L:outer_wall'
    surface2_name = 'R4_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_6-L:outer_wall'
    surface2_name = 'R4_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_7-L:outer_wall'
    surface2_name = 'R4_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_8-L:outer_wall'
    surface2_name = 'R4_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-L:outer_wall'
    surface2_name = 'R4_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_10-L:outer_wall'
    surface2_name = 'R4_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4C_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_11-L:outer_wall'
    surface2_name = 'R4_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-11-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
#### Ring2 Upper sturcture
  [./Gap_R2UPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_1-L:outer_wall'
    surface2_name = 'R2UP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_2-L:outer_wall'
    surface2_name = 'R2UP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_3-L:outer_wall'
    surface2_name = 'R2UP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R2UPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_4-L:outer_wall'
    surface2_name = 'R2UP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_5-L:outer_wall'
    surface2_name = 'R2UP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_6-L:outer_wall'
    surface2_name = 'R2UP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_7-L:outer_wall'
    surface2_name = 'R2UP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_8-L:outer_wall'
    surface2_name = 'R2UP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_9-L:outer_wall'
    surface2_name = 'R2UP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_10-L:outer_wall'
    surface2_name = 'R2UP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2UPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2UP_11-L:outer_wall'
    surface2_name = 'R2UP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-11-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
##Ring 3 Upper sturcture
  [./Gap_R3UPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_1-L:outer_wall'
    surface2_name = 'R3UP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_2-L:outer_wall'
    surface2_name = 'R3UP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_3-L:outer_wall'
    surface2_name = 'R3UP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R3UPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_4-L:outer_wall'
    surface2_name = 'R3UP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_5-L:outer_wall'
    surface2_name = 'R3UP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_6-L:outer_wall'
    surface2_name = 'R3UP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_7-L:outer_wall'
    surface2_name = 'R3UP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_8-L:outer_wall'
    surface2_name = 'R3UP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_9-L:outer_wall'
    surface2_name = 'R3UP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_10-L:outer_wall'
    surface2_name = 'R3UP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3UPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3UP_11-L:outer_wall'
    surface2_name = 'R3UP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-11-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


##ring 4 Upper sturcture
  [./Gap_R4UPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_1-L:outer_wall'
    surface2_name = 'R4UP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_2-L:outer_wall'
    surface2_name = 'R4UP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_3-L:outer_wall'
    surface2_name = 'R4UP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R4UPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_4-L:outer_wall'
    surface2_name = 'R4UP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_5-L:outer_wall'
    surface2_name = 'R4UP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_6-L:outer_wall'
    surface2_name = 'R4UP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_7-L:outer_wall'
    surface2_name = 'R4UP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_8-L:outer_wall'
    surface2_name = 'R4UP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_9-L:outer_wall'
    surface2_name = 'R4UP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_10-L:outer_wall'
    surface2_name = 'R4UP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4UPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4UP_11-L:outer_wall'
    surface2_name = 'R4UP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-11-L}
    length = ${axial_length_2}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
### R2 ring LP
  [./Gap_R2LPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_1-L:outer_wall'
    surface2_name = 'R2LP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_2-L:outer_wall'
    surface2_name = 'R2LP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_3-L:outer_wall'
    surface2_name = 'R2LP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R2LPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_4-L:outer_wall'
    surface2_name = 'R2LP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_5-L:outer_wall'
    surface2_name = 'R2LP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_6-L:outer_wall'
    surface2_name = 'R2LP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_7-L:outer_wall'
    surface2_name = 'R2LP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_8-L:outer_wall'
    surface2_name = 'R2LP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_9-L:outer_wall'
    surface2_name = 'R2LP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_10-L:outer_wall'
    surface2_name = 'R2LP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R2LPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R2LP_11-L:outer_wall'
    surface2_name = 'R2LP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R2-11-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
##R3 ring LP
  [./Gap_R3LPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_1-L:outer_wall'
    surface2_name = 'R3LP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_2-L:outer_wall'
    surface2_name = 'R3LP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_3-L:outer_wall'
    surface2_name = 'R3LP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R3LPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_4-L:outer_wall'
    surface2_name = 'R3LP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_5-L:outer_wall'
    surface2_name = 'R3LP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_6-L:outer_wall'
    surface2_name = 'R3LP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_7-L:outer_wall'
    surface2_name = 'R3LP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_8-L:outer_wall'
    surface2_name = 'R3LP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_9-L:outer_wall'
    surface2_name = 'R3LP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_10-L:outer_wall'
    surface2_name = 'R3LP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R3LPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R3LP_11-L:outer_wall'
    surface2_name = 'R3LP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R3-11-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]
##R4 ring LP
  [./Gap_R4LPC_1]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_1-L:outer_wall'
    surface2_name = 'R4LP_1-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-1-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_2]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_2-L:outer_wall'
    surface2_name = 'R4LP_2-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-2-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_3]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_3-L:outer_wall'
    surface2_name = 'R4LP_3-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-3-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


  [./Gap_R4LPC_4]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_4-L:outer_wall'
    surface2_name = 'R4LP_4-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-4-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_5]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_5-L:outer_wall'
    surface2_name = 'R4LP_5-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-5-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_6]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_6-L:outer_wall'
    surface2_name = 'R4LP_6-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-6-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_7]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_7-L:outer_wall'
    surface2_name = 'R4LP_7-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-7-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_8]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_8-L:outer_wall'
    surface2_name = 'R4LP_8-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-8-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_9-L:outer_wall'
    surface2_name = 'R4LP_9-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_10]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_10-L:outer_wall'
    surface2_name = 'R4LP_10-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-10-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]

  [./Gap_R4LPC_11]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4LP_11-L:outer_wall'
    surface2_name = 'R4LP_11-R:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-11-L}
    length = ${axial_length_3}
    eos = eos
    h_gap =  ${hGap_cond}
  [../]


####
  [./U_plenum]
    type = PBVolumeBranch
    center = '0 0 ${Uplenum_z}'
     outputs = 'R2CUP-1(out) R2CUP-2(out) R2CUP-3(out) R2CUP-4(out) R2CUP-5(out) R2CUP-6(out) R2CUP-7(out) R2CUP-8(out)
               R2CUP-9(out) R2CUP-10(out) R2CUP-11(out)
   R3CUP-1(out) R3CUP-2(out) R3CUP-3(out) R3CUP-4(out) R3CUP-5(out) R3CUP-6(out) R3CUP-7(out) R3CUP-8(out)
               R3CUP-9(out) R3CUP-10(out) R3CUP-11(out)
  R4CUP-1(out) R4CUP-2(out) R4CUP-3(out) R4CUP-4(out) R4CUP-5(out) R4CUP-6(out) R4CUP-7(out) R4CUP-8(out)
               R4CUP-9(out) R4CUP-10(out) R4CUP-11(out)'
     inputs = 'R6UP_C(out)'
     K = '0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'

     Area = 40.43
     volume = 60.5

    initial_P = ${p_out}
    initial_T = ${T_out}
#    initial_V = 1.30
    eos = eos
    display_pps = true
    nodal_Tbc = true
  [../]


  [./L_plenum]
    type = PBVolumeBranch
    center = '0 0 ${Lplenum_z}'
     inputs = 'R2CLP-1(in) R2CLP-2(in) R2CLP-3(in) R2CLP-4(in) R2CLP-5(in) R2CLP-6(in) R2CLP-7(in) R2CLP-8(in)
               R2CLP-9(in) R2CLP-10(in) R2CLP-11(in)
  R3CLP-1(in) R3CLP-2(in) R3CLP-3(in) R3CLP-4(in) R3CLP-5(in) R3CLP-6(in) R3CLP-7(in) R3CLP-8(in)
               R3CLP-9(in) R3CLP-10(in) R3CLP-11(in)
  R4CLP-1(in) R4CLP-2(in) R4CLP-3(in) R4CLP-4(in) R4CLP-5(in) R4CLP-6(in) R4CLP-7(in) R4CLP-8(in)
               R4CLP-9(in) R4CLP-10(in) R4CLP-11(in)'
    outputs = 'EHXin_pipe1(in)'
#    outputs = 'pipe_exit(in)'
     K = '0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0'
    Area = 40.43
    volume = 32.06
    initial_P = ${p_out}
    initial_T = ${T_out}
#    initial_V = 1.30
    eos = eos
    display_pps = true
    nodal_Tbc = true
  [../]

#####  EHX ####
  [./EHX]
    type = PBHeatExchanger
    eos = eos
#    eos_secondary = eos_water
    eos_secondary = eos
    position = '0 8.5 -6.439257'
    orientation = '0 0 -1'
    A = 0.766e1
    A_secondary = 0.5170021e1   #0.517e1
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 8.0
    n_elems = 40
    initial_V_secondary = -2
    Hw = ${EHX_hCoef}
    Hw_secondary = ${EHX_hCoef}
    HTC_geometry_type = Pipe # pipe model
    HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 729
    HT_surface_area_density_secondary = 1080.1
    Twall_init = ${Ts_1}
    wall_thickness = 0.0033
    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 3
  [../]
###EHX secondary side pipes for visulaization
#  [./EHXsin_pipe1]
#    type = PBOneDFluidComponent
#    eos = eos
#    position = '0 8 -6'
#    orientation = '0 1 0'
#    A = ${aw_tot}
#    Dh = ${channel_dia}
#    length = 0.5
#    n_elems = 2
#    f = ${fric_coef}
#  [../]

#  [./EHXsout_pipe1]
#    type = PBOneDFluidComponent
#    eos = eos
#    position = '0 8.5 -2'
#    orientation = '0 -1 0'
#    A = ${aw_tot}
#    Dh = ${channel_dia}
#    length = 0.5
#    n_elems = 2
#    f = ${fric_coef}
#  [../]

#  [./Branch_EHXsin]
#    type = PBSingleJunction
#    inputs = 'EHXsin_pipe1(out)'
#    outputs = 'EHX(secondary_in)'
#    eos = eos
#  [../]

#  [./Branch_EHXsout]
#    type = PBSingleJunction
#    inputs = 'EHX(secondary_out)'
#    outputs = 'EHXsout_pipe1(in)'
#    eos = eos
#  [../]

###EHX primary side pipes for visulaization

  [./EHXin_pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 0 ${Lplenum_z}'
    orientation = '0 1 0'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 8.5
    n_elems = 20
    Hw = 0
  [../]

  [./EHXin_veritcal_Pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.5 ${Lplenum_z}'
    orientation = '0 0 -1'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 2
    n_elems = 10
  [../]

  [./Branch_EHX3]
    type = PBSingleJunction
    inputs = 'EHXin_pipe1(out)'
    outputs = 'EHXin_veritcal_Pipe1(in)'
    eos = eos
  [../]

  [./Branch_EHX4]
    type = PBSingleJunction
    inputs = 'EHXin_veritcal_Pipe1(out)'
    outputs = 'EHX(primary_in)'
    eos = eos
  [../]

  [./EHXout_pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.3 ${Lplenum_z}'
    orientation = '0 -1 0'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 2.8
    n_elems = 10
  [../]

  [./EHXout_veritcal_Pipe1]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.3 -14.43926'
    orientation = '0 0 1'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 10
    n_elems = 20
  [../]

  [./EHXout_pipe2]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 8.5 -14.43926'
    orientation = '0 -1 0'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 0.2
    n_elems = 5
  [../]

  [./Branch_EHXout1]
    type = PBSingleJunction
    inputs = 'EHX(primary_out)'
    outputs = 'EHXout_pipe2(in)'
    eos = eos
  [../]

  [./Branch_EHXout2]
    type = PBSingleJunction
    inputs = 'EHXout_veritcal_Pipe1(in)'
    outputs = 'EHXout_pipe2(out)'
    eos = eos
  [../]

  [./Branch_EHXout3]
    type = PBSingleJunction
    inputs = 'EHXout_veritcal_Pipe1(out)'
    outputs = 'EHXout_pipe1(in)'
    eos = eos
  [../]

###

  [./EHXLoop_in]
    type = PBTDJ
#    input = 'EHXsin_pipe1(in)'
    input = 'EHX(secondary_in)'
#    v_fn = flow_secondary
    v_bc = -10.68  #0.05
    T_bc = ${Ts_1}
    eos = eos
    weak_bc = true
  [../]

  [./EHXLoop_out]
    type = PressureOutlet
#    input = 'EHXsout_pipe1(out)'
    input = 'EHX(secondary_out)'
    p_bc = '${p_out}'
    eos = eos
  [../]

###### PUMP ######
  [./Pump_p]
    type = PBPump
    eos = eos
    inputs = 'pump_pipe(out)'
    outputs = 'pump_discharge(in)'
    K = '0. 0.'
    Area = ${aw_tot}
    initial_P = ${p_out}
    initial_V = ${v_1}
    Head = 127495.54397557
#    Head_fn = pump_p_coastdown
    Desired_mass_flow_rate = ${tot_massFlowRate}
    Response_interval = 1.0
  [../]

  [./pump_discharge]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 5.5 -4.339257'
    orientation = '0 0 1'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 0.2964
    n_elems = 5
    Hw = 0
  [../]

 [./Branch1]
    type = PBBranch
    inputs = 'EHXout_pipe1(out)'
    outputs = 'pump_pipe(in)'
    K = '0 0'
    Area =  ${aw_tot}
    initial_T = ${Ts_1}
    initial_P = ${p_out}
    eos = eos
  [../]

  [./pump_pipe]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 5.5 ${Lplenum_z}'
    orientation = '0 0 1'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 0.1
    n_elems = 5
    Hw = 0
  [../]

 [./Branch2]
    type = PBBranch
    inputs = 'pump_discharge(out) tank_pipe(out)'
    outputs = 'loop_close(in)'
    K = '0 0 0'
    Area =   ${aw_tot}
    initial_T = ${Ts_1}
    initial_P = ${p_out}
    eos = eos
  [../]


  [./loop_close]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 5.5 -${axial_length_3}'
    orientation = '0 -1 0'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length =2.1075
    n_elems = 10
    Hw = 0
  [../]

  [./Branch_loopClose]
    type = PBSingleJunction
    inputs = 'loop_close(out)'
    outputs = 'R6LP_C(in)'
    eos = eos
  [../]


#### Infinte tank to maintain pressure jump from a pump
  [./tank_pipe]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 6.5 -${axial_length_3}'
    orientation = '0 -1 0'
    A = ${aw_tot}
    Dh = ${channel_dia}
    length = 1.0
    n_elems = 10
    Hw = 0
  [../]

  [./tank_pU]
    type = PBTDV
    input = 'tank_pipe(in)'
    p_bc = '${p_out}'
    T_bc = ${Ts_1}
    eos = eos
  [../]


######## INLET & OUTLET  #####
#  [./inlet1]
#   type = PBTDJ
# input = 'R6LP_C(in)'
#        eos = eos
# v_bc = 26.19
#   T_bc = 623.15
#  [../]

#  [./outlet1]
#   type = PBTDV
#   input = 'pump_discharge(out)'
#        eos = eos
#   p_bc = 70.0e5
#   T_bc = 900
#  [../]

[]



###


[Postprocessors]
#  [./Tin]
#    type = ComponentBoundaryVariableValue
#    variable = temperature
#    input = L_plenum(in)
#  [../]
#  [./R2_Tout]
#    type = ComponentBoundaryVariableValue
#    variable = temperature
#    input = U_plenum(in)
#  [../]

#  [./heat_removal_primary]
#    type = HeatExchangerHeatRemovalRate
#    block = EHX:primary_pipe
#    heated_perimeter = 5584.14
#  [../]
#  [./heat_removal_secondary]
#    type = HeatExchangerHeatRemovalRate
#    block = EHX:secondary_pipe
#    heated_perimeter = 5584.14
#  [../]

####
  [./R2C11_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R2C-11(in)
  [../]

  [./R2C11_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R2C-11(in)
  [../]


  [./R3C11_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R3C-11(in)
  [../]

  [./R3C11_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R3C-11(in)
  [../]

  [./R4C11_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R4C-11(in)
  [../]

  [./R4C11_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R4C-11(in)
  [../]

  [./R6C_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R6_C(in)
  [../]

  [./R6C_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R6_C(in)
  [../]

####
  [./R2C11_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R2C-11(out)
  [../]

  [./R2C11_V_out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R2C-11(out)
  [../]


  [./R3C11_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R3C-11(out)
  [../]

  [./R3C11_V_out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R3C-11(out)
  [../]

  [./R4C11_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R4C-11(out)
  [../]

  [./R4C11_V_out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R4C-11(out)
  [../]

  [./R6C_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R6_C(out)
  [../]

  [./R6C_V_out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R6_C(out)
  [../]

##

  [./EHX_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = EHX(primary_out)
  [../]

  [./EHX_V_out]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = EHX(primary_out)
  [../]

  [./EHX_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = EHX(primary_in)
  [../]

  [./EHX_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = EHX(primary_in)
  [../]

###

  [./RCCS_avG_tmp_AC]
    type = SideAverageValue
    variable = T_solid
    boundary = 'RCCS_AC:outer_wall'
  [../]

  [./RCCS_avG_tmp_LP]
    type = SideAverageValue
    variable = T_solid
    boundary = 'RCCS_LP:outer_wall'
  [../]

  [./RCCS_avG_tmp_UP]
    type = SideAverageValue
    variable = T_solid
    boundary = 'RCCS_UP:outer_wall'
  [../]


#  [./heat_removal_secondary]
#    type = HeatExchangerHeatRemovalRate
#    block = EHX:secondary_pipe
#    heated_perimeter = 5584.14
#  [../]



####


  [./R1_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R1:hs0'
    variable = T_solid
  [../]

  [./R2_1L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R2_1-L:hs0'
    variable = T_solid
  [../]
  [./R2_1R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R2_1-R:hs0'
    variable = T_solid
  [../]


  [./R2_11L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R2_11-L:hs0'
    variable = T_solid
  [../]
  [./R2_11R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R2_11-R:hs0'
    variable = T_solid
  [../]


  [./R3_1L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R3_1-L:hs0'
    variable = T_solid
  [../]
  [./R3_1R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R3_1-R:hs0'
    variable = T_solid
  [../]


  [./R3_11L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R3_11-L:hs0'
    variable = T_solid
  [../]
  [./R3_11R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R3_11-R:hs0'
    variable = T_solid
  [../]

##
  [./R4_1L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R4_1-L:hs0'
    variable = T_solid
  [../]
  [./R4_1R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R4_1-R:hs0'
    variable = T_solid
  [../]


  [./R4_11L_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R4_11-L:hs0'
    variable = T_solid
  [../]
  [./R4_11R_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R4_11-R:hs0'
    variable = T_solid
  [../]

##
  [./R5_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R5:hs0'
    variable = T_solid
  [../]

  [./R6_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R6:hs0'
    variable = T_solid
  [../]


  [./R7_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'R7:hs0'
    variable = T_solid
  [../]

  [./RCCS_max]                               # Output maximum solid temperature of block CH1: solid:fuel
    type = NodalMaxValue
    block = 'RCCS_AC:hs0'
    variable = T_solid
  [../]



###



[]

[Preconditioning]
   active = 'SMP_PJFNK'
  [./SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
  [../]
[] # End preconditioning block

[Executioner]
  type = Transient #Steady
  dt =1.
  dtmin = 1e-3


  start_time = -0.5e6
  end_time = 0   #1e6
  num_steps =30000
 [./TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-6
  [../]


#  [./TimeStepper]
#    type = IterationAdaptiveDT
#    growth_factor = 1.5
#    optimal_iterations = 8
#    linear_iteration_ratio = 150
#    cutback_factor = 0.8
#    cutback_factor_at_failure = 0.8
#    dt = 1.0
#  [../]
# dtmax = 100.



  petsc_options_iname = '-ksp_gmres_restart -pc_type'
  petsc_options_value = '300 lu '
#  line_search = basic

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-5
  nl_max_its = 40

  l_tol = 1e-4 # Relative linear tolerance for each Krylov solve
  l_max_its = 100 # Number of linear iterations for each Krylov solve

   [./Quadrature]
      type = TRAP
      order = FIRST
#      type = GAUSS
#      order = SECOND
   [../]
[] # close Executioner section

#  [Problem]
#   restart_file_base = restart/1388
#  []

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  [./out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
   interval =10
  [../]

  [./checkpoint]
    type = Checkpoint
    num_files = 1
  [../]

  [./console]
    type = Console
  [../]

  [./csv]
    type = CSV
  []

[]
