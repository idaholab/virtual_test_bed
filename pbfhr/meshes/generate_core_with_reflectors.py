#!python

# 2-D mesh of the PB-FHR reactor, consisting of the core and reflectors

import numpy as np
import sys
import os

# append path to module so cubit can find it
sys.path.append(os.getcwd())
import pbfhr as fhr

# whether to include orificing along the outflow boundary
plenum = True

# meshing scheme
scheme = 'Map'

# approximate element size
dx = 0.06

cubit.cmd('reset')

################################################################################
# Surface (volume) definitions
################################################################################

# Current index and dictionnary of indices
index = 1
ind = {}

####
# Inner reflector (surface 1, block 1)

# Create left most vertices
cubit.cmd('create vertex 0.01 ' + str(fhr.geometry['inner_cr_channel']['z'][0]) + ' 0')
cubit.cmd('create vertex 0.01 ' + str(fhr.geometry['inner_cr_channel']['z'][-1]) + ' 0')
ind['center_axis'] = index
index += 2

# Create vertices defining the inner reflector
ind['inner_reflector'] = index
for i in [0, fhr.geometry['inner_cr_channel']['n_vertices'] - 1]:   #range(fhr.geometry['inner_cr_channel']['n_vertices']):
  cubit.cmd('create vertex ' + str(fhr.geometry['inner_cr_channel']['r'][i]) + ' ' + str(fhr.geometry['inner_cr_channel']['z'][i]) + ' 0')
  index += 1

# Create surface from those vertices
vertices = "4 3 1 2"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Control rod channel (surface 2, block 2)

# Create vertices at the right of the channel
cubit.cmd('create vertex 0.35 ' + str(fhr.geometry['inner_cr_channel']['z'][0]) + ' 0')
cubit.cmd('create vertex 0.35 ' + str(fhr.geometry['inner_cr_channel']['z'][-1]) + ' 0')
ind['inner_cr_channel'] = index
index += 2

# Create vertices where the channel touches the active region, as well as the other part of the reflector
for i in range(fhr.geometry['inner_radius']['n_vertices']):
  cubit.cmd('create vertex ' + str(fhr.geometry['inner_radius']['r'][i]) + ' ' + str(fhr.geometry['inner_radius']['z'][i]) + ' 0')
index += fhr.geometry['inner_radius']['n_vertices']

# Make the control rod channel surface
vertices = "3 4 6 12 11 10 5"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Inner reflector outside of the control rod channel (surface 3 & 4, block 1)
# Bottom part
vertices = "10 5 7 8 9"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('merge all')
cubit.cmd('compress all')

# Top part
vertices = "14 13 12 6"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Fueled active region (surface 5, block 3)

# Create the vertices between the fuel and the reflector pebbles
ind['active_region'] = index
for i in range(fhr.geometry['middle_radius']['n_vertices']):
    cubit.cmd('create vertex ' + str(fhr.geometry['middle_radius']['r'][i]) + ' ' + str(fhr.geometry['middle_radius']['z'][i]) + ' 0')
index += fhr.geometry['middle_radius']['n_vertices']

# create surface from vertices defining the active region
vertices = "7 8 16 15"
cubit.cmd('create surface vertex ' + vertices)
vertices = "8 9 17 16"
cubit.cmd('create surface vertex ' + vertices)
vertices = "9 10 18 17"
cubit.cmd('create surface vertex ' + vertices)
vertices = "10 11 19 18"
cubit.cmd('create surface vertex ' + vertices)
vertices = "11 12 20 19"
cubit.cmd('create surface vertex ' + vertices)
vertices = "12 13 21 20"
cubit.cmd('create surface vertex ' + vertices)
vertices = "13 14 22 21"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('compress all')
cubit.cmd('merge all')

# ####
# # Reflector/blanket pebbles region (surface 6, block 4)
ind['pebble_reflector'] = index
for i in range(fhr.geometry['outer_radius']['n_vertices']):
    cubit.cmd('create vertex ' + str(fhr.geometry['outer_radius']['r'][i]) + ' ' + str(fhr.geometry['outer_radius']['z'][i]) + ' 0')
index += fhr.geometry['outer_radius']['n_vertices']
cubit.cmd('compress all')
cubit.cmd('merge all')

vertices = "15 16 24 23"
cubit.cmd('create surface vertex ' + vertices)
vertices = "16 17 18 19 25 24"
cubit.cmd('create surface vertex ' + vertices)
vertices = "19 20 26 25"
cubit.cmd('create surface vertex ' + vertices)
if (not plenum):
    vertices = "20 21 27 26"
else:
    cubit.cmd('create vertex 0.94333 4.42014 0')
    cubit.cmd('compress all')
    cubit.cmd('merge all')
    index += 1
    vertices = "26 39 27 21 20"  # should be 29!
cubit.cmd('create surface vertex ' + vertices)
vertices = "21 22 28 27"
cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('compress all')
cubit.cmd('merge all')

# ####
# # Plenum

