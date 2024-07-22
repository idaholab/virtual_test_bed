################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Mesh Generation                                                     ##
## Input File Using MOOSE Framework/Reactor Module Mesh Generators            ##
## Original Mesh for Griffin                                                  ##
## Please contact the authors for mesh generation issues:                     ##
## - Dr. Kun Mo (kunmo@anl.gov)                                               ##
## - Dr. Soon Kyu Lee (soon.lee@anl.gov)                                      ##
################################################################################

################################################################################
# Geometry Info.
################################################################################
# Radii used in parsed curve generators to model different component geometries.
################################################################################
r1  = 0.33655
r2  = 0.559435
r3  = 0.69
r5  = 1.0033
r6  = 1.412875
r7  = 1.9939
r8  = 2.6
r9  = 3.175
r10 = 3.6
r11 = 4.1
r12 = 4.45168
r13 = 5.285907
r14 = 5.4991
r15 = 6.0325
r16 = 6.35
r17 = 7.049135
r18 = 7.140575
r19 = 7.3025
r20 = 7.874
r21 = 10.4775
r22 = 12.7
r23 = 15.22413
r24 = 19.05
r25 = 19.84375
r26 = 20.48002
r27 = 50.96002

################################################################################
# Top Plate Parameters:
################################################################################
plate_wirth_half  = 31.75
plate_length_half = 38.1

################################################################################
# Top Bar Parameters:
################################################################################
bar_length_half = 46.99

################################################################################
# Heat Pipe Parameters:
################################################################################
r_hp     = 0.635
r_hp_gap = 0.6477
hp_x     = 5.19938
r_slot   = 0.9525

################################################################################
# Component Hights
# (h is the distance of H(x)-H(x-1); for example, h2 = -27.935-(-35)):
################################################################################
# h  ---------------  Height          # Notes
# h1 =0                 #1   -35
h2 =7.065             #2   -27.935
# h3 =0                 #3   -27.935
h4 =2.3774            #4   -25.5576
h5 =0.1626            #5   -25.395
h6 =4.9174            #6   -20.4776
h7 =5.08              #7   -15.3976
h8 =1.2625            #8   -14.1351
h9 =2.0701            #9   -12.065
h10=1.27              #10  -10.795
h11=0.635             #11  -10.16
h12=4.9224            #12  -5.2376
h13=5.08012           #13  -0.15748
h14=0.15748           #14  0          # Fuel Zone Start
h15=4                 #15  4
h16=4.33374           #16  8.33374    # Bottom Fuel Zone End & Middle Fuel Zone Start
h17=1.28778           #17  9.62152
h18=0.2286            #18  9.85012
h19=0.53              #19  10.38012
h20=1.61988           #20  12
h21=2.18012           #21  14.18012
h22=0.53              #22  14.71012
h23=0.2413            #23  14.95142
h24=1.71606           #24  16.66748   # Middle Fuel Zone End & Top Fuel Zone Start
h25=3.33252           #25  20
h26=3.36671           #26  23.36671
h27=1.63451           #27  25.00122   # Top Fuel Zone End
h28=3.8354            #28  28.83662
h29=2.52468           #29  31.3613
h30=0.96266           #30  32.32396
h31=2.83726           #31  35.16122
h32=1.60774           #32  36.76896
h33=0.94234           #33  37.7113
h34=1.25992           #34  38.97122
h35=1.905             #35  40.87622
h36=1.91508           #36  42.7913
h37=1.27              #37  44.0613
h38=3.81008           #38  47.87138
h39=1.27              #39  49.14138

################################################################################
# Starting of the Mesh Input Block
################################################################################
[Mesh]
  # final_generator=Extrude
