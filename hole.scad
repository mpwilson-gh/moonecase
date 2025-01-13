
// hole.scad


// Generic hole module with optional countersink
module hole(position, diameter, height, countersink=false, countersink_diameter=6, countersink_depth=1, fn=30) {
    translate(position) {
        // Main hole
        cylinder(h=height, d=diameter, $fn=fn);
        
        // Countersink (if enabled)
        if (countersink) {
            cylinder(h=countersink_depth, d=countersink_diameter, $fn=fn);
        }
    }
}

// end hole.scad
