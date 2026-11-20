# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Cooldown stage parameters, including the welding outputs it reads (checkpoint, CSV).

cp_file_base = '${thickness}/cooldown'
heat_transfer_coefficient = 10e-6

# Restart source: checkpoint directory written by the welding stage (resolved via LATEST,
# i.e. the newest checkpoint by modification time = the final step of an uninterrupted run).
weld_cp_dir = '../welding/40mm/weld_cp'

# CSV output of the welding stage. The bottom-node displacement BCs of the cooldown are read from
# its columns xzfix_bot_disp_x, xzfix_bot_disp_z and zfix_bot_disp_z (PointValue postprocessors at
# (-75, 450, 0) and (75, 450, 0)); see [Functions] in cooldown_objects.i. Nothing is hard-coded:
# the values always come from the same welding run as the restart checkpoint above.
weld_csv = '../welding/40mm/scl.csv'

# weld
total_passes = 8
pass_weld_time = 1200
delay_time = 25 #300
total_weld_time = '${fparse pass_weld_time*total_passes + delay_time}'

# cooldown
load_release_time = 360 # Release the top BCs slowly...
end_of_cooldown = 720000 # 360000 if pwht is used; 720000 if pwht is not used

dt = 2.5
dtmax = 3600
dtmin = 1e-8
sync_times = '${total_weld_time} ${fparse total_weld_time+dt} ${fparse (total_weld_time+load_release_time)} ${fparse end_of_cooldown/2} ${end_of_cooldown}'

disp_save_in = ''
