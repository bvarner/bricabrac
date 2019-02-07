use <gopro_mounts_mooncactus.scad>;

nozzle_diameter = 0.4;
nozzle_radius = nozzle_diameter / 2;
$fn = 90;

// RocketStand Controller Box.
wall = 1.8 - nozzle_diameter;

bottom = 1.5;
top = 1.5;

corner_radius = 3;

// physical board sizes & clearance
board_x = 75.4;
board_y = 65;
board_z = 1.4;

board_x_padding = [0, 5]; // 0 on the axis side, 5 after
board_y_padding = [5, 10]; // plenty of room. 
board_z_padding = [4, 40 - board_z]; // 

x = board_x_padding[0] + board_x + wall * 2 + board_x_padding[1];
y = board_y_padding[0] + board_y + wall * 2 + board_y_padding[1]; // extra padding on one end.
z = bottom + board_z_padding[0] + board_z + board_z_padding[1] + top;

mount_locations = [
    [26.8, 3.5],
    [26.8, 3.5 + 58],
    [26.8 + 23, 3.5],
    [26.8 + 23, 3.5 + 58]
];




top_portion();
//bottom_portion();
//binding_post();
//gopro_extension();
//cable_sheath_mold();



module board(ease= corner_radius - top, cutout = true) {
    round_rect([
            x - (2 * wall),
            y - (2 * wall),
            board_z_padding[0] + board_z + board_z_padding[1]], 
        radius = corner_radius - wall, ease = ease);
    
    // Switch
    translate([-wall - 1, board_y_padding[0] + 10, board_z_padding[0] + board_z]) cube([17, 17.5, 12.6]);
    
    // Power
    translate([-wall -1, board_y_padding[0] + 43 + 7, board_z_padding[0] + board_z + 7]) rotate([0, 90, 0]) cylinder(d = 13, h = 18);
    
    // LED 
    translate([-wall -1, board_y_padding[0] + 36.5 + 1.5, board_z_padding[0] + board_z + 8 + 1.5]) rotate([0, 90, 0]) cylinder(d = 3 + nozzle_diameter, h = 10);
    
    if (cutout) {
        translate([0, 0, -bottom]) {
            // Switch
            translate([-wall - 1, board_y_padding[0] + 10, 0]) cube([17, 17.5, 12.6]);
            
            // Power
            translate([-wall-1, board_y_padding[0] + 43.5, 0]) cube([14, 13, bottom + board_z_padding[0] + board_z + 7]);
            
        }
    }
}

module round_rect(size, radius, ease = 0, ease_lower = false) {
    if (ease == 0) {
        hull() {
            translate([size[0] - radius, size[1] - radius, 0])
                cylinder(r = radius, h = size[2]);
            translate([size[0] - radius, radius, 0])
                cylinder(r = radius, h = size[2]);
            translate([radius, size[1] - radius, 0])
                cylinder(r = radius, h = size[2]);
            translate([radius, radius, 0])
                cylinder(r = radius, h = size[2]);
        }
    } else {
        hull() {
            if (!ease_lower) {
                translate([size[0] - radius, size[1] - radius, 0])
                    cylinder(r = radius, h = ease);
                translate([size[0] - radius, radius, 0])
                    cylinder(r = radius, h = ease);
                translate([radius, size[1] - radius, 0])
                    cylinder(r = radius, h = ease);
                translate([radius, radius, 0])
                    cylinder(r = radius, h = ease);
            } else {
                translate([size[0] - radius, size[1] - radius, ease])
                    resize([0, 0, ease * 2]) sphere(r = radius);
                translate([size[0] - radius, radius, ease])
                    resize([0, 0, ease * 2]) sphere(r = radius);
                translate([radius, size[1] - radius, ease])
                    resize([0, 0, ease * 2]) sphere(r = radius);
                translate([radius, radius, ease])
                    resize([0, 0, ease * 2]) sphere(r = radius);
            }
            
            translate([size[0] - radius, size[1] - radius, size[2] - ease])
                resize([0, 0, ease * 2]) sphere(r = radius);
            translate([size[0] - radius, radius, size[2] - ease])
                resize([0, 0, ease * 2]) sphere(r = radius);
            translate([radius, size[1] - radius, size[2] - ease])
                resize([0, 0, ease * 2]) sphere(r = radius);
            translate([radius, radius, size[2] - ease])
                resize([0, 0, ease * 2]) sphere(r = radius);
        }
    }
}

module gopro_extension() {
    translate([-x * 1.25, 0, 0]) {
        gopro_connector("double");
        gopro_extended(len=21)
            scale([1,-1,1])
                    gopro_connector("triple");
    }
    

    translate([-x * 1.25, 50, 0]) {
        gopro_connector("double");
        gopro_extended(len=95 / 2)
            scale([1,-1,1]) rotate([0, 180, 0])
                    gopro_connector("triple");
        
        linlen= (95/ 2 - 2*gopro_connector_y);
        translate([gopro_connector_x / 2 - 1.5, gopro_connector_y, -gopro_connector_z / 2 ]) {
            difference() {
                cube([3.5, linlen , gopro_connector_z]);
                translate([1.5, 0, (gopro_connector_z - 12) / 2]) cube([1, linlen, 12]); 
            }
        }
    }
}

