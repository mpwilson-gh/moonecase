

// begin micro_usb_cutout.scad

// This is JUST a hole in the wall to shove a cable in to.  
// It's not a "cool punch-out panel" or anything.
// I just needed a place to pull constants from or I wouldn't have bothered.

function get_muc_length_x() = 15;
function get_muc_depth_y(wall_thickness) = wall_thickness;
function get_muc_height_z() = 12;


// No constants, but let's do the math in here.
// I'll combine these into one.  But for now...

// Whups. :)


function get_muc_x_offset(wall_thickness,pi_panel_offset_x,usb_offset_x) = (wall_thickness + pi_panel_offset_x + usb_offset_x) - (get_muc_length_x() / 2);
function get_muc_y_offset() = 0;
function get_muc_z_offset(wall_thickness,pi_riser_height,pi_pcb_height) = wall_thickness + pi_riser_height + pi_pcb_height;

// Derp.
module micro_usb_cutout(wall_thickness) 
{

    x = get_muc_length_x();
    y = get_muc_depth_y(wall_thickness);
    z = get_muc_height_z();

    cube([x,y,z]);
}


// end micro_usb_cutout.scad