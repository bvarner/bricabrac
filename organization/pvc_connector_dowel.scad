difference() {
    rotate([0, 90, 0]) translate([-(15.65 / 2), 15.5 / 2, 10]) union() {
        cylinder(d = 15.65, h = 30, $fn = 360);
        translate([0, 0, 30]) cylinder(d1 = 15.65, d2 = 14.5, h = 10, $fn = 360);
        translate([0, 0, -10]) cylinder(d2 = 15.65, d1 = 14.5, h = 10, $fn = 360);
    }
    translate([-2.5, 0, 0]) cube([55, 15.65, .5]);
}

