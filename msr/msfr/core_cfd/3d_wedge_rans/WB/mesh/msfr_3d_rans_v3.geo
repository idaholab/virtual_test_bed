// Core geometric details
h_cl 			= 1.6;
h_peripheral 	= 2.65;
r_wall 			= 1.264;
theta_wall 		= Pi/1.75; //the arch angle of the outer wall
dh_inlet 		= 0.235; // this is not the channel width, but the width of the vertical cross section.
r_core 			= 1.054;
x_outlet 		= 1.785; 
h_extru 		= 0.6;
h_extru2  		= 0.6;


// Model setup parameters
h_bl			=0.025;				// Boundary layer thickness
ratio_bl		=1.5;
n_bl			=6;
n_Azi			=9;
ratio_Azi1 		=1.2;
ratio_Azi2 		=0.8;
n_curve			=21;
n_width			=16; 
n_neck			=9;
n_elbow 		=9;
n_extru			=11;
n_extru2		=21;

// Points on the centerline
Point(1) = {0, -h_cl/2, 0, 1.0};
Point(2) = {0, -(h_cl/2-h_bl), 0, 1.0};
Point(3) = {0, 0, 0, 1.0};
Point(4) = {0, h_cl/2-h_bl, 0, 1.0};
Point(5) = {0, h_cl/2, 0, 1.0};
//+
Line(1) = {1,2}; Line(2) = {5,4}; Transfinite Curve {1:2}= n_bl Using Progression ratio_bl;
Line(3) = {2,3}; Line(4) = {4,3}; Transfinite Curve {3:4}= n_curve Using Progression 1.0;

// Points on the centerline for axisymmetric rotation
Point(6) = {0, h_peripheral/2, 0, 1.0};
Point(7) = {0, h_peripheral/2-h_bl, 0, 1.0};
Point(8) = {0, h_peripheral/2-dh_inlet+h_bl, 0, 1.0};
Point(9) = {0, h_peripheral/2-dh_inlet, 0, 1.0};

Point(10) = {0, h_peripheral/2-dh_inlet-0.15, 0, 1.0};
Point(11) = {0, h_peripheral/2-dh_inlet-0.15-h_extru, 0, 1.0};

Point(12) = {0, -h_peripheral/2, 0, 1.0};
Point(13) = {0, -(h_peripheral/2-h_bl), 0, 1.0};
Point(14) = {0, -(h_peripheral/2-dh_inlet+h_bl), 0, 1.0};
Point(15) = {0, -(h_peripheral/2-dh_inlet), 0, 1.0};

Point(16) = {0, -(h_peripheral/2-dh_inlet-0.15), 0, 1.0};
Point(17) = {0, -(h_peripheral/2-dh_inlet-0.15-h_extru), 0, 1.0};

x2 = r_core+r_wall-r_wall*Cos(theta_wall/2); y2 = r_wall*Sin(theta_wall/2);
x4 = x2; 
y4 = h_peripheral/2 - ((x_outlet - x4) * (h_peripheral-h_cl)/2/x_outlet);
y1 = r_wall*Sin(theta_wall/4);
r_tmp = Sqrt((r_core+r_wall-x2)^2.0+(y2+1.5*h_bl)^2);
y3 = r_tmp*Sin(theta_wall/4);
Point(18) = {0, y4, 0, 1.0};
Point(19) = {0, y4-h_bl, 0, 1.0};
Point(20) = {0, y2 + 1.5*h_bl, 0, 1.0};
Point(21) = {0, y2, 0, 1.0};
Point(22) = {0, y1, 0, 1.0};
Point(23) = {0, y3, 0, 1.0};

Point(24) = {0, -y4, 0, 1.0};
Point(25) = {0, -(y4-h_bl), 0, 1.0};
Point(26) = {0, -(y2 + 1.5*h_bl), 0, 1.0};
Point(27) = {0, -y2, 0, 1.0};
Point(28) = {0, -y1, 0, 1.0};
Point(29) = {0, -y3, 0, 1.0};

nWallPatch=0; 	nInletPatch=0; 	nOutletPatch=0; nSymPatch=0; nFluidVolume=0;
nChanSideOut=0; nChanSideIn=0;
startSurface=0; startVolume=0;

Function fillSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
Return

Function fillWallSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	wall[nWallPatch]=startSurface; nWallPatch=nWallPatch+1;
Return

Function fillChanSideOutSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	chanSideOut[nChanSideOut]=startSurface; nChanSideOut=nChanSideOut+1;
Return

Function fillChanSideInSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	chanSideIn[nChanSideIn]=startSurface; nChanSideIn=nChanSideIn+1;
Return

Function fillSymSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	sym[nSymPatch]=startSurface; nSymPatch=nSymPatch+1;
Return

Function fillInletSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	inlet[nInletPatch]=startSurface; nInletPatch=nInletPatch+1;
Return

Function fillOutletSurface
	startSurface=startSurface+1;
	Curve Loop (startSurface)={l1, l2, l3, l4};
	Surface (startSurface)={startSurface};
	outlet[nOutletPatch]=startSurface; nOutletPatch=nOutletPatch+1;
Return

Function fillVolume
	startVolume=startVolume+1;
	Surface Loop (startVolume) = {s1,s2,s3,s4,s5,s6};
	Volume (startVolume) = {startVolume};
	fluid[nFluidVolume]=startVolume; nFluidVolume=nFluidVolume+1;
Return

Function fan
// outlet channels
	pref3=newp; Printf("pref3 =%g", pref3);
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet, 		  0, 1.0};
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet+h_bl,   0, 1.0}; 	Line(newl) = {pref3  ,pref3+1};
	Point(newp) = {x_outlet,  h_peripheral/2-h_bl, 			  0, 1.0};          
	Point(newp) = {x_outlet,  h_peripheral/2, 				  0, 1.0};  Line(newl) = {pref3+3,pref3+2};

	Point(newp) = {x_outlet, h_peripheral/2-dh_inlet-0.15, 0, 1.0}; // center of the arch
	height1 = h_peripheral/2-dh_inlet-0.15;
	pref4=newp; Printf("pref4 =%g", pref4);
	Point(newp) = {x_outlet+0.15, 					height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height1, 0, 1.0};	Line(newl) = {pref4  ,pref4+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height1, 0, 1.0};	Line(newl) = {pref4+3,pref4+2};

	height2 = height1-h_extru;
	Point(newp) = {x_outlet+0.15, 					height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height2, 0, 1.0};	Line(newl) = {pref4+4,pref4+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height2, 0, 1.0};	Line(newl) = {pref4+7,pref4+6};

