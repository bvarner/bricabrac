
nozzle_diameter = 0.4;

resize([28 + nozzle_diameter, 0, 6], auto=true)
difference() {
    translate([0, 0, 35]) rotate([0, 0, 0]) cylinder(d = 28, $fn =6, h = 6);
    import("Gardena_X_Male_050_NPT.stl");
    cylinder(r = 6, h = 45);
}