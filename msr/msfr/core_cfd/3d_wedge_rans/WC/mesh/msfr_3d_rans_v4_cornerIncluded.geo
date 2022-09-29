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
	l1 = -(lref1+4);  l2 = lref3;     l3 = (lref2-12);  l4 = -(lref3+1);   Call fillWallSurface; 
	l1 = -(lref1+7);  l2 = lref3+1;   l3 = lref2;       l4 = -(lref3+2);   Call fillWallSurface;
	l1 = lref1+5;     l2 = lref3+2;   l3 = -(lref2-11); l4 = -(lref3+3);   Call fillWallSurface;
//
	l1 = lref1;  	  l2 = lref3+5;   l3 =-(lref2-6);   l4 = -(lref3+4);   Call fillWallSurface;
	l1 = lref1+8;     l2 = lref3+6;   l3 =-(lref2+3);   l4 = -(lref3+5);   Call fillWallSurface;
	l1 =-(lref1+6);   l2 = lref3+7;   l3 = (lref2-5);   l4 = -(lref3+6);   Call fillWallSurface;
// filling surfaces related to inlet/outlet elbow parts
	l1 = -(lref2-12); l2 = lref4;     l3 = (lref2-10);  l4 = -(lref4+1);   Call fillWallSurface;
	l1 = -lref2;      l2 = lref4+1;   l3 = (lref2+1);   l4 = -(lref4+2);   Call fillWallSurface;
	l1 = lref2-11;    l2 = lref4+2;   l3 =-(lref2-9);   l4 = -(lref4+3);   Call fillWallSurface;
//
	l1 = (lref2-6);   l2 = lref4+5;   l3 =-(lref2-4);   l4 = -(lref4+4);   Call fillWallSurface;
	l1 = (lref2+3);   l2 = lref4+6;   l3 =-(lref2+4);   l4 = -(lref4+5);   Call fillWallSurface;
	l1 =-(lref2-5);   l2 = lref4+7;   l3 = (lref2-3);   l4 = -(lref4+6);   Call fillWallSurface;
// filling surfaces related to inlet/outlet extrusion parts
	l1 =-(lref2-10);  l2 = lref5;     l3 = (lref2-8);   l4 = -(lref5+1);   Call fillWallSurface;
	l1 =-(lref2+1);   l2 = lref5+1;   l3 = (lref2+2);   l4 = -(lref5+2);   Call fillWallSurface;
	l1 = (lref2-9);   l2 = lref5+2;   l3 =-(lref2-7);   l4 = -(lref5+3);   Call fillWallSurface;
//
	l1 = (lref2-4);   l2 = lref5+5;   l3 =-(lref2-2);   l4 = -(lref5+4);   Call fillWallSurface;
	l1 = (lref2+4);   l2 = lref5+6;   l3 =-(lref2+5);   l4 = -(lref5+5);   Call fillWallSurface;
	l1 =-(lref2-3);   l2 = lref5+7;   l3 = (lref2-1);   l4 = -(lref5+6);   Call fillWallSurface;

Return

Function fan2 // for the symmetric face
// outlet channels
	pref3=newp; Printf("pref3 =%g", pref3);
	x_outlet1 = x2 + (x_outlet-x2/Cos(Pi/16));
	Point(newp) = {x_outlet1,  h_peripheral/2-dh_inlet, 	  0, 1.0};
	Point(newp) = {x_outlet1,  h_peripheral/2-dh_inlet+h_bl,  0, 1.0}; 	Line(newl) = {pref3  ,pref3+1};
	Point(newp) = {x_outlet1,  h_peripheral/2-h_bl, 		  0, 1.0};          
	Point(newp) = {x_outlet1,  h_peripheral/2, 				  0, 1.0};  Line(newl) = {pref3+3,pref3+2};

	Point(newp) = {x_outlet1, h_peripheral/2-dh_inlet-0.15, 0, 1.0}; // center of the arch
	height1 = h_peripheral/2-dh_inlet-0.15;
	pref4=newp; Printf("pref4 =%g", pref4);
	xchan1 = (x_outlet1+0.15);
	xchan2 = (x_outlet1+0.15+h_bl);
	xchan3 = (x_outlet1+0.15+dh_inlet-h_bl);
	xchan4 = (x_outlet1+0.15+dh_inlet);
	Point(newp) = {xchan1, 	height1, 0, 1.0};
	Point(newp) = {xchan2, 	height1, 0, 1.0};	Line(newl) = {pref4  ,pref4+1};
	Point(newp) = {xchan3, 	height1, 0, 1.0};
	Point(newp) = {xchan4, 	height1, 0, 1.0};	Line(newl) = {pref4+3,pref4+2};

	height2 = height1-h_extru;
	Point(newp) = {xchan1, 	height2, 0, 1.0};
	Point(newp) = {xchan2, 	height2, 0, 1.0};	Line(newl) = {pref4+4,pref4+5};
	Point(newp) = {xchan3, 	height2, 0, 1.0};
	Point(newp) = {xchan4, 	height2, 0, 1.0};	Line(newl) = {pref4+7,pref4+6};