################################################################################
# 2D Component Generation Near the Heat Pipe (Region1-26)
# Due to the complex geometries of the Krusty components, various Regions are
# outlined with the ParsedCurveGenerator and meshed with the XYDelaunayGenerator.
# Each region holds multiple components when axially extruded.
#
# The following key components are comprised of these Regions:
# Fuel:            Region 1, 2, 3, 11, 12, 13
# Heat Pipe (HP):  Region 8, 9, 10
# HP and Fuel Gap: Region 5, 6, 7
# BeO Reflector:   Region 18, 19, 20, 24, 25, 26
################################################################################
  [Region1]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                 t2:=t-1;
                 x1:=r12*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=r_slot*cos(t2*(th2_end-th2_start)+th2_start)+hp_x;
                 if(t<1,x1,x2)'
    y_formula = 't1:=t;
                 t2:=t-1;
                 y1:=r12*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r_slot*sin(t2*(th2_end-th2_start)+th2_start);
                 if(t<1,y1,y2)'
    section_bounding_t_values = '0 1 2'
    constant_names =          'pi              r12            r_slot            hp_x       th1_start               th1_end            th2_start             th2_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r_slot} ${fparse hp_x}       0                    0.12272974563      2.5324547478        ${fparse pi}'
    nums_segments = '4 4'
    is_closed_loop = true
  []
  [Region1_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region1'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary=9527
    output_subdomain_name = 101
  []
  [Region2]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                 t2:=t-1;
                 t3:=t-2;
                 t4:=t-3;
                 x1:=r_hp_gap*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                 x2:=r13*cos(t2*(th2_end-th2_start)+th2_start);
                 x3:=r_slot*cos(t3*(th3_end-th3_start)+th3_start)+hp_x;
                 x4:=r12*cos(t4*(th4_end-th4_start)+th4_start);
                 if(t<1,x1,if(t<2,x2,if(t<3,x3,x4)))'
    y_formula = 't1:=t;
                 t2:=t-1;
                 t3:=t-2;
                 t4:=t-3;
                 y1:=r_hp_gap*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r13*sin(t2*(th2_end-th2_start)+th2_start);
                 y3:=r_slot*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r12*sin(t4*(th4_end-th4_start)+th4_start);
                 if(t<1,y1,if(t<2,y2,if(t<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13            r_slot          r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end           th3_start      th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r_slot} ${fparse r_hp_gap} ${fparse hp_x}    ${fparse pi}  1.4983163888   0.12251793865   0.18118584459  1.5707963268     2.5324547478  0.12272974563       0'
    nums_segments = '4 2 4 4'
    is_closed_loop = true
    # show_info = true
  []
  [Region2_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region2'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary=9527
    output_subdomain_name = 102
  []
  [Region3]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r_hp_gap*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                  x2:=r14*cos(t2*(th2_end-th2_start)+th2_start);
                  x3:=t3*(th3_end-th3_start)+th3_start;
                  x4:=r13*cos(t4*(th4_end-th4_start)+th4_start);
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r_hp_gap*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r14*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=r_slot;
                  y4:=r13*sin(t4*(th4_end-th4_start)+th4_start);
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp_gap} ${fparse hp_x}    1.4983163888  1.14417605    0.1074325051   0.1740881695      5.41598048         5.19938     0.18118584    0.12251793'
    nums_segments = '2 2 2 2'
    is_closed_loop = true
  []
  [Region3_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region3'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.01
    output_boundary=9527
    output_subdomain_name = 103
  []
  [Region4]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  t4:=t-3;
                  x1:=r15*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=t2*(th2_end-th2_start)+th2_start;
                  x3:=r14*cos(t3*(th3_end-th3_start)+th3_start);
                  x4:=r_hp_gap*cos(t4*(th4_end-th4_start)+th4_start)+hp_x;
                  if(t<1,x1,if(t<2,x2,if(t<3,x3,x4)))'
    y_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  t4:=t-3;
                  y1:=r15*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_slot;
                  y3:=r14*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=r_hp_gap*sin(t4*(th4_end-th4_start)+th4_start);
                  if(t<1,y1,if(t<2,y2,if(t<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp_gap} ${fparse hp_x}           0      0.15855828      5.9568280      5.41598048    0.1740881695   0.1074325051   1.14417605         0 '
    nums_segments = '3 2 2 4'
    is_closed_loop = true
  []
  [Region4_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region4'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 104
  []
  [Region21]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r16*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=t2*(th2_end-th2_start)+th2_start;
                  x3:=r15*cos(t3*(th3_end-th3_start)+th3_start);
                  x4:=t4*(th4_end-th4_start)+th4_start;
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r16*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_slot;
                  y3:=r15*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=0;
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r16)} ${fparse sqrt(r16^2-r_slot^2)} ${fparse sqrt(r15^2-r_slot^2)} ${fparse asin(r_slot/r15)}         0       ${fparse r15}   ${fparse r16}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region21_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region21'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 121
  []
  [Region22]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r17*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=t2*(th2_end-th2_start)+th2_start;
                  x3:=r16*cos(t3*(th3_end-th3_start)+th3_start);
                  x4:=t4*(th4_end-th4_start)+th4_start;
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r17*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_slot;
                  y3:=r16*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=0;
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r17)} ${fparse sqrt(r17^2-r_slot^2)} ${fparse sqrt(r16^2-r_slot^2)} ${fparse asin(r_slot/r16)}         0       ${fparse r16}   ${fparse r17}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region22_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region22'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 122
  []
  [Region23]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r18*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_end-th2_start)+th2_start;
                 x3:=r17*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r18*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r_slot;
                 y3:=r17*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=0;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r18)} ${fparse sqrt(r18^2-r_slot^2)} ${fparse sqrt(r17^2-r_slot^2)} ${fparse asin(r_slot/r17)}         0       ${fparse r17}   ${fparse r18}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region23_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region23'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 123
  []
  [Region24]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r19*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=t2*(th2_end-th2_start)+th2_start;
                  x3:=r18*cos(t3*(th3_end-th3_start)+th3_start);
                  x4:=t4*(th4_end-th4_start)+th4_start;
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r19*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_slot;
                  y3:=r18*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=0;
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r19)} ${fparse sqrt(r19^2-r_slot^2)} ${fparse sqrt(r18^2-r_slot^2)} ${fparse asin(r_slot/r18)}         0       ${fparse r18}   ${fparse r19}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region24_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region24'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 124
  []
  [Region25]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r20*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=t2*(th2_end-th2_start)+th2_start;
                  x3:=r19*cos(t3*(th3_end-th3_start)+th3_start);
                  x4:=t4*(th4_end-th4_start)+th4_start;
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r20*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_slot;
                  y3:=r19*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=0;
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r20)} ${fparse sqrt(r20^2-r_slot^2)} ${fparse sqrt(r19^2-r_slot^2)} ${fparse asin(r_slot/r19)}         0       ${fparse r19}   ${fparse r20}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region25_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region25'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 125
  []
  [Region26]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r21*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_end-th2_start)+th2_start;
                 x3:=r20*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r21*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r_slot;
                 y3:=r20*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=0;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x             th1_start               th1_end              th2_start                        th2_end                    th3_start                  th3_end        th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}           0       ${fparse asin(r_slot/r21)} ${fparse sqrt(r21^2-r_slot^2)} ${fparse sqrt(r20^2-r_slot^2)} ${fparse asin(r_slot/r20)}         0       ${fparse r20}   ${fparse r21}'
    nums_segments = '3 6 3 6'
    is_closed_loop = true
  []
  [Region26_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region26'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.2
    output_boundary = 9527
    output_subdomain_name = 126
  []
  [Stitch_Region1_to_4_and_21_to_26]
    type = StitchedMeshGenerator
    inputs = 'Region1_mesh Region2_mesh Region3_mesh Region4_mesh Region21_mesh Region22_mesh Region23_mesh Region24_mesh Region25_mesh  Region26_mesh'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527'
  []
  [Region5]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  x1:=r_hp*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                  x2:=r13*cos(t2*(th2_end-th2_start)+th2_start);
                  x3:=r_hp_gap*cos(t3*(th3_end-th3_start)+th3_start)+hp_x;
                  if(t<1,x1,if(t<2,x2,x3))'
    y_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  y1:=r_hp*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r13*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=r_hp_gap*sin(t3*(th3_end-th3_start)+th3_start);
                  if(t<1,y1,if(t<2,y2,y3))'
    section_bounding_t_values = '0 1 2 3'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}    ${fparse pi} 1.494390157     0.120068556   0.12251793865  1.4983163888  ${fparse pi}'
    nums_segments = '4 1 4'
    is_closed_loop = true
  []
  [Region5_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region5'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 105
  []
   [Region6]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  x1:=r_hp*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                  x2:=r14*cos(t2*(th2_end-th2_start)+th2_start);
                  x3:=r_hp_gap*cos(t3*(th3_end-th3_start)+th3_start)+hp_x;
                  x4:=r13*cos(t4*(th4_end-th4_start)+th4_start);
                  if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  t4:=tm-3;
                  y1:=r_hp*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r14*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=r_hp_gap*sin(t3*(th3_end-th3_start)+th3_start);
                  y4:=r13*sin(t4*(th4_end-th4_start)+th4_start);
                  if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end   th4_start      th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}    1.494390157  1.1323433     0.1047421651   0.1074325051    1.14417605  1.4983163888  0.12251793865  0.120068556'
    nums_segments = '2 1 2 1'
    is_closed_loop = true
  []
  [Region6_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region6'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 106
  []
  [Region7]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  x1:=r_hp_gap*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                  x2:=r14*cos(t2*(th2_end-th2_start)+th2_start);
                  x3:=r_hp*cos(t3*(th3_end-th3_start)+th3_start)+hp_x;
                  if(t<1,x1,if(t<2,x2,x3))'
    y_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  y1:=r_hp_gap*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r14*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=r_hp*sin(t3*(th3_end-th3_start)+th3_start);
                  if(t<1,y1,if(t<2,y2,y3))'
    section_bounding_t_values = '0 1 2 3'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end   '
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}       0          1.14417605   0.1074325051   0.1047421651   1.1323433           0'
    nums_segments = '4 1 4'
    is_closed_loop = true
  []
  [Region7_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region7'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 107
  []
  [Stitch_Region5_6_7]
    type = StitchedMeshGenerator
    inputs = 'Region5_mesh Region6_mesh Region7_mesh'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527; 9527 9527'
  []
  [Region8]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                  x1:=r13*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=r_hp*cos(t2*(th2_end-th2_start)+th2_start)+hp_x;
                  x3:=t3*(th3_end-th3_start)+th3_start;
                  if(tm<1,x1,if(tm<2,x2,x3))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 y1:=r13*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r_hp*sin(t2*(th2_end-th2_start)+th2_start);
                 y3:=0;
                 if(tm<1,y1,if(tm<2,y2,y3))'
    section_bounding_t_values = '0 1 2 3'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end   '
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}      0           0.120068556  1.494390157     ${fparse pi}     4.56438        ${fparse r13}'
    nums_segments = '4 4 4'
    is_closed_loop = true
  []
  [Region8_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region8'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 108
  []
   [Region9]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  x1:=r14*cos(t1*(th1_end-th1_start)+th1_start);
                  x2:=r_hp*cos(t2*(th2_end-th2_start)+th2_start)+hp_x;
                  x3:=r13*cos(t3*(th3_end-th3_start)+th3_start);
                  if(t<1,x1,if(t<2,x2,x3))'
    y_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  y1:=r14*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r_hp*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=r13*sin(t3*(th3_end-th3_start)+th3_start);
                  if(t<1,y1,if(t<2,y2,y3))'
    section_bounding_t_values = '0 1 2 3'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end   '
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}       0          0.1047421651    1.1323433   1.494390157      0.120068556          0'
    nums_segments = '3 2 4'
    is_closed_loop = true
    forced_closing_num_segments = 2
  []
  [Region9_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region9'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.01
    output_boundary = 9527
    output_subdomain_name = 109
  []
  [Region10]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                 x1:=r_hp*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                 x2:=r14*cos(t2*(th2_end-th2_start)+th2_start);
                 x3:=t3*(th3_end-th3_start)+th3_start;
                 if(tm<1,x1,if(tm<2,x2,x3))'
    y_formula = 'tm:=if(t=4,0,t);
                  t1:=tm;
                  t2:=tm-1;
                  t3:=tm-2;
                 y1:=r_hp*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r14*sin(t2*(th2_end-th2_start)+th2_start);
                 y3:=0;
                 if(tm<1,y1,if(tm<2,y2,y3))'
    section_bounding_t_values = '0 1 2 3'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start     th1_end        th2_start      th2_end        th3_start      th3_end   '
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}      0           1.1323433     0.104742165        0       ${fparse r14}        5.83438'
    nums_segments = '4 3 2'
    is_closed_loop = true
  []
  [Region10_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region10'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 110
  []
  [Stitch_Region8_9_10]
    type = StitchedMeshGenerator
    inputs = 'Region8_mesh Region9_mesh Region10_mesh'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527; 9527 9527'
  []
  [Region11]
    type = ParsedCurveGenerator
    x_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  t4:=t-3;
                  x1:=r_slot*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                  x2:=r12*cos(t2*(th2_end-th2_start)+th2_start);
                  x3:=t3*(th3_x_end-th3_x_start)+th3_x_start;
                  x4:=r11*cos(t4*(th4_end-th4_start)+th4_start);
                  if(t<1,x1,if(t<2,x2,if(t<3,x3,x4)))'
    y_formula = 't1:=t;
                  t2:=t-1;
                  t3:=t-2;
                  t4:=t-3;
                  y1:=r_slot*sin(t1*(th1_end-th1_start)+th1_start);
                  y2:=r12*sin(t2*(th2_end-th2_start)+th2_start);
                  y3:=t3*(th3_y_end-th3_y_start)+th3_y_start;
                  y4:=r11*sin(t4*(th4_end-th4_start)+th4_start);
                  if(t<1,y1,if(t<2,y2,if(t<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi            r11             r12           r13           r14           r15            r_slot          r_hp_gap             hp_x       th1_start     th1_end        th2_start         th2_end               th3_x_start              th3_x_end            th3_y_start              th3_y_end                 th4_start       th4_end'
    constant_expressions = '${fparse pi} ${fparse r11} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp_gap} ${fparse hp_x}    ${fparse pi} 2.5324547478   0.12272974563    ${fparse pi/8}    ${fparse cos(pi/8)*r12}  ${fparse cos(pi/8)*r11}  ${fparse sin(pi/8)*r12}  ${fparse sin(pi/8)*r11}   ${fparse pi/8}       0'
    nums_segments = '4 3 2 4'
    is_closed_loop = true
  []
  [Region11_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region11'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    # desired_area = 0.03 can make the mesh evenly distributed; but may be expensive for compuation
    #desired_area = 0.03
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 111
  []
  [Region12]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r_slot*cos(t1*(th1_end-th1_start)+th1_start)+hp_x;
                 x2:=r13*cos(t2*(th2_end-th2_start)+th2_start);
                 x3:=t3*(th3_x_end-th3_x_start)+th3_x_start;
                 x4:=r12*cos(t4*(th4_end-th4_start)+th4_start);
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r_slot*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=r13*sin(t2*(th2_end-th2_start)+th2_start);
                 y3:=t3*(th3_y_end-th3_y_start)+th3_y_start;
                 y4:=r12*sin(t4*(th4_end-th4_start)+th4_start);
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start         th1_end        th2_start      th2_end               th3_x_start              th3_x_end                   th3_y_start              th3_y_end              th4_start      th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}     2.5324547478   1.5707963268     0.18118584459   ${fparse pi/8}      ${fparse cos(pi/8)*r13}  ${fparse cos(pi/8)*r12}  ${fparse sin(pi/8)*r13}  ${fparse sin(pi/8)*r12}  ${fparse pi/8}    0.12272974563  '
    nums_segments = '4 3 4 3'
    is_closed_loop = true
  []
  [Region12_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region12'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 112
  []
  [Region13]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r14*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r13*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r14*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r13*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r14)}  ${fparse pi/8}      ${fparse cos(pi/8)*r14} ${fparse cos(pi/8)*r13} ${fparse sin(pi/8)*r14} ${fparse sin(pi/8)*r13} ${fparse pi/8}   ${fparse asin(r_slot/r13)} ${fparse sqrt(r13^2-r_slot^2)} ${fparse sqrt(r14^2-r_slot^2)}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region13_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region13'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.03
    output_boundary = 9527
    output_subdomain_name = 113
  []
  [Region14]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r15*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r14*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r15*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r14*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15            r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r15)}  ${fparse pi/8}      ${fparse cos(pi/8)*r15} ${fparse cos(pi/8)*r14} ${fparse sin(pi/8)*r15} ${fparse sin(pi/8)*r14} ${fparse pi/8}   ${fparse asin(r_slot/r14)} ${fparse sqrt(r14^2-r_slot^2)} ${fparse sqrt(r15^2-r_slot^2)}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region14_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region14'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 114
  []
  [Region15]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r16*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r15*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r16*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r15*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16          r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r16)}  ${fparse pi/8}      ${fparse cos(pi/8)*r16} ${fparse cos(pi/8)*r15} ${fparse sin(pi/8)*r16} ${fparse sin(pi/8)*r15} ${fparse pi/8}   ${fparse asin(r_slot/r15)} ${fparse sqrt(r15^2-r_slot^2)} ${fparse sqrt(r16^2-r_slot^2)}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region15_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region15'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 115
  []
  [Region16]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r17*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r16*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r17*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r16*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r17)}  ${fparse pi/8}      ${fparse cos(pi/8)*r17} ${fparse cos(pi/8)*r16} ${fparse sin(pi/8)*r17} ${fparse sin(pi/8)*r16} ${fparse pi/8}   ${fparse asin(r_slot/r16)} ${fparse sqrt(r16^2-r_slot^2)} ${fparse sqrt(r17^2-r_slot^2)}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region16_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region16'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 116
  []
  [Region17]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r18*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r17*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r18*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r17*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r18)}  ${fparse pi/8}      ${fparse cos(pi/8)*r18} ${fparse cos(pi/8)*r17} ${fparse sin(pi/8)*r18} ${fparse sin(pi/8)*r17} ${fparse pi/8}   ${fparse asin(r_slot/r17)} ${fparse sqrt(r17^2-r_slot^2)} ${fparse sqrt(r18^2-r_slot^2)}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region17_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region17'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 117
  []
  [Region18]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r19*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r18*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r19*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r18*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r19)}  ${fparse pi/8}      ${fparse cos(pi/8)*r19} ${fparse cos(pi/8)*r18} ${fparse sin(pi/8)*r19} ${fparse sin(pi/8)*r18} ${fparse pi/8}   ${fparse asin(r_slot/r18)} ${fparse sqrt(r18^2-r_slot^2)} ${fparse sqrt(r19^2-r_slot^2)}'
    nums_segments = '3 1 3 1'
    is_closed_loop = true
  []
  [Region18_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region18'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.1
    output_boundary = 9527
    output_subdomain_name = 118
  []
  [Region19]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r20*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r19*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r20*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r19*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r20)}  ${fparse pi/8}      ${fparse cos(pi/8)*r20} ${fparse cos(pi/8)*r19} ${fparse sin(pi/8)*r20} ${fparse sin(pi/8)*r19} ${fparse pi/8}   ${fparse asin(r_slot/r19)} ${fparse sqrt(r19^2-r_slot^2)} ${fparse sqrt(r20^2-r_slot^2)}'
    nums_segments = '3 2 3 2'
    is_closed_loop = true
  []
  [Region19_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region19'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 119
  []
  [Region20]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 x1:=r21*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r20*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=t4*(th4_end-th4_start)+th4_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
    y_formula = 'tm:=if(t=4,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 y1:=r21*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r20*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r_slot;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
    section_bounding_t_values = '0 1 2 3 4'
    constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21         r_slot          r_hp           r_hp_gap             hp_x       th1_start                     th1_end              th2_x_start                  th2_x_end           th2_y_start          th2_y_end               th3_start              th3_end           th4_start                    th4_end'
    constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}  ${fparse asin(r_slot/r21)}  ${fparse pi/8}      ${fparse cos(pi/8)*r21} ${fparse cos(pi/8)*r20} ${fparse sin(pi/8)*r21} ${fparse sin(pi/8)*r20} ${fparse pi/8}   ${fparse asin(r_slot/r20)} ${fparse sqrt(r20^2-r_slot^2)} ${fparse sqrt(r21^2-r_slot^2)}'
    nums_segments = '3 6 3 6'
    is_closed_loop = true
  []
  [Region20_mesh]
    type = XYDelaunayGenerator
    boundary = 'Region20'
    # add_nodes_per_boundary_segment = 2
    refine_boundary = false
    desired_area = 0.3
    output_boundary = 9527
    output_subdomain_name = 120
  []
  [Stitch_Region11_to_20]
    type = StitchedMeshGenerator
    inputs = 'Region11_mesh Region12_mesh Region13_mesh Region14_mesh Region15_mesh Region16_mesh Region17_mesh Region18_mesh Region19_mesh Region20_mesh'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527; 9527 9527'
  []
  [Stitch_Region_1_to_26]
    type = StitchedMeshGenerator
    inputs = 'Stitch_Region8_9_10 Stitch_Region5_6_7 Stitch_Region1_to_4_and_21_to_26 Stitch_Region11_to_20'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527; 9527 9527 ; 9527 9527'
  []
  [mirror_x]
    type = TransformGenerator
    input = Stitch_Region_1_to_26
    transform = ROTATE
    vector_value = '0 180 0'
  []
  [Stitch_mirror]
    type = StitchedMeshGenerator
    inputs = 'Stitch_Region_1_to_26 mirror_x'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527'
  []