// inlet part
	pref5=newp; Printf("pref5 =%g", pref5);
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet), 	  0, 1.0};    	
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet+h_bl), 0, 1.0};	Line(newl) = {pref5  ,pref5+1};
	Point(newp) = {x_outlet, -(h_peripheral/2-h_bl), 		  0, 1.0};			
	Point(newp) = {x_outlet, -(h_peripheral/2), 			  0, 1.0};	Line(newl) = {pref5+3,pref5+2};

	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet-0.15), 0, 1.0}; // center of the arch
	height3 = -height1;
	pref6=newp; Printf("pref6 =%g", pref6);
	Point(newp) = {x_outlet+0.15, 					height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height3, 0, 1.0}; 	Line(newl) = {pref6  ,pref6+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height3, 0, 1.0};	Line(newl) = {pref6+3,pref6+2};
	
	height4 = -(height1-h_extru2);
	Point(newp) = {x_outlet+0.15, 					height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height4, 0, 1.0};	Line(newl) = {pref6+4,pref6+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height4, 0, 1.0};	Line(newl) = {pref6+7,pref6+6};
// boundary layer lines are connected first from the wall to the interior.
	lref2=newl; Printf("lref2 =%g", lref2);
	Transfinite Curve {lref2-12:lref2-1}= n_bl Using Progression ratio_bl;  

	Line(newl) = {pref3+1,pref3+2};
	Line(newl) = {pref4+1,pref4+2};
	Line(newl) = {pref4+5,pref4+6};

	Line(newl) = {pref5+1,pref5+2};
	Line(newl) = {pref6+1,pref6+2};
	Line(newl) = {pref6+5,pref6+6};

	lref3=newl; Printf("lref3 =%g", lref3);
	Transfinite Curve {lref2:lref3-1}= n_width Using Progression 1.0;

// connecting inlet and outlet necks 
	Line(newl) = {pref1-1,pref3  };
	Line(newl) = {pref2-1,pref3+1};
	Line(newl) = {pref2+1,pref3+2};
	Line(newl) = {pref2  ,pref3+3};

	Line(newl) = {pref   ,pref5  };
	Line(newl) = {pref1  ,pref5+1};
	Line(newl) = {pref2+3,pref5+2};
	Line(newl) = {pref2+2,pref5+3};

	lref4=newl; Printf("lref4 =%g", lref4);
	Transfinite Curve {lref3:lref4-1}= n_neck Using Progression 1.0;

// connecting inlet and outlet elbows
	Circle(newl) = {pref3  ,pref4-1,pref4  };
	Circle(newl) = {pref3+1,pref4-1,pref4+1};
	Circle(newl) = {pref3+2,pref4-1,pref4+2};
	Circle(newl) = {pref3+3,pref4-1,pref4+3};

	Circle(newl) = {pref5  ,pref6-1,pref6  };
	Circle(newl) = {pref5+1,pref6-1,pref6+1};
	Circle(newl) = {pref5+2,pref6-1,pref6+2};
	Circle(newl) = {pref5+3,pref6-1,pref6+3};

	lref5=newl; Printf("lref5=%g", lref5);
	Transfinite Curve {lref4:lref5-1}= n_elbow Using Progression 1.0;

// connecting inlet and outlet extrusion pipes
	Line(newl) = {pref4  ,pref4+4};
	Line(newl) = {pref4+1,pref4+5};
	Line(newl) = {pref4+2,pref4+6};
	Line(newl) = {pref4+3,pref4+7};

	Line(newl) = {pref6  ,pref6+4};
	Line(newl) = {pref6+1,pref6+5};
	Line(newl) = {pref6+2,pref6+6};
	Line(newl) = {pref6+3,pref6+7};

	lref6=newl; Printf("lref6=%g", lref6);
	Transfinite Curve {lref5:lref5+3}= n_extru Using Progression 1.0;
	Transfinite Curve {lref5+4:lref6-1}= n_extru2 Using Progression 1.0;

// filling surfaces related to inlet/outlet neck parts
	l1 = -(lref1+4);  l2 = lref3;     l3 = (lref2-12);  l4 = -(lref3+1);   Call fillChanSideOutSurface; 
	l1 = -(lref1+7);  l2 = lref3+1;   l3 = lref2;       l4 = -(lref3+2);   Call fillChanSideOutSurface;
	l1 = lref1+5;     l2 = lref3+2;   l3 = -(lref2-11); l4 = -(lref3+3);   Call fillChanSideOutSurface;
//
	l1 = lref1;  	  l2 = lref3+5;   l3 =-(lref2-6);   l4 = -(lref3+4);   Call fillChanSideInSurface;
	l1 = lref1+8;     l2 = lref3+6;   l3 =-(lref2+3);   l4 = -(lref3+5);   Call fillChanSideInSurface;
	l1 =-(lref1+6);   l2 = lref3+7;   l3 = (lref2-5);   l4 = -(lref3+6);   Call fillChanSideInSurface;
// filling surfaces related to inlet/outlet elbow parts
	l1 = -(lref2-12); l2 = lref4;     l3 = (lref2-10);  l4 = -(lref4+1);   Call fillChanSideOutSurface;
	l1 = -lref2;      l2 = lref4+1;   l3 = (lref2+1);   l4 = -(lref4+2);   Call fillChanSideOutSurface;
	l1 = lref2-11;    l2 = lref4+2;   l3 =-(lref2-9);   l4 = -(lref4+3);   Call fillChanSideOutSurface;
//
	l1 = (lref2-6);   l2 = lref4+5;   l3 =-(lref2-4);   l4 = -(lref4+4);   Call fillChanSideInSurface;
	l1 = (lref2+3);   l2 = lref4+6;   l3 =-(lref2+4);   l4 = -(lref4+5);   Call fillChanSideInSurface;
	l1 =-(lref2-5);   l2 = lref4+7;   l3 = (lref2-3);   l4 = -(lref4+6);   Call fillChanSideInSurface;
// filling surfaces related to inlet/outlet extrusion parts
	l1 =-(lref2-10);  l2 = lref5;     l3 = (lref2-8);   l4 = -(lref5+1);   Call fillChanSideOutSurface;
	l1 =-(lref2+1);   l2 = lref5+1;   l3 = (lref2+2);   l4 = -(lref5+2);   Call fillChanSideOutSurface;
	l1 = (lref2-9);   l2 = lref5+2;   l3 =-(lref2-7);   l4 = -(lref5+3);   Call fillChanSideOutSurface;
//
	l1 = (lref2-4);   l2 = lref5+5;   l3 =-(lref2-2);   l4 = -(lref5+4);   Call fillChanSideInSurface;
	l1 = (lref2+4);   l2 = lref5+6;   l3 =-(lref2+5);   l4 = -(lref5+5);   Call fillChanSideInSurface;
	l1 =-(lref2-3);   l2 = lref5+7;   l3 = (lref2-1);   l4 = -(lref5+6);   Call fillChanSideInSurface;

Return

