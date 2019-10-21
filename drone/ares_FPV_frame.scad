// Replacement air-frame for ARES Recon / Recon HD FPV drones.

// These machines use 8.5x20mm brushed motors, and a rather 'strange' battery size by default.
// I've attempted to make this as close to the original geometry as possible while moving the battery to the 'top'.
// I did this to make it easier to swap batteries, and to enable using larger batteries.
// As a result, the nacell mounts are attached slightly lower.
// To make this more printable, the boards and batteries mount on the lower part of the printed frame.
// The nacells are split in two and friction fit.
// We reuse:
//    props (2.5" or 65mm) sets.
//    prop guards (the nacells are designed to use the original ares prop guards)
//    screws (you'll need to keep a few on hand)
//    landing bumpers. They fit in the bottom of the nacells. :-)
//    
// The original frame (minus screws, props, guards) weighed in at ~13grams.
// Printing in PETG, PrusaSlicer says it'll be 11.88g. :-D
// 
$fn = 180;
nozzle_diameter = 0.4;
wall = 0.45; // one line
twall = 0.87; // two lines
fwall = 1.7; // four lines

// Settings for a 0.25mm nozzle.
//nozzle_diameter = 0.25;
//wall = 0.48; // one line
//twall = 0.71; // two lines
//fwall = 0.94; // four lines

motor_od = 8.5 + nozzle_diameter;
motor_tight = motor_od - 0.25;

screw_d = 1.5; // clearance diameter of screws.
screw_hole_d = 0.75 + nozzle_diameter; // for differencing a hole for a screw.

layer = 0.15;
function layer_height(target) = round(target / layer) * layer;
function layers(laf) = laf * layer;

frame_height = layer_height(3);

fpv_board = [40, 17, 5];  // with shielding.

// Battery size by spec. Additional space is added to accomodate some slew,
// and typical 5mm in the x-axis for lipo connecitons internal to the pack.

// Ares FPV Stock is a 500mAh 853030.
battery = [30, 30, 8.5];
// I have replacement 700mAh 802540's.
//battery = [40, 25, 8.0];
collision_check = false;

// arms are 17mm, then 21.5 to the body.
// body is 35mm wide, 50mm long.
// arms are 10mm apart.

