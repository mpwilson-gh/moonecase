


Length = 100;
Width = 60;
Height = 45;
Thickness = 5;
wall_thickness = Thickness; //wall thickness


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

        translate([wall_thickness,wall_thickness,wall_thickness * 2]) 
        cube([inner_length, inner_width, inner_height]);
    }
}


// -----------------------------------------------------------
// Screw stuff...


screw = 3.5;  // diameter in mm
Screw_Post_Offset = 3;  // screw post offset (options: 0.001, 1, 2, 3, 4)
scpo_height = Height;
scpo_radius = screw;
scpo_diameter = screw * 2;
scpo_inset_offset = Thickness + scpo_radius;


module screw_stand_single()
{
    // So a single screw "stand" is "screw pitch * 2" in diameter.
    difference()
    {
        cylinder(scpo_height,d=scpo_diameter);
        cylinder(scpo_height,d=screw);
    }
}

module screw_stands()
{
    translator(0,0,-0.2){screw_stand_single();}
}



module inner_screw_stands()
{

    // Bottom left:
    translate([ scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Bottom Right
    translate([ Length - scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Top Left
    translate([ scpo_inset_offset ,Width - scpo_inset_offset, 0])
    screw_stand_single();

    // Top Right
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

// -----------------------------------------------------------

lid_offset = -68; // This is just where it is relative to everything else on the model.

module lid() {
    // It renders "separately" 
    lid_inset = Thickness / 2;


    translate ([0,lid_offset,0])
    cube([Length - lid_inset,Width - lid_inset,Thickness]);
}

module lid_holes() {
    // Need the offsets from the posts.

    // lid hole offset =...
    //lho = scpo_inset_offset + (screw / 2);
    lho = scpo_inset_offset;


    // Bottom left
    translate([lho,lho + lid_offset,0])
    cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.

    // Bottom Right
    translate([Length - lho,lho + lid_offset,0])
    cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.

    // Top Left
    translate([lho,Width - (lho - lid_offset),0])
    cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.

    // Top Right
    translate([Length - lho, Width - (lho - lid_offset),0])
    cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.


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

module full_lid() {

difference () {
    lid();
    lid_holes();
}

}