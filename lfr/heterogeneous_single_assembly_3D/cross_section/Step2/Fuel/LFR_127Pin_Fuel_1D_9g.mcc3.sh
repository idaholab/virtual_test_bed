#!/bin/bash
# ***************************************************************************************
# LFR 127-pin fuel assembly 
# Strategy: 
#          1) Homogenize each axial region of fuel assembly radially -> 1041g MCC3 infinite medium
#          2) Represent axial regions in TWODANT    -> 1041g RZMFLX
#          3) [Non-fuel regions] Collapse 1041g MCC3 infinite medium mixture with RZMFLX
#      **  4) [Fuel/Control] Collapse 1D MCC3 cylinder geometry with RZMFLX 
# ***************************************************************************************

lib=/software/MCC3
cp ../../Step1/LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh.rzmflx rzmflx

cat > input << EOF
&library
     c_mcclibdir  ="$lib/lib.mcc.new"
     c_pwlibdir   ="$lib/lib.pw.200.new","."
/
&control
     c_group_structure       =ANL9
     i_number_region         =29
     c_geometry_type         =cylinder
     i_scattering_order      =3
     c_externalspectrum_ufg  =rzmflx
/
&control1d
     l_spatial_homogenization = F
/
&geometry
     i_mesh     = 4 4 4 4 4
                  4 4 4 4 4
                  4 4 4 4 4
                  4 4 4 4 4
                  4 4 4 4 4
                  4 4 4 4
     r_location = 0.4495 0.5404 1.0541 1.1752 1.6104
                  1.6921 2.1694 2.2905 2.7696 2.8654
                  3.3589 3.4774 3.9659 4.0668 4.5650
                  4.6818 5.1737 5.2771 5.7773 5.8929
                  6.3865 6.4913 6.9925 7.1074 7.6018
                  7.7076 8.0553 8.4263 8.6193
     i_composition =  2  9  1  9
                      3  9  1  9
                      4  9  1  9
                      5  9  1  9
                      6  9  1  9
                      7  9  1  9
                      8  9  1 10  11
/

&material

i_externalspectrum(1) = 6    ! Active Fuel, use region 6 flux from MC2-3/TWODANT Calculation

!************************************
!Description	Composition #
!Coolant	1
!Fuel Ring 1	2
!Fuel Ring 2	3
!Fuel Ring 3	4
!Fuel Ring 4	5
!Fuel Ring 5	6
!Fuel Ring 6	7
!Fuel Ring 7	8
!Clad     	9
!Duct           10
!Gap Coolant	11
!************************************

t_composition(:,1)=   ! Pb Coolant in active fuel zone; density= 10.402 g/cc
PB2047   PB204A  4.2322E-04   808.0
PB2067   PB206A  7.2854E-03   808.0
PB2077   PB207A  6.6808E-03   808.0
PB2087   PB208A  1.5840E-02   808.0

t_composition(:,2)=   ! UPuO-He smeared mixture in active fuel zone ring 1; density= 7.289 g/cc
U234_7   U234B   1.2754E-07   1300.0
U235_7   U235B   3.1753E-05   1300.0
U238_7   U238B   1.2509E-02   1300.0
PU2387   PU238B  8.9755E-06   1300.0
PU2397   PU239B  2.4609E-03   1300.0
PU2407   PU240B  9.5162E-04   1300.0
PU2417   PU241B  6.2414E-05   1300.0
PU2427   PU242B  8.9004E-05   1300.0
AM2417   AM241B  1.5049E-04   1300.0
O16__7   O16B    3.2041E-02   1300.0
HE4__7   HE4B    6.9850E-06   1300.0

