# This is a Python module containing all of the geometrical information relevant to the modeling
# of the PB-FHR. By placing this information in this script, it can be shared by models used in
# a variety of different codes. All information in this document are from the following sources:

# [1] Mk-1 PB-FHR design report:
#       http://fhr.nuc.berkeley.edu/wp-content/uploads/2014/10/14-002-PB-FHR_Design_Report_Final.pdf
# [2] Xin Wang's PhD thesis

# The geometrical information information in this script is incomplete due to a lack of
# information. The following TODO codes are included to clearly indicate the level of trust
# expected of the information used here:
#
#   TODO (confirm): an estimate exists, but differs between sources
#   TODO (refine):  a rough estimate is used not based on a particular source
#   TODO (find):    an arbitrary guess is used

# All units are specified in units of meters. Because Monte Carlo codes are almost universally
# based on length units of centimeters, the get_mc_length() method multiplies a variable
# within this module by 100.0 to obtain units of centimeters.

import numpy as np
import random as rand
import math

# dictionary holding all information relevant to the boundary conditions
bcs = {}

# dictionary holding all information relevant to the macroscopic geometry of the bed
geometry = {}

# dictionary holding all information relevant to the pebble geometry
pebble = {}

# dictionary holding all information relevant to the fuel particle geometry
particle = {}

# dictionary holding all information relevant to the meshing
mesh = {}

# dictionary holding all of the nominal steady-state operating conditions
state = {}


# The radial arrangement of the core at any given horizontal slice is as follows.
# The notation used in the 'geometry' dictionary to is indicated on the second line below.
#
#   inner reflector  |  pebble bed  |  outer reflector  |  barrel  |  downcomer  |  vessel | bricks
#                    ^              ^
#               inner_radius   outer_radius
#
# Within the pebble bed, a thin region of graphite pebbles is placed at the core outer
# periphery. The transition between the active region and this reflector region is defined
# as 'middle_radius'.

inner_cr_channel = {}
inner_radius  = {}
outer_radius  = {}
middle_radius = {}
vessel        = {}
downcomer     = {}
barrel        = {}
outlet_plenum = {}
bricks        = {}

bricks['outer_radius'] = 1.75 + 0.5                           # [1]
vessel['outer_radius'] = 1.75                                 # [1] table 1.7
vessel['inner_radius'] = vessel['outer_radius'] - 0.05        # TODO (confirm) [2], but 0.06 in [1] table 1.5
downcomer['outer_radius'] = vessel['inner_radius']            #
downcomer['inner_radius'] = downcomer['outer_radius'] - 0.028 # [1] page 47 last paragraph
barrel['outer_radius'] = downcomer['inner_radius']            #
barrel['inner_radius'] = 1.65                                 # from solidworks model

inner_cr_channel = {}
inner_cr_channel['r'] = [0.2, 0.2, 0.2, 0.2, 0.2]
inner_cr_channel['z'] = [0, 1.328, 2.656, 3.984, 5.3125]

# radial coordinates corresponding to edge of each straight-line segment of the inner radial
# boundary of the core. The PB-FHR inner radial boundary consists of five straight-line
# segments, two of which are angled interspersed between the straight line segments. All data
# from [1] page 44 paragrah 1, supported by [2] table C.1
inner_radius['r'] = [0.45, 0.45, 0.45, 0.35, 0.35, 0.35, 0.71, 0.71]

# axial coordinates corresponding to the bottom of each straight-line segment of the inner
# radial boundary of the core; [2] table C.1
inner_radius['z'] = [0.0, 0.709, 0.859, 1.0322, 1.389, 3.889, 4.5125, 5.3125]

if (len(inner_radius['r']) != len(inner_radius['z'])):
  raise ValueError("Number of radial and axial coordinate points do not match for "\
    "'inner_radius'")

