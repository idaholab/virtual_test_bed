# ==============================================================================
# ABTR Equivalent-full core calculation
# Application: Griffin
# POC: Shikhar Kumar (kumars at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

# Input files modifications that MUST be done by the user:
# - User should define heterogeneous RGMB core mesh in [Mesh] block or as separate input file
# - User should set Mesh/eqv_core/input to name of heterogeneous RGMB CoreMeshGenerator mesh
# - User should make sure boundary sidesets (outer_core, top, and bottom) are defined
#   in either TransportSystems/VacuumBoundary or TransportSystems/ReflectingBoundary
#   but not both
# See 'tests' file for the command line arguments to pass to do this
# Adding command line arguments from the input is coming in MOOSE FY24

[Mesh]
  [eqv_core]
    type = EquivalentCoreMeshGenerator
    input = het_core
    target_geometry = full_hom
  []
  [block_numbering]
    type = ElementIDToSubdomainID
    input = 'eqv_core'
    extra_element_id_name = 'material_id'
  []
  data_driven_generator = eqv_core
[]

[GlobalParams]
  is_meter = false
  plus = true
  library_file = 'mcc3xs.xml'
  library_name = 'ISOTXS-neutron'
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 33
  # ReflectingBoundary = 'outer_core top bottom'
  VacuumBoundary = 'outer_core top bottom'
  [dfem_sn]
    scheme = DFEM-SN
    family = L2_LAGRANGE
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 1
    using_array_variable = true
    using_averaged_xs = true
    direction_major_ordering = true
  []
[]

[Executioner]
  type = SweepUpdate
  richardson_rel_tol = 1e-6
  richardson_abs_tol = 1e-6
  richardson_max_its = 100
  richardson_value = eigenvalue
  inner_solve_type = GMRes
  max_inner_its = 4
  inner_tol = 1.e-3
  cmfd_acceleration = true
[]

[Materials]
  [material_core_grid1]
    type = MixedMatIDNeutronicsMaterial
    isotopes = 'pseudo_REG'
    densities = '1.0'
    block = '100 300 400 700 800 900 1000'
    grid_names = 'Tcool'
    grid = '1'
  []
  [material_core_grid2]
    type = MixedMatIDNeutronicsMaterial
    isotopes = 'pseudo_REG'
    densities = '1.0'
    block = '200 500 600'
    grid_names = 'Tcool Tfuel'
    grid = '1 1'
  []
[]
