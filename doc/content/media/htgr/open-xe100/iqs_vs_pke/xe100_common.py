"""Shared code for the IQS-vs-PKE plot scripts of doc/content/htgr/open-xe100/open-xe100_results.md.

Each script in this directory makes one image, named after the script, from the gold files of the
Open Xe-100 transient (IQS and PKE) cases. MooseDocs runs them on-the-fly via, for example,

    !media htgr/open-xe100/iqs_vs_pke/power_comparison.py

The plotting itself is done by htgr/open-xe100/plot_iqs_vs_pke.py, which users can also run on
their own results.
"""

import os
import sys
from pathlib import Path

# To make the relative paths work
os.chdir(os.path.dirname(os.path.realpath(__file__)))

MODEL_DIR = Path('../../../../../../htgr/open-xe100').resolve()
sys.path.append(str(MODEL_DIR))

import plot_iqs_vs_pke

def make_plot(script, name):
    """Make the plot called `name` from the gold files, saved next to `script` as <script>.png."""
    data = plot_iqs_vs_pke.read_data(MODEL_DIR / 'gold')
    plot_iqs_vs_pke.make_plot(name, data, Path(script).resolve().with_suffix('.png'))
