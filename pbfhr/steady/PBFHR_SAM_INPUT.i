# Modeling the PB-FHR reactor. Some parts of input came from VTB. The system was
# Built from descriptions based on the reference plant from Berkeley and several
# papers from that group.
#
# SAM Code Enhancement, Validation, and Reference
# Model Development for Fluoride-salt-cooled High temperature
# Reactors
#
# Technical Description of the “Mark 1” Pebble-Bed Fluoride-Salt-Cooled
# High-Temperature Reactor (PB-FHR) Power Plant

# Application : SAM

[GlobalParams]                  # global parameters initialization
    global_init_P = 1.0e5
    global_init_V = 1.796 # this is a really bad idea, every pipe is different.
    # A global init flux or mass flow rate makes a lot more sense
    global_init_T = 874
    Tsolid_sf = 1e-3

[PBModelParams]               # new user should not make changes to this block
    pbm_scaling_factors = '1 1e-2 1e-6'
    pspg = true
    supg_max = false
    p_order = 1
  []
[]


[EOS]
  [Flibe_Salt]
    type = SaltEquationOfState     # use built-in equation of state of Flibe
    salt_type = Flibe
  []

  [Air]
    type = AirEquationOfState
  []

  [Solar_Salt]
    type = SaltEquationOfState
    salt_type = Flibe
  []
[]

[MaterialProperties]
  [ss-mat]
    type = SolidMaterialProps
    k = 40
    Cp = 583.333
    rho = 6e3
  []
  [h451]
    type = SolidMaterialProps
    k = 173.49544
    Cp = 1323.92
    rho = 4914.2582
  []
  [fuel]
    type = SolidMaterialProps
    k = 32.5304 #15
    Cp = 1323.92
    rho = 4914.2582
  []
[]

[Functions]

[]

