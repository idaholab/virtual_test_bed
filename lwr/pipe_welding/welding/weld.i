# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Codes: Grizzly (BlackBear objects: SpatioTemporalPath, ADMovingEllipsoidalHeatSource)
# Welding stage, main input: 8-pass girth weld in a 40 mm thick pipe wall, t = 0 to 9625 s.
# Coupled transient heat conduction and quasi-static solid mechanics with a moving
# ellipsoidal heat source and progressive activation of the weld-pass elements.

!include common_config.i
!include weld_config.i

end_time = ${total_weld_time}

!include common_objects_R5_plas.i
!include weld_objects.i
