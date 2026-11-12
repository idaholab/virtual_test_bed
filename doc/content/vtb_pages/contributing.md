# Contributing to the VTB

The Virtual Test Bed welcomes contributions in advanced nuclear reactor modeling from all horizons,
including, but not limited to, regulatory, industrial and academic institutions.

Contributions to the VTB are made through Github pull (merge) requests. Before opening a pull
request, please see the directions below. Pull requests require that at least one commit reference
an issue number for the repository.

## New Models

Any contribution must:

- be releasable as an open-source model. Contributing a model, from the moment the pull request is made,
  makes it available to everyone.
- be made in good faith and be of sufficient quality and interest. If you would like to discuss
  your model before preparing a contribution, please [contact us](vtb_pages/contact.md). Alternatively
  you may create an issue on Github and start a discussion there for your proposed contribution.
- undergo a review process with the VTB team. Please ensure that you have sufficient
  time and funding to address the review.
- provide any files needed to run the model, including input files, mesh files, etc.
- provide testing if using any NEAMS codes.
- provide documentation using [MooseDocs](https://mooseframework.inl.gov/python/MooseDocs/index.html).

The VTB team can help you meet any of these requirements if you are not familiar with the tools used.

We also prefer but do not require that models employ International System (SI) units.

!alert note
If the copyright on the model should be retained by the contributer, please contact the support
team ahead of time so we can design the appropriate process.

The sections that follow provide guidance for each type of file.

### Input Files

All files needed to run the model must be provided; please follow these guidelines:

- Begin each input file with a header indicating the authors of the model and their institution,
  the codes used to run the input file, and a brief summary of the simulation performed.
- Use the Git Large File System (lfs) to host any large file (such as a 3D mesh).
- Ensure input files are as easy to read as possible. For example, use comments where useful,
  and delete any commented-out lines that serve no purpose.

### Documentation

Documentation is implemented using [MooseDocs](https://mooseframework.inl.gov/python/MooseDocs/index.html).
Please follow these guidelines:

- Place documentation files in `doc/content/<reactor_type>/<model_directory>`, using the
  same sub-directory names as the input files.
- Start from [this documentation template](https://github.com/idaholab/virtual_test_bed/blob/devel/doc/template.md).
- Follow the [MooseDocs style guide](https://mooseframework.inl.gov/python/MooseDocs/standards.html) for the documentation.
  For example, tabs and trailing whitespaces should not be present in either the documentation or input files.
- Provide plot scripts where possible. See [vtb_pages/utilities.md#vtbplot] for a VTB plot class
  that can be used for line plots.
- Make the plots in the documentation +on-the-fly+ when possible, instead of committing the images.
  If a plot can be made from files that are in the repository, such as the gold files of a test,
  MooseDocs can run the plot script when the documentation is built. The plot then stays consistent
  with the files it is made from and no image has to be stored in the repository.
  See [vtb_pages/plotting.md#on-the-fly-plots] for how to do this.

### Testing

The VTB continuously tests models that use codes available for CIVET testing.

- Some models may use eligible codes but a full simulation may not reasonable due to requiring
  excessive computational resources. If this is the case, a test may choose to run the model
  for a shorter period of time or use a smaller mesh. If this is still too expensive, input
  syntax-checking tests may be used.
- Use the Git Large File System (lfs) to host any large output file needed for testing.
- See [#running_tests] for instructions on how to verify that your tests pass.

## Fixes and Improvements

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
capabilities = 'bisonapp | bluecrabapp | direwolfapp'
```

In this example, the developer has informed the test harness that this particular
test can only be run by executables that meet one of the patterns `bisonapp`, `bluecrabapp`,
or `direwolfapp`; if running the test suite with an incompatible executable, this
test will be skipped.

Assuming you've already followed the instructions on [vtb_pages/getting_started.md],
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
sockeye-opt --run --spec-file ~/projects/virtual_test_bed -j 20
```

!alert! tip
If you do not want to run the entire VTB test suite, use the `--re=<regular_expression>`
option to restrict the tests. For example, if you are contributing a new model
in a directory `some_reactor/`, use the following:

```
cd ~/projects/sockeye/tests
sockeye-opt --run --spec-file ~/projects/virtual_test_bed -j 20 --re=some_reactor
```
!alert-end!


