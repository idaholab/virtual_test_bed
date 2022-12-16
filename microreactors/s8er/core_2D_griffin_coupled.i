# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2022-07-20 10:50:17
# Author(s): Isaac Naupa Aguirre
# Supervisor: Stefano Terlizzi
# ==============================================================================
# SNAP8ER 2D Core  Wet Operational Conditions, Coupled with Bison.
# Application : Griffin (standalone), BlueCRAB (coupled)
# For use of this model please cite:
# @InProceedings{s8er_naupa2022,
#     author = "Naupa, Isaac and Garcia, Samuel and Terlizzi, Stefano and Kotlyar, Dan and Lindley, Ben",
#     title = "{(In Preperation) Validation of SNAP8 Criticality Configuration Experiments using NEAMS Tools}",
#     booktitle = "{Proceedings of ANS M\&C}",
#     year = "2022"
# }
# @InProceedings{s8er_garcia2022,
#     author = "Garcia, Samuel and Naupa, Isaac and Kotlyar, Dan and Lindley, Ben",
#     title = "{Validation of SNAP8 Criticality Configuration Experiments using SERPENT}",
#     booktitle = "{Proceedings of ANS Winter Conference}",
#     year = "2022"
# }
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Calculations for material property equations and system parameters & dimensions
# can be found under Models/SNAP8ER_dimensions_params_etc.xlsx

# Geometry ---------------------------------------------------------------------
# Reference:
# Reference:
# @techreport{SNAP8Summary,
#     author = "Division, Atomics Internation",
#     title = "{SNAP 8 summary report}",
#     institution = "Atomics Internation Division",
#     year = "1973",
#     doi = "10.2172/4393793",
#     url = "https://www.osti.gov/biblio/4393793"
# }
hex_apothem               = 0.007239
#fuel_volume               = ${fparse pi*fuel_len*fuel_radius*fuel_radius} # (m3)
# fuel_len                  = 0.3556 # (m).
# fuel_len_half             = ${fparse fuel_len*0.5}
# fuel_radius               = 0.0067564 # (m)

active_apothem            = .110414
nonactive_corner       = .2550
nonactive_corner_half     = ${fparse nonactive_corner*0.5}

# Geometry Cuts

cut_apothem               = .115824
cut_y                     = .057912
cut_x                     = .1003065264

scube_apothem             = .1181
scube_x                   = 0.05905
scube_y                   = 0.1022776

