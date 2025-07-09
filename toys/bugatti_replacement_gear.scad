use <MCAD/involute_gears.scad>;

$fn = 90;
difference() {
    union() {
        gear(number_of_teeth = 18,
             circular_pitch = 1.87,
             hub_diameter = 0,
             rim_width = 0,
             rim_thickness = 0,
             bore_diameter = 2.4,
             pressure_angle = 20,
             gear_thickness = 2.55, $fn = 90);
        gear(number_of_teeth = 9,
            circular_pitch = 2.4,
            hub_diameter = 0,
            rim_width = 0,
            rim_thickness = 0,
            bore_diameter = 2.4,
            pressure_angle = 20,
            gear_thickness = 6.45, $fn = 90);
    }
    difference() {
        cylinder(d = 8.25, h = 1.1);
        cylinder(d = 3.5, h = 1.1);
    }
}