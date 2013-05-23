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
  location  <30, 0, 0>
  look_at   <0, 0, 0>
  angle 45
}                              
//Declare light sources
light_source { <+15, 0, 0> White }

//---Mathematical form of gaussian beam intensity distribution---:  
//---See readme for sources--
//Beam parameters:
#declare lamda = 0.400; //wavelength (for propagation properties, not colour)
#declare k = 2*3.14159/lamda; //wavenumber 
#declare I_0 = 1;             //intensity (doesn't work properly, leave as 1) 
                              //-> real intensity is changed with the `emission'...
                              //-> ...declaration in the object definition below
#declare w_0 = 1;             //beam waist        
#declare phi_0 = 0;           //longitudinal phase of beam at origin

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


//---Object declarations---
//Plain old gaussian beam    
//Transparent cylinder is the `container' for our beam
cylinder {
  <0,0,-20>,<0,0,20>,2
  pigment {rgbt 1}  //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <0,0,0.3>  //intensity/colour of beam, bit buggy, just play with it
      density {
	function{ gaussian_beam(x,y,x) } //density of emissive media is our function	
      }
    } // end of media ---
  } // end of interior
  translate +6*y
}

//gaussian beam with wavefronts  
//Transparent cylinder is the `container' for our beam
cylinder {
  <0,0,-20>,<0,0,20>,2
  pigment {rgbt 1} //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <0,0,0.3>  //intensity/colour of beam, bit buggy, just play with it
      density {
	function{ gaussian_beam(x,y,z)*wavefronts(x,y,z) } //density of emissive media is our function
      }
    } // end of media ---
  } // end of interior
  translate +2*y
  rotate <0,0,0>
}

//TEM 01 mode
//Transparent cylinder is the `container' for our beam
cylinder {
  <0,0,-20>,<0,0,20>,2
  pigment {rgbt 1} //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <0,0,0.3>  //intensity/colour of beam, bit buggy, just play with it
      density {
	function{ TEM_01(x,y,z)*gaussian_beam(x,y,z)*wavefronts(x,y,z) } //density of emissive media is our function
      }
    } // end of media ---
  } // end of interior
  translate -2*y
  rotate <0,0,0>
}   

//TEM 11 mode
//Transparent cylinder is the `container' for our beam
cylinder {
  <0,0,-20>,<0,0,20>,2
  pigment {rgbt 1} //transparency
  hollow
  interior{ //-- This is where the magic happens, see povray documentation
    media{
      emission <0,0,0.3>  //intensity/colour of beam, bit buggy, just play with it
      density {
	function{ TEM_11(x,y,z)*gaussian_beam(x,y,z)*wavefronts(x,y,z) } //density of emissive media is our function
      }
    } // end of media ---
  } // end of interior 
  rotate <0,0,40> 
  translate -6*y   
}
