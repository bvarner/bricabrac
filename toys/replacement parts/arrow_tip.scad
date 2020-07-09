$fn = 360;

rotate([0, -90, 0])
difference() {
    union() {
        hull() {
            resize([23.5, 8, 3]) rotate([0, 0, 45]) translate([-5, -5, 0]) cube([10, 10, 3]);
            resize([39.5, 16, .25]) rotate([0, 0, 45]) translate([-5, -5, 0]) cube([10, 10, 0.25]);
            resize([23.5, 8, 3]) rotate([0, 0, 45]) translate([-5, -5, -3]) cube([10, 10, 3]);
        }
        translate([-20, 0, 0]) rotate([0, 90, 0]) {
            cylinder(d = 10.5, h = 8);
            translate([0, 0, 8]) cylinder(d1 = 10.5, d2 = 6, h = 3.5);
        }
    }
    translate([-21, 0, 0]) rotate([0, 90, 0]) {
        cylinder(d = 7.05, h = 9);
        translate([0, 0, 9]) cylinder(d1 = 7.05, d2 = 0, h = 2);
    }
//    translate([, 0, 0]) cube([3, 20, 20], center = true);
}