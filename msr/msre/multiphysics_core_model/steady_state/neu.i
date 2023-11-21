# ==============================================================================
# Model description
# Molten Salt Reactor Experiment (MSRE) Model
# Core Neutronics Model
# Integrates:
# - Doppler-Temperature feedback with interpolation from tabulated cross sections
# - Density-Temperature feedback with field functions for density
# MSRE: reference plant design based on 5MW of MSRE Experiment.
# ==============================================================================
# Author(s): Dr. Mauricio Tano, Dr. Mustafa K. Jaradat, Dr. Samuel Walker
# ==============================================================================
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
total_power = 5.0E+6 # Total reactor Power (W)
T_Salt_initial = 923.0
Salt_Density_initial = 2263.0
# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  library_file = '../mgxs/xs.xml'
  library_name = 'MSRE-Simplified'
  is_meter = true
[]
# ==============================================================================
# TRANSPORT SYSTEM
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 16
  ReflectingBoundary = 'left'
  VacuumBoundary = 'bottom loop_boundary right top top_core_barrel'
  [transport]
    scheme = CFEM-Diffusion
    family = LAGRANGE
    order = FIRST
    n_delay_groups = 6

    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true

    external_dnp_variable = 'dnp'
    fission_source_aux = true
  []
[]
# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/mesh_in.e'
  []
[]
# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [vel_x]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [vel_y]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [T_salt]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = ${T_Salt_initial}
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [T_solid]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = ${T_Salt_initial}
    block = 'core core_barrel'
  []
  [fission_rate]
    family = MONOMIAL
    order = CONSTANT
  []
  [Absorption_rate]
    family = MONOMIAL
    order = CONSTANT
  []
  [Leakage_rate]
    family = MONOMIAL
    order = CONSTANT
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 0.000
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
  []

  [ad_U235]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 9.692763E-05
  []
  [ad_U238]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.967924E-04
  []
  [ad_Be9]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 9.496943E-03
  []
  [ad_Li7]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2.121311E-02
  []
  [ad_F9]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 4.790899E-02
  []
  [ad_Zr90]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 8.395505E-04
  []
  [ad_Zr91]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 1.830855E-04
  []
  [ad_Zr92]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2.798495E-04
  []
  [ad_Zr94]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2.836027E-04
  []
  [ad_Zr96]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 4.568967E-05
  []
  [ad_C12]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 7.247622E-02
    block = 'core core_barrel'
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'initial timestep_begin final'
  []
  [update_ad_f_U235]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_U235
    args = 'T_salt'
    function = '9.692763E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_U238]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_U238
    args = 'T_salt'
    function = '1.967924E-04 *(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Be9]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Be9
    args = 'T_salt'
    function = '9.496943E-03*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Li7]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Li7
    args = 'T_salt'
    function = '2.121311E-02 *(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_F9]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_F9
    args = 'T_salt'
    function = '4.790899E-02*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Zr90]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Zr90
    args = 'T_salt'
    function = '8.395505E-04*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Zr91]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Zr91
    args = 'T_salt'
    function = '1.830855E-04*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Zr92]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Zr92
    args = 'T_salt'
    function = '2.798495E-04*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Zr94]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Zr94
    args = 'T_salt'
    function = '2.836027E-04*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_f_Zr96]
    type = ParsedAux
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
    variable = ad_Zr96
    args = 'T_salt'
    function = '4.568967E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_U235]
    type = ParsedAux
    block = 'core'
    variable = ad_U235
    args = 'T_salt'
    function = '2.159856E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_U238]
    type = ParsedAux
    block = 'core'
    variable = ad_U238
    args = 'T_salt'
    function = '4.385162E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Be9]
    type = ParsedAux
    block = 'core'
    variable = ad_Be9
    args = 'T_salt'
    function = '2.116221E-03*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Li7]
    type = ParsedAux
    block = 'core'
    variable = ad_Li7
    args = 'T_salt'
    function = '4.726958E-03*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_F9]
    type = ParsedAux
    block = 'core'
    variable = ad_F9
    args = 'T_salt'
    function = '1.067565E-02*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Zr90]
    type = ParsedAux
    block = 'core'
    variable = ad_Zr90
    args = 'T_salt'
    function = '1.870786E-04*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Zr91]
    type = ParsedAux
    block = 'core'
    variable = ad_Zr91
    args = 'T_salt'
    function = '4.079728E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Zr92]
    type = ParsedAux
    block = 'core'
    variable = ad_Zr92
    args = 'T_salt'
    function = '6.235937E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_c_Zr94]
    type = ParsedAux
    block = 'core'
    variable = ad_Zr94
    args = 'T_salt'
    function = '6.319571E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
  [update_ad_Zr96]
    type = ParsedAux
    block = 'core'
    variable = ad_Zr96
    args = 'T_salt'
    function = '1.018111E-05*(1.0-0.4798*(T_salt-${T_Salt_initial})/${Salt_Density_initial})'
    execute_on = 'INITIAL timestep_end'
  []
