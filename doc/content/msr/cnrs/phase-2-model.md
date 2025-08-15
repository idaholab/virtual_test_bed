# Phase 2: Time-dependent Multiphysics Coupling

## Description

This phase is composed of a sole task which aims to verify the multiphysics coupled transient calculations.
The heat transfer coefficient is represented by a sinusoidal function of the following form
\begin{equation}\label{eq:heat_transfer_coefficient_s21}
  \gamma = \gamma_\circ\left(1+0.1\times \sin\left(2\pi f\right)\right)
\end{equation}
where $\gamma_\circ$ is the reference volumetric heat transfer coefficient, and f is the frequency which results in a sinusoidal behavior of the reactor power.
In the simulation, varying values of frequency used are 0.0125, 0.025, 0.05, 0.1, 0.2, 0.4, 0.8.
The power gain in the reactor with the varying power can be calculated as a function of frequency according to the following equation

\begin{equation}
  G(f) = \frac{P_\text{max}(f)/P_\text{avg}(f)-1}{\gamma_\text{max}(f)/\gamma_\text{avg}(f)-1}
\end{equation}

There are two coupled inputs for this stage. 
The first performs the neutronics calculations and the second performs the Navier-Stocks solution.
The sinusoidal power behavior modeling is defined in the neutronics input as a function within the ```Functions``` module within the Navier-Stocks input.

!listing msr/cnrs/s21/cnrs_s21_ns_flow.i block=Functions

For each frequency, 10 cycles are ran to obtain the asymptotic power wave.
The last three cycles are used to obtain the power gain and phase shift.
The problem is set to transient and the time step size is set inversely proportional to the frequency.
This is requested in the ```Executioner``` block in the neutronics input as

!listing msr/cnrs/s21/cnrs_s21_griffin_neutronics.i block=Executioner

The rest of the transport solve input has a structure similar to that of the transport input
in Step 1.3.
The difference is in assigning a ```transient``` equation type instead of 
```eigenvalue```, and changing ```type``` input in ```Executioner``` block
to ```Transient```.


On the Navier-Stokes solve side, the problem is still executed as a transient 
solver.
However, instead of running the problem for a long time to achieve steady state,
the problem is defined as follows

!listing msr/cnrs/s21/cnrs_s21_ns_flow.i block=Executioner

## Results

The results for this exercise report the power gain and the phase shift as a function of the frequency as defined above.
The power gain decreases with increases the frequency, and the phase shift approaches 90 degrees with increasing the frequency.
These results are displayed in [step21_result]

!media media/msr/cnrs/PowerGain_PhaseShift.png
  style=width:80%
  id=step21_result