# System Properties ------------------------------------------------------------
# Reference:
# @techreport{SNAP8Summary,
#     author = "Division, Atomics Internation",
#     title = "{SNAP 8 summary report}",
#      institution = "Atomics Internation Division",
#      year = "1973",
#      doi = "10.2172/4393793",
#      url = "https://www.osti.gov/biblio/4393793"
#  }
total_power               = 600000.00 # (W). #total power
inlet_T_fluid             = 949.81667 # (K)

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
    [fuel_elem1]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '1 1'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem2]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '2 2'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem3]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '3 3'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem4]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '4 4'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem5]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '5 5'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem6]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '6 6'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem7]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '7 7'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_elem8]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '8 8'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [air_elem1]
         type = PolygonConcentricCircleMeshGenerator
         num_sides = '6'
         num_sectors_per_side = '2 2 2 2 2 2'
         polygon_size = '${hex_apothem}'
         preserve_volumes = true
         background_intervals = '2'
         background_block_ids = '9 9'
         quad_center_elements = true
         smoothing_max_it = 3
    []
    [fuel_assem]
        type = PatternedHexMeshGenerator
        inputs = 'fuel_elem1 fuel_elem2 fuel_elem3 fuel_elem4 fuel_elem5 fuel_elem6 fuel_elem7 fuel_elem8 air_elem1'
        # Pattern ID  0 1 2 3 4 5 6 7 8
        background_intervals = 1
        background_block_id = '10'
        background_block_name = 'AIR'
        hexagon_size = '${active_apothem}'
        hexagon_size_style = 'apothem'
        pattern_boundary = 'hexagon'
        pattern =
           '8 7 7 7 7 7 7 7 8;
            7 6 6 6 6 6 6 6 6 7 ;
            7 6 5 5 5 5 5 5 5 6 7 ;
            7 6 5 4 4 4 4 4 4 5 6 7 ;
            7 6 5 4 3 3 3 3 3 4 5 6 7 ;
            7 6 5 4 3 2 2 2 2 3 4 5 6 7 ;
            7 6 5 4 3 2 1 1 1 2 3 4 5 6 7 ;
            7 6 5 4 3 2 1 0 0 1 2 3 4 5 6 7 ;
            8 6 5 4 3 2 1 0 0 0 1 2 3 4 5 6 8 ;
            7 6 5 4 3 2 1 0 0 1 2 3 4 5 6 7 ;
            7 6 5 4 3 2 1 1 1 2 3 4 5 6 7 ;
            7 6 5 4 3 2 2 2 2 3 4 5 6 7 ;
            7 6 5 4 3 3 3 3 3 4 5 6 7 ;
            7 6 5 4 4 4 4 4 4 5 6 7 ;
            7 6 5 5 5 5 5 5 5 6 7 ;
            7 6 6 6 6 6 6 6 6 7 ;
            8 7 7 7 7 7 7 7 8'
        external_boundary_id = '10'
        external_boundary_name = 'active_outer'
    []
    [int_ref]
        type = PeripheralRingMeshGenerator
        input = fuel_assem
        peripheral_ring_radius = '${nonactive_corner_half}'
        input_mesh_external_boundary = 'active_outer'
        external_boundary_name = 'core_outer'
        external_boundary_id = '11'
        peripheral_ring_block_id = 11
        peripheral_ring_block_name = int_ref
        peripheral_layer_num = 10
    []
    [cut_1]
        type = PlaneDeletionGenerator
        point = '0 ${cut_apothem} 0'
        normal = '0 ${cut_apothem} 0'
        input = int_ref
        new_boundary = 'core_outer'
    []
    [cut_2]
        type = PlaneDeletionGenerator
        point = '${cut_x} ${cut_y} 0'
        normal = '${cut_x} ${cut_y} 0'
        input = cut_1
        new_boundary = 'core_outer'
    []
    [cut_3]
        type = PlaneDeletionGenerator
        point = '${cut_x} -${cut_y} 0'
        normal = '${cut_x} -${cut_y} 0'
        input = cut_2
        new_boundary = 'core_outer'
    []
    [cut_4]
        type = PlaneDeletionGenerator
        point = '0 -${cut_apothem} 0'
        normal = '0 -${cut_apothem} 0'
        input = cut_3
        new_boundary = 'core_outer'
    []
    [cut_5]
        type = PlaneDeletionGenerator
        point = '-${cut_x} -${cut_y} 0'
        normal = '-${cut_x} -${cut_y} 0'
        input = cut_4
        new_boundary = 'core_outer'
    []
    [cut_6]
        type = PlaneDeletionGenerator
        point = '-${cut_x} ${cut_y} 0'
        normal = '-${cut_x} ${cut_y} 0'
        input = cut_5
        new_boundary = 'core_outer'
    []
    [scube_1]
        type = PlaneDeletionGenerator
        point = '${scube_apothem} 0  0'
        normal = '${scube_apothem} 0  0'
        input = cut_6
        new_boundary = 'core_outer'
    []
    [scube_2]
        type = PlaneDeletionGenerator
        point = '${scube_x} ${scube_y} 0'
        normal = '${scube_x} ${scube_y} 0'
        input = scube_1
        new_boundary = 'core_outer'
    []
    [scube_3]
        type = PlaneDeletionGenerator
        point = '${scube_x} -${scube_y} 0'
        normal = '${scube_x} -${scube_y} 0'
        input = scube_2
        new_boundary = 'core_outer'
    []
    [scube_4]
        type = PlaneDeletionGenerator
        point = '-${scube_apothem} 0 0'
        normal = '-${scube_apothem} 0 0'
        input = scube_3
        new_boundary = 'core_outer'
    []
    [scube_5]
        type = PlaneDeletionGenerator
        point = '-${scube_x} -${scube_y} 0'
        normal = '-${scube_x} -${scube_y} 0'
        input = scube_4
        new_boundary = 'core_outer'
    []
    [scube_6]
        type = PlaneDeletionGenerator
        point = '-${scube_x} ${scube_y} 0'
        normal = '-${scube_x} ${scube_y} 0'
        input = scube_5
        new_boundary = 'core_outer'
    []
    [set_mat_id]
        type = SubdomainExtraElementIDGenerator
        input = 'scube_6'
        subdomains = '1 2 3 4 5 6 7 8 9 10 11'
        extra_element_id_names = 'material_id'
        extra_element_ids = '100 200 900 400 500 600 700 800 300 300 1200'
    []
