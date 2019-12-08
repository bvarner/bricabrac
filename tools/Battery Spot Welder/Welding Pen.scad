// A bare-bones battery terminal welding pen
// based around a P12 terminal block.
$fn = $preview ? 32 : 90;

// Manufacturing Machine defaults
printer_nozzle_od = 0.4;

// Length of the pen.
pen_length = 75;

// Sized for General Cable 01777.35T.01
cable_od = 10.16;

// Sized for Southwire 57008102
cable_od = 8.66;

// width of the p12 block.
p12_w = 8.23;
p12_l = 20.08;
p12_fh = 17.75;
p12_h = 9;

// Target width of the printed walls.
wall = 1.7;

// Current size matches P12 terminal block inner brass piece.
module terminal_block(o = printer_nozzle_od, h = p12_h, w = p12_w, l = p12_l) {
    union() {
        rotate([0, 90, 0]) {
            cylinder(d = w + o, h = l + o, center = true);
        }
        translate([(l + o) * -0.5, 5.55 * -0.5, 0]) {
            cube([l + o, 5.55, (h / 2) + o]);
        }
        translate([0, 0, p12_h / 2]) {
            xsymmetric() translate([(13 / 2), 0, 0]) cylinder(d = 5.1 + o, h = 9.25);
        }
    }
}

module handle(b = true, t = false) {
    difference() {
        hull() {
            ysymmetric() {
                translate([-p12_l / 2 - wall, p12_fh + wall - (p12_h + wall * 2) / 2, 0]) {
                    sphere(d = p12_w + wall * 2);
                    translate([p12_l - (p12_w / 2 + wall), 0, 0]) sphere(d = p12_w + wall * 2);
                }
                translate([pen_length - (2 * p12_w + wall), 2 * wall + cable_od, 0]) {
                        sphere(d = cable_od + wall * 2);
                }
            }
        };
        
        ysymmetric() translate([0, max(cable_od, p12_w) / 2 + wall, 0]) {
            rotate([270, 0, 0]) terminal_block();
            translate([- p12_l / 2, 0, 0]) {
                // Exit hole for the electrodes
                rotate([0, 270, 0]) cylinder(d = min(cable_od, p12_w), h = p12_w + wall * 2);
                rotate([0, 90, 0]) cylinder(d = cable_od + printer_nozzle_od, h = pen_length);
            }
        }
        
        // M3x12
        // screws to hold it together.
        ysymmetric() {
            translate([-p12_l / 2 - wall - printer_nozzle_od / 2, p12_fh + wall - (p12_h + wall * 2) / 2 + 2, 0]) {
                screw(h = 10, e = 5);
            }
            translate([pen_length - (2 * p12_w + wall), 2 * wall + cable_od + 1, 0]) {
                screw(h = 10, e = 5);
            }
        }
    }
}


module xsymmetric() {
    for (mx = [0, 1]) {
        mirror([mx, 0, 0])
            children();
    }
}

module ysymmetric() {
    for (my = [0, 1]) {
        mirror([0, my, 0])
            children();
    }
}

module screw(h = 15, e = 10) {
    translate([0, 0, -h / 2]) {
        // Excess below the nut
        translate([0, 0, -e])
            cylinder(d = 7 + printer_nozzle_od, $fn = 6, h = e);

        // Nut entryway
        cylinder(d1 = 7 + printer_nozzle_od, d2 = 6.45 + printer_nozzle_od, $fn = 6, h = .5);
        translate([0, 0, 0.5]) cylinder(d1 = 6.45 + printer_nozzle_od, d2 = 6.01 + printer_nozzle_od, $fn = 6, h = 2.5);
        
        // shaft
        cylinder(d = 3.2 + printer_nozzle_od, h = h);
        // head
        translate([0, 0, h - 3]) cylinder(d = 5.5 + printer_nozzle_od, h = 3);

        // Extra above head.
        translate([0, 0, h]) cylinder(d = 5.5 + printer_nozzle_od, h = e);
    }
}

for (mz = [0 : 1]) {
    translate([0, 0, mz * 5])
    difference() {
        handle();
            mirror([0, 0, mz])
                translate([0, 0, 15]) cube([pen_length * 2, pen_length * 2, 30], center = true);
    }
}


