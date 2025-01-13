

// include <moonecase_3.scad>

include <lid_panel.scad>
include <pi_zero_panel.scad>

// Box dimensions
/*
Length = 100;
Width = 60;
Height = 45;
Thickness = 5;
wall_thickness = Thickness; //wall thickness

// ------------------------------------------------------------------------------
// Screw parameters
//screw = 3.5;  // diameter in mm
screw = 3;  // diameter in mm
// ------------------------------------------------------------------------------


// ------------------------------------------------------------------------------
// Mounting hole parameters
// ------------------------------------------------------------------------------

mounting_hole_diameter = 3;  // in mm
mounting_hole_offset = 3.5;  // in mm


Screw_Post_Offset = 3;  // screw post offset (options: 0.001, 1, 2, 3, 4)
scpo_height = Height;
scpo_radius = screw;
//scpo_diameter = screw * 2;
scpo_diameter = screw * 3;
scpo_inset_offset = Thickness + scpo_radius;

which_pi = "pi_zero_two";


// Because we take "half thickness" off of each side.
echo(version=version());
*/ 

module lid_cut_outs(box_length,box_width,wall_thickness,screw_diameter,post_offset,which_pi) {

    //echo("lid_cut_outs()",box_length,box_width,wall_thickness,screw_diameter,post_offset,which_pi);
    difference() {

        full_lid(box_length,box_width,wall_thickness,screw_diameter,post_offset);    

        lid_length_x = get_lid_length_x(box_length,wall_thickness);
        lid_width_y  = get_lid_width_y(box_width,wall_thickness);

        cutout_x = get_pipanel_length_x(which_pi);
        cutout_y = get_pipanel_width_y(which_pi);

        pipa_offset_x = (lid_length_x - cutout_x) / 2;
        pipa_offset_y = (lid_width_y - cutout_y) / 2;

        translate([pipa_offset_x,pipa_offset_y,0])  
        {
            pi_zero_cutout(which_pi,wall_thickness);
        }
    }

}

module lid_added_panels(box_length,box_width,wall_thickness,screw_diameter,post_offset,which_pi) {

    union () {
        lid_cut_outs(box_length,box_width,wall_thickness,screw_diameter,post_offset,which_pi);
        translate([0,0,0])  
        {
        lid_length_x = get_lid_length_x(box_length,wall_thickness);
        lid_width_y  = get_lid_width_y(box_width,wall_thickness);

        cutout_x = get_pipanel_length_x(which_pi);
        cutout_y = get_pipanel_width_y(which_pi);

        pipa_offset_x = (lid_length_x - cutout_x) / 2;
        pipa_offset_y = (lid_width_y - cutout_y) / 2;

        translate([pipa_offset_x,pipa_offset_y,0])  
        {
            pi_zero_panel(wall_thickness);
        }
        }
    }
}



//lid_added_panels(box_length,box_width,wall_thickness,screw_diameter,post_offset);


//full_lid(Length,Width,wall_thickness,screw,Screw_Post_Offset,"pi_zero_two");
//lid_cut_outs(Length,Width,wall_thickness,screw,Screw_Post_Offset,which_pi);
// lid_added_panels(Length,Width,wall_thickness,screw,Screw_Post_Offset,which_pi);
//pi_zero_cutout(which_pi,wall_thickness);
