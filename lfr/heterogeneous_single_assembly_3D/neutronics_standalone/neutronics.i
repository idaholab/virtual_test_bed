# ==============================================================================
# Model description
# Application : Griffin
# ------------------------------------------------------------------------------
# Lemont, ANL, November 14th, 2022
# Author(s): Hansol Park, Emily Shemon
# ==============================================================================
# - LFR 3D Single Assembly Hot Full Power Configuration GRIFFIN neutronics input
# - Single App
# ==============================================================================
# Geometry Info.
# ==============================================================================
half_pinpitch = 0.0067123105    # m
fuel_r_o = 0.004318648          # m
fuel_r_i = 0.00202042           # m
clad_r_i = 0.004495             # m
clad_r_o = 0.0054037675         # m
duct_thickness = 0.003533       # m
asmgap_thickness = 0.0018375    # m
flat_to_flat = 0.153424         # m
half_asmpitch = ${fparse flat_to_flat / 2 + duct_thickness + asmgap_thickness}

# Below are axial coordinates in meter.
hA = 0.1007 # Lower Core Plate
hB = 0.4086 # Inlet Wrapper
hC = 0.4742 # Lower Bundle Grid and Lower Pins Plug
hD = 1.3327 # Lower Gas Plenum
hE = 1.3479 # Lower Thermal Insulator
hF = 2.4086 # Active Fuel Region
hG = 2.4237 # Upper Thermal Insulator
hH = 2.5450 # Upper Gas Plenum
hI = 2.5955 # Upper Bundle Grid and Upper Pins Plug
hJ = 3.5342 # Outlet Wrapper

# Below are heights of each axial zone in meter.
dhA = ${fparse hA - 0.0}
dhB = ${fparse hB - hA}
dhC = ${fparse hC - hB}
dhD = ${fparse hD - hC}
dhE = ${fparse hE - hD}
dhF = ${fparse hF - hE}
dhG = ${fparse hG - hF}
dhH = ${fparse hH - hG}
dhI = ${fparse hI - hH}
dhJ = ${fparse hJ - hI}

# Below are the numbers of axial meshes per axial zone.
num_axmeshA = 1
num_axmeshB = 3
num_axmeshC = 1
num_axmeshD = 9
num_axmeshE = 1
num_axmeshF = 20
num_axmeshG = 1
num_axmeshH = 2
num_axmeshI = 1
num_axmeshJ = 9

# ==============================================================================
# Library IDs
# ==============================================================================
lid_A = 1
lid_B = 2
lid_C = 3
lid_D = 4
lid_E = 5
lid_G = 6
lid_H = 7
lid_I = 8
lid_J = 9
lid_F_lead = 11
lid_F_fuel_R1 = 12
lid_F_fuel_R2 = 13
lid_F_fuel_R3 = 14
lid_F_fuel_R4 = 15
lid_F_fuel_R5 = 16
lid_F_fuel_R6 = 17
lid_F_fuel_R7 = 18
lid_F_clad = 19
lid_F_duct = 20
lid_F_leadgap = 21

# ==============================================================================
# Material IDs
# ==============================================================================
mid_A = 100 # lid_A
mid_B = 200 # lid_B
mid_C = 300 # lid_C

# lid_D
mid_D_lead = 410
mid_D_clad = 420
mid_D_duct = 430
mid_D_tubemix = 440 # Plenum tube + Helium mixture

# lid_E
mid_E_lead = 510
mid_E_clad = 520
mid_E_duct = 530
mid_E_yszmix = 540 # YSZ + Helium mixture

mid_F_lead = 620    # lid_F_lead
mid_F_helium = 610  # lid_fuel_R1
mid_F_fuel_R1 = 601 # lid_fuel_R1
mid_F_fuel_R2 = 602 # lid_fuel_R2
mid_F_fuel_R3 = 603 # lid_fuel_R3
mid_F_fuel_R4 = 604 # lid_fuel_R4
mid_F_fuel_R5 = 605 # lid_fuel_R5
mid_F_fuel_R6 = 606 # lid_fuel_R6
mid_F_fuel_R7 = 607 # lid_fuel_R7
mid_F_clad = 640    # lid_F_clad
mid_F_duct = 650    # lid_F_duct
mid_F_leadgap = 630 # lid_F_leadgap

# lid_G
mid_G_lead = 710
mid_G_clad = 720
mid_G_duct = 730
mid_G_yszmix = 740 # YSZ + Helium mixture

# lid_H
mid_H_lead = 810
mid_H_clad = 820
mid_H_duct = 830
mid_H_springmix = 840 # Spring + Helium mixture

mid_I = 900  # lid_I
mid_J = 1000 # lid_J

# ==============================================================================
# Block IDs
# ==============================================================================
bid_A = 100
bid_B = 200
bid_C = 300
bid_I = 900
bid_J = 1000
bid_Ac = 101
bid_Bc = 201
bid_Cc = 301
bid_Ic = 901
bid_Jc = 1001

bid_D_lead = 410
bid_D_clad = 420
bid_D_duct = 430
bid_D_tubemix = 440 # Plenum tube + Helium mixture
bid_D_tubemixc = 441 # Plenum tube + Helium mixture

bid_E_lead = 510
bid_E_clad = 520
bid_E_duct = 530
bid_E_yszmix = 540 # YSZ + Helium mixture
bid_E_yszmixc = 541 # YSZ + Helium mixture

bid_F_fuel_R1 = 601
bid_F_fuel_R2 = 602
bid_F_fuel_R3 = 603
bid_F_fuel_R4 = 604
bid_F_fuel_R5 = 605
bid_F_fuel_R6 = 606
bid_F_fuel_R7 = 607
bid_F_helium = 610
bid_F_heliumc = 611
bid_F_lead = 620
bid_F_leadgap = 630
bid_F_clad = 640
bid_F_duct = 650

bid_G_lead = 710
bid_G_clad = 720
bid_G_duct = 730
bid_G_yszmix = 740 # YSZ + Helium mixture
bid_G_yszmixc = 741 # YSZ + Helium mixture

bid_H_lead = 810
bid_H_clad = 820
bid_H_duct = 830
bid_H_springmix = 840 # Spring + Helium mixture
bid_H_springmixc = 841 # Spring + Helium mixture

# ==============================================================================
# Power
# ==============================================================================
totalpower = 3700000.0 # W

