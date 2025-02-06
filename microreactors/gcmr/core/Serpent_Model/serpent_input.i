%------------------------------------------------------------------------------------------
% ANL GCMR
% If using or referring to this model, please cite as explained in
% https://mooseframework.inl.gov/virtual_test_bed/citing.html
%Contacts: Ahmed Abdelhameed (aabdelhameed.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)
% -----------------------------------------------------------------------------------------
set title "ANL GC MicroReactor"

surf inf inf
pbed 700 33 "PART_U900_PF40_R85.inp"
pbed 701 33 "PART_U901_PF40_R85.inp"
pbed 702 33 "PART_U902_PF40_R85.inp"
pbed 754 33 "PART_U954_PF25_R25.inp"
pbed 764 33 "PART_U964_PF25_R25.inp"

% infinite cells defining material universes
cell 51 802 moderator  -inf
cell 52 33  matrix_pin -inf
cell 53 803    matrix  -inf
cell 54 804    coolant -inf
cell 55 805      Refl  -inf
cell 56 806  shell_mod -inf
cell 57 807    coolant -inf
cell 58 809  boron_ctr -inf
cell 59 810         Cr -inf
cell 155 811      Refl -inf

% Fuel region

particle 900
     fuel0     2.1250e-02
     buffer    3.1250e-02
     PyC1      3.5250e-02
     SiC       3.8750e-02
     PyC2      4.2750e-02
matrix_pin
particle 901
     fuel1     2.1250e-02
     buffer    3.1250e-02
     PyC1      3.5250e-02
     SiC       3.8750e-02
     PyC2      4.2750e-02
matrix_pin
particle 902
     fuel2     2.1250e-02
     buffer    3.1250e-02
     PyC1      3.5250e-02
     SiC       3.8750e-02
     PyC2      4.2750e-02
matrix_pin

cell i110  3 fill 700       -1  95l   -95lu1 % fuel compact
cell i111  3 fill 700       -1  95lu1 -95lu2 % fuel compact
cell i112  3 fill 700       -1  95lu2 -95lu3 % fuel compact
cell i113  3 fill 700       -1  95lu3 -95lu4 % fuel compact
cell i114  3 fill 700       -1  95lu4 -95u   % fuel compact
cell i12   3 fill 803        1  95l   -95u
cell i13   3 fill 805                  95u
cell i14   3 fill 805                 -95l

cell m110  5 fill 701       -1  95l   -95lu1 % fuel compact
cell m111  5 fill 701       -1  95lu1 -95lu2 % fuel compact
cell m112  5 fill 701       -1  95lu2 -95lu3 % fuel compact
cell m113  5 fill 701       -1  95lu3 -95lu4 % fuel compact
cell m114  5 fill 701       -1  95lu4 -95u   % fuel compact
cell m12   5 fill 803        1  95l   -95u
cell m13   5 fill 805                  95u
cell m14   5 fill 805                 -95l

cell o110  8 fill 702       -1  95l   -95lu1 % fuel compact
cell o111  8 fill 702       -1  95lu1 -95lu2 % fuel compact
cell o112  8 fill 702       -1  95lu2 -95lu3 % fuel compact
cell o113  8 fill 702       -1  95lu3 -95lu4 % fuel compact
cell o114  8 fill 702       -1  95lu4 -95u % fuel compact
cell o12   8 fill 803        1  95l   -95u
cell o13   8 fill 805                  95u
cell o14   8 fill 805                 -95l


% Coolant channel:

cell 20 6 fill 807       -7
cell 21 6 fill 803        7   95l -95u
cell 22 6 fill 805        7   95u
cell 23 6 fill 805        7       -95l

% Central control pin

cell 29 7 fill 805   -9        -95l
cell 30 7 fill 804   -9    95l -97l
cell 31 7 fill 809   -9    97l
cell 32 7 fill 805    9    95u
cell 33 7 fill 805    9        -95l
cell 34 7 fill 803    9    95l -95u


cell m29 27 fill 805   -9        -95l
cell m30 27 fill 804   -9    95l -97lh
cell m31 27 fill 809   -9    97lh
cell m32 27 fill 805    9    95u
cell m33 27 fill 805    9        -95l
cell m34 27 fill 803    9    95l -95u


particle 952
     Gd_bpI1   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 954
     Gd_bpI2   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 955
     Gd_bpI3   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 961
     Gd_bpO1   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 963
     Gd_bpO2   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 964
     Gd_bpO3   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

