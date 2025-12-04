"""
Introduction to INL and STARTR

This model constructs each element of the STARTR reactor component-by-component, with all materials
used defined at the top of the code. This model is designed to run on one core within one hour
with a standard deviation less than 30 pcm.

Modified versions of this code for various reactor analysis tasks can be found in the
subdirectories herein. The test suite includes control drum worth calculations, radial and axial
power peaking analysis, isothermal reactivity calculations, and more.

The ENDF/B-VIII.0 library was used for cross section and thermal scattering data under
D.A. Brown et al., "ENDF/B-VIII.0: The 8th Major Release of the Nuclear Reaction Data Library
with CIELO-project Cross Sections, New Standards and Thermal Scattering Data," Nuclear Data
Sheets, 148, 1 (2018); https://doi.org/10.1015/j.nds.2018.02.001.
"""
import openmc
import numpy as np
from na_density import calc_na_density

########## GLOBAL VARIABLES ##########
NUM_PELLETS = 5 # Number of uzrh pellets in fuel rod, 5 in STARTR, 3 in typical TRIGA rod
CLADD_OVERLAP = 1.2695 # cm of cladding past top and bottom of fuel rod components

# Isothermal temperature applied to all materials in model
"""
Thermal scattering data in ENDFB 8.0 does not exist at 900 K.
899K corresponds to 800 K thermal scattering with x-section data at 900 K.
901 K corresponds to 1000 K thermal scattering with x-section data at 900 K.
"""
TEMP = 899 # K

# Drum rotations: (+) -> ccw, (-) -> cw
"""
All control drums rotate counter-clockwise when withdrawn from the core
and their movement is linked. i.e. if the north drum is withdrawn 30 degrees, all
drums are withdrawn 30 degrees.

An angle of 0 corresponds to the b4c poison plates pointing northward. The below
cases correspond to full insertion and full removal. Comment out the case not being
used.
"""
# Rotations for all drums facing inwards (maximally inserted)
#N_DRUM_ROTATION = 180
#E_DRUM_ROTATION = 90
#S_DRUM_ROTATION = 0
#W_DRUM_ROTATION = -90

# Rotations for all drums facing outwards (minimally inserted)
N_DRUM_ROTATION = 0
E_DRUM_ROTATION = -90
S_DRUM_ROTATION = 180
W_DRUM_ROTATION = 90

########## Material Definitions ##########
"""
STARTR uses 19.75% enriched Uranium Zirconium Hydride as fuel with 30% weight percent
uranium, as is standard in TRIGA fuel rods.
"""
uzrh = openmc.Material(name="UZrH Fuel Meat")
uzrh.set_density('g/cm3', 7.135)
uzrh.add_nuclide('U235', 0.05925, 'wo')
uzrh.add_nuclide('U238', 0.24075, 'wo')
uzrh.add_element('Zr', 0.688, 'wo')
uzrh.add_element('H', 0.012, 'wo')
uzrh.add_s_alpha_beta('c_Zr_in_ZrH') # Thermal scattering
uzrh.add_s_alpha_beta('c_H_in_ZrH') # Thermal scattering
uzrh.temperature = TEMP

zirconium = openmc.Material(name="Zirconium")
zirconium.set_density('g/cm3', 6.505)
zirconium.add_element('Zr', 1.0)
zirconium.temperature = TEMP

graphite = openmc.Material(name="Graphite")
graphite.set_density('g/cm3', 1.7) # Lower than theoretical natural density due to manufacturing inefficiencies
graphite.add_element('C', 1.0)
graphite.add_s_alpha_beta('c_Graphite_30p') # Thermal scattering that accounts for manufacturing inefficiencies
graphite.temperature = TEMP

molybdenum = openmc.Material(name="Molybdenum")
molybdenum.set_density('g/cm3', 10.223)
molybdenum.add_element('Mo', 1.0)
molybdenum.temperature = TEMP

void = openmc.Material(name="Void") # Air
void.set_density('g/cm3', 0.001205)
void.add_element('N', 0.755268)
void.add_element('O', 0.231781)
void.add_element('Ar', 0.012827)
void.add_element('C', 0.000124)
void.temperature = TEMP

"""
Trace material amounts permitted in 304 Stainless Steel by ASTM A269/A269M-15a,
such as C, P, S, and Si are ommitted here to improve model runtime.

The STARTR design uses 316H Stainless Steel for the vessel wall under ASTM A312/A312M-25,
however, minimizing the model to one type of stainless steel significantly reduces the runtime
without meaningfully affecting the reactivity or tallies of the model. Thus, SS316H was ommitted
and this model uses 304 SS for the fuel rod cladding and the vessel wall.

ASTM A269/A269M-16A (Historical), "Standard specification for Seamless and Welded Austenitic Stainless
Steel Tubing for General Service," ASTM A269/A269M-15a, ASTM International, West Conshohocken, Pennsylvania (2019);
https://doi.org/10.1520/A0269_A0269M-15A.
"""
ss304 = openmc.Material(name="304 Stainless Steel")
ss304.set_density('g/cm3', 7.93)
ss304.add_element('Mn', 0.02, 'wo')
ss304.add_element('Ni', 0.095, 'wo')
ss304.add_element('Cr', 0.19, 'wo')
ss304.add_element('Fe', 0.695, 'wo')
ss304.temperature = TEMP

