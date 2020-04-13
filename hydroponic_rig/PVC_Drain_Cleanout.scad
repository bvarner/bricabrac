use <threads.scad>;

printer_extrusion_width = 0.45;

pipe_id = 3.786 * 25.4;
ideal_perimeter = 2.54;
water_level = ((2.75 * 25.4) - (pipe_id / 2));

drain_point = sqrt((pow((pipe_id / 2), 2)) - (pow(water_level, 2)));

difference() {
    union() {
        // The cap
        // taper decreases as z increases, so we rotate it upside down.
        translate([0, 0, 7/8 * 25.4])
        rotate([180, 0, 0]) {
            english_thread(diameter = 4.5 - (0.03937008 * (1 + printer_extrusion_width)),
                           threads_per_inch = 8, 
                           length = 7/8, 
                           taper = 1/16, 
                           leadin = 1,
                           leadfac = 3,
                           test = false,
                           internal = false
            );
            cylinder(d = (4.25 * 25.4) - (0.03937008 * 1 + printer_extrusion_width), h = 7/8 * 25.4, $fn = $preview ? 50: 180);
        }
        
        // Drain outlet standoff
        translate([0, -(pipe_id / 2) + (1.05 * 25.4 / 2) + 10, 7/8 * 25.4 + 10])
        rotate([180, 0, 0])
            cylinder(d = 1.05 * 25.4 + ideal_perimeter * 3, h = 10, $fn = $preview ? 32 : 180);
    }


    union() {
        // Main outer torroid.
        translate([0, 0, (1/4 + 1/8) * 25.4]) {
            rotate_extrude($fn = 180) 
                translate([(pipe_id / 2) -   ideal_perimeter - (1/4 * 25.4), 0, 0]) 
                    circle(d = 1/2 * 25.4, $fn = $preview ? 32 : 90);
        }
        
        // Drain lip (determines water height)
        rotate([0, 0, 180])
        intersection() {
            cylinder(r = pipe_id / 2 - ideal_perimeter, h = (1/4 + 3/8) * 25.4, $fn = $preview ? 32 : 90);
            translate([-drain_point, -pipe_id / 2 + water_level - 1/2 * 25.4, 0]) {
                hull() {
                    cube([drain_point * 2, 1/2 * 25.4, 1/8 * 25.4]);
                    translate([0, 0, (1/8 + 3/8) * 25.4])
                        cube([drain_point * 2, (1/2 + 1/4) * 25.4, 1/8 * 25.4]);
                }
            }
        }
        
        // Air Vent
        for(rz = [-10 : 1 : 10]) {
            rotate([0, 0, rz])
                translate([0, (pipe_id / 2) - ideal_perimeter - (1/4 * 25.4), (1/8 + 1/4) * 25.4])
                    rotate([-10, 0, 0]) 
                        cylinder(d = 1/4 * 25.4, h = 7/8 * 25.4);
        }
        
        // M4 tappable plug hole for draining.
        translate([0, -1 * (pipe_id / 2 - 3.7 / 2), 0]) {
            cylinder(d = 3.7, h = 7/8 * 25.4 + 1, $fn = 32);
            translate([0, 0, 7/8 * 25.4]) cylinder(d = 7, h = 20, $fn = 90);
        };
        
        translate([0, -(pipe_id / 2) + (1.05 * 25.4 / 2) + 10, (1/4 + 1/8) * 25.4]) {
            cylinder(d = 5/8 * 25.4, h= 30);
            translate([0, 0, 1/16 * 25.4]) sphere(d = 5/8 * 25.4);
            hull() {
                rotate([0, 0, 0]) rotate([90, 0 , 0]) cylinder(d = 1/2 * 25.4, h= 15);
                rotate([0, 0, 45]) rotate([90, 0 , 0]) cylinder(d = 1/2 * 25.4, h= 15);
                rotate([0, 0, -45]) rotate([90, 0 , 0]) cylinder(d = 1/2 * 25.4, h= 15);
            }
        }
    }

    // The thread for the inlet / drain
    translate([0, -(pipe_id / 2) + (1.05 * 25.4 / 2) + 10, 7/8 * 25.4 + 10])
    rotate([180, 0, 0])
    {
        english_thread(diameter = 1.05, 
                       threads_per_inch = 14, 
                       length = 1, 
                       taper = 1/16, 
                       internal = true, test = $preview);
    }
    
    translate([-63 / 2, -7.25 / 2, 18/32 * 25.4]) cube([63, 7.25, 50]);
}