module bottom_portion() {
    // lower platform
    difference() {
        union() {
            translate([wall + nozzle_radius, wall + nozzle_radius, 0]) 
                round_rect([x - 2 * wall - 2 * nozzle_radius, y - 2 * wall - 2 * nozzle_radius, 1 + bottom + board_z_padding[0]], corner_radius - wall - nozzle_radius);

            // cutouts for the things.
            translate([wall, wall, 0]) {
                // Switch
                translate([-wall, board_y_padding[0] + 10 + nozzle_radius, 0]) cube([17, 17.5 - nozzle_diameter, 12.6]);
                
                // Power
                translate([-wall, board_y_padding[0] + 43.5 + nozzle_radius, 0]) cube([14, 13 - nozzle_diameter, bottom + board_z_padding[0] + board_z + 7]);
                
            }
        };
        difference() {
           translate([wall, wall, bottom]) board(cutout = false);
            
            // Reinforcement of the lower wall.
            translate([wall, wall, bottom]) cube([wall, y, board_z_padding[0]]);
            translate([x - 2 * wall, wall, bottom]) cube([wall, y, board_z_padding[0]]);
            translate([wall, wall, bottom]) cube([x, wall, board_z_padding[0]]);
            translate([wall, y - 2 * wall, bottom]) cube([x, wall, board_z_padding[0]]);
            

            // Corner Support cutouts
            translate([wall, wall, bottom]) 
                cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
            translate([wall, y - wall - 5, bottom]) 
                cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
            translate([x - wall - 5, wall, bottom]) 
                cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
            translate([x - wall - 5, y - wall - 5, bottom]) 
                cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
            
            translate([wall, wall, bottom]) 
                cube([10, 10, 4 - bottom]);
            translate([wall, y - wall - 10, bottom]) 
                cube([10, 10, 4 - bottom]);
            translate([x - wall - 10, wall, bottom]) 
                cube([10, 10, 4 - bottom]);
            translate([x - wall - 10, y - wall - 10, bottom]) 
                cube([10, 10, 4 - bottom]);
            
        }
        cap_screws();
    }

    translate([wall + board_x_padding[0], wall + board_y_padding[0], bottom]) {
        for(location = mount_locations) {
            translate([location[0], location[1], 0]) standoff(height = board_z_padding[0]);
        }
    }
}

module top_portion() {
    union() {
        difference() {
            round_rect([x, y, z], corner_radius, corner_radius);
            
            difference() {
                translate([wall, wall, bottom]) {
                    board();
                }
                
                // Corner Support cutouts
                translate([wall, wall, bottom]) 
                    cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
                translate([wall, y - wall - 5, bottom]) 
                    cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
                translate([x - wall - 5, wall, bottom]) 
                    cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
                translate([x - wall - 5, y - wall - 5, bottom]) 
                    cube([5, 5, board_z_padding[0] + board_z + board_z_padding[1]]);
                
                // Ignition mount reinforcements
                translate([x * (1 / 4), y - wall - corner_radius - 5 , z - 1.5]) cylinder(d = 10, h = 3, center = true);
                translate([x * (3 / 4), y - wall - corner_radius - 5 , z - 1.5]) cylinder(d = 10, h = 3, center = true);
            }
            
            // remove the bottom
            translate([wall, wall, -1]) 
                round_rect([x - 2 * wall, y - 2 * wall, 1 + bottom + board_z_padding[0] + 1.05], corner_radius - wall);
            
            // screw mounts
            cap_screws(square = false);
            
            // camera cable slot
            translate([x / 2 - 17 / 2, y - wall - 5, z - top - 2]) cube([17, 1.25, top + 4]);
            
            // Load cell cable...
            translate([wall + board_x_padding[0] + 15, y, bottom + board_z_padding[0] + board_z + 1 + 6.5 / 2]) 
                rotate([90, 0 , 0]) cylinder(d = 6.5, h = 10, center = true);
            
            // Ventilation holes
            // Angled cuts
            step = y / 15;
            for (zd = [1 : 4]) {
                intersection() {
                    for(y = [0 : step : y]) {
                        translate([x / 2, y, z / 2]) rotate([(zd % 2 == 0 ? 30 : -30), 0, 0]) 
                            cube([x+ 2, step / 4, z], center = true);
                    }
                    
                    // Restraining Cubes
                    vent_y =  y - (2 * (wall + corner_radius)) - 5;
                    vent_z = z - bottom - top - corner_radius * 5;
                    translate([(zd < 3 ? wall : -1), wall + corner_radius + 2.5, 
                        bottom + corner_radius + 
                        ((zd - 1) * vent_z / 4) +
                        ((zd - 1) * corner_radius)
                    ])
                        cube([x + 2, vent_y, vent_z / 4]);
                }
            }
            
            // Ignition mount.
            translate([x * (1 / 4), y - wall - corner_radius - 5 , z]) cylinder(d = 3.3, h = 10, center = true);
            translate([x * (3 / 4), y - wall - corner_radius - 5 , z]) cylinder(d = 3.3, h = 10, center = true);
        }
        
