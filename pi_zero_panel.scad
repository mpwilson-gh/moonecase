

// begin pi_zero_panel.scad


// Seems silly to have to add this parameter every time. 
// But I also wish I could programmatically override it.
// But...you know...immutability and all. (feh.)
DefaultRiserHeight = 6;

/*
include <globals.scad>

// Raspberry Pi Zero dimensions (standard 58 mm x 23 mm)
pi_zero_width = 58;
pi_zero_depth = 23;
pi_zero_height = 1.5;  // Thickness of the Pi Zero


// Riser parameters
riser_height = 10;  // Height of the risers
riser_diameter = 6;  // Diameter of the risers
pi_hole_diameter = 2.5;  // Diameter of the Pi mounting holes

// Base plate dimensions (aligned with global wall_thickness)
base_plate_thickness = Thickness;  // Use global wall thickness
base_plate_width = pi_zero_width + 7;   // Add 7 mm for offsets (3.5 mm on each side)
base_plate_depth = pi_zero_depth + 7;   // Add 7 mm for offsets (3.5 mm on each side)

*/


// This will be fun.


// Wait!  58 x 23 was the reported dimensions of the 0 before.  Now the innert00bz is saying
//        it's 66 x 30.5 x 5.0
// I'm going to experiment with those.  But keep this comment, just in case.

// 4 × M2.5 mounting holes

/*
Raspberry Pi 3 Model B+	85 x 56 x 17
Raspberry Pi 3 Model B	85 x 56 x 17
Raspberry Pi 2	85 x 56
Raspberry Pi B+	85 x 56
Raspberry Pi Zero & Zero W	65 x 30
Raspberry Pi Model A+	65 x 56 x 12
Raspberry Pi Model B & Model A	85 x 56
Raspberry Pi Camera Module v1 & v2	25 x 24 x 9

Raspberry Pi Zero 2	65 x 30
Raspberry Pi 4 Model B	85 x 56
Raspberry Pi 5	
----

openings for the pi zero 2. But it's proving...cumbersome.

Designing port openings can definitely be tricky, especially when you want everything to fit perfectly. For the Raspberry Pi Zero 2, here are the key port dimensions you'll need:

    Micro USB Power Port: 5 mm x 5 mm

    Micro USB Data Port: 5 mm x 5 mm

    Mini HDMI Port: 10 mm x 10 mm

    40-pin GPIO Header: 40 mm x 20 mm (standard pin spacing is 2.54 mm)

    Camera Connector: 10 mm x 10 mm

    MicroSD Card Slot: 15 mm x 10 mm

Would you like any specific advice on how to incorporate these into your OpenSCAD design, or do you need help with something else?
*/

// This returns the following tuple:
// length_x, width_y, thickness



function get_pi_dims(which_pi) = 
    which_pi == "pi_zero_two" ? [65, 30, 5] : 
    which_pi == "pi_five" ? [55, 40, 4.7] : 
    undef;

// Different pis put their "power" usb jack in 
// different places (so far on the same side.)
// This isn't just a matter of scaling.  Check 
// out the Pi 0 and Pi 5 diagrams to see what 
// I mean.

function get_pi_power_usb_offset(which_pi) = 
    which_pi == "pi_zero_two" ? 54 :
    which_pi == "pi_five" ? 11.2 : undef;



// This won't work.  The 5, for instance, has mounting holes in different relative positions
// It's not just a matter of "scalar offset."  I'm going to have to iterate through them
// all for the complex case.
// Dammit.  These holes are 3.5 inset on the zero 2, not 3.  And they're drilled out at 2.75 +/-.

// Inset from case, hole diameter (literal), "pad clearance" ( - 1 to get riser post outer diameter)
function get_pi_mounting_hole_dims(which_pi) =
    which_pi == "pi_zero_two" ? [3.5,2.75,6] : 
    which_pi == "pi_five" ? [5,3,6] :
    undef;

// how much larger should the cutout be than the underlying panel?  
// SHOULD be zero.  But I know better.  MM.
function get_pipanel_cutout_oversize() = 0.2;

function get_pipanel_riser_height() = DefaultRiserHeight;
function get_pipanel_cutout_thickness(wall_thickness) = wall_thickness + get_pipanel_cutout_oversize();

// For now it's 1:1 pcb size to panel dimensions.
function get_pipanel_length_x(which_pi) = get_pi_dims(which_pi)[0];
function get_pipanel_width_y(which_pi)  = get_pi_dims(which_pi)[1];

module pi_zero_cutout (which_pi,wall_thickness) {
    dimensions = get_pi_dims(which_pi);
    length_x  = dimensions[0];
    width_y   = dimensions[1];
    thickness = get_pipanel_cutout_thickness(wall_thickness);

    // That +2 is "cutout addition" which is awful.
    cube([length_x,width_y,thickness]);
}

module pi_post_riser(which_pi,riser_height)
{
    pmh_d = get_pi_mounting_hole_dims(which_pi);
    hole_inset = pmh_d[0];
    hole_diameter = pmh_d[1];
    riser_diameter = pmh_d[2];

    post_hole_diameter = hole_diameter - 0.3; // hole is 2.75.  Screw is 2.5.  0.2 undersized seems the right play.

    difference() 
    {
    cylinder(h=riser_height, d=riser_diameter);
    cylinder(h=riser_height, d=post_hole_diameter);
    }

}
module raspberry_pi_base_box(which_pi,wall_thickness) 
{
    dimensions = get_pi_dims(which_pi);
    length_x  = dimensions[0];
    width_y   = dimensions[1];
    thickness = get_pipanel_cutout_thickness(wall_thickness);
    // Create the base plate
    color("purple") {
        cube([length_x,width_y,thickness]);
    }

}
module raspberry_pi_base(which_pi,wall_thickness) {

    riser_height = DefaultRiserHeight;  // *shrug*.  Parameterize it at some point.

    dimensions = get_pi_dims(which_pi);
    length_x  = dimensions[0];
    width_y   = dimensions[1];
    thickness = wall_thickness;

    hole_dims = get_pi_mounting_hole_dims(which_pi);
    hole_inset = hole_dims[0];


    // "Post position", you reprobate.
    pp_x1 = 0 + hole_inset;
    pp_x2 = length_x - hole_inset;

    pp_y1 = 0 + hole_inset;
    pp_y2 = width_y - hole_inset;

    // Hole positions and dimensions.
    
    // Get hole positions:  Won't THIS be a treat.
    // Raspberry Pi mounting hole positions (standard 58 mm x 23 mm)
    pi_hole_positions = [
        [pp_x1,pp_y1],  // Bottom-left hole
        [pp_x2,pp_y1],  // Top-left hole
        [pp_x1,pp_y2],  // Bottom-right hole
        [pp_x2,pp_y2]  // Top-right hole
    ];



    raspberry_pi_base_box(which_pi,wall_thickness);

    // Create the risers
    for (pos = pi_hole_positions) 
    {
        translate([pos[0], pos[1], wall_thickness]) 
        {
            pi_post_riser(which_pi,riser_height);
        }
    }
}


module pi_zero_panel(wall_thickness) {
    raspberry_pi_base("pi_zero_two",wall_thickness);
        
}

//wall_thickness = 5;
//pi_zero_panel(wall_thickness);
// end pi_zero_panel.scad