// The wall curve
Function curvedWall
	pcenter=newp; Printf("pcenter =%g", pcenter);
	Point(newp) = {r_core+r_wall, 0, 0, 1.0};
	pref=newp; Printf("pref =%g", pref);
	x1 = r_core+r_wall-r_wall*Cos(theta_wall/4); y1 = r_wall*Sin(theta_wall/4); 
	x2 = r_core+r_wall-r_wall*Cos(theta_wall/2); y2 = r_wall*Sin(theta_wall/2); 
	Point(newp) = {x2, 		-y2, 0, 1.0};
	Point(newp) = {x1, 		-y1, 0, 1.0}; 
	Point(newp) = {r_core, 	  0, 0, 1.0}; 
	Point(newp) = {x1,   	 y1, 0, 1.0};
	Point(newp) = {x2, 		 y2, 0, 1.0};
	lref=newl; Printf("lref =%g", lref);
	Circle(newl) = {pref  ,pcenter,pref+1};
	Circle(newl) = {pref+1,pcenter,pref+2};
	Circle(newl) = {pref+2,pcenter,pref+3};
	Circle(newl) = {pref+3,pcenter,pref+4};
	
	r_tmp = Sqrt((r_core+r_wall-x2)^2.0+(y2+1.5*h_bl)^2); r_new = r_core+r_wall-r_tmp;
	pref1=newp; Printf("pref1 =%g", pref1);
	x3 = r_core+r_wall-r_tmp*Cos(theta_wall/4); y3 = r_tmp*Sin(theta_wall/4); 
	Point(newp) = {x2, 		-(y2 + 1.5*h_bl), 	0, 1.0};
	Point(newp) = {x3, 		-y3, 				0, 1.0};
	Point(newp) = {r_new,    0, 				0, 1.0};
	Point(newp) = {x3, 		 y3, 				0, 1.0};
	Point(newp) = {x2, 		 y2 + 1.5*h_bl, 	0, 1.0};
	Circle(newl) = {pref1  ,pcenter,pref1+1};
	Circle(newl) = {pref1+1,pcenter,pref1+2};
	Circle(newl) = {pref1+2,pcenter,pref1+3};
	Circle(newl) = {pref1+3,pcenter,pref1+4};
	Transfinite Curve {lref:lref+7}= n_curve Using Progression 1.0;
	
	lref1=newl; Printf("lref1 =%g", lref1);
	For ipoint In {0:4:1}
		Line(newl) = {pref+ipoint, pref1+ipoint};
	EndFor

// BL faces parallel to the radial direction (z>0)
	l1 = lref+2;      l2 = lref1+1+2; l3 = -(lref+4+2); l4 = -(lref1+2);   Call fillSymSurface; 
	l1 = lref+3;      l2 = lref1+1+3; l3 = -(lref+4+3); l4 = -(lref1+3);   Call fillSymSurface;
// (z<0)
	l1 = lref+1;      l2 = lref1+2;   l3 = -(lref+5);   l4 = -(lref1+1);   Call fillSymSurface;
	l1 = lref;        l2 = lref1+1;   l3 = -(lref+4);   l4 = -(lref1);     Call fillSymSurface;
// the top and bottom points at the outlet/inlet faces 
	x4 = x2; 
	y4 = h_peripheral/2 - ((x_outlet - x4) * (h_peripheral-h_cl)/2/x_outlet);
	pref2=newp; Printf("pref2 =%g", pref2);
	Point(newp) = {x4,  y4, 0, 1.0}; Point(newp) = {x4,   y4-h_bl,  0, 1.0}; Line(newl) = {pref2  ,pref2+1};
	Point(newp) = {x4, -y4, 0, 1.0}; Point(newp) = {x4, -(y4-h_bl), 0, 1.0}; Line(newl) = {pref2+2,pref2+3};
	Transfinite Curve {lref1:lref1+6}= n_bl Using Progression ratio_bl;  
	Line(newl) = {pref2-1,pref2+1};
	Line(newl) = {pref1  ,pref2+3};
	Transfinite Curve {lref1+7:lref1+8}= n_width Using Progression 1.0;

	pref_beg=newp; Printf("pref_beg =%g", pref_beg);
	Call fan;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
Return 

Function fan2
// outlet channels
	pref3=newp; Printf("pref3 =%g", pref3);
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet, 		  0, 1.0};
	Point(newp) = {x_outlet,  h_peripheral/2-dh_inlet+h_bl,   0, 1.0}; 	Line(newl) = {pref3  ,pref3+1};
	Point(newp) = {x_outlet,  h_peripheral/2-h_bl, 			  0, 1.0};          
	Point(newp) = {x_outlet,  h_peripheral/2, 				  0, 1.0};  Line(newl) = {pref3+3,pref3+2};

	Point(newp) = {x_outlet, h_peripheral/2-dh_inlet-0.15, 0, 1.0}; // center of the arch
	height1 = h_peripheral/2-dh_inlet-0.15;
	pref4=newp; Printf("pref4 =%g", pref4);
	Point(newp) = {x_outlet+0.15, 					height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height1, 0, 1.0};	Line(newl) = {pref4  ,pref4+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height1, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height1, 0, 1.0};	Line(newl) = {pref4+3,pref4+2};

	height2 = height1-h_extru;
	Point(newp) = {x_outlet+0.15, 					height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height2, 0, 1.0};	Line(newl) = {pref4+4,pref4+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height2, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height2, 0, 1.0};	Line(newl) = {pref4+7,pref4+6};

// inlet part
	pref5=newp; Printf("pref5 =%g", pref5);
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet), 	  0, 1.0};    	
	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet+h_bl), 0, 1.0};	Line(newl) = {pref5  ,pref5+1};
	Point(newp) = {x_outlet, -(h_peripheral/2-h_bl), 		  0, 1.0};			
	Point(newp) = {x_outlet, -(h_peripheral/2), 			  0, 1.0};	Line(newl) = {pref5+3,pref5+2};

	Point(newp) = {x_outlet, -(h_peripheral/2-dh_inlet-0.15), 0, 1.0}; // center of the arch
	height3 = -height1;
	pref6=newp; Printf("pref6 =%g", pref6);
	Point(newp) = {x_outlet+0.15, 					height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height3, 0, 1.0}; 	Line(newl) = {pref6  ,pref6+1};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height3, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height3, 0, 1.0};	Line(newl) = {pref6+3,pref6+2};
	
	height4 = -(height1-h_extru2);
	Point(newp) = {x_outlet+0.15, 					height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+h_bl, 				height4, 0, 1.0};	Line(newl) = {pref6+4,pref6+5};
	Point(newp) = {x_outlet+0.15+dh_inlet-h_bl, 	height4, 0, 1.0};
	Point(newp) = {x_outlet+0.15+dh_inlet, 			height4, 0, 1.0};	Line(newl) = {pref6+7,pref6+6};
