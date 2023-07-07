import scipy as scp
import numpy as np
import matplotlib.pyplot as plt

turbulent = 1# 0 implies laminar, >0 implies turbulent

#=======================================
# full mesh, 2D
#=======================================
H = 2.36368 #from channel base to top
Dh = 40./1000.
Aw = 30727.523993417268/1000.0/1000.0 # cross-section area of the channel
Ahot = 1095958.0485001195/1000.0/1000.0 #area of the hot wall

#material properties, temperature BCs

rho_amb = 1.103236458 # ambient density at 50 deg C
kelvin = 273.15
T_in = 50.0 + kelvin
T_hot = (420.0 + kelvin) #*0.6337 # sinusoid, can also comment out 0.6 for constant BC
mu = 0.00001951
M_air = 28.9647/1000.0 # kg/mol
k_fluid = 0.02766 #W/m/K
P_atm = 101325.0
Cp = 1007.433186
Rgc = 8.314 # gas constant
g = 9.80665
Pr = mu*Cp/k_fluid
beta = 1.0/T_in

#=======================================

def T_mean(tout):
    return 0.5*(tout+T_in)

def rho_mean(to):
    return P_atm*M_air/Rgc/T_mean(to)

def reno(ub):
    return rho_amb*ub*Dh/mu

def fdturb(ub):
    return 0.3164*(reno(ub))**(-0.25) #Blasius, turbulent friction factor

def fdlam(ub):
    return 64.0/reno(ub)

def htcoeff(ub):
    return (k_fluid/Dh)*(0.023 * (reno(ub)**(0.8)) * Pr**(0.4)) #Dittus-Boelter, turbulent

def htlam():
    return (k_fluid/Dh)*(3.66) #Incropera, laminar

def pqbalance(ubto):
    ub, to = ubto
    #turbulent:
    expr1 = (rho_amb*beta*(T_mean(to)-T_in)*g*H) - (fdturb(ub)*rho_amb*ub*ub*H/2.0/Dh)
    expr2 = (Ahot*htcoeff(ub)*(T_hot-T_mean(to))) - (rho_amb*ub*Aw*Cp*(to-T_in))

    return (expr1,expr2)

def pqbalance_lam(ubto):
    ub, to = ubto
    expr1 = (rho_amb*beta*(T_mean(to)-T_in)*g*H) - (fdlam(ub)*rho_amb*ub*ub*H/2.0/Dh)  # P balance
    expr2 = (Ahot*htlam()*(T_hot-T_mean(to))) - (rho_amb*ub*Aw*Cp*(to-T_in))      # q balance
    return (expr1,expr2)

def richardson(ub):
    return g*beta*(T_hot-T_in)*Dh/ub/ub


if (turbulent):
    #turbulent solve
    Ubar, Tout =  scp.optimize.fsolve(pqbalance, (1.0, 0.5*(T_hot+T_in)))
else:
    # laminar solve
    Ubar, Tout =  scp.optimize.fsolve(pqbalance_lam, (0.5, 0.5*(T_hot+T_in)))

print("Mean velocity, outlet temp:",Ubar," m/s ", Tout, " K")

if (turbulent):
    # print residuals for balance equations assuming turbulent flow:
    print("Residual of turbulent momentum, energy balance:",pqbalance((Ubar,Tout)))
else:
    # print residuals for balance equations assuming laminar flow:
    print("Residual of laminar momentum, energy balance:",pqbalance_lam((Ubar,Tout)))


print("Reynolds no.:",reno(Ubar))
print("Friction factor:",fdturb(Ubar))
print("Mean density:",rho_mean(Tout))
print("Bulk temperature:",T_mean(Tout))
print("Richardson number:",richardson(Ubar))