[Components]

  ### Dummy Sources and Sinks to ensure input is built properly ###

  # [inlet_air_HP]
  #   type = PBTDJ
  #   input = 'HP_Salt_to_Air_HX(secondary_in)' # Name of the connected components and the end type
  #   eos = Air # The equation -of - state
  #   v_bc = 0.5 # Velocity boundary condition
  #   T_bc = 418.59 # or T_fn = tin_sine # Temperature boundary condition
  # []
  #
  # [outlet_air_HP]
  #   type = PressureOutlet
  #   input = 'HP_Salt_to_Air_HX(secondary_out)' # Name of the connected components and the end type
  #   eos = Air # The equation -of - state
  #   p_bc = '1.876e6' # Pressure boundary condition
  # []
  #
  # [inlet_air_LP]
  #   type = PBTDJ
  #   input = 'LP_Salt_to_Air_HX(secondary_in)' # Name of the connected components and the end type
  #   eos = Air # The equation -of - state
  #   v_bc = 0.5 # Velocity boundary condition
  #   T_bc = 418.59 # or T_fn = tin_sine # Temperature boundary condition
  # []
  #
  # [outlet_air_LP]
  #   type = PressureOutlet
  #   input = 'LP_Salt_to_Air_HX(secondary_out)' # Name of the connected components and the end type
  #   eos = Air # The equation -of - state
  #   p_bc = '4.99e5' # Pressure boundary condition
  # []

  ### ###

  ### Main Salt Loop Containing reactor Core ###

  # Core inlet plenum through the outlet plenum (Pronghorn Replace)
  # Start with heat structure coupled to pipe then "upgrade" from there (Done Completely)

  [Upper_Plenum]
    type = PBVolumeBranch
    center = '0 4.94445 -0.76'
    inputs = 'Core_to_Upper(out) Core_Bypass(out)'
    outputs = 'Outlet_Plenum_Connective_Piping_1(in)'
    volume = 0.99970002
    K = '0.3668 0.35336 0.0006'    # loss coefficients
    Area = 0.2524495      # L = 3.96
    eos = Flibe_Salt
    initial_V = 2.040
    initial_T = 970
    initial_P = 1.7e5
    width = 2
    height = 0.2
    nodal_Tbc = true
  []

  [Core_to_Upper]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 4.94445 -1'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 1.327511
    Dh = 0.03
    length = 0.24
    n_elems = 13 #26
    initial_V = 0.37    #####
    initial_T = 970     #####
    initial_P = 1.7e5   #####

    WF_user_option = User
    User_defined_WF_parameters = '5.467 847.17 -1.0'
  []

  # [Core_Channel]
  #   type = PBOneDFluidComponent
  #   eos = Flibe_Salt
  #   position = '0 4.94445 -5.34'
  #   orientation = '0 0 1'
  #   roughness = 0.000015
  #   A = 1.327511
  #   Dh = 0.03
  #   length = 4.58
  #   n_elems = 13 #26
  #   initial_V = 0.290
  #   initial_T = 920
  #   initial_P = 3.6e5
  #
  #   WF_user_option = User
  #   User_defined_WF_parameters = '5.467 847.17 -1.0'
  # []
  #
  # [Core_Fuel]
  #   type = PBCoupledHeatStructure
  #
  #   position = '0 4.94445 -5.34'
  #   orientation = '0 0 1'
  #
  #   length = 4.58
  #   elem_number_axial = 13
  #   radius_i = 0.0
  #
  #   Ts_init = 950
  #   elem_number_radial = '5 5 2'
  #   material_hs = 'h451 fuel h451'
  #   n_heatstruct = 3
  #   fuel_type = cylinder
  #   name_of_hs = 'inner fuel outer'
  #   width_of_hs = '0.007896334 0.001463164 0.001020503'
  #
  #   hs_power = 10000 # Replace eventually
  #   hs_type = 'cylinder'
  #   power_fraction = '0 1 0'
  #   dim_hs = 2
  #
  #   HS_BC_type = 'Adiabatic Coupled'
  #   HTC_geometry_type = Bundle
  #   PoD = 1.1
  #   HT_surface_area_density_right = 133.33
  #
  #   ext_power_source = False
  #
  #   name_comp_right = Core_Channel
  # []

  ### Coupled Core Section ###

  [CH1_in]
    type = CoupledPPSTDV
    input = 'Lower_to_Core(out)'
    eos = Flibe_Salt
    p_bc = 1e5
    T_bc = 873  ######
    postprocessor_pbc = from_sub_pbc_out
    postprocessor_Tbc = from_sub_Tbc_out
  [../]

  [CH1_out]
    type = CoupledPPSTDJ
    input = 'Core_to_Upper(in)'
    eos = Flibe_Salt
    v_bc = 0.37  ###
    T_bc = 970
    postprocessor_vbc = from_sub_vbc_in
    postprocessor_Tbc = from_sub_Tbc_in
  []

  ###   ###

  [Core_Bypass]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 5.92445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.065
    Dh = 0.01
    length = 4.58
    n_elems = 13 #26
    initial_V = 1.993
    initial_P = 3.6e5
  []

  [Lower_to_Core]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 4.94445 -5.34'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 1.327511
    Dh = 0.03
    length = 0.24
    n_elems = 13 #26
    initial_V = 0.37    #####
    initial_T = 873.15  #####
    initial_P = 3.6e5

    WF_user_option = User
    User_defined_WF_parameters = '5.467 847.17 -1.0'
  []

  [Lower_Plenum]
    type = PBVolumeBranch
    inputs = 'Downcomer(out)'    # A = 0.3038791
    outputs = 'Core_Bypass(in) Lower_to_Core(in)' # A = 1.327511  A = 0.065
    center = '0 6.53445 -5.34'
    volume = 0.2655022
    #K = '0.35964 0.0 0.3750'
    K = '0.35964 0.0 0.6000'
    Area = 1.327511      # L = 0.2
    eos = Flibe_Salt
    initial_V = 0.388
    initial_P = 3.4e5
    width = 3.18
    height = 0.2
  []

  [Downcomer]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 8.12445 -0.58'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3038791
    Dh = 0.0560284
    length = 4.76
    n_elems = 14 #27
    initial_V = 1.695
    initial_P = 2.9e5
  []

  # Injection Plenum Where Low Pressure and High Pressure Streams rejoin (Done Completely)

  [Injection_Plenum]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 8.12445 2.96'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.3019068
    Dh = 0.438406
    length = 3.04
    n_elems = 9 #17
    initial_P = 2.1e5
  []

  [Injection_Plenum_Branch_1]
    type = PBBranch
    inputs = 'HP_Salt_Stand_To_RV(out) LP_Salt_Stand_To_RV(out)'       # A = 0.3041
    outputs = 'Injection_Plenum(in)'       # A = 0.4926017
    eos = Flibe_Salt
    K = '0.0 0.0 0.0'
    Area = 0.3041
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  []

  [Injection_Plenum_Branch_2]
    type = PBVolumeBranch
    inputs = 'Injection_Plenum(out)'       # A = 0.3041
    outputs = 'Downcomer(in) Downcomer_to_DHX(in)'       # A = 0.4926017
    eos = Flibe_Salt
    center = '0 8.12445 -0.33'
    volume = 0.15193955
    K = '0.0 0.0 0.3727'
    Area = 0.3038791     # L = 0.5
    initial_V = 1.784
    initial_P = 2.5e5
    width = 0.2
  []

  # HP Coiled Tube HX (Done Completely)

  [HP_Salt_Pump]
    type = PBPump # This is a PBPump component
    eos = Flibe_Salt
    inputs = 'Expansion_Tank_to_Pump_Piping_1(out)'
    outputs = 'HP_Piping_from_Pump_to_HX_1(in)'
    K = '0 0' # Form loss coefficient at pump inlet and outlet
    K_reverse = '2000000 2000000'
    Area = 0.15205 # Reference pump flow area
    initial_P = 1.5e5 # Initial pressure
    Head = 183737.5 # Pump head , Pa

    Desired_mass_flow_rate = 1230
    # Coupled
    # 1300 -> 1018
    # 1100 -> 907
    # 976 -> 836
    # 610 for uncoupled
    ######### this has to include the bypass flow rate, but also not the only pump contributing!
  []

  [HP_Piping_from_Pump_to_HX_1]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 10.271 3.43'
    orientation = '0 3.22967 -0.046'
    roughness = 0.000015
    A = 0.15205
    Dh = 0.4399955
    length = 3.23
    n_elems = 9 #18
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  []

  [HP_Hot_CTAH_Manifold]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 13.5 3.384'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.24630085
    Dh = 0.28
    length = 3.418
    n_elems = 10 #19
    initial_V = 1.100
    initial_T = 970
    initial_P = 4.9e5
  []

  [HP_Salt_to_Air_HX] # Helical Heat Exchanger (Diagram indicates mostly CC)
    type = PBPipe
    eos = Flibe_Salt
    position = '0 13.5 -0.034'
    orientation = '0 18.4692719 -0.164'
    roughness = 0.000015
    A = 0.22458895
    Dh = 0.004572
    length = 18.47
    n_elems = 50 #99
    initial_V = 1.207
    initial_T = 970  ##### before the HX!
    initial_P = 4.1e5

    HS_BC_type = Temperature
    Hw = 2000   #cut for transient
    Ph = 392.9818537
    T_wall = 873.15
    Twall_init = 900
    hs_type = cylinder
    material_wall = ss-mat
    dim_wall = 2
    n_wall_elems = 4
    radius_i = 0.002286
    wall_thickness = 0.000889
  []

  [HP_Cold_CTAH_Manifold]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 18.2055 -0.197'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.0962113
    Dh = 0.175
    length = 3.418
    n_elems = 10 #19
    initial_V = 2.818
    initial_P = 2.8e5
  []

  [HP_Salt_Drain_Tanks]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 18.2055 -3.615'
    orientation = '0 -3.4791917 -0.075'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 3.48
    n_elems = 10 #20
    initial_P = 3.1e5
  []

  [HP_Salt_Stand_Pipe]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 14.7263 -3.69'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 6.51
    n_elems = 19 #37
    initial_P = 2.5e5
  []

  [HP_Salt_Stand_To_RV]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 14.7263 2.82'
    orientation = '0 -6.6018536 0.14'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 6.6033378
    n_elems = 19 #37
    initial_P = 1.8e5
  []

  [HP_Branch_to_Manifold]
    type = PBBranch
    inputs = 'HP_Piping_from_Pump_to_HX_1(out)'
    outputs = 'HP_Hot_CTAH_Manifold(in) '
    eos = Flibe_Salt
    K = '0.16804 0.16804'
    Area = 0.15205
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  []

  [HP_Manifold_to_HX]
    type = PBBranch
    inputs = 'HP_Hot_CTAH_Manifold(out)'
    outputs = 'HP_Salt_to_Air_HX(in) '
    eos = Flibe_Salt
    K = '0.01146 0.01146'
    Area = 0.22458895
    initial_V = 1.207
    initial_T = 970
    initial_P = 5.2e5
  []

  [HP_HX_to_Manifold]
    type = PBBranch
    inputs = 'HP_Salt_to_Air_HX(out)'
    outputs = 'HP_Cold_CTAH_Manifold(in) '
    eos = Flibe_Salt
    K = '0.28882 0.28882'
    Area = 0.0962113
    initial_V = 2.818
    initial_P = 2.5e5
  []

  [HP_Manifold_to_Drain]
    type = PBPump
    inputs = 'HP_Cold_CTAH_Manifold(out)'
    outputs = 'HP_Salt_Drain_Tanks(in) '
    eos = Flibe_Salt
    K = '0.15422 0.15422'
    K_reverse = '2000000 2000000'
    Area = 0.0962113
    initial_P = 3.1e5
  []

  [HP_Drain_to_Stand]
    type = PBSingleJunction
    inputs = 'HP_Salt_Drain_Tanks(out)'
    outputs = 'HP_Salt_Stand_Pipe(in) '
    eos = Flibe_Salt
  []

  [HP_Stand_to_SRV]
    type = PBSingleJunction
    inputs = 'HP_Salt_Stand_Pipe(out)'
    outputs = 'HP_Salt_Stand_To_RV(in) '
    eos = Flibe_Salt
  []

  # LP Coiled Tube HX (Done Completely)

  [LP_Salt_Pump]
    type = PBPump # This is a PBPump component
    eos = Flibe_Salt
    inputs = 'Expansion_Tank_to_Pump_Piping_2(out)'
    outputs = 'LP_Piping_from_Pump_to_HX_1(in)'
    K = '0 0' # Form loss coefficient at pump inlet and outlet
    K_reverse = '2000000 2000000'
    Area = 0.15205 # Reference pump flow area
    initial_P = 1.5e5 # Initial pressure
    Head = 183737.5 # Pump head , Pa
  []

  [LP_Piping_from_Pump_to_HX_1]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 10.271 3.43'
    orientation = '0 3.22967 -0.046'
    roughness = 0.000015
    A = 0.15205
    Dh = 0.4399955
    length = 3.23
    n_elems = 9 #18
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  []

  [LP_Hot_CTAH_Manifold]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 13.5 3.384'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.24630085
    Dh = 0.28
    length = 3.418
    n_elems = 10 #19
    initial_V = 1.100
    initial_T = 970
    initial_P = 4.9e5
  []

  [LP_Salt_to_Air_HX] # Helical Heat Exchanger (Diagram indicates mostly CC)
    type = PBPipe
    eos = Flibe_Salt
    position = '0 13.5 -0.034'
    orientation = '0 18.4692719 -0.164'
    roughness = 0.000015
    A = 0.22458895
    Dh = 0.004572
    length = 18.47
    n_elems = 50 #99
    initial_V = 1.207
    initial_T = 970
    initial_P = 4.1e5

    HS_BC_type = Temperature
    Hw = 2000   #cut for transient
    Ph = 392.9818537
    T_wall = 873.15
    Twall_init = 900
    hs_type = cylinder
    material_wall = ss-mat
    dim_wall = 2
    n_wall_elems = 4
    radius_i = 0.002286
    wall_thickness = 0.000889
  []

  [LP_Cold_CTAH_Manifold]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 18.2055 -0.197'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.0962113
    Dh = 0.175
    length = 3.418
    n_elems = 10 #19
    initial_V = 2.818
    initial_P = 2.8e5
  []

  [LP_Salt_Drain_Tanks]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 18.2055 -3.615'
    orientation = '0 -3.4791917 -0.075'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 3.48
    n_elems = 10 #20
    initial_P = 3.1e5
  []

  [LP_Salt_Stand_Pipe]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 14.7263 -3.69'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 6.51
    n_elems = 19 #37
    initial_P = 2.5e5
  []

  [LP_Salt_Stand_To_RV]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 14.7263 2.82'
    orientation = '0 -6.6018536 0.14'
    roughness = 0.000015
    A = 0.1509534
    Dh = 0.438406
    length = 6.6033378
    n_elems = 19 #37
    initial_P = 1.8e5
  []

  [LP_Branch_to_Manifold]
    type = PBBranch
    inputs = 'LP_Piping_from_Pump_to_HX_1(out)'
    outputs = 'LP_Hot_CTAH_Manifold(in) '
    eos = Flibe_Salt
    K = '0.16804 0.16804'
    Area = 0.15205
    initial_V = 1.783
    initial_T = 970
    initial_P = 4.6e5
  []

  [LP_Manifold_to_HX]
    type = PBBranch
    inputs = 'LP_Hot_CTAH_Manifold(out)'
    outputs = 'LP_Salt_to_Air_HX(in) '
    eos = Flibe_Salt
    K = '0.01146 0.01146'
    Area = 0.22458895
    initial_V = 1.207
    initial_T = 970
    initial_P = 5.2e5
  []

  [LP_HX_to_Manifold]
    type = PBBranch
    inputs = 'LP_Salt_to_Air_HX(out)'
    outputs = 'LP_Cold_CTAH_Manifold(in) '
    eos = Flibe_Salt
    K = '0.28882 0.28882'
    Area = 0.0962113
    initial_V = 2.818
    initial_P = 2.5e5
  []

  [LP_Manifold_to_Drain]
    type = PBPump
    inputs = 'LP_Cold_CTAH_Manifold(out)'
    outputs = 'LP_Salt_Drain_Tanks(in) '
    eos = Flibe_Salt
    K = '0.15422 0.15422'
    K_reverse = '2000000 2000000'
    Area = 0.0962113
    initial_P = 3.1e5
  []

  [LP_Drain_to_Stand]
    type = PBSingleJunction
    inputs = 'LP_Salt_Drain_Tanks(out)'
    outputs = 'LP_Salt_Stand_Pipe(in) '
    eos = Flibe_Salt
  []

  [LP_Stand_to_SRV]
    type = PBSingleJunction
    inputs = 'LP_Salt_Stand_Pipe(out)'
    outputs = 'LP_Salt_Stand_To_RV(in) '
    eos = Flibe_Salt
  []

  # DHX Pool and "Diode" connection

  [Downcomer_to_DHX]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 1 -0.58'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 0.58
    n_elems = 3 #3
    initial_V = 0.767
    initial_P = 2.5e5
  []

  [DHX]
    type = PBHeatExchanger
    eos = Flibe_Salt
    eos_secondary = Solar_Salt
    hs_type = cylinder

    radius_i = 0.00545
    position = '0 0.5 0'
    orientation = '0 0 1'
    A = 0.2224163
    Dh = 0.01085449
    A_secondary = 0.1836403
    Dh_secondary = 0.0109
    roughness = 0.000015
    roughness_secondary = 0.000015
    length = 2.5
    n_elems = 7 #14

    initial_V = 0.122 #0.11969487
    initial_V_secondary = 0.029349731
    initial_T = 870
    initial_T_secondary = 830
    initial_P = 1.9e5
    initial_P_secondary = 2.0e5

    HT_surface_area_density =  441.287971
    HT_surface_area_density_secondary = 458.715596
    #Hw = 526.266
    #Hw_secondary = 440
    HTC_geometry_type = Pipe
    HTC_geometry_type_secondary = Pipe
    PoD = 1.1

    Twall_init = 900
    wall_thickness = 0.0009
    dim_wall = 2
    material_wall = ss-mat
    n_wall_elems = 4
  []

  [DHX_to_Hot_Leg]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 1 2.5'
    orientation = '0 2.96445 .51'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.008
    n_elems = 9 #17
    initial_V = 0.767
    initial_T = 860
    initial_P = 3.6e5
  []

  [Fluidic_Diode_DHX]
    type = PBPump
    inputs = 'Downcomer_to_DHX(out)'       # A = 0.03534292
    outputs = 'DHX(primary_in)'      # A = 0.2224163
    eos = Flibe_Salt
    K = '50.0 50.0'
    K_reverse = '1.0 1.0'
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 2.3e5
  []

  [DHX_to_Hot_Leg_Branch]
    type = PBBranch
    inputs = 'DHX(primary_out)'      # A = 0.2224163
    outputs = 'DHX_to_Hot_Leg(in)'       # A = 0.03534292
    eos = Flibe_Salt
    K = '94.8693 94.8693'
    Area = 0.03534292
    initial_V = 0.767
    initial_P = 1.3e5
  []

  # Expansion Tank with LP and HP salt side pumps (No pressure difference on salt side) (Done Completely)

  [Branch_to_Tank]
    type = PBVolumeBranch
    inputs = 'Outlet_Plenum_Connective_Piping_2(out)'
    outputs = 'Expansion_Tank_to_Pump_Piping_1(in) Expansion_Tank_to_Pump_Piping_2(in) Pipe_To_Tank(in)'
    center = '0 8.25 3.09'
    volume = 0.0264208
    K = '0 0.3744 0.3744 0.35187'
    Area = 0.264208
    eos = Flibe_Salt
    initial_V = 2.052
    initial_T = 970
    width = 0.1
  []

  [Pipe_To_Tank]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 8.25 3.19'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 1
    initial_V = 0.0
    initial_T = 970
  []

  [Expansion_Volume]
    type = PBLiquidVolume
    center = '0 8.25 3.74'
    inputs = 'Pipe_To_Tank(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 970
    initial_V = 0.0
    display_pps = false
    covergas_component = 'Cover_Gas'
    eos = Flibe_Salt
  []

  [Cover_Gas]
    type = CoverGas
  	n_liquidvolume = 1
  	name_of_liquidvolume = 'Expansion_Volume'
    initial_P = 9e4
    initial_Vol = 0.5
    initial_T = 970
  []

  [Expansion_Tank_to_Pump_Piping_1] # Can't connect a pump to a volume so a pipe is needed
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 8.30 3.09' #'0 8.19357 3.091'
    orientation = '0 1.970888 0.34'
    roughness = 0.000015
    A = 3.3145
    Dh = 1.452610
    length = 2.00
    n_elems = 6 #11
    initial_V = 0.164
    initial_T = 970
  []

  [Expansion_Tank_to_Pump_Piping_2] # Can't connect a pump to a volume so a pipe is needed
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 8.30 3.09' #'0 8.19357 3.091'
    orientation = '0 1.970888 0.34'
    roughness = 0.000015
    A = 3.3145
    Dh = 1.452610
    length = 2.00
    n_elems = 6 #11
    initial_V = 0.164
    initial_T = 970
  []

  # Outlet plenum connective piping (Needs to be accurate to volume and DP)

  [Outlet_Plenum_Connective_Piping_1]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 3.96445 -0.76'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.2512732
    Dh = 0.5656244
    length = 3.77
    n_elems = 11 #21
    initial_V = 2.050
    initial_T = 970
    initial_P = 1.3e5
  []

  [Outlet_Plenum_Connective_Piping_2]
    type = PBOneDFluidComponent
    eos = Flibe_Salt
    position = '0 4.46445 3.01'
    orientation = '0 3.72912 0.081'
    roughness = 0.000015
    A = 0.264208
    Dh = 0.58
    length = 3.73
    n_elems = 11 #21
    initial_V = 2.05
    initial_T = 970
  []

  [Outlet_Plenum_Connective_Piping_Branch_1]
    type = PBVolumeBranch
    inputs = 'Outlet_Plenum_Connective_Piping_1(out) DHX_to_Hot_Leg(out)'
    outputs = 'Outlet_Plenum_Connective_Piping_2(in)'
    eos = Flibe_Salt
    center = '0 4.21445 3.01'
    volume = 0.132104
    K = '0.3713 0.00636 0.0'   # loss coefficients
    Area = 0.264208      # L = 0.5
    initial_V = 2.052
    initial_T = 970
    height = 0.1
    nodal_Tbc = true
  []

  ### ###

  ### DHX loop Described in FHR_2021.pdf ("Solar Salt") ###

  [DRACS_Hot_Leg_1]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '0 0 2.5'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.45
    n_elems = 10 #20
  []

  [DRACS_Hot_Leg_2]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '0 -0.2 5.95'
    orientation = '0 -1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 3.67
    n_elems = 11 #21
  []

  [TCHX_Manifold]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '0 -3.87 5.95'
    orientation = '0 0 1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 2.60
    n_elems = 8 #15
  []

  [TCHX_Salt_Tube]
    type = PBPipe
    eos = Solar_Salt
    position = '0 -3.87 8.55'
    orientation = '0 -5.407402334 -2.6'
    roughness = 0.000015
    A = 0.1746822
    Dh = 0.0109
    length = 6.0
    n_elems = 17 #34
    initial_V = 0.04855862

    HS_BC_type = Temperature
    Hw = 1000
    #Ph = 64.10356978
    HT_surface_area_density = 366.972535
    T_wall = 799.15
    Twall_init = 800
    hs_type = cylinder
    material_wall = ss-mat
    dim_wall = 2
    n_wall_elems = 4
    radius_i = 0.00545
    wall_thickness = 0.0009
  []

  [DRACS_Cold_Leg_1]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '1 -4.43 5.95'
    orientation = '0 1 0'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 4.43
    n_elems = 13 #25
  []

  [DRACS_Cold_Leg_2]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '1 0 5.95'
    orientation = '0 0 -1'
    roughness = 0.000015
    A = 0.03534292
    Dh = 0.15
    length = 5.95
    n_elems = 17 #34
  []

  [Pipe_To_DRACS_Tank]
    type = PBOneDFluidComponent
    eos = Solar_Salt
    position = '0 0 5.95'
    orientation = '0 0 1'
    A = 1
    Dh = 1.12838
    length = 0.1
    n_elems = 1
    initial_T = 852.7
  []

  [DRACS_Tank]
    type = PBLiquidVolume
    center = '0 0 6.5'
    inputs = 'Pipe_To_DRACS_Tank(out)'
    Steady = 1
    K = '0.0'
    Area = 1
    volume = 0.9
    initial_level = 0.4
    initial_T = 852.7
    initial_V = 0.0
    display_pps = true
    covergas_component = 'DRACS_Tank_Cover_Gas'
    eos = Solar_Salt
  []

  [DRACS_Tank_Cover_Gas]
    type = CoverGas
    n_liquidvolume = 1
    name_of_liquidvolume = 'DRACS_Tank'
    initial_P = 2e5
    initial_Vol = 0.5
    initial_T = 852.7
  []

  [DRACS_Tank_Branch]
    type = PBVolumeBranch
    inputs = 'DRACS_Hot_Leg_1(out)'       # A = 0.1836403
    outputs = 'DRACS_Hot_Leg_2(in) Pipe_To_DRACS_Tank(in)'   # A = 0.1836403 A = 1
    center = '0 -0.1 5.95'
    volume = 0.003534292
    K = '0.0 0.0 0.3673'
    Area = 0.03534292
    eos = Solar_Salt
  []

  [Hot_Leg_1_Branch]
    type = PBBranch
    inputs = 'DHX(secondary_in)'  # A = 0.1836403
    outputs = 'DRACS_Hot_Leg_1(in)'       # A = 0.03534292
    eos = Solar_Salt
    K = '56.3666 56.3666'
    Area = 0.03534292
  []

  [TCHX_in_Branch]
    type = PBSingleJunction
    inputs = 'DRACS_Hot_Leg_2(out)'
    outputs = 'TCHX_Manifold(in)'
    eos = Solar_Salt
  []

  [TCHX_in_Salt_Tube_Branch]
    type = PBBranch
    inputs = 'TCHX_Manifold(out)'    # A = 0.03534292
    outputs = 'TCHX_Salt_Tube(in)'    # A = 0.1746822
    eos = Solar_Salt
    K = '0.3655 0.3655'
    #K = '0.0 0.3655'
    Area = 0.03534292
  []

  [TCHX_Tube_To_Cold_Leg_Branch]
    type = PBBranch
    inputs = 'TCHX_Salt_Tube(out)'    # A = 0.1746822
    outputs = 'DRACS_Cold_Leg_1(in)'    # A = 0.03534292
    eos = Solar_Salt
    K = '0.3655 0.3655'
    #K = '0.3655 0.0'
    Area = 0.03534292
  []

  [DRACS_Cold_Leg_1_to_2_Branch]
    type = PBSingleJunction
    inputs = 'DRACS_Cold_Leg_1(out)'
    outputs = 'DRACS_Cold_Leg_2(in)'
    eos = Solar_Salt
  []

  [Cold_Leg_To_DHX_Branch]
    type = PBBranch
    inputs = 'DRACS_Cold_Leg_2(out)'    # A = 0.03534292
    outputs = 'DHX(secondary_out)'      # A = 0.1836403
    eos = Solar_Salt
    K = '0.3666 0.3666'
    #K = '0.0 0.3666'
    Area = 0.03534292
  []

  ### ###

  ### RCCS water loop described in FHR_2021.pdf ### (No info, water does not exist in SAM)

  ### ###

  ### Air side of High Pressure HX (High Pressure Air) ### (No info)

  ### ###

  ### Air side of Low Pressure HX (Low Pressure Air) ### (No Info)

  ### ###

  ### Air Side of TCHX heat exchanger ###

  ### ###

