% --- SNAP 8 Core Model ---------

/*
General comments:
Core Modeling completed to allow for preliminary dry critical configuration
comparison with NAA-SR-9642. Work total excess reactivity is 5.7%, this was done
via implementing SS316 layering in core cylinder, Sm2O3 poisoning in fuel, and
removal of hexagonal vertices in reflector material.
*/

% --- Problem title:

set title "SNAP 8"

% --- Cross section library file path:

set acelib "/hpc-common/data/serpent/xsdata/s2v0_endfb71/s2v0_endfb71.xsdata"

% --- Materials:

include "SNAP8ER_f1200c900r300.mat"
% ------------------------------------------------------------

/************************
 * Geometry definitions *
 ************************/
% ---------------------
% Fuel Pin Definitions
% ---------------------
% --- Fuel Pin (0.56in OD, 0.01in Hastelloy N clad, 0.0022in Ceramic Coating, 0.0016 He gap)
% Ceramic thickness can be found here: SNAP and Al Fuel Summary Report, pg. 4
% Other dimensions: NAA-SR-9642, pg. 19
pin 100
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 200
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 400
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 500
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 600
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 700
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 800
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

pin 900
UZrH     0.67564
ceramic  0.681228
Sm2O3    0.6812587
intatm   0.6858
hasteN   0.7112
nak

% --- Void Pin
pin 300
nak

% ---------------------
% Surface Definitions
% ---------------------

% --- Cylindrical Surface for reactor core boundary, 9.352in OD (NAA-SR-9642, pg. 13)

surf S5 cyl 0.0 0.0 11.87704 % -18.3769 18.3769

surf SUG cyl 0.0 0.0 11.87704 % 18.3769  19.2500 % for upper grid plate
surf SLG cyl 0.0 0.0 11.87704 %-19.1707 -18.3769 % for lower grid plate
surf S12 cyl 0.0 0.0 11.718036 %-18.3769 18.3769
surf S13 cyl 0.0 0.0 11.93 %-18.3769 18.3769
surf S14 cyl 0.0 0.0 11.6926 %-18.3769 18.3769
surf SCube sqc 0.0 0.0 11.87704

% --- surfaces for drums
surf sDrum1 cyl  23.972012 0.0 11.9126% -18.3769 18.3769
surf sDrum4 cyl -23.972012 0.0 11.9126% -18.3769 18.3769
surf sDrum2 cyl  11.9860  20.7604 11.9126% -18.3769 18.3769
surf sDrum3 cyl -11.9860  20.7604 11.9126% -18.3769 18.3769
surf sDrum5 cyl -11.9860 -20.7604 11.9126% -18.3769 18.3769
surf sDrum6 cyl  11.9860 -20.7604 11.9126% -18.3769 18.3769

% --- surfaces for void near drums
surf sVDrum1 cyl  23.972012 0.0    11.95% -18.3769 18.3769
surf sVDrum4 cyl -23.972012 0.0    11.95% -18.3769 18.3769
surf sVDrum2 cyl  11.9860  20.7604 11.95% -18.3769 18.3769
surf sVDrum3 cyl -11.9860  20.7604 11.95% -18.3769 18.3769
surf sVDrum5 cyl -11.9860 -20.7604 11.95% -18.3769 18.3769
surf sVDrum6 cyl  11.9860 -20.7604 11.95% -18.3769 18.3769

% --- Cutoff at the end of hexagonal vertex for drums
surf sCut1 plane     0       20.9     0 436.81
surf sCut2 plane   -18.0999  10.450   0 436.81
surf sCut3 plane   -18.0999 -10.450   0 436.81
surf sCut4 plane     0      -20.9     0 436.81
surf sCut5 plane    18.0999 -10.45    0 436.81
surf sCut6 plane    18.0999  10.45    0 436.81

