// Core geometric details
h_cl 			= 1.6;
h_peripheral 	= 2.65;
r_wall 			= 1.264;
theta_wall 		= Pi/1.75; //the arch angle of the outer wall
dh_inlet 		= 0.235; // this is not the channel width, but the width of the vertical cross section.
r_core 			= 1.054;
x_outlet 		= 1.785; 

// Model setup parameters
h_bl			= 0.025;				// Boundary layer thickness
ratio_bl		= 1.5;
n_bl			= 9;
n_inlet			= 9;
n_elbow 		= 9;
n_extru 		= 13;
n_curve1		= 21;
n_curve2		= 21;
n_core			= 11;
n_width			= 16;

// Points on the core centerline
Point(newp) = {0, 0, 			0, 1.0};
Point(newp) = {0, h_cl/2-h_bl, 	0, 1.0};
Point(newp) = {0, h_cl/2, 		0, 1.0};
//+

// The wall curve
pref=newp; Printf("pref =%g", pref);
Point(newp) = {r_core+r_wall, 0, 0, 1.0};
Point(newp) = {r_core, 0, 0, 1.0}; 
Point(newp) = {r_core+r_wall-r_wall*Cos(theta_wall/4), r_wall*Sin(theta_wall/4), 0, 1.0};
x = r_core+r_wall-r_wall*Cos(theta_wall/2); y = r_wall*Sin(theta_wall/2);
Point(newp) = {x, y, 0, 1.0};

r_tmp = Sqrt((r_core+r_wall-x)^2.0+(y+1.5*h_bl)^2);
pref1=newp; Printf("pref1 =%g", pref1);
Point(newp) = {r_core+r_wall-r_tmp, 0, 0, 1.0};
Point(newp) = {r_core+r_wall-r_tmp*Cos(theta_wall/4), r_tmp*Sin(theta_wall/4), 0, 1.0};
Point(newp) = {x, y + 1.5*h_bl, 0, 1.0};

x = r_core+r_wall-r_wall*Cos(theta_wall/2);
y = h_peripheral/2 - ((x_outlet - x) * (h_peripheral-h_cl)/2/x_outlet);
Point(newp) = {x, y, 0, 1.0}; Point(newp) = {x, y-h_bl, 0, 1.0};
x = x/3;
y = h_peripheral/2 - ((x_outlet - x) * (h_peripheral-h_cl)/2/x_outlet);
Point(newp) = {x, y, 0, 1.0}; Point(newp) = {x, y-h_bl, 0, 1.0};
Point(newp) = {x, 0, 0, 1.0}; 

Point(newp) = {x_outlet, h_peripheral/2-dh_inlet, 		0, 1.0};
Point(newp) = {x_outlet, h_peripheral/2-dh_inlet+h_bl, 	0, 1.0};
Point(newp) = {x_outlet, h_peripheral/2-h_bl, 			0, 1.0};
Point(newp) = {x_outlet, h_peripheral/2, 				0, 1.0};

Point(newp) = {x_outlet, h_peripheral/2-dh_inlet-0.15, 0, 1.0};

height1 = h_peripheral/2-dh_inlet-0.15;
Point(newp) = {x_outlet+0.15, 					height1, 0, 1.0};
Point(newp) = {x_outlet+0.15+h_bl, 				height1, 0, 1.0};
Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height1, 0, 1.0};
Point(newp) = {x_outlet+0.15+dh_inlet, 			height1, 0, 1.0};

height2 = height1-0.6;
Point(newp) = {x_outlet+0.15, 					height2, 0, 1.0};
Point(newp) = {x_outlet+0.15+h_bl, 				height2, 0, 1.0};
Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height2, 0, 1.0};
Point(newp) = {x_outlet+0.15+dh_inlet, 			height2, 0, 1.0};

pref2=newp; Printf("pref2 =%g", pref2);
Rotate {{0,0,1}, {0,0,0}, Pi/2} { Point{1:pref2-1}; }

