# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Welding stage parameters: passes, heat source, time stepping.

cp_file_base = '${thickness}/weld'
heat_transfer_coefficient = 10e-6 # W/(mm^2 K) (= 10 W/(m^2 K))
pi = 3.14159265359
delay_time = 25 # s, delay before the first pass starts

# weld
weld_blocks = 'weldpass-1 weldpass-2 weldpass-3 weldpass-4 weldpass-5 weldpass-6 weldpass-7 weldpass-8'
subdomain_block_id = '11'
total_passes = 8
# Calibrated heat input [W/mm] (peak temperature ~ melting point of 316H); see weld_objects.i
base_power = 500 # W/mm
elip_a = 40 # mm, semi-axis along the torch path
elip_b = 20 # mm, semi-axis normal to the torch path
elm_weld_time = 120
pass_weld_time = 1200
total_weld_time = '${fparse pass_weld_time*total_passes + delay_time}'

# timestep restriction
dt = 5
dtmax = 2.5 # s
dtmin = 1e-8

# Output and time step sync times; the time stepper hits the union of the two sets below (see
# [Times] and [Outputs] in common_objects_R5_plas.i):
#  - every output_interval = 25 s from t = 0 to the end of welding (TimeIntervalTimes), and
#  - pass_sync_times: one dtmax before the first pass starts (t = delay_time - dtmax = 22.5 s) and
#    0.1 s after the start of passes 2 to 8 (t = 1225.1, 2425.1, ..., 8425.1 s).
output_interval = 25
pass_sync_times = '${fparse delay_time - dtmax}
                   ${fparse delay_time + 1 * pass_weld_time + 0.1}
                   ${fparse delay_time + 2 * pass_weld_time + 0.1}
                   ${fparse delay_time + 3 * pass_weld_time + 0.1}
                   ${fparse delay_time + 4 * pass_weld_time + 0.1}
                   ${fparse delay_time + 5 * pass_weld_time + 0.1}
                   ${fparse delay_time + 6 * pass_weld_time + 0.1}
                   ${fparse delay_time + 7 * pass_weld_time + 0.1}'
