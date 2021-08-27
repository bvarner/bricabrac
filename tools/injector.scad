$fn = 90;
nozzle_d = 0.4;


od = 15;
wall = 0.85;
length = 80;
smooth = 3;
flange = 20;

opening = 6;

difference() {
    union() {
        translate([0, 0, length - (length / (2 * smooth))]) resize([0, 0, length / smooth]) sphere(d = od);
        cylinder(d = od, h = length - (length / (2 * smooth)));
        // flange
        resize([flange * 2 + od, od + flange, 0]) cylinder(d = 35, h = 2);
    }
    
    union() {
        translate([0, 0, length - (length / (2 * smooth))]) resize([0, 0, length / smooth - (wall * 2)]) sphere(d = od - (wall * 2) + nozzle_d);
        cylinder(d = od - (wall * 2) + nozzle_d, h = length - (length / (2 * smooth)));
    }
    cylinder(d = opening + nozzle_d, h = length + 10);
}

// The plunger
translate([flange * 4, 0, 0]) {
    union() {
        translate([0, 0, length - (length / (2 * smooth))]) resize([0, 0, length / smooth - (wall * 2)]) sphere(d = od - (wall * 2));
        difference() {
            cylinder(d = od - (wall * 2), h = length - (length / (2 * smooth)));
            for (rz = [0 : 90 : 360]) {
                rotate([0, 0, rz]) 
                    translate([wall / 2, wall / 2, 2]) cube([od, od, length - (length / (2 * smooth)) - 2]);
            }
        }
    }
}