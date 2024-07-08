################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Steady State                                                        ##
## Griffin neutronics only input file                                         ##
## DFEM-SN (3, 5) NA = 3 with CMFD acceleration                               ##
################################################################################

[Mesh]
 [fmg]
  type = FileMeshGenerator
  file = '../../MESH/Griffin_mesh.e'
 []
 [id]
   type=SubdomainExtraElementIDGenerator
   input = fmg
   subdomains = '1 2 3 4 5 6
                 64 71 72 73
                 8 9 10 11
                 12 1212
                 13 14 15 16 17 18 19
                 20 21 22 23 24
                 2081 2091 2101 2111 2121 2131 2141
                 2082 2092 2102 2112 2122 2132 2142
                 3081 3091 3101 3111 3121 3131 3141
                 3082 3092 3102 3112 3122 3132 3142
                 4081 4091 4101 4111 4121 4131 4141
                 4082 4092 4102 4112 4122 4132 4142'

   extra_element_id_names = 'material_id'
   extra_element_ids ='99 17 11 15 70 18
                       99 6 6 60
                       8 5 10 40
                       51 52
                       4 20 18 40 50 14 13
                       6 7 12 11 9
                       300  310  320  330  340  350  360
                       301  311  321  331  341  351  361
                       202  212  222  232  242  252  262
                       203  213  223  233  243  253  263
                       104  114  124  134  144  154  164
                       105  115  125  135  145  155  165'
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim= 3
    nx = 20   # about 2 cm may need to adjust
    ny = 20   # about 2 cm may need to adjust
    nz = 40   # about 5 cm may need to adjust to test convergence or performance
    xmin = -2
    xmax =  52
    ymin = -2
    ymax =  52
    zmin = -1
    zmax =  135
  []
   [assign_coarse_id]
     type = CoarseMeshExtraElementIDGenerator
     input = id
     coarse_mesh = coarse_mesh
     extra_element_id_name = coarse_element_id
   []
   # parallel_type = distributed  # transfer dependent user object / interpolation transfer
[]

[AuxVariables]
  [Tf]
    initial_condition = 300
    order = CONSTANT
    family = MONOMIAL
  []

  [Ts]
      initial_condition = 300
      order = CONSTANT
      family = MONOMIAL
  []
[]
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G =22
  VacuumBoundary = '9527 9528 9529'
  ReflectingBoundary = '1982 1983'


  [sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 3
    NAzmthl = 5

    NA = 3
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering  = true
    n_delay_groups = 6
  []
[]

[PowerDensity]
  power = 1275.0
  power_density_variable = power_density
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-6
  richardson_rel_tol = 1e-20

  richardson_max_its = 1000
  inner_solve_type = GMRes # SI #GMRes

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  max_diffusion_coefficient = 10.0 # might need to be smaller  0.05
  diffusion_eigen_solver_type = newton
  diffusion_prec_type = lu
  prolongation_type = multiplicative

[]

[Materials]
 [all]
  type=CoupledFeedbackMatIDNeutronicsMaterial
  block='1 2 3 4 5 6
         64 71 72 73
         8 9 10 11
         12 1212
         13 14 15 16 17 18 19
         20 21 22 23 24
         2081 2091 2101 2111 2121 2131 2141
         2082 2092 2102 2112 2122 2132 2142
         3081 3091 3101 3111 3121 3131 3141
         3082 3092 3102 3112 3122 3132 3142
         4081 4091 4101 4111 4121 4131 4141
         4082 4092 4102 4112 4122 4132 4142'
  library_file ='../Serp_hbrid_reflector_updated.xml'
  library_name ='krusty_serpent_ANL_endf70_g22'
  isotopes = 'pseudo'
  densities = '1.0'
  grid_names = 'Tfuel Tsteel'
  grid_variables = 'Tf Ts'
  plus = 1
  is_meter = true
  dbgmat = false
 []
[]


[Outputs]
  csv = true
  exodus=true
  [pgraph]
    type = PerfGraphOutput
    level = 2
  []
[]
