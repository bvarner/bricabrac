//30.14
//28.6
//30.14
//
//33.75
//40.75

$fn = $preview ? 64 : 360;

difference() {
    union() {
        cylinder(d1 = 40.75, d2 = 33.75, h = 10.65);
        cylinder(d1 = 40.75, d2 = 38.75, h = 5.25);
    }
    cylinder(d = 28.6, h = 10.65);
    cylinder(d = 30.14, h = 2.75);
    translate([0, 0, 2.75]) cylinder(d1 = 30.14, d2 = 28.6, h =0.25);
    translate([0, 0, 10.65 - 3]) cylinder(d = 30.14, h = 3);
}