Symmetry { 1.0,0.0,0.0,0.0 }{Duplicata{Point{1:pref2-1};}}



// // Connecting lines

Line(1) = {3, 2};
//+
Line(2) = {30, 31};
//+
Line(3) = {13, 14};
//+
Line(4) = {41, 42};
//+
Line(5) = {11, 12};
//+
Line(6) = {39, 40};
//+
Line(7) = {19, 18};
//+
Line(8) = {47, 46};
//+
Line(9) = {24, 23};
//+
Line(10) = {28, 27};
//+
Line(11) = {25, 26};
//+
Line(12) = {21, 22};
//+
Line(13) = {16, 17};
//+
Line(14) = {7, 10};
//+
Line(15) = {6, 9};
//+
Line(16) = {5, 8};
//+
Line(17) = {34, 37};
//+
Line(18) = {35, 38};
//+
Line(19) = {44, 45};
//+
Line(20) = {49, 50};
//+
Line(21) = {53, 54};
//+
Line(22) = {56, 55};
//+
Line(23) = {52, 51};
Transfinite Curve {1,-2,3:23}= n_bl Using Progression ratio_bl;//+
Line(24) = {11, 19};
//+
Line(25) = {12, 18};
//+
Line(26) = {10, 17};
//+
Line(27) = {7, 16};
//+
Line(28) = {35, 44};
//+
Line(29) = {38, 45};
//+
Line(30) = {40, 46};
//+
Line(31) = {39, 47};
Transfinite Curve {24:31}= n_inlet Using Progression 1.0;//+//+//+
Circle(32) = {19, 20, 24};
//+
Circle(33) = {18, 20, 23};
//+
Circle(34) = {17, 20, 22};
//+
Circle(35) = {16, 20, 21};
//+
Circle(36) = {47, 48, 52};
//+
Circle(37) = {46, 48, 51};
//+
Circle(38) = {45, 48, 50};
//+
Circle(39) = {44, 48, 49};
Transfinite Curve {31:39}= n_elbow Using Progression 1.0;//+//+//+//+
Line(40) = {21, 25};
//+
Line(41) = {22, 26};
//+
Line(42) = {23, 27};
//+
Line(43) = {24, 28};
//+
Line(44) = {49, 53};
//+
Line(45) = {50, 54};
//+
Line(46) = {51, 55};
//+
Line(47) = {52, 56};
Transfinite Curve {40:47}= n_extru Using Progression 1.0;//+
Circle(48) = {7, 4, 6};
//+
Circle(49) = {10, 4, 9};
//+
Line(50) = {12, 14};
//+
Line(51) = {11, 13};
//+
Circle(52) = {35, 4, 34};
//+
Circle(53) = {38, 4, 37};
//+
Line(54) = {40, 42};
//+
Line(55) = {39, 41};
Transfinite Curve {48:55}= n_curve1 Using Progression 1.0;//+//+//+//+//+
Circle(56) = {6, 4, 5};
//+
Circle(57) = {9, 4, 8};
//+
Line(58) = {14, 15};
//+
Line(59) = {2, 1};
//+
Circle(60) = {34, 4, 5};
//+
Circle(61) = {37, 4, 8};
//+
Line(62) = {42, 15};
//+
Line(63) = {1, 30};
Transfinite Curve {56:63}= n_curve2 Using Progression 1.0;//+//+//+//+//+//+
Line(64) = {13, 3};
//+
Line(65) = {14, 2};
//+
Line(66) = {15, 1};
//+
Line(67) = {42, 30};
//+
Line(68) = {41, 31};
Transfinite Curve {64:68}= n_core Using Progression 1.0;//+//+

//+
Line(69) = {27, 26};
//+
Line(70) = {23, 22};
//+
Line(71) = {18, 17};
//+
Line(72) = {12, 10};
//+
Line(73) = {14, 9};
//+
Line(74) = {15, 8};
//+
Line(75) = {42, 37};
//+
Line(76) = {40, 38};
//+
Line(77) = {46, 45};
//+
Line(78) = {51, 50};
//+
Line(79) = {55, 54};
Transfinite Curve {69:79}= n_width Using Progression 1.0;//+//+

