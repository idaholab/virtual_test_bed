#!/usr/bin/env python
"""Plot the IQS-vs-PKE transient comparison shown on doc/content/htgr/open-xe100/open-xe100_results.md.

Usage (from this directory, after running the IQS and PKE inputs):

    python plot_iqs_vs_pke.py                        # every plot, written to the current directory
    python plot_iqs_vs_pke.py power_comparison c-0   # only these plots
    python plot_iqs_vs_pke.py --data-dir gold --output-dir plots

The plots are read from iqs.csv, iqs_pke_params.csv and pke_fuel_auto.csv in the data directory
(the current directory by default) and are written as iqs_vs_pke_<name>.png.

The documentation makes the same plots from the gold files, using the scripts in
doc/content/media/htgr/open-xe100/iqs_vs_pke, which call this script.
"""

import argparse
import sys
from pathlib import Path
import pandas as pd

# Add VTB python directory to path
def find_vtb_python_dir():
    this_dir = Path(__file__).resolve().parent
    for folder in [this_dir, *this_dir.parents]: # this directory, then each one above it
        if (folder / "python" / "virtual_test_bed").is_dir():
            return folder / "python"
    raise RuntimeError("Could not find python/virtual_test_bed above " + str(this_dir))
sys.path.append(str(find_vtb_python_dir()))

from virtual_test_bed.plotting import VTBPlot

N_GROUPS = 6 # number of delayed neutron precursor groups

def read_data(data_dir='.'):
    """Read the IQS and PKE results from `data_dir`."""
    data_dir = Path(data_dir)
    return {
        'iqs': pd.read_csv(data_dir / 'iqs.csv'),
        'iqs_params': pd.read_csv(data_dir / 'iqs_pke_params.csv'),
        'pke': pd.read_csv(data_dir / 'pke_fuel_auto.csv'),
    }

def power(data):
    iqs, pke = data['iqs'], data['pke']
    return ("Normalized power [-]",
            iqs['time'], iqs['total_power'] / iqs['total_power'][0],
            pke['time'], pke['n'] / pke['n'][0])

def param(ylabel, iqs_column, pke_column):
    """A PKE parameter. The IQS and PKE outputs name their columns differently."""
    def get(data):
        iqs, pke = data['iqs_params'], data['pke']
        return ylabel, iqs['time'], iqs[iqs_column], pke['time'], pke[pke_column]
    return get

# Each plot is a function of the data returning (ylabel, IQS time, IQS values, PKE time, PKE values)
PLOTS = {
    'power_comparison': power,
    'mean_generation_time': param(r"Mean generation time $\Lambda$ [s]", 'Lambda', 'Lambda'),
}
for i in range(N_GROUPS):
    PLOTS[f'beta-{i}'] = param(rf"Delayed neutron fraction $\beta_{i}$ [-]", f'beta-{i}', f'betas_{i}')
    PLOTS[f'lambda-{i}'] = param(rf"Decay constant $\lambda_{i}$ [1/s]", f'lambda-{i}', f'lambdas_{i}')
    PLOTS[f'c-{i}'] = param(rf"Precursor concentration $C_{i}$ [#/cm$^3$]", f'c-{i}', f'precursor_{i}')

def make_plot(name, data, output_file):
    """Make the plot called `name` from `data` (see read_data) and save it to `output_file`."""
    ylabel, iqs_time, iqs_data, pke_time, pke_data = PLOTS[name](data)
    plot = VTBPlot("Time [s]", ylabel)
    plot.plot(iqs_time, iqs_data, 'o-', label="IQS")
    plot.plot(pke_time, pke_data, 's--', markerfacecolor='none', label="PKE")
    plot.legend()
    plot.finish(str(output_file))

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("plots", nargs="*", metavar="PLOT",
                    help="Plots to make (default: all). Any of: " + ", ".join(PLOTS))
    ap.add_argument("--data-dir", default=".", help="Directory with the results (default: current)")
    ap.add_argument("--output-dir", default=".", help="Directory for the images (default: current)")
    args = ap.parse_args()

    unknown = [p for p in args.plots if p not in PLOTS]
    if unknown:
        ap.error("unknown plot(s): " + ", ".join(unknown) + ". Choose from: " + ", ".join(PLOTS))

    try:
        data = read_data(args.data_dir)
    except FileNotFoundError as e:
        sys.exit(f"{e}\nRun the IQS and PKE inputs first, or use --data-dir to point to the results.")

    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    for name in args.plots or PLOTS:
        make_plot(name, data, output_dir / f"iqs_vs_pke_{name}.png")

if __name__ == "__main__":
    main()
