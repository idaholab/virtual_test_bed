# Plotting

This page describes how to make plots for the VTB documentation. The VTB provides a
plot class, `VTBPlot`, that gives plots a consistent style; it is described on the
[utilities page](vtb_pages/utilities.md#vtbplot).

## On-the-fly plots id=on-the-fly-plots

The plots in the documentation can be made +on-the-fly+: instead of committing an image, the
documentation points to a plot script, and MooseDocs runs the script each time the documentation is built
and uses the image that it writes. This is recommended whenever a plot can be made from files that are in the
repository, such as the gold files of a test, because
the plot cannot go out of date with respect to the files it is made from, and no binary files are added to the repository.

Plots that need data which is not in the repository, such as results of a long simulation that is not
tested, still need to be committed as images.

### How it works

A plot script is used with the `!media` command in the same way as an image:

```
!media htgr/open-xe100/iqs_vs_pke/c-0.py
       style=width:70%
       id=iqs_vs_pke_c-0
       caption=Comparison of delayed neutron precursor concentration for the 0th group.
```

- MooseDocs runs the script with no arguments, so a script makes a single image and has no way to be told which one.
- The script must write an image with the name of the script and the extension `.png`, in the directory
  of the script. A different name can be given with the `image_name` setting of `!media`.
- MooseDocs only finds scripts below `doc/content`, so the script must be there. Scripts for documentation
  plots are placed in `doc/content/media/<relevant_reactor>/`.
- The script is not necessarily run from its own directory, so it should change to it
  (`os.chdir(os.path.dirname(os.path.realpath(__file__)))`) before using relative paths.
- Add the images to `.gitignore`, since they are made whenever the documentation is built.

### Recommended structure

The plot script that a user would run on their own results should live next to the input files, and
the script that MooseDocs runs should be a thin wrapper around it that uses the gold files. This way, the documentation does not
depend on running the model, and the plot script remains available for reuse.
It also keeps the generated images out of the directories where the model is run.

Plot scripts for documentation should use `VTBPlot` (see [vtb_pages/utilities.md#vtbplot]). The
[Open Xe-100 results](open-xe100_results.md) have a set of IQS and PKE comparison plots that use this structure.

First, `htgr/open-xe100/plot_iqs_vs_pke.py` sits next to the input files. Run without arguments in the directory with the results of
`xe100_iqs.i` and `xe100_pke.i`, it makes all of the plots. The plots to make can also be selected by name, and
the directories for the results and for the images can be set with `--data-dir` and `--output-dir`.
The function that makes a single plot is:

!listing htgr/open-xe100/plot_iqs_vs_pke.py start=def make_plot end=def main

Second, `xe100_common.py` in `doc/content/media/htgr/open-xe100/iqs_vs_pke` imports the plot script and sets it up
to use the gold files:

!listing htgr/open-xe100/iqs_vs_pke/xe100_common.py

Last, each image has its own script that is only two lines long, so
the documentation can use it as a plot. For example, `c-0.py`, which makes `c-0.png`:

!listing htgr/open-xe100/iqs_vs_pke/c-0.py

The name of the image comes from the name of the script, so the two cannot fall out of sync. Each script writes
only its own image, so the documentation can be built in parallel without scripts overwriting each other's files.
The images are ignored by git with the line `doc/content/media/htgr/open-xe100/iqs_vs_pke/*.png` in `.gitignore`.
