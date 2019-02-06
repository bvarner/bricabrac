difference() {
    // Starting geometry, solid cube.
    cube([153, 153, 16.5]);

    // subtract the outer curve
    difference () {
        cube([45, 45, 16.5]);
        translate([45, 45, 0])
            cylinder(16.6, r = 45);
    }
    
    // Subtract the inside of the outer curve.
    translate([2, 2, 0])
    
    union() {
        difference () {
            translate([48, 48, 0])
                scale([1/10, 1/10, 1/10])
                cylinder(80, r = 500);
            translate([48,48, 0])
                scale([1/10, 1/10, 1/10])
                cylinder(80, r = 480);
            translate([50, 0, 0])
                cube([50, 100, 8]);
            translate([0, 50, 0])
                cube([100, 50, 8]);
        };
        translate([50, -1.75, 0])
            cube([10, 2, 8]);
        translate([-1.75, 50, 0])
            cube([2, 10, 8]);
    }
}