particle 965
     Gd_bpO3   0.0100 % kernel at 100 microns
     buffer 0.0118 % graphite at 18 microns
     PyC1   0.0141 % different graphite at 23 microns
matrix_pin

cell i150  2 fill 754       -2  95l   -95lu1 % burnable compact
cell i151  2 fill 754       -2  95lu1 -95lu2 % burnable compact
cell i152  2 fill 754       -2  95lu2 -95lu3 % burnable compact
cell i153  2 fill 754       -2  95lu3 -95lu4 % burnable compact
cell i154  2 fill 754       -2  95lu4 -95u   % burnable compact
cell i16   2 fill 803        2  95l   -95u
cell i17   2 fill 805           95u
cell i18   2 fill 805                 -95l

cell o150  9 fill 764       -2  95l   -95lu1 % burnable compact
cell o151  9 fill 764       -2  95lu1 -95lu2 % burnable compact
cell o152  9 fill 764       -2  95lu2 -95lu3 % burnable compact
cell o153  9 fill 764       -2  95lu3 -95lu4 % burnable compact
cell o154  9 fill 764       -2  95lu4 -95u   % burnable compact
cell o16   9 fill 803        2  95l   -95u
cell o17   9 fill 805            95u
cell o18   9 fill 805                 -95l

% plain graphite region
cell 36  1 fill 803            95l -95u
cell 37  1 fill 805            95u
cell 38  1 fill 805                -95l

% Moderator region:

cell 40  4 fill 802      -3   95l -95u % 0.95 cm pin
cell 41a 4 fill 810    3 -4   95l -95u % 0.05 cm coating
cell 41b 4 fill 806    4 -5   95l -95u % 0.05 cm shell
cell 42  4 fill 803    5      95l -95u
cell 43  4 fill 806      -5   96l -95l % 0.05 cm shell
cell 44  4 fill 806      -5   95u -96u % 0.05 cm shell
cell 45  4 fill 805       5   96l -95l % 0.05 cm shell
cell 46  4 fill 805       5   95u -96u % 0.05 cm shell
cell 47  4 fill 805           96u
cell 48  4 fill 805               -96l

% --- cylinders
surf  1 cyl 0.0 0.0 0.850  0.000000 240
surf  2 cyl 0.0 0.0 0.250  0.000000 240
surf  3 cyl 0.0 0.0 0.693  0.000000 240
surf  4 cyl 0.0 0.0 0.700  0.000000 240
surf  5 cyl 0.0 0.0 0.750  0.000000 240
surf  7 cyl 0.0 0.0 0.600  0.000000 240
surf  9 cyl 0.0 0.0 0.950  0.000000 240

% --- axial dimensions
surf 95l pz  20
surf 95lu1 pz  60.0
surf 95lu2 pz  100.0
surf 95lu3 pz  140.0
surf 95lu4 pz  180.0
surf 95u pz  220
surf 96l pz  19.95
surf 96u pz  220.05
surf 97l pz  220
surf 97lh pz  220

% --- hexprism assembly
surf 30 hexxprism 0.0 0.0 10.4000 0 240

% --- Assembly lattice

lat 26 3  0.0 0.0 13 13   2.000000                 % regular fuel assembly with rods - central
    1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 3 6 3 3 6 3 1
    1 1 1 1 1 6 4 3 6 3 4 6 1
    1 1 1 1 3 3 6 3 3 6 3 3 1
    1 1 1 3 6 3 2 6 2 3 6 3 1
    1 1 6 3 3 6 3 3 6 3 3 6 1
    1 3 4 6 2 3 6 3 2 6 4 3 1
    1 6 3 3 6 3 3 6 3 3 6 1 1
    1 3 6 3 2 6 2 3 6 3 1 1 1
    1 3 3 6 3 3 6 3 3 1 1 1 1
    1 6 4 3 6 3 4 6 1 1 1 1 1
    1 3 6 3 3 6 3 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1

cell 67 19 fill 26  -30
cell 167 19 fill 803  30

