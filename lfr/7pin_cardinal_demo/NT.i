################################################################################
## Lead Fast Reactor 7-pin assembly
## Neutronics simulation
## Documentation: https://mooseframework.inl.gov/virtual_test_bed/lfr/cardinal_7pincell/Cardinal_7pin_LFR_demo.html
## Contact: hansol.park@anl.gov
################################################################################

#half_pinpitch = 0.0067123105    # m
#fuel_r_o = 0.004318648          # m
#fuel_r_i = 0.00202042           # m
#gap_i = ${fparse fuel_r_i * 0.25}
#clad_r = 0.0054037675           # m
#duct_thickness = 0.0035327      # m
#flat_to_flat = 0.037164         # m
activefuelheight = 1.06072      # m
#lowerreflectorheight = 0.2      # m
#upperreflectorheight = 0.2      # m

#num_coolreg = 2
#num_coolreg_back = 2
num_layers_fuel = 20
num_layers_refl = 4
#numside=6

linearpower = 27466.11572112955 # W/m
inlet_T = 693.15                # K
fuelconductance = 1.882        # W/m/K
#cladconductance = 21.6         # W/m/K

mid_gap = 1
mid_ifl = 2
mid_ofl = 3
mid_clad = 4
mid_cool = 5
mid_duct = 6

# === derived
#half_asmpitch = ${fparse flat_to_flat / 2 + duct_thickness}
coolantdensity_ref = ${fparse 10678-13174*(inlet_T-600.6)/10000} # kg/m^3

richardsonreltol=1E-1
richardsonabstol=1E+5
maxinnerits=1
maxfixptits=100000
richardsonmaxits=1000

#==============================================================

# material_id 1: helium gap  | block_id 1
#             2: inner fuel             100
#             3: outer fuel             101 102 103 104 105 106
#             4: clad                   2
#             5: coolant                4
#             6: duct                   3
#             4: reflector(clad)        5, 6

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'NTmesh_in.e'
    exodus_extra_element_integers = 'material_id pin_id coarse_element_id'
  []
[]

[Executioner]
  type = SweepUpdate
  verbose = false

  richardson_rel_tol = ${richardsonreltol}
  richardson_abs_tol = ${richardsonabstol}
  richardson_max_its = ${richardsonmaxits}
  richardson_value = 'eigenvalue'
  inner_solve_type = GMRes
  max_inner_its = ${maxinnerits}

  fixed_point_solve_outer = true
  fixed_point_max_its = ${maxfixptits}
  custom_pp = nek_bulk_temp_pp
  custom_rel_tol = 1e-8
  force_fixed_point_solve = true

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  diffusion_eigen_solver_type = newton
  prolongation_type = multiplicative
[]

