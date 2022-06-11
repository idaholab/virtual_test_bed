[GlobalParams]
  global_init_P = 1e5
  global_init_V = 1
  global_init_T = 628.15
  Tsolid_sf = 1e-3

  [PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
  []
[]

[EOS]
  [eos]
     type = PBSodiumEquationOfState
  []
[]

[Functions]
  [time_stepper]
    type = PiecewiseLinear
    x = '-1000  -499.9   -499.8   -499   -498   -450  -449   -1     0       2     3   10   11  380   381    440   441   1e5'
    y =' 0.02    0.02      0.2    0.2    0.5    0.5     2    2   0.2     0.2   0.5  0.5    2    2     2      2     5     5'
  []

  [ppf_axial]
    type = PiecewiseLinear
    x = '0.0  0.0200  0.0600  0.100  0.140  0.180  0.220  0.260  0.300  0.340    0.380
         0.420  0.460  0.500  0.540  0.580  0.620  0.660  0.700  0.740    0.780   0.800'
    y = '7.818e-1 8.12035e-1 8.72501e-1 9.43054e-1 1.01107 1.04739 1.09779 1.13790 1.16662 1.17569 1.18022
         1.17255 1.15267 1.13305 1.08829 1.03142 9.62681e-1 9.08601e-1 8.11380e-1 7.04156e-1 5.90929e-1 5.34316e-1'
    axis = x
  []

  [rho_func]
    type = PiecewiseLinear
    x ='-5000.0      0.0  70  500  700  1000  5000.0'
    y ='0.0          0.0  -4.67292E-04  -3.33780E-04  -6.67560E-04  -6.17493E-04  0.0'
  []

  [power_history]
    type = PiecewiseLinear
    x ='-1.000E+03  0  0.1  20  40  60  80  100  120  140  160  180  200  220  240  260  280  300  320  340  360  380  400  450  500  600  700  800  900  1000 1e5'
    y ='1.0000E+00  1.0000E+00  5.5000E-02  5.0246E-02  4.5903E-02  4.1936E-02  3.8311E-02  3.4999E-02  3.3473E-02  3.2012E-02  3.0615E-02  2.9279E-02  2.8001E-02  2.7588E-02  2.7182E-02  2.6782E-02  2.6388E-02  2.6000E-02  2.5797E-02  2.5595E-02  2.5396E-02  2.5197E-02  2.5001E-02  2.4515E-02  2.4039E-02  2.3115E-02  2.2227E-02  2.1372E-02  2.0551E-02  1.9761E-02  2.7650E-19'
  []

  [pump_p_coastdown]
    type = PiecewiseLinear
    x ='-1.000E+03  0.00E+00  4.00E-01  8.00E-01  1.20E+00  1.60E+00  2.00E+00  2.40E+00  2.80E+00  3.20E+00  3.60E+00
  4.00E+00  4.40E+00  4.80E+00  5.20E+00  5.60E+00  6.00E+00  6.40E+00  6.80E+00  7.20E+00  7.60E+00
  8.000E+00  1.000E+01  2.000E+01  3.000E+01  4.000E+01  5.000E+01  6.000E+01  7.000E+01  8.000E+01  9.000E+01
  1.000E+02  1.100E+02  1.200E+02  1.300E+02  1.400E+02  1.500E+02  1.600E+02  1.700E+02  1.800E+02  1.900E+02
  2.000E+02  2.100E+02  2.200E+02  2.300E+02  2.400E+02  2.500E+02  2.600E+02  2.700E+02  2.800E+02  2.900E+02
  3.000E+02  3.100E+02  3.200E+02  3.300E+02  3.400E+02  3.500E+02  3.600E+02  3.700E+02  3.800E+02  3.900E+02
  4.000E+02  4.100E+02  4.200E+02  1.00E+05'

    y ='1.000E+00  1.000E+00  9.671E-01  9.355E-01  9.050E-01  8.757E-01  8.476E-01  8.205E-01  7.945E-01  7.695E-01  7.455E-01
  7.225E-01  7.004E-01  6.792E-01  6.590E-01  6.395E-01  6.209E-01  6.031E-01  5.860E-01  5.697E-01  5.540E-01
  5.396E-01  4.749E-01  2.753E-01  1.773E-01  1.219E-01  8.812E-02  6.655E-02  5.206E-02  4.181E-02  3.425E-02
  2.850E-02  2.401E-02  2.043E-02  1.754E-02  1.516E-02  1.317E-02  1.151E-02  1.009E-02  8.869E-03  7.816E-03
  6.898E-03  6.094E-03  5.382E-03  4.752E-03  4.192E-03  3.692E-03  3.253E-03  2.814E-03  2.480E-03  2.132E-03
  1.866E-03  1.621E-03  1.397E-03  1.190E-03  9.999E-04  8.248E-04  6.642E-04  5.175E-04  3.841E-04  2.637E-04
  1.558E-04  5.989E-05    0      0'

    scale_factor = 415100
  []

  [pump_s_coastdown]
    type = PiecewiseLinear
    x ='-1.000E+03  0.00E+00  4.00E-01  8.00E-01  1.20E+00  1.60E+00  2.00E+00  2.40E+00  2.80E+00  3.20E+00  3.60E+00
  4.00E+00  4.40E+00  4.80E+00  5.20E+00  5.60E+00  6.00E+00  6.40E+00  6.80E+00  7.20E+00  7.60E+00
  8.000E+00  1.000E+01  2.000E+01  3.000E+01  4.000E+01  5.000E+01  6.000E+01  7.000E+01  8.000E+01  9.000E+01
  1.000E+02  1.100E+02  1.200E+02  1.300E+02  1.400E+02  1.500E+02  1.600E+02  1.700E+02  1.800E+02  1.900E+02
  2.000E+02  2.100E+02  2.200E+02  2.300E+02  2.400E+02  2.500E+02  2.600E+02  2.700E+02  2.800E+02  2.900E+02
  3.000E+02  3.100E+02  3.200E+02  3.300E+02  3.400E+02  3.500E+02  3.600E+02  3.700E+02  3.800E+02  3.900E+02
  4.000E+02  4.100E+02  4.200E+02  1.00E+05'

    y ='1.000E+00  1.000E+00  9.671E-01  9.355E-01  9.050E-01  8.757E-01  8.476E-01  8.205E-01  7.945E-01  7.695E-01  7.455E-01
  7.225E-01  7.004E-01  6.792E-01  6.590E-01  6.395E-01  6.209E-01  6.031E-01  5.860E-01  5.697E-01  5.540E-01
  5.396E-01  4.749E-01  2.753E-01  1.773E-01  1.219E-01  8.812E-02  6.655E-02  5.206E-02  4.181E-02  3.425E-02
  2.850E-02  2.401E-02  2.043E-02  1.754E-02  1.516E-02  1.317E-02  1.151E-02  1.009E-02  8.869E-03  7.816E-03
  6.898E-03  6.094E-03  5.382E-03  4.752E-03  4.192E-03  3.692E-03  3.253E-03  2.814E-03  2.480E-03  2.132E-03
  1.866E-03  1.621E-03  1.397E-03  1.190E-03  9.999E-04  8.248E-04  6.642E-04  5.175E-04  3.841E-04  2.637E-04
  1.558E-04  5.989E-05    0      0'

    scale_factor = 40300
  []

  [flow_secondary]
    type = PiecewiseLinear
    x ='-1.000E+03  0          1       1e5'
    y = '-1259     -1259     0       0'
    scale_factor = 0.002216 # 1/rhoA
  []

  [flow_dhx]
    type = PiecewiseLinear
    x ='-1.000E+03   0     1      1e5'
    y = '0  0  -6.478    -6.478'
    scale_factor = 0.046 # 1/rhoA
  []
[]

[MaterialProperties]
  [fuel-mat]
    type = HeatConductionMaterialProps
    k = 29.3
    Cp = 191.67
    rho = 1.4583e4
    alpha = 1.76E-5
    YoungsM = 2.8E+10
  []
  [gap-mat]
    type = HeatConductionMaterialProps
    k = 64
    Cp = 1272
    rho = 865
  []
  [clad-mat]
    type = HeatConductionMaterialProps
    k = 26.3
    Cp = 638
    rho = 7.646e3
    alpha = 1.4E-5
    YoungsM = 1.5E+11
  []
  [ss-mat]
    type = HeatConductionMaterialProps
    k = 26.3
    Cp = 638
    rho = 7.646e3
  []
[]

[Components]
  [reactor]
    type = ReactorPower
    initial_power = 250e6
    pke = 'point_kinetics_basic'
    decay_heat = power_history
    point_kinetics_power = 0.0
  []

######  Test for Point-Kinetics  ######
  [point_kinetics_basic]
    type = PointKinetics
    lambda = '1.3376E-02  3.0994E-02  1.1750E-01  3.0873E-01  8.8507E-01  2.9393E+00'
    rho_fn_name = rho_func
    LAMBDA = 3.30729E-07
    betai =  '8.1430E-05  5.9311E-04  5.0653E-04  1.1955E-03  7.0362E-04  2.5761E-04'
    Normalized_fission_power = 'Pf'
    Delay_neutron_precursor_name = 'C1   C2   C3   C4   C5   C6'
    irk_solver = true
  []

######  Primary Loop  ######

  [CH1]
    type = PBCoreChannel
    eos = eos
    position = '0 -1 0'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 2
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00052'
    elem_number_of_hs = '20 5'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.02248 0.0'
    power_shape_function = ppf_axial
  []

  [CH1_LP]
    type = PBPipe
    eos = eos
    position = '0 -1 -0.6'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005 #0.002
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []

  [CH1_UP]
    type = PBPipe
    eos = eos
    position = '0 -1 0.8'
    orientation = '0 0 1'

    A = 4.9237e-3
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [Branch_CH1_L]
    type = PBSingleJunction
    inputs = 'CH1_LP(out)'
    outputs = 'CH1(in)'
    eos = eos
  []
  [Branch_CH1_U]
    type = PBSingleJunction
    inputs = 'CH1(out)'
    outputs = 'CH1_UP(in)'
    eos = eos
  []

  [CH2]
    type = PBCoreChannel
    eos = eos
    position = '0 -0.5 0'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 2
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00052'
    elem_number_of_hs = '20 5'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.41924 0.0'
    power_shape_function = ppf_axial
  []
  [CH2_LP]
    type = PBPipe
    eos = eos
    position = '0 -0.5 -0.6'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [CH2_UP]
    type = PBPipe
    eos = eos
    position = '0 -0.5 0.8'
    orientation = '0 0 1'

    A = 0.11323
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [Branch_CH2_L]
    type = PBSingleJunction
    inputs = 'CH2_LP(out)'
    outputs = 'CH2(in)'
    eos = eos
  []
  [Branch_CH2_U]
    type = PBSingleJunction
    inputs = 'CH2(out)'
    outputs = 'CH2_UP(in)'
    eos = eos
  []

  [CH3]
    type = PBCoreChannel
    eos = eos
    position = '0 0 0'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 2
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00052'
    elem_number_of_hs = '20 5'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.09852 0.0'
    power_shape_function = ppf_axial
  []
  [CH3_LP]
    type = PBPipe
    eos = eos
    position = '0 0 -0.6'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [CH3_UP]
    type = PBPipe
    eos = eos
    position = '0 0 0.8'
    orientation = '0 0 1'

    A = 0.029539
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [Branch_CH3_L]
    type = PBSingleJunction
    inputs = 'CH3_LP(out)'
    outputs = 'CH3(in)'
    eos = eos
  []
  [Branch_CH3_U]
    type = PBSingleJunction
    inputs = 'CH3(out)'
    outputs = 'CH3_UP(in)'
    eos = eos
  []


  [CH4]
    type = PBCoreChannel
    eos = eos
    position = '0 0.5 0'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 0.8
    n_elems = 20

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 1107.8

    dim_hs = 2
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '0.00348 0.00052'
    elem_number_of_hs = '20 5'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.43116 0.0'
    power_shape_function = ppf_axial
  []
  [CH4_LP]
    type = PBPipe
    eos = eos
    position = '0 0.5 -0.6'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [CH4_UP]
    type = PBPipe
    eos = eos
    position = '0 0.5 0.8'
    orientation = '0 0 1'

    A = 0.14769
    Dh = 2.972e-3
    length = 1.5
    n_elems = 4
    radius_i = 0.02

    lam_factor = 1.406
    turb_factor = 1.12933
    HTC_geometry_type = Pipe # pipe model

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.0005
    n_wall_elems = 1
    HT_surface_area_density = 1107.8
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [Branch_CH4_L]
    type = PBSingleJunction
    inputs = 'CH4_LP(out)'
    outputs = 'CH4(in)'
    eos = eos
  []
  [Branch_CH4_U]
    type = PBSingleJunction
    inputs = 'CH4(out)'
    outputs = 'CH4_UP(in)'
    eos = eos
  []


  [CH5]
    type = PBCoreChannel
    eos = eos
    position = '0 1 0'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3
    length = 0.8
    n_elems = 20

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_hs = 1
    name_of_hs = 'fuel clad'
    Ts_init = 628.15
    n_heatstruct = 2
    fuel_type = cylinder
    width_of_hs = '6.32340e-3 7.0260e-4'
    elem_number_of_hs = '6 1'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.02860 0.0'
    power_shape_function = ppf_axial
  []
  [CH5_LP]
    type = PBPipe
    eos = eos
    position = '0 1 -0.6'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3
    length = 0.6
    n_elems = 2
    radius_i = 0.02

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.001 #0.0035
    n_wall_elems = 1
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [CH5_UP]
    type = PBPipe
    eos = eos
    position = '0 1 0.8'
    orientation = '0 0 1'

    A = 0.153955129
    Dh = 1.694e-3

    length = 1.5
    n_elems = 4
    radius_i = 0.02

    HTC_geometry_type = Pipe # pipe model
    HT_surface_area_density = 2113.6

    dim_wall = 1
    Twall_init = 628.15
    wall_thickness = 0.001 #0.0035
    n_wall_elems = 1
    material_wall = ss-mat
    HS_BC_type = Adiabatic
  []
  [Branch_CH5_L]
    type = PBSingleJunction
    inputs = 'CH5_LP(out)'
    outputs = 'CH5(in)'
    eos = eos
  []
  [Branch_CH5_U]
    type = PBSingleJunction
    inputs = 'CH5(out)'
    outputs = 'CH5_UP(in)'
    eos = eos
  []

  [IHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    position = '0 1.7 5.88'
    orientation = '0 0 -1'
    A = 0.766
    A_secondary = 0.517
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 3.71
    n_elems = 20
    initial_V_secondary = -2
    disp_mode = -1

    HTC_geometry_type = Pipe # pipe model
    HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 729
    HT_surface_area_density_secondary = 1080.1

    Twall_init = 628.15
    wall_thickness = 0.0041 #0.0033

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 2
  []

  [pump_pipe]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -1.5 3.61'
    orientation = '0 0 -1'

    A = 0.132
    Dh = 0.34
    length = 4.38
    n_elems = 4
    f = 0.001
    Hw = 0
  []

  [pump_discharge]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 -1.5 -0.77'
    orientation = '0 1 0'

    A = 5.36
    Dh = 1
    length = 1.26
    n_elems = 3
    f = 0.001
    Hw = 0
  []


  [inlet_plenum]
    type = PBVolumeBranch
    center = '0 0 -0.77'
    inputs = 'pump_discharge(out)'
    outputs = 'CH1_LP(in) CH2_LP(in) CH3_LP(in) CH4_LP(in) CH5_LP(in)'
    K = '0.2     0.5  5.2    6.0      13.8  12480' # considered density difference
    Area = 0.44934
    volume = 3.06
    width = 2.4
    height = 0.6

    initial_P = 3e5
    initial_T = 628.15
    eos = eos
    display_pps = true
    nodal_Tbc = true
  []

  [hot_pool]
    type = PBLiquidVolume
    center = '0 0 6.45'
    inputs = 'CH1_UP(out) CH2_UP(out) CH3_UP(out) CH4_UP(out) CH5_UP(out)'
    outputs = 'IHX(primary_in)'
    K = '0.5 0.5 0.5 0.5 0.5 5.0'
    Area = 11.16
    volume = 92.51
    width = 4
    height = 5

    initial_level = 2.16 #3.59
    initial_T = 783.15
    initial_V = 0.00356
    display_pps = true
    eos = eos
    covergas_component = 'cover_gas'
  []

  [cold_pool_low]
    type = PBLiquidVolume
    center = '0 0 2.3'
    inputs = 'IHX(primary_out) DHX(primary_out)'
    outputs = 'pump_pipe(in) DHX(primary_in)'

    K = '0.1 0.1 0.2  0.1 '
    Area =  23.96
    volume = 152.97
    width = 5
    height = 8

    initial_level = 5
    initial_T = 628.15
    initial_P = 3e5
    display_pps = true
    eos = eos
    covergas_component = 'cover_gas'
  []
  [cover_gas]
    type = CoverGas
    n_liquidvolume =2
    name_of_liquidvolume = 'hot_pool cold_pool_low'
    initial_P = 1e5
    initial_Vol = 66.77
    initial_T = 783.15
  []
  [Pump_p]
    type = PBPump
    eos = eos
    inputs = 'pump_pipe(out)'
    outputs = 'pump_discharge(in)'

    K = '1. 1.'
    Area = 0.055
    initial_P = 3e5

    Head = 415100
    Head_fn = pump_p_coastdown
  []

######  Secondary Loop  ######
  [pipe8]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 2.7 2.17'
    orientation = '0 -1 0'

    A = 0.092
    Dh = 0.34
    length = 1
    n_elems = 3
    f = 0.001
    Hw = 0
  []

  [pipe9]
    type = PBOneDFluidComponent
    eos = eos
    position = '0 1.7 5.88'
    orientation = '0 1 0'

    A = 0.092
    Dh = 0.34
    length = 1
    n_elems = 3
    f = 0.001
    Hw = 0
  []

  [NaHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    position = '0 2.72 5.88'
    orientation = '0 0 -1'
    A = 0.766
    A_secondary = 0.517
    Dh = 0.0186
    Dh_secondary = 0.014
    length = 3.71
    n_elems = 20
    initial_V_secondary = -2.8
    disp_mode = -1

    HTC_geometry_type = Pipe # pipe model
    HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 729
    HT_surface_area_density_secondary = 1080.1

    Twall_init = 628.15
    wall_thickness = 0.002 #0.00174, 0.00087

    dim_wall = 1
    material_wall = ss-mat
    n_wall_elems = 2
  []

  [Branch8]
    type = PBBranch
    inputs = 'pipe8(out)'
    outputs = 'IHX(secondary_in)'
    K = '0.05 0.05'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  []

  [Branch9]
    type = PBBranch
    inputs = 'IHX(secondary_out)'
    outputs = 'pipe9(in)'
    K = '0.0 0.0'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  []

  [Branch10]
    type = PBBranch
    inputs = 'pipe9(out) '
    outputs = 'NaHX(primary_in)'
    K = '0.01 0.01'
    Area = 0.092
    initial_P = 2e5
    eos = eos
  []

  [Pump_s]
    type = PBPump
    eos = eos
    inputs = 'NaHX(primary_out)'
    outputs = 'pipe8(in)'

    K = '0.1 0.1'
    Area = 0.766

    initial_P = 2e5

    Head = 40300
    Head_fn = pump_s_coastdown
  []

  [secondary_p]
    type = ReferenceBoundary
    input = 'NaHX(primary_in)'
    variable = 'pressure'
    value = 1e5
  []

######  Power conversion loop  ######

  [NaLoop_in]
    type = PBTDJ
    input = 'NaHX(secondary_in)'
    v_fn = flow_secondary
    T_bc = 596.75
    eos = eos
    weak_bc = true
  []

  [NaLoop_out]
    type = PressureOutlet
    input = 'NaHX(secondary_out)'
    p_bc = '1e5'
    eos = eos
  []

######   DRACS loop    ######
  [DHX]
    type = PBHeatExchanger
    eos = eos
    eos_secondary = eos
    position = '0 -2.3 6.04'
    orientation = '0 0 -1'
    A = 0.024
    A_secondary = 0.024
    Dh = 0.037
    Dh_secondary = 0.037
    length = 2.35
    n_elems = 10

    HTC_geometry_type = Pipe # pipe model
    HTC_geometry_type_secondary = Pipe
    HT_surface_area_density = 108.1
    HT_surface_area_density_secondary = 108.1
    tao_supg = 0.1
    tao_supg_secondary = 0.1

    Twall_init = 628.15
    dim_wall = 1
    wall_thickness = 0.0045
    material_wall = ss-mat

    n_wall_elems = 2
  []

  [DRACS_inlet]
    type = PBTDJ
    input = 'DHX(secondary_in)'
    v_fn = flow_dhx
    T_bc = 450.3
    eos = eos
    weak_bc = true
  []
  [DRACS_outlet]
    type = PressureOutlet
    input = 'DHX(secondary_out)'
    p_bc = 1.3e5
    eos = eos
  []
[]

[Postprocessors]
  [pump_flow]
    type = ComponentBoundaryFlow
    input = pump_pipe(in)
  []
  [IHX_primaryflow]
    type = ComponentBoundaryFlow
    input = IHX(primary_in)
  []
  [IHX_secondaryflow]
    type = ComponentBoundaryFlow
    input = IHX(secondary_in)
  []
  [DHX_flow]
    type = ComponentBoundaryFlow
    input = DHX(primary_in)
  []
  [IHX_inlet_T]
    type = ComponentBoundaryVariableValue
    input = IHX(primary_in)
    variable = temperature
  []
  [CH1_velocity]
    type = ComponentBoundaryVariableValue
    input = CH1(in)
    variable = velocity
  []
  [CH2_velocity]
    type = ComponentBoundaryVariableValue
    input = CH2(in)
    variable = velocity
  []
  [CH3_velocity]
    type = ComponentBoundaryVariableValue
    input = CH3(in)
    variable = velocity
  []
  [CH4_velocity]
    type = ComponentBoundaryVariableValue
    input = CH4(in)
    variable = velocity
  []
  [CH5_velocity]
    type = ComponentBoundaryVariableValue
    input = CH5(in)
    variable = velocity
  []
  [CH1_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH1_UP(out)
  []
  [CH2_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH2_UP(out)
  []
  [CH3_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH3_UP(out)
  []
  [CH4_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH4_UP(out)
  []
  [CH5_outlet_flow]
    type = ComponentBoundaryFlow
    input = CH5_UP(out)
  []
  [CH1_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH1_UP(out)
    variable = temperature
  []
  [CH2_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH2_UP(out)
    variable = temperature
  []
  [CH3_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH3_UP(out)
    variable = temperature
  []
  [CH4_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH4_UP(out)
    variable = temperature
  []
  [CH5_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH5_UP(out)
    variable = temperature
  []
  [max_Tcoolant_core]
    type = NodalMaxValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = temperature
  []
  [max_Tco_core]
    type = NodalMaxValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = Tw
  []
  [max_Tci_core]
    type = NodalMaxValue
    block = 'CH1:solid:clad CH2:solid:clad CH3:solid:clad CH4:solid:clad'
    variable = T_solid
  []
  [max_Tf_core]
    type = NodalMaxValue
    block = 'CH1:solid:fuel CH2:solid:fuel CH3:solid:fuel CH4:solid:fuel'
    variable = T_solid
  []
  [max_Tcoolant_Ref]
    type = NodalMaxValue
    block = 'CH5:pipe'
    variable = temperature
  []
  [max_Tco_Ref]
    type = NodalMaxValue
    block = 'CH5:pipe'
    variable = Tw
  []
  [max_Tci_Ref]
    type = NodalMaxValue
    block = 'CH5:solid:clad'
    variable = T_solid
  []
  [max_Tf_Ref]
    type = NodalMaxValue
    block = 'CH5:solid:fuel'
    variable = T_solid
  []

  [DHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'DHX:primary_pipe'
    heated_perimeter = 2.5944
  []
  [IHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'IHX:primary_pipe'
    heated_perimeter = 558.414
  []
  [NaHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'NaHX:secondary_pipe'
    heated_perimeter = 558.414
  []
[]

[Preconditioning]
   active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type  = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  []
[] # End preconditioning block

[Executioner]
  type = Transient
  dt = 0.1
  dtmin = 1e-3

  # setting time step range
  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-3
  []
#   line_search = basic

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-6
  nl_max_its = 20

  l_tol = 1e-5 # Relative linear tolerance for each Krylov solve
  l_max_its = 100 # Number of linear iterations for each Krylov solve

  start_time = -500
  num_steps =  10000
  end_time = 0

  [Quadrature]
      type = TRAP
      order = FIRST
  []
[] # close Executioner section

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  []
  [checkpoint]
    type = Checkpoint
    num_files = 1
  []
  [console]
    type = Console
  []
  [csv]
    type = CSV
  []
[]
