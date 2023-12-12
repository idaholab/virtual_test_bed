################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor TRISO Failure Model                                 ##
## Assembly Model for Calculating TRISO Operating Conditions                  ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
################################################################################

mesh_subdomains = '1 2 3 4 5 6 7 8 101
                  102 103 104 105 106 107 108 109
                  110 111 112 113 114 115 116 117
                  118 119 120 121 122 123 124 125
                  126 127 128 129 130 131 132 201
                  202 203 204 205 206 207 208 209
                  210 211 212 213 214 215 216 217
                  218 219 220 221 222 223 224 225
                  226 227 228 229 230 231 232 401
                  402 403 404 405 406 407 408 409
                  410 411 412 413 414 415 416 417
                  418 419 420 421 422 423 424 425
                  426 427 428 429 430 431 432 501
                  502 503 504 505 506 507 508 509
                  510 511 512 513 514 515 516 517
                  518 519 520 521 522 523 524 525
                  526 527 528 529 530 531 532 301
                  302 303 304 305 306 307 308 309
                  310 311 312 313 314 315 316 317
                  318 319 320 321 322 323 324 325
                  326 327 328 329 330 331 332 333
                  334 335 336 601 602 603 604 605
                  606 607 608 609 610 611 612 613
                  614 615 616 617 618 619 620 621
                  622 623 624 625 626 627 628 629
                  630 631 632 633 634 635 636'

fuel_blocks = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08
               fuel_09 fuel_10 fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16
               fuel_17 fuel_18 fuel_19 fuel_20 fuel_21 fuel_22 fuel_23 fuel_24
               fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 fuel_31 fuel_32'

