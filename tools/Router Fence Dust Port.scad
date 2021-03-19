// Router Fence Dust Port
width = 103;
length = 156.5;

wall_thickness = 1.75;

vacuum_id = 2.25 * 24.5;
vacuum_od = vacuum_id + 4 * wall_thickness;
vacuum_stand = 10;

port_offset = -30;
port_opening = 57.5;
port_flare = 0.5;
port_depth = 20;

$fn = 360;

difference() {
    union() {
        cube([width, length, wall_thickness], center = true);
        // main air-flow entry
        translate([0, port_offset, 0]) {
            cylinder(d1 = vacuum_od + (((length / 2) - port_offset - vacuum_od) / 2), 
                     d2 = vacuum_od, h = vacuum_stand + port_depth + wall_thickness / 2);
        }
    }
    translate([0, port_offset, -wall_thickness / 2]) {
        cylinder(d = vacuum_id, h = vacuum_stand + port_depth + wall_thickness);
        
        translate([0, 0, wall_thickness / 2 + vacuum_stand]) {
            cylinder(d1 = port_opening, d2 = port_opening + port_flare, h = port_depth + wall_thickness / 2);
        }
    }
    
    // Mounting holes
    for (my = [0 : 1]) mirror([0, my, 0]) {
        for (mx = [0 : 1]) mirror([mx, 0, 0]) {
            translate([width / 2 - 6, 0, - wall_thickness]) {
                cylinder(d = 3, h = wall_thickness * 2);
                translate([0, -length / 2 + 6, 0]) 
                    cylinder(d = 3, h = wall_thickness * 2);
            }
        }
    }
}