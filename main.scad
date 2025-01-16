

// begin main.scad

include <moonecase_3.scad>

include <speaker_panel.scad>

include <composite_lid_panel.scad>

include <micro_usb_cutout.scad>


DefaultPcbThickness = 1.6; // It's true.  I read it on the internet.

module shell_minus_cut_outs() {

    sc_x_diff = wall_thickness;
    sc_y_diff = (Width - sp_cutout_width) / 2;

    difference () {
        shell();

        translate([(Length - sp_cutout_width) - sc_x_diff,sc_y_diff,-1])
        {
          speaker_cutout();
        }
        
        translate([sc_x_diff,sc_y_diff,-1])
        {
          speaker_cutout();
        }


        // This block is repeated later.  This is the only one
        // That actually needs to exist since the usb cutout is JuST a cut out.
        // But putting the conditional guides in seemed to make more sense in the 
        // additive section.
        // I was just rushing through at this point.  This is the last feature.
        
        box_length = Length;
        which_pi = "pi_zero_two";
        lid_length = get_lid_length_x(box_length,wall_thickness);
        pipanel_length_x = get_pipanel_length_x(which_pi);
        power_usb_offset = get_pi_power_usb_offset(which_pi);
        pipanel_offset_x = ( lid_length - pipanel_length_x) / 2;

        muc_x1 = get_muc_x_offset(wall_thickness,pipanel_offset_x,power_usb_offset);
        muc_y1 = get_muc_y_offset();
        muc_z1 = get_muc_z_offset(wall_thickness,get_pipanel_riser_height(),DefaultPcbThickness);  // pcb measures at roughly 0.

        muc_x2 = muc_x1 + get_muc_length_x() ;
        muc_y2 = muc_y1 + get_muc_depth_y(wall_thickness);
        muc_z2 = muc_z1 + get_muc_height_z();

        x1 = Length - muc_x2;
        x2 = x1 + get_muc_length_x() ;

        y1 = get_muc_y_offset();
        y2 = y1 + get_muc_depth_y(wall_thickness);

        z1 = Height - muc_z2;
        z2 = z1 + get_muc_height_z();

        if ($preview)
        {
            color("blue") translate([x1,0,z1]) cube([1,400,1],true);
            color("green") translate([x1,0,z2]) cube([1,400,1],true);
            color("blue") translate([x2,0,z1]) cube([1,400,1],true);
            color("green") translate([x2,0,z2]) cube([1,400,1],true);
        }


        translate([x1,y1,z1])
        {
            micro_usb_cutout(wall_thickness);
        }
    }
}

module shell_with_panels() {

    sc_x_diff = wall_thickness;
    sc_y_diff = (Width - sp_cutout_width) / 2;

    union () {
        shell_minus_cut_outs();

        translate([(sp_cutout_width * 2) ,sp_cutout_height + sc_y_diff,0])
        {
            rotate([0,0,180])
            speaker_panel();
        }

        translate([sc_x_diff,sc_y_diff,0])
        {
            speaker_panel();
        }


        // usb cutout guide lines.
        if ($preview)
            {
                /*
                // Most of this block is repeated from the usb cutout block above.
                // I was just rushing through it at this point.

                box_length = Length;
                which_pi = "pi_zero_two";
                lid_length = get_lid_length_x(box_length,wall_thickness);
                pipanel_length_x = get_pipanel_length_x(which_pi);
                power_usb_offset = get_pi_power_usb_offset(which_pi);
                pipanel_offset_x = ( lid_length - pipanel_length_x) / 2;

                muc_x1 = get_muc_x_offset(wall_thickness,pipanel_offset_x,power_usb_offset);
                muc_y1 = get_muc_y_offset();
                muc_z1 = get_muc_z_offset(wall_thickness,get_pipanel_riser_height(),DefaultPcbThickness);  // pcb measures at roughly 0.

                muc_x2 = muc_x1 + get_muc_length_x() ;
                muc_y2 = muc_y1 + get_muc_depth_y(wall_thickness);
                muc_z2 = muc_z1 + get_muc_height_z();

                x1 = Length - muc_x2;
                x2 = x1 + get_muc_length_x() ;

                y1 = get_muc_y_offset();
                y2 = y1 + get_muc_depth_y(wall_thickness);

                z1 = Height - muc_z2;
                z2 = z1 + get_muc_height_z();

                
                color("blue") translate([x1,0,z1]) cube([1,400,1],true);
                color("green") translate([x1,0,z2]) cube([1,400,1],true);
                color("blue") translate([x2,0,z1]) cube([1,400,1],true);
                color("green") translate([x2,0,z2]) cube([1,400,1],true);
*/

            }


    }
}

module final_lid() 
{

    lid_inset       = get_lid_inset_scalar(wall_thickness);
    lid_hole_scalar = get_hole_placement_scalar(Screw_Post_Offset,wall_thickness);

    lid_length_x = get_lid_length_x(Length,wall_thickness);
    lid_width_y  = get_lid_width_y(Width,wall_thickness);

    lh_x1 = lid_hole_scalar;
    lh_y1 = lid_hole_scalar;
    lh_x2 = lid_length_x - lid_hole_scalar;
    lh_y2 = lid_width_y - lid_hole_scalar;



    // Lid with debug guides.
    echo("Lid Inset: ",lid_inset);
    echo("Lid X:", lid_length_x)
    translate([lid_inset / 2,0,0])
    //translate([lid_inset / 2,lid_inset / 2,0])
    {
        translate([0,-70,0])
        {
            lid_added_panels(Length,Width,wall_thickness,screw,Screw_Post_Offset,"pi_zero_two");
            if ($preview)
            {
                color("blue") translate([lh_x1,0,-2]) cube([1,400,1],true);
                color("blue") translate([lh_x2,0,-2]) cube([1,400,1],true);
                color("blue") translate([0,lh_y1,-2]) cube([400,1,1],true);
                color("blue") translate([0,lh_y2,-2]) cube([400,1,1],true);
            }
        }
    }
}


module final_shell() 
{

    if ($preview)
    {
        offsets = get_abs_screw_stand_insets();
        x1 = offsets[0];
        y1 = offsets[1];
        x2 = offsets[2];
        y2 = offsets[3];

        echo("Shell Offsets: ",offsets);
        color("red") translate([x1,0,-1]) cube([1,400,1],true);
        color("red") translate([x2,0,-1]) cube([1,400,1],true);
        color("red") translate([0,y1,-1]) cube([400,1,1],true);
        color("red") translate([0,y2,-1]) cube([400,1,1],true);
    }

    shell_with_panels();

}

final_shell();
final_lid();


// end main.scad
