function inToMm(i) = i * 25.4;

$fn = 360;
peg(base = 1.5);

translate([0, 40, 0]) {
    peg(base = 0.5);
}

translate([40, 0, 0]) {
    sleeve();
}


module peg(base = 1.5, peg_length = 1/2) {
    cylinder(d = 12.2, h = inToMm(base + peg_length - (1/8)));
    translate([0, 0, inToMm(base + peg_length - (1/8))]) 
        cylinder(d1 = 12.2, d2 = 10, h = inToMm(1/8));
    cylinder(d = inToMm(3/4), h = inToMm(base));
}

module sleeve() {
    rotate([180, 270 , 0]) {
        intersection() {
            difference() {
                cylinder(d = 12.2, h = inToMm(4));
                cylinder(d = inToMm(3/8), h = inToMm(4));
            }
            translate([0, -12.2 / 2, 0]) {
                cube([12.2, 12.2, inToMm(4)]);
            }
        }
    }
}