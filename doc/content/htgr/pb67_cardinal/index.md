# Conjugate heat transfer simulation of a 67-pebble core

*Contact: John Acierno (Penn State), Dillon Shaver (dshaver.at.anl.gov), and April Novak (anovak.at.anl.gov)* 

In this tutorial we are going to set up and simulate a simple [!ac](CHT) case using a helium (Pr=0.71) cooled 67-pebble bed.
This tutorial was developed from an example case provided with NekRS and couples to MOOSE's [!ac](CHT) module using CARDINAL as a wrapper. 
More information about the NEAMS tool CARDINAL can be found on [github](https://github.com/neams-th-coe/cardinal), or on the [Cardinal website](https://cardinal.cels.anl.gov/).
In each time step MOOSE will solve the energy equation in the the solid subdomain and pass the solution to NekRS, which will in-turn solve both the Navier-Stokes and energy equations in the fluid subdomain.
NekRS will then pass its temperature solution back to MOOSE in the next time step. 
This transfer of information occurs at the boundary between solid and fluid subdomains, which are the pebble surfaces in this case.

!include CardinalandMOOSE.md

## NekRS

!include nekrs_dimless.md

!include nekrs_LES.md

## Heat Conduction Model

!include steady_hc.md

## Geometry and computational model

The geometry for this case consists of 67 pebbles in a randomly packed cylindrical bed.
The pebbles have a diameter of 1 (dimensionless) and the cylinder has a diameter of 4.4 (dimensionless).
The pebble bed begins around 2.5 pebble diameters upstream from the cylinder inlet and has a total height of about 5 pebble diameters.
A cross section of the fluid domain is shown in [pb67geom] where the fluid is the gray region and the pebbles are the white regions.

!media pb67_cardinal/fluid_slice.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=pb67geom
       caption=A cross section of the fluid domain for the 67 pebble geometry.

## NekRS Setup

For this case, the mesh file is provided through github Large File Storage (LFS) system.
It can be downloaded in the following way

```language=bash
$ cd virtual_test_bed/htgr/pb67_cardinal
$ git lfs fetch pb67.re2
```

The mesh includes over 110,000 hexahedral elements and has been generated using a Voronoi cell approach [!cite](lan2021).

### oudf file style=font-size:125%

We will begin by setting up the +.oudf+ file. 
This file contains the setup for the required boundary conditions.

!listing /htgr/pb67_cardinal/pb67.oudf language=cpp

Note that we have ```bc->flux = bc->wrk[bc->idM]``` in +scalarNeumannConditions+ block. 
This line allows NekRS to use the heat flux provided by the MOOSE CHT module at the surface of the pebbles instead of using a constant heat flux as previously defined.
There are also two kernel functions defined in the +.oudf+ file, ```cliptOKL``` and ```userVp```.
The ```cliptOKL``` kernel is used to limit extreme temperatures in the simulation which can occur in underresolved parts of the mesh. If the temperature is greater than 100 or less than 0, this kernel will set the temperature to 100 or 0 respectively. 
The ```userVp``` kernel simply increases the viscosity and conductivity near the underresolved outlet in order to maintain a stable solution.

### udf file style=font-size:125%

The +.udf+ file utilizes the kernal functions we defined in +.oudf+, and provides the detailed configurations of the related nekRS simulations. 

!listing /htgr/pb67_cardinal/pb67.udf language=cpp

### par file style=font-size:125%

The +.par+ file lists the necessary input parameters to nekRS simulations. 

!listing /htgr/pb67_cardinal/pb67.par language=ini

The +CUDA+ backend is enabled in ```[OCCA]``` block to allow nekRS running on GPU hardware. The specific filtering settings allow us to smooth out high frequencies. If you are planning on doing a DNS you should not include any filtering.
Next, the parameters in ```[PRESSURE]``` block are selected to have a short time-to-solution. We are able to achieve this by adding a preconditioner and a smoother. In NekRS version 21.1 the combination of semg preconditioner with ```chebyshev+asm``` smoothers works well, but in later versions 22.0+, using the amgx preconditioner with ```chebyshev+jac``` smoothers is much faster.

### usr file style=font-size:125%

The +.usr+ is a legacy from Nek5000 code, and we still use to specify the boundary conditons in Nek CFD calculations. 
Here we prescribe every element a boundaryID for both velocity and temperature. We are able to check the type of element using ```cbc(ifc,iel,1).eq.'TOP'``` and assign boundary types based on that. 
In this case we have 5 types of elements: inlet, outlet, outer wall, pebble wall, and chamfer wall. Notice, for the chamfer we assign the wall condition for velocity, but the +E+ condition for temperature. 
This results in flow moving around the chamfered area without an additional heat flux. The chamfer is necessary to prevent a mesh singularity between touching pebbles.

!listing /htgr/pb67_cardinal/pb67.usr language=fortran start=subroutine usrdat2() end=subroutine usrdat3 


## MOOSE setup

As previously stated, we strongly recommend completing the CHT tutorials on CARDINAL, which fully describe every aspect of the MOOSE setup. Here, we will only cover case specific necessities.

In this case we need to create two files: +nek.i+ and +moose.i+ pertaining to the NekRS and MOOSE parameters respectively.

Starting with the simpler +nek.i+ which contains the following

!listing /htgr/pb67_cardinal/nek.i

In the ```[MESH]``` block, MOOSE will create a copy of the Nek mesh at the given boundaries. In this case it is at the pebble surfaces. 
In the ```[Problem]``` block we define the name of corresponding NekRS files. 
Next, we want MOOSE to use the same time steps as Nek so we prescribe that in the ```[Executioner]``` block. 
In the ```[Output]``` block we tell MOOSE to output an exodus file of the shallow Nek copy every 1,000 time steps. This can be a helpful check at the beginning of the simulation to make sure you are using the correct boundaries. 
Finally, in the ```[Postprocessor]``` block we define what values we want MOOSE to calculate for us. Here we want the integral flux, min, max, and average temperature at the pebble surface.

To setup the MOOSE mesh, a text file containing the center points of each pebble is necessary. 
For the bed used in this case, the file can be obtained [here](/htgr/pb67_cardinal/positions.txt).

!listing /htgr/pb67_cardinal/moose.i

Notice in the ```[MESH]``` block we are using a file to generate the solid mesh. Make sure to include the sphere.e file in your working directory. We use this single sphere of radius 1 and duplicate it using `CombinerGenerator` and all of the coordinates of the 67 pebbles given in +positions.txt+. 
From here we scale down the pebbles to ensure that they are not touching in the solid mesh. We then call the heat conduction module in the ```[KERNEL]``` block ensuring MOOSE will solve the temperature in the solid mesh. 
Then we tell MOOSE to match the boundary conidtions use in Nek in the ```[BCs]``` block. In the ```[TRANSFER]``` block we define what and how variables get transfered. We define a multi app and transfer the temperature from Nek to MOOSE and return the average flux and flux integral back to Nek. Built in post-processors are used to obtain these values. Finally, we define an aux kernel to model the avg flux. Notice in +nek.i+ the boundary from nek is 4 and in +moose.i+ the boundary of interest is 1. Be sure not to mix up the boundaries in the fluid and solid mesh.

## Results

Below are 3D renderings done in VisIt of the velocity(left) and temperature(right) fields.

!media pb67_cardinal/pb67_3D_renderings.png
  style=width:70%;margin-left:auto;margin-right:auto
  id=pb673D
  caption=3D volumetric renderings done in VisIt of the velocity (left) and the temperature (right) fields. 