[]
# ==============================================================================
# USER OBJECTS (Needed for Restart)
# ==============================================================================
[UserObjects]
  [transport_solution_s1]
    type = TransportSolutionVectorFile
    transport_system = transport
    writing = true
    execute_on = 'FINAL'
  []
  [auxvar_solution_s1]
    type = SolutionVectorFile
    var = 'vel_x  vel_y  T_salt  T_solid  c1  c2  c3  c4  c5  c6
           ad_C12  ad_U235 ad_U238 ad_Be9  ad_Li7  ad_F9
           ad_Zr90 ad_Zr91 ad_Zr92 ad_Zr94 ad_Zr96'
    writing = true
    execute_on = 'FINAL'
  []
[]
# ==============================================================================
# MATERIALS
# ==============================================================================
[PowerDensity]
  power = '${fparse total_power}'
  power_density_variable = power_density
  integrated_power_postprocessor = total_power
  family = L2_LAGRANGE
  order = FIRST
[]

[Materials]
  [activeCore]
    type = CoupledFeedbackNeutronicsMaterial
    grid_names = ' Tfuel'
    grid_variables = ' T_salt'
    plus = true
    isotopes = ' C12   U235   U238    BE9      LI7    F19
                ZR90   ZR91   ZR92   ZR94   ZR96'
    densities = 'ad_C12   ad_U235  ad_U238  ad_Be9   ad_Li7   ad_F9
                 ad_Zr90  ad_Zr91  ad_Zr92  ad_Zr94  ad_Zr96'
    material_id = 1
    block = 'core'
  []
  [flow_loop]
    type = CoupledFeedbackNeutronicsMaterial
    grid_names = ' Tfuel '
    grid_variables = ' T_salt'
    plus = true
    isotopes = 'U235   U238    BE9      LI7    F19
                ZR90   ZR91   ZR92   ZR94   ZR96'
    densities = 'ad_U235  ad_U238  ad_Be9   ad_Li7   ad_F9
                 ad_Zr90  ad_Zr91  ad_Zr92  ad_Zr94  ad_Zr96'
    material_id = 2
    block = 'lower_plenum upper_plenum down_comer riser pump elbow'
  []
  [core_barrel]
    type = CoupledFeedbackNeutronicsMaterial
    grid_names = ' Tfuel '
    grid_variables = ' T_solid'
    plus = true
    isotopes = 'C12'
    densities = 'ad_C12'
    material_id = 1
    block = 'core_barrel'
  []