"""
While all material densities vary with temperature, the sodium coolant is the only liquid
present in the design, and its density varies the most. Thus, sodium densities are calculated
using a helper function with equations defined in na_density.py.
"""
na_dens = calc_na_density(TEMP)
na = openmc.Material(name="Sodium")
na.set_density('g/cm3', na_dens)
na.add_element('Na', 1)
na.temperature = TEMP

b4c = openmc.Material(name="Boron Carbide")
b4c.set_density('g/cm3', 2.52)
b4c.add_element('B', 4)
b4c.add_element('C', 1)
b4c.temperature = TEMP

beo = openmc.Material(name="Beryllium Oxide")
beo.set_density('g/cm3', 3.01)
beo.add_element('Be', 1)
beo.add_element('O', 1)
beo.add_s_alpha_beta('c_Be_in_BeO') # Thermal scattering
beo.add_s_alpha_beta('c_O_in_BeO') # Thermal scattering
beo.temperature = TEMP

be = openmc.Material(name="Metallic Beryllium")
be.set_density('g/cm3', 1.845)
be.add_element('Be', 1)
be.add_s_alpha_beta('c_Be') # Thermal scattering
be.temperature = TEMP

# Materials must be exported to a .xml file for openmc to run properly
materials = openmc.Materials([uzrh, zirconium, graphite, molybdenum, void, ss304, na, b4c, beo, be])
materials.export_to_xml()

# Colors for all materials for use in all generated plots
MODEL_COLORS = {
        uzrh: 'seagreen',
        zirconium: 'gold',
        graphite: 'lightsteelblue',
        molybdenum: 'fuchsia',
        void: 'skyblue',
        ss304: 'steelblue',
        na: 'pink',
        b4c: 'mediumvioletred',
        beo: 'goldenrod',
        be: 'salmon'
        }
########## Geometry ##########
"""
The first component we will build is the TRIGA fuel rod. Dimensions for all included component are described in

J. A. Evans et al., "Uranium-zirconium Hydride Nuclear Fuel Performance in the NaK-cooled MARVEL microreactor,"
Journal of Nuclear Materials, 598, 1 (2024); https://doi.org/10.1016/j.jnucmat.2024.155145.

These measurements were used to define the cladding overlap defined at the top of this file as well. All
measurements are in units of centimeters.

The general format for creating a component or "universe" in openmc in this code is as follows:
    1. define surfaces
    2. define planes
    3. define cells (contiguous regions of a certain material type

For all cylinders, I use the naming ID or OD, short for inner diameter and outer diameter respectively.
Note that openmc defines cylinders using the radius, which is why the dimensions from the cited paper are halved.

For all planes, the name min and max define the bottom and top of the cell respectively.
"""
### Fuel Rod
## Fuel Rod Surfaces

# Fuel Pellet
meat_ID = openmc.ZCylinder(r=.635/2)
meat_OD = openmc.ZCylinder(r=3.482/2)
meat_height = 12.7

# Internal Zr Rod
rod_OD = openmc.ZCylinder(r=0.572/2)
rod_height = meat_height

# Top Graphite Reflector
top_refl_OD = openmc.ZCylinder(r=3.274/2)
top_refl_height = 6.604

# Molybdenum Poison Disk
mo_disk_OD = openmc.ZCylinder(r=3.47/2)
mo_disk_height = 0.079

# Bottom Graphite Reflector
bot_refl_OD = top_refl_OD
bot_refl_height = 8.687

# Cladding
cladd_OD = openmc.ZCylinder(r=3.594/2)
cladd_ID = openmc.ZCylinder(r=1.746) # Corresponds to thickness of 0.51mm
cladd_height = 82.626

# Plenum void gap
gap_OD = cladd_ID
gap_height = 1.217

# Bottom Steel Fitting
# NOTE: Geometry is more complicated than modeled here, 2" solid cylinder assumed for simplicity
bot_fitt_OD = cladd_ID
bot_fitt_height = 5.08

# Top Steel Fitting
# NOTE: Geometry is more complicated than modeled here, 2" solid cylinder assumed for simplicity
top_fitt_OD = cladd_ID
top_fitt_height = 5.08

"""
Planes and regions are aliased here throughout the code, where multiple variables point to the same
plane or region. This is to avoid redundant surfaces which may slow the code, while making the surface names
and region definitions for each cell easier to understand later on.

In this section, the height defined above is used to construct all necessary planes from the bottom up. This
makes it easy to add new subcomponents or change the height of existing pieces.
"""
## Fuel Rod Planes (built from bottom up)
# NOTE: If changing the bottom element, update cladding cell minimum at the bottom of this section
curr_height = 0

# Bottom Steel fitting
bot_fitt_min = openmc.ZPlane(z0=curr_height)
curr_height += bot_fitt_height
bot_fitt_max = openmc.ZPlane(z0=curr_height)

# Bottom Reflector
bot_refl_min = bot_fitt_max
curr_height += bot_refl_height
bot_refl_max = openmc.ZPlane(z0=curr_height)

# Molybdenum Disk
mo_disk_min = bot_refl_max
curr_height += mo_disk_height
mo_disk_max = openmc.ZPlane(z0=curr_height)

# Fuel Cell & Zr Rod
meat_min = mo_disk_max
rod_min = meat_min
curr_height += NUM_PELLETS * meat_height
meat_max = openmc.ZPlane(z0=curr_height)
rod_max = meat_max

