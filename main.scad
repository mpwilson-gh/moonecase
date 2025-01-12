


include <moonecase_3.scad>

// Cut outs and panels.

include <speaker_panel.scad>
include <pi_zero_panel.scad>

module cut_outs() {
    // Debugging with union.

    sc_x_diff = wall_thickness;
    sc_y_diff = (Width - sp_cutout_width) / 2;

    difference () {
        shell();


        //translate([ (Width / 2 - sp_width), 0, -20]) {
        translate([(Length - sp_cutout_width) - sc_x_diff,sc_y_diff,-1])
        //translate([(Length - sp_cutout_width) - wall_thickness,(Width - sp_cutout_width) / 2,-1])
        {
        speaker_cutout();
        }
        
        //translate([-100,-100,-20])
        translate([sc_x_diff,sc_y_diff,-1])
        {
        speaker_cutout();
        }
    }
}

module with_panels() {

    sc_x_diff = wall_thickness;
    sc_y_diff = (Width - sp_cutout_width) / 2;

    union () {
        cut_outs();


        // This is fine without the rotation.
        //translate([(Length - sp_cutout_width) - sc_x_diff,sc_y_diff,0])

        translate([(sp_cutout_width * 2) ,sp_cutout_height + sc_y_diff,0])
        {
            rotate([0,0,180])
            speaker_panel();
        }

        translate([sc_x_diff,sc_y_diff,0])
        {
            
        speaker_panel();
        }


    }
}

module lid_cut_outs() {
//        pco_x_diff = (Length - base_plate_width) / 2 - (wall_thickness / 2);
        pco_x_diff = (Length - base_plate_width) / 2 ;
        pco_y_diff = (- (Width -  base_plate_depth) / 2 )- wall_thickness;
        echo("Length/Width:",Length,Width);
        echo("bp width/depth:", base_plate_width,base_plate_depth);
        echo("xdiff/ydiff:",pco_x_diff,pco_y_diff);

    difference() {
        full_lid();

        translate([pco_x_diff,pco_y_diff + (lid_offset / 2),0])  
        {
            pi_zero_cutout();
        }
    }

}

module lid_added_panels() {
        pco_x_diff = (Length - base_plate_width) / 2 ;
        pco_y_diff = (- (Width -  base_plate_depth) / 2 )- wall_thickness;

    union () {
        full_lid();

        translate([pco_x_diff,pco_y_diff + (lid_offset / 2),0])  
        {
            pi_zero_panel();
        }
    }

}

module final_base() {
    with_panels();
}
module final_lid() {
    lid_added_panels();

}

// speaker_panel();
 final_base();
// final_lid();

 // full_lid();