use <threadlib/threadlib.scad>;

threaded = 1;

difference() {
    scale([0.995, 0.995, 0.995])
    intersection() {
        cylinder(d = 9.5, h = 20, center = true, $fn = 90);
        difference() {
            cube([5.6, 9.5, 1.9 + 0.9], center = true);
            translate([2.9 / 2, -10 / 2, 2.8 / 2 - 0.9]) cube([5, 10, 1]);
            mirror([1, 0, 0]) translate([2.9 / 2, -10 / 2, 2.8 / 2 - 0.9]) cube([5, 10, 1]);
            
            translate([1.8 / 2, -10 / 2, -2.8 / 2]) rotate([0, 45, 0]) cube([5, 10, 2.687]);
            mirror([1, 0, 0]) translate([1.8 / 2, -10 / 2, -2.8 / 2]) rotate([0, 45, 0]) cube([5, 10, 2.687]);
        }
    }
    if (threaded == 1) {
        translate([0, 0, -3.8]) rotate([0, 0, 90]) tap("M3x0.5", 10, higbee_arc=45);
    } else {
        cylinder(d = 2.5, h = 20, center = true, $fn = 90);
    }
}
