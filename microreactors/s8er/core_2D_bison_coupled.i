# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2022-07-20 10:50:17
# Author(s): Isaac Naupa Aguirre
# Supervisor: Stefano Terlizzi
# ==============================================================================
# SNAP8ER 2D Core  Wet Operational Conditions, Coupled with Bison.
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
# # ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Calculations for material property equations and system parameters & dimensions
# can be found under Models/SNAP8ER_dimensions_params_etc.xlsx

# Geometry ---------------------------------------------------------------------
# Reference:
# @techreport{SNAP8Summary,
#     author = "Division, Atomics Internation",
#     title = "{SNAP 8 summary report}",
#     institution = "Atomics Internation Division",
#     year = "1973",
#     doi = "10.2172/4393793",
#     url = "https://www.osti.gov/biblio/4393793"
# }
fuel_radius               = 0.0067564 # (m)
ceramic_radius_outer      = 0.006826079 # (m)
gap_radius_outer          = 0.006866719 # (m)
clad_radius_outer         = 0.007130879 # (m)
#fuel_len                  = 0.3556 # (m).
#fuel_len_half             = ${fparse fuel_len*0.5}
hex_apothem               = 0.007239
#fuel_volume               = ${fparse pi*fuel_len*fuel_radius*fuel_radius} # (m3)
#clad_thickness            = 0.00026416 # (m)

active_apothem            = .110414
nonactive_corner 		  = .2550
nonactive_corner_half     = ${fparse nonactive_corner*0.5}
cut_apothem               = 0.115924
cut_y                     = 0.057962
cut_x                     = 0.100393129

scube_apothem             = .11815
scube_x                   = 0.059075
scube_y                   = 0.102320901

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
inlet_T_fluid             = 949.81667 # (K) 
ht_coeff                  = 4539.6


# Material Properties ------------------------------------------------------------
# Reference:
# @article{SNAPFuel,
#     author = "Nelson, S G",
#     title = "High-temperature thermal propeties of SNAP-10A fuel material",
#     doi = "10.2172/4260713",
#     url = "https://www.osti.gov/biblio/4260713",
#     journal = "",
#     place = "United States",
#     year = "1965",
#     month = "2"
# }
clad_density              = 8617.9333 # (kg/m^3)
clad_tc                   = 18.85239 # (W/m K)
clad_cp                   = 418.68 # (J/kg-K)
fuel_density              = 5963 # (kg/m^3)
gap_tc                    = .346146933
#gap_dens        = 0.016646998
#gap_cp          = 5193.163779


# fuel_dens                    = -0.222222222*T + 6003 
# fuel_cp                      = -0.222222222*T + 27.73992
# fuel_tc                      = -0.222222222*T + 472.27104
ceramic_emiss             = .80
clad_emiss                = .80

ceramic_dens              = 2242.584872
ceramic_cp                = 837.36
ceramic_tc                = 1.730734666
        
intref_dens               = 1810.086361
intref_cp                 = 2721.42
intref_tc                 = 131.5358346
        
coolant_dens                  = 800 
coolant_cp                    = 880
coolant_tc                    = 28


# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
	[fuel_elem1]
	     type = PolygonConcentricCircleMeshGenerator
	     num_sides = '6'
	     num_sectors_per_side = '4 4 4 4 4 4' 
	     polygon_size = '${hex_apothem}' 
	     preserve_volumes = true 
         ring_radii = '${fuel_radius} ${ceramic_radius_outer} ${gap_radius_outer} ${clad_radius_outer} ' 
         ring_intervals = '1 1 1 1'
         ring_block_ids = '1 2 3 4'
	     background_intervals = '1' 
	     background_block_ids = '5' 
	     quad_center_elements = true 
	     smoothing_max_it = 3
	[]
	[coolant_elem1]
	     type = PolygonConcentricCircleMeshGenerator
	     num_sides = '6'
	     num_sectors_per_side = '4 4 4 4 4 4'
	     polygon_size = '${hex_apothem}' 
	     preserve_volumes = true 
	     background_intervals = '1' 
	     background_block_ids = '6' 
	     quad_center_elements = true 
	     smoothing_max_it = 3
         external_boundary_id = '6'
	[]
    [fuel_assem]
        type = PatternedHexMeshGenerator
        inputs = 'fuel_elem1 coolant_elem1'
        # Pattern ID  0 1 
        background_intervals = 1
        background_block_id = '7'
        background_block_name = 'coolant'
        hexagon_size = '${active_apothem}'
        hexagon_size_style = 'apothem'
        pattern_boundary = 'hexagon'
        pattern =       
		   '1 0 0 0 0 0 0 0 1;
			0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 0 ;
			0 0 0 0 0 0 0 0 0 0 ;
			1 0 0 0 0 0 0 0 1'
    []
    [block_rename1]
        type = RenameBlockGenerator
        input = fuel_assem
        old_block = '1 2 3 4 5 6 7'
        new_block = 'fuel ceramic gap clad coolant coolant coolant'
    []
    [bound_rename1]
        type = RenameBoundaryGenerator
        input = block_rename1
        old_boundary = '2 3 4'
        new_boundary = 'gap_inner gap_outer clad_outer'
    []
    [inner_gap1]
        type = SideSetsBetweenSubdomainsGenerator
        input = bound_rename1
        primary_block = ceramic
        paired_block = gap
        new_boundary = 'gap_inner'
    []
    [outer_gap1]
        type = SideSetsBetweenSubdomainsGenerator
        input = inner_gap1
        primary_block = clad
        paired_block = gap
        new_boundary = 'gap_outer'
    []
    [del_gap1]
        type = BlockDeletionGenerator
        block = gap
        input = outer_gap1
    []
    [int_ref]
        type = PeripheralRingMeshGenerator
        input = del_gap1
        peripheral_ring_radius = '${nonactive_corner_half}'
        input_mesh_external_boundary = 10000
        peripheral_ring_block_id = 8
        peripheral_ring_block_name = int_ref
        peripheral_layer_num = 10
    []
    [cut_1]
        type = PlaneDeletionGenerator
        point = '0 ${cut_apothem} 0'
        normal = '0 ${cut_apothem} 0'
        input = int_ref
        new_boundary = 10000
    []
    [cut_2]
        type = PlaneDeletionGenerator
        point = '${cut_x} ${cut_y} 0'
        normal = '${cut_x} ${cut_y} 0'
        input = cut_1
        new_boundary = 10000
    []
    [cut_3]
        type = PlaneDeletionGenerator
        point = '${cut_x} -${cut_y} 0'
        normal = '${cut_x} -${cut_y} 0'
        input = cut_2
        new_boundary = 10000
    []
    [cut_4]
        type = PlaneDeletionGenerator
        point = '0 -${cut_apothem} 0'
        normal = '0 -${cut_apothem} 0'
        input = cut_3
        new_boundary = 10000
    []
    [cut_5]
        type = PlaneDeletionGenerator
        point = '-${cut_x} -${cut_y} 0'
        normal = '-${cut_x} -${cut_y} 0'
        input = cut_4
        new_boundary = 10000
    []
    [cut_6]
        type = PlaneDeletionGenerator
        point = '-${cut_x} ${cut_y} 0'
        normal = '-${cut_x} ${cut_y} 0'
        input = cut_5
        new_boundary = 10000
    []
    [scube_1]
        type = PlaneDeletionGenerator
        point = '${scube_apothem} 0  0'
        normal = '${scube_apothem} 0  0'
        input = cut_6
        new_boundary = 10000
    []
    [scube_2]
        type = PlaneDeletionGenerator
        point = '${scube_x} ${scube_y} 0'
        normal = '${scube_x} ${scube_y} 0'
        input = scube_1
        new_boundary = 10000
    []
    [scube_3]
        type = PlaneDeletionGenerator
        point = '${scube_x} -${scube_y} 0'
        normal = '${scube_x} -${scube_y} 0'
        input = scube_2
        new_boundary = 10000
    []
    [scube_4]
        type = PlaneDeletionGenerator
        point = '-${scube_apothem} 0 0'
        normal = '-${scube_apothem} 0 0'
        input = scube_3
        new_boundary = 10000
    []
    [scube_5]
        type = PlaneDeletionGenerator
        point = '-${scube_x} -${scube_y} 0'
        normal = '-${scube_x} -${scube_y} 0'
        input = scube_4
        new_boundary = 10000
    []
    [scube_6]
        type = PlaneDeletionGenerator
        point = '-${scube_x} ${scube_y} 0'
        normal = '-${scube_x} ${scube_y} 0'
        input = scube_5
        new_boundary = 10000
    []
    [bound_rename2]
        type = RenameBoundaryGenerator
        input = scube_6
        old_boundary = '10000'
        new_boundary = 'void_outer'
    []
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[Variables]
    [bison_temp]
        #initial_condition = '${inlet_T_fluid}'
    []
