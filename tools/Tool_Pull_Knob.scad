use <threadlib/threadlib.scad>

$fn = $preview ? 32 : 360;

stem_height = 3/4 * 25.4;


difference() {
    union() {
        hull() {
            rotate_extrude() translate([14.5, 0, 0]) circle(r = 1.5);
            translate([0, 0, stem_height])
                rotate_extrude() translate([14.5, 0, 0]) circle(r = 1.5);
        }
        translate([0, 0, stem_height + 6]) {
            hull() {
                rotate_extrude() translate([38 / 2, 0, 0]) circle(r = 6);
                translate([0, 0, 19 / 2])
                    rotate_extrude() translate([55 / 2, 0, 0]) circle(r = 1.5);
            }
        }
        // collar for fillet
        translate([0, 0, stem_height - 3]) cylinder(d = 38, h = 3);
    }
    // cut fillet
    translate([0, 0, stem_height - 3]) rotate_extrude() translate([38 / 2, 0, 0]) circle(r = 3);
    // cut the bottom.
    mirror([0, 0, 1]) cylinder(d = 55, h = 3);
    // Tap bolt hole.
    cylinder(d = 8.2, h = 5);
    translate([0, 0, 5]) 
        tap("UNC-5/16", length = 25.4 * 1.125, higbee_arc = 180);
}

//cylinder(d = 32, h = 20);
//translate([0, 0, 20])
//    cylinder(d = 58, h = 19);
    