$fn = $preview ? 90 : 360;

difference() {
    cylinder(d = 48.45 + 1.67 * 2, h = 20);
    translate([0, 0, 1.2]) cylinder(d = 48.5, h = 20);
}