[]

[Kernels]
    # Equation 0 (Heat conduction equation with heat generation).
    [heat_conduction]
        type = ADHeatConduction
        variable = bison_temp
    []
    [heat_source]
        type = ADCoupledForce
        variable = bison_temp
        v = bison_norm_power_density
        block = fuel
    []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
    [aux_tk]
        family = LAGRANGE
        order = FIRST
        block = fuel
    []
    [aux_cp]
        family = LAGRANGE
        order = FIRST
        block = fuel
    []
    [bison_power_density]
        family = L2_LAGRANGE 
        order = FIRST 
        block = fuel
    []
    [aux_T_inf]
        family = LAGRANGE
        order = FIRST
        block = clad
    []
    [bison_Tfuel]
        block = 'fuel'
    []
    [bison_Tcool]
        block = 'coolant'
    []
    [bison_Tintref]
        block = 'int_ref'
    []
    [bison_norm_power_density]
        family = L2_LAGRANGE
        order = FIRST
        block = fuel
    []
[]

[AuxKernels]

    [aux_tk]
        type = FunctionAux
        function = tk_f
        variable = aux_tk
        block = fuel
    []
    [aux_cp]
        type = FunctionAux
        function = cp_f
        variable = aux_cp
        block = fuel
    []
    [aux_T_inf]
        type = FunctionAux
        function = T_inf_f
        variable = aux_T_inf
        block = clad
    []
    [norm_Tfuel]
        type = NormalizationAux
        variable = bison_Tfuel
        source_variable = bison_temp
        execute_on = 'timestep_end' #check
    []
    [norm_Tcool]
        type = NormalizationAux
        variable = bison_Tcool
        source_variable = bison_temp
        execute_on = 'timestep_end' #check
    []
    [norm_Tintref]
        type = NormalizationAux
        variable = bison_Tintref
        source_variable = bison_temp
        execute_on = 'timestep_end' #check
    []
    [norm_power_density]
        type = NormalizationAux
        variable = bison_norm_power_density
        source_variable = bison_power_density
        normal_factor = 1.26359177225#1.265805981 
        execute_on = 'timestep_begin' #check
    []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[Functions]

    [tk_f]
        type = ParsedFunction
        vars = 'bison_temp'
        vals = 'temp_av'
        value = '27.73992+bison_temp*0.027428444'#Models/SNAP10A_dimensions
    []
    [cp_f]
        type = ParsedFunction
        vars = 'bison_temp'
        vals = 'temp_av'
        value = '472.27104+bison_temp*0.7275728'#Models/SNAP10A_dimensions
    []
    [T_inf_f]
        type = ParsedFunction
        value = '${inlet_T_fluid}'
    []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS, AND USER OBJECTS
