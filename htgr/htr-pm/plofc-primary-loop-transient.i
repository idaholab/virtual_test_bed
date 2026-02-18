# Start model ------------------------------------------------------------------
!include plofc-primary-loop-ss.i

[Problem]
  restart_file_base = 'ss-main_out_primary_loop0_checkpoint_cp/LATEST'
[]

[Executioner]
  start_time := 0
  end_time := 500000
[]

