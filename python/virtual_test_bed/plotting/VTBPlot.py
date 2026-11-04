"""Consistent matplotlib plots for the Virtual Test Bed (VTB)."""

import matplotlib.pyplot as plt
from cycler import cycler

# NRIC colors (doc/content/css/vtb_theme.css, taken from the NRIC logo):
NRIC_BLUE = '#006e97'
NRIC_DARK_BLUE = '#122736'
NRIC_TEAL = '#00bfb2'
NRIC_DARK_TEAL = '#00555e'
NRIC_YELLOW = '#e3e935'

COLORS = (
  NRIC_BLUE,
  NRIC_TEAL,
  NRIC_YELLOW,
  'orange',
  'limegreen',
  'orchid',
  'mediumpurple',
  'indianred'
)

TEXT_COLOR = NRIC_DARK_BLUE
AXIS_COLOR = 'darkgray'
TICK_COLOR = 'darkgray'
GRID_COLOR = 'whitesmoke'

SETS_LINEWIDTH = 1.8
AXES_LINEWIDTH = 0.8
GRID_LINEWIDTH = 0.8
HLINE_LINEWIDTH = 0.8
VLINE_LINEWIDTH = 0.8

TITLE_FONTSIZE = 13
TEXT_FONTSIZE = 11
AXES_FONTSIZE = 11

FIGSIZE_X = 8
FIGSIZE_Y = 6

def rc_params():
  """The matplotlib rcParams that define the VTB look."""
  return {
    'figure.facecolor': 'white',
    'savefig.facecolor': 'white',
    'font.family': 'sans-serif',
    'font.sans-serif': ['Helvetica Neue', 'Helvetica', 'Arial', 'DejaVu Sans'],
    'mathtext.fontset': 'dejavusans',
    'font.size': TEXT_FONTSIZE,
    'text.color': TEXT_COLOR,
    'axes.titlesize': TITLE_FONTSIZE,
    'axes.titleweight': 'bold',
    'axes.titlelocation': 'left',
    'axes.titlepad': 10,
    'axes.labelcolor': TEXT_COLOR,
    'axes.labelsize': AXES_FONTSIZE,
    'axes.edgecolor': AXIS_COLOR,
    'axes.linewidth': AXES_LINEWIDTH,
    'axes.spines.top': False,
    'axes.spines.right': False,
    'axes.axisbelow': True,
    'axes.prop_cycle': cycler(color=list(COLORS)),
    'axes.formatter.useoffset': False,
    'axes.grid': True,
    'axes.grid.axis': 'y',
    'grid.color': GRID_COLOR,
    'grid.linewidth': GRID_LINEWIDTH,
    'grid.linestyle': '-',
    'xtick.color': TICK_COLOR,
    'ytick.color': TICK_COLOR,
    'xtick.labelcolor': TEXT_COLOR,
    'ytick.labelcolor': TEXT_COLOR,
    'ytick.major.size': 0,
    'lines.linewidth': SETS_LINEWIDTH,
    'lines.solid_capstyle': 'round',
    'lines.solid_joinstyle': 'round',
    'lines.markersize': 6,
    'legend.frameon': True,
    'legend.labelcolor': TEXT_COLOR,
  }


class VTBPlot(object):
  """A single-axes figure with VTB styling.

  Parameters
  ----------
  xlabel, ylabel : axis labels.
  usetex : render text with LaTeX (needs a LaTeX install; off by default).
  title : optional title, left-aligned above the axes.
  grid : 'y' (default), 'x', 'both' or None.
  figsize : figure size in inches.
  """

  def __init__(self, xlabel, ylabel, usetex=False, title=None, grid='y', figsize=(FIGSIZE_X, FIGSIZE_Y)):
    self.xrange = None
    self.yrange = None

    plt.rcParams.update(rc_params())
    plt.rc('text', usetex=usetex)

    self.fig = plt.figure(figsize=figsize)
    self.ax = plt.subplot(1, 1, 1)
    if grid:
      self.ax.grid(True, axis=grid)
    else:
      self.ax.grid(False)
    plt.xlabel(xlabel)
    plt.ylabel(ylabel)
    if title:
      self.ax.set_title(title)

  def set_xlim(self, xmin, xmax):
    self.xrange = (xmin, xmax)

  def set_ylim(self, ymin, ymax):
    self.yrange = (ymin, ymax)

  # The plotting methods draw on this plot's axes and take the same arguments
  # as their matplotlib counterparts. Omit ``color`` to take the next color
  # in the cycle.
  def plot(self, *args, **kwargs):
    return self.ax.plot(*args, **kwargs)

  def semilogy(self, *args, **kwargs):
    return self.ax.semilogy(*args, **kwargs)

  def errorbar(self, *args, **kwargs):
    return self.ax.errorbar(*args, **kwargs)

  def axvline(self, *args, **kwargs):
    kwargs.setdefault('color', AXIS_COLOR)
    kwargs.setdefault('linewidth', VLINE_LINEWIDTH)
    return self.ax.axvline(*args, **kwargs)

  def axhline(self, *args, **kwargs):
    kwargs.setdefault('color', AXIS_COLOR)
    kwargs.setdefault('linewidth', HLINE_LINEWIDTH)
    return self.ax.axhline(*args, **kwargs)

  def legend(self, *args, **kwargs):
    return self.ax.legend(*args, **kwargs)

  def finish(self, filename, close=True):
    """Apply axis limits, lay out, save to ``filename`` and (by default) close."""
    if self.xrange:
      xmin, xmax = self.xrange
      self.ax.set_xlim(xmin, xmax)

    if self.yrange:
      ymin, ymax = self.yrange
      self.ax.set_ylim(ymin, ymax)

    self.fig.tight_layout()
    self.fig.savefig(filename, dpi=300, bbox_inches='tight')
    if close:
      plt.close(self.fig)