################################################################################
# 2D Circular Boundary Correction
# Due to the polygonization effect, the area within a 2D circular interface
# are actually smaller than the real circle with the same radius. Here, interface
# boundaries between circular blocks are generated in order to use the
# CircularBoundaryCorrectionGenerator to preserve a correct circular area.
################################################################################
# Generating interface boundary between blocks in order to use CCG
################################################################################
  [interface_r_hp_1]
    type = SideSetsBetweenSubdomainsGenerator
    input = Stitch_mirror
    primary_block = '108'
    paired_block = '105'
    new_boundary = 1945
  []
  [interface_r_hp_2]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_1
    primary_block = '109'
    paired_block = '106'
    new_boundary = 1945
  []
  [interface_r_hp_3]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_2
    primary_block = '110'
    paired_block = '107'
    new_boundary = 1945
  []
  [interface_r_hp_gap_1]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_3
    primary_block = '105'
    paired_block = '102'
    new_boundary = 1946
  []
  [interface_r_hp_gap_2]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_gap_1
    primary_block = '106'
    paired_block = '103'
    new_boundary = 1946
  []
  [interface_r_hp_gap_3]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_gap_2
    primary_block = '107'
    paired_block = '104'
    new_boundary = 1946
  []
  [interface_r_slot_1]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_hp_gap_3
    primary_block = '101'
    paired_block = '111'
    new_boundary = 1947
  []
  [interface_r_slot_2]
    type = SideSetsBetweenSubdomainsGenerator
    input = interface_r_slot_1
    primary_block = '102'
    paired_block = '112'
    new_boundary = 1947
  []
  [ccg_hp_gap_slot]
    type = CircularBoundaryCorrectionGenerator
    input = interface_r_slot_2
    input_mesh_circular_boundaries = '1945 1946 1947'
    custom_circular_tolerance = 1e-8
    transition_layer_ratios='0.0001 0.0001 0.001'
  []
################################################################################
# Complete the circular correction for heat pipe, heat pipe gaps and slots.
################################################################################
  [rotate_part_to_add_1]
    type = TransformGenerator
    input = ccg_hp_gap_slot
    transform = ROTATE
    vector_value = '0 0 45'
  []
  [rename_blocks_hp_pipe_zone]
    type = RenameBlockGenerator
    input = rotate_part_to_add_1
    old_block = '101 102 103 104 105 106 107 108 109 110'
    new_block = '301 302 303 304 305 306 307 308 309 310'
  []
  [Stitch_rotation_parts_1]
    type = StitchedMeshGenerator
    inputs = 'rename_blocks_hp_pipe_zone ccg_hp_gap_slot'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527'
  []
  [rotate_part_to_add_2]
    type = TransformGenerator
    input = Stitch_rotation_parts_1
    transform = ROTATE
    vector_value = '0 0 90'
  []
  [Stitch_rotation_parts_2]
    type = StitchedMeshGenerator
    inputs = 'rotate_part_to_add_2 Stitch_rotation_parts_1'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527'
  []
  [rotate_part_to_add_3]
    type = TransformGenerator
    input = Stitch_rotation_parts_2
    transform = ROTATE
    vector_value = '0 0 180'
  []
  [Stitch_rotation_parts_final]
    type = StitchedMeshGenerator
    inputs = 'rotate_part_to_add_3 Stitch_rotation_parts_2'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527'
  []