if plenum:
    # split the curve on the right to permit different boundary condition specifications.
    # First we need to split the curve according which part of the boundary is outflow.
    # cubit.cmd('split curve 40 fraction ' + str(1.0 - fhr.bcs['outflow_h_fraction']))
    # cubit.cmd('merge all')
    # cubit.cmd('compress all')
    #
    # Create the rest of the plenum outlet
    #TODO Create orifices for the connection to the plenum
    #TODO Add a component limiting flow from the plenum to reflector
    # We have not found specifications, so all of this is assumed
    cubit.cmd('create vertex 1.05 4.47017 0')
    cubit.cmd('create vertex 1.05 5.3125 0')
    cubit.cmd('create vertex 1.25 5.3125 0')
    cubit.cmd('create vertex 1.25 4.47017 0')
    cubit.cmd('compress all')
    cubit.cmd('merge all')
    #
    index += 4
    vertices = '29 30 33 26'
    cubit.cmd('create surface vertex ' + vertices)
    vertices = '30 31 32 33'
    cubit.cmd('compress all')
    cubit.cmd('merge all')
    cubit.cmd('create surface vertex ' + vertices)
    cubit.cmd('compress all')
    cubit.cmd('merge all')

# ####
# # Outer reflector surface (surface 7, block 5)
#
# # create vertices defining the outer reflector and surface
ind['outer_reflector'] = index
cubit.cmd('create vertex ' + str(fhr.geometry['barrel']['inner_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][-1]) + ' 0')
cubit.cmd('create vertex ' + str(fhr.geometry['barrel']['inner_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][0]) + ' 0')
index += 2
cubit.cmd('compress all')
cubit.cmd('merge all')

if not plenum:
    vertices = "28 27 26 25 24 23 30 29"
    cubit.cmd('create surface vertex ' + vertices)
else:
    # Between defueling chute and plenum
    vertices = "28 27 29 30 31"
    cubit.cmd('create surface vertex ' + vertices)
    # Outside of plenum
    vertices = "35 34 32 33 26 25 24 23"
    cubit.cmd('create surface vertex ' + vertices)
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Core barrel (surface 8, block 6)
cubit.cmd('create vertex ' + str(fhr.geometry['barrel']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][-1]) + ' 0')
cubit.cmd('create vertex ' + str(fhr.geometry['barrel']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][0]) + ' 0')
ind['core_barrel'] = index
index += 2
cubit.cmd('create surface vertex '+str(ind['outer_reflector']+1)+' '+str(ind['outer_reflector'])+' '+\
                                   str(ind['core_barrel'])+' '+str(ind['core_barrel']+1))
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Downcomer (surface 9, block 7)
cubit.cmd('create vertex ' + str(fhr.geometry['downcomer']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][-1]) + ' 0')
cubit.cmd('create vertex ' + str(fhr.geometry['downcomer']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][0]) + ' 0')
ind['downcomer'] = index
index += 2
cubit.cmd('create surface vertex '+str(ind['core_barrel']+1)+' '+str(ind['core_barrel'])+' '+\
                                   str(ind['downcomer'])+' '+str(ind['downcomer']+1))
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Vessel (surface 10, block 8)
cubit.cmd('create vertex ' + str(fhr.geometry['vessel']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][-1]) + ' 0')
cubit.cmd('create vertex ' + str(fhr.geometry['vessel']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][0]) + ' 0')
ind['vessel'] = index
index += 2
cubit.cmd('create surface vertex '+str(ind['downcomer']+1)+' '+str(ind['downcomer'])+' '+\
                                   str(ind['vessel'])+' '+str(ind['vessel']+1))
cubit.cmd('merge all')
cubit.cmd('compress all')

####
# Fire bricks (surface 11, block 9)
cubit.cmd('create vertex ' + str(fhr.geometry['bricks']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][-1]) + ' 0')
cubit.cmd('create vertex ' + str(fhr.geometry['bricks']['outer_radius']) + ' ' + str(fhr.geometry['outer_radius']['z'][0]) + ' 0')
ind['bricks'] = index
index += 2
cubit.cmd('create surface vertex '+str(ind['vessel']+1)+' '+str(ind['vessel'])+' '+\
                                   str(ind['bricks'])+' '+str(ind['bricks']+1))
cubit.cmd('merge all')
cubit.cmd('compress all')

################################################################################
# Mesh generation
################################################################################
refinement = 1

# Set intervals for each curves
# Oulet regions
cubit.cmd('curve 16 30 interval '+str(4*refinement))
cubit.cmd('curve 40 interval '+str(3*refinement))
cubit.cmd('curve 41 interval '+str(refinement))
cubit.cmd('curve 15 32 43 interval '+str(5*refinement))
# Main pebble region
cubit.cmd('curve 7 28 39 interval '+str(10*refinement))
# Inlet regions
cubit.cmd('curve 8 26 interval '+str(2*refinement))
cubit.cmd('curve 14 24 interval '+str(refinement))
cubit.cmd('curve 13 22 interval '+str(refinement))
cubit.cmd('curve 12 19 interval '+str(3*refinement))
# Plenum bottom
cubit.cmd('curve 45 interval '+str(refinement))
cubit.cmd('curve 47 interval '+str(2*refinement))
# cubit.cmd('surface 17 size '+str(0.02/refinement**2))
# Plenum top
cubit.cmd('curve 48 50 interval '+str(6*refinement))
cubit.cmd('curve 46 49 interval '+str(2*refinement))

