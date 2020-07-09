$fn = $preview ? 90 : 360;

difference() {
    union () {
        cylinder(d = 48.45, h = 45);
        cylinder(d = 48.45 + 4.5, h = 20);
    }
    cylinder(d = 43.5, h = 45);
}