# Top Reflector
top_refl_min = meat_max
curr_height += top_refl_height
top_refl_max = openmc.ZPlane(z0=curr_height)

# Void Gap
gap_min = top_refl_max
curr_height += gap_height
gap_max = openmc.ZPlane(z0=curr_height)

# Top Steel fitting
top_fitt_min = gap_max
curr_height += top_fitt_height
top_fitt_max = openmc.ZPlane(z0=curr_height)

# Cladding
cladd_min = openmc.ZPlane(z0=bot_fitt_max.z0 - CLADD_OVERLAP)
cladd_max = openmc.ZPlane(z0=gap_max.z0 + CLADD_OVERLAP)

"""
The universe is where all of the subcomponents, such as the fuel meat, zirconium rod, etc. get placed
to actually create the fuel rod. This needs to be defined for us to add each "cell," or subcomponent.
"""
## Fuel Rod Universe
fuel_rod_univ = openmc.Universe(name="TRIGA Fuel Rod Universe")

"""
Every cell needs a region that it occupies and a material to fill that region. This is why we
aliased the planes above, so every surface and plane used by the cell shares the same name as
the cell itself.

Regions are defined in half-spaces which is clearly explained in the openmc documentation. As a brief
overview, the negative half-space of a cylinder is everything within the cylinder, and the negative half space of a
plane is everything below that plane. With boolean logic one can define more complex regions, such as hollow cylinders
as is done below.

Note that names for the cells are not strictly necessary, but it is useful for debugging and interpreting your
results.
"""
## Fuel Rod Cells (from bottom up)

# Bottom Fitting
bot_fitt_cell = openmc.Cell(name="Bottom Steel Fitting Cell")
bot_fitt_cell.region = +bot_fitt_min & -bot_fitt_max & -bot_fitt_OD
bot_fitt_cell.fill = ss304
fuel_rod_univ.add_cell(bot_fitt_cell)

# Bottom Reflector
bot_refl_cell = openmc.Cell(name="Bottom Graphite Reflector Cell")
bot_refl_cell.region = +bot_refl_min & -bot_refl_max & -bot_refl_OD
bot_refl_cell.fill = graphite
fuel_rod_univ.add_cell(bot_refl_cell)

# Molybdenum Disk
mo_disk_cell = openmc.Cell(name="Molybdenum Disk Cell")
mo_disk_cell.region = +mo_disk_min & -mo_disk_max & -mo_disk_OD
mo_disk_cell.fill = molybdenum
fuel_rod_univ.add_cell(mo_disk_cell)

# Fuel Meat
meat_cell = openmc.Cell(name="UZrH Fuel Meat Cell")
meat_cell.region = +meat_min & -meat_max & +meat_ID & -meat_OD
meat_cell.fill = uzrh
fuel_rod_univ.add_cell(meat_cell)

# Zirconium Rod
rod_cell = openmc.Cell(name="Central Zirconium Rod")
rod_cell.region = +rod_min & -rod_max & -rod_OD
rod_cell.fill = zirconium
fuel_rod_univ.add_cell(rod_cell)

# Top Reflector
top_refl_cell = openmc.Cell(name="Top Graphite Reflector Cell")
top_refl_cell.region = +top_refl_min & -top_refl_max & -top_refl_OD
top_refl_cell.fill = graphite
fuel_rod_univ.add_cell(top_refl_cell)

"""
None of the components are exactly flush with the inner wall of the cladding, so there is a
small air gap between them. These are all defined as individual cells rather than one large cell
because the air sections are not contiguous with each other.
"""
# Void Gap
gap_regions = {
        "Bottom Fitting Gap" : +bot_refl_min & -bot_refl_max & +bot_refl_OD & -cladd_ID,
        "Molybdenum Disk Gap" : +mo_disk_min & -mo_disk_max & +mo_disk_OD & -cladd_ID,
        "Zr Rod to Fuel Meat Gap" : +rod_min & -rod_max & +rod_OD & -meat_ID,
        "Meat to Cladding Gap" : +meat_min & -meat_max & +meat_OD & -cladd_ID,
        "Top Fitting Gap" : +top_refl_min & -top_refl_max & +top_refl_OD & -cladd_ID,
        "Plenum Void Gap" : +gap_min & -gap_max & -gap_OD,
        }

gap_cells = []
for name in gap_regions:
    temp_cell = openmc.Cell(name=name)
    temp_cell.region = gap_regions[name]
    temp_cell.fill = void
    gap_cells.append(temp_cell)
fuel_rod_univ.add_cells(gap_cells)

# Cladding
cladd_cell = openmc.Cell(name="Stainless Steel 304 Cladding")
cladd_cell.region = +cladd_min & -cladd_max & +cladd_ID & -cladd_OD
cladd_cell.fill = ss304
fuel_rod_univ.add_cell(cladd_cell)

# Top Fitting
top_fitt_cell = openmc.Cell(name="Bottom Steel Fitting Cell")
top_fitt_cell.region = +top_fitt_min & -top_fitt_max & -top_fitt_OD
top_fitt_cell.fill = ss304
fuel_rod_univ.add_cell(top_fitt_cell)

