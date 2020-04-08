wall_thickness = 1.67;
nozzle_diameter = 0.4;

pipe_od = 21.4;

channel_width = 13;
channel_depth = 11;

$fn = $preview ? 32 : 90;

module joint(length = 50, hole = 3.15, single_hole = false) {
    $fn = 90;
    difference() {
        cube([length, channel_width, channel_depth], center = true);
        if (!single_hole) {
            translate([-0, 0, channel_depth / 2]) rotate([0, 45, 0]) cube([1, channel_width + 1, 1], center = true);
            for (xm = [0, 1]) {
                mirror([xm, 0, 0]) {
                    translate([-length / 4, 0, 0]) {
                        rotate([90, 0, 0]) cylinder(d = hole, h = channel_width + 5, center = true);
                        for (my = [0, 1]) {
                            mirror([0, my, 0]) {
                                translate([0, channel_width / 2 - 1.5 - wall_thickness, 0]) 
                                    nut_trap();
                            }
                        }
                    }
                }
            }
        } else {
            rotate([90, 0, 0]) {
                cylinder(d = hole, h = channel_width + 5, center = true);
                cube([3.45 * 2, hole, 3.5], center = true);
            }
            for (my = [0, 1]) {
                mirror([0, my, 0]) {
                    translate([0, channel_width / 2 - 1.5 - wall_thickness, 0]) 
                        nut_trap();
                }
            }
        }
    }
}


module nut_trap() {
    // M3 Nut Trap
    rotate([90, 0, 0]) hull() {
        rotate([0, 0, 30]) cylinder(h = 3, r = 3.45, $fn=6, center = true);
        translate([0, channel_depth / 2, 0]) rotate([0, 0, 30]) cylinder(h = 3, r = 3.45, $fn=6, center = true);
    }
}

module hanger() {
    difference() {
        translate([0, 0, (channel_depth + pipe_od) / 2 + 0.5]) difference() {
            hull() {
                rotate([90, 0, 0]) cylinder(d = pipe_od + wall_thickness * 2 + nozzle_diameter, h = channel_width, center = true);
                translate([0, 0, -pipe_od / 2]) cube([pipe_od, channel_width, 1], center = true);
           }
           rotate([90, 0, 0]) cylinder(d = pipe_od + nozzle_diameter, h = channel_width, center = true);
        }
        for (my = [0, 1]) {
            mirror([0, my, 0]) {
                translate([0, channel_width / 2 - 1.5 - wall_thickness, 0]) nut_trap();
            }
        }
    }
    joint(length = pipe_od, single_hole = true);
}

module wire_guide(length = 30, wire_od = 5, hole = 3.15) {
    difference() {
        hull() {
            cube([1, channel_width, channel_depth], center = true);
            translate([length - channel_depth / 2 - 0.5, 0, 0]) 
                rotate([90, 0, 0]) 
                    cylinder(d = channel_depth, h = channel_width, center = true);
        }
        translate([channel_depth, 0, channel_depth / 2]) rotate([90, 0, 0]) 
            minkowski() {
                hull() {
                    cylinder(d = channel_depth * 2 - wire_od, h = 1, center = true);
                    translate([length / 2 - channel_depth + wire_od, 0, 0]) cylinder(d = channel_depth * 2 - wire_od, h = 1, center = true);
                }
                sphere(d = wire_od - 1);
            }
            
        translate([length / 2 - 2.5, 0, 0]) {
            rotate([90, 0, 0]) {
                cylinder(d = hole, h = channel_width + 5, center = true);
            }
            translate([0, channel_width / 2 - 1.5 - wall_thickness, 0]) 
                nut_trap();
        }
    }
}

joint();
translate([0, channel_width * 3, 0]) rotate([-90, 0, 0]) hanger();
translate([0, channel_width * 6, 0]) wire_guide();