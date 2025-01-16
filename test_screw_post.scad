

// begin test_screw_post.scad

include <moonecase_3.scad>

include <speaker_panel.scad>

include <composite_lid_panel.scad>

include <micro_usb_cutout.scad>


DefaultPcbThickness = 1.6; // It's true.  I read it on the internet.

module screw_post(screw_diameter,height)
{

/*
function get_hole_countersink_diameter(screw_diameter) = screw_diameter * 2;
function get_hole_countersink_depth(thickness) = thickness / 2;
function get_hole_countersink_placement_scalar(box_post_offset,wall_thickness) = get_hole_placement_scalar(box_post_offset,wall_thickness);
*/
    // So a single screw "stand" is "screw pitch * 2" in diameter.
    difference()
    {
        cylinder(height,d=scpo_diameter);
        // n-1
        //cylinder(scpo_height,d=screw);
        shd = get_screw_hole_diameter_mm(screw_diameter);
        echo("Screw pitch vs hole diameter:",screw_diameter,shd);
        cylinder(height,d=shd);
    }
}
module tmp_countersink_hole(screw_diameter,height,wall_thickness)
{
    cs_diameter = get_hole_countersink_diameter(screw_diameter);
    cs_depth    = get_hole_countersink_depth(wall_thickness);

    cylinder(d=cs_diameter,h=cs_depth,$fn=10); 
}

// Running some tests.
echo("Running some tests.  Screw diameter set to:",screw);

test_height = 10;
test_wall_thickness = 10;
translate([-20,0,0]) screw_post(screw,test_height);

translate([20,0,0]) 
//union() {
difference() {
    screw_post(screw,test_height);
    translate([0,0,(test_height-get_hole_countersink_depth(test_wall_thickness))])
    tmp_countersink_hole(screw,test_height,test_wall_thickness); // Just 5mm as a "random" thickness.
}


// end test_screw_post.scad