# radial coordinates corresponding to the edge of each straight-line segment of the outer radial
# boundary of the core. The PB-FHR outer radial boundary consists of five straight-line
# segments, two of which are angled interspersed between the straight line segments. All data
# from [2] table C.1. No data is available for radii at the top, so we center the outlet port,
# supported by [2] figure 4.3.
OR_middle_r = 1.25    # [1] table 2.1

x = inner_radius['r'][-2] - inner_radius['r'][-3]
outer_radius['r'] = [0.8574, 0.8574, OR_middle_r, OR_middle_r, OR_middle_r - x, \
  OR_middle_r - x]

# axial coordinates corresponding to the bottom of each straight-line segment of the outer
# radial boundary of the core; [2] table C.1. The axial coordinates in [2] Table C.1 are
# slightly incorrect, and an inclination angle of 30 degrees is used.
z = math.tan(60.0 / 180.0 * math.pi) * (outer_radius['r'][2] - outer_radius['r'][1])
outer_radius['z'] = [0.0, 0.709, z + 0.709, inner_radius['z'][-3], inner_radius['z'][-2],\
  inner_radius['z'][-1]]

if (len(outer_radius['r']) != len(outer_radius['z'])):
  raise ValueError("Number of radial and axial coordinate points do not match for "\
    "'outer_radius'")

# radial coordinates corresponding to the boundary between the active and reflector pebbles;
# Table C.2 [2]. From Fig. 4.3 [2], it appears that the radial position is constant within
# the fueling and defueling chutes, so this is assumed here. The width of the graphite
# pebble region in the defueling chute is 9 cm according to Table C.3 [2], so because we
# centered the outlet chute above, we define the defueling chute thickness based on a
# thickness of 9 cm.
middle_radius['r'] = [0.7541, 0.7541, 0.81937, 0.89474, 1.05, 1.05, outer_radius['r'][-2] - 0.09, outer_radius['r'][-1] - 0.09]

# axial coordinates corresponding to the boundary between the active and reflector pebbles;
# Fig. 4.3 [2] suggests that the axial positions are the same as those used for the outer_radius.
middle_radius['z'] = [0.0, 0.709, 0.859, 1.0322, z + 0.709, inner_radius['z'][-3], inner_radius['z'][-2],\
  inner_radius['z'][-1]]

if (len(middle_radius['r']) != len(middle_radius['z'])):
  raise ValueError("Number of radial and axial coordinate points do not match for "\
    "'middle_radius'")

# arbitrary specifications for the outlet plenum section within the outer reflector.
# All values are entirely invented. TODO (find)

# perpendicular distance away from the pebble bed that the outlet plenum connector extends
outlet_plenum['perpendicular_distance'] = 0.1

# width of the outlet plenum upon exiting the top of the reflector
outlet_plenum['outlet_width'] = 0.2

if (outlet_plenum['perpendicular_distance'] > (vessel['inner_radius'] - outer_radius['r'][3])):
  raise ValueError("Perpendicular distance cannot consume the entire width of the "\
    "outer reflector")


# populate the geometry dictionary
geometry['inner_cr_channel'] = inner_cr_channel
geometry['inner_cr_channel']['n_vertices'] = len(geometry['inner_cr_channel']['r'])
geometry['inner_radius'] = inner_radius
geometry['inner_radius']['n_vertices'] = len(geometry['inner_radius']['r'])
geometry['outer_radius'] = outer_radius
geometry['outer_radius']['n_vertices'] = len(geometry['outer_radius']['r'])
geometry['middle_radius'] = middle_radius
geometry['middle_radius']['n_vertices'] = len(geometry['middle_radius']['r'])
geometry['barrel']        = barrel
geometry['downcomer']     = downcomer
geometry['vessel']        = vessel
geometry['outlet_plenum'] = outlet_plenum
geometry['bricks']        = bricks

# nominal average pebble porosity
geometry['porosity'] = 0.4

# nominal porosity of outer reflector
geometry['OR_porosity'] = 0.4

# nominal porosity of outlet plenum
geometry['plenum_porosity'] = 0.5

# nominal porosity of the inner reflector
geometry['IR_porosity'] = 0.5


