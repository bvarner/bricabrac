// Erector Set Replacement Wrench
$fn = 90;
// Nut
nut_side = 6.75;
length = 50;

difference() {
    translate([0, 0, 0.5]) minkowski() {
        difference() {
            union() {
                hull() {
                    cylinder(d = 10, h = 1);
                    translate([50, 0, 0]) 
                        cube([3, 5.25, 1]);
                }
                hull() {
                    cylinder(d = 10, h = 1);
                    translate([25, 1.25, 0])
                        cylinder(d = 10, h = 1);
                }
            }
            translate([10, 22, 0]) cylinder(d = 36, h = 2);
            mirror([0, 1, 0]) translate([25 / 2, 21, 0]) cylinder(d = 36, h = 2);
        }
        sphere(r = 0.5, $fn = 32);
    }
    translate([25, 1.25, 0]) cylinder(d = 4.5, h = 2);
    translate([-2.5, -6.25, 0]) rotate([0, 0, 35]) cube([nut_side, nut_side, 2]);
}