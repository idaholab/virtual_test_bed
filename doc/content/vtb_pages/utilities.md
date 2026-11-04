# VTB Utilities

This page lists utilities provided within the VTB repository.

## VTBPlot id=vtbplot

It is highly recommended that contributions to the VTB provide the corresponding plot scripts
where possible. For line plots, it is recommended to use the VTB's python plot class `VTBPlot`,
which enables a consistent style for VTB plots.

`VTBPlot` is a thin wrapper around [matplotlib](https://matplotlib.org/). It creates a
single-axes figure with a VTB style, and saves the figure.
It is located in `python/virtual_test_bed/plotting/VTBPlot.py`.

### Making the class importable

A plot script that sits next to a model's input files needs to be able to import `VTBPlot`.
While the repository's `python` directory could be added to the `PYTHONPATH` environment
variable, it is preferred to have it work without modifying environment variables.
The following code snippet can be used at the top of a plot script to add the python
directory to the system path:

!listing microreactors/gcmr/balance_of_plant/plot.py start=# Add VTB python directory to path end=from virtual_test_bed.plotting import VTBPlot

### Basic usage

Create a `VTBPlot` with the axis labels, add one or more lines, and call `finish()` with the name of
the image file to write:

```python
from virtual_test_bed.plotting import VTBPlot

# (load data from file into time, T_inlet, and T_outlet)

plot = VTBPlot("Time [h]", "Temperature [K]")
plot.plot(time, T_inlet,  label="Core outlet")
plot.plot(time, T_outlet, label="Core outlet")
plot.legend()
plot.finish("temperature.png")
```

- Lines that do not specify a `color` take the next color in the VTB cycle, in order.
- `plot`, `semilogy`, `errorbar`, `axvline`, `axhline` and `legend` accept the same arguments as the
  corresponding matplotlib functions.
- `plot.set_xlim(xmin, xmax)` and `plot.set_ylim(ymin, ymax)` set the axis limits; they take effect when
  `finish()` is called.
- `plot.ax` and `plot.fig` are the underlying matplotlib axes and figure, for anything not covered above.
- Optional arguments to `VTBPlot` include `title`, `grid` (`'y'`, `'x'`, `'both'` or `None`), `figsize`
  and `usetex` (LaTeX text, which requires a LaTeX installation).
- `finish()` also closes the figure, so many plots can be made in one script.

### Full example

The balance-of-plant plots in [BOP_results.md] are made with `VTBPlot` by
`microreactors/gcmr/balance_of_plant/plot.py`:

!listing microreactors/gcmr/balance_of_plant/plot.py

Running `python plot.py startup` or `python plot.py load_follow` in that directory, after running the
corresponding input file, writes one image per plot.

For making the plots of the documentation from plot scripts when the documentation is built, see
[vtb_pages/plotting.md#on-the-fly-plots].
