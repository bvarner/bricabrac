/* based upon measurements taken from charlotte pipe company specs */
pipe_id = ((1.9 - (2 * 0.145)) * 25.4);
hose_end_od = 43.5;
$fn = 360;

difference() {
    union() {
        cylinder(d = hose_end_od + 3, h = 24);
        translate([0, 0, 20]) {
            cylinder(d = pipe_id, h = 25);
            translate([0, 0, 25])
                cylinder(d1 = pipe_id, d2 = pipe_id - 1, h = 4);
        }
    }
    
    cylinder(d = hose_end_od, h = 20);
    cylinder(d = 30, h = 50);
    translate([0, 0, 20]) cylinder(d1 = hose_end_od, d2 = 30, h = 4);
}