// Main body.    
difference() {
    union() {
        translate([-25, -0.5 * (36 + twall), 0])
            cube([50, 36 + twall, frame_height]);
        // camera 8x8 mount (use double-stick tape)
        translate([-25, 0, 0]) rotate([0, 255, 0]) translate([0, -4, -2]) cube([8, 8, 2]);
        // fpv antenna mount
        hull() {
            translate([25 - 1, -4, 0]) cube([1, 8, frame_height]);
            translate([25 + 3.5, 0, 4]) rotate([90, 0, 0]) cylinder(d = 8, h = 8, center = true);
        }

        // main board mounts
        // 1.5mm standoffs & screw receivers
        // 18.25 oc x axis
        pinloc = [18, 14];
        for (my = [0 : 1]) {
            mirror([0, my, 0])
            for (mx = [0 : 1]) {
                mirror([mx, 0, 0])
                    translate([pinloc[0] / 2, pinloc[1] / 2, frame_height]) {
                        if ((mx == 0 && my == 0) || (mx == 1 && my == 1)) {
                            difference() {
                                cylinder(d = 3, h = layer_height(1.75));
                                cylinder(d = 0.85 + nozzle_diameter, h = layer_height(1.75));
                            }
                        } else {
                            cylinder(d = 1.5, h = 3.5);
                            translate([-1.5, -twall / 2, 0]) cube([3, twall, layer_height(1.75)]);
                        }
                    }
            }
        }
        
        // stands for the battery bay.
        for (my = [0 : 1]) {
            mirror([0, my, 0])
            for (mx = [0 : 1]) {
                mirror([mx, 0, 0]) {
                    translate([-fpv_board[0] / 2 + fwall, (-36 - twall) / 2, 0]) {
                        cube([fwall + 1 + fwall, fwall + 1 + fwall, layer_height(9)]);
                    }
                }
            }
        }
        
        
        // Battery bay.
        difference() {
            hull() {
                translate([-(battery[0] + 5 + nozzle_diameter + fwall) / 2 - 2.5,  (-36 - twall) / 2, layer_height(9) + layers(1)])
                    cube([battery[0] + 5 + nozzle_diameter + fwall + 5, 36 + twall, layers(3)]);
                translate([-(battery[0] + 5 + nozzle_diameter + wall * 2) / 2,  
                                -(battery[1] + nozzle_diameter + wall * 2) / 2, 
                                layer_height(9) + layers(4) + (2 / 3) * battery[2] - 0.5])
                    cube([battery[0] + 5 + nozzle_diameter + wall * 2, battery[1] + nozzle_diameter + wall * 2, layers(1)]);
            }
            // Battery Space.
            // 9 + space + bottom thickness + midpoint of battery
            color("pink")
                translate([(battery[0] + 5 + nozzle_diameter) * -0.5, 
                    (battery[1] + nozzle_diameter) * -0.5, 
                    layer_height(9) + layers(1) + layers(3)]) 
                    cube([battery[0] + 5 + nozzle_diameter, battery[1] + nozzle_diameter, battery[2]]);
            // Rubber band hooks
            for (my = [0, 1]) mirror([0, my, 0]) {
                for (mx = [0, 1]) mirror([mx, 0, 0]) {
                    translate([-(battery[0] + 5 + nozzle_diameter + fwall) / 2 - 2.5 + 1.25,  -3, layer_height(9)])
                        rotate([0, 0, 30])
                            cylinder(d = 3, $fn = 6, h = (2 / 3) * battery[2]);
                    translate([-(battery[0] + 5 + nozzle_diameter + fwall) / 2 - 2.5 + fwall,  -3, layer_height(9)])
                        rotate([-90, 0, 0])
                            rotate([0, 0, 30])
                            cylinder(d = 2, $fn = 6, h = (2 / 3) * battery[2]);
                    translate([-3,  (-36 - twall) / 2 + 1.25, layer_height(9)])
                        cylinder(d = 3, $fn = 6, h = (2 / 3) * battery[2]);
                    translate([-3,  (-36 - twall) / 2 + fwall, layer_height(9)])
                        rotate([0, 90, 0])
                            cylinder(d = 2, $fn = 6, h = (2 / 3) * battery[2]);
                    // cut to middle.
                    translate([-(battery[0] + 5 + nozzle_diameter + fwall) / 2 - 2.5,  7.5, layer_height(9) + layers(4)])
                    rotate([0, 0, 30])
                        cube([(battery[0] + 5 + nozzle_diameter + fwall) / 2, 10, battery[2] + 1]);
                }
            }
        }
        
        
        // FPV Board Clip
        translate([-fpv_board[0] / 2 - 0.88 - twall, -fpv_board[1] / 2 - 2.88 - twall, -layers(1)]) {
            remaining_height = fpv_board[2] - (frame_height - layers(3)) + layers(3);
            mirror([0, 0, 1]) {
                difference() {
                    cube([fpv_board[0] + 2 * (twall + 0.88), 
                             fpv_board[1] + 2 * (twall + 2.88),
                             remaining_height]);
                    // Move to the edge of the board...
                    translate([0.88 + twall, 2.88 + twall, 0]) {
                        translate([-3, 1.25, 0]) cube([fpv_board[0] + 6, fpv_board[1] - 2.5, remaining_height - layers(3)]);
                        translate([2, -4, 0]) cube([fpv_board[0] - 4, fpv_board[1] + 8, remaining_height - layers(3)]);
                        translate([fpv_board[0] / 4, fpv_board[1] / 2, 0]) cylinder(d = fpv_board[1], $fn = 6, h = fpv_board[2]);
                        translate([fpv_board[0] * 3/4, fpv_board[1] / 2, 0]) cylinder(d = fpv_board[1], $fn = 6, h = fpv_board[2]);
                        // cut for micro SD card insert...
                        translate([12.5 + 5.5, -4, 0]) resize([18, 8, 0]) cylinder(d = 16, h = fpv_board[2], $fn = 6);
                    }
                }
            }
        }
        
        // arms
        mirror([0, 0, 0]) arm();
        mirror([1, 0, 0]) arm();
        mirror([0, 1, 0]) {
            mirror([0, 0, 0]) arm();
            mirror([1, 0, 0]) arm();
        }
    }

    // weight reductions
    resize([12, 36 - fwall * 6, 0]) rotate([0, 0, 45]) cylinder($fn = 4, d = 10, h = frame_height + 1);
    translate([16, 0, 0]) resize([8, 17, 0]) rotate([0, 0, 45]) cylinder($fn = 4, d = fpv_board[1], h = frame_height + 1);
    translate([-16, 0, 0]) resize([8, 17, 0]) rotate([0, 0, 45]) cylinder($fn = 4, d = fpv_board[1], h = frame_height + 1);
    for (mx = [0, 1]) mirror([mx, 0, 0]) for(my = [0, 1]) mirror([0, my, 0]) {
        translate([(-(battery[0] + 5 + nozzle_diameter + fwall) / 2 - 2.5) / 2, 
                        ((-36 - twall) / 2) / 2,
                        layer_height(9)])
            cylinder(d = 12, h = layers(5) + battery[2] + 1, $fn = 6);
    }
    translate([0, 0, layer_height(9)]) cylinder(d = 12, h = 2, $fn = 6);
    
    // clipped corners
    for (my = [0 : 1]) {
        mirror([0, my, 0])
        for (mx = [0 : 1]) {
            mirror([mx, 0, 0])
                translate([-25, - 0.5 * (36 + twall), -10]) rotate([0, 0, -25])
                    cylinder($fn = 3, d = 29, h =26);
        }
    }
    
    // battery mount screws.
    color("blue")
    for (my = [0 : 1]) {
        mirror([0, my, 0])
        for (mx = [0 : 1]) {
            mirror([mx, 0, 0])
                translate([-fpv_board[0] / 2 + fwall + fwall + 0.5, 
                                (-(36 + twall) / 2 ) + fwall + 0.5,
                                frame_height + layer_height(9) + layers(3)]) 
                mirror([0, 0, 1]) {
                    screw_opening();
                }
        }
    }
    
    // fpv board and anchors
    color("green") {
        // board, recessed 2.25mm + 1.25 for shielding, and padding.
         translate([0, 0, -fpv_board[2] / 2 + frame_height - layers(3)])
            cube(fpv_board, center = true);
        
        // FPV bracket_screws
        for (my = [0 : 1]) {
            mirror([0, my, 0])
            for (mx = [0 : 1]) {
                mirror([mx, 0, 0])
                    translate([-fpv_board[0] / 2 + twall, -fpv_board[1] / 2 - 1.44 - wall, frame_height + layers(4) + layer_height(0.75)])
                        mirror([0, 0, 1]) screw_opening();
            }
        }
        // do these twice, to balance weight
        for (my = [0 : 1]) {
            mirror([0, my, 0]) {
                // antenna wire cut.
                translate([fpv_board[0] / 2, fpv_board[1]/ 2 - 2, 0]) cylinder(d = 3, h = frame_height - layers(3));
                // control and voltage cut.
                translate([-fpv_board[0] / 2, fpv_board[1]/ 2 - 3.75, 0]) cylinder(d = 5, h = frame_height - layers(3));
            }
        }
        // antenna mount cut.
        translate([25 + 3.5, 0, 3.5]) rotate([90, 0, 0]) cylinder(d = 4.75 + nozzle_diameter, h = 8.5, center = true);
        translate([25 + 3.5, 0, 3.5]) rotate([0, -45, 0]) translate([0, -4.25, -2]) cube([8, 8.5, 4]);
    }
}

