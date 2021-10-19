#!python
import math

# This Cubit script will generate a 2D Exodus mesh for the MSFR intended to be
# used for axisymmetric simulations.

# Scaling factor applied to the model before export.
scaling = 0.01  # Conversion from cm to m

################################################################################
# Define geometry parameters
################################################################################

z_top_core_cl = 80.0
z_top_hotleg = 132.5

r_core_wall_transition = 158.5
r_leg_transition = 178.5

core_wall_minor_radius = 126.4
r_toroidal_axis = 231.8

leg_dz = 23.5

dz = z_top_hotleg - z_top_core_cl
r_frac = r_core_wall_transition / r_leg_transition
z_top_wall_transition = z_top_core_cl + dz * r_frac

r_core_mesh_transition1 = 90.0
z_core_mesh_transition1 = 60.0

r_core_mesh_transition2 = 70.0
dz = z_top_hotleg - z_top_core_cl
r_frac = r_core_mesh_transition2 / r_leg_transition
z_core_mesh_transition2 = z_top_core_cl + dz * r_frac

leg_bend_ir = 15.0

z_neck = 89.0
z_shoulder = 70.0
r_outer_hx = 233.0

################################################################################
# Define the vertices for the top half of the core region
################################################################################

cubit.cmd('reset')

# Define the vertices along the top of fuel
radii = (0, r_core_mesh_transition2, r_core_wall_transition, r_leg_transition)
heights = (z_top_core_cl, z_core_mesh_transition2, z_top_wall_transition, z_top_hotleg)
for r, z in zip(radii, heights):
    cubit.cmd('create vertex {:g} {:g} 0'.format(r, z))

# Define the vertices along curved wall of the core
dz = z_top_wall_transition - leg_dz
dr = r_toroidal_axis - r_core_wall_transition
end_theta = math.atan2(dz, dr)
start_theta = -end_theta
theta_grid = [start_theta + i * (end_theta-start_theta) / 3 for i in range(4)]
for theta in theta_grid[2:]:
    r = r_toroidal_axis - core_wall_minor_radius * math.cos(theta)
    z = core_wall_minor_radius * math.sin(theta)
    cubit.cmd('create vertex {:g} {:g} 0'.format(r, z))

# Define the interior vertices used for the core mesh transitions
r = r_core_mesh_transition1
z = z_core_mesh_transition1
cubit.cmd('create vertex {:g} {:g} 0'.format(0, z))
cubit.cmd('create vertex {:g} {:g} 0'.format(r, z))

# Define the vertices used for the bends in the coldleg and hotleg
r1 = r_leg_transition
r2 = r1 + leg_bend_ir
r3 = r2 + leg_dz
z1 = z_top_hotleg - leg_dz
z2 = z1 - leg_bend_ir
cubit.cmd('create vertex {:g} {:g} 0'.format(r1, z1))
cubit.cmd('create vertex {:g} {:g} 0'.format(r2, z2))
cubit.cmd('create vertex {:g} {:g} 0'.format(r3, z2))

# Define the vertices used for the neck and shoulder of the hx/pump region
cubit.cmd('create vertex {:g} {:g} 0'.format(r2, z_neck))
cubit.cmd('create vertex {:g} {:g} 0'.format(r3, z_neck))
cubit.cmd('create vertex {:g} {:g} 0'.format(r2, z_shoulder))
cubit.cmd('create vertex {:g} {:g} 0'.format(r_outer_hx, z_shoulder))

################################################################################
# Define the curves and surfaces for the top half of the core region
################################################################################

cubit.cmd('create curve vertex 3 6')
cubit.cmd('create curve vertex 4 9')
cubit.cmd('create curve vertex 10 11')
cubit.cmd('create curve vertex 12 13')
cubit.cmd('create curve vertex 14 15')

for i in range(1, 6):
    cubit.cmd('split curve {:d} fraction 0.5'.format(i))

cubit.cmd('create curve arc vertex 5 19 radius {:g} normal 0 0 -1'.format(core_wall_minor_radius))
cubit.cmd('create curve vertex 19 23')
cubit.cmd('create curve arc vertex 23 24 radius {:g} normal 0 0 -1'.format(leg_bend_ir))
cubit.cmd('create curve vertex 24 28')
cubit.cmd('create curve vertex 28 32')

