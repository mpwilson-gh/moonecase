
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
    echo("Bottom Left:",[ scpo_inset_offset ,scpo_inset_offset]);
    translate([ scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Bottom Right
    echo("Bottom Right:",[ Length - scpo_inset_offset ,scpo_inset_offset]);
    translate([ Length - scpo_inset_offset ,scpo_inset_offset, 0])
    screw_stand_single();

    // Top Left
    echo("Top Left:",[ scpo_inset_offset ,Width - scpo_inset_offset]);
    translate([ scpo_inset_offset ,Width - scpo_inset_offset, 0])
    screw_stand_single();

    // Top Right
    echo("Top Right:",[ Length - scpo_inset_offset ,Width - scpo_inset_offset]);
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
// lid_offset = 0; // This is just where it is relative to everything else on the model.
lid_inset = Thickness / 2;

module lid() {
    // It renders "separately" 
//    lid_inset = Thickness / 2;

    lid_x = Length - lid_inset;
    lid_y = Width - lid_inset;
    lid_z = Thickness;

    lid_dx = lid_inset;
    lid_dy = lid_offset + lid_inset;
//    lid_dz = 50; // debug value.
    lid_dz = 0; // debug value.
    echo("Lid: ",[lid_x,lid_y,lid_z]);

//    translate ([0,lid_offset,0])
    // Debug translation:
    echo("Lid Offsets:",[lid_dx,lid_dy,lid_dz]);
    translate ([lid_dx,lid_dy,lid_dz])
    {
    cube([Length - (2 * lid_inset),Width - (2 * lid_inset),Thickness]);
    }
}

module lid_holes () {

    /*
        The edge of the lid is "Width - (lid_inset * 2)" * "Length - (lid_inset * 2)"

        The "absolute" position of the screw holes is the same as the post centers, like so:

            // Bottom Left
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

        From each of those we have to subtract the size of the lip for the lid from each side.
        That value is "lid_inset"


        Given a normal "0,0" origin...

        // For bottom left
             X is the above x + lid_inset.
             y is the above y + lid_inset.

        //  For bottom right
             X is the above x - lid_inset
             Y is the above y + lid_inset

        // For top left
            X is the above x + lid_insert
            Y is the above y - lid_insert

        // For top right
            X is the above x - lid_insert
            Y is the above y - lid_insert

        That's assuming the post offsets are center relative (I think.)            


        Then take all Y values and "add" the lid_offset because we print it at a different orientation to keep
        it on the same plate.






    */
    
    // Baseline from absolute coordinates.
    base_left_x   = scpo_inset_offset - (Thickness - lid_inset);
    base_bottom_y = scpo_inset_offset - (Thickness - lid_inset);

    base_right_x  = (Length - scpo_inset_offset) + (Thickness - lid_inset);
    base_top_y    = (Width - scpo_inset_offset) + (Thickness - lid_inset);

    // Now add lid "lip" offsets.  (Pull them in by lid_inset)

    lid_left_x = base_left_x + lid_inset;
    lid_bottom_y = base_bottom_y + lid_inset;

    lid_right_x = base_right_x - lid_inset;
    lid_top_y   = base_top_y - lid_inset;

    // Now for the final positioning offsets (y only.)
    // These are absolute offsets.  Not "pull in from each side."
    // I should probably do this all in a single translate([]) but
    // I'm lazy enough to do it the dumb way yet again.

    offset_left_x   = lid_left_x;
    offset_bottom_y = lid_bottom_y + lid_offset;

    offset_right_x  = lid_right_x;
    offset_top_y    = lid_top_y + lid_offset;

    offset_z = 0; // This is only non-zero when debugging, for eyeballing.

    // Bottom Left
    translate([offset_left_x,offset_bottom_y,offset_z])
    {
        echo("Bottom Left: ",[offset_left_x,offset_bottom_y]);
        cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.
    }

    // Bottom Right
    translate([offset_right_x,offset_bottom_y,offset_z])
    {
        echo("Bottom Right: ",[offset_right_x,offset_bottom_y,offset_z]);
        cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.
    }

    // Top Left
    translate([offset_left_x,offset_top_y,offset_z])
    {
        echo("Top Left: ",[offset_left_x,offset_top_y,offset_z]);
        cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.
    }

    // Top Right
    translate([offset_right_x,offset_top_y,offset_z])
    {
        echo("Top Right: ",[offset_right_x,offset_top_y,offset_z]);
        cylinder(h=Thickness,d=screw,$fn=10); // Low res hole gives the screw more to bite on.
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

module full_lid() 
{
    difference () 
    {
        lid();
        lid_holes();
    }
}