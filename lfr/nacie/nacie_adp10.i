u_ref = 0.4

u_init = ${fparse u_ref}

u_init_hx = ${fparse u_ref}

u_init_fm = ${fparse u_init*16}

u_shell = 0.039368 

T_inlet_shell = 443.15

[GlobalParams]
    global_init_P = 1.0e5                       # Global initial fluid pressure
    global_init_V =  ${u_init}                  # Global initial fluid velocity
    global_init_T = 543.2                       #
    scaling_factor_var = '1 1e-3 1e-4'          # Scaling factors for fluid variables (p, v, T)
    gravity  = '0 -9.81 0'
    Tsolid_sf = 1e-3
[]

[EOS]
  [sodium_eos]
      type = PBSodiumEquationOfState
  []
  [LBE_eos]
      type = LeadBismuthEquationOfState
      metal_type = LBE
  []

  [water_eos]
    type = PTFunctionsEOS
    p_0 = 1.0e5
    cp = water_cp
    enthalpy = water_h
    k = water_k
    mu = water_mu
    rho = water_rho
  []

[]

[MaterialProperties]
  [ss-mat]
    type = SolidMaterialProps
    k = 10
    Cp = 638
    rho = 6e3
  []

  [S304]
    type = SolidMaterialProps
    k = 17.824
    Cp = 550.196
    rho = 7687
  []

  [S316]
    type = SolidMaterialProps
    k  = 18.674
    Cp = 538.5
    rho = 7817.0
  []

  [S316_hx]
    type = SolidMaterialProps
    k = 2.053  
    Cp = 538.5
    rho = 7817.0 
  []

  [insulation]
    type = SolidMaterialProps
    k = 0.1
    Cp = 1.2
    rho = 50.0
  []

[]

