#include "colors.inc"
#include "textures.inc"
#include "glass.inc"
#include "math.inc"

//Ambient light  just in case
global_settings { ambient_light rgb<1,1,1> }

//Colour of the far distance
background { color Gray50 } 
//Camera location and direction
camera {
  location  <0,0,15>
  look_at   <0, 0, 0>
  angle 45
}       
//Declare light sources
light_source { <0, 50, -200> White }

//Mathematical form of gaussian beam intensity distribution: 
//---See readme for sources--
//Beam parameters:
#declare lamda = 1; //wavelength (for propagation properties, not colour)
#declare k = 2*3.14159/lamda; //wavenumber 
#declare I_0 = 1;             //intensity (doesn't work properly, leave as 1) 
                              //-> real intensity is changed with the `emission'...
                              //-> ...declaration in the object definition below
#declare w_0 = 1.5;             //beam waist        
#declare phi_0 = pi/2;           //longitudinal phase of beam at origin  

//--Functions--:   
//Radial coordinate
#declare r_squared = function {
  (pow(x,2)+pow(y,2))
}

//Rayleigh range
#declare z_r = pow(w_0,2)*3.14159/lamda;

//Beam diameter as a function of z
#declare w_z = function {
  w_0*sqrt(1+pow((z/z_r),2))
}

//Radius of curvature of the wavefront as a function of z
#declare R_z =  function {
  z*(1+pow(z_r/z, 2))
}

//guoy phase as a function of z
#declare guoy_phase = function {
  atan(z/z_r)
}        

//Basic gaussian beam
#declare gaussian_beam = function { 
  I_0*pow( w_0/w_z(x,y,z), 2 )*exp( -2*r_squared(x,y,z)/pow( w_z(x,y,z), 2 ) ) 
}

//-transverse mode functions-
//TEM_00
#declare TEM_00 = 1;

//TEM_01
#declare TEM_01 = function {
  4*pow(y,2)
}

//TEM_11
#declare TEM_11 = function {
  4*pow(x,2)*4*pow(y,2)
}

//Longitudinal wavefront properties 
#declare wavefronts = function {
  pow(sin(-k*(z+r_squared(x,y,z)/(2*R_z(x,y,z)))+guoy_phase(x,y,z) + phi_0),2)  
}

//---Object declarations ---
//Transparent cylinder is the `container' for our beam
cylinder {
  <0,0,-20>,<0,0,20>,11
  pigment {rgbt 1}   //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <0.1,0,0>  //intensity/colour of beam, bit buggy, just play with it
      intervals 10        //Number of evaluations of the function.. I think
      density {
	function{ TEM_01(x,y,z)*gaussian_beam(x,y,z)*wavefronts(x,y,z) }  //density of emissive media is our function
	//warp{turbulence 0.1} //Add turbulence if you're in the mood ...
      }                   
    } // end of media ---
  } // end of interior
//  translate +2*y
  rotate <0,90,0>
}

//`Ions' can be drawn similarly to above, but with a sphere as container
//and one of the standard density functions to give us that nice 
//"glowing point of light" feel.
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
      } // end of density
    } // end of media ---
  } // end of interior
  translate <0,0.00,0>
} //----- end of sphere  

//Ion string is just three of them put together
#declare ion_string = union{
  object { ion scale 0.15 translate <1.2,0,0> }
  object { ion scale 0.15 translate <0.0,0,0> }
  object { ion scale 0.15 translate <-1.2,0,0> }
  scale 1
}

//Cavity mirrors are constructed in the standard CSG manner
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


//Whack 'em in your picture for fun and profit.
object { cavity_mirror scale 11 translate 40*x rotate <0,0,0> }
object { cavity_mirror scale 11 rotate <0,180,0> translate -40*x}  
object { ion_string rotate <0,0,90>}
