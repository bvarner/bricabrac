// HC-SR04 Transducer and ntc-100 temp probe 
// mount in a 2" net pot opening.
// Secure the transducer and thermistor with zip-ties!
printer_nozzle_od = 0.4;
wall = 1.7;

grommet_depth = 10;
sensor_height = 40;

pipe_od = inToMm(4.5);

function inToMm(i) = i * 25.4;

$fn = $preview ? 32 : 360;

translate([0, 0, ]) // Net pot base
difference() {
    union() {
        difference() {
            translate([0, 0, -sensor_height]) 
                cylinder(d = inToMm(2 + 2/16), h = inToMm(1/32) + grommet_depth + sensor_height);
            // Horizontal pipe cut.
            translate([0, 0, pipe_od / 2 + inToMm(1/32)]) 
                rotate([0, 90, 0]) 
                    cylinder(d = pipe_od, h = 100, center = true);
        }
        translate([0, 0, inToMm(1/32)]) 
            cylinder(d1 = inToMm(2), d2 = inToMm(2) - printer_nozzle_od, h = grommet_depth);
    }

    // center hollow
    translate([0, 0, inToMm(1/32) - sensor_height]) {
        difference() {
            cylinder(d1 = inToMm(2) - wall, d2 = inToMm(2) - printer_nozzle_od - wall, h = grommet_depth + sensor_height);
            // Temperature probe mount
            rotate([0, 0, 180]) translate([-wall, inToMm(1) - wall * 2, sensor_height]) cube([wall * 2, wall * 2, grommet_depth]);
        }
    }
    
    // Temperature probe entry & zip tie points
    rotate([0, 0, 180]) translate([0, inToMm(1), 0]) rotate([90, 0, 0]) {
        cylinder(d = 3, h = 10, center = true);
        translate([0, 0, wall]) rotate([-30, 0, 0]) cylinder(d1 = 3.5, d2 = 5, h = 5);
        for (mx = [0 : 1]) mirror ([mx, 0, 0]) {
            translate([wall + 1.5 / 2 + printer_nozzle_od, grommet_depth / 2, 0]) cylinder(d = 1.5 + printer_nozzle_od, h = 10, center = true);
        }
    }
    
    
    // Transducer cutouts
    translate([0, 0, -sensor_height]) {
        translate([-7, -10.25, 0]) cube([14, 20.5, grommet_depth + sensor_height]);
        translate([13, 0, 0]) cylinder(d = 17, h = grommet_depth + sensor_height);
        translate([-13, 0, 0]) cylinder(d = 17, h = grommet_depth + sensor_height);

        for (my = [0 : 1]) mirror([0, my, 0]) {
            for (mx = [0 : 1]) mirror([mx, 0, 0]) {
                // screw holes (1.25mm) are 42.5 and 17.5 OC.
                translate([42.5 / 2, 17.5 / 2, 0]) cylinder(d = 1.5 + printer_nozzle_od, h = grommet_depth + sensor_height);
            }
        }
        
        // Mating ring for top closure
        difference() {
            cylinder(d = inToMm(2 + 2/16) - wall, h = inToMm(1/64));
            cylinder(d = inToMm(2 + 2/16) - wall - wall, h = inToMm(1/64));
        }
        
        // Screw holes for the locking top.
        translate([0, inToMm(3/4), 0]) cylinder(d = 3.2 + printer_nozzle_od, h = inToMm(1/32));
        translate([inToMm(1/2), -inToMm(5/8), 0]) cylinder(d = 3.2 + printer_nozzle_od, h = inToMm(1/32));
        translate([-inToMm(1/2), -inToMm(5/8), 0]) cylinder(d = 3.2 + printer_nozzle_od, h = inToMm(1/32));
    }
}





