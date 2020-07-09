use <hose_barb.scad>;
use <threads.scad>;
$fn = 90;

id = 8.91;

difference() {
    union() {
        english_thread(diameter=1.05, 
                       threads_per_inch=14, 
                       length=3/4, 
                       taper=-1/16, 
                       internal = false);
        translate([0, 0, 3/4 * 24.5]) {
            cylinder(d = 1.5 * 24.5, $fn = 6, h = 0.25 * 24.5);
            cylinder(d = 3/4 * 24.5, h = 3/4 * 24.5);
            translate([0, 0, 3/4 * 24.5]) {
                sphere(d = 3/4 * 24.5);
                
                for (rz = [0, 180]) {
                    rotate([0, 0, rz]) {
                        translate([0, 0, 1/8 * 24.5])
                        rotate([90, 0, 0])
                        mirror([0, 0, 1])
                            barb(hose_od = 25, 
                                 hose_id = 1/2 * 24.5, 
                                 swell = 3, 
                                 wall_thickness = 1.67, 
                                 barbs = 3, 
                                 barb_length = 3, 
                                 shell = true, 
                                 bore = false, 
                                 ezprint = false);
                    }
                }
            }
        }
    };
    hull() {
        sphere(d = id);
        translate([0, 0, (1.5 + 1/8) * 24.5]) {
            sphere(d = id);
        }
    }
    translate([0, 0, (1.5 + 1/8) * 24.5]) {
        rotate([90, 0, 0])
        cylinder(d = id, h = 4 * 24.5, center = true);
    }
}