[Functions]

  [water_rho]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '901.1882429242 900.4711410408 899.7516552864 899.0297773482 898.3054987413 897.5788108084 896.8497047173 896.1181714592 895.3842018476 894.6477865160 893.9089159160 893.1675803157 892.4237697978 891.6774742574 890.9286834000 890.1773867396 889.4235735963 888.6672330944 887.9083541598 887.1469255181 886.3829356919 885.6163729986 884.8472255478 884.0754812386 883.3011277573 882.5241525747 881.7445429429 880.9622858932 880.1773682324 879.3897765406 878.5994971675 877.8065162300 877.0108196081 876.2123929425 875.4112216307 874.6072908237 873.8005854224 872.9910900742 872.1787891690 871.3636668353 870.5457069368 869.7248930676 868.9012085490 868.0746364242 867.2451594547 866.4127601158 865.5774205914 864.7391227700 863.8978482394 863.0535782818 '
  []

  [water_cp]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '4355.7635107700335 4358.075357414094 4360.409793215455 4362.767057430224 4365.147402862236 4367.551086131402 4369.978357354028 4372.429480671814 4374.904724235317 4377.404349579894 4379.92863276932 4382.477854085259 4385.052287088751 4387.65222410741 4390.2779470820005 4392.929753381679 4395.607944981994 4398.312816978846 4401.044680476879 4403.80385144714 4406.5906388976555 4409.405368458754 4412.248370909677 4415.119969994134 4418.020506727525 4420.950327581471 4423.9097719320625 4426.899197115309 4429.918966257965 4432.969435345814 4436.050979054856 4439.16397821644 4442.308806492273 4445.485857010327 4448.695529451788 4451.938216318822 4455.214335078968 4458.524291495055 4461.868512202708 4465.24743113756 4468.661475091955 4472.111092650545 4475.596740203194 4479.1188670545225 4482.677945284339 4486.274455331673 4489.908870640937 4493.58168848425 4497.293415101477 4501.044549865968 '
  []

  [water_h]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '705910.5387656270 708980.6814513456 712052.4611455493 715125.8938499906 718200.9957409566 721277.7831718482 724356.2726757976 727436.4809683274 730518.4249500601 733602.1217094720 736687.5885256878 739774.8428713366 742863.9024154438 745954.7850263858 749047.5087748924 752142.0919371016 755238.5529976768 758336.9106529718 761437.1838142674 764539.3916110557 767643.5533943949 770749.6887403270 773857.8174533608 776967.9595700203 780080.1353624668 783194.3653421915 786310.6702637818 789429.0711287630 792549.5891895181 795672.2459532943 798797.0631862790 801924.0629177758 805053.2674444591 808184.6993347227 811318.3814331230 814454.3368649122 817592.5890406795 820733.1616610857 823876.0787217084 827021.3645179929 830169.0436503158 833319.1410291645 836471.6818804329 839626.6917508411 842784.1965134814 845944.2223734960 849106.7958738843 852271.9439014546 855439.6936929169 858610.0728411208 '
  []

  [water_k]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '0.6772678843 0.6770171941 0.6767610905 0.6764996379 0.6762328913 0.6759608992 0.6756837038 0.6754013430 0.6751138506 0.6748212572 0.6745235907 0.6742208764 0.6739131378 0.6736003966 0.6732826728 0.6729599852 0.6726323514 0.6722997876 0.6719623095 0.6716199316 0.6712726676 0.6709205307 0.6705635332 0.6702016869 0.6698350028 0.6694634918 0.6690871640 0.6687060289 0.6683200959 0.6679293737 0.6675338708 0.6671335952 0.6667285545 0.6663187561 0.6659042069 0.6654849136 0.6650608824 0.6646321195 0.6641986306 0.6637604210 0.6633174959 0.6628698602 0.6624175185 0.6619604751 0.6614987341 0.6610322992 0.6605611741 0.6600853619 0.6596048657 0.6591196883 '
  []

  [water_mu]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '0.0001632030 0.0001624707 0.0001617449 0.0001610255 0.0001603124 0.0001596056 0.0001589049 0.0001582104 0.0001575218 0.0001568392 0.0001561625 0.0001554915 0.0001548262 0.0001541665 0.0001535124 0.0001528638 0.0001522206 0.0001515828 0.0001509502 0.0001503228 0.0001497006 0.0001490834 0.0001484713 0.0001478640 0.0001472617 0.0001466642 0.0001460714 0.0001454834 0.0001448999 0.0001443211 0.0001437467 0.0001431769 0.0001426114 0.0001420503 0.0001414934 0.0001409408 0.0001403924 0.0001398481 0.0001393079 0.0001387717 0.0001382395 0.0001377112 0.0001371868 0.0001366662 0.0001361493 0.0001356362 0.0001351268 0.0001346210 0.0001341188 0.0001336202 '
  []

  [water_alfav]
    type=PiecewiseLinear
    x = '440.000000 440.704659 441.409319 442.113978 442.818637 443.523297 444.227956 444.932615 445.637275 446.341934 447.046593 447.751253 448.455912 449.160572 449.865231 450.569890 451.274550 451.979209 452.683868 453.388528 454.093187 454.797846 455.502506 456.207165 456.911824 457.616484 458.321143 459.025802 459.730462 460.435121 461.139780 461.844440 462.549099 463.253758 463.958418 464.663077 465.367737 466.072396 466.777055 467.481715 468.186374 468.891033 469.595693 470.300352 471.005011 471.709671 472.414330 473.118989 473.823649 474.528308 '
    y = '0.0011273670 0.0011320153 0.0011366869 0.0011413824 0.0011461020 0.0011508461 0.0011556151 0.0011604095 0.0011652295 0.0011700757 0.0011749484 0.0011798480 0.0011847749 0.0011897296 0.0011947125 0.0011997241 0.0012047647 0.0012098348 0.0012149349 0.0012200655 0.0012252269 0.0012304197 0.0012356443 0.0012409013 0.0012461911 0.0012515142 0.0012568711 0.0012622624 0.0012676886 0.0012731501 0.0012786476 0.0012841816 0.0012897526 0.0012953613 0.0013010081 0.0013066937 0.0013124186 0.0013181835 0.0013239889 0.0013298356 0.0013357241 0.0013416550 0.0013476291 0.0013536469 0.0013597093 0.0013658168 0.0013719701 0.0013781700 0.0013844172 0.0013907125 '
  []

  [k_eff]
    type=PiecewiseLinear
    x = '423.15 425.6752525252525 428.20050505050506 430.72575757575754 433.2510101010101 435.77626262626256 438.3015151515151 440.82676767676764 443.3520202020202 445.8772727272727 448.40252525252527 450.92777777777775 453.4530303030303 455.9782828282828 458.5035353535353 461.02878787878785 463.5540404040404 466.07929292929293 468.6045454545454 471.12979797979796 473.6550505050505 476.180303030303 478.7055555555555 481.23080808080806 483.7560606060606 486.28131313131314 488.8065656565656 491.33181818181816 493.85707070707065 496.3823232323232 498.9075757575757 501.43282828282827 503.9580808080808 506.4833333333333 509.00858585858583 511.5338383838384 514.0590909090909 516.5843434343434 519.1095959595959 521.6348484848485 524.160101010101 526.6853535353534 529.2106060606061 531.7358585858585 534.2611111111111 536.7863636363636 539.3116161616161 541.8368686868687 544.3621212121211 546.8873737373738 549.4126262626262 551.9378787878787 554.4631313131313 556.9883838383838 559.5136363636364 562.0388888888889 564.5641414141414 567.0893939393939 569.6146464646464 572.1398989898989 574.6651515151515 577.190404040404 579.7156565656566 582.2409090909091 584.7661616161615 587.2914141414141 589.8166666666666 592.3419191919191 594.8671717171717 597.3924242424242 599.9176767676768 602.4429292929292 604.9681818181818 607.4934343434343 610.0186868686868 612.5439393939394 615.0691919191919 617.5944444444444 620.119696969697 622.6449494949495 625.1702020202019 627.6954545454545 630.220707070707 632.7459595959596 635.2712121212121 637.7964646464646 640.3217171717172 642.8469696969696 645.3722222222221 647.8974747474747 650.4227272727272 652.9479797979798 655.4732323232323 657.9984848484848 660.5237373737373 663.0489898989899 665.5742424242424 668.0994949494949 670.6247474747474 673.15'
    y = '0.19918396472513453 0.2714209469930336 0.3432008353843668 0.4145279547446379 0.4854065755308635 0.5558409146638627 0.62583513636459 0.6953933529748102 0.764519625762505 0.8332179657123232 0.9014923343013751 0.9693466442607286 1.0367847603228892 1.1038104999555594 1.170427634081986 1.236639887788166 1.3024509410172047 1.367864429251095 1.4328839441801533 1.49751303436043 1.5617552058592816 1.6256139228894029 1.6890926084315354 1.752194644846088 1.8149233744738962 1.8772821002263673 1.9392740861652025 2.000902558071924 2.0621707040074018 2.1230816748616195 2.1836385848938216 2.2438445122633 2.3037024995509516 2.3632155542718354 2.4223866493788924 2.4812187237580035 2.5397146827145556 2.5978773984517134 2.655709710540516 2.713214426381998 2.770394321661485 2.8272521407951934 2.883790597369331 2.940012374571782 2.9959201256166024 3.051516474161393 3.1068040147177207 3.161785313054728 3.216462906596052 3.2708393048101843 3.3249169895943793 3.378698415652299 3.4321860108654096 3.4853821766583497 3.5382892883583326 3.590909695548691 3.643245722416709 3.695299668095821 3.7470738070022906 3.7985703891664797 3.8497916405587964 3.9007397634104404 3.9514169365290233 4.001825315609164 4.051967033538159 4.101844200696828 4.151458905255575 4.200813213465823 4.249909169946862 4.298748797968185 4.347334099727442 4.395667056624054 4.443749629528558 4.4915837590477885 4.539171365785982 4.586514350601802 4.633614594861472 4.680473960687969 4.727094291206444 4.773477410785878 4.819625125277056 4.865539222246946 4.911221471209498 4.95667362385298 5.001897414263879 5.046894559147434 5.091666758044866 5.136215693547348 5.180543031506803 5.224650421243532 5.2685394957507965 5.3122118718963405 5.355669150620944 5.398912917134064 5.441944741106571 5.4847661768606955 5.527378763557143 5.569784025379548 5.611983471716168 5.653978597338999 '
  []

  [head_function]
    type=PiecewiseLinear

    x = '-100000           1225        1245 6000'        
    y = '30686.99926  30686.99926      0 0'           
  []

  [q_fn]
    type = ParsedFunction
    expression = '30e3/1.315/654.1503e-6'
  []

  [power_history]
    type = PiecewiseLinear
    x = '0 50 50.1 120'
    y = '1 1 0.2 0.2'
  []

  [uniform]
    type = PiecewiseLinear
    x = '0 0.6'
    y = '1 1'

  []

  [dt_max_fn]
    type = PiecewiseLinear
    x = '-100000 -1050 -50    0  1150   1200   1220    1225 1500 1510    2000  2010  2500  2510 2520  10000  '
    y = ' 50      50    50  5.0    5.0   0.5    0.5    0.5  0.5   1.0    1.0    1.0   1.0  5.0   5.0   5.0  '
  []

  [q_tfm]
    type = PiecewiseLinear
    data_file = 'QTFM_ADP10.csv'
    format = "columns"
    scale_factor = 1.0
  []

  [t_in_water]
    type = PiecewiseLinear
    data_file = 'T_WATER_ADP10.csv'
    format = "columns"
    scale_factor = 1.0
  []