[]

[Postprocessors]
  # Outlet of core
  [from_sub_vbc_in]
    type = FlexReceiver
    default = 0.37  #############
    relaxation_factor = 0.8
  []
  [from_sub_Tbc_in]
    type = Receiver
    default = 970  #############
  []

  # Turns out the CP is pretty much constant If the mdot is the same then we're good
  # ????
  # [from_sub_E_in]
  #   type = Receiver
  #   default = ${fparse 976 * 2415.78 * 970}
  # []
  # [from_sub_Tbc_in]
  #   type = T_from_E
  #   eos = Flibe_Salt
  #   Ein_pp = from_sub_E_in
  #   mdot_pp = Coremdot      #############    TO CHANGE THIS SHOULD BE RECEIVED
  #   pressure_pp = CoreOutletP
  # []

  # Inlet of core
  [from_sub_pbc_out]
    type = FlexReceiver
    default = 3.6e5
  []
  [from_sub_Tbc_out]
    type = Receiver
    default = 873.15  ######
  []

  # Get core inlet mass & energy flow rate, through v, T, rho
  # rho could be skipped if SAM and Pgh were using the same EOS
  [Corev]
    type = ComponentBoundaryVariableValue
    input = 'Lower_to_Core(out)'
    variable = 'velocity'
    execute_on = 'initial timestep_end'
  []
  [Corerho]
    type = ComponentBoundaryVariableValue
    input = 'Lower_to_Core(out)'
    variable = 'rho'
    execute_on = 'initial timestep_end'
  []
  [Coremdot]
    type = ParsedPostprocessor
    function = 'Corev * Corerho * 1.327511'
    pp_names = 'Corev Corerho'
    execute_on = 'initial timestep_end'
  []
  [CoreT]
    type = ComponentBoundaryVariableValue
    input = 'Lower_to_Core(out)'
    variable = 'temperature'
    execute_on = 'initial timestep_end'
  []

  # Outlet pressure
  [CoreOutletP]
    type = ComponentBoundaryVariableValue
    input = 'Core_to_Upper(in)'
    variable = 'pressure'
    execute_on = 'initial timestep_end'
  []

  [picard_its]
    type = NumFixedPointIterations
    execute_on = 'initial timestep_end'
  []
