//14.5 spread...
//so... 13.5 to a 15
$fn = 90;
wall_thickness = 1.74;

intersection() {
    difference() {
        intersection() {
            cylinder(d = 14.5 + (wall_thickness * 2), h = 5);
            translate([0, 3, 2.5]) cube([14.5 + (wall_thickness * 2), 14.5 + wall_thickness, 5], center = true);
        }
        cylinder(d = 14.5, h = 5);
    }
    translate([-(14.5 + (wall_thickness * 2)) / 2, -(14.5 + wall_thickness), 0]) cube([14.5 + (wall_thickness* 2), 14.5 + wall_thickness, 5]);
}
translate([-(14.5 + (wall_thickness * 2)) / 2, 0, 0]) cube([14.5 + (wall_thickness * 2), wall_thickness, 5]);