[]

[ComponentInputParameters]
    [2.5in-Schedule-40]
        type = PBPipeParameters
        eos = LBE_eos
        A = 0.00308566 # pi * 0.06268^2 / 4
        heat_source = 0
        Dh = 0.06268
        hs_type = cylinder
        radius_i = 0.03134
        Twall_init = 610
        dim_wall = 2
        wall_thickness = '0.00516 0.05'
        n_wall_elems = '4 4'
        material_wall = 'S304 insulation'
        HS_BC_type = Convective 
        h_amb = 5.0
        HT_surface_area_density = 63.816 # 4/D
        n_elems = 20
        HTC_geometry_type = Pipe
        fluid_conduction = true
    []

    [2.5in-Schedule-40-Flanges]
        type = PBPipeParameters
        eos = LBE_eos
        A = 0.00308566 # pi * 0.06268^2 / 4
        heat_source = 0
        Dh = 0.06268
        hs_type = cylinder
        radius_i = 0.03134
        heat_source_solid = '0'
        dim_wall = 2
        wall_thickness = '0.05 0.05'
        n_wall_elems = '4 4'
        material_wall = 'S304 insulation'
        HS_BC_type = Convective 
        h_amb = 5.0
        HT_surface_area_density = 63.816 # 4/D
        n_elems = 20
        HTC_geometry_type = Pipe
        fluid_conduction = true
    []

    [HX-Collectors]
        type = PBPipeParameters
        eos = LBE_eos
        A = 0.00308566 # pi * 0.06268^2 / 4
        heat_source = 0
        Dh = 0.06268
        hs_type = cylinder
        radius_i = 0.03134
        heat_source_solid = '0'
        dim_wall = 2
        wall_thickness = '0.1'
        n_wall_elems = '4'
        material_wall = 'S316'# insulation
        HT_surface_area_density = 63.816 # 4/D
        n_elems = 20
        HTC_geometry_type = Pipe
        fluid_conduction = true
    []

    [1in-Schedule-40]
        type = PBPipeParameters
        eos = LBE_eos
        A = 0.000557598 # pi * 0.026645^2 / 4
        heat_source = 0
        Dh = 0.026645
        hs_type = cylinder
        radius_i = 0.0133225
        Twall_init = 610
        heat_source_solid = '0'
        dim_wall = 2
        wall_thickness = '0.0033'
        n_wall_elems = 2
        material_wall = 'S304'
        HS_BC_type = Adiabatic 
        T_wall = 2.981500e+02
        HT_surface_area_density = 150.12197 # 4/D
        n_elems = 20
        HTC_geometry_type = Pipe
        fluid_conduction = true
        HTC_user_option = UserForced
        User_defined_HTC_parameters = '5.0 0.025 0.8 0 0.8 0 0'
        WF_user_option = 'Churchill'
        roughness = 32e-6
    []

    [FPS]
        type = PBPipeParameters
        eos = LBE_eos
        A =  654.1503e-6
        heat_source = 0
        Dh  = 6.55e-3
        PoD = 1.2824
        HoD = 40
        WF_geometry_type  = WireWrap
        hs_type = cylinder
        radius_i = 0.03134 
        Twall_init = 510
        heat_source_solid = '0'
        dim_wall = 2
        wall_thickness = '0.00516' 
        n_wall_elems = '4'
        material_wall = 'S304'
        T_wall = 2.981500e+02
        HT_surface_area_density = 610.687 
        n_elems = 20
        HTC_geometry_type = Pipe
        fluid_conduction = true
    []
