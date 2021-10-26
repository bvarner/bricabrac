$fn = $preview ? 90 : 360;

/*
 * Adapts a pool hose to fit within the bell-end of a 1.5" PVC pipe.
 */


difference() {
    union () {
        cylinder(d = 48.45, h = 45);
        cylinder(d = 48.45 + 4.5, h = 20);
    }
    cylinder(d = 43.5, h = 45);
}
