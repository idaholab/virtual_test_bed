# SEFOR Griffin Neutronic Model for Core I-I

For the subsequent Griffin simulations, a split-mesh was adopted to reduce per rank memory footprint.
The partitioning is configured in the Mesh block of the Griffin input file and executed with the Griffin prior to the physics run.
After generating the pre-split mesh, the workflow switches to simulation mode by replacing the Exodus mesh reference with the split `.cpr file` and enabling the `parallel_type=distributed` option to activate distributed processing.

Griffin transport calculations used the DFEM-SN solver with Gauss–Chebyshev angular quadrature.
While MC2-3 was used to generate microscopic cross-sections in 33 energy groups structure. The discretization and 3D mesh statistics reflect the differing problem sizes of the two cores.

For Core I-I, the problem was solved is larger than Core I-E, with 1.128×10^11 DOFs and 5.81×10^7 local DOFs; the mesh contained 6.17×10^6 total nodes (3.82×10^3 local) and 8.90×10^6 total elements (4.58×10^3 local).
Griffin eigenvalue calculations for Core I-I employed the DFEM-SN (3,4) method with NA=3.
Simulations ran on INL’s Windriver1 HPC system using 6,048 cores and approximately 47 TB of aggregate memory. However, enabling `flux_moment_primal_variable` parameter in the transport solver input can substantially reduce memory usage by storing flux moments rather than the full angular flux.


!listing sfr/sefor/Core_II/Griffin_SEFOR_CoreII_450K.i

