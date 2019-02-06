printer_nozzle_od = 0.4;
height = 15;
$fn = 90;
difference() {
    cylinder(d= 5.5 - printer_nozzle_od, h = height);
    cylinder(d = 2.65 + printer_nozzle_od, h = height);
}