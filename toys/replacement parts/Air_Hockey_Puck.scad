od = 65;
thickness = 5;
rim_width = 5;
inset = 1;
$fn = 360;

union() {
    for (i= [0, 1]) {
        mirror([0,0,i]) 
        difference() {
            cylinder(d = od, h = thickness / 2);
            translate([0, 0, (thickness / 2)- inset]) cylinder(d = od - (2 * rim_width), h = inset + 1);
        }
    }
}