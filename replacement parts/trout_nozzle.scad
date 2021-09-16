extrusion_width = 0.45;
$fn = 360;

//lower_diameter = 20.25;
//lower_height = 26;
//
//upper_d1 = 17.6;
//upper_d2 = 17.15;
//upper_height = 16;

// Shrinkage Corrections for Nylon
lower_diameter = 20.45;
lower_height = 26.5;

upper_d1 = 17.9;
upper_d2 = 17.30;
upper_height = 16.5;


pin_location = lower_height - 18;

difference() {
    union() {
        // lower diameter
        translate([0, 0, 1.5]) minkowski() {
            cylinder(d = lower_diameter - 3, h = lower_height - 3);
            sphere(d = 3, $fn = 64);
        }
        // Hook for retention string.
        translate([0, 0, lower_height - 3 - 0.5]) {
            difference() {
                hull() {
                    translate([0, 0, -5]) cylinder(d = lower_diameter, h = 7);
                    minkowski() {
                        translate([13, 0, 0]) cylinder(d = 5.25, h = 1.5, $fn = 64);
                        sphere(d = 1, $fn = 32);
                    }
                };
                translate([13, 0, -6]) cylinder(d = 2.75 + extrusion_width, h = 10);
            }
        }

        // upper diameter
        translate([0, 0, lower_height]) {
            minkowski() {
                // upper diameter and heights
                cylinder(d1 =upper_d1 - 2, d2 = upper_d2 - 2, h = upper_height - 2);
                sphere(d = 2, $fn = 64);
            }
        }
        
        // Locking Pins.
        translate([0, 0, pin_location + (3.7 / 2)]) rotate([90, 0, 0]) minkowski() {
            cylinder(d = 2, h = 25, $fn = 64, center = true);
            sphere(d = 1.7, $fn = 64);
        }
        
        // Removable support below the locking pins.
        difference() {
            hull() {
                translate([-extrusion_width, -lower_diameter / 2, pin_location - 2.5])
                    cube([2 * extrusion_width, lower_diameter, 0.25]);
                translate([-extrusion_width, -25 / 2, pin_location])
                    cube([2 * extrusion_width, 25, 0.25]);
            }
            translate([-extrusion_width, -23 / 2, pin_location - 0.2])
                cube([2 * extrusion_width, 23, 1]);
            translate([-extrusion_width, -20.5 / 2, pin_location - 1])
                cube([2 * extrusion_width, 20.5, .5]);
            translate([-extrusion_width, -20.5 / 2, pin_location - 1.75])
                cube([2 * extrusion_width, 20.5, .5]);
        }
    };
    
    // Hollow it out.
    cylinder(d1 = 16 + extrusion_width, d2 = 13.4 + extrusion_width, h = lower_height + upper_height);
}