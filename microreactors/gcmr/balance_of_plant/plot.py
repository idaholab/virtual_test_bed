#!/usr/bin/env python
"""Plot the balance-of-plant results shown on doc/content/microreactors/gcmr/BOP_results.md.

Usage (from this directory, after running the inputs):

    python plot.py startup
    python plot.py load_follow
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

def makePlots(test):
    data_filename = 'htgr_' + test + '_transient.csv'
    data = pd.read_csv(data_filename)

    plotTorques(data, test)
    plotOmega(data, test)
    plotPrimaryMassFlowRate(data, test)
    plotSecondaryMassFlowRate(data, test)
    plotPrimaryPressure(data, test)
    plotSecondaryPressure(data, test)
    plotTemperature(data, test)
    plotPower(data, test)

def plotTorques(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Torque [N·m]")
    plot.plot(t_hours, data["sec_motor_torque"], label="Motor")
    plot.plot(t_hours, data["turbine_torque"], label="Turbine")
    plot.legend()
    plot.finish(test + "_torques.png")

def plotOmega(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Rotation speed [rad/s]")
    plot.plot(t_hours, data["shaft_speed"])
    plot.finish(test + "_omega.png")

def plotPrimaryMassFlowRate(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Mass flow rate [kg/s]")
    plot.plot(t_hours, data["core_m_dot_in"])
    plot.finish(test + "_primary_m_dot.png")

def plotSecondaryMassFlowRate(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Mass flow rate [kg/s]")
    plot.plot(t_hours, data["hx_sec_m_dot_in"])
    plot.finish(test + "_secondary_m_dot.png")

def plotPrimaryPressure(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Pressure [MPa]")
    plot.plot(t_hours, data["core_p_in"] * 1e-6, label="Core inlet")
    plot.plot(t_hours, data["hx_pri_p_in"] * 1e-6, label="Primary side, heat exchanger inlet")
    plot.plot(t_hours, data["pump_p_in"] * 1e-6, label="Pump inlet")
    plot.legend()
    plot.finish(test + "_primary_P.png")

def plotSecondaryPressure(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Pressure [MPa]")
    plot.plot(t_hours, data["comp_p_in"] * 1e-6, label="Compressor inlet")
    plot.plot(t_hours, data["comp_p_out"] * 1e-6, label="Compressor outlet")
    plot.plot(t_hours, data["hx_sec_p_in"] * 1e-6, label="Secondary side, heat exchanger inlet")
    plot.plot(t_hours, data["hx_sec_p_out"] * 1e-6, label="Secondary side, heat exchanger outlet")
    plot.plot(t_hours, data["turb_p_in"] * 1e-6, label="Turbine inlet")
    plot.plot(t_hours, data["turb_p_out"] * 1e-6, label="Turbine outlet")
    plot.legend()
    plot.finish(test + "_secondary_P.png")

def plotTemperature(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Temperature [K]")
    plot.plot(t_hours, data["core_T_wall_in"], label="Wall, core inlet")
    plot.plot(t_hours, data["core_T_wall_out"], label="Wall, core outlet")
    plot.plot(t_hours, data["core_T_in"], label="Coolant, core inlet")
    plot.plot(t_hours, data["core_T_out"], label="Coolant, core outlet")
    plot.plot(t_hours, data["hx_sec_T_in"], label="Secondary side, heat exchanger inlet")
    plot.plot(t_hours, data["hx_sec_T_out"], label="Secondary side, heat exchanger outlet")
    plot.legend()
    plot.finish(test + "_T.png")

def plotPower(data, test):
    t_hours = data["time"] / 3600.0
    plot = VTBPlot("Time [h]", "Power [MW]")
    plot.plot(t_hours, data["core_power_difference"] * 1e-6, label="Power transferred in the core")
    plot.plot(t_hours, -data["hx_pri_power_difference"] * 1e-6, label="Power transferred in the heat exchanger")
    plot.plot(t_hours, -data["generator_power"] * 1e-6, label="Power transferred in the generator")
    plot.legend()
    plot.finish(test + "_power.png")

def main():
    ap = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    ap.add_argument("test", help="Test case", choices=['startup', 'load_follow'])
    args = ap.parse_args()

    makePlots(args.test)


if __name__ == "__main__":
    main()