"""
Sodium coolant needs to be defined outside the fuel rod to avoid undefined regions
when we create the hexagonal lattice later on. The lattice in openmc assumes each element occupies
a hexagonal space, separated by the defined pitch. Thus, if we don't surround our fuel rod with coolant,
we will have the cylindrical rod as we expect, with undefined regions between each rod.

Note that the cladding sticks out slightly farther than the top and bottom steel fittings, which creates
a small hollow cylinder shape that is undefined if not for the two additional regions applied below.
"""
# Surrounding Na coolant
na_inf_cell = openmc.Cell(name="Fuel Rod Infinite Na Cell")
na_inf_cell.region = (
        +cladd_OD | +top_fitt_max | -bot_fitt_min | # Overall surroundings
        +cladd_max & -top_fitt_max & +top_fitt_OD & -cladd_OD | # Top undefined region
        +bot_fitt_min & -cladd_min & +bot_fitt_OD & -cladd_OD # Bottom undefined region
        )
na_inf_cell.fill = na
fuel_rod_univ.add_cell(na_inf_cell)

"""
Fuel Rod Visualization Plots

Every time we finish a component/universe, it's a good idea to plot the geometry that was made to ensure
everything was built correctly. The colors of each material are defined at the top of this file so every
plot has the same coloring. Each plot in this code takes the xy and yz cross sections at the center
of the component.

If you find that the plot generation slows the code significantly, comment out the plot_geometry
command at the bottom, or reduce the number of pixels.

NOTE: Always be sure to export the geometry you want to see and your plot settings to xml before you
try to plot_geometry().
"""
fuel_plot_geometry = openmc.Geometry(fuel_rod_univ)
fuel_plot_geometry.export_to_xml()

xy_fuel_rod_plot = openmc.Plot()
xy_fuel_rod_plot.basis = 'xy'
xy_fuel_rod_plot.origin = (0, 0, 45.1235)
xy_fuel_rod_plot.width = (4., 4.)
xy_fuel_rod_plot.pixels = (800, 800)
xy_fuel_rod_plot.color_by = 'material'
xy_fuel_rod_plot.colors = MODEL_COLORS
xy_fuel_rod_plot.filename = "xy fuel rod"

yz_fuel_rod_plot = openmc.Plot()
yz_fuel_rod_plot.basis = 'yz'
yz_fuel_rod_plot.origin = (0, 0, 45.1235)
yz_fuel_rod_plot.width = (4., 95.)
yz_fuel_rod_plot.pixels = (200, 2375)
yz_fuel_rod_plot.color_by = 'material'
yz_fuel_rod_plot.colors = MODEL_COLORS
yz_fuel_rod_plot.filename = "yz fuel rod"

plots = openmc.Plots([xy_fuel_rod_plot, yz_fuel_rod_plot])
plots.export_to_xml()
openmc.plot_geometry()

"""
At the center of STARTR is a void rod, which has the same cladding and fittings dimensions as the
TRIGA fuel rods, but with air instead of fuel meat, reflectors, etc.

Again, surfaces that would be redundant to create are instead aliased to avoid slowing down the Monte
Carlo simulation.
"""
### Void Rod
## Void Rod Surfaces

# Cladding
vr_cladd_OD = cladd_OD
vr_cladd_ID = cladd_ID

# Steel Fittings
vr_bot_fitt_OD = bot_fitt_OD
vr_top_fitt_OD = top_fitt_OD

# Void Region
vr_void_OD = vr_cladd_ID

## Void Rod Planes

# Cladding
vr_cladd_min = cladd_min
vr_cladd_max = cladd_max

# Steel Fittings
vr_bot_fitt_min = bot_fitt_min
vr_bot_fitt_max = bot_fitt_max
vr_top_fitt_min = top_fitt_min
vr_top_fitt_max = top_fitt_max

# Void Region
vr_void_min = vr_bot_fitt_max
vr_void_max = vr_top_fitt_min

## Void Rod Universe
vr_univ = openmc.Universe(name="Void Rod Universe")

## Void Rod Cells

# Cladding
vr_cladd_cell = openmc.Cell(name="Void Rod Cladding Cell")
vr_cladd_cell.region = +vr_cladd_min & -vr_cladd_max & +vr_cladd_ID & -vr_cladd_OD
vr_cladd_cell.fill = ss304
vr_univ.add_cell(vr_cladd_cell)

# Void
vr_void_cell = openmc.Cell(name="Void Rod Void Cell")
vr_void_cell.region = +vr_void_min & -vr_void_max & -vr_void_OD
vr_void_cell.fill = void
vr_univ.add_cell(vr_void_cell)

# Bottom Steel Fitting
vr_bot_fitt_cell = openmc.Cell(name="Void Rod Bottom Steel Fitting Cell")
vr_bot_fitt_cell.region = +vr_bot_fitt_min & -vr_bot_fitt_max & -vr_bot_fitt_OD
vr_bot_fitt_cell.fill = ss304
vr_univ.add_cell(vr_bot_fitt_cell)

# Top Steel Fitting
vr_top_fitt_cell = openmc.Cell(name="Void Rod Top Steel Fitting Cell")
vr_top_fitt_cell.region = +vr_top_fitt_min & -vr_top_fitt_max & -vr_top_fitt_OD
vr_top_fitt_cell.fill = ss304
vr_univ.add_cell(vr_top_fitt_cell)