# ==============================================================================
[Materials]
    [fuel_thermal_conduction]
    # Metallic Uranium Zirc Hydride fuel conduction params.
        type = ADHeatConductionMaterial
        temp = bison_temp
        specific_heat_temperature_function = cp_f
        thermal_conductivity_temperature_function = tk_f
        block = fuel
    []
    # Metallic Uranium Zirc Hydride fuel density
    [fuel_density]
        type = ADGenericConstantMaterial
        prop_names = 'density'
        prop_values = '${fuel_density}'
        block = fuel
    []
    # Fluid ambient temperature.
    # [T_infinity]
    #     #Models/SNAP10A_dimensions
    #     type = ADCoupledValueFunctionMaterial
    #     prop_name = 'T_infinity'
    #     function = 'if(x<180, 293.15+2.908240722*x, 816.48333)'
    #     v = 'aux_time'
    #     block = 2
    #     boundary = 'right'
    # []
    [clad_thermal_conduction]
        #Models/SNAP10A_dimensions
        type = ADGenericConstantMaterial
        prop_names = 'density specific_heat thermal_conductivity'
        prop_values = '${clad_density} ${clad_cp} ${ clad_tc}'
        block = clad
    []
    [gap_heat_transfer]
        #Models/SNAP10A_dimensions
        type = GenericConstantMaterial
        prop_names = 'gap_conductance gap_conductance_dT'
        prop_values = '${gap_tc} 0.0'
        boundary = 'gap_inner gap_outer'
    []
    # [gap_thermal_conduction]
    #     #Models/SNAP10A_dimensions
    #     type = ADGenericConstantMaterial
    #     prop_names = 'density specific_heat thermal_conductivity'
    #     prop_values = '${gap_dens} ${gap_cp} ${gap_tc}'
    #     block = gap
    # []
    [ceramic_thermal_conduction]
        #Models/SNAP10A_dimensions
        type = ADGenericConstantMaterial
        prop_names = 'density specific_heat thermal_conductivity'
        prop_values = '${ceramic_dens} ${ ceramic_cp} ${ ceramic_tc}'
        block = ceramic
    []
    [intref_thermal_conduction]
        #Models/SNAP10A_dimensions
        type = ADGenericConstantMaterial
        prop_names = 'density specific_heat thermal_conductivity'
        prop_values = '${intref_dens} ${intref_cp} ${ intref_tc}'
        block = int_ref
    []
    # [air_thermal_conduction]
    #     #Models/SNAP10A_dimensions
    #     type = ADGenericConstantMaterial
    #     prop_names = 'density specific_heat thermal_conductivity'
    #     prop_values = '${air_dens} ${air_cp} ${air_tc}'
    #     block = air
    # []
    [coolant_thermal_conduction]
        #Models/SNAP10A_dimensions
        type = ADGenericConstantMaterial
        prop_names = 'density specific_heat thermal_conductivity'
        prop_values = '${coolant_dens} ${coolant_cp} ${coolant_tc}'
        block = coolant
    []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
    # Convective BC outer surface fuel pin
    [convective_boundary]
        type = CoupledConvectiveHeatFluxBC
        variable = bison_temp
        boundary = clad_outer
        T_infinity = aux_T_inf
        htc = '${ht_coeff}'
    []
[]

