use <threads.scad>;

// base
translate([-3, -3, -1.5])
    cube([3 + 24 + 12 + 23 + 12 + 21 + 3, 3 + 58 + 3, 1.5]);

// pH Probe
standoff();
translate([24, 0, 0])
    standoff();
translate([0, 34, 0])
    standoff();
translate([24, 34, 0])
    standoff();
    
translate([24 + 12, 0, 0]) {
    // Pi Zero W.
    standoff();
    translate([23, 0, 0])
        standoff();
    translate([0, 58, 0])
        standoff();
    translate([23, 58, 0])
        standoff();
}

// 5v Buck Converter
translate([24 + 12 + 23 + 12, 0, 0]) {
    translate([2.75, 6.5, 0]) standoff();
    translate([21 - 2.75, 43.25 - 6.5, 0]) standoff();
    
}


module standoff(d = 6, h = 6) {
    difference() {
        cylinder(d = d, h = h, $fn = 6);
        translate([0, 0, h -4])
            cylinder(d = 2.5, h = 4, $fn = 16);
    }
}