[]

[Components]
  [FA_active]
    type           = PBOneDFluidComponent
    eos            = LBE_eos
    A              = 654.1503e-6
    length         = 1.315
    Dh             = 3.0125e-3
    n_elems        = 24
    orientation    = '0 1 0'
    position       = '0 0 0'
    initial_P      = 872562.8
    initial_T      = 538.4583
    heat_source = q_fn
    overlap_coupled = true
    overlap_pp = dpdz_core_receive
  []

  [FA_outlet]
    type = PBSingleJunction
    inputs = 'FA_active(out)'
    outputs = 'pipe_after_FA(in)'
    eos = LBE_eos
    initial_P = 795525.0
    initial_T = 578.4887
  []

  [pipe_after_FA]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40-Flanges
    fluid_conduction  = True
    position          = '0 1.315 0'
    orientation       = '0 1 0'
    length            = 0.4115
    n_elems           = 10
    initial_P         = 775056.0
    initial_T         = 578.3288
  []

  [pipe_after_FA_2]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40-Flanges
    fluid_conduction  = True
    position          = '0 1.7265 0'
    orientation       = '0 1 0'
    length            = 0.269
    n_elems           = 5
    initial_P         = 740972.0
    initial_T         = 578.0644
  []

  [Pipe_after_FA_Juc]
    type = PBSingleJunction
    inputs = 'pipe_after_FA(out)'
    outputs = 'pipe_after_FA_2(in)'
    eos = LBE_eos
    initial_P = 754587.0
    initial_T = 578.1690
  []

  [VA_riser]
    type = PBBranch
    inputs = 'pipe_after_FA_2(out)'
    outputs = 'riser_P103(in)'
    K = '0 0.05'
    Area = 3.0856e-03
    initial_P = 727356.6
    initial_T = 577.9599
    eos = LBE_eos
  []

  [riser_P103]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 1.9955 0'
    orientation       = '0 1 0'
    length            = 0.4545
    n_elems           = 10
    initial_P         = 704351.0
    initial_T         = 577.8615
  []

  [P103_Junction]
    type = PBSingleJunction
    inputs = 'riser_P103(out)'
    outputs = 'riser_P103_pump(in)'
    eos = LBE_eos
    initial_P = 681345.5
    initial_T = 577.7631
  []

  [riser_P103_pump]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 2.45 0'
    orientation       = '0 1 0'
    length            = 0.1
    n_elems           = 5
  []

  [gas_injection]
   type = PBPump
   inputs = 'riser_P103_pump(out)'
   outputs = 'riser_P104(in)'
   K = '0 0.46'
   Area = 654.1503e-6 
   initial_V = ${u_init_fm}
   initial_P = 701193.2
   initial_T = 577.7198
   eos = LBE_eos
   Head = head_function   
 []

   [riser_P104]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 2.55 0'
    orientation       = '0 1 0'
    length            = 0.1
    n_elems           = 5
    initial_P         = 696482.0
    initial_T         = 577.6982
  []

  [riser_TP103]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 2.65 0'
    orientation       = '0 1 0'
    length            = 2
    n_elems           = 50
    initial_P         = 590531.7
    initial_T         = 577.2445
  []

  [riser_TP104]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 4.65 0'
    orientation       = '0 1 0'
    length            = 2
    n_elems           = 50
    initial_P         = 388043.2
    initial_T         = 576.3818
  []

  [riser_P105]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 6.65 0'
    orientation       = '0 1 0'
    length            = 0.5
    n_elems           = 10
    initial_P         = 261479.4
    initial_T         = 575.8436
  []

  [pipe_riser]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction  = True
    position          = '0 7.15 0'
    orientation       = '0 1 0'
    length            = 0.85
    n_elems           = 10
    initial_P         = 193129.8
    initial_T         = 575.5538
  []

  [riser_chain]
    type = PipeChain
    component_names = 'riser_P104 riser_TP103 riser_TP104 riser_P105 pipe_riser'
               eos  = LBE_eos
  []

  [EXP]

    type = PBBranch
    inputs = 'pipe_riser(out)'
    outputs = 'expantion_tank(in) set_pressure(in)'
    K = '0 0.0 0'
    Area = 3.0856e-03
    initial_P = 150094.1
    initial_T = 575.3711
    eos = LBE_eos

  []

  [expantion_tank]
    type              = PBPipe
    eos               = LBE_eos
    fluid_conduction  = True
    Dh                = 0.210
    A                 = 0.034636
    hs_type           = cylinder
    radius_i          = 0.105
    heat_source_solid = '0'
    dim_wall          = 2
    wall_thickness    = '0.03'  
    n_wall_elems      = '4'
    material_wall     = 'S304'
    HT_surface_area_density = 19.047
    HTC_geometry_type = Pipe
    position          = '0 8.0 0'
    orientation       = '0 -1 0'
    length            = 0.300
    n_elems           = 7
    initial_P         = 165281.5
    initial_T         = 575.3591
  []

  [EXP_out]
    type = PBBranch
    inputs = 'expantion_tank(out)'
    outputs = 'pipe_upper(in)'
    K = '0.21 0'
    Area = 3.0856e-03
    initial_P = 180468.9
    initial_T = 575.3471
    eos = LBE_eos

  []

  [pipe_upper]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '0 7.7 0'
    orientation       = '1 0 0'
    length            = 2.4
    n_elems           = 58
    initial_P         = 180453.2
    initial_T         = 574.8328
  []

  [elbow_upper]
    type = PBBranch
    inputs = 'pipe_upper(out)'
    outputs = 'pipe_short_down(in)'
    K = '0 0.21'
    Area = 3.0856e-03
    initial_P = 180437.6
    initial_T = 574.3186
    eos = LBE_eos
  []

  [pipe_short_down]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = HX-Collectors
    fluid_conduction = True
    position          = '2.4 7.7 0'
    orientation       = '0 -1 0'
    length            = 0.521
    n_elems           = 9
    initial_P         = 206814.6
    initial_T         = 574.1706
  []

  [HX_upper]
    type = PBVolumeBranch
    inputs = 'pipe_short_down(out)'
    outputs = 'HX_inactive(in)'
    K = '0.73 0'
    center = '2.4 7.179 0'
    Area = 0.117847242
    eos = LBE_eos
    volume = 0.017
    initial_P = 233191.6
    initial_T = 574.0223
  []

  [HX_inactive] 
    type = PBPipe
    A                 = 0.0215996 #m^2
    Dh                = 0.06268 #m
    eos               = LBE_eos
    fluid_conduction  = True
    heat_source_solid = '0'
    heat_source       = 0
    WF_geometry_type  = Pipe
    radius_i          = 0.03134
    hs_type           = cylinder
    dim_wall          = 2
    wall_thickness    = 0.01310
    n_wall_elems      = '4'
    material_wall     = 'S316_hx'
    HS_BC_type        = Adiabatic
    HT_surface_area_density = 63.816 # 4/D
    HTC_geometry_type = Pipe

    orientation       = '0 -1 0'
    position          = '2.4 7.179 0'
    length            = 0.7 
    n_elems           = 20
    initial_P         = 268634.5
    initial_T         = 573.9854
  []

  [HX_dummy]
    type = PBBranch
    inputs = 'HX_inactive(out)'
    outputs = 'HX_active(secondary_out)'
    K = '0 0'
    Area = 0.0215996 #m^2
    initial_P = 304077.5
    initial_T = 573.9486
    eos = LBE_eos
  []

  [HX_active] 
    type = PBHeatExchanger
    eos = water_eos
    eos_secondary = LBE_eos
    position = '2.4 6.479 0 '
    orientation = '0 -1 0'
    A_secondary = 0.0215996
    A = 0.070559
    Dh_secondary = 0.06268
    Dh = 0.089543
    length =  1.8  #2.140
    n_elems = 40

    radius_i = 0.0313565
    hs_type = Cylinder

    HTC_geometry_type = Pipe
    HTC_geometry_type_secondary = Pipe
    HTC_user_option = Default
    HTC_user_option_secondary = ChengTak
    HT_surface_area_density_secondary = 63.816
    HT_surface_area_density = 27.707

    initial_V         = ${u_init_hx}
    initial_P         = 1.0e5
    initial_T         = ${T_inlet_shell}
    initial_P_secondary = 395737.9
    initial_T_secondary = 534.5826

    Twall_init = ${T_inlet_shell}

    wall_thickness = 0.01310

    dim_wall = 1
    material_wall = 'S316_hx'  
    n_wall_elems = 4
  []

  [HX_lower]
    type = PBVolumeBranch
    inputs = 'HX_active(secondary_in)'
    outputs = 'pipe_out_HX(in)'
    K = '0 0.43'
    center =  '2.4 4.679 0 '
    Area = 0.088964118
    initial_P = 487398.2
    initial_T = 495.2167
    eos = LBE_eos
    volume = 0.016
  []

  [pipe_out_HX]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = HX-Collectors
    fluid_conduction  = True
    hs_type           = cylinder
    position          = '2.4 4.689 0'
    orientation       = '0 -1 0'
    length            = 0.5165
    n_elems           = 9
    initial_P         = 513269.1
    initial_T         = 495.1689
  []

  [VA_down]
    type = PBBranch
    inputs = 'pipe_out_HX(out)'
    outputs = 'pipe_down(in)'
    K = '0.05 0'
    Area = 3.0856e-03
    initial_V = ${u_init_hx}
    initial_P = 539140.0
    initial_T = 495.1211
    eos = LBE_eos
  []

  [pipe_down]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '2.4 4.1725 0'
    orientation       = '0 -1 0'
    length            = 2
    n_elems           = 50
    initial_P         = 641397.5
    initial_T         = 494.8200
  []

  [TP106_Juction]
    type = PBSingleJunction
    inputs = 'pipe_down(out)'
    outputs = 'pipe_TP106(in)'
    eos = LBE_eos
    initial_P = 743655.1
    initial_T = 494.5190
  []

  [pipe_TP106]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '2.4 2.1725 0'
    orientation       = '0 -1 0'
    length            = 2.1725
    n_elems           = 50
    initial_P         = 854741.0
    initial_T         = 494.1930
  []

  [elbow_lower]
    type = PBBranch
    inputs = 'pipe_TP106(out)'
    outputs = 'TFM(in)'
    K = '0 0.67'
    Area = 3.0856e-03
    initial_V = ${u_init_fm}
    initial_P = 965826.9
    initial_T = 493.8670
    eos = LBE_eos
  []

  [TFM]
    type              = PBOneDFluidComponent
    eos               = LBE_eos
    fluid_conduction = True
    position          = '2.4 0 0'
    orientation       = '-1 0 0'
    Dh                = 0.016
    length            = 0.795
    n_elems           = 20
    A                 = 2.010619298e-4
    initial_V = ${u_init_fm}
    initial_P = 957713.7
    initial_T = 496.4035
    heat_source       = q_tfm  
  []

  [FM_branch]
    type = PBBranch
    inputs = 'TFM(out)'
    outputs = 'pipe_lower(in)'
    K = '0.46 0'
    Area = 3.0856e-03
    initial_V = ${u_init_fm}
    initial_P = 949622.5
    initial_T = 498.9399
    eos = LBE_eos
  []

  [pipe_lower_chain]
    type = PipeChain
    component_names = 'pipe_lower pipe_P101 pipe_TP101 pipe_lower_valve pipe_lower_1'
    eos               = LBE_eos
  []

  [pipe_lower]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '1.605 0 0'
    orientation       = '-1 0 0'
    length            = 1.042
    n_elems           = 40
    initial_V = ${u_init_fm}
    initial_P = 949615.4
    initial_T = 498.7798
  []

  [pipe_P101]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '0.563 0 0'
    orientation       = '-1 0 0'
    length            = 0.07
    n_elems           = 3
    initial_V = ${u_init_fm}
    initial_P = 949609.8
    initial_T = 498.6090
  []

  [pipe_TP101]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '0.493 0 0'
    orientation       = '-1 0 0'
    length            = 0.388
    n_elems           = 15
    initial_V = ${u_init_fm}
    initial_P = 949604.7
    initial_T = 498.5386
  []

  [pipe_lower_valve]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40-Flanges
    fluid_conduction = True
    position          = '0.105 0 0'
    orientation       = '-1 0 0'
    length            = 0.075
    n_elems           = 3
    initial_V = ${u_init_fm}
    initial_P = 949601.5
    initial_T = 498.4581
  []

  [pipe_lower_1]
    type              = PBPipe
    eos               = LBE_eos
    input_parameters  = 2.5in-Schedule-40
    fluid_conduction = True
    position          = '0.03 0 0'
    orientation       = '-1 0 0'
    length            = 0.03
    n_elems           = 3
    initial_V = ${u_init_fm}
    initial_P = 949600.8
    initial_T = 498.4305
  []

  [fps_lower_branch]
    type = PBBranch
    inputs = 'pipe_lower_1(out)'
    outputs = 'FA_active(in)'
    K = '0.0 16.13'   
    Area = 3.0856e-03
    eos = LBE_eos
    initial_P = 949600.6
    initial_T = 498.4279
  []

  [set_pressure]
    type              = PBOneDFluidComponent
    eos               = LBE_eos
    fluid_conduction = True
    position          = '0 8.0 0'
    orientation       = '0 1 0'
    length            = 0.1
    n_elems           = 3
    Dh                = 0.06268
    A                 = 3.0856e-03
    initial_V = ${u_init_fm}
    initial_P = 1.4e5
    initial_T = 663.2870
  []

  [pbtdv]
    type  = PBTDV
    input = 'set_pressure(out)'
    eos  = LBE_eos
    p_bc = 1.4e+05 
    T_bc = 6.632870e+02
  []

  [inlet2]
    type              = PBTDJ
    input             = 'HX_active(primary_out)'
    eos               = water_eos
    v_bc              = -${u_shell}
    T_fn              = t_in_water
  []

  [outlet2]
    type              = PBTDV
    input             = 'HX_active(primary_in)'
    eos               = water_eos
    T_bc = ${T_inlet_shell} 
    p_bc = 1.0e5
  []