# Inner reflector side
# cubit.cmd('curve 6 interval 5')
# cubit.cmd('curve 1 3 interval 30')
# cubit.cmd('curve 9 interval 5')
cubit.cmd('curve 2 4 interval '+str(refinement))
cubit.cmd('curve 10 5 interval '+str(refinement))
# cubit.cmd('curve 11 17 interval 1')
# Horizontal for flow regions
cubit.cmd('curve 31 29 27 25 23 21 18 20 interval '+str(3*refinement))
cubit.cmd('curve 35 33 36 38 43 42 interval '+str(refinement))

# mesh the entire domain
# cubit.cmd('surface 1 2 3 4 5 6 7 8 9 10 11 12 size ' + str(dx))
cubit.cmd('surface 1 2 3 4 5 6 7 8 9 10 11 12 scheme ' + scheme)
cubit.cmd('block 1 surface 1 3 4') # inner reflector
cubit.cmd('block 2 surface 2')     # control rod channel
cubit.cmd('block 3 surface 5 6 7 8 9 10 11')    # core
cubit.cmd('block 4 surface 12 13 14 15 16')     # pebble reflector
cubit.cmd('block 5 surface 17 18')     # plenum
cubit.cmd('block 6 surface 19 20')  # outer reflector
cubit.cmd('block 7 surface 21')     # core barrel
cubit.cmd('block 8 surface 22')     # downcomer
cubit.cmd('block 9 surface 23')     # vessel
cubit.cmd('block 10 surface 24')    # bricks
cubit.cmd('mesh surface 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24')

################################################################################
# Curves and sideset definitions
################################################################################

# Inflow
cubit.cmd('sideset 101 curve 20 wrt surface 5')
cubit.cmd('sideset 101 curve 35 wrt surface 12')
cubit.cmd('sideset 101 name "bed_horizontal_bottom"')

# Outflow
cubit.cmd('sideset 102 curve 31 wrt surface 11')
cubit.cmd('sideset 102 curve 42 wrt surface 16')
cubit.cmd('sideset 102 name "bed_horizontal_top"')
cubit.cmd('sideset 103 curve 46 wrt surface 17')
cubit.cmd('sideset 103 name "plenum_top"')

# Inner
cubit.cmd('sideset 104 curve 12 13 14 7 8 15 16 wrt volume 3')
cubit.cmd('sideset 104 name "bed_left"')

# Right-most boundary
cubit.cmd('sideset 105 curve 64 wrt volume 9')
cubit.cmd('sideset 105 name "brick_surface"')

################################################################################
# Refine some interfaces
################################################################################

# interfaces between _large_ changes in porosity
# porosity_interfaces = '14 15 16 21 23 25'
#
# cubit.cmd('refine curve ' + porosity_interfaces + ' numsplit 1 bias 1.0 depth 2 smooth')
#
# cubit.cmd('surface 1 2 3 4 5 smooth scheme condition number beta 1.2 cpu 10')
#
# more_refinement = '4 34 35 25 30 1 15 16'
#
# cubit.cmd('refine curve ' + more_refinement + ' numsplit 1 bias 1.0 depth 1 smooth')
#
# # refine on angled section near bottom
# cubit.cmd('refine curve 2 numsplit 1 bias 1.0 depth 5 smooth')
#
# # curves near the inlet where there is a rapid redistribution of the flow
# inlet_refinement = '12 13 14 39'
# cubit.cmd('refine curve ' + inlet_refinement  + ' numsplit 1 bias 1.0 depth 2 smooth')

# if (orifice == False):
#     curves = fhr.number_string(1, 6, 1) + ' ' + fhr.number_string(12, 18, 1)
#     cubit.cmd('refine curve ' + curves + ' 25 26 numsplit 1 bias 1.0 depth 2 smooth')
#     cubit.cmd('surface 1 2 3 4 smooth scheme condition number beta 1.2 cpu 10')
# else:
#     curves = fhr.number_string(1, 6, 1) + ' ' + fhr.number_string(12, 17, 1) + fhr.number_string(24, split_curves[-1], 1)
#     cubit.cmd('refine curve ' + curves + ' numsplit 1 bias 1.0 depth 2 smooth')
#     cubit.cmd('surface 1 2 smooth scheme condition number beta 1.2 cpu 10')

# curves = fhr.number_string(7, 11, 1)
# cubit.cmd('refine curve ' + curves + ' numsplit 1 bias 1.0 depth 1 smooth')
# cubit.cmd('surface 1 2 smooth scheme condition number beta 1.2 cpu 10')

################################################################################
# Output
################################################################################

# Select file name
filename = 'core_CFD'
filename += "_" + str(dx)

# save file
cubit.cmd('set large exodus file on')
cubit.cmd('export Genesis  "/Users/giudgl/projects/virtual_test_bed/pbfhr/meshes/' + filename + '.e" dimension 2  overwrite')
