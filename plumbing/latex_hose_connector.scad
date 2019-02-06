use <hose_barb.scad>;
use <threads.scad>;
$fn = 360;


top = true;
bottom = true;

if (top) {
    difference() {
        union() {
            cylinder(d = 30 + (1.67 * 2), h = 20, $fn = 6);
            translate([0, 0, 20]) cylinder(d1 = 30 + (1.67 * 2), d2 = 6.2, h = 5, $fn = 6);
            translate([0, 0, 25]) mirror([0, 0, 1]) 
                barb(hose_od = 9.8, hose_id = 6.2, swell = 3, wall_thickness = 1.67, barbs = 3, barb_length = 3, shell = true, bore = true, ezprint = false);
        }

        english_thread (diameter=1.05, threads_per_inch=14, length=3/4, taper=1/16, internal = true);
        
        cylinder(d = 6.2 - (2 * 1.67), h = 25);
    }
}

if (bottom) {
translate([0, 45, 0])
    difference() {
        union() {
            translate([0, 0, 6])
            english_thread (diameter=1.05, threads_per_inch=14, length= (3/4) - 0.23622, taper=1/16, internal = false);
            cylinder(d = 26, $fn = 6, h = 6);
        }
        
        
        cylinder(d = 15.4, h = 25);
        translate([0, 0, 19 - 9]) cylinder(d = 20, h = 30);
    }
}