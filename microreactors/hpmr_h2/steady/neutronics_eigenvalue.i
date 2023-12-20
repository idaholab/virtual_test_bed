# ##################################################################################################################
# AUTHORS:            Stefano Terlizzi and Vincent Labouré
# DATE:               June 2023
# ORGANIZATION:       Idaho National Laboratory (INL), C-110
# CITATION:           S. Terlizzi and V. Labouré. (2023).
#                     "Asymptotic hydrogen redistribution analysis in yttrium-hydride-moderated heat-pipe-cooled
#                     microreactors using DireWolf", Annals of Nuclear Energy, Vol. 186, 109735.
# DESCRIPTION:        Main input file containing neutronic model for the SiMBA reactor.
# FUNDS:              This work was supported by INL Laboratory Directed Research&
#                     Development (LDRD) Program under U.S. Department of Energy (DOE) Idaho Operations Office,
#                     United States of America contract DE-AC07-05ID14517.
# ##################################################################################################################
# Block assignment
bison_fuel_blocks = '1 2'
moderator_blocks = '3 4'
monolith_blocks = '8 22' # For now fill the air gap with monolith
reflector_blocks = '10 11 13 14 15 16 17 18 19'
absorber_blocks = '12'
bison_mod_blocks = '${moderator_blocks} ${monolith_blocks}'
bison_ref_blocks = '${reflector_blocks} ${absorber_blocks}'
[Mesh]
  [main]
    type = FileMeshGenerator
    file = '../mesh/one_twelfth_empire_core_in.e'
  []
  [coarse_mesh]
    type = FileMeshGenerator
    file = '../mesh/one_twelfth_empire_core_CM_in.e'
  []
  [mesh]
    type = CoarseMeshExtraElementIDGenerator
    input = main
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
[]

[PowerDensity]
  power = 1.66666e5 # power: 2e6 / 12 = 1.66666e5 W/m
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[TransportSystems]
  equation_type = eigenvalue
  particle = neutron
  G = 11

  ReflectingBoundary = 'bottom topleft'
  VacuumBoundary = 'right back front'

  [sn]
    scheme = DFEM-SN
    n_delay_groups = 6
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 1 # use >=2 for final runs (4 sawtooth nodes sufficient)
    NAzmthl = 3 # use >=6 for final runs (4 sawtooth nodes sufficient)
    NA = 1
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    hide_angular_flux = true
  []
[]

[GlobalParams]
  library_file = '../cross_sections_library/empire_fmh_b_fine.xml'
  library_name = empire_fmh_b_fine
  densities = 1.0
  isotopes = 'pseudo'
  dbgmat = false
  grid_names = 'Tfuel Tmod Trefl ch'
  grid_variables = 'Tfuel Tmod Trefl ch'
  is_meter = true
[]

[AuxVariables]
  [Tfuel] # fuel temperature
    initial_condition = 1000
  []
  [Tmod] # moderator + monolith + HP temperature
    initial_condition = 1000
  []
  [Trefl] # radial reflector temperature
    initial_condition = 900
  []
  [ch]
    initial_condition = 1.8
  []
[]

[Materials]
  [fuel]
    type = CoupledFeedbackNeutronicsMaterial
    block = '1 2' # fuel pin with 1 cm outer radius, no gap
    material_id = 1001
    plus = true
  []
  [moderator]
    type = CoupledFeedbackNeutronicsMaterial
    block = '3 4 5' # moderator pin with 0.975 cm outer radius
    material_id = 1002
  []
  [monolith]
    type = CoupledFeedbackNeutronicsMaterial
    block = '8'
    material_id = 1003
  []
  [hpipe]
    type = CoupledFeedbackNeutronicsMaterial
    block = '6 7' # gap homogenized with HP
    material_id = 1004
  []
  [be]
    type = CoupledFeedbackNeutronicsMaterial
    block = '10 11 13 14 15'
    material_id = 1005
  []
  [b4c]
    type = CoupledFeedbackNeutronicsMaterial
    block = '12'
    material_id = 1006
  []
  [air]
    type = CoupledFeedbackNeutronicsMaterial
    block = '20 21 22'
    material_id = 1007
  []
  [axial_refl]
    type = CoupledFeedbackNeutronicsMaterial
    block = '16 17'
    material_id = 1008
  []
[]

[Executioner]
  type = SweepUpdate
  # verbose = true
  # debug_richardson = true
  # Richardson
  richardson_rel_tol = 1e-3
  richardson_max_its = 50
  inner_solve_type = GMRes
  max_inner_its = 2
  # CMFD solver
  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  diffusion_eigen_solver_type = newton
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1
  # Fixed point
  fixed_point_solve_outer = true
  fixed_point_algorithm = picard
  custom_pp = eigenvalue
  custom_rel_tol = 1e-50
  custom_abs_tol = 1e-5
  force_fixed_point_solve = true
  fixed_point_max_its = 6
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    input_files = thermal_ss.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true # to restart from the latest solve of the multiapp (for pseudo-transient)
  []
[]

[Transfers]
  [pdens_to_modules]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    source_variable = power_density
    variable = power_density
    from_blocks = '1 2'
    to_blocks = '${bison_fuel_blocks}'
  []
  [tfuel_from_modules]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = bison
    source_variable = Tsolid
    variable = Tfuel
    from_blocks = '${bison_fuel_blocks}'
  []
  [tmod_from_modules]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = bison
    source_variable = Tsolid
    variable = Tmod
    from_blocks = '${bison_mod_blocks}'
  []
  [trefl_from_modules]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = bison
    source_variable = Tsolid
    variable = Trefl
    from_blocks = '${bison_ref_blocks}'
  []
  [ch_from_modules]
    type = MultiAppGeneralFieldNearestNodeTransfer
    from_multi_app = bison
    source_variable = ch
    variable = ch
  []
[]

[Postprocessors]
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tfuel
    block = '1 2'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = Tfuel
    block = '1 2'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = Tfuel
    value_type = min
    block = '1 2'
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = Tmod
    block = '3 4'
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = Tmod
    block = '3 4'
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = Tmod
    value_type = min
    block = '3 4'
  []
  [fuel_volume]
    type = VolumePostprocessor
    block = '1 2'
  []
  [ch_avg]
    type = ElementAverageValue
    variable = ch
    block = '3 4'
  []
  [ch_max]
    type = ElementExtremeValue
    variable = ch
    block = '3 4'
  []
  [ch_min]
    type = ElementExtremeValue
    variable = ch
    value_type = min
    block = '3 4'
  []
[]

[Outputs]
  csv = true
  # nemesis = true
  file_base = 'output/neutronics_eigenvalue'
  [console]
    type = Console
    outlier_variable_norms = false
  []
  [pgraph]
    type = PerfGraphOutput
    level = 2
  []
[]