t_composition(:,3)=   ! UPuO-He smeared mixture in active fuel zone ring 2; density= 7.289 g/cc 
U234_7   U234C   1.2754E-07   1300.0
U235_7   U235C   3.1753E-05   1300.0
U238_7   U238C   1.2509E-02   1300.0
PU2387   PU238C  8.9755E-06   1300.0
PU2397   PU239C  2.4609E-03   1300.0
PU2407   PU240C  9.5162E-04   1300.0
PU2417   PU241C  6.2414E-05   1300.0
PU2427   PU242C  8.9004E-05   1300.0
AM2417   AM241C  1.5049E-04   1300.0
O16__7   O16C    3.2041E-02   1300.0
HE4__7   HE4C    6.9850E-06   1300.0


t_composition(:,4)=   ! UPuO-He smeared mixture in active fuel zone ring 3; density= 7.289 g/cc
U234_7   U234D   1.2754E-07   1300.0
U235_7   U235D   3.1753E-05   1300.0
U238_7   U238D   1.2509E-02   1300.0
PU2387   PU238D  8.9755E-06   1300.0
PU2397   PU239D  2.4609E-03   1300.0
PU2407   PU240D  9.5162E-04   1300.0
PU2417   PU241D  6.2414E-05   1300.0
PU2427   PU242D  8.9004E-05   1300.0
AM2417   AM241D  1.5049E-04   1300.0
O16__7   O16D    3.2041E-02   1300.0
HE4__7   HE4D    6.9850E-06   1300.0


t_composition(:,5)=   ! UPuO-He smeared mixture in active fuel zone ring 4; density= 7.289 g/cc 
U234_7   U234E   1.2754E-07   1300.0
U235_7   U235E   3.1753E-05   1300.0
U238_7   U238E   1.2509E-02   1300.0
PU2387   PU238E  8.9755E-06   1300.0
PU2397   PU239E  2.4609E-03   1300.0
PU2407   PU240E  9.5162E-04   1300.0
PU2417   PU241E  6.2414E-05   1300.0
PU2427   PU242E  8.9004E-05   1300.0
AM2417   AM241E  1.5049E-04   1300.0
O16__7   O16E    3.2041E-02   1300.0
HE4__7   HE4E    6.9850E-06   1300.0

t_composition(:,6)=   ! UPuO-He smeared mixture in active fuel zone ring 5; density= 7.289 g/cc
U234_7   U234F   1.2754E-07   1300.0
U235_7   U235F   3.1753E-05   1300.0
U238_7   U238F   1.2509E-02   1300.0
PU2387   PU238F  8.9755E-06   1300.0
PU2397   PU239F  2.4609E-03   1300.0
PU2407   PU240F  9.5162E-04   1300.0
PU2417   PU241F  6.2414E-05   1300.0
PU2427   PU242F  8.9004E-05   1300.0
AM2417   AM241F  1.5049E-04   1300.0
O16__7   O16F    3.2041E-02   1300.0
HE4__7   HE4F    6.9850E-06   1300.0


t_composition(:,7)=   ! UPuO-He smeared mixture in active fuel zone ring 6; density= 7.289 g/cc
U234_7   U234G   1.2754E-07   1300.0
U235_7   U235G   3.1753E-05   1300.0
U238_7   U238G   1.2509E-02   1300.0
PU2387   PU238G  8.9755E-06   1300.0
PU2397   PU239G  2.4609E-03   1300.0
PU2407   PU240G  9.5162E-04   1300.0
PU2417   PU241G  6.2414E-05   1300.0
PU2427   PU242G  8.9004E-05   1300.0
AM2417   AM241G  1.5049E-04   1300.0
O16__7   O16G    3.2041E-02   1300.0
HE4__7   HE4G    6.9850E-06   1300.0


t_composition(:,8)=   ! UPuO-He smeared mixture in active fuel zone ring 7; density= 7.289 g/cc
U234_7   U234H   1.2754E-07   1300.0
U235_7   U235H   3.1753E-05   1300.0
U238_7   U238H   1.2509E-02   1300.0
PU2387   PU238H  8.9755E-06   1300.0
PU2397   PU239H  2.4609E-03   1300.0
PU2407   PU240H  9.5162E-04   1300.0
PU2417   PU241H  6.2414E-05   1300.0
PU2427   PU242H  8.9004E-05   1300.0
AM2417   AM241H  1.5049E-04   1300.0
O16__7   O16H    3.2041E-02   1300.0
HE4__7   HE4H    6.9850E-06   1300.0


