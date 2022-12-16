## ABTR Steady state relaxation transient simulation
## Application: SAM
## POC: Jun Fang (fangj at anl.gov)
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

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
    type = PiecewiseConstant
    x = '-500 -490    -10     0       2     3   10   11  380   381    440   441   1e5'
    y =' 1.0    50.       50.0 0.2     0.2   0.5  0.5    2    2     2      2     5     5'
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
    x ='-5000.0      0.0    70              500             700             1000            5000.0'
    y ='0.0          0.0    -4.67292E-04    -3.33780E-04    -6.67560E-04    -6.17493E-04    0.0'
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
    y = '-6.478  -6.478  -6.478    -6.478'
    scale_factor = 0.046 # 1/rhoA
  []
  [CH1_fuel_axial_reactivity_fn]
    type = PiecewiseLinear
    axis = x
    x = '-0.2 0.00  0.04  0.08  0.12  0.16  0.20  0.24  0.28  0.32  0.36  0.40  0.44  0.48  0.52  0.56  0.60  0.64  0.68  0.72  0.76  0.80  1.0'
    y = '8.16610E-06 8.16610E-06  8.16610E-06  9.42750E-06   1.10140E-05   1.26600E-05   1.35860E-05   1.49250E-05   1.60350E-05   1.68550E-05   1.71180E-05   1.72500E-05   1.70260E-05   1.64540E-05   1.58990E-05   1.46680E-05   1.31750E-05   1.14770E-05   1.02240E-05   8.15290E-06   6.14050E-06   4.32450E-06 4.32450E-06'
  []
  [CH2_fuel_axial_reactivity_fn]
    type = PiecewiseLinear
    axis = x
    x = '-0.2 0.00  0.04  0.08  0.12  0.16  0.20  0.24  0.28  0.32  0.36  0.40  0.44  0.48  0.52  0.56  0.60  0.64  0.68  0.72  0.76  0.80  1.0'
    y = '8.16610E-06 8.16610E-06  8.16610E-06  9.42750E-06   1.10140E-05   1.26600E-05   1.35860E-05   1.49250E-05   1.60350E-05   1.68550E-05   1.71180E-05   1.72500E-05   1.70260E-05   1.64540E-05   1.58990E-05   1.46680E-05   1.31750E-05   1.14770E-05   1.02240E-05   8.15290E-06   6.14050E-06   4.32450E-06 4.32450E-06'

  []
  [CH3_fuel_axial_reactivity_fn]
    type = PiecewiseLinear
    axis = x
    x = '-0.2 0.00  0.04  0.08  0.12  0.16  0.20  0.24  0.28  0.32  0.36  0.40  0.44  0.48  0.52  0.56  0.60  0.64  0.68  0.72  0.76  0.80  1.0'
    y = '6.641E-06  6.641E-06  6.641E-06  7.667E-06  8.957E-06  1.030E-05  1.105E-05  1.214E-05  1.304E-05  1.371E-05  1.392E-05  1.403E-05  1.385E-05  1.338E-05  1.293E-05  1.193E-05  1.071E-05  9.334E-06  8.315E-06  6.630E-06  4.994E-06  3.517E-06  3.517E-06'

  []
  [CH4_fuel_axial_reactivity_fn]
    type = PiecewiseLinear
    axis = x
    x = '-0.2 0.00  0.04  0.08  0.12  0.16  0.20  0.24  0.28  0.32  0.36  0.40  0.44  0.48  0.52  0.56  0.60  0.64  0.68  0.72  0.76  0.80  1.0'
    y = '4.907E-06  4.907E-06  4.907E-06  5.665E-06  6.618E-06  7.608E-06  8.164E-06  8.969E-06  9.636E-06  1.013E-05  1.029E-05  1.037E-05  1.023E-05  9.888E-06  9.554E-06  8.814E-06  7.917E-06  6.897E-06  6.144E-06  4.899E-06  3.690E-06  2.599E-06  2.599E-06'

  []
[]

[MaterialProperties]
  [fuel-mat]
    type = SolidMaterialProps
    k = 29.3
    Cp = 191.67
    rho = 1.4583e4
    alpha = 1.76E-5
    YoungsM = 2.8E+10
  []
  [clad-mat]
    type = SolidMaterialProps
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
    operating_power = 250e6
    pke = 'point_kinetics_basic'
    enable_decay_heat = true
    isotope_fission_fraction = '1.0 0.0 0.0 0.0'
  []

