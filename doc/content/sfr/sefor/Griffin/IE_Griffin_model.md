# SEFOR Griffin Neutronic Model for Core I-E

For Griffin calculations, a split-mesh configuration was used to optimize parallel computational performance, especially with respect to the memory requirement. The workflow involves configuring the mesh split setup prior to running simulations using Griffin. The Griffin executable is utilized to execute the mesh splitting [Griffin_mesh_split]:

!listing id=Griffin_mesh_split caption=Griffin command for splitting the mesh
griffin-opt -i Mesh_Core-I-E_3D_450K.i --split-mesh 1440 --split-file Core-I-E_3D_450K_mesh_split_with_cmfd.cpa.gz

Once the pre-split mesh is created, the workflow transitions to simulation mode by substituting the Exodus file with the split .cpr file and activating the “parallel_type=distributed” option to enable distributed processing during the simulation as illustrated in [load_split_mesh] .  

!listing sfr/sefor/Core_IE/Core-I-E_ENDF71V2_450K_NA-3_NP-3_NAZ-6_CMFD_1440Tasks_30Nodes_48Cores.i
         block=Mesh
         id=load_split_mesh
         caption=Griffin mesh block for using distributed mesh

Microscopic cross sections generated from MC$^2$-3 were used to describe the homogenized zones including the bottom grid plate, core top (Na_steel), Downcomers (inside or outside the vessel DC_IV/DC_OV), radial reflectors and radial shields. For various fuel assemblies, the materials for each region within the fuel assembly was redefined by specifying the atom density for each isotope and using the microscopic cross sections from the MC$^2$-3 homogenized zone. [load_material] shows the Griffin input to define the materail regions for regions within a standard fuel assembly. 

!listing sfr/sefor/Core_IE/Core-I-E_ENDF71V2_450K_NA-3_NP-3_NAZ-6_CMFD_1440Tasks_30Nodes_48Cores.i
         start=Materials
         end=std_assm_insul_uo2
         id=load_material
         caption=Griffin material block for defining materials in axial segments of the standard fuel assembly with UO2 layers. 

In this VTB model, Griffin simulations utilized the DFEM-SN transport solver. Angular discretization was achieved using Gauss-Chebyshev quadrature with three polar angles and six azimuthal angles. The finite element shape functions for the angular fluxes (primal variables) were first-order MONOMIAL and the maximum scattering anisotropy order was set to NA=3 as illustrated in [Griffin_tr]:

!listing sfr/sefor/Core_IE/Core-I-E_ENDF71V2_450K_NA-3_NP-3_NAZ-6_CMFD_1440Tasks_30Nodes_48Cores.i
         block=TransportSystems
         id=Griffin_tr
         caption=Griffin transport block for modeling SEFOR Core I-E

To enhance computational efficiency, the “using_array_variable” option was enabled, allowing angular fluxes for each group to be stored via MOOSE’s ArrayVariable system. This approach reduces the number of computational kernels and minimizes overall computational cost. Additionally, the “collapse_scattering” option was activated, enabling in-group scattering sources to be directly formed within the scattering kernels, further reducing simulation runtime.

For the cases with CMFD acceleration as shown in [Griffin_excutioner], the “prolongation_type” was set to multiplicative. This configuration updates the fine mesh flux using the coarse mesh solution in a multiplicative manner, influencing convergence behavior and allowing for performance tuning. A maximum diffusion coefficient of 1.0 was specified using the “max_diffusion_coefficient” parameter. The Richardson outer iteration was configured with an absolute tolerance of 1.0E-6, a relative tolerance of 1.0E-6, and a maximum of 1000 iterations. The inner linear solver used GMRES, with a maximum of 1000 iterations per solve.

!listing sfr/sefor/Core_IE/Core-I-E_ENDF71V2_450K_NA-3_NP-3_NAZ-6_CMFD_1440Tasks_30Nodes_48Cores.i
         block=Executioner
         id=Griffin_excutioner
         caption=Griffin executioner block for modeling SEFOR Core I-E

Griffin simulations were completed after approximately 7 hours using 2016 CPUs distributed over 84 computational nodes from the INL HPC cluster as of the date, with 24 cores per node and collectively total about 16 TB of memory. Subsequent optimization indicated that Griffin’s computational memory requirements could be substantially reduced by activating the 'flux_moment_primal_variable' parameter within the transport solver, which stores flux moments rather than the full angular flux information. The effect of implementing this option is siginificant. Activation of this parameter is strongly recommended for modeling SEFOR. 