module arm() {
    translate([6.25 + (3 + 3 * twall) / 2, 35 / 2, 0]) union() {
        // Arm from body.
        translate([0, 0, frame_height]) wire_guide();
        hull() {
            translate([(3 + 3 * twall) * -0.5, -35 / 2, 0])
                cube([(3 + 3 * twall), (3 + 3 * twall), frame_height]);
            translate([0, 21.5, 0]) cylinder(d = 3 + 3 * twall, h = frame_height);
        }

        // Arm to nacell
        translate([0, 21.5, frame_height]) rotate([0, 0, -45]) wire_guide();
        translate([0, 21.5, 0])  {
            union() {
                hull() {
                    cylinder(d = 3 + 3 * twall, h = frame_height);
                    translate([18 - ((3 + 3 * twall) * 1.5), (3 + 3 * twall) * - 0.5, 0])
                        cube([3.1 + 3 * twall, 3 + 3 * twall, frame_height]);
                }
                translate([18, 0, 0]) mirror([0, 1, 0]) nacell();
            }
        }
    }
}

module wire_guide() {
    difference() {
        translate([0, 0, -layers(1)]) cylinder(d1 = 3 + 3 * twall, d2 = fwall *1.5, h = layer_height(3));
        translate([0, 0, layer_height(1)]) 
            rotate([90, 0, 0]) 
                translate([0, 0, -(3 + 3 * twall) / 2]) 
                    cylinder(d = 2, h = 3 + 3 * twall);
        translate([-(0.4 + nozzle_diameter) / 2, -(3 + 3 * twall) / 2, 1.5]) cube([0.4 + nozzle_diameter, 3 + 3 * twall, 2]);
        translate([0, 0, layer_height(3.55)]) 
            rotate([90, 0, 0]) 
                translate([0, 0, -(3 + 3 * twall) / 2])  resize([1.75, 3, 0]) rotate([0, 0, 30])
                    cylinder(d = 1, h = 3 + 3 * twall, $fn= 6);
    }
}