[ThermalContact]
    # Gap Heat Transfer 
    [gap_ht]
        type = GapHeatTransfer
        variable = bison_temp
        gap_geometry_type = 'PLATE'
        primary = 'gap_inner'
        secondary = 'gap_outer'
        emissivity_primary = '${ceramic_emiss}'
        emissivity_secondary = '${clad_emiss}'
        gap_conductivity = '${gap_tc}' # W/mK
        quadrature = true
    []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
    type = Steady
    nl_rel_tol = 1e-8
    nl_abs_tol = 1e-8
    nl_abs_step_tol = 1e-8
    l_tol = 1e-8
    solve_type = NEWTON
    petsc_options_iname = '-pc_type -pc_hypre_type'
    petsc_options_value = 'hypre boomeramg'
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
    [temp_av]
    # Temp average fuel
        type = ElementAverageValue
        variable = bison_temp
    []
    [tc_av]
        type = ElementAverageValue
        variable = aux_tk
        block = fuel
    []
    # Specific Heat postprocessor
    [cp_av]
        type = ElementAverageValue
        variable = aux_cp
        block = fuel
    []
    # Temp max value
    [temp_max]
        type = ElementExtremeValue
        variable = bison_temp
    []
    # Temp min value
    [temp_min]
        type = ElementExtremeValue
        variable = bison_temp
        value_type = min
    []
    [power]
        type = ElementIntegralVariablePostprocessor
        variable = bison_power_density
        #use_displaced_mesh = true # check
        block = fuel
        execute_on = 'initial timestep_end'
    []
    [norm_power]
        type = ElementIntegralVariablePostprocessor
        variable = bison_norm_power_density
        #use_displaced_mesh = true # check
        block = fuel
        execute_on = 'initial timestep_end'
    []
    [power_density_avg]
        type = ElementAverageValue
        variable = bison_power_density
        #use_displaced_mesh = true # check
        block = fuel
        execute_on = 'initial timestep_end'
    []
    [norm_power_density_avg]
        type = ElementAverageValue
        variable = bison_norm_power_density
        #use_displaced_mesh = true # check
        block = fuel
        execute_on = 'initial timestep_end'
    []
    [coolant_vol]
        type = VolumePostprocessor
        block = 'coolant'
    []
    [fuel_vol]
        type = VolumePostprocessor
        block = 'fuel'
    []
    [intref_vol]
        type = VolumePostprocessor
        block = 'int_ref'
    []
    [clad_vol]
        type = VolumePostprocessor
        block = 'clad'
    []
    [ceramic_vol]
        type = VolumePostprocessor
        block = 'ceramic'
    []
[]

# [VectorPostprocessors]
#    # Radial Fuel Power Dist
#     [peak_fuel_radial_pd]
#         type = LineValueSampler
#         start_point = '0.00 0.00 ${fuel_len_half}'
#         end_point = '${fuel_radius} 0.00 ${fuel_len_half}'
#         variable = bison_power_density
#         num_points = 15
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     # Radial Fuel Temp Dist
#     [peak_fuel_radial_temp]
#         type = LineValueSampler
#         start_point = '0.00 0.00 ${fuel_len_half}'
#         end_point = '${fuel_radius} 0.00 ${fuel_len_half}'
#         variable = bison_temp
#         num_points = 15
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     # Radial Fuel Power Dist
#     [peak_nonfuel_radial_pd]
#         type = LineValueSampler
#         start_point = '${fuel_radius} 0.00 ${fuel_len_half}'
#         end_point = '${clad_radius_outer} 0.00 ${fuel_len_half}'
#         variable = bison_power_density
#         num_points = 15
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     # Radial Fuel Temp Dist
#     [peak_nonfuel_radial_temp]
#         type = LineValueSampler
#         start_point = '${fuel_radius} 0.00 ${fuel_len_half}'
#         end_point = '${clad_radius_outer} 0.00 ${fuel_len_half}'
#         variable = bison_temp
#         num_points = 15
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     # Axial Fuel Temp Dist
#     [fuel_axial_temp]
#         type = LineValueSampler
#         start_point = '0.00 0.00 0.00'
#         end_point = '0.00 0.00 ${fuel_len}'
#         variable = bison_temp
#         num_points = 100
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     # Axial Fuel Temp Dist
#     [fuel_axial_pd]
#         type = LineValueSampler
#         start_point = '0.00 0.00 0.00'
#         end_point = '0.00 0.00 ${fuel_len}'
#         variable = bison_power_density
#         num_points = 100
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
#     [T_inf_dist]
#         type = LineValueSampler
#         start_point = '${clad_radius_outer} 0.00 0.00'
#         end_point = '${clad_radius_outer} 0.00 ${fuel_len}'
#         variable = aux_T_inf
#         num_points = 22
#         sort_by = 'id'
#         #execute_on = 'initial timestep_end'
#     []
# []

[Outputs]
    exodus = true
    [csv]
        type = CSV
    []
[]