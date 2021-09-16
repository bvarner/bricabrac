difference() {
    translate([43 / 2 - 6, -40 / 2, 0]) cube([14, 40, 10]);
    cylinder(d = 43, h = 20, $fn = 90);
    translate([43 / 2 - 6 + 14 - 5, -16, 0]) cube([6, 32, 12]);
    translate([43 / 2 - 6 + 14 - 2.5, 25, 5]) rotate([90, 0, 0]) cylinder(d = 2.55, h = 50, $fn = 90);
}
