# MSRE Model for reactivity insertion test
# SAM input file for transient simulation
# Application: SAM
# POC: Jun Fang (fangj at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

!include msre_pke_ss.i

[Functions]
  [time_stepper]
    x := '0.0 10.0 50.0 100.0'
    y := '0.1 0.5  1.0    2.0'
  []

  [ext_rho]
    x := '0.0      1.0'
    y := '0.000190 0.000190'
  []
[]

[Executioner]
  start_time := 0.
  end_time   := 400
  nl_rel_tol := 1e-7
  nl_abs_tol := 1e-5
  nl_max_its := 20
  l_tol      := 1e-5
  l_max_its  := 50
[]

[Problem]
  restart_file_base = msre_pke_ss_ckpt_cp/LATEST
[]