[]
# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
    [griffin_Tfuel]
        family = MONOMIAL
        order = constant
        initial_condition = '${inlet_T_fluid}'
    []
    [griffin_Tcool]
        family = MONOMIAL
        order = constant
        initial_condition = '${inlet_T_fluid}'
    []
    [griffin_Tintref]
        family = MONOMIAL
        order = constant
        initial_condition = '${inlet_T_fluid}'
    []
[]

# ==============================================================================
# TRANSPORT SYSTEMS
# ==============================================================================
[TransportSystems]
    # Eigenvalue Problem
    particle = neutron
    equation_type = eigenvalue

    # Sixteen Group XS Structure
    G = 16
    VacuumBoundary = 'core_outer'

    # DFEM-Transport
    [dsn]
        scheme = DFEM-SN
        #n_delay_groups = 6
        family = MONOMIAL
        order = FIRST
        AQtype = Gauss-Chebyshev
        NPolar = 3 # use >=2 for final runs (4 sawtooth nodes sufficient)
        NAzmthl = 9 # use >=6 for final runs (4 sawtooth nodes sufficient)
        NA = 1
        sweep_type = asynchronous_parallel_sweeper
        using_array_variable = true
        collapse_scattering  = true
        hide_angular_flux = true
        # verbose = 3
    []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS, AND USER OBJECTS
# ==============================================================================
[Materials]
    [core]
        type = CoupledFeedbackMatIDNeutronicsMaterial
        block = '1 2 3 4 5 6 7 8 9 10'
        library_file = './serpent/core_2D_nodrums_16G_WET_XS.xml'
        library_name = 'core_2D_nodrums_16G_WET_XS'
        isotopes = 'pseudo'
        densities = '1.0'
        plus = 1
        is_meter = true
        grid_names = 'Tfuel Tcool'
        grid_variables = 'griffin_Tfuel griffin_Tcool'
        #volume_adjuster = core_vol_adjust  #to be fixed
    []
    [int_ref]
        type = CoupledFeedbackMatIDNeutronicsMaterial
        block = '11'
        library_file = './serpent/core_2D_nodrums_16G_WET_XS.xml'
        library_name = 'core_2D_nodrums_16G_WET_XS'
        isotopes = 'pseudo'
        densities = '1.0'
        plus = 1
        is_meter = true
        grid_names = 'Tfuel Tcool'
        grid_variables = 'griffin_Tfuel griffin_Tcool'
        volume_adjuster = int_ref_vol_adjust
    []
[]

[PowerDensity]
    power = '${total_power}'
    power_density_variable = griffin_power_density
    integrated_power_postprocessor = integrated_power
    family = L2_LAGRANGE
    order = FIRST
[]

[UserObjects]
    # [core_vol_adjust] # TO BE FIXED
    #     type = VolumeAdjuster
    #     block = '1 2 3 4 5 6 7 8 9 10'
    #     vol = 0.040999863
    #     execute_on = 'initial timestep_begin timestep_end'
    #     correct_XS = true
    # []
    [int_ref_vol_adjust]
        type = VolumeAdjuster
        block = '11'
        vol = 0.00331416
        execute_on = 'initial timestep_begin timestep_end'
        correct_XS = true
    []
    # [Tcore]
    #     type = LayeredAverage
    #     variable = griff_temp
    #     direction = x
    #     num_layers = '9'
    #     block = 'core'
    #     #execute_on = 'initial linear'
    # []
