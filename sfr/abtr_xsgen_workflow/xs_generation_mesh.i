# ==============================================================================
# ABTR Equivalent-full core cross section generation mesh
# Application: Griffin
# POC: Shikhar Kumar (kumars at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

!include abtr_het_mesh.i
[Mesh]
  # Define equivalent RZ core from input heterogeneous RGMB core
  [rz_core]
    type = EquivalentCoreMeshGenerator
    input = het_core
    target_geometry = rz
    max_radial_mesh_size = 5
    radial_boundaries = '7.66 20.28 27.63 35.95 48.47 64.13 94.18 108.12'
    radial_assembly_names = 'control_assembly fuel_assembly_1 fuel_assembly_3
                             control_assembly fuel_assembly_1 fuel_assembly_2
                             reflector_assembly shielding_assembly'
    debug_equivalent_core = true
  []
  # Define and apply a coarse RZ mesh
  [rz_coarse_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '7.66 12.61 7.36 8.31 12.52 15.65 30.06 13.94'
    dy = '60 80 20 100'
  []
  [rz_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = rz_core
    coarse_mesh = rz_coarse_mesh
    extra_element_id_name = coarse_elem_id
  []
  coord_type = RZ
  data_driven_generator = rz_core
[]
