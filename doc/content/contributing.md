# Contributing to the VTB

The Virtual Test Bed welcomes contributions in advanced nuclear reactor modeling from all horizons,
including, but not limited to, regulatory, industrial and academic institutions.

## Requirements for new models

Any contribution must:

- use NEAMS tools, at least partially. The objective of this repository is also to show how to use NEAMS tools for nuclear reactor
  modeling

- utilize MooseDocs for documentation. MooseDocs files should be placed in `doc/content/<relevant_reactor>`.
  Please follow [this documentation template](template.md).

- follow the MooseDocs style guide ([link](https://mooseframework.inl.gov/python/MooseDocs/standards.html)) for the documentation
  and not use tabs and trailing whitespaces for both the documentation and input files

- have every input file contain a header indicating the authors of the model and their institution, the codes used to run
  the input file and briefly summarizing the simulation performed

- be tested, using either syntax checking to avoid deprecation, or reasonably sized regression tests. This
  requirement is waived for simulation tools which cannot leverage the CIVET testing suite.
  See [#running_tests] for instructions on how to check your tests.

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

Fixes and improvements of existing models are welcome. Those should be made using the pull request system.
Please first report the defect or potential for improvement as an issue in order to engage the discussion
with the relevant developers and analysts.

## Running tests id=running_tests

The VTB maintains a regression test suite that is run upon proposed modification
to the repository. It is sometimes useful to run this test suite (or some part
of it) by yourself, such as checking your new tests when you contribute a model
to the VTB, or if you're making other modifications to the VTB.

Each regression test is compatible with a selection of applications. Some
applications are coupled applications composed of other applications; for example,
BlueCrab and DireWolf are both applications that both couple Bison to other
applications, so the regression test may have the following line in the `tests`
file:

```
executable_pattern = 'bison*|blue_crab*|dire_wolf*'
```

In this example, the developer has informed the test harness that this particular
test can only be run by executables that meet one of the patterns `bison*`, `blue_crab*`,
or `dire_wolf*`; if running the test suite with an incompatible executable, this
test will be skipped.

Assuming you've already followed the [directions for getting started with the VTB](resources/how_to_use_vtb.md),
you can run tests as described below. The instructions differ depending on whether
you have source vs. executable access to the desired application(s) to test.

### Running tests with source access

First, compile the application to test. You may compile the application from the
corresponding VTB submodule within the `apps/` directory or from a directory
outside of the VTB directory, e.g., `~/projects/bison/`. If you would like to
use VTB's submodule, initialize submodules as follows:

```
cd ~/projects/virtual_test_bed
git submodule update --init
```

This will download the submodules that you have access to. Then you may
navigate into each desired applications directory and compile.

If you are using the VTB submodule(s), simply run the `scripts/run_app_tests.py`
script, either from the VTB root directory or from the `scripts/` directory:

```
cd ~/projects/virtual_test_bed
scripts/run_app_tests.py
```

By default, the script will run tests for all applications in the `apps/`
directory, but you can restrict to certain applications using command-line arguments
to the script, e.g.,

```
scripts/run_app_tests.py bison dire_wolf
```

Note the script currently hard-codes `-j 16` to be passed to the `run_tests` script.

If you are not using the VTB submodule(s), navigate to the directory
of the executable of interest, which should contain the script `run_tests`.
Note that it is requirement to call this script from this directory; it will
not function correctly when calling from another. Now you may run the test
script, and you must pass the option `--spec-file <vtb_dir>`, where
`<vtb_dir>` is the path to the VTB directory, along with any other desired
command-line options for `run_tests`. For example, if the VTB is installed
in `~/projects/virtual_test_bed` and you want to allocate 10 processes,
you would do this:

```
./run_tests --spec-file ~/projects/virtual_test_bed -j 10
```

### Running tests with executable access

Assuming that you have logged onto the machine where you'll be running the
tests and loaded the necessary modules to use the desired application, you
next need to install some tests for that application, even though we will not
run these. For example, if the desired application is Sockeye,

```
cd ~/projects
sockeye-opt --copy-inputs tests
```

This creates a directory `~/projects/sockeye/tests` which has a file `testroot`
and the subdirectory `tests`, which contains the tests. Go to the directory with
`testroot` and then run tests, passing the path to the VTB directory:

```
cd ~/projects/sockeye/tests
sockeye-opt --run --spec-file /scratch/hansje/projects/virtual_test_bed -j 20
```

!alert! tip
If you do not want to run the entire VTB test suite, use the `--re=<regular_expression>`
option to restrict the tests. For example, if you are contributing a new model
in a directory `some_reactor/`, use the following:

```
cd ~/projects/sockeye/tests
sockeye-opt --run --spec-file /scratch/hansje/projects/virtual_test_bed -j 20 --re=some_reactor
```
!alert-end!


