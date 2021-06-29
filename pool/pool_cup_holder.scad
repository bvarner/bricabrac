can_diameter = 72;
wall_thickness = 0.86;
smoothing_thickness = 1.67;

bottom_thickness = 2;
$fn = 180;

difference() {
    union() {
        cylinder(d = can_diameter + 2 * wall_thickness, h = 60 + bottom_thickness);
        translate([0, 0, 60 - bottom_thickness]) {
            cylinder(d1 = can_diameter + 2 * wall_thickness, d2 = can_diameter + 4 * wall_thickness, h = bottom_thickness);
            translate([0, 0, bottom_thickness]) 
                cylinder(d = can_diameter + 4 * wall_thickness, h = bottom_thickness);
        }
        hull() {
            cylinder(d = can_diameter + 2 * wall_thickness, h = 25);
            translate([can_diameter / 2 + (4 * wall_thickness) + 2.5 + 37 / 2, 0, 0]) {
                cylinder(d = 8 + 37, h = 25);
            }
        }
    }
    
    translate([0, 0, bottom_thickness]) cylinder(d = can_diameter, h = 65);
    
    cylinder(d = can_diameter / 2, h = bottom_thickness * 2, center = true);
    
    translate([can_diameter / 2 + (4 * wall_thickness) + 2.5 + 37 / 2, 0, 0]) {
        cylinder(d = 37, h = 55, center = true);
        translate([37 / 2, 0, 0]) rotate([0, 0, 30]) cylinder(d = 37 + 8, h = 55, $fn = 6, center = true); 
        
        translate([0, 0, 4]) {
            difference() {
                cylinder(d = 37 + 11.5, h = 4);
                cylinder(d = 37 + 8, h = 4);
            }
        }
        translate([0, 0, 17]) {
            difference() {
                cylinder(d = 37 + 11.5, h = 4);
                cylinder(d = 37 + 8, h = 4);
            }
        }
        
    }
}