[]

[DefaultElementQuality]
  failure_type = Warning
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu NONZERO 1e-9'
  []
[] # End preconditioning block

[Executioner]
  type = Transient


  dt = 1e0
  dtmin = 1e-5
  # setting time step range

  start_time = 0.0
  num_steps = 200
  end_time = 100

  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1
    cutback_factor     = 0.5
    growth_factor      = 2.0
  []


  # Time step size is controlled by this TimeStepper
  # [TimeStepper]
  #   type = FunctionDT
  #   time_t = '0 0.1 0.2 20 21 100 101 1e5' # Physical time
  #   time_dt ='0.01 0.01 0.1 0.1 0.5 0.5 1 1' # Time step size dependent on
  #   # the physical time
  # []

  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '100'
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 20
  l_tol = 1e-5
  l_max_its = 100

  fixed_point_algorithm = 'steffensen'
  fixed_point_max_its = 100
  relaxed_variables = 'temperature pressure velocity'

  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  csv = true
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end '
    sequence = false
  []
[]

[MultiApps]
  [pronghorn_sub]
    app_type = PronghornApp
    # execute_on = timestep_end
    type = TransientMultiApp
    input_files = ss1_combined.i
  []
[]

# Isothermal transfers
# [Transfers]
#   [to_pgh]
#     type = MultiAppReporterTransfer
#     direction = to_multiapp
#     multi_app = pronghorn_sub
#     from_reporters = 'Coremdot/value CoreOutletP/value'
#     to_reporters = 'inlet_mdot/value outlet_pressure/value'
#   []
#
#   [from_pgh]
#     type = MultiAppReporterTransfer
#     direction = from_multiapp
#     multi_app = pronghorn_sub
#     from_reporters = 'v_out_normalized_for_SAM/value pressure_in/value'
#     to_reporters = 'from_sub_vbc_in/value from_sub_pbc_out/value'
#   []
# []

