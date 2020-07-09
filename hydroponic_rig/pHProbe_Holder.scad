// 2" net pot grommet.
// Helps hold the cups more stable to the pipe.
printer_nozzle_od = 0.4;
wall = 1.7;

grommet_depth = 10;

pipe_od = inToMm(4.5);

function inToMm(i) = i * 25.4;

$fn = $preview ? 32 : 360;

difference() {
    union() {
        cylinder(d = inToMm(2) - printer_nozzle_od, h = 10);
        translate([0, 0, 10])cylinder(d1 = inToMm(2) - printer_nozzle_od, d2 = inToMm(0.5) + printer_nozzle_od + 0.87, h = inToMm(2) - 10);
        
        difference() {
            cylinder(d = inToMm(2 + 1/8) - printer_nozzle_od, h = inToMm(1/32) + grommet_depth);

            // Horizontal pipe cut.
            translate([0, 0, pipe_od / 2 + inToMm(1/32)]) 
                rotate([0, 90, 0]) 
                    cylinder(d = pipe_od, h = 100, center = true);
        }
    }

    // center hollow
    cylinder(d = inToMm(0.5) + printer_nozzle_od, h = grommet_depth + inToMm(1/32) + inToMm(2));
}