% --- Cutoff for stationary reflectors
surf sStatCut1 plane     0       18.9     0 357.21
surf sStatCut2 plane   -16.3679   9.450   0 357.21
surf sStatCut3 plane   -16.3679  -9.450   0 357.21
surf sStatCut4 plane     0      -18.9     0 357.21
surf sStatCut5 plane    16.3679  -9.45    0 357.21
surf sStatCut6 plane    16.3679   9.45    0 357.21


% --- surfaces for empty shims
surf sShimE1 plane  17.8206  0       0 317.5752
surf sShimE2 plane   8.9103  15.4331 0 317.5752
surf sShimE3 plane  -8.9103  15.4331 0 317.5752
surf sShimE4 plane -17.8206  0       0 317.5752
surf sShimE5 plane  -8.9103 -15.4331 0 317.5752
surf sShimE6 plane   8.9103 -15.4331 0 317.5752

% --- surfaces for B shims
surf sShimB1 plane  21.9354   0      0 481.1618
surf sShimB2 plane  10.9677  18.9966 0 481.1618
surf sShimB3 plane -10.9677  18.9966 0 481.1618
surf sShimB4 plane -21.9354   0      0 481.1618
surf sShimB5 plane -10.9677 -18.9966 0 481.1618
surf sShimB6 plane  10.9677 -18.9966 0 481.1618

%--- BEGIN CUBOID DEFINITIONS
surf sCuboid1 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24
surf sCuboid2 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24
surf sCuboid3 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24
surf sCuboid4 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24
surf sCuboid5 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24
surf sCuboid6 rect 19.7002 21.9354 -7.712 7.712 %-15.24 15.24

% --- surfaces for internal reflectors
surf srefl1 plane  0      11.0668 0 122.4736
surf srefl2 plane -9.5841  5.5334 0 122.4736
surf srefl3 plane -9.5841 -5.5334 0 122.4736
surf srefl4 plane  0     -11.0668 0 122.4736
surf srefl5 plane  9.5841 -5.5334 0 122.4736
surf srefl6 plane  9.5841  5.5334 0 122.4736

% --- Begin Surface Definitions for Housing --- %
surf sHouseD1 cyl  23.972012 0.0    11.75385% -18.3769 18.3769
surf sHouseD4 cyl -23.972012 0.0    11.75385% -18.3769 18.3769
surf sHouseD2 cyl  11.9860  20.7604 11.75385% -18.3769 18.3769
surf sHouseD3 cyl -11.9860  20.7604 11.75385% -18.3769 18.3769
surf sHouseD5 cyl -11.9860 -20.7604 11.75385% -18.3769 18.3769
surf sHouseD6 cyl  11.9860 -20.7604 11.75385 -18.3769 18.3769
surf sHouseE1 plane  17.6619  0       0 311.9409
surf sHouseE2 plane   8.8309  15.2956 0 311.9409
surf sHouseE3 plane  -8.8309  15.2956 0 311.9409
surf sHouseE4 plane -17.6619  0       0 311.9409
surf sHouseE5 plane  -8.8309 -15.2956 0 311.9409
surf sHouseE6 plane   8.8309 -15.2956 0 311.9409
surf sHCut1 plane     0       20.7413  0 430.1995
surf sHCut2 plane   -17.9624  10.3706  0 430.1995
surf sHCut3 plane   -17.9624 -10.3706  0 430.1995
surf sHCut4 plane     0      -20.741   0 430.1995
surf sHCut5 plane    17.9624 -10.3706  0 430.1995
surf sHCut6 plane    17.9624  10.3706  0 430.1995
surf S8House hexxc 0.0 0.0 19.54145% -18.3769 18.3769
surf sHrefl1 plane  0      11.0414 0 121.9121
surf sHrefl2 plane -9.5621  5.5207 0 121.9121
surf sHrefl3 plane -9.5621 -5.5207 0 121.9121
surf sHrefl4 plane  0     -11.0414 0 121.9121
surf sHrefl5 plane  9.5621 -5.5207 0 121.9121
surf sHrefl6 plane  9.5621  5.5207 0 121.9121

