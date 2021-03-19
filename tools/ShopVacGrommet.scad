// Dust Vacuum Grommet.
// Converts a 2.53" hole to 2.25" For friction fit with a shop-vac hose.
od = 2.53;
id = 2.25;
flange = 0.75 / 2;
nozzle_od = 0.4;

$fn = 360;

function inToMm(x) = x * 25.4;

module port() {
    difference() {
        union() {
            cylinder(d = inToMm(od), h = inToMm(0.75));
            cylinder(d = inToMm(od + flange * 2), h = 2);
        }
        cylinder(d1 = inToMm(id), d2 = inToMm(id) - 1, h = inToMm(0.75));
        for (rz = [0 : 90 : 270]) {
            rotate([0, 0, rz]) translate([inToMm(od + flange) / 2, 0, 0]) cylinder(d = 1.5, h = 2);
        }
    }
}

port();
translate([0, 0, -inToMm(1)]) plug();

module plug() {
    difference() {
        union() {
            translate([0, 0, -3]) 
                cylinder(d1 = inToMm(od + flange), d2 = inToMm(od + flange) - 2, h = 3);
            cylinder(d = inToMm(id) + nozzle_od / 2, h = inToMm(0.25));
            translate([0, 0, inToMm(0.25)])
                cylinder(d1 = inToMm(id) + nozzle_od / 2, 
                         d2 = inToMm(id) - nozzle_od, 
                         h = inToMm(0.25));
        }
        //M4 tap
        translate([0, 0, -3]) cylinder(d = 3.6, h = inToMm(0.75));
    }
}