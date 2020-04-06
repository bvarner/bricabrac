$fn = $preview ? 32 : 90;

difference() {
    minkowski() {
        cylinder(d = 39, h = 88);
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