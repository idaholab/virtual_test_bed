dx_system = ${units 29 ft -> m} # x length of system, equal to ${fparse 2*(t_wall+t_water) + dx_cavity}
dy_system = ${units 47 ft -> m} # y length of system, equal to ${fparse dy_door1 + dy_airgap1 + dy_door2 + dy_airgap2 + dy_cavity + t_water + t_wall}
dz_system = ${units 23 ft -> m} # z length of system, equal to ${fparse dz_floor2 + dz_cavity + dz_ceiling1 + dz_ceiling2}
dz_ground = ${units 17 ft -> m}

dy_door1 = ${units 6.27 ft -> m}
dy_airgap1 = ${units 1 in -> m}
dy_door2 = ${units 3.605 ft -> m}
dy_airgap2 = ${units 0.5 in -> m}

dy_floor1 = ${units 10 ft -> m}
dz_floor1 = ${units 2.458 ft -> m}
dz_floor2 = ${units 2.75 ft -> m}

dx_floor3 = ${units 16.66667 ft -> m}
dy_floor3 = ${units 30.833 ft -> m}
dz_floor3 = ${units 1.25 ft -> m}

dx_cavity = ${units 15 ft -> m}
dy_cavity = ${units 30 ft -> m} # this is not including the air gap behind door2
dz_cavity = ${units 13 ft -> m}

t_wall = ${units 4.375 ft -> m} # back wall and side walls
dz_wall = ${units 14.5 ft -> m}

dz_ceiling3 =${units 5.75 ft -> m} # applicable for ceiling_3, ceiling_4 and ceiling_5
dz_ceiling1 = ${units 1.25 ft -> m}
dz_ceiling2 = ${units 6 ft -> m}

t_tankwall = ${units 1 in -> m}
t_water = ${units 2.625 ft -> m} # including insulation and air gap
t_airgap_water = ${units 1.9 in -> m}
t_water_actual = ${fparse t_water - 2*t_tankwall - t_airgap_water}

xmin_cavity = ${fparse t_water + t_wall}
xmin_floor3 = ${fparse (dx_system - dx_floor3)/2}

ymax_door2 = ${fparse dy_door1 + dy_airgap1 + dy_door2}
ymax_airgap2 = ${fparse ymax_door2 + dy_airgap2}
ymin_cavity = ${ymax_door2} # cavity includes air gap behind door2
ymax_cavity = ${fparse ymin_cavity + dy_airgap2 + dy_cavity}

zmax_floor2 = ${dz_floor2}
zmax_floor3 = ${zmax_floor2}
zmax_ground = 0
zmin_ceiling1 = ${fparse dz_system - dz_ceiling2 - dz_ceiling1}

#variables added to ensure mesh exists in all intermediate volumes when the first Cartesian Mesh is defined
add_no = ${units 1.7086667 ft -> m}
add_no2 = ${units 0.958 ft -> m}

# shifts to make consistent with OpenMC geometry
openmc_shift_x = ${fparse -0.5*dx_system} # centered in x
openmc_shift_y = ${fparse -0.5*dy_system} # centered in y
openmc_shift_z = ${fparse -dz_floor2} # bottom cavity surface at z=0

dz_core_floor_gap = 0.4572 # This is to stay consistent with elevation of reactor in contractor reports
dx_entries_begin = '${t_wall} ${t_airgap_water} ${t_tankwall} ${t_water_actual} ${t_tankwall}'
ix_entries_begin = '2 1 1 6 1'
dx_entries_end = '${t_tankwall} ${t_water_actual} ${t_tankwall} ${t_airgap_water} ${t_wall}'
ix_entries_end = '1 6 1 1 2'
dy_entries_begin = '${dy_door1} ${dy_airgap1} ${dy_door2} ${dy_airgap2} ${t_tankwall}'
iy_entries_begin = '3 1 2 1 1'
dy_entries_end = '${t_tankwall} ${add_no} ${fparse t_water_actual - add_no} ${t_tankwall} ${t_airgap_water} ${t_wall}'
iy_entries_end = '1 1 2 1 1 2'
dz_entries_begin = '${dz_ground} ${fparse dz_floor2 - dz_floor3} ${add_no2} ${fparse dz_floor3 - add_no2} ${t_tankwall}'
iz_entries_begin = '6 2 1 2 1'
dz_entries_end = '${t_tankwall} ${dz_ceiling1} ${fparse dz_ceiling2 - dz_ceiling3} ${dz_ceiling3}'
iz_entries_end = '1 2 2 3'