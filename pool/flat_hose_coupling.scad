r = 1;

difference() {
    for (mz = [0, 1]) {
        mirror([0, 0, mz]) {
            minkowski() {
                cylinder(d1 = 37 - 2 * r, d2 = 37.75 - 2 * r, h = 27, $fn = 360);
                sphere(r = r, $fn = 45);
            }
            translate([0, 0, 19.5]) {
                rotate_extrude($fn = 360) translate([37 / 2, 0, 0])
                circle(r = 1, $fn = 45);
            }
        }
    }
    cylinder(d = 37.75 - 6, h = 60, center = true);
};