[Mesh]
  [loader]
    type = FileMeshGenerator
    file = ../mesh/3D_unit_cell_FY21_simple_YAN_40sections_5cm_axial_dist.e
  []
  [id]
    type = SubdomainExtraElementIDGenerator
    input = loader
    extra_element_id_names = 'material_id equivalence_id'
    subdomains = ${mesh_subdomains}
    extra_element_ids = '  805 805 805 805 805 805 805 805 801
                  801 801 801 801 801 801 801 801
                  801 801 801 801 801 801 801 801
                  801 801 801 801 801 801 801 801
                  801 801 801 801 801 801 801 802
                  802 802 802 802 802 802 802 802
                  802 802 802 802 802 802 802 802
                  802 802 802 802 802 802 802 802
                  802 802 802 802 802 802 802 803
                  803 803 803 803 803 803 803 803
                  803 803 803 803 803 803 803 803
                  803 803 803 803 803 803 803 803
                  803 803 803 803 803 803 803 816
                  816 816 816 816 816 816 816 816
                  816 816 816 816 816 816 816 816
                  816 816 816 816 816 816 816 816
                  816 816 816 816 816 816 816 815
                  815 815 815 815 815 815 815 815
                  815 815 815 815 815 815 815 815
                  815 815 815 815 815 815 815 815
                  815 815 815 815 815 815 815 815
                  815 815 815 817 817 817 817 817
                  817 817 817 817 817 817 817 817
                  817 817 817 817 817 817 817 817
                  817 817 817 817 817 817 817 817
                  817 817 817 817 817 817 817;
                  1 2 3 4 5 6 7 8 9
                  10 11 12 13 14 15 16 17
                  18 19 20 21 22 23 24 25
                  26 27 28 29 30 31 32 33
                  34 35 36 37 38 39 40 41
                  42 43 44 45 46 47 48 49
                  50 51 52 53 54 55 56 57
                  58 59 60 61 62 63 64 65
                  66 67 68 69 70 71 72 73
                  74 75 76 77 78 79 80 81
                  82 83 84 85 86 87 88 89
                  90 91 92 93 94 95 96 97
                  98 99 100 101 102 103 104 105
                  106 107 108 109 110 111 112 113
                  114 115 116 117 118 119 120 121
                  122 123 124 125 126 127 128 129
                  130 131 132 133 134 135 136 137
                  138 139 140 141 142 143 144 145
                  146 147 148 149 150 151 152 153
                  154 155 156 157 158 159 160 161
                  162 163 164 165 166 167 168 169
                  170 171 172 173 174 175 176 177
                  178 179 180 181 182 183 184 185
                  186 187 188 189 190 191 192 193
                  194 195 196 197 198 199 200 201
                  202 203 204 205 206 207 208'
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 6
    ny = 6
    nz = 20
    xmin = -0.23
    xmax = 0.23
    ymin = -0.23
    ymax = 0.23
    zmin = -0.05
    zmax = 1.95
  []
  [assign_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = id
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
[]

[AuxVariables]
  [Tf]
    initial_condition = 800
    order = CONSTANT
    family = MONOMIAL
  []

  [Tm]
    initial_condition = 800
    order = CONSTANT
    family = MONOMIAL
  []
  [layered_integral]
    order = CONSTANT
    family = MONOMIAL
    block = ${fuel_blocks}
  []
[]

[AuxKernels]
  [axial_power]
    type = SpatialUserObjectAux
    variable = layered_integral
    user_object = layered_integral
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 11
  VacuumBoundary = '1 8'
  ReflectingBoundary = '2'

  [SN]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST

    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 2
    n_delay_groups = 6

    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    hide_angular_flux = true
  []
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-8
  richardson_rel_tol = 1e-8
  richardson_value = eigenvalue

  richardson_max_its = 1000
  inner_solve_type = GMRes
  max_inner_its = 20

  fixed_point_max_its = 1
  custom_pp = integrated_power
  custom_rel_tol = 1e-6
  force_fixed_point_solve = true

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  diffusion_eigen_solver_type = newton
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1
[]

[Materials]
  [all]
    # type=MixedMatIDNeutronicsMaterial
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = ${mesh_subdomains}
    library_file = '../ISOXML/unitcell_nogap_hom_G11_tr_no_900K.xml'
    library_name = 'unitcell_nogap_hom_G11_tr_no_900K'
    isotopes = 'pseudo'
    densities = '1.0'
    grid_names = 'Tfuel Tmod'
    grid_variables = 'Tf Tm'
    plus = 1
    is_meter = true
  []
[]

[PowerDensity]
  power = 1.8e3
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[MultiApps]
  [bison_diff]
    type = FullSolveMultiApp
    app_type = BisonApp
    positions = '0.0 0.0 0.0' #bottom of the heat pipe
    input_files = 'MP_ss_bison.i'
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppProjectionTransfer
    from_multi_app = bison_diff
    variable = power_density
    source_variable = power_density
    execute_on = 'initial timestep_end'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
  []
  [from_sub_tempf]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_diff
    variable = Tf
    source_variable = Tfuel
    execute_on = 'initial timestep_end'
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
  [from_sub_tempm]
    type = MultiAppGeometricInterpolationTransfer
    from_multiapp = bison_diff
    variable = Tm
    source_variable = Tmod
    execute_on = 'initial timestep_end'
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
  [from_bison_hptemp]
    type = MultiAppPostprocessorTransfer
    from_multi_app = bison_diff
    from_postprocessor = heatpipe_surface_temp_avg
    to_postprocessor = hp_temp
    execute_on = 'initial timestep_end'
    reduction_type = average
  []
[]

[UserObjects]
  [layered_integral]
    type = LayeredIntegral
    direction = z
    num_layers = 100
    variable = power_density
    block = ${fuel_blocks}
  []
  [ss]
    type = TransportSolutionVectorFile
    transport_system = SN
    writing = true
    execute_on = final
  []
[]

[Postprocessors]
  [scaled_power_avg]
    type = ElementAverageValue
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [hp_temp]
    type = Receiver
  []
  [hydro_stress]
    type = Receiver
  []
[]

[Debug]
  check_boundary_coverage = false
  print_block_volume = false
  show_actions = false
[]

[Outputs]
  csv = true
  perf_graph = true
  [console]
    type = Console
    outlier_variable_norms = false
  []
[]
