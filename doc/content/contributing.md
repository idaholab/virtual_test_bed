# Contribution guidelines

The Virtual Test Bed welcomes contributions in advanced nuclear reactor modeling from all horizons,
including, but not limited to, regulatory, industrial and academic institutions.

## Minimum viable contribution

Any contribution must:

- use NEAMS tool, at least partially. The objective of this repository is also to show how to use NEAMS tool for nuclear reactor
  modeling

- utilize MooseDocs for documentation. MooseDocs files should be placed in `doc/content/<relevant_reactor>`

- follow the MooseDocs style guide ([link](https://mooseframework.inl.gov/python/MooseDocs/standards.html)) for the documentation
  and not use tabs and trailing whitespaces for both the documentation and input files

- have every input file contain a header indicating the authors of the model and their institution, the codes used to run
  the input file and briefly summarizing the simulation performed

- be tested, using either syntax checking to avoid deprecation, or reasonably sized regression tests. This
  requirement is waived for simulation tools which cannot leverage the CIVET testing suite

- use the Git Large File System (lfs) to host any large file (3D mesh for example)

- be releasable as an open source model. Placing a model on this repository, from the moment the pull request is made,
  will make it available to everyone

- be made through a pull request to the repository, referencing an issue you create in the repository. Creating an issue before
  contributing allows others to engage earlier with the developers of the new model, and creates a discussion forum
  dedicated to the contribution

- use International System (SI) units

- be made in good faith and be of sufficient quality and interest


We can help you meet any of these requirements if you are not familiar with the tools used.
We reserve the right to refuse any contribution which does not meet these requirements.

!alert note
If the copyright on the model should be retained by the contributer, please contact the support
team ahead of time so we can design the appropriate process.

!alert note
If the model or the documentation you wish to contribute needs to be cleared for export control
by your home institution, please either make the pull request to the internal gitlab repository,
or wait for clearance before making a pull request to the public GitHub repository.

## Contributing fixes or improvements

Bug fixes and improvements of existing models are welcome. Those should be made using the pull request system.
Please first report the bug or potential for improvement as an issue in order to engage the discussion
with the relevant developers and analysts.