#############################################################################################
# 2D Inner and Outer Ring-Shaped Component Generation
# Inner Ring Region: Ring r1  - r11
# Outer Ring Region: Ring r22 - r26
# Center circle (r1) is generated with the PolygonConcentricCircleMeshGenerator.
# Inner peripheral ring layers (r2-r11) are added using the PeripheralTriangleMeshGenerator.
# Outer ring layers (r22-r26) are initially created for the 1/8th portion, then mirrored
# to form the 1/4th portion. These are delineated with the ParsedCurveGenerator and meshed
# using the XYDelaunayGenerator.
#
# The following key components are comprised of these Rings:
# Fuel:            Ring r8, 9, 10, 11
# BeO Reflector:   Ring r22, 23, 24
#############################################################################################
  [r1_ring_prep]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 16
    num_sectors_per_side = '4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4'
    background_intervals = 1
    ring_radii = ${fparse r1}
    ring_intervals = 1
    ring_block_ids = '201'
    # ring_block_names = 'center_tri center'
    background_block_ids = 147
    #   background_block_names = background
    polygon_size = 5.0
    preserve_volumes = on
  []
  [r1_ring]
    type = BlockDeletionGenerator
    input = r1_ring_prep
    block = '147'
    new_boundary = 1985
  []
  [r2_ring]
    type = PeripheralTriangleMeshGenerator
    input = r1_ring
    peripheral_ring_radius = ${fparse r2}
    peripheral_ring_num_segments = 64
    desired_area = 0.005
    peripheral_ring_block_name = 202
    external_boundary_name = 1002
  []
  [r3_ring]
    type = PeripheralTriangleMeshGenerator
    input = r2_ring
    peripheral_ring_radius = ${fparse r3}
    peripheral_ring_num_segments = 64
    desired_area = 0.005
    peripheral_ring_block_name =203
    external_boundary_name = 1003
  []
  [r5_ring]
    type = PeripheralTriangleMeshGenerator
    input = r3_ring
    peripheral_ring_radius = ${fparse r5}
    peripheral_ring_num_segments = 64
    desired_area = 0.015
    peripheral_ring_block_name =205
    external_boundary_name = 1005
  []
  [r6_ring]
    type = PeripheralTriangleMeshGenerator
    input = r5_ring
    peripheral_ring_radius = ${fparse r6}
    peripheral_ring_num_segments = 64
    desired_area = 0.025
    peripheral_ring_block_name =206
    external_boundary_name = 1006
  []
  [r7_ring]
    type = PeripheralTriangleMeshGenerator
    input = r6_ring
    peripheral_ring_radius = ${fparse r7}
    peripheral_ring_num_segments = 64
    desired_area = 0.05
    peripheral_ring_block_name =207
    external_boundary_name = 1007
  []
  [r8_ring]
    type = PeripheralTriangleMeshGenerator
    input = r7_ring
    peripheral_ring_radius = ${fparse r8}
    peripheral_ring_num_segments = 64
    desired_area = 0.05
    peripheral_ring_block_name =208
    external_boundary_name = 1008
  []
  [r9_ring]
    type = PeripheralTriangleMeshGenerator
    input = r8_ring
    peripheral_ring_radius = ${fparse r9}
    peripheral_ring_num_segments = 64
    desired_area = 0.05
    peripheral_ring_block_name =209
    external_boundary_name = 1009
  []
  [r10_ring]
    type = PeripheralTriangleMeshGenerator
    input = r9_ring
    peripheral_ring_radius = ${fparse r10}
    peripheral_ring_num_segments = 64
    desired_area = 0.05
    peripheral_ring_block_name =210
    external_boundary_name = 1010
  []
  [r11_ring]
    type = PeripheralTriangleMeshGenerator
    input = r10_ring
    peripheral_ring_radius = ${fparse r11}
    peripheral_ring_num_segments = 64
    desired_area = 0.05
    peripheral_ring_block_name =211
    external_boundary_name = 9527
  []
  [Stitch_internal_rings]
    type = StitchedMeshGenerator
    inputs = 'r11_ring Stitch_rotation_parts_final'
    clear_stitched_boundary_ids = true
    prevent_boundary_ids_overlap =false
    stitch_boundaries_pairs = '9527 9527'
  []
################################################################################
# Complete the inner ring. Below is the outer ring part.
################################################################################
  [r22_ring_prep]
    type = ParsedCurveGenerator
    x_formula = 'tm:=if(t=6,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 t5:=tm-4;
                 t6:=tm-5;
                 x1:=r22*cos(t1*(th1_end-th1_start)+th1_start);
                 x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                 x3:=r21*cos(t3*(th3_end-th3_start)+th3_start);
                 x4:=r21*cos(t4*(th4_end-th4_start)+th4_start);
                 x5:=r21*cos(t5*(th5_end-th5_start)+th5_start);
                 x6:=t6*(th6_end-th6_start)+th6_start;
                 if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,if(tm<4,x4,if(tm<5,x5,x6)))))'
    y_formula = 'tm:=if(t=6,0,t);
                 t1:=tm;
                 t2:=tm-1;
                 t3:=tm-2;
                 t4:=tm-3;
                 t5:=tm-4;
                 t6:=tm-5;
                 y1:=r22*sin(t1*(th1_end-th1_start)+th1_start);
                 y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                 y3:=r21*sin(t3*(th3_end-th3_start)+th3_start);
                 y4:=r21*sin(t4*(th4_end-th4_start)+th4_start);
                 y5:=r21*sin(t5*(th5_end-th5_start)+th5_start);
                 y6:=0;
                 if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,if(tm<4,y4,if(tm<5,y5,y6)))))'
      section_bounding_t_values = '0 1 2 3 4 5 6'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22       r_slot          r_hp           r_hp_gap             hp_x           th1_start                     th1_end                      th2_x_start                  th2_x_end                      th2_y_start          th2_y_end               th3_start                th3_end                      th4_start                    th4_end                   th5_start                th5_end         th6_start                    th6_end'
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}        0                       ${fparse pi/4}          ${fparse cos(pi/4)*r22}           ${fparse cos(pi/4)*r21}    ${fparse sin(pi/4)*r22}    ${fparse sin(pi/4)*r21}      ${fparse pi/4}       ${fparse asin(6.704514/r21)} ${fparse asin(6.704514 /r21)} ${fparse asin(r_slot /r21)} ${fparse asin(r_slot /r21)}     0        ${fparse r21}               ${fparse r22}'
      nums_segments = '6 2 3 6 3 2'
      is_closed_loop = true
    []
    [r22_ring_mesh]
      type = XYDelaunayGenerator
      boundary = 'r22_ring_prep'
      # add_nodes_per_boundary_segment = 2
      #refine_boundary = true
      desired_area = 1
      output_boundary = 9527
      output_subdomain_name = 222
    []
    [r23_ring_prep]
      type = ParsedCurveGenerator
      x_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   x1:=r23*cos(t1*(th1_end-th1_start)+th1_start);
                   x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                   x3:=r22*cos(t3*(th3_end-th3_start)+th3_start);
                   x4:=t4*(th4_end-th4_start)+th4_start;
                   if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
      y_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   y1:=r23*sin(t1*(th1_end-th1_start)+th1_start);
                   y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                   y3:=r22*sin(t3*(th3_end-th3_start)+th3_start);
                   y4:=0;
                   if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
      section_bounding_t_values = '0 1 2 3 4'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x           th1_start                     th1_end                      th2_x_start                  th2_x_end                      th2_y_start          th2_y_end                       th3_start                th3_end                      th4_start                    th4_end      '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}        0                       ${fparse pi/4}          ${fparse cos(pi/4)*r23}           ${fparse cos(pi/4)*r22}    ${fparse sin(pi/4)*r23}    ${fparse sin(pi/4)*r22}      ${fparse pi/4}                   0                       ${fparse r22}               ${fparse r23}'
      nums_segments = '6 2 6 2'
      is_closed_loop = true
    []
    [r23_ring_mesh]
      type = XYDelaunayGenerator
      boundary = 'r23_ring_prep'
      # add_nodes_per_boundary_segment = 2
      #refine_boundary = true
      desired_area = 1.5
      output_boundary = 9527
      output_subdomain_name = 223
    []
    [r24_ring_prep]
      type = ParsedCurveGenerator
      x_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   x1:=r24*cos(t1*(th1_end-th1_start)+th1_start);
                   x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                   x3:=r23*cos(t3*(th3_end-th3_start)+th3_start);
                   x4:=t4*(th4_end-th4_start)+th4_start;
                   if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
      y_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   y1:=r24*sin(t1*(th1_end-th1_start)+th1_start);
                   y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                   y3:=r23*sin(t3*(th3_end-th3_start)+th3_start);
                   y4:=0;
                   if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
      section_bounding_t_values = '0 1 2 3 4'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x           th1_start                     th1_end                      th2_x_start                  th2_x_end                      th2_y_start          th2_y_end                       th3_start                th3_end                      th4_start                    th4_end      '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}        0                       ${fparse pi/4}          ${fparse cos(pi/4)*r24}           ${fparse cos(pi/4)*r23}    ${fparse sin(pi/4)*r24}    ${fparse sin(pi/4)*r23}      ${fparse pi/4}                   0                       ${fparse r23}               ${fparse r24}'
      nums_segments = '6 2 6 2'
      is_closed_loop = true
    []
    [r24_ring_mesh]
      type = XYDelaunayGenerator
      boundary = 'r24_ring_prep'
      # add_nodes_per_boundary_segment = 2
      #refine_boundary = true
      desired_area = 3
      output_boundary = 9527
      output_subdomain_name = 224
    []
    [r25_ring_prep]
      type = ParsedCurveGenerator
      x_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   x1:=r25*cos(t1*(th1_end-th1_start)+th1_start);
                   x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                   x3:=r24*cos(t3*(th3_end-th3_start)+th3_start);
                   x4:=t4*(th4_end-th4_start)+th4_start;
                   if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
      y_formula = 'tm:=if(t=4,0,t);
                   t1:=tm;
                   t2:=tm-1;
                   t3:=tm-2;
                   t4:=tm-3;
                   y1:=r25*sin(t1*(th1_end-th1_start)+th1_start);
                   y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                   y3:=r24*sin(t3*(th3_end-th3_start)+th3_start);
                   y4:=0;
                   if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
      section_bounding_t_values = '0 1 2 3 4'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x           th1_start                     th1_end                      th2_x_start                  th2_x_end                      th2_y_start          th2_y_end                       th3_start                th3_end                      th4_start                    th4_end      '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}        0                       ${fparse pi/4}          ${fparse cos(pi/4)*r25}           ${fparse cos(pi/4)*r24}    ${fparse sin(pi/4)*r25}    ${fparse sin(pi/4)*r24}      ${fparse pi/4}                   0                       ${fparse r24}               ${fparse r25}'
      nums_segments = '6 1 6 1'
      is_closed_loop = true
    []
    [r25_ring_mesh]
      type = XYDelaunayGenerator
      boundary = 'r25_ring_prep'
      # add_nodes_per_boundary_segment = 2
      #refine_boundary = true
      desired_area = 3
      output_boundary = 9527
      output_subdomain_name = 225
    []
    [r26_ring_prep]
      type = ParsedCurveGenerator
      x_formula = 'tm:=if(t=4,0,t);
                    t1:=tm;
                    t2:=tm-1;
                    t3:=tm-2;
                    t4:=tm-3;
                    x1:=r26*cos(t1*(th1_end-th1_start)+th1_start);
                    x2:=t2*(th2_x_end-th2_x_start)+th2_x_start;
                    x3:=r25*cos(t3*(th3_end-th3_start)+th3_start);
                    x4:=t4*(th4_end-th4_start)+th4_start;
                    if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,x4)))'
      y_formula = 'tm:=if(t=4,0,t);
                    t1:=tm;
                    t2:=tm-1;
                    t3:=tm-2;
                    t4:=tm-3;
                    y1:=r26*sin(t1*(th1_end-th1_start)+th1_start);
                    y2:=t2*(th2_y_end-th2_y_start)+th2_y_start;
                    y3:=r25*sin(t3*(th3_end-th3_start)+th3_start);
                    y4:=0;
                    if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,y4)))'
      section_bounding_t_values = '0 1 2 3 4'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x           th1_start                     th1_end                      th2_x_start                  th2_x_end                      th2_y_start          th2_y_end                       th3_start                th3_end                      th4_start                    th4_end      '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}        0                       ${fparse pi/4}          ${fparse cos(pi/4)*r26}           ${fparse cos(pi/4)*r25}    ${fparse sin(pi/4)*r26}    ${fparse sin(pi/4)*r25}      ${fparse pi/4}                   0                       ${fparse r25}               ${fparse r26}'
      nums_segments = '6 1 6 1'
      is_closed_loop = true
    []
    [r26_ring_mesh]
      type = XYDelaunayGenerator
      boundary = 'r26_ring_prep'
      # add_nodes_per_boundary_segment = 2
      #refine_boundary = true
      desired_area = 3
      output_boundary = 9527
      output_subdomain_name = 226
    []
    [Stitch_r22_ring]
      type = StitchedMeshGenerator
      inputs = 'r22_ring_mesh r23_ring_mesh r24_ring_mesh r25_ring_mesh r26_ring_mesh'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527; 9527 9527; 9527 9527; 9527 9527'
    []
    [rotate_r22_ring_mesh_1]
        type = TransformGenerator
        input = Stitch_r22_ring
        transform = ROTATE
        vector_value = '0 0 45'
    []
    [Stitch_r22_ring_quarter]
        type = StitchedMeshGenerator
        inputs = 'Stitch_r22_ring rotate_r22_ring_mesh_1'
        clear_stitched_boundary_ids = true
        prevent_boundary_ids_overlap =false
        stitch_boundaries_pairs = '9527 9527'
    []
