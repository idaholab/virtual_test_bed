# ==============================================================================
# ABTR Equivalent-full core cross section generation
# Application: Griffin / MCC3
# POC: Shikhar Kumar (kumars at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[MCC3CrossSection]
  remove_pwfiles = false
  remove_inputs = true
  remove_outputs = true
  remove_xmlfiles = true
  # This path is selected for VTB continuous integration
  # Adapt this path to your installation of griffin_data
  griffin_data = '../../apps/griffin/griffin_data'
  endfb_version = 'ENDF/B-VII.0'
  library_pointwise = './'

  xml_macro_cross_section = true
  xml_filename = 'mcc3xs.xml'
  generate_core_input = true

  rz_calculation = true
  rz_spectrum_pn_order = 3
  group_structure = 'ANL33'
  rz_group_structure = 'ANL1041'

  map_het_grid_name = 'fuel1 Tfuel
                       fuel2 Tfuel
                       fuel3 Tfuel
                 control_b4c Tcool
                         ht9 Tcool
                      sodium Tcool
            radial_reflector Tcool
            radial_shielding Tcool
             lower_reflector Tcool
             upper_na_plenum Tcool
            upper_gas_plenum Tcool
               control_empty Tcool'
  map_het_grid_ref_value = 'Tfuel 900
                            Tcool 700'
  map_het_grid_values = 'Tfuel 900
                         Tcool 700'

  rz_meshgenerator = rz_core
  het_cross_sections = 'fuel1 fuel2 fuel3 control_b4c'
  max_het_mesh_size = 0.5
  target_core = full_hom
[]

[Compositions]
  [fuel1]
    type = IsotopeComposition
    isotope_densities = 'ZR90 3.91909E-03
                         ZR91 8.45242E-04
                         ZR92 1.27794E-03
                         ZR94 1.26746E-03
                         ZR96 1.99934E-04
                         U235 3.33146E-05
                         U236 2.65386E-06
                         U238 2.15143E-02
                         NP237 2.37839E-05
                         PU238 1.01970E-05
                         PU239 3.68541E-03
                         PU240 4.94293E-04
                         PU241 5.33116E-05
                         PU242 2.35963E-05
                         AM241 2.46886E-05
                         AM242M 6.47017E-07
                         AM243 5.15491E-06
                         CM244 1.28342E-06'
    density_type = atomic
    composition_ids = 1
  []
  [fuel2]
    type = IsotopeComposition
    isotope_densities = 'ZR90 3.91839E-03
                         ZR91 8.45090E-04
                         ZR92 1.27771E-03
                         ZR94 1.26723E-03
                         ZR96 1.99898E-04
                         U235 3.16338E-05
                         U236 2.51998E-06
                         U238 2.04290E-02
                         NP237 2.25841E-05
                         PU238 1.27905E-05
                         PU239 4.62263E-03
                         PU240 6.20033E-04
                         PU241 6.68729E-05
                         PU242 2.95978E-05
                         AM241 2.34432E-05
                         AM242M 6.14392E-07
                         AM243 4.89465E-06
                         CM244 1.21867E-06'
    density_type = atomic
    composition_ids = 2
  []
  [fuel3]
    type = IsotopeComposition
    isotope_densities = 'ZR90 3.91871E-03
                         ZR91 8.45159E-04
                         ZR92 1.27782E-03
                         ZR94 1.26734E-03
                         ZR96 1.99914E-04
                         U235 3.24342E-05
                         U236 2.58374E-06
                         U238 2.09457E-02
                         NP237 2.31554E-05
                         PU238 1.15555E-05
                         PU239 4.17640E-03
                         PU240 5.60169E-04
                         PU241 6.04162E-05
                         PU242 2.67400E-05
                         AM241 2.40363E-05
                         AM242M 6.29931E-07
                         AM243 5.01855E-06
                         CM244 1.24951E-06'
    density_type = atomic
    composition_ids = 3
  []
  [control_b4c]
    type = IsotopeComposition
    isotope_densities = 'B10 1.86773e-02
                         B11 7.47092e-02
                         C0 2.33466e-02'
    density_type = atomic
    composition_ids = 4
  []
  [shield_b4c]
    type = IsotopeComposition
    isotope_densities = 'B10 1.77984e-02
                         B11 7.11935e-02
                          C0 2.22479e-02'
    density_type = atomic
  []
  [ht9]
    type = IsotopeComposition
    isotope_densities = 'CR50 4.57952E-04
                         CR52 8.83105E-03
                         CR53 1.00138E-03
                         CR54 2.49227E-04
                         MN55 4.66898E-04
                         FE54 4.14335E-03
                         FE56 6.50402E-02
                         FE57 1.50207E-03
                         FE58 1.99862E-04
                         NI58 2.97516E-04
                         NI60 1.14633E-04
                         NI61 4.96964E-06
                         NI62 1.59028E-05
                         NI64 4.05854E-06
                         MO92 7.39648E-05
                         MO94 4.60520E-05
                         MO95 7.93486E-05
                         MO96 8.30758E-05
                         MO97 4.76257E-05
                         MO98 1.20265E-04
                         MO100 4.79570E-05'
    density_type = atomic
    composition_ids = 5
  []
  [sodium]
    type = IsotopeComposition
    isotope_densities = 'NA23 2.22656e-02'
    density_type = atomic
    composition_ids = 6
  []
  [void]
    type = IsotopeComposition
    isotope_densities = 'HE4 1.0e-10'
    density_type = atomic
  []
  [radial_reflector]
    type = MixedComposition
    volume_fraction = 'sodium 0.1573 ht9 0.8427'
    composition_ids = 7
  []
  [radial_shielding]
    type = MixedComposition
    volume_fraction = 'sodium 0.1730 ht9 0.3041 shield_b4c 0.5229'
    composition_ids = 8
  []
  [lower_reflector]
    type = MixedComposition
    volume_fraction = 'sodium 0.3208 ht9 0.6792'
    composition_ids = 9
  []
  [upper_na_plenum]
    type = MixedComposition
    volume_fraction = 'sodium 0.7682 ht9 0.2318'
    composition_ids = 10
  []
  [upper_gas_plenum]
    type = MixedComposition
    volume_fraction = 'sodium 0.3208 ht9 0.2318 void 0.4474'
    composition_ids = 11
  []
  [control_empty]
    type = MixedComposition
    volume_fraction = 'sodium 0.9217 ht9 0.0783'
    composition_ids = 12
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 1041
  ReflectingBoundary = 'left'
  VacuumBoundary = 'right top bottom'
  [dfem_sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 3
    NAzmthl = 7
    NA = 3
    using_averaged_xs = true
    update_averaged_xs_on = INITIAL
  []
[]

[Executioner]
  type = SweepUpdate
  richardson_rel_tol = 1e-6
  richardson_abs_tol = 1e-6
  richardson_max_its = 1000
  richardson_value = eigenvalue
  inner_solve_type = GMRes
  max_inner_its = 2
  cmfd_acceleration = true
  truncate_scat_order = 0
  coarse_element_id = coarse_elem_id
  uniform_group_collapsing = 20
  prolongation_type = multiplicative
[]

[Outputs]
  [console]
    type = Console
    outlier_variable_norms = false
  []
[]
