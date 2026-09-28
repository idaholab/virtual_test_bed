# Shared between ph_start.i (Pronghorn) and msre_sam_do.i (SAM): delayed
# neutron precursor decay constants, and the pseudo-transient time-stepping
# schedule both apps must stay on since they're coupled every step via
# [OverlappingDomainCoupling].
lambda_1              = 0.013336
lambda_2              = 0.0327389985
lambda_3              = 0.120779999
lambda_4              = 0.302780002
lambda_5              = 0.849489987
lambda_6              = 2.85299993

[Functions]
  [time_stepper]
    type         = PiecewiseConstant
    direction    = LEFT_INCLUSIVE
    x = '-2000.0  -1998.0  -1980.0  -1900.0  -1500.0'
    y = '    0.5      1.0      5.0     20.0    100.0'
  []
[]
