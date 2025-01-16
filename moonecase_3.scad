
Length = 100;
Width = 60;
Height = 45;
Thickness = 5;
wall_thickness = Thickness; //wall thickness

include <screw_holes.scad>
module outer_wall()
{
    
    color("yellow",0.25)
        cube([Length,Width,Height]);
}

module inner_wall()
{
    inner_length = Length - (wall_thickness * 2);
    inner_width  = Width  - (wall_thickness * 2);
    inner_height = Height - (wall_thickness);
 
    difference() {
        outer_wall();

        translate([wall_thickness,wall_thickness,wall_thickness ]) 
        cube([inner_length, inner_width, inner_height + wall_thickness]);
    }
}


// -----------------------------------------------------------
// Screw stuff...


screw = 3.5;  // diameter in mm
Screw_Post_Offset = 3;  // screw post offset (options: 0.001, 1, 2, 3, 4)
scpo_height = Height;
scpo_radius = screw;
//scpo_diameter = screw * 2;
scpo_diameter = screw * 3;
scpo_inset_offset = Thickness + scpo_radius;


// x1,y1,x2,y2
function get_abs_screw_stand_insets() = [scpo_inset_offset,scpo_inset_offset,Length - scpo_inset_offset,Width - scpo_inset_offset];


module screw_stand_single()
{
    // So a single screw "stand" is "screw pitch * 2" in diameter.
    difference()
    {
        cylinder(scpo_height,d=scpo_diameter);
        // n-1
        //cylinder(scpo_height,d=screw);
        shd = get_screw_hole_diameter_mm(screw);
        echo("Screw pitch vs hole diameter:",screw,shd);
        cylinder(scpo_height,d=get_screw_hole_diameter_mm(screw));
    }
}

module screw_stands()
{
    translator(0,0,-0.2){screw_stand_single();}
}



module inner_screw_stands()
{

    // Bottom left:
    //echo("Bottom Left:",[ scpo_inset_offset ,scpo_inset_offset]);
    translate([ scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Bottom Right
    //echo("Bottom Right:",[ Length - scpo_inset_offset ,scpo_inset_offset]);
    translate([ Length - scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Top Left
    //echo("Top Left:",[ scpo_inset_offset ,Width - scpo_inset_offset]);
    translate([ scpo_inset_offset ,Width - scpo_inset_offset, 0])
    screw_stand_single();

    // Top Right
    //echo("Top Right:",[ Length - scpo_inset_offset ,Width - scpo_inset_offset]);
    translate([ Length - scpo_inset_offset ,Width - scpo_inset_offset, 0])
    screw_stand_single();

}

module in_screw_stand_single()
{
    difference()
    {
        cylinder(Post_Height,d=Mount_Screw_Diameter*2,center=true);
        cylinder(Post_Height,d=Mount_Screw_Diameter,center=true);
    }
}




module shell() {

    lid_inset = Thickness / 2;

    difference() 
    {

        union ()  
        {
            inner_wall();
            inner_screw_stands();
        };

        translate ([lid_inset / 2,lid_inset / 2,Height - Thickness])
        cube([Length - lid_inset,Width - lid_inset,Thickness]);
    }

}