// inlet part
	pref5=newp; Printf("pref5 =%g", pref5);
	Point(newp) = {x_outlet1, -(h_peripheral/2-dh_inlet), 	  0, 1.0};    	
	Point(newp) = {x_outlet1, -(h_peripheral/2-dh_inlet+h_bl), 0, 1.0};	Line(newl) = {pref5  ,pref5+1};
	Point(newp) = {x_outlet1, -(h_peripheral/2-h_bl), 		  0, 1.0};			
	Point(newp) = {x_outlet1, -(h_peripheral/2), 			  0, 1.0};	Line(newl) = {pref5+3,pref5+2};

	Point(newp) = {x_outlet1, -(h_peripheral/2-dh_inlet-0.15), 0, 1.0}; // center of the arch
	height3 = -height1;
	pref6=newp; Printf("pref6 =%g", pref6);
	Point(newp) = {xchan1, 	height3, 0, 1.0};
	Point(newp) = {xchan2, 	height3, 0, 1.0}; 	Line(newl) = {pref6  ,pref6+1};
	Point(newp) = {xchan3, 	height3, 0, 1.0};
	Point(newp) = {xchan4, 	height3, 0, 1.0};	Line(newl) = {pref6+3,pref6+2};
	
	height4 = -(height1-h_extru2);
	Point(newp) = {xchan1, 	height4, 0, 1.0};
	Point(newp) = {xchan2, 	height4, 0, 1.0};	Line(newl) = {pref6+4,pref6+5};
	Point(newp) = {xchan3, 	height4, 0, 1.0};
	Point(newp) = {xchan4, 	height4, 0, 1.0};	Line(newl) = {pref6+7,pref6+6};
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
	l1 = -(lref1+4);  l2 = lref3;     l3 = (lref2-12);  l4 = -(lref3+1);   Call fillSymSurface; 
	l1 = -(lref1+7);  l2 = lref3+1;   l3 = lref2;       l4 = -(lref3+2);   Call fillSymSurface;
	l1 = lref1+5;     l2 = lref3+2;   l3 = -(lref2-11); l4 = -(lref3+3);   Call fillSymSurface;

	l1 = lref1;  	  l2 = lref3+5;   l3 =-(lref2-6);   l4 = -(lref3+4);   Call fillSymSurface;
	l1 = lref1+8;     l2 = lref3+6;   l3 =-(lref2+3);   l4 = -(lref3+5);   Call fillSymSurface;
	l1 =-(lref1+6);   l2 = lref3+7;   l3 = (lref2-5);   l4 = -(lref3+6);   Call fillSymSurface;
// filling surfaces related to inlet/outlet elbow parts
	l1 = -(lref2-12); l2 = lref4;     l3 = (lref2-10);  l4 = -(lref4+1);   Call fillSymSurface;
	l1 = -lref2;      l2 = lref4+1;   l3 = (lref2+1);   l4 = -(lref4+2);   Call fillSymSurface;
	l1 = lref2-11;    l2 = lref4+2;   l3 =-(lref2-9);   l4 = -(lref4+3);   Call fillSymSurface;

	l1 = (lref2-6);   l2 = lref4+5;   l3 =-(lref2-4);   l4 = -(lref4+4);   Call fillSymSurface;
	l1 = (lref2+3);   l2 = lref4+6;   l3 =-(lref2+4);   l4 = -(lref4+5);   Call fillSymSurface;
	l1 =-(lref2-5);   l2 = lref4+7;   l3 = (lref2-3);   l4 = -(lref4+6);   Call fillSymSurface;
