# TODO User should define heterogeneous RGMB core mesh in [Mesh] block or as separate input file
# TODO User should set Mesh/eqv_core/input to name of heterogeneous RGMB CoreMeshGenerator mesh
# TODO User should make sure boundary sidesets (outer_core, top, and bottom) are defined
#      in either TransportSystems/VacuumBoundary or TransportSystems/ReflectingBoundary
#      but not both
# TODO User should set depletion times in Executioner/depletion_times, starting from 0

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
  library_file = '/data/gambka/projects/virtual_test_bed/sfr/abtr_xsgen_workflow/mcc3xs.xml'
  library_name = 'ISOTXS-neutron'
[]

# NOTE: TransportSystems/dfem_sn/flux_moment_primal_variable = true helps reduce memory
# consumption but should be set to false for problems with displaced mesh. For problems
# with significant angular flux (including all-reflective boundary conditions), this
# parameter can be set to true but Executioner/inner_solve_type = SI should be set.
# With flux_moment_primal_variable set to true, adaptive mesh refinement can also
# only be applied on INITIAL.
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 33
  ReflectingBoundary = 'outer_core top bottom'
  VacuumBoundary = 'outer_core top bottom'
  [dfem_sn]
    scheme = DFEM-SN
    family = L2_LAGRANGE
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 1
    using_averaged_xs = true
    direction_major_ordering = true
    flux_moment_primal_variable = true
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
  # Mapping of homogeneous subassembly ID to associated (heterogeneous assembly, axial ID) pairs:
  # 100: (fuel_assembly_1, 0), (fuel_assembly_2, 0), (fuel_assembly_3, 0)
  # 300: (fuel_assembly_1, 2), (fuel_assembly_2, 2), (fuel_assembly_3, 2)
  # 400: (fuel_assembly_1, 3), (fuel_assembly_2, 3), (fuel_assembly_3, 3)
  # 700: (control_assembly, 0), (control_assembly, 1)
  # 800: (control_assembly, 2), (control_assembly, 3)
  # 900: (reflector_assembly, 0), (reflector_assembly, 1), (reflector_assembly, 2), (reflector_assembly, 3)
  # 1000: (shielding_assembly, 0), (shielding_assembly, 1), (shielding_assembly, 2), (shielding_assembly, 3)
  [material_core_grid1]
    type = MixedMatIDNeutronicsMaterial
    isotopes = 'pseudo_REG'
    densities = '1.0'
    block = '100 300 400 700 800 900 1000'
    grid_names = 'Tcool'
    grid = '1'
  []
  # Mapping of homogeneous subassembly ID to associated (heterogeneous assembly, axial ID) pairs:
  # 200: (fuel_assembly_1, 1)
  # 500: (fuel_assembly_2, 1)
  # 600: (fuel_assembly_3, 1)
  [material_core_grid2]
    type = MixedMatIDNeutronicsMaterial
    isotopes = 'pseudo_REG'
    densities = '1.0'
    block = '200 500 600'
    grid_names = 'Tcool Tfuel'
    grid = '1 1'
  []
[]
