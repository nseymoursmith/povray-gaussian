#include "colors.inc"
#include "textures.inc"
#include "glass.inc"

global_settings { ambient_light rgb<0,0,0> }

background { color Gray50 }
camera {
  location  <5, 5, -15>
  look_at   <0, 0, 0>
  angle 25
}
light_source { <0, 0, -15> White }

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
  object { ion scale 0.15 translate <0.5,0,0> }
  object { ion scale 0.15 translate <0.0,0,0> }
  object { ion scale 0.15 translate <-0.5,0,0> }
}

#declare wave_node = merge {
  sphere { 
    <0,0,0>, 1
//    pigment{colour Red}
  } // end of sphere
  cone {
    <0.707,0,0>,0.707
    <1.5,0,0>,0
//    pigment{colour Red}
  } // end of cone 1
  cone {
    <-0.707,0,0>,0.707
    <-1.5,0,0>,0
//    pigment{colour Red}
  } // end of cone 2
} //end of merge

#declare standing_wave = merge {
  object {
    wave_node 
    translate 1*1.414*x
  }
  object {
    wave_node 
    translate 3*1.414*x
  }
  object {
    wave_node 
    translate -1*1.414*x
  }
  object {
    wave_node 
    translate -3*1.414*x
  }
  pigment {rgbt 1}
  hollow
  interior{ //-----------
    media{
      emission <0.6,0,0>
      //   intervals 1
      //  scattering{1,<1,1,1>}
      // density{ spherical
      // 	turbulence 0
      // 	// color_map {
      // 	  //  [0 rgb 0.0]//border
      // 	  //  [1 rgb 1.0]//center
      // 	  //  } // end color_map
      // } // end of density
    } // end of media ---
  } // end of interior

}

// cylinder {
//   <-1,0,0>,<1,0,0>,0.1 
//   pigment {rgbt 1}
//   hollow
//   interior{ //-----------
//     media{
//       emission <1.5,0,0>
//       //   intervals 1
//       //  scattering{1,<1,1,1>}
//       density{ cylindrical
// 	turbulence 0
// 	// color_map {
// 	  //  [0 rgb 0.0]//border
// 	  //  [1 rgb 1.0]//center
// 	  //  } // end color_map
// 	rotate <0,0,90>
//       } // end of density
//     } // end of media ---
//   } // end of interior      
//   translate -3*x
// } //end of cylinder


object { cavity_mirror translate 5.5*x rotate <0,0,0> }
object { cavity_mirror rotate <0,180,0> translate -5.5*x}
object { ion_string rotate <0,0,0>}
object{ standing_wave scale 0.37 }

// light_source {<-0.5,0,0> Blue}
// light_source {<0,0,0> Blue}
// light_source {<0.5,0,0> Blue}