# Conjugate heat transfer simulation of a 67-pebble core

*Contact: John Acierno (Penn State), Dillon Shaver (dshaver.at.anl.gov), and April Novak (anovak.at.anl.gov)* 

In this tutorial we are going to set up and simulate a simple [!ac](CHT) case using a helium (Pr=0.71) cooled 67-pebble bed.
This tutorial was developed from an example case provided with NekRS and couples to MOOSE's [!ac](CHT) module using CARDINAL as a wrapper. 
More information about the NEAMS tool CARDINAL can be found on [github](https://github.com/neams-th-coe/cardinal), or on the [Cardinal website](https://cardinal.cels.anl.gov/).
In each time step MOOSE will solve the energy equation in the the solid subdomain and pass the solution to NekRS, which will in-turn solve both the Navier-Stokes and energy equations in the fluid subdomain.
NekRS will then pass its temperature solve back to MOOSE in the next time step. 
This transfer of information occurs at the boundary between solid and fluid subdomains, which are the pebble surfaces in this case.

!include CardinalandMOOSE.md

## Geometry and computational model

The geometry for this case consists of 67 pebbles in a randomly packed cylindrical bed.
The pebbles have a diameter of 1 (dimensionless) and the cylinder has a diameter of 4.4 (dimensionless).
The pebble bed begins around 2.5 pebble diameters upstream from the cylinder inlet and has a total heigh of about 5 pebble diameters.
A cross section of the fluid domain is shown in [pb67geom] where the fluid is the gray region and the pebbles are the white regions.

!media pb67_cardinal/fluid_slice.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=pb67geom
       caption=A cross section of the fluid domain for the 67 pebble geometry.

## NekRS

!include nekrs_dimless.md

!include nekrs_LES.md

## Heat Conduction Model

!include steady_hc.md

## Case Setup

### NekRS setup

For this case, the mesh file is provided and may be download from [here](pb67.re2.gz).
The provided file is zipped with the gzip utility and must be unzipped prior to use with

```$ gunzip pb67.re2.gz```

You should now have the mesh file ```pb67.re2```.
The mesh includes over 110,000 hexahedral elements and has been generated using a Voronoi cell approach [!cite](lan2021).

#### oudf file

We will begin by setting up the ```.oudf``` file. 
This file contains the setup for the required boundary conditions.

!listing /htgr/pb67_cardinal/pb67.oudf language=cpp

#### udf file

!listing /htgr/pb67_cardinal/pb67.udf language=cpp

#### par file

!listing /htgr/pb67_cardinal/pb67.par language=ini

#### usr file

!listing /htgr/pb67_cardinal/pb67.usr language=fortran

#### nek input

!listing /htgr/pb67_cardinal/nek.i

### MOOSE setup

To setup the MOOSE mesh, a text file containing the center points of each pebble is necessary. 
For the bed used in this case, the file can be obtained [here](/htgr/pb67/pb67_positions.txt).

!listing /htgr/pb67_cardinal/moose.i

!listing /htgr/pb67_cardinal/moose.i

## Results

!media pb67_cardinal/pb67_3D_renderings.png
  style=width:70%;margin-left:auto;margin-right:auto
  id=pb673D
  caption=3D volumetric renderings done in VisIt of the velocity (left) and the temperature (right) fields. 


