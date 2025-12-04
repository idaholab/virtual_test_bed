#### Tallies
tallies = openmc.Tallies()

## Generate Mesh Filter
core_mesh = openmc.RegularMesh()
core_mesh.dimension = [100, 100, 100]
core_mesh.lower_left = [-15, -15, 0]
core_mesh.upper_right = [15, 15, 100]

core_mesh_filter = openmc.MeshFilter(core_mesh)

## Generate Energy filter
energies = np.logspace(np.log10(1e-5), np.log10(20.0e6), 501)
core_energy_filter = openmc.EnergyFilter(energies)

## Basic fission tally
spectrum_tally = openmc.Tally(name="Fission Tally")
spectrum_tally.scores = ['flux', 'fission']
spectrum_tally.filters = [core_energy_filter]
tallies.append(spectrum_tally)

## Export tallies
tallies.export_to_xml()