[]


# ==============================================================================
# MULTIAPPS AND TRANSFERS
# ==============================================================================
[MultiApps]
    [bison_coupled]
        type = FullSolveMultiApp
        app_type = GriffinApp
        input_files = 'core_2D_bison_coupled.i'
        positions = '0 0 0'
    []
[]

[Transfers]
    [to_bison_power_density]
        type = MultiAppProjectionTransfer
        to_multi_app = bison_coupled
        source_variable = griffin_power_density
        variable = bison_power_density
    []
    [from_bison_Tfuel]
        type = MultiAppGeometricInterpolationTransfer
        from_multi_app = bison_coupled
        source_variable = bison_Tfuel
        variable = griffin_Tfuel
    []
    [from_bison_Tcool]
        type = MultiAppGeometricInterpolationTransfer
        from_multi_app = bison_coupled
        source_variable = bison_Tcool
        variable = griffin_Tcool
    []
    [from_bison_Tintref]
        type = MultiAppGeometricInterpolationTransfer
        from_multi_app = bison_coupled
        source_variable = bison_Tintref
        variable = griffin_Tintref
    []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
# DFEM-SN Executioner
[Executioner]
    type = SweepUpdate
    verbose = true

    richardson_max_its = 50
    richardson_value = fission_source_integral
    richardson_rel_tol = 1e-4

    inner_solve_type = GMRes
    max_inner_its = 2

    fixed_point_max_its = 2
    custom_pp = fission_source_integral
    custom_rel_tol = 1e-4
    force_fixed_point_solve = true
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
    [griffin_power]
        type = ElementIntegralVariablePostprocessor
        variable = griffin_power_density
        #use_displaced_mesh = true
        execute_on = 'initial timestep_end'
    []
    [core_vol]
        type = VolumePostprocessor
        block = '1 2 3 4 5 6 7 8 9 10'
        execute_on = 'initial timestep_end'
    []
    [intref_vol]
        type = VolumePostprocessor
        block = '11'
        execute_on = 'initial timestep_end'
    []
    [griffin_Tfuel_max]
        type = ElementExtremeValue
        block = '1 2 3 4 5 6 7 8 9 10'
        variable = griffin_Tfuel
        execute_on = 'initial timestep_end'
    []
    [griffin_Tfuel_avg]
        type = ElementAverageValue
        block = '1 2 3 4 5 6 7 8 9 10'
        variable = griffin_Tfuel
        execute_on = 'initial timestep_end'
    []
    [griffin_Tfuel_min]
        type = ElementExtremeValue
        block = '1 2 3 4 5 6 7 8 9 10'
        value_type = min
        variable = griffin_Tfuel
        execute_on = 'initial timestep_end'
    []
    [griffin_Tcool_max]
        type = ElementExtremeValue
        block = '1 2 3 4 5 6 7 8 9 10'
        variable = griffin_Tcool
        execute_on = 'initial timestep_end'
    []
    [griffin_Tcool_avg]
        type = ElementAverageValue
        block = '1 2 3 4 5 6 7 8 9 10'
        variable = griffin_Tcool
        execute_on = 'initial timestep_end'
    []
    [griffin_Tcool_min]
        type = ElementExtremeValue
        block = '1 2 3 4 5 6 7 8 9 10'
        value_type = min
        variable = griffin_Tcool
        execute_on = 'initial timestep_end'
    []
    [griff_power_density_avg]
        type = ElementAverageValue
        block = '1 2 3 4 5 6 7 8'
        variable = griffin_power_density
        execute_on = 'initial timestep_end'
    []
    [norm_volume]
        type = VolumePostprocessor
        block = '1 2 3 4 5 6 7 8'
    []
[]

[Outputs]
    exodus = true
    csv = true
    perf_graph = true
[]
