rim = 4.5;
$fn = 180;

difference() {
    union() {
        rim();
        translate([0, 0, 34.25]) rim();
        translate([44 / 2 - 4, 0, (38.75 / 2) - (13.75 / 2)]) mount();
        cylinder(d = 44.25, h = 38.75);
        translate([0, 0, (38.75 / 2)]) squeeze_point();
    }
    translate([0, 0, -0.5]) cylinder(d = 38, h = 40);
    translate([-40, -1, -0.5]) cube([40, 2, 40]);
    
    translate([-(44 / 2) - 8, -16, (38.75 / 2)]) rotate([-90, 0, 0]) {
        cylinder(d = 6, h = 31);
        cylinder(d1 = 13.5, d2 = 11.5, h = 2, $fn = 6);
        cylinder(d = 11.5, h = 7, $fn = 6);
    }
}

module rim() {
    minkowski() {
        cylinder(d = 38 + (2 * rim), h = rim);
        sphere(r = 0.25);
    }
}

module squeeze_point() {
    hull() {
        translate([0, 0, -8.5]) cylinder(d = 30, h = 17);
        translate([-(44 / 2) - 8, -15, 0]) rotate([-90, 0, 0]) minkowski() {
            cylinder(d = 16, h = 29);
            sphere(r = .5);
        }
    } 
}

module mount() {
    translate([0, -8, 0]) {
        $fn = 360;
        difference() {
            union() {
                hull() {
                    cube([16, 16, 13.75]);
                    translate([16 + 8.5, 8, 0]) cylinder(d = 16, h = 13.75);
                }
                translate([16 + 8.5, 8, 13.75]) cylinder(d1 = 16, d2 = 11.5, h = 3.5);
            }
            translate([16, -1, 2]) cube([18, 18, 3.25]);
            translate([16, -1, 13.75 - 3.5 - 2]) cube([18, 18, 3.25]);
            translate([16 + 8.5, 8, -0.5]) cylinder(d = 5, h = 18);
            translate([16 + 8.5, 8, 14]) cylinder(d = 9.5, h = 4, $fn = 6);
        }
    }
}
