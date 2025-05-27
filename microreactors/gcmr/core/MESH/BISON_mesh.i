#####################################################################################################
# Whole-core mesh for a Gas-cooled Microreactor
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
#####################################################################################################

# Use TRI3/QUAD4 for linear elements (default in this model)
# Use TRI6/QUAD8 for quadratic elements
tri_type = TRI3
quad_type = QUAD4

[GlobalParams]
  tri_element_type = ${tri_type}
  quad_element_type = ${quad_type}
  boundary_region_element_type = ${quad_type}
[]

[Mesh]
  [Coolant_hole]
    # boundary layer setting for coolant channels only for BISON
    background_inner_boundary_layer_width = 0.15
    background_inner_boundary_layer_intervals = 2
    background_inner_boundary_layer_bias = 2
  []
  [extrude]
    # biased axial layers only for BISON
    biases = '2 1 1 1 1 1 0.5'
    num_layers := '3 4 4 4 4 4 3'
  []
[]

!include Griffin_mesh.i