lat 13 3  0.0 0.0 13 13   2.000000                 % regular fuel assembly - inner
    1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 2 6 3 3 6 2 1
    1 1 1 1 1 6 4 3 6 3 4 6 1
    1 1 1 1 3 3 6 3 3 6 3 3 1
    1 1 1 3 6 3 2 6 2 3 6 3 1
    1 1 6 3 3 6 3 3 6 3 3 6 1
    1 2 4 6 2 3 6 3 2 6 4 2 1
    1 6 3 3 6 3 3 6 3 3 6 1 1
    1 3 6 3 2 6 2 3 6 3 1 1 1
    1 3 3 6 3 3 6 3 3 1 1 1 1
    1 6 4 3 6 3 4 6 1 1 1 1 1
    1 2 6 3 3 6 2 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1

cell 60 14 fill 13  -30
cell 160 14 fill 803  30

lat 10 3  0.0 0.0 13 13   2.000000                 % regular fuel assembly with rods - middle
    1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 5 6 5 5 6 5 1
    1 1 1 1 1 6 4 5 6 5 4 6 1
    1 1 1 1 5 5 6 5 5 6 5 5 1
    1 1 1 5 6 5 2 6 2 5 6 5 1
    1 1 6 5 5 6 5 5 6 5 5 6 1
    1 5 4 6 2 5 7 5 2 6 4 5 1
    1 6 5 5 6 5 5 6 5 5 6 1 1
    1 5 6 5 2 6 2 5 6 5 1 1 1
    1 5 5 6 5 5 6 5 5 1 1 1 1
    1 6 4 5 6 5 4 6 1 1 1 1 1
    1 5 6 5 5 6 5 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1

cell 61 15 fill 10  -30
cell 161 15 fill 803  30

lat 12 3  0.0 0.0 13 13   2.000000                 % regular fuel assembly with rods - middle core - 2nd type of CR
    1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 5 6 5 5 6 5 1
    1 1 1 1 1 6 4 5 6 5 4 6 1
    1 1 1 1 5 5 6 5 5 6 5 5 1
    1 1 1 5 6 5 2 6 2 5 6 5 1
    1 1 6 5 5 6 5 5 6 5 5 6 1
    1 5 4 6 2 5 27 5 2 6 4 5 1
    1 6 5 5 6 5 5 6 5 5 6 1 1
    1 5 6 5 2 6 2 5 6 5 1 1 1
    1 5 5 6 5 5 6 5 5 1 1 1 1
    1 6 4 5 6 5 4 6 1 1 1 1 1
    1 5 6 5 5 6 5 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1

cell 66 25 fill 12  -30
cell 166 25 fill 803  30

lat 11 3  0.0 0.0 13 13   2.000000                 % regular fuel assembly without rod and burnable poisons - outer core
    1 1 1 1 1 1 1 1 1 1 1 1 1
    1 1 1 1 1 1 8 6 8 8 6 8 1
    1 1 1 1 1 6 4 8 6 8 4 6 1
    1 1 1 1 8 8 6 8 8 6 8 8 1
    1 1 1 8 6 8 2 6 2 8 6 8 1
    1 1 6 8 8 6 8 8 6 8 8 6 1
    1 8 4 6 2 8 6 8 2 6 4 8 1
    1 6 8 8 6 8 8 6 8 8 6 1 1
    1 8 6 8 2 6 2 8 6 8 1 1 1
    1 8 8 6 8 8 6 8 8 1 1 1 1
    1 6 4 8 6 8 4 6 1 1 1 1 1
    1 8 6 8 8 6 8 1 1 1 1 1 1
    1 1 1 1 1 1 1 1 1 1 1 1 1

cell 62 16 fill 11  -30
cell 162 16 fill 803  30

% control drum region (currently plain)
cell 164 17 fill 807 -30
cell 165 17 fill 811  30


% reflector region
cell 63 18 fill 811  -30
cell 163 18 fill 811  30



lat 50  2  0.0 0.0 17 17 20.8
18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18
18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18
18 18 18 18 18 18 18 18 18 18 18 17 18 18 18 18 18
18 18 18 18 18 18 18 18 17 16 16 16 16 17 18 18 18
18 18 18 18 18 18 18 16 16 15 15 15 16 16 18 18 18
18 18 18 18 18 17 16 15 25 25 25 25 15 16 17 18 18
18 18 18 18 18 16 15 25 14 14 14 25 15 16 18 18 18
18 18 18 18 16 15 25 14 14 14 14 25 15 16 18 18 18
18 18 18 17 16 25 14 14 14 14 14 25 16 17 18 18 18
18 18 18 16 15 25 14 14 14 14 25 15 16 18 18 18 18
18 18 18 16 15 25 14 14 14 25 15 16 18 18 18 18 18
18 18 17 16 15 25 25 25 25 15 16 17 18 18 18 18 18
18 18 18 16 16 15 15 15 16 16 18 18 18 18 18 18 18
18 18 18 17 16 16 16 16 17 18 18 18 18 18 18 18 18
18 18 18 18 18 17 18 18 18 18 18 18 18 18 18 18 18
18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18
18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18 18


