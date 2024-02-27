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

num_coolreg = 8
num_coolreg_back = 8
num_layers_fuel = 40
num_layers_refl = 8
numside = 6

linearpower = 27466.11572112955 # W/m
inlet_T = 693.15                # K
#fuelconductance = 1.882         # W/m/K
cladconductance = 21.6          # W/m/K
gapconductance = 0.251          # W/m/K

bid_gapc = 9
bid_gap = 1
bid_fl  = 100
bid_clad = 2
bid_cool = 4
bid_duct = 3
bid_lrfl = 5
bid_urfl = 6
bid_lrflc = 7
bid_urflc = 8

half_asmpitch = ${fparse flat_to_flat / 2 + duct_thickness}
powerdensity = ${fparse linearpower / (pi * (fuel_r_o * fuel_r_o - fuel_r_i * fuel_r_i))}

[Mesh]
  # These make the 7 unique pins
  [./P]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '${numside} ${numside} ${numside} ${numside} ${numside} ${numside}'
    polygon_size = ${half_pinpitch}
    ring_radii = '${gap_i} ${fuel_r_i} ${fuel_r_o} ${clad_r}'  # he-fuel, fuel-clad, clad-pb
    ring_intervals = '1 6 10 6'
    ring_block_ids = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad}'
    background_intervals = ${num_coolreg}
    background_block_ids = ${bid_cool}
    preserve_volumes = on
    quad_center_elements = false

  []
  # This assembles the 7 pins into an assembly with a duct
  [./hex_assembly]
    type = HexIDPatternedMeshGenerator
    inputs = 'P'
    pattern_boundary = hexagon
    assign_type = 'pattern'  # assigns pin_id 0-6 according to pattern below
    id_name = 'pin_id'
    background_intervals = ${num_coolreg_back}
    hexagon_size = ${half_asmpitch}  # this is the apothem = 1/2*flat-flat + 1*duct wall)
    duct_sizes = ${fparse flat_to_flat/2}
    duct_sizes_style = apothem
    duct_intervals = '10'
    background_block_id = ${bid_cool}
    duct_block_ids = ${bid_duct}
    external_boundary_id = 997
    pattern = '0    0;
             0   0    0;
               0    0'

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
    subdomain_swaps = '${bid_gapc} ${bid_lrflc} ${bid_gap} ${bid_lrfl} ${bid_clad} ${bid_lrfl} ${bid_duct} ${bid_duct} ${bid_cool} ${bid_cool}  ${bid_fl} ${bid_lrfl};
                       ${bid_gapc} ${bid_gapc}  ${bid_gap} ${bid_gap}  ${bid_clad} ${bid_clad} ${bid_duct} ${bid_duct} ${bid_cool} ${bid_cool}  ${bid_fl} ${bid_fl}  ;
                       ${bid_gapc} ${bid_urflc} ${bid_gap} ${bid_urfl} ${bid_clad} ${bid_urfl} ${bid_duct} ${bid_duct} ${bid_cool} ${bid_cool}  ${bid_fl} ${bid_urfl}'

  []

  # This renames sidesets to common sensical names
  [rename_sidesets]
    type = RenameBoundaryGenerator
    input = extrude
    old_boundary = '7        DuctLeadInterface 998          999             997'
    new_boundary = 'ROD_SIDE DUCT_INNERSIDE    ASSEMBLY_TOP ASSEMBLY_BOTTOM ASSEMBLY_SIDE'
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
