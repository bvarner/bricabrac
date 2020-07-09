use <threadlib/threadlib.scad>

/*
 * 1/2G BSPP thread to 1/2" vinyl hose barb.
 */
function inToMm(i) = i * 25.4;

$fn = $preview ? 32 : 360;


union() {
    difference() {
        union() {
            // outside of the threaded portion.
            cylinder(d = inToMm(1.25), h = inToMm(0.75), $fn = 6);
            cylinder(d = inToMm(0.5), h = inToMm(1.75));
            translate([0, 0, inToMm(1.75)]) cylinder(d1 = inToMm(0.5), d2 = inToMm(0.4), h = inToMm(0.1));
            translate([0, 0, inToMm(1)]) cylinder(d1 = inToMm(0.6), d2 = inToMm(0.5), h = inToMm(0.25));
            translate([0, 0, inToMm(1.35)]) cylinder(d1 = inToMm(0.6), d2 = inToMm(0.5), h = inToMm(0.25));
        }
        specs = thread_specs("G1/2-int");
        P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
        section_profile = specs[3];
        H = (8 + 1) * P;
        translate([0, 0, -P / 2]) cylinder(h=H, d=Dsupport, $fn = 120);
        cylinder(d = inToMm(0.45), h = inToMm(2));
    }
    // Add the threads back in
    specs = thread_specs("G1/2-int");
    P = specs[0]; Rrot = specs[1]; Dsupport = specs[2];
    translate([0, 0, P/2]) nut("G1/2", turns = 8, higbee_arc=180);
}