// boundary layer lines are connected first from the wall to the interior.
	lref2=newl; Printf("lref2 =%g", lref2);
	Transfinite Curve {lref2-12:lref2-1}= n_bl Using Progression ratio_bl;  

	Line(newl) = {pref3+1,pref3+2};
	Line(newl) = {pref4+1,pref4+2};
	Line(newl) = {pref4+5,pref4+6};

	Line(newl) = {pref5+1,pref5+2};
	Line(newl) = {pref6+1,pref6+2};
	Line(newl) = {pref6+5,pref6+6};

	lref3=newl; Printf("lref3 =%g", lref3);
	Transfinite Curve {lref2:lref3-1}= n_width Using Progression 1.0;

// connecting inlet and outlet necks 
	Line(newl) = {pref1-1,pref3  };
	Line(newl) = {pref2-1,pref3+1};
	Line(newl) = {pref2+1,pref3+2};
	Line(newl) = {pref2  ,pref3+3};

	Line(newl) = {pref   ,pref5  };
	Line(newl) = {pref1  ,pref5+1};
	Line(newl) = {pref2+3,pref5+2};
	Line(newl) = {pref2+2,pref5+3};

	lref4=newl; Printf("lref4 =%g", lref4);
	Transfinite Curve {lref3:lref4-1}= n_neck Using Progression 1.0;

// connecting inlet and outlet elbows
	Circle(newl) = {pref3  ,pref4-1,pref4  };
	Circle(newl) = {pref3+1,pref4-1,pref4+1};
	Circle(newl) = {pref3+2,pref4-1,pref4+2};
	Circle(newl) = {pref3+3,pref4-1,pref4+3};

	Circle(newl) = {pref5  ,pref6-1,pref6  };
	Circle(newl) = {pref5+1,pref6-1,pref6+1};
	Circle(newl) = {pref5+2,pref6-1,pref6+2};
	Circle(newl) = {pref5+3,pref6-1,pref6+3};

	lref5=newl; Printf("lref5=%g", lref5);
	Transfinite Curve {lref4:lref5-1}= n_elbow Using Progression 1.0;

// connecting inlet and outlet extrusion pipes
	Line(newl) = {pref4  ,pref4+4};
	Line(newl) = {pref4+1,pref4+5};
	Line(newl) = {pref4+2,pref4+6};
	Line(newl) = {pref4+3,pref4+7};

	Line(newl) = {pref6  ,pref6+4};
	Line(newl) = {pref6+1,pref6+5};
	Line(newl) = {pref6+2,pref6+6};
	Line(newl) = {pref6+3,pref6+7};

	lref6=newl; Printf("lref6=%g", lref6);
	Transfinite Curve {lref5:lref5+3}= n_extru Using Progression 1.0;
	Transfinite Curve {lref5+4:lref6-1}= n_extru2 Using Progression 1.0;

// filling surfaces related to inlet/outlet neck parts
	l1 = -(lref1+4);  l2 = lref3;     l3 = (lref2-12);  l4 = -(lref3+1);   Call fillSurface; 
	l1 = -(lref1+7);  l2 = lref3+1;   l3 = lref2;       l4 = -(lref3+2);   Call fillSurface;
	l1 = lref1+5;     l2 = lref3+2;   l3 = -(lref2-11); l4 = -(lref3+3);   Call fillSurface;
//
	l1 = lref1;  	  l2 = lref3+5;   l3 =-(lref2-6);   l4 = -(lref3+4);   Call fillSurface;
	l1 = lref1+8;     l2 = lref3+6;   l3 =-(lref2+3);   l4 = -(lref3+5);   Call fillSurface;
	l1 =-(lref1+6);   l2 = lref3+7;   l3 = (lref2-5);   l4 = -(lref3+6);   Call fillSurface;
// filling surfaces related to inlet/outlet elbow parts
	l1 = -(lref2-12); l2 = lref4;     l3 = (lref2-10);  l4 = -(lref4+1);   Call fillSurface;
	l1 = -lref2;      l2 = lref4+1;   l3 = (lref2+1);   l4 = -(lref4+2);   Call fillSurface;
	l1 = lref2-11;    l2 = lref4+2;   l3 =-(lref2-9);   l4 = -(lref4+3);   Call fillSurface;
//
	l1 = (lref2-6);   l2 = lref4+5;   l3 =-(lref2-4);   l4 = -(lref4+4);   Call fillSurface;
	l1 = (lref2+3);   l2 = lref4+6;   l3 =-(lref2+4);   l4 = -(lref4+5);   Call fillSurface;
	l1 =-(lref2-5);   l2 = lref4+7;   l3 = (lref2-3);   l4 = -(lref4+6);   Call fillSurface;
// filling surfaces related to inlet/outlet extrusion parts
	l1 =-(lref2-10);  l2 = lref5;     l3 = (lref2-8);   l4 = -(lref5+1);   Call fillSurface;
	l1 =-(lref2+1);   l2 = lref5+1;   l3 = (lref2+2);   l4 = -(lref5+2);   Call fillSurface;
	l1 = (lref2-9);   l2 = lref5+2;   l3 =-(lref2-7);   l4 = -(lref5+3);   Call fillSurface;
//
	l1 = (lref2-4);   l2 = lref5+5;   l3 =-(lref2-2);   l4 = -(lref5+4);   Call fillSurface;
	l1 = (lref2+4);   l2 = lref5+6;   l3 =-(lref2+5);   l4 = -(lref5+5);   Call fillSurface;
	l1 =-(lref2-3);   l2 = lref5+7;   l3 = (lref2-1);   l4 = -(lref5+6);   Call fillSurface;

Return

// The wall curve
Function curvedWall2
	pcenter=newp; Printf("pcenter =%g", pcenter);
	Point(newp) = {r_core+r_wall, 0, 0, 1.0};
	pref=newp; Printf("pref =%g", pref);
	x1 = r_core+r_wall-r_wall*Cos(theta_wall/4); y1 = r_wall*Sin(theta_wall/4); 
	x2 = r_core+r_wall-r_wall*Cos(theta_wall/2); y2 = r_wall*Sin(theta_wall/2); 
	Point(newp) = {x2, 		-y2, 0, 1.0};
	Point(newp) = {x1, 		-y1, 0, 1.0}; 
	Point(newp) = {r_core, 	  0, 0, 1.0}; 
	Point(newp) = {x1,   	 y1, 0, 1.0};
	Point(newp) = {x2, 		 y2, 0, 1.0};
	lref=newl; Printf("lref =%g", lref);
	Circle(newl) = {pref  ,pcenter,pref+1};
	Circle(newl) = {pref+1,pcenter,pref+2};
	Circle(newl) = {pref+2,pcenter,pref+3};
	Circle(newl) = {pref+3,pcenter,pref+4};
	
	r_tmp = Sqrt((r_core+r_wall-x2)^2.0+(y2+1.5*h_bl)^2); r_new = r_core+r_wall-r_tmp;
	pref1=newp; Printf("pref1 =%g", pref1);
	x3 = r_core+r_wall-r_tmp*Cos(theta_wall/4); y3 = r_tmp*Sin(theta_wall/4); 
	Point(newp) = {x2, 		-(y2 + 1.5*h_bl), 	0, 1.0};
	Point(newp) = {x3, 		-y3, 				0, 1.0};
	Point(newp) = {r_new,    0, 				0, 1.0};
	Point(newp) = {x3, 		 y3, 				0, 1.0};
	Point(newp) = {x2, 		 y2 + 1.5*h_bl, 	0, 1.0};
	Circle(newl) = {pref1  ,pcenter,pref1+1};
	Circle(newl) = {pref1+1,pcenter,pref1+2};
	Circle(newl) = {pref1+2,pcenter,pref1+3};
	Circle(newl) = {pref1+3,pcenter,pref1+4};
	Transfinite Curve {lref:lref+7}= n_curve Using Progression 1.0;
	
	lref1=newl; Printf("lref1 =%g", lref1);
	For ipoint In {0:4:1}
		Line(newl) = {pref+ipoint, pref1+ipoint};
	EndFor