module screw_opening() {
    $fn = 64;
    union() {
        translate([0, 0, -0.5]) cylinder(d = 2.33 + nozzle_diameter, h = 3);
        intersection() {
            translate([0, 0, -0.5]) cylinder(d = 2.33 + nozzle_diameter, h = 3 + layer);
            translate([0, 0, 2.5 + layer]) cube([2.33 + nozzle_diameter, 0.8 + nozzle_diameter, layers(2)] , center = true);
        }
        translate([0, 0, 2.5]) cylinder(d = 0.8 + nozzle_diameter, h= 7);
    }
}

module nacell(height = layer_height(24.5)) {
    nacell_od = 10.25;
    translate([13, 0, -(height - layer_height(1.5) - 15.5)])
    difference() {
        union() {
            hull() {
                cylinder(d = nacell_od, h = height);
                translate([0, 0, -layer_height(1.4)])
                        cylinder(d = 6 + twall, h = layer_height(1.5));
            }
            if (collision_check) {
                color("black") {
                    translate([0, 0, height + 1])
                        cylinder(d = 65, h = 3);
                }
            }
            
            translate([0, 0, height - layer_height(1.5) - 2.5 -  3.5 - layer_height(0.5)]) {
                hull() {
                    intersection() {
                        union() {
                            cylinder(r = 6.25 + (2 / 2) + twall, h = 3.5 + layer_height(0.5));
                            translate([0, 0, -2]) cylinder(d1 = nacell_od, r2 = 6.25 + (2 / 2) + twall, h = 2);
                        };
                        translate([-2 / 2 - wall, 2 / 2 + wall, -2]) rotate([0, 0, -90]) cube([6.25 + 2 + 2 * twall, 6.25 + 2 + 2 * twall, 3.5 + layer_height(0.5) + 2]);
                    }
                    translate([0, 0, -2]) cylinder(d = nacell_od, h = 3.5 + layer_height(0.5) + 2);
                }
            }
            
            translate([0, 0, -layer_height(1.4)]) {
                hull() {
                    cylinder(d = 7.5 + twall, h = layer_height(1.5));
                    translate([0, 0, -layer_height(0.75)]) 
                        cylinder(d = 6 + twall, h = layer_height(0.75)) ;
                }
                hull() {
                    translate([0, 0, -layer_height(0.75)]) 
                        cylinder(d = 6 + twall, h = layer_height(0.75)) ;
                    translate([0, 0, -layer_height(1)]) 
                        cylinder(d = 6 + twall, h = layer_height(1));
                }
            }
            
            // Nacell Connection
            hull() {
                translate([-13 + ((3 + 3 * twall) * - 0.5), (3 + 3 * twall) * - 0.5, height - layer_height(1.5) - 15.5]) 
                    cube([3 + 3 * twall, 3 + 3 * twall, frame_height]);
                translate([-8, 0, height - layer_height(1.5) - 15.5]) 
                    cylinder(d = 3 + 3 * twall, h = frame_height);
            }
            hull() {
                translate([-8, 0, height - layer_height(1.5) - 15.5]) 
                    cylinder(d = 3 + 3 * twall, h = frame_height);
                translate([0, 0, height - layer_height(1.5) - 15.5])                 
                    cylinder(d = nacell_od, h = layer_height(5));
            }
        }
        
        // Brushed Motor & Landing Pad Stack.
        color("grey") {
            // Cutouts for prop guards
            rotate([0, 0, 45]) {
                translate([0, 0, height - layer_height(1.5) - 1.25]) cube([4, nacell_od, 2.5], center = true);
                rotate([0, 0, 90]) translate([0, 0, height - layer_height(1.5) - 1.25]) cube([4, nacell_od, 2.5], center = true);
            }

            // Need 1.6mm holes at the proper spots for mounting the guards.
            translate([0, 0, height - layer_height(1.5) - 2.5 -  3.5]) {
                translate([0, -6.25, 0]) cylinder(d = 1.6 + nozzle_diameter, h = 3.5);
                translate([6.25, 0, 0]) cylinder(d = 1.6 + nozzle_diameter, h = 3.5);
                rotate([0, 0, -45]) translate([6.5, 0, 0]) cylinder(d = 1.6 + nozzle_diameter, h = 3.5);
            }
            
            // Landing Pad and motor stack
            translate([0, 0, height - layer_height(1.5) - 20]) {
                cylinder(d = motor_tight - 0.2, h = 4); // super-tight
                translate([0, 0, 4]) cylinder(d = motor_tight, h = 11); // tight
                translate([0, 0, 15]) cylinder(d = motor_od, h = 5); // loose
                translate([0, 0, 20]) cylinder(d1 = motor_tight, d2 = 6, h = layer_height(1));
                translate([0, 0, 19]) cylinder(d = 6, h = layer_height(1.5) + 2);
                translate([0, 0, -7]) {
                    sphere(d = 4);
                    cylinder(d = 4, h = 3);
                    translate([0, 0, 3]) cylinder(d = 5, h = 4);
                }
            }
            
            // Friction fit slot. (doubles as wire egress)
            rotate([0, 0, 180]) translate([0, -1, height - layer_height(1.5) - 20 - 1]) {
                cube([nacell_od - 1, 2, 7 + 9]);
                translate([nacell_od - 1, 1, 0]) cylinder(d = 2, h = 7 + 9);
            }
            
            // horizontal cut for landing bumper.
            translate([0, 0, height - layer_height(1.5) - 15.5]) cube([20, 20, layer / 4], center = true);
        }
        
        // LED
        color("red") {
            translate([-13, 0, 0]) cylinder(d = 2.8 + nozzle_diameter, h= height);
        }
    }
}
    