// filling surfaces related to inlet/outlet extrusion parts
	l1 =-(lref2-10);  l2 = lref5;     l3 = (lref2-8);   l4 = -(lref5+1);   Call fillSymSurface;
	l1 =-(lref2+1);   l2 = lref5+1;   l3 = (lref2+2);   l4 = -(lref5+2);   Call fillSymSurface;
	l1 = (lref2-9);   l2 = lref5+2;   l3 =-(lref2-7);   l4 = -(lref5+3);   Call fillSymSurface;

	l1 = (lref2-4);   l2 = lref5+5;   l3 =-(lref2-2);   l4 = -(lref5+4);   Call fillSymSurface;
	l1 = (lref2+4);   l2 = lref5+6;   l3 =-(lref2+5);   l4 = -(lref5+5);   Call fillSymSurface;
	l1 =-(lref2-3);   l2 = lref5+7;   l3 = (lref2-1);   l4 = -(lref5+6);   Call fillSymSurface; 

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
	Call fan2;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
Return 

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
	Call fan;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
	Rotate {{0,1,0}, {x4,y4,0}, Pi/16} { Point{pref_beg:pref_end}; }

	// Call printEntities;
	pref_beg=newp; Printf("pref_beg =%g", pref_beg);
	Call fan;
	pref_end=newp-1; Printf("pref_end =%g", pref_end);
	Rotate {{0,1,0}, {x4,y4,0}, -Pi/16} { Point{pref_beg:pref_end}; }

Return 