# TODO (find) fraction of outermost outer_radius['r'] through which flow exits
bcs['outflow_h_fraction'] = 0.4


# basic information related to the geometry
mesh['can_webcut'] = geometry['inner_radius']['n_vertices'] == geometry['outer_radius']['n_vertices']
mesh['n_vertices'] = geometry['inner_radius']['n_vertices'] + \
  geometry['outer_radius']['n_vertices'] + geometry['middle_radius']['n_vertices'] + geometry['inner_cr_channel']['n_vertices']
mesh['n_surfaces'] = mesh['n_vertices'] / 2 - 1
mesh['n_webcuts']  = mesh['n_surfaces'] - 1


# for orificed boundaries, we need to specify the width of each port and the distance
# between ports. We currently assume that all outlet ports are the same size and that
# a boundary is orified such that at the edges of the boundary is a solid wall.
# TODO (find): determine orificing structure
#
# |----|--------------|----|---------------|----|-------------------|----|
#  ^- port_sep                ^- port_width
#
# We specify a minimum port separation, and for each boundary, determine the actual
# port separation that allows us to include the most number of ports.
min_port_sep = 0.1
port_width   = 0.2

# [3], table 2.1, except that the thickness of the fuel-matrix annulus is changed
# from 1.5 mm to 2 mm (while decreasing the size of the central core). See
# documentation in `dissertation/pbfhr/documentation` for references and results
# showing that 4730 TRISO particles probably can't fit in the original, very thin,
# annulus, especially when considering a realistic minimum separation distance
# between particles.
pebble['dr'] = [0.012, 0.002, 0.001]

particle['dr'] = [200e-6, 100e-6, 35e-6, 35e-6, 35e-6]  # [3], table III

particle['cumulative_dr'] = np.zeros(len(particle['dr']))
particle['cumulative_dr'][0] = particle['dr'][0]

for i in range(1, len(particle['dr'])):
  particle['cumulative_dr'][i] = particle['cumulative_dr'][i - 1] + particle['dr'][i]

pebble['cumulative_dr'] = np.zeros(len(pebble['dr']))
pebble['cumulative_dr'][0] = pebble['dr'][0]

for i in range(1, len(pebble['dr'])):
  pebble['cumulative_dr'][i] = pebble['cumulative_dr'][i - 1] + pebble['dr'][i]

# volumes of each of the layers of the pebble
pebble['volumes'] = np.zeros(len(pebble['dr']))
pebble['volumes'][0] = 4.0 / 3.0 * math.pi * (pebble['cumulative_dr'][0]**3)

for i in range(1, len(pebble['volumes'])):
  pebble['volumes'][i] = 4.0 / 3.0 * math.pi * ((pebble['cumulative_dr'][i]**3) - (pebble['cumulative_dr'][i - 1]**3))

# volumes of each of the layers of the particle
particle['volumes'] = np.zeros(len(particle['dr']))
particle['volumes'][0] = 4.0 / 3.0 * math.pi * (particle['cumulative_dr'][0]**3)

for i in range(1, len(particle['volumes'])):
  particle['volumes'][i] = 4.0 / 3.0 * math.pi * ((particle['cumulative_dr'][i]**3) - (particle['cumulative_dr'][i - 1]**3))

# volume of the particle and pebble
particle['volume'] = 4.0 / 3.0 * math.pi * (particle['cumulative_dr'][-1]**3)
pebble['volume'] = 4.0 / 3.0 * math.pi * (pebble['cumulative_dr'][-1]**3)

# phase fractions of various constituents
particle['phase_fractions'] = [i / particle['volume'] for i in particle['volumes']]
pebble['phase_fractions'] = [i / pebble['volume'] for i in pebble['volumes']]

# partice packing fraction in matrix material. This is computed based on a set
# number of 4730 particles [1] in the fuel-matrix region
pebble['np'] = 4730
particle['pf'] = pebble['np'] * particle['volume'] / pebble['volumes'][1]


