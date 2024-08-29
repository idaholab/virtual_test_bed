# Phase 2: Time-dependent Multiphysics Coupling

This phase is comprised of a sole task which a fully coupled time dependent simulation
of the cavity problem.
This problem is modeled using two inputs, too.
These inputs are the transport solve input, and the Navier-Stokes solve.
The transport solve input has a structure similar to that of the transport input
in Step 1.3.
The difference in in assigning a ```transient``` equation type instead of 
```eigenvalue```, and changing ```type``` input in ```Executioner``` block
to Transient

```
[TransportSystems]
  particle = neutron
  equation_type = transient
  G = 6
  VacuumBoundary = 'left bottom right top'
  #restart_transport_system = true
  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 8
    family = LAGRANGE
    order = FIRST
    external_dnp_variable = 'dnp'
    fission_source_aux = true
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]
```

```
[Executioner]
  type = Transient
  solve_type = PJFNK 
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'

  start_time = 0.0
  dt = ${fparse max(0.005, 0.05*0.0125/frequency)}
  end_time = ${fparse 10/frequency}
  line_search = l2 #none #l2
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 200
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
  fixed_point_min_its = 2
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-6
  fixed_point_abs_tol = 1e-6
[]
```

On the Navier-Stokes solve side, the problem is still executed as a transient 
solver.
However, instead of running the problem for a long time to achieve steady state,
the problem is defined as follows

```
[Executioner]
  type = Transient
  start_time = 0.0
  dt = ${fparse max(0.005, 0.05*0.0125/frequency)}
  end_time = ${fparse 10/frequency}
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = l2#'none'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
  nl_max_its = 200
  l_max_its = 200
  automatic_scaling = true
[]
```


