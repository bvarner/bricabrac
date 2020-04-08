thickness = 0.2;
nozzle_diameter = 0.4;
hole_diameter = 3.2;

$fn = 360;

difference() {
    cylinder(d = 7, h = thickness, center = true);
    cylinder(d = hole_diameter + nozzle_diameter / 2, h = thickness + 1, center = true);
}