cubit.cmd('create curve vertex 17 21')
cubit.cmd('create curve arc vertex 21 26 radius {:g} normal 0 0 -1'.format(leg_bend_ir+0.5*leg_dz))
cubit.cmd('create curve vertex 26 29')
cubit.cmd('create curve vertex 29 33')

cubit.cmd('create curve vertex 16 20')
cubit.cmd('create curve arc vertex 20 27 radius {:g} normal 0 0 -1'.format(leg_bend_ir+leg_dz))
cubit.cmd('create curve vertex 27 31')
cubit.cmd('create curve vertex 31 35')

cubit.cmd('create curve vertex 7 1')
cubit.cmd('create curve vertex 5 8')
cubit.cmd('create curve vertex 8 2')

cubit.cmd('create curve vertex 7 8')
cubit.cmd('create curve vertex 8 45')
cubit.cmd('create curve vertex 1 2')
cubit.cmd('create curve vertex 2 53')

cubit.cmd('create surface curve 32 31 34 29')
cubit.cmd('create surface curve 30 16 7 33')
cubit.cmd('create surface curve 33 6 35 31')
cubit.cmd('create surface curve 17 9 21 7')
cubit.cmd('create surface curve 21 8 25 6')
cubit.cmd('create surface curve 18 10 22 9')
cubit.cmd('create surface curve 22 11 26 8')
cubit.cmd('create surface curve 12 23 10 19')
cubit.cmd('create surface curve 13 27 11 23')
cubit.cmd('create surface curve 14 24 12 20')
cubit.cmd('create surface curve 15 28 13 24')

cubit.cmd('merge all')

################################################################################
# Mesh the top half of the core region
################################################################################

cubit.cmd('curve 29 scheme bias factor 1.1 start vertex 1')
cubit.cmd('curve 31 scheme bias factor 1.1 start vertex 2')
cubit.cmd('curve 6 scheme bias factor 1.1 start vertex 16')
cubit.cmd('curve 8 scheme bias factor 1.1 start vertex 20')
cubit.cmd('curve 11 scheme bias factor 1.1 start vertex 27')
cubit.cmd('curve 13 scheme bias factor 1.1 start vertex 31')
cubit.cmd('curve 15 scheme bias factor 1.1 start vertex 35')

cubit.cmd('curve 30 scheme bias factor 1.1 start vertex 5')
cubit.cmd('curve 7 scheme bias factor 1.1 start vertex 19')
cubit.cmd('curve 9 scheme bias factor 1.1 start vertex 23')
cubit.cmd('curve 10 scheme bias factor 1.1 start vertex 24')
cubit.cmd('curve 12 scheme bias factor 1.1 start vertex 28')
cubit.cmd('curve 14 scheme bias factor 1.1 start vertex 32')

cubit.cmd('curve 29 31 30 7 6 9 8 10 11 12 13 14 15 interval 6')

cubit.cmd('curve 32 34 16 33 35 scheme equal')
cubit.cmd('curve 32 34 16 33 35 interval 14')

cubit.cmd('curve 18 22 26 scheme equal')
cubit.cmd('curve 18 22 26 interval 10')

cubit.cmd('curve 20 24 28 scheme equal')
cubit.cmd('curve 20 24 28 interval 4')

cubit.cmd('curve 17 21 25 scheme equal')
cubit.cmd('curve 17 21 25 interval 4')

cubit.cmd('curve 19 23 27 scheme equal')
cubit.cmd('curve 19 23 27 interval 2')

cubit.cmd('mesh curve all')

cubit.cmd('surface all scheme map')
cubit.cmd('mesh surface all')

###############################################################################A
# Reflect the geometry and mesh
################################################################################

cubit.cmd('surface all copy reflect y')

################################################################################
# Define the geometry and mesh that connects the top and bottom regions
################################################################################

cubit.cmd('create curve vertex 89 7')
cubit.cmd('create curve vertex 91 8')
cubit.cmd('create curve arc vertex 93 5 radius {:g} normal 0 0 -1'.format(core_wall_minor_radius))

cubit.cmd('create surface curve 51 81 32 80')
cubit.cmd('create surface curve 57 82 30 81')

cubit.cmd('create surface vertex 106 107 33 32')
cubit.cmd('create surface vertex 107 108 35 33')

cubit.cmd('merge all')