# Infinite Na, necessary for latticing with same reason as TRIGA fuel rod
vr_na_inf_cell = openmc.Cell(name="Void Rod Infinite Na Cell")
vr_na_inf_cell.region = (
        +vr_cladd_OD | +vr_top_fitt_max | -vr_bot_fitt_min | # Overall surroundings
        +vr_cladd_max & -vr_top_fitt_max & +vr_top_fitt_OD & -vr_cladd_OD | # Top undefined region
        +vr_bot_fitt_min & -vr_cladd_min & +vr_bot_fitt_OD & -vr_cladd_OD # Bottom undefined region
        )
vr_na_inf_cell.fill = na
vr_univ.add_cell(vr_na_inf_cell)

""" Void Rod Plots """
void_rod_geometry = openmc.Geometry(vr_univ)
void_rod_geometry.export_to_xml()

xy_void_rod_plot = openmc.Plot()
xy_void_rod_plot.basis = 'xy'
xy_void_rod_plot.origin = (0, 0, 45.1235)
xy_void_rod_plot.width = (4., 4.)
xy_void_rod_plot.pixels = (800, 800)
xy_void_rod_plot.color_by = 'material'
xy_void_rod_plot.colors = MODEL_COLORS
xy_void_rod_plot.filename = "xy void rod"

yz_void_rod_plot = openmc.Plot()
yz_void_rod_plot.basis = 'yz'
yz_void_rod_plot.origin = (0, 0, 45.1235)
yz_void_rod_plot.width = (4., 95.)
yz_void_rod_plot.pixels = (200, 2375)
yz_void_rod_plot.color_by = 'material'
yz_void_rod_plot.colors = MODEL_COLORS
yz_void_rod_plot.filename = "yz void rod"

plots = openmc.Plots([xy_void_rod_plot, yz_void_rod_plot])
plots.export_to_xml()
openmc.plot_geometry()

"""
Now that we have all the necessary components for the lattice, we'll start working on the reactor core
which houses the void rod, fuel rods, sodium coolant, metallic beryllium reflector, and vessel cladding.
"""
### Reactor Core
"""
The hexagonal lattice needs surrounding sodium coolant for a similar reason to the fuel and void rods. When
placing the hexagonal lattice into the core universe, we need to define a region with simple planes. Most simply,
we can create a large hexagonal region to contain everything. However, there will be an undefined section
between the edge lattice elements and the hexagon the lattice is placed in unless we surround the lattice with
a universe of infinite coolant. This is achieved by assigning the universe one cell with one material and no
specified region. The universe is then applied to the hexagonal lattice with the .outer property.

To visualize what occurs without a proper .outer universe, one can replace the fill for lattice_inf_na_cell
with a material other than na, then plot the geometry.

Note that the .outer property is REQUIRED to define a lattice in openmc.
"""
## Infinite Coolant Universe for Lattice
lattice_inf_na_cell = openmc.Cell(name="Infinite Coolant for Lattice Cell", fill= na)
lattice_inf_na_univ = openmc.Universe(name="Infinite Lattice Coolant Universe", cells=(lattice_inf_na_cell,))

"""
The pitch, or spacing between elements, is defined in
T. L. Lange et al., "MARVEL Core Design and Neutronic Characteristics," ANS Winter Meeting 2022,
vol. 127, 1078-2081, Phoenix, AZ, November 13-17, American Nuclear Society (2022);
https://doi.org/10.13182/T127-39465.

Numpy is used to shorten the syntax for specifying the position of fuel elements. Details on defining
universes in a hex lattice can be found in the openmc documentation.
"""
## Hexagonal Lattice
hex_lat = openmc.HexLattice()
hex_lat.center = (0,0)
hex_lat.pitch = [3.7916]

outer_ring = np.full(18, fuel_rod_univ, dtype=object)
middle_ring = np.full(12, fuel_rod_univ, dtype=object)
inner_ring = np.full(6, fuel_rod_univ, dtype=object)
center = [vr_univ]

hex_lat.universes = [outer_ring, middle_ring, inner_ring, center]
hex_lat.outer = lattice_inf_na_univ

## Reactor Core Surfaces

# Vessel Cladding
vessel_OD = openmc.ZCylinder(r=28.2575/2)
vessel_ID = openmc.ZCylinder(r=13.81125) # Corresponds to wall thickness of 0.3175cm
# Height not included, distance from top and bottom of fuel element defined in planes

# Metallic Beryllium
metal_be_OD = vessel_ID

# Hexagonal lattice
hex_lat_prism = openmc.model.HexagonalPrism(edge_length=vessel_ID.r)

## Reactor Core Planes

# Vessel Cladding
vessel_min = openmc.ZPlane(z0=bot_fitt_min.z0 - 2.54, boundary_type='vacuum')
vessel_max = openmc.ZPlane(z0=top_fitt_max.z0 + 2.54, boundary_type='vacuum')

# Metallic Beryllium
metal_be_min = vessel_min
metal_be_max = vessel_max

# Hexagonal Lattice
hex_lat_min = vessel_min
hex_lat_max = vessel_max

## Reactor Core Universe
"""
Now that the lattice is complete, we can place the fuel elements, void rod, coolant region,
metallic beryllium reflector, and outer vessel steel into a universe that represents the core
and vessel of the reactor.
"""
core_univ = openmc.Universe(name="Reactor Core Universe")

## Reactor Core Cells

