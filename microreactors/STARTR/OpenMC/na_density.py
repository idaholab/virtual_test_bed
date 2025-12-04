def calc_na_density(temperature=294):
    """
    Calculate the density (g/cc) of Na coolant from O.J. Foust, Sodium-NaK Engineering Handbook, Gordin and 
    Breach Science Publishers Inc. (1972), eq. 1.3, p.g. 13
    """
    avail_temps = [250, 294, 600, 900, 1200, 2500] # cross-section temps in endfb 8.0 library
    t = min(avail_temps, key=lambda x: abs(x - temperature))
    print(t)
    # Convert temp to celcius
    t = t - 293.15
    density = (0.9501 - 2.2976e-04*t - 1.46e-08*t**2 + 5.638e-12*t**3)
    return density

# Check if temperature correction works and output density
if __name__ == "__main__":
    readout = calc_na_density(899)
    print(readout)