surf  11 cyl 0.0 0.0 121   0.0 240

cell 170 0 fill 50 -11

% -----------DRUMS DEFINITTION---------------------------------------------------------------------------------------

 731 732 733 734 735 736 737 738 739 740 741 742
cell 180 0 fill       731 -731
cell 181 0 fill       732 -732
cell 182 0 fill       733 -733
cell 183 0 fill       734 -734
cell 184 0 fill       735 -735
cell 185 0 fill       736 -736
cell 186 0 fill       737 -737
cell 187 0 fill       738 -738
cell 188 0 fill       739 -739
cell 189 0 fill       740 -740
cell 190 0 fill       741 -741
cell 191 0 fill       742 -742


surf 731 cyl 104.0000   0.00 10.0000   0.00 240.00
surf 831 cyl 104.0000   0.00 9.0000   0.00 240.00
surf 771 plane 1.0000   0.00 0.0 110.36
surf 871 plane 1.0000  -0.00 0.0  97.64
cell 801  731 fill 811   -731   -771
cell 802  731 fill 809    831  -731  771
cell 803  731 fill 811   -831   771
surf 732 cyl 52.0000  90.07 10.0000   0.00 240.00
surf 832 cyl 52.0000  90.07 9.0000   0.00 240.00
surf 772 plane 1.0000   1.73 0.0 220.73
surf 872 plane 1.0000   1.73 0.0 195.27
cell 806  732 fill 811   -732   -772
cell 807  732 fill 809    832  -732  772
cell 808  732 fill 811   -832   772
surf 733 cyl -52.0000  90.07 10.0000   0.00 240.00
surf 833 cyl -52.0000  90.07 9.0000   0.00 240.00
surf 773 plane 1.0000  -1.73 0.0 -220.73
surf 873 plane 1.0000  -1.73 0.0 -195.27
cell 811  733 fill 811   -733   773
cell 812  733 fill 809    833  -733  -773
cell 813  733 fill 811   -833   -773
surf 734 cyl -104.0000   0.00 10.0000   0.00 240.00
surf 834 cyl -104.0000   0.00 9.0000   0.00 240.00
surf 774 plane 1.0000  -0.00 0.0 -110.36
surf 874 plane 1.0000   0.00 0.0 -97.64
cell 816  734 fill 811   -734   774
cell 817  734 fill 809    834  -734  -774
cell 818  734 fill 811   -834   -774
surf 735 cyl -52.0000 -90.07 10.0000   0.00 240.00
surf 835 cyl -52.0000 -90.07 9.0000   0.00 240.00
surf 775 plane 1.0000   1.73 0.0 -220.73
surf 875 plane 1.0000   1.73 0.0 -195.27
cell 821  735 fill 811   -735   775
cell 822  735 fill 809    835  -735  -775
cell 823  735 fill 811   -835   -775
surf 736 cyl 52.0000 -90.07 10.0000   0.00 240.00
surf 836 cyl 52.0000 -90.07 9.0000   0.00 240.00
surf 776 plane 1.0000  -1.73 0.0 220.73
surf 876 plane 1.0000  -1.73 0.0 195.27
cell 826  736 fill 811   -736   -776
cell 827  736 fill 809    836  -736  776
cell 828  736 fill 811   -836   776
surf 737 cyl 93.6000  54.04 10.0000   0.00 240.00
surf 837 cyl 93.6000  54.04 9.0000   0.00 240.00
surf 777 plane 1.0000   0.58 0.0 132.15
surf 877 plane 1.0000   0.58 0.0 117.45
cell 831  737 fill 811   -737   -777
cell 832  737 fill 809    837  -737  777
cell 833  737 fill 811   -837   777
surf 738 cyl 0.0000 108.08 10.0000   0.00 240.00
surf 838 cyl 0.0000 108.08 9.0000   0.00 240.00
surf 778 plane 0.0000   1.00 0.0 114.44
surf 878 plane 1.0000 895647891448936.75 0.0 91101729311334400.00
cell 836  738 fill 811   -738   -778
cell 837  738 fill 809    838  -738  778
cell 838  738 fill 811   -838   778
surf 739 cyl -93.6000  54.04 10.0000   0.00 240.00
surf 839 cyl -93.6000  54.04 9.0000   0.00 240.00
surf 779 plane 1.0000  -0.58 0.0 -132.15
surf 879 plane 1.0000  -0.58 0.0 -117.45
cell 841  739 fill 811   -739   779
cell 842  739 fill 809    839  -739  -779
cell 843  739 fill 811   -839   -779
surf 740 cyl -93.6000 -54.04 10.0000   0.00 240.00
surf 840 cyl -93.6000 -54.04 9.0000   0.00 240.00
surf 780 plane 1.0000   0.58 0.0 -132.15
surf 880 plane 1.0000   0.58 0.0 -117.45
cell 846  740 fill 811   -740   780
cell 847  740 fill 809    840  -740  -780
cell 848  740 fill 811   -840   -780
surf 741 cyl -0.0000 -108.08 10.0000   0.00 240.00
surf 841 cyl -0.0000 -108.08 9.0000   0.00 240.00
surf 781 plane 1.0000 895647891448936.75 0.0 -102501465868115968.00
surf 881 plane 1.0000 895647891448936.38 0.0 -91101729311334368.00
cell 851  741 fill 811   -741   781
cell 852  741 fill 809    841  -741  -781
cell 853  741 fill 811   -841   -781
surf 742 cyl 93.6000 -54.04 10.0000   0.00 240.00
surf 842 cyl 93.6000 -54.04 9.0000   0.00 240.00
surf 782 plane 1.0000  -0.58 0.0 132.15
surf 882 plane 1.0000  -0.58 0.0 117.45
cell 856  742 fill 811   -742   -782
cell 857  742 fill 809    842  -742  782
cell 858  742 fill 811   -842   782

