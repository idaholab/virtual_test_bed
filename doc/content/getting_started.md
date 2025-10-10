!config navigation breadcrumbs=False scrollspy=False

# Getting Started

Before getting started, note how to navigate this website:

- The *Documentation* menu gives instructions on how to use the VTB and gives some tutorials.
- The *Models* menu lists the models available in the VTB:

  - [By Filter](https://mooseframework.inl.gov/virtual_test_bed/resources/filter/index.html) filters the available models by several criteria, such as reactor type, code used, or simulation type.
  - [By Index](resources/manual_indexing.md) provides several manually maintained lists of the models, such as by reactor type.

To get started with the Virtual Test Bed (VTB), follow these steps:

1. [Register for the VTB](registration.md).
1. +Install git.+ The VTB is an open-source `git` repository and is hosted on Github. If it is not already installed on your computer, install it; see [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for example.

   Some models require `git-lfs` as well, which is used for storing very large files such as large meshes. If your model of interest does not require `git-lfs`, then feel free to skip this step. To install `git-lfs`, see [here](https://git-lfs.github.com/).
1. +Download the VTB repository.+ Choose a download location on your computer (here, we will add the VTB repository in the `~/projects/` directory), and then clone the VTB in your terminal as follows:

   ```
   cd ~/projects
   git clone git@github.com:idaholab/virtual_test_bed.git
   ```

   This will create a new directory `~/projects/virtual_test_bed/` to mirror the VTB repository hosted on Github.
1. Browse the VTB models using the "Models" menu.
1. [Obtain the code(s) of interest](obtaining_codes.md). Each model page should list the codes needed.
1. Continue to [running_models.md] to learn how to run VTB models.

