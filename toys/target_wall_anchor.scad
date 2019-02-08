$fn = 90;
difference() {
    union() {
        cylinder(d = 15, h = 3);
        translate([0, 0, 3]) cylinder(d1 = 15, d2 = 6, h = 2);
        translate([0, 0, 5]) cylinder(d1 = 6, d2 = 3.5, h = 15);
    };
    cylinder(d1 = 3.5, d2 = 2.5, h = 20);
    translate([0, 0, 5 + 7.5]) cube([0.75, 8, 15], center = true);
}