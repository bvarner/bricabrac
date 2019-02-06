use <hose_barb.scad>;

$fn = 90;

union() {
    translate([0, 0, -2]) difference() {
        cylinder(d1 = 15, d2 = 6.5, h = 4);
        cylinder(d1 = 15 - (2 * 1.67), d2 = 6.5 - (2 * (1.67 - 0.43)), h = 4);
    }
    
    translate([0, 0, -2]) difference() {
        cylinder(d = 15, h = 10);
        cylinder(d = 15 - (1.67 * 2), h = 8);
        translate([0, 0, 8]) cylinder(d1 = 15 - (1.67 * 2), d2 = 15, h = 2);
    }
    
    translate([0, 0, -2]) barb(hose_id = 15, hose_od = 21, wall_thickness = 1.67, swell = 2, barb_length = 4, barbs = 2, ezprint = false);

    translate([0, 0, 2]) mirror([0, 0, 1]) barb(hose_id = 6.5, hose_od = 9.5, wall_thickness = 1.67 - 0.43, swell = 2, barb_length = 2, barbs = 2, ezprint = false);
}