# total inlet mass flowrate, [1] table 1.1, page 14
state['flowrate'] = 976.0

# fraction of total mass flowrate entering the bed from the bottom (not through the
# holes in the center reflector), [1]
state['bottom_flowrate_fraction'] = 0.3

# MWth [1]
state['power'] = 236e6

# FIND: outlet pressure (Pa)
state['outlet_pressure'] = 2.0 * 101325.0

# inlet temperature (K)
state['inlet_fluid_temperature'] = 873.15

# minimum separation between TRISO particles
particle['min_sep'] = 30e-6/2.0

# -------------------------------------- functions -------------------------------- #

def matrix_outer_radius(pf):
  # compute the outer radius of matrix surrounding material for the Stainsby T/H method
  return math.pow(particle['volume'] / pf / (4.0 / 3.0 * math.pi), 1.0 / 3.0)

def orifice_splitting(l):
  # returns a vector of the fractional distance to split with each curve splitting.
  # For an integer n = number of ports, find the port separation that is closest to l.
  # n * port_width + (n + 1) * min_port_sep = l

  n_ports = math.floor((l - min_port_sep) / (port_width + min_port_sep))

  # find the actual spacing between ports
  port_sep = (l - n_ports * port_width) / (n_ports + 1.0)

  split_fraction          = np.zeros(2 * n_ports)
  total_distance          = np.zeros(2 * n_ports)
  incremental_distance    = np.zeros(2 * n_ports)
  total_distance[0]       = l
  incremental_distance[0] = port_sep

  total_distance[0] = l
  for i in range(1, len(split_fraction)):
    incremental_distance[i] = (1 - i % 2) * port_sep + (i % 2) * port_width
    total_distance[i] = total_distance[i - 1] - incremental_distance[i - 1]

  for i in range(len(split_fraction)):
    split_fraction[i] = incremental_distance[i] / total_distance[i]

  return split_fraction


def max_separation(a, b, c, d):
  separation = vector_separation(a, b, c, d)
  index = np.argmax(separation)
  value = separation[index]
  return [index, value]

def separation(a, b):
  # compute the L-2 norm distance between points a and b
  return np.sqrt((a[0] - b[0]) ** 2 + (a[1] - b[1]) ** 2)

def number_string(start, stop, step):
  # create a string of numbers
  s = ''
  start = int(start)
  stop = int(stop)
  step = int(step)

  for i in range(start, stop + 1, step):
    s += str(i) + ' '

  return s

def vector_separation(a, b, c, d):
  # return a vector of distances between lists of points (a, b) and (c, d)
  if (len(a) != len(b) or len(c) != len(d) or len(a) != len(c)):
    raise ValueError("Length vectors must be the same in call to 'max_separation'!")

  s = np.zeros(len(a))
  for i in range(len(a)):
    s[i] = separation([a[i], b[i]], [c[i], d[i]])

  return s

def spacing(dr1, dr2, factor):
  # computes the mesh spacing given two mesh spacings dr1 and dr2 and a scaling factor
  return factor * 0.5 * (dr1 + dr2)

def get_mc_length(x):
  return x * 100.0

def get_mc_volume(x):
  return x * (100.0**3)

def inside_fuel_matrix_annulus(pt, symmetry = 1, allow_truncation = False):
  # checks that particles have their centers within the fuel-matrix annulus with
  # a particular level of symmetry (1 = full pebble, 8 = octant symmetry, 16 =
  # half-octant symmetry).

  # The incoming point is assumed to be in units of centimeters because it will be
  # coming from a Cubit mesh file, so convert to the units in this script first.
  x = pt[0] / 100.0
  y = pt[1] / 100.0
  z = pt[2] / 100.0

  rp = particle['cumulative_dr'][-1]
  rmin = rp + pebble['cumulative_dr'][0]
  rmax = pebble['cumulative_dr'][1] - rp
  r = math.sqrt(x**2 + y**2 + z**2)

  inside_annulus = r > rmin and r < rmax
  inside_octant = x > rp and y > rp and z > rp

  if (symmetry == 1):
    return inside_annulus

  if (allow_truncation):
    inside_octant = (x >= 0.0 and y >= 0.0 and z >= 0.0)

  if (symmetry == 8):
    return inside_annulus and inside_octant

  if (symmetry == 16):
    if ((not inside_octant) or (not inside_annulus)):
      return False

    inside_sector = math.atan(y / x) <= math.pi / 4.0
    if (allow_truncation):
      return inside_sector
    else:
      # find distance from y = x line
      d = np.abs(x - y) / math.sqrt(2.0)
      return inside_sector and (d > rp)

  raise ValueError