######  Test for Point-Kinetics  ######
  [point_kinetics_basic]
    type = PointKinetics
    lambda = '1.3376E-02  3.0994E-02  1.1750E-01  3.0873E-01  8.8507E-01  2.9393E+00'
    rho_fn_name = rho_func
    LAMBDA = 3.30729E-07
    betai =  '8.1430E-05  5.9311E-04  5.0653E-04  1.1955E-03  7.0362E-04  2.5761E-04'

    # Turn on reactivity feedbacks
    feedback_components = 'CH1 CH2 CH3 CH4'
    feedback_start_time = 0.0
    irk_solver = true
# Core radial expansion model
    core_radial_expansion_reactivity_feedback = true
    core_radial_expansion_reactivity_coefficients = '-0.86929  -0.86929'
    core_radial_expansion_weights = '0.3  0.7'
    use_external_radial_displacement = false
    core_radial_thermal_expansion_coefficient = '1.60E-5  1.60E-5'
    coupled_radial_temperatures_pps = 'CH1_inlet_T CH1_outlet_T'
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
    elem_number_of_hs = '5 2'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.02248 0.0'
    power_shape_function = ppf_axial

    # Coolant density reactivity feedback models
    coolant_density_reactivity_feedback = true
    n_layers_coolant = 20
    coolant_reactivity_coefficients = '2.25950E-05  2.25950E-05   2.25950E-05   2.25950E-05   1.13940E-04   1.13940E-04   1.13940E-04   1.13940E-04   1.42850E-04   1.42850E-04   1.42850E-04   1.42850E-04   9.28900E-05   9.28900E-05   9.28900E-05   9.28900E-05   -1.79300E-05   -1.79300E-05   -1.79300E-05   -1.79300E-05'

    pke_material_type = 'FuelDoppler None '
    n_layers_doppler = 20
    fuel_doppler_coef = -1.432E-03
    fuel_doppler_axial_weight = '6.00E-02  6.00E-02  6.00E-02  6.00E-02  5.50E-02  5.50E-02  5.50E-02  5.50E-02  5.70E-02  5.70E-02  5.70E-02  5.70E-02  4.70E-02  4.70E-02  4.70E-02  4.70E-02  3.10E-02  3.10E-02  3.10E-02  3.10E-02'

    # Fuel axial expansion reactivity feedback model
    fuel_axial_expansion_reactivity_feedback = true
    n_layers_axial_expansion = 20
    fuel_axial_expansion_reactivity_fn = CH1_fuel_axial_reactivity_fn
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
    elem_number_of_hs = '5 2'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.41924 0.0'
    power_shape_function = ppf_axial

    # Coolant density reactivity feedback models
    coolant_density_reactivity_feedback = true
    n_layers_coolant = 20
    coolant_reactivity_coefficients = '2.25950E-05  2.25950E-05   2.25950E-05   2.25950E-05   1.13940E-04   1.13940E-04   1.13940E-04   1.13940E-04   1.42850E-04   1.42850E-04   1.42850E-04   1.42850E-04   9.28900E-05   9.28900E-05   9.28900E-05   9.28900E-05   -1.79300E-05   -1.79300E-05   -1.79300E-05   -1.79300E-05'

    # Fuel Doppler reactivity feedback model
    pke_material_type = 'FuelDoppler None '
    n_layers_doppler = 20
    fuel_doppler_coef = -1.432E-03
    fuel_doppler_axial_weight = '6.00E-02  6.00E-02  6.00E-02  6.00E-02  5.50E-02  5.50E-02  5.50E-02  5.50E-02  5.70E-02  5.70E-02  5.70E-02  5.70E-02  4.70E-02  4.70E-02  4.70E-02  4.70E-02  3.10E-02  3.10E-02  3.10E-02  3.10E-02'
    # Fuel axial expansion reactivity feedback model
    fuel_axial_expansion_reactivity_feedback = true
    n_layers_axial_expansion = 20
    fuel_axial_expansion_reactivity_fn = CH2_fuel_axial_reactivity_fn
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
    elem_number_of_hs = '5 2'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.09852 0.0'
    power_shape_function = ppf_axial

    # Coolant density reactivity feedback models
    coolant_density_reactivity_feedback = true
    n_layers_coolant = 20
    coolant_reactivity_coefficients = '2.52430E-05  2.52430E-05   2.52430E-05   2.52430E-05   1.28450E-04   1.28450E-04   1.28450E-04   1.28450E-04   1.59820E-04   1.59820E-04   1.59820E-04   1.59820E-04   1.03630E-04   1.03630E-04   1.03630E-04   1.03630E-04   -1.68580E-05   -1.68580E-05   -1.68580E-05   -1.68580E-05'

    # Fuel Doppler reactivity feedback model
    pke_material_type = 'FuelDoppler None '
    n_layers_doppler = 20
    fuel_doppler_coef = -2.624E-04
    fuel_doppler_axial_weight = '5.80E-02  5.80E-02  5.80E-02  5.80E-02  5.40E-02  5.40E-02  5.40E-02  5.40E-02  5.70E-02  5.70E-02  5.70E-02  5.70E-02  4.70E-02  4.70E-02  4.70E-02  4.70E-02  3.40E-02  3.40E-02  3.40E-02  3.40E-02'
    # Fuel axial expansion reactivity feedback model
    fuel_axial_expansion_reactivity_feedback = true
    n_layers_axial_expansion = 20
    fuel_axial_expansion_reactivity_fn = CH3_fuel_axial_reactivity_fn
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
    elem_number_of_hs = '5 2'
    material_hs = 'fuel-mat clad-mat'

    power_fraction = '0.43116 0.0'
    power_shape_function = ppf_axial

    # Coolant density reactivity feedback model
    coolant_density_reactivity_feedback = true
    n_layers_coolant = 20
    coolant_reactivity_coefficients = '-1.83920E-05  -1.83920E-05   -1.83920E-05   -1.83920E-05   -8.51710E-07   -8.51710E-07   -8.51710E-07   -8.51710E-07   4.50680E-06   4.50680E-06   4.50680E-06   4.50680E-06   -4.90700E-06   -4.90700E-06   -4.90700E-06   -4.90700E-06   -2.53840E-05   -2.53840E-05   -2.53840E-05   -2.53840E-05'

    # Fuel Doppler reactivity feedback model
    pke_material_type = 'FuelDoppler None '
    n_layers_doppler = 20
    fuel_doppler_coef = -1.050E-03
    fuel_doppler_axial_weight = '5.20E-02  5.20E-02  5.20E-02  5.20E-02  5.60E-02  5.60E-02  5.60E-02  5.60E-02  5.90E-02  5.90E-02  5.90E-02  5.90E-02  4.90E-02  4.90E-02  4.90E-02  4.90E-02  3.40E-02  3.40E-02  3.40E-02  3.40E-02'
    # Fuel axial expansion feedback model
    fuel_axial_expansion_reactivity_feedback = true
    n_layers_axial_expansion = 20
    fuel_axial_expansion_reactivity_fn = CH4_fuel_axial_reactivity_fn
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
    elem_number_of_hs = '3 1'
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

    dim_wall = 2
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

    initial_P = 515366.5528
    initial_T = 636.9052461
    initial_V = 3.257927206
    Steady = true
    eos = eos
  []

  [hot_pool]
    type = PBLiquidVolume
    center = '0 0 6.45'
    inputs = 'CH1_UP(out) CH2_UP(out) CH3_UP(out) CH4_UP(out) CH5_UP(out)'
    outputs = 'IHX(primary_in)'
    K = '0.5 0.5 0.5 0.5 0.5 5.0'
    Area = 11.16
    volume = 97.01464649
    width = 4
    height = 5

    initial_level = 2.563642158
    initial_T = 792.3706448
    initial_V = 0.00356
    initial_P = 123076.1707
    Steady = true
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
    volume = 149.3629099
    width = 5
    height = 8

    initial_level = 4.849453669
    initial_T = 636.9092646
    initial_P = 143316.8194
    initial_V = 1.13E-06
    eos = eos
    covergas_component = 'cover_gas'
  []
  [cover_gas]
    type = CoverGas
    n_liquidvolume =2
    name_of_liquidvolume = 'hot_pool cold_pool_low'
    initial_P = 101237.0534
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
  []

  [NaLoop_out]
    type = PBTDV
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

    Twall_init = 628.15
    dim_wall = 1
    wall_thickness = 0.0045
    material_wall = ss-mat
    SC_HTC_secondary = 0.0
    n_wall_elems = 2
  []

  [DRACS_inlet]
    type = PBTDJ
    input = 'DHX(secondary_in)'
    v_fn = flow_dhx
    T_bc = 450.3
    eos = eos
  []
  [DRACS_outlet]
    type = PBTDV
    input = 'DHX(secondary_out)'
    p_bc = 1.3e5
    eos = eos
  []
