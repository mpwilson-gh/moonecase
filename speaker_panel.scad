
// begin speaker_panel.scad

include <globals.scad>
include <hole.scad>

//Thickness = 3;

// Speaker parameters
speaker_size = 28.575;  // 1 1/8" square

sp_width = 32;
sp_height = 30;


sp_thickness = Thickness;
//sp_thickness = 3;
// 1.22: 30.988
// 1.11: 28.194
// 0.18 to center: 4.572
// 0.24: 6.096

sp_border_width = 8;  // no idea if this is right.  I'm thinking 3/8"

//speaker_panel_size = speaker_size + (2 * border_width);


// wall_thickness = sp_thickness;
wall_thickness = Thickness;

sp_cutout_width = sp_width + (sp_border_width * 2);
sp_cutout_height = sp_height + (sp_border_width * 2);

module speaker_cutout() {
    //cube([sp_width + (sp_border_width * 2),sp_height + (sp_border_width * 2),sp_thickness]);  
    cube([sp_cutout_width,sp_cutout_height,sp_thickness + 5]);  
}

module speaker_panel_base() {
    spb_outer_width = sp_width + (sp_border_width * 2);
    spb_outer_height = sp_height + (sp_border_width * 2);
    // The frame
    difference () {
        echo ("outer: ", spb_outer_width, spb_outer_height,sp_thickness / 2);
        echo ("die:   ", sp_width,sp_height,sp_thickness * 2.2);

        //cube([spb_outer_width,spb_outer_height,sp_thickness /2]);
        cube([spb_outer_width,spb_outer_height,sp_thickness + 1]);
        translate([sp_border_width,sp_border_width,-1]) // "-1" is to push it low and punch all the way through.
         cube([sp_width,sp_height,sp_thickness * 2.2]); // * 2.2 is to make the "die" bigger than the blank it's punching through.

        // Now the orientation matters.  We need 2 screw holes.
        hole([spb_outer_width / 2,sp_border_width/2,0], mounting_hole_diameter, sp_thickness*2, countersink=false);

        hole([spb_outer_width / 2,spb_outer_height - (sp_border_width / 2),0], mounting_hole_diameter, sp_thickness*2, countersink=false);


        offset = 2;
        ch = sp_border_width + offset;
        cr1 = 0;
        cr2 = sp_thickness;

        translate([0,sp_cutout_height / 2,sp_border_width/1.5])
        rotate([0,90,0])
        cylinder(h=ch,r1=cr1,r2=cr2);
    }
}

module speaker_panel() {
    speaker_panel_base();
}

// end speaker_panel.scad