% --- Hexagonal surfrace for reflector core boundaries, 9.352in OD + 0.0818 reflector radial thickness at thinnest point
%     + 4.68 drum radius =23.972012 cm radial distance flat to flat x-hexagonal (NAA-SR-9642, pg. 13)
%     Note that the actual thickest portion of the drum is noted as 3 inches which makes the half distance from flat point
%     to flat point 9.352 OD + 0.0818 + 3 in drum thickness = 19.704812 cm distance flat to flat x-hexagonal (AI-AEC-13070
%     Table 2 Sheet 2 of 4)

surf S8 hexxc 0.0 0.0 19.7002% -18.3769 18.3769

% ---------------------
% Cell Definitions
% ---------------------


% --- Latice x-type hexagonal, pitch = 0.57in (NAA-SR-9642, pg. 19)
%     Lattice universe is part of universe "core"
% lat Uni Type x_o y_o UNI
lat C3critload 2 0.0 0.0 21 21 1.4478
300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300
  300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300
    300 300 300 300 300 300 300 300 300 300 300 800 800 800 800 800 800 800 300 300 300 % top row, 7 inside, ending in position 4
      300 300 300 300 300 300 300 300 300 800 700 700 700 700 700 700 700 700 800 300 300 % 10 inside, ending in position 300
        300 300 300 300 300 300 300 300 800 700 600 600 600 600 600 600 600 700 800 300 300 % 11 inside, ending in position 300
          300 300 300 300 300 300 300 800 700 600 500 500 500 500 500 500 600 700 800 300 300 % 12 inside, ending in position 300
            300 300 300 300 300 300 800 700 600 500 400 400 400 400 400 500 600 700 800 300 300 % 1300 inside, ending in position 300
              300 300 300 300 300 800 700 600 500 400 900 900 900 900 400 500 600 700 800 300 300 % 14 inside, ending in position 300
                300 300 300 300 800 700 600 500 400 900 200 200 200 900 400 500 600 700 800 300 300 % 15 inside, ending in position 300
                  300 300 300 800 700 600 500 400 900 200 100 100 200 900 400 500 600 700 800 300 300 % 16 inside, ending in position 300
                    300 300 300 700 600 500 400 900 200 100 100 100 200 900 400 500 600 700 300 300 300 % middle row, 15 inside, starting in position 4
                      300 300 800 700 600 500 400 900 200 100 100 200 900 400 500 600 700 800 300 300 300 % 15 inside, starting in position 300
                        300 300 800 700 600 500 400 900 200 200 200 900 400 500 600 700 800 300 300 300 300 % 14 inside, starting in position 300
                          300 300 800 700 600 500 400 900 900 900 900 400 500 600 700 800 300 300 300 300 300 % 1300 inside, starting in position 300
                            300 300 800 700 600 500 400 400 400 400 400 500 600 700 800 300 300 300 300 300 300 % 12 inside, starting in position 300
                              300 300 800 700 600 500 500 500 500 500 500 600 700 800 300 300 300 300 300 300 300 % 11 inside, starting in position 300
                                300 300 800 700 600 600 600 600 600 600 600 700 800 300 300 300 300 300 300 300 300 % 10 inside, starting in position 300
                                  300 300 800 700 700 700 700 700 700 700 700 800 300 300 300 300 300 300 300 300 300 % 9 inside, starting in position 300
                                    300 300 300 800 800 800 800 800 800 800 300 300 300 300 300 300 300 300 300 300 300 % bottom row, 7 are inside, starting in position 4
                                      300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300
                                        300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300 300

% --- These cells define the reactor i.e. cutting off the "core"
%     universe with cylindrical boundaries

% --- fill definitions

