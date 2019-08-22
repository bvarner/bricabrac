$fn = 90;
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
fpv_camera = [8, 8];
fpv_tilt = 15;

// Battery size by spec. Additional space is added to accomodate some slew,
// and typical 5mm in the x-axis for lipo connecitons internal to the pack.

// Ares FPV Stock is a 500mAh 853030.
//battery = [30, 30, 8.5];
// battery = [40, 31.5, 9.5];

// I have replacement 700mAh 802540's.
// [40, 25, 8.0] is a bit too tight, so here's my fix.
battery = [48, 26.5, 9];
battery_box_zgrow = layers(8) + layer_height(1);

breakaway_supports = true;

arms = true;
nacells = true;
battery_bay = true;
main_board_mounts = true;

nacell_bottoms = true;
fpv_board_clip = true;

collision_check = false;

difference() {
    union() {
        // The idea here is that we're translating everything to be baselined on the 0 at the z-axis.
        // we accomplish cube sizing based on outsets of the cube, by wall thickness and z-layers (FDM, baby)
        // All cubes are centered when constructed.
        if (battery_bay) translate([0, 0, (battery[2] + battery_box_zgrow) / 2]) {
            difference() {
                union() {
                    outsetcube(battery, [fwall, fwall * 3, battery_box_zgrow], center = true);
                    
                    // Add the arms
                    if (arms) translate([0, 0, -(battery[2] + battery_box_zgrow) / 2]) {
                        for (my = [0 : 1]) mirror([0, my, 0]) for (mx = [0 : 1]) mirror([mx, 0, 0]) arm();
                    }
                    
                    // FPV Camera spur
                    translate([-battery[0] / 2 - fwall / 2, -fpv_camera[0] / 2, -battery[2] / 2 - layers(4)]) hull() {
                        cube([wall, fpv_camera[1], battery[2] + battery_box_zgrow]);
                        rotate([0, -fpv_tilt, 0]) cube([wall, fpv_camera[1], battery[2] + battery_box_zgrow]);
                    }
                }
                // Battery insertion opening
                translate([fwall / 2, 0, layers(1) / 2]) resize([battery[0] + fwall, 0, 0]) 
                    color("pink")
                        outsetcube(battery, [0, 0, layers(2)], center = true);
                
                // Weight reductions.
                for (mx = [0, 1]) {
                    mirror([mx, 0, 0]) {
                        translate([0, 0, frame_height / 2]) cube([8, battery[1] + 10, battery[2] - frame_height], center = true);
                        translate([18, 0, frame_height / 2]) cube([8, battery[1] + 10, battery[2] - frame_height], center = true);
                        translate([0, 0, 2]) cube([battery[0] / 4, battery[1], battery[2] + 2], center = true);
                        translate([(battery[0] / 4) + 5, 0, 2]) cube([(battery[0] / 2) - ((battery[0] / 4) / 2 + 8), battery[1], battery[2] + 2], center = true);
                        translate([0, 0, -2]) cube([12, battery[1], battery[2] + 2], center = true);
                        translate([14.5, 0, -2]) cube([5, battery[1], battery[2] + 2], center = true);
                    }
                }
                
                // Make enough room to mount the fpv camera in the middle.
                for (my = [0, 1]) {
                    mirror([0, my, 0]) translate([0, battery[1] / 2 / 2 + (fpv_camera[0] / 4) - fwall / 2, 0]) cube([battery[0] + 10, (battery[1] - fpv_camera[0]) / 2 - fwall, battery[2]], center = true);
                }
            }

            // Printing support
            if (breakaway_supports) {
                difference() {
                    // support is not 'full height' to allow the top layers to gently sag while bridging.
                    // support is also not positioned directly atop the lower part, so as to be 'floating' when printed.
                    translate([twall, 0, layers(1) / 2]) cube([battery[0], wall, battery[2]], center = true);
                    for(mx = [0, 1])
                        mirror([mx, 0, 0]) 
                            for (x = [0 : 2])
                                translate([x * battery[0] / 6, 0, 0]) cube([battery[0] / 8, twall, battery[2] / 2], center = true);
                }
            }
        }

        if (main_board_mounts) {
            // main board mounts
            // 1.5mm standoffs & screw receivers
            // 18.25 oc x axis
            pinloc = [18, 14];
            for (my = [0 : 1]) {
                mirror([0, my, 0])
                for (mx = [0 : 1]) {
                    mirror([mx, 0, 0])
                        translate([pinloc[0] / 2, pinloc[1] / 2, (battery[2] + battery_box_zgrow - layers(2))]) {
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
        }


        // FPV Board clip.
        if (fpv_board_clip) color("green") translate([0, 0, -fpv_board[2]  / 2 - layers(8)]) {
            difference() {
                union() {
                    // main retention cube
                    outsetcube(fpv_board, [fwall, fwall * 3, layers(4)], center = true);
                    // antenna mount
                    translate([0, fpv_board[1] / 2 + fwall * 1.5, 0]) {
                        intersection() {
                            rotate([0, 90, 0]) rotate([0, 0, 30]) cylinder(d = 8, $fn = 6, h = 8, center = true);
                            cube([9, 8, fpv_board[2] + layers(4)], center = true);
                        }
                    }
                }
                // antenna mount
                translate([0, fpv_board[1] / 2 + fwall * 1.5, ((fpv_board[2] - (4.75 + nozzle_diameter)) / 2) + layers(4)]) {
                    rotate([0, 90, 0]) cylinder(d = 4.75 + nozzle_diameter, h = 10, center = true);
                    rotate([45, 0, 0]) translate([0, 0, 2.5]) cube([10, 4, 6], center = true);
                }
                
                // Open top cuts
                translate([0, 0, layers(2)]) {
                    // Remove the fpv board.
                    cube(fpv_board, center = true);
                    // cutouts for sides and what-not.
                    cube([fpv_board[0] + 10, fpv_board[1] - 4, fpv_board[2]], center = true);
                    for (mx = [0: 1]) mirror([mx, 0, 0]) translate([(fpv_board[0] - 4) / 4 + 2, 0, 0]) cube([(fpv_board[0] - 4 - 8) / 2, fpv_board[1] + 30, fpv_board[2]], center = true);
                }
                // Full thickness cuts
                translate([-fpv_board[0] / 2 + 12.5 + 5.5, -fpv_board[1] / 2 - fwall * 1.5, 0]) resize([18, 8, 0]) cylinder(d = 2, h = fpv_board[2] + layers(8), $fn = 6, center = true);
                for (mx = [0 : 1]) mirror([mx, 0, 0])
                    translate([-fpv_board[0] / 4, 0, 0]) resize([16, 10, 0]) cylinder(d = 2, h = fpv_board[2] + layers(8), $fn = 6, center = true);
            }
        }
    }
    // Cuts
    // FPV Board screws
    for (my = [0 : 1]) mirror([0, my, 0]) for (mx = [0 : 1]) mirror([mx, 0, 0]) 
        translate([fpv_board[0] / 2 - (0.8 + nozzle_diameter) / 2, fpv_board[1] / 2 + (0.8 + nozzle_diameter) / 2 + fwall / 3, 3 + layer]) mirror([0, 0, 1]) screw_opening();
}

module outsetcube(dim, grow, center) {
    echo("outset dim:" , dim);
    if (len(grow) == undef) {
        echo("fixed increase");
        // add grow to each dimenions.
        cube([dim[0] + grow, dim[1] + grow, dim[2] + grow], center = center);
    } else {
        cube([dim[0] + grow[0], dim[1] + grow[1], dim[2] + grow[2]], center = center);
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

module arm() {
    translate([6.25 + (3 + 3 * twall) / 2, 35 / 2, 0]) union() {
        // Arm from body.
        translate([0, 4, frame_height]) wire_guide();
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
                if (nacells) {
                    translate([18, 0, 0]) mirror([0, 1, 0]) nacell();
                }
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
        translate([-(0.35 + nozzle_diameter) / 2, -(3 + 3 * twall) / 2, 1.5]) cube([0.35 + nozzle_diameter, 3 + 3 * twall, 2]);
        translate([0, 0, layer_height(3.55)]) 
            rotate([90, 0, 0]) 
                translate([0, 0, -(3 + 3 * twall) / 2])  resize([1.75, 3, 0]) rotate([0, 0, 30])
                    cylinder(d = 1, h = 3 + 3 * twall, $fn= 6);
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
            if (nacell_bottoms) {
                translate([0, 0, height - layer_height(1.5) - 15.5]) cube([20, 20, layer / 4], center = true);
            } else {
                translate([0, 0, -5]) cylinder(d = 20, h = height - layer_height(1.5) - 15.5 + 5);
            }
        }
        
        // LED
        color("red") {
            translate([-13, 0, 0]) cylinder(d = 2.8 + nozzle_diameter, h= height);
        }
    }
}