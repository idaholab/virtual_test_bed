################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Griffin Main Application input file base                                   ##
## Steady state neutronics model                                              ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  uniform_refine = 1
  coord_type = 'RZ'
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/msfr_rz_mesh.e'
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 6

  VacuumBoundary = 'outer'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
    fission_source_aux = true

    # For PJFNKMO
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]

[PowerDensity]
  power = 3e9
  power_density_variable = power_density
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[GlobalParams]
  # No displacement modeled
  # fixed_meshes = true
[]

################################################################################
# CROSS SECTIONS
################################################################################

[Materials]
  [fuel]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 2
    block = 'fuel pump hx'
  []
  [shield]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel_constant'
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 5
    block = 'shield'
  []
  [reflector]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'msfr_xs'
    library_file = '../mgxs/msfr_xs.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel_constant'
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 1
    block = 'reflector'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 50'
  l_max_its = 50

  free_power_iterations = 4  # important to obtain fundamental mode eigenvalue

  nl_abs_tol = 1e-9
  fixed_point_abs_tol = 1e-9
  fixed_point_max_its = 20
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  checkpoint = true
  [restart]
    type = Exodus
    execute_on = 'final'
    file_base = 'run_neutronics_restart'
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]