[] # END OF COMPONENTS

[Postprocessors]
  [Picard_its]
    type                = NumFixedPointIterations
    execute_on          = 'TIMESTEP_END'
  []
  [dt_max_pp]
    type       = FunctionValuePostprocessor
    function   = dt_max_fn
    execute_on = TIMESTEP_BEGIN
  []
  [dpdz_core_receive]
    type = Receiver
    default = 107490.9787
  []
  [mFlow_inlet]
    type = ComponentBoundaryFlow
    input = FA_active(in)
  []
  [inlet_mass_flux]
    type = ParsedPostprocessor
    pp_names = 'mFlow_inlet'
    expression = 'abs(mFlow_inlet/654.1503e-6)'
  []

  [P_inlet_active]
    type = ComponentBoundaryVariableValue
    input = FA_active(in)
    variable = pressure
  []

  [P_outlet_active]
    type = ComponentBoundaryVariableValue
    input = FA_active(out)
    variable = pressure
  []

  [T_inlet_active]
    type = ComponentBoundaryVariableValue
    input = FA_active(in)
    variable = temperature
  []

  [T_outlet_active]
    type = ComponentBoundaryVariableValue
    input = FA_active(out)
    variable = temperature
  []

  [h_inlet_active]
    type = ComponentBoundaryVariableValue
    input = HX_active(primary_in)
    variable = heat_transfer_coefficient
  []
  [DP_active]
    type = DifferencePostprocessor
    value1 = P_inlet_active
    value2 = P_outlet_active
  []

  [mFlow_inlet_tube]
    type = ComponentBoundaryFlow
    input = HX_active(secondary_out)
  []
  [mFlow_inlet_shell]
    type = ComponentBoundaryFlow
    input = HX_active(primary_out)
  []

  [heat_removal_tube]
    type = HeatExchangerHeatRemovalRate
    block=HX_active:secondary_pipe
    heated_perimeter = 1.3784
  []
  [heat_removal_shell]
    type = HeatExchangerHeatRemovalRate
    block=HX_active:primary_pipe
    heated_perimeter = 1.9550
  []
  [T_inlet_tube]
    type = ComponentBoundaryVariableValue
    input = pipe_upper(out)
    variable = 'temperature'
  []
  [T_outlet_tube]
    type = ComponentBoundaryVariableValue
    input = pipe_down(in)
    variable = temperature
  []

  [T_outlet_shell]
    type = ComponentBoundaryVariableValue
    input = HX_active(primary_in)
    variable = temperature
  []

  [mFlow_after_HX]
    type = ComponentBoundaryFlow
    input = pipe_down(in)
  []

  [mFlow_metter]
    type = ComponentBoundaryFlow
    input = TFM(out)
  []

    [TP101]
    type = ComponentBoundaryVariableValue
    input = pipe_TP101(in)
    variable = temperature
  []

  [TP102]
    type = ComponentBoundaryVariableValue
    input = pipe_after_FA(out)
    variable = temperature
  []

  [TP103]
    type = ComponentBoundaryVariableValue
    input = riser_TP103(out)
    variable = temperature
  []

  [TP104]
    type = ComponentBoundaryVariableValue
    input = riser_TP104(out)
    variable = temperature
  []

  [TP105]
    type = ComponentBoundaryVariableValue
    input = pipe_upper(out)
    variable = temperature
  []

  [TP106]
    type = ComponentBoundaryVariableValue
    input = pipe_TP106(in)
    variable = temperature
  []

  [TP107]
    type = ComponentBoundaryVariableValue
    input = pipe_TP106(out)
    variable = temperature
  []

  [TP203]
    type = ComponentBoundaryVariableValue
    input = HX_active(primary_in)
    variable = temperature
  []

  [TP204]
    type = ComponentBoundaryVariableValue
    input = HX_active(primary_out)
    variable = temperature
  []

  [P101]
    type = ComponentBoundaryVariableValue
    input = pipe_P101(in)
    variable = pressure
  []

  [P102]
    type = ComponentBoundaryVariableValue
    input = pipe_after_FA(out)
    variable = pressure
  []

  [P103]
    type = ComponentBoundaryVariableValue
    input = riser_P103(out)
    variable = pressure
  []

  [P104]
    type = ComponentBoundaryVariableValue
    input = riser_P104(out)
    variable = pressure
  []

  [P105]
    type = ComponentBoundaryVariableValue
    input = riser_P105(out)
    variable = pressure
  []

  [P106]
    type = ComponentBoundaryVariableValue
    input = pipe_short_down(in)
    variable = pressure
  []

  [P107]
    type = ComponentBoundaryVariableValue
    input = pipe_out_HX(in)
    variable = pressure
  []
