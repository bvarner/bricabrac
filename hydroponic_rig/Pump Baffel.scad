// 4" pipe pump baffel.
// 
// 
// 2" Cup holes measure ~51.15mm diameter.
// Drilled into 4" SCH80 pipe, measuring ~106mm;
// 
printer_nozzle = 0.4;
cup_hole = 51.15;
pipe_diameter = 106;

$fn = $preview ? 32 : 360;

module pipe(solid = false) {
    difference() {
        rotate([0, 90, 0]) cylinder(d = pipe_diameter, h = 100);
        if (!solid) {
            rotate([0, 90, 0]) cylinder(d = pipe_diameter - 4, h = 100);
            translate([50, 0, 0]) {
                cylinder(d = cup_hole, h = pipe_diameter / 2);
            }
        }
    }
}

//pipe();


difference() {
    union() {
        difference() {
            translate([50, 0, pipe_diameter / 2 - 10]) cylinder(d = cup_hole + 4, h = 12);
            pipe(solid = true);
        }
        translate([50, 0, pipe_diameter / 2]) {
            difference() {
                hull() {
                    cylinder(d = cup_hole, h = 2);
                    translate([0, 0, -pipe_diameter + 10]) 
                        rotate([0, 0, 180]) 
                            cylinder(d = cup_hole, h = 2, $fn = 3);
                }
                for (my = [0 : 1]) {
                    mirror([0, my, 0]) {
                        for (tz = [8 : 5 : pipe_diameter / 2 + 20]) {
                            translate([-25, 2, -pipe_diameter + 10 + tz])
                                rotate([00, 20, 30])
                                    cube([cup_hole, cup_hole, 2.5]);
                        }
                    }
                }
            }
        }
    }
    translate([50, -10, -10 - 2]) {
        cube([8, 20, 65 + 2]);
        translate([0, 10, 6]) rotate([0, 90, 0]) cylinder(d = 12, h = 25);
    }
}