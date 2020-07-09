function inToMm(i) = i * 25.4;

union() {
    difference() {
        union() {
            cube([20, inToMm(4), 1.5], center = true);
            hull() {
                translate([-10, -inToMm(2.75) / 2 , -1.5 / 2]) cube([20, inToMm(2.75), 1.5]);
                translate([10 - 1.5 + inToMm(0.5), -inToMm(2.75) / 2 , 1.5 / 2]) 
                    rotate([0, 90, 0]) cube([11.5, inToMm(2.75), 1.5]);
            }
        }
        translate([-10, -inToMm(2.75) / 2 + 1.5, -1.5 / 2 - 10]) cube([20 - 1.5 + inToMm(0.5), inToMm(2.75) - 3, 10]);
        
        translate([0, inToMm(3.25) / 2, 0]) cylinder(d = 3.7, h = 4, center = true, $fn = 24);
        mirror([0, 1, 0]) translate([0, inToMm(3.25) / 2, 0]) cylinder(d = 3.7, h = 4, center = true, $fn = 24);

        // 4 Channel Relay.
        translate([10 + inToMm(0.5), -inToMm(2) / 2, -8]) rotate([-90, 0, 90]) {
            standoff(negative = true);
            translate([47.25, 0, 0])
                standoff(negative = true);
        }
        
    }
    
    // 4 Channel Relay.
    translate([10 + inToMm(0.5) - 1.5, -inToMm(2) / 2, -8]) rotate([-90, 0, 90]) {
        standoff();
        translate([47.25, 0, 0])
            standoff();
    }
}

module standoff(d = 6, h = 3, negative = false) {
    if (!negative) {
        difference() {
            hull() {
                cylinder(d = d, h = h, $fn = 6);
                translate([0, -d / 2, -0.1])
                    cylinder(d = d, h = 0.1, $fn = 6);
            }
            translate([0, 0, h - 5]) 
                cylinder(d = 2.5, h = 5, $fn = 24);
        }
    } else {
        cylinder(d = 2.5, h = h, $fn = 24);
    }
}