[]


[Preconditioning]
  active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  []

[]

[MultiApps]
  [sub_app]
    type = TransientMultiApp
    app_type = SubchannelApp
    execute_on = 'timestep_end'
    input_files = 'nacie_adp10_fps_subchannel.i'
  []
[]

[Transfers]
  [inlet_temperature_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = sub_app
    from_postprocessor = T_inlet_active
    to_postprocessor = T_in_bc
    execute_on = 'timestep_end'
  []

  [mass_flux_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = sub_app
    from_postprocessor = inlet_mass_flux
    to_postprocessor = mass_flux_SAM
    execute_on = 'timestep_end'
  []

  [outlet_pressure_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = sub_app
    from_postprocessor = P_outlet_active
    to_postprocessor = P_out_bc
    execute_on = 'timestep_end'
  []

  [pressure_drop_transfer]
    type = MultiAppPostprocessorTransfer
    from_multi_app = sub_app
    from_postprocessor = dpdz_core
    to_postprocessor = dpdz_core_receive
    execute_on = 'timestep_end'
    reduction_type = average
  []

[]

[Controls]
  [transfers_control]
    type = TimePeriod
    disable_objects = '*::inlet_temperature_transfer *::mass_flux_transfer *::outlet_pressure_transfer *::pressure_drop_transfer'
    start_time = -10000
    end_time = -8000
    execute_on = 'initial timestep_begin'
  []
[]

[Executioner]
  type = Transient

  accept_on_max_fixed_point_iteration = true
  disable_fixed_point_residual_norm_check = true
  custom_pp = 'dpdz_core_receive'
  custom_rel_tol = 1e-3
  fixed_point_max_its = 10

  start_time = -10000.0
  end_time = 6300 

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.25
    optimal_iterations = 15
    linear_iteration_ratio = 100
    dt = 0.5
    cutback_factor = 0.5
    cutback_factor_at_failure = 0.5
    timestep_limiting_postprocessor = dt_max_pp
  []
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '100'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 20
  l_tol = 1e-4
  l_max_its = 100

  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  [out]
    type = Checkpoint
    execute_on = 'FINAL'
  []
  [console]
    type = Console
  []
  [csv]
    type = CSV
  []
[]