// BL faces parallel to the radial direction (z>0)
	l1 = lref+2;      l2 = lref1+1+2; l3 = -(lref+4+2); l4 = -(lref1+2);   Call fillSurface; 
	l1 = lref+3;      l2 = lref1+1+3; l3 = -(lref+4+3); l4 = -(lref1+3);   Call fillSurface;
// (z<0)
	l1 = lref+1;      l2 = lref1+2;   l3 = -(lref+5);   l4 = -(lref1+1);   Call fillSurface;
	l1 = lref;        l2 = lref1+1;   l3 = -(lref+4);   l4 = -(lref1);     Call fillSurface;
// the top and bottom points at the outlet/inlet faces 
	x4 = x2; 
	y4 = h_peripheral/2 - ((x_outlet - x4) * (h_peripheral-h_cl)/2/x_outlet);
	pref2=newp; Printf("pref2 =%g", pref2);
	Point(newp) = {x4,  y4, 0, 1.0}; Point(newp) = {x4,   y4-h_bl,  0, 1.0}; Line(newl) = {pref2  ,pref2+1};
	Point(newp) = {x4, -y4, 0, 1.0}; Point(newp) = {x4, -(y4-h_bl), 0, 1.0}; Line(newl) = {pref2+2,pref2+3};
	Transfinite Curve {lref1:lref1+6}= n_bl Using Progression ratio_bl;  
	Line(newl) = {pref2-1,pref2+1};
	Line(newl) = {pref1  ,pref2+3};
	Transfinite Curve {lref1+7:lref1+8}= n_width Using Progression 1.0;

	pref_beg=newp; Printf("pref_beg =%g", pref_beg);
	Call fan2;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
Return 

