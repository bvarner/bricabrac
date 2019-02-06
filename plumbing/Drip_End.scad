use <hose_barb.scad>

$fn = 90;

// Inner diameter of the hose you're using
hose_id = 6.5;

// Outer diameter of the hose you're using (calculates the collar length)
hose_od = 9.5;

// Outer Diameter of the barbs.
swell = 2.5;

// Drip Nozzle diameter
drip_id = 1.75;

wall_thickness = 1.74;

// Make the barbs have smooth bottoms to print easier?
ezprint = true;

difference() {
    union() {
        barb(hose_od = hose_od, hose_id = hose_id, wall_thickness = wall_thickness, swell = 0, shell = true, bore = false);
        rotate([0, 180 + 60, 0]) barb(hose_od = hose_od, hose_id = hose_id, wall_thickness = wall_thickness, swell = swell, shell = true, bore = false);
        // moon slice to fill the gap
        hull() {
            intersection() {
                union() {
                    cylinder(d = hose_id, h = 0.1);
                    rotate([0, 180 + 60, 0]) cylinder(d = hose_id, h = 0.1);
                }
                translate([-(hose_id / 2), -(hose_id / 2), 0]) cube([hose_id / 2, hose_id, hose_id / 2]);
            }
        };
    }
    union() {
        id = hose_id - (wall_thickness * 2);
        
        sphere(d = 3);
        // Size of drip end is 1.75
        barb(hose_od = hose_od, hose_id = hose_id, wall_thickness = (hose_id - drip_id) / 2, shell = false, bore = true);
        rotate([0, 180 + 60, 0]) barb(hose_od = hose_od, hose_id = hose_id, wall_thickness = wall_thickness, shell = false, bore = true);
        // Keep full flow through the 90-degree bend
        translate([0, 0, -(id / 2)]) cylinder(d = id, h = (id / 2));
        // Drip adjustment.
        translate([0, 0.5, -3]) rotate([140, 0, 0]) cylinder(d = 2.6, h = 10);
    }
}




    