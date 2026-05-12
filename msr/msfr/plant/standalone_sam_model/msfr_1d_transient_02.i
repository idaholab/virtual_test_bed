################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## SAM system modeling of the primary pump trip                               ##
################################################################################

!include msfr_1d_ss.i

[Functions]
  [TimeStepperFunc]
    x := '0.0  20    120   180  200  240   300  600'
    y := '1.0  2.    0.1   0.5    1.   1.5   2.   2.'
  []
  [head_func] # Dynamic pump head
    type = PiecewiseLinear
    x    = '0   120 180  600'
    y    = '1.0 1.0 0.0  0.0'
    scale_factor = 156010.45
  []
[]

[Components]
  [pump]
    Head   := head_func
  []
[]

[Problem]
  restart_file_base = msfr_1d_ss_checkpoint_cp/LATEST
[]

[Executioner]
  nl_max_its := 10
  start_time := 0.0
  end_time := 600
[]
