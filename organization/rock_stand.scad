difference() {
    union() {
        difference() {
            cylinder(r = 20, h = 3.5, $fn = 3);
            translate([15.5, -3, -.25]) cube([5, 6, 4]);
            rotate([0, 0, 120]) translate([15.5, -3, -.25]) cube([5, 6, 4]);
            rotate([0, 0, 240]) translate([15.5, -3, -.25]) cube([5, 6, 4]);
        }
        translate([10, 0, 3.5]) cylinder(r = 3, h = 14, $fn = 128);
        rotate([0, 0, 120]) translate([10, 0, 3.5]) cylinder(r = 3, h = 14, $fn = 128);
        rotate([0, 0, 240]) translate([10, 0, 3.5]) cylinder(r = 3, h = 14, $fn = 128);
    }
    translate([0, 0, 32]) sphere(r = 20, $fn = 128);
}
