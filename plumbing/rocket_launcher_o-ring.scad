$fn = 360;

// Oring crosssection diameter
oringd = 2.5;
// Oring Height
oringh = 2.75;

// Outder Diameter of the ring 
od = 22;

id = od - (oringd * 2);

// Enable view the cross section
cross_section_test = false;

if (cross_section_test) {
    profile();
} else {
    rotate_extrude(convexity = 10) {
        translate([id/2 + (od/2 - id/2) / 2 , 0, 0]) {
            profile();
        }
    }
}

module profile() {
    translate([0, (oringh - oringd) / 2, 0])
        circle(d = oringd);
    translate([0, -(oringh - oringd) / 2, 0])
        circle(d = oringd);
    square([oringd, (oringh - oringd)], true);
}