# ==============================================================================
# Mesh
# ==============================================================================
[Mesh]
  [Pin1]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R1} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin2]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R2} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin3]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R3} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin4]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R4} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin5]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R5} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin6]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R6} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []
  [Pin7]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${fuel_r_i} ${fuel_r_o} ${clad_r_i} ${clad_r_o}'
    ring_intervals = '1 1 1 1'
    ring_block_ids = '${bid_F_heliumc} ${bid_F_fuel_R7} ${bid_F_helium} ${bid_F_clad}'
    background_intervals = 1
    background_block_ids = ${bid_F_lead}
    preserve_volumes = on
    quad_center_elements = false
  []

  # This assembles the 7 pins into an assembly with a duct
  [ASM]
    type = HexIDPatternedMeshGenerator
    inputs = 'Pin1 Pin2 Pin3 Pin4 Pin5 Pin6 Pin7'
    pattern_boundary = hexagon
    hexagon_size = ${half_asmpitch}
    background_intervals = 1
    background_block_id = '${fparse bid_F_lead + 1}' # To generate pin_ids correctly
    duct_sizes = '${fparse flat_to_flat/2} ${fparse flat_to_flat/2 + duct_thickness}'
    duct_intervals = '1 1'
    duct_block_ids = '${bid_F_duct} ${bid_F_leadgap}'
    duct_sizes_style = apothem
    external_boundary_id = 997
    assign_type = 'cell' # different pin_id for different pins
    pattern = '6 6 6 6 6 6 6;
              6 5 5 5 5 5 5 6;
             6 5 4 4 4 4 4 5 6;
            6 5 4 3 3 3 3 4 5 6;
           6 5 4 3 2 2 2 3 4 5 6;
          6 5 4 3 2 1 1 2 3 4 5 6;
         6 5 4 3 2 1 0 1 2 3 4 5 6;
          6 5 4 3 2 1 1 2 3 4 5 6;
           6 5 4 3 2 2 2 3 4 5 6;
            6 5 4 3 3 3 3 4 5 6;
             6 5 4 4 4 4 4 5 6;
              6 5 5 5 5 5 5 6;
               6 6 6 6 6 6 6'
    id_name = 'pin_id'
  []

  [interface_define]
    input = ASM
    type = SideSetsBetweenSubdomainsGenerator
    new_boundary = DuctLeadInterface
    paired_block = ${fparse bid_F_lead + 1}
    primary_block = ${bid_F_duct}
  []

  # This extrudes the 7-pin assembly axially and renames block IDs appropriately
  [extrude]
    type = AdvancedExtruderGenerator
    input = interface_define
    direction = '0 0 1'
    top_boundary = 998
    bottom_boundary = 999
    heights = '${dhA} ${dhB} ${dhC} ${dhD} ${dhE} ${dhF} ${dhG} ${dhH} ${dhI} ${dhJ}'
    num_layers = '${num_axmeshA} ${num_axmeshB} ${num_axmeshC} ${num_axmeshD} ${num_axmeshE} ${num_axmeshF} ${num_axmeshG} ${num_axmeshH} ${num_axmeshI} ${num_axmeshJ}'
    subdomain_swaps = '${bid_F_fuel_R1} ${bid_A}           ${bid_F_fuel_R2} ${bid_A}           ${bid_F_fuel_R3} ${bid_A}           ${bid_F_fuel_R4} ${bid_A}           ${bid_F_fuel_R5} ${bid_A}           ${bid_F_fuel_R6} ${bid_A}           ${bid_F_fuel_R7} ${bid_A}           ${bid_F_heliumc}  ${bid_Ac}           ${bid_F_helium}  ${bid_A}            ${bid_F_lead} ${bid_A}       ${fparse bid_F_lead + 1} ${bid_A}       ${bid_F_leadgap} ${bid_A}         ${bid_F_clad} ${bid_A}       ${bid_F_duct} ${bid_A};
                       ${bid_F_fuel_R1} ${bid_B}           ${bid_F_fuel_R2} ${bid_B}           ${bid_F_fuel_R3} ${bid_B}           ${bid_F_fuel_R4} ${bid_B}           ${bid_F_fuel_R5} ${bid_B}           ${bid_F_fuel_R6} ${bid_B}           ${bid_F_fuel_R7} ${bid_B}           ${bid_F_heliumc}  ${bid_Bc}           ${bid_F_helium}  ${bid_B}            ${bid_F_lead} ${bid_B}       ${fparse bid_F_lead + 1} ${bid_B}       ${bid_F_leadgap} ${bid_B}         ${bid_F_clad} ${bid_B}       ${bid_F_duct} ${bid_B};
                       ${bid_F_fuel_R1} ${bid_C}           ${bid_F_fuel_R2} ${bid_C}           ${bid_F_fuel_R3} ${bid_C}           ${bid_F_fuel_R4} ${bid_C}           ${bid_F_fuel_R5} ${bid_C}           ${bid_F_fuel_R6} ${bid_C}           ${bid_F_fuel_R7} ${bid_C}           ${bid_F_heliumc}  ${bid_Cc}           ${bid_F_helium}  ${bid_C}            ${bid_F_lead} ${bid_C}       ${fparse bid_F_lead + 1} ${bid_C}       ${bid_F_leadgap} ${bid_C}         ${bid_F_clad} ${bid_C}       ${bid_F_duct} ${bid_C};
                       ${bid_F_fuel_R1} ${bid_D_tubemix}   ${bid_F_fuel_R2} ${bid_D_tubemix}   ${bid_F_fuel_R3} ${bid_D_tubemix}   ${bid_F_fuel_R4} ${bid_D_tubemix}   ${bid_F_fuel_R5} ${bid_D_tubemix}   ${bid_F_fuel_R6} ${bid_D_tubemix}   ${bid_F_fuel_R7} ${bid_D_tubemix}   ${bid_F_heliumc}  ${bid_D_tubemixc}   ${bid_F_helium}  ${bid_D_tubemix}    ${bid_F_lead} ${bid_D_lead}  ${fparse bid_F_lead + 1} ${bid_D_lead}  ${bid_F_leadgap} ${bid_D_lead}    ${bid_F_clad} ${bid_D_clad}  ${bid_F_duct} ${bid_D_duct};
                       ${bid_F_fuel_R1} ${bid_E_yszmix}    ${bid_F_fuel_R2} ${bid_E_yszmix}    ${bid_F_fuel_R3} ${bid_E_yszmix}    ${bid_F_fuel_R4} ${bid_E_yszmix}    ${bid_F_fuel_R5} ${bid_E_yszmix}    ${bid_F_fuel_R6} ${bid_E_yszmix}    ${bid_F_fuel_R7} ${bid_E_yszmix}    ${bid_F_heliumc}  ${bid_E_yszmixc}    ${bid_F_helium}  ${bid_E_yszmix}     ${bid_F_lead} ${bid_E_lead}  ${fparse bid_F_lead + 1} ${bid_E_lead}  ${bid_F_leadgap} ${bid_E_lead}    ${bid_F_clad} ${bid_E_clad}  ${bid_F_duct} ${bid_E_duct};
                       ${bid_F_fuel_R1} ${bid_F_fuel_R1}   ${bid_F_fuel_R2} ${bid_F_fuel_R2}   ${bid_F_fuel_R3} ${bid_F_fuel_R3}   ${bid_F_fuel_R4} ${bid_F_fuel_R4}   ${bid_F_fuel_R5} ${bid_F_fuel_R5}   ${bid_F_fuel_R6} ${bid_F_fuel_R6}   ${bid_F_fuel_R7} ${bid_F_fuel_R7}   ${bid_F_heliumc}  ${bid_F_heliumc}    ${bid_F_helium}  ${bid_F_helium}     ${bid_F_lead} ${bid_F_lead}  ${fparse bid_F_lead + 1} ${bid_F_lead}  ${bid_F_leadgap} ${bid_F_leadgap} ${bid_F_clad} ${bid_F_clad}  ${bid_F_duct} ${bid_F_duct};
                       ${bid_F_fuel_R1} ${bid_G_yszmix}    ${bid_F_fuel_R2} ${bid_G_yszmix}    ${bid_F_fuel_R3} ${bid_G_yszmix}    ${bid_F_fuel_R4} ${bid_G_yszmix}    ${bid_F_fuel_R5} ${bid_G_yszmix}    ${bid_F_fuel_R6} ${bid_G_yszmix}    ${bid_F_fuel_R7} ${bid_G_yszmix}    ${bid_F_heliumc}  ${bid_G_yszmixc}    ${bid_F_helium}  ${bid_G_yszmix}     ${bid_F_lead} ${bid_G_lead}  ${fparse bid_F_lead + 1} ${bid_G_lead}  ${bid_F_leadgap} ${bid_G_lead}    ${bid_F_clad} ${bid_G_clad}  ${bid_F_duct} ${bid_G_duct};
                       ${bid_F_fuel_R1} ${bid_H_springmix} ${bid_F_fuel_R2} ${bid_H_springmix} ${bid_F_fuel_R3} ${bid_H_springmix} ${bid_F_fuel_R4} ${bid_H_springmix} ${bid_F_fuel_R5} ${bid_H_springmix} ${bid_F_fuel_R6} ${bid_H_springmix} ${bid_F_fuel_R7} ${bid_H_springmix} ${bid_F_heliumc}  ${bid_H_springmixc} ${bid_F_helium}  ${bid_H_springmix}  ${bid_F_lead} ${bid_H_lead}  ${fparse bid_F_lead + 1} ${bid_H_lead}  ${bid_F_leadgap} ${bid_H_lead}    ${bid_F_clad} ${bid_H_clad}  ${bid_F_duct} ${bid_H_duct};
                       ${bid_F_fuel_R1} ${bid_I}           ${bid_F_fuel_R2} ${bid_I}           ${bid_F_fuel_R3} ${bid_I}           ${bid_F_fuel_R4} ${bid_I}           ${bid_F_fuel_R5} ${bid_I}           ${bid_F_fuel_R6} ${bid_I}           ${bid_F_fuel_R7} ${bid_I}           ${bid_F_heliumc}  ${bid_Ic}           ${bid_F_helium}  ${bid_I}            ${bid_F_lead} ${bid_I}       ${fparse bid_F_lead + 1} ${bid_I}       ${bid_F_leadgap} ${bid_I}         ${bid_F_clad} ${bid_I}       ${bid_F_duct} ${bid_I};
                       ${bid_F_fuel_R1} ${bid_J}           ${bid_F_fuel_R2} ${bid_J}           ${bid_F_fuel_R3} ${bid_J}           ${bid_F_fuel_R4} ${bid_J}           ${bid_F_fuel_R5} ${bid_J}           ${bid_F_fuel_R6} ${bid_J}           ${bid_F_fuel_R7} ${bid_J}           ${bid_F_heliumc}  ${bid_Jc}           ${bid_F_helium}  ${bid_J}            ${bid_F_lead} ${bid_J}       ${fparse bid_F_lead + 1} ${bid_J}       ${bid_F_leadgap} ${bid_J}         ${bid_F_clad} ${bid_J}       ${bid_F_duct} ${bid_J}'
  []

  # This renames sidesets to common sensical names
  [rename_sidesets]
    type = RenameBoundaryGenerator
    input = extrude
    old_boundary = '3        DuctLeadInterface 998          999             997'
    new_boundary = 'ROD_SIDE DUCT_INNERSIDE    ASSEMBLY_TOP ASSEMBLY_BOTTOM ASSEMBLY_SIDE'
  []

  [assign]
    type = SubdomainExtraElementIDGenerator
    input = rename_sidesets
    extra_element_id_names = 'material_id'
    subdomains =        '${bid_A} ${bid_Ac} ${bid_B} ${bid_Bc} ${bid_C} ${bid_Cc} ${bid_D_lead} ${bid_D_clad} ${bid_D_duct} ${bid_D_tubemix} ${bid_D_tubemixc} ${bid_E_lead} ${bid_E_clad} ${bid_E_duct} ${bid_E_yszmix} ${bid_E_yszmixc} ${bid_F_fuel_R1} ${bid_F_fuel_R2} ${bid_F_fuel_R3} ${bid_F_fuel_R4} ${bid_F_fuel_R5} ${bid_F_fuel_R6} ${bid_F_fuel_R7} ${bid_F_heliumc} ${bid_F_helium} ${bid_F_lead} ${bid_F_leadgap} ${bid_F_clad} ${bid_F_duct} ${bid_G_lead} ${bid_G_clad} ${bid_G_duct} ${bid_G_yszmix} ${bid_G_yszmixc} ${bid_H_lead} ${bid_H_clad} ${bid_H_duct} ${bid_H_springmix} ${bid_H_springmixc} ${bid_I} ${bid_Ic} ${bid_J} ${bid_Jc}'
    extra_element_ids = '${mid_A} ${mid_A}  ${mid_B} ${mid_B}  ${mid_C} ${mid_C}  ${mid_D_lead} ${mid_D_clad} ${mid_D_duct} ${mid_D_tubemix} ${mid_D_tubemix}  ${mid_E_lead} ${mid_E_clad} ${mid_E_duct} ${mid_E_yszmix} ${mid_E_yszmix}  ${mid_F_fuel_R1} ${mid_F_fuel_R2} ${mid_F_fuel_R3} ${mid_F_fuel_R4} ${mid_F_fuel_R5} ${mid_F_fuel_R6} ${mid_F_fuel_R7} ${mid_F_helium}  ${mid_F_helium} ${mid_F_lead} ${mid_F_leadgap} ${mid_F_clad} ${mid_F_duct} ${mid_G_lead} ${mid_G_clad} ${mid_G_duct} ${mid_G_yszmix} ${mid_G_yszmix}  ${mid_H_lead} ${mid_H_clad} ${mid_H_duct} ${mid_H_springmix} ${mid_H_springmix}  ${mid_I} ${mid_I}  ${mid_J} ${mid_J}'
  []

  [PinIn_CM]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    background_intervals = '1'
    background_block_ids = '1'
    preserve_volumes = on
    quad_center_elements = false
  []

  [PinOut_CM]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '2 2 2 2 2 2'
    polygon_size = ${half_pinpitch}
    ring_radii = '${clad_r_o}'
    ring_intervals = '1'
    ring_block_ids = '2'
    background_intervals = '1'
    background_block_ids = '3'
    preserve_volumes = on
    quad_center_elements = false
  []

  # This assembles the 7 pins into an assembly with a duct
  [ASM_CM]
    type = PatternedHexMeshGenerator
    inputs = 'PinIn_CM PinOut_CM'
    pattern_boundary = hexagon
    background_intervals = '1'
    hexagon_size = ${half_asmpitch}
    duct_sizes = '${fparse flat_to_flat/2} ${fparse flat_to_flat/2 + duct_thickness}'
    duct_sizes_style = apothem
    duct_intervals = '1 1'
    background_block_id = '4'
    duct_block_ids = '5 6'
    external_boundary_id = 997
    pattern = '1 1 1 1 1 1 1;
              1 0 0 0 0 0 0 1;
             1 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 1;
           1 0 0 0 0 0 0 0 0 0 1;
          1 0 0 0 0 0 0 0 0 0 0 1;
         1 0 0 0 0 0 0 0 0 0 0 0 1;
          1 0 0 0 0 0 0 0 0 0 0 1;
           1 0 0 0 0 0 0 0 0 0 1;
            1 0 0 0 0 0 0 0 0 1;
             1 0 0 0 0 0 0 0 1;
              1 0 0 0 0 0 0 1;
               1 1 1 1 1 1 1'
  []
  [coarse_mesh]
    type = AdvancedExtruderGenerator
    input = ASM_CM
    heights = '${dhA} ${dhB} ${dhC} ${dhD} ${dhE} ${dhF} ${dhG} ${dhH} ${dhI} ${dhJ}'
    num_layers = '${num_axmeshA} ${num_axmeshB} ${num_axmeshC} ${num_axmeshD} ${num_axmeshE} ${num_axmeshF} ${num_axmeshG} ${num_axmeshH} ${num_axmeshI} ${num_axmeshJ}'
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