cell 171 0 outside  11

set ures 1

% -----------------------------------------------------------------------------------
% Material data:

% materials

mat fuel0   -10.7440 burn 1  tmp 725.0   rgb 200 0 0
  92235.01c    6.8794e-02
  92238.01c    2.7604e-01
 6012.01c    1.3793e-01
  8016.01c    5.1724e-01

mat fuel1   -10.7440 burn 1  tmp 725.0   rgb 230 0 0
  92235.01c    6.8794e-02
  92238.01c    2.7604e-01
 6012.01c    1.3793e-01
  8016.01c    5.1724e-01

mat fuel2   -10.7440 burn 1  tmp 725.0   rgb 255 0 0
  92235.01c    6.8794e-02
  92238.01c    2.7604e-01
 6012.01c    1.3793e-01
  8016.01c    5.1724e-01

mat Gd_bpI1 -7.0395  burn 1  tmp 725.0  rgb 0 0 200
 64152.01c   2.43139E-05
 64154.01c   2.61576E-04
 64155.01c   1.76435E-03
 64156.01c   2.42465E-03
 64157.01c   1.84189E-03
 64158.01c   2.90497E-03
 64160.01c   2.52445E-03
 8016.01c   3.52386E-02

mat Gd_bpI2 -7.0395 burn 1  tmp 725.0  rgb 0 0 250
 64152.01c   2.43139E-05
 64154.01c   2.61576E-04
 64155.01c   1.76435E-03
 64156.01c   2.42465E-03
 64157.01c   1.84189E-03
 64158.01c   2.90497E-03
 64160.01c   2.52445E-03
 8016.01c   3.52386E-02



mat Gd_bpI3 -7.0395 burn 1  tmp 725.0  rgb 0 0 200
64152.01c   2.43139E-05
64154.01c   2.61576E-04
64155.01c   1.76435E-03
64156.01c   2.42465E-03
64157.01c   1.84189E-03
64158.01c   2.90497E-03
64160.01c   2.52445E-03
8016.01c   3.52386E-02

mat Gd_bpO1 -7.0395 burn 1  tmp 725.0  rgb 0 0 250
64152.01c   2.43139E-05
64154.01c   2.61576E-04
64155.01c   1.76435E-03
64156.01c   2.42465E-03
64157.01c   1.84189E-03
64158.01c   2.90497E-03
64160.01c   2.52445E-03
8016.01c   3.52386E-02