cell cInternRefl1   1200  reflMix  srefl1 -S14% -sHouseZ1 sHouseZ2
cell cInternRefl2   1200  reflMix  srefl2 -S14% -sHouseZ1 sHouseZ2
cell cInternRefl3   1200  reflMix  srefl3 -S14% -sHouseZ1 sHouseZ2
cell cInternRefl4   1200  reflMix  srefl4 -S14% -sHouseZ1 sHouseZ2
cell cInternRefl5   1200  reflMix  srefl5 -S14% -sHouseZ1 sHouseZ2
cell cInternRefl6   1200  reflMix  srefl6 -S14% -sHouseZ1 sHouseZ2
cell cHouseRefl1    1200 reflMix (sHrefl1 -srefl1 -S12):(S14 -S12 srefl1)
cell cHouseRefl2    1200 reflMix (sHrefl2 -srefl2 -S12):(S14 -S12 srefl2)
cell cHouseRefl3    1200 reflMix (sHrefl3 -srefl3 -S12):(S14 -S12 srefl3)
cell cHouseRefl4    1200 reflMix (sHrefl4 -srefl4 -S12):(S14 -S12 srefl4)
cell cHouseRefl5    1200 reflMix (sHrefl5 -srefl5 -S12):(S14 -S12 sHrefl5)
cell cHouseRefl6    1200 reflMix (sHrefl6 -srefl6 -S12):(S14 -S12 srefl6)

cell cIntRefCore reactor fill 1200 (-S12 sHrefl1):(-S12 sHrefl2):(-S12 sHrefl3):(-S12 sHrefl4):(-S12 sHrefl5):(-S12 sHrefl6)
cell cCore reactor fill C3critload -S12 -sHrefl1 -sHrefl2 -sHrefl3 -sHrefl4 -sHrefl5 -sHrefl6
cell cCoreWall 1200  ss316 S12 -S5
cell cBarrel reactor fill 1200 S12 -S5
cell voidCell reactor void S5 -SCube

%surf cuty px 0
%surf cuthex plane 0 0 0 25.98076211350 15 0 0 0 1
% --- Cell cIN  is filled with universe "core", also its important to keep in mind that
%     the "0" universe is the universe for which outside needs to be defined.
%     Serpent gives the warning that the  '0' universe should be the only one defining outside
%     although this is not strictly true based on serpent-2 documentation.
%cell cIN 0 fill reactor cuty -cuthex -SCube
cell cIN 0 fill reactor -SCube

% --- Cell cOUT  is defined as everything outside the cubic cell
cell cOuT 0 outside SCube

% ------------------------------------------------------------

/******************
 * Run parameters *
 ******************/

% --- Boundary condition (1 = black, 2 = reflective, 3 = periodic)

set bc 1 1 2

% --- Neutron population: 100000 neutrons per cycle, 60 active / 20 inactive cycles

set pop 1000000 100 40

% --- XY-plot (3)

plot 31 1000 1000  %-19.0
plot 31 1000 1000  18.2
plot 31 1000 1000 -17.8
plot 21 1000 1000
%plot 11 1000 1000
% --- XY-meshplot (3), which is 700 by 700 pixels and covers the whole geometry

mesh 3 900 900
mesh 2 900 900
%branch Fhi  stp UZrH -6.0968 600
%branch dens repm UZrH UZrH_dens
%set power 1000
%dep daystep 10 20 30
set gcu 300 100 200 400 500 600 700 800 900 1200
ene sxtngroup 1 2.53E-08  1.00E-07  4.00E-07  1.00E-06  3.00E-06  1.00E-05  3.00E-05  1.00E-04  5.50E-04  3.00E-03  1.70E-02  1.00E-01  4.00E-01  9.00E-01  1.40E+00  3.00E+00  1.00E+01
set nfg sxtngroup

det ring1 de eqLet du 100
det ring2 de eqLet du 200
det ring3 de eqLet du 900
det ring4 de eqLet du 400
det ring5 de eqLet du 500
det ring6 de eqLet du 600
det ring7 de eqLet du 700
det ring8 de eqLet du 800
det ring9 de eqLet du 300
det ref de eqLet du 1200
ene eqLet 3 1500 1e-9 2e1

%det ringpowers dr -8 void dx -10.71 10.71 17 dy -10.71 10.71 17

