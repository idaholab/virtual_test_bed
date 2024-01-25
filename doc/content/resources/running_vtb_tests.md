# Running tests for the Virtual Test Bed

The Virtual Test Bed (VTB) maintains a regression test suite that is run upon
proposed modification to the repository. It is sometimes useful to run this test
suite (or some part of it) by yourself, such as checking your new tests when you
[contribute a model to the VTB](contributing.md), or if you're making other
modifications to the VTB.

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
you can run tests as follows:

1. +Decide on the application.+ The test suite is run for a particular application.
   If you want to test multiple applications, these steps must be followed for each.
1. +Navigate to the application repository.+ You must change the directory
   to the executable of interest, containing the script `run_tests`. Note that
   it is not sufficient to call this script from another directory. For example,

   ```
   cd ~/projects/dire_wolf
   ```

1. +Run the test script.+ The `run_tests` script must be run with the `--spec-file <vtb_dir>`
   option, along with any other desired command-line options for `run_tests`, where
   `<vtb_dir>` is the path to the VTB directory. For example, if the VTB is installed
   in `~/projects/virtual_test_bed` and you want to allocate 10 processes:

   ```
   ./run_tests --spec-file ~/projects/virtual_test_bed -j 10
   ```
