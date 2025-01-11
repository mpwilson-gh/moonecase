
// begin micro_usb_panel.scad

include <globals.scad>;
include <hole.scad>;

// Micro USB port parameters
usb_width = 9;  // Width of the USB port cutout
usb_height = 4;  // Height of the USB port cutout
usb_depth = 10;  // Depth of the USB port cutout (into the case)
border_width = 8;  // Border around the USB port cutout
outer_width = usb_width + 2 * border_width;
outer_height = usb_height + 2 * border_width;

module micro_usb_cutout() {
    translate([wall_thickness,0,0])
    rotate([0,-90,0])
    cube([outer_width,outer_height,wall_thickness]);

}
module micro_usb_panel_base() {
    // Outer plate dimensions
    outer_width = usb_width + 2 * border_width;
    outer_height = usb_height + 2 * border_width;

    // Create the plate
    difference() {
        // Outer plate
        cube([outer_width, outer_height, wall_thickness]);

        // USB port cutout
        translate([border_width, border_width, -1])  // -1 to ensure the cutout goes through
        cube([usb_width, usb_height, wall_thickness + 2]);  // +2 to ensure the cutout goes through

        // Optional: Add screw holes for mounting (if needed)
        screw_offset = border_width / 2;
        hole([screw_offset, screw_offset, 0], mounting_hole_diameter, wall_thickness, countersink=false);
        hole([outer_width - screw_offset, screw_offset, 0], mounting_hole_diameter, wall_thickness, countersink=false);
        hole([screw_offset, outer_height - screw_offset, 0], mounting_hole_diameter, wall_thickness, countersink=false);
        hole([outer_width - screw_offset, outer_height - screw_offset, 0], mounting_hole_diameter, wall_thickness, countersink=false);
    }
}

module micro_usb_panel() {
     translate([wall_thickness,0,0])
     rotate([0,-90,0])
   micro_usb_panel_base();
}

// end micro_usb_panel.scad