# Regular coupling
[Transfers]
  # Send core inlet temperature and velocity, core outlet pressure
  [to_pgh]
    type = MultiAppReporterTransfer
    direction = to_multiapp
    multi_app = pronghorn_sub
    from_reporters = 'Coremdot/value CoreT/value CoreOutletP/value'
    to_reporters = 'inlet_mdot/value inlet_temp_fluid/value outlet_pressure/value'
  []

  # Receive core outlet temperature and velocity, core inlet pressure
  [from_pgh]
    type = MultiAppReporterTransfer
    direction = from_multiapp
    multi_app = pronghorn_sub
    from_reporters = 'v_out_normalized_for_SAM/value T_flow_out/value pressure_in/value'
    to_reporters = 'from_sub_vbc_in/value from_sub_Tbc_in/value from_sub_pbc_out/value'
    # not transferring T_inlet, let s assume no flow reversal for now
  []
  # Energy transfer
  # [from_pgh]
  #   type = MultiAppReporterTransfer
  #   direction = from_multiapp
  #   multi_app = pronghorn_sub
  #   from_reporters = 'v_out_normalized_for_SAM/value eflow_out/value pressure_in/value'
  #   to_reporters = 'from_sub_vbc_in/value from_sub_E_in/value from_sub_pbc_out/value'
  #   # not transferring T_inlet, let s assume no flow reversal for now
  # []
  # Isothermal study
  # [from_pgh]
  #   type = MultiAppReporterTransfer
  #   direction = from_multiapp
  #   multi_app = pronghorn_sub
  #   from_reporters = 'v_out_normalized_for_SAM/value pressure_in/value'
  #   to_reporters = 'from_sub_vbc_in/value from_sub_pbc_out/value'
  #   # not transferring T_inlet, let s assume no flow reversal for now
  # []
[]
