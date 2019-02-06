
wall = 1.8;

bottom = wall;
top = 0;
board_x_padding = [0.5, 0.5];
board_y_padding = [5, 0.5];
board_z_padding = [5, 4];

board_x = 25;
board_y = 24;
board_z = 1;

x = board_x_padding[0] + board_x + board_x_padding[1];
y = board_y_padding[0] + board_y + board_y_padding[1];
z = board_z_padding[0] + board_z + board_z_padding[1] + top;


pegs = false;

$fn = 90;
//case_front();
case_back();

module case_back() {
    difference() {
        union() {
            hull() {
                translate([x / 2, y / 2, z]) sphere(r = wall);
                translate([x / 2, -y / 2, z]) sphere(r = wall);
                translate([-x / 2, y / 2, z]) sphere(r = wall);
                translate([-x / 2, -y / 2, z]) sphere(r = wall);
                translate([0, 0, z - top - board_z_padding[1]]) {
                    translate([x / 2, y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([x / 2, -y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([-x / 2, y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([-x / 2 , -y / 2, 0]) cylinder(r = wall, h = 1);
                }
            };
        }
        
        // Hollow for the M12 mount screws
        translate([-x / 2, - 2.5, -bottom]) 
            cube([x, 5, 10]);
           
        difference() {
            translate([-x / 2 + wall, -y / 2 + wall, 0]) cube([x - 2 * wall, y - wall * 1.5, z + 1]);

            // Posts for holes.
            for (mx = [0 : 1]) {
                mirror([mx, 0, 0]) {
                    translate([-x / 2 + board_x_padding[0] + 2, y / 2 - board_y_padding[1] - 2, z - top - board_z_padding[1]])
                    {
                        cylinder(d = 3.5, h = 1.5);
                        translate([0, 0, 1.5]) cylinder(d1 = 3.5, d2 = 8, h = board_z_padding[1] + top + wall - 1.5);
                    }
                    
                    translate([-x / 2 + board_x_padding[0] + 2, -y / 2 + board_y_padding[1] + 2, z - top - board_z_padding[1]])
                    {
                        cylinder(d = 3.5, h = 1.5);
                        translate([0, 0, 1.5]) cylinder(d1 = 3.5, d2 = 8, h = board_z_padding[1] + top + wall - 1.5);
                    }
                }
            }
        }
            
        for (mx = [0 : 1]) {
            mirror([mx, 0, 0]) {
                translate([-x / 2 + board_x_padding[0] + 2, y / 2 - board_y_padding[1] - 2, z - top - board_z_padding[1]])
                    cylinder(d = 1.8, h = board_z_padding[1] + top + wall);
                translate([-x / 2 + board_x_padding[0] + 2, y / 2 - board_y_padding[1] - 2, z + wall - 2.25])
                    cylinder(d = 3.8 + 0.4, h = 2.25);
                
                translate([-x / 2 + board_x_padding[0] + 2, -y / 2 + board_y_padding[1] + 2, z - top - board_z_padding[1]])
                    cylinder(d = 1.8, h = board_z_padding[1] + top + wall);
                translate([-x / 2 + board_x_padding[0] + 2, -y / 2 + board_y_padding[1] + 2, z + wall - 2.25])
                    cylinder(d = 3.8 + 0.4, h = 2.25);
            }
        }
        
        // 16mm wide exit hole for the ribbon cable.
        translate([-16 / 2, -y / 2 - wall, z - top - board_z_padding[1]])
            cube([16, wall * 2, board_z_padding[1] - wall]);

        case_front(negative = true);
    }
}

module case_front(negative = false) {
    difference() {
        union() {
            hull() {
                translate([x / 2, y / 2, 0]) sphere(r = wall);
                translate([x / 2, -y / 2, 0]) sphere(r = wall);
                translate([-x / 2, y / 2, 0]) sphere(r = wall);
                translate([-x / 2, -y / 2, 0]) sphere(r = wall);
                translate([0, 0, z - 1]) {
                    translate([x / 2, y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([x / 2, -y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([-x / 2, y / 2, 0]) cylinder(r = wall, h = 1);
                    translate([-x / 2 , -y / 2, 0]) cylinder(r = wall, h = 1);
                }
            };
            
            // Gopro mount
            difference() {
                hull() {
                    translate([0, - y / 2 - wall - 4 - 7.5, 7.5 - wall]) 
                        rotate([0,90, 0]) cylinder(d = 15, h = 9, center = true);
                    translate([-4.5, -y / 2 - wall, -wall]) cube([9, wall, z - board_z_padding[1]], false);
                };
                
                hull() {
                    translate([0, - y / 2 - wall - 4 - 7.5, 7.5 - wall]) 
                        rotate([0,90, 0]) cylinder(d = 15, h = 3, center = true);
                    translate([-1.5, -y / 2 - wall, -wall]) cube([3, wall, z - board_z_padding[1]], false);
                };
                
                translate([0, - y / 2 - wall - 4 - 7.5, 7.5 - wall]) 
                    rotate([0,90, 0]) cylinder(d = 5.25, h = 10, center = true);
            }
        }
        
        // Subtract out all the important bits.
        
        // Hollow out for the board.
        difference() {
            if (negative) {
                translate([-x / 2 + 0.2, -y / 2 + 0.2, 0]) cube([x - 0.4, y - 0.4, z + 1]);
            } else {
                translate([-x / 2, -y / 2, 0]) cube([x, y, z + 1]);
            }
            
            // Support for the mounting....
            for (mx = [0 : 1]) {
                mirror([mx, 0, 0]) {
                    difference() {
                        union() {
                            translate([-x / 2, -y / 2, 0])
                                cube ([x / 2, board_y_padding[0] , z - board_z_padding[1] - board_z]);
                            translate([-x / 2, -y / 2, 0])
                                cube([4, board_y_padding[0] + 4, z - board_z_padding[1] - board_z]);
                            translate([-x / 2, y / 2 - board_y_padding[1] - 4, 0])
                                cube ([board_x_padding[0] + 4, board_y_padding[1] + 4, z - board_z_padding[1] - board_z]);
                        }
                        
                        if (!pegs) {
                            union() {
                                translate([-x / 2 + board_x_padding[0] + 2, y / 2 - board_y_padding[1] - 2, 0])
                                    cylinder(d = 1.8, h = z - board_z_padding[1] + board_z);
                                
                                translate([-x / 2 + board_x_padding[0] + 2, -y / 2 + board_y_padding[1] + 2, 0])
                                    cylinder(d = 1.8, h = z - board_z_padding[1] + board_z);
                            }
                        }
                    }                        
                        
                    if (pegs) {
                        translate([-x / 2 + board_x_padding[0] + 2, y / 2 - board_y_padding[1] - 2, 0])
                            cylinder(d = 1.5, h = z - board_z_padding[1] + board_z);
                        translate([-x / 2 + board_x_padding[0] + 2, -y / 2 + board_y_padding[1] + 2, 0])
                            cylinder(d = 1.5, h = z - board_z_padding[1] + board_z);
                    }
                }
            }
        }
        
        // Hollow for the M12 mount.
        translate([-x / 2 + board_x_padding[0] + 4.25, -y / 2 + board_y_padding[0] + 1.25, -bottom]) 
            cube([16.5, 16.5, 10]);
        
        // LED
        translate([-x / 2 + board_x_padding[0] + 4.75, y / 2 - board_y_padding[1] - 4, -bottom])
            cylinder(d1 = 1.5, d2 = 1.5, h = bottom);
        
        // 16mm wide exit hole for the ribbon cable.
        translate([-16 / 2, -y / 2 - wall, z - top - board_z_padding[1]])
            cube([16, wall, board_z_padding[1] + 1]);
    }
}
