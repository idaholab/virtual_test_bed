half_pinpitch = 0.0067123105    # m
fuel_r_o = 0.004318648          # m
fuel_r_i = 0.00202042           # m
gap_i = ${fparse fuel_r_i * 0.25}
clad_r = 0.0054037675           # m
duct_thickness = 0.0035327      # m
flat_to_flat = 0.037164         # m
activefuelheight = 1.06072      # m
lowerreflectorheight = 0.2      # m
upperreflectorheight = 0.2      # m

num_coolreg = 2
num_coolreg_back = 2
num_layers_fuel = 20
num_layers_refl = 4
numside=6

linearpower = 27466.11572112955 # W/m
inlet_T = 693.15                # K
fuelconductance = 1.882        # W/m/K
#cladconductance = 21.6         # W/m/K

mid_gap = 1
mid_ifl = 2
mid_ofl = 3
mid_clad = 4
mid_cool = 5
mid_duct = 6

bid_gapc = 9
bid_gap = 1
bid_ifl = 100
bid_ofl1 = 101
bid_ofl2 = 102
bid_ofl3 = 103
bid_ofl4 = 104
bid_ofl5 = 105
bid_ofl6 = 106
bid_clad = 2
bid_cool = 4
bid_duct = 3

bid_gapcl = 1000
bid_gapl  = 1001
bid_ifll  = 1002
bid_ofl1l = 1003
bid_ofl2l = 1004
bid_ofl3l = 1005
bid_ofl4l = 1006
bid_ofl5l = 1007
bid_ofl6l = 1008
bid_cladl = 1009

bid_gapch = 2000
bid_gaph  = 2001
bid_iflh  = 2002
bid_ofl1h = 2003
bid_ofl2h = 2004
bid_ofl3h = 2005
bid_ofl4h = 2006
bid_ofl5h = 2007
bid_ofl6h = 2008
bid_cladh = 2009

#bid_lrfl = 5
#bid_urfl = 6
#bid_lrflc = 7
#bid_urflc = 8

# === derived
half_asmpitch = ${fparse flat_to_flat / 2 + duct_thickness}
coolantdensity_ref = ${fparse 10678-13174*(inlet_T-600.6)/10000} # kg/m^3

richardsonreltol=1E-3
richardsonabstol=1E+3
maxinnerits=1
maxfixptits=100000
richardsonmaxits=1000

#==============================================================

# material_id 1: helium gap  | block_id 1
#             2: inner fuel             100
#             3: outer fuel             101 102 103 104 105 106
#             4: clad                   2
#             5: coolant                4
#             6: duct                   3
#             4: reflector(clad)        5, 6

