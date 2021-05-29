# Contribution guidelines

The Virtual Test Bed welcomes contributions in advanced nuclear reactor modeling from all horizons,
including but not limited to regulatory, industrial and academic institutions.

## Minimum viable contribution

Any contribution must:

- use NEAMS tool, at least partially. The objective of this repository is to show how to use NEAMS tool for nuclear reactor
modeling

- be documented, using MooseDocs `.md` files, placed in `doc/content/<relevant_reactor>`

- be tested, using either syntax checking to avoid deprecation, or reasonably sized regression tests. This
requirement is waived for simulation tools which cannot leverage the testing suite

- be releasable as an open source model. Placing a model on this repository, from the moment the pull request is made,
will make it available to everyone.

- be of sufficient quality and interest.

- be made through a pull request to the repository, referencing an issue you create in the repository. Creating an issue before
contributing allows others to engage earlier with the developers of the new model, and creates a discussion forum
dedicated to the contribution.

We can help you meet any of these requirements if you are not familiar with the tools used.
We reserve the right to refuse any contribution which does not meet these requirements.

!alert note
If the model or the documentation you wish to contribute needs to be cleared for export control
by your home institution, please either make the pull request to the internal gitlab repository,
or wait for clearance before making a pull request to the public GitHub repository.
