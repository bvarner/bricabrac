$fn = 45;

difference() {
    union() {
        translate([0, 1, 0]) cylinder(d = 2.5, h = 6.5);
        translate([0, 4.3, 0]) cylinder(d = 2.5, h = 6.5);
        minkowski() {
            translate([0.75, 0.75, 0.75]) cube([24, 3.8, 5]);
            sphere(d = 1.5);
        }
    }

    // Tip Cut
    translate([25.5 - 2.5, 0, 0]) {
        intersection() {
            difference() {
                translate([-2.5, 0, 0]) cube([5, 10, 10]);
                rotate([-90, 0 , 0]) cylinder(r = 2.5, h = 10);
            }
            translate([.5, 0, 0]) cube([5, 10, 10]);
        }
    }
    
    // Bottom Cut
    translate([7.5, 0, 6.5]) rotate([-90, 0, 0]) cylinder(r = 2.5, h = 10);
    
    // Slant to connect...
    translate([7.5, 0, 4]) rotate([0, 5.5, 0]) cube([25, 5.5, 5]);
    
    // Lower Keys
    translate([-1.25, -1, 0]) {
        translate([1, 0, 0]) cube([4.5, 7.5, 2.85]);
        translate([0, 0, 2.85 + 2.45]) cube([5.5, 7.5, 2.85]);
    }
    
    // Lower Cut
    translate([-1.25, 1, 0]) cube([5.5, 3.3, 6.5]);
}