[]
# ==============================================================================
# POSTPROCESSORS
# ==============================================================================
[Postprocessors]
  [Fuel_max_Temp]
    type = ElementExtremeValue
    variable = T_salt
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Fuel_avg_Temp]
    type = ElementAverageValue
    variable = T_salt
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Fuel_core_max_Temp]
    type = ElementExtremeValue
    variable = T_salt
    block = 'core'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Fuel_core_avg_Temp]
    type = ElementAverageValue
    variable = T_salt
    block = 'core'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Mod_max_Temp]
    type = ElementExtremeValue
    variable = T_solid
    block = 'core core_barrel'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Mod_avg_Temp]
    type = ElementAverageValue
    variable = T_solid
    block = 'core core_barrel'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [nufission_RR]
    type = FluxRxnIntegral
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    cross_section = nu_sigma_fission
    coupled_flux_groups = ' sflux_g0    sflux_g1    sflux_g2    sflux_g3 sflux_g4    sflux_g5    sflux_g6    sflux_g7 sflux_g8    sflux_g9    sflux_g10   sflux_g11 sflux_g12   sflux_g13   sflux_g14   sflux_g15'
    execute_on = 'transfer timestep_end'
  []
  [absorption_RR]
    type = FluxRxnIntegral
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    cross_section = sigma_absorption
    coupled_flux_groups = ' sflux_g0    sflux_g1    sflux_g2    sflux_g3 sflux_g4    sflux_g5    sflux_g6    sflux_g7 sflux_g8    sflux_g9    sflux_g10   sflux_g11 sflux_g12   sflux_g13   sflux_g14   sflux_g15'
    execute_on = 'transfer timestep_end'
  []
  [fission_RR]
    type = FluxRxnIntegral
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    cross_section = sigma_fission
    coupled_flux_groups = ' sflux_g0    sflux_g1    sflux_g2    sflux_g3 sflux_g4    sflux_g5    sflux_g6    sflux_g7 sflux_g8    sflux_g9    sflux_g10   sflux_g11 sflux_g12   sflux_g13   sflux_g14   sflux_g15'
    execute_on = 'transfer timestep_end'
  []
  [ngamma_RR]
    type = FluxRxnIntegral
    block = 'core lower_plenum upper_plenum down_comer riser pump elbow'
    cross_section = sigma_ngamma
    coupled_flux_groups = ' sflux_g0    sflux_g1    sflux_g2    sflux_g3 sflux_g4    sflux_g5    sflux_g6    sflux_g7 sflux_g8    sflux_g9    sflux_g10   sflux_g11 sflux_g12   sflux_g13   sflux_g14   sflux_g15'
    execute_on = 'transfer timestep_end'
  []
  [Leakage]
    type = PartialSurfaceCurrent
    boundary = 'right bottom loop_boundary pump_outlet downcomer_inlet top_core_barrel'
    transport_system = transport
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 50'
  l_max_its = 5000
  nl_abs_tol = 1e-10

  free_power_iterations = 4 # important to obtain fundamental mode eigenvalue

  # MultiApp
  fixed_point_min_its = 2
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-6
  fixed_point_abs_tol = 1e-6

[]

# ==============================================================================
# MULTIAPPS AND TRANSFERS
# ==============================================================================
[MultiApps]
  [flow_dnp]
    type = FullSolveMultiApp
    input_files = 'th.i'
    execute_on = 'timestep_end'
    max_procs_per_app = 48
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppShapeEvaluationTransfer
    to_multi_app = flow_dnp
    source_variable = power_density
    variable = power_density
    execute_on = 'timestep_end'
  []
  [fission_source]
    type = MultiAppShapeEvaluationTransfer
    to_multi_app = flow_dnp
    source_variable = fission_source
    variable = fission_source
    execute_on = 'timestep_end'
  []
  [c1]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c1'
    variable = 'c1'
    execute_on = 'timestep_end'
  []
  [c2]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c2'
    variable = 'c2'
    execute_on = 'timestep_end'
  []
  [c3]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c3'
    variable = 'c3'
    execute_on = 'timestep_end'
  []
  [c4]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c4'
    variable = 'c4'
    execute_on = 'timestep_end'
  []
  [c5]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c5'
    variable = 'c5'
    execute_on = 'timestep_end'
  []
  [c6]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'c6'
    variable = 'c6'
    execute_on = 'timestep_end'
  []
  [T_salt]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'T_fluid'
    variable = 'T_salt'
    execute_on = 'timestep_end'
  []
  [T_graph]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'T_solid'
    variable = 'T_solid'
    execute_on = 'timestep_end'
  []
  [vel_x]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'vel_x'
    variable = 'vel_x'
    execute_on = 'timestep_end'
  []
  [vel_y]
    type = MultiAppShapeEvaluationTransfer
    from_multi_app = flow_dnp
    source_variable = 'vel_y'
    variable = 'vel_y'
    execute_on = 'timestep_end'
  []
[]

[Debug]
  show_var_residual_norms = false
[]
# ==============================================================================
# OUTPUTS
# ==============================================================================
[Outputs]
  file_base = msre_neutronics_ss_s2_out
  exodus = true
  csv = true
  perf_graph = true
  execute_on = 'INITIAL FINAL TIMESTEP_END'
[]
