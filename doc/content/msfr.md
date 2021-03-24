# Molten Salt Fast Reactor (MSFR)

## Reactor description

The VTB MSFR model is based off of the EVOL MSFR design
[!citep](brovchenko2019). It is a fast-spectrum, LiF salt reactor that produces
3 GW of thermal power.

## NEAMS model

!media msfr_mesh.png
       style=width:40%
       caption=The coarse MSFR mesh used for Griffin and Pronghorn calculations. Red indicates the bulk fuel salt. Blue and green represent the pump and heat exchanger regions. Purplande and orange are reflector/shield regions.

!media msfr_steady_T.png
       style=width:40%
       caption=Steady-state temperature in the MSFR.

Pronghorn models the equations:
\begin{equation}
  \nabla \cdot \overline{\vec{u}} = 0
\end{equation}
\begin{equation}
  \frac{\partial \overline{\vec{u}}}{\partial t}
  + \overline{\vec{u}} \cdot\nabla \overline{\vec{u}}
  = -\frac{1}{\rho_0} \nabla \overline{p} +
  \nu\nabla^2 \overline{\vec{u}}
  - \frac{1}{\rho_0} \nabla \cdot \rho_0 \overline{\vec{u}' \vec{u}'}
  + \vec{g} \left( 1 - \alpha \left(\overline{T} - T_0\right)\right)
\end{equation}
\begin{equation}
  \frac{\partial  \overline{T}}{\partial t}
  + \overline{\vec{u}} \cdot \nabla \overline{T}
  = \frac{\kappa}{\rho_0 c_p} \nabla^2 \overline{T}
  - \frac{1}{\rho_0 c_p} \nabla \cdot \rho_0 c_p \overline{T' \vec{u}'}
  + \frac{1}{\rho_0 c_p}\sum\limits_{g'=1}^G \kappa \Sigma_{f,g'} \phi_{g'},
\end{equation}
