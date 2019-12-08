nozzle_diameter = 0.25;

tactile_button();

//charge_indicator(true);

module charge_indicator(positive = false) {
    p = positive ? (nozzle_diameter * 1.5) : 0;
    
    translate([((5.25 + p) / -2) - 0.375, ((43.5 + p) / -2) - 0.075, -2.4])
    union() {
        // PCB.
        difference() {
            union() {
                cube([5.25 + p, 43.5 + p, 3]);
                translate([-5.5 - p / 2, 1 + p / 2, 0]) 
                    cube([16.5 + p, 41.5 + p, 3]);
            }
        
            // Mounting holes
            translate([(5.25 + p) / 2, 4.125 + (p / 2), 1.5]) {
                cylinder(d = 1.75, h = 4, $fn = 32, center = true);
                translate([0, 36, 0])
                    cylinder(d = 1.75, h = 4, $fn = 32, center = true);
            }
        }
        
        // Display
        translate([-5.5 - p / 2 - 1.5, 1 + 4.7 + p / 2, 3])
            translate([]) cube([20 + p, 31.25 + p, 6 + (positive ? 8 : 0)]);
        
        if (positive) {
            // Mounting holes
            translate([(5.25 + p) / 2, 4.125 + (p / 2), 0]) {
                cylinder(d = 1.75, h = 8, $fn = 32);
                translate([0, 36, 0])
                    cylinder(d = 1.75, h = 8, $fn = 32);
            }
        }
    }
}

module tactile_button(positive = true, depth = 0, retention_diameter = 1.65, retention_depth = 2) {
    p = positive ? (nozzle_diameter * 1.5) : 0;
    
    translate([(6 + p) / -2, (3.5 + p) / -2, -depth]) union() {
        translate([0, 0, 0.35]) {
            // body
            cube([6 + p, 3.5 + p, 3 + depth]);

            // button
            translate([3 / 2, 1.95 / 2, 0])
                cube([3 + p, 1.55 + p, 4.75 + depth]);
        }
        
        // standoffs
        translate([0, 0, depth]) {
            cube([1.15 + p, 3.5 + p, 0.35]);
            translate([6 + p - 1.15 - p, 0, 0])
                cube([1.15 + p, 3.5 + p, 0.35]);
        }
        
        // Egress of solder joints
        translate([-1.5 - p, 1, 0]) cube([1.5 + p, 1.5 + p, 2 + depth]);
        translate([6 + p, 1, 0]) cube([1.5 + p, 1.5 + p, 2 + depth]);
    }
    
    // retention holes
    translate([0, 0, (retention_diameter + nozzle_diameter) / -2 + 0.35 + nozzle_diameter / 2]) rotate([90, 0, 0]) cylinder(d = retention_diameter + nozzle_diameter, h = 3.5 + p + (retention_depth * 2), center = true, $fn = 32);
}