t_composition(:,9)=   ! DS4 Clad in active fuel zone; density= 7.734 g/cc
FE54_7   FE54I   3.1861E-03   843.0
FE56_7   FE56I   5.0014E-02   843.0
FE57_7   FE57I   1.1550E-03   843.0
FE58_7   FE58I   1.5372E-04   843.0
NI58_7   NI58I   8.3738E-03   843.0
NI60_7   NI60I   3.2256E-03   843.0
NI61_7   NI61I   1.4023E-04   843.0
NI62_7   NI62I   4.4700E-04   843.0
NI64_7   NI64I   1.1390E-04   843.0
CR50_7   CR50I   5.6437E-04   843.0
CR52_7   CR52I   1.0883E-02   843.0
CR53_7   CR53I   1.2341E-03   843.0
CR54_7   CR54I   3.0719E-04   843.0
MN55_7   MN55I   1.2717E-03   843.0
MO92_7   MO92I   1.0806E-04   843.0
MO94_7   MO94I   6.7355E-05   843.0
MO95_7   MO95I   1.1592E-04   843.0
MO96_7   MO96I   1.2146E-04   843.0
MO97_7   MO97I   6.9539E-05   843.0
MO98_7   MO98I   1.7571E-04   843.0
MO1007   MO100I  7.0122E-05   843.0
SI28_7   SI28I   1.3002E-03   843.0
SI29_7   SI29I   6.6019E-05   843.0
SI30_7   SI30I   4.3520E-05   843.0
C____7   CI      3.4901E-04   843.0
P31__7   P31I    6.7670E-05   843.0
S32__7   S32I    2.0688E-05   843.0
S33__7   S33I    1.6562E-07   843.0
S34__7   S34I    9.3490E-07   843.0
S36__7   S36I    4.3585E-09   843.0
TI46_7   TI46I   3.2111E-05   843.0
TI47_7   TI47I   2.8959E-05   843.0
TI48_7   TI48I   2.8694E-04   843.0
TI49_7   TI49I   2.1057E-05   843.0
TI50_7   TI50I   2.0162E-05   843.0
V____7   VI      2.7430E-05   843.0
ZR90_7   ZR90I   7.8809E-06   843.0
ZR91_7   ZR91I   1.7186E-06   843.0
ZR92_7   ZR92I   2.6270E-06   843.0
ZR94_7   ZR94I   2.6622E-06   843.0
ZR96_7   ZR96I   4.2889E-07   843.0
W182_7   W182I   2.0142E-06   843.0
W183_7   W183I   1.0877E-06   843.0
W184_7   W184I   2.3380E-06   843.0
W186_7   W186I   2.1609E-06   843.0
CU63_7   CU63I   1.5210E-05   843.0
CU65_7   CU65I   6.7793E-06   843.0
CO59_7   CO59I   2.3711E-05   843.0
CA40_7   CA40I   3.3799E-05   843.0
CA42_7   CA42I   2.2558E-07   843.0
CA43_7   CA43I   4.7068E-08   843.0
CA44_7   CA44I   7.2729E-07   843.0
CA46_7   CA46I   1.3946E-09   843.0
CA48_7   CA48I   6.5198E-08   843.0
NB93_7   NB93I   7.5201E-06   843.0
N14__7   N14I    4.9696E-05   843.0
N15__7   N15I    1.8356E-07   843.0
AL27_7   AL27I   2.5894E-05   843.0
TA1817   TA181I  3.8612E-06   843.0
B10__7   B10I    5.1447E-06   843.0
B11__7   B11I    2.0708E-05   843.0

