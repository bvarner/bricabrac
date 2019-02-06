$fn = 120;
difference() {
    translate([0, 0, 0.85]) minkowski() {
        cylinder(r = 10, h = 4.3);
        sphere(r = 0.85);
    };
    translate([0, 0, -0.25]) cylinder(r = 3.25, h = 6.5);
    cylinder(r = 7.75 / 2, h = 0.6);
    translate([0, 0, 5.4]) cylinder(r = 7.75 / 2, h = 0.6);
}