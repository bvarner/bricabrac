// Attempt at a conical burr grinder...

// Grind fineness can be adjusted by the height of the cone interface.
$fn = 180;

diameter = 50;
radius = diameter / 2;
hopper_height = 20;
wall_thickness = 1.67; // 4 lines at 0.2
burr_height = 30;
skirt_height = 20;
max_grain = 12.5;

body = 1;
burr = 0;

// Body.
if (body) {
    difference() {
        cylinder(d = diameter, h = burr_height + hopper_height + skirt_height);
        cylinder(r = radius - wall_thickness, skirt_height);
        translate([0, 0, skirt_height]) {
            cylinder(r1 = radius - wall_thickness, d2 = radius, h = burr_height);
            translate([0, 0, burr_height]) {
                difference() {
                    cylinder(d1 = radius, r2 = radius - wall_thickness, h = hopper_height+ 1);
                    for(zr = [0, 120, 240]) {
                        rotate([0, 0, zr])
                            translate([-radius, -wall_thickness * 1.5, 0])
                                cube([radius, wall_thickness * 3, 3]);
                    }
                }
            }
        }
    }
}


// Burr Cone Shape
if (burr) {
    translate([0, 0, skirt_height - 1]) {
        for(zr = [0 : 45 : 360]) {
            rotate([0, 0, zr]) difference() {
                hull() {
                    cylinder(r1 = radius - wall_thickness, d2 = radius - max_grain, h = burr_height);
                    intersection() {
                        cylinder(r1 = radius - wall_thickness, d2 = radius, h = burr_height);
                        rotate([0, 0, 0.5]) intersection() {
                            rotate([0, 0, 89]) cube([radius, radius, burr_height]);
                            rotate([0, 0, 0]) cube([radius, radius, burr_height]);
                        }
                    }
                }
                rotate([0, 0, 0]) cube([radius, radius, burr_height]);
            }
        }
        cylinder(r1 = radius - wall_thickness, d2 = radius - max_grain, h = burr_height);
    }
}