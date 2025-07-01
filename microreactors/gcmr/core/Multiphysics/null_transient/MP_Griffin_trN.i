################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Null Transient                           ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

fuel_blocks = '400 4000 40000 401 4001 40001'
he_channel_blocks = '200 201'
mod_blocks = '100 101'
poison_blocks = '19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903'
ref_blocks = '1000 1003 250 600 602 1777 1773'
he_void_blocks = '300 301 604'
cd_poison_blocks = '603'
fecral_blocks = '103'
cr_blocks = '102'
small_parts_blocks = '${cd_poison_blocks} ${fecral_blocks} ${cr_blocks}'
monolith_blocks = '10'

non_he_channel_blocks = '${fuel_blocks} ${mod_blocks} ${poison_blocks} ${ref_blocks} ${he_void_blocks} ${small_parts_blocks} ${monolith_blocks}'

[Mesh]
  # If you do not have a presplit mesh already, you should generate it first:
  # 1. Uncomment all the mesh blocks
  # 2. Use the exodus file in the fmg block
  # 3. Comment the "parallel_type = distributed" line
  # 4. Use moose executable to presplit the mesh
  # Once you have the presplit mesh
  # 1. Comment all the mesh blocks except the fmg block
  # 2. Use the cpr file in the fmg block
  # 3. Uncomment the "parallel_type = distributed" line
  # The mesh used here is the same as the one used in the steady-state neutronics simulation.
  # If you already generated the presplit mesh you can symbolically link it here.
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/Griffin_mesh_in.e'
    # file = 'griffin-mesh.cpr'
  []
  [fmg_id]
    type = SubdomainExtraElementIDGenerator
    input = fmg
    subdomains = '10  100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
    extra_element_id_names = 'material_id '
    extra_element_ids = '803 802 802 810 806 807 807 700 700 701  701  702    702  807 807 811 811 809 807 805  805  764   764   764   764   764   764   764   764   764   764   754   754   754   754   754   754   754   754   754   754   809  809 811'
    #monolith  moderator  moderator_tri  Cr  FECRAL  coolant  coolant_tri  Fuel_in  Fuel_tri_in  Fuel_mid  Fuel_tri_mid  Fuel_out  Fuel_tri_out  Control_hole  Control_hole_tri  CD_Radial1  CD_Radial2  CD_poison  CD_coolant  reflector_quad  reflector_tri  BP0_1  BP0_2  BP0_3  BP0_4  BP0_5  BP0_tr_1  BP0_tr_2  BP0_tr_3  BP0_tr_4  BP0_tr_5  BP1_1  BP1_2  BP1_3  BP1_4  BP1_5  BP1_tr_1  BP1_tr_2  BP1_tr_3  BP1_tr_4  BP1_tr_5  Control_ref  Control_ref_tri  rad_ref
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 20
    ny = 20
    nz = 20
    xmin = -1.21
    xmax = 1.21
    ymin = -1.21
    ymax = 1.21
    zmin = 0.
    zmax = 2.4
  []
  [assign_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = fmg_id
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
  # parallel_type = DISTRIBUTED
[]

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 1e-8
  richardson_rel_tol = 1e-9

  richardson_max_its = 1000
  inner_solve_type = GMRes
  max_inner_its = 100

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  # cmfd_eigen_solver_type = newton
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1

  end_time = 500
  dt = 1
  dtmax = 10
  dtmin = 1e-3
[]

[Debug]
  check_boundary_coverage = false
  print_block_volume = false
  show_actions = false
[]

[AuxVariables]
  [Tf]
    # initial_condition = 725.0
    order = CONSTANT
    family = MONOMIAL
  []
  [nH]
    # initial_condition = 1.94
    order = CONSTANT
    family = MONOMIAL
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = transient
  G = 11
  VacuumBoundary = 'top_boundary bottom_boundary side'
  ReflectingBoundary = 'cut_surf'

  [SN]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST

    AQtype = Gauss-Chebyshev
    NPolar = 1
    NAzmthl = 3
    NA = 2
    n_delay_groups = 6

    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    hide_angular_flux = true
  []
[]

[GlobalParams]
  library_file = '../../ISOXML/GCMR_XS_2grid_detailed.xml'
  library_name = GCMR_XS_2grid_detailed
  isotopes = 'pseudo'
  densities = 1.0
  is_meter = true
  # power normalization
  plus = true
  dbgmat = false
  grid_names = 'Tfuel Hdens'
  grid_variables = 'Tf nH'
[]

[PowerDensity]
  power = 3.33e6
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10  100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = SN
    writing = false
    execute_on = initial
    folder = '../steady_state'
  []
[]

[Outputs]
  csv = true
  exodus = false
  perf_graph = true
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    input_files = MP_BISON_trN.i
    execute_on = 'initial timestep_end'
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    variable = power_density
    source_variable = power_density
    from_postprocessors_to_be_preserved = integrated_power
    to_postprocessors_to_be_preserved = power_density
    execute_on = 'timestep_end'
  []
  [from_sub_temp]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app  = bison
    variable = Tf
    source_variable = Tfuel
    to_blocks = ${non_he_channel_blocks}
  []
  [from_sub_temp_he]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
    to_blocks = ${he_channel_blocks}
  []
[]