Function externalChan // creating channnels outside the core
	lref7=newl; Printf("lref7 =%g", lref7); 
    Circle(newl) = {pref-41,27,pref};
	Circle(newl) = {pref-41+1,28,pref+1};
	Circle(newl) = {pref-41+2,3 ,pref+2};
	Circle(newl) = {pref-41+3,22 ,pref+3};
	Circle(newl) = {pref-41+4,19 ,pref+4};
	Circle(newl) = {pref-41+5,26 ,pref+5};	
	Circle(newl) = {pref-41+6,29 ,pref+6};
	Circle(newl) = {pref-41+7,3 ,pref+7};	
	Circle(newl) = {pref-41+8,23 ,pref+8};
    Circle(newl) = {pref-41+9,21 ,pref+9};
    Circle(newl) = {pref-41+10,18 ,pref+10};
	Circle(newl) = {pref-41+11,19 ,pref+11};
	Circle(newl) = {pref-41+12,24 ,pref+12};
	Circle(newl) = {pref-41+13,25 ,pref+13};

	ldelta3=97; If(iflip==1) ldelta3=59; EndIf

	sref1=startSurface+1; Printf("sref1 =%g", sref1);
	For iface In {0:4:1} // boundary layer faces along the curved wall
		l1 = -(lref7+iface);	l2 = lref1+iface-ldelta3;	l3 = lref7+5+iface;			l4 = -(lref1+iface);	Call fillSurface;
	EndFor

	For iface In {0:3:1} // patches of the curved wall
		l1 = (lref+iface);		l2 = -(lref7+1+iface);		l3 = -(l1-ldelta3); 	 	l4 = lref7+iface;		Call fillWallSurface;
		l1 = (lref+iface+4);	l2 = -(lref7+6+iface);		l3 = -(l1-ldelta3); 		l4 = lref7+iface+5;		Call fillSurface;
	EndFor

	sdelta=81; If(iflip==1) sdelta=22; EndIf
	s1=sref+3;		s2=s1-sdelta;		s3=sref1;		s4=sref1+1;		s5=sref1+5;		s6=sref1+6; 	Call fillVolume;
	s1=sref+2;		s2=s1-sdelta;		s3=sref1+1;		s4=sref1+2;		s5=sref1+7;		s6=sref1+8; 	Call fillVolume;
	s1=sref;   		s2=s1-sdelta;		s3=sref1+2;		s4=sref1+3;		s5=sref1+9;		s6=sref1+10; 	Call fillVolume;
	s1=sref+1;		s2=s1-sdelta;		s3=sref1+3;		s4=sref1+4;		s5=sref1+11;	s6=sref1+12; 	Call fillVolume;

	// patches when the inlet/outlet channels meeting the bulk core
	sref2=startSurface+1; Printf("sref2 =%g", sref2);
	l1 = lref1+7;			l2 = -(lref7+11);		l3 = -(l1-ldelta3); 	 l4 = lref7+9;		Call fillSurface;
	l1 = -(lref1+5);		l2 = -(lref7+10);		l3 = (-l1-ldelta3); 	 l4 = lref7+11;		Call fillSurface;

	l1 = -(lref1+8);		l2 = -(lref7+5);		l3 = (-l1-ldelta3); 	 l4 = lref7+13;		Call fillSurface;
	l1 = (lref1+6);	     	l2 = -(lref7+13);		l3 = -(l1-ldelta3); 	 l4 = lref7+12;		Call fillSurface;

	lref8=newl; Printf("lref8 =%g", lref8);
    Circle(newl) = {pref3-41,9,pref3};
    Circle(newl) = {pref3-41+1,8,pref3+1};
    Circle(newl) = {pref3-41+2,7,pref3+2};
    Circle(newl) = {pref3-41+3,6,pref3+3};

	For iedge In {pref4:pref4+3:1}
		Circle(newl) = {iedge-41,10,iedge};
	EndFor

	For iedge In {pref4+4:pref4+7:1}
		Circle(newl) = {iedge-41,11,iedge};
	EndFor

	// patches between outlet necks and elbows
	ldelta4=97; If(iflip==1) ldelta4=59; EndIf
	sref3=startSurface+1; Printf("sref3 =%g", sref3);
	l1 = lref8;		l2 = lref1+9;		l3 = -(lref8+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+1;	l2 = lref2;			l3 = -(lref8+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = -(lref1+10);	l3 = -(lref8+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7+4;	l2 = lref3;			l3 = -(lref7+14);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+9;	l2 = (lref3+1);		l3 = -(lref7+15);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+11;	l2 = (lref3+2);		l3 = -(lref7+16);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+10;	l2 = (lref3+3);		l3 = -(lref7+17);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between outlet elbows and extrusions	
	l1 = lref8+4;	l2 = lref1+11;		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+5;	l2 = lref2+1;		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = -(lref1+12);	l3 = -(lref8+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref8;		l2 = lref4;			l3 = -(lref8+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+1;	l2 = (lref4+1);		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = (lref4+2);		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+3;	l2 = (lref4+3);		l3 = -(lref8+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// outlet face patches
	l1 = lref8+8;	l2 = lref1+13;		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+9;	l2 = lref2+2;		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+10;	l2 = -(lref1+14);	l3 = -(lref8+11);	l4 =(-l2-ldelta4);	Call fillOutletSurface;

	l1 = lref8+4;	l2 = lref5;			l3 = -(lref8+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+5;	l2 = (lref5+1);		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = (lref5+2);		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+7;	l2 = (lref5+3);		l3 = -(lref8+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	sdelta1=81; If(iflip==1) sdelta1=22; EndIf
	s1=sref+4;		s2=s1-sdelta1;		s3=sref1+4;		s4=sref3;		s5=sref3+3;		s6=sref3+4; 	Call fillVolume;
	s1=sref+5;		s2=s1-sdelta1;		s3=sref2;		s4=sref2+5;		s5=sref3+4;		s6=sref3+5; 	Call fillVolume;
	s1=sref+6;   	s2=s1-sdelta1;		s3=sref2+1;		s4=sref2+6;		s5=sref3+5;		s6=sref3+6; 	Call fillVolume;

	s1=sref+10;		s2=s1-sdelta1;		s3=sref3;		s4=sref3+7;		s5=sref3+10;	s6=sref3+11; 	Call fillVolume;
	s1=sref+11;		s2=s1-sdelta1;		s3=sref3+1;		s4=sref3+8;		s5=sref3+11;	s6=sref3+12; 	Call fillVolume;
	s1=sref+12;   	s2=s1-sdelta1;		s3=sref3+2;		s4=sref3+9;		s5=sref3+12;	s6=sref3+13; 	Call fillVolume;

	s1=sref+16;		s2=s1-sdelta1;		s3=sref3+7;		s4=sref3+14;	s5=sref3+17;	s6=sref3+18; 	Call fillVolume;
	s1=sref+17;		s2=s1-sdelta1;		s3=sref3+8;		s4=sref3+15;	s5=sref3+18;	s6=sref3+19; 	Call fillVolume;
	s1=sref+18;   	s2=s1-sdelta1;		s3=sref3+9;		s4=sref3+16;	s5=sref3+19;	s6=sref3+20; 	Call fillVolume;

	lref9=newl; Printf("lref9 =%g", lref9); // start working on the lower/inlet part
    Circle(newl) = {pref5-41,15,pref5};
    Circle(newl) = {pref5-41+1,14,pref5+1};
	Circle(newl) = {pref5-41+2,13,pref5+2};
    Circle(newl) = {pref5-41+3,12,pref5+3};

	For iedge In {pref6:pref6+3:1}
		Circle(newl) = {iedge-41,16,iedge};
	EndFor		

	For iedge In {pref6+4:pref6+7:1}
		Circle(newl) = {iedge-41,17,iedge};
	EndFor	

	// patches between inlet necks and elbows
	sref4=startSurface+1; Printf("sref4 =%g", sref4);
	l1 = lref9;		l2 = lref1+15;		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+1;	l2 = lref2+3;		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = -(lref1+16);	l3 = -(lref9+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7;  	l2 = lref3+4;		l3 = -lref9;		l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+5;	l2 = (lref3+5);		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+13;	l2 = (lref3+6);		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+12;	l2 = (lref3+7);		l3 = -(lref9+3);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between inlet elbows and extrusions	
	l1 = lref9+4;	l2 = lref1+17;		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+5;	l2 = lref2+4;		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = -(lref1+18);	l3 = -(lref9+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref9;		l2 = lref4+4;		l3 = -(lref9+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+1;	l2 = (lref4+5);		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = (lref4+6);		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+3;	l2 = (lref4+7);		l3 = -(lref9+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// inlet face patches
	l1 = lref9+8;	l2 = lref1+19;		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+9;	l2 = lref2+5;		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+10;	l2 = -(lref1+20);	l3 = -(lref9+11);	l4 =(-l2-ldelta4);	Call fillInletSurface;

	l1 = lref9+4;	l2 = lref5+4;		l3 = -(lref9+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+5;	l2 = (lref5+5);		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = (lref5+6);		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+7;	l2 = (lref5+7);		l3 = -(lref9+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	s1=sref+7;		s2=s1-sdelta1;		s3=sref1;		s4=sref4;		s5=sref4+3;		s6=sref4+4; 	Call fillVolume;
	s1=sref+8;		s2=s1-sdelta1;		s3=sref2+2;		s4=sref4+1;		s5=sref4+4;		s6=sref4+5; 	Call fillVolume;
	s1=sref+9;   	s2=s1-sdelta1;		s3=sref2+3;		s4=sref4+2;		s5=sref4+5;		s6=sref4+6; 	Call fillVolume;

	s1=sref+13;		s2=s1-sdelta1;		s3=sref4;		s4=sref4+7;		s5=sref4+10;	s6=sref4+11; 	Call fillVolume;
	s1=sref+14;		s2=s1-sdelta1;		s3=sref4+1;		s4=sref4+8;		s5=sref4+11;	s6=sref4+12; 	Call fillVolume;
	s1=sref+15;   	s2=s1-sdelta1;		s3=sref4+2;		s4=sref4+9;		s5=sref4+12;	s6=sref4+13; 	Call fillVolume;

	s1=sref+19;		s2=s1-sdelta1;		s3=sref4+7;		s4=sref4+14;	s5=sref4+17;	s6=sref4+18; 	Call fillVolume;
	s1=sref+20;		s2=s1-sdelta1;		s3=sref4+8;		s4=sref4+15;	s5=sref4+18;	s6=sref4+19; 	Call fillVolume;
	s1=sref+21;   	s2=s1-sdelta1;		s3=sref4+9;		s4=sref4+16;	s5=sref4+19;	s6=sref4+20; 	Call fillVolume;
Return

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// front face
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sref=startSurface+1; Printf("sref =%g", sref);
iflip = 1;
Call curvedWall;
pref_end=newp-1; Printf("pref_end =%g", pref_end);	
Rotate {{0,1,0}, {0,0,0}, Pi/16} { Point{pcenter:pref_end}; }
Printf("***********face 1 completes**********");
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// middle face
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sref=startSurface+1; Printf("sref =%g", sref);
Call curvedWall2;
pref_end=newp-1; Printf("pref_end =%g", pref_end);
Printf("***********face 2 completes**********");
Call externalChan;
Transfinite Curve {lref7:lref9+11}= n_Azi Using Progression ratio_Azi1;
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// back face
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sref=startSurface+1; Printf("sref =%g", sref);
iflip = -1;
Call curvedWall;
pref_end=newp-1; Printf("pref_end =%g", pref_end);	
Rotate {{0,1,0}, {0,0,0}, -Pi/16} { Point{pcenter:pref_end}; }
Printf("***********face 3 completes**********");
Call externalChan;
Transfinite Curve {lref7:lref9+11}= n_Azi Using Progression ratio_Azi2;

// Create mesh blocks in the core cavity
pratio1 = 0.24; pratio2 = 0.32;
x4 = r_core+r_wall-r_wall*Cos(theta_wall/2); 
x5 = x4*Cos(Pi/16)*pratio1;
y5 = (y4-h_cl/2)*pratio1+h_cl/2;
z5 = x5*Tan(Pi/16); 
x6 = x4*Cos(Pi/16)*pratio2;
y6 = (y4-h_cl/2)*pratio2+h_cl/2;

pref7=newp; Printf("pref7 =%g", pref7);
Point(newp) = {x5, y5,-z5, 1.0};
Point(newp) = {x6, y6,  0, 1.0};
Point(newp) = {x5, y5, z5, 1.0};

Point(newp) = {x5, y5-h_bl,-z5, 1.0};
Point(newp) = {x6, y6-h_bl,  0, 1.0};
Point(newp) = {x5, y5-h_bl, z5, 1.0};

Point(newp) = {x5, 0,-z5, 1.0};
Point(newp) = {x6, 0,  0, 1.0};
Point(newp) = {x5, 0, z5, 1.0};

Point(newp) = {x5, -(y5-h_bl),-z5, 1.0};
Point(newp) = {x6, -(y6-h_bl),  0, 1.0};
Point(newp) = {x5, -(y5-h_bl), z5, 1.0};

Point(newp) = {x5, -y5,-z5, 1.0};
Point(newp) = {x6, -y6,  0, 1.0};
Point(newp) = {x5, -y5, z5, 1.0};

// connect the BL lines from wall to the interior
lref10=newl; Printf("lref10 =%g", lref10);
Line(newl) = {pref7,  pref7+3};
Line(newl) = {pref7+1,pref7+4};
Line(newl) = {pref7+2,pref7+5};

Line(newl) = {pref7+12,  pref7+9};
Line(newl) = {pref7+13,  pref7+10};
Line(newl) = {pref7+14,  pref7+11};
Transfinite Curve {lref10:lref10+5}= n_bl Using Progression ratio_bl;

// connecting interior points to the centerline
lref11=newl; Printf("lref11 =%g", lref11); 
For iedge In {pref7:pref7+12:3} // for the curved wall part 
	Line(newl) = {iedge,iedge+1};
EndFor
Transfinite Curve {lref11:lref11+4}= n_Azi Using Progression ratio_Azi1;
iedge=2;
Line(newl) = {pref7+iedge,   5};
Line(newl) = {pref7+iedge+3, 4};
Line(newl) = {pref7+iedge+6, 3};
Line(newl) = {pref7+iedge+9, 2};
Line(newl) = {pref7+iedge+12,1};
Transfinite Curve {lref11+5:lref11+9}= n_Azi Using Progression ratio_Azi2;

For iedge In {pref7+1:pref7+13:3} // for the curved wall part 
	Line(newl) = {iedge,iedge+1};
EndFor
iedge=0;
Line(newl) = {pref7+iedge,   5};
Line(newl) = {pref7+iedge+3, 4};
Line(newl) = {pref7+iedge+6, 3};
Line(newl) = {pref7+iedge+9, 2};
Line(newl) = {pref7+iedge+12,1};
Transfinite Curve {lref11+10:lref11+19}= n_Azi Using Progression ratio_Azi2;

// connecting interior points to the curved wall, part 1, not using pure pointers
lref12=newl; Printf("lref12 =%g", lref12); 
Line(newl) = {pref7+3,15+24}; 	Line(newl) = {pref7+6,14+24}; 	Line(newl) = {pref7+9,13+24};
Line(newl) = {133+24,56+24}; 		Line(newl) = {136+24,55+24}; 		Line(newl) = {139+24,54+24}; 
Line(newl) = {134+24,97+24}; 		Line(newl) = {137+24,96+24}; 		Line(newl) = {140+24,95+24}; 
Transfinite Curve {lref12:lref12+8}= n_width Using Progression 1;

lref13=newl; Printf("lref13 =%g", lref13);
Line(newl) = {pref7,17+24};
Line(newl) = {132+24,18+24}; 
Line(newl) = {135+24,132+24}; 
Line(newl) = {135+24,138+24};
Line(newl) = {138+24,20+24};
Line(newl) = {141+24,19+24};

Line(newl) = {130+24,58+24};
Line(newl) = {133+24,59+24};
Line(newl) = {136+24,133+24};
Line(newl) = {136+24,139+24};
Line(newl) = {139+24,61+24};
Line(newl) = {142+24,60+24};

Line(newl) = {131+24,99+24};
Line(newl) = {134+24,100+24};
Line(newl) = {137+24,134+24};
Line(newl) = {137+24,140+24};
Line(newl) = {140+24,102+24};
Line(newl) = {143+24,101+24};
Transfinite Curve {lref13:lref13+17}= n_curve Using Progression 1;

// filling faces can create fluid volumes now
l1 = 293;	l2 = 18;	l3 = -294;	l4 =-258;	Call fillSymSurface;
l1 = 299;	l2 = 77;	l3 = -300;	l4 =-259;	Call fillSurface;
l1 = 264;	l2 = 259;	l3 = -265;	l4 =-258;	Call fillSurface;
l1 = 293;	l2 = 133;	l3 = -299;	l4 =-264;	Call fillWallSurface;
l1 = 294;	l2 = 134;	l3 = -300;	l4 =-265;	Call fillSurface;
s1=185;		s2=186;		s3=187;		s4=59;		s5=188;		s6=189; 	Call fillVolume;

l1 = 294;	l2 = -20;	l3 = -12;	l4 =-284;	Call fillSymSurface;
l1 = 300;	l2 = -79;	l3 = -71;	l4 =-287;	Call fillSurface;
l1 = 284;	l2 = 131;	l3 = -287;	l4 =-265;	Call fillSurface;
s1=189;		s2=57;		s3=190;		s4=191;		s5=58;		s6=192; 	Call fillVolume;

l1 = 284;	l2 = -11;	l3 = -285;	l4 =295;	Call fillSymSurface;
l1 = 287;	l2 = -70;	l3 = -288;	l4 =301;	Call fillSurface;
l1 = 266;	l2 = 301;	l3 = -265;	l4 =-295;	Call fillSurface;
l1 = 285;	l2 = 130;	l3 = -288;	l4 =-266;	Call fillSurface;
s1=193;		s2=194;		s3=195;		s4=55;		s5=196;		s6=192; 	Call fillVolume;

l1 = 285;	l2 = -10;	l3 = -286;	l4 =-296;	Call fillSymSurface;
l1 = 288;	l2 = -69;	l3 = -289;	l4 =-302;	Call fillSurface;
l1 = 267;	l2 = -302;	l3 = -266;	l4 = 296;	Call fillSurface;
l1 = 286;	l2 = 129;	l3 = -289;	l4 = -267;	Call fillSurface;
s1=197;		s2=198;		s3=199;		s4=53;		s5=196;		s6=200; 	Call fillVolume;

l1 = 286;	l2 = -9;	l3 = 21;	l4 =-297;	Call fillSymSurface;
l1 = 289;	l2 = -68;	l3 = 80;	l4 =-303;	Call fillSurface;
l1 = 297;	l2 = 136;	l3 = -303;	l4 =-267;	Call fillSurface;
s1=201;		s2=202;		s3=203;		s4=51;		s5=200;		s6=60; 	Call fillVolume;

l1 = 297;	l2 = -19;	l3 = -298;	l4 = 261;	Call fillSymSurface;
l1 = 303;	l2 = -78;	l3 = -304;	l4 = 262;	Call fillSurface;
l1 = 298;	l2 = 135;	l3 = -304;	l4 =-268;	Call fillWallSurface;
l1 = 268;	l2 = 262;	l3 = -267;	l4 =-261;	Call fillSurface;
s1=204;		s2=205;		s3=206;		s4=203;		s5=61;		s6=207; 	Call fillVolume;

l1 = 305;	l2 = 174;	l3 = -306;	l4 = -260;	Call fillSymSurface;
l1 = 299;	l2 = 230;	l3 = -305;	l4 = -274;	Call fillWallSurface;
l1 = 300;	l2 = 231;	l3 = -306;	l4 = -275;	Call fillSurface;
l1 = 275;	l2 = -260;	l3 = -274;	l4 = 259;	Call fillSurface;
s1=208;		s2=186;		s3=209;		s4=210;		s5=140;		s6=211; 	Call fillVolume;

l1 = 306;	l2 = -176;	l3 = -168;	l4 = -290;	Call fillSymSurface;
l1 = 290;	l2 = -228;	l3 = -287;	l4 = 275;	Call fillSurface;
s1=212;		s2=191;		s3=210;		s4=138;		s5=213;		s6=139; 	Call fillVolume;

l1 = 290;	l2 = -167;	l3 = -291;	l4 = 307;	Call fillSymSurface;
l1 = 288;	l2 = 227;	l3 = -291;	l4 = -276;	Call fillSurface;
l1 = 276;	l2 = 307;	l3 = -275;	l4 = -301;	Call fillSurface;
s1=214;		s2=194;		s3=216;		s4=136;		s5=213;		s6=215; 	Call fillVolume;

l1 = 291;	l2 = -166;	l3 = -292;	l4 = -308;	Call fillSymSurface;
l1 = 289;	l2 = 226;	l3 = -292;	l4 = -277;	Call fillSurface;
l1 = 277;	l2 = -308;	l3 = -276;	l4 = 302;	Call fillSurface;
s1=217;		s2=198;		s3=219;		s4=134;		s5=218;		s6=215; 	Call fillVolume;

l1 = 292;	l2 = -165;	l3 = 177;	l4 = -309;	Call fillSymSurface;
l1 = 303;	l2 = 233;	l3 = -309;	l4 = -277;	Call fillSurface;
s1=220;		s2=202;		s3=221;		s4=132;		s5=218;		s6=141; 	Call fillVolume;

l1 = 309;	l2 = -175;	l3 = -310;	l4 = 263;	Call fillSymSurface;
l1 = 304;	l2 = 232;	l3 = -310;	l4 = -278;	Call fillWallSurface;
l1 = 278;	l2 = 263;	l3 = -277;	l4 = -262;	Call fillSurface;
s1=222;		s2=205;		s3=223;		s4=221;		s5=142;		s6=224; 	Call fillVolume;

l1 = 279;	l2 = -269;	l3 = -274;	l4 = -264;	Call fillWallSurface;
l1 = 280;	l2 = -270;	l3 = -275;	l4 = -265;	Call fillSurface;
l1 = 279;	l2 = 2;	l3 = -280;	l4 = -258;	Call fillSymSurface;
l1 = 269;	l2 = 2;	l3 = -270;	l4 = -260;	Call fillSymSurface;
s1=225;		s2=226;		s3=227;		s4=211;		s5=228;		s6=187; 	Call fillVolume;

l1 = 280;	l2 = 4;	l3 = -281;	l4 = 295;	Call fillSymSurface;
l1 = 270;	l2 = 4;	l3 = -271;	l4 = 307;	Call fillSymSurface;
l1 = 281;	l2 = -271;	l3 = -276;	l4 = -266;	Call fillSurface;
s1=229;		s2=216;		s3=230;		s4=195;		s5=226;		s6=231; 	Call fillVolume;

l1 = 281;	l2 = -3;	l3 = -282;	l4 = -296;	Call fillSymSurface;
l1 = 271;	l2 = -3;	l3 = -272;	l4 = -308;	Call fillSymSurface;
l1 = 282;	l2 = -272;	l3 = -277;	l4 = -267;	Call fillSurface;
s1=232;		s2=219;		s3=233;		s4=199;		s5=234;		s6=231; 	Call fillVolume;

l1 = 282;	l2 = -1;	l3 = -283;	l4 = 261;	Call fillSymSurface;
l1 = 272;	l2 = -1;	l3 = -273;	l4 = 263;	Call fillSymSurface;
l1 = 283;	l2 = -273;	l3 = -278;	l4 = -268;	Call fillWallSurface;
s1=235;		s2=224;		s3=236;		s4=207;		s5=234;		s6=237; 	Call fillVolume;

Transfinite Surface "*"; 
Recombine Surface "*";
Physical Surface("Symmetry", 4) = sym[];
Physical Surface("Wall", 3) = wall[];
Physical Surface("Outlet", 2) = outlet[];
Physical Surface("Inlet", 1) = inlet[];
Physical Surface("SideOutlet", 5) = chanSideOut[];
Physical Surface("SideInlet", 6) = chanSideIn[];
Physical Volume("Fluid", 7) = fluid[];
Transfinite Volume "*";//+

