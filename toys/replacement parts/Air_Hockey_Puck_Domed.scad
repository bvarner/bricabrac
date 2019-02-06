thickness = 5;

od = 65;
rim_width = 5;

inset = 0.8;
dome = 1;

$fn = 360;
union() {
    difference() {
        cylinder(d = od, h = thickness);
        cylinder(d = od - (rim_width * 2), h = thickness);
    }
    translate([0, 0, thickness / 2]) 
    if (dome == 1) {
        resize([0, 0, thickness - inset]) sphere(d = od);
    } else {
        cylinder(d = od, h = thickness - (inset * 2), center = true);
    }
}