####################################################################################
# 2D Most Outer Shield Component Generation (Region 27-30)
# The most outer shielding components comprised of stainless steel (SS) and B4C are
# are initially created for the 1/4th portion. These are delineated with the
# ParsedCurveGenerator and meshed using the XYDelaunayGenerator.
####################################################################################
    [Region27_prep]
      type = ParsedCurveGenerator
       x_formula = 'tm:=if(t=5,0,t);
                    t1:=tm;
                    t2:=tm-1;
                    t3:=tm-2;
                    t4:=tm-3;
                    t5:=tm-4;
                    x1:=plate_length_half;
                    x2:=t2*(th2_end-th2_start)+th2_start;
                    x3:=0;
                    x4:=r26*cos(t4*(th4_end-th4_start)+th4_start);
                    x5:=t5*(th5_end-th5_start)+th5_start;
                    if(tm<1,x1,if(tm<2,x2,if(tm<3,x3,if(tm<4,x4,x5))))'
       y_formula = 'tm:=if(t=5,0,t);
                    t1:=tm;
                    t2:=tm-1;
                    t3:=tm-2;
                    t4:=tm-3;
                    t5:=tm-4;
                    y1:=t1*(th1_end-th1_start)+th1_start;
                    y2:=plate_wirth_half;
                    y3:=t3*(th3_end-th3_start)+th3_start;
                    y4:=r26*sin(t4*(th4_end-th4_start)+th4_start);
                    y5:=0;
                    if(tm<1,y1,if(tm<2,y2,if(tm<3,y3,if(tm<4,y4,y5))))'
      section_bounding_t_values = '0 1 2 3 4 5'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x            plate_wirth_half              plate_length_half                    th1_start                     th1_end                                 th2_start                  th2_end        th3_start                       th3_end             th4_start              th4_end        th5_start      th5_end  '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}   ${fparse plate_wirth_half} ${fparse plate_length_half}       0                       ${fparse plate_wirth_half}          ${fparse plate_length_half}          0      ${fparse plate_wirth_half}    ${fparse r26}            ${fparse pi/2}             0    ${fparse r26} ${fparse plate_length_half} '
      nums_segments = '12 12 4 12 6'
      is_closed_loop = true
    []
    [Region27_mesh]
      type = XYDelaunayGenerator
      boundary = 'Region27_prep'
      # add_nodes_per_boundary_segment = 2
      refine_boundary = false
      desired_area = 5
      output_boundary = 9527
      output_subdomain_name = 127
    []
    [Region28_prep]
      type = ParsedCurveGenerator
      x_formula = 't1:=t;
                   t2:=t-1;
                   t3:=t-2;
                   t4:=t-3;
                   x1:=r27*cos(t1*(th1_end-th1_start)+th1_start);
                   x2:=t2*(th2_end-th2_start)+th2_start;
                   x3:=0;
                   x4:=t4*(th4_end-th4_start)+th4_start;
                   if(t<1,x1,if(t<2,x2,if(t<3,x3,x4)))'
      y_formula = 't1:=t;
                   t2:=t-1;
                   t3:=t-2;
                   t4:=t-3;
                   y1:=r27*sin(t1*(th1_end-th1_start)+th1_start);
                   y2:=bar_length_half;
                   y3:=t3*(th3_end-th3_start)+th3_start;
                   y4:=plate_wirth_half;
                   if(t<1,y1,if(t<2,y2,if(t<3,y3,y4)))'
      section_bounding_t_values = '0 1 2 3 4'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x            plate_wirth_half              plate_length_half        bar_length_half                           th1_start                               th1_end                                              th2_start                  th2_end        th3_start                       th3_end             th4_start         th4_end              '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}   ${fparse plate_wirth_half} ${fparse plate_length_half}   ${fparse bar_length_half}    ${fparse acos(plate_length_half/r27)}    ${fparse pi/2-acos(bar_length_half/r27)}       ${fparse r27*sin(acos(bar_length_half/r27))}    0        ${fparse bar_length_half} ${fparse plate_wirth_half}        0      ${fparse plate_length_half}  '
      nums_segments = '6 6 4 12'
      is_closed_loop = true
    []
    [Region28_mesh]
      type = XYDelaunayGenerator
      boundary = 'Region28_prep'
      # add_nodes_per_boundary_segment = 2
      refine_boundary = false
      desired_area = 5
      output_boundary = 9527
      output_subdomain_name = 128
    []
    [Region29_prep]
      type = ParsedCurveGenerator
      x_formula = 't1:=t;
                   t2:=t-1;
                   x1:=t1*(th1_end-th1_start)+th1_start;
                   x2:=r27*cos(t2*(th2_end-th2_start)+th2_start);
                   if(t<1,x1,x2)'
      y_formula = 't1:=t;
                   t2:=t-1;
                   y1:=bar_length_half;
                   y2:=r27*sin(t2*(th2_end-th2_start)+th2_start);
                   if(t<1,y1,y2)'
      section_bounding_t_values = '0 1 2'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x            plate_wirth_half              plate_length_half        bar_length_half                           th1_start                               th1_end                              th2_start                          th2_end     '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}   ${fparse plate_wirth_half} ${fparse plate_length_half}   ${fparse bar_length_half}                    0             ${fparse r27*sin(acos(bar_length_half/r27))}    ${fparse pi/2-acos(bar_length_half/r27)}       ${fparse pi/2}       '
      nums_segments = '6 6'
      is_closed_loop = true
    []
    [Region29_mesh]
      type = XYDelaunayGenerator
      boundary = 'Region29_prep'
      # add_nodes_per_boundary_segment = 2
      refine_boundary = false
      desired_area = 5
      output_boundary = 9527
      output_subdomain_name = 129
    []
    [Region30_prep]
      type = ParsedCurveGenerator
       x_formula = 't1:=t;
                   t2:=t-1;
                   t3:=t-2;
                   x1:=plate_length_half;
                   x2:=t2*(th2_end-th2_start)+th2_start;
                   x3:=r27*cos(t3*(th3_end-th3_start)+th3_start);
                   if(t<1,x1,if(t<2,x2,x3))'
      y_formula = 't1:=t;
                   t2:=t-1;
                   t3:=t-2;
                   y1:=t1*(th1_end-th1_start)+th1_start;
                   y2:=0;
                   y3:=r27*sin(t3*(th3_end-th3_start)+th3_start);
                   if(t<1,y1,if(t<2,y2,y3))'
      section_bounding_t_values = '0 1 2 3'
      constant_names =          'pi              r12           r13           r14           r15           r16             r17           r18           r19           r20           r21             r22           r23           r24           r25            r26           r27      r_slot          r_hp           r_hp_gap             hp_x            plate_wirth_half              plate_length_half        bar_length_half                           th1_start        th1_end           th2_start                  th2_end        th3_start                       th3_end               '
      constant_expressions = '${fparse pi} ${fparse r12} ${fparse r13} ${fparse r14} ${fparse r15}  ${fparse r16}  ${fparse r17} ${fparse r18} ${fparse r19} ${fparse r20}  ${fparse r21} ${fparse r22} ${fparse r23} ${fparse r24} ${fparse r25}  ${fparse r26} ${fparse r27} ${fparse r_slot} ${fparse r_hp} ${fparse r_hp_gap} ${fparse hp_x}   ${fparse plate_wirth_half} ${fparse plate_length_half}   ${fparse bar_length_half}    ${fparse plate_wirth_half}      0       ${fparse plate_length_half}    ${fparse r27}          0             ${fparse acos(plate_length_half/r27)}    '
      nums_segments = '12 4 12'
      is_closed_loop = true
    []
    [Region30_mesh]
      type = XYDelaunayGenerator
      boundary = 'Region30_prep'
      # add_nodes_per_boundary_segment = 2
      refine_boundary = false
      desired_area = 5
      output_boundary = 9527
      output_subdomain_name = 130
    []
    [Stitch_r22_ring_27_28_29]
      type = StitchedMeshGenerator
      inputs = 'Stitch_r22_ring_quarter Region27_mesh Region28_mesh Region29_mesh'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527; 9527 9527; 9527 9527'
    []
    [Stitch_r22_ring_27_to_30]
      type = StitchedMeshGenerator
      inputs = 'Stitch_r22_ring_27_28_29 Region30_mesh'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527'
    []
    [mirror_outer_zone_1]
      type = TransformGenerator
      input = Stitch_r22_ring_27_to_30
      transform = ROTATE
      vector_value = '0 180 0'
    []
    [Stitch_mirror_outer_zone_1]
      type = StitchedMeshGenerator
      inputs = 'Stitch_r22_ring_27_to_30 mirror_outer_zone_1'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527'
    []
    [mirror_outer_zone_2]
      type = TransformGenerator
      input = Stitch_mirror_outer_zone_1
      transform = ROTATE
      vector_value = '0 0 180'
    []
    [Stitch_mirror_outer_zone_2]
      type = StitchedMeshGenerator
      inputs = 'Stitch_mirror_outer_zone_1 mirror_outer_zone_2'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527'
    []
    [Stitch_inner_outer]
      type = StitchedMeshGenerator
      inputs = 'Stitch_internal_rings Stitch_mirror_outer_zone_2'
      clear_stitched_boundary_ids = true
      prevent_boundary_ids_overlap =false
      stitch_boundaries_pairs = '9527 9527'
    []