# ==============================================================================
# Transport Systems
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 9
  VacuumBoundary = 'ASSEMBLY_TOP ASSEMBLY_BOTTOM'
  ReflectingBoundary = 'ASSEMBLY_SIDE'
  [sn]
    scheme = DFEM-SN
    family = L2_LAGRANGE
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 1
    using_array_variable = true
    collapse_scattering  = true
  []
[]

# ==============================================================================
# Executioner
# ==============================================================================
[Executioner]
  type = SweepUpdate
  verbose = true

  richardson_rel_tol = 1e-4
  richardson_max_its = 500
  richardson_value = 'eigenvalue'
  inner_solve_type = SI
  max_inner_its = 7

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
[]

# ==============================================================================
# Flux Normalization for Total Power
# ==============================================================================
[PowerDensity]
  power = ${totalpower}
  power_density_variable = power_density
[]

# ==============================================================================
# Fuel pin-wise and axial mesh-wise power output
# ==============================================================================
[AuxVariables]
  [volume]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = 1
  []
  [x_coord]
    family = LAGRANGE
    order = FIRST
    [InitialCondition]
      type = FunctionIC
      function = x
    []
  []
  [y_coord]
    family = LAGRANGE
    order = FIRST
    [InitialCondition]
      type = FunctionIC
      function = y
    []
  []
[]

[VectorPostprocessors]
  [vpp_power]
    type = HexagonalGridVariableIntegral
    variable = 'volume x_coord y_coord power_density'
    print_on_screen = false
    center_point = '0.0 0.0'
    pitch = ${fparse 2.0 * half_pinpitch}
    rotation = 30
    execute_on = 'timestep_end'
    block = '${bid_F_fuel_R1} ${bid_F_fuel_R2} ${bid_F_fuel_R3} ${bid_F_fuel_R4} ${bid_F_fuel_R5} ${bid_F_fuel_R6} ${bid_F_fuel_R7}'
    num_rings = 7
    z_layers = "${hE} 1.400935 1.45397 1.507005 1.56004 1.613075 1.66611 1.719145 1.77218 1.825215 1.87825 1.931285 1.98432 2.037355 2.09039 2.143425 2.19646 2.249495 2.30253 2.355565 ${hF}"
  []