def distance(r1, r2):
  # compute distance between two points r1 and r2
  return math.sqrt((r1[0] - r2[0])**2 + (r1[1] - r2[1])**2 + (r1[2] - r2[2])**2)

def sample_particle_coordinates(face, ro, ri, rp_lim, symmetry):
  if (symmetry == 8): # octant symmetry
    if (face == 0):
      rn_y = rand.random(); rn_z = rand.random()
      xn = 0.0
      yn = rn_y * (ro - rp_lim) + rp_lim
      if (yn > ri):
        zmin = rp_lim
      else:
        zmin = math.sqrt(ri**2 - yn**2)
      zmax = math.sqrt(ro**2 - yn**2)
      zn = rn_z * (zmax - zmin) + zmin
    elif (face == 1):
      rn_x = rand.random(); rn_z = rand.random()
      xn = rn_x * (ro - rp_lim) + rp_lim
      yn = 0.0
      if (xn > ri):
        zmin = rp_lim
      else:
        zmin = math.sqrt(ri**2 - xn**2)
      zmax = math.sqrt(ro**2 - xn**2)
      zn = rn_z * (zmax - zmin) + zmin
    elif (face == 2):
      rn_x = rand.random(); rn_y = rand.random()
      xn = rn_x * (ro - rp_lim) + rp_lim
      zn = 0.0
      if (xn > ri):
        ymin = rp_lim
      else:
        ymin = math.sqrt(ri**2 - xn**2)
      ymax = math.sqrt(ro**2 - xn**2)
      yn = rn_y * (ymax - ymin) + ymin
    else:
      raise ValueError

  if (symmetry == 16): # 1/16th symmetry
    if (face == 0):
      rn_y = rand.random(); rn_z = rand.random()
      yn = (rn_y * (ro - rp_lim) + rp_lim) * math.sin(math.pi / 4.0)
      xn = yn
      if (yn > ri * math.sin(math.pi / 4.0)):
        zmin = rp_lim
      else:
        zmin = math.sqrt(ri**2 - yn**2 - xn**2)
      zmax = math.sqrt(ro**2 - yn**2 - xn**2)
      zn = rn_z * (zmax - zmin) + zmin
    elif (face == 1):
      rn_x = rand.random(); rn_z = rand.random()
      xn = rn_x * (ro - rp_lim) + rp_lim
      yn = 0.0
      if (xn > ri):
        zmin = rp_lim
      else:
        zmin = math.sqrt(ri**2 - xn**2)
      zmax = math.sqrt(ro**2 - xn**2)
      zn = rn_z * (zmax - zmin) + zmin
    elif (face == 2):
      # instead of writing different logic here, repeat until getting a valid point
      max_samples = 100
      samples = 0
      while (samples < max_samples):
        rn_x = rand.random(); rn_y = rand.random()
        xn = rn_x * (ro - rp_lim) + rp_lim
        zn = 0.0
        if (xn > ri):
          ymin = rp_lim
        else:
          ymin = math.sqrt(ri**2 - xn**2)
        ymax = math.sqrt(ro**2 - xn**2)
        yn = rn_y * (ymax - ymin) + ymin

        if (not inside_fuel_matrix_annulus([xn, yn, zn], symmetry, False)):
          samples += 1
        else:
          break
    else:
      raise ValueError

  return [xn, yn, zn]