[]

[Postprocessors]
  [CH1_inlet_T]
    type = ComponentBoundaryVariableValue
    input = CH1(in)
    variable = temperature
  []
  [CH1_outlet_T]
    type = ComponentBoundaryVariableValue
    input = CH1(out)
    variable = temperature
  []

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
  [CH1UP_outlet_T]
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
    type = NodalExtremeValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = temperature
  []
  [max_Tco_core]
    type = NodalExtremeValue
    block = 'CH1:pipe CH2:pipe CH3:pipe CH4:pipe'
    variable = Tw
  []
  [max_Tci_core]
    type = NodalExtremeValue
    block = 'CH1:solid:clad CH2:solid:clad CH3:solid:clad CH4:solid:clad'
    variable = T_solid
  []
  [max_Tf_core]
    type = NodalExtremeValue
    block = 'CH1:solid:fuel CH2:solid:fuel CH3:solid:fuel CH4:solid:fuel'
    variable = T_solid
  []
  [max_Tcoolant_Ref]
    type = NodalExtremeValue
    block = 'CH5:pipe'
    variable = temperature
  []
  [max_Tco_Ref]
    type = NodalExtremeValue
    block = 'CH5:pipe'
    variable = Tw
  []
  [max_Tci_Ref]
    type = NodalExtremeValue
    block = 'CH5:solid:clad'
    variable = T_solid
  []
  [max_Tf_Ref]
    type = NodalExtremeValue
    block = 'CH5:solid:fuel'
    variable = T_solid
  []

  [DHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'DHX:primary_pipe'
    heated_perimeter = ${fparse 2.5944/250e6}
  []
  [IHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'IHX:primary_pipe'
    heated_perimeter = ${fparse 558.414/250e6}
  []
  [NaHX_heatremoval]
    type = HeatExchangerHeatRemovalRate
    block = 'NaHX:secondary_pipe'
    heated_perimeter = ${fparse 558.414/250e6}
  []
  [./feedback-Axial]
    type = SumOfPostprocessors
    pps_names = 'CH1_Fuel_Axial_Expansion_Reactivity CH2_Fuel_Axial_Expansion_Reactivity CH3_Fuel_Axial_Expansion_Reactivity CH4_Fuel_Axial_Expansion_Reactivity'
  [../]
  [./feedback-doppler]
    type = SumOfPostprocessors
    pps_names = 'CH1:fuel_Fuel_Doppler_Reactivity CH2:fuel_Fuel_Doppler_Reactivity CH3:fuel_Fuel_Doppler_Reactivity CH4:fuel_Fuel_Doppler_Reactivity'
  [../]
  [./feedback-coolant]
    type = SumOfPostprocessors
    pps_names = 'CH1:pipe_Coolant_Density_Reactivity CH2:pipe_Coolant_Density_Reactivity CH3:pipe_Coolant_Density_Reactivity CH4:pipe_Coolant_Density_Reactivity'
  [../]
  [./feedback-ext]
    type = FunctionValuePostprocessor
    function = 'rho_func'
  [../]
  [./feedback-total]
    type = SumOfPostprocessors
    pps_names = 'Total_Reactivity_Feedback feedback-ext'
  [../]
[]

[Preconditioning]
   active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type  = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  []
[] # End preconditioning block

[Executioner]
  type = Transient
  dt = 1.0
  dtmin = 1e-3

  # setting time step range
  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-3
  []

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  nl_max_its = 10

  l_max_its = 50 # Number of linear iterations for each Krylov solve

  start_time = -500
  num_steps =  10000
  end_time = -0

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
    interval = 40
  []
  [checkpoint]
    type = Checkpoint
    num_files = 1
    execute_on = 'FINAL FAILED'
  []
  [console]
    type = Console
    fit_mode = AUTO
    output_nonlinear = false
    output_linear = false
    execute_scalars_on = 'NONE'
    interval = 20
  []
  [csv]
    type = CSV
    interval = 10
    execute_scalars_on = 'NONE'
    hide = 'CH1:fuel_Fuel_Doppler_Reactivity CH1:pipe_Coolant_Density_Reactivity CH1_Fuel_Axial_Expansion_Reactivity CH2:fuel_Fuel_Doppler_Reactivity CH2:pipe_Coolant_Density_Reactivity CH2_Fuel_Axial_Expansion_Reactivity CH3:fuel_Fuel_Doppler_Reactivity CH3:pipe_Coolant_Density_Reactivity CH3_Fuel_Axial_Expansion_Reactivity CH4:fuel_Fuel_Doppler_Reactivity CH4:pipe_Coolant_Density_Reactivity CH4_Fuel_Axial_Expansion_Reactivity'
  []
[]