[PowerDensity]
  power = ${fparse linearpower * activefuelheight} # W
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 9
  ReflectingBoundary = 'ASSEMBLY_SIDE'
  VacuumBoundary = 'ASSEMBLY_TOP ASSEMBLY_BOTTOM'
  [sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 1
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering  = true
  []
[]

[AuxVariables]
  [nek_bulk_temp]
    block = 'Lead'
    initial_condition = ${inlet_T}  # K
  []
  [solid_temp]
    block = 'HeliumHolePrism HeliumHole Clad Fuel00 Fuel10 Fuel11 Fuel12 Fuel13 Fuel14 Fuel15 LowerHeliumHolePrism LowerHeliumHole LowerClad LowerFuel00 LowerFuel10 LowerFuel11 LowerFuel12 LowerFuel13 LowerFuel14 LowerFuel15 UpperHeliumHolePrism UpperHeliumHole UpperClad UpperFuel00 UpperFuel10 UpperFuel11 UpperFuel12 UpperFuel13 UpperFuel14 UpperFuel15 Duct'
    initial_condition = ${inlet_T} # K
  []
  [fluid_density]
    block = 'Lead'
    initial_condition = ${coolantdensity_ref}  # kg/m^3
  []
  [nek_surf_temp]
    initial_condition = ${inlet_T}  # K
  []
[]

[AuxKernels]
  [fluid_density_temp]
    type = ParsedAux
    variable = fluid_density
    coupled_variables = 'nek_bulk_temp'
    expression = '10678-13174*(nek_bulk_temp-600.6)/10000'
    execute_on = 'INITIAL timestep_end'
  []
[]

[GlobalParams]
    plus = true
    dbgmat = false
    grid_names = 'Temp'
    maximum_diffusion_coefficient = 1000
    is_meter = true
[]

[Compositions]
  [IF_HELIUM00]
    type = IsotopeComposition
    isotope_densities = 'pseudo_HE4__FR1 2.512611E-05'
    density_type = atomic
    composition_ids = ${mid_gap}
  []
  [IF_FUELR100]
    type = IsotopeComposition
    isotope_densities = 'pseudo_U234_FR1 1.769055E-07
                         pseudo_U235_FR1 4.404137E-05
                         pseudo_U238_FR1 1.735054E-02
                         pseudo_PU238FR1 1.244939E-05
                         pseudo_PU239FR1 3.413306E-03
                         pseudo_PU240FR1 1.319941E-03
                         pseudo_PU241FR1 8.656869E-05
                         pseudo_PU242FR1 1.234538E-04
                         pseudo_AM241FR1 2.087265E-04
                         pseudo_O16__FR1 4.444138E-02'
    density_type = atomic
    composition_ids = ${mid_ifl}
  []
  [IF_FUELR200]
    type = IsotopeComposition
    isotope_densities = 'pseudo_U234_FR2 1.769055E-07
                         pseudo_U235_FR2 4.404137E-05
                         pseudo_U238_FR2 1.735054E-02
                         pseudo_PU238FR2 1.244939E-05
                         pseudo_PU239FR2 3.413306E-03
                         pseudo_PU240FR2 1.319941E-03
                         pseudo_PU241FR2 8.656869E-05
                         pseudo_PU242FR2 1.234538E-04
                         pseudo_AM241FR2 2.087265E-04
                         pseudo_O16__FR2 4.444138E-02'
    density_type = atomic
    composition_ids = ${mid_ofl}
  []
  [IF_CLAD00]
    type = IsotopeComposition
    isotope_densities = 'pseudo_FE54_FCD 3.185952E-03
                         pseudo_FE56_FCD 5.001168E-02
                         pseudo_FE57_FCD 1.154947E-03
                         pseudo_FE58_FCD 1.537129E-04
                         pseudo_NI58_FCD 8.373412E-03
                         pseudo_NI60_FCD 3.225451E-03
                         pseudo_NI61_FCD 1.402235E-04
                         pseudo_NI62_FCD 4.469793E-04
                         pseudo_NI64_FCD 1.138947E-04
                         pseudo_CR50_FCD 5.643439E-04
                         pseudo_CR52_FCD 1.088250E-02
                         pseudo_CR53_FCD 1.234043E-03
                         pseudo_CR54_FCD 3.071758E-04
                         pseudo_MN55_FCD 1.271641E-03
                         pseudo_MO92_FCD 1.080550E-04
                         pseudo_MO94_FCD 6.735188E-05
                         pseudo_MO95_FCD 1.159146E-04
                         pseudo_MO96_FCD 1.214544E-04
                         pseudo_MO97_FCD 6.953578E-05
                         pseudo_MO98_FCD 1.757019E-04
                         pseudo_MO100FCD 7.011875E-05
                         pseudo_SI28_FCD 1.300140E-03
                         pseudo_SI29_FCD 6.601594E-05
                         pseudo_SI30_FCD 4.351798E-05
                         pseudo_C____FCD 3.489938E-04
                         pseudo_P31__FCD 6.766687E-05
                         pseudo_S32__FCD 2.068704E-05
                         pseudo_S33__FCD 1.656123E-07
                         pseudo_S34__FCD 9.348567E-07
                         pseudo_S36__FCD 4.358298E-09
                         pseudo_TI46_FCD 3.210951E-05
                         pseudo_TI47_FCD 2.895766E-05
                         pseudo_TI48_FCD 2.869267E-04
                         pseudo_TI49_FCD 2.105602E-05
                         pseudo_TI50_FCD 2.016107E-05
                         pseudo_V____FCD 2.742873E-05
                         pseudo_ZR90_FCD 7.880535E-06
                         pseudo_ZR91_FCD 1.718520E-06
                         pseudo_ZR92_FCD 2.626878E-06
                         pseudo_ZR94_FCD 2.662077E-06
                         pseudo_ZR96_FCD 4.288701E-07
                         pseudo_W182_FCD 2.014107E-06
                         pseudo_W183_FCD 1.087650E-06
                         pseudo_W184_FCD 2.337892E-06
                         pseudo_W186_FCD 2.160800E-06
                         pseudo_CU63_FCD 1.520930E-05
                         pseudo_CU65_FCD 6.778986E-06
                         pseudo_CO59_FCD 2.370990E-05
                         pseudo_CA40_FCD 3.379743E-05
                         pseudo_CA42_FCD 2.255696E-07
                         pseudo_CA43_FCD 4.706582E-08
                         pseudo_CA44_FCD 7.272563E-07
                         pseudo_CA46_FCD 1.394535E-09
                         pseudo_CA48_FCD 6.519498E-08
                         pseudo_NB93_FCD 7.519752E-06
                         pseudo_N14__FCD 4.969370E-05
                         pseudo_N15__FCD 1.835515E-07
                         pseudo_AL27_FCD 2.589280E-05
                         pseudo_TA181FCD 3.861021E-06
                         pseudo_B10__FCD 5.144462E-06
                         pseudo_B11__FCD 2.070704E-05'
    density_type = atomic
    composition_ids = ${mid_clad}
  []
  [IF_WRAPPER00]
    type = IsotopeComposition
    isotope_densities = 'pseudo_FE54_FWR 3.192503E-03
                         pseudo_FE56_FWR 5.011505E-02
                         pseudo_FE57_FWR 1.157401E-03
                         pseudo_FE58_FWR 1.540302E-04
                         pseudo_NI58_FWR 8.390808E-03
                         pseudo_NI60_FWR 3.232103E-03
                         pseudo_NI61_FWR 1.405101E-04
                         pseudo_NI62_FWR 4.479004E-04
                         pseudo_NI64_FWR 1.141301E-04
                         pseudo_CR50_FWR 5.655206E-04
                         pseudo_CR52_FWR 1.090501E-02
                         pseudo_CR53_FWR 1.236601E-03
                         pseudo_CR54_FWR 3.078103E-04
                         pseudo_MN55_FWR 1.274301E-03
                         pseudo_MO92_FWR 1.082801E-04
                         pseudo_MO94_FWR 6.749107E-05
                         pseudo_MO95_FWR 1.161601E-04
                         pseudo_MO96_FWR 1.217001E-04
                         pseudo_MO97_FWR 6.968007E-05
                         pseudo_MO98_FWR 1.760602E-04
                         pseudo_MO100FWR 7.026407E-05
                         pseudo_SI28_FWR 1.302801E-03
                         pseudo_SI29_FWR 6.615206E-05
                         pseudo_SI30_FWR 4.360804E-05
                         pseudo_C____FWR 3.497203E-04
                         pseudo_P31__FWR 6.780707E-05
                         pseudo_S32__FWR 2.073002E-05
                         pseudo_S33__FWR 1.659602E-07
                         pseudo_S34__FWR 9.367909E-07
                         pseudo_S36__FWR 4.367304E-09
                         pseudo_TI46_FWR 3.217603E-05
                         pseudo_TI47_FWR 2.901703E-05
                         pseudo_TI48_FWR 2.875203E-04
                         pseudo_TI49_FWR 2.110002E-05
                         pseudo_TI50_FWR 2.020302E-05
                         pseudo_V____FWR 2.748603E-05
                         pseudo_ZR90_FWR 7.896908E-06
                         pseudo_ZR91_FWR 1.722102E-06
                         pseudo_ZR92_FWR 2.632303E-06
                         pseudo_ZR94_FWR 2.667603E-06
                         pseudo_ZR96_FWR 4.297604E-07
                         pseudo_W182_FWR 2.018302E-06
                         pseudo_W183_FWR 1.089901E-06
                         pseudo_W184_FWR 2.342702E-06
                         pseudo_W186_FWR 2.165302E-06
                         pseudo_CU63_FWR 1.524101E-05
                         pseudo_CU65_FWR 6.793007E-06
                         pseudo_CO59_FWR 2.375902E-05
                         pseudo_CA40_FWR 3.386703E-05
                         pseudo_CA42_FWR 2.260402E-07
                         pseudo_CA43_FWR 4.716405E-08
                         pseudo_CA44_FWR 7.287707E-07
                         pseudo_CA46_FWR 1.397401E-09
                         pseudo_CA48_FWR 6.533006E-08
                         pseudo_NB93_FWR 7.535407E-06
                         pseudo_N14__FWR 4.979705E-05
                         pseudo_N15__FWR 1.839302E-07
                         pseudo_AL27_FWR 2.594703E-05
                         pseudo_TA181FWR 3.869004E-06
                         pseudo_B10__FWR 5.155105E-06
                         pseudo_B11__FWR 2.075002E-05'
    density_type = atomic
    composition_ids = ${mid_duct}
  []
  [IF_LEADCOOL00]
    type = IsotopeComposition
    isotope_densities = 'pseudo_PB204FCO ${fparse 4.232323E-04*coolantdensity_ref/10401.99540132}
                         pseudo_PB206FCO ${fparse 7.285612E-03*coolantdensity_ref/10401.99540132}
                         pseudo_PB207FCO ${fparse 6.680995E-03*coolantdensity_ref/10401.99540132}
                         pseudo_PB208FCO ${fparse 1.584046E-02*coolantdensity_ref/10401.99540132}'
    density_type = atomic
    composition_ids = ${mid_cool}
  []
[]

[Materials]
  [Neutronics_fuel_gap]
    type = MicroNeutronicsMaterial
    library_file = LFR9g_P5.xml
    library_name = ISOTXS-neutron
    library_id = 3
    block = 'HeliumHolePrism HeliumHole Fuel00 Fuel10 Fuel11 Fuel12 Fuel13 Fuel14 Fuel15'
    grid_variables = solid_temp
  []
  [Neutronics_clad_duct]
    type = MicroNeutronicsMaterial
    library_file = LFR9g_P5.xml
    library_name = ISOTXS-neutron
    library_id = 2
    block = 'Clad Duct LowerHeliumHolePrism LowerHeliumHole LowerClad LowerFuel00 LowerFuel10 LowerFuel11 LowerFuel12 LowerFuel13 LowerFuel14 LowerFuel15 UpperHeliumHolePrism UpperHeliumHole UpperClad UpperFuel00 UpperFuel10 UpperFuel11 UpperFuel12 UpperFuel13 UpperFuel14 UpperFuel15'
    grid_variables = solid_temp
  []
  [Neutronics_cool]
    type = MicroNeutronicsMaterial
    library_file = LFR9g_P5.xml
    library_name = ISOTXS-neutron
    library_id = 2
    block = 'Lead'
    grid_variables = nek_bulk_temp
    fluid_density  = fluid_density
    reference_fluid_density = ${coolantdensity_ref}
  []
[]

[MultiApps]
  [HeatConduction]
    type = FullSolveMultiApp
    # To be replaced by the Application block
    # app_type = CardinalApp
    # library_path = '/projects/neams_ad_fr/testing_dl/cardinal/lib'
    input_files = HC.i
    keep_solution_during_restore = true
    execute_on = 'timestep_end'
    cli_args = 'Materials/HeatConduct_Fuel/thermal_conductivity=${fuelconductance}'
  []
[]

[Transfers]
  [PowerDensity_to_HeatConduction]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = HeatConduction
    source_variable = power_density
    variable = heat_source
    from_postprocessors_to_be_preserved = power_density_pp
    to_postprocessors_to_be_preserved = heat_source_rod_duct
  []
  [solid_temp_from_HeatConduction]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = HeatConduction
    source_variable = solid_temp
    variable = solid_temp
  []
  [nek_bulk_temp_from_nek]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = HeatConduction
    source_variable = nek_bulk_temp
    variable = nek_bulk_temp
  []

  [nek_surf_temp_rod_from_HeatConduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = nek_surf_temp
    variable = nek_surf_temp
    from_boundaries = 'ROD_SIDE'
    to_boundaries = 'ROD_SIDE'
    from_multi_app = HeatConduction
    search_value_conflicts = false
  []
  [nek_surf_temp_rod_to_HeatConduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = nek_surf_temp
    variable = nek_surf_temp
    from_boundaries = 'ROD_SIDE'
    to_boundaries = 'ROD_SIDE'
    to_multi_app = HeatConduction
    search_value_conflicts = false
  []
  [nek_surf_temp_duct_from_HeatConduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = nek_surf_temp
    variable = nek_surf_temp
    from_boundaries = 'DUCT_INNERSIDE'
    to_boundaries = 'DUCT_INNERSIDE'
    from_multi_app = HeatConduction
    search_value_conflicts = false
  []
  [nek_surf_temp_duct_to_HeatConduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = nek_surf_temp
    variable = nek_surf_temp
    from_boundaries = 'DUCT_INNERSIDE'
    to_boundaries = 'DUCT_INNERSIDE'
    to_multi_app = HeatConduction
    search_value_conflicts = false
  []

  [nek_bulk_temp_pp]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = nek_bulk_temp_pp
    from_postprocessor = nek_bulk_temp_pp
    from_multi_app = HeatConduction
    reduction_type = maximum
  []
[]

[UserObjects]
  [power_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
  []
  [powerl_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Lead'
  []
  [powergap_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'HeliumHolePrism HeliumHole LowerHeliumHolePrism LowerHeliumHole UpperHeliumHolePrism UpperHeliumHole'
  []
  [powerclad_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Clad LowerClad UpperClad'
  []
  [powerduct_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
   num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Duct'
  []
  [powerif_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel00 LowerFuel00 UpperFuel00'
  []
  [powerof1_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel10 LowerFuel10 UpperFuel10'
  []
  [powerof2_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel11 LowerFuel11 UpperFuel11'
  []
  [powerof3_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel12 LowerFuel12 UpperFuel12'
  []
  [powerof4_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel13 LowerFuel13 UpperFuel13'
  []
  [powerof5_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel14 LowerFuel14 UpperFuel14'
  []
  [powerof6_axial_uo]
    type = LayeredAverage
    variable = power_density
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel15 LowerFuel15 UpperFuel15'
  []
  [fluidtemp_axial_uo]
    type = LayeredAverage
    variable = nek_bulk_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Lead'
  []
  [iftemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel00 LowerFuel00 UpperFuel00'
  []
  [of1temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel10 LowerFuel10 UpperFuel10'
  []
  [of2temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel11 LowerFuel11 UpperFuel11'
  []
  [of3temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel12 LowerFuel12 UpperFuel12'
  []
  [of4temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel13 LowerFuel13 UpperFuel13'
  []
  [of5temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel14 LowerFuel14 UpperFuel14'
  []
  [of6temp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Fuel15 LowerFuel15 UpperFuel15'
  []
  [cladtemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Clad LowerClad UpperClad'
  []
  [ducttemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_refl + num_layers_fuel + num_layers_refl}
    block = 'Duct'
  []
[]

[Postprocessors]
  [nek_bulk_temp_pp]
    type = Receiver
  []
  [fluid_density]
    type = ElementAverageValue
    variable = fluid_density
    block = 'Lead'
    execute_on = 'timestep_begin timestep_end'
  []
  [power_density_pp]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'HeliumHolePrism HeliumHole Clad Fuel00 Fuel10 Fuel11 Fuel12 Fuel13 Fuel14 Fuel15 Duct LowerHeliumHolePrism LowerHeliumHole LowerClad LowerFuel00 LowerFuel10 LowerFuel11 LowerFuel12 LowerFuel13 LowerFuel14 LowerFuel15 UpperHeliumHolePrism UpperHeliumHole UpperClad UpperFuel00 UpperFuel10 UpperFuel11 UpperFuel12 UpperFuel13 UpperFuel14 UpperFuel15'
    execute_on = 'transfer initial timestep_end'
  []
  [power_density_duct]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Duct'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_gap]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'HeliumHolePrism HeliumHole'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_clad]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Clad'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ifl]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel00'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl1]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel10'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl2]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel11'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl3]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel12'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl4]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel13'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl5]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel14'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_ofl6]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Fuel15'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [power_density_cool]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'Lead'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [nek_bulk_temp_max]
    type = ElementExtremeValue
    variable = nek_bulk_temp
    block = 'Lead'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [nek_bulk_temp_min]
    type = ElementExtremeValue
    variable = nek_bulk_temp
    value_type = min
    block = 'Lead'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'HeliumHolePrism HeliumHole'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'HeliumHolePrism HeliumHole'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [innerfuel_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel00'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [innerfuel_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel00'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel1_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel10'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel1_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel10'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel2_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel11'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel2_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel11'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel3_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel12'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel3_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel12'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel4_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel13'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel4_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel13'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel5_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel14'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel5_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel14'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel6_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel15'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [outerfuel6_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel15'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Clad'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Clad'
    execute_on = 'initial timestep_begin timestep_end'
  []
[]

[VectorPostprocessors]
  [power_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = power_axial_uo
  []
  [powerl_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerl_axial_uo
  []
  [powerduct_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerduct_axial_uo
  []
  [powergap_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powergap_axial_uo
  []
  [powerclad_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerclad_axial_uo
  []
  [powerif_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerif_axial_uo
  []
  [powerof1_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof1_axial_uo
  []
  [powerof2_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof2_axial_uo
  []
  [powerof3_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof3_axial_uo
  []
  [powerof4_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof4_axial_uo
  []
  [powerof5_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof5_axial_uo
  []
  [powerof6_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerof6_axial_uo
  []
  [fluidtemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = fluidtemp_axial_uo
  []
  [iftemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = iftemp_axial_uo
  []
  [of1temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of1temp_axial_uo
  []
  [of2temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of2temp_axial_uo
  []
  [of3temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of3temp_axial_uo
  []
  [of4temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of4temp_axial_uo
  []
  [of5temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of5temp_axial_uo
  []
  [of6temp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = of6temp_axial_uo
  []
  [cladtemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = cladtemp_axial_uo
  []
  [ducttemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = ducttemp_axial_uo
  []
[]

[Outputs]
  [console]
    type = Console
    outlier_variable_norms = false
  []
  [pgraph]
    type = PerfGraphOutput
    level = 2
  []
  csv = true
  exodus = true
  perf_graph = true
  execute_on = 'timestep_end'
[]
