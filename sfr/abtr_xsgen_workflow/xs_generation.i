# ==============================================================================
# ABTR Equivalent-full core cross section generation
# Application: Griffin / MCC3
# POC: Shikhar Kumar (kumars at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

#!include xs_generation_mesh.i
fuel_pin_pitch = 0.908
fuel_clad_r_i = 0.348
fuel_clad_r_o = 0.40333 # Adjusts for wire wrap diameter
control_pin_pitch = 1.243
control_clad_r_i = 0.485
control_clad_r_o = 0.55904 # Adjusts for wire wrap diameter
control_duct_pitch_inner = 12.198
control_duct_pitch_outer = 12.798
duct_pitch_inner = 13.598
duct_pitch_outer = 14.198
assembly_pitch = 14.598

z_active_core_lower = 60
z_active_core_upper = 140
z_sodium_gp_upper = 160
z_gp_upper = 260

dz_active_core_lower = '${fparse z_active_core_lower - 0}'
dz_active_core_upper = '${fparse z_active_core_upper - z_active_core_lower}'
dz_sodium_gp_upper = '${fparse z_sodium_gp_upper - z_active_core_upper}'
dz_gp_upper = '${fparse z_gp_upper - z_sodium_gp_upper}'

max_axial_mesh_size = 8
naxial_active_core_lower = '${fparse ceil(dz_active_core_lower / max_axial_mesh_size)}'
naxial_active_core_upper = '${fparse ceil(dz_active_core_upper / max_axial_mesh_size)}'
naxial_sodium_gp_upper = '${fparse ceil(dz_sodium_gp_upper / max_axial_mesh_size)}'
naxial_gp_upper = '${fparse ceil(dz_gp_upper / max_axial_mesh_size)}'

# ==============================================================================
# Material IDs
# ==============================================================================
mid_fuel_1 = 1
mid_fuel_2 = 2
mid_fuel_3 = 3
mid_b4c = 4
mid_ht9 = 5
mid_sodium = 6
mid_rad_refl = 7
mid_rad_shld = 8
mid_lower_refl = 9
mid_upper_na_plen = 10
mid_upper_gas_plen = 11
mid_control_empty = 12

