use <threadlib/threadlib.scad>
use <knurledFinishLib.scad>

$fn = 360;

// Enable / disable Knurling    
knurled = !$preview;

/* [Quality / Accuracy Dimensions] */
// Rough approximation of your extrusion width
nozzle_diameter = 0.4;

// How much 'slew' to allow for external paths to print threads for the bolt. Default is to use half the extrusion width.
bolt_slew = 0.5;

/* [General Dimensions] */
// How thick do you want the exterior parts to be?
thickness = 4;

// How thick should the compression collar (pushed onto the spring) be above the cover?
collar_thickness = 2.75;

/* [Cover Attributes] */
// Do you want the cover fully closed or open?
closed_cover = false;

// If the cover is not fully closed this width is used to calculate how wide the outer wheel is.
outer_ring_width = 25 / 2;
// How wide the cross-bars are.
cross_width = 5;

// Calculate an x-y scale for the bolt to avoid slew.
boltscale = 1 - ((nozzle_diameter * bolt_slew) / 6);


module wheel() {
        union() {
        difference() {
            if (knurled) {
                knurled_cyl(thickness, 60, 3, 3, 1, 2, 50); 
            } else {
                cylinder(d = 60, h = thickness);
            }
            if (!closed_cover) {
                translate([0, 0, -0.25]) {
                    difference() {
                        cylinder(d = 60 - outer_ring_width, h = thickness + 0.5);
                        cube([cross_width, 60 - outer_ring_width, thickness * 2 + 1], center = true);
                        rotate([0, 0, 90]) cube([cross_width, 60 - outer_ring_width, thickness * 2 + 1], center = true);
                    }
                }
            }
        }
        cylinder(d = 10, h = thickness + collar_thickness); // protrudes collar_thickness into the spring
    }
}

// Nut side
difference() {
    wheel();
    translate([0, 0, 0]) tap("M6", length = thickness + collar_thickness, higbee_arc=90);
}

// screw side
translate([75, 0, 0]) {
    difference() {
        wheel();
        translate([0, 0, 2.25])
            cylinder(d = 6.3 + nozzle_diameter, h = thickness * 2 + 1);
        intersection() {
            cylinder(d = 9 + nozzle_diameter, h = 2.25);
            translate([-(5 + nozzle_diameter) / 2, -5, 0]) cube([5 + nozzle_diameter, 10, 2.25]);
        }
    }
}

// Horizontal orientation for the bolt to print in a 'strong' manner, with scaling to adjust for extruder diameter.
translate([-45, 0, 2.5]) {
    rotate([-90, 0, 0])
    rotate([0, 0, 90]) 
    intersection() {
        union() {
            cylinder(d = 9, h = 2, $fn = 360);
            rotate([0, 0, 45]) scale([boltscale, boltscale, 1])
                bolt("M6", length = (thickness * 2) + 16, higbee_arc=30, leadin=1);
        }
        cube([5, 10, ((thickness * 2) + 16) * 2], center = true);
    }
}

