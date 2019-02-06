// Rain Barrel Diverter
// Because all the others I've seen I just don't like.
// I measured my downspout with calipers. :-)
// The output nozzles do a pretty decent job of friction-engaging with standard garden hose.
// Think of it as an external barb.
// I wanted to get as much waterflow through these things as I could, and all the fittings I could find
// constrict flow.

nozzle_diameter = 0.4;
$fn = 90;

// Physical size of the outside of the downspout.
downspout_x = 55;
downspout_y = 85; 
downspout_wall_thickness = 2;

grit_drain_diameter = 1;

diverter_height = 185;
diverter_wall_thickness = 1.26;
diverter_wall = diverter_wall_thickness * 2;
diverter_radius = downspout_x / 2;

diverter_grate_wall_thickness = diverter_wall_thickness * 3;

//translate([0, 0, diverter_height]) rotate([0, 90, 0]) 
{
    difference() {
        union() {
            // Outter Hull
            difference() {
                union() {
                    cube([diverter_height, downspout_x + diverter_wall, downspout_y + diverter_wall]);
                    triangle(diverter_height, (downspout_x) * 2, diverter_radius + diverter_wall, downspout_y + diverter_wall);
                }
                
                translate([0, diverter_wall_thickness, diverter_wall_thickness]) union() {
                    cube([diverter_height, downspout_x, downspout_y]);
                    triangle(diverter_height, (downspout_x * 2) - diverter_wall, diverter_radius, downspout_y);
                }
            }
            
            

            // Inner Hull
            translate([diverter_height / 6, diverter_wall_thickness, diverter_wall_thickness])
            {
                // Slotted collection triangle
                difference() {
                    triangle(diverter_height / 1.5, downspout_x + 10, 0.1, downspout_y);
                    translate([diverter_grate_wall_thickness, 0, 0])
                        triangle((diverter_height / 1.5) - diverter_grate_wall_thickness, downspout_x + 10 - diverter_grate_wall_thickness, 0.1, downspout_y);
                    for (z = [0:5:downspout_y])  {
                        if (z % 10 == 0) {
                            translate([0, 0, z]) cube([diverter_height / 3, downspout_x, 6]);
                        }
                    }
                }
            }
            
            // Barbs
            translate([diverter_height / 2 + (7.5 * 4), diverter_wall_thickness + 13, downspout_y + diverter_wall]) inverted_barb();
            translate([diverter_height / 2 + (5.5), diverter_wall_thickness + 13, downspout_y + diverter_wall]) inverted_barb();
        }

        // Barb hollows
        translate([diverter_height / 2 + (7.5 * 4), diverter_wall_thickness + 13, diverter_wall_thickness]) cylinder(d = 15, h = downspout_y + diverter_wall_thickness + 20);
        translate([diverter_height / 2 + 5.5, diverter_wall_thickness + 13, diverter_wall_thickness]) cylinder(d = 15, h = downspout_y+ diverter_wall_thickness + 20);
        
        // grit drains
        for (z = [1:3]) {
            translate([diverter_height / 2, diverter_wall_thickness + (grit_drain_diameter / 2), (downspout_y / 4) * z])
                rotate([0, 90, 0]) cylinder(d = grit_drain_diameter, h = diverter_height / 2);
        }
    }
}


module triangle(length, height, radius, z) {
    hull() {
        translate([radius + 10, radius, 0]) cylinder(r = radius, h = z);
        translate([length - 10 - radius, radius, 0]) cylinder(r = radius, h = z);
        translate([length / 2, height - radius, 0]) cylinder(r = radius, h = z);
    }
}

module inverted_barb() {
    difference() {
        union() {
            cylinder(d1 = 26 + (diverter_wall_thickness * 2), d = 26, h = 10);
            cylinder(d = 21 + 5, h = 20);
        }
        union() {
            for ( z = [0:5:20] ) {
                translate([0, 0, z]) cylinder(d1 = 20 + nozzle_diameter, d2 = 21 + nozzle_diameter, h = 5);
            }
            cylinder(d = 20 + nozzle_diameter, h = 21);
        }
    }        
}