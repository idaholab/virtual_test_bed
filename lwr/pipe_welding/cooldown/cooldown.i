# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Cooldown stage, main input: restart from the final welding state, release of the
# welding clamps and cooling to ambient temperature, t = 9625 to 720000 s.

!include common_config.i
!include cooldown_config.i

end_time = ${end_of_cooldown}

!include common_objects_R5_plas.i
!include cooldown_objects.i
