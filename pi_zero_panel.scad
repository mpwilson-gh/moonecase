

// begin pi_zero_panel.scad

include <globals.scad>

// Raspberry Pi Zero dimensions (standard 58 mm x 23 mm)
pi_zero_width = 58;
pi_zero_depth = 23;
pi_zero_height = 1.5;  // Thickness of the Pi Zero


// Riser parameters
riser_height = 10;  // Height of the risers
riser_diameter = 6;  // Diameter of the risers
pi_hole_diameter = 2.5;  // Diameter of the Pi mounting holes

// Base plate dimensions (aligned with global wall_thickness)
base_plate_thickness = Thickness;  // Use global wall thickness
base_plate_width = pi_zero_width + 7;   // Add 7 mm for offsets (3.5 mm on each side)
base_plate_depth = pi_zero_depth + 7;   // Add 7 mm for offsets (3.5 mm on each side)


module pi_zero_cutout () {
        cube([base_plate_width, base_plate_depth, base_plate_thickness + 2]);
}

module pi_zero_panel_base() {

    // Raspberry Pi mounting hole positions (standard 58 mm x 23 mm)
    pi_hole_positions = [
        [3.5, 3.5],  // Bottom-left hole
        [3.5, 23 + 3.5],  // Top-left hole
        [58 + 3.5, 3.5],  // Bottom-right hole
        [58 + 3.5, 23 + 3.5]  // Top-right hole
    ];


    // Create the base plate
    color("purple") {
        cube([base_plate_width, base_plate_depth, base_plate_thickness]);
    }

    // Create the risers
    for (pos = pi_hole_positions) {
        translate([pos[0], pos[1], base_plate_thickness]) {
            difference() {
                // Create the riser
                cylinder(h=riser_height, d=riser_diameter, $fn=30);

                // Subtract the Pi mounting hole
                translate([0, 0, -1])
                cylinder(h=riser_height + 2, d=pi_hole_diameter, $fn=30);  // Add 2 mm to ensure the hole goes all the way through
            }
        }
    }
}

module pi_zero_panel() {
        pi_zero_panel_base();
}

// end pi_zero_panel.scad
