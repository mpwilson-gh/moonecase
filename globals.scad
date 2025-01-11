// ====================
// Global Parameters
// ====================


// Box dimensions

Length = 100;
Width = 60;
Height = 45;
Thickness = 5;
wall_thickness = Thickness; //wall thickness


/* [Holes To Add] */
/*
Add_16mm_hole_to_lid_centered = false;
Add_22mm_hole_to_lid_centered = false;
Add_mount_screw_holes_to_base = false;
*/

/* [Inner Screw Mount Posts] */
/*
Include_Inner_Mount_Posts = false;
Post_Height = 2.5;
Length_On_Centers = 40;
Width_On_Centers = 15;
Mount_Screw_Diameter = 2;
*/
/* [Generate] */
//Helpful to split your print into 2 separate parts.  Don't change above parameters between Generate clicks

/*
Generate_Lid = true;

Generate_Base = true;
*/
/* [Hidden] */
// of the walls in mm.
//Thickness = 3;
//Will also round side edges if Side Edge Rounding is set to less than this value. (Forced to 2.2 until I can correct oddities.)

$fn  = 100;   //circle slices (quality)


// ------------------------------------------------------------------------------
// Screw parameters
screw = 3.5;  // diameter in mm
// ------------------------------------------------------------------------------


// ------------------------------------------------------------------------------
// Mounting hole parameters
// ------------------------------------------------------------------------------
mounting_hole_diameter = 3;  // in mm
mounting_hole_offset = 3.5;  // in mm

// Micro-USB port placeholder parameters
usb_hole_width = 10;  // in mm
usb_hole_height = 5;  // in mm
usb_screw_diameter = 2;  // in mm
usb_screw_offset = 2;    // in mm

// Speaker parameters
speaker_recess = 9.53;  // in mm
speaker_offset_from_side = 5;  // in mm

// Screw tab parameters
screw_tab_height = Thickness * 2;  // in mm
screw_tab_diameter = mounting_hole_diameter * 2;  // in mm

// ====================
// Helper Functions
// ====================
// Function to generate hole positions
function generate_hole_positions(width, depth, offset, z=-1) = [
    [offset, offset, z],
    [width - offset, offset, z],
    [offset, depth - offset, z],
    [width - offset, depth - offset, z]
];

