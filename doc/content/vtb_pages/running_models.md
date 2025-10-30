!config navigation breadcrumbs=False scrollspy=False

# Running Models

After a model of interest has been selected, navigate to the corresponding directory
within the VTB repository, which should be noted on the model's documentation page.

Most of the codes used in the VTB are based on the [MOOSE framework](https://mooseframework.inl.gov/index.html)
and have a common invocation on the command line. The input files for these applications
have the extension `.i` and are executed as follows, where `theapp-opt` represents
the name of the executable, and `theinput.i` represents the name of the input file:

```
theapp-opt -i theinput.i
```

Note that this corresponds to serial execution; for parallel execution, the following
would execute with 10 processes, for example:

```
mpiexec -n 10 theapp-opt -i theinput.i
```

See [MOOSE documentation](https://mooseframework.inl.gov/application_usage/command_line_usage.html)
for further information on executing MOOSE-based applications, including various
command-line arguments.

For all other applications, please refer to the specific model/application documentation.

For a basic tutorial on using the VTB, see [vtb_tutorials/vtb_basics.md].