################################################################################
# Generating interface boundary between blocks in order to use CCG
################################################################################
    [interface_r_11]
      type = SideSetsBetweenSubdomainsGenerator
      input = Stitch_inner_outer
      primary_block = '211'
      paired_block = '111'
      new_boundary = 1011
    []
    [interface_r_12_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_11
      primary_block = '301'
      paired_block = '302'
      new_boundary = 1012
    []
    [interface_r_12_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_12_1
      primary_block = '101'
      paired_block = '102'
      new_boundary = 1012
    []
    [interface_r_12_3]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_12_2
      primary_block = '111'
      paired_block = '112'
      new_boundary = 1012
    []
    [interface_r_13_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_12_3
      primary_block = '102'
      paired_block = '103'
      new_boundary = 1013
    []
    [interface_r_13_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_1
      primary_block = '105'
      paired_block = '106'
      new_boundary = 1013
    []
    [interface_r_13_3]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_2
      primary_block = '108'
      paired_block = '109'
      new_boundary = 1013
    []
    [interface_r_13_4]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_3
      primary_block = '302'
      paired_block = '303'
      new_boundary = 1013
    []
    [interface_r_13_5]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_4
      primary_block = '305'
      paired_block = '306'
      new_boundary = 1013
    []
    [interface_r_13_6]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_5
      primary_block = '308'
      paired_block = '309'
      new_boundary = 1013
    []
    [interface_r_13_7]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_6
      primary_block = '112'
      paired_block = '113'
      new_boundary = 1013
    []
    [interface_r_14_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_13_7
      primary_block = '103'
      paired_block = '104'
      new_boundary = 1014
    []
    [interface_r_14_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_1
      primary_block = '106'
      paired_block = '107'
      new_boundary = 1014
    []
    [interface_r_14_3]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_2
      primary_block = '109'
      paired_block = '110'
      new_boundary = 1014
    []
    [interface_r_14_4]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_3
      primary_block = '303'
      paired_block = '304'
      new_boundary = 1014
    []
    [interface_r_14_5]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_4
      primary_block = '306'
      paired_block = '307'
      new_boundary = 1014
    []
    [interface_r_14_6]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_5
      primary_block = '309'
      paired_block = '310'
      new_boundary = 1014
    []
    [interface_r_14_7]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_6
      primary_block = '113'
      paired_block = '114'
      new_boundary = 1014
    []
    [interface_r_15_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_14_7
      primary_block = '104'
      paired_block = '121'
      new_boundary = 1015
    []
    [interface_r_15_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_15_1
      primary_block = '114'
      paired_block = '115'
      new_boundary = 1015
    []
    [interface_r_15_3]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_15_2
      primary_block = '304'
      paired_block = '121'
      new_boundary = 1015
    []
    [interface_r_16_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_15_3
      primary_block = '121'
      paired_block = '122'
      new_boundary = 1016
    []
    [interface_r_16_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_16_1
      primary_block = '115'
      paired_block = '116'
      new_boundary = 1016
    []
    [interface_r_17_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_16_2
      primary_block = '122'
      paired_block = '123'
      new_boundary = 1017
    []
    [interface_r_17_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_17_1
      primary_block = '116'
      paired_block = '117'
      new_boundary = 1017
    []
    [interface_r_18_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_17_2
      primary_block = '123'
      paired_block = '124'
      new_boundary = 1018
    []
    [interface_r_18_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_18_1
      primary_block = '117'
      paired_block = '118'
      new_boundary = 1018
    []
    [interface_r_19_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_18_2
      primary_block = '124'
      paired_block = '125'
      new_boundary = 1019
    []
    [interface_r_19_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_19_1
      primary_block = '118'
      paired_block = '119'
      new_boundary = 1019
    []
    [interface_r_20_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_19_2
      primary_block = '125'
      paired_block = '126'
      new_boundary = 1020
    []
    [interface_r_20_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_20_1
      primary_block = '119'
      paired_block = '120'
      new_boundary = 1020
    []
    [interface_r_21_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_20_2
      primary_block = '126'
      paired_block = '222'
      new_boundary = 1021
    []
    [interface_r_21_2]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_21_1
      primary_block = '120'
      paired_block = '222'
      new_boundary = 1021
    []
    [interface_r_22_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_21_2
      primary_block = '222'
      paired_block = '223'
      new_boundary = 1022
    []
    [interface_r_23_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_22_1
      primary_block = '223'
      paired_block = '224'
      new_boundary = 1023
    []
    [interface_r_24_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_23_1
      primary_block = '224'
      paired_block = '225'
      new_boundary = 1024
    []
    [interface_r_25_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_24_1
      primary_block = '225'
      paired_block = '226'
      new_boundary = 1025
    []
    [interface_r_26_1]
      type = SideSetsBetweenSubdomainsGenerator
      input = interface_r_25_1
      primary_block = '226'
      paired_block = '127'
      new_boundary = 1026
    []
    [ccg_r1_r26]
      type = CircularBoundaryCorrectionGenerator
      input = interface_r_26_1
      input_mesh_circular_boundaries = '1002 1003 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021 1022 1023 1024 1025 1026 9527'
      transition_layer_ratios='0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01 0.01'
      custom_circular_tolerance = 1e-2
    []
################################################################################
# Complete the circular correction.
# Moving the nodes to generate the real gap widths outside the HP.
################################################################################
    [Move_Nodes_gap_1]
      type = MoveNodeGenerator
      input = ccg_r1_r26
      node_id = '3082 3216 3081 3215'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_2]
      type = TransformGenerator
      input = Move_Nodes_gap_1
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_2]
      type = MoveNodeGenerator
      input = Rotate_gap_2
      node_id = '1071 1228 1070 1227'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_3]
      type = TransformGenerator
      input = Move_Nodes_gap_2
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_3]
      type = MoveNodeGenerator
      input = Rotate_gap_3
      node_id = '1378 1512 1377 1511'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_4]
      type = TransformGenerator
      input = Move_Nodes_gap_3
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_4]
      type = MoveNodeGenerator
      input = Rotate_gap_4
      node_id = '1662 1796 1661 1795'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_5]
      type = TransformGenerator
      input = Move_Nodes_gap_4
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_5]
      type = MoveNodeGenerator
      input = Rotate_gap_5
      node_id = '1946 2080 1945 2079'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_6]
      type = TransformGenerator
      input = Move_Nodes_gap_5
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_6]
      type = MoveNodeGenerator
      input = Rotate_gap_6
      node_id = '2230 2364 2229 2363'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_7]
      type = TransformGenerator
      input = Move_Nodes_gap_6
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_7]
      type = MoveNodeGenerator
      input = Rotate_gap_7
      node_id = '2514 2648 2513 2647'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_8]
      type = TransformGenerator
      input = Move_Nodes_gap_7
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Move_Nodes_gap_8]
      type = MoveNodeGenerator
      input = Rotate_gap_8
      node_id = '2798 2932 2797 2931'
      new_position = '5.4630653 0.652762  0.0
                      5.4630653 -0.652762 0.0
                      5.36098   0.652762  0.0
                      5.36098   -0.652762 0.0'
    []
    [Rotate_gap_1]
      type = TransformGenerator
      input = Move_Nodes_gap_8
      transform = ROTATE
      vector_value = '0 0 45'
    []
    [Add_mega_data_to_trim_1]
      type = AddMetaDataGenerator
      input = Rotate_gap_1
      boolean_scalar_metadata_names = 'square_center_trimmability square_peripheral_trimmability'
      boolean_scalar_metadata_values = ' true true'
    []
    [Trim_1]
      type = CartesianMeshTrimmer
      input = Add_mega_data_to_trim_1
      center_trim_ending_index = 4
      center_trim_starting_index = 0
      center_trimming_section_boundary = 1982
    []
    [Add_mega_data_to_trim_2]
      type = AddMetaDataGenerator
      input = Trim_1
      boolean_scalar_metadata_names = 'square_center_trimmability square_peripheral_trimmability'
      boolean_scalar_metadata_values = ' true true'
    []
    [Trim_2]
      type = CartesianMeshTrimmer
      input = Add_mega_data_to_trim_2
      center_trim_ending_index = 4
      center_trim_starting_index = 2
      center_trimming_section_boundary = 1983
    []
################################################################################
# Extruding 2D mesh in z-direction with the AdvancedExtruderGenerator
# Generating and naming sidesets
################################################################################
  [Extrude]
    type = AdvancedExtruderGenerator
    input = Trim_2
    heights = '${h2} ${h4} ${h5} ${h6} ${h7} ${h8} ${h9} ${h10} ${h11} ${h12} ${h13} ${h14} ${h15} ${h16} ${h17} ${h18} ${h19} ${h20} ${h21} ${h22} ${h23} ${h24} ${h25} ${h26} ${h27} ${h28} ${h29} ${h30} ${h31} ${h32} ${h33} ${h34} ${h35} ${h36} ${h37} ${h38} ${h39} '
    num_layers = '2     1    1     2     2     2     1     1    1        2    2    1     4       4     2       1      2      2    2       1     1      2     4      4     2     2       2     1       1       2     1     1       1     1       1       1      1 '
    direction = '0 0 1'
    subdomain_swaps ='101 1     102 1     103 1     104 1   105 1   106 1  107 1 108 1   109 1   110 1   111 1     112 1     113 1     114 1   115 1   116 1   117 1   118 1   119 1   120 1   121 1   122 1   123 1   124 1   125 1   126 1   127 1   128 1   129 1 130 1 201 1     202 1   203 1   205 1  206 1   207 1   208 1     209 1     210 1     211 1     222 1     223 1     224 1     225 1   226 1   301  1    302 1     303 1     304 1   305 1   306 1   307 1   308 1   309 1   310 1 ;
                      101 3     102 3     103 3     104 3   105 3   106 3  107 3 108 3   109 3   110 3   111 3     112 3     113 3     114 3   115 3   116 3   117 3   118 3   119 3   120 3   121 3   122 3   123 3   124 3   125 3   126 3   127 2   128 2   129 2 130 2 201 3     202 3   203 3   205 3  206 3   207 3   208 3     209 3     210 3     211 3     222 3     223 3     224 3     225 3   226 1   301  3    302 3     303 3     304 3   305 3   306 3   307 3   308 3   309 3   310 3 ;
                      101 3     102 3     103 3     104 3   105 3   106 3  107 3 108 3   109 3   110 3   111 3     112 3     113 3     114 3   115 3   116 3   117 3   118 3   119 3   120 3   121 3   122 3   123 3   124 3   125 3   126 3   127 2   128 2   129 2 130 2 201 3     202 3   203 3   205 3  206 3   207 3   208 3     209 3     210 3     211 3     222 3     223 3     224 3     225 3   226 1   301  3    302 3     303 3     304 3   305 3   306 3   307 3   308 3   309 3   310 3 ;
                      101 3     102 3     103 3     104 3   105 3   106 3  107 3 108 3   109 3   110 3   111 3     112 3     113 3     114 3   115 3   116 3   117 3   118 3   119 3   120 3   121 3   122 3   123 3   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 3     202 3   203 3   205 3  206 3   207 3   208 3     209 3     210 3     211 3     222 3     223 3     224 3     225 3   226 1   301  3    302 3     303 3     304 3   305 3   306 3   307 3   308 3   309 3   310 3 ;
                      101 5     102 5     103 5     104 5   105 5   106 5  107 5 108 5   109 5   110 5   111 5     112 5     113 5     114 5   115 5   116 5   117 5   118 5   119 5   120 5   121 5   122 5   123 5   124 5   125 5   126 5   127 4   128 4   129 4 130 4 201 5     202 5   203 5   205 5  206 5   207 5   208 5     209 5     210 5     211 5     222 5     223 5     224 5     225 5   226 1   301  5    302 5     303 5     304 5   305 5   306 5   307 5   308 5   309 5   310 5 ;
                      101 1     102 1     103 1     104 1   105 1   106 1  107 1 108 1   109 1   110 1   111 1     112 1     113 1     114 1   115 1   116 1   117 6   118 3   119 3   120 3   121 1   122 1   123 6   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 1     202 1   203 1   205 1  206 1   207 1   208 1     209 1     210 1     211 1     222 3     223 3     224 3     225 3   226 1   301  1    302 1     303 1     304 1   305 1   306 1   307 1   308 1   309 1   310 1 ;
                      101 71    102 71    103 71    104 71  105 71 106 71 107 71 108 71 109 71 110 71 111 71   112 71   113 71   114 71 115 71 116 1   117 6   118 3   119 3   120 3   121 71 122 1   123 6   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 71    202 71 203 71 205 71  206 71 207 71 208 71   209 71   210 71   211 71    222 3     223 3     224 3     225 3   226 1   301  71   302 71    303 71    304 71  305 71  306 71  307 71  308 71 309 71 310 71;
                      101 72    102 72   103 72   104 72  105 72 106 72 107 72 108 10 109 10 110 10 111 72   112 72   113 72   114 72 115 72 116 1   117 6   118 3   119 3   120 3   121 72 122 1   123 6   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 8     202 8   203 8   205 8  206 8   207 8   208 8     209 8     210 72   211 72    222 3     223 3     224 3     225 3   226 1   301  72   302 72    303 72    304 72  305 72  306 72  307 72  308 10 309 10 310 10;
                      101 73    102 73   103 73   104 73  105 73 106 73 107 73 108 10 109 10 110 10 111 73   112 73   113 73   114 73 115 73 116 1   117 6   118 3   119 3   120 3   121 73 122 1   123 6   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 8     202 8   203 8   205 8  206 8   207 8   208 8     209 8     210 73   211 73    222 3     223 3     224 3     225 3   226 1   301  73   302 73    303 73    304 73  305 73  306 73  307 73  308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 9     112 9     113 9     114 9   115 9   116 1   117 6   118 3   119 3   120 3   121 1   122 1   123 6   124 3   125 3   126 3   127 4   128 4   129 4 130 4 201 11    202 9   203 9   205 9  206 9   207 9   208 9     209 9     210 9     211 9     222 3     223 3     224 3     225 3   226 1   301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 9     112 9     113 9     114 9   115 9   116 1   117 6   118 12 119 12 120 12 121 1   122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 11    202 9   203 9   205 9  206 9   207 9   208 9     209 9     210 9     211 9     222 1212  223 1212  224 1212  225 1   226 1   301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 9     112 9     113 9     114 9   115 9   116 1   117 6   118 12 119 12 120 12 121 1   122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 11    202 1   203 1   205 1  206 1   207 1   208 1     209 1     210 9     211 9     222 1212  223 1212  224 1212  225 1   226 1   301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 2121  102 2131 103 2141 104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 2121 112 2131  113 2141 114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 11    202 1   203 1   205 1  206 1   207 1   208 2081  209 2091  210 2101  211 2111  222 1212  223 1212  224 1212  225 1   226 1   301  2121 302 2131  303 2141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 2122  102 2132 103 2142 104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 2122 112 2132  113 2142 114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 11    202 1   203 1   205 1  206 1   207 1   208 2082 209 2092  210 2102 211 2112  222 1212  223 1212  224 1212  225 1   226 1   301  2122 302 2132  303 2142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3121  102 3131  103 3141  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3121  112 3131  113 3141  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 11    202 1   203 1   205 1  206 1   207 1   208 3081  209 3091  210 3101  211 3111  222 1212  223 1212  224 1212  225 1   226 1   301  3121 302 3131  303 3141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3121  102 3131  103 3141  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3121  112 3131  113 3141  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 16    202 16 203 16 205 16 206 16 207 1   208 3081  209 3091  210 3101  211 3111  222 1212  223 1212  224 1212  225 1   226 1   301  3121 302 3131  303 3141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3121  102 3131  103 3141  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3121  112 3131  113 3141  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 15    202 15 203 15 205 15 206 16 207 1   208 3081  209 3091  210 3101  211 3111  222 1212  223 1212  224 1212  225 1   226 1   301  3121 302 3131  303 3141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3121  102 3131  103 3141  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3121  112 3131  113 3141  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 14    202 14  203 14  205 15 206 16 207 1   208 3081  209 3091  210 3101  211 3111  222 1212  223 1212  224 1212  225 1   226 1   301  3121 302 3131  303 3141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3122  102 3132  103 3142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3122  112 3132  113 3142  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 14    202 14  203 14 205 15 206 16 207 1   208 3082  209 3092  210 3102  211 3112  222 1212  223 1212  224 1212  225 1   226 1   301  3122 302 3132  303 3142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3122  102 3132  103 3142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3122  112 3132  113 3142  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 15    202 15 203 15 205 15 206 16 207 1   208 3082  209 3092  210 3102  211 3112  222 1212  223 1212  224 1212  225 1   226 1   301  3122 302 3132  303 3142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3122  102 3132  103 3142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3122  112 3132  113 3142  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 16    202 16 203 16 205 16 206 16 207 1   208 3082  209 3092  210 3102  211 3112  222 1212  223 1212  224 1212  225 1   226 1   301  3122 302 3132  303 3142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 3122  102 3132  103 3142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 3122  112 3132  113 3142  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 1     202 1   203 1   205 1   206 1   207 1   208 3082  209 3092  210 3102  211 3112  222 1212  223 1212  224 1212  225 1   226 1   301  3122 302 3132  303 3142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 4121  102 4131  103 4141  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 4121  112 4131  113 4141  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 1     202 1   203 1   205 1   206 1   207 1   208 4081  209 4091  210 4101  211 4111  222 1212  223 1212  224 1212  225 1   226 1   301  4121 302 4131  303 4141  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 4122  102 4132  103 4142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 4122  112 4132  113 4142  114 1   115 13 116 1   117 6   118 12 119 12 120 12 121 13 122 1   123 6   124 12 125 12 126 12 127 4   128 4   129 4 130 4 201 1     202 1   203 1   205 1   206 1   207 1   208 4082  209 4092  210 4102  211 4112  222 1212  223 1212  224 1212  225 1   226 1   301  4122 302 4132  303 4142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 4122  102 4132  103 4142  104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 4122  112 4132  113 4142  114 1   115 13 116 1   117 6   118 1   119 1   120 1   121 13 122 1   123 6   124 1   125 1   126 1   127 4   128 4   129 4 130 4 201 1     202 1   203 1   205 1   206 1   207 1   208 4082  209 4092  210 4102  211 4112  222 1     223 1     224 1     225 1   226 1   301  4122 302 4132  303 4142  304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 17   112 17   113 17   114 17 115 17 116 1   117 1   118 1   119 1   120 1   121 1   122 1   123 1   124 1   125 1   126 1   127 4   128 4   129 4 130 4 201 1     202 1   203 17 205 17 206 17 207 17 208 17   209 17   210 17   211 17    222 1     223 1     224 1     225 1   226 1   301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 17   112 17   113 17   114 17 115 17 116 1   117 1   118 1   119 1   120 1   121 1   122 1   123 1   124 1   125 1   126 1   127 4   128 4   129 4 130 4 201 17    202 17 203 17 205 17 206 17 207 17 208 17   209 17   210 17   211 17    222 1     223 1     224 1     225 1   226 1   301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 17   112 17   113 17   114 17 115 17 116 1   117 18 118 18 119 18 120 18 121 1   122 1   123 18 124 18 125 18 126 18 127 4   128 4   129 4 130 4 201 17    202 17 203 17 205 17 206 17 207 17 208 17   209 17   210 17   211 17    222 18    223 18    224 19    225 19  226 19  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 17   112 17   113 17   114 17 115 17 116 1   117 18 118 18 119 18 120 18 121 1   122 1   123 18 124 18 125 18 126 18 127 4   128 4   129 4 130 4 201 17    202 17 203 17 205 17 206 17 207 17 208 17   209 17   210 17   211 17    222 19    223 19    224 19    225 19  226 19  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 20   112 20   113 20   114 20 115 20 116 1   117 18 118 18 119 18 120 18 121 1   122 1   123 18 124 18 125 18 126 18 127 4   128 4   129 4 130 4 201 20    202 20 203 20 205 20 206 20 207 20 208 20   209 20   210 20   211 20    222 19    223 19    224 19    225 19  226 19  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 20   112 20   113 20   114 20 115 20 116 1   117 1   118 1   119 1   120 21 121 1   122 1   123 1   124 1   125 1   126 21 127 4   128 4   129 4 130 4 201 20    202 20 203 20 205 20 206 20 207 20 208 20   209 20   210 20   211 20    222 19    223 19    224 19    225 19  226 19  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 20   112 20   113 20   114 20 115 20 116 1   117 1   118 1   119 1   120 21 121 1   122 1   123 1   124 1   125 1   126 21 127 22 128 21 129 1 130 1 201 20    202 20 203 20 205 20 206 20 207 20 208 20   209 20   210 20   211 20    222 22    223 22    224 22    225 22  226 22  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 21   112 21   113 21   114 21 115 21 116 1   117 1   118 1   119 1   120 21 121 1   122 1   123 1   124 1   125 1   126 21 127 21 128 21 129 1 130 1 201 21    202 21 203 21 205 21 206 21 207 21 208 21   209 21   210 21   211 21    222 21    223 21    224 21    225 21  226 21  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 21   112 21   113 21   114 21 115 21 116 1   117 1   118 1   119 1   120 1   121 1   122 1   123 1   124 1   125 1   126 1   127 21 128 21 129 1 130 1 201 21    202 21 203 21 205 21 206 21 207 21 208 21   209 21   210 21   211 21    222 21    223 21    224 21    225 21  226 21  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 21   112 21   113 21   114 21 115 21 116 1   117 1   118 1   119 1   120 1   121 1   122 1   123 1   124 1   125 1   126 1   127 21 128 1   129 1 130 1 201 21    202 21 203 21 205 21 206 21 207 21 208 21   209 21   210 21   211 21    222 21    223 21    224 21    225 21  226 21  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 1     102 1     103 1     104 1   105 64  106 64 107 1 108 10 109 10 110 10 111 24   112 24   113 24   114 24 115 24 116 24 117 24 118 24 119 24 120 24 121 1   122 1   123 1   124 1   125 1   126 1   127 23 128 23 129 1 130 1 201 1     202 1   203 1   205 1   206 1   207 24 208 24   209 24   210 24   211 24    222 23    223 23    224 23    225 23  226 23  301  1    302 1     303 1     304 1   305 64  306 64  307 1   308 10 309 10 310 10;
                      101 24    102 24    103 24    104 24  105 24  106 24 107 24 108 10  109 10  110 10  111 24    112 24    113 24   114 24 115 24 116 24 117 24 118 24 119 24 120 24 121 24 122 24 123 24 124 24 125 24 126 24 127 1   128 1   129 1 130 1 201 1     202 1   203 1   205 1   206 1   207 24 208 24   209 24   210 24   211 24    222 24    223 1     224 1     225 1   226 1   301  24   302 24    303 24    304 24  305 24  306 24  307 24  308 10  309 10  310 10'
  []
  [Rename_boundaries]
    type = RenameBoundaryGenerator
    input = Extrude
    old_boundary = '     1982           1983       9529     9528         9527   '
    new_boundary = 'Mirror_X_surf Mirror_Y_surf Core_top Core_bottom Core_outer_boundary'
  []
  [Get_HP_top_Surf]
    type = SideSetsAroundSubdomainGenerator
    new_boundary = 'HP_top'
    normal = '0 0 1'
    block = '10'
    input = Rename_boundaries
  []
  [sideset_hp_top_surf]
    type = ParsedGenerateSideset
    input = Get_HP_top_Surf
    combinatorial_geometry = 'z > 83.745'
    included_subdomains = '1 24'
    normal = '0 0 1'
    new_sideset_name = Core_top_no_HP
  []
  # [sideset_fuel_side]
  #   type = SideSetsBetweenSubdomainsGenerator
  #   input = sideset_hp_top_surf
  #   primary_block = '2141 2142 3141 3142 4141 4142'
  #   paired_block = '1 1 1 1 1 1'
  #   new_boundary = fuel_side_1
  # []
  [sideset_fuel_side]
    type = ParsedGenerateSideset
    input = sideset_hp_top_surf
    combinatorial_geometry = 'x^2+y^2 > 5.49^2'
    included_subdomains = '2141 2142 3141 3142 4141 4142'
    # normal = '0 0 -1'
    new_sideset_name = fuel_side_1
  []
  [sideset_fuel_gap_side]
    type = SideSetsBetweenSubdomainsGenerator
    input = sideset_fuel_side
    primary_block = '2131 2132 3131 3132 4131 4132 2141 2142 3141 3142 4141 4142'
    paired_block = '64 64 64 64 64 64 64 64 64 64 64 64'
    new_boundary = fuel_side_2
  []
  [sideset_fuel_bottom]
    type = ParsedGenerateSideset
    input = sideset_fuel_gap_side
    combinatorial_geometry = 'z < 35.1'
    included_subdomains = '2081 2091 2101 2111 2121 2131 2141'
    normal = '0 0 -1'
    new_sideset_name = fuel_bottom
  []
  [sideset_fuel_top]
    type = ParsedGenerateSideset
    input = sideset_fuel_bottom
    combinatorial_geometry = 'z > 59.9'
    included_subdomains = '4082 4092 4102 4112 4122 4132 4142'
    normal = '0 0 1'
    new_sideset_name = fuel_top
  []
  [sideset_fuel_inside]
    type = ParsedGenerateSideset
    input = sideset_fuel_top
    combinatorial_geometry = 'x^2+y^2 < 1.994^2'
    included_subdomains = '2081 2082 3081 3082 4081 4082'
    # normal = '0 0 -1'
    new_sideset_name = fuel_inside
  []
  # [Get_Top_Surf_no_HP]
  #   type = SideSetsAroundSubdomainGenerator
  #   new_boundary = 'Top_Surf_no_HP'
  #   normal = '0 0 1'
  #   block = '24 1'
  #   input = sideset_fuel_top
  # []
################################################################################
# Scaling cm to m
################################################################################
  [scale]
    type = TransformGenerator
    input = sideset_fuel_inside
    transform = SCALE
    vector_value = '1e-2 1e-2 1e-2'
  []
[]