[Mesh]
  # These make the 7 unique pins
  [./P000]
    type = PolygonConcentricCircleMeshGenerator 
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ifl} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P001]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl1} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P002]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl2} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P003]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl3} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P004]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl4} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P005]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl5} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []
  [./P006]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 1 3 1'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_ofl6} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false
  []

  # This assembles the 7 pins into an assembly with a duct
  [./hex_assembly]
    type = PatternedHexMeshGenerator
    inputs = 'P000 P001 P002 P003 P004 P005 P006'
    pattern_boundary = hexagon
    assign_type = 'pattern'  # assigns pin_id 0-6 according to pattern below
    id_name = 'pin_id'
    background_intervals = ${num_coolreg_back}
    hexagon_size = ${half_asmpitch}  # this is the apothem = 1/2*flat-flat + 1*duct wall)
    duct_sizes = ${fparse flat_to_flat/2}
    duct_sizes_style = apothem
    duct_intervals = '2'
    background_block_id = ${bid_cool}
    duct_block_ids = ${bid_duct}
    external_boundary_id = 997
    pattern = '3    2;
             4   0    1;
               5    6'
  []

  [interface_define]
    input = hex_assembly
    type = SideSetsBetweenSubdomainsGenerator
    new_boundary = DuctLeadInterface
    paired_block = ${bid_cool}
    primary_block = ${bid_duct}
  []

  # This extrudes the 7-pin assembly axially and renames block IDs appropriately
  [./extrude]
    type = AdvancedExtruderGenerator
    input = interface_define
    heights = '${lowerreflectorheight} ${activefuelheight} ${upperreflectorheight}'
    num_layers = '${num_layers_refl} ${num_layers_fuel} ${num_layers_refl}'
    direction = '0 0 1'
    top_boundary = 998
    bottom_boundary = 999
    subdomain_swaps = '${bid_gapc} ${bid_gapcl} ${bid_gap} ${bid_gapl} ${bid_clad} ${bid_cladl}  ${bid_duct} ${bid_duct}  ${bid_cool} ${bid_cool}  ${bid_ifl} ${bid_ifll} ${bid_ofl1} ${bid_ofl1l} ${bid_ofl2} ${bid_ofl2l} ${bid_ofl3} ${bid_ofl3l} ${bid_ofl4} ${bid_ofl4l} ${bid_ofl5} ${bid_ofl5l} ${bid_ofl6} ${bid_ofl6l};
                       ${bid_gapc} ${bid_gapc}  ${bid_gap} ${bid_gap}  ${bid_clad} ${bid_clad}   ${bid_duct} ${bid_duct}  ${bid_cool} ${bid_cool}  ${bid_ifl} ${bid_ifl}  ${bid_ofl1} ${bid_ofl1}  ${bid_ofl2} ${bid_ofl2}  ${bid_ofl3} ${bid_ofl3}  ${bid_ofl4} ${bid_ofl4}  ${bid_ofl5} ${bid_ofl5}  ${bid_ofl6} ${bid_ofl6};
                       ${bid_gapc} ${bid_gapch} ${bid_gap} ${bid_gaph} ${bid_clad} ${bid_cladh}  ${bid_duct} ${bid_duct}  ${bid_cool} ${bid_cool}  ${bid_ifl} ${bid_iflh} ${bid_ofl1} ${bid_ofl1h} ${bid_ofl2} ${bid_ofl2h} ${bid_ofl3} ${bid_ofl3h} ${bid_ofl4} ${bid_ofl4h} ${bid_ofl5} ${bid_ofl5h} ${bid_ofl6} ${bid_ofl6h}'
  []

  # This renames sidesets to common sensical names
  [rename_sidesets]
    type = RenameBoundaryGenerator
    input = extrude
    old_boundary = '7        DuctLeadInterface 998          999             997'
    new_boundary = 'ROD_SIDE DUCT_INNERSIDE    ASSEMBLY_TOP ASSEMBLY_BOTTOM ASSEMBLY_SIDE'
  []

  [assign]  
    type = SubdomainExtraElementIDGenerator
    input = rename_sidesets
    extra_element_id_names = 'material_id'
    subdomains =        '${bid_gapc} ${bid_gap} ${bid_clad} ${bid_ifl} ${bid_ofl1} ${bid_ofl2} ${bid_ofl3} ${bid_ofl4} ${bid_ofl5} ${bid_ofl6} ${bid_gapcl} ${bid_gapl} ${bid_cladl} ${bid_ifll} ${bid_ofl1l} ${bid_ofl2l} ${bid_ofl3l} ${bid_ofl4l} ${bid_ofl5l} ${bid_ofl6l} ${bid_gapch} ${bid_gaph} ${bid_cladh} ${bid_iflh} ${bid_ofl1h} ${bid_ofl2h} ${bid_ofl3h} ${bid_ofl4h} ${bid_ofl5h} ${bid_ofl6h} ${bid_duct} ${bid_cool}'
    extra_element_ids = '${mid_gap}  ${mid_gap} ${mid_clad} ${mid_ifl} ${mid_ofl}  ${mid_ofl}  ${mid_ofl}  ${mid_ofl}  ${mid_ofl}  ${mid_ofl}  ${mid_clad}  ${mid_clad} ${mid_clad}  ${mid_clad} ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad} ${mid_clad}  ${mid_clad} ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_clad}  ${mid_duct} ${mid_cool}'
  []

  [Pcm]
    type = PolygonConcentricCircleMeshGenerator 
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1'
    ring_block_ids = '1'
    background_intervals = '1'
    background_block_ids = '2'
    preserve_volumes = on
    quad_center_elements = false
  []

  # This assembles the 7 pins into an assembly with a duct
  [Acm]
    type = PatternedHexMeshGenerator
    inputs = 'Pcm'
    pattern_boundary = hexagon
    assign_type = 'pattern'  # assigns pin_id 0-6 according to pattern below
    id_name = 'pin_id'
    background_intervals = '1'
    hexagon_size = ${half_asmpitch}  # this is the apothem = 1/2*flat-flat + 1*duct wall)
    duct_sizes = ${fparse flat_to_flat/2}
    duct_sizes_style = apothem
    duct_intervals = '2'
    background_block_id = '2'
    duct_block_ids = ${bid_duct}
    external_boundary_id = 997
    pattern = '0    0;
             0   0    0;
               0    0'

  []
  [coarse_mesh]
    type = AdvancedExtruderGenerator
    input = Acm
    heights = '${lowerreflectorheight} ${activefuelheight} ${upperreflectorheight}'
    num_layers = '${num_layers_refl} ${num_layers_fuel} ${num_layers_refl}'
    direction = '0 0 1'
    top_boundary = 998
    bottom_boundary = 999
  []

  [cmesh]
    type = CoarseMeshExtraElementIDGenerator
    input = assign
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
  uniform_refine = 0
[]

[Executioner]
  type = Steady
[]

[AuxVariables]
  [var]
  []
[]

[Problem]
  type = FEProblem
  solve = false
[]

[Outputs]
  exodus = true
[]