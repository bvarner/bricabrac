$fn = $preview ? 32 : 90;

height = 110;

translate([0, 0, 5])
difference() {
    minkowski() {
        cylinder(d = 39, h = height - 10);
        sphere(d = 10);
    }
    for (my = [0, 1]) {
        mirror([0, my, 0]) {
            translate([-7.5 / 2, -49 / 2 + 2, -5]) rotate([90, 0, 0]) hull() {
                cube([7.5, 30, 0.5]);
                translate([-1, 0, 1.8]) cube([10, 30, 0.2]);
            }
        }
    }
}