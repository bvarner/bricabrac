$fn = 90;

difference() {
    union() {
        barb(swell = 0, shell = true, bore = false);
        rotate([0, 180 + 60, 180]) barb(shell = true, bore = false);
        rotate([0, 180 + 60, 0]) barb(shell = true, bore = false);
    }
    union() {
        // Size of drip end is 1.75
        barb(id = 1.75, shell = false, bore = true);
        rotate([0, 180 - 60, 0]) barb(shell = false, bore = true);
        rotate([0, 180 + 60, 0]) barb(shell = false, bore = true);
        // Keep full flow through the 90-degree bend
        translate([0, 0, -1.5]) cylinder(d = 3, h = 1.5);
        // Drip adjustment.
        translate([0, 0.5, -3]) rotate([140, 0, 0]) cylinder(d = 2.6, h = 10);
    }
}

module barb(y = 0, hose_id = 6.5, hose_od = 9.5, swell = 2.5, id = 3, shell = true, bore = true, ezprint = true) {
    translate([0, 0, -(6 + 4.5 + (hose_od - hose_id))])
    difference() {
        union() {
            if (shell == true) {
                for (i = [0 : 1]) {
                    rotate([0, y, 0]) {
                        for (z = [0 : 1 : 2]) {
                            translate([0, 0, z * 2]) cylinder(d1 = hose_id, d2 = hose_id + swell, h = 2);
                        }
                        translate([0, 0, 6]) cylinder(d = hose_id, h = 4.5 + (hose_od - hose_id));
                    }
                }
            }
        }
        if (bore == true) {
            translate([0, 0, -1]) cylinder(d = id, h = 6 + 4.5 + (hose_od - hose_id) + 1);
        }
        if (ezprint == true) {
            difference() {
                cylinder(d = hose_id + (swell * 3), h = 6);
                translate([swell, 0, 0]) cylinder(d = hose_id + (swell * 2), h = 6);
            }
        }
    }
}