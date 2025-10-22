# ==============================================================================
# Model description
# Streamline depletion model for equilibrium core calculation
# 9 burnup groups
# ------------------------------------------------------------------------------
# Idaho Falls, INL, September 29, 2022
# Author(s): Dr. Sebastian Schunert, Dr. Javier Ortensi, Dr. Mustafa Jaradat
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# parameters describing the reactor geometry
core_height = 11.0
axial_reflector_height = 3.228
fuel_radius = 1.5
r_streamline_1 = 12.5e-2
r_streamline_2 = 37.5e-2
r_streamline_3 = 62.5e-2
r_streamline_4 = 87.5e-2
r_streamline_5 = 112.5e-2
r_streamline_6 = 137.5e-2
burnup_group_boundaries = '5.35E+13 1.070E+14 1.604E+14 2.139E+14 2.674E+14 3.209E+14 3.743E+14 4.278E+14 4.818E+14'

# parameters describing the pebbles
pebble_radius = 3e-2
pebble_volume = ${fparse 4 / 3 * pi * pebble_radius * pebble_radius * pebble_radius}
# parameters describing pebble motion
residence_time = 70.5 #to approximate 15 passes
pebble_speed = ${fparse core_height / (residence_time * 3600 * 24)}
area = ${fparse pi * fuel_radius * fuel_radius}
pebble_unloading_rate = ${fparse pebble_speed * area * 0.61 / pebble_volume}

[Mesh]
  [generate_streamlines]
    type = PolyLineStreamlineGenerator
    points = '${r_streamline_1} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_1} ${axial_reflector_height} 0;
              ${r_streamline_2} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_2} ${axial_reflector_height} 0;
              ${r_streamline_3} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_3} ${axial_reflector_height} 0;
              ${r_streamline_4} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_4} ${axial_reflector_height} 0;
              ${r_streamline_5} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_5} ${axial_reflector_height} 0;
              ${r_streamline_6} ${fparse core_height + axial_reflector_height} 0 ${r_streamline_6} ${axial_reflector_height} 0'
    segment_subdivisions = '20; 20; 20; 20; 20; 20'
  []
 [assign_material_id]
   type = SubdomainExtraElementIDGenerator
   input = generate_streamlines
   extra_element_id_names = 'material_id'
   subdomains = '0 1 2 3 4 5'
   extra_element_ids = '1 1 1 1 1 1'
 []
[]

[Problem]
  kernel_coverage_check = false
[]

[Variables]
  [u]
  []
[]

[PebbleDepletionVariables]
  burnup_group_boundaries = ${burnup_group_boundaries}
  n_fresh_pebble_types = 1
  G = 9
  n_isotopes = 294
[]

[UserObjects]
  [sweep]
    type = PebbleDepletionSweepUserObject
    pebble_unloading_rate = ${pebble_unloading_rate}
    pebble_flow_rate_distribution = '0.027777778 0.083333333 0.138888889 0.194444444 0.25 0.305555556'
    burnup_group_boundaries = ${burnup_group_boundaries}
    burnup_limit = 4.818E+14
    n_fresh_pebble_types = 1
    major_streamline_axis = y
    scalar_flux_scaling = 1
    pebble_diameter = 0.06
    dataset = ISOXML
    isoxml_data_file = '../xsections/DRAGON5_DT.xml'
    isoxml_lib_name = 'DRAGON'
    library_file ='../xsections/HTR-PM_9G-Tnew.xml'
    library_name = 'HTR-PM'
    strictness = 0
    debug_mode = false
    moderator_temperature_grid_name = Tmod
    fuel_temperature_grid_name = Tfuel
    burnup_grid_name = Burnup
    is_meter = true					   
    fresh_pebble_isotopes =          '     U234      U235      U238       O16        O17
                                        Graphite     SI28     SI29        SI30      C12'
    fresh_pebble_isotope_densities = '1.0887E-07 1.3550E-05 1.4209E-04 3.1137E-04 1.1837E-07
                                       8.5357E-02 3.1399E-04 1.5944E-05 1.0510E-05 3.4044E-04'
    sweep_tol = 1e-5
    sweep_max_iterations = 100
  []
[]

[Executioner]
  type = Steady
[]

[Outputs]
  [exodus]
    type = Exodus
    execute_on = 'INITIAL TIMESTEP_END FAILED'
  []
[]
