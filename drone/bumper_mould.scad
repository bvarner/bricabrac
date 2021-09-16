// Rubberized Landing Bumper
// I'm replacing this with hot-melt glue stick injection moulded.
$fn = 90;
printer_nozzle_od = 0.4;

injection_mould = false;


module bumper() {
    cylinder(d = 5, h = 4);
    translate([0, 0, 4]) cylinder(d = 3.5, h = 3.5);
    translate([0, 0, 7.5]) sphere(d = 4);
    if (injection_mould == false) {
        translate([0, 0, 7.5]) {
            cylinder(d1 = 2.49, d2 = 1.67, h = 10);
        }
    }
}


module side() {
    difference() {
        translate([-10, -4, 0]) cube([65, 4, 15]);
        for (x = [0 : 15 : 45]) {
            translate([x, 0, 3])
                bumper();
            translate([x, 0, 0]) cylinder(d = 1, h = 5);
            translate([x, 0, 5]) cylinder(d = 1.5, h = 10);
            if (x < 45)
                translate([x, 0, 4]) rotate([0, 90, 0]) cylinder(d = 1.25, h = 15);
        }
        
        translate([-7, 3, 3]) rotate([90, 0, 0]) cylinder(d = 3, h = 10);
        translate([-7, 3, 12]) rotate([90, 0, 0]) cylinder(d = 3, h = 10);
        translate([52, 3, 3]) rotate([90, 0, 0]) cylinder(d = 3, h = 10);
        translate([52, 3, 12]) rotate([90, 0, 0]) cylinder(d = 3, h = 10);
    }
}

if (injection_mould == true) {
    difference() {
        translate([0, -5, 0]) side();
        // sprue
        for (x = [0 : 15 : 45]) 
            translate([x, -4, 5]) rotate([90, 0, 0]) cylinder(d1 = 2.5, d2 = 4 + printer_nozzle_od, h = 6);
    }
    translate([0, 5, 0]) mirror([0, 1, 0]) side();
} else {
    bumper();
}