#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"

global_settings { ambient_light rgb<1,1,1> }

background { color Gray50 }
camera {
  location  <0,0,15>
  look_at   <0, 0, 0>
  angle 45
}
light_source { <0, 50, -200> White }

//Mathematical form of gaussian beam intensity distribution:
#declare lamda = 1;
#declare k = 2*3.14159/lamda;
#declare I_0 = 1;
#declare w_0 = 1.5;
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

#declare TEM_00 = function { 
  I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) )*pow(sin(-k*(z+r_squared(x,y,z)/(2*R_z(x,y,z)))+guoy_phase(x,y,z) + pi/2),2) 
}

#declare TEM_01 = function { 
  I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) )*4*pow(y,2)*pow(sin(-k*(z+r_squared(x,y,z)/(2*R_z(x,y,z)))+guoy_phase(x,y,z) + pi/2),2)
}

cylinder {
  <0,0,-20>,<0,0,20>,11
  pigment {rgbt 1}
  hollow
  interior{ //-----------
    media{
      emission <0.1,0,0>
      intervals 10
      density {
	function{ TEM_01(x,y,z) } 
	warp{turbulence 0.2}
      }                   
    } // end of media ---
  } // end of interior
//  translate +2*y
  rotate <0,90,0>
}

// cylinder {
//   <0,0,-20>,<0,0,20>,100
//   pigment {rgbt 1}
//   hollow
//   interior{// -----------
//     media{
//       emission <0.3,0,0>
//       density {
// 	function{ I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) )*pow(sin(-k*(z+r_squared(x,y,z)/(2*R_z(x,y,z)))+guoy_phase(x,y,z)),2) }
//       }
//     } //end of media ---
//   } //end of interior
// //  translate -2*y
//   rotate <0,90,0>
// }

#declare Substrate = merge {
  cylinder {
    <-2,0,0>, <2,0,0>,1
//    pigment { Blue }
  }

  cone {
    <-4,0,0>, 0 //centre and radius one
    <-1.999,0,0>, 1 //centre and radius 2
//    pigment{ Blue }
  }
//  pigment {Blue filter .5}
}

#declare cavity_mirror = difference {
  object {
    Substrate
  }
  sphere {
    <-7.5,0,0>, 4
//    pigment {Blue filter .5}
  }
  hollow
  material{
    texture {
      pigment{ colour rgbt<1,1,1,0.5>}
      finish {phong .5}    
    }
    interior{
      ior 1.5
//      caustics 0.25
    }
  }
//  pigment {Col_Glass_Bluish}

//  finish {F_Glass10}
}       

#declare ion = sphere{
    <0,0,0>, 1
    pigment{rgbt 1}
    hollow
  interior{ //-----------
    media{
      emission <2,0,3>
      //   intervals 1
      //  scattering{1,<1,1,1>}
      density{ spherical
	turbulence 0
	// color_map {
	  //  [0 rgb 0.0]//border
	  //  [1 rgb 1.0]//center
	  //  } // end color_map
      } // end of density
    } // end of media ---
  } // end of interior
  translate <0,0.00,0>
} //----- end of sphere

#declare ion_string = union{
  object { ion scale 0.15 translate <1.2,0,0> }
  object { ion scale 0.15 translate <0.0,0,0> }
  object { ion scale 0.15 translate <-1.2,0,0> }
  scale 1
}

object { cavity_mirror scale 11 translate 40*x rotate <0,0,0> }
object { cavity_mirror scale 11 rotate <0,180,0> translate -40*x}  
object { ion_string rotate <0,0,90>}