# Vessel Cladding
vessel_cell = openmc.Cell(name="Steel Reactor Vessel Cell")
vessel_cell.region = +vessel_min & -vessel_max & +vessel_ID & -vessel_OD
vessel_cell.fill = ss304 # Reasoning for ss304 instead of ss316h supplied in materials section
core_univ.add_cell(vessel_cell)

# Metallic Beryllium
metal_be_cell = openmc.Cell(name="Metallic Beryllium Cell")
metal_be_cell.region = +metal_be_min & -metal_be_max & -vessel_ID & +hex_lat_prism
metal_be_cell.fill = be
core_univ.add_cell(metal_be_cell)

# Hexagonal Lattice
hex_lat_cell = openmc.Cell(name="Hexagonal Lattice Cell")
hex_lat_cell.region = +hex_lat_min & -hex_lat_max & -hex_lat_prism
hex_lat_cell.fill = hex_lat
core_univ.add_cell(hex_lat_cell)

""" Reactor Core Plotting """
vessel_plot_geometry = openmc.Geometry(core_univ)
vessel_plot_geometry.export_to_xml()

xy_vessel_plot = openmc.Plot()
xy_vessel_plot.basis = 'xy'
xy_vessel_plot.origin = (0, 0, 45.1235)
xy_vessel_plot.width = (30., 30.)
xy_vessel_plot.pixels = (800, 800)
xy_vessel_plot.color_by = 'material'
xy_vessel_plot.colors = MODEL_COLORS
xy_vessel_plot.filename = "xy vessel"

yz_vessel_plot = openmc.Plot()
yz_vessel_plot.basis = 'yz'
yz_vessel_plot.origin = (0, 0, 45.1235)
yz_vessel_plot.width = (30., 120.)
yz_vessel_plot.pixels = (800, 3200)
yz_vessel_plot.color_by = 'material'
yz_vessel_plot.colors = MODEL_COLORS
yz_vessel_plot.filename = "yz vessel"

plots = openmc.Plots([xy_vessel_plot, yz_vessel_plot])
plots.export_to_xml()
openmc.plot_geometry()

"""
Rather than typical control rods, STARTR uses control drums that house a 120 degree sweep of boron carbide
as poison that is assumed to be 1.5cm thick. The rest of the control drum is made of beryllium oxide reflector,
the same material as the stationary reflector. The height of the beryllium oxide and boron carbide
both span the length of the fuel meat.
"""
### Control Drum
control_drum_univ = openmc.Universe(name="Rotational Reflector Universe")

## Rotational Reflector Surfaces
control_drum_OD = openmc.ZCylinder(r=28.2575/4) # Assuming reflector diameter equals radius of vessel
control_drum_ID = openmc.ZCylinder(r=control_drum_OD.r-1.5) # Assuming thickness of 1cm

## Rotational Reflector Planes
control_drum_min = bot_refl_min
control_drum_max = top_refl_max

# Planes to make 120 degree b4c slice
control_drum_vertical = openmc.XPlane(x0=0) # Straight vertical plane
control_drum_angled = openmc.Plane(a=0.5, b=0.87, c=0, d=0) # 30 degrees clockwise from +x-axis

## Rotational Reflector Universe

## Rotational Reflector Cells
control_drum_cell = openmc.Cell(name="Rotational Reflector BeO Cell")
control_drum_cell.region = (
        +control_drum_min & -control_drum_max & (+control_drum_vertical | +control_drum_angled) & -control_drum_ID | # Sunken-in Section
        +control_drum_min & -control_drum_max & (-control_drum_vertical | -control_drum_angled) & -control_drum_OD # Remaining Cylinder
        )
control_drum_cell.fill = beo
control_drum_univ.add_cell(control_drum_cell)

rot_b4c_cell = openmc.Cell(name="Rotational Reflector B4C Cell")
rot_b4c_cell.region = +control_drum_min & -control_drum_max & (+control_drum_vertical | +control_drum_angled) & +control_drum_ID & -control_drum_OD
rot_b4c_cell.fill = b4c
control_drum_univ.add_cell(rot_b4c_cell)

""" Rotational Reflector Plots """
control_drum_plot_geometry = openmc.Geometry(control_drum_univ)
control_drum_plot_geometry.export_to_xml()

xy_control_drum_plot = openmc.Plot()
xy_control_drum_plot.basis = 'xy'
xy_control_drum_plot.origin = (0, 0, 45.1235)
xy_control_drum_plot.width = (30., 30.)
xy_control_drum_plot.pixels = (800, 800)
xy_control_drum_plot.color_by = 'material'
xy_control_drum_plot.colors = MODEL_COLORS
xy_control_drum_plot.filename = "xy rotational reflector"

yz_control_drum_plot = openmc.Plot()
yz_control_drum_plot.basis = 'yz'
yz_control_drum_plot.origin = (0, 0, 45.1235)
yz_control_drum_plot.width = (30., 120.)
yz_control_drum_plot.pixels = (800, 3200)
yz_control_drum_plot.color_by = 'material'
yz_control_drum_plot.colors = MODEL_COLORS
yz_control_drum_plot.filename = "yz rotational reflector"

plots = openmc.Plots([xy_control_drum_plot, yz_control_drum_plot])
plots.export_to_xml()
openmc.plot_geometry()

### Stationary Reflector Universe (Contains Drums)
"""
The stationary reflector is made entirely of beryllium oxide, with four cutouts
for the control drums to be placed into. Like the control drums, the stationary
reflector spans the length of the fuel meat.
"""
stat_refl_univ = openmc.Universe(name="Stationary Reflector Universe")