Physical Curve("inlet", 1) = {10,11,69};
// +
Physical Curve("outlet", 2) = {21,22,79};
// +
Physical Curve("symmetry", 4) = {1,59,63,2};

Physical Curve("Wall", 3) = {43, 32, 24, 51, 64, 68, 55, 31, 36, 47, 44, 39, 28, 52, 60, 56, 48, 27, 35, 40};


//+
Curve Loop(1) = {10, -42, -9, 43};
//+
Surface(1) = {1};
//+
Curve Loop(2) = {69, -41, -70, 42};
//+
Surface(2) = {2};
//+
Curve Loop(3) = {11, -41, -12, 40};
//+
Surface(3) = {3};
//+
Curve Loop(4) = {9, -33, -7, 32};
//+
Surface(4) = {4};
//+
Curve Loop(5) = {70, -34, -71, 33};
//+
Surface(5) = {5};
//+
Curve Loop(6) = {12, -34, -13, 35};
//+
Surface(6) = {6};
//+
Curve Loop(7) = {7, -25, -5, 24};
//+
Surface(7) = {7};
//+
Curve Loop(8) = {71, -26, -72, 25};
//+
Surface(8) = {8};
//+
Curve Loop(9) = {13, -26, -14, 27};
//+
Surface(9) = {9};
//+
Curve Loop(10) = {5, 50, -3, -51};
//+
Surface(10) = {10};
//+
Curve Loop(11) = {72, 49, -73, -50};
//+
Surface(11) = {11};
//+
Curve Loop(12) = {14, 49, -15, -48};
//+
Surface(12) = {12};
//+
Curve Loop(13) = {73, 57, -74, -58};
//+
Surface(13) = {13};
//+
Curve Loop(14) = {15, 57, -16, -56};
//+
Surface(14) = {14};
//+
Curve Loop(15) = {1, -65, -3, 64};
//+
Surface(15) = {15};
//+
Curve Loop(16) = {59, -66, -58, 65};
//+
Surface(16) = {16};
//+
Curve Loop(17) = {63, -67, 62, 66};
//+
Surface(17) = {17};
//+
Curve Loop(18) = {2, -68, 4, 67};
//+
Surface(18) = {18};
//+
Curve Loop(19) = {74, -61, -75, 62};
//+
Surface(19) = {19};
//+
Curve Loop(20) = {16, -61, -17, 60};
//+
Surface(20) = {20};
//+
Curve Loop(21) = {17, -53, -18, 52};
//+
Surface(21) = {21};
//+
Curve Loop(22) = {75, -53, -76, 54};
//+
Surface(22) = {22};
//+
Curve Loop(23) = {4, -54, -6, 55};
//+
Surface(23) = {23};
//+
Curve Loop(24) = {18, 29, -19, -28};
//+
Surface(24) = {24};
//+
Curve Loop(25) = {76, 29, -77, -30};
//+
Surface(25) = {25};
//+
Curve Loop(26) = {6, 30, -8, -31};
//+
Surface(26) = {26};
//+
Curve Loop(27) = {19, 38, -20, -39};
//+
Surface(27) = {27};
//+
Curve Loop(28) = {77, 38, -78, -37};
//+
Surface(28) = {28};
//+
Curve Loop(29) = {8, 37, -23, -36};
//+
Surface(29) = {29};
//+
Curve Loop(30) = {20, 45, -21, -44};
//+
Surface(30) = {30};
//+
Curve Loop(31) = {78, 45, -79, -46};
//+
Surface(31) = {31};
//+
Curve Loop(32) = {23, 46, -22, -47};
//+
Surface(32) = {32};
// +
Physical Surface("fluid", 5) = {1:32};
Transfinite Surface "*";
Recombine Surface "*";//+
//+
