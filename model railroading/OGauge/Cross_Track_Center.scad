function inToMm(i) = i * 25.4;

outer_dim = 1.5;
radius = 1/16;

cube_side = inToMm(1.5 - radius * 2);

// 1/16th inch radiuses.
difference() {
    union() {
        minkowski() {
            cube([cube_side, cube_side, inToMm(0.2 - radius * 2)], center = true);
            sphere(r = inToMm(radius), $fn = 90);
        }

        // Rail Walls
        for (rz = [0 : 90 : 270]) {
            rotate([0, 0, rz])
            translate([cube_side / 2, 0, 0]) {
                minkowski() {
                    cube([0.001, inToMm(0.6055) - inToMm(1/8), 2 * (inToMm(0.25) - inToMm(1/16))], center = true);
                    sphere(r = inToMm(radius), $fn = 90);
                }
            }
        }
        
        // Center Cylinder
        minkowski() {
            cylinder(d = inToMm(0.5), h = 2 * (inToMm(0.25) - inToMm(1/16)), center = true, $fn = 90);
            sphere(r = inToMm(radius), $fn = 90);
        }
    }
    
    // Center Hole
    translate([0, 0, 2.75]) cylinder(d = inToMm(0.25) + 1, h = 30, $fn = 90);
    cylinder(d = inToMm(0.125), h = 30, $fn = 90, center = true);
    
    // Square Corners
    for (rz = [0 : 90 : 270]) {
        rotate([0, 0, rz])
            translate([inToMm(0.75 - 0.0625), inToMm(0.75 - 0.0625), 0]) cube([inToMm(0.125), inToMm(0.125), 30], center = true);
    }
    
    // Flat Bottom
    translate([0, 0, -15.015]) cube([inToMm(2), inToMm(2), 30], center = true);
    
    // Track cut recesses
    for (rz = [1 : 2])
        rotate([0, 0, rz * 90])
            cube([inToMm(3), inToMm(0.6235), inToMm(0.035) * 2 + 0.2], center = true);
}