## Stationary Reflector Surfaces
stat_refl_OD = openmc.ZCylinder(r=27.2575)
stat_refl_ID = vessel_OD

n_drum = openmc.ZCylinder(r=control_drum_OD.r, x0=0, y0=vessel_OD.r + control_drum_OD.r)
e_drum = openmc.ZCylinder(r=control_drum_OD.r, x0=vessel_OD.r + control_drum_OD.r, y0=0)
s_drum = openmc.ZCylinder(r=control_drum_OD.r, x0=0, y0=-(vessel_OD.r + control_drum_OD.r))
w_drum = openmc.ZCylinder(r=control_drum_OD.r, x0=-(vessel_OD.r + control_drum_OD.r), y0=0)

## Stationary Reflector Planes
stat_refl_min = bot_refl_min
stat_refl_max = top_refl_max

## Stationary Reflector Cells
# Define exclusion regions to slot drums into
drum_region = +n_drum & +e_drum & +s_drum & +w_drum

stat_refl_cell = openmc.Cell(name="Stationary Reflector Cell")
stat_refl_cell.region = +stat_refl_min & -stat_refl_max & +stat_refl_ID & -stat_refl_OD & drum_region
stat_refl_cell.fill = beo
stat_refl_univ.add_cell(stat_refl_cell)

n_drum_cell = openmc.Cell(name="North Rotational Reflector Cell")
n_drum_cell.region = +stat_refl_min & -stat_refl_max & -n_drum
n_drum_cell.fill = control_drum_univ
n_drum_cell.rotation = (0, 0, N_DRUM_ROTATION + 60) # 60 degrees counter-clockwise places arc northwards
n_drum_cell.translation = (n_drum.x0, n_drum.y0, 0)
stat_refl_univ.add_cell(n_drum_cell)

e_drum_cell = openmc.Cell(name="East Rotational Reflector Cell")
e_drum_cell.region = +stat_refl_min & -stat_refl_max & -e_drum
e_drum_cell.fill = control_drum_univ
e_drum_cell.rotation = (0, 0, E_DRUM_ROTATION + 60)
e_drum_cell.translation = (e_drum.x0, e_drum.y0, 0)
stat_refl_univ.add_cell(e_drum_cell)

s_drum_cell = openmc.Cell(name="South Rotational Reflector Cell")
s_drum_cell.region = +stat_refl_min & -stat_refl_max & -s_drum
s_drum_cell.fill = control_drum_univ
s_drum_cell.rotation = (0, 0, S_DRUM_ROTATION + 60)
s_drum_cell.translation = (s_drum.x0, s_drum.y0, 0)
stat_refl_univ.add_cell(s_drum_cell)

w_drum_cell = openmc.Cell(name="West Rotational Reflector Cell")
w_drum_cell.region = +stat_refl_min & -stat_refl_max & -w_drum
w_drum_cell.fill = control_drum_univ
w_drum_cell.rotation = (0, 0, W_DRUM_ROTATION + 60)
w_drum_cell.translation = (w_drum.x0, w_drum.y0, 0)
stat_refl_univ.add_cell(w_drum_cell)

""" Stationary Reflector Plots """
stat_refl_plot_geometry = openmc.Geometry(stat_refl_univ)
stat_refl_plot_geometry.export_to_xml()

xy_stat_refl_plot = openmc.Plot()
xy_stat_refl_plot.basis = 'xy'
xy_stat_refl_plot.origin = (0, 0, 45.1235)
xy_stat_refl_plot.width = (70., 70.)
xy_stat_refl_plot.pixels = (700, 700)
xy_stat_refl_plot.color_by = 'material'
xy_stat_refl_plot.colors = MODEL_COLORS
xy_stat_refl_plot.filename = "xy stationary reflector"

yz_stat_refl_plot = openmc.Plot()
yz_stat_refl_plot.basis = 'yz'
yz_stat_refl_plot.origin = (0, 0, 45.1235)
yz_stat_refl_plot.width = (70., 140.)
yz_stat_refl_plot.pixels = (700, 1400)
yz_stat_refl_plot.color_by = 'material'
yz_stat_refl_plot.colors = MODEL_COLORS
yz_stat_refl_plot.filename = "yz stationary reflector"

plots = openmc.Plots([xy_stat_refl_plot, yz_stat_refl_plot])
plots.export_to_xml()
openmc.plot_geometry()

### Final Universe
"""
OpenMC requires a "root" universe, the home universe that all other geometries are placed into. In this model,
that is the core, stationary reflector, control drum, and surrounding air.
"""
root_univ = openmc.Universe(name="Root Universe")

## Root Surfaces
root_vessel_OD = vessel_OD

root_n_drum = n_drum
root_e_drum = e_drum
root_s_drum = s_drum
root_w_drum = w_drum

root_stat_refl_OD = stat_refl_OD

# Bounding cylinder with boundary conditions
"""
The vessel_min and vessel_max planes already have a vacuum condition applied. It is important
that the model be surrounded by vacuum boundary conditions, otherwise OpenMC will error as it thinks
there are undefined regions remaining. We want those particles to count as leakage, which is how the vacuum
condition is used.
"""
bound_OD = openmc.ZCylinder(r=stat_refl_OD.r + control_drum_OD.r, boundary_type='vacuum')
bound_min = vessel_min
bound_max = vessel_max