        // Gopro camera mount
        translate([x / 2, y + gopro_connector_y, z - gopro_connector_z / 2 - corner_radius]) 
            rotate([270, 270, 270]) gopro_connector("triple");
    }
}

module cap_screw(square = true) {
    cylinder(d = 5.5 + nozzle_diameter, h = 3);
    if (square) {
        translate([-(5.5 + nozzle_diameter) / 2, -(5.5 + nozzle_diameter) / 2, 0])
            cube([(5.5 + nozzle_diameter) / 2, (5.5 + nozzle_diameter) / 2, 3]);
    }
    translate([0, 0, 3]) cylinder(d = 2.5 + nozzle_radius, h = 30);
}

module cap_screws(square = true) {
    translate([wall + 2.5, wall + 2.5, 0]) cap_screw(square);
    translate([wall + 2.5, y - (wall + 2.5), 0]) rotate([0,0,270]) cap_screw(square);
    translate([x - (wall + 2.5), y - (wall + 2.5), 0]) rotate([0,0,180]) cap_screw(square);
    translate([x - (wall + 2.5), wall + 2.5, 0]) rotate([0,0,90]) cap_screw(square);
}

module standoff(height = board_z_padding[1]) {
    difference() {
        cylinder(d= 5.5 - nozzle_diameter, h = height);
        cylinder(d = 2.5 + nozzle_radius, h = height);
    }
}

module binding_post() {
    translate([x * 1.25, 0, 0]) {
        difference() {
            cylinder(d = 11, h = 15);
            
            // rounded top
            difference() {
                translate([0, 0, 13]) cylinder(d = 11, h = 2);
                hull() {
                    translate([0, 0, 13])
                    rotate_extrude(convexity = 10)
                        translate([11 / 2 - 2, 0, 0])
                            circle(r = 2, $fn = 100);
                }
            }
            
            // knurl
            for(z = [0 : 30 : 360]) {
                rotate([0, 0, z]) translate([11 / 2 + .5, 0, 5]) cylinder(d = 2.25, h = 10);
            }
            
            // Beneath knurl
            translate([0, 0, 6])
            rotate_extrude(convexity = 10)
                translate([13 / 2, 0, 0])
                    circle(r = 2, $fn = 100);
            
            // Press-fit nut
            cylinder(d = 7.63 + nozzle_diameter, h = 4, $fn = 6);
            
            // Center bore
            cylinder(d = 4, h = 10);
        }
    }
}

// Injection mold for the load cell sheath.
module cable_sheath_mold() {
    translate([0, y * 1.25, 0]) {
        // Side A.
        difference() {
            union() {
                translate([0, -3.5, (wall * 2 + 15 / 2)]) 
                    cube([20, 7, wall * 4 + 15 + wall * 4], center = true);
                translate([7, 0, 6]) sphere(d = 3.5, center = true);
                translate([7, 0, 16]) sphere(d = 3.5, center = true);
                translate([-7, 0, 6]) sphere(d = 3.5, center = true);
                translate([-7, 0, 16]) sphere(d = 3.5, center = true);
            }
            sheath();
            translate([0, 0, - wall * 2]) {
                cylinder(d = 3.5 + nozzle_diameter, h = wall * 4 + 15 + wall * 4);
            }
            
            // sprue
            translate([0, -8, 1.5]) rotate([-90, 0, 0]) {
                cylinder(d2 = 4 + nozzle_diameter, d1 = 5.5 + nozzle_diameter, h = 4);
                translate([0, 0, 4]) cylinder(d = 4 + nozzle_diameter, h = 10);
            }

            translate([0, -8, wall * 4.5]) rotate([-90, 0, 0]) {
                cylinder(d = 1.5, h = 10);
            }
        }

        translate([0, 5, 0]) {
            // Side B.
            difference() {
                    translate([0, 3.5, (wall * 2 + 15 / 2)]) 
                        cube([20, 7, wall * 4 + 15 + wall * 4], center = true);
                    translate([7, 0, 6]) 
                        sphere(d = 3.5 + nozzle_diameter, center = true);
                    translate([7, 0, 16]) 
                        sphere(d = 3.5 + nozzle_diameter, center = true);
                    translate([-7, 0, 6]) 
                        sphere(d = 3.5 + nozzle_diameter, center = true);
                    translate([-7, 0, 16]) 
                        sphere(d = 3.5 + nozzle_diameter, center = true);
                sheath();
                translate([0, 0, - wall * 2]) {
                    cylinder(d = 3.5 + nozzle_diameter, h = wall * 4 + 15 + wall * 4);
                }
            }
        }
    }
}

module sheath() {
    difference() {
        union() {
                cylinder(d1 = 5.5, d2 = 8, h = wall * 4);
            translate([0, 0, wall * 4])
                cylinder(d1 = 8, d2 = 4.25, h = 15);
        };
        
        translate([0, 0, wall * 2.8]) {
            difference() {
                cylinder(d = 9, h = wall * 1.2);
                cylinder(d = 6, h = wall * 1.2);
            }
        };
    }
}

