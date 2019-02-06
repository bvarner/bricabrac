nozzle_diameter = 0.4;

hose_diameter = 20;
clamp_wall_thickness = 3;
clamp_thickness = 15;
spike_length = 175;
spike_width = 8;

$fn = 180;

difference() {
    union() {
        translate([hose_diameter / 2 + clamp_wall_thickness, spike_width + hose_diameter / 2 + clamp_wall_thickness, 0]) {
                difference() {
                    cylinder(d = hose_diameter + (clamp_wall_thickness * 2), h = clamp_thickness);
                    translate([hose_diameter / 2, 0, 0])
                        cylinder(d = hose_diameter + nozzle_diameter, h = clamp_thickness);
                }
        }
        hull() {
#            cube([clamp_wall_thickness, clamp_wall_thickness + (hose_diameter / 2), clamp_thickness]);
            translate([spike_length, 0, 0]) cube([1, 1, clamp_thickness]);
        }
        cube([clamp_wall_thickness, clamp_wall_thickness + spike_width + (hose_diameter / 2), clamp_thickness]);
    }
    translate([hose_diameter / 2 + clamp_wall_thickness, spike_width + hose_diameter / 2 + clamp_wall_thickness, 0]) {
        cylinder(d = hose_diameter + nozzle_diameter, h = clamp_thickness);
    }
    
    intersection() {
        difference() {
            cube([hose_diameter + (clamp_wall_thickness * 2), hose_diameter + (clamp_wall_thickness * 2), clamp_thickness]);
            translate([hose_diameter / 2, hose_diameter / 2, 0]) 
                cylinder(d = hose_diameter + nozzle_diameter, h = clamp_thickness);
        }
        cube([spike_width, spike_width, clamp_thickness]);
    }
    
    
}