t_composition(:,10)=  ! DS4 Duct (Wrapper) in active fuel zone; density= 7.750 g/cc  
FE54_7   FE54J   3.1925E-03   808.0
FE56_7   FE56J   5.0115E-02   808.0
FE57_7   FE57J   1.1574E-03   808.0
FE58_7   FE58J   1.5403E-04   808.0
NI58_7   NI58J   8.3908E-03   808.0
NI60_7   NI60J   3.2321E-03   808.0
NI61_7   NI61J   1.4051E-04   808.0
NI62_7   NI62J   4.4790E-04   808.0
NI64_7   NI64J   1.1413E-04   808.0
CR50_7   CR50J   5.6552E-04   808.0
CR52_7   CR52J   1.0905E-02   808.0
CR53_7   CR53J   1.2366E-03   808.0
CR54_7   CR54J   3.0781E-04   808.0
MN55_7   MN55J   1.2743E-03   808.0
MO92_7   MO92J   1.0828E-04   808.0
MO94_7   MO94J   6.7491E-05   808.0
MO95_7   MO95J   1.1616E-04   808.0
MO96_7   MO96J   1.2170E-04   808.0
MO97_7   MO97J   6.9680E-05   808.0
MO98_7   MO98J   1.7606E-04   808.0
MO1007   MO100J  7.0264E-05   808.0
SI28_7   SI28J   1.3028E-03   808.0
SI29_7   SI29J   6.6152E-05   808.0
SI30_7   SI30J   4.3608E-05   808.0
C____7   CJ      3.4972E-04   808.0
P31__7   P31J    6.7807E-05   808.0
S32__7   S32J    2.0730E-05   808.0
S33__7   S33J    1.6596E-07   808.0
S34__7   S34J    9.3679E-07   808.0
S36__7   S36J    4.3673E-09   808.0
TI46_7   TI46J   3.2176E-05   808.0
TI47_7   TI47J   2.9017E-05   808.0
TI48_7   TI48J   2.8752E-04   808.0
TI49_7   TI49J   2.1100E-05   808.0
TI50_7   TI50J   2.0203E-05   808.0
V____7   VJ      2.7486E-05   808.0
ZR90_7   ZR90J   7.8969E-06   808.0
ZR91_7   ZR91J   1.7221E-06   808.0
ZR92_7   ZR92J   2.6323E-06   808.0
ZR94_7   ZR94J   2.6676E-06   808.0
ZR96_7   ZR96J   4.2976E-07   808.0
W182_7   W182J   2.0183E-06   808.0
W183_7   W183J   1.0899E-06   808.0
W184_7   W184J   2.3427E-06   808.0
W186_7   W186J   2.1653E-06   808.0
CU63_7   CU63J   1.5241E-05   808.0
CU65_7   CU65J   6.7930E-06   808.0
CO59_7   CO59J   2.3759E-05   808.0
CA40_7   CA40J   3.3867E-05   808.0
CA42_7   CA42J   2.2604E-07   808.0
CA43_7   CA43J   4.7164E-08   808.0
CA44_7   CA44J   7.2877E-07   808.0
CA46_7   CA46J   1.3974E-09   808.0
CA48_7   CA48J   6.5330E-08   808.0
NB93_7   NB93J   7.5354E-06   808.0
N14__7   N14J    4.9797E-05   808.0
N15__7   N15J    1.8393E-07   808.0
AL27_7   AL27J   2.5947E-05   808.0
TA1817   TA181J  3.8690E-06   808.0
B10__7   B10J    5.1551E-06   808.0
B11__7   B11J    2.0750E-05   808.0


t_composition(:,11)=  ! Pb Coolant in interassembly gap; density= 10.402 g/cc
PB2047   PB204K  4.2322E-04   808.0
PB2067   PB206K  7.2854E-03   808.0
PB2077   PB207K  6.6808E-03   808.0
PB2087   PB208K  1.5840E-02   808.0

/
EOF

# $lib/mcc3.x
~/codes/mcc3/src/mcc3.x

mv ISOTXS.merged   $0.ISOTXS
