holes_and_print();


module holes_and_print() {
    difference() {
        // Resultant size is [97.75, 46.5, 43]
        translate([42.75, 0, 45]) rotate([90, 0, 180])
            render() trim_depth();
        
        {
            // Cut out holes
            $fn = 64;
            
            // main power cable
            translate([97.75 - (25 / 2), -1, 22]) 
                rotate([-90, 0, 0]) cylinder(d = 6.5 + 0.4, h = 10);
            
            // centered hole
        //    translate([97.75 / 2, -1, 22]) 
        //        rotate([-90, 0, 0]) cylinder(d = 6.5 + 0.4, h = 50);
            
            // other side (output) cables
            translate([25 / 2 + 1.5, -1, 22]) {
                translate([-3.75, 0, 0])
                    rotate([-90, 0, 0]) cylinder(d = 4.75 + 0.4, h = 10);
                translate([+3.75, 0, 0])
                    rotate([-90, 0, 0]) cylinder(d = 4.75 + 0.4, h = 10);
            }
        }
    }
}

module trim_depth() {
    union() {
        intersection() {
            move_mount_hole();
            translate([-60, -10.5, 0]) cube([120, 10.5, 50]);
        }
        
        translate([0, 3.5, 0])
        intersection() {
            move_mount_hole();
            translate([-60, -10.5 - 3.5 - 40, 0]) cube([120, 40, 50]);
        }
    }
}

module move_mount_hole() {
        translate([0, 3.5, 0])
        union() {
            // move the mount hole by 2mm to the front.
            intersection() {
                fill_first_mount_hole();
                translate([-60, -50, 30]) cube([120, 5,20]);
            }
            intersection() {
                fill_first_mount_hole();
                translate([-60, -50, 0]) cube([120, 12, 30]);
            }

            // fill the gap
            translate([0, -3.5, 0]) {
                intersection() {
                    fill_first_mount_hole();
                    translate([0, -50 + 5 + 3.5, 30]) cube([60, 2, 20]);
                }
            }
            
            // create a gap.
            translate([0, -1.5, 0]) {
                // leave off the rounded corner
                intersection() {
                    fill_first_mount_hole();
                    translate([0, -50 + 5 + 3.5, 30]) cube([60, 41.5 - 4, 20]);
                }

                // only get the rounded corner and move it where it goes.
                translate([0, -2, 0])
                intersection() {
                    fill_first_mount_hole();
                    translate([0, -50 + 5 + 3.5 + 41.5 - 2, 30]) cube([60, 2, 20]);
                }
            }

            // get the other parts.
            translate([0, -3.5, 0]) {
                intersection() {
                    fill_first_mount_hole();
                    translate([-60, -50 + 5 + 3.5, 30]) cube([60, 41.5, 20]);
                }
                
                intersection() {
                    fill_first_mount_hole();
                    translate([-60, -50 + 12 + 3.5, 0]) cube([120, 34.5, 30]);
                }
            }
        }
}

module fill_first_mount_hole() {
    union() {
        flange_shrink();
        for (i = [0 : 2 : 10]) {
            translate([0, -i, 0])
            intersection() {
                flange_shrink();
                translate([20, -50 + 11.5, 30]) cube([25, 2, 20]);
            }
        }
    }
}


module flange_shrink() {
    // shorten the flange
    union() {
        translate([0, 0, -3.5]) intersection() { // upper rounded edges
            top_bottom();
            translate([-60, -50, 50 - 2]) cube([120, 50, 2]);
        }
        intersection() { // the bottom portion
            top_bottom();
            translate([-60, -50, 0]) cube([120, 50, 50 - 2 - 3.5]);
        }
    }
}


module top_bottom() {
    union() {
        // top
        translate([0, 0, -20]) intersection() {
            left_right();
            translate([-60, -50, 35]) cube([120, 50, 35]);
        }
        // bottom
        intersection() {
            left_right();
            translate([-60, -50, 0]) cube([120, 50, 15]);
        }
        // middle left (fills the hole)
        translate([0, 0, -15]) intersection() {
            left_right();
            translate([35, -50, 20]) cube([10, 50, 10]);
        }
    }
}


module left_right() {
    union() {
        // left side
        intersection() {
            import("Power_Shroud_.stl");
            translate([-60, -50, 0]) cube([60, 50, 70]);
        }
        // right side
        translate([-12.25, 0, 0]) intersection() {
            import("Power_Shroud_.stl");
            translate([0, -50, 0]) cube([60, 50, 70]);
        }
    }
}