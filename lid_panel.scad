

include <screw_holes.scad>

DefaultLidClearance = 0;

function get_lid_inset_scalar(thickness) = thickness / 2 + DefaultLidClearance;

/*
function get_lid_length_x(box_length,thickness) = (box_length - (get_lid_inset_scalar(thickness) * 2)) - DefaultLidClearance;
function get_lid_width_y(box_width,thickness) = (box_width - (get_lid_inset_scalar(thickness) * 2)) - DefaultLidClearance;
*/
function get_lid_length_x(box_length,thickness) = (box_length - (get_lid_inset_scalar(thickness) )) - DefaultLidClearance;
function get_lid_width_y(box_width,thickness) = (box_width - (get_lid_inset_scalar(thickness) )) - DefaultLidClearance;


function get_lid_thickness(thickness) = thickness; // For debugging we're gonna make this 1.


// Takes post offset and wall thickness.  Computes lid inset.
function get_hole_placement_scalar(box_post_offset,wall_thickness) = box_post_offset + (get_lid_inset_scalar(wall_thickness) * 2);
//function get_hole_placement_scalar(box_post_offset,wall_thickness,lid_inset) = box_post_offset + lid_inset + wall_thickness;
//function get_hole_diameter(screw_diameter) = get_screw_hole_diameter_mm(screw_diameter);
function get_screw_hole_diameter(screw_diameter) = get_screw_hole_diameter_mm(screw_diameter);

// ------------------------------------------------------------------------------------
// These should be hardware specific, not relative.  But we need to start somewhere.
// ------------------------------------------------------------------------------------

function get_hole_countersink_diameter(screw_diameter) = screw_diameter * 2;
function get_hole_countersink_depth(thickness) = thickness / 2;
function get_hole_countersink_placement_scalar(box_post_offset,wall_thickness) = get_hole_placement_scalar(box_post_offset,wall_thickness);

// ------------------------------------------------------------------------------------
// Given that set of functions, the dimensions of the lid and placement of it's
// countersink and through holes should be trivial (lol.)
// ------------------------------------------------------------------------------------

module lid_hole(screw_diameter,wall_thickness)
{
    //echo("lid_hole():",screw_diameter,wall_thickness);
    hole_diameter =  get_screw_hole_diameter(screw_diameter);
    cylinder(d=hole_diameter,h=wall_thickness,$fn=10); // Low res hole gives the screw more to bite on.
}
module countersink_hole(screw_diameter,wall_thickness)
{
    cs_diameter = get_hole_countersink_diameter(screw_diameter);
    cs_depth    = get_hole_countersink_depth(wall_thickness);

    cylinder(d=cs_diameter,h=cs_depth,$fn=10); 
}

module lid_hole_with_countersink(screw_diameter,wall_thickness)
{
    union() {
        lid_hole(screw_diameter,wall_thickness);
        countersink_hole(screw_diameter,wall_thickness);
    }

}

module lid_base(box_length,box_width,wall_thickness) {
    //echo("lid_base:",box_length,box_width,wall_thickness);

    lid_x = get_lid_length_x(box_length,wall_thickness);
    lid_y = get_lid_width_y(box_width,wall_thickness);
    lid_z = get_lid_thickness(wall_thickness);

    lid_dz = 0; // debug value.
    //echo("Lid: ",[lid_x,lid_y,lid_z]);

    cube([lid_x,lid_y,lid_z]);
}

module lid_holes (box_length,box_width,wall_thickness,screw_diameter,post_offset) {

    //echo("lid_holes:",box_length,box_width,wall_thickness,screw_diameter,post_offset);

    lid_inset = get_lid_inset_scalar(wall_thickness);
    //echo("lid_holes:hps():",post_offset,lid_inset);
    offset = get_hole_placement_scalar(post_offset,wall_thickness);
    lid_thickness = get_lid_thickness(wall_thickness);
    lid_x = get_lid_length_x(box_length,wall_thickness);
    lid_y = get_lid_width_y(box_width,wall_thickness);

    //echo ("lh: inset,offset,lid_thickness,lid_x,lid_y",lid_inset,offset,lid_thickness,lid_x,lid_y);

    // Top left
    translate([lid_x - offset,offset,0])
    {
        lid_hole_with_countersink(screw_diameter,lid_thickness);
    }

    // Top Right
    translate([lid_x - offset,lid_y - offset,0])
    {
        lid_hole_with_countersink(screw_diameter,lid_thickness);
    }

    // Bottom Left
    translate([offset,offset,0])
    {
        lid_hole_with_countersink(screw_diameter,lid_thickness);
    }

    // Bottom Right
    translate([offset,lid_y - offset,0])
    {
        lid_hole_with_countersink(screw_diameter,lid_thickness);
    }
}


module full_lid(box_length,box_width,wall_thickness,screw_diameter,post_offset) 
{
    echo("full_lid()",box_length,box_width,wall_thickness,screw_diameter,post_offset); 
    difference () 
    {
        lid_base(box_length,box_width,wall_thickness);
        lid_holes(box_length,box_width,wall_thickness,screw_diameter,post_offset);
    }
}