bound_region = +bound_min & -bound_max & -bound_OD

## Root Planes
root_vessel_min = vessel_min
root_vessel_max = vessel_max

root_stat_refl_min = stat_refl_min
root_stat_refl_max = stat_refl_max

## Root Cells
root_vessel_cell = openmc.Cell(name="Root Reactor Core Cell")
root_vessel_cell.region = +root_vessel_min & -root_vessel_max & -root_vessel_OD
root_vessel_cell.fill = core_univ
root_univ.add_cell(root_vessel_cell)

root_refl_cell = openmc.Cell(name="Root Reflector Structures Cell")
root_refl_cell.region = (
        +root_stat_refl_min & -root_stat_refl_max &
        (-root_stat_refl_OD | -root_n_drum | -root_e_drum | -root_s_drum | -root_w_drum)
        )
root_refl_cell.fill = stat_refl_univ
root_univ.add_cell(root_refl_cell)

root_void_inf_cell = openmc.Cell(name="Root Surrounding Air Cell")
root_void_inf_cell.region = (
        +stat_refl_max & -bound_max & +vessel_OD & -bound_OD | # Top circular region
        +bound_min & -stat_refl_min & +vessel_OD & -bound_OD | # Bottom circular region
        +stat_refl_min & -stat_refl_max &
        (+stat_refl_OD & +root_n_drum & +root_e_drum & +root_s_drum & +root_w_drum) & -bound_OD # Middle section
        )
root_void_inf_cell.fill = void
root_univ.add_cell(root_void_inf_cell)

""" Root Universe Plotting """
root_plot_geometry = openmc.Geometry(root_univ)
root_plot_geometry.export_to_xml()

xy_root_plot = openmc.Plot()
xy_root_plot.basis = 'xy'
xy_root_plot.origin = (0, 0, 45.1235)
xy_root_plot.width = (60., 60.)
xy_root_plot.pixels = (1200, 1200)
xy_root_plot.color_by = 'material'
xy_root_plot.colors = MODEL_COLORS
xy_root_plot.filename = "xy root universe"

yz_root_plot = openmc.Plot()
yz_root_plot.basis = 'yz'
yz_root_plot.origin = (0, 0, 45.1235)
yz_root_plot.width = (60., 120.)
yz_root_plot.pixels = (1200, 2400)
yz_root_plot.color_by = 'material'
yz_root_plot.colors = MODEL_COLORS
yz_root_plot.filename = "yz root universe"

plots = openmc.Plots([xy_root_plot, yz_root_plot])
plots.export_to_xml()
openmc.plot_geometry()
"""
If you want to plot the flux, fissions, energies, or other reactor physics, you need to generate a tallies.xml.
This model is currently designed for k-eigenvalue calculations only. More details on tally options can be found
in the OpenMC documentation. An example tally code is commented out below for reference.
"""
"""
#### Tallies
tallies = openmc.Tallies()

## Generate Mesh Filter
core_mesh = openmc.RegularMesh()
core_mesh.dimension = [100, 100, 100]
core_mesh.lower_left = [-15, -15, 0]
core_mesh.upper_right = [15, 15, 100]

core_mesh_filter = openmc.MeshFilter(core_mesh)

## Generate Energy filter
energies = np.logspace(np.log10(1e-5), np.log10(20.0e6), 501)
core_energy_filter = openmc.EnergyFilter(energies)

## Basic fission tally
spectrum_tally = openmc.Tally(name="Fission Tally")
spectrum_tally.scores = ['flux', 'fission']
spectrum_tally.filters = [core_energy_filter]
tallies.append(spectrum_tally)

## Export tallies
tallies.export_to_xml()
"""
#### Run the simulation
"""
The last step is to define our simulation settings and run the Monte Carlo code. We must have a geometry, materials,
and settings .xml file for the code to run. It's important to check that we are exporting the root geometry to
.xml given the many times we created .xmls for plotting above.
"""
### Simulation Settings
settings = openmc.Settings()
settings.run_mode = 'eigenvalue'

"""
The below settings result in a runtime of about 30 minutes and a std. dev. of ~30 pcm
"""
settings.particles = 25000
settings.batches = 500
settings.inactive = 50
settings.seed = 1

"""
This temperature setting allows us to test the reactor using cross-section data at 900K and thermal
scattering data at either 800K or 1000K. OpenMC does have a temperature interpolation mode if that
implementation is desired.
"""
# Change temp to nearest and increase tolerance
settings.temperature = {
        'method': 'nearest',
        'tolerance': 99
        }

"""
The source provides the initial distribution of neutrons for the simulation. Inactive batches prevent
calculating k_eff before this distribution has converged to the reactivity of the actual reactor.
"""
## Source
source = openmc.IndependentSource()
source.space = openmc.stats.Box((-15,-15,0),(15,15,90))
source.constraints = {'fissionable': True}
settings.source = source

### Run Simulation
geometry = openmc.Geometry(root_univ)
geometry.export_to_xml()
settings.export_to_xml()
# Materials were exported above
"""
openmc.run() will use one thread, while the above line will run openmc in parallel with 48 cpu cores.
Change this value to the number of cores if you wish to run the model in parallel for faster simulation times.
"""
#openmc.run(mpi_args=['mpiexec', '-n', '48'])
openmc.run()
