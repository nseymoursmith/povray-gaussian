#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"

global_settings { ambient_light rgb<1,1,1> }

background { color Gray50 }
camera {
  location  <100, 0, 0>
  look_at   <0, 0, 0>
  angle 45
}
light_source { <+15, 0, 0> White }

//Mathematical form of gaussian beam intensity distribution:
#declare lamda = 0.400;
#declare k = 2*3.14159/lamda;
#declare I_0 = 1;
#declare w_0 = 10;
#declare z_r = pow(w_0,2)*3.14159/lamda;

#declare w_z = function {
  w_0*sqrt(1+pow((z/z_r),2))
}

#declare r_squared = function {
  (pow(x,2)+pow(y,2))
}

#declare R_z =  function {
  z*(1+pow(z_r/z, 2))
}

#declare guoy_phase = function {
  atan(z/z_r)
}

#declare gaussian_intensity = function { 
  I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) ) 
}

cylinder {
  <0,0,-200>,<0,0,200>,40
  pigment {rgbt 1}
  hollow
  interior{ //-----------
    media{
      emission <0,0,0.03>
      density {
	function{ I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) ) }	
      }
    } // end of media ---
  } // end of interior
//  translate +2*y
}

#declare lens_1 = <1,0,0.2,1>; //<A,B,C,D> (propagation matrix elements)
#declare q_0 = z_0;

#declare polar_amplitude = function(v1,v2) {
  sqrt(pow(v1,2) + pow(v2,2))
}

#declare polar_phase = function(v1,v2) {
  atan2(v2,v1)
}

#declare cartesian_1 = function(r, theta) {
  r*cos(theta)
}

#declare cartesian_2 = function(r, theta) {
  r*sin(theta)
}

#declare q_Re = function(q_Re,q_Im) {
  A*polar_amplitude(q_Re,q_Im)
}

// cylinder {
//   <0,0,-20>,<0,0,20>,2
//   pigment {rgbt 1}
//   hollow
//   interior{ //-----------
//     media{
//       emission <0,0,0.3>
//       density {
// 	function{ I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) )*pow(sin(-k*(z+r_squared(x,y,z)/(2*R_z(x,y,z)))+guoy_phase(x,y,z)),2)*(4*pow(y,2)) }
//       }
//     } // end of media ---
//   } // end of interior
//   translate -2*y
//   rotate <0,0,0>
// }

//object{ standing_wave scale 0.48 rotate <0,90,0> translate -2*y}
