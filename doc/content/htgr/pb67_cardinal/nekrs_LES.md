This case uses an LES turbulence model in nekRS. 
For LES, the viscous stress tensor is given by

\begin{equation}
\tau_{ij} = \mu_f\left(\frac{\partial u_i}{\partial x_j}+\frac{\partial u_j}{\partial x_i}\right)
\end{equation}

and a filtering operation is implemented as a source term to the momentum equation

\begin{equation}
f_i = - \chi \left(u_i - H * u_i\right) + \hat f_i
\end{equation}

where $\chi$ is the filter strength and $(H\ *)$ is an element-wise convolution operator that acts on the specified number of modes (usually two).
These are integrated into the dimensionless momentum equation to yield

\begin{equation}
\label{eq:LES_mom}
\frac{\partial u_i^\dagger}{\partial t^\dagger}+u_j^\dagger\frac{\partial u_i^\dagger}{\partial x_j^\dagger} 
=-\frac{\partial P^\dagger}{\partial x_i^\dagger}
+\frac{1}{Re}\frac{\partial^2 u_i^\dagger}{\partial x_j^{\dagger 2}}
-\chi\left( u_i^\dagger - H * u_i^\dagger\right)
+\hat f_i^\dagger
\end{equation}

where $\hat f_i^\dagger$ may include other momentum source terms.