cubit.cmd('webcut volume 25 26 with plane yplane offset 70 merge')
cubit.cmd('webcut volume 25 26 with plane yplane offset 25 merge')
cubit.cmd('webcut volume 25 26 with plane yplane offset 5 merge')

cubit.cmd('curve 80 81 82 scheme equal')
cubit.cmd('curve 80 81 82 interval 14')

cubit.cmd('curve 96 scheme bias factor 1.1 start vertex 127')
cubit.cmd('curve 102 scheme bias factor 1.1 start vertex 130')
cubit.cmd('curve 108 scheme bias factor 1.1 start vertex 135')
cubit.cmd('curve 114 scheme bias factor 1.1 start vertex 138')
cubit.cmd('curve 96 102 108 114 interval 6')

cubit.cmd('curve 101 100 106 113 112 118 109 110 116 scheme equal')
cubit.cmd('curve 101 100 106 interval 10')
cubit.cmd('curve 113 112 118 interval 4')
cubit.cmd('curve 109 110 116 interval 14')

cubit.cmd('surface 23 24 28 30 32 34 31 33 scheme map')
cubit.cmd('mesh surface 23 24 28 30 32 34 31 33')

################################################################################
# Define the geometry and mesh for the reflector regions
################################################################################

cubit.cmd('create vertex 0 -150')
cubit.cmd('create vertex 250 -150')
cubit.cmd('create vertex 250 150')
cubit.cmd('create vertex 0 150')

cubit.cmd('create curve vertex 90 142')
cubit.cmd('create curve vertex 142 143')
cubit.cmd('create curve vertex 143 144')
cubit.cmd('create curve vertex 144 145')
cubit.cmd('create curve vertex 145 1')

cubit.cmd('create surface curve 60 65 70 75 109 113 101 20 19 18 17 16 82 54')
cubit.cmd('create surface curve 121 122 123 124 34 35 25 26 27 28 106 118 116 79 74 69 64 59 53 120')
cubit.cmd('merge all')

cubit.cmd('curve 120 121 122 123 124 scheme equal')
cubit.cmd('curve 121 122 123 interval 52')
cubit.cmd('curve 120 124 interval 12')

cubit.cmd('surface 35 36 scheme pave')
cubit.cmd('mesh surface 35 36')

################################################################################
# Define the blocks and sidesets
################################################################################

cubit.cmd('block 1 add surface 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 32 34')
cubit.cmd('block 1 element type QUAD4')
cubit.cmd('block 1 name "fuel"')

cubit.cmd('block 2 add surface 28 30')
cubit.cmd('block 2 element type QUAD4')
cubit.cmd('block 2 name "pump"')

cubit.cmd('block 3 add surface 31 33')
cubit.cmd('block 3 element type QUAD4')
cubit.cmd('block 3 name "hx"')

cubit.cmd('block 4 add surface 35')
cubit.cmd('block 4 element type QUAD4')
cubit.cmd('block 4 name "shield"')

cubit.cmd('block 5 add surface 36')
cubit.cmd('block 5 element type QUAD4')
cubit.cmd('block 5 name "reflector"')

cubit.cmd('sideset 1 add curve 50 80 29')
cubit.cmd('sideset 1 name "fluid_symmetry"')

cubit.cmd('sideset 2 add curve 120 124')
cubit.cmd('sideset 2 name "solid_symmetry"')

cubit.cmd('sideset 3 add curve 121 122 123')
cubit.cmd('sideset 3 name "outer"')

cubit.cmd('sideset 4 add curve 60 65 70 75 109 113 101 20 19 18 17 16 82 54')
cubit.cmd('sideset 4 name "shield_wall"')

cubit.cmd('sideset 5 add curve 34 35 25 26 27 28 106 118 116 79 74 69 64 59 53')
cubit.cmd('sideset 5 name "reflector_wall"')

cubit.cmd('sideset 6 add curve 76 78')
cubit.cmd('sideset 6 name "hx_out"')

cubit.cmd('sideset 7 add curve 108 114')
cubit.cmd('sideset 7 name "hx_in"')

################################################################################
# Scale and export
################################################################################

cubit.cmd('volume all scale {:g}'.format(scaling))

cubit.cmd('set exodus netcdf4 off')
cubit.cmd('set large exodus on')
cubit.cmd("export mesh 'msfr_rz_mesh.e' dimension 2 overwrite")

