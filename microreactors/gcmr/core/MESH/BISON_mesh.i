#####################################################################################################
# Whole-core mesh for a Gas-cooled Microreactor
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
#####################################################################################################

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