Function externalChan // creating channnels outside the core
	lref7=newl; Printf("lref7 =%g", lref7); 
	For iedge In {pref:pref2+3:1} // for the curved wall part 
		Line(newl) = {iedge-41,iedge};
	EndFor
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
	pdelta=0; If(iflip==1) pdelta=-26; EndIf
	For iedge In {pref3+pdelta:pref3+pdelta+3:1}
		Line(newl) = {iedge-41,iedge};
	EndFor
	For iedge In {pref4+pdelta:pref4+pdelta+7:1}
		Line(newl) = {iedge-41,iedge};
	EndFor

	// patches between outlet necks and elbows
	ldelta4=97; If(iflip==1) ldelta4=59; EndIf
	ldelta5=0; If(iflip==1) ldelta5=42; EndIf
	sref3=startSurface+1; Printf("sref3 =%g", sref3);
	l1 = lref8;		l2 = lref1+9;		l3 = -(lref8+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+1;	l2 = lref2-ldelta5;			l3 = -(lref8+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = -(lref1+10);	l3 = -(lref8+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7+4;	l2 = lref3-ldelta5;			l3 = -(lref7+14);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+9;	l2 = (lref3-ldelta5+1);		l3 = -(lref7+15);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+11;	l2 = (lref3-ldelta5+2);		l3 = -(lref7+16);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+10;	l2 = (lref3-ldelta5+3);		l3 = -(lref7+17);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between outlet elbows and extrusions	
	l1 = lref8+4;	l2 = lref1+11;		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+5;	l2 = lref2-ldelta5+1;		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = -(lref1+12);	l3 = -(lref8+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref8;		l2 = lref4-ldelta5;			l3 = -(lref8+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+1;	l2 = (lref4-ldelta5+1);		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = (lref4-ldelta5+2);		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+3;	l2 = (lref4-ldelta5+3);		l3 = -(lref8+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// outlet face patches
	l1 = lref8+8;	l2 = lref1+13;		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+9;	l2 = lref2-ldelta5+2;		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+10;	l2 = -(lref1+14);	l3 = -(lref8+11);	l4 =(-l2-ldelta4);	Call fillOutletSurface;

	l1 = lref8+4;	l2 = lref5-ldelta5;			l3 = -(lref8+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+5;	l2 = (lref5-ldelta5+1);		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = (lref5-ldelta5+2);		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+7;	l2 = (lref5-ldelta5+3);		l3 = -(lref8+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

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
	For iedge In {pref5+pdelta:pref5+pdelta+3:1}
		Line(newl) = {iedge-41,iedge};
	EndFor
	For iedge In {pref6+pdelta:pref6+pdelta+7:1}
		Line(newl) = {iedge-41,iedge};
	EndFor		

	// patches between inlet necks and elbows
	sref4=startSurface+1; Printf("sref4 =%g", sref4);
	l1 = lref9;		l2 = lref1+15;		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+1;	l2 = lref2-ldelta5+3;		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = -(lref1+16);	l3 = -(lref9+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7;  	l2 = lref3-ldelta5+4;		l3 = -lref9;		l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+5;	l2 = (lref3-ldelta5+5);		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+13;	l2 = (lref3-ldelta5+6);		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+12;	l2 = (lref3-ldelta5+7);		l3 = -(lref9+3);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between inlet elbows and extrusions	
	l1 = lref9+4;	l2 = lref1+17;		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+5;	l2 = lref2-ldelta5+4;		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = -(lref1+18);	l3 = -(lref9+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref9;		l2 = lref4-ldelta5+4;		l3 = -(lref9+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+1;	l2 = (lref4-ldelta5+5);		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = (lref4-ldelta5+6);		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+3;	l2 = (lref4-ldelta5+7);		l3 = -(lref9+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// inlet face patches
	l1 = lref9+8;	l2 = lref1+19;		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+9;	l2 = lref2-ldelta5+5;		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+10;	l2 = -(lref1+20);	l3 = -(lref9+11);	l4 =(-l2-ldelta4);	Call fillInletSurface;

	l1 = lref9+4;	l2 = lref5-ldelta5+4;		l3 = -(lref9+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+5;	l2 = (lref5-ldelta5+5);		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = (lref5-ldelta5+6);		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+7;	l2 = (lref5-ldelta5+7);		l3 = -(lref9+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

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

Function externalChan2 // creating channnels outside the core
	lref7=newl; Printf("lref7 =%g", lref7); 
	For iedge In {pref:pref2+3:1} // for the curved wall part 
		Line(newl) = {iedge-67,iedge};
	EndFor
	ldelta3=139; If(iflip==1) ldelta3=59; EndIf

	sref1=startSurface+1; Printf("sref1 =%g", sref1);
	For iface In {0:4:1} // boundary layer faces along the curved wall
		l1 = -(lref7+iface);	l2 = lref1+iface-ldelta3;	l3 = lref7+5+iface;			l4 = -(lref1+iface);	Call fillSurface;
	EndFor

	For iface In {0:3:1} // patches of the curved wall
		l1 = (lref+iface);		l2 = -(lref7+1+iface);		l3 = -(l1-ldelta3); 	 	l4 = lref7+iface;		Call fillWallSurface;
		l1 = (lref+iface+4);	l2 = -(lref7+6+iface);		l3 = -(l1-ldelta3); 		l4 = lref7+iface+5;		Call fillSurface;
	EndFor

	sdelta=99; If(iflip==1) sdelta=22; EndIf
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
	pdelta=0; If(iflip==1) pdelta=-26; EndIf
	For iedge In {pref3+pdelta:pref3+pdelta+3:1}
		Line(newl) = {iedge-41,iedge};
	EndFor
	For iedge In {pref4+pdelta:pref4+pdelta+7:1}
		Line(newl) = {iedge-41,iedge};
	EndFor

	// patches between outlet necks and elbows
	ldelta4=97; If(iflip==1) ldelta4=59; EndIf
	ldelta5=0; If(iflip==1) ldelta5=42; EndIf
	sref3=startSurface+1; Printf("sref3 =%g", sref3);
	l1 = lref8;		l2 = lref1+9;		l3 = -(lref8+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+1;	l2 = lref2-ldelta5;			l3 = -(lref8+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = -(lref1+10);	l3 = -(lref8+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7+4;	l2 = lref3-ldelta5;			l3 = -(lref7+14);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+9;	l2 = (lref3-ldelta5+1);		l3 = -(lref7+15);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+11;	l2 = (lref3-ldelta5+2);		l3 = -(lref7+16);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+10;	l2 = (lref3-ldelta5+3);		l3 = -(lref7+17);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between outlet elbows and extrusions	
	l1 = lref8+4;	l2 = lref1+11;		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+5;	l2 = lref2-ldelta5+1;		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = -(lref1+12);	l3 = -(lref8+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref8;		l2 = lref4-ldelta5;			l3 = -(lref8+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+1;	l2 = (lref4-ldelta5+1);		l3 = -(lref8+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+2;	l2 = (lref4-ldelta5+2);		l3 = -(lref8+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+3;	l2 = (lref4-ldelta5+3);		l3 = -(lref8+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// outlet face patches
	l1 = lref8+8;	l2 = lref1+13;		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+9;	l2 = lref2-ldelta5+2;		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillOutletSurface;
	l1 = lref8+10;	l2 = -(lref1+14);	l3 = -(lref8+11);	l4 =(-l2-ldelta4);	Call fillOutletSurface;

	l1 = lref8+4;	l2 = lref5-ldelta5;			l3 = -(lref8+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref8+5;	l2 = (lref5-ldelta5+1);		l3 = -(lref8+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+6;	l2 = (lref5-ldelta5+2);		l3 = -(lref8+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref8+7;	l2 = (lref5-ldelta5+3);		l3 = -(lref8+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

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
	For iedge In {pref5+pdelta:pref5+pdelta+3:1}
		Line(newl) = {iedge-41,iedge};
	EndFor
	For iedge In {pref6+pdelta:pref6+pdelta+7:1}
		Line(newl) = {iedge-41,iedge};
	EndFor		

	// patches between inlet necks and elbows
	sref4=startSurface+1; Printf("sref4 =%g", sref4);
	l1 = lref9;		l2 = lref1+15;		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+1;	l2 = lref2-ldelta5+3;		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = -(lref1+16);	l3 = -(lref9+3);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref7;  	l2 = lref3-ldelta5+4;		l3 = -lref9;		l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref7+5;	l2 = (lref3-ldelta5+5);		l3 = -(lref9+1);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+13;	l2 = (lref3-ldelta5+6);		l3 = -(lref9+2);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref7+12;	l2 = (lref3-ldelta5+7);		l3 = -(lref9+3);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// patches between inlet elbows and extrusions	
	l1 = lref9+4;	l2 = lref1+17;		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+5;	l2 = lref2-ldelta5+4;		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = -(lref1+18);	l3 = -(lref9+7);	l4 =(-l2-ldelta4);	Call fillSurface;

	l1 = lref9;		l2 = lref4-ldelta5+4;		l3 = -(lref9+4);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+1;	l2 = (lref4-ldelta5+5);		l3 = -(lref9+5);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+2;	l2 = (lref4-ldelta5+6);		l3 = -(lref9+6);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+3;	l2 = (lref4-ldelta5+7);		l3 = -(lref9+7);	l4 =-(l2-ldelta4);	Call fillWallSurface;

	// inlet face patches
	l1 = lref9+8;	l2 = lref1+19;		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+9;	l2 = lref2-ldelta5+5;		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillInletSurface;
	l1 = lref9+10;	l2 = -(lref1+20);	l3 = -(lref9+11);	l4 =(-l2-ldelta4);	Call fillInletSurface;

	l1 = lref9+4;	l2 = lref5-ldelta5+4;		l3 = -(lref9+8);	l4 =-(l2-ldelta4);	Call fillWallSurface;
	l1 = lref9+5;	l2 = (lref5-ldelta5+5);		l3 = -(lref9+9);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+6;	l2 = (lref5-ldelta5+6);		l3 = -(lref9+10);	l4 =-(l2-ldelta4);	Call fillSurface;
	l1 = lref9+7;	l2 = (lref5-ldelta5+7);		l3 = -(lref9+11);	l4 =-(l2-ldelta4);	Call fillWallSurface;

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
Transfinite Curve {lref7:lref9+11}= n_Azi Using Progression ratio_Azi2;
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// back face
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
sref=startSurface+1; Printf("sref =%g", sref);
iflip = -1;
Call curvedWall;
pref_end=newp-1; Printf("pref_end =%g", pref_end);	
Rotate {{0,1,0}, {0,0,0}, -Pi/16} { Point{pcenter:pref_end}; }
Printf("***********face 3 completes**********");
Call externalChan2;
Transfinite Curve {lref7:lref9+11}= n_Azi Using Progression ratio_Azi1;

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
Transfinite Curve {lref11:lref11+4}= n_Azi Using Progression ratio_Azi2;
iedge=2;
Line(newl) = {pref7+iedge,   5};
Line(newl) = {pref7+iedge+3, 4};
Line(newl) = {pref7+iedge+6, 3};
Line(newl) = {pref7+iedge+9, 2};
Line(newl) = {pref7+iedge+12,1};
Transfinite Curve {lref11+5:lref11+9}= n_Azi Using Progression ratio_Azi1;

For iedge In {pref7+1:pref7+13:3} // for the curved wall part 
	Line(newl) = {iedge,iedge+1};
EndFor
iedge=0;
Line(newl) = {pref7+iedge,   5};
Line(newl) = {pref7+iedge+3, 4};
Line(newl) = {pref7+iedge+6, 3};
Line(newl) = {pref7+iedge+9, 2};
Line(newl) = {pref7+iedge+12,1};
Transfinite Curve {lref11+10:lref11+19}= n_Azi Using Progression ratio_Azi1;

// connecting interior points to the curved wall, part 1, not using pure pointers
lref12=newl; Printf("lref12 =%g", lref12); 
Line(newl) = {pref7+3,15}; 	Line(newl) = {pref7+6,14}; 	Line(newl) = {pref7+9,13};
Line(newl) = {133+26,56}; 		Line(newl) = {136+26,55}; 		Line(newl) = {139+26,54}; 
Line(newl) = {134+26,97+26}; 		Line(newl) = {137+26,96+26}; 		Line(newl) = {140+26,95+26}; 
Transfinite Curve {lref12:lref12+8}= n_width Using Progression 1;

lref13=newl; Printf("lref13 =%g", lref13);
Line(newl) = {pref7,17};
Line(newl) = {132+26,18}; 
Line(newl) = {135+26,132+26}; 
Line(newl) = {135+26,138+26};
Line(newl) = {138+26,20};
Line(newl) = {141+26,19};

Line(newl) = {130+26,58};
Line(newl) = {133+26,59};
Line(newl) = {136+26,133+26};
Line(newl) = {136+26,139+26};
Line(newl) = {139+26,61};
Line(newl) = {142+26,60};

Line(newl) = {131+26,99+26};
Line(newl) = {134+26,100+26};
Line(newl) = {137+26,134+26};
Line(newl) = {137+26,140+26};
Line(newl) = {140+26,102+26};
Line(newl) = {143+26,101+26};
Transfinite Curve {lref13:lref13+17}= n_curve Using Progression 1;

// filling faces can create fluid volumes now
l1 = 293+42;	l2 = 18;	l3 = -294-42;	l4 =-258-42;	Call fillSymSurface;
l1 = 299+42;	l2 = 77;	l3 = -300-42;	l4 =-259-42;	Call fillSurface;
l1 = 264+42;	l2 = 259+42;	l3 = -265-42;	l4 =-258-42;	Call fillSurface;
l1 = 293+42;	l2 = 133+42;	l3 = -299-42;	l4 =-264-42;	Call fillWallSurface;
l1 = 294+42;	l2 = 134+42;	l3 = -300-42;	l4 =-265-42;	Call fillSurface;
s1=185+18;		s2=186+18;		s3=187+18;		s4=59+18;		s5=188+18;		s6=189+18; 	Call fillVolume;

l1 = 294+42;	l2 = -20;	l3 = -12;	l4 =-284-42;	Call fillSymSurface;
l1 = 300+42;	l2 = -79;	l3 = -71;	l4 =-287-42;	Call fillSurface;
l1 = 284+42;	l2 = 131+42;	l3 = -287-42;	l4 =-265-42;	Call fillSurface;
s1=189+18;		s2=57+18;		s3=190+18;		s4=191+18;		s5=58+18;		s6=192+18; 	Call fillVolume;

l1 = 284+42;	l2 = -11;	l3 = -285-42;	l4 =295+42;	Call fillSymSurface;
l1 = 287+42;	l2 = -70;	l3 = -288-42;	l4 =301+42;	Call fillSurface;
l1 = 266+42;	l2 = 301+42;	l3 = -265-42;	l4 =-295-42;	Call fillSurface;
l1 = 285+42;	l2 = 130+42;	l3 = -288-42;	l4 =-266-42;	Call fillSurface;
s1=193+18;		s2=194+18;		s3=195+18;		s4=55+18;		s5=196+18;		s6=192+18; 	Call fillVolume;

l1 = 285+42;	l2 = -10;	l3 = -286-42;	l4 =-296-42;	Call fillSymSurface;
l1 = 288+42;	l2 = -69;	l3 = -289-42;	l4 =-302-42;	Call fillSurface;
l1 = 267+42;	l2 = -302-42;	l3 = -266-42;	l4 = 296+42;	Call fillSurface;
l1 = 286+42;	l2 = 129+42;	l3 = -289-42;	l4 = -267-42;	Call fillSurface;
s1=197+18;		s2=198+18;		s3=199+18;		s4=53+18;		s5=196+18;		s6=200+18; 	Call fillVolume;

l1 = 286+42;	l2 = -9;	l3 = 21;	l4 =-297-42;	Call fillSymSurface;
l1 = 289+42;	l2 = -68;	l3 = 80;	l4 =-303-42;	Call fillSurface;
l1 = 297+42;	l2 = 136+42;	l3 = -303-42;	l4 =-267-42;	Call fillSurface;
s1=201+18;		s2=202+18;		s3=203+18;		s4=51+18;		s5=200+18;		s6=60+18; 	Call fillVolume;

l1 = 297+42;	l2 = -19;	l3 = -298-42;	l4 = 261+42;	Call fillSymSurface;
l1 = 303+42;	l2 = -78;	l3 = -304-42;	l4 = 262+42;	Call fillSurface;
l1 = 298+42;	l2 = 135+42;	l3 = -304-42;	l4 =-268-42;	Call fillWallSurface;
l1 = 268+42;	l2 = 262+42;	l3 = -267-42;	l4 =-261-42;	Call fillSurface;
s1=204+18;		s2=205+18;		s3=206+18;		s4=203+18;		s5=61+18;		s6=207+18; 	Call fillVolume;

l1 = 305+42;	l2 = 174+42;	l3 = -306-42;	l4 = -260-42;	Call fillSymSurface;
l1 = 299+42;	l2 = 230+42;	l3 = -305-42;	l4 = -274-42;	Call fillWallSurface;
l1 = 300+42;	l2 = 231+42;	l3 = -306-42;	l4 = -275-42;	Call fillSurface;
l1 = 275+42;	l2 = -260-42;	l3 = -274-42;	l4 = 259+42;	Call fillSurface;
s1=208+18;		s2=186+18;		s3=209+18;		s4=210+18;		s5=140+18;		s6=211+18; 	Call fillVolume;

l1 = 306+42;	l2 = -176-42;	l3 = -168-42;	l4 = -290-42;	Call fillSymSurface;
l1 = 290+42;	l2 = -228-42;	l3 = -287-42;	l4 = 275+42;	Call fillSurface;
s1=212+18;		s2=191+18;		s3=210+18;		s4=138+18;		s5=213+18;		s6=139+18; 	Call fillVolume;

l1 = 290+42;	l2 = -167-42;	l3 = -291-42;	l4 = 307+42;	Call fillSymSurface;
l1 = 288+42;	l2 = 227+42;	l3 = -291-42;	l4 = -276-42;	Call fillSurface;
l1 = 276+42;	l2 = 307+42;	l3 = -275-42;	l4 = -301-42;	Call fillSurface;
s1=214+18;		s2=194+18;		s3=216+18;		s4=136+18;		s5=213+18;		s6=215+18; 	Call fillVolume;

l1 = 291+42;	l2 = -166-42;	l3 = -292-42;	l4 = -308-42;	Call fillSymSurface;
l1 = 289+42;	l2 = 226+42;	l3 = -292-42;	l4 = -277-42;	Call fillSurface;
l1 = 277+42;	l2 = -308-42;	l3 = -276-42;	l4 = 302+42;	Call fillSurface;
s1=217+18;		s2=198+18;		s3=219+18;		s4=134+18;		s5=218+18;		s6=215+18; 	Call fillVolume;

l1 = 292+42;	l2 = -165-42;	l3 = 177+42;	l4 = -309-42;	Call fillSymSurface;
l1 = 303+42;	l2 = 233+42;	l3 = -309-42;	l4 = -277-42;	Call fillSurface;
s1=220+18;		s2=202+18;		s3=221+18;		s4=132+18;		s5=218+18;		s6=141+18; 	Call fillVolume;

l1 = 309+42;	l2 = -175-42;	l3 = -310-42;	l4 = 263+42;	Call fillSymSurface;
l1 = 304+42;	l2 = 232+42;	l3 = -310-42;	l4 = -278-42;	Call fillWallSurface;
l1 = 278+42;	l2 = 263+42;	l3 = -277-42;	l4 = -262-42;	Call fillSurface;
s1=222+18;		s2=205+18;		s3=223+18;		s4=221+18;		s5=142+18;		s6=224+18; 	Call fillVolume;

l1 = 279+42;	l2 = -269-42;	l3 = -274-42;	l4 = -264-42;	Call fillWallSurface;
l1 = 280+42;	l2 = -270-42;	l3 = -275-42;	l4 = -265-42;	Call fillSurface;
l1 = 279+42;	l2 = 2;	l3 = -280-42;	l4 = -258-42;	Call fillSymSurface;
l1 = 269+42;	l2 = 2;	l3 = -270-42;	l4 = -260-42;	Call fillSymSurface;
s1=225+18;		s2=226+18;		s3=227+18;		s4=211+18;		s5=228+18;		s6=187+18; 	Call fillVolume;

l1 = 280+42;	l2 = 4;	l3 = -281-42;	l4 = 295+42;	Call fillSymSurface;
l1 = 270+42;	l2 = 4;	l3 = -271-42;	l4 = 307+42;	Call fillSymSurface;
l1 = 281+42;	l2 = -271-42;	l3 = -276-42;	l4 = -266-42;	Call fillSurface;
s1=229+18;		s2=216+18;		s3=230+18;		s4=195+18;		s5=226+18;		s6=231+18; 	Call fillVolume;

l1 = 281+42;	l2 = -3;	l3 = -282-42;	l4 = -296-42;	Call fillSymSurface;
l1 = 271+42;	l2 = -3;	l3 = -272-42;	l4 = -308-42;	Call fillSymSurface;
l1 = 282+42;	l2 = -272-42;	l3 = -277-42;	l4 = -267-42;	Call fillSurface;
s1=232+18;		s2=219+18;		s3=233+18;		s4=199+18;		s5=234+18;		s6=231+18; 	Call fillVolume;

l1 = 282+42;	l2 = -1;	l3 = -283-42;	l4 = 261+42;	Call fillSymSurface;
l1 = 272+42;	l2 = -1;	l3 = -273-42;	l4 = 263+42;	Call fillSymSurface;
l1 = 283+42;	l2 = -273-42;	l3 = -278-42;	l4 = -268-42;	Call fillWallSurface;
s1=235+18;		s2=224+18;		s3=236+18;		s4=207+18;		s5=234+18;		s6=237+18; 	Call fillVolume;

Transfinite Surface "*"; 
Recombine Surface "*";
Physical Surface("Symmetry", 4) = sym[];
Physical Surface("Wall", 3) = wall[];
Physical Surface("Outlet", 2) = outlet[];
Physical Surface("Inlet", 1) = inlet[];

Physical Volume("Fluid", 5) = fluid[];
Transfinite Volume "*";//+

//+
Show "*";