mat Gd_bpO2 -7.0395 burn 1  tmp 725.0  rgb 0 0 200
64152.01c   2.43139E-05
64154.01c   2.61576E-04
64155.01c   1.76435E-03
64156.01c   2.42465E-03
64157.01c   1.84189E-03
64158.01c   2.90497E-03
64160.01c   2.52445E-03
8016.01c   3.52386E-02

mat Gd_bpO3 -7.0395 burn 1  tmp 725.0  rgb 0 0 250
64152.01c   2.43139E-05
64154.01c   2.61576E-04
64155.01c   1.76435E-03
64156.01c   2.42465E-03
64157.01c   1.84189E-03
64158.01c   2.90497E-03
64160.01c   2.52445E-03
8016.01c   3.52386E-02

mat boron_ctr -2.4700 tmp 725.0  rgb 0 0 250 % highly enriched B4C
 5010.01c 0.768
 5011.01c 0.032
 6012.01c 0.20

mat coolant    -3.6500e-03  tmp 725.0 rgb 0 0 100
 2004.01c  1.0

mat shell_mod  -7.0550  tmp 725.0   rgb 33 233 133  % density at 900K - FeCrAl
24050.01c  8.6800E-03
24052.01c  1.6762E-01
24053.01c  1.8980E-02
24054.01c  4.7200E-03
26054.01c  4.3790E-02
26056.01c  6.9249E-01
26057.01c  1.6610E-02
26058.01c  2.1140E-03
13027.01c  4.5000E-02

% --- Carbon buffer layer:

mat buffer  -1.0400 moder grph 6012 tmp 725.0  rgb 0 200 200
 6012.01c    1.0

% --- Pyrolytic carbon layer:

mat PyC1     -1.8820 moder grph 6012 tmp 725.0   rgb 0 200 200
 6012.01c    1.0

% --- Pyrolytic carbon layer:

mat PyC2     -1.8820 moder grph 6012 tmp 725.0 rgb 0 200 200
 6012.01c    1.0

% --- Silicon carbide layer:

mat SiC     -3.1710  tmp 725.0 rgb 0 100 0
14028.01c    0.4611
14029.01c    0.0234
14030.01c    0.0154
 6012.01c     0.5

mat Nb   -8.4132  tmp 725.0   rgb 100 0 100   % Nobium
41093.01c  -0.99
40090.01c  -5.132E-03
40091.01c  -1.107E-03
40092.01c  -1.674E-03
40094.01c  -1.660E-03
40096.01c  -2.618E-04

mat Cr   -7.1900  tmp 725.0   rgb 100 0 200   % Chromium
24050.01c  -4.345e-2
24052.01c  -83.789e-2
24053.01c  -9.501e-2
24054.01c  -2.365e-2

% --- Graphite matrix:

mat matrix_pin       -1.8060 moder grph 6012  tmp 725.0  rgb 220 220 220
 6012.01c    1

mat matrix       -1.8060 moder grph 6012  tmp 725.0 rgb 200 200 200
 6012.01c  0.9999997
 5010.01c  0.0000003

mat moderator   -4.0850 moder h-yh2 1001 moder y-yh2 39089 tmp 725.0   rgb 73 64 171
39089.01c  0.357142857
1001.01c   0.642857143

mat Refl        -2.7987  moder beo 4009 tmp 725.0   rgb 100 220 200  % GREY
 4009.01c    0.5
 8016.01c    0.5

% -----------------------------------------------------------------------------

therm grph    grph.84t
therm  beo     be-beo.84t
therm h-yh2   h-yh2.84t
therm y-yh2   y-yh2.84t

% Calculation parameters:

% -----------------------------------------------------------------------------

% --- Geometry plot:
plot 3 10000 10000   120.0
plot 2 10000 10000   0.2

% --- Libraries:

set acelib "/home/ycao/XSLIB/serpent/sss_endfb8_serpent_yan.xsdir"
set declib "/home/talamo/XSLIB/serpent/sss_endfb7.dec"
set nfylib "/home/talamo/XSLIB/serpent/sss_endfb7.nfy"


% --- Boundary conditions:

set bc 1

% --- Power density

set power 20000000.0  % W

% --- Histories:
set pop 10000 300 30

set xenon 1
set gcu 700 701 702 754 764 802 803 804 805 806 807 809 810 811

set nfg  11  8.00000e-08 1.80000e-07 6.25000e-07 1.30000e-06 4.00000e-06
             1.48730e-04 9.11800e-03 1.83000e-01 5.00000e-01 1.35300e+00

% -----------------------------------------------------------------------------
