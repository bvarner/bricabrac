// Replacement Rivet for knock-off Crocs sold at Meijer.
// Based upon actual measurements. :-)

$fn = 90;

nozzle_diameter = 0.4;
translate([15, 0, 2.75 / 2]) rotate([-90, 0, 0])
intersection() {
    rivet();
    difference() {
        union() {
            translate([0, 0, -1.5]) cylinder(d1 = 5.5, d2 = 3.75, h = 1.5);
            cylinder(d = 3.75, h = 10);
        }
        // Flat for printing
        translate([-5.5 / 2, 2.75 / 2, -1.5]) cube([5.5, 2.75, 10]);
    }
}

translate([0, 0, -10]) mirror([0, 0, 1])
translate([0, 0, -10]) {
    difference() {
        intersection() {
            translate([-7, -7, -1.50]) cube([14, 14, 1.5]);
            rivet();
        }
        difference() {
        translate([0, 0, -1.5]) cylinder(d1 = 5.5 + nozzle_diameter, d2 = 3.75 + nozzle_diameter, h = 1.5);
            // Flat for printing
            translate([-5.5 / 2, (2.75 / 2) + nozzle_diameter / 2, -1.5]) cube([5.5, 2.75, 10]);
        }
    }
}


module rivet() {
    intersection() {
        translate([-3.75 / 2, -2.75 / 2, -1.5]) cube([3.75, 2.75, 8.75], center = false);
        union() {
            cylinder(d = 3.75, h = 2.5);
            translate([0, 0, 2.5]) cylinder(d1 = 3.75, d2 = 2.75,h = 2.75);
            translate([0, 0, 5.25]) cylinder(d1 = 3.75, d2 = 3, h = 2);
        }
    }
    resize([14, 14, 1.5])
    intersection() {
        translate([0, 0, -3.5]) cube([14, 14, 7], center = true);
        sphere(d = 14);
    }
}