[]

[Outputs]
  [console]
    type = Console
    outlier_variable_norms = false
  []
  [pgraph]
    type = PerfGraphOutput
    level = 2
  []
  csv = true
  execute_on = 'timestep_end'
[]

# ==============================================================================
# Material assignment and cross section library
# ==============================================================================
[GlobalParams]
  library_file = '../cross_section/LFR_127Pin_9g.xml'
  library_name = ISOTXS-neutron
  is_meter = true
  plus = true
  dbgmat = false
  grid_names = 'Tfuel'
  grid = '1'
  maximum_diffusion_coefficient = 1000
[]

[Materials]
  [Fuel_Ring1_Hole]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R1} ${bid_F_heliumc} ${bid_F_helium}'
    library_id = '${lid_F_fuel_R1}'
    materials = '
     Fuel_Hole ${mid_F_helium}
       HE4:2.512611E-05;

     Fuel_Ring1 ${mid_F_fuel_R1}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring2]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R2}'
    library_id = '${lid_F_fuel_R2}'
    materials = '
     Fuel_Ring2 ${mid_F_fuel_R2}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring3]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R3}'
    library_id = '${lid_F_fuel_R3}'
    materials = '
     Fuel_Ring3 ${mid_F_fuel_R3}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring4]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R4}'
    library_id = '${lid_F_fuel_R4}'
    materials = '
     Fuel_Ring4 ${mid_F_fuel_R4}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring5]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R5}'
    library_id = '${lid_F_fuel_R5}'
    materials = '
     Fuel_Ring5 ${mid_F_fuel_R5}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring6]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R6}'
    library_id = '${lid_F_fuel_R6}'
    materials = '
     Fuel_Ring6 ${mid_F_fuel_R6}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Ring7]
    type = MicroNeutronicsMaterial
    block = '${bid_F_fuel_R7}'
    library_id = '${lid_F_fuel_R7}'
    materials = '
     Fuel_Ring7 ${mid_F_fuel_R7}
       U234:1.769055E-07
       U235:4.404137E-05
       U238:1.735054E-02
       PU238:1.244939E-05
       PU239:3.413306E-03
       PU240:1.319941E-03
       PU241:8.656869E-05
       PU242:1.234538E-04
       AM241:2.087265E-04
       O16:4.444138E-02'
  []
  [Fuel_Clad]
    type = MicroNeutronicsMaterial
    block = '${bid_F_clad}'
    library_id = '${lid_F_clad}'
    materials = '
     Fuel_Clad ${mid_F_clad}
       FE54:3.185952E-03
       FE56:5.001168E-02
       FE57:1.154947E-03
       FE58:1.537129E-04
       NI58:8.373412E-03
       NI60:3.225451E-03
       NI61:1.402235E-04
       NI62:4.469793E-04
       NI64:1.138947E-04
       CR50:5.643439E-04
       CR52:1.088250E-02
       CR53:1.234043E-03
       CR54:3.071758E-04
       MN55:1.271641E-03
       MO92:1.080550E-04
       MO94:6.735188E-05
       MO95:1.159146E-04
       MO96:1.214544E-04
       MO97:6.953578E-05
       MO98:1.757019E-04
       MO100:7.011875E-05
       SI28:1.300140E-03
       SI29:6.601594E-05
       SI30:4.351798E-05
       C:3.489938E-04
       P31:6.766687E-05
       S32:2.068704E-05
       S33:1.656123E-07
       S34:9.348567E-07
       S36:4.358298E-09
       TI46:3.210951E-05
       TI47:2.895766E-05
       TI48:2.869267E-04
       TI49:2.105602E-05
       TI50:2.016107E-05
       V:2.742873E-05
       ZR90:7.880535E-06
       ZR91:1.718520E-06
       ZR92:2.626878E-06
       ZR94:2.662077E-06
       ZR96:4.288701E-07
       W182:2.014107E-06
       W183:1.087650E-06
       W184:2.337892E-06
       W186:2.160800E-06
       CU63:1.520930E-05
       CU65:6.778986E-06
       CO59:2.370990E-05
       CA40:3.379743E-05
       CA42:2.255696E-07
       CA43:4.706582E-08
       CA44:7.272563E-07
       CA46:1.394535E-09
       CA48:6.519498E-08
       NB93:7.519752E-06
       N14:4.969370E-05
       N15:1.835515E-07
       AL27:2.589280E-05
       TA181:3.861021E-06
       B10:5.144462E-06
       B11:2.070704E-05'
  []
  [Fuel_Lead]
    type = MicroNeutronicsMaterial
    block = '${bid_F_lead}'
    library_id = '${lid_F_lead}'
    materials = '
     Fuel_Lead ${mid_F_lead}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02'
  []
  [Fuel_LeadGap]
    type = MicroNeutronicsMaterial
    block = '${bid_F_leadgap}'
    library_id = '${lid_F_leadgap}'
    materials = '
     Fuel_LeadGap ${mid_F_leadgap}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02'
  []
  [Fuel_Duct]
    type = MicroNeutronicsMaterial
    block = '${bid_F_duct}'
    library_id = '${lid_F_duct}'
    materials = '
     Fuel_Duct ${mid_F_duct}
       FE54:3.192503E-03
       FE56:5.011505E-02
       FE57:1.157401E-03
       FE58:1.540302E-04
       NI58:8.390808E-03
       NI60:3.232103E-03
       NI61:1.405101E-04
       NI62:4.479004E-04
       NI64:1.141301E-04
       CR50:5.655206E-04
       CR52:1.090501E-02
       CR53:1.236601E-03
       CR54:3.078103E-04
       MN55:1.274301E-03
       MO92:1.082801E-04
       MO94:6.749107E-05
       MO95:1.161601E-04
       MO96:1.217001E-04
       MO97:6.968007E-05
       MO98:1.760602E-04
       MO100:7.026407E-05
       SI28:1.302801E-03
       SI29:6.615206E-05
       SI30:4.360804E-05
       C:3.497203E-04
       P31:6.780707E-05
       S32:2.073002E-05
       S33:1.659602E-07
       S34:9.367909E-07
       S36:4.367304E-09
       TI46:3.217603E-05
       TI47:2.901703E-05
       TI48:2.875203E-04
       TI49:2.110002E-05
       TI50:2.020302E-05
       V:2.748603E-05
       ZR90:7.896908E-06
       ZR91:1.722102E-06
       ZR92:2.632303E-06
       ZR94:2.667603E-06
       ZR96:4.297604E-07
       W182:2.018302E-06
       W183:1.089901E-06
       W184:2.342702E-06
       W186:2.165302E-06
       CU63:1.524101E-05
       CU65:6.793007E-06
       CO59:2.375902E-05
       CA40:3.386703E-05
       CA42:2.260402E-07
       CA43:4.716405E-08
       CA44:7.287707E-07
       CA46:1.397401E-09
       CA48:6.533006E-08
       NB93:7.535407E-06
       N14:4.979705E-05
       N15:1.839302E-07
       AL27:2.594703E-05
       TA181:3.869004E-06
       B10:5.155105E-06
       B11:2.075002E-05'
  []
  [LowerCorePlate]
    type = MicroNeutronicsMaterial
    block = '${bid_A} ${bid_Ac}'
    library_id = '${lid_A}'
    materials = '
     LowerCorePlate ${mid_A}
       FE54:2.357119E-03
       FE56:3.700230E-02
       FE57:8.545370E-04
       FE58:1.137209E-04
       NI58:4.964541E-03
       NI60:1.912316E-03
       NI61:8.313568E-05
       NI62:2.650122E-04
       NI64:6.752956E-05
       CR50:4.670038E-04
       CR52:9.005674E-03
       CR53:1.021208E-03
       CR54:2.541921E-04
       MN55:6.804056E-04
       MO92:1.208810E-04
       MO94:7.534562E-05
       MO95:1.296811E-04
       MO96:1.358711E-04
       MO97:7.778964E-05
       MO98:1.965516E-04
       MO100:7.844165E-05
       SI28:6.346952E-04
       SI29:3.222827E-05
       SI30:2.124518E-05
       C:1.414012E-04
       P31:2.963124E-05
       S32:1.501712E-05
       S33:1.202210E-07
       S34:6.786456E-07
       S36:3.163826E-09
       TI46:4.392136E-06
       TI47:3.960833E-06
       TI48:3.924632E-05
       TI49:2.880124E-06
       TI50:2.757723E-06
       V:3.751831E-06
       ZR90:1.077909E-06
       ZR91:2.350719E-07
       ZR92:3.593130E-07
       ZR94:3.641330E-07
       ZR96:5.866348E-08
       W182:2.755023E-07
       W183:1.487712E-07
       W184:3.197926E-07
       W186:2.955624E-07
       CU63:2.080417E-06
       CU65:9.272576E-07
       CO59:3.243027E-06
       CA40:4.622938E-06
       CA42:3.085425E-08
       CA43:6.437853E-09
       CA44:9.947682E-08
       CA46:1.907516E-10
       CA48:8.917673E-09
       NB93:1.028608E-06
       N14:6.797356E-06
       N15:2.510621E-08
       AL27:3.541729E-06
       TA181:5.281244E-07
       B10:7.036758E-07
       B11:2.832423E-06
       PB204:1.170210E-04
       PB206:2.014417E-03
       PB207:1.847215E-03
       PB208:4.379936E-03'
  []
  [InletWrapper]
    type = MicroNeutronicsMaterial
    block = '${bid_B} ${bid_Bc}'
    library_id = '${lid_B}'
    materials = '
     InletWrapper ${mid_B}
       FE54:2.614802E-04
       FE56:4.104560E-03
       FE57:9.479369E-05
       FE58:1.261549E-05
       NI58:6.872268E-04
       NI60:2.647203E-04
       NI61:1.150845E-05
       NI62:3.668443E-05
       NI64:9.347864E-06
       CR50:4.631781E-05
       CR52:8.931848E-04
       CR53:1.012839E-04
       CR54:2.521098E-05
       MN55:1.043741E-04
       MO92:8.868246E-06
       MO94:5.527715E-06
       MO95:9.513671E-06
       MO96:9.967888E-06
       MO97:5.707022E-06
       MO98:1.441956E-05
       MO100:5.754824E-06
       SI28:1.067042E-04
       SI29:5.418111E-06
       SI30:3.571639E-06
       C:2.864312E-05
       P31:5.553616E-06
       S32:1.697766E-06
       S33:1.359253E-08
       S34:7.672599E-08
       S36:3.576939E-10
       TI46:2.635303E-06
       TI47:2.376593E-06
       TI48:2.354892E-05
       TI49:1.728167E-06
       TI50:1.654664E-06
       V:2.251188E-06
       ZR90:6.467752E-07
       ZR91:1.410455E-07
       ZR92:2.155884E-07
       ZR94:2.184885E-07
       ZR96:3.519937E-08
       W182:1.653064E-07
       W183:8.926448E-08
       W184:1.918775E-07
       W186:1.773469E-07
       CU63:1.248249E-06
       CU65:5.563717E-07
       CO59:1.945876E-06
       CA40:2.773808E-06
       CA42:1.851272E-08
       CA43:3.862851E-09
       CA44:5.968833E-08
       CA46:1.144545E-10
       CA48:5.350809E-09
       NB93:6.171741E-07
       N14:4.078559E-06
       N15:1.506459E-08
       AL27:2.125083E-06
       TA181:3.168823E-07
       B10:4.222165E-07
       B11:1.699466E-06
       PB204:3.885751E-04
       PB206:6.688961E-03
       PB207:6.133839E-03
       PB208:1.454357E-02'
  []
  [LowerBundle]
    type = MicroNeutronicsMaterial
    block = '${bid_C} ${bid_Cc}'
    library_id = '${lid_C}'
    materials = '
     LowerBundle ${mid_C}
       FE54:1.251752E-03
       FE56:1.964981E-02
       FE57:4.537988E-04
       FE58:6.039250E-05
       NI58:3.289936E-03
       NI60:1.267252E-03
       NI61:5.509228E-05
       NI62:1.756173E-04
       NI64:4.474985E-05
       CR50:2.217292E-04
       CR52:4.275877E-03
       CR53:4.848501E-04
       CR54:1.206850E-04
       MN55:4.996407E-04
       MO92:4.245476E-05
       MO94:2.646209E-05
       MO95:4.554388E-05
       MO96:4.771797E-05
       MO97:2.732113E-05
       MO98:6.903086E-05
       MO100:2.754914E-05
       SI28:5.108111E-04
       SI29:2.593807E-05
       SI30:1.709871E-05
       C:1.371257E-04
       P31:2.658610E-05
       S32:8.127836E-06
       S33:6.507069E-08
       S34:3.673052E-07
       S36:1.712371E-09
       TI46:1.261552E-05
       TI47:1.137747E-05
       TI48:1.127347E-04
       TI49:8.273042E-06
       TI50:7.921328E-06
       V:1.077645E-05
       ZR90:3.096328E-06
       ZR91:6.752279E-07
       ZR92:1.032143E-06
       ZR94:1.045943E-06
       ZR96:1.685070E-07
       W182:7.913527E-07
       W183:4.273277E-07
       W184:9.185680E-07
       W186:8.489851E-07
       CU63:5.975747E-06
       CU65:2.663510E-06
       CO59:9.315485E-06
       CA40:1.327855E-05
       CA42:8.862667E-08
       CA43:1.849277E-08
       CA44:2.857418E-07
       CA46:5.479227E-10
       CA48:2.561506E-08
       NB93:2.954522E-06
       N14:1.952481E-05
       N15:7.211698E-08
       AL27:1.017342E-05
       TA181:1.516963E-06
       B10:2.021284E-06
       B11:8.135837E-06
       PB204:2.570306E-04
       PB206:4.424583E-03
       PB207:4.057368E-03
       PB208:9.620298E-03'
  []
  [LowerGasPlenum]
    type = MicroNeutronicsMaterial
    block = '${bid_D_lead} ${bid_D_clad} ${bid_D_duct} ${bid_D_tubemix} ${bid_D_tubemixc}'
    library_id = '${lid_D}'
    materials = '
     D_TUBEMIX ${mid_D_tubemix}
       FE54:6.532669E-04
       FE56:1.025499E-02
       FE57:2.368260E-04
       FE58:3.151812E-05
       NI58:1.716934E-03
       NI60:6.613685E-04
       NI61:2.875159E-05
       NI62:9.165281E-05
       NI64:2.335454E-05
       CR50:1.157225E-04
       CR52:2.231534E-03
       CR53:2.530392E-04
       CR54:6.298624E-05
       MN55:2.607607E-04
       MO92:2.215631E-05
       MO94:1.381068E-05
       MO95:2.376862E-05
       MO96:2.490384E-05
       MO97:1.425877E-05
       MO98:3.602700E-05
       MO100:1.437779E-05
       SI28:2.665818E-04
       SI29:1.353663E-05
       SI30:8.923334E-06
       C:7.156191E-05
       P31:1.387470E-05
       S32:4.241824E-06
       S33:3.395960E-08
       S34:1.916872E-07
       S36:8.936736E-10
       TI46:6.584079E-06
       TI47:5.937654E-06
       TI48:5.883443E-05
       TI49:4.317539E-06
       TI50:4.134003E-06
       V:5.624293E-06
       ZR90:1.615914E-06
       ZR91:3.523885E-07
       ZR92:5.386347E-07
       ZR94:5.458561E-07
       ZR96:8.794009E-08
       W182:4.130003E-07
       W183:2.230133E-07
       W184:4.793831E-07
       W186:4.430761E-07
       CU63:3.118706E-06
       CU65:1.390070E-06
       CO59:4.861645E-06
       CA40:6.930147E-06
       CA42:4.625299E-08
       CA43:9.650875E-09
       CA44:1.491290E-07
       CA46:2.859556E-10
       CA48:1.336860E-08
       NB93:1.541900E-06
       N14:1.018998E-05
       N15:3.763731E-08
       AL27:5.309332E-06
       TA181:7.916938E-07
       B10:1.054905E-06
       B11:4.245925E-06
       HE4:1.990687E-05;

     D_Clad ${mid_D_clad}
       FE54:3.185952E-03
       FE56:5.001168E-02
       FE57:1.154947E-03
       FE58:1.537129E-04
       NI58:8.373412E-03
       NI60:3.225451E-03
       NI61:1.402235E-04
       NI62:4.469793E-04
       NI64:1.138947E-04
       CR50:5.643439E-04
       CR52:1.088250E-02
       CR53:1.234043E-03
       CR54:3.071758E-04
       MN55:1.271641E-03
       MO92:1.080550E-04
       MO94:6.735188E-05
       MO95:1.159146E-04
       MO96:1.214544E-04
       MO97:6.953578E-05
       MO98:1.757019E-04
       MO100:7.011875E-05
       SI28:1.300140E-03
       SI29:6.601594E-05
       SI30:4.351798E-05
       C:3.489938E-04
       P31:6.766687E-05
       S32:2.068704E-05
       S33:1.656123E-07
       S34:9.348567E-07
       S36:4.358298E-09
       TI46:3.210951E-05
       TI47:2.895766E-05
       TI48:2.869267E-04
       TI49:2.105602E-05
       TI50:2.016107E-05
       V:2.742873E-05
       ZR90:7.880535E-06
       ZR91:1.718520E-06
       ZR92:2.626878E-06
       ZR94:2.662077E-06
       ZR96:4.288701E-07
       W182:2.014107E-06
       W183:1.087650E-06
       W184:2.337892E-06
       W186:2.160800E-06
       CU63:1.520930E-05
       CU65:6.778986E-06
       CO59:2.370990E-05
       CA40:3.379743E-05
       CA42:2.255696E-07
       CA43:4.706582E-08
       CA44:7.272563E-07
       CA46:1.394535E-09
       CA48:6.519498E-08
       NB93:7.519752E-06
       N14:4.969370E-05
       N15:1.835515E-07
       AL27:2.589280E-05
       TA181:3.861021E-06
       B10:5.144462E-06
       B11:2.070704E-05;

     D_Lead ${mid_D_lead}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02;

     D_Duct ${mid_D_duct}
       FE54:3.192503E-03
       FE56:5.011505E-02
       FE57:1.157401E-03
       FE58:1.540302E-04
       NI58:8.390808E-03
       NI60:3.232103E-03
       NI61:1.405101E-04
       NI62:4.479004E-04
       NI64:1.141301E-04
       CR50:5.655206E-04
       CR52:1.090501E-02
       CR53:1.236601E-03
       CR54:3.078103E-04
       MN55:1.274301E-03
       MO92:1.082801E-04
       MO94:6.749107E-05
       MO95:1.161601E-04
       MO96:1.217001E-04
       MO97:6.968007E-05
       MO98:1.760602E-04
       MO100:7.026407E-05
       SI28:1.302801E-03
       SI29:6.615206E-05
       SI30:4.360804E-05
       C:3.497203E-04
       P31:6.780707E-05
       S32:2.073002E-05
       S33:1.659602E-07
       S34:9.367909E-07
       S36:4.367304E-09
       TI46:3.217603E-05
       TI47:2.901703E-05
       TI48:2.875203E-04
       TI49:2.110002E-05
       TI50:2.020302E-05
       V:2.748603E-05
       ZR90:7.896908E-06
       ZR91:1.722102E-06
       ZR92:2.632303E-06
       ZR94:2.667603E-06
       ZR96:4.297604E-07
       W182:2.018302E-06
       W183:1.089901E-06
       W184:2.342702E-06
       W186:2.165302E-06
       CU63:1.524101E-05
       CU65:6.793007E-06
       CO59:2.375902E-05
       CA40:3.386703E-05
       CA42:2.260402E-07
       CA43:4.716405E-08
       CA44:7.287707E-07
       CA46:1.397401E-09
       CA48:6.533006E-08
       NB93:7.535407E-06
       N14:4.979705E-05
       N15:1.839302E-07
       AL27:2.594703E-05
       TA181:3.869004E-06
       B10:5.155105E-06
       B11:2.075002E-05'
  []
  [LowerInsulator]
    type = MicroNeutronicsMaterial
    block = '${bid_E_lead} ${bid_E_clad} ${bid_E_duct} ${bid_E_yszmix} ${bid_E_yszmixc}'
    library_id = '${lid_E}'
    materials = '
     E_YSZMIX ${mid_E_yszmix}
       ZR90:1.110556E-02
       ZR91:2.421721E-03
       ZR92:3.701685E-03
       ZR94:3.751388E-03
       ZR96:6.043603E-04
       Y89:3.753788E-03
       O16:4.880044E-02
       HE4:2.388520E-06;

     E_CLAD00 ${mid_E_clad}
       FE54:3.185952E-03
       FE56:5.001168E-02
       FE57:1.154947E-03
       FE58:1.537129E-04
       NI58:8.373412E-03
       NI60:3.225451E-03
       NI61:1.402235E-04
       NI62:4.469793E-04
       NI64:1.138947E-04
       CR50:5.643439E-04
       CR52:1.088250E-02
       CR53:1.234043E-03
       CR54:3.071758E-04
       MN55:1.271641E-03
       MO92:1.080550E-04
       MO94:6.735188E-05
       MO95:1.159146E-04
       MO96:1.214544E-04
       MO97:6.953578E-05
       MO98:1.757019E-04
       MO100:7.011875E-05
       SI28:1.300140E-03
       SI29:6.601594E-05
       SI30:4.351798E-05
       C:3.489938E-04
       P31:6.766687E-05
       S32:2.068704E-05
       S33:1.656123E-07
       S34:9.348567E-07
       S36:4.358298E-09
       TI46:3.210951E-05
       TI47:2.895766E-05
       TI48:2.869267E-04
       TI49:2.105602E-05
       TI50:2.016107E-05
       V:2.742873E-05
       ZR90:7.880535E-06
       ZR91:1.718520E-06
       ZR92:2.626878E-06
       ZR94:2.662077E-06
       ZR96:4.288701E-07
       W182:2.014107E-06
       W183:1.087650E-06
       W184:2.337892E-06
       W186:2.160800E-06
       CU63:1.520930E-05
       CU65:6.778986E-06
       CO59:2.370990E-05
       CA40:3.379743E-05
       CA42:2.255696E-07
       CA43:4.706582E-08
       CA44:7.272563E-07
       CA46:1.394535E-09
       CA48:6.519498E-08
       NB93:7.519752E-06
       N14:4.969370E-05
       N15:1.835515E-07
       AL27:2.589280E-05
       TA181:3.861021E-06
       B10:5.144462E-06
       B11:2.070704E-05;

     E_Lead ${mid_E_lead}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02;

     E_Duct ${mid_E_duct}
       FE54:3.192503E-03
       FE56:5.011505E-02
       FE57:1.157401E-03
       FE58:1.540302E-04
       NI58:8.390808E-03
       NI60:3.232103E-03
       NI61:1.405101E-04
       NI62:4.479004E-04
       NI64:1.141301E-04
       CR50:5.655206E-04
       CR52:1.090501E-02
       CR53:1.236601E-03
       CR54:3.078103E-04
       MN55:1.274301E-03
       MO92:1.082801E-04
       MO94:6.749107E-05
       MO95:1.161601E-04
       MO96:1.217001E-04
       MO97:6.968007E-05
       MO98:1.760602E-04
       MO100:7.026407E-05
       SI28:1.302801E-03
       SI29:6.615206E-05
       SI30:4.360804E-05
       C:3.497203E-04
       P31:6.780707E-05
       S32:2.073002E-05
       S33:1.659602E-07
       S34:9.367909E-07
       S36:4.367304E-09
       TI46:3.217603E-05
       TI47:2.901703E-05
       TI48:2.875203E-04
       TI49:2.110002E-05
       TI50:2.020302E-05
       V:2.748603E-05
       ZR90:7.896908E-06
       ZR91:1.722102E-06
       ZR92:2.632303E-06
       ZR94:2.667603E-06
       ZR96:4.297604E-07
       W182:2.018302E-06
       W183:1.089901E-06
       W184:2.342702E-06
       W186:2.165302E-06
       CU63:1.524101E-05
       CU65:6.793007E-06
       CO59:2.375902E-05
       CA40:3.386703E-05
       CA42:2.260402E-07
       CA43:4.716405E-08
       CA44:7.287707E-07
       CA46:1.397401E-09
       CA48:6.533006E-08
       NB93:7.535407E-06
       N14:4.979705E-05
       N15:1.839302E-07
       AL27:2.594703E-05
       TA181:3.869004E-06
       B10:5.155105E-06
       B11:2.075002E-05'
  []
  [UpperInsulator]
    type = MicroNeutronicsMaterial
    block = '${bid_G_lead} ${bid_G_clad} ${bid_G_duct} ${bid_G_yszmix} ${bid_G_yszmixc}'
    library_id = '${lid_G}'
    materials = '
     G_YSZMIX ${mid_G_yszmix}
       ZR90:1.110556E-02
       ZR91:2.421721E-03
       ZR92:3.701685E-03
       ZR94:3.751388E-03
       ZR96:6.043603E-04
       Y89:3.753788E-03
       O16:4.880044E-02
       HE4:2.388520E-06;

     G_Clad ${mid_G_clad}
       FE54:3.185952E-03
       FE56:5.001168E-02
       FE57:1.154947E-03
       FE58:1.537129E-04
       NI58:8.373412E-03
       NI60:3.225451E-03
       NI61:1.402235E-04
       NI62:4.469793E-04
       NI64:1.138947E-04
       CR50:5.643439E-04
       CR52:1.088250E-02
       CR53:1.234043E-03
       CR54:3.071758E-04
       MN55:1.271641E-03
       MO92:1.080550E-04
       MO94:6.735188E-05
       MO95:1.159146E-04
       MO96:1.214544E-04
       MO97:6.953578E-05
       MO98:1.757019E-04
       MO100:7.011875E-05
       SI28:1.300140E-03
       SI29:6.601594E-05
       SI30:4.351798E-05
       C:3.489938E-04
       P31:6.766687E-05
       S32:2.068704E-05
       S33:1.656123E-07
       S34:9.348567E-07
       S36:4.358298E-09
       TI46:3.210951E-05
       TI47:2.895766E-05
       TI48:2.869267E-04
       TI49:2.105602E-05
       TI50:2.016107E-05
       V:2.742873E-05
       ZR90:7.880535E-06
       ZR91:1.718520E-06
       ZR92:2.626878E-06
       ZR94:2.662077E-06
       ZR96:4.288701E-07
       W182:2.014107E-06
       W183:1.087650E-06
       W184:2.337892E-06
       W186:2.160800E-06
       CU63:1.520930E-05
       CU65:6.778986E-06
       CO59:2.370990E-05
       CA40:3.379743E-05
       CA42:2.255696E-07
       CA43:4.706582E-08
       CA44:7.272563E-07
       CA46:1.394535E-09
       CA48:6.519498E-08
       NB93:7.519752E-06
       N14:4.969370E-05
       N15:1.835515E-07
       AL27:2.589280E-05
       TA181:3.861021E-06
       B10:5.144462E-06
       B11:2.070704E-05;

     G_Lead ${mid_G_lead}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02;

     G_Duct ${mid_G_duct}
       FE54:3.192503E-03
       FE56:5.011505E-02
       FE57:1.157401E-03
       FE58:1.540302E-04
       NI58:8.390808E-03
       NI60:3.232103E-03
       NI61:1.405101E-04
       NI62:4.479004E-04
       NI64:1.141301E-04
       CR50:5.655206E-04
       CR52:1.090501E-02
       CR53:1.236601E-03
       CR54:3.078103E-04
       MN55:1.274301E-03
       MO92:1.082801E-04
       MO94:6.749107E-05
       MO95:1.161601E-04
       MO96:1.217001E-04
       MO97:6.968007E-05
       MO98:1.760602E-04
       MO100:7.026407E-05
       SI28:1.302801E-03
       SI29:6.615206E-05
       SI30:4.360804E-05
       C:3.497203E-04
       P31:6.780707E-05
       S32:2.073002E-05
       S33:1.659602E-07
       S34:9.367909E-07
       S36:4.367304E-09
       TI46:3.217603E-05
       TI47:2.901703E-05
       TI48:2.875203E-04
       TI49:2.110002E-05
       TI50:2.020302E-05
       V:2.748603E-05
       ZR90:7.896908E-06
       ZR91:1.722102E-06
       ZR92:2.632303E-06
       ZR94:2.667603E-06
       ZR96:4.297604E-07
       W182:2.018302E-06
       W183:1.089901E-06
       W184:2.342702E-06
       W186:2.165302E-06
       CU63:1.524101E-05
       CU65:6.793007E-06
       CO59:2.375902E-05
       CA40:3.386703E-05
       CA42:2.260402E-07
       CA43:4.716405E-08
       CA44:7.287707E-07
       CA46:1.397401E-09
       CA48:6.533006E-08
       NB93:7.535407E-06
       N14:4.979705E-05
       N15:1.839302E-07
       AL27:2.594703E-05
       TA181:3.869004E-06
       B10:5.155105E-06
       B11:2.075002E-05'
  []
  [UpperGasPlenum]
    type = MicroNeutronicsMaterial
    block = '${bid_H_lead} ${bid_H_clad} ${bid_H_duct} ${bid_H_springmix} ${bid_H_springmixc}'
    library_id = '${lid_H}'
    materials = '
     H_SPRINGMIX ${mid_H_springmix}
       FE54:3.504949E-04
       FE56:5.501991E-03
       FE57:1.270690E-04
       FE58:1.691020E-05
       NI58:9.211855E-04
       NI60:3.548352E-04
       NI61:1.542610E-05
       NI62:4.917349E-05
       NI64:1.252989E-05
       CR50:6.208541E-05
       CR52:1.197285E-03
       CR53:1.357596E-04
       CR54:3.379340E-05
       MN55:1.398999E-04
       MO92:1.188684E-05
       MO94:7.409526E-06
       MO95:1.275291E-05
       MO96:1.336095E-05
       MO97:7.649844E-06
       MO98:1.932937E-05
       MO100:7.713948E-06
       SI28:1.430302E-04
       SI29:7.262616E-06
       SI30:4.787540E-06
       C:3.839473E-05
       P31:7.444329E-06
       S32:2.275762E-06
       S33:1.822029E-08
       S34:1.028473E-07
       S36:4.794741E-10
       TI46:3.532451E-06
       TI47:3.185626E-06
       TI48:3.156524E-05
       TI49:2.316465E-06
       TI50:2.217958E-06
       V:3.017514E-06
       ZR90:8.669616E-07
       ZR91:1.890634E-07
       ZR92:2.889905E-07
       ZR94:2.928608E-07
       ZR96:4.718135E-08
       W182:2.215757E-07
       W183:1.196485E-07
       W184:2.571983E-07
       W186:2.377169E-07
       CU63:1.673219E-06
       CU65:7.457830E-07
       CO59:2.608385E-06
       CA40:3.718164E-06
       CA42:2.481576E-08
       CA43:5.177868E-09
       CA44:8.000768E-08
       CA46:1.534209E-10
       CA48:7.172310E-09
       NB93:8.272788E-07
       N14:5.466988E-06
       N15:2.019243E-08
       AL27:2.848602E-06
       TA181:4.247602E-07
       B10:5.659602E-07
       B11:2.278062E-06
       HE4:2.228358E-05;

     H_Clad ${mid_H_clad}
       FE54:3.185952E-03
       FE56:5.001168E-02
       FE57:1.154947E-03
       FE58:1.537129E-04
       NI58:8.373412E-03
       NI60:3.225451E-03
       NI61:1.402235E-04
       NI62:4.469793E-04
       NI64:1.138947E-04
       CR50:5.643439E-04
       CR52:1.088250E-02
       CR53:1.234043E-03
       CR54:3.071758E-04
       MN55:1.271641E-03
       MO92:1.080550E-04
       MO94:6.735188E-05
       MO95:1.159146E-04
       MO96:1.214544E-04
       MO97:6.953578E-05
       MO98:1.757019E-04
       MO100:7.011875E-05
       SI28:1.300140E-03
       SI29:6.601594E-05
       SI30:4.351798E-05
       C:3.489938E-04
       P31:6.766687E-05
       S32:2.068704E-05
       S33:1.656123E-07
       S34:9.348567E-07
       S36:4.358298E-09
       TI46:3.210951E-05
       TI47:2.895766E-05
       TI48:2.869267E-04
       TI49:2.105602E-05
       TI50:2.016107E-05
       V:2.742873E-05
       ZR90:7.880535E-06
       ZR91:1.718520E-06
       ZR92:2.626878E-06
       ZR94:2.662077E-06
       ZR96:4.288701E-07
       W182:2.014107E-06
       W183:1.087650E-06
       W184:2.337892E-06
       W186:2.160800E-06
       CU63:1.520930E-05
       CU65:6.778986E-06
       CO59:2.370990E-05
       CA40:3.379743E-05
       CA42:2.255696E-07
       CA43:4.706582E-08
       CA44:7.272563E-07
       CA46:1.394535E-09
       CA48:6.519498E-08
       NB93:7.519752E-06
       N14:4.969370E-05
       N15:1.835515E-07
       AL27:2.589280E-05
       TA181:3.861021E-06
       B10:5.144462E-06
       B11:2.070704E-05;

     H_Lead ${mid_H_lead}
       PB204:4.232323E-04
       PB206:7.285612E-03
       PB207:6.680995E-03
       PB208:1.584046E-02;

     H_Duct ${mid_H_duct}
       FE54:3.192503E-03
       FE56:5.011505E-02
       FE57:1.157401E-03
       FE58:1.540302E-04
       NI58:8.390808E-03
       NI60:3.232103E-03
       NI61:1.405101E-04
       NI62:4.479004E-04
       NI64:1.141301E-04
       CR50:5.655206E-04
       CR52:1.090501E-02
       CR53:1.236601E-03
       CR54:3.078103E-04
       MN55:1.274301E-03
       MO92:1.082801E-04
       MO94:6.749107E-05
       MO95:1.161601E-04
       MO96:1.217001E-04
       MO97:6.968007E-05
       MO98:1.760602E-04
       MO100:7.026407E-05
       SI28:1.302801E-03
       SI29:6.615206E-05
       SI30:4.360804E-05
       C:3.497203E-04
       P31:6.780707E-05
       S32:2.073002E-05
       S33:1.659602E-07
       S34:9.367909E-07
       S36:4.367304E-09
       TI46:3.217603E-05
       TI47:2.901703E-05
       TI48:2.875203E-04
       TI49:2.110002E-05
       TI50:2.020302E-05
       V:2.748603E-05
       ZR90:7.896908E-06
       ZR91:1.722102E-06
       ZR92:2.632303E-06
       ZR94:2.667603E-06
       ZR96:4.297604E-07
       W182:2.018302E-06
       W183:1.089901E-06
       W184:2.342702E-06
       W186:2.165302E-06
       CU63:1.524101E-05
       CU65:6.793007E-06
       CO59:2.375902E-05
       CA40:3.386703E-05
       CA42:2.260402E-07
       CA43:4.716405E-08
       CA44:7.287707E-07
       CA46:1.397401E-09
       CA48:6.533006E-08
       NB93:7.535407E-06
       N14:4.979705E-05
       N15:1.839302E-07
       AL27:2.594703E-05
       TA181:3.869004E-06
       B10:5.155105E-06
       B11:2.075002E-05'
  []
  [UpperBundle]
    type = MicroNeutronicsMaterial
    block = '${bid_I} ${bid_Ic}'
    library_id = '${lid_I}'
    materials = '
     UpperBundle ${mid_I}
       FE54:1.251752E-03
       FE56:1.964981E-02
       FE57:4.537988E-04
       FE58:6.039250E-05
       NI58:3.289936E-03
       NI60:1.267252E-03
       NI61:5.509228E-05
       NI62:1.756173E-04
       NI64:4.474985E-05
       CR50:2.217292E-04
       CR52:4.275877E-03
       CR53:4.848501E-04
       CR54:1.206850E-04
       MN55:4.996407E-04
       MO92:4.245476E-05
       MO94:2.646209E-05
       MO95:4.554388E-05
       MO96:4.771797E-05
       MO97:2.732113E-05
       MO98:6.903086E-05
       MO100:2.754914E-05
       SI28:5.108111E-04
       SI29:2.593807E-05
       SI30:1.709871E-05
       C:1.371257E-04
       P31:2.658610E-05
       S32:8.127836E-06
       S33:6.507069E-08
       S34:3.673052E-07
       S36:1.712371E-09
       TI46:1.261552E-05
       TI47:1.137747E-05
       TI48:1.127347E-04
       TI49:8.273042E-06
       TI50:7.921328E-06
       V:1.077645E-05
       ZR90:3.096328E-06
       ZR91:6.752279E-07
       ZR92:1.032143E-06
       ZR94:1.045943E-06
       ZR96:1.685070E-07
       W182:7.913527E-07
       W183:4.273277E-07
       W184:9.185680E-07
       W186:8.489851E-07
       CU63:5.975747E-06
       CU65:2.663510E-06
       CO59:9.315485E-06
       CA40:1.327855E-05
       CA42:8.862667E-08
       CA43:1.849277E-08
       CA44:2.857418E-07
       CA46:5.479227E-10
       CA48:2.561506E-08
       NB93:2.954522E-06
       N14:1.952481E-05
       N15:7.211698E-08
       AL27:1.017342E-05
       TA181:1.516963E-06
       B10:2.021284E-06
       B11:8.135837E-06
       PB204:2.570306E-04
       PB206:4.424583E-03
       PB207:4.057368E-03
       PB208:9.620298E-03'
  []
  [OutletWrapper]
    type = MicroNeutronicsMaterial
    block = '${bid_J} ${bid_Jc}'
    library_id = '${lid_J}'
    materials = '
     OutletWrapper ${mid_J}
       FE54:7.604462E-04
       FE56:1.193694E-02
       FE57:2.756886E-04
       FE58:3.668882E-05
       NI58:1.998690E-03
       NI60:7.698761E-04
       NI61:3.346883E-05
       NI62:1.066895E-04
       NI64:2.718586E-05
       CR50:1.347093E-04
       CR52:2.597687E-03
       CR53:2.945585E-04
       CR54:7.332063E-05
       MN55:3.035385E-04
       MO92:2.579187E-05
       MO94:1.607592E-05
       MO95:2.766886E-05
       MO96:2.898985E-05
       MO97:1.659792E-05
       MO98:4.193779E-05
       MO100:1.673692E-05
       SI28:3.103184E-04
       SI29:1.575692E-05
       SI30:1.038695E-05
       C:8.330258E-05
       P31:1.615192E-05
       S32:4.937775E-06
       S33:3.953080E-08
       S34:2.231389E-07
       S36:1.040295E-09
       TI46:7.664362E-06
       TI47:6.911865E-06
       TI48:6.848666E-05
       TI49:5.025975E-06
       TI50:4.812276E-06
       V:6.547067E-06
       ZR90:1.880991E-06
       ZR91:4.102079E-07
       ZR92:6.270069E-07
       ZR94:6.354168E-07
       ZR96:1.023695E-07
       W182:4.807576E-07
       W183:2.596087E-07
       W184:5.580372E-07
       W186:5.157674E-07
       CU63:3.630382E-06
       CU65:1.618092E-06
       CO59:5.659272E-06
       CA40:8.067160E-06
       CA42:5.384173E-08
       CA43:1.123394E-08
       CA44:1.735891E-07
       CA46:3.328683E-10
       CA48:1.556192E-08
       NB93:1.794891E-06
       N14:1.186194E-05
       N15:4.381178E-08
       AL27:6.180469E-06
       TA181:9.215854E-07
       B10:1.227894E-06
       B11:4.942575E-06
       PB204:3.224084E-04
       PB206:5.549972E-03
       PB207:5.089375E-03
       PB208:1.206694E-02'
  []
[]
