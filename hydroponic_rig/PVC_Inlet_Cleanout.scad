use <threads.scad>;

printer_extrusion_width = 0.45;
ideal_perimeter = 2.54;
pipe_id = 3.786 * 25.4;

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
                           internal = false
            );
            cylinder(d = (4.25 * 25.4) - (0.03937008 * 1 + printer_extrusion_width), h = 7/8 * 25.4, $fn = $preview ? 50: 180);
        }
        
        
        translate([0, 2/3 * pipe_id / 2 - 1.05 * 25.4 / 2, 7/8 * 25.4 + 10])
        rotate([180, 0, 0])
            cylinder(d = 1.05 * 25.4 + ideal_perimeter * 3, h = 10, $fn = $preview ? 32 : 180);
    }

    // The thread for the inlet / drain
    translate([0, 0, 15/16 * 25.4 + 10]) 
    rotate([0, 0, 180])
    rotate([180, 0, 0])
    {
        translate([0, 2/3 * pipe_id / 2 - 1.05 * 25.4 / 2, 0]) {
            english_thread(diameter = 1.05, 
                           threads_per_inch = 14, 
                           length = 1, 
                           taper = 1/16, 
                           internal = true, test = $preview);
            cylinder(d = 1/2 * 25.4, h = 1 * 25.4);
            translate([0, 0, 1 * 25.4]) {
                cylinder(d = 1/2 * 25.4, h = 1/16 * 25.4);
                translate([0, 0, 1/16 * 25.4]) {
                    sphere(d = 1/2 * 25.4);
                    rotate([90, 0, 0]) 
                        cylinder(d = 1/2 * 25.4, h = 2 /3 * pipe_id / 2 - 1.05 * 25.4 / 2);
                }
            }
        }
        
        // Output
        union() {
            $fn = 32;
            translate([0, 0, (1 + 1/16) * 25.4]) {
                translate([pipe_id / 2 - (1/2 * 25.4), 0, 0])
                    sphere(d = 3/8 * 25.4);
                
                translate([-1 * (pipe_id / 2 - (1/2 * 25.4)), 0, 0])
                    sphere(d = 3/8 * 25.4);
                for (rz = [-90 : 45 : 90]) {                    
                    rotate([0, 0, 90 + rz]) 
                        rotate([0, 90, 0]) 
                            cylinder(d = max(5/16, abs(rz) / 90) * 3/8 * 25.4, h = (pipe_id / 2) - 1/2 * 25.4);
                }
                
                rotate_extrude(angle = 180) 
                    translate([pipe_id / 2 - (1/2 * 25.4), 0, 0]) 
                        circle(d = 3/8 * 25.4);
                
                intersection() {
                    difference() {
                        cylinder(d = pipe_id - (5/8 * 25.4), h = 5/16 * 25.4);
                        cylinder(d1 = pipe_id - (5/8 * 25.4) - 1/2 * 25.4,
                                 d2 = pipe_id - (5/8 * 25.4) - 1/8 * 25.4,
                                 h = 5/16 * 25.4 + 0.1);
                        for (rz = [22.5 : 22.5 : 180 - 22.5]) {                    
                            rotate([0, 0, rz]) cube([pipe_id, 3, 25.4]);
                        }
                    }
                    translate([- pipe_id / 2, 0, 0])
                        cube([pipe_id, pipe_id / 2, 25.4]);
                }
            }
        }
    };
    
    // Selective Infill.
//    translate([0, 0, 1/8 * 25.4]) {
//        difference() {
//            intersection() {
//                cylinder(d = pipe_id - (1/8) * 25.4, h = (7/8 - 1/4) * 25.4);
//                translate([-pipe_id / 2, - pipe_id / 2 - 7.25 / 2 - 2.12 - 2.12, 0]) 
//                    cube([pipe_id, pipe_id / 2, (7/8 - 1/4) * 25.4]);
//            }
//            for (rz = [0 : 30 : 150]) {
//                rotate([0, 0, rz]) cube([1.75 * 2, pipe_id, 25.4 * 2], center = true);
//            }
//        }
//    }
    
    translate([-63 / 2, -7.25 / 2, 18/32 * 25.4]) cube([65, 7.25, 50]);
}