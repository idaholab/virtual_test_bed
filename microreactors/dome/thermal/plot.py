import matplotlib.pyplot as plt
import pandas
import argparse

def plotTemperatures(data, test):
    plt.figure(figsize=(8, 6))
    plt.rc("text", usetex=False)
    plt.rc("font", family="sans-serif")
    ax = plt.subplot(1, 1, 1)
    ax.get_yaxis().get_major_formatter().set_useOffset(False)
    plt.xlabel("Time [h]")
    plt.ylabel("Temperature [K]")
    plt.plot(data["time"] / 3600, data["Tavg_concrete"], linestyle="-", marker="", color="black", label="Avg. Concrete")
    plt.plot(data["time"] / 3600, data["Tmax_concrete"], linestyle="-", marker="", color="indianred", label="Max Concrete")
    plt.plot(data["time"] / 3600, data["T_water_out"], linestyle="-", marker="", color="cornflowerblue", label="Water Out")
    plt.plot(data["time"] / 3600, data["Tavg_shield_outer_air"], linestyle="-", marker="", color="lightgreen", label="Shield Outer, Air")
    plt.plot(data["time"] / 3600, data["Tavg_shield_outer_ground"], linestyle="-", marker="", color="mediumpurple", label="Shield Ground")
    ax.legend(frameon=True, prop={"size": 12})
    plt.tight_layout()
    plt.savefig(test + "_temperature.png", dpi=300)

def plotHeatRates(data, test):
    plt.figure(figsize=(8, 6))
    plt.rc("text", usetex=False)
    plt.rc("font", family="sans-serif")
    ax = plt.subplot(1, 1, 1)
    ax.get_yaxis().get_major_formatter().set_useOffset(False)
    plt.xlabel("Time [h]")
    plt.ylabel("Power [kW]")
    plt.plot(data["time"] / 3600, data["Q_core"] / 1e3, linestyle="-", marker="", color="black", label="Core")
    plt.plot(data["time"] / 3600, -data["Q_water"] / 1e3, linestyle="-", marker="", color="cornflowerblue", label="Water")
    plt.plot(data["time"] / 3600, data["Q_air"] / 1e3, linestyle="-", marker="", color="indianred", label="Air")
    plt.plot(data["time"] / 3600, data["Q_ground"] / 1e3, linestyle="-", marker="", color="lightgreen", label="Ground")
    plt.plot(data["time"] / 3600, data["Q_loss_total"] / 1e3, linestyle="-", marker="", color="mediumpurple", label="Total Loss")
    ax.legend(frameon=True, prop={"size": 12})
    plt.tight_layout()
    plt.savefig(test + "_power.png", dpi=300)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument("test", choices=['coarse', 'cartesian'], help="Test case")
    args = parser.parse_args()

    test = args.test
    if test == 'coarse':
        data_file = 'coarse/coarse_tr.csv'
    elif test == 'cartesian':
        data_file = 'standalone/cartesian.csv'

    data = pandas.read_csv(data_file)

    plotTemperatures(data, test)
    plotHeatRates(data, test)