# ==============================================================================
# Mesh
# ==============================================================================
[Mesh]
  # Define global reactor mesh parameters
  [rmp]
    type = ReactorMeshParams
    dim = 3
    geom = "Hex"
    assembly_pitch = ${assembly_pitch}
    axial_regions = '${dz_active_core_lower} ${dz_active_core_upper} ${dz_sodium_gp_upper} ${dz_gp_upper}'
    axial_mesh_intervals = '${naxial_active_core_lower} ${naxial_active_core_upper}
                            ${naxial_sodium_gp_upper} ${naxial_gp_upper}'
    top_boundary_id = 201
    bottom_boundary_id = 202
    radial_boundary_id = 203
    flexible_assembly_stitching = true
  []
  # Define constituent pins of fuel assemblies
  [fuel_pin_1]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 1
    pitch = ${fuel_pin_pitch}
    num_sectors = 2
    ring_radii = '${fuel_clad_r_i} ${fuel_clad_r_o}'
    mesh_intervals = '1 1 1' # Fuel, cladding, background
    region_ids = '${mid_lower_refl}     ${mid_lower_refl}     ${mid_lower_refl};
                  ${mid_fuel_1}         ${mid_ht9}            ${mid_sodium};
                  ${mid_upper_na_plen}  ${mid_upper_na_plen}  ${mid_upper_na_plen};
                  ${mid_upper_gas_plen} ${mid_upper_gas_plen} ${mid_upper_gas_plen}' # Fuel, cladding, background
    quad_center_elements = false
  []
  [fuel_pin_2]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 2
    pitch = ${fuel_pin_pitch}
    num_sectors = 2
    ring_radii = '${fuel_clad_r_i} ${fuel_clad_r_o}'
    mesh_intervals = '1 1 1' # Fuel, cladding, background
    region_ids = '${mid_lower_refl}     ${mid_lower_refl}     ${mid_lower_refl};
                  ${mid_fuel_2}         ${mid_ht9}            ${mid_sodium};
                  ${mid_upper_na_plen}  ${mid_upper_na_plen}  ${mid_upper_na_plen};
                  ${mid_upper_gas_plen} ${mid_upper_gas_plen} ${mid_upper_gas_plen}' # Fuel, cladding, background
    quad_center_elements = false
  []
  [fuel_pin_3]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 3
    pitch = ${fuel_pin_pitch}
    num_sectors = 2
    ring_radii = '${fuel_clad_r_i} ${fuel_clad_r_o}'
    mesh_intervals = '1 1 1' # Fuel, cladding, background
    region_ids = '${mid_lower_refl}     ${mid_lower_refl}     ${mid_lower_refl};
                  ${mid_fuel_3}         ${mid_ht9}            ${mid_sodium};
                  ${mid_upper_na_plen}  ${mid_upper_na_plen}  ${mid_upper_na_plen};
                  ${mid_upper_gas_plen} ${mid_upper_gas_plen} ${mid_upper_gas_plen}' # Fuel, cladding, background
    quad_center_elements = false
  []
  # Define constituent pin of control assembly
  [control_pin]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 4
    pitch = ${control_pin_pitch}
    num_sectors = 2
    ring_radii = '${control_clad_r_i} ${control_clad_r_o}'
    mesh_intervals = '1 1 1' # Fuel, cladding, background
    region_ids = '${mid_control_empty} ${mid_control_empty} ${mid_control_empty};
                  ${mid_control_empty} ${mid_control_empty} ${mid_control_empty};
                  ${mid_b4c}            ${mid_ht9}            ${mid_sodium};
                  ${mid_b4c}            ${mid_ht9}            ${mid_sodium};' # Fuel, cladding, background
    quad_center_elements = false
  []
  # Define fuel assemblies
  [fuel_assembly_1]
    type = AssemblyMeshGenerator
    assembly_type = 1
    background_intervals = 1
    background_region_id = '${mid_lower_refl} ${mid_sodium} ${mid_upper_na_plen} ${mid_upper_gas_plen}'
    duct_halfpitch = '${fparse duct_pitch_inner / 2} ${fparse duct_pitch_outer / 2}'
    duct_intervals = '1 1'
    duct_region_ids = ' ${mid_lower_refl}     ${mid_lower_refl};
                        ${mid_ht9}            ${mid_sodium};
                        ${mid_upper_na_plen}  ${mid_upper_na_plen};
                        ${mid_upper_gas_plen} ${mid_upper_gas_plen}'
    inputs = 'fuel_pin_1'
    pattern = '0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 0'
  []
  [fuel_assembly_2]
    type = AssemblyMeshGenerator
    assembly_type = 2
    background_intervals = 1
    background_region_id = '${mid_lower_refl} ${mid_sodium} ${mid_upper_na_plen} ${mid_upper_gas_plen}'
    duct_halfpitch = '${fparse duct_pitch_inner / 2} ${fparse duct_pitch_outer / 2}'
    duct_intervals = '1 1'
    duct_region_ids = ' ${mid_lower_refl}     ${mid_lower_refl};
                        ${mid_ht9}            ${mid_sodium};
                        ${mid_upper_na_plen}  ${mid_upper_na_plen};
                        ${mid_upper_gas_plen} ${mid_upper_gas_plen}'
    inputs = 'fuel_pin_2'
    pattern = '0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 0'
  []
  [fuel_assembly_3]
    type = AssemblyMeshGenerator
    assembly_type = 3
    background_intervals = 1
    background_region_id = '${mid_lower_refl} ${mid_sodium} ${mid_upper_na_plen} ${mid_upper_gas_plen}'
    duct_halfpitch = '${fparse duct_pitch_inner / 2} ${fparse duct_pitch_outer / 2}'
    duct_intervals = '1 1'
    duct_region_ids = ' ${mid_lower_refl}     ${mid_lower_refl};
                        ${mid_ht9}            ${mid_sodium};
                        ${mid_upper_na_plen}  ${mid_upper_na_plen};
                        ${mid_upper_gas_plen} ${mid_upper_gas_plen}'
    inputs = 'fuel_pin_3'
    pattern = '0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
       0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
        0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
         0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0 0 0 0;
               0 0 0 0 0 0 0 0 0'
  []
  # Define control assembly
  [control_assembly]
    type = AssemblyMeshGenerator
    assembly_type = 4
    background_intervals = 1
    background_region_id = '${mid_control_empty} ${mid_control_empty} ${mid_sodium} ${mid_sodium}'
    duct_halfpitch = '${fparse control_duct_pitch_inner / 2} ${fparse control_duct_pitch_outer / 2}
                      ${fparse duct_pitch_inner / 2}         ${fparse duct_pitch_outer / 2}'
    duct_intervals = '1 1 1 1'
    duct_region_ids = '${mid_control_empty} ${mid_control_empty} ${mid_control_empty} ${mid_control_empty};
                       ${mid_control_empty} ${mid_control_empty} ${mid_control_empty} ${mid_control_empty};
                       ${mid_ht9}           ${mid_sodium}        ${mid_ht9}           ${mid_sodium};
                       ${mid_ht9}           ${mid_sodium}        ${mid_ht9}           ${mid_sodium}'
    inputs = 'control_pin'
    pattern = '0 0 0 0 0 0;
              0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0;
          0 0 0 0 0 0 0 0 0 0 0;
           0 0 0 0 0 0 0 0 0 0;
            0 0 0 0 0 0 0 0 0;
             0 0 0 0 0 0 0 0;
              0 0 0 0 0 0 0;
               0 0 0 0 0 0'
  []
  # Define homogenized reflector and shielding assemblies
  [reflector_assembly]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 5
    pitch = ${assembly_pitch}
    num_sectors = 2
    mesh_intervals = '1'
    region_ids = '${mid_rad_refl};
                  ${mid_rad_refl};
                  ${mid_rad_refl};
                  ${mid_rad_refl}' # Background
    use_as_assembly = true
    quad_center_elements = false
  []
  [shielding_assembly]
    type = PinMeshGenerator
    reactor_params = rmp
    pin_type = 6
    pitch = ${assembly_pitch}
    num_sectors = 2
    mesh_intervals = '1'
    region_ids = '${mid_rad_shld};
                  ${mid_rad_shld};
                  ${mid_rad_shld};
                  ${mid_rad_shld}' # Background
    use_as_assembly = true
    quad_center_elements = false
  []
  # Define heterogeneous core
  [het_core]
    type = CoreMeshGenerator
    inputs = 'fuel_assembly_1 fuel_assembly_2 fuel_assembly_3
              control_assembly reflector_assembly shielding_assembly
              dummy'
    dummy_assembly_name = 'dummy'
    pattern = '6 6 5 5 5 5 5 6 6;
              6 5 5 4 4 4 4 5 5 6;
             5 5 4 4 4 4 4 4 4 5 5;
            5 4 4 4 4 1 1 4 4 4 4 5;
           5 4 4 4 1 1 3 1 1 4 4 4 5;
          5 4 4 1 1 2 0 0 4 1 1 4 4 5;
         5 4 4 1 3 0 0 2 0 0 3 1 4 4 5;
        6 5 4 4 1 0 3 0 0 3 0 1 4 4 5 6;
       6 5 4 4 1 4 0 0 3 0 0 2 1 4 4 5 6;
        6 5 4 4 1 0 2 0 0 2 0 1 4 4 5 6;
         5 4 4 1 3 0 0 3 0 0 3 1 4 4 5;
          5 4 4 1 1 2 0 0 4 1 1 4 4 5;
           5 4 4 4 1 1 3 1 1 4 4 4 5;
            5 4 4 4 4 1 1 4 4 4 4 5;
             5 5 4 4 4 4 4 4 4 5 5;
              6 5 5 4 4 4 4 5 5 6;
               6 6 5 5 5 5 5 6 6'
    extrude = true
  []
  # Define equivalent RZ core from input heterogeneous RGMB core
  [rz_core]
    type = EquivalentCoreMeshGenerator
    input = het_core
    target_geometry = rz
    max_radial_mesh_size = 5
    radial_boundaries = '7.66 20.28 27.63 35.95 48.47 64.13 94.18 108.12'
    radial_assembly_names = 'control_assembly fuel_assembly_1 fuel_assembly_3
                             control_assembly fuel_assembly_1 fuel_assembly_2
                             reflector_assembly shielding_assembly'
    debug_equivalent_core = true
  []
  # Define and apply a coarse RZ mesh
  [rz_coarse_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '7.66 12.61 7.36 8.31 12.52 15.65 30.06 13.94'
    dy = '60 80 20 100'
  []
  [rz_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = rz_core
    coarse_mesh = rz_coarse_mesh
    extra_element_id_name = coarse_elem_id
  []
  coord_type = RZ
  data_driven_generator = rz_core
[]

[MCC3CrossSection]
  remove_pwfiles = false
  remove_inputs = true
  remove_outputs = true
  remove_xmlfiles = true
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
