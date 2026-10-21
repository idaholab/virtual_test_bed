# ==============================================================================
# Model: Molten Salt Separate Effects Loop (SEL)
# Application: SAM (System Analysis Module)
# Simulation: Loss-of-flow transient (pump trip) and natural circulation
# ------------------------------------------------------------------------------
# Author(s): Thanh Hua (thua@anl.gov), Jun Fang (fangj@anl.gov)
# Institution: Argonne National Laboratory (ANL)
# Sponsor: ARPA-E
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

!include OnepinSS.i

[Executioner]
  start_time := 0
  end_time   := 5000
  dtmax      := 50.0
[]

[Problem]
  restart_file_base = OnepinSS_out_cp/LATEST
[]
