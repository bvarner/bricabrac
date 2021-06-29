use <threadlib/threadlib.scad>;

difference() {
    union() {
        cylinder(d = 27.5, h = 15);
        translate([0, 0, 15])
            bolt("G1/2", length = 15, higbee_arc=30);
    }
    for (i = [0 : 30 : 360]) {
        echo(i);
        rotate([0, 0, i])
            translate([27.5 / 2, 0, 0])
                rotate([0, 0, 30]) cylinder(d = 5, $fn = 6, h = 15);
    }
    cylinder(d = 12, h = 40, $fn=360);
}