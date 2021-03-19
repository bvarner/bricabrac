difference() {
    cube([20, 30, 70]);

    roundover = 0.2 + 1.5875;

    translate([10, 10, 0]) 
    hull() {
        translate([roundover, roundover, 0])
        cylinder(r = roundover, h = 70, $fn = 90);
        translate([20 - roundover, roundover, 0])
            cylinder(r = roundover, h = 70, $fn = 90);
        translate([roundover, 30 - roundover, 0])
            cylinder(r = roundover, h = 70, $fn = 90);
        translate([20 - roundover, 30 - roundover, 0])
            cylinder(r = roundover, h = 70, $fn = 90);
    }
}