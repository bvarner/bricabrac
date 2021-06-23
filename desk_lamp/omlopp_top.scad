use <threadlib/threadlib.scad>

extrusion_d = 0.45;

wall = 2.75;
// 68.5 x 7
omloppD = 68.5 + extrusion_d;


difference() {
    hull() {
        cylinder(d = omloppD + wall * 2, h = 10, $fn = 360);
        translate([0, 0, 10]) cylinder(d1 = omloppD + wall * 2, d2 = omloppD + wall * 2 - 4, h = 2, $fn = 360);
        translate([omloppD + wall, 0, 0]) {
            cylinder(d = omloppD + wall * 2, h = 10, $fn = 360);
            translate([0, 0, 10]) cylinder(d1 = omloppD + wall * 2, d2 = omloppD + wall * 2 - 4, h = 2, $fn = 360);
        }
    }
            
    // Hollow for the OMLOPPs
    translate([0, 0, -0.5]) {
        cylinder(d = omloppD, h = 7.5, $fn = 360);
        // mounting locations are at 55mm OC
        // We'll tap these so we can use M2x4 cap head screws
        rotate([0, 0, 45]) translate([55 / 2, 0, 7.5]) tap("M2", length = 4);
        rotate([0, 0, 45]) translate([-55 / 2, 0, 7.5]) tap("M2", length = 4);
        
        translate([omloppD + wall, 0, 0]) {
            cylinder(d = omloppD, h = 7.5, $fn = 360);
            translate([55 / 2, 0, 7.5]) tap("M2", length = 4);            
            translate([-55 / 2, 0, 7.5]) tap("M2", length = 4);            
        }
        
        // Hollow out the back for the connection
        cube([omloppD + wall, omloppD / 2 - 3, 7.5]);
    }
    
    // 8mm hole for the wires
    translate([(omloppD + wall) / 2, (omloppD + wall) / 2 - 8 - 3 - wall , 7.5]) {
        rotate([-45, 0, 0]) 
            cylinder(d = 8 + extrusion_d, h = 30, $fn = 360, center = true);
    }
    
    // 3x7.4mm cube that goes 3mm into the wall. for the sleeve to lock into
    translate([(omloppD + wall) / 2, 0, 10 / 2 - 3 / 2]) {
        translate([0, omloppD / 2 - 3, 0]) { 
            translate([-7.5 / 2, wall, -1.625]) cube([7.55, 3.25, 3.25]);
            
            // then 3mm hold for the M3 screw.
            rotate([-90, 0, 0]) cylinder(d = 3, h = wall + 3, $fn = 90);
        }
    }
    
    
}