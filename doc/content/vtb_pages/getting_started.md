!config navigation breadcrumbs=False scrollspy=False

# Getting Started

## Navigating the VTB Website

Before getting started, note how to navigate this website:

- The "Documentation" menu gives instructions on how to use the VTB and gives some tutorials.
- The "Models" menu lists the models available in the VTB:

  - [By Filter](https://mooseframework.inl.gov/virtual_test_bed/resources/filter/index.html) filters the available models by several criteria, such as reactor type, code used, or simulation type.
  - [By Index](vtb_pages/manual_indexing.md) provides several manually maintained lists of the models, such as by reactor type or transient scenario.

- The "Support" menu lists contact and help information.
- The Github logo link will take you to the VTB Github repository.

To get started with the Virtual Test Bed (VTB), follow these steps:

## Step 1: Register for the VTB

First [register for the VTB](vtb_pages/registration.md).

## Step 2: Install git

The VTB is an open-source `git` repository and is hosted on Github. If it is not already installed on your computer, install it; see [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) for example.

## Step 3: Install git-lfs (Optional) id=lfs

Some models require `git-lfs` as well, which is used for storing very large files such as large meshes. If your model of interest does not require `git-lfs`, then feel free to skip this step. To install `git-lfs`, see [here](https://git-lfs.github.com/).

## Step 4: Download the VTB Repository

Choose a download location on your computer (here, we will add the VTB repository in the `~/projects/` directory), and then clone the VTB in your terminal as follows:

```
cd ~/projects
git clone git@github.com:idaholab/virtual_test_bed.git
```

This will create a new directory `~/projects/virtual_test_bed/` to mirror the VTB repository hosted on Github.

## Step 5: Browse Models

Browse the VTB models using the "Models" menu.

## Step 6: Obtain Codes

Each model page should list the codes needed. See [vtb_pages/codes.md] for information on obtaining each code.

## Step 7: Run Models

Continue to [vtb_pages/running_models.md] to learn how to run VTB models.

