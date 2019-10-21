printer_nozzle_od = 0.4;

$fn = $preview ? 32 : 90;

// standoff (m3)

difference() {
    cylinder(d = 6, h = 6.75);
    cylinder(d = 2.7 + printer_nozzle_od, h = 6.75);
}

// button
translate([20, 0, 0]) {
    cylinder(d1 = 3.5, d2 = 6, h = 6.75 - (4.5 + 0.25));
    cylinder(d1 = 3.5, d2 = 3.25, h = 6.75 - (4.5 + 0.25) + 5.5 + 2);
}