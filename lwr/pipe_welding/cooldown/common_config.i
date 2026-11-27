# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Parameters shared by the welding and cooldown stages (geometry, file names, temperatures).

thickness = '40mm'
exo_file_base = '${thickness}/out'
csv_file_base = '${thickness}/scl'
base_blocks = 'basemetal weld_to_base'
# Postprocessor probe points in the weld region (y = 600 mm) [mm]: inner surface, outer surface, mid-wall
id_point = '75 600 0'
od_point = '115 600 0'
mid_point = '95 600 0'

strain = SMALL

T0